// F4-ORCH-01: Karte des Partyfalls. Ziele der neun Entscheidungen an Kanon-Stellen,
// Kartenzustand pfadgleich vor dem Finale (E-008), Rückblende aus der Tatmatrix.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

/// Spielt einen Abend bis zur Anklage und meldet nach jedem Schritt den Kartenzustand.
List<Map<String, Object?>> _verlauf(PartyKarte karte, String pfad, List<String> wahl, {int rollen = 7}) {
  final s = Spiel(kanon, ermittlung: karte.ermittlung);
  final out = <Map<String, Object?>>[];
  void merke() => out.add(karte.zustand(s).toJson());
  s.einrichten(Einstellungen(rollen: rollen, detektiv: 'w', code: FallCode.fuerPfad(pfad, kanon.pfade)));
  merke();
  var i = 0;
  while (s.phase != PartyPhase.anklage) {
    if (s.phase == PartyPhase.entscheidungen) {
      final e = karte.laufend(s);
      if (e != null) {
        s.waehle(e, wahl[i++]);
        merke();
        continue;
      }
    }
    if (s.phase == PartyPhase.gruppenwahl) s.abstimmen(kooperativ: s.runde % 2 == 0 ? 0 : rollen - 1, taeterSabotiert: false);
    s.weiter();
    merke();
  }
  return out;
}

void main() {
  late PartyKarte karte;
  setUpAll(() => karte = PartyKarte(kanon));

  test('jede Option hat ein Ziel an einer Kanon-Stelle', () {
    final opt = [for (final e in karte.ermittlung.entscheidungen) for (final o in e.optionen) o.id];
    expect(karte.ziele.keys.toSet(), opt.toSet());
    expect(karte.ermittlung.entscheidungen, hasLength(9));
    final g = kanon.graph;
    for (final z in karte.ziele.values) {
      if (z.person != null) {
        expect(kanon.figur(z.person!), isNotNull, reason: z.option);
        expect(z.x, isNull, reason: z.option);
      } else {
        expect(g.raumAn(z.x! + 0.5, z.y! + 0.5)?.id, z.raum, reason: '${z.option} liegt nicht im Raum ${z.raum}');
      }
      expect(z.name, isNotEmpty, reason: z.option);
    }
  });

  test('Ziele einer Entscheidung sind verschieden und Handlungen in der Welt', () {
    for (final e in karte.ermittlung.entscheidungen) {
      final ziele = karte.zieleVon(e.id);
      expect(ziele, hasLength(e.optionen.length), reason: e.id);
      final kennungen = {for (final z in ziele) z.person ?? z.hotspot};
      expect(kennungen, hasLength(ziele.length), reason: '${e.id}: zwei Optionen am selben Ziel');
      expect(e.optionen.length, inInclusiveRange(2, 3), reason: e.id);
    }
  });

  test('Hotspots im Szenario sind genau die Ziele ohne Person', () {
    final h = karte.hotspotJson();
    expect({for (final x in h) x['id']}, {for (final z in karte.ziele.values) if (z.person == null) z.hotspot});
    for (final x in h) {
      expect(x['kind'], 'search');
    }
  });

  test('Figuren stehen an ihrem Ermittlungsort, keine zwei auf derselben Stelle', () {
    expect(karte.figuren, hasLength(kanon.personen.length - 1));
    final stellen = <String>{};
    for (final f in karte.figuren) {
      expect(kanon.graph.raumAn(f.x, f.y)?.id, f.raum, reason: f.id);
      expect(stellen.add('${f.x},${f.y}'), isTrue, reason: '${f.id} teilt die Stelle mit einer anderen Figur');
    }
  });

  test('Kartenzustand ist vor dem Finale in allen Pfaden gleich', () {
    final wahlen = <String, List<String>>{
      for (final p in kanon.pfade) 'bestes Spiel $p': karte.ermittlung.bestesSpiel(p),
      'erste Optionen': [for (final e in karte.ermittlung.entscheidungen) e.optionen.first.id],
      'letzte Optionen': [for (final e in karte.ermittlung.entscheidungen) e.optionen.last.id],
    };
    for (final w in wahlen.entries) {
      for (final n in [4, 12, 20]) {
        final verlaeufe = {for (final p in kanon.pfade) p: _verlauf(karte, p, w.value, rollen: n)};
        final erster = verlaeufe[kanon.pfade.first]!;
        for (final p in kanon.pfade.skip(1)) {
          expect(verlaeufe[p], erster, reason: '${w.key}, $n Rollen: Pfad $p weicht ab');
        }
      }
    }
  });

  test('Ziele sind nur in der laufenden Entscheidung offen', () {
    final s = Spiel(kanon, ermittlung: karte.ermittlung)
      ..einrichten(Einstellungen(rollen: 4, detektiv: 'm', code: FallCode.fuerPfad('olli', kanon.pfade)))
      ..weiter()
      ..weiter()
      ..weiter();
    expect(s.phase, PartyPhase.entscheidungen);
    final z = karte.zustand(s);
    expect(z.entscheidung, 'e1_1');
    expect(z.ansprechbar.keys.toSet(), {for (final x in karte.zieleVon('e1_1')) x.person});
    expect(karte.zielFuer(s, 'emine'), isNull, reason: 'Emine gehört zu e1_2');
    final ziel = karte.zielFuer(s, karte.zieleVon('e1_1').first.person!)!;
    s.waehle('e1_1', ziel.option);
    expect(karte.zustand(s).entscheidung, 'e1_2');
  });

  test('Rückblende: 15-Sekunden-Schritte, alle Personen, Stromausfall dunkel', () {
    for (final p in kanon.pfade) {
      final r = karte.rueckblende(p);
      expect(r.ablauf.fehler, isEmpty, reason: '$p: ${r.ablauf.fehler.join('; ')}');
      expect(r.schritte.first, kanon.regeln.planVon);
      expect(r.schritte.last, kanon.regeln.planBis);
      for (var i = 1; i < r.schritte.length; i++) {
        expect(r.schritte[i].minus(r.schritte[i - 1]), 15);
      }
      expect(r.hervorgehoben, containsAll([p, 'schneider']));
      for (final t in r.schritte) {
        final b = r.bild(t);
        expect(b.personen.keys, containsAll(kanon.personen.where((x) => x != 'detective')), reason: '$p $t');
      }
      final dunkel = r.bild(Uhrzeit.parse('23:59:00'));
      expect(dunkel.helleRaeume, isNot(contains('thekensaal')), reason: '$p: im Stromausfall ist der Buffetsaal dunkel');
      expect(dunkel.lichter.map((l) => l.id), contains('licht_notausgang'));
      expect(r.bild(Uhrzeit.parse('23:56:00')).helleRaeume, contains('thekensaal'));
    }
  });

  test('Texte.baustein liefert Hinweise und Erzähler-Bausteine wortgleich', () {
    final texte = Texte(kanon, Textsammlung.lade((p) => leseJson('$repoWurzel/content/party/schlosskeller/$p')));
    final h = (kanon.bonusJson['hinweise'] as List).first as Map;
    expect(texte.baustein('hinweis.${h['id']}'), h['text']);
    expect(texte.baustein('intro.start'), texte.sammlung.bausteine['intro.start']);
    expect(() => texte.baustein('intro.gibt_es_nicht'), throwsArgumentError);
    expect(() => texte.baustein('hinweis.gibt_es_nicht'), throwsArgumentError);
  });

  test('Handlung am Knopf folgt dem Verb der Option (E-038)', () {
    final opt = {
      for (final e in kanon.entscheidungenJson['entscheidungen'] as List)
        for (final o in (e as Map)['optionen'] as List) (o as Map)['id'] as String: o['text'] as String,
    };
    for (final z in karte.ziele.values) {
      final t = opt[z.option]!.toLowerCase();
      final soll = t.endsWith('untersuchen') || t.endsWith('durchsuchen')
          ? ZielArt.gegenstand
          : t.endsWith('fragen') || t.endsWith('befragen')
              ? ZielArt.person
              : t.endsWith('suchen')
                  ? ZielArt.raum
                  : z.art;
      expect(z.aktion, soll, reason: '${z.option}: ${opt[z.option]}');
    }
    // Personen, die untersucht werden, gibt es wirklich (sonst prüft der Test nichts).
    expect(karte.ziele.values.where((z) => z.person != null && z.aktion == ZielArt.gegenstand), isNotEmpty);
    expect(aktionAus('Olli und seine Weste untersuchen', ZielArt.person), ZielArt.gegenstand);
    expect(aktionAus('Emine befragen', ZielArt.person), ZielArt.person);
    expect(aktionAus('Im Turmgang suchen', ZielArt.raum), ZielArt.raum);
  });
}

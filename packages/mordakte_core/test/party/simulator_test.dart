// F-06, F-07, F-08: Lösbarkeit und Fairness des Entscheidungsmodells über alle Pfade, Optionsfolgen, Gruppenergebnisse und Anklagen.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

/// Kurze Fehlermeldung: Anzahl und die ersten Fälle.
String befund(List<String> f) =>
    f.isEmpty ? 'keine Verstöße' : '${f.length} Verstöße, z. B.:\n${f.take(10).join('\n')}';

bool gleicheMenge(Set<String> a, Set<String> b) => a.length == b.length && a.containsAll(b);

/// W-1 scharf: Kennungen von Bonus-Hinweisen ändern die Restmenge der Fakten nie.
bool aendertRest(Ermittlung e, Set<String> fakten, Iterable<String> kennungen) =>
    !gleicheMenge(e.restmenge(<String>{...fakten, ...kennungen}), e.restmenge(fakten));

/// Folgen (Pfad und Optionen), deren Restmenge sich durch Bonus-Kennungen ändert.
List<String> hinweisVerstoesse(Simulator s, Iterable<String> pfade) {
  final kennungen = [for (final h in s.gruppe.hinweise) h['id'] as String];
  return [
    for (final p in pfade)
      for (final f in s.folgen())
        if (aendertRest(s.ermittlung, s.verlauf(p, f).fakten, kennungen)) '$p ${f.join(',')}',
  ];
}

/// Kanon mit einer gezielten Änderung an einer Datei (nur für Rot-Proben).
Kanon geaendert(String datei, void Function(Map<String, Object?> j) aendern) => Kanon.lade((p) {
  final j = leseJson('$repoWurzel/content/party/schlosskeller/$p');
  if (p == datei) aendern(j);
  return j;
});

/// Wortlaut der Quelle eines Fakts: Beobachtungstext oder Spurtext (`zeigt`).
String? quelltext(Ermittlung e, Fakt f) {
  final b = f.beobachtung;
  if (b != null) return e.beobachtungJson(b)?['text'] as String?;
  final s = f.spur;
  if (s == null) return null;
  return e.spurJson(s)?['zeigt'] as String?;
}

/// Eintrag mit der Kennung [id] in der Liste [liste] einer Kanon-Datei.
Map<String, Object?> eintrag(Map<String, Object?> j, String liste, String id) =>
    (j[liste] as List).cast<Map<String, Object?>>().firstWhere((x) => x['id'] == id);

void main() {
  late Simulator sim;
  late Ermittlung ermittlung;
  late List<String> kern;
  late Map<String, List<Verlauf>> verlaeufe;
  late Map<String, PfadBericht> bericht;

  setUpAll(() {
    sim = Simulator(kanon);
    ermittlung = sim.ermittlung;
    kern = kanon.kernverdaechtige;
    verlaeufe = {
      for (final p in kanon.pfade) p: [for (final f in sim.folgen()) sim.verlauf(p, f)],
    };
    bericht = sim.auszaehlen();
  });

  test('pruefe() meldet keinen Verstoß gegen F-06, F-07 und F-08', () {
    final f = sim.pruefe();
    expect(f, isEmpty, reason: befund(f));
  });

  test('pruefeSchwellen() meldet keinen Verstoß: jede Qualität ist für 4 bis 20 Rollen erreichbar', () {
    final f = sim.pruefeSchwellen();
    expect(f, isEmpty, reason: befund(f));
  });

  test('pruefe() und pruefeSchwellen() laufen zusammen in unter 60 Sekunden', () {
    final neu = Simulator(kanon);
    final sw = Stopwatch()..start();
    neu.pruefe();
    neu.pruefeSchwellen();
    sw.stop();
    expect(sw.elapsed, lessThan(const Duration(seconds: 60)), reason: 'gemessen: ${sw.elapsed}');
  });

  test('bestes Spiel hat in jedem Pfad alle Entscheidungen richtig (9 Punkte)', () {
    for (final p in kanon.pfade) {
      final v = sim.verlauf(p, ermittlung.bestesSpiel(p));
      expect(v.punkte, ermittlung.entscheidungen.length, reason: p);
    }
  });

  test('bestes Spiel lässt nach Runde 2 genau zwei Restverdächtige', () {
    for (final p in kanon.pfade) {
      final v = sim.verlauf(p, ermittlung.bestesSpiel(p));
      expect(v.restNachRunde[1], hasLength(2), reason: '$p: ${v.restNachRunde[1]}');
    }
  });

  test('bestes Spiel endet bei genau der Täterperson', () {
    for (final p in kanon.pfade) {
      final v = sim.verlauf(p, ermittlung.bestesSpiel(p));
      expect(v.rest, unorderedEquals([p]), reason: '$p: ${v.rest}');
    }
  });

  test('ohne richtige Entscheidung bleiben mindestens zwei Restverdächtige', () {
    final f = <String>[];
    for (final p in kanon.pfade) {
      final ohneTreffer = verlaeufe[p]!.where((v) => v.punkte == 0).toList();
      expect(ohneTreffer, isNotEmpty, reason: p);
      for (final v in ohneTreffer) {
        if (v.rest.length < 2) f.add('$p ${v.optionen.join(',')}: ${v.rest}');
      }
    }
    expect(f, isEmpty, reason: befund(f));
  });

  test('Bonus-Hinweise ändern in keiner Folge die Restmenge (W-1 scharf)', () {
    expect(sim.gruppe.hinweise, hasLength(kanon.pfade.length * 9), reason: 'je Pfad 3 Runden × 3 Qualitäten');
    final f = hinweisVerstoesse(sim, kanon.pfade);
    expect(f, isEmpty, reason: befund(f));
  });

  test('bei 0 richtigen Entscheidungen ändern die drei wahren Hinweise des Pfads nichts', () {
    final f = <String>[];
    for (final p in kanon.pfade) {
      final wahr = [for (var r = 1; r <= 3; r++) sim.gruppe.hinweis(p, r, Qualitaet.wahr)['id'] as String];
      final ohneTreffer = verlaeufe[p]!.where((v) => v.punkte == 0).toList();
      expect(ohneTreffer, isNotEmpty, reason: p);
      for (final v in ohneTreffer) {
        if (aendertRest(ermittlung, v.fakten, wahr)) f.add('$p ${v.optionen.join(',')}');
      }
    }
    expect(f, isEmpty, reason: befund(f));
  });

  test('W-1 gilt bei jeder Punktzahl von 0 bis 9, und jede Punktzahl kommt vor', () {
    final anzahl = <int, int>{};
    final f = <String>[];
    final kennungen = [for (final h in sim.gruppe.hinweise) h['id'] as String];
    for (final p in kanon.pfade) {
      for (final v in verlaeufe[p]!) {
        anzahl[v.punkte] = (anzahl[v.punkte] ?? 0) + 1;
        if (aendertRest(ermittlung, v.fakten, kennungen)) f.add('$p ${v.optionen.join(',')}');
      }
    }
    expect(anzahl.keys.toList()..sort(), [for (var k = 0; k <= 9; k++) k], reason: 'Anzahl je Punktzahl: $anzahl');
    expect(f, isEmpty, reason: befund(f));
  });

  test('folgen() liefert jede Optionsfolge genau einmal', () {
    final erwartet = ermittlung.entscheidungen.fold<int>(1, (n, e) => n * e.optionen.length);
    final alle = [for (final f in sim.folgen()) f.join(',')];
    expect(alle, hasLength(erwartet), reason: 'Produkt der Optionszahlen');
    expect(alle.toSet(), hasLength(erwartet), reason: 'doppelte Folgen');
  });

  test('Folgen je Punktzahl entsprechen dem Polynom aus den Optionszahlen', () {
    // Je Entscheidung eine richtige und n−1 falsche Optionen: Die Zahl der Folgen mit k
    // richtigen Entscheidungen ist der Koeffizient von x^k in ∏ (x + (n−1)).
    var koeff = <int>[1];
    for (final e in ermittlung.entscheidungen) {
      final falsch = e.optionen.length - 1;
      final neu = List<int>.filled(koeff.length + 1, 0);
      for (var k = 0; k < koeff.length; k++) {
        neu[k] += koeff[k] * falsch;
        neu[k + 1] += koeff[k];
      }
      koeff = neu;
    }
    for (final p in kanon.pfade) {
      final zaehl = List<int>.filled(koeff.length, 0);
      for (final v in verlaeufe[p]!) {
        zaehl[v.punkte]++;
      }
      expect(zaehl, equals(koeff), reason: p);
    }
  });

  test('Runde 1 und 2 richtig: nach Runde 2 genau zwei Restverdächtige', () {
    final n1 = ermittlung.runde(1).length;
    final n2 = ermittlung.runde(2).length;
    final f = <String>[];
    for (final p in kanon.pfade) {
      final faelle = verlaeufe[p]!.where((v) => v.richtigJeRunde[0] == n1 && v.richtigJeRunde[1] == n2).toList();
      expect(faelle, isNotEmpty, reason: p);
      for (final v in faelle) {
        if (v.restNachRunde[1].length != 2) f.add('$p ${v.optionen.join(',')}: ${v.restNachRunde[1]}');
      }
    }
    expect(f, isEmpty, reason: befund(f));
  });

  test('die Täterperson scheidet in keiner Folge und nach keiner Runde aus', () {
    final f = <String>[];
    for (final p in kanon.pfade) {
      for (final v in verlaeufe[p]!) {
        for (var r = 0; r < v.restNachRunde.length; r++) {
          if (!v.restNachRunde[r].contains(p)) f.add('$p, nach Runde ${r + 1}: ${v.optionen.join(',')}');
        }
      }
    }
    expect(f, isEmpty, reason: befund(f));
  });

  test('Enden zählen jedes Spiel genau einmal (Summe der Enden gleich Spiele)', () {
    for (final p in kanon.pfade) {
      final b = bericht[p]!;
      expect(b.enden.values.fold<int>(0, (s, n) => s + n), b.spiele, reason: p);
    }
  });

  test('jede Optionsfolge wird mit jeder Kernperson gespielt', () {
    for (final p in kanon.pfade) {
      expect(bericht[p]!.spiele, verlaeufe[p]!.length * kern.length, reason: p);
    }
  });

  test('Rate-Enden kommen in jedem Pfad vor (rateEnden größer als 0)', () {
    for (final p in kanon.pfade) {
      expect(bericht[p]!.rateEnden, greaterThan(0), reason: p);
    }
  });

  test('rateEnden zählt genau die Anklagen außerhalb der Restmenge', () {
    for (final p in kanon.pfade) {
      var n = 0;
      for (final v in verlaeufe[p]!) {
        final rest = ermittlung.restmenge(v.fakten);
        n += kern.where((a) => !rest.contains(a)).length;
      }
      expect(bericht[p]!.rateEnden, n, reason: p);
    }
  });

  test('rateTreffer zählt richtige Anklagen nur bei mehr als einer Restperson', () {
    for (final p in kanon.pfade) {
      final n = verlaeufe[p]!.where((v) => ermittlung.restmenge(v.fakten).length > 1).length;
      expect(bericht[p]!.rateTreffer, n, reason: p);
    }
  });

  test('falsche Optionen zeigen weder Schlüsselbeweis noch Zusatzindiz (D-1)', () {
    final f = <String>[];
    var geprueft = 0;
    for (final p in kanon.pfade) {
      for (final e in ermittlung.entscheidungen) {
        for (final o in e.optionen) {
          if (o.id == e.richtig[p]) continue;
          geprueft++;
          for (final a in ermittlung.aufdecken(o.id, p).where((x) => x.entstanden)) {
            final typ = ermittlung.fakten[a.fakt]!.typ;
            if (typ == 'schluesselbeweis' || typ == 'zusatzindiz') f.add('$p, ${o.id}: zeigt $typ (${a.fakt})');
          }
        }
      }
    }
    final erwartet = ermittlung.entscheidungen.fold<int>(0, (s, e) => s + e.optionen.length - 1) * kanon.pfade.length;
    expect(geprueft, erwartet, reason: 'geprüfte falsche Optionen');
    expect(f, isEmpty, reason: befund(f));
  });

  test('jede falsche Fährte belastet einen Unschuldigen', () {
    final f = <String>[];
    for (final p in kanon.pfade) {
      final falsch = sim.gruppe.hinweise.where((h) => h['pfad'] == p && h['qualitaet'] == 'falsch').toList();
      if (falsch.length != 3) f.add('$p: ${falsch.length} falsche Fährten statt 3 (je Runde eine)');
      for (final h in falsch) {
        final w = h['wirkung'] as Map;
        final person = w['person'];
        if (w['art'] != 'belastet' || person == p || !kern.contains(person)) {
          f.add('${h['id']}: belastet $person, nicht einen Unschuldigen');
        }
      }
    }
    expect(f, isEmpty, reason: befund(f));
  });

  test('jede falsche Fährte wird durch eine im Pfad richtige Entscheidung widerlegt', () {
    final f = <String>[];
    for (final p in kanon.pfade) {
      final richtig = ermittlung.bestesSpiel(p);
      for (final h in sim.gruppe.hinweise.where((h) => h['pfad'] == p && h['qualitaet'] == 'falsch')) {
        final wd = [for (final o in (h['widerlegtDurch'] as List? ?? const [])) o as String];
        if (!wd.any((o) => richtig.contains(o))) f.add('${h['id']}: widerlegt durch $wd, im Pfad nicht richtig');
      }
    }
    expect(f, isEmpty, reason: befund(f));
  });

  test('die widerlegende Entscheidung liegt in derselben oder einer früheren Runde', () {
    final rundeVon = {
      for (final e in ermittlung.entscheidungen)
        for (final o in e.optionen) o.id: e.runde,
    };
    final f = <String>[];
    for (final h in sim.gruppe.hinweise.where((h) => h['qualitaet'] == 'falsch')) {
      final r = h['runde'] as int;
      for (final o in (h['widerlegtDurch'] as List? ?? const [])) {
        final runde = rundeVon[o as String];
        if (runde == null || runde > r) f.add('${h['id']}: $o aus Runde $runde');
      }
    }
    expect(f, isEmpty, reason: befund(f));
  });

  test('bestes Spiel deckt das Nebendelikt jeder Kernperson auf', () {
    final f = <String>[];
    for (final p in kanon.pfade) {
      final st = ermittlung.stand(sim.verlauf(p, ermittlung.bestesSpiel(p)).fakten);
      for (final q in kern) {
        if (!(st[q] ?? const <String>{}).contains('nebendelikt')) f.add('$p: $q ohne Nebendelikt');
      }
    }
    expect(f, isEmpty, reason: befund(f));
  });

  test('angezeigte Fakten gibt es im Pfad und zeigen den Wortlaut ihrer Quelle', () {
    final f = <String>[];
    var angezeigt = 0;
    for (final p in kanon.pfade) {
      for (final e in ermittlung.entscheidungen) {
        for (final o in e.optionen) {
          for (final a in ermittlung.aufdecken(o.id, p).where((x) => x.entstanden)) {
            angezeigt++;
            if (!ermittlung.gibtEs(a.fakt, p) || quelltext(ermittlung, ermittlung.fakten[a.fakt]!) != a.text) {
              f.add('$p, ${o.id}: ${a.fakt}');
            }
          }
        }
      }
    }
    expect(angezeigt, greaterThan(0));
    expect(f, isEmpty, reason: befund(f));
  });

  test('harmlose Fassungen gehören zu Spuren, die es im Pfad nicht gibt', () {
    final f = <String>[];
    var harmlos = 0;
    for (final p in kanon.pfade) {
      for (final e in ermittlung.entscheidungen) {
        for (final o in e.optionen) {
          for (final a in ermittlung.aufdecken(o.id, p).where((x) => !x.entstanden)) {
            harmlos++;
            final spur = ermittlung.fakten[a.fakt]!.spur;
            final passt =
                spur != null && ermittlung.spurJson(spur)?['harmlos'] == a.text && !ermittlung.gibtEs(a.fakt, p);
            if (!passt) f.add('$p, ${o.id}: ${a.fakt}');
          }
        }
      }
    }
    expect(harmlos, greaterThan(0));
    expect(f, isEmpty, reason: befund(f));
  });

  test('Begründungsketten nutzen nur Vorwissen', () {
    final f = sim.pruefeBegruendungen();
    expect(f, isEmpty, reason: befund(f));
  });

  test('Rot-Probe: Schlüsselbeweis als richtige Option für Fatma wird gemeldet', () {
    final kaputt = geaendert('entscheidungen.json', (j) {
      (eintrag(j, 'entscheidungen', 'e3_2')['richtig'] as Map<String, Object?>)['fatma'] = 'e3_2_kerzenstaender';
    });
    final f = Simulator(kaputt).pruefe();
    expect(f.any((m) => m.startsWith('Pfad fatma')), isTrue, reason: befund(f));
  });

  test('Rot-Probe: falsche Fährte, die die Täterperson selbst belastet, wird gemeldet', () {
    final kaputt = geaendert('bonus.json', (j) {
      (eintrag(j, 'hinweise', 'h_ahmet_1_falsch')['wirkung'] as Map<String, Object?>)['person'] = 'ahmet';
    });
    final f = Simulator(kaputt).pruefe();
    expect(f.any((m) => m.contains('h_ahmet_1_falsch')), isTrue, reason: befund(f));
  });

  test('Rot-Probe: Bonus-Kennung, die einem Fakt gleicht, ändert die Restmenge (W-1)', () {
    final kaputt = geaendert('bonus.json', (j) {
      eintrag(j, 'hinweise', 'h_ahmet_1_wahr')['id'] = 'f_k_ahmet';
    });
    final f = hinweisVerstoesse(Simulator(kaputt), ['ahmet']);
    expect(f, isNotEmpty, reason: 'keine Meldung trotz Kennungs-Kollision');
  });

  test('Rot-Probe: Begründung mit einem Fakt, der erst später bekannt wird, wird gemeldet', () {
    final kaputt = geaendert('entscheidungen.json', (j) {
      final beg = eintrag(j, 'entscheidungen', 'e1_1')['begruendung'] as Map<String, Object?>;
      ((beg['alle'] as Map<String, Object?>)['kette'] as List).add('fakt:f_nd_can_maske');
    });
    final f = Simulator(kaputt).pruefeBegruendungen();
    expect(f.any((m) => m.contains('f_nd_can_maske')), isTrue, reason: befund(f));
  });
}

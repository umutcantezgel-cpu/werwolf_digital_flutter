// F-14 (F5-ORCH-01): Das Druckmodell spielt sich wie der Bildschirm. 100 Zufallsspiele
// über Detektivbogen, Indizkarten, Stimmkarten, Auszähltabelle und Endentabelle
// ergeben dieselbe Restmenge, dieselben Hinweise und dasselbe Ende wie `Spiel`.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte_core/src/party/druck/modell.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

void main() {
  late Texte texte;
  setUpAll(() => texte = Texte(kanon, Textsammlung.lade((p) => leseJson('$repoWurzel/content/party/schlosskeller/$p'))));

  test('100 Zufallsspiele: Druck und Bildschirm kommen zum selben Ergebnis', () {
    for (var i = 0; i < 100; i++) {
      final rng = Rng(9100 + i);
      final code = FallCode.zufall(rng);
      final n = 4 + rng.nextInt(17);
      final detektiv = rng.nextInt(2) == 0 ? 'm' : 'w';
      final satz = DruckSatz.aus(kanon, texte, code, rollen: n, detektiv: detektiv);
      final s = Spiel(kanon)..einrichten(Einstellungen(rollen: n, detektiv: detektiv, code: code));
      final gezogen = <String, String>{};
      final kreuze = <Kreuz>[];
      s
        ..weiter()
        ..weiter();
      for (var r = 1; r <= 3; r++) {
        expect(s.phase, PartyPhase.gespraeche);
        s.weiter();
        for (final b in satz.detektivbogen.where((b) => b.runde == r)) {
          // Gleiche Reihenfolge der Optionen wie am Bildschirm
          expect([for (final o in b.optionen) o.option], [for (final o in s.optionen(b.id)) o.id], reason: '${b.id} $code');
          final o = b.optionen[rng.nextInt(b.optionen.length)];
          final funde = s.waehle(b.id, o.option);
          final karte = satz.karte(o.karte);
          expect(karte.funde, [for (final f in funde) f.text], reason: '${b.id} $code');
          gezogen[b.id] = o.karte;
          kreuze.addAll(karte.kreuze);
        }
        expect(satz.restmengeAus(kreuze), s.restmenge(r), reason: 'Runde $r $code');
        s.weiter();
        // Stimmen: jede Rolle A oder B
        var summe = 0;
        var kooperativ = 0;
        var sabotiert = false;
        for (final rolle in s.besetzt) {
          final a = rng.nextInt(3) > 0;
          final k = satz.stimmkarten.firstWhere((x) => x.rolle == rolle && x.runde == r && x.a == a);
          summe += k.wert;
          if (rolle == s.pfad) {
            sabotiert = !a;
          } else if (a) {
            kooperativ++;
          }
        }
        final q = s.abstimmen(kooperativ: kooperativ, taeterSabotiert: sabotiert);
        final u = satz.umschlag(satz.spielleitung.auszaehlung[r - 1].umschlagBei(summe));
        expect(u.qualitaet, q, reason: 'Runde $r, Summe $summe, $n Rollen, $code');
        s.weiter();
        expect(u.kennungen, s.bausteine.sublist(s.bausteine.length - 2), reason: 'Hinweis Runde $r');
        s.weiter();
        s.weiter();
      }
      final angeklagt = kanon.kernverdaechtige[rng.nextInt(4)];
      s
        ..anklagen(angeklagt)
        ..weiter();
      final punkte = [for (final e in gezogen.entries) if (satz.aufloesung.richtig[e.key] == e.value) e].length;
      expect(punkte, s.punkte, reason: '$code');
      final richtig = angeklagt == satz.aufloesung.taeter;
      final ende = satz.aufloesung.endentabelle.singleWhere((e) => e.richtig == richtig && punkte >= e.punkteVon && punkte <= e.punkteBis);
      expect(ende.id, s.ende.id, reason: '$code');
      expect(satz.aufloesung.finale[ende.id], s.erzaehler.finale(s));
    }
  });

  test('Codes sind eindeutig und neutral', () {
    for (final p in kanon.pfade) {
      final satz = DruckSatz.aus(kanon, texte, FallCode.fuerPfad(p, kanon.pfade), rollen: 12, detektiv: 'w');
      final codes = [for (final k in satz.indizkarten) k.code, for (final u in satz.umschlaege) u.code, for (final f in satz.fassungen) f.code];
      expect(codes.toSet(), hasLength(codes.length));
      final optionen = [for (final e in kanon.entscheidungenJson['entscheidungen'] as List) ...((e as Map)['optionen'] as List)];
      expect(codes.length, optionen.length + 9 + 4);
      for (final c in codes) {
        expect(c, matches(RegExp(r'^[A-Z]{2}[3479]$')));
      }
      expect(satz.aufloesung.codes.keys.toSet(), codes.toSet());
      // Alle vier Fassungen gibt es immer; nur die eigene ist die Täterfassung.
      expect({for (final f in satz.fassungen) f.rolle}, kanon.kernverdaechtige.toSet());
      expect([for (final f in satz.fassungen) if (f.dossier.taeter) f.rolle], [p]);
    }
  });

  test('Spielleitungsheft kennt jede mögliche Restmenge und jede Lage', () {
    final satz = DruckSatz.aus(kanon, texte, FallCode.fuerPfad('olli', kanon.pfade), rollen: 7, detektiv: 'm');
    expect(satz.spielleitung.resuemeeRest, hasLength(1 + 4 + 6 + 4));
    for (final k in [...satz.spielleitung.resuemeeRest.values, for (final m in satz.spielleitung.resuemeeLage.values) ...m.values]) {
      expect(texte.baustein(k), isNotEmpty, reason: k);
    }
    expect(satz.spielleitung.resuemeeRest['ahmet'], 'resuemee.rest.eins');
  });
}

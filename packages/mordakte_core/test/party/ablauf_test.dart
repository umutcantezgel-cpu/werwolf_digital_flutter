// Spielablauf (Master 7.6) als Zustandsautomat und Bausteinwahl des Erzählers (7.12, S-1).
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

void main() {
  late Ermittlung e;
  setUpAll(() => e = Ermittlung(kanon));

  Spiel neu(String pfad, {int rollen = 6}) =>
      Spiel(kanon, ermittlung: e)..einrichten(Einstellungen(rollen: rollen, detektiv: 'w', code: FallCode.fuerPfad(pfad, kanon.pfade)));

  /// Spielt bis zur Anklage; [wahl] liefert je Entscheidung die Option.
  Spiel bisAnklage(String pfad, String Function(Entscheidung) wahl, {bool zusammen = true}) {
    final s = neu(pfad);
    final phasen = <PartyPhase>[s.phase];
    while (s.phase != PartyPhase.anklage) {
      if (s.phase == PartyPhase.entscheidungen) {
        for (final x in e.runde(s.runde)) {
          s.waehle(x.id, wahl(x));
        }
      }
      if (s.phase == PartyPhase.gruppenwahl) s.abstimmen(kooperativ: zusammen ? 5 : 0, taeterSabotiert: !zusammen);
      s.weiter();
      phasen.add(s.phase);
    }
    return s;
  }

  test('Abschnitte in fester Reihenfolge, drei Runden', () {
    final s = Spiel(kanon, ermittlung: e);
    expect(s.phase, PartyPhase.titel);
    s.weiter();
    expect(s.phase, PartyPhase.einrichtung);
    s.einrichten(Einstellungen(rollen: 5, detektiv: 'm', code: FallCode.fuerPfad('olli', kanon.pfade)));
    final folge = <PartyPhase>[s.phase];
    while (s.phase != PartyPhase.ende) {
      if (s.phase == PartyPhase.entscheidungen) {
        for (final x in e.runde(s.runde)) {
          s.waehle(x.id, x.optionen.first.id);
        }
      }
      if (s.phase == PartyPhase.gruppenwahl) s.abstimmen(kooperativ: 2, taeterSabotiert: false);
      if (s.phase == PartyPhase.anklage) s.anklagen('can');
      s.weiter();
      folge.add(s.phase);
    }
    const runde = [PartyPhase.gespraeche, PartyPhase.entscheidungen, PartyPhase.gruppenwahl, PartyPhase.bonus, PartyPhase.resuemee];
    expect(folge, [
      PartyPhase.rollen,
      PartyPhase.intro,
      ...runde,
      ...runde,
      ...runde,
      PartyPhase.anklage,
      PartyPhase.finale,
      PartyPhase.aufloesung,
      PartyPhase.ende,
    ]);
  });

  test('ohne alle drei Entscheidungen, Gruppenwahl oder Anklage geht es nicht weiter', () {
    final s = neu('fatma')
      ..weiter()
      ..weiter()
      ..weiter();
    expect(s.phase, PartyPhase.entscheidungen);
    s.waehle('e1_1', 'e1_1_damir');
    expect(s.weiter, throwsStateError);
    expect(() => s.waehle('e1_1', 'e1_1_joanna'), throwsStateError, reason: 'schon entschieden');
    expect(() => s.waehle('e2_1', 'e2_1_ascheneimer'), throwsStateError, reason: 'falsche Runde');
    s
      ..waehle('e1_2', 'e1_2_emine')
      ..waehle('e1_3', 'e1_3_azra')
      ..weiter();
    expect(s.weiter, throwsStateError, reason: 'Gruppenwahl fehlt');
    expect(() => s.abstimmen(kooperativ: 6, taeterSabotiert: false), throwsRangeError);
    final a = bisAnklage('fatma', (x) => x.richtig['fatma']!);
    expect(a.weiter, throwsStateError, reason: 'Anklage fehlt');
    expect(() => a.anklagen('tugba'), throwsArgumentError);
  });

  test('Punkte und Ende folgen aus Wertung und Anklage', () {
    for (final p in kanon.pfade) {
      final best = bisAnklage(p, (x) => x.richtig[p]!);
      expect(best.punkte, 9);
      best.anklagen(p);
      expect(best.ende.id, 'ende_meister');
      final falsch = bisAnklage(p, (x) => x.optionen.firstWhere((o) => o.id != x.richtig[p]).id);
      expect(falsch.punkte, 0);
      falsch.anklagen(kanon.kernverdaechtige.firstWhere((q) => q != p));
      expect(falsch.ende.id, 'ende_eskalation');
    }
  });

  test('Erzähler wählt nur Bausteine aus dem Katalog oder Bonus-Hinweise', () {
    final katalog = Erzaehler(kanon).katalog().toSet();
    final hinweise = {for (final h in Gruppenwahl(kanon).hinweise) 'hinweis.${h['id']}'};
    for (final p in kanon.pfade) {
      for (final zusammen in [true, false]) {
        final s = bisAnklage(p, (x) => x.richtig[p]!, zusammen: zusammen)..anklagen(p);
        s
          ..weiter()
          ..weiter();
        for (final k in s.bausteine) {
          expect(katalog.contains(k) || hinweise.contains(k), isTrue, reason: k);
        }
      }
    }
  });

  test('vor dem Finale nennt kein Baustein den Pfad; bei einer Restperson kein Name (S-1)', () {
    for (final p in kanon.pfade) {
      final s = bisAnklage(p, (x) => x.richtig[p]!);
      for (final k in s.bausteine.where((k) => !k.startsWith('hinweis.'))) {
        for (final q in kanon.kernverdaechtige) {
          expect(k.startsWith('resuemee.rest.') || !k.contains(q), isTrue, reason: k);
        }
      }
      expect(s.bausteine.last, startsWith('anklage.'));
      expect(s.bausteine.where((k) => k.startsWith('resuemee.rest.')).last, 'resuemee.rest.eins');
    }
  });

  test('Resümee-Restmenge nennt nur, was der Detektiv weiß: gleiche Fakten, gleiche Bausteine', () {
    // Runde 1 mit den falschen Optionen deckt in allen Pfaden dasselbe auf.
    final folgen = <String, List<String>>{};
    for (final p in kanon.pfade) {
      final s = neu(p)
        ..weiter()
        ..weiter()
        ..weiter();
      for (final x in e.runde(1)) {
        s.waehle(x.id, x.optionen.firstWhere((o) => o.id != x.richtig[p]).id);
      }
      s
        ..weiter()
        ..abstimmen(kooperativ: 0, taeterSabotiert: true)
        ..weiter()
        ..weiter();
      folgen[p] = [for (final k in s.bausteine) if (k.startsWith('resuemee.')) k];
    }
    expect(folgen.values.map((l) => l.join('|')).toSet(), hasLength(1), reason: '$folgen');
  });
}

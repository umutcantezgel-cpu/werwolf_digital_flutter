// F-04: Tatmatrix und Plausibilität für alle vier Pfade.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

void main() {
  late List<Verstoss> verstoesse;
  setUpAll(() => verstoesse = pruefer.pruefe());

  test('0 Verstöße in allen Pfaden', () {
    expect(verstoesse, isEmpty, reason: verstoesse.join('\n'));
  });

  test('41 Zeitschritte × alle Personen je Pfad (23:55:00–0:05:00, 15 s)', () {
    for (final p in kanon.pfade) {
      final a = pruefer.auswertung[p]!.ablauf;
      var schritte = 0;
      for (var t = Uhrzeit.parse('23:55:00'); t <= Uhrzeit.parse('00:05:00'); t = t.plus(15)) {
        schritte++;
        for (final person in kanon.personen) {
          expect(a.zustand(person, t)?.raum, isNotNull, reason: '$p: $person @ $t');
        }
      }
      expect(schritte, 41);
      expect(kanon.personen.length, 22);
    }
  });

  test('jede Kernperson hat genau einen Trenner-Zeugen, und nur diese wissen pfadabhängig etwas', () {
    final zeugen = <String, Set<String>>{};
    for (final b in kanon.beobachtungen) {
      final t = b['trenner'] as String?;
      if (t != null) (zeugen[t] ??= {}).add(b['wer'] as String);
    }
    expect(zeugen.keys.toSet(), kanon.kernverdaechtige.toSet());
    for (final z in zeugen.values) {
      expect(z, hasLength(1));
    }
    final erlaubt = {for (final z in zeugen.values) ...z};
    final wissen = pruefer.wissensUnterschiede();
    expect(wissen.keys.where((p) => !erlaubt.contains(p)), isEmpty, reason: '$wissen');
  });

  test('Ein Gegenbeispiel wird erkannt: zu schneller Weg', () {
    // Selbsttest des Prüfers: Ein manipulierter Plan muss auffallen.
    final basis = TatmatrixDatei.fromJson(kanon.json['tatmatrix/basis.json']!);
    final pfad = TatmatrixDatei.fromJson(kanon.json['tatmatrix/can.json']!);
    final m = Tatmatrix.zusammen(basis, pfad);
    final plan = [...m.plaene['selin']!, PlanSchritt(t: Uhrzeit.parse('23:58:00'), nach: 'am_jackenstaender', bis: Uhrzeit.parse('23:58:02'))];
    final kaputt = Tatmatrix(pfad: 'can', plaene: {...m.plaene, 'selin': plan}, ereignisse: m.ereignisse, gegenstaende: m.gegenstaende);
    final a = Ablauf(kanon.graph, kaputt, start: kanon.regeln.planVon, ende: kanon.regeln.planBis);
    final weg = a.abschnitte['selin']!.firstWhere((x) => x.istWeg);
    expect(weg.laenge / weg.bis.minus(weg.von), greaterThan(2.5));
  });
}

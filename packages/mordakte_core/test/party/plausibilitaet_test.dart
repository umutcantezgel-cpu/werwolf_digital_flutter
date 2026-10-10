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
    // Ausnahme (E-039): eine Kernperson mit erklärtem eigenem Pfadverhalten.
    final eigen = {for (final b in kanon.beobachtungen) if (b['eigenwissen'] == true) b['wer'] as String};
    expect(eigen, {'ahmet'});
    final erlaubt = {for (final z in zeugen.values) ...z, ...eigen};
    final wissen = pruefer.wissensUnterschiede();
    expect(wissen.keys.where((p) => !erlaubt.contains(p)), isEmpty, reason: '$wissen');
    expect(pruefer.verstoesse.where((v) => v.regel == 'Wissen'), isEmpty);
  });

  test('Rot-Probe: ohne erklärtes eigenes Pfadverhalten meldet der Prüfer Ahmets Wissen im Pfad Can', () {
    final k = Kanon.lade((d) {
      final j = kanon.json[d]!;
      if (d != 'beobachtungen.json') return j;
      return {
        ...j,
        'beobachtungen': [
          for (final x in j['beobachtungen'] as List) {...(x as Map).cast<String, Object?>()}..remove('eigenwissen'),
        ],
      };
    });
    final p = Plausibilitaet(k)..pruefe();
    expect(p.verstoesse.where((v) => v.regel == 'Wissen' && v.text.startsWith('ahmet ')), isNotEmpty);
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

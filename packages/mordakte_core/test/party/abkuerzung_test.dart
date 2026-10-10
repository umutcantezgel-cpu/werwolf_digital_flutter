// F-06, E-039 (F6-GEGEN-01 Nr. 1 bis 3, 6 bis 8): keine Abkürzung zum Täter.
// Vor Runde 3 bleiben immer zwei; allein bleibt die Täterperson nur über
// Schlüsselbeweis und Fundort; nach Runde 1 sieht die Lage in jedem Pfad gleich
// aus; kein Name verrät die Qualität eines Hinweises; der Kerzenständer zeigt
// in jedem Pfad gleich viele Funde.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

/// Kanon mit der Fassung vor E-039: Ahmet hat im Pfad Can Damirs Alibi.
Kanon _vorE039() => Kanon.lade((d) {
      final j = kanon.json[d]!;
      if (d != 'beobachtungen.json') return j;
      return {
        ...j,
        'beobachtungen': [
          for (final x in j['beobachtungen'] as List)
            switch ((x as Map)['id']) {
              'b_damir_ahmet_blieb' => {...x.cast<String, Object?>(), 'pfade': ['fatma', 'olli', 'can']},
              'b_damir_ahmet_weg' => {...x.cast<String, Object?>(), 'pfade': ['ahmet']},
              _ => x,
            },
        ],
      };
    });

void main() {
  late Simulator sim;
  setUpAll(() => sim = Simulator(kanon));

  test('in keiner Folge bleibt vor Runde 3 nur eine Person, und allein bleibt die Täterperson nur mit Schlüsselbeweis und Fundort', () {
    final f = <String>[];
    for (final p in kanon.pfade) {
      for (final folge in sim.folgen()) {
        final v = sim.verlauf(p, folge);
        if (v.restNachRunde[0].length < 2 || v.restNachRunde[1].length < 2) f.add('$p ${folge.join(',')}');
        if (v.rest.length == 1) {
          if (!v.fakten.contains('f_k_$p') || !v.fakten.contains('f_fundort_$p')) f.add('$p allein ohne Beweis: ${folge.join(',')}');
        }
      }
    }
    expect(f, isEmpty, reason: f.take(5).join('\n'));
  });

  test('nach Runde 1 bei bestem Spiel: in jedem Pfad genau eine Spätankunft, zwei Alibis und die Lage „Spur“', () {
    final erz = Erzaehler(kanon);
    for (final p in kanon.pfade) {
      final e = sim.ermittlung;
      final fakten = {
        for (final x in e.entscheidungen.where((x) => x.runde == 1)) ...e.faktenVon(x.richtig[p]!, p),
      };
      final st = e.stand(fakten);
      expect([for (final q in kanon.kernverdaechtige) if (st[q]!.contains('spaetankunft')) q], hasLength(1), reason: p);
      expect([for (final q in kanon.kernverdaechtige) if (st[q]!.contains('alibi')) q], hasLength(2), reason: p);
      final s = Spiel(kanon)..einrichten(Einstellungen(rollen: 4, detektiv: 'w', code: FallCode.fuerPfad(p, kanon.pfade)));
      expect(erz.lageStufe(s, fakten), 'spur', reason: p);
    }
  });

  test('Rot-Probe: mit Damirs Alibi für Ahmet im Pfad Can (vor E-039) meldet der Simulator die Abkürzung', () {
    final f = Simulator(_vorE039()).pruefe();
    expect(f.where((x) => x.startsWith('Pfad can')), isNotEmpty);
    expect(f, contains(startsWith('Pfad can: nach Runde 1 bei bestem Spiel')));
    expect(f, contains(startsWith('Pfad can: allein übrig ohne Schlüsselbeweis')));
  });

  test('kein Figurenname steht in den Hinweisen einer Runde nur bei einer Qualität (G-1)', () {
    final hinweise = Gruppenwahl(kanon).hinweise;
    // Vornamen der Figuren und der Nachname des Opfers, auch im Genitiv („Fatmas“, „Herrn Schneider“).
    final namen = {for (final f in kanon.figuren) f['name'] as String, 'Schneider'};
    final f = <String>[];
    for (var r = 1; r <= 3; r++) {
      for (final n in namen) {
        final q = {
          for (final h in hinweise)
            if (h['runde'] == r && RegExp('\\b${n}s?\\b').hasMatch(h['text'] as String)) h['qualitaet'],
        };
        if (q.length == 1) f.add('Runde $r: $n nur ${q.single}');
      }
    }
    expect(f, isEmpty, reason: f.join('\n'));
  });

  test('der Kerzenständer zeigt in jedem Pfad gleich viele Funde, harmlose Sätze sind mindestens halb so lang wie belastende', () {
    final e = sim.ermittlung;
    final anzahl = {for (final p in kanon.pfade) p: e.aufdecken('e3_2_kerzenstaender', p).length};
    expect(anzahl.values.toSet(), hasLength(1), reason: '$anzahl');
    final spuren = [
      for (final g in kanon.gegenstaende)
        for (final s in (g['spuren'] as List? ?? const [])) (s as Map).cast<String, Object?>(),
    ];
    for (final s in spuren.where((s) => s['harmlos'] != null)) {
      expect((s['harmlos'] as String).length * 2, greaterThanOrEqualTo((s['zeigt'] as String).length), reason: s['id'] as String);
    }
  });
}

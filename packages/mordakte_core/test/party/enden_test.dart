// F-07: Endenmatrix: genau ein Ende je Punkte und Anklage; jedes Ende ist in jedem Pfad erreichbar.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

/// Endenmatrix des Masters (B-12): Punkte, Anklage richtig, erwartetes Ende.
const _masterTabelle = <(int, bool, String)>[
  (0, true, 'ende_teilerfolg'),
  (1, true, 'ende_teilerfolg'),
  (2, true, 'ende_teilerfolg'),
  (3, true, 'ende_teilerfolg'),
  (4, true, 'ende_teilerfolg'),
  (5, true, 'ende_teilerfolg'),
  (6, true, 'ende_teilerfolg'),
  (7, true, 'ende_meister'),
  (8, true, 'ende_meister'),
  (9, true, 'ende_meister'),
  (0, false, 'ende_eskalation'),
  (1, false, 'ende_eskalation'),
  (2, false, 'ende_eskalation'),
  (3, false, 'ende_eskalation'),
  (4, false, 'ende_justizirrtum'),
  (5, false, 'ende_justizirrtum'),
  (6, false, 'ende_justizirrtum'),
  (7, false, 'ende_justizirrtum'),
  (8, false, 'ende_justizirrtum'),
  (9, false, 'ende_justizirrtum'),
];

/// Das Ende zu Punkten und Anklage; bei mehrdeutiger Matrix eine Fehlerangabe.
String _endeOderFehler(Enden enden, int punkte, bool richtig) {
  try {
    return enden.ende(punkte, richtig).id;
  } on StateError {
    return 'nicht eindeutig: ${enden.passend(punkte, richtig).map((r) => r.id).join(', ')}';
  }
}

void main() {
  final enden = Enden(kanon);

  test('jede Kombination aus 0 bis 9 Punkten und Anklage passt auf genau eine Regel', () {
    for (var punkte = 0; punkte <= 9; punkte++) {
      for (final richtig in [true, false]) {
        expect(
          enden.passend(punkte, richtig),
          hasLength(1),
          reason: '$punkte Punkte, Anklage ${richtig ? 'richtig' : 'falsch'}',
        );
      }
    }
  });

  test('Endenmatrix wie im Master: alle 20 Kombinationen einzeln geprüft', () {
    expect(_masterTabelle, hasLength(20));
    final fehler = <String>[];
    for (final (punkte, richtig, erwartet) in _masterTabelle) {
      final gefunden = _endeOderFehler(enden, punkte, richtig);
      if (gefunden != erwartet) {
        fehler.add('$punkte Punkte, Anklage ${richtig ? 'richtig' : 'falsch'}: $gefunden statt $erwartet');
      }
    }
    expect(fehler, isEmpty, reason: fehler.join('\n'));
  });

  test('die Matrix hat genau die vier Enden des Masters', () {
    expect(
      enden.regeln.map((r) => r.id),
      unorderedEquals(['ende_meister', 'ende_teilerfolg', 'ende_justizirrtum', 'ende_eskalation']),
    );
  });

  test('die Simulation zählt jede Optionsfolge genau einmal', () {
    final sim = Simulator(kanon);
    final folgen = [for (final f in sim.folgen()) f.join(',')];
    final anzahl = sim.ermittlung.entscheidungen.fold<int>(1, (a, e) => a * e.optionen.length);
    expect(folgen, hasLength(anzahl));
    expect(folgen.toSet(), hasLength(anzahl));
  });

  test('jedes Ende ist in jedem Pfad erreichbar', () {
    final sim = Simulator(kanon);
    final folgen = sim.folgen().toList();
    final soll = {for (final r in enden.regeln) r.id};
    for (final pfad in kanon.pfade) {
      final erreicht = <String>{};
      for (final folge in folgen) {
        final punkte = sim.verlauf(pfad, folge).punkte;
        for (final a in kanon.kernverdaechtige) {
          erreicht.add(enden.ende(punkte, a == pfad).id);
        }
      }
      expect(erreicht, unorderedEquals(soll), reason: 'Pfad $pfad');
    }
  });

  test('Rot-Probe: eine überlappende Matrix wird erkannt (ende_teilerfolg reicht bis 7)', () {
    expect(enden.passend(7, true), hasLength(1), reason: 'Kontrolle: das Original ist eindeutig');
    final verrueckt = Kanon.lade((p) {
      final j = leseJson('$repoWurzel/content/party/schlosskeller/$p');
      if (p == 'fall.json') {
        final matrix = ((j['enden'] as Map)['matrix'] as List).cast<Map<String, Object?>>();
        matrix.firstWhere((e) => e['id'] == 'ende_teilerfolg')['punkteBis'] = 7;
      }
      return j;
    });
    final kaputt = Enden(verrueckt);
    expect(kaputt.passend(7, true), hasLength(2));
    expect(() => kaputt.ende(7, true), throwsStateError);
  });
}

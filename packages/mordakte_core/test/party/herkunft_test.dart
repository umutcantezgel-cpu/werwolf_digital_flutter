// TON §7 und §10 Nr. 5 (F-15, E-039 zu F6-GEGEN-03 Nr. 8): Die Herkunftsmatrix
// ist maschinenlesbar, und keine Herkunft trägt eine Art von Verfehlung allein.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

void main() {
  test('Matrix umfasst alle 20 Figuren mit fünf Herkünften', () {
    final m = herkunftsMatrix(kanon);
    expect(m, hasLength(20));
    expect({for (final z in m) z.herkunft}, {'deutsch', 'türkisch', 'polnisch', 'bosnisch', 'kurdisch'});
  });

  test('keine Herkunft trägt Nebendelikt, Lüge oder Verschweigen allein; eine Kopftuchträgerin ist unbelastet', () {
    final m = herkunftsMatrix(kanon);
    expect(herkunftsVerstoesse(m), isEmpty);
    // Die vier Kernrollen haben vier verschiedene Herkünfte (E-007).
    expect({for (final z in m) if (z.kernrolle) z.herkunft}, hasLength(4));
  });

  test('Rot-Probe: alle Nebendelikte bei einer Herkunft werden gemeldet', () {
    final m = [
      for (final z in herkunftsMatrix(kanon))
        HerkunftZeile(z.figur, z.nebendelikt ? 'türkisch' : z.herkunft, z.kernrolle, z.nebendelikt, z.luegen, z.verschweigt, z.kopftuch),
    ];
    expect(herkunftsVerstoesse(m), contains(startsWith('Nebendelikt:')));
  });

  test('Rot-Probe: jede Kopftuchträgerin belastet wird gemeldet', () {
    final m = [
      for (final z in herkunftsMatrix(kanon))
        HerkunftZeile(z.figur, z.herkunft, z.kernrolle, z.nebendelikt || z.kopftuch, z.luegen, z.verschweigt, z.kopftuch),
    ];
    expect(herkunftsVerstoesse(m), contains(startsWith('Kopftuch:')));
  });
}

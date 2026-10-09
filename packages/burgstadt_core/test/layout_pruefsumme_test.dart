import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:test/test.dart';

/// Winzige Fixture-Welt: Keller mit Tür [tuerX] (Zielmarke h im Hof) und einem Tisch
/// der Höhe [tischHoehe]; Hof mit Marke h.
Map<String, Bereich> _welt({int tuerX = 2, double tischHoehe = 0.9}) {
  final zeile2 = [
    for (var x = 0; x < 7; x++) x == 0 || x == 6 ? '#' : (x == tuerX ? 'D' : (x == 4 ? 'T' : '.')),
  ].join();
  final keller = Bereich.ausJson({
    'id': 'keller',
    'name': 'Keller',
    'innen': true,
    'karte': ['#######', '#.....#', zeile2, '#..m..#', '#######'],
    'legende': {
      'D': {'art': 'tuer', 'name': 'Treppe zum Hof', 'ziel': 'hof', 'zielMarke': 'h'},
      'T': {'art': 'objekt', 'name': 'Tisch', 'form': 'tisch', 'hoehe': tischHoehe},
    },
  });
  final hof = Bereich.ausJson({
    'id': 'hof',
    'name': 'Hof',
    'innen': false,
    'karte': ['#######', '#.....#', '#..h..#', '#######'],
    'legende': <String, dynamic>{},
  });
  return {'keller': keller, 'hof': hof};
}

void main() {
  test('gleiche Eingabe ergibt gleichen Hash', () {
    final a = kanonischeForm(_welt());
    final b = kanonischeForm(_welt());
    expect(a, b);
    expect(fnv1a64(a), fnv1a64(b));
    expect(fnv1a64(a), hasLength(16));
  });

  test('verschobene Tür ändert den Hash', () {
    expect(fnv1a64(kanonischeForm(_welt(tuerX: 3))), isNot(fnv1a64(kanonischeForm(_welt()))));
  });

  test('geändertes Ding ändert den Hash', () {
    expect(fnv1a64(kanonischeForm(_welt(tischHoehe: 1.1))), isNot(fnv1a64(kanonischeForm(_welt()))));
  });

  test('FNV-1a 64 Bit: Referenzwerte', () {
    expect(fnv1a64(''), 'cbf29ce484222325');
    expect(fnv1a64('a'), 'af63dc4c8601ec8c');
  });
}

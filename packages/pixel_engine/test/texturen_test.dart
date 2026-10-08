import 'package:pixel_engine/src/kit/texturen.dart';
import 'package:pixel_engine/src/palette.dart';
import 'package:pixel_engine/src/raster/texture.dart';
import 'package:test/test.dart';

/// Texturen, die Grün (Rampe 5) tragen dürfen: Moos und Wiese.
const _gruenErlaubt = {'dachBiberschwanzMoos', 'wiese', 'bruchsteinMauer'};

/// „Gleich oder benachbart“: gleicher Index, oder gleiche Rampe mit höchstens einer Stufe Unterschied.
bool _benachbart(int a, int b) => a == b || (a >> 3 == b >> 3 && (a - b).abs() <= 1);

/// Anteil der Randpaare (links/rechts und oben/unten), die gleich oder benachbart sind.
double _kantenAnteil(IndexedTexture t) {
  final n = t.width, px = t.levels[0];
  var gut = 0, alle = 0;
  for (var i = 0; i < n; i++) {
    alle++;
    if (_benachbart(px[i * n], px[i * n + n - 1])) gut++;
    alle++;
    if (_benachbart(px[i], px[(n - 1) * n + i])) gut++;
  }
  return gut / alle;
}

void main() {
  test('Katalog: 36 Texturen, Index = TexturId.index', () {
    expect(TexturId.values.length, 36);
    final alle = baueAlleTexturen();
    expect(alle.length, TexturId.values.length);
    for (final id in TexturId.values) {
      expect(alle[id.index].width, baueTextur(id).width, reason: id.name);
    }
  });

  for (final id in TexturId.values) {
    group(id.name, () {
      test('Größe ist 32×32 oder 64×64 (Zweierpotenz, quadratisch)', () {
        final t = baueTextur(id);
        expect([32, 64], contains(t.width));
        expect(t.height, t.width);
      });

      test('nur Palettenindizes 0–63, keine Transparenz', () {
        final t = baueTextur(id);
        for (final lv in t.levels) {
          expect(lv.every((c) => c < 64), isTrue, reason: 'Index ≥ 64 oder 255');
        }
        expect(t.hasTransparency, isFalse);
      });

      test('kachelbar: Randpaare gleich oder benachbart ≥ 60 %', () {
        final anteil = _kantenAnteil(baueTextur(id));
        expect(anteil, greaterThanOrEqualTo(0.6), reason: '${(anteil * 100).toStringAsFixed(1)} % der Randpaare passen');
      });

      test('höchstens 5 verschiedene Farben (Auftrag: 4–5 Stufen, Abnahme: höchstens 6)', () {
        final farben = baueTextur(id).levels[0].toSet();
        expect(farben.length, lessThanOrEqualTo(5), reason: '${farben.length} Farben: $farben');
      });

      test('keine Grüntöne (Rampe 5) außer Moos, Wiese und Bruchsteinmauer', () {
        if (_gruenErlaubt.contains(id.name)) return;
        final gruen = baueTextur(id).levels[0].where((c) => c >> 3 == Ramp.green);
        expect(gruen, isEmpty);
      });

      test('deterministisch: zweimal bauen ergibt identische Bytes', () {
        final a = baueTextur(id), b = baueTextur(id);
        expect(a.levels.length, b.levels.length);
        for (var i = 0; i < a.levels.length; i++) {
          expect(a.levels[i], orderedEquals(b.levels[i]));
        }
      });
    });
  }
}

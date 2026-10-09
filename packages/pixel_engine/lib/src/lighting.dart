import 'dart:math' as math;
import 'dart:typed_data';

import 'palette.dart';

/// Licht-Tabelle im Stil der Doom-Colormaps: Basisfarbe × warmes Licht × kaltes
/// Licht × Nebel → Palettenindex. Damit bleibt jedes beleuchtete Pixel in der
/// Palette; Übergänge entstehen durch Bayer-Dithering zwischen den Stufen.
class LightTable {
  static const warmLevels = 8;
  static const coldLevels = 8;
  static const fogLevels = 4;
  /// Farben der Palette v2 (Zeilenlänge der Tabelle).
  static const colors = 160;

  /// [fog][warm][cold][farbe]
  final Uint8List table;

  /// Palettenindex der Nebelfarbe (für Himmel/Ferne).
  final int fogColor;

  /// Lichtstufen liegen quadratisch (Stufe k ↔ Licht (k/7)²): mehr Stufen im
  /// Dunkeln, wo die Nacht spielt. [levelLut] wandelt Licht 0..1 (×1024) in die
  /// Stufe 0..7 als Kommazahl.
  static final Float32List levelLut = Float32List.fromList(
      [for (var i = 0; i <= 1024; i++) math.sqrt(i / 1024) * 7]);

  /// Lichtwert der Stufe [k] (0..7).
  static double lightOfLevel(int k) => (k / 7) * (k / 7);

  LightTable._(this.table, this.fogColor);

  /// Standard-Nachtlicht: kaltes Mond-/Handylicht, warmes Kerzen-/Laternenlicht,
  /// bläulicher Nebel.
  factory LightTable.night({
    double ambient = 0.10,
    List<double> warmTint = const [1.30, 0.96, 0.58],
    List<double> coldTint = const [0.80, 0.90, 1.12],
    int fogRgb = 0x1E2A3A,
    double fogMax = 0.88,
    double crossRamp = 1.6,
  }) {
    final t = Uint8List(fogLevels * warmLevels * coldLevels * colors);
    final fr = (fogRgb >> 16) & 0xFF, fg = (fogRgb >> 8) & 0xFF, fb = fogRgb & 0xFF;
    var i = 0;
    for (var f = 0; f < fogLevels; f++) {
      final ft = f / (fogLevels - 1) * fogMax;
      for (var w = 0; w < warmLevels; w++) {
        final wl = lightOfLevel(w);
        for (var c = 0; c < coldLevels; c++) {
          final cl = lightOfLevel(c);
          final mr = ambient + wl * warmTint[0] + cl * coldTint[0];
          final mg = ambient + wl * warmTint[1] + cl * coldTint[1];
          final mb = ambient + wl * warmTint[2] + cl * coldTint[2];
          for (var p = 0; p < colors; p++) {
            var r = paletteR(p) * mr, g = paletteG(p) * mg, b = paletteB(p) * mb;
            r = r > 255 ? 255 : r;
            g = g > 255 ? 255 : g;
            b = b > 255 ? 255 : b;
            r = r + (fr - r) * ft;
            g = g + (fg - g) * ft;
            b = b + (fb - b) * ft;
            // Übergang (Migrationsbeleg 1): Suche nur über die 64 Farben der Palette v1
            t[i++] = nearestPaletteIndexBiased(r.round(), g.round(), b.round(), p >> 4, crossRamp: crossRamp, nurV1: true);
          }
        }
      }
    }
    return LightTable._(t, nearestPaletteIndex(fr, fg, fb));
  }

  @pragma('vm:prefer-inline')
  int lookup(int color, int warm, int cold, int fog) =>
      table[((fog * warmLevels + warm) * coldLevels + cold) * colors + color];
}

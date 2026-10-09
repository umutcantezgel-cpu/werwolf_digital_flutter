import 'dart:math' as math;
import 'dart:typed_data';

import 'palette.dart';

/// Licht-Tabelle im Stil der Doom-Colormaps: Basisfarbe × warmes Licht × kaltes
/// Licht × Nebel → Palettenindex. Damit bleibt jedes beleuchtete Pixel in der
/// Palette; Übergänge entstehen durch Bayer-Dithering zwischen den Stufen.
class LightTable {
  static const warmLevels = 16;
  static const coldLevels = 16;
  static const fogLevels = 6;
  /// Farben der Palette v2 (Zeilenlänge der Tabelle).
  static const colors = 160;

  /// [fog][warm][cold][farbe]
  final Uint8List table;

  /// Palettenindex der Nebelfarbe (für Himmel/Ferne).
  final int fogColor;

  /// Lichtstufen liegen auf einer Potenzkurve (Stufe k ↔ Licht (k/15)^1,6): mehr Stufen im Dunkeln,
  /// wo die Nacht spielt, und kleine Schritte auch im Hellen (Lichttabelle v2, Banding ≤ 1 Stufe).
  /// [levelLut] wandelt Licht 0..1 (×1024) in die Stufe 0..15 als Kommazahl.
  static const double lichtKurve = 1.6;
  static final Float32List levelLut = Float32List.fromList(
      [for (var i = 0; i <= 1024; i++) math.pow(i / 1024, 1 / lichtKurve) * (warmLevels - 1)]);

  /// Lichtwert der Stufe [k] (0..15).
  static double lightOfLevel(int k) => math.pow(k / (warmLevels - 1), lichtKurve).toDouble();

  /// Höchste Licht- und Nebelstufe (für die Klammern im Renderer).
  static const maxLight = warmLevels - 1, maxFog = fogLevels - 1;

  static LightTable? _nacht;

  /// Standard-Nachtlicht, einmal gebaut und geteilt (Aufbau ist teuer; L-05).
  static LightTable get nacht => _nacht ??= LightTable.night();

  LightTable._(this.table, this.fogColor);

  /// Standard-Nachtlicht: kaltes Mond-/Handylicht, warmes Kerzen-/Laternenlicht,
  /// bläulicher Nebel.
  factory LightTable.night({
    double ambient = 0.10,
    List<double> warmTint = const [1.30, 0.96, 0.58],
    List<double> coldTint = const [0.80, 0.90, 1.12],
    int fogRgb = 0x1E2A3A,
    double fogMax = 0.88,
    double crossRamp = 1.2,
  }) {
    final t = Uint8List(fogLevels * warmLevels * coldLevels * colors);
    final fr = (fogRgb >> 16) & 0xFF, fg = (fogRgb >> 8) & 0xFF, fb = fogRgb & 0xFF;
    // Schnelle Suche: Palette als Ganzzahl-Felder, Ergebnisse je (RGB, Rampe) zwischengespeichert –
    // dieselbe Formel wie [nearestPaletteIndexBiased], nur ohne Wiederholungen (L-05).
    final n = paletteRgb.length;
    final pr = Int32List(n), pg = Int32List(n), pb = Int32List(n);
    for (var k = 0; k < n; k++) {
      pr[k] = paletteR(k);
      pg[k] = paletteG(k);
      pb[k] = paletteB(k);
    }
    final merk = <int, int>{};
    int naechste(int r, int g, int b, int ramp) {
      final schluessel = ((r << 16) | (g << 8) | b) * 16 + ramp;
      final alt = merk[schluessel];
      if (alt != null) return alt;
      var best = 0;
      var bestD = double.infinity;
      for (var k = 0; k < n; k++) {
        // Grün (Grünregel E-025), Altrosa und Türkis (Fassadenrampen) erreicht nur, wer selbst daher kommt
        final rk = k >> 4;
        if (rk != ramp && (rk == Ramp.green || rk == Ramp.altrosa || rk == Ramp.tuerkis)) continue;
        final rm = (r + pr[k]) >> 1;
        final dr = r - pr[k], dg = g - pg[k], db = b - pb[k];
        var d = ((512 + rm) * dr * dr) / 256 + 4 * dg * dg + ((767 - rm) * db * db) / 256;
        if ((k >> 4) != ramp) d *= crossRamp;
        if (d < bestD) {
          bestD = d;
          best = k;
        }
      }
      merk[schluessel] = best;
      return best;
    }

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
            t[i++] = naechste(r.round(), g.round(), b.round(), p >> 4);
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

/// Feste Nachtpalette: 8 Rampen × 8 Stufen = 64 Farben (dunkel → hell).
///
/// Jede Farbe im fertigen Bild gehört zu dieser Palette. Die Kernfarben aus dem
/// Kanon-Stilblatt K8 sind exakt enthalten (markiert mit K8).
library;

/// Index 255 bedeutet in Sprites und Texturen „durchsichtig“.
const int kTransparent = 255;

/// Rampen (je 8 Stufen, Index = rampe * 8 + stufe).
abstract final class Ramp {
  /// Neutral kühl: Eisenschwarz bis Raureif-Weiß.
  static const neutral = 0;

  /// Bruchstein warmgrau.
  static const stone = 1;

  /// Holz, Fachwerk, Türen.
  static const wood = 2;

  /// Ziegelrot, Glut, Bordeaux, Orange.
  static const red = 3;

  /// Bernstein, Kerzenlicht, Senfgelb.
  static const amber = 4;

  /// Moos, Tannen, Grün (Kleidung nur Merle/Jonas).
  static const green = 5;

  /// Nachtblau bis Spukcyan.
  static const blue = 6;

  /// Haut und Pergament.
  static const skin = 7;

  static const count = 8;
  static const shades = 8;

  /// Palettenindex einer Rampe/Stufe (Stufe wird auf 0..7 begrenzt).
  static int at(int ramp, int shade) => ramp * shades + (shade < 0 ? 0 : (shade > 7 ? 7 : shade));
}

/// RGB-Werte der 64 Palettenfarben als 0xRRGGBB.
const List<int> paletteRgb = [
  // 0 neutral (Eisenschwarz K8 = Index 2)
  0x0B0C10, 0x16171D, 0x22201E, 0x34353B, 0x4B4D55, 0x6E717A, 0xA3A6AE, 0xE4E6EA,
  // 1 Bruchstein (K8 #6B6660 = Index 12)
  0x1C1A18, 0x2C2926, 0x403B37, 0x55504A, 0x6B6660, 0x8A847C, 0xADA69C, 0xD4CEC3,
  // 2 Holz
  0x1E120B, 0x2E1C11, 0x45291A, 0x5E3A24, 0x7A4E31, 0x976743, 0xB98A5E, 0xD9B88E,
  // 3 Rot/Glut (K8 Punschbraun #9C4A23 = 28, Glutorange #C8642B = 29)
  0x200C0A, 0x3A1410, 0x5A1E16, 0x7E2A1C, 0x9C4A23, 0xC8642B, 0xE08A4A, 0xF2B37A,
  // 4 Bernstein (K8 Kerzenbernstein #E8A33D = 37)
  0x2A1D08, 0x4A330E, 0x6E4C14, 0x94661A, 0xBC8424, 0xE8A33D, 0xF2C46A, 0xFBE6A8,
  // 5 Grün (K8 Moosgrün #4A5A3C = 44)
  0x0D140D, 0x172317, 0x22331F, 0x2F4429, 0x4A5A3C, 0x5F7A48, 0x7E9C5C, 0xA9C083,
  // 6 Blau (K8 Nachtblau #1E2A3A = 50, Spukcyan #A9D6D9 = 55)
  0x0A0F18, 0x121A28, 0x1E2A3A, 0x2A3B55, 0x3A5378, 0x56739B, 0x7F9DBF, 0xA9D6D9,
  // 7 Haut/Pergament (K8 Pergament #E9DCC0 = 63)
  0x2B1A12, 0x4A2E20, 0x6E4632, 0x93624A, 0xB98466, 0xD8A888, 0xEBC9AA, 0xE9DCC0,
];

/// Benannte Farben für Oberfläche und Effekte.
abstract final class Pal {
  static const black = 0; // fast schwarz
  static const iron = 2; // Eisenschwarz K8
  static const darkGrey = 3;
  static const grey = 5;
  static const lightGrey = 6;
  static const white = 7; // Raureif, Laken
  static const stone = 12; // Bruchstein K8
  static const woodDark = 19;
  static const wood = 21;
  static const bordeaux = 27;
  static const punch = 28; // Punschbraun K8
  static const ember = 29; // Glutorange K8
  static const orange = 30;
  static const mustard = 36;
  static const candle = 37; // Kerzenbernstein K8
  static const candleLight = 38;
  static const paleGold = 39;
  static const moss = 44; // Moosgrün K8
  static const green = 45;
  static const nightBlue = 50; // Nachtblau K8
  static const midBlue = 51;
  static const blue = 52;
  static const skyBlue = 54;
  static const ghostCyan = 55; // Spukcyan K8, sparsam
  static const parchment = 63; // Pergament K8
  static const ink = 1;
}

/// Palette als ARGB-Ints (0xFFRRGGBB).
final List<int> paletteArgb = List.unmodifiable([for (final c in paletteRgb) 0xFF000000 | c]);

int paletteR(int i) => (paletteRgb[i] >> 16) & 0xFF;
int paletteG(int i) => (paletteRgb[i] >> 8) & 0xFF;
int paletteB(int i) => paletteRgb[i] & 0xFF;

/// Nächste Palettenfarbe zu einem RGB-Wert (gewichtete Distanz, Rotmittel-Formel).
int nearestPaletteIndex(int r, int g, int b) => nearestPaletteIndexBiased(r, g, b, -1);

/// Wie [nearestPaletteIndex], aber Farben außerhalb der Rampe [ramp] zählen
/// [crossRamp]-mal weiter entfernt. So bleibt beim Abdunkeln der Farbton
/// erhalten und benachbarte Lichtstufen liegen in derselben Rampe (ruhiges Dithering).
int nearestPaletteIndexBiased(int r, int g, int b, int ramp, {double crossRamp = 1.6}) {
  var best = 0;
  var bestD = double.infinity;
  for (var i = 0; i < paletteRgb.length; i++) {
    final pr = paletteR(i), pg = paletteG(i), pb = paletteB(i);
    final rm = (r + pr) >> 1;
    final dr = r - pr, dg = g - pg, db = b - pb;
    var d = (((512 + rm) * dr * dr) / 256 + 4 * dg * dg + ((767 - rm) * db * db) / 256).toDouble();
    if (ramp >= 0 && (i >> 3) != ramp) d *= crossRamp;
    if (d < bestD) {
      bestD = d;
      best = i;
    }
  }
  return best;
}

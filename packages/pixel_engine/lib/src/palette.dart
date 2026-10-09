/// Feste Nachtpalette v2 (Burgstadt HD): 10 Rampen × 16 Stufen = 160 Farben (dunkel → hell).
///
/// Index = Rampe · 16 + Stufe. Die 64 Farben der Palette v1 (8 Rampen × 8 Stufen) liegen exakt
/// auf den ungeraden Stufen: alte Stufe s ↔ neue Stufe 2s + 1. Die geraden Stufen sind die
/// OKLab-Mitte zwischen den alten Nachbarstufen (Stufe 0 eine tiefere Variante der alten Stufe 0).
/// Neu sind die Rampen 8 (Altrosa) und 9 (Türkis, blauseitig – kein Grün).
///
/// Jede Farbe im fertigen Bild gehört zu dieser Palette. Die Kernfarben aus dem
/// Kanon-Stilblatt K8 sind exakt enthalten.
library;

/// Index 255 bedeutet in Sprites und Texturen „durchsichtig“.
const int kTransparent = 255;

/// Rampen (je 16 Stufen, Index = rampe * 16 + stufe).
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

  /// Altrosa (Fassaden, Burgstadt HD).
  static const altrosa = 8;

  /// Türkis, blauseitig (Fassaden, Burgstadt HD).
  static const tuerkis = 9;

  static const count = 10;

  /// Stufen je Rampe in Palette v2.
  static const shades = 16;

  /// Palettenindex einer Rampe in der 8er-Stufung der Palette v1 (Stufe 0..7 → 2·Stufe + 1).
  /// So bleiben alle Bestandsaufrufe und die eingefrorenen Figurendaten farbgleich.
  static int at(int ramp, int shade) => ramp * shades + 2 * (shade < 0 ? 0 : (shade > 7 ? 7 : shade)) + 1;

  /// Palettenindex einer Rampe in der vollen 16er-Stufung (Stufe 0..15).
  static int at16(int ramp, int shade) => ramp * shades + (shade < 0 ? 0 : (shade > 15 ? 15 : shade));
}

/// Rampe eines Palettenindex.
@pragma('vm:prefer-inline')
int rampeVon(int index) => index >> 4;

/// Stufe eines Palettenindex in der 16er-Stufung (0..15).
@pragma('vm:prefer-inline')
int stufeVon(int index) => index & 15;

/// Stufe eines Palettenindex in der 8er-Stufung der Palette v1 (0..7; Zwischenstufen abgerundet).
@pragma('vm:prefer-inline')
int stufe8Von(int index) => (index & 15) >> 1;

/// RGB-Werte der 160 Palettenfarben als 0xRRGGBB (Index = Rampe · 16 + Stufe).
const List<int> paletteRgb = [
  // 0 neutral (Eisenschwarz K8 = Ramp.at(neutral, 2))
  0x06070A, 0x0B0C10, 0x101116, 0x16171D, 0x1C1B1E, 0x22201E, 0x2B2A2C, 0x34353B,
  0x3F4148, 0x4B4D55, 0x5C5F67, 0x6E717A, 0x888B94, 0xA3A6AE, 0xC3C6CC, 0xE4E6EA,
  // 1 Bruchstein (K8 #6B6660 = Ramp.at(stone, 4))
  0x141311, 0x1C1A18, 0x24211F, 0x2C2926, 0x36322E, 0x403B37, 0x4A4540, 0x55504A,
  0x605B55, 0x6B6660, 0x7A756E, 0x8A847C, 0x9B958C, 0xADA69C, 0xC0BAAF, 0xD4CEC3,
  // 2 Holz
  0x170D07, 0x1E120B, 0x26170E, 0x2E1C11, 0x392215, 0x45291A, 0x51311F, 0x5E3A24,
  0x6C442A, 0x7A4E31, 0x885A3A, 0x976743, 0xA87850, 0xB98A5E, 0xC9A176, 0xD9B88E,
  // 3 Rot/Glut (K8 Punschbraun #9C4A23 = Ramp.at(red, 4), Glutorange #C8642B = Ramp.at(red, 5))
  0x160705, 0x200C0A, 0x2D100D, 0x3A1410, 0x4A1913, 0x5A1E16, 0x6C2419, 0x7E2A1C,
  0x8D3A20, 0x9C4A23, 0xB25727, 0xC8642B, 0xD4773B, 0xE08A4A, 0xE99F63, 0xF2B37A,
  // 4 Bernstein (K8 Kerzenbernstein #E8A33D = Ramp.at(amber, 5))
  0x1D1203, 0x2A1D08, 0x3A280B, 0x4A330E, 0x5C3F11, 0x6E4C14, 0x815917, 0x94661A,
  0xA8751F, 0xBC8424, 0xD29331, 0xE8A33D, 0xEDB455, 0xF2C46A, 0xF7D58A, 0xFBE6A8,
  // 5 Grün (K8 Moosgrün #4A5A3C = Ramp.at(green, 4))
  0x080D08, 0x0D140D, 0x121B12, 0x172317, 0x1C2B1B, 0x22331F, 0x283B24, 0x2F4429,
  0x3C4F32, 0x4A5A3C, 0x546A42, 0x5F7A48, 0x6E8B52, 0x7E9C5C, 0x93AE6F, 0xA9C083,
  // 6 Blau (K8 Nachtblau #1E2A3A = Ramp.at(blue, 2), Spukcyan #A9D6D9 = Ramp.at(blue, 7))
  0x060A11, 0x0A0F18, 0x0E1420, 0x121A28, 0x182231, 0x1E2A3A, 0x243247, 0x2A3B55,
  0x324766, 0x3A5378, 0x486389, 0x56739B, 0x6A88AD, 0x7F9DBF, 0x94B9CC, 0xA9D6D9,
  // 7 Haut/Pergament (K8 Pergament #E9DCC0 = Ramp.at(skin, 7))
  0x1E100A, 0x2B1A12, 0x3A2419, 0x4A2E20, 0x5C3A29, 0x6E4632, 0x80543E, 0x93624A,
  0xA67358, 0xB98466, 0xC89677, 0xD8A888, 0xE2B899, 0xEBC9AA, 0xEAD3B5, 0xE9DCC0,
  // 8 Altrosa (neu, Fassaden Marktviertel)
  0x150A09, 0x261211, 0x371B1A, 0x492525, 0x5A3030, 0x6C3B3C, 0x7D4849, 0x8D5557,
  0x9D6466, 0xAC7375, 0xBB8386, 0xC89497, 0xD4A6A8, 0xDFB8BB, 0xEACBCD, 0xF3DFE0,
  // 9 Türkis (neu, blauseitig, Fassaden Untere Stadt)
  0x031012, 0x021D21, 0x002A30, 0x03383F, 0x014750, 0x09565F, 0x18666E, 0x27757D,
  0x39848C, 0x4C949B, 0x60A3A9, 0x76B2B7, 0x8DC1C5, 0xA5D0D2, 0xBEDEE0, 0xD8EDED,
];

/// Benannte Farben für Oberfläche und Effekte (Werte = `Ramp.at(…)` der Palette v1, als
/// Literale, damit sie `const` bleiben; der Palettentest prüft Name → RGB).
abstract final class Pal {
  static const black = 1; // fast schwarz = Ramp.at(neutral, 0)
  static const iron = 5; // Eisenschwarz K8 = Ramp.at(neutral, 2)
  static const darkGrey = 7; // Ramp.at(neutral, 3)
  static const grey = 11; // Ramp.at(neutral, 5)
  static const lightGrey = 13; // Ramp.at(neutral, 6)
  static const white = 15; // Raureif, Laken = Ramp.at(neutral, 7)
  static const stone = 25; // Bruchstein K8 = Ramp.at(stone, 4)
  static const woodDark = 39; // Ramp.at(wood, 3)
  static const wood = 43; // Ramp.at(wood, 5)
  static const bordeaux = 55; // Ramp.at(red, 3)
  static const punch = 57; // Punschbraun K8 = Ramp.at(red, 4)
  static const ember = 59; // Glutorange K8 = Ramp.at(red, 5)
  static const orange = 61; // Ramp.at(red, 6)
  static const mustard = 73; // Ramp.at(amber, 4)
  static const candle = 75; // Kerzenbernstein K8 = Ramp.at(amber, 5)
  static const candleLight = 77; // Ramp.at(amber, 6)
  static const paleGold = 79; // Ramp.at(amber, 7)
  static const moss = 89; // Moosgrün K8 = Ramp.at(green, 4)
  static const green = 91; // Ramp.at(green, 5)
  static const nightBlue = 101; // Nachtblau K8 = Ramp.at(blue, 2)
  static const midBlue = 103; // Ramp.at(blue, 3)
  static const blue = 105; // Ramp.at(blue, 4)
  static const skyBlue = 109; // Ramp.at(blue, 6)
  static const ghostCyan = 111; // Spukcyan K8, sparsam = Ramp.at(blue, 7)
  static const parchment = 127; // Pergament K8 = Ramp.at(skin, 7)
  static const ink = 3; // Ramp.at(neutral, 1)
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
/// [nurV1] beschränkt die Suche auf die 64 Farben der Palette v1 (ungerade Stufen, Rampen 0–7).
int nearestPaletteIndexBiased(int r, int g, int b, int ramp, {double crossRamp = 1.6, bool nurV1 = false}) {
  var best = 0;
  var bestD = double.infinity;
  for (var i = 0; i < paletteRgb.length; i++) {
    if (nurV1 && ((i & 1) == 0 || (i >> 4) >= 8)) continue;
    final pr = paletteR(i), pg = paletteG(i), pb = paletteB(i);
    final rm = (r + pr) >> 1;
    final dr = r - pr, dg = g - pg, db = b - pb;
    var d = (((512 + rm) * dr * dr) / 256 + 4 * dg * dg + ((767 - rm) * db * db) / 256).toDouble();
    if (ramp >= 0 && (i >> 4) != ramp) d *= crossRamp;
    if (d < bestD) {
      bestD = d;
      best = i;
    }
  }
  return best;
}

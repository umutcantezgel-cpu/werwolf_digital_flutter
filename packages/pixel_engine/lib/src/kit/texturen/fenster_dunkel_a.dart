import '../../palette.dart';
import '../../raster/texture.dart';
import '../werkzeug.dart';

/// Dunkles Fensterglas mit Sprossenkreuz, Variante A (Burgstadt HD, Paket P1-AUTOR-07; Kandidat
/// `fensterDunkel_a`, Ersatz für den Bestand `fensterDunkel`). Nur die Glasfläche: Rahmen, Laibung und
/// Sims baut das Bauteil „fenster“ als Geometrie. 64×64 Texel = 1 m × 1 m, kachelbar, 64 Texel/m.
///
/// Sprossenkreuz: senkrechte und waagrechte Sprossen beginnen bei 0, 21 und 42 Texel (3 Felder je Meter,
/// Abstände 21, 21 und 22). Jede Sprosse hat einen 2 Texel breiten Körper aus `wood` Stufe 6 und außen
/// je eine 1 Texel breite Kante: links bzw. oben Stufe 8 (Licht), rechts bzw. unten Stufe 4 (Schatten).
/// Die Sprossen sind erhaben, das Licht kommt von oben links.
///
/// Glas aus `blue`: Jede Scheibe hat eine ganze Fläche in Stufe 2, 3 oder 4 (Lcg), unten und rechts je
/// 1 Texel Stufe 1 als Tiefe, oben links eine kurze diagonale Spiegelung unter 45° in Stufe 6, 3 bis 5
/// Texel lang (Lcg). Kein Rauschen. Zufall nur über [Lcg] mit festem Seed.
IndexedTexture fensterDunkelV2A() {
  const n = 64;
  final t = Tex(n), r = Lcg(6107);

  // Scheiben zwischen den Sprossen: Zeilen- und Spaltenbereiche gleich (Sprosse plus Kante).
  const scheiben = [(3, 19), (24, 40), (45, 62)];
  // Körperanfang je Sprosse; die Kanten liegen bei b − 1 (Licht) und b + 2 (Schatten).
  const sprossen = [0, 21, 42];
  const glasStufen = [2, 3, 4];

  final tiefe = Ramp.at16(Ramp.blue, 1), spiegel = Ramp.at16(Ramp.blue, 6);
  final licht = Ramp.at16(Ramp.wood, 8), holz = Ramp.at16(Ramp.wood, 6), schatten = Ramp.at16(Ramp.wood, 4);

  for (final (y0, y1) in scheiben) {
    for (final (x0, x1) in scheiben) {
      t.rect(x0, y0, x1 - x0 + 1, y1 - y0 + 1, Ramp.at16(Ramp.blue, glasStufen[r.below(glasStufen.length)]));
      t.hline(x0, y1, x1 - x0 + 1, tiefe);
      t.vline(x1, y0, y1 - y0 + 1, tiefe);
      final laenge = 3 + r.below(3);
      for (var k = 0; k < laenge; k++) {
        t.p(x0 + 2 + k, y0 + 2 + k, spiegel);
      }
    }
  }

  // Senkrechte Sprossen über die volle Höhe, waagrechte darüber (Kreuzungen gehören zur waagrechten).
  for (final b in sprossen) {
    t.vline(b - 1, 0, n, licht);
    t.vline(b, 0, n, holz);
    t.vline(b + 1, 0, n, holz);
    t.vline(b + 2, 0, n, schatten);
  }
  for (final b in sprossen) {
    t.hline(0, b - 1, n, licht);
    t.hline(0, b, n, holz);
    t.hline(0, b + 1, n, holz);
    t.hline(0, b + 2, n, schatten);
  }
  return t.build();
}

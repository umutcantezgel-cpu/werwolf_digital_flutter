import '../../palette.dart';
import '../../raster/texture.dart';
import '../werkzeug.dart';

/// Kopfsteinpflaster der Oberstadt-Gassen, Variante A (Reihenpflaster), Burgstadt HD, Paket P1-AUTOR-04.
/// 128×128 Texel (2 m). Gerundete Natursteine in versetzten Reihen: Körper aus `stone` Stufen 7–9,
/// jeder zehnte Stein mit einem Riss, jeder sechste Stein aus `neutral` (Stufen 7–8). Fugen 2 Texel
/// breit in Stufe 3. Oberkante und linke Kante 1 Texel heller, Unterkante und rechte Kante 2 Texel
/// dunkler (je 2 Stufen). Die Eckpixel jedes Steins haben die Fugenfarbe.
///
/// Die Reihen beginnen bei Zeile 126: Dort liegen drei Fugenzeilen (126, 127, 0), damit die
/// Textur nach unten nahtlos kachelt. Alle Reihen- und Steinkanten liegen auf geraden Texeln,
/// damit die Mip-Stufen die Fugen sauber treffen.
IndexedTexture pflasterV2A() {
  const n = 128;
  final t = Tex(n), r = Lcg(4101);
  t.fill(Ramp.at16(Ramp.stone, 3));

  // Reihenhöhe je Reihe (Körper + Fuge), Summe 128. Körper 10 oder 12 Texel (Reihenhöhe 11 ± 1).
  const reihen = [12, 14, 12, 12, 14, 12, 12, 14, 12, 14];
  // Steinbreite je Reihe (Körper + 2 Fugen), Summe 128. Körper 12 bis 16 Texel.
  const breiten = [14, 16, 18, 16, 14, 18, 16, 16];

  var y = 126;
  var versatz = 0;
  for (var k = 0; k < reihen.length; k++) {
    final oben = k == 0 ? y + 3 : y + 2;
    final unten = y + reihen[k] - 1;
    versatz = (versatz + 2 * (2 + r.below(3))) % n;
    final rot = r.below(breiten.length);
    var x = versatz;
    for (var i = 0; i < breiten.length; i++) {
      final p = breiten[(i + rot) % breiten.length];
      final neutral = r.below(6) == 0;
      final rampe = neutral ? Ramp.neutral : Ramp.stone;
      final koerper = neutral ? 7 + r.below(2) : 7 + r.below(3);
      _stein(t, r, a: x + 2, b: x + p - 1, y0: oben, y1: unten, rampe: rampe, koerper: koerper);
      x += p;
    }
    y += reihen[k];
  }
  return t.build();
}

/// Ein Stein im Rechteck [a]–[b] × [y0]–[y1] (Texel; [Tex] umbricht Koordinaten).
void _stein(
  Tex t,
  Lcg r, {
  required int a,
  required int b,
  required int y0,
  required int y1,
  required int rampe,
  required int koerper,
}) {
  final fuge = Ramp.at16(Ramp.stone, 3);
  final breite = b - a + 1, hoehe = y1 - y0 + 1;
  t.rect(a, y0, breite, hoehe, Ramp.at16(rampe, koerper));
  t.hline(a, y0, breite, Ramp.at16(rampe, koerper + 2));
  t.vline(a, y0, hoehe, Ramp.at16(rampe, koerper + 2));
  t.rect(a, y1 - 1, breite, 2, Ramp.at16(rampe, koerper - 2));
  t.rect(b - 1, y0, 2, hoehe, Ramp.at16(rampe, koerper - 2));
  for (final (x, y) in [(a, y0), (b, y0), (a, y1), (b, y1)]) {
    t.p(x, y, fuge);
  }
  // Jeder zehnte Stein bekommt einen 3–4 Texel langen Riss in Fugenfarbe, innen im Körper.
  if (r.below(10) == 0) {
    final laenge = 3 + r.below(2);
    final x0 = a + 2 + r.below(b - a - 2 - laenge);
    final y = y0 + 2 + r.below(hoehe - 4);
    t.hline(x0, y, laenge, fuge);
  }
}

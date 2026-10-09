import '../../palette.dart';
import '../../raster/texture.dart';
import '../werkzeug.dart';

/// Biberschwanz-Ziegeldach, Variante A (Doppeldeckung), Burgstadt HD, Paket P1-AUTOR-06 (HZ-04).
/// Ersetzt den Bestand `dachBiberschwanz`. 128×128 Texel (2 m). Oberkante der Textur am First,
/// Unterkante an der Traufe: die gerundeten Ziegelenden zeigen nach unten.
///
/// Elf Reihen mit sichtbar 11 oder 12 Texel; je zwei Reihen teilen sich eine Ziegelfolge, die zweite ist
/// um einen halben Ziegel (6 Texel) versetzt. Ziegel 10 oder 11 Texel breit, zwischen den Ziegeln 1 Texel
/// Fuge in `red` Stufe 4. Körper `red` Stufen 7–9 (je Ziegel eine von drei per Lcg), jeder achte Ziegel
/// `wood` Stufe 7 als gealterter brauner Ziegel (per Lcg mit Wahrscheinlichkeit 1 zu 8).
/// Licht von oben links: Oberkante 1 Texel +1, linke Kante 1 Texel +2 (Stufe höchstens 10), Unterkante und
/// rechte Kante 1 Texel −2. Die zwei unteren Eckpixel jeder Seite liegen in Schattenfarbe (`red` Stufe 3);
/// unter jedem Ziegelende liegen 2 Texel Schlagschatten (`red` Stufe 3) auf der nächsten Reihe.
///
/// Die Reihen summieren sich auf 128 Texel, und jede Reihe schließt aus Ziegeln und Fugen auf 128 Texel,
/// damit die Textur in beide Richtungen nahtlos kachelt. Der Kachelrand fällt in einen Ziegelkörper: Die
/// erste Reihe beginnt in Zeile 122, also 6 Texel über dem Texturrand, und keine Fuge liegt in Spalte 0 oder
/// 127. Zufall nur über [Lcg] mit festem Seed.

/// Sichtbare Höhe je Reihe (Summe 128).
const List<int> _reihenHoehe = [12, 12, 11, 12, 12, 11, 12, 11, 12, 12, 11];

/// Ziegelbreiten je Reihe (Summe 117, dazu 11 Fugen je 1 Texel = 128).
const List<int> _ziegelBreite = [11, 11, 10, 11, 11, 10, 11, 10, 11, 11, 10];

/// Ob keine Fuge der Reihe in Spalte 0 oder 127 liegt, wenn die Reihe bei [start] beginnt.
bool _fugeFrei(List<int> breiten, int start, int n) {
  var p = start;
  for (final w in breiten) {
    p += w;
    if (p % n == 0 || p % n == n - 1) return false;
    p += 1;
  }
  return true;
}

IndexedTexture dachBiberschwanzV2A() {
  const n = 128;
  final t = Tex(n), r = Lcg(4106);
  final fuge = Ramp.at16(Ramp.red, 4), schatten = Ramp.at16(Ramp.red, 3);
  t.fill(fuge);

  // Alle Ziegel als Rechtecke: Spalten a–b, Zeilen y0–y1 (mit Umbruch), Material und Körperstufe.
  final ziegel = <({int a, int b, int y0, int y1, int rampe, int koerper})>[];
  var y0 = n - 6;
  var breiten = <int>[];
  var start = 0;
  for (var k = 0; k < _reihenHoehe.length; k++) {
    final y1 = y0 + _reihenHoehe[k] - 1;
    if (k.isEven) {
      // Reihenpaar (k, k + 1) teilt sich eine Ziegelfolge; die zweite Reihe ist um 6 Texel (einen halben
      // Ziegel) versetzt. Der Anfang wird so gewählt, dass in beiden Reihen keine Fuge in Spalte 0 oder 127 liegt.
      breiten = List<int>.of(_ziegelBreite);
      for (var i = breiten.length - 1; i > 0; i--) {
        final j = r.below(i + 1);
        final tmp = breiten[i];
        breiten[i] = breiten[j];
        breiten[j] = tmp;
      }
      start = 0;
      while (!_fugeFrei(breiten, start, n) || !_fugeFrei(breiten, start + 6, n)) {
        start++;
      }
    }
    var x = k.isEven ? start : start + 6;
    for (final w in breiten) {
      final gealtert = r.below(8) == 0;
      ziegel.add((
        a: x,
        b: x + w - 1,
        y0: y0,
        y1: y1,
        rampe: gealtert ? Ramp.wood : Ramp.red,
        koerper: gealtert ? 7 : 7 + r.below(3),
      ));
      x += w + 1;
    }
    y0 = y1 + 1;
  }

  // Körper, Oberkante, Kanten und gerundete Enden.
  for (final z in ziegel) {
    final w = z.b - z.a + 1, h = z.y1 - z.y0 + 1, rampe = z.rampe, s = z.koerper;
    t.rect(z.a, z.y0, w, h, Ramp.at16(rampe, s));
    t.hline(z.a, z.y0, w, Ramp.at16(rampe, s + 1));
    t.hline(z.a, z.y1, w, Ramp.at16(rampe, s - 2));
    t.vline(z.a, z.y0, h, Ramp.at16(rampe, s + 2 > 10 ? 10 : s + 2));
    t.vline(z.b, z.y0, h, Ramp.at16(rampe, s - 2));
    for (final (x, y) in [(z.a, z.y1), (z.a, z.y1 - 1), (z.b, z.y1), (z.b, z.y1 - 1)]) {
      t.p(x, y, schatten);
    }
  }

  // Schlagschatten: 2 Texel unter jedem Ziegelende, auf der darunterliegenden Reihe.
  for (final z in ziegel) {
    final w = z.b - z.a + 1;
    t.hline(z.a, z.y1 + 1, w, schatten);
    t.hline(z.a, z.y1 + 2, w, schatten);
  }
  return t.build();
}

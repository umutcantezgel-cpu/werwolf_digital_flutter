import 'dart:typed_data';

import '../palette.dart';
import '../raster/texture.dart';

/// Werkzeugkasten für Pixeltexturen (Burgstadt HD, P1-OPUS-01): öffentliche Helfer, mit denen
/// die Bestandstexturen gezeichnet sind und neue Texturen in `kit/texturen/<name>.dart` entstehen.
/// Alles deterministisch: [Lcg] mit festem Seed, [hashTeil] für Varianten je Objekt und Teil –
/// nie `dart:math`-Zufall.

/// Kleiner LCG mit festem Seed. Modulo statt Bit-Maske, damit auch dart2js exakt rechnet.
class Lcg {
  Lcg(this._s);
  int _s;

  int next() {
    _s = (_s * 1664525 + 1013904223) % 4294967296;
    return _s ~/ 65536;
  }

  int below(int k) => next() % k;
}

/// Quadratische Indexfläche mit Wrap: Koordinaten außerhalb werden umbrochen,
/// dadurch setzt sich jede Figur, die über den Rand läuft, auf der Gegenseite fort.
class Tex {
  Tex(this.n) : px = Uint8List(n * n);

  final int n;
  final Uint8List px;

  int _i(int x, int y) => ((y % n) + n) % n * n + ((x % n) + n) % n;

  void p(int x, int y, int c) => px[_i(x, y)] = c;

  int g(int x, int y) => px[_i(x, y)];

  void fill(int c) => px.fillRange(0, px.length, c);

  void rect(int x, int y, int w, int h, int c) {
    for (var j = 0; j < h; j++) {
      for (var i = 0; i < w; i++) {
        p(x + i, y + j, c);
      }
    }
  }

  void hline(int x, int y, int w, int c) => rect(x, y, w, 1, c);

  void vline(int x, int y, int h, int c) => rect(x, y, 1, h, c);

  IndexedTexture build() => IndexedTexture(n, n, Uint8List.fromList(px));
}

/// Steine zwischen Fugen. Zeilenfugen [zeilen] sind aufsteigend; Band k reicht von
/// zeilen[k]+1 bis zeilen[k+1]-1 (mit Wrap). Spaltenfugen je Band stehen in [spalten][k].
/// Oben und links eine Stufe heller, unten und rechts eine Stufe dunkler. Mit [toene]
/// wird ein Teil der Steine eine Stufe dunkler gezeichnet. [ecken] färbt die unteren
/// Ecken jedes Steins (abgerundete Ziegelenden).
void steine(
  Tex t,
  Lcg r, {
  required int rampe,
  required int koerper,
  required int fuge,
  required List<int> zeilen,
  required List<List<int>> spalten,
  int toene = 1,
  int? ecken,
  int? runden,
}) {
  final n = t.n;
  t.fill(fuge);
  for (var k = 0; k < zeilen.length; k++) {
    final y0 = zeilen[k] + 1;
    final y1 = (k + 1 < zeilen.length ? zeilen[k + 1] : zeilen[0] + n) - 1;
    final fugen = spalten[k];
    if (fugen.isEmpty) {
      stein(t, r, rampe, koerper, toene, 0, n - 1, y0, y1, kanten: false, ecken: ecken, runden: runden);
      continue;
    }
    for (var i = 0; i < fugen.length; i++) {
      final a = fugen[i] + 1;
      final b = (i + 1 < fugen.length ? fugen[i + 1] : fugen[0] + n) - 1;
      stein(t, r, rampe, koerper, toene, a, b, y0, y1, kanten: true, ecken: ecken, runden: runden);
    }
  }
}

void stein(
  Tex t,
  Lcg r,
  int rampe,
  int koerper,
  int toene,
  int a,
  int b,
  int y0,
  int y1, {
  required bool kanten,
  int? ecken,
  int? runden,
}) {
  final dunkler = toene > 0 && r.below(3) == 0;
  final s = koerper - (dunkler ? 1 : 0);
  final korper = Ramp.at(rampe, s), hell = Ramp.at(rampe, s + 1), schatten = Ramp.at(rampe, s - 1);
  for (var y = y0; y <= y1; y++) {
    for (var x = a; x <= b; x++) {
      t.p(x, y, korper);
    }
  }
  for (var x = a; x <= b; x++) {
    t.p(x, y0, hell);
  }
  if (kanten) {
    for (var y = y0; y <= y1; y++) {
      t.p(a, y, hell);
    }
  }
  for (var x = a; x <= b; x++) {
    t.p(x, y1, schatten);
  }
  if (kanten) {
    for (var y = y0; y <= y1; y++) {
      t.p(b, y, schatten);
    }
  }
  if (ecken != null && kanten) {
    t.p(a, y1, ecken);
    t.p(b, y1, ecken);
  }
  if (runden != null && kanten) {
    for (final (x, y) in [(a, y0), (b, y0), (a, y1), (b, y1)]) {
      t.p(x, y, runden);
    }
  }
}

/// Senkrechte Bohlen zwischen den Fugen [fugenX] (aufsteigend, Wrap). Links hell, rechts dunkel,
/// dazu kurze Maserungsstriche in Körperfarbe dunkler.
void planken(
  Tex t,
  Lcg r, {
  required int rampe,
  required int koerper,
  required int fuge,
  required List<int> fugenX,
  int toene = 1,
  int maserung = 2,
}) {
  final n = t.n;
  t.fill(fuge);
  for (var i = 0; i < fugenX.length; i++) {
    final a = fugenX[i] + 1;
    final b = (i + 1 < fugenX.length ? fugenX[i + 1] : fugenX[0] + n) - 1;
    final dunkler = toene > 0 && r.below(3) == 0;
    final s = koerper - (dunkler ? 1 : 0);
    final korper = Ramp.at(rampe, s), hell = Ramp.at(rampe, s + 1), schatten = Ramp.at(rampe, s - 1);
    for (var y = 0; y < n; y++) {
      for (var x = a; x <= b; x++) {
        t.p(x, y, korper);
      }
      t.p(a, y, hell);
      t.p(b, y, schatten);
    }
    final breite = b - a - 1;
    for (var k = 0; k < maserung && breite > 0; k++) {
      final x0 = a + 1 + r.below(breite), y = r.below(n), laenge = 2 + r.below(3);
      for (var j = 0; j < laenge && x0 + j < b; j++) {
        t.p(x0 + j, y, schatten);
      }
    }
  }
}

/// Verputzte Fläche: gleichmäßiger Körper mit weichen Flecken und wenigen feuchten Schlieren.
IndexedTexture putz(int rampe, int b, {required int seed}) {
  final t = Tex(32), r = Lcg(seed);
  t.fill(Ramp.at(rampe, b));
  // Weiche Flecken: kleine Gruppen einen Schritt dunkler, nicht über die ganze Fläche.
  for (var k = 0; k < 5; k++) {
    final x = 2 + r.below(27), y = r.below(32);
    t.rect(x, y, 3 + r.below(2), 2, Ramp.at(rampe, b - 1));
  }
  // Feuchte Schlieren: zwei Pixel breit, nach unten kürzer.
  for (var k = 0; k < 3; k++) {
    final x = 3 + r.below(25), y = r.below(32), h = 4 + r.below(4);
    t.rect(x, y, 2, h, Ramp.at(rampe, b - 1));
  }
  return t.build();
}

/// 32-Bit-Multiplikation modulo 2³² aus 16-Bit-Teilprodukten – gleiche Ergebnisse auf der VM
/// und im Web (dart2js rechnet mit Gleitkommazahlen, volle 32×32-Produkte wären dort ungenau).
int _mul32(int a, int b) {
  final aLo = a & 0xFFFF, aHi = (a >> 16) & 0xFFFF;
  final bLo = b & 0xFFFF, bHi = (b >> 16) & 0xFFFF;
  return (aLo * bLo + ((((aHi * bLo) + (aLo * bHi)) & 0xFFFF) << 16)) & 0xFFFFFFFF;
}

/// Deterministischer Hash für Detailvarianten (K-011, E-008): [id] = stabile Objektkennung
/// (z. B. Haus-ID, Bereich + Ding), [teil] = Nummer des Teils (Fenster 3, Laden links …).
/// FNV-1a über die Zeichen, dann [teil] eingemischt und mit dem murmur3-Finalisierer verteilt.
/// Ergebnis 0 … 2³¹−1, auf VM und Web gleich. Nie den Zufallsstrom des Stadtgenerators nutzen.
int hashTeil(String id, int teil) {
  var h = 0x811C9DC5;
  for (final c in id.codeUnits) {
    h = _mul32(h ^ c, 0x01000193);
  }
  h = _mul32(h ^ (teil & 0xFFFFFFFF), 0x01000193);
  h ^= h >> 16;
  h = _mul32(h, 0x85EBCA6B);
  h ^= h >> 13;
  h = _mul32(h, 0xC2B2AE35);
  h ^= h >> 16;
  return h & 0x7FFFFFFF;
}

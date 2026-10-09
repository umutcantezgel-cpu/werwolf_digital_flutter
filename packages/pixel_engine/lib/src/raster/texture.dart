import 'dart:typed_data';

import '../palette.dart';

/// Indizierte Textur (Seitenlängen Zweierpotenzen) mit Mip-Stufen.
/// Mips werden per Mehrheitsfarbe gebildet – es entstehen keine neuen Farben.
class IndexedTexture {
  final List<Uint8List> levels;
  final List<int> widths;
  final List<int> heights;
  final bool hasTransparency;

  IndexedTexture._(this.levels, this.widths, this.heights, this.hasTransparency);

  int get width => widths[0];
  int get height => heights[0];

  factory IndexedTexture(int width, int height, Uint8List pixels, {int maxLevels = 5}) {
    assert(width & (width - 1) == 0 && height & (height - 1) == 0, 'Zweierpotenz nötig');
    final levels = <Uint8List>[pixels];
    final ws = <int>[width], hs = <int>[height];
    var w = width, h = height;
    var cur = pixels;
    while (levels.length < maxLevels && w > 1 && h > 1) {
      final nw = w >> 1, nh = h >> 1;
      final next = Uint8List(nw * nh);
      for (var y = 0; y < nh; y++) {
        for (var x = 0; x < nw; x++) {
          final a = cur[(2 * y) * w + 2 * x], b = cur[(2 * y) * w + 2 * x + 1];
          final c = cur[(2 * y + 1) * w + 2 * x], d = cur[(2 * y + 1) * w + 2 * x + 1];
          next[y * nw + x] = _majority(a, b, c, d);
        }
      }
      levels.add(next);
      ws.add(nw);
      hs.add(nh);
      cur = next;
      w = nw;
      h = nh;
    }
    return IndexedTexture._(levels, ws, hs, pixels.contains(kTransparent));
  }

  static int _majority(int a, int b, int c, int d) {
    if (a == b || a == c || a == d) return a;
    if (b == c || b == d) return b;
    if (c == d) return c;
    return a;
  }

  /// Texelverdoppelte Fassung (jede Seite ×2, nearest): Bestand mit 32 Texel/m für die Welt mit
  /// 64 Texel/m. Mip-Stufe k + 1 ist exakt Mip-Stufe k von [t]; die Stufenzahl bleibt gleich.
  factory IndexedTexture.verdoppelt(IndexedTexture t) {
    final w = t.width, h = t.height, src = t.levels[0];
    final px = Uint8List(w * h * 4);
    for (var y = 0; y < 2 * h; y++) {
      final zeile = (y >> 1) * w, ziel = y * 2 * w;
      for (var x = 0; x < 2 * w; x++) {
        px[ziel + x] = src[zeile + (x >> 1)];
      }
    }
    return IndexedTexture(2 * w, 2 * h, px, maxLevels: t.levels.length);
  }

  /// Einfarbige Textur.
  factory IndexedTexture.solid(int color, {int size = 8}) =>
      IndexedTexture(size, size, Uint8List(size * size)..fillRange(0, size * size, color));
}

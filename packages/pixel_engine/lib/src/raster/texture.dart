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

  /// Einfarbige Textur.
  factory IndexedTexture.solid(int color, {int size = 8}) =>
      IndexedTexture(size, size, Uint8List(size * size)..fillRange(0, size * size, color));
}

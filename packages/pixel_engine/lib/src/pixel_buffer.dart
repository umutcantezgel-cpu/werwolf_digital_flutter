import 'dart:typed_data';

import 'palette.dart';

/// Indizierter Bildpuffer (Palettenindizes) mit Tiefenpuffer (1/z, 0 = unendlich fern).
class PixelBuffer {
  final int width;
  final int height;
  final Uint8List color;
  final Float32List depth;

  PixelBuffer(this.width, this.height)
      : color = Uint8List(width * height),
        depth = Float32List(width * height);

  void clear(int colorIndex) {
    color.fillRange(0, color.length, colorIndex);
    depth.fillRange(0, depth.length, 0);
  }

  void clearDepth() => depth.fillRange(0, depth.length, 0);

  @pragma('vm:prefer-inline')
  int get(int x, int y) => color[y * width + x];

  @pragma('vm:prefer-inline')
  void set(int x, int y, int c) {
    if (x >= 0 && y >= 0 && x < width && y < height) color[y * width + x] = c;
  }

  void fillRect(int x, int y, int w, int h, int c) {
    final x0 = x < 0 ? 0 : x, y0 = y < 0 ? 0 : y;
    final x1 = x + w > width ? width : x + w, y1 = y + h > height ? height : y + h;
    for (var yy = y0; yy < y1; yy++) {
      color.fillRange(yy * width + x0, yy * width + x1 > yy * width + x0 ? yy * width + x1 : yy * width + x0, c);
    }
  }

  /// In RGBA8888-Bytes wandeln (für `ui.decodeImageFromPixels`, PNG).
  void toRgba(Uint8List out) {
    final o = out.buffer.asUint32List(out.offsetInBytes, width * height);
    final lut = _rgbaLut;
    for (var i = 0; i < color.length; i++) {
      o[i] = lut[color[i]];
    }
  }

  Uint8List toRgbaBytes() {
    final out = Uint8List(width * height * 4);
    toRgba(out);
    return out;
  }

  /// Kopiert [src] an die Stelle (dx, dy); [kTransparent] wird übersprungen.
  void blit(PixelBuffer src, int dx, int dy) {
    for (var y = 0; y < src.height; y++) {
      final ty = dy + y;
      if (ty < 0 || ty >= height) continue;
      for (var x = 0; x < src.width; x++) {
        final tx = dx + x;
        if (tx < 0 || tx >= width) continue;
        final c = src.color[y * src.width + x];
        if (c != kTransparent) color[ty * width + tx] = c;
      }
    }
  }
}

/// Little-Endian-Lookup: Palettenindex → RGBA als Uint32 (A<<24|B<<16|G<<8|R).
final Uint32List _rgbaLut = () {
  final l = Uint32List(256);
  for (var i = 0; i < 256; i++) {
    if (i < paletteRgb.length) {
      final c = paletteRgb[i];
      final r = (c >> 16) & 0xFF, g = (c >> 8) & 0xFF, b = c & 0xFF;
      l[i] = 0xFF000000 | (b << 16) | (g << 8) | r;
    } else if (i == kTransparent) {
      l[i] = 0; // durchsichtig (UI-Ebene)
    } else {
      l[i] = 0xFFFF00FF; // nie sichtbar – fällt im Palettentest auf
    }
  }
  return l;
}();

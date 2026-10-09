import 'dart:typed_data';

import 'palette.dart';

/// Prüfwerkzeuge für Pixeltreue (Ebene 5): Palettentest und Blocktest.

/// Anzahl Pixel in [rgba], deren Farbe nicht in der Palette liegt
/// (Alpha wird ignoriert, nur deckende Pixel zählen).
int countOffPalette(Uint8List rgba) {
  final set = <int>{for (final c in paletteRgb) c};
  var off = 0;
  for (var i = 0; i < rgba.length; i += 4) {
    if (rgba[i + 3] == 0) continue;
    final c = (rgba[i] << 16) | (rgba[i + 1] << 8) | rgba[i + 2];
    if (!set.contains(c)) off++;
  }
  return off;
}

/// Ergebnis des Blocktests.
class BlockResult {
  final int blocks;
  final int uniform;
  BlockResult(this.blocks, this.uniform);
  double get ratio => blocks == 0 ? 0 : uniform / blocks;
  @override
  String toString() => '$uniform/$blocks Blöcke einfarbig (${(ratio * 100).toStringAsFixed(2)} %)';
}

/// Blocktest: Das Bild [rgba] (Breite [w], Höhe [h]) wird in [k]×[k]-Blöcke ab
/// ([ox],[oy]) zerlegt; gezählt wird, wie viele Blöcke genau eine Farbe haben.
/// Bei ganzzahliger Skalierung ohne Glättung sind es 100 %.
BlockResult blockTest(Uint8List rgba, int w, int h, int k, {int ox = 0, int oy = 0, int? areaW, int? areaH}) {
  final aw = areaW ?? (w - ox), ah = areaH ?? (h - oy);
  var blocks = 0, uniform = 0;
  for (var by = oy; by + k <= oy + ah; by += k) {
    for (var bx = ox; bx + k <= ox + aw; bx += k) {
      blocks++;
      final i0 = (by * w + bx) * 4;
      final r = rgba[i0], g = rgba[i0 + 1], b = rgba[i0 + 2];
      var same = true;
      for (var y = by; y < by + k && same; y++) {
        for (var x = bx; x < bx + k; x++) {
          final i = (y * w + x) * 4;
          if (rgba[i] != r || rgba[i + 1] != g || rgba[i + 2] != b) {
            same = false;
            break;
          }
        }
      }
      if (same) uniform++;
    }
  }
  return BlockResult(blocks, uniform);
}

/// Ganzzahlige Vergrößerung ohne Glättung (Referenz für die Bildausgabe).
Uint8List upscaleRgba(Uint8List rgba, int w, int h, int k) {
  final out = Uint8List(w * k * h * k * 4);
  final ow = w * k;
  for (var y = 0; y < h * k; y++) {
    final sy = y ~/ k;
    for (var x = 0; x < ow; x++) {
      final s = (sy * w + x ~/ k) * 4, d = (y * ow + x) * 4;
      out[d] = rgba[s];
      out[d + 1] = rgba[s + 1];
      out[d + 2] = rgba[s + 2];
      out[d + 3] = rgba[s + 3];
    }
  }
  return out;
}

/// FNV-1a-Hash über Bytes (Determinismus-Prüfung, 32 Bit, auch in dart2js gleich).
int fnv1a(Uint8List bytes) {
  var h = 0x811c9dc5;
  for (final b in bytes) {
    h ^= b;
    h = (h * 0x01000193) & 0xffffffff;
  }
  return h;
}

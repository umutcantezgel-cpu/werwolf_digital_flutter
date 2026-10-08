import 'dart:typed_data';

import 'package:pixel_engine/pixel_engine.dart';

import 'skalierung.dart';

/// Setzt Welt (×kWelt) und UI (×kUi) zu einem Bild in physischen Pixeln zusammen –
/// genau wie die App-Hülle es zeigt. Für Bildschirmfotos und Pixeltests.
Uint8List komponiere(PixelBuffer welt, PixelBuffer ui, Skalierung s) {
  final w = s.physW, h = s.physH;
  final out = Uint8List(w * h * 4);
  final o = out.buffer.asUint32List();
  final wl = welt.toRgbaBytes().buffer.asUint32List();
  final ul = ui.toRgbaBytes().buffer.asUint32List();
  for (var y = 0; y < h; y++) {
    final wy = y ~/ s.kWelt, uy = y ~/ s.kUi;
    for (var x = 0; x < w; x++) {
      final u = ul[uy * ui.width + x ~/ s.kUi];
      o[y * w + x] = (u >>> 24) != 0 ? u : wl[wy * welt.width + x ~/ s.kWelt];
    }
  }
  return out;
}

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

/// Wandelt RGBA-Puffer in `ui.Image`: nativ synchron (Impeller), sonst asynchron
/// mit Verwerfen, solange noch ein Bild unterwegs ist (kein Rückstau).
class FrameSink {
  ui.Image? bild;
  bool _unterwegs = false;
  bool? _sync;
  int verworfen = 0;

  /// Übergibt [rgba] (wird bei asynchronem Weg kopiert). [fertig] wird gerufen, wenn
  /// ein neues Bild bereitsteht.
  void liefere(Uint8List rgba, int w, int h, VoidCallback fertig) {
    if (_sync != false && !kIsWeb) {
      try {
        final neu = ui.decodeImageFromPixelsSync(rgba, w, h, ui.PixelFormat.rgba8888);
        _sync = true;
        bild?.dispose();
        bild = neu;
        fertig();
        return;
      } catch (_) {
        _sync = false;
      }
    }
    if (_unterwegs) {
      verworfen++;
      return;
    }
    _unterwegs = true;
    final kopie = Uint8List.fromList(rgba);
    ui.decodeImageFromPixels(kopie, w, h, ui.PixelFormat.rgba8888, (neu) {
      _unterwegs = false;
      bild?.dispose();
      bild = neu;
      fertig();
    });
  }

  String get weg => _sync == true ? 'synchron' : 'asynchron';

  void dispose() {
    bild?.dispose();
    bild = null;
  }
}

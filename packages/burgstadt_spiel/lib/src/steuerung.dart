import 'dart:math' as math;

import 'package:pixel_engine/pixel_engine.dart';

/// Ich-Steuerung: Tastatur/Gamepad aus [Eingabe] plus Touch (linke Hälfte =
/// Joystick, rechte Hälfte = Blick ziehen, kurzes Tippen rechts = Aktion) und
/// Maus (Ziehen = Blick).
class Steuerung {
  int? _joyId;
  double _jx0 = 0, _jy0 = 0, _jx = 0, _jy = 0;
  int? _blickId;
  double _bx = 0, _by = 0, _bStartX = 0, _bStartY = 0, _bZeit = 0;

  /// Ergebnis dieses Bildes.
  double gehenX = 0, gehenY = 0, drehen = 0, nicken = 0;
  bool tippAktion = false;

  /// Joystick-Anzeige (UI-Pixel) oder null.
  (int, int, int, int)? joystick;

  static const joyRadius = 26.0;

  void verarbeite(Eingabe e, PixelUi ui, int uiW, double dt, {double empfindlichkeit = 1}) {
    tippAktion = false;
    var blickX = 0.0, blickY = 0.0;
    for (final z in e.zeiger) {
      switch (z.art) {
        case ZeigerArt.runter:
          if (ui.trifftUi(z.x, z.y)) continue;
          if (!z.maus && z.x < uiW / 2 && _joyId == null) {
            _joyId = z.id;
            _jx0 = _jx = z.x;
            _jy0 = _jy = z.y;
          } else if (_blickId == null) {
            _blickId = z.id;
            _bx = _bStartX = z.x;
            _by = _bStartY = z.y;
            _bZeit = 0;
          }
        case ZeigerArt.bewegt:
          if (z.id == _joyId) {
            _jx = z.x;
            _jy = z.y;
          } else if (z.id == _blickId) {
            blickX += z.x - _bx;
            blickY += z.y - _by;
            _bx = z.x;
            _by = z.y;
          }
        case ZeigerArt.hoch || ZeigerArt.abbruch:
          if (z.id == _joyId) _joyId = null;
          if (z.id == _blickId) {
            final weg = math.sqrt(math.pow(z.x - _bStartX, 2) + math.pow(z.y - _bStartY, 2));
            if (z.art == ZeigerArt.hoch && weg < 6 && _bZeit < 0.35 && !z.maus) tippAktion = true;
            if (z.art == ZeigerArt.hoch && weg < 3 && z.maus) tippAktion = true;
            _blickId = null;
          }
      }
    }
    if (_blickId != null) _bZeit += dt;
    // Joystick
    var jx = 0.0, jy = 0.0;
    if (_joyId != null) {
      var dx = _jx - _jx0, dy = _jy - _jy0;
      final l = math.sqrt(dx * dx + dy * dy);
      if (l > joyRadius) {
        dx = dx / l * joyRadius;
        dy = dy / l * joyRadius;
      }
      jx = dx / joyRadius;
      jy = -dy / joyRadius;
      joystick = (_jx0.round(), _jy0.round(), (_jx0 + dx).round(), (_jy0 + dy).round());
    } else {
      joystick = null;
    }
    // Tastatur
    var kx = 0.0, ky = 0.0;
    if (e.haelt(Taste.hoch)) ky += 1;
    if (e.haelt(Taste.runter)) ky -= 1;
    if (e.haelt(Taste.links)) kx -= 1;
    if (e.haelt(Taste.rechts)) kx += 1;
    gehenX = (jx + kx + e.gehenX).clamp(-1.0, 1.0);
    gehenY = (jy + ky + e.gehenY).clamp(-1.0, 1.0);
    var dreh = 0.0;
    if (e.haelt(Taste.drehLinks)) dreh -= 2.2 * dt;
    if (e.haelt(Taste.drehRechts)) dreh += 2.2 * dt;
    const proPixel = 0.0085;
    drehen = (blickX * proPixel + e.blickDx + dreh) * empfindlichkeit;
    nicken = (-blickY * proPixel - e.blickDy) * empfindlichkeit;
  }
}

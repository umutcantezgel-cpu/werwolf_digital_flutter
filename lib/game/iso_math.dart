import 'dart:math' as math;
import 'dart:ui';

/// Isometrische Projektion (2:1, Kachel 64×32).
///
/// Welt-Koordinaten sind Kacheln: `x` nach Osten, `y` nach Süden, `z` nach oben
/// in Höheneinheiten (1 = eine Kachel Höhe). „Bildschirm“ meint hier immer die
/// unskalierte Welt-Bildfläche in Pixeln (vor Kamera-Zoom/-Verschiebung).
///
///     screenX = (x − y) · 32
///     screenY = (x + y) · 16 − z · [unitZ]
abstract final class Iso {
  static const double tileW = 64;
  static const double tileH = 32;
  static const double halfW = 32;
  static const double halfH = 16;

  /// Pixel pro Höheneinheit.
  static const double unitZ = 40;

  /// Länge einer Kachelkante nach [applyGround] (32·√2).
  static const double groundScale = 45.254833995939045;

  static double sx(double x, double y) => (x - y) * halfW;
  static double sy(double x, double y, [double z = 0]) => (x + y) * halfH - z * unitZ;

  /// Welt → Bildschirm.
  static Offset toScreen(double x, double y, [double z = 0]) =>
      Offset((x - y) * halfW, (x + y) * halfH - z * unitZ);

  /// Bildschirm → Welt (auf der Bodenebene z = 0).
  static Offset toWorld(double sx, double sy) {
    final a = sx / halfW;
    final b = sy / halfH;
    return Offset((a + b) / 2, (b - a) / 2);
  }

  /// Richtungsvektor auf dem Bildschirm (z. B. Joystick) → Welt-Richtung mit
  /// derselben Länge wie die Eingabe (0..1). „Hoch“ bleibt „hoch“.
  static Offset screenDirToWorld(double dx, double dy) {
    final len = math.sqrt(dx * dx + dy * dy);
    if (len < 1e-9) return Offset.zero;
    final w = toWorld(dx, dy);
    final wl = w.distance;
    if (wl < 1e-9) return Offset.zero;
    return w * (len / wl);
  }

  /// Welt-Richtung → Bildschirm-Richtung (nicht normiert).
  static Offset worldDirToScreen(double dx, double dy) => Offset((dx - dy) * halfW, (dx + dy) * halfH);

  /// Blickwinkel (Welt, Radiant, 0 = Osten) → Bildschirm-Richtung (normiert).
  static Offset facingToScreen(double facing) {
    final d = worldDirToScreen(math.cos(facing), math.sin(facing));
    final l = d.distance;
    return l < 1e-9 ? const Offset(0, 1) : d / l;
  }

  /// Transformiert den Canvas so, dass ab dem aktuellen Ursprung in Welt-Einheiten
  /// auf der Bodenebene gezeichnet werden kann (1 Einheit = 1 Kachel).
  static void applyGround(Canvas canvas) {
    canvas.scale(1, 0.5);
    canvas.rotate(math.pi / 4);
    canvas.scale(groundScale);
  }

  /// Tiefe für die Sortierung (größer = weiter vorne).
  static double depth(double x, double y) => x + y;

  /// Bildschirm-Rechteck einer Kachel mit einem Objekt der Höhe [h].
  static Rect tileBounds(int x, int y, double h, [double margin = 0]) {
    final cx = (x - y) * halfW;
    final top = (x + y) * halfH - h * unitZ;
    final bottom = (x + y + 2) * halfH;
    return Rect.fromLTRB(cx - halfW - margin, top - margin, cx + halfW + margin, bottom + margin);
  }
}

import 'dart:math' as math;

/// Ich-Kamera. Welt: x = Osten, y = oben, z = Süden (Meter).
/// [yaw] 0 = Blick nach Osten, π/2 = nach Süden (wie `facing` im Bestand).
class Camera {
  double x = 0, y = 1.6, z = 0;
  double yaw = 0;
  double pitch = 0;

  /// Vertikales Sichtfeld in Radiant.
  double fovY = 62 * math.pi / 180;
  double near = 0.08;
  double far = 48;

  // Abgeleitete Werte (nach [update]).
  double fx = 1, fz = 0; // Blickrichtung (xz)
  double rx = 0, rz = 1; // rechts (xz)
  double cp = 1, sp = 0; // cos/sin pitch
  double focal = 1;
  double cx = 0, cy = 0;
  int width = 1, height = 1;

  void update(int w, int h) {
    width = w;
    height = h;
    fx = math.cos(yaw);
    fz = math.sin(yaw);
    rx = -fz;
    rz = fx;
    cp = math.cos(pitch);
    sp = math.sin(pitch);
    focal = (h / 2) / math.tan(fovY / 2);
    cx = w / 2;
    cy = h / 2;
  }

  /// Weltpunkt → Kameraraum (vx rechts, vy oben, vz vorwärts). Ergebnis in [out] ab [o].
  @pragma('vm:prefer-inline')
  void toView(double px, double py, double pz, List<double> out, int o) {
    final dx = px - x, dy = py - y, dz = pz - z;
    final vx = dx * rx + dz * rz;
    final vz0 = dx * fx + dz * fz;
    out[o] = vx;
    out[o + 1] = dy * cp - vz0 * sp;
    out[o + 2] = vz0 * cp + dy * sp;
  }

  /// Ist eine Kugel (Mittelpunkt, Radius) im Sichtkegel (grob, für Culling)?
  bool sphereVisible(double px, double py, double pz, double r) {
    final dx = px - x, dy = py - y, dz = pz - z;
    final vz0 = dx * fx + dz * fz;
    final vz = vz0 * cp + dy * sp;
    if (vz < -r || vz - r > far) return false;
    final vx = dx * rx + dz * rz;
    final vy = dy * cp - vz0 * sp;
    final tx = (width / 2) / focal, ty = (height / 2) / focal;
    final lim = vz.abs() + r * 1.8;
    return vx.abs() <= lim * tx + r && vy.abs() <= lim * ty + r;
  }
}

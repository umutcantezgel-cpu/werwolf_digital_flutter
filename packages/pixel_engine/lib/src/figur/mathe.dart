import 'dart:math' as math;

/// Affine 3×4-Matrix (Zeilen: [a b c tx; d e f ty; g h i tz]).
class Mat34 {
  final List<double> m;
  Mat34(this.m);

  factory Mat34.identitaet() => Mat34([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0]);

  factory Mat34.verschiebung(double x, double y, double z) => Mat34([1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, z]);

  factory Mat34.skalierung(double x, double y, double z) => Mat34([x, 0, 0, 0, 0, y, 0, 0, 0, 0, z, 0]);

  /// Drehung: erst um z, dann um x, dann um y (Gieren zuletzt) – Winkel in Radiant.
  factory Mat34.drehung(double rx, double ry, double rz) {
    final cx = math.cos(rx), sx = math.sin(rx);
    final cy = math.cos(ry), sy = math.sin(ry);
    final cz = math.cos(rz), sz = math.sin(rz);
    // R = Ry * Rx * Rz
    final rzM = Mat34([cz, -sz, 0, 0, sz, cz, 0, 0, 0, 0, 1, 0]);
    final rxM = Mat34([1, 0, 0, 0, 0, cx, -sx, 0, 0, sx, cx, 0]);
    final ryM = Mat34([cy, 0, sy, 0, 0, 1, 0, 0, -sy, 0, cy, 0]);
    return ryM * rxM * rzM;
  }

  Mat34 operator *(Mat34 o) {
    final a = m, b = o.m;
    return Mat34([
      a[0] * b[0] + a[1] * b[4] + a[2] * b[8],
      a[0] * b[1] + a[1] * b[5] + a[2] * b[9],
      a[0] * b[2] + a[1] * b[6] + a[2] * b[10],
      a[0] * b[3] + a[1] * b[7] + a[2] * b[11] + a[3],
      a[4] * b[0] + a[5] * b[4] + a[6] * b[8],
      a[4] * b[1] + a[5] * b[5] + a[6] * b[9],
      a[4] * b[2] + a[5] * b[6] + a[6] * b[10],
      a[4] * b[3] + a[5] * b[7] + a[6] * b[11] + a[7],
      a[8] * b[0] + a[9] * b[4] + a[10] * b[8],
      a[8] * b[1] + a[9] * b[5] + a[10] * b[9],
      a[8] * b[2] + a[9] * b[6] + a[10] * b[10],
      a[8] * b[3] + a[9] * b[7] + a[10] * b[11] + a[11],
    ]);
  }

  /// Punkt transformieren.
  (double, double, double) punkt(double x, double y, double z) =>
      (m[0] * x + m[1] * y + m[2] * z + m[3], m[4] * x + m[5] * y + m[6] * z + m[7], m[8] * x + m[9] * y + m[10] * z + m[11]);

  /// Richtung transformieren (ohne Verschiebung).
  (double, double, double) richtung(double x, double y, double z) =>
      (m[0] * x + m[1] * y + m[2] * z, m[4] * x + m[5] * y + m[6] * z, m[8] * x + m[9] * y + m[10] * z);

  /// Inverse (allgemeine affine Matrix).
  Mat34 invers() {
    final a = m[0], b = m[1], c = m[2], d = m[4], e = m[5], f = m[6], g = m[8], h = m[9], i = m[10];
    final co0 = e * i - f * h, co1 = -(d * i - f * g), co2 = d * h - e * g;
    final det = a * co0 + b * co1 + c * co2;
    final id = 1 / det;
    final r = [
      co0 * id, -(b * i - c * h) * id, (b * f - c * e) * id, 0.0,
      co1 * id, (a * i - c * g) * id, -(a * f - c * d) * id, 0.0,
      co2 * id, -(a * h - b * g) * id, (a * e - b * d) * id, 0.0,
    ];
    final tx = m[3], ty = m[7], tz = m[11];
    r[3] = -(r[0] * tx + r[1] * ty + r[2] * tz);
    r[7] = -(r[4] * tx + r[5] * ty + r[6] * tz);
    r[11] = -(r[8] * tx + r[9] * ty + r[10] * tz);
    return Mat34(r);
  }

  /// Normale (mit inverser Transponierter des linearen Teils dieser – bereits inversen – Matrix).
  (double, double, double) normaleAusInverser(double x, double y, double z) =>
      (m[0] * x + m[4] * y + m[8] * z, m[1] * x + m[5] * y + m[9] * z, m[2] * x + m[6] * y + m[10] * z);
}

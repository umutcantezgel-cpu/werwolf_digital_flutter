import 'dart:math' as math;
import 'dart:typed_data';

import 'iso_backen.dart';

/// Schattenkarte für gerichtetes Licht (7.3: Schatten aus der Form der Blöcke): Tiefen der
/// lichtzugewandten Oberflächenblöcke aller Körper einer Szene, gesehen aus Richtung des Lichts.
/// Aufbau einmal je Szene und Licht, Abfrage je Fläche in O(1).
class Schattenkarte {
  Schattenkarte._(this._l, this._e1, this._e2, this._u0, this._v0, this._t, this._b, this._h, this._tiefe);

  /// Baut die Karte für [welt] mit Licht zur Richtung [richtung] (zum Licht hin) und Texelgröße [texel] m.
  factory Schattenkarte.bau(List<Platzierung> welt, List<double> richtung, {double texel = 0.0125}) {
    final n = math.sqrt(richtung[0] * richtung[0] + richtung[1] * richtung[1] + richtung[2] * richtung[2]);
    final l = [richtung[0] / n, richtung[1] / n, richtung[2] / n];
    // Basis senkrecht zum Licht: e1 = l × z, e2 = e1 × l
    var e1 = [l[1], -l[0], 0.0];
    final n1 = math.sqrt(e1[0] * e1[0] + e1[1] * e1[1]);
    e1 = n1 < 1e-9 ? [1.0, 0.0, 0.0] : [e1[0] / n1, e1[1] / n1, 0.0];
    final e2 = [e1[1] * l[2] - e1[2] * l[1], e1[2] * l[0] - e1[0] * l[2], e1[0] * l[1] - e1[1] * l[0]];
    // Ausdehnung aus den Ecken aller Körper
    var u0 = double.infinity, u1 = -double.infinity, v0 = double.infinity, v1 = -double.infinity;
    for (final p in welt) {
      final k = p.koerper, s = k.blockgroesse;
      for (final x in [p.x, p.x + k.breite * s]) {
        for (final y in [p.y, p.y + k.tiefe * s]) {
          for (final z in [p.z, p.z + k.hoehe * s]) {
            final u = x * e1[0] + y * e1[1] + z * e1[2], v = x * e2[0] + y * e2[1] + z * e2[2];
            u0 = math.min(u0, u);
            u1 = math.max(u1, u);
            v0 = math.min(v0, v);
            v1 = math.max(v1, v);
          }
        }
      }
    }
    final b = ((u1 - u0) / texel).ceil() + 2, h = ((v1 - v0) / texel).ceil() + 2;
    final tiefe = Float32List(b * h)..fillRange(0, b * h, -1e30);
    // Lichtzugewandte Flächen: Normale · l > 0
    final seiten = <List<int>>[
      for (final s in const [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]])
        if (s[0] * l[0] + s[1] * l[1] + s[2] * l[2] > 1e-6) s,
    ];
    for (final p in welt) {
      final k = p.koerper, s = k.blockgroesse;
      final r = s * 0.6; // Fußabdruck des Blocks in der Karte (lückenlos bei Texel ≤ s/2, ohne Selbstschatten)
      final rt = (r / texel).ceil();
      k.jederBlock((x, y, z, _) {
        var frei = false;
        for (final d in seiten) {
          if (k.wert(x + d[0], y + d[1], z + d[2]) == 0) {
            frei = true;
            break;
          }
        }
        if (!frei) return;
        final cx = p.x + (x + 0.5) * s, cy = p.y + (y + 0.5) * s, cz = p.z + (z + 0.5) * s;
        final d = cx * l[0] + cy * l[1] + cz * l[2];
        final iu = ((cx * e1[0] + cy * e1[1] + cz * e1[2] - u0) / texel).floor();
        final iv = ((cx * e2[0] + cy * e2[1] + cz * e2[2] - v0) / texel).floor();
        for (var j = math.max(0, iv - rt); j <= math.min(h - 1, iv + rt); j++) {
          for (var i = math.max(0, iu - rt); i <= math.min(b - 1, iu + rt); i++) {
            final o = j * b + i;
            if (d > tiefe[o]) tiefe[o] = d;
          }
        }
      });
    }
    return Schattenkarte._(l, e1, e2, u0, v0, texel, b, h, tiefe);
  }

  final List<double> _l, _e1, _e2;
  final double _u0, _v0, _t;
  final int _b, _h;
  final Float32List _tiefe;

  /// Liegt der Weltpunkt im Schatten? [abstand] = Toleranz gegen Selbstschatten (≈ Blockgröße).
  bool imSchatten(double x, double y, double z, double abstand) {
    final i = ((x * _e1[0] + y * _e1[1] + z * _e1[2] - _u0) / _t).floor();
    final j = ((x * _e2[0] + y * _e2[1] + z * _e2[2] - _v0) / _t).floor();
    if (i < 0 || j < 0 || i >= _b || j >= _h) return false;
    final d = x * _l[0] + y * _l[1] + z * _l[2];
    return _tiefe[j * _b + i] > d + abstand;
  }

  /// Speicher der Karte in Bytes.
  int get speicherBytes => _tiefe.lengthInBytes;
}

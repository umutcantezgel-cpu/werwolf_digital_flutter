import 'dart:math' as math;
import 'dart:typed_data';

import '../daten/blockkoerper.dart';
import '../daten/material.dart';

/// Deterministischer Zufall (VM und Web gleich, keine Bibliothek): lineare Kongruenz, Werte exakt in
/// doppelter Genauigkeit darstellbar.
class FeinZufall {
  FeinZufall(int saat) : _s = saat & 0xFFFFFFFF;
  int _s;

  /// 0 ≤ x < 1.
  double naechste() {
    _s = (_s * 1664525 + 1013904223) % 4294967296;
    return _s / 4294967296;
  }

  /// −1 < x < 1.
  double zwischen() => naechste() * 2 - 1;
}

/// Ein beweglicher Blockkörper (7.4): Lage, Drehung (Quaternion), Geschwindigkeit, Drehgeschwindigkeit,
/// Masse und Trägheit aus seinen Blöcken. Simulation nur mit Grundrechenarten und Wurzel (deterministisch).
class Starrkoerper {
  Starrkoerper(this.koerper, {required double x, required double y, required double z}) {
    _masse();
    px = x;
    py = y;
    pz = z;
  }

  final Blockkoerper koerper;

  /// Schwerpunkt in Welt (m) und Drehung als Quaternion (w, x, y, z).
  double px = 0, py = 0, pz = 0, qw = 1, qx = 0, qy = 0, qz = 0;

  /// Geschwindigkeit (m/s) und Drehgeschwindigkeit (rad/s) in Welt.
  double vx = 0, vy = 0, vz = 0, wx = 0, wy = 0, wz = 0;
  double masse = 0;

  /// Schwerpunkt im Körper (m, ab Block-Ecke 0,0,0).
  double sx = 0, sy = 0, sz = 0;

  /// Inverse Trägheit im Körper (3×3, zeilenweise).
  final Float64List _iInvKoerper = Float64List(9);

  /// Kontaktpunkte im Körper relativ zum Schwerpunkt (Ecken der Oberflächenblöcke, ausgedünnt).
  late Float64List punkte;
  bool schlaeft = false;
  int _ruhig = 0;

  /// Aufprallereignisse des letzten Schritts (für Klang und Bruch): Lage und Impuls.
  final List<(double, double, double, double)> stoesse = [];

  void _masse() {
    final s = koerper.blockgroesse, vol = s * s * s;
    var m = 0.0, mx = 0.0, my = 0.0, mz = 0.0;
    koerper.jederBlock((x, y, z, w) {
      final d = materialVon(koerper.tafel[w]!.material)!.dichte * vol;
      m += d;
      mx += d * (x + 0.5) * s;
      my += d * (y + 0.5) * s;
      mz += d * (z + 0.5) * s;
    });
    masse = m;
    sx = mx / m;
    sy = my / m;
    sz = mz / m;
    final t = Float64List(9);
    final eigen = s * s / 6; // Würfel um die eigene Achse: m·s²/6
    final pts = <double>[];
    var nr = 0;
    koerper.jederBlock((x, y, z, w) {
      final d = materialVon(koerper.tafel[w]!.material)!.dichte * vol;
      final rx = (x + 0.5) * s - sx, ry = (y + 0.5) * s - sy, rz = (z + 0.5) * s - sz;
      t[0] += d * (ry * ry + rz * rz + eigen);
      t[4] += d * (rx * rx + rz * rz + eigen);
      t[8] += d * (rx * rx + ry * ry + eigen);
      t[1] -= d * rx * ry;
      t[2] -= d * rx * rz;
      t[5] -= d * ry * rz;
      // Kontaktpunkte: äußere Ecken von Blöcken mit freier Nachbarseite, jeden zweiten nehmen
      final rand = koerper.wert(x - 1, y, z) == 0 || koerper.wert(x + 1, y, z) == 0 || koerper.wert(x, y - 1, z) == 0 ||
          koerper.wert(x, y + 1, z) == 0 || koerper.wert(x, y, z - 1) == 0 || koerper.wert(x, y, z + 1) == 0;
      if (rand && (nr++ & 1) == 0) pts.addAll([rx, ry, rz]);
    });
    t[3] = t[1];
    t[6] = t[2];
    t[7] = t[5];
    _invertiere(t, _iInvKoerper);
    punkte = Float64List.fromList(pts);
  }

  static void _invertiere(Float64List a, Float64List o) {
    final det = a[0] * (a[4] * a[8] - a[5] * a[7]) - a[1] * (a[3] * a[8] - a[5] * a[6]) + a[2] * (a[3] * a[7] - a[4] * a[6]);
    final i = 1 / det;
    o[0] = (a[4] * a[8] - a[5] * a[7]) * i;
    o[1] = (a[2] * a[7] - a[1] * a[8]) * i;
    o[2] = (a[1] * a[5] - a[2] * a[4]) * i;
    o[3] = (a[5] * a[6] - a[3] * a[8]) * i;
    o[4] = (a[0] * a[8] - a[2] * a[6]) * i;
    o[5] = (a[2] * a[3] - a[0] * a[5]) * i;
    o[6] = (a[3] * a[7] - a[4] * a[6]) * i;
    o[7] = (a[1] * a[6] - a[0] * a[7]) * i;
    o[8] = (a[0] * a[4] - a[1] * a[3]) * i;
  }

  /// Drehmatrix aus der Quaternion (zeilenweise) in [m].
  void matrix(Float64List m) {
    final w = qw, x = qx, y = qy, z = qz;
    m[0] = 1 - 2 * (y * y + z * z);
    m[1] = 2 * (x * y - w * z);
    m[2] = 2 * (x * z + w * y);
    m[3] = 2 * (x * y + w * z);
    m[4] = 1 - 2 * (x * x + z * z);
    m[5] = 2 * (y * z - w * x);
    m[6] = 2 * (x * z - w * y);
    m[7] = 2 * (y * z + w * x);
    m[8] = 1 - 2 * (x * x + y * y);
  }

  final Float64List _r = Float64List(9), _iw = Float64List(9);

  /// Inverse Trägheit in Welt: R · I⁻¹ · Rᵀ.
  Float64List inverseTraegheitWelt() {
    matrix(_r);
    final r = _r, a = _iInvKoerper, o = _iw;
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        var v = 0.0;
        for (var k = 0; k < 3; k++) {
          for (var l = 0; l < 3; l++) {
            v += r[i * 3 + k] * a[k * 3 + l] * r[j * 3 + l];
          }
        }
        o[i * 3 + j] = v;
      }
    }
    return o;
  }

  /// Integriert Lage und Drehung um [dt] (halbimplizit: erst Geschwindigkeit, dann Lage).
  void integriere(double dt) {
    px += vx * dt;
    py += vy * dt;
    pz += vz * dt;
    // q += 0.5 · (0, ω) · q · dt
    final dw = -wx * qx - wy * qy - wz * qz, dx = wx * qw + wy * qz - wz * qy;
    final dy = -wx * qz + wy * qw + wz * qx, dz = wx * qy - wy * qx + wz * qw;
    qw += 0.5 * dw * dt;
    qx += 0.5 * dx * dt;
    qy += 0.5 * dy * dt;
    qz += 0.5 * dz * dt;
    final n = 1 / math.sqrt(qw * qw + qx * qx + qy * qy + qz * qz);
    qw *= n;
    qx *= n;
    qy *= n;
    qz *= n;
  }

  /// Schlafzustand (7.4: was ruht, schläft): nach 0,5 s fast ohne Bewegung.
  void pruefeSchlaf(double dt) {
    final e = vx * vx + vy * vy + vz * vz + 0.05 * (wx * wx + wy * wy + wz * wz);
    if (e < 0.0004) {
      _ruhig++;
      if (_ruhig * dt > 0.5) {
        schlaeft = true;
        vx = vy = vz = wx = wy = wz = 0;
      }
    } else {
      _ruhig = 0;
    }
  }

  void wecke() {
    schlaeft = false;
    _ruhig = 0;
  }
}

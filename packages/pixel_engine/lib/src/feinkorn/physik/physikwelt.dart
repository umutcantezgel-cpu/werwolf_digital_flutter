import 'dart:math' as math;
import 'dart:typed_data';

import '../daten/material.dart';
import 'starrkoerper.dart';

/// Ruhender Quader (Möbel, Mauer) als Stoßpartner, achsenparallel, in Metern.
class Kasten {
  const Kasten(this.x0, this.y0, this.z0, this.x1, this.y1, this.z1);
  final double x0, y0, z0, x1, y1, z1;
}

/// Partikel-Speicher (7.4): feste Kapazität, wiederverwendet; abgelagerte Partikel ruhen und rechnen nicht mehr.
class Partikel {
  Partikel(this.kapazitaet)
      : x = Float64List(kapazitaet),
        y = Float64List(kapazitaet),
        z = Float64List(kapazitaet),
        vx = Float64List(kapazitaet),
        vy = Float64List(kapazitaet),
        vz = Float64List(kapazitaet),
        groesse = Float64List(kapazitaet),
        farbe = Int32List(kapazitaet),
        material = Uint8List(kapazitaet),
        zustand = Uint8List(kapazitaet),
        ruhig = Uint16List(kapazitaet);

  final int kapazitaet;
  final Float64List x, y, z, vx, vy, vz, groesse;
  final Int32List farbe;
  final Uint8List material;

  /// 0 = frei, 1 = fliegt, 2 = abgelagert.
  final Uint8List zustand;
  final Uint16List ruhig;
  int _naechster = 0;

  int get fliegend => zustand.where((z) => z == 1).length;
  int get abgelagert => zustand.where((z) => z == 2).length;

  /// Legt ein Partikel an (Ring: das älteste fliegende oder freie wird überschrieben).
  void neu(double px, double py, double pz, double qx, double qy, double qz, double g, int f, int m) {
    var i = _naechster;
    for (var n = 0; n < kapazitaet; n++) {
      final j = (_naechster + n) % kapazitaet;
      if (zustand[j] == 0) {
        i = j;
        break;
      }
    }
    _naechster = (i + 1) % kapazitaet;
    x[i] = px;
    y[i] = py;
    z[i] = pz;
    vx[i] = qx;
    vy[i] = qy;
    vz[i] = qz;
    groesse[i] = g;
    farbe[i] = f;
    material[i] = m;
    zustand[i] = 1;
    ruhig[i] = 0;
  }
}

/// Physikwelt mit fester Rate (7.4): unabhängig von der Bildrate, je Startwert deterministisch.
class Physikwelt {
  Physikwelt({this.rate = 120, int saat = 1, int partikel = 4096})
      : zufall = FeinZufall(saat),
        teilchen = Partikel(partikel);

  final int rate;
  double get dt => 1 / rate;
  final FeinZufall zufall;
  final Partikel teilchen;
  final List<Starrkoerper> koerper = [];
  final List<Kasten> kaesten = [];
  static const schwere = 9.81;
  double _rest = 0;
  int schritte = 0;

  /// Rückmeldung für Bruch und Klang: Körper, Lage, Impuls.
  void Function(Starrkoerper k, double x, double y, double z, double impuls)? aufprall;

  /// Läuft [sekunden] Wanduhrzeit vor (beliebige Bildrate) und gibt die Zahl der Schritte zurück.
  int vor(double sekunden) {
    _rest += sekunden;
    var n = 0;
    while (_rest >= dt - 1e-12) {
      schritt();
      _rest -= dt;
      n++;
    }
    return n;
  }

  final Float64List _m = Float64List(9);

  /// Ein Simulationsschritt.
  void schritt() {
    schritte++;
    final h = dt;
    for (final k in koerper) {
      if (k.schlaeft) continue;
      k.vz -= schwere * h;
      _stoesse(k, h);
      k.integriere(h);
      k.pruefeSchlaf(h);
    }
    _partikel(h);
  }

  void _stoesse(Starrkoerper k, double h) {
    k.matrix(_m);
    final m = _m, p = k.punkte, n = p.length ~/ 3;
    // Kontakte sammeln: Weltpunkt, Normale, Tiefe
    final kon = <double>[];
    for (var i = 0; i < n; i++) {
      final lx = p[i * 3], ly = p[i * 3 + 1], lz = p[i * 3 + 2];
      final rx = m[0] * lx + m[1] * ly + m[2] * lz, ry = m[3] * lx + m[4] * ly + m[5] * lz, rz = m[6] * lx + m[7] * ly + m[8] * lz;
      final wx = k.px + rx, wy = k.py + ry, wz = k.pz + rz;
      if (wz < 0) kon.addAll([rx, ry, rz, 0, 0, 1, -wz]);
      for (final b in kaesten) {
        if (wx <= b.x0 || wx >= b.x1 || wy <= b.y0 || wy >= b.y1 || wz <= b.z0 || wz >= b.z1) continue;
        // kleinste Eindringtiefe wählt die Seite
        final t = [wx - b.x0, b.x1 - wx, wy - b.y0, b.y1 - wy, wz - b.z0, b.z1 - wz];
        var best = 0;
        for (var j = 1; j < 6; j++) {
          if (t[j] < t[best]) best = j;
        }
        const nx = [-1.0, 1.0, 0.0, 0.0, 0.0, 0.0], ny = [0.0, 0.0, -1.0, 1.0, 0.0, 0.0], nz = [0.0, 0.0, 0.0, 0.0, -1.0, 1.0];
        kon.addAll([rx, ry, rz, nx[best], ny[best], nz[best], t[best]]);
      }
    }
    final nk = kon.length ~/ 7;
    if (nk == 0) return;
    final iw = k.inverseTraegheitWelt();
    final inv = 1 / k.masse;
    final summe = Float64List(nk);
    // Material des Körpers: Reibung und Rückprall aus dem häufigsten Tafeleintrag (Prototyp: erster Eintrag)
    final mat = materialVon(k.koerper.tafel[1]!.material)!;
    final mu = mat.reibung, e = mat.abprall;
    var staerksterStoss = 0.0, sx = 0.0, sy = 0.0, sz = 0.0;
    for (var iter = 0; iter < 10; iter++) {
      for (var c = 0; c < nk; c++) {
        final o = c * 7;
        final rx = kon[o], ry = kon[o + 1], rz = kon[o + 2], nx = kon[o + 3], ny = kon[o + 4], nz = kon[o + 5], tiefe = kon[o + 6];
        // Relativgeschwindigkeit am Punkt: v + ω × r
        final ux = k.vx + k.wy * rz - k.wz * ry, uy = k.vy + k.wz * rx - k.wx * rz, uz = k.vz + k.wx * ry - k.wy * rx;
        final vn = ux * nx + uy * ny + uz * nz;
        // effektive Masse in Normalenrichtung
        final cx = ry * nz - rz * ny, cy = rz * nx - rx * nz, cz = rx * ny - ry * nx;
        final ix = iw[0] * cx + iw[1] * cy + iw[2] * cz, iy = iw[3] * cx + iw[4] * cy + iw[5] * cz, iz = iw[6] * cx + iw[7] * cy + iw[8] * cz;
        final kn = inv + (iy * rz - iz * ry) * nx + (iz * rx - ix * rz) * ny + (ix * ry - iy * rx) * nz;
        final bias = 0.2 / h * math.max(0.0, tiefe - 0.001);
        final ziel = (iter == 0 && vn < -0.5 ? -e * vn : 0.0) + bias;
        var j = (ziel - vn) / kn;
        final alt = summe[c];
        summe[c] = math.max(0.0, alt + j);
        j = summe[c] - alt;
        if (iter == 0 && -vn * k.masse / nk > staerksterStoss) {
          staerksterStoss = -vn * k.masse / nk;
          sx = k.px + rx;
          sy = k.py + ry;
          sz = k.pz + rz;
        }
        _impuls(k, inv, iw, rx, ry, rz, j * nx, j * ny, j * nz);
        // Reibung (Coulomb) in Tangentenrichtung
        final ux2 = k.vx + k.wy * rz - k.wz * ry, uy2 = k.vy + k.wz * rx - k.wx * rz, uz2 = k.vz + k.wx * ry - k.wy * rx;
        final vn2 = ux2 * nx + uy2 * ny + uz2 * nz;
        var tx = ux2 - vn2 * nx, ty = uy2 - vn2 * ny, tz = uz2 - vn2 * nz;
        final tl = math.sqrt(tx * tx + ty * ty + tz * tz);
        if (tl < 1e-9) continue;
        tx /= tl;
        ty /= tl;
        tz /= tl;
        final dx = ry * tz - rz * ty, dy = rz * tx - rx * tz, dz = rx * ty - ry * tx;
        final jx = iw[0] * dx + iw[1] * dy + iw[2] * dz, jy = iw[3] * dx + iw[4] * dy + iw[5] * dz, jz = iw[6] * dx + iw[7] * dy + iw[8] * dz;
        final kt = inv + (jy * rz - jz * ry) * tx + (jz * rx - jx * rz) * ty + (jx * ry - jy * rx) * tz;
        var jt = -tl / kt;
        final grenze = mu * summe[c];
        jt = jt < -grenze ? -grenze : (jt > grenze ? grenze : jt);
        _impuls(k, inv, iw, rx, ry, rz, jt * tx, jt * ty, jt * tz);
      }
    }
    if (staerksterStoss > 0.05) aufprall?.call(k, sx, sy, sz, staerksterStoss);
  }

  static void _impuls(Starrkoerper k, double inv, Float64List iw, double rx, double ry, double rz, double jx, double jy, double jz) {
    k.vx += jx * inv;
    k.vy += jy * inv;
    k.vz += jz * inv;
    final tx = ry * jz - rz * jy, ty = rz * jx - rx * jz, tz = rx * jy - ry * jx;
    k.wx += iw[0] * tx + iw[1] * ty + iw[2] * tz;
    k.wy += iw[3] * tx + iw[4] * ty + iw[5] * tz;
    k.wz += iw[6] * tx + iw[7] * ty + iw[8] * tz;
  }

  void _partikel(double h) {
    final t = teilchen;
    for (var i = 0; i < t.kapazitaet; i++) {
      if (t.zustand[i] != 1) continue;
      final m = materialVon(t.material[i])!;
      // Staub und Ruß schweben (Luftwiderstand hoch, Auftrieb), Krümel fallen
      final schwebt = m.bruch == Bruchmuster.koerner;
      final daempf = schwebt ? 3.0 : 0.15;
      t.vx[i] -= t.vx[i] * daempf * h;
      t.vy[i] -= t.vy[i] * daempf * h;
      t.vz[i] -= (schwere * (schwebt ? 0.12 : 1.0) + t.vz[i] * daempf) * h;
      t.x[i] += t.vx[i] * h;
      t.y[i] += t.vy[i] * h;
      t.z[i] += t.vz[i] * h;
      var boden = 0.0;
      for (final b in kaesten) {
        if (t.x[i] > b.x0 && t.x[i] < b.x1 && t.y[i] > b.y0 && t.y[i] < b.y1 && t.z[i] < b.z1 + 0.02 && t.z[i] > b.z1 - 0.05) boden = b.z1;
      }
      if (t.z[i] < boden) {
        t.z[i] = boden;
        t.vz[i] = -t.vz[i] * m.abprall;
        t.vx[i] *= 1 - m.reibung * 0.5;
        t.vy[i] *= 1 - m.reibung * 0.5;
      }
      final v2 = t.vx[i] * t.vx[i] + t.vy[i] * t.vy[i] + t.vz[i] * t.vz[i];
      if (t.z[i] <= boden + 1e-6 && v2 < 0.0025) {
        t.ruhig[i]++;
        if (t.ruhig[i] > rate * 0.2) {
          t.zustand[i] = 2; // Ablagerung: ruht und wird Teil der Welt
          t.vx[i] = t.vy[i] = t.vz[i] = 0;
        }
      } else {
        t.ruhig[i] = 0;
      }
    }
  }

  /// Prüfsumme des Zustands (Determinismus-Test): Lagen, Geschwindigkeiten, Partikel.
  int pruefsumme() {
    var h = 0x811C9DC5;
    void misch(double v) {
      final b = Float64List(1)..[0] = v;
      for (final x in b.buffer.asUint8List()) {
        h = _mul32(h ^ x, 0x01000193);
      }
    }

    for (final k in koerper) {
      for (final v in [k.px, k.py, k.pz, k.qw, k.qx, k.qy, k.qz, k.vx, k.vy, k.vz, k.wx, k.wy, k.wz]) {
        misch(v);
      }
    }
    for (var i = 0; i < teilchen.kapazitaet; i++) {
      if (teilchen.zustand[i] == 0) continue;
      misch(teilchen.x[i]);
      misch(teilchen.y[i]);
      misch(teilchen.z[i]);
    }
    return h;
  }
}

int _mul32(int a, int b) {
  final aLo = a & 0xFFFF, aHi = (a >> 16) & 0xFFFF;
  final bLo = b & 0xFFFF, bHi = (b >> 16) & 0xFFFF;
  return (aLo * bLo + ((((aHi * bLo) + (aLo * bHi)) & 0xFFFF) << 16)) & 0xFFFFFFFF;
}

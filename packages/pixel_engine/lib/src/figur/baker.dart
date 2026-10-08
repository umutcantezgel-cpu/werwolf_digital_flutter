import 'dart:math' as math;
import 'dart:typed_data';

import '../palette.dart';
import '../raster/mesh.dart' show kTexelsPerMeter;
import '../raster/renderer.dart' show SpriteImage;
import 'figur.dart';
import 'mathe.dart';

/// Alle gebrannten Bilder einer Figur: Animation → Bild → Richtung (0–7).
class FigurSatz {
  final Figurenkarte karte;
  final Map<String, List<List<SpriteImage>>> bilder;
  FigurSatz(this.karte, this.bilder);

  SpriteImage bild(String animation, int nr, int richtung) {
    final a = bilder[animation] ?? bilder['stehen']!;
    return a[nr % a.length][richtung & 7];
  }
}

class _Prim {
  final Mat34 inv; // Figur-Raum → Einheitskörper
  final Form form;
  final int material; // Index in _mats
  final bool kopf;
  final double cx, cy, cz, r; // Begrenzungskugel im Figur-Raum
  _Prim(this.inv, this.form, this.material, this.kopf, this.cx, this.cy, this.cz, this.r);
}

/// Brennt Figuren per Strahlwurf (orthografisch, 32 Texel/m) in 8 Richtungen:
/// Schattierung in der Materialrampe (Licht von links oben), 1-px-Kontur,
/// Innenlinien an Tiefensprüngen, Augen als Pixel.
class FigurBaker {
  static const int breite = 48, hoehe = 80, fussX = 24, fussY = 77;

  /// Blick leicht von oben (Grad).
  final double erhebung;

  /// Stilisierung für Lesbarkeit bei ~56 px Figurhöhe: größerer Kopf,
  /// kräftigere Glieder, etwas breiterer Rumpf.
  static const double kopfStil = 1.24, gliedStil = 1.3, rumpfStil = 1.1;
  final Map<String, Teil> bibliothek;

  FigurBaker(this.bibliothek, {this.erhebung = 7});

  static const _licht = (-0.55, 0.62, 0.56);

  FigurSatz backe(Figurenkarte k, {Iterable<String>? animationen}) {
    final out = <String, List<List<SpriteImage>>>{};
    for (final name in animationen ?? kAnimationen.keys) {
      final posen = kAnimationen[name]!;
      out[name] = [
        for (final p in posen) [for (var r = 0; r < 8; r++) backeEinzel(k, p, r)],
      ];
    }
    return FigurSatz(k, out);
  }

  /// Ein Bild: Figur [k] in Pose [p], Richtung [richtung] (0 = schaut zum
  /// Betrachter, 2 = schaut nach rechts, 4 = Rücken, 6 = nach links).
  SpriteImage backeEinzel(Figurenkarte k, Pose p, int richtung) {
    final s = k.groesse / 1.75;
    // Knochen
    final welt = <String, Mat34>{};
    for (final kn in kSkelett) {
      final d = p.dreh[kn.name] ?? const [0.0, 0.0, 0.0];
      const rad = math.pi / 180;
      final bx = kn.eltern == 'rumpf' || kn.eltern == 'becken' ? k.breite : 1.0;
      final lokal = Mat34.verschiebung(kn.x * s * bx, kn.y * s + (kn.eltern == null ? p.hebung : 0), kn.z * s) *
          Mat34.drehung(d[0] * rad, d[1] * rad, d[2] * rad);
      welt[kn.name] = kn.eltern == null ? lokal : welt[kn.eltern]! * lokal;
    }
    // Bodenkontakt: der tiefste Fuß steht immer auf y = 0.
    var tiefst = double.infinity;
    for (final f in const ['fussL', 'fussR']) {
      for (final z in const [-0.06, 0.045, 0.15]) {
        final (_, y, _) = welt[f]!.punkt(0, -0.065 * s, z * s);
        if (y < tiefst) tiefst = y;
      }
    }
    final boden = Mat34.verschiebung(0, -tiefst, 0);
    for (final kn in kSkelett) {
      welt[kn.name] = boden * welt[kn.name]!;
    }
    // Materialien und Umleitungen
    final teile = <Teil>[kKoerper, for (final id in k.teile) bibliothek[id] ?? (throw ArgumentError('Teil „$id“ fehlt'))];
    final umleitung = <String, String>{};
    for (final t in teile) {
      umleitung.addAll(t.umleitung);
    }
    final mats = <Material>[];
    final matIndex = <String, int>{};
    int material(String name) {
      var n = name;
      for (var i = 0; i < 8; i++) {
        final u = umleitung[n];
        if (u == null || u == n) break;
        n = u;
      }
      for (var i = 0; i < 8 && !k.materialien.containsKey(n) && !kMaterialStandard.containsKey(n); i++) {
        final e = kMaterialErsatz[n];
        if (e == null) break;
        n = e;
      }
      final m = k.materialien[n] ?? kMaterialStandard[n] ?? const Material(Ramp.neutral, 4);
      return matIndex.putIfAbsent(n, () {
        mats.add(m);
        return mats.length - 1;
      });
    }

    final prims = <_Prim>[];
    for (final t in teile) {
      for (final g in t.koerper) {
        final b = welt[g.knochen];
        if (b == null) throw ArgumentError('Knochen „${g.knochen}“ unbekannt (Teil ${t.id})');
        final istKopf = g.knochen == 'kopf';
        final kf = istKopf ? k.kopf * kopfStil : 1.0;
        final istRumpf = g.knochen == 'rumpf' || g.knochen == 'becken';
        final bf = istRumpf ? k.breite * rumpfStil : 1.0;
        final gl = !istKopf && !istRumpf ? gliedStil : 1.0;
        const rad = math.pi / 180;
        final m = b *
            Mat34.verschiebung(g.mitte[0] * s * kf * bf, g.mitte[1] * s * kf, g.mitte[2] * s * kf) *
            Mat34.drehung(g.dreh[0] * rad, g.dreh[1] * rad, g.dreh[2] * rad) *
            Mat34.skalierung(g.groesse[0] * s * kf * bf * gl, g.groesse[1] * s * kf, g.groesse[2] * s * kf * gl * (bf > 1 ? (1 + (bf - 1) * 0.6) : 1));
        final (cx, cy, cz) = m.punkt(0, 0, 0);
        var r = 0.0;
        for (final ax in [(1.0, 0.0, 0.0), (0.0, 1.0, 0.0), (0.0, 0.0, 1.0)]) {
          final (x, y, z) = m.richtung(ax.$1, ax.$2, ax.$3);
          r = math.max(r, math.sqrt(x * x + y * y + z * z));
        }
        if (g.form != Form.ellipsoid) r *= math.sqrt(3);
        prims.add(_Prim(m.invers(), g.form, material(g.material), istKopf && g.material == 'haut', cx, cy, cz, r * 1.001));
      }
    }

    // Ansicht: Figur um θ drehen, dann von oben neigen. W: Figur → Ansicht.
    final th = richtung * math.pi / 4;
    final e = erhebung * math.pi / 180;
    final w = Mat34([1, 0, 0, 0, 0, math.cos(e), -math.sin(e), 0, 0, math.sin(e), math.cos(e), 0]) *
        Mat34([math.cos(th), 0, math.sin(th), 0, 0, 1, 0, 0, -math.sin(th), 0, math.cos(th), 0]);
    final wi = w.invers();
    final (dfx, dfy, dfz) = wi.richtung(0, 0, -1);

    const n = breite * hoehe;
    final tiefe = Float64List(n)..fillRange(0, n, double.infinity);
    final mat = Int16List(n)..fillRange(0, n, -1);
    final kopfFlag = Uint8List(n);
    final schatten = Int8List(n);
    final (lx0, ly0, lz0) = _licht;
    final ll = math.sqrt(lx0 * lx0 + ly0 * ly0 + lz0 * lz0);
    final lx = lx0 / ll, ly = ly0 / ll, lz = lz0 / ll;

    for (var py = 0; py < hoehe; py++) {
      final vy = (fussY - (py + 0.5)) / kTexelsPerMeter;
      for (var px = 0; px < breite; px++) {
        final vx = (px + 0.5 - fussX) / kTexelsPerMeter;
        final (ox, oy, oz) = wi.punkt(vx, vy, 5);
        var bestT = double.infinity;
        _Prim? best;
        var bnx = 0.0, bny = 0.0, bnz = 0.0;
        for (final pr in prims) {
          // Begrenzungskugel
          final qx = pr.cx - ox, qy = pr.cy - oy, qz = pr.cz - oz;
          final proj = qx * dfx + qy * dfy + qz * dfz;
          if (qx * qx + qy * qy + qz * qz - proj * proj > pr.r * pr.r) continue;
          final inv = pr.inv;
          final (ux, uy, uz) = inv.punkt(ox, oy, oz);
          final (rx, ry, rz) = inv.richtung(dfx, dfy, dfz);
          final hit = _schneide(pr.form, ux, uy, uz, rx, ry, rz);
          if (hit == null || hit.$1 >= bestT) continue;
          bestT = hit.$1;
          best = pr;
          final (nx, ny, nz) = inv.normaleAusInverser(hit.$2, hit.$3, hit.$4);
          final (vnx, vny, vnz) = w.richtung(nx, ny, nz);
          final l = math.sqrt(vnx * vnx + vny * vny + vnz * vnz);
          bnx = vnx / l;
          bny = vny / l;
          bnz = vnz / l;
        }
        if (best == null) continue;
        final i = py * breite + px;
        tiefe[i] = bestT;
        mat[i] = best.material;
        kopfFlag[i] = best.kopf ? 1 : 0;
        final lam = bnx * lx + bny * ly + bnz * lz;
        schatten[i] = lam > 0.8 ? 1 : (lam > 0.42 ? 0 : (lam > 0.12 ? -1 : -2));
      }
    }

    // Farben, Kontur, Innenlinien
    final pix = Uint8List(n)..fillRange(0, n, kTransparent);
    for (var py = 0; py < hoehe; py++) {
      for (var px = 0; px < breite; px++) {
        final i = py * breite + px;
        final m = mat[i];
        if (m < 0) continue;
        final mm = mats[m];
        var rand = false, innen = false;
        for (final (dx, dy) in const [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
          final x2 = px + dx, y2 = py + dy;
          if (x2 < 0 || y2 < 0 || x2 >= breite || y2 >= hoehe) {
            rand = true;
            continue;
          }
          final j = y2 * breite + x2;
          if (mat[j] < 0) {
            rand = true;
          } else if (tiefe[j] < tiefe[i] - 0.07) {
            innen = true;
          }
        }
        int stufe;
        if (rand) {
          stufe = math.max(0, mm.stufe - 3);
        } else if (innen) {
          stufe = math.max(0, mm.stufe - 2);
        } else {
          stufe = (mm.stufe + schatten[i]).clamp(0, 7);
        }
        pix[i] = Ramp.at(mm.rampe, stufe);
      }
    }

    // Augen (nur auf sichtbarer Gesichtshaut)
    final kopf = welt['kopf']!;
    final kf = k.kopf * kopfStil;
    for (final seite in const [-1.0, 1.0]) {
      final (fx, fy, fz) = kopf.punkt(seite * 0.037 * s * kf, 0.118 * s * kf, 0.098 * s * kf);
      final (vx, vy, vz) = w.punkt(fx, fy, fz);
      final px = (vx * kTexelsPerMeter + fussX).floor();
      final py = (fussY - vy * kTexelsPerMeter).floor();
      if (px < 0 || py < 0 || px >= breite || py >= hoehe) continue;
      final i = py * breite + px;
      if (kopfFlag[i] == 0) continue;
      // sichtbar, wenn der Augpunkt nicht hinter der getroffenen Fläche liegt
      final tAuge = 5 - vz;
      if (tAuge > tiefe[i] + 0.03) continue;
      pix[i] = Ramp.at(Ramp.neutral, 1);
    }
    return SpriteImage(breite, hoehe, pix, footX: fussX, footY: fussY);
  }

  /// Schnitt mit Einheitskörper; liefert (t, nx, ny, nz) im Einheitsraum.
  static (double, double, double, double)? _schneide(Form f, double ox, double oy, double oz, double dx, double dy, double dz) {
    switch (f) {
      case Form.ellipsoid:
        final a = dx * dx + dy * dy + dz * dz;
        final b = 2 * (ox * dx + oy * dy + oz * dz);
        final c = ox * ox + oy * oy + oz * oz - 1;
        final disk = b * b - 4 * a * c;
        if (disk < 0) return null;
        final t = (-b - math.sqrt(disk)) / (2 * a);
        if (t < 0) return null;
        return (t, ox + t * dx, oy + t * dy, oz + t * dz);
      case Form.quader:
        var tmin = -double.infinity, tmax = double.infinity;
        var achse = 0;
        var vorz = 1.0;
        final o = [ox, oy, oz], d = [dx, dy, dz];
        for (var k = 0; k < 3; k++) {
          if (d[k].abs() < 1e-12) {
            if (o[k] < -1 || o[k] > 1) return null;
            continue;
          }
          var t1 = (-1 - o[k]) / d[k], t2 = (1 - o[k]) / d[k];
          var s = -1.0;
          if (t1 > t2) {
            final tmp = t1;
            t1 = t2;
            t2 = tmp;
            s = 1.0;
          }
          if (t1 > tmin) {
            tmin = t1;
            achse = k;
            vorz = s;
          }
          if (t2 < tmax) tmax = t2;
          if (tmin > tmax) return null;
        }
        if (tmin < 0) return null;
        return (tmin, achse == 0 ? vorz : 0, achse == 1 ? vorz : 0, achse == 2 ? vorz : 0);
      case Form.zylinder:
        double? best;
        var nx = 0.0, ny = 0.0, nz = 0.0;
        final a = dx * dx + dz * dz;
        if (a > 1e-12) {
          final b = 2 * (ox * dx + oz * dz);
          final c = ox * ox + oz * oz - 1;
          final disk = b * b - 4 * a * c;
          if (disk >= 0) {
            final t = (-b - math.sqrt(disk)) / (2 * a);
            final y = oy + t * dy;
            if (t >= 0 && y >= -1 && y <= 1) {
              best = t;
              nx = ox + t * dx;
              nz = oz + t * dz;
            }
          }
        }
        if (dy.abs() > 1e-12) {
          for (final cap in const [-1.0, 1.0]) {
            final t = (cap - oy) / dy;
            if (t < 0 || (best != null && t >= best)) continue;
            final x = ox + t * dx, z = oz + t * dz;
            if (x * x + z * z <= 1) {
              best = t;
              nx = 0;
              ny = cap;
              nz = 0;
            }
          }
        }
        return best == null ? null : (best, nx, ny, nz);
    }
  }
}

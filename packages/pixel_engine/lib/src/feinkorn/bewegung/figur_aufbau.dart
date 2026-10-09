import 'dart:math' as math;
import 'dart:typed_data';

import '../daten/blockkoerper.dart';
import 'skelett.dart';

/// Ergebnis eines Figuren-Aufbaus: Blockkörper in Weltausrichtung (Ecke bei [x], [y], [z]) und je Block
/// die Nummer des Knochens + 1 ([teilVon], 0 = leer) für die Lückenprüfung.
class Aufgebaut {
  Aufgebaut(this.koerper, this.x, this.y, this.z, this.teilVon);
  final Blockkoerper koerper;
  final double x, y, z;
  final Uint8List teilVon;

  int index(int i, int j, int k) => (k * koerper.tiefe + j) * koerper.breite + i;
}

/// Gelenkweg (7.5, K0-Prototyp): wie aus den Teilmodellen der Knochen in einer Pose ein Blockkörper wird.
enum Gelenkweg {
  /// Vorwärtsabbildung: jeder Block eines Teils wird gedreht und auf das Weltraster gerundet.
  /// Schnell, aber Drehungen reißen Löcher und Gelenke öffnen sich.
  starr,

  /// Neuaufbau je Bild: jeder Weltblock wird in die Teilmodelle zurückgerechnet (Rückabtastung), dazu
  /// Gelenkkugeln. Lückenlos; Details der Teilmodelle (Gesicht, Knöpfe) bleiben erhalten.
  rueck,
}

/// Baut die Figur in der gestellten Lage des [skelett] (vorher [Skelett.stelle] aufrufen).
/// [gelenkRadius] je Knochen (Index) füllt eine Kugel um sein Gelenk mit der Farbe des Teils.
Aufgebaut baueFigur(Skelett skelett, double s, Gelenkweg weg, {Map<int, double> gelenkRadius = const {}}) {
  // Weltgrenzen aus den gedrehten Teil-Hüllen
  var x0 = double.infinity, y0 = double.infinity, z0 = double.infinity, x1 = -double.infinity, y1 = -double.infinity, z1 = -double.infinity;
  for (var b = 0; b < skelett.knochen.length; b++) {
    final k = skelett.knochen[b], l = skelett.lagen[b], t = k.teil, ts = t.blockgroesse;
    for (final ax in [k.teilX, k.teilX + t.breite * ts]) {
      for (final ay in [k.teilY, k.teilY + t.tiefe * ts]) {
        for (final az in [k.teilZ, k.teilZ + t.hoehe * ts]) {
          final wx = l.x + l.m[0] * ax + l.m[1] * ay + l.m[2] * az;
          final wy = l.y + l.m[3] * ax + l.m[4] * ay + l.m[5] * az;
          final wz = l.z + l.m[6] * ax + l.m[7] * ay + l.m[8] * az;
          x0 = math.min(x0, wx);
          y0 = math.min(y0, wy);
          z0 = math.min(z0, wz);
          x1 = math.max(x1, wx);
          y1 = math.max(y1, wy);
          z1 = math.max(z1, wz);
        }
      }
    }
  }
  x0 = (x0 / s).floor() * s - s;
  y0 = (y0 / s).floor() * s - s;
  z0 = (z0 / s).floor() * s - s;
  final nx = ((x1 - x0) / s).ceil() + 2, ny = ((y1 - y0) / s).ceil() + 2, nz = ((z1 - z0) / s).ceil() + 2;
  final aus = Blockkoerper(blockgroesse: s, breite: nx, tiefe: ny, hoehe: nz);
  final teilVon = Uint8List(nx * ny * nz);
  // Tafeln zusammenführen: Teil-Eintrag → Index im Ausgabekörper
  final abb = <int, List<int>>{};
  for (var b = 0; b < skelett.knochen.length; b++) {
    final t = skelett.knochen[b].teil;
    abb[b] = [0, for (var i = 1; i < t.tafel.length; i++) aus.eintrag(t.tafel[i]!)];
  }

  for (var b = 0; b < skelett.knochen.length; b++) {
    final k = skelett.knochen[b], l = skelett.lagen[b], t = k.teil, ts = t.blockgroesse, m = l.m, tafel = abb[b]!;
    if (weg == Gelenkweg.starr) {
      t.jederBlock((i, j, kk, w) {
        final ax = k.teilX + (i + 0.5) * ts, ay = k.teilY + (j + 0.5) * ts, az = k.teilZ + (kk + 0.5) * ts;
        final ox = ((l.x + m[0] * ax + m[1] * ay + m[2] * az - x0) / s).floor();
        final oy = ((l.y + m[3] * ax + m[4] * ay + m[5] * az - y0) / s).floor();
        final oz = ((l.z + m[6] * ax + m[7] * ay + m[8] * az - z0) / s).floor();
        aus.setze(ox, oy, oz, tafel[w]);
        if (ox >= 0 && oy >= 0 && oz >= 0 && ox < nx && oy < ny && oz < nz) teilVon[(oz * ny + oy) * nx + ox] = b + 1;
      });
    } else {
      // Rückabtastung über die gedrehte Hülle des Teils
      var bx0 = 1 << 30, by0 = 1 << 30, bz0 = 1 << 30, bx1 = -1, by1 = -1, bz1 = -1;
      for (final ax in [k.teilX, k.teilX + t.breite * ts]) {
        for (final ay in [k.teilY, k.teilY + t.tiefe * ts]) {
          for (final az in [k.teilZ, k.teilZ + t.hoehe * ts]) {
            final ix = ((l.x + m[0] * ax + m[1] * ay + m[2] * az - x0) / s).floor();
            final iy = ((l.y + m[3] * ax + m[4] * ay + m[5] * az - y0) / s).floor();
            final iz = ((l.z + m[6] * ax + m[7] * ay + m[8] * az - z0) / s).floor();
            bx0 = math.min(bx0, ix);
            by0 = math.min(by0, iy);
            bz0 = math.min(bz0, iz);
            bx1 = math.max(bx1, ix);
            by1 = math.max(by1, iy);
            bz1 = math.max(bz1, iz);
          }
        }
      }
      for (var oz = math.max(0, bz0); oz <= math.min(nz - 1, bz1); oz++) {
        for (var oy = math.max(0, by0); oy <= math.min(ny - 1, by1); oy++) {
          for (var ox = math.max(0, bx0); ox <= math.min(nx - 1, bx1); ox++) {
            final dx = x0 + (ox + 0.5) * s - l.x, dy = y0 + (oy + 0.5) * s - l.y, dz = z0 + (oz + 0.5) * s - l.z;
            // Rᵀ · d
            final ax = m[0] * dx + m[3] * dy + m[6] * dz, ay = m[1] * dx + m[4] * dy + m[7] * dz, az = m[2] * dx + m[5] * dy + m[8] * dz;
            final w = t.wert(((ax - k.teilX) / ts).floor(), ((ay - k.teilY) / ts).floor(), ((az - k.teilZ) / ts).floor());
            if (w == 0) continue;
            aus.setze(ox, oy, oz, tafel[w]);
            teilVon[(oz * ny + oy) * nx + ox] = b + 1;
          }
        }
      }
      // Gelenkkugel: Farbe des Teils am Gelenk (nächster belegter Block im Teil nahe dem Ursprung)
      final r = gelenkRadius[b];
      if (r != null) {
        var farbe = 0;
        for (var d = 0; d < 6 && farbe == 0; d++) {
          farbe = t.wert(((-k.teilX) / ts).floor(), ((-k.teilY) / ts).floor(), ((-k.teilZ) / ts).floor() + d);
        }
        if (farbe != 0) {
          final cx = (l.x - x0) / s, cy = (l.y - y0) / s, cz = (l.z - z0) / s, rb = r / s;
          for (var oz = (cz - rb).floor(); oz <= (cz + rb).ceil(); oz++) {
            for (var oy = (cy - rb).floor(); oy <= (cy + rb).ceil(); oy++) {
              for (var ox = (cx - rb).floor(); ox <= (cx + rb).ceil(); ox++) {
                final ex = ox + 0.5 - cx, ey = oy + 0.5 - cy, ez = oz + 0.5 - cz;
                if (ex * ex + ey * ey + ez * ez > rb * rb) continue;
                if (aus.wert(ox, oy, oz) != 0) continue;
                aus.setze(ox, oy, oz, tafel[farbe]);
                if (ox >= 0 && oy >= 0 && oz >= 0 && ox < nx && oy < ny && oz < nz) teilVon[(oz * ny + oy) * nx + ox] = b + 1;
              }
            }
          }
        }
      }
    }
  }
  return Aufgebaut(aus, x0, y0, z0, teilVon);
}

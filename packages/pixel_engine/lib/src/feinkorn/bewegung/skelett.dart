import 'dart:math' as math;
import 'dart:typed_data';

import '../daten/blockkoerper.dart';

/// Ein Knochen des Skeletts (7.5): Gelenk relativ zum Gelenk des Elternknochens (Ruhepose, Meter),
/// Länge entlang der eigenen Achse und ein Blockmodell [teil] im Knochenraum (Ursprung = Gelenk).
class Knochen {
  Knochen(this.name, this.eltern, this.ox, this.oy, this.oz, this.teil, this.teilX, this.teilY, this.teilZ);

  final String name;

  /// Index des Elternknochens (−1 = Wurzel).
  final int eltern;

  /// Gelenklage relativ zum Elterngelenk in der Ruhepose (m).
  final double ox, oy, oz;

  /// Blockmodell des Teils; Block (i, j, k) liegt im Knochenraum bei teilX + i·s … (Gelenk = 0).
  final Blockkoerper teil;
  final double teilX, teilY, teilZ;
}

/// Pose: Drehwinkel je Knochen um die x-Achse (vor/zurück) und die y-Achse (seitlich), dazu Wurzelversatz.
class Pose {
  Pose(int knochen)
      : beugen = Float64List(knochen),
        seitlich = Float64List(knochen);

  final Float64List beugen, seitlich;
  double wurzelZ = 0, wurzelY = 0;
}

/// Weltlage eines Knochens: Drehmatrix (zeilenweise) und Gelenkposition.
class Lage {
  final Float64List m = Float64List(9);
  double x = 0, y = 0, z = 0;
}

/// Skelett mit Vorwärtskinematik. Drehungen nur aus vorberechneten Sinus/Kosinus der Pose
/// (die Simulation selbst bleibt deterministisch, Winkel kommen aus Animationsdaten).
class Skelett {
  Skelett(this.knochen) : lagen = [for (var i = 0; i < knochen.length; i++) Lage()];

  final List<Knochen> knochen;
  final List<Lage> lagen;

  int index(String name) => knochen.indexWhere((k) => k.name == name);

  /// Rechnet die Weltlagen aller Knochen für [pose] (Wurzel bei (wx, wy, wz)).
  void stelle(Pose pose, double wx, double wy, double wz) {
    for (var i = 0; i < knochen.length; i++) {
      final k = knochen[i];
      final l = lagen[i];
      // lokale Drehung: erst seitlich (um y), dann beugen (um x)
      final cb = math.cos(pose.beugen[i]), sb = math.sin(pose.beugen[i]);
      final cs = math.cos(pose.seitlich[i]), ss = math.sin(pose.seitlich[i]);
      // Rx(b) · Ry(s)
      final r = Float64List.fromList([cs, 0, ss, sb * ss, cb, -sb * cs, -cb * ss, sb, cb * cs]);
      if (k.eltern < 0) {
        l.m.setAll(0, r);
        l.x = wx + k.ox;
        l.y = wy + k.oy + pose.wurzelY;
        l.z = wz + k.oz + pose.wurzelZ;
      } else {
        final p = lagen[k.eltern];
        for (var a = 0; a < 3; a++) {
          for (var b = 0; b < 3; b++) {
            l.m[a * 3 + b] = p.m[a * 3] * r[b] + p.m[a * 3 + 1] * r[3 + b] + p.m[a * 3 + 2] * r[6 + b];
          }
        }
        l.x = p.x + p.m[0] * k.ox + p.m[1] * k.oy + p.m[2] * k.oz;
        l.y = p.y + p.m[3] * k.ox + p.m[4] * k.oy + p.m[5] * k.oz;
        l.z = p.z + p.m[6] * k.ox + p.m[7] * k.oy + p.m[8] * k.oz;
      }
    }
  }
}

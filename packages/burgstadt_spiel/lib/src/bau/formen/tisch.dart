import 'package:pixel_engine/pixel_engine.dart';

import '../form.dart';

/// Tisch (Muster-Form, 1:1 aus dem Bestand portiert): Platte 6 cm, vier Beine 8 × 8 cm.
class TischForm implements Moebelform {
  const TischForm();

  @override
  String get name => 'tisch';

  @override
  void baue(MeshBuilder m, FormOrt o) {
    final t = o.textur, h = o.hoehe, w = o.warm, k = o.kalt;
    m.box(o.x0, h - 0.06, o.z0, o.x1, h, o.z1, t, warm: w, cold: k);
    for (final (lx, lz) in [(o.x0 + 0.1, o.z0 + 0.1), (o.x1 - 0.18, o.z0 + 0.1), (o.x0 + 0.1, o.z1 - 0.18), (o.x1 - 0.18, o.z1 - 0.18)]) {
      m.box(lx, 0, lz, lx + 0.08, h - 0.06, lz + 0.08, t, warm: w * 0.8, cold: k);
    }
  }
}

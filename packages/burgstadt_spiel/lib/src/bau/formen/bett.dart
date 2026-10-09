import 'package:pixel_engine/pixel_engine.dart';

import '../form.dart';

/// Bett (Platzhalter bis P4-AUTOR): zeichnet wie der Bestand einen Quader über die Grundfläche.
class BettForm implements Moebelform {
  const BettForm();

  @override
  String get name => 'bett';

  @override
  void baue(MeshBuilder m, FormOrt o) {
    m.box(o.x0, 0, o.z0, o.x1, o.hoehe, o.z1, o.textur, warm: o.warm, cold: o.kalt);
  }
}

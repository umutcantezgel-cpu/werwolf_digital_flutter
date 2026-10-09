import 'package:pixel_engine/pixel_engine.dart';

import '../form.dart';

/// Stuhl (Platzhalter bis P4-AUTOR): zeichnet wie der Bestand einen Quader über die Grundfläche.
class StuhlForm implements Moebelform {
  const StuhlForm();

  @override
  String get name => 'stuhl';

  @override
  void baue(MeshBuilder m, FormOrt o) {
    m.box(o.x0, 0, o.z0, o.x1, o.hoehe, o.z1, o.textur, warm: o.warm, cold: o.kalt);
  }
}

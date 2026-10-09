import 'package:pixel_engine/pixel_engine.dart';

import '../form.dart';

/// Bank (Platzhalter bis P4-AUTOR): zeichnet wie der Bestand einen Quader über die Grundfläche.
class BankForm implements Moebelform {
  const BankForm();

  @override
  String get name => 'bank';

  @override
  void baue(MeshBuilder m, FormOrt o) {
    m.box(o.x0, 0, o.z0, o.x1, o.hoehe, o.z1, o.textur, warm: o.warm, cold: o.kalt);
  }
}

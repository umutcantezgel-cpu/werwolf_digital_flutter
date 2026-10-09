import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:room_host/raum_spiel.dart';

/// `BurgstadtRaum` als `RaumSpiel` (das Kernpaket kennt room_host nicht).
class BurgstadtRaumSpiel implements RaumSpiel {
  final BurgstadtRaum raum;
  BurgstadtRaumSpiel(this.raum);

  @override
  bool beitreten(String spielerId, String name) => raum.beitreten(spielerId, name);
  @override
  void verlassen(String spielerId) => raum.verlassen(spielerId);
  @override
  void verbunden(String spielerId, bool ja) => raum.verbunden(spielerId, ja);
  @override
  void nachricht(String spielerId, Map<String, Object?> inhalt) => raum.nachricht(spielerId, inhalt);
  @override
  void tick(double dt) => raum.tick(dt);
  @override
  Map<String, Object?> zustandFuer(String spielerId) => raum.zustandFuer(spielerId);
  @override
  List<Map<String, Object?>> ereignisseFuer(String spielerId) => raum.ereignisseFuer(spielerId);
  @override
  bool get beendet => raum.beendet;
}

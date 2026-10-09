import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:room_host/room_host.dart';

/// Auf Android, iOS und Desktop kann das Gerät einen Raum eröffnen (Server über `dart:io`).
const kannGastgeben = true;

/// Raum-Host im Gerät des Gastgebers: WebSocket unter `/raum`, bevorzugt Port 47100.
class Gastgeber {
  RaumHost? _host;

  /// Startet den Host, eröffnet einen Raum für [raum] und tritt als Teilnehmer `H` bei
  /// (als Erster, also Gastgeber und Detektiv). Liefert Code, Adressen „IP:Port“ und `H`.
  Future<(String, List<String>, String)> starte(BurgstadtRaum raum, String name) async {
    final h = RaumHost((_) => BurgstadtRaumSpiel(raum));
    int port;
    try {
      port = await h.starte(port: 47100);
    } catch (_) {
      port = await h.starte(); // Port belegt: freien nehmen
    }
    final code = h.erstelleRaum();
    const ich = 'H';
    raum
      ..beitreten(ich, name)
      ..verbunden(ich, true);
    _host = h;
    return (code, [for (final a in await RaumHost.lanAdressen()) '$a:$port'], ich);
  }

  Future<void> stoppe() async {
    await _host?.stoppe();
    _host = null;
  }
}

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

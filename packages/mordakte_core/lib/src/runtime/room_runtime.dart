import '../engine/engine.dart';
import '../protocol/commands.dart';
import '../protocol/events.dart';
import '../protocol/views.dart';
import '../scenario/scenario_def.dart';

/// Ein Spielraum. Server (pro Raumcode) und Offline-Solo benutzen exakt diese Klasse.
///
/// Ablauf pro Frame/Tick:
/// 1. Eingaben anwenden: [applyMove], [applyCommand]
/// 2. [tick] mit vergangener Zeit
/// 3. Pro Spieler [worldFor], [caseFor] (nur wenn geändert) und [drainEvents] senden
class RoomRuntime {
  final Engine _engine;

  RoomRuntime({
    required String roomCode,
    required Map<String, ScenarioDef> scenarios,
    int? clockSeed,
  }) : _engine = Engine(roomCode: roomCode, scenarios: scenarios, clockSeed: clockSeed);

  String get roomCode => _engine.roomCode;

  /// Spieler-IDs (ohne Bots).
  List<String> get humanPlayers => _engine.humanPlayerIds;

  bool get isEmpty => _engine.humanPlayerIds.isEmpty;

  bool get inLobby => _engine.inLobby;

  bool get finished => _engine.finished;

  /// Fügt einen Spieler hinzu (oder verbindet ihn neu). Gibt `false` zurück,
  /// wenn der Raum voll ist oder das Spiel läuft und der Spieler unbekannt ist.
  bool join(String playerId, String name) => _engine.join(playerId, name);

  /// Entfernt einen Spieler endgültig (Lobby) bzw. markiert ihn als getrennt (im Spiel).
  void leave(String playerId) => _engine.leave(playerId);

  /// Verbindungsstatus (Reconnect-Fenster).
  void setConnected(String playerId, bool connected) => _engine.setConnected(playerId, connected);

  /// Lässt einen menschlichen Spieler von der KI steuern (Autoplay, Simulation).
  void setAutopilot(String playerId, bool on) => _engine.setAutopilot(playerId, on);

  /// Nur für Werkzeuge: Zugriff auf die Engine (Wahrheit, Phase).
  Engine get debugEngine => _engine;

  void applyMove(String playerId, MoveInput move) => _engine.applyMove(playerId, move);

  void applyCommand(String playerId, Command command) => _engine.applyCommand(playerId, command);

  /// Simulation um [dtMs] weiterrechnen.
  void tick(int dtMs) => _engine.tick(dtMs);

  WorldSnapshot worldFor(String playerId) => _engine.worldFor(playerId);

  /// Fall-Ansicht, wenn sie sich für diesen Spieler seit dem letzten Abruf
  /// geändert hat (oder [force]); sonst `null`.
  CaseView? caseFor(String playerId, {bool force = false}) => _engine.caseFor(playerId, force: force);

  /// Ereignisse für diesen Spieler seit dem letzten Abruf.
  List<GameEvent> drainEvents(String playerId) => _engine.drainEvents(playerId);
}

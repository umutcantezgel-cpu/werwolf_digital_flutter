import '../protocol/commands.dart';
import '../protocol/events.dart';
import '../protocol/views.dart';
import '../scenario/scenario_def.dart';

/// Interne Spiel-Engine hinter [RoomRuntime]. (Wird gerade implementiert.)
class Engine {
  final String roomCode;
  final Map<String, ScenarioDef> scenarios;

  Engine({required this.roomCode, required this.scenarios, int? clockSeed});

  List<String> get humanPlayerIds => const [];
  bool get inLobby => true;
  bool get finished => false;

  bool join(String playerId, String name) => throw UnimplementedError();
  void leave(String playerId) => throw UnimplementedError();
  void setConnected(String playerId, bool connected) => throw UnimplementedError();
  void applyMove(String playerId, MoveInput move) => throw UnimplementedError();
  void applyCommand(String playerId, Command command) => throw UnimplementedError();
  void tick(int dtMs) => throw UnimplementedError();
  WorldSnapshot worldFor(String playerId) => throw UnimplementedError();
  CaseView? caseFor(String playerId, {bool force = false}) => throw UnimplementedError();
  List<GameEvent> drainEvents(String playerId) => throw UnimplementedError();
}

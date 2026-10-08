import 'package:mordakte_core/mordakte_core.dart';

import 'fake_session.dart';
import 'game_session.dart';

/// Konfiguration des Online-Servers: `--dart-define=MORDAKTE_SERVER=wss://…/ws`.
const defaultServerUrl = String.fromEnvironment('MORDAKTE_SERVER', defaultValue: 'ws://localhost:8080/ws');

/// Erzeugt Sessions. Die Lobby-Phase läuft in beiden Modi in der Session:
/// Solo → Lobby (KI-Partner, Klasse) → Start; Online → Raum erstellen/beitreten → Lobby → Start.
class SessionFactory {
  /// Offline-Solo: Runtime läuft im Prozess, der Spieler ist Host.
  static Future<GameSession> solo({
    required Map<String, ScenarioDef> scenarios,
    required String playerName,
  }) async {
    // Wird mit der Engine durch LocalSession ersetzt.
    return FakeSession();
  }

  /// Online: [roomCode] == null → neuen Raum erstellen.
  static Future<GameSession> online({
    required Map<String, ScenarioDef> scenarios,
    required String playerName,
    String? roomCode,
    String serverUrl = defaultServerUrl,
  }) async {
    throw UnimplementedError('OnlineSession folgt');
  }

  static GameSession fake() => FakeSession();
}

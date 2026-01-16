import 'package:werwolf_digital_flutter/services/network_service.dart';

class LobbyService {
  final NetworkService _networkService;

  LobbyService(this._networkService);

  /// Host creates a lobby.
  /// Returns the initial GameState (local) and emits the create event.
  /// Host creates a lobby.
  /// Emits 'create_room' event. The actual state creation happens when 'room_created' is received.
  void createLobby(String playerName, String playerId) {
    // Emit 'createRoom' event
    _networkService.emit(SocketEvents.createRoom, {
      'playerName': playerName,
      'playerId': playerId,
    });
  }

  /// Client joins a lobby.
  /// Emits 'join_room' event.
  void joinLobby(String playerName, String playerId, String roomCode) {
    final joinData = {
      'roomCode': roomCode,
      'playerName': playerName,
      'playerId': playerId,
    };
    _networkService.emit(SocketEvents.joinRoom, joinData);
  }
}

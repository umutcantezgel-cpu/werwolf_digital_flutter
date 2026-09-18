import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/foundation.dart';

// Check socket state
enum ServerConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

class SocketEvents {
  static const String connect = 'connect';
  static const String disconnect = 'disconnect';

  // Client -> Server
  static const String createRoom = 'create_room';
  static const String joinRoom = 'join_room';
  static const String gameAction = 'game_action'; // Relay to Host
  static const String stateUpdate = 'state_update'; // Host -> Server

  // Server -> Client
  static const String roomCreated = 'room_created';
  static const String playerJoined = 'player_joined';
  static const String gameStateUpdate = 'game_state_update';
  static const String error = 'error';
}

class NetworkService {
  late io.Socket _socket;
  final String _uri;

  // Stream controller for connection state
  final _connectionStateController =
      StreamController<ServerConnectionState>.broadcast();
  Stream<ServerConnectionState> get connectionState =>
      _connectionStateController.stream;

  // Callbacks
  Function(dynamic)? onConnect;
  Function(dynamic)? onDisconnect;
  Function(Map<String, dynamic>)? onGameStateUpdate;
  Function(Map<String, dynamic>)? onPlayerJoined;
  Function(Map<String, dynamic>)? onGameAction; // New: Received by Host
  Function(String)? onLobbyCreated;
  Function(String)? onError;

  NetworkService(this._uri) {
    _initSocket();
  }

  void _initSocket() {
    _connectionStateController.add(ServerConnectionState.connecting);

    _socket = io.io(
        _uri,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect() // Connect manually
            .setReconnectionDelay(1000)
            .setReconnectionAttempts(5)
            .build());

    _socket.onConnect((_) {
      debugPrint('✅ NetworkService: Connected to $_uri');
      _connectionStateController.add(ServerConnectionState.connected);
      onConnect?.call(_);
    });

    _socket.onDisconnect((_) {
      debugPrint('❌ NetworkService: Disconnected');
      _connectionStateController.add(ServerConnectionState.disconnected);
      onDisconnect?.call(_);
    });

    _socket.onReconnecting((_) {
      debugPrint('🔄 NetworkService: Reconnecting...');
      _connectionStateController.add(ServerConnectionState.reconnecting);
    });

    _socket.on(SocketEvents.gameStateUpdate, (data) {
      if (data is Map<String, dynamic>) {
        onGameStateUpdate?.call(data);
      }
    });

    _socket.on(SocketEvents.playerJoined, (data) {
      if (data is Map<String, dynamic>) {
        onPlayerJoined?.call(data);
      }
    });

    _socket.on(SocketEvents.gameAction, (data) {
      if (data is Map<String, dynamic>) {
        onGameAction?.call(data);
      }
    });

    _socket.on(SocketEvents.roomCreated, (data) {
      if (data is Map<String, dynamic> && data['roomCode'] != null) {
        onLobbyCreated?.call(data['roomCode']);
      }
    });

    _socket.on(SocketEvents.error, (data) {
      debugPrint('⚠️ NetworkService Error: $data');
      if (data is Map && data['message'] != null) {
        onError?.call(data['message']);
      }
      _connectionStateController.add(ServerConnectionState.error);
    });
  }

  void connect() {
    if (!_socket.connected) {
      _socket.connect();
    }
  }

  void disconnect() {
    _socket.disconnect();
  }

  void emit(String event, dynamic data) {
    if (_socket.connected) {
      _socket.emit(event, data);
    } else {
      debugPrint('⚠️ Cannot emit "$event": Socket disconnected');
    }
  }

  String? get id => _socket.id;

  void dispose() {
    _connectionStateController.close();
    _socket.dispose();
  }
}

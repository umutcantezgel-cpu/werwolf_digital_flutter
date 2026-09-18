import 'package:flutter/material.dart';
import 'package:werwolf_digital_flutter/config/app_config.dart';

import '../models/player.dart';
import '../models/game_state.dart';
import '../services/game_engine.dart';
import '../models/night_action.dart';
import '../services/network_service.dart'; // Import NetworkService
import '../services/lobby_service.dart';
import '../services/challenge_manager.dart'; // For Scenario
import '../models/role.dart' hide ActionType; // For RoleType
import '../services/voice_director.dart';
import '../services/haptic_manager.dart';
import '../services/bot_manager.dart';
import '../models/chat_message.dart';
import '../config/constants.dart'; // For GamePhase

class GameProvider extends ChangeNotifier {
  late GameState _gameState;
  final GameEngine _gameEngine = GameEngine();
  late NetworkService _networkService;
  late LobbyService _lobbyService;

  bool _isHost = false; // Flag to indicate if the current client is the host
  String? _myPlayerId; // Store the ID of the current player
  String? _myPlayerName; // Store the name of the current player

  GameState get gameState => _gameState;
  bool get isHost => _isHost;
  String? get myPlayerId => _myPlayerId;

  GameProvider({NetworkService? networkService}) {
    _gameState = GameState.initial();
    // Initialize NetworkService. In a real app, the URI would be dynamic.
    _networkService =
        networkService ?? NetworkService(AppConfig.serverUrl); // Dummy URI

    _networkService.onConnect = (_) {
      debugPrint('GameProvider: NetworkService connected.');
      // After connecting, if we were trying to join a lobby, emit join event
      // This logic might need refinement based on exact app flow
    };

    _networkService.onDisconnect = (_) {
      debugPrint('GameProvider: NetworkService disconnected.');
    };

    _networkService.onGameStateUpdate = (data) {
      debugPrint(
          'GameProvider: Received gameStateUpdate. Data keys: ${data.keys.toList()}');
      try {
        if (data.containsKey('state')) {
          _gameState = GameState.fromJson(data['state']);
        } else {
          _gameState = GameState.fromJson(data);
        }
        notifyListeners();
      } catch (e) {
        debugPrint('Error parsing game state: $e');
      }
    };

    _networkService.onPlayerJoined = (data) {
      // For host, this might trigger an update to all players
      debugPrint('Player ${data['name']} joined lobby ${data['roomCode']}');
    };

    _networkService.onLobbyCreated = (roomCode) {
      debugPrint('Lobby created with code: $roomCode');
      if (_isHost && _myPlayerId != null && _myPlayerName != null) {
        // Create the host player and add to the players list
        final hostPlayer = Player(
          id: _myPlayerId!,
          name: _myPlayerName!,
          isHost: true,
        );
        _gameState = _gameState.copyWith(
          roomCode: roomCode,
          players: [hostPlayer],
        );
        notifyListeners();
      }
    };

    _networkService.onGameAction = (data) {
      if (!_isHost) return;

      final roomCode = data['roomCode'];
      if (roomCode != _gameState.roomCode) return;

      final actionType = data['actionType'];
      final payload = data['data'];

      if (actionType == 'night_action') {
        _handleNightAction(payload);
      } else if (actionType == 'vote') {
        _handleVote(payload);
      }

      // Broadcast updated state
      _networkService.emit(SocketEvents.stateUpdate, {
        'roomCode': _gameState.roomCode,
        'state': _gameState.toJson(),
      });
      notifyListeners();
    };

    _networkService.connect(); // Connect to the socket server

    // Listen to connection state changes
    _networkService.connectionState.listen((state) {
      _connectionState = state;
      notifyListeners();
    });

    _lobbyService = LobbyService(_networkService);
  }

  // Connection State
  ServerConnectionState _connectionState = ServerConnectionState.disconnected;
  ServerConnectionState get connectionState => _connectionState;

  // ### Lobby Management ###
  void createLobby(String playerName, String playerId) {
    _isHost = true;
    _myPlayerId = playerId;
    _myPlayerName = playerName; // Store for later use
    // Ideally, we'd have a pending state or similar.
    // For now, we rely on the side-effects.

    // Emit create request
    _lobbyService.createLobby(playerName, playerId);

    // UI might need a loading state here.
    // But since we navigate only on success (which needs a callback or listener),
    // we should rely on the screen waiting for gameState.roomCode to be valid.
  }

  void joinLobby(String playerName, String playerId, String roomCode) {
    _isHost = false;
    _myPlayerId = playerId;
    _lobbyService.joinLobby(playerName, playerId, roomCode);
    // Optimistic: We'll receive playerJoined/gameStateUpdate from server.
  }

  // ### Solo Mode ###
  BotManager? _botManager;

  // Chat
  final List<ChatMessage> _chatHistory = [];
  List<ChatMessage> get chatHistory => List.unmodifiable(_chatHistory);

  void addMessage(ChatMessage msg) {
    _chatHistory.add(msg);
    notifyListeners();
  }

  bool _isSoloMode = false;

  bool get isSoloMode => _isSoloMode;
  BotManager? get botManager => _botManager;

  /// Start a solo game with AI bots
  Future<void> startSoloGame(SoloModeConfig config,
      {RoleType? fixedRole}) async {
    _isSoloMode = true;
    _isHost = true;
    _myPlayerId = 'player_${DateTime.now().millisecondsSinceEpoch}';
    _myPlayerName = 'Du';

    // Initialize bot manager
    _botManager = BotManager();
    _botManager!.initializeBots(config);

    // Create human player
    final humanPlayer = Player(
      id: _myPlayerId!,
      name: _myPlayerName!,
      isHost: true,
      role: fixedRole ??
          RoleType.unassigned, // Assign fixed role if provided, else unassigned
    );

    // Create game state with human + bots
    final allPlayers = [humanPlayer, ..._botManager!.toPlayers()];

    _gameState = GameState(
      roomCode: 'SOLO-${DateTime.now().millisecondsSinceEpoch % 10000}',
      players: allPlayers,
      gamePhase: GamePhase.lobby,
      round: 0,
    );

    notifyListeners();
  }

  /// Start a specific scenario
  Future<void> startScenario(Object scenarioObj) async {
    if (scenarioObj is Scenario) {
      await startSoloGame(scenarioObj.setupConfig,
          fixedRole: scenarioObj.fixedPlayerRole);
    }
  }

  /// Start the solo match from lobby (Assign roles + reveal)
  void startSoloMatch() {
    if (!_isSoloMode) return;

    // Assign roles
    _gameState = _gameEngine.assignRoles(_gameState);

    // Update bot manager with assigned roles
    // BotManager needs to know which exact role belongs to which bot ID
    for (final player in _gameState.players) {
      if (player.id != _myPlayerId) {
        // We need a method in BotManager to update specific bot role
        // For now, let's assume updateBotRole exists or we add it
        _botManager!.updateBotRole(player.id, player.role);
      }
    }

    // Advance to role reveal
    _gameState = _gameState.copyWith(gamePhase: GamePhase.roleReveal);

    // Audio trigger
    VoiceDirector().onPhaseStart('roleReveal', 0);

    notifyListeners();
  }

  // ### Game Flow ###
  void startGame() {
    if (!_isHost) return;
    _gameState = _gameEngine.assignRoles(_gameState);

    // Host sends State Update
    _networkService.emit(SocketEvents.stateUpdate, {
      'roomCode': _gameState.roomCode,
      'state': _gameState.toJson(),
    });
    notifyListeners();
  }

  void nextPhase() {
    if (!_isHost) return;
    _gameState = _gameEngine.nextPhase(_gameState);

    // Audio cue (local for host, but really should be triggered by state update on all clients)
    // We keep it here for responsiveness, but check duplicate on incoming state?
    // VoiceDirector handles "onPhaseStart" by comparing old/new state usually, but here is direct call.
    final round = _gameState.round;
    VoiceDirector().onPhaseStart(_gameState.gamePhase.name, round);
    HapticManager().impactMedium();

    // Broadcast update
    _networkService.emit(SocketEvents.stateUpdate, {
      'roomCode': _gameState.roomCode,
      'state': _gameState.toJson(),
    });
    notifyListeners();

    // Trigger Bot Processing if in Solo Mode
    if (_isSoloMode && _botManager != null) {
      _processBotPhase();
    }
  }

  /// Process bot actions for current phase
  Future<void> _processBotPhase() async {
    List<BotAction> actions = [];

    switch (_gameState.gamePhase) {
      case GamePhase.night:
        actions = await _botManager!.processNightPhase();
        break;
      case GamePhase.voting:
        // Pass null for open voting (everyone picks a target)
        actions = await _botManager!.processVoting(null);
        break;
      case GamePhase.day:
        // Generate discussions
        actions = await _botManager!.generateDiscussion(
          duration: const Duration(seconds: 30),
          maxMessagesPerBot: 2,
        );
        break;
      default:
        break;
    }

    if (actions.isNotEmpty) {
      _executeBotActions(actions);
    }
  }

  /// Execute bot actions with delays
  Future<void> _executeBotActions(List<BotAction> actions) async {
    // Sort by delay?? Actions might have inherent delays.
    // For now, simple iteration.
    for (final action in actions) {
      // Don't block entirely, maybe use future delayed but continue if parallel?
      // For sequential realism, we wait.
      if (action.delayMs > 0) {
        await Future.delayed(Duration(milliseconds: action.delayMs));
      }

      switch (action.type) {
        case BotActionType.nightAction:
          if (action.data is NightAction) {
            final nightAction = action.data as NightAction;
            // Directly handle action for immediate effect in state
            _handleNightAction({
              'playerId': nightAction.playerId,
              'roleActionType': nightAction.actionType.toString(),
              'targetId': nightAction.targetId
            });
            notifyListeners();
          }
          break;
        case BotActionType.vote:
          if (action.data is String) {
            final targetId = action.data as String;
            _handleVote({'playerId': action.botId, 'targetId': targetId});
            notifyListeners();
          }
          break;
        case BotActionType.speak:
          if (action.data is String) {
            final content = action.data as String;
            addMessage(ChatMessage(
              senderId: action.botId,
              senderName: action.botName,
              content: content,
              isBot: true,
              timestamp: DateTime.now(),
              senderRole: null, // Keep hidden unless revealed logic exists
            ));
          }
          break;
        default:
          break;
      }
    }

    // If Night Phase complete (all bots + human done), maybe auto-advance?
    // Implementation for auto-advance is complex, usually host presses button.
  }

  void _handleNightAction(Map<String, dynamic> data) {
    final playerId = data['playerId'];
    final roleActionTypeStr = data['roleActionType'];
    final targetId = data['targetId'];

    // Parse ActionType
    final roleActionType = ActionType.values.firstWhere(
        (e) => e.toString() == roleActionTypeStr,
        orElse: () => ActionType.kill); // Default fallback

    // Add to pending actions
    final newAction = NightAction(
      playerId: playerId,
      role: _gameState.players.firstWhere((p) => p.id == playerId).role,
      actionType: roleActionType,
      targetId: targetId,
      timestamp: DateTime.now(),
    );

    // Remove existing action for this player
    final updatedActions = List<NightAction>.from(_gameState.nightActions);
    updatedActions.removeWhere((a) => a.playerId == playerId);
    updatedActions.add(newAction);

    _gameState = _gameState.copyWith(nightActions: updatedActions);
  }

  void _handleVote(Map<String, dynamic> data) {
    final playerId = data['playerId'];
    final targetId = data['targetId'];

    final updatedVotes = Map<String, String>.from(_gameState.currentVotes);
    updatedVotes[playerId] = targetId;

    _gameState = _gameState.copyWith(currentVotes: updatedVotes);
  }

  void submitNightAction(ActionType type, String? targetId) {
    if (_myPlayerId == null) return;

    if (_isSoloMode) {
      // Direct handling
      _handleNightAction({
        'playerId': _myPlayerId,
        'roleActionType': type.toString(),
        'targetId': targetId
      });
      notifyListeners();
      return;
    }

    final actionPayload = {
      'roomCode': _gameState.roomCode,
      'actionType': 'night_action',
      'data': {
        'playerId': _myPlayerId,
        'roleActionType': type.toString(),
        'targetId': targetId,
      }
    };

    _networkService.emit(SocketEvents.gameAction, actionPayload);
  }

  void submitVote(String targetId) {
    if (_myPlayerId == null) return;

    if (_isSoloMode) {
      _handleVote({'playerId': _myPlayerId, 'targetId': targetId});
      notifyListeners();
      return;
    }

    final votePayload = {
      'roomCode': _gameState.roomCode,
      'actionType': 'vote',
      'data': {
        'playerId': _myPlayerId,
        'targetId': targetId,
      }
    };

    _networkService.emit(SocketEvents.gameAction, votePayload);
  }

  void resetGame() {
    _gameState = GameState.initial();
    _isHost = false;
    _myPlayerId = null;
    _isSoloMode = false;
    _botManager?.dispose();
    _botManager = null;

    // Potentially emit a reset event to the server
    if (!_isSoloMode) {
      _networkService.emit('resetGame', null);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _networkService.disconnect();
    _networkService.dispose();
    _botManager?.dispose();
    super.dispose();
  }
}

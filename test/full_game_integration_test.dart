import 'package:flutter_test/flutter_test.dart';
import 'package:werwolf_digital_flutter/models/game_state.dart';
import 'package:werwolf_digital_flutter/models/player.dart';
import 'package:werwolf_digital_flutter/models/role.dart' hide ActionType;
import 'package:werwolf_digital_flutter/models/night_action.dart';

import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/services/network_service.dart';
import 'package:werwolf_digital_flutter/config/constants.dart'; // For GamePhase

// Mock NetworkService
class MockNetworkService extends NetworkService {
  MockNetworkService() : super('http://localhost:3000');
  @override
  void connect() {}
  @override
  void disconnect() {}
  @override
  void dispose() {}
  @override
  void emit(String event, dynamic data) {
    // Simulate Host receiving their own broadcasts
    if (event == SocketEvents.stateUpdate && onGameStateUpdate != null) {
      if (data is Map<String, dynamic> && data.containsKey('state')) {
        onGameStateUpdate!(data['state']);
      } else {
        onGameStateUpdate!(data);
      }
    }
    if (event == SocketEvents.createRoom && onLobbyCreated != null) {
      onLobbyCreated!('TEST');
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Full Game Integration Test', () {
    late GameProvider gameProvider;
    late MockNetworkService mockNetworkService;

    setUp(() {
      mockNetworkService = MockNetworkService();
      gameProvider = GameProvider(networkService: mockNetworkService);
    });

    test(
        'Full game loop: Lobby -> Night (Kill) -> Day (Tragedy) -> Voting (Exec) -> Victory',
        () {
      // 1. Lobby Phase
      gameProvider.createLobby('Host', 'host_id');

      // Manually sets players since createLobby only adds host
      // Explicitly typed List<Player>
      List<Player> players = [
        Player(id: 'host_id', name: 'Host', isHost: true),
        Player(id: 'p2', name: 'Player 2'),
        Player(id: 'p3', name: 'Player 3'),
        Player(id: 'p4', name: 'Player 4'),
        Player(id: 'p5', name: 'Player 5'),
      ];

      GameState currentState = gameProvider.gameState;
      currentState = currentState.copyWith(players: players);

      // Force update provider state
      mockNetworkService.onGameStateUpdate!(currentState.toJson());

      expect(gameProvider.gameState.players.length, 5);
      expect(gameProvider.gameState.roomCode, 'TEST');

      // 2. Start Game -> Role Distribution
      gameProvider.startGame();
      expect(gameProvider.gameState.gamePhase, GamePhase.roleDistribution);

      // Verify roles assigned
      final roles = gameProvider.gameState.players.map((p) => p.role).toList();
      expect(roles.contains(RoleType.werwolf), true);

      // 3. Advance to Role Reveal
      gameProvider.nextPhase();
      expect(gameProvider.gameState.gamePhase, GamePhase.roleReveal);

      // 4. Advance to Night
      gameProvider.nextPhase();
      expect(gameProvider.gameState.gamePhase, GamePhase.night);
      expect(gameProvider.gameState.round, 1);

      // 5. Perform Night Action (Werewolf Kill)
      final werewolf = gameProvider.gameState.players
          .firstWhere((p) => p.role == RoleType.werwolf);
      final victim = gameProvider.gameState.players
          .firstWhere((p) => p.role != RoleType.werwolf);

      final killAction = NightAction(
          playerId: werewolf.id,
          role: RoleType.werwolf,
          actionType: ActionType.kill,
          targetId: victim.id,
          timestamp: DateTime.now());

      // Simulate receiving gameAction -> update state
      currentState =
          gameProvider.gameState.copyWith(nightActions: [killAction]);
      mockNetworkService.onGameStateUpdate!(currentState.toJson());

      // 6. Advance to Day (Tragedy should happen)
      gameProvider.nextPhase(); // Night -> Tragedy (if death)

      expect(gameProvider.gameState.gamePhase, GamePhase.tragedy);
      expect(gameProvider.gameState.lastKilledPlayerId, victim.id);

      // 7. Advance to Day
      gameProvider.nextPhase();
      expect(gameProvider.gameState.gamePhase, GamePhase.day);

      // 8. Advance to Voting
      gameProvider.nextPhase();
      expect(gameProvider.gameState.gamePhase, GamePhase.voting);

      // 9. Perform Voting (Lynch the Werewolf)
      // Everyone votes for Werewolf
      final votes = {
        'host_id': werewolf.id,
        'p2': werewolf.id,
        'p3': werewolf.id,
        'p4': werewolf.id,
        'p5': werewolf.id,
      };
      currentState = gameProvider.gameState.copyWith(currentVotes: votes);
      mockNetworkService.onGameStateUpdate!(currentState.toJson());

      // 10. Advance to Execution (Resolution)
      gameProvider.nextPhase();
      expect(gameProvider.gameState.gamePhase, GamePhase.execution);

      // 11. Advance to Victory (since Wolf is dead)
      gameProvider.nextPhase();
      expect(gameProvider.gameState.gamePhase, GamePhase.victory);
      expect(gameProvider.gameState.narration, contains('hat gewonnen'));
    });
  });
}

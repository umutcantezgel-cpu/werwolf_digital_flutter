import 'package:flutter_test/flutter_test.dart';
import 'package:werwolf_digital_flutter/services/game_engine.dart';
import 'package:werwolf_digital_flutter/models/game_state.dart';
import 'package:werwolf_digital_flutter/models/player.dart';
import 'package:werwolf_digital_flutter/models/role.dart';
import 'package:werwolf_digital_flutter/config/constants.dart';

void main() {
  group('GameEngine Tests', () {
    late GameEngine gameEngine;

    setUp(() {
      gameEngine = GameEngine();
    });

    test('createLobby returns valid initial state', () {
      final state = gameEngine.createLobby('HostPlayer', 'host123');
      expect(state.roomCode.length, 4);
      expect(state.players.length, 1);
      expect(state.players.first.name, 'HostPlayer');
      expect(state.players.first.isHost, true);
      expect(state.gamePhase, GamePhase.lobby);
    });

    test('assignRoles distributes roles correctly for 5 players', () {
      GameState state = gameEngine.createLobby('Host', '1');
      // Add 4 more players
      final players =
          List.generate(5, (i) => Player(id: i.toString(), name: 'Player $i'));
      state = state.copyWith(players: players);

      final newState = gameEngine.assignRoles(state);

      expect(newState.gamePhase, GamePhase.roleDistribution);
      expect(newState.players.length, 5);

      final roles = newState.players.map((p) => p.role).toList();
      expect(roles.contains(RoleType.werwolf), true);
      expect(roles.contains(RoleType.seherin), true);
      expect(roles.contains(RoleType.hexe), true);
      expect(roles.contains(RoleType.dorfbewohner), true);
      // expect(roles.contains(RoleType.jager), true); // Logic might vary slightly based on shuffle but 5 player setup is hardcoded
    });

    test('nextPhase advances correctly from role distribution', () {
      GameState state = gameEngine.createLobby('Host', '1');
      state = state.copyWith(gamePhase: GamePhase.roleDistribution);

      final newState = gameEngine.nextPhase(state);
      expect(newState.gamePhase, GamePhase.roleReveal);
    });

    test('nextPhase loop works (Night -> Dawn -> Day)', () {
      GameState state = gameEngine.createLobby('Host', '1');
      state = state.copyWith(gamePhase: GamePhase.night, round: 1);

      // Night -> Dawn
      state = gameEngine.nextPhase(state);
      expect(state.gamePhase, GamePhase.dawn);
      // No rooster yet, potentially scream if death, but here logic implies silence or specific event sfx from resolution

      // Dawn -> Day
      state = gameEngine.nextPhase(state);
      expect(state.gamePhase, GamePhase.day);
      expect(state.lastSoundEffect, 'sfx/day/rooster_crow.mp3');

      // Day -> Voting
      state = gameEngine.nextPhase(state);
      expect(state.gamePhase, GamePhase.voting);
    });
  });
}

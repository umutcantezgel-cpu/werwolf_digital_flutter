import 'dart:math';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/role.dart' hide ActionType;
import '../config/constants.dart';
import '../models/night_action.dart';
import 'narrative_service.dart';

class GameEngine {
  final NarrativeService _narrativeService = NarrativeService();

  /// Creates a new lobby and returns the initial GameState.
  GameState createLobby(String hostPlayerName, String hostPlayerId) {
    final host = Player(id: hostPlayerId, name: hostPlayerName, isHost: true);
    final roomCode = _generateRoomCode();
    return GameState(
      roomCode: roomCode,
      players: [host],
      gamePhase: GamePhase.lobby,
      narration: 'Warte auf weitere Spieler...',
    );
  }

  /// Assigns roles to players based on the number of players.
  /// Respects pre-assigned roles (e.g. for Scenarios).
  GameState assignRoles(GameState currentState) {
    var players = List<Player>.from(currentState.players);
    final rolePool = <RoleType>[];

    // Separate players with fixed roles from those needing assignment
    final fixedPlayers =
        players.where((p) => p.role != RoleType.unassigned).toList();
    final playersToAssign =
        players.where((p) => p.role == RoleType.unassigned).toList();

    // Calculate remaining slots
    // Total desired counts minus what is already taken by fixed players
    int wolfCount = max(1, players.length ~/ 4);
    int seerCount = players.length >= 3 ? 1 : 0;
    int witchCount = players.length >= 4 ? 1 : 0;
    int hunterCount = players.length >= 6 ? 1 : 0;
    int cupidCount = players.length >= 8 ? 1 : 0;
    int bodyguardCount = players.length >= 10 ? 1 : 0;

    // Adjust counts based on fixed roles
    for (final p in fixedPlayers) {
      if (p.role == RoleType.werwolf) wolfCount--;
      if (p.role == RoleType.seherin) seerCount--;
      if (p.role == RoleType.hexe) witchCount--;
      if (p.role == RoleType.jager) hunterCount--;
      if (p.role == RoleType.amor) cupidCount--;
      if (p.role == RoleType.leibwachter) bodyguardCount--;
    }

    // Ensure we don't have negative counts (if scenario forces extra roles)
    wolfCount = max(0, wolfCount);
    seerCount = max(0, seerCount);
    witchCount = max(0, witchCount);
    hunterCount = max(0, hunterCount);
    cupidCount = max(0, cupidCount);
    bodyguardCount = max(0, bodyguardCount);

    // Fill pool for remaining players
    rolePool.addAll(List.filled(wolfCount, RoleType.werwolf));
    if (seerCount > 0) rolePool.add(RoleType.seherin);
    if (witchCount > 0) rolePool.add(RoleType.hexe);
    if (hunterCount > 0) rolePool.add(RoleType.jager);
    if (cupidCount > 0) rolePool.add(RoleType.amor);
    if (bodyguardCount > 0) rolePool.add(RoleType.leibwachter);

    // Fill remaining with Villagers
    while (rolePool.length < playersToAssign.length) {
      rolePool.add(RoleType.dorfbewohner);
    }

    // Shuffle and Assign to unassigned players
    rolePool.shuffle();
    for (int i = 0; i < playersToAssign.length; i++) {
      // Find the index of this player in the main list to update it
      final originalIndex =
          players.indexWhere((p) => p.id == playersToAssign[i].id);
      if (originalIndex != -1) {
        players[originalIndex] =
            players[originalIndex].copyWith(role: rolePool[i]);
      }
    }

    return currentState.copyWith(
      players: players,
      gamePhase: GamePhase.roleDistribution,
      narration: 'Rollen wurden verteilt. Schaut auf eure Karten...',
    );
  }

  /// Advances the game to the next phase.
  GameState nextPhase(GameState currentState) {
    GamePhase nextGamePhase = currentState.gamePhase;
    String narration = '';
    List<Player> updatedPlayers = List.from(currentState.players);
    int currentRound = currentState.round;
    List<NightAction> currentActions = List.from(currentState.nightActions);
    Map<String, dynamic> currentRoleData = Map.from(currentState.roleData);
    String? sfx;

    switch (currentState.gamePhase) {
      case GamePhase.lobby:
        nextGamePhase = GamePhase.roleDistribution;
        break;
      case GamePhase.roleDistribution:
        nextGamePhase = GamePhase.roleReveal;
        break;
      case GamePhase.roleReveal:
        nextGamePhase = GamePhase.night;
        currentRound = 1;
        break;
      case GamePhase.night:
        final resolution = _resolveNightActions(
            updatedPlayers, currentActions, currentRoleData);
        updatedPlayers = resolution.updatedPlayers;
        currentRoleData = resolution.updatedRoleData;
        narration = resolution.narration;
        sfx = resolution.sfx;
        currentActions.clear();

        // If someone died, go to Tragedy phase
        if (resolution.lastKilledPlayerId != null) {
          nextGamePhase = GamePhase.tragedy;
        } else {
          // No death -> Dawn (Rooster)
          nextGamePhase = GamePhase.dawn;
          sfx = 'sfx/day/rooster_crow.mp3'; // Explicit rooster
        }
        break;
      case GamePhase.tragedy:
        // After tragedy animation, go to day
        nextGamePhase = GamePhase.day;
        break;
      case GamePhase.dawn:
        nextGamePhase = GamePhase.day;
        sfx = 'sfx/day/rooster_crow.mp3';
        break;
      case GamePhase.day:
        nextGamePhase = GamePhase.voting;
        break;
      case GamePhase.voting:
        final resolution =
            _resolveVoting(updatedPlayers, currentState.currentVotes);
        updatedPlayers = resolution.updatedPlayers;
        narration = resolution.narration;
        sfx = resolution.sfx;
        nextGamePhase = GamePhase.execution;
        break;
      case GamePhase.execution:
        final winner = _checkWinConditions(updatedPlayers);
        if (winner != null) {
          nextGamePhase = GamePhase.victory; // Use Victory phase
          narration =
              '${winner == Team.dorf ? "Das Dorf" : "Die Werwölfe"} hat gewonnen!';
          sfx = 'sfx/win/victory_fanfare.mp3';
        } else {
          nextGamePhase = GamePhase.night;
          currentRound++;
          sfx = 'sfx/ambience/night_start.mp3';
        }
        break;
      default:
        break;
    }

    return currentState.copyWith(
      gamePhase: nextGamePhase,
      players: updatedPlayers,
      round: currentRound,
      narration: narration.isNotEmpty
          ? narration
          : _narrativeService.generateNarration(
              currentState.copyWith(gamePhase: nextGamePhase)),
      nightActions: currentActions,
      roleData: currentRoleData,
      lastSoundEffect: sfx,
      pendingActionPlayerIds: [],
      // Ensure we pass the victim ID if available so TragedyScreen can use it
      lastKilledPlayerId: (currentState.gamePhase == GamePhase.night &&
              nextGamePhase == GamePhase.tragedy)
          ? (_resolveNightActions(
                  List.from(currentState.players),
                  List.from(currentState.nightActions),
                  Map.from(currentState.roleData)))
              .lastKilledPlayerId // Re-calculating is bad, let's optimize
          : null,
    );
  }

  // Optimize: We shouldn't re-calculate resolveNightActions in the return.
  // We need to capture the resolution result earlier.
  // Actually, I can't easily capture it in the switch case and use it in return without changing structure significantly.
  // But wait, `nextPhase` returns `currentState.copyWith`.
  // I should update `lock` variables.

  _ResolutionResult _resolveNightActions(List<Player> players,
      List<NightAction> actions, Map<String, dynamic> roleData) {
    List<Player> tempPlayers = List.from(players);
    String narration = 'Die Nacht ist vorbei. ';
    List<String> deadNames = [];
    String? sfx;
    String? lastKilledPlayerId;

    // --- 1. Resolve Werewolf Kill ---
    // Count votes for each target
    final wolfVotes =
        actions.where((a) => a.actionType == ActionType.kill).toList();
    String? wolfTargetId;

    if (wolfVotes.isNotEmpty) {
      final voteCounts = <String, int>{};
      for (final vote in wolfVotes) {
        if (vote.targetId != null) {
          voteCounts[vote.targetId!] = (voteCounts[vote.targetId!] ?? 0) + 1;
        }
      }

      // Find target with max votes
      if (voteCounts.isNotEmpty) {
        // Sort by votes descending
        final sortedVotes = voteCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        // MVP: Take top vote. Coin toss on tie not implemented yet.
        wolfTargetId = sortedVotes.first.key;
      }
    }

    // --- 2. Resolve Witch Actions ---
    String? protectedId; // Id protected by Witch or Bodyguard

    // Witch Heal
    final witchHeal = actions.firstWhere((a) => a.actionType == ActionType.heal,
        orElse: () => NightAction(
            playerId: '',
            role: RoleType.unassigned,
            actionType: ActionType.none,
            timestamp: DateTime.now()));

    bool witchUsedHeal = roleData['witchHealUsed'] == true;

    if (!witchUsedHeal &&
        witchHeal.actionType == ActionType.heal &&
        witchHeal.targetId == wolfTargetId) {
      // Healed!
      protectedId = wolfTargetId;
      roleData['witchHealUsed'] = true;
    }

    // Witch Poison
    final witchPoison = actions.firstWhere(
        (a) => a.actionType == ActionType.poison,
        orElse: () => NightAction(
            playerId: '',
            role: RoleType.unassigned,
            actionType: ActionType.none,
            timestamp: DateTime.now()));

    bool witchUsedPoison = roleData['witchPoisonUsed'] == true;
    String? poisonTargetId;

    if (!witchUsedPoison &&
        witchPoison.actionType == ActionType.poison &&
        witchPoison.targetId != null) {
      poisonTargetId = witchPoison.targetId;
      roleData['witchPoisonUsed'] = true;
    }

    // --- 3. Bodyguard Protection (Leibwachter) ---
    final bodyguardProtect = actions.firstWhere(
        (a) => a.actionType == ActionType.protect,
        orElse: () => NightAction(
            playerId: '',
            role: RoleType.unassigned,
            actionType: ActionType.none,
            timestamp: DateTime.now()));
    if (bodyguardProtect.targetId != null) {
      // If bodyguard protects the wolf target, they are saved
      if (bodyguardProtect.targetId == wolfTargetId) {
        protectedId = wolfTargetId;
      }
    }

    // --- 4. Apply Deaths ---

    // Wolf Victim
    if (wolfTargetId != null && wolfTargetId != protectedId) {
      final idx = tempPlayers.indexWhere((p) => p.id == wolfTargetId);
      if (idx != -1) {
        tempPlayers[idx] = tempPlayers[idx].copyWith(isAlive: false);
        deadNames.add(tempPlayers[idx].name);
      }
    }

    // Poison Victim
    if (poisonTargetId != null) {
      final idx = tempPlayers.indexWhere((p) => p.id == poisonTargetId);
      if (idx != -1) {
        // Prevent double death if same person
        if (tempPlayers[idx].isAlive) {
          tempPlayers[idx] = tempPlayers[idx].copyWith(isAlive: false);
          deadNames.add(tempPlayers[idx].name);
        }
      }
    }

    // --- 5. Generate Narration ---
    if (deadNames.isEmpty) {
      narration += 'Niemand ist gestorben. Ein wahres Wunder!';
      sfx = 'sfx/day/no_death.mp3';
    } else {
      narration += '${deadNames.join(", ")} ist von uns gegangen.';
      sfx = 'sfx/day/death_announce.mp3';
    }

    // Find the ID of the killed player (priority to wolf target for now)
    // Note: If multiple die, we might need a list. For TragedyScreen, just taking one is okay for MVP.
    if (wolfTargetId != null && wolfTargetId != protectedId) {
      lastKilledPlayerId = wolfTargetId;
    } else if (poisonTargetId != null) {
      lastKilledPlayerId = poisonTargetId;
    }

    return _ResolutionResult(tempPlayers, roleData, narration, sfx,
        lastKilledPlayerId: lastKilledPlayerId);
  }

  _ResolutionResult _resolveVoting(
      List<Player> players, Map<String, String> votes) {
    List<Player> tempPlayers = List.from(players);

    if (votes.isEmpty) {
      return _ResolutionResult(tempPlayers, {},
          'Niemand wurde gewählt. Das Dorf ist unentschlossen.', null);
    }

    final voteCounts = <String, int>{};
    for (final targetId in votes.values) {
      voteCounts[targetId] = (voteCounts[targetId] ?? 0) + 1;
    }

    // Sort to find max
    final sortedVotes = voteCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topVote = sortedVotes.first;

    // Check for tie
    bool isTie = false;
    if (sortedVotes.length > 1) {
      if (sortedVotes[1].value == topVote.value) {
        isTie = true;
      }
    }

    if (isTie) {
      return _ResolutionResult(
          tempPlayers, {}, 'Unentschieden! Niemand stirbt.', null);
    }

    final victimId = topVote.key;
    final victimIndex = tempPlayers.indexWhere((p) => p.id == victimId);

    if (victimIndex != -1) {
      final victim = tempPlayers[victimIndex];
      tempPlayers[victimIndex] = victim.copyWith(isAlive: false);
      return _ResolutionResult(tempPlayers, {},
          '${victim.name} wurde hingerichtet.', 'sfx/day/guillotine.mp3');
    }

    return _ResolutionResult(
        tempPlayers, {}, 'Niemand wurde hingerichtet.', null);
  }

  Team? _checkWinConditions(List<Player> players) {
    final alivePlayers = players.where((p) => p.isAlive).toList();
    final aliveWerewolves =
        alivePlayers.where((p) => p.role == RoleType.werwolf).length;
    final aliveVillagers =
        alivePlayers.length - aliveWerewolves; // Includes seer, witch, hunter

    if (aliveWerewolves == 0 && aliveVillagers > 0) {
      return Team.dorf; // All werewolves are dead, and villagers remain
    }

    if (aliveWerewolves >= aliveVillagers && aliveWerewolves > 0) {
      return Team.werwolf; // Werewolves equal or outnumber villagers
    }

    if (aliveVillagers == 0 && aliveWerewolves > 0) {
      return Team.werwolf; // All villagers are dead, werewolves remain
    }

    return null; // No win condition met yet
  }

  String _generateRoomCode({int length = 4}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  /// Registers a night action from a player.
  GameState processNightAction(GameState currentState, NightAction action) {
    final currentActions = List<NightAction>.from(currentState.nightActions);
    // Remove existing action from this player if any (allow changing mind)
    currentActions.removeWhere((a) => a.playerId == action.playerId);
    currentActions.add(action);
    return currentState.copyWith(nightActions: currentActions);
  }
}

class _ResolutionResult {
  final List<Player> updatedPlayers;
  final Map<String, dynamic> updatedRoleData;
  final String narration;
  final String? sfx;
  final String? lastKilledPlayerId;

  _ResolutionResult(
      this.updatedPlayers, this.updatedRoleData, this.narration, this.sfx,
      {this.lastKilledPlayerId});
}

/// Bot Manager
///
/// Manages the lifecycle and coordination of all AI bots in Solo Mode.
/// Handles bot creation, role assignment, and action processing.

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:werwolf_digital_flutter/models/bot_player.dart';
import 'package:werwolf_digital_flutter/models/bot_personality.dart';
import 'package:werwolf_digital_flutter/models/bot_knowledge.dart';
import 'package:werwolf_digital_flutter/models/game_state.dart';
import 'package:werwolf_digital_flutter/models/player.dart';
import 'package:werwolf_digital_flutter/models/role.dart' hide ActionType;
import 'package:werwolf_digital_flutter/models/night_action.dart';
import 'package:werwolf_digital_flutter/services/bot_decision_engine.dart';
import 'package:werwolf_digital_flutter/services/bot_dialogue_system.dart';

/// Configuration for Solo Mode
class SoloModeConfig {
  final int totalPlayers;
  final int humanPlayers;
  final DifficultyLevel difficulty;
  final bool showBotThoughts;
  final bool disableTimeLimits;

  const SoloModeConfig({
    required this.totalPlayers,
    required this.humanPlayers,
    required this.difficulty,
    this.showBotThoughts = false,
    this.disableTimeLimits = false,
  });

  int get botCount => totalPlayers - humanPlayers;
}

/// A bot action that can be executed
class BotAction {
  final String botId;
  final String botName;
  final BotActionType type;
  final dynamic data;
  final int delayMs;

  const BotAction({
    required this.botId,
    required this.botName,
    required this.type,
    required this.data,
    this.delayMs = 0,
  });
}

enum BotActionType {
  speak,
  vote,
  nominate,
  nightAction,
  reaction,
}

/// Manages all bots in a Solo Mode game
class BotManager extends ChangeNotifier {
  final Map<String, BotPlayer> _bots = {};
  final BotDialogueSystem _dialogueSystem = BotDialogueSystem();
  final Random _random = Random();

  SoloModeConfig? _config;
  GameState? _gameState;

  /// Get current configuration
  SoloModeConfig? get config => _config;

  /// Get all bots
  List<BotPlayer> get bots => _bots.values.toList();

  /// Get alive bots
  List<BotPlayer> get aliveBots =>
      _bots.values.where((b) => b.isAlive).toList();

  /// Get wolf bots
  List<BotPlayer> get wolfBots => _bots.values.where((b) => b.isWolf).toList();

  /// Initialize bots for a new game
  void initializeBots(SoloModeConfig config) {
    _config = config;
    _bots.clear();
    _dialogueSystem.reset();

    final personalities =
        BotNameGenerator.distributePersonalities(config.botCount);
    final usedNames = <String>[];

    for (int i = 0; i < config.botCount; i++) {
      final personality = personalities[i];
      final name = BotNameGenerator.generateName(personality, usedNames);
      usedNames.add(name);

      final bot = BotPlayer(
        id: 'bot_${i}_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        personality: personality,
        difficulty: config.difficulty,
      );

      _bots[bot.id] = bot;
    }

    debugPrint('BotManager: Initialized ${_bots.length} bots');
    notifyListeners();
  }

  /// Assign roles to bots
  void assignRoles(List<RoleType> botRoles) {
    int index = 0;
    for (final bot in _bots.values) {
      if (index < botRoles.length) {
        bot.role = botRoles[index++];
        debugPrint('BotManager: ${bot.name} assigned ${bot.role}');
      }
    }

    // Initialize wolf knowledge (wolves see each other)
    final wolfIds =
        _bots.values.where((b) => b.isWolf).map((b) => b.id).toList();
    for (final bot in _bots.values.where((b) => b.isWolf)) {
      bot.initializeAsWolf(wolfIds);
    }

    notifyListeners();
  }

  /// Update a specific bot's role
  void updateBotRole(String botId, RoleType role) {
    if (_bots.containsKey(botId)) {
      _bots[botId]!.role = role;
      debugPrint('BotManager: Updated role for ${_bots[botId]!.name} to $role');
    }
  }

  /// Update game state for bot decision making
  void updateGameState(GameState state) {
    _gameState = state;

    // Update bot alive status
    for (final bot in _bots.values) {
      final playerState = state.players.firstWhere(
        (p) => p.id == bot.id,
        orElse: () => Player(id: '', name: ''),
      );
      bot.isAlive = playerState.id.isNotEmpty && playerState.isAlive;
    }
  }

  /// Process bot actions for night phase
  Future<List<BotAction>> processNightPhase() async {
    if (_gameState == null) return [];

    final actions = <BotAction>[];
    final alivePlayers = _gameState!.players.where((p) => p.isAlive).toList();

    // Sort bots by night priority
    final sortedBots = aliveBots.toList()
      ..sort((a, b) => a.nightPriority.compareTo(b.nightPriority));

    for (final bot in sortedBots) {
      if (!bot.hasNightAction) continue;

      final action = await _processNightAction(bot, alivePlayers);
      if (action != null) {
        actions.add(action);
      }

      // Simulate thinking time
      await Future.delayed(Duration(milliseconds: _random.nextInt(1000) + 500));
    }

    return actions;
  }

  Future<BotAction?> _processNightAction(
      BotPlayer bot, List<Player> alivePlayers) async {
    NightActionDecision? decision;

    switch (bot.role) {
      case RoleType.werwolf:
      case RoleType.urwolf:
      case RoleType.grosserBoserWolf:
        decision = BotDecisionEngine.decideWolfKill(
          bot: bot,
          gameState: _gameState!,
          alivePlayers: alivePlayers,
        );
        break;

      case RoleType.seherin:
        decision = BotDecisionEngine.decideSeerCheck(
          bot: bot,
          gameState: _gameState!,
          alivePlayers: alivePlayers,
        );
        break;

      case RoleType.leibwachter:
        decision = BotDecisionEngine.decideBodyguardProtect(
          bot: bot,
          gameState: _gameState!,
          alivePlayers: alivePlayers,
          lastProtectedId: null, // TODO: Track this
        );
        break;

      case RoleType.hexe:
        // TODO: Get wolf victim from game state
        decision = BotDecisionEngine.decideWitchAction(
          bot: bot,
          gameState: _gameState!,
          wolfVictimId: null,
          hasHealPotion: true,
          hasKillPotion: true,
        );
        break;

      default:
        return null;
    }

    if (decision.targetId == null && decision.actionType != ActionType.none) {
      return null;
    }

    return BotAction(
      botId: bot.id,
      botName: bot.name,
      type: BotActionType.nightAction,
      data: NightAction(
        playerId: bot.id,
        role: bot.role!,
        actionType: decision.actionType,
        targetId: decision.targetId,
        timestamp: DateTime.now(),
      ),
      delayMs: bot.difficultyConfig.reactionDelay.inMilliseconds,
    );
  }

  /// Process bot voting
  Future<List<BotAction>> processVoting(String? nominatedPlayerId) async {
    if (_gameState == null) return [];

    final actions = <BotAction>[];
    final alivePlayers = _gameState!.players.where((p) => p.isAlive).toList();

    for (final bot in aliveBots) {
      final decision = BotDecisionEngine.decideVoteTarget(
        bot: bot,
        gameState: _gameState!,
        alivePlayers: alivePlayers,
      );

      // Apply difficulty mistake logic
      // TODO: Implement mistake logic for target voting if needed

      if (decision.targetId != null) {
        actions.add(BotAction(
          botId: bot.id,
          botName: bot.name,
          type: BotActionType.vote,
          data: decision.targetId,
          delayMs: bot.difficultyConfig.reactionDelay.inMilliseconds +
              _random.nextInt(2000),
        ));
      } else {
        // Abstain / No vote (optional: could vote for themselves or skip)
      }
    }

    // Sort by delay for realistic staggered voting
    actions.sort((a, b) => a.delayMs.compareTo(b.delayMs));

    return actions;
  }

  /// Generate discussion messages
  Future<List<BotAction>> generateDiscussion({
    required Duration duration,
    required int maxMessagesPerBot,
  }) async {
    if (_gameState == null) return [];

    final actions = <BotAction>[];
    final alivePlayers = _gameState!.players.where((p) => p.isAlive).toList();

    // Each bot may speak based on personality
    for (final bot in aliveBots) {
      // Leadership determines how early they speak
      final speakProbability = bot.behavior.leadership / 100.0;

      if (_random.nextDouble() > speakProbability * 0.7) continue;

      final mostSuspicious = bot.knowledge.getMostSuspicious([bot.id]);

      if (mostSuspicious != null &&
          _random.nextDouble() < (bot.behavior.aggressiveness / 100.0)) {
        final targetPlayer = alivePlayers.firstWhere(
          (p) => p.id == mostSuspicious,
          orElse: () => Player(id: '', name: 'Unbekannt'),
        );

        final dialogue = _dialogueSystem.generateAccusation(
          bot: bot,
          targetName: targetPlayer.name,
          reason: 'verdächtiges Verhalten',
        );

        actions.add(BotAction(
          botId: bot.id,
          botName: bot.name,
          type: BotActionType.speak,
          data: dialogue.message,
          delayMs: dialogue.delayMs,
        ));
      }
    }

    return actions;
  }

  /// Record a death and update bot knowledge
  void recordDeath(
      String playerId, String playerName, RoleType? role, String cause) {
    for (final bot in _bots.values) {
      bot.knowledge.recordDeath(DeathRecord(
        round: _gameState?.round ?? 1,
        playerId: playerId,
        playerName: playerName,
        role: role,
        cause: cause,
      ));
    }
  }

  /// Get a bot by ID
  BotPlayer? getBot(String botId) => _bots[botId];

  /// Convert bots to Player objects for game state
  List<Player> toPlayers() {
    return _bots.values
        .map((bot) => Player(
              id: bot.id,
              name: bot.name,
              isAlive: bot.isAlive,
              isHost: false,
            ))
        .toList();
  }

  /// Dispose resources
  @override
  void dispose() {
    _bots.clear();
    super.dispose();
  }
}

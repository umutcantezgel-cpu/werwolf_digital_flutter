/// Bot Decision Engine
///
/// The AI brain that decides what actions bots take based on
/// their role, personality, knowledge, and the current game state.

import 'dart:math';
import 'package:werwolf_digital_flutter/models/bot_player.dart';
import 'package:werwolf_digital_flutter/models/role.dart' hide ActionType;
import 'package:werwolf_digital_flutter/models/game_state.dart';
import 'package:werwolf_digital_flutter/models/player.dart';
import 'package:werwolf_digital_flutter/models/night_action.dart';

/// Result of a bot's vote decision
class VoteDecision {
  final bool voteYes;
  final String reason;
  final int confidence; // 0-100

  const VoteDecision({
    required this.voteYes,
    required this.reason,
    required this.confidence,
  });
}

/// Result of a bot's night action decision
class NightActionDecision {
  final String? targetId;
  final ActionType actionType;
  final String reason;

  const NightActionDecision({
    this.targetId,
    required this.actionType,
    required this.reason,
  });
}

/// The decision engine for bot AI
class BotDecisionEngine {
  static final Random _random = Random();

  /// Evaluate suspicion levels for all players
  static Map<String, int> evaluateSuspicions({
    required BotPlayer bot,
    required GameState gameState,
    required List<Player> alivePlayers,
  }) {
    final suspicions = <String, int>{};

    for (final player in alivePlayers) {
      if (player.id == bot.id) continue; // Skip self
      if (bot.knowledge.knownVillagerIds.contains(player.id)) continue;

      int suspicion = bot.knowledge.getSuspicion(player.id).suspicionLevel;

      // Analyze voting history
      for (final vote in bot.knowledge.votingHistory) {
        if (vote.voterId != player.id) continue;

        // Voted against confirmed villager?
        if (bot.knowledge.knownVillagerIds.contains(vote.targetId) &&
            vote.votedYes) {
          suspicion += 20;
        }

        // Defended a confirmed wolf?
        if (bot.knowledge.knownWolfIds.contains(vote.targetId) &&
            !vote.votedYes) {
          suspicion += 30;
        }
      }

      // Quiet players are slightly suspicious
      // TODO: Track speech frequency

      suspicions[player.id] = suspicion.clamp(0, 100);
    }

    return suspicions;
  }

  /// Decide who to vote for (target-based voting)
  static NightActionDecision decideVoteTarget({
    required BotPlayer bot,
    required GameState gameState,
    required List<Player> alivePlayers,
  }) {
    // 1. If Wolf: Coordinate attacks
    if (bot.isWolf) {
      // Find a non-wolf target
      final candidates = alivePlayers
          .where((p) =>
              !bot.knowledge.knownWolfIds.contains(p.id) && p.id != bot.id)
          .toList();

      if (candidates.isNotEmpty) {
        // Simple strategy: Vote for the most suspicious village leader or random
        // TODO: Coordinate with other wolves (hive mind)
        final target = candidates[_random.nextInt(candidates.length)];
        return NightActionDecision(
          targetId: target.id,
          actionType: ActionType.none, // Just a placeholder for vote
          reason: 'Wolf-Strategie: Verdacht lenken',
        );
      }
    }

    // 2. Calculate suspicions for all alive players
    final suspicions = evaluateSuspicions(
      bot: bot,
      gameState: gameState,
      alivePlayers: alivePlayers,
    );

    if (suspicions.isEmpty) {
      return const NightActionDecision(
        targetId: null, // Abstain
        actionType: ActionType.none,
        reason: 'Keine Verdächtigen',
      );
    }

    // 3. Find most suspicious
    final sortedSuspects = suspicions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topSuspect = sortedSuspects.first;

    // Threshold check (Personality based)
    final threshold = 40 + (bot.behavior.logic - 50) * 0.2;

    if (topSuspect.value > threshold) {
      return NightActionDecision(
        targetId: topSuspect.key,
        actionType: ActionType.none,
        reason: 'Höchster Verdacht: ${topSuspect.value}%',
      );
    }

    // 4. If no strong suspicion, maybe follow a leader (highest trust)
    // TODO: Implement leader following logic

    return const NightActionDecision(
      targetId: null, // Abstain
      actionType: ActionType.none,
      reason: 'Unsicher',
    );
  }

  /// Decide night action for wolf
  static NightActionDecision decideWolfKill({
    required BotPlayer bot,
    required GameState gameState,
    required List<Player> alivePlayers,
  }) {
    final candidates = alivePlayers
        .where(
            (p) => !bot.knowledge.knownWolfIds.contains(p.id) && p.id != bot.id)
        .toList();

    if (candidates.isEmpty) {
      return const NightActionDecision(
        targetId: null,
        actionType: ActionType.kill,
        reason: 'Keine Opfer verfügbar',
      );
    }

    // Score each candidate
    final scores = <String, int>{};

    for (final candidate in candidates) {
      int threatScore = 0;

      // Check for known dangerous roles
      final confirmedRole = bot.knowledge.confirmedRoles[candidate.id];
      if (confirmedRole == RoleType.seherin) threatScore = 100;
      if (confirmedRole == RoleType.hexe) threatScore = 90;

      // Check claimed roles
      final claimedRole = bot.knowledge.claimedRoles[candidate.id];
      if (claimedRole == RoleType.seherin) threatScore += 50;

      // Player who accused wolves
      if (bot.knowledge
          .getSuspicion(candidate.id)
          .accusedBy
          .any((accuser) => bot.knowledge.knownWolfIds.contains(accuser))) {
        threatScore += 30;
      }

      // High trust = probably village leader = threat
      if (bot.knowledge.getTrust(candidate.id) > 50) {
        threatScore += 25;
      }

      scores[candidate.id] = threatScore;
    }

    // Sort by threat score
    final sortedCandidates = candidates.toList()
      ..sort((a, b) => (scores[b.id] ?? 0).compareTo(scores[a.id] ?? 0));

    final target = sortedCandidates.first;

    // Apply difficulty - maybe pick suboptimal target
    if (_random.nextDouble() < bot.difficultyConfig.mistakeChance) {
      final randomTarget = candidates[_random.nextInt(candidates.length)];
      return NightActionDecision(
        targetId: randomTarget.id,
        actionType: ActionType.kill,
        reason: 'Zufällige Wahl (Fehler)',
      );
    }

    return NightActionDecision(
      targetId: target.id,
      actionType: ActionType.kill,
      reason: 'Höchste Bedrohung: ${scores[target.id]}',
    );
  }

  /// Decide seer investigation target
  static NightActionDecision decideSeerCheck({
    required BotPlayer bot,
    required GameState gameState,
    required List<Player> alivePlayers,
  }) {
    // Filter out already-checked players
    final unchecked = alivePlayers
        .where((p) =>
            p.id != bot.id && !bot.knowledge.confirmedRoles.containsKey(p.id))
        .toList();

    if (unchecked.isEmpty) {
      return const NightActionDecision(
        targetId: null,
        actionType: ActionType.see,
        reason: 'Alle bereits geprüft',
      );
    }

    // Prioritize suspicious players
    unchecked.sort((a, b) {
      final suspicionA = bot.knowledge.getSuspicion(a.id).suspicionLevel;
      final suspicionB = bot.knowledge.getSuspicion(b.id).suspicionLevel;
      return suspicionB.compareTo(suspicionA);
    });

    final target = unchecked.first;

    return NightActionDecision(
      targetId: target.id,
      actionType: ActionType.see,
      reason: 'Höchster Verdacht',
    );
  }

  /// Decide witch action (heal or poison)
  static NightActionDecision decideWitchAction({
    required BotPlayer bot,
    required GameState gameState,
    required String? wolfVictimId,
    required bool hasHealPotion,
    required bool hasKillPotion,
  }) {
    // Heal decision
    if (wolfVictimId != null && hasHealPotion) {
      // Heal self always
      if (wolfVictimId == bot.id) {
        return NightActionDecision(
          targetId: wolfVictimId,
          actionType: ActionType.protect, // heal
          reason: 'Selbstrettung',
        );
      }

      // Heal confirmed important role
      final victimRole = bot.knowledge.confirmedRoles[wolfVictimId];
      if (victimRole == RoleType.seherin) {
        return NightActionDecision(
          targetId: wolfVictimId,
          actionType: ActionType.protect,
          reason: 'Seherin retten',
        );
      }

      // Early game: consider saving heal
      if (gameState.round <= 2) {
        if (_random.nextDouble() > 0.6) {
          // 40% chance to heal anyway
          return NightActionDecision(
            targetId: wolfVictimId,
            actionType: ActionType.protect,
            reason: 'Dorfbewohner retten',
          );
        }
      } else {
        // Late game: always heal
        return NightActionDecision(
          targetId: wolfVictimId,
          actionType: ActionType.protect,
          reason: 'Dorfbewohner retten (Endspiel)',
        );
      }
    }

    // Kill decision (if no heal or chose not to heal)
    if (hasKillPotion) {
      final mostSuspicious = bot.knowledge.getMostSuspicious([bot.id]);
      if (mostSuspicious != null) {
        final suspicionLevel =
            bot.knowledge.getSuspicion(mostSuspicious).suspicionLevel;

        // Only use poison if very confident
        if (suspicionLevel > 80) {
          return NightActionDecision(
            targetId: mostSuspicious,
            actionType: ActionType.kill,
            reason: 'Hoher Verdacht: $suspicionLevel%',
          );
        }
      }
    }

    return const NightActionDecision(
      targetId: null,
      actionType: ActionType.none,
      reason: 'Keine Aktion',
    );
  }

  /// Decide bodyguard protection target
  static NightActionDecision decideBodyguardProtect({
    required BotPlayer bot,
    required GameState gameState,
    required List<Player> alivePlayers,
    required String? lastProtectedId,
  }) {
    // Cannot protect same player twice in a row
    final candidates = alivePlayers
        .where((p) => p.id != bot.id && p.id != lastProtectedId)
        .toList();

    if (candidates.isEmpty) {
      return const NightActionDecision(
        targetId: null,
        actionType: ActionType.protect,
        reason: 'Niemand zu beschützen',
      );
    }

    // Prioritize confirmed important roles
    for (final candidate in candidates) {
      final role = bot.knowledge.confirmedRoles[candidate.id];
      if (role == RoleType.seherin || role == RoleType.hexe) {
        return NightActionDecision(
          targetId: candidate.id,
          actionType: ActionType.protect,
          reason: 'Wichtige Rolle schützen',
        );
      }
    }

    // Protect player with highest trust
    candidates.sort((a, b) {
      final trustA = bot.knowledge.getTrust(a.id);
      final trustB = bot.knowledge.getTrust(b.id);
      return trustB.compareTo(trustA);
    });

    return NightActionDecision(
      targetId: candidates.first.id,
      actionType: ActionType.protect,
      reason: 'Vertrauenswürdigsten schützen',
    );
  }
}

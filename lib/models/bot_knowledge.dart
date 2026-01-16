/// Bot Knowledge Base
///
/// Tracks what each bot "knows" about the game state, including
/// suspicions, confirmed roles, voting history, and claimed roles.

import 'package:werwolf_digital_flutter/models/role.dart';

/// Data about how suspicious a player is
class SuspicionData {
  final String playerId;
  int suspicionLevel; // 0-100, 50 is neutral
  final List<String> reasons;
  final List<String> accusedBy;
  final List<String> defendedBy;

  SuspicionData({
    required this.playerId,
    this.suspicionLevel = 50,
    List<String>? reasons,
    List<String>? accusedBy,
    List<String>? defendedBy,
  })  : reasons = reasons ?? [],
        accusedBy = accusedBy ?? [],
        defendedBy = defendedBy ?? [];

  void addSuspicion(int amount, String reason) {
    suspicionLevel = (suspicionLevel + amount).clamp(0, 100);
    if (reason.isNotEmpty) reasons.add(reason);
  }

  void reduceSuspicion(int amount, String reason) {
    suspicionLevel = (suspicionLevel - amount).clamp(0, 100);
    if (reason.isNotEmpty) reasons.add(reason);
  }
}

/// Record of a single vote
class VoteRecord {
  final int round;
  final String voterId;
  final String targetId;
  final bool votedYes;
  final String? nominatedPlayerId;

  const VoteRecord({
    required this.round,
    required this.voterId,
    required this.targetId,
    required this.votedYes,
    this.nominatedPlayerId,
  });
}

/// Record of a death
class DeathRecord {
  final int round;
  final String playerId;
  final String playerName;
  final RoleType? role;
  final String cause; // 'wolf_kill', 'execution', 'witch', 'hunter'

  const DeathRecord({
    required this.round,
    required this.playerId,
    required this.playerName,
    this.role,
    required this.cause,
  });
}

/// The knowledge base for a single bot
class BotKnowledge {
  /// Roles that are 100% confirmed (e.g., dead players, revealed roles)
  final Map<String, RoleType> confirmedRoles = {};

  /// Suspicion level for each player
  final Map<String, SuspicionData> suspicions = {};

  /// Trust level for each player (-100 to +100)
  final Map<String, int> trustLevels = {};

  /// History of all votes
  final List<VoteRecord> votingHistory = [];

  /// History of all deaths
  final List<DeathRecord> deathHistory = [];

  /// What players have claimed to be
  final Map<String, RoleType> claimedRoles = {};

  /// Players the bot knows are wolves (only for wolf bots)
  final Set<String> knownWolfIds = {};

  /// Players the bot knows are villagers (from seer checks, etc.)
  final Set<String> knownVillagerIds = {};

  BotKnowledge();

  /// Get suspicion level for a player (creates if not exists)
  SuspicionData getSuspicion(String playerId) {
    return suspicions.putIfAbsent(
      playerId,
      () => SuspicionData(playerId: playerId),
    );
  }

  /// Add suspicion to a player
  void addSuspicion(String playerId, int amount, String reason) {
    getSuspicion(playerId).addSuspicion(amount, reason);
  }

  /// Get the most suspicious player
  String? getMostSuspicious(List<String> excludeIds) {
    String? mostSuspect;
    int highestSuspicion = 60; // Minimum threshold

    for (final entry in suspicions.entries) {
      if (excludeIds.contains(entry.key)) continue;
      if (knownVillagerIds.contains(entry.key)) continue;
      if (entry.value.suspicionLevel > highestSuspicion) {
        highestSuspicion = entry.value.suspicionLevel;
        mostSuspect = entry.key;
      }
    }

    return mostSuspect;
  }

  /// Record a vote
  void recordVote(VoteRecord vote) {
    votingHistory.add(vote);

    // Analyze vote for suspicion
    // TODO: Implement vote analysis logic
  }

  /// Record a death and update knowledge
  void recordDeath(DeathRecord death) {
    deathHistory.add(death);

    if (death.role != null) {
      confirmedRoles[death.playerId] = death.role!;

      // Update suspicions based on who was wrong
      if (death.cause == 'execution') {
        if (death.role == RoleType.werwolf) {
          // Correct execution - those who voted yes were right
        } else {
          // Wrong execution - those who voted yes were wrong or wolves
        }
      }
    }
  }

  /// Record a role claim
  void recordClaim(String playerId, RoleType claimedRole) {
    claimedRoles[playerId] = claimedRole;

    // Check for conflicts
    final existingClaims = claimedRoles.entries
        .where((e) => e.value == claimedRole && e.key != playerId)
        .toList();

    if (existingClaims.isNotEmpty) {
      // Multiple claims for same unique role = one is lying
      for (final claim in existingClaims) {
        addSuspicion(claim.key, 30, 'Conflicting role claim');
      }
      addSuspicion(playerId, 30, 'Conflicting role claim');
    }
  }

  /// Confirm a player's role (from seer check, death reveal, etc.)
  void confirmRole(String playerId, RoleType role, {bool isWolf = false}) {
    confirmedRoles[playerId] = role;

    if (isWolf) {
      knownWolfIds.add(playerId);
      suspicions
          .remove(playerId); // No need to track suspicion for confirmed wolves
    } else {
      knownVillagerIds.add(playerId);
      suspicions
          .remove(playerId); // No suspicion needed for confirmed villagers
    }
  }

  /// Get trust level for a player
  int getTrust(String playerId) => trustLevels[playerId] ?? 0;

  /// Adjust trust level
  void adjustTrust(String playerId, int amount) {
    trustLevels[playerId] = (getTrust(playerId) + amount).clamp(-100, 100);
  }

  /// Clear volatile suspicions (for new round)
  void resetRoundSuspicions() {
    for (final suspicion in suspicions.values) {
      // Decay suspicion slightly each round
      suspicion.suspicionLevel =
          ((suspicion.suspicionLevel - 50) * 0.8 + 50).round();
    }
  }
}

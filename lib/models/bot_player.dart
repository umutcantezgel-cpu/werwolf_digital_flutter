/// Bot Player Model
///
/// Represents an AI-controlled player in Solo Mode with
/// personality, knowledge, and decision-making capabilities.

import 'package:werwolf_digital_flutter/models/role.dart';
import 'package:werwolf_digital_flutter/models/bot_personality.dart';
import 'package:werwolf_digital_flutter/models/bot_knowledge.dart';

/// Difficulty levels for bot AI
enum DifficultyLevel {
  leicht, // Easy - 40% mistakes, 30% optimal, poor bluffing
  normal, // Normal - 20% mistakes, 60% optimal, average bluffing
  schwer, // Hard - 10% mistakes, 80% optimal, good bluffing
  experte, // Expert - 2% mistakes, 95% optimal, excellent bluffing
}

/// Configuration for difficulty-based behavior
class DifficultyConfig {
  final double mistakeChance; // 0.0-1.0
  final double optimalPlayRate; // 0.0-1.0
  final double bluffQuality; // 0.0-1.0
  final double memoryAccuracy; // 0.0-1.0
  final Duration reactionDelay;

  const DifficultyConfig({
    required this.mistakeChance,
    required this.optimalPlayRate,
    required this.bluffQuality,
    required this.memoryAccuracy,
    required this.reactionDelay,
  });

  factory DifficultyConfig.fromLevel(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.leicht:
        return const DifficultyConfig(
          mistakeChance: 0.40,
          optimalPlayRate: 0.30,
          bluffQuality: 0.20,
          memoryAccuracy: 0.60,
          reactionDelay: Duration(seconds: 3),
        );
      case DifficultyLevel.normal:
        return const DifficultyConfig(
          mistakeChance: 0.20,
          optimalPlayRate: 0.60,
          bluffQuality: 0.50,
          memoryAccuracy: 0.80,
          reactionDelay: Duration(seconds: 2),
        );
      case DifficultyLevel.schwer:
        return const DifficultyConfig(
          mistakeChance: 0.10,
          optimalPlayRate: 0.80,
          bluffQuality: 0.75,
          memoryAccuracy: 0.95,
          reactionDelay: Duration(milliseconds: 1500),
        );
      case DifficultyLevel.experte:
        return const DifficultyConfig(
          mistakeChance: 0.02,
          optimalPlayRate: 0.95,
          bluffQuality: 0.90,
          memoryAccuracy: 1.0,
          reactionDelay: Duration(seconds: 1),
        );
    }
  }
}

/// Represents a single AI-controlled bot player
class BotPlayer {
  final String id;
  final String name;
  final PersonalityType personality;
  final DifficultyLevel difficulty;
  final BotBehavior behavior;
  final DifficultyConfig difficultyConfig;

  RoleType? role;
  bool isAlive;
  final BotKnowledge knowledge;

  BotPlayer({
    required this.id,
    required this.name,
    required this.personality,
    required this.difficulty,
  })  : behavior = BotBehavior.fromPersonality(personality),
        difficultyConfig = DifficultyConfig.fromLevel(difficulty),
        knowledge = BotKnowledge(),
        isAlive = true;

  /// Check if this bot is a wolf
  bool get isWolf =>
      role == RoleType.werwolf ||
      role == RoleType.urwolf ||
      role == RoleType.grosserBoserWolf;

  /// Check if this bot has a night action
  bool get hasNightAction {
    if (role == null) return false;
    switch (role!) {
      case RoleType.werwolf:
      case RoleType.urwolf:
      case RoleType.grosserBoserWolf:
      case RoleType.seherin:
      case RoleType.hexe:
      case RoleType.leibwachter:
      case RoleType.amor:
        return true;
      default:
        return false;
    }
  }

  /// Get night action priority (lower = earlier)
  int get nightPriority {
    if (role == null) return 99;
    switch (role!) {
      case RoleType.amor:
        return 0;
      case RoleType.seherin:
        return 1;
      case RoleType.leibwachter:
        return 2;
      case RoleType.werwolf:
      case RoleType.urwolf:
      case RoleType.grosserBoserWolf:
        return 3;
      case RoleType.hexe:
        return 4;
      case RoleType.jager:
        return 5; // On death trigger
      default:
        return 99;
    }
  }

  /// Initialize wolf knowledge (sees other wolves)
  void initializeAsWolf(List<String> fellowWolfIds) {
    for (final wolfId in fellowWolfIds) {
      if (wolfId != id) {
        knowledge.knownWolfIds.add(wolfId);
      }
    }
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'personality': personality.name,
        'difficulty': difficulty.name,
        'role': role?.name,
        'isAlive': isAlive,
      };

  /// Create from JSON
  factory BotPlayer.fromJson(Map<String, dynamic> json) {
    final bot = BotPlayer(
      id: json['id'] as String,
      name: json['name'] as String,
      personality: PersonalityType.values.firstWhere(
        (p) => p.name == json['personality'],
      ),
      difficulty: DifficultyLevel.values.firstWhere(
        (d) => d.name == json['difficulty'],
      ),
    );

    if (json['role'] != null) {
      bot.role = RoleType.values.firstWhere(
        (r) => r.name == json['role'],
      );
    }
    bot.isAlive = json['isAlive'] as bool? ?? true;

    return bot;
  }

  @override
  String toString() =>
      'BotPlayer($name, $personality, ${role?.name ?? "unassigned"})';
}

/// Extension for difficulty display names
extension DifficultyLevelExtension on DifficultyLevel {
  String get displayName {
    switch (this) {
      case DifficultyLevel.leicht:
        return 'Leicht';
      case DifficultyLevel.normal:
        return 'Normal';
      case DifficultyLevel.schwer:
        return 'Schwer';
      case DifficultyLevel.experte:
        return 'Experte';
    }
  }

  String get description {
    switch (this) {
      case DifficultyLevel.leicht:
        return 'Für Anfänger. Bots machen viele Fehler.';
      case DifficultyLevel.normal:
        return 'Ausgewogene Herausforderung für normale Spieler.';
      case DifficultyLevel.schwer:
        return 'Für erfahrene Spieler. Bots spielen strategisch.';
      case DifficultyLevel.experte:
        return 'Für Profis. Bots spielen nahezu perfekt.';
    }
  }
}

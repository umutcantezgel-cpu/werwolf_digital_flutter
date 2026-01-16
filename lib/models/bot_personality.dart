/// Bot Personality Types and Behavior Configuration
///
/// Based on the Solo Mode specification, each bot has a distinct personality
/// that affects their decision-making, communication style, and gameplay.

import 'dart:math';

/// The 8 distinct personality types for bots
enum PersonalityType {
  analytiker, // Logical, fact-based, tracks voting patterns
  aggressor, // Accuses early and often, demands votes
  beobachter, // Quiet observer, late but accurate conclusions
  diplomat, // Mediator, builds alliances, seeks compromise
  emotionaler, // Gut-feeling based, unpredictable, personal
  manipulator, // Subtle misdirection, plays players against each other
  anfuehrerin, // Natural leader, structures discussions
  beschuetzerin, // Defends weaker players, loyal, self-sacrificing
}

/// Behavior stats that define how a bot plays
class BotBehavior {
  /// 0-100: How actively accusatory the bot is
  final int aggressiveness;

  /// 0-100: How strongly the bot defends itself and others
  final int defensiveness;

  /// 0-100: How good the bot is at lying (as wolf)
  final int deception;

  /// 0-100: How analytically the bot thinks
  final int logic;

  /// 0-100: How much the bot relies on "gut feeling"
  final int intuition;

  /// 0-100: How often the bot leads discussion
  final int leadership;

  const BotBehavior({
    required this.aggressiveness,
    required this.defensiveness,
    required this.deception,
    required this.logic,
    required this.intuition,
    required this.leadership,
  });

  /// Create behavior from personality type
  factory BotBehavior.fromPersonality(PersonalityType type) {
    switch (type) {
      case PersonalityType.analytiker:
        return const BotBehavior(
          aggressiveness: 40,
          defensiveness: 30,
          deception: 50,
          logic: 90,
          intuition: 20,
          leadership: 60,
        );
      case PersonalityType.aggressor:
        return const BotBehavior(
          aggressiveness: 90,
          defensiveness: 70,
          deception: 40,
          logic: 40,
          intuition: 60,
          leadership: 70,
        );
      case PersonalityType.beobachter:
        return const BotBehavior(
          aggressiveness: 20,
          defensiveness: 40,
          deception: 60,
          logic: 70,
          intuition: 80,
          leadership: 20,
        );
      case PersonalityType.diplomat:
        return const BotBehavior(
          aggressiveness: 30,
          defensiveness: 60,
          deception: 70,
          logic: 50,
          intuition: 50,
          leadership: 80,
        );
      case PersonalityType.emotionaler:
        return const BotBehavior(
          aggressiveness: 60,
          defensiveness: 80,
          deception: 30,
          logic: 30,
          intuition: 90,
          leadership: 40,
        );
      case PersonalityType.manipulator:
        return const BotBehavior(
          aggressiveness: 50,
          defensiveness: 50,
          deception: 95,
          logic: 60,
          intuition: 70,
          leadership: 50,
        );
      case PersonalityType.anfuehrerin:
        return const BotBehavior(
          aggressiveness: 60,
          defensiveness: 50,
          deception: 50,
          logic: 70,
          intuition: 50,
          leadership: 95,
        );
      case PersonalityType.beschuetzerin:
        return const BotBehavior(
          aggressiveness: 20,
          defensiveness: 90,
          deception: 40,
          logic: 50,
          intuition: 70,
          leadership: 40,
        );
    }
  }
}

/// German name patterns by personality type
class BotNameGenerator {
  static final Random _random = Random();

  static const Map<PersonalityType, List<String>> _namesByPersonality = {
    PersonalityType.analytiker: [
      'Thomas',
      'Stefan',
      'Martin',
      'Klaus',
      'Peter'
    ],
    PersonalityType.aggressor: ['Max', 'Felix', 'Paul', 'Tim', 'Lukas'],
    PersonalityType.beobachter: ['Jonas', 'Lukas', 'Tim', 'Florian', 'Jan'],
    PersonalityType.diplomat: [
      'Alexander',
      'Sebastian',
      'Florian',
      'Philipp',
      'Daniel'
    ],
    PersonalityType.emotionaler: ['Leon', 'Ben', 'Finn', 'Elias', 'Noah'],
    PersonalityType.manipulator: [
      'David',
      'Philipp',
      'Nico',
      'Moritz',
      'Julian'
    ],
    PersonalityType.anfuehrerin: ['Anna', 'Sophie', 'Laura', 'Julia', 'Lena'],
    PersonalityType.beschuetzerin: ['Marie', 'Emma', 'Mia', 'Hannah', 'Lea'],
  };

  /// Generate a name based on personality type
  static String generateName(PersonalityType type, List<String> usedNames) {
    final names = _namesByPersonality[type]!;
    final available = names.where((n) => !usedNames.contains(n)).toList();

    if (available.isEmpty) {
      // Fallback: add number suffix
      return '${names[_random.nextInt(names.length)]} ${_random.nextInt(99)}';
    }

    return available[_random.nextInt(available.length)];
  }

  /// Distribute personalities balanced for a game
  static List<PersonalityType> distributePersonalities(int count) {
    final personalities = <PersonalityType>[];
    final allTypes = PersonalityType.values.toList()..shuffle(_random);

    // Ensure at least one analytiker and one aggressor for game dynamics
    personalities.add(PersonalityType.analytiker);
    personalities.add(PersonalityType.aggressor);

    // Fill remaining slots
    int index = 0;
    while (personalities.length < count) {
      final type = allTypes[index % allTypes.length];

      // Max 2 of same personality
      if (personalities.where((p) => p == type).length < 2) {
        personalities.add(type);
      }
      index++;

      // Safety: prevent infinite loop
      if (index > count * 3) break;
    }

    personalities.shuffle(_random);
    return personalities.take(count).toList();
  }
}

/// Display name for personality type (German)
extension PersonalityTypeExtension on PersonalityType {
  String get displayName {
    switch (this) {
      case PersonalityType.analytiker:
        return 'Der Analytiker';
      case PersonalityType.aggressor:
        return 'Der Aggressor';
      case PersonalityType.beobachter:
        return 'Der Beobachter';
      case PersonalityType.diplomat:
        return 'Der Diplomat';
      case PersonalityType.emotionaler:
        return 'Der Emotionale';
      case PersonalityType.manipulator:
        return 'Der Manipulator';
      case PersonalityType.anfuehrerin:
        return 'Die Anführerin';
      case PersonalityType.beschuetzerin:
        return 'Die Beschützerin';
    }
  }

  String get description {
    switch (this) {
      case PersonalityType.analytiker:
        return 'Argumentiert mit Logik und Fakten. Deckt Widersprüche auf.';
      case PersonalityType.aggressor:
        return 'Beschuldigt früh und oft. Fordert sofortige Abstimmungen.';
      case PersonalityType.beobachter:
        return 'Spricht wenig, beobachtet viel. Überraschend treffsicher.';
      case PersonalityType.diplomat:
        return 'Versucht zu vermitteln. Baut Allianzen auf.';
      case PersonalityType.emotionaler:
        return 'Reagiert auf Bauchgefühl. Unberechenbar.';
      case PersonalityType.manipulator:
        return 'Streut subtil Misstrauen. Meisterhafter Lügner.';
      case PersonalityType.anfuehrerin:
        return 'Übernimmt natürlich die Diskussionsleitung.';
      case PersonalityType.beschuetzerin:
        return 'Verteidigt schwächere Spieler. Loyal bis zum Ende.';
    }
  }
}

import 'package:flutter/material.dart';
import '../models/role.dart';
import '../models/bot_player.dart'; // For DifficultyLevel
import 'bot_manager.dart'; // For SoloModeConfig

class Challenge {
  final String id;
  final String title;
  final String description;
  final int rewardXp;
  final bool isCompleted;
  final double progress; // 0.0 to 1.0

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardXp,
    this.isCompleted = false,
    this.progress = 0.0,
  });

  Challenge copyWith({
    bool? isCompleted,
    double? progress,
  }) {
    return Challenge(
      id: id,
      title: title,
      description: description,
      rewardXp: rewardXp,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
    );
  }
}

class ChallengeManager extends ChangeNotifier {
  final List<Challenge> _challenges = [
    const Challenge(
      id: 'c1',
      title: 'Erster Sieg',
      description: 'Gewinne ein Spiel im Solo-Modus.',
      rewardXp: 100,
      progress: 0.0,
    ),
    const Challenge(
      id: 'c2',
      title: 'Meister-Detektiv',
      description: 'Enttarne 3 Werwölfe in einem Spiel.',
      rewardXp: 300,
      progress: 0.0,
    ),
    const Challenge(
      id: 'c3',
      title: 'Alpha-Tier',
      description: 'Gewinne als Werwolf, ohne dass ein anderer Wolf stirbt.',
      rewardXp: 500,
      progress: 0.0,
    ),
    const Challenge(
      id: 'c4',
      title: 'Überlebenskünstler',
      description: 'Überlebe 5 Nächte als Dorfbewohner.',
      rewardXp: 200,
      progress: 0.0,
    ),
  ];

  List<Challenge> get challenges => _challenges;

  // In a real app, this would save to SharedPreferences/Database
  void completeChallenge(String id) {
    final index = _challenges.indexWhere((c) => c.id == id);
    if (index != -1 && !_challenges[index].isCompleted) {
      _challenges[index] = _challenges[index].copyWith(
        isCompleted: true,
        progress: 1.0,
      );
      notifyListeners();
    }
  }

  void updateProgress(String id, double progress) {
    final index = _challenges.indexWhere((c) => c.id == id);
    if (index != -1 && !_challenges[index].isCompleted) {
      _challenges[index] = _challenges[index].copyWith(
        progress: progress.clamp(0.0, 1.0),
      );
      if (progress >= 1.0) {
        _challenges[index] = _challenges[index].copyWith(isCompleted: true);
      }
      notifyListeners();
    }
  }

  // Scenarios
  final List<Scenario> _scenarios = [
    const Scenario(
      id: 's1',
      title: 'Das erste Opfer',
      description:
          'Du bist ein einsamer Werwolf gegen 5 Dorfbewohner. Kannst du gewinnen?',
      setupConfig: SoloModeConfig(
        totalPlayers: 6,
        humanPlayers: 1,
        difficulty: DifficultyLevel.leicht,
      ),
      fixedPlayerRole: RoleType.werwolf,
    ),
    const Scenario(
      id: 's2',
      title: 'Das allwissende Auge',
      description:
          'Als Seherin musst du die Wölfe finden, bevor sie dich finden. (Schwer)',
      setupConfig: SoloModeConfig(
        totalPlayers: 10,
        humanPlayers: 1,
        difficulty: DifficultyLevel.schwer,
      ),
      fixedPlayerRole: RoleType.seherin,
    ),
  ];

  List<Scenario> get scenarios => _scenarios;
}

class Scenario {
  final String id;
  final String title;
  final String description;
  final SoloModeConfig setupConfig;
  final RoleType fixedPlayerRole;

  const Scenario({
    required this.id,
    required this.title,
    required this.description,
    required this.setupConfig,
    required this.fixedPlayerRole,
  });
}

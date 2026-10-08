import 'package:mordakte_core/mordakte_core.dart';

/// Rang-Schwellen (XP). Index = Rang (wird mit `DetectiveClass.unlockRank` verglichen).
/// Namen: Anwärter, Ermittler, Inspektor, Kommissar, Hauptkommissar, Legende.
const rankThresholds = <int>[0, 300, 900, 2000, 4000, 8000];

int rankForXp(int xp) {
  var r = 0;
  for (var i = 0; i < rankThresholds.length; i++) {
    if (xp >= rankThresholds[i]) r = i;
  }
  return r;
}

/// XP-Schwelle des nächsten Rangs (oder `null` beim höchsten Rang).
int? nextRankXp(int xp) {
  final r = rankForXp(xp);
  return r + 1 < rankThresholds.length ? rankThresholds[r + 1] : null;
}

/// Fortschritt innerhalb des aktuellen Rangs (0..1).
double rankProgress(int xp) {
  final r = rankForXp(xp);
  final next = nextRankXp(xp);
  if (next == null) return 1;
  final lo = rankThresholds[r];
  return ((xp - lo) / (next - lo)).clamp(0.0, 1.0);
}

/// Ab welchem Rang ein Hut freigeschaltet ist.
const hatUnlockRank = <String, int>{
  'fedora': 0,
  'cap': 0,
  'none': 0,
  'bowler': 1,
  'beret': 2,
  'cloche': 3,
  'top': 4,
};

/// Ab welchem Rang eine Mantelfarbe (Index in `detectiveCoats`) freigeschaltet ist.
const coatUnlockRank = <int>[0, 0, 0, 0, 1, 2, 3, 5];

int classUnlockRank(String cls) => detectiveClasses[cls]?.unlockRank ?? 0;
int hatRank(String hat) => hatUnlockRank[hat] ?? 0;
int coatRank(int coat) => coat >= 0 && coat < coatUnlockRank.length ? coatUnlockRank[coat] : 0;

/// Bonus für den Fall des Tages.
const dailyBonusXp = 100;

/// Alle Erfolge (Texte: `ach_<id>` / `ach_<id>_desc`).
const achievementIds = <String>[
  'first_case',
  'perfect',
  'all_survived',
  'revive3',
  'secret',
  'all_scenarios',
  'streak5',
  'ghost_helper',
  'online',
  'combos10',
];

/// Datum als `yyyy-mm-dd` (lokal).
String dayKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Fall des Tages: gleiche Akte und gleicher Seed auf jedem Gerät.
class DailyCase {
  final String day;
  final int seed;
  final String? scenarioId;

  const DailyCase(this.day, this.seed, this.scenarioId);

  factory DailyCase.forDate(DateTime date, Iterable<String> scenarioIds) {
    final day = dayKey(date);
    final seed = Rng.hashString(day);
    final ids = scenarioIds.toList()..sort();
    return DailyCase(day, seed, ids.isEmpty ? null : ids[seed % ids.length]);
  }
}

/// Ein Ende-Schlüssel `verdict.team.culprit[.secret]` zerlegt.
class EndingKey {
  final String verdict;
  final String team;
  final String? culprit;
  final bool secret;

  const EndingKey(this.verdict, this.team, this.culprit, this.secret);

  factory EndingKey.parse(String id) {
    final p = id.split('.');
    return EndingKey(
      p.isNotEmpty ? p[0] : 'unsolved',
      p.length > 1 ? p[1] : 'none',
      p.length > 2 && p[2] != 'secret' ? p[2] : null,
      p.contains('secret'),
    );
  }
}

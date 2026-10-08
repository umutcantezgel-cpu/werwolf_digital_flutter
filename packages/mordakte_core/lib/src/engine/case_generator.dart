import '../scenario/scenario_def.dart';
import '../util/rng.dart';

/// Wählt die Wahrheit eines Durchlaufs.
///
/// - `story`: die kanonische Variante des Szenarios (erster Durchlauf).
/// - `random` / `daily`: aus [seed] gewürfelt – Täter aus den Kandidaten, ein
///   zum Täter passendes Motiv und eine Waffe. Gleicher Seed → gleicher Fall auf
///   jedem Gerät.
class CaseGenerator {
  static CaseTruthDef generate(ScenarioDef s, {required String mode, required int seed}) {
    if (mode == 'story') return s.story;
    final rng = Rng(seed ^ Rng.hashString(s.id));
    final candidates = s.candidates.where((c) => c.motives.any(s.motiveById.containsKey)).toList();
    if (candidates.isEmpty || s.weapons.isEmpty) return s.story;
    final culprit = rng.pick(candidates);
    final motives = culprit.motives.where(s.motiveById.containsKey).toList();
    final motive = rng.pick(motives);
    final weapon = rng.pick(s.weapons).id;
    return CaseTruthDef(culprit: culprit.id, motive: motive, weapon: weapon);
  }

  /// Alle möglichen Wahrheiten eines Szenarios (für Validator und Sammlung).
  static List<CaseTruthDef> allTruths(ScenarioDef s) => [
        for (final c in s.candidates)
          for (final m in c.motives.where(s.motiveById.containsKey))
            for (final w in s.weapons) CaseTruthDef(culprit: c.id, motive: m, weapon: w.id),
      ];
}

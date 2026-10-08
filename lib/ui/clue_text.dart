import 'package:mordakte_core/mordakte_core.dart';

import '../l10n/lookup.dart';

/// Darstellbare Texte eines Hinweises.
class ClueTexts {
  /// Name/Überschrift (z. B. „Verschmierte Tinte“).
  final String title;

  /// Aktueller Text (Stufe 0 → `found`, Stufe 1 → aufgedeckter Text).
  final String text;

  /// „Im Labor analysieren“ / „Ergebnis in Kapitel N“, solange ausstehend.
  final String? pending;

  /// Art (Merkmal, Motiv …) als Text.
  final String kindLabel;

  const ClueTexts({required this.title, required this.text, required this.pending, required this.kindLabel});
}

/// Baut die Texte eines Hinweises aus Szenario + [ClueView].
///
/// - Stufe 0 → `def.found`
/// - Stufe 1 je Art: trait → `fillTemplate(def.reveal, {value})`, motive → `motives[value].reveal`,
///   weapon → `weapons[value].reveal`, alibi → `reveal`/`revealFalse`, story → `found`,
///   sighting (ohne Def) → „Sichtung: {Merkmal} – {Wert}“.
ClueTexts clueTexts(ScenarioDef? s, ClueView c, L l, {String locale = 'de'}) {
  final def = s?.clueById[c.id];
  final title = def?.name.resolve(locale) ?? (c.kind == 'sighting' ? l.clue_sighting_title : l.clue_kind_other);
  final pending = c.revealed
      ? null
      : switch (c.pending) {
          'lab' => l.clue_pending_lab,
          'time' => l.clue_pending_time(c.revealChapter ?? 0),
          _ => null,
        };
  return ClueTexts(
    title: title,
    text: clueText(s, c, l, locale: locale),
    pending: pending,
    kindLabel: l.clueKind(c.kind),
  );
}

/// Nur der Text eines Hinweises (siehe [clueTexts]).
String clueText(ScenarioDef? s, ClueView c, L l, {String locale = 'de'}) {
  final def = s?.clueById[c.id];
  String traitValue(String? traitId, String? value) {
    if (traitId == null || value == null) return value ?? '?';
    return s?.traits[traitId]?.values[value]?.resolve(locale) ?? value;
  }

  if (def == null) {
    if (c.kind == 'sighting') {
      final label = c.trait == null ? '?' : (s?.traits[c.trait]?.label.resolve(locale) ?? c.trait!);
      return l.clue_sighting(label, traitValue(c.trait, c.value));
    }
    return l.clue_unknown;
  }
  if (!c.revealed) return def.found.resolve(locale);
  final text = switch (c.kind) {
    ClueKind.trait => fillTemplate(def.reveal.resolve(locale), {'value': traitValue(c.trait ?? def.trait, c.value)}),
    ClueKind.motive => s?.motiveById[c.value]?.reveal.resolve(locale) ?? def.found.resolve(locale),
    ClueKind.weapon => s?.weaponById[c.value]?.reveal.resolve(locale) ?? def.found.resolve(locale),
    ClueKind.alibi => c.value == 'true' ? def.reveal.resolve(locale) : def.revealFalse.resolve(locale),
    _ => def.found.resolve(locale),
  };
  return text.isEmpty ? def.found.resolve(locale) : text;
}

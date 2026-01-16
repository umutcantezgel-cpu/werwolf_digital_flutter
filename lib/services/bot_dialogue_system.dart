/// Bot Dialogue System
///
/// Generates natural German dialogue for bots based on their
/// personality, the game situation, and available templates.

import 'dart:math';
import 'package:werwolf_digital_flutter/models/bot_personality.dart';
import 'package:werwolf_digital_flutter/models/bot_player.dart';

/// Types of dialogue contexts
enum DialogueContext {
  accusation,
  selfDefense,
  defendOther,
  voteYes,
  voteNo,
  voteAbstain,
  reactionDeath,
  reactionAccused,
  nightComplete,
  roleClaim,
  question,
  greeting,
  agreement,
  disagreement,
}

/// A single dialogue message from a bot
class BotDialogue {
  final String message;
  final DialogueContext context;
  final String? targetPlayerName;
  final String? reason;
  final int delayMs; // Delay before showing

  const BotDialogue({
    required this.message,
    required this.context,
    this.targetPlayerName,
    this.reason,
    this.delayMs = 0,
  });
}

/// Generates dialogue for bots
class BotDialogueSystem {
  static final Random _random = Random();

  /// Track used templates to avoid repetition
  final Set<String> _usedTemplates = {};

  /// Reset used templates (e.g., new game)
  void reset() {
    _usedTemplates.clear();
  }

  /// Generate accusation dialogue
  BotDialogue generateAccusation({
    required BotPlayer bot,
    required String targetName,
    required String reason,
  }) {
    final templates = _accusationTemplates[bot.personality] ??
        _accusationTemplates[PersonalityType.diplomat]!;
    final template = _selectTemplate(templates);

    final message = template
        .replaceAll('{player}', targetName)
        .replaceAll('{reason}', reason);

    return BotDialogue(
      message: message,
      context: DialogueContext.accusation,
      targetPlayerName: targetName,
      reason: reason,
      delayMs: _calculateDelay(bot),
    );
  }

  /// Generate self-defense dialogue
  BotDialogue generateSelfDefense({
    required BotPlayer bot,
    required String accuserName,
    required bool isWolf,
  }) {
    final templates =
        isWolf ? _wolfDefenseTemplates : _villagerDefenseTemplates;
    final template = _selectTemplate(templates);

    final message = template.replaceAll('{accuser}', accuserName);

    return BotDialogue(
      message: message,
      context: DialogueContext.selfDefense,
      delayMs: _calculateDelay(bot, urgent: true),
    );
  }

  /// Generate vote announcement
  BotDialogue generateVoteAnnouncement({
    required BotPlayer bot,
    required String targetName,
    required bool voteYes,
    required int confidence,
  }) {
    final templates = voteYes ? _voteYesTemplates : _voteNoTemplates;
    final template = _selectTemplate(templates);

    final message = template.replaceAll('{player}', targetName);

    return BotDialogue(
      message: message,
      context: voteYes ? DialogueContext.voteYes : DialogueContext.voteNo,
      targetPlayerName: targetName,
      delayMs: _random.nextInt(2000) + 500,
    );
  }

  /// Generate reaction to death
  BotDialogue generateDeathReaction({
    required BotPlayer bot,
    required String victimName,
    required bool wasWolf,
  }) {
    final templates =
        wasWolf ? _wolfRevealedTemplates : _villagerKilledTemplates;
    final template = _selectTemplate(templates);

    final message = template.replaceAll('{player}', victimName);

    return BotDialogue(
      message: message,
      context: DialogueContext.reactionDeath,
      targetPlayerName: victimName,
      delayMs: _random.nextInt(3000) + 1000,
    );
  }

  /// Generate role claim
  BotDialogue generateRoleClaim({
    required BotPlayer bot,
    required String roleName,
    required String evidence,
  }) {
    const templates = _roleClaimTemplates;
    final template = _selectTemplate(templates);

    final message = template
        .replaceAll('{role}', roleName)
        .replaceAll('{evidence}', evidence);

    return BotDialogue(
      message: message,
      context: DialogueContext.roleClaim,
      delayMs: _calculateDelay(bot),
    );
  }

  String _selectTemplate(List<String> templates) {
    // Prefer unused templates
    final unused = templates.where((t) => !_usedTemplates.contains(t)).toList();
    final pool = unused.isNotEmpty ? unused : templates;

    final selected = pool[_random.nextInt(pool.length)];
    _usedTemplates.add(selected);

    return selected;
  }

  int _calculateDelay(BotPlayer bot, {bool urgent = false}) {
    // Leadership personalities respond faster
    final baseDelay = urgent ? 1000 : 3000;
    final leadershipFactor = (100 - bot.behavior.leadership) / 100;
    return (baseDelay * leadershipFactor).round() + _random.nextInt(2000);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // DIALOGUE TEMPLATES
  // ═══════════════════════════════════════════════════════════════════════

  static const Map<PersonalityType, List<String>> _accusationTemplates = {
    PersonalityType.analytiker: [
      'Ich habe die Abstimmungen analysiert. {player} hat verdächtig gestimmt.',
      'Logisch betrachtet: {player} hat {reason}. Das passt nicht.',
      'Fakt ist: {player} war der einzige, der so gehandelt hat.',
      'Die Daten sprechen gegen {player}. Erklärung?',
    ],
    PersonalityType.aggressor: [
      'Ich sage es direkt: {player} ist ein Wolf. Abstimmung, jetzt!',
      'Leute, macht die Augen auf! {player} ist so offensichtlich verdächtig!',
      '{player}! Erklär dich! Warum hast du {reason}?',
      'Wir verschwenden Zeit. {player} muss weg.',
    ],
    PersonalityType.beobachter: [
      'Mir ist etwas aufgefallen... {player} war sehr ruhig.',
      'Ich beobachte {player} schon eine Weile. {reason}.',
      'Hat jemand bemerkt, wie {player} reagiert hat?',
    ],
    PersonalityType.diplomat: [
      'Ich möchte nicht vorschnell urteilen, aber {player} gibt mir zu denken.',
      'Können wir mal über {player} sprechen? {reason}.',
      'Vielleicht irre ich mich, aber {player} scheint mir verdächtig.',
    ],
    PersonalityType.emotionaler: [
      'Ich hab so ein Gefühl bei {player}. Ich kann es nicht erklären.',
      '{player} macht mich nervös. Irgendwas stimmt da nicht.',
      'Ich trau {player} einfach nicht. Punkt.',
    ],
    PersonalityType.manipulator: [
      'Interessant, dass {player} genau das getan hat...',
      'Hat jemand bemerkt, was {player} gesagt hat? {reason}.',
      'Ich will ja nichts sagen, aber {player}...',
    ],
    PersonalityType.anfuehrerin: [
      'Lasst uns fokussieren: {player} hat {reason}. Gedanken?',
      'Ich schlage vor, wir diskutieren {player}. Die Fakten sprechen dagegen.',
      'Ordnung bitte. {player} muss sich erklären.',
    ],
    PersonalityType.beschuetzerin: [
      'Es fällt mir schwer das zu sagen, aber {player} war verdächtig.',
      'Ich will niemanden falsch beschuldigen, aber bei {player}...',
      '{player} hat sich anders verhalten als sonst.',
    ],
  };

  static const List<String> _villagerDefenseTemplates = [
    'Ich bin Dorfbewohner! Warum sollte ich das tun wenn ich Wolf wäre?',
    'Denkt doch mal nach: Wenn ich Wolf wäre, hätte ich anders gehandelt.',
    'Ich verstehe den Verdacht, aber ich bin unschuldig.',
    'Ihr macht einen Fehler. Ich bin auf eurer Seite.',
    'Das ist ein Missverständnis. Lasst mich erklären...',
  ];

  static const List<String> _wolfDefenseTemplates = [
    'Das ist absurd! Ich habe das Dorf die ganze Zeit unterstützt.',
    'Wer mich beschuldigt, spielt den Wölfen in die Hände.',
    'Interessant, dass gerade du mich beschuldigst. Was verbirgst du?',
    'Ich bin einer der aktivsten Spieler. Das ist verdächtig?',
    'Prüft meine Abstimmungen - ich hab immer richtig gestimmt.',
  ];

  static const List<String> _voteYesTemplates = [
    'Ich stimme für die Hinrichtung von {player}.',
    'Ja von mir. {player} ist verdächtig genug.',
    'Schweren Herzens: Ja.',
    '{player} muss gehen. Ich stimme dafür.',
  ];

  static const List<String> _voteNoTemplates = [
    'Nein. Ich glaube nicht, dass {player} ein Wolf ist.',
    'Ich bin nicht überzeugt. Nein von mir.',
    'Wir sollten {player} nicht hinrichten. Dagegen.',
    'Das reicht mir nicht. Ich stimme mit Nein.',
  ];

  static const List<String> _wolfRevealedTemplates = [
    'Ich wusste es! {player} war die ganze Zeit ein Wolf!',
    'Gut gemacht. {player} hat es verdient.',
    'Ein Wolf weniger. Weiter so!',
    'Endlich! {player} war so verdächtig.',
  ];

  static const List<String> _villagerKilledTemplates = [
    'Oh nein... {player} war unschuldig. Das ist schlecht.',
    'Wir haben einen Fehler gemacht. Armer {player}.',
    'Das war falsch. {player} war einer von uns.',
    'Tragisch. Wir haben {player} umsonst geopfert.',
  ];

  static const List<String> _roleClaimTemplates = [
    'Ich muss mich outen: Ich bin {role}. {evidence}.',
    'Es ist Zeit für die Wahrheit. Ich bin {role}.',
    'Ich bin {role}. Ich kann es beweisen: {evidence}.',
  ];
}

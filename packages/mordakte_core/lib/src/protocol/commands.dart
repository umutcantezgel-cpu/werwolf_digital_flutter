/// Befehle vom Client an die RoomRuntime. Bewegung läuft separat über [MoveInput].
library;

sealed class Command {
  const Command();

  String get type;

  Map<String, dynamic> toJson() => {'type': type, ..._fields()};

  Map<String, dynamic> _fields();

  static Command fromJson(Map<String, dynamic> j) {
    String s(String k) => j[k] as String;
    String? os(String k) => j[k] as String?;
    switch (j['type'] as String) {
      case SetLoadout.t:
        return SetLoadout(cls: s('cls'), coat: (j['coat'] as num).toInt(), hat: s('hat'));
      case SetReady.t:
        return SetReady(j['ready'] as bool);
      case ConfigureGame.t:
        return ConfigureGame(
          scenarioId: s('scenarioId'),
          mode: s('mode'),
          seed: (j['seed'] as num?)?.toInt(),
          bots: (j['bots'] as num? ?? 0).toInt(),
        );
      case StartGame.t:
        return const StartGame();
      case Interact.t:
        return Interact(s('target'));
      case CancelAction.t:
        return const CancelAction();
      case AskTopic.t:
        return AskTopic(npc: s('npc'), topic: s('topic'));
      case PresentClue.t:
        return PresentClue(npc: s('npc'), clue: s('clue'));
      case ShareClue.t:
        return ShareClue(s('clue'));
      case Combine.t:
        return Combine(s('a'), s('b'));
      case VoteLead.t:
        return VoteLead(s('lead'));
      case Accuse.t:
        return Accuse(culprit: s('culprit'), motive: os('motive'), weapon: os('weapon'));
      case UseAbility.t:
        return const UseAbility();
      case UseItem.t:
        return UseItem((j['slot'] as num).toInt());
      case Signal.t:
        return Signal(
          kind: s('kind'),
          value: s('value'),
          x: (j['x'] as num?)?.toDouble(),
          y: (j['y'] as num?)?.toDouble(),
        );
      default:
        throw FormatException('Unbekannter Befehl: ${j['type']}');
    }
  }
}

/// Lobby: Klasse, Mantelfarbe (Index in `detectiveCoats`), Hut.
class SetLoadout extends Command {
  static const t = 'loadout';
  final String cls;
  final int coat;
  final String hat;
  const SetLoadout({required this.cls, required this.coat, required this.hat});
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {'cls': cls, 'coat': coat, 'hat': hat};
}

/// Lobby: bereit; Intro: überspringen.
class SetReady extends Command {
  static const t = 'ready';
  final bool ready;
  const SetReady(this.ready);
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {'ready': ready};
}

/// Nur Host, in der Lobby. `mode`: `story`, `random`, `daily`.
class ConfigureGame extends Command {
  static const t = 'configure';
  final String scenarioId;
  final String mode;
  final int? seed;

  /// KI-Detektive, die die Lobby auffüllen.
  final int bots;
  const ConfigureGame({required this.scenarioId, required this.mode, this.seed, this.bots = 0});
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {'scenarioId': scenarioId, 'mode': mode, 'seed': seed, 'bots': bots};
}

/// Nur Host.
class StartGame extends Command {
  static const t = 'start';
  const StartGame();
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {};
}

/// Interaktion mit einem Ziel in Reichweite:
/// Hotspot-ID, Verdächtigen-ID, Item-ID oder Spieler-ID (wiederbeleben).
class Interact extends Command {
  static const t = 'interact';
  final String target;
  const Interact(this.target);
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {'target': target};
}

class CancelAction extends Command {
  static const t = 'cancel';
  const CancelAction();
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {};
}

class AskTopic extends Command {
  static const t = 'ask';
  final String npc;
  final String topic;
  const AskTopic({required this.npc, required this.topic});
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {'npc': npc, 'topic': topic};
}

class PresentClue extends Command {
  static const t = 'present';
  final String npc;
  final String clue;
  const PresentClue({required this.npc, required this.clue});
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {'npc': npc, 'clue': clue};
}

class ShareClue extends Command {
  static const t = 'share';
  final String clue;
  const ShareClue(this.clue);
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {'clue': clue};
}

class Combine extends Command {
  static const t = 'combine';
  final String a;
  final String b;
  const Combine(this.a, this.b);
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {'a': a, 'b': b};
}

class VoteLead extends Command {
  static const t = 'vote_lead';
  final String lead;
  const VoteLead(this.lead);
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {'lead': lead};
}

class Accuse extends Command {
  static const t = 'accuse';
  final String culprit;
  final String? motive;
  final String? weapon;
  const Accuse({required this.culprit, this.motive, this.weapon});
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {'culprit': culprit, 'motive': motive, 'weapon': weapon};
}

class UseAbility extends Command {
  static const t = 'ability';
  const UseAbility();
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {};
}

/// Item aus Inventar-Slot benutzen.
class UseItem extends Command {
  static const t = 'use_item';
  final int slot;
  const UseItem(this.slot);
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {'slot': slot};
}

/// Emote, Schnellchat oder Map-Ping.
/// `kind`: `emote` (value = Emote-ID), `quick` (value = Phrasen-ID), `ping` (x/y in Kacheln).
class Signal extends Command {
  static const t = 'signal';
  final String kind;
  final String value;
  final double? x;
  final double? y;
  const Signal({required this.kind, required this.value, this.x, this.y});
  @override
  String get type => t;
  @override
  Map<String, dynamic> _fields() => {'kind': kind, 'value': value, 'x': x, 'y': y};
}

/// Emote- und Schnellchat-IDs (Texte/Symbole in der App).
const emoteIds = ['wave', 'shock', 'think', 'laugh', 'scared', 'thumbs'];
const quickChatIds = ['come_here', 'found_clue', 'help', 'stay_together', 'split_up', 'suspect', 'danger', 'thanks'];

/// Positions-Update des eigenen Detektivs (Client besitzt seine Position).
class MoveInput {
  final double x;
  final double y;
  final double facing;
  final int seq;

  const MoveInput({required this.x, required this.y, required this.facing, required this.seq});

  Map<String, dynamic> toJson() => {'x': _r(x), 'y': _r(y), 'f': _r(facing), 's': seq};

  factory MoveInput.fromJson(Map<String, dynamic> j) => MoveInput(
        x: (j['x'] as num).toDouble(),
        y: (j['y'] as num).toDouble(),
        facing: (j['f'] as num).toDouble(),
        seq: (j['s'] as num).toInt(),
      );
}

double _r(double v) => (v * 1000).roundToDouble() / 1000;

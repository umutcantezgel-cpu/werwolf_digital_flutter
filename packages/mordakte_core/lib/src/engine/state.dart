import '../model/rules.dart';
import '../scenario/catalog.dart';
import '../scenario/scenario_def.dart';

/// Laufende Kanal-Aktion eines Detektivs.
class Channel {
  final String kind; // search | lab | revive
  final String target;
  final int totalMs;
  final double startX;
  final double startY;
  int elapsedMs = 0;

  Channel(this.kind, this.target, this.totalMs, this.startX, this.startY);

  double get progress => totalMs <= 0 ? 1 : (elapsedMs / totalMs).clamp(0, 1).toDouble();
  bool get done => elapsedMs >= totalMs;
}

/// Statistik pro Spieler (für Auszeichnungen und XP).
class PlayerStats {
  int found = 0;
  int shared = 0;
  int combos = 0;
  int revives = 0;
  int contradictions = 0;
  int attacks = 0;
  int ghostHelp = 0;

  Map<String, int> toMap() => {
        'found': found,
        'shared': shared,
        'combos': combos,
        'revives': revives,
        'contradictions': contradictions,
        'attacks': attacks,
        'ghostHelp': ghostHelp,
      };
}

class PlayerState {
  final String id;
  String name;
  final bool bot;
  bool connected = true;
  int disconnectedMs = 0;

  // Lobby
  String cls = 'forensic';
  int coat = 0;
  String hat = 'fedora';
  bool ready = false;

  // Welt
  double x = 0;
  double y = 0;
  double facing = 0;
  int ackSeq = 0;
  int lastMoveAt = 0;
  double? correctX;
  double? correctY;
  bool moving = false;
  int movingUntil = 0;

  // Leben
  LifeState life = LifeState.alive;
  int hp = Tuning.baseHp;
  int maxHp = Tuning.baseHp;
  double nerves = Tuning.nervesMax;
  int downedLeftMs = 0;
  bool hidden = false;
  String? hideSpot;
  int poisonTimerMs = 0;

  /// Effekt-ID → Restzeit in ms (−1 = bis entfernt).
  final Map<String, int> effects = {};

  Channel? channel;
  final List<String> inventory = [];
  int abilityCdMs = 0;
  int abilityCharges = 0;
  int pingsLeft = Tuning.pingsPerChapter;
  int lastSignalAt = -100000;
  int lastShadowNearAt = -100000;
  String? talkingTo;
  int talkingUntil = 0;

  /// Vom Bot gesteuert (Bots, getrennte Spieler, Autoplay).
  bool autopilot = false;

  PlayerStats stats = PlayerStats();

  PlayerState(this.id, this.name, {this.bot = false});

  DetectiveClass get detectiveClass => detectiveClasses[cls] ?? detectiveClasses['forensic']!;

  bool get alive => life == LifeState.alive;
  bool get ghost => life == LifeState.ghost;
  bool get downed => life == LifeState.downed;

  bool hasEffect(String id) => effects.containsKey(id);

  Iterable<Modifiers> get _mods => effects.keys.map((e) => effectCatalog[e]?.mods).whereType<Modifiers>();

  double get speedMul {
    if (ghost) return 1.1;
    var m = 1.0;
    for (final mod in _mods) {
      m *= mod.speed;
    }
    return m;
  }

  double get searchMul {
    var m = 1.0;
    for (final mod in _mods) {
      m *= mod.search;
    }
    return m;
  }

  double get lightMul {
    var m = 1.0;
    for (final mod in _mods) {
      m *= mod.light;
    }
    return m;
  }

  double get nervesRegenBonus => _mods.fold(0.0, (s, m) => s + m.nervesRegen);
  bool get silenced => _mods.any((m) => m.silenced);
  bool get protected => hidden || _mods.any((m) => m.protected);
  bool get sight => _mods.any((m) => m.sight);
}

class NpcState {
  final SuspectDef def;
  double x;
  double y;
  bool alive = true;

  NpcState(this.def)
      : x = def.x + 0.5,
        y = def.y + 0.5;

  String get id => def.id;
}

/// Ein gefundener Hinweis (genau einmal pro Spiel).
class ClueInst {
  final String id;
  final ClueDef? def;
  final String kind;
  int stage;
  String? pending;
  int? revealChapter;
  final String? trait;

  /// Fester Wert (Sichtungen) – sonst aus der Wahrheit berechnet.
  final String? fixedValue;
  String holder;
  final String foundBy;
  bool onBoard = false;
  String? sharedBy;

  ClueInst({
    required this.id,
    required this.def,
    required this.kind,
    required this.stage,
    required this.pending,
    required this.revealChapter,
    required this.trait,
    required this.fixedValue,
    required this.holder,
    required this.foundBy,
  });

  bool get revealed => stage >= 1;

  factory ClueInst.fromDef(ClueDef def, String finder, int chapter) {
    final evolve = def.evolve;
    final immediate = evolve == Evolve.none || def.kind == ClueKind.story;
    return ClueInst(
      id: def.id,
      def: def,
      kind: def.kind,
      stage: immediate ? 1 : 0,
      pending: immediate ? null : evolve,
      revealChapter: evolve == Evolve.time ? chapter + def.chapters : null,
      trait: def.trait,
      fixedValue: null,
      holder: finder,
      foundBy: finder,
    );
  }
}

/// Die Wahrheit eines Durchlaufs.
class CaseTruth {
  final CaseTruthDef truth;
  final ScenarioDef scenario;

  CaseTruth(this.truth, this.scenario);

  SuspectDef get culprit => scenario.suspectById[truth.culprit]!;

  /// Wert, den ein Hinweis auf Stufe 1 zeigt.
  String? valueFor(ClueInst c) {
    if (c.fixedValue != null) return c.fixedValue;
    final def = c.def;
    if (def == null) return null;
    switch (def.kind) {
      case ClueKind.trait:
        return culprit.traits[def.trait];
      case ClueKind.motive:
        return truth.motive;
      case ClueKind.weapon:
        return truth.weapon;
      case ClueKind.alibi:
        return def.subject == truth.culprit ? 'false' : 'true';
      default:
        return null;
    }
  }
}

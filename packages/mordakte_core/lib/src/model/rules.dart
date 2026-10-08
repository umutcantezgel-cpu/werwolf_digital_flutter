/// Spielregeln als Daten: Phasen, Klassen, Effekte, Balance-Werte.
library;

enum Phase { lobby, intro, investigation, council, night, accusation, ending }

enum LifeState { alive, downed, ghost }

/// Feste Balance-Werte. Zeiten in Millisekunden, Strecken in Kacheln.
abstract final class Tuning {
  static const tickMs = 50;
  static const snapshotMs = 100;

  static const introMs = 14000;
  static const investigationMs = 240000;
  static const councilMs = 90000;
  static const nightMs = 75000;
  static const accusationMs = 120000;

  static const playerSpeed = 3.2;
  static const moveTolerance = 1.25;
  static const playerRadius = 0.28;
  static const interactRange = 1.5;
  static const groupRadius = 3.5;

  static const searchMs = 2500;
  static const labMs = 4000;
  static const reviveMs = 3000;
  static const downedMs = 15000;
  static const baseHp = 3;
  static const maxInventory = 3;

  static const nervesMax = 100.0;
  static const nervesLowAlone = 2.5; // pro Sekunde, nachts allein
  static const nervesNearShadow = 9.0; // pro Sekunde, Schatten in der Nähe
  static const nervesRegenSafe = 4.0; // pro Sekunde, tagsüber / im Licht / in Gruppe
  static const panicRecoverAt = 40.0;

  static const dayLightRadius = 12.0;
  static const nightLightRadius = 4.5;
  static const hearRadius = 1.6;

  static const shadowSpeed = 2.5;
  static const shadowSpeedSolo = 2.1;
  static const shadowAttackCooldownMs = 18000;
  static const shadowAttackCooldownSoloMs = 30000;
  static const shadowFleeMs = 9000;
  static const shadowAttackRange = 0.85;
  static const shadowNearRadius = 5.0;

  static const pingsPerChapter = 1;
  static const signalLifetimeMs = 6000;

  /// Beweisstärke für die Urteile.
  static const strengthPerfect = 8;
  static const strengthSolid = 5;

  /// XP-Werte für die Meta-Progression.
  static const xpClueFound = 10;
  static const xpClueShared = 15;
  static const xpCombo = 25;
  static const xpRevive = 40;
  static const xpSurvive = 50;
  static const xpVerdict = {
    'perfect': 400,
    'solid': 250,
    'partial': 120,
    'wrong': 40,
    'unsolved': 20,
  };
}

/// Modifikatoren eines Effekts. Werte werden multipliziert bzw. addiert.
class Modifiers {
  final double speed;
  final double search;
  final double light;
  final double nervesRegen;

  /// HP-Verlust: alle `hpDrainMs` 1 HP.
  final int hpDrainMs;

  /// NPCs verweigern das Gespräch.
  final bool silenced;

  /// Der Schatten greift nicht an.
  final bool protected;

  /// Sieht `blood`-Hotspots.
  final bool sight;

  const Modifiers({
    this.speed = 1,
    this.search = 1,
    this.light = 1,
    this.nervesRegen = 0,
    this.hpDrainMs = 0,
    this.silenced = false,
    this.protected = false,
    this.sight = false,
  });
}

class EffectDef {
  final String id;
  final bool buff;

  /// Standard-Dauer in ms; 0 = bis entfernt (oder Aura, jeden Tick neu berechnet).
  final int durationMs;
  final Modifiers mods;

  const EffectDef(this.id, this.buff, this.durationMs, this.mods);
}

/// Alle Buffs und Debuffs. Texte kommen aus der App-Lokalisierung (`effect_<id>`).
const effectCatalog = <String, EffectDef>{
  // Buffs
  'caffeine': EffectDef('caffeine', true, 45000, Modifiers(speed: 1.3, search: 1.15)),
  'teamgeist': EffectDef('teamgeist', true, 0, Modifiers(search: 1.25, nervesRegen: 3, protected: true)),
  'adrenaline': EffectDef('adrenaline', true, 8000, Modifiers(speed: 1.45)),
  'eagle_eye': EffectDef('eagle_eye', true, 15000, Modifiers(sight: true, search: 1.3)),
  'focused': EffectDef('focused', true, 12000, Modifiers(nervesRegen: 10, search: 1.2)),
  'bright': EffectDef('bright', true, 0, Modifiers(light: 1.6)),
  'hidden': EffectDef('hidden', true, 0, Modifiers(protected: true, speed: 0)),
  // Debuffs
  'injured': EffectDef('injured', false, 0, Modifiers(speed: 0.75)),
  'panic': EffectDef('panic', false, 0, Modifiers(light: 0.6, search: 0.6)),
  'poisoned': EffectDef('poisoned', false, 0, Modifiers(hpDrainMs: 60000)),
  'blinded': EffectDef('blinded', false, 9000, Modifiers(light: 0.3)),
  'suspicious': EffectDef('suspicious', false, 30000, Modifiers(silenced: true)),
};

/// Detektiv-Klassen. Fähigkeiten werden in der Engine über die `ability`-ID ausgeführt.
class DetectiveClass {
  final String id;
  final int maxHp;
  final double reviveMul;
  final double labMul;

  /// Sieht Lügen-Markierung in Verhören.
  final bool seesLies;

  /// Hat das Thema `rumor`.
  final bool rumors;

  final String ability;
  final int abilityCooldownMs;

  /// Einsätze pro Nacht (0 = unbegrenzt, nur Cooldown).
  final int chargesPerNight;

  /// Ab welchem Rang freigeschaltet (Meta-Progression).
  final int unlockRank;

  const DetectiveClass({
    required this.id,
    this.maxHp = Tuning.baseHp,
    this.reviveMul = 1,
    this.labMul = 1,
    this.seesLies = false,
    this.rumors = false,
    required this.ability,
    required this.abilityCooldownMs,
    this.chargesPerNight = 0,
    this.unlockRank = 0,
  });
}

const detectiveClasses = <String, DetectiveClass>{
  'forensic': DetectiveClass(
    id: 'forensic',
    labMul: 0.5,
    ability: 'scan', // eagle_eye auf sich selbst
    abilityCooldownMs: 60000,
  ),
  'profiler': DetectiveClass(
    id: 'profiler',
    seesLies: true,
    ability: 'calm', // focused für alle in groupRadius, heilt panic
    abilityCooldownMs: 45000,
  ),
  'excop': DetectiveClass(
    id: 'excop',
    maxHp: 4,
    ability: 'scare', // Schatten in 4.5 Kacheln flieht
    abilityCooldownMs: 20000,
    chargesPerNight: 1,
    unlockRank: 2,
  ),
  'journalist': DetectiveClass(
    id: 'journalist',
    rumors: true,
    ability: 'sources', // markiert den Ort eines ungefundenen Hinweises
    abilityCooldownMs: 90000,
    unlockRank: 1,
  ),
  'medic': DetectiveClass(
    id: 'medic',
    reviveMul: 0.5,
    ability: 'firstaid', // +1 HP, entfernt injured/poisoned beim nächsten Detektiv
    abilityCooldownMs: 40000,
    unlockRank: 3,
  ),
};

/// Item-Wirkungen (Engine), Typen siehe `ItemType`.
const itemEffects = <String, String>{
  'coffee': 'caffeine',
  'battery': 'bright',
  'salts': 'focused',
};

/// Farbpalette für Detektiv-Mäntel (Index im Loadout).
const detectiveCoats = <String>[
  '#b23a48', '#3a6ea5', '#4f8a3f', '#c08a2e', '#7a4fa0', '#2f8f8a', '#c45a9a', '#6b6b6b',
];

const detectiveHats = <String>['fedora', 'bowler', 'cap', 'beret', 'cloche', 'top', 'none'];

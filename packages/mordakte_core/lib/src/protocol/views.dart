import '../model/rules.dart';
import '../scenario/scenario_def.dart';

/// Was ein Client sieht. Zwei Teile:
/// - [WorldSnapshot]: Positionen & Lebenswerte, ~10× pro Sekunde.
/// - [CaseView]: Fall-Zustand (Notizbuch, Beweiswand, Abstimmungen …), nur bei Änderung.
///
/// Beides wird pro Spieler projiziert: private Hinweise anderer Spieler und der
/// Schatten außerhalb der eigenen Sicht werden nie übertragen.

Phase _phase(Object? j) => Phase.values.byName(j as String);
double _d(Object? j) => (j as num).toDouble();
int _i(Object? j) => (j as num).toInt();
double _r(double v) => (v * 100).roundToDouble() / 100;
List<T> _l<T>(Object? j, T Function(Map<String, dynamic>) f) =>
    [for (final e in (j as List? ?? const [])) f((e as Map).cast<String, dynamic>())];

class WorldSnapshot {
  /// Laufzeit des Raums in ms.
  final int t;
  final Phase phase;
  final int chapter;
  final int phaseRemainingMs;
  final int phaseTotalMs;
  final List<DetectiveView> detectives;
  final List<NpcView> npcs;

  /// Nur gesetzt, wenn der Betrachter den Schatten sehen/hören kann.
  final ShadowView? shadow;
  final List<SignalView> signals;

  /// Letzte akzeptierte Bewegungs-Sequenz des Betrachters.
  final int ackSeq;

  /// Gesetzt, wenn die Runtime eine Bewegung abgelehnt hat → Client springt zurück.
  final double? correctX;
  final double? correctY;

  const WorldSnapshot({
    required this.t,
    required this.phase,
    required this.chapter,
    required this.phaseRemainingMs,
    required this.phaseTotalMs,
    required this.detectives,
    required this.npcs,
    required this.shadow,
    required this.signals,
    required this.ackSeq,
    this.correctX,
    this.correctY,
  });

  DetectiveView? detective(String id) {
    for (final d in detectives) {
      if (d.id == id) return d;
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        't': t,
        'phase': phase.name,
        'ch': chapter,
        'rem': phaseRemainingMs,
        'tot': phaseTotalMs,
        'det': [for (final d in detectives) d.toJson()],
        'npc': [for (final n in npcs) n.toJson()],
        if (shadow != null) 'sh': shadow!.toJson(),
        'sig': [for (final s in signals) s.toJson()],
        'ack': ackSeq,
        if (correctX != null) 'cx': _r(correctX!),
        if (correctY != null) 'cy': _r(correctY!),
      };

  factory WorldSnapshot.fromJson(Map<String, dynamic> j) => WorldSnapshot(
        t: _i(j['t']),
        phase: _phase(j['phase']),
        chapter: _i(j['ch']),
        phaseRemainingMs: _i(j['rem']),
        phaseTotalMs: _i(j['tot']),
        detectives: _l(j['det'], DetectiveView.fromJson),
        npcs: _l(j['npc'], NpcView.fromJson),
        shadow: j['sh'] == null ? null : ShadowView.fromJson((j['sh'] as Map).cast()),
        signals: _l(j['sig'], SignalView.fromJson),
        ackSeq: _i(j['ack']),
        correctX: (j['cx'] as num?)?.toDouble(),
        correctY: (j['cy'] as num?)?.toDouble(),
      );
}

/// Laufende Kanal-Aktion (Durchsuchen, Labor, Wiederbeleben).
class ChannelView {
  /// `search`, `lab`, `revive`
  final String kind;
  final String target;
  final double progress;

  const ChannelView({required this.kind, required this.target, required this.progress});

  Map<String, dynamic> toJson() => {'k': kind, 'tg': target, 'p': _r(progress)};

  factory ChannelView.fromJson(Map<String, dynamic> j) =>
      ChannelView(kind: j['k'] as String, target: j['tg'] as String, progress: _d(j['p']));
}

class DetectiveView {
  final String id;
  final String name;
  final String cls;
  final int coat;
  final String hat;
  final bool bot;
  final bool connected;
  final double x;
  final double y;
  final double facing;
  final LifeState life;
  final int hp;
  final int maxHp;
  final int nerves;
  final bool hidden;
  final bool moving;
  final ChannelView? channel;
  final List<String> effects;
  final int downedLeftMs;

  const DetectiveView({
    required this.id,
    required this.name,
    required this.cls,
    required this.coat,
    required this.hat,
    required this.bot,
    required this.connected,
    required this.x,
    required this.y,
    required this.facing,
    required this.life,
    required this.hp,
    required this.maxHp,
    required this.nerves,
    required this.hidden,
    required this.moving,
    required this.channel,
    required this.effects,
    required this.downedLeftMs,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'n': name,
        'c': cls,
        'co': coat,
        'h': hat,
        if (bot) 'b': true,
        if (!connected) 'dc': true,
        'x': _r(x),
        'y': _r(y),
        'f': _r(facing),
        'l': life.name,
        'hp': hp,
        'mhp': maxHp,
        'nv': nerves,
        if (hidden) 'hd': true,
        if (moving) 'mv': true,
        if (channel != null) 'ch': channel!.toJson(),
        if (effects.isNotEmpty) 'fx': effects,
        if (downedLeftMs > 0) 'dl': downedLeftMs,
      };

  factory DetectiveView.fromJson(Map<String, dynamic> j) => DetectiveView(
        id: j['id'] as String,
        name: j['n'] as String,
        cls: j['c'] as String,
        coat: _i(j['co']),
        hat: j['h'] as String,
        bot: j['b'] == true,
        connected: j['dc'] != true,
        x: _d(j['x']),
        y: _d(j['y']),
        facing: _d(j['f']),
        life: LifeState.values.byName(j['l'] as String),
        hp: _i(j['hp']),
        maxHp: _i(j['mhp']),
        nerves: _i(j['nv']),
        hidden: j['hd'] == true,
        moving: j['mv'] == true,
        channel: j['ch'] == null ? null : ChannelView.fromJson((j['ch'] as Map).cast()),
        effects: (j['fx'] as List? ?? const []).cast<String>(),
        downedLeftMs: _i(j['dl'] ?? 0),
      );
}

class NpcView {
  final String id;
  final double x;
  final double y;
  final bool alive;

  /// Spieler-ID, mit der der NPC gerade spricht.
  final String? talkingTo;

  const NpcView({required this.id, required this.x, required this.y, required this.alive, this.talkingTo});

  Map<String, dynamic> toJson() => {
        'id': id,
        'x': _r(x),
        'y': _r(y),
        if (!alive) 'dead': true,
        if (talkingTo != null) 'tt': talkingTo,
      };

  factory NpcView.fromJson(Map<String, dynamic> j) => NpcView(
        id: j['id'] as String,
        x: _d(j['x']),
        y: _d(j['y']),
        alive: j['dead'] != true,
        talkingTo: j['tt'] as String?,
      );
}

class ShadowView {
  final double x;
  final double y;

  /// `roam`, `hunt`, `flee`, `attack`
  final String mode;

  const ShadowView({required this.x, required this.y, required this.mode});

  Map<String, dynamic> toJson() => {'x': _r(x), 'y': _r(y), 'm': mode};

  factory ShadowView.fromJson(Map<String, dynamic> j) =>
      ShadowView(x: _d(j['x']), y: _d(j['y']), mode: j['m'] as String);
}

class SignalView {
  final String by;
  final String kind;
  final String value;
  final double? x;
  final double? y;
  final int ageMs;

  const SignalView({required this.by, required this.kind, required this.value, this.x, this.y, required this.ageMs});

  Map<String, dynamic> toJson() => {
        'by': by,
        'k': kind,
        'v': value,
        if (x != null) 'x': _r(x!),
        if (y != null) 'y': _r(y!),
        'a': ageMs,
      };

  factory SignalView.fromJson(Map<String, dynamic> j) => SignalView(
        by: j['by'] as String,
        kind: j['k'] as String,
        value: j['v'] as String,
        x: (j['x'] as num?)?.toDouble(),
        y: (j['y'] as num?)?.toDouble(),
        ageMs: _i(j['a']),
      );
}

// ---------------------------------------------------------------------------

class LobbyPlayer {
  final String id;
  final String name;
  final String cls;
  final int coat;
  final String hat;
  final bool ready;
  final bool bot;
  final bool connected;

  const LobbyPlayer({
    required this.id,
    required this.name,
    required this.cls,
    required this.coat,
    required this.hat,
    required this.ready,
    required this.bot,
    required this.connected,
  });

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'cls': cls, 'coat': coat, 'hat': hat, 'ready': ready, 'bot': bot, 'conn': connected};

  factory LobbyPlayer.fromJson(Map<String, dynamic> j) => LobbyPlayer(
        id: j['id'] as String,
        name: j['name'] as String,
        cls: j['cls'] as String,
        coat: _i(j['coat']),
        hat: j['hat'] as String,
        ready: j['ready'] == true,
        bot: j['bot'] == true,
        connected: j['conn'] != false,
      );
}

/// Ein Hinweis, wie ihn ein Spieler sieht.
class ClueView {
  /// Eindeutige ID: bei Szenario-Hinweisen die `ClueDef.id`, bei Sichtungen `sight_<n>`.
  final String id;

  /// `trait`, `motive`, `weapon`, `alibi`, `story` oder `sighting`.
  final String kind;

  /// 0 = gefunden (Text `found`), 1 = aufgedeckt (Text `reveal`).
  final int stage;

  /// `lab` oder `time`, solange noch nicht aufgedeckt.
  final String? pending;

  /// Bei `time`: Kapitel, in dem er sich aufdeckt.
  final int? revealChapter;

  /// Nur auf Stufe 1: Merkmalswert (trait/sighting), Motiv-ID, Waffen-ID,
  /// bei alibi `true`/`false` (Alibi hält / gelogen).
  final String? value;

  /// Bei trait/sighting: Merkmal-ID.
  final String? trait;

  final String foundBy;
  final String? sharedBy;

  const ClueView({
    required this.id,
    required this.kind,
    required this.stage,
    this.pending,
    this.revealChapter,
    this.value,
    this.trait,
    required this.foundBy,
    this.sharedBy,
  });

  bool get revealed => stage >= 1;

  Map<String, dynamic> toJson() => {
        'id': id,
        'k': kind,
        'st': stage,
        if (pending != null) 'pd': pending,
        if (revealChapter != null) 'rc': revealChapter,
        if (value != null) 'v': value,
        if (trait != null) 'tr': trait,
        'fb': foundBy,
        if (sharedBy != null) 'sb': sharedBy,
      };

  factory ClueView.fromJson(Map<String, dynamic> j) => ClueView(
        id: j['id'] as String,
        kind: j['k'] as String,
        stage: _i(j['st']),
        pending: j['pd'] as String?,
        revealChapter: (j['rc'] as num?)?.toInt(),
        value: j['v'] as String?,
        trait: j['tr'] as String?,
        foundBy: j['fb'] as String,
        sharedBy: j['sb'] as String?,
      );
}

class ItemView {
  final String id;
  final String type;
  final double x;
  final double y;

  const ItemView({required this.id, required this.type, required this.x, required this.y});

  Map<String, dynamic> toJson() => {'id': id, 't': type, 'x': x, 'y': y};

  factory ItemView.fromJson(Map<String, dynamic> j) =>
      ItemView(id: j['id'] as String, type: j['t'] as String, x: _d(j['x']), y: _d(j['y']));
}

class AccuseVote {
  final String culprit;
  final String? motive;
  final String? weapon;

  const AccuseVote({required this.culprit, this.motive, this.weapon});

  Map<String, dynamic> toJson() => {'c': culprit, 'm': motive, 'w': weapon};

  factory AccuseVote.fromJson(Map<String, dynamic> j) =>
      AccuseVote(culprit: j['c'] as String, motive: j['m'] as String?, weapon: j['w'] as String?);
}

/// Hotspot-Zustand aus Sicht eines Spielers.
abstract final class HotspotState {
  /// Kann durchsucht werden (evtl. leer).
  static const open = 'open';

  /// Wurde schon durchsucht und ist leer.
  static const searched = 'searched';

  /// Hat für diesen Spieler noch etwas (z. B. erst ab einer Klasse) – Marker leuchtet.
  static const fresh = 'fresh';
}

class EndingView {
  /// `perfect`, `solid`, `partial`, `wrong`, `unsolved`
  final String verdict;

  /// `all`, `some`, `lone`, `none`
  final String team;
  final bool secret;
  final bool caught;
  final CaseTruthDef truth;
  final AccuseVote? accused;
  final int strength;

  /// Eindeutige ID für die Enden-Sammlung, z. B. `perfect.all.butler.secret`.
  final String endingId;
  final Map<String, List<String>> awards;
  final Map<String, int> xp;
  final Map<String, Map<String, int>> stats;
  final List<String> survivors;
  final int witnessesAlive;

  const EndingView({
    required this.verdict,
    required this.team,
    required this.secret,
    required this.caught,
    required this.truth,
    required this.accused,
    required this.strength,
    required this.endingId,
    required this.awards,
    required this.xp,
    required this.stats,
    required this.survivors,
    required this.witnessesAlive,
  });

  Map<String, dynamic> toJson() => {
        'verdict': verdict,
        'team': team,
        'secret': secret,
        'caught': caught,
        'truth': truth.toJson(),
        'accused': accused?.toJson(),
        'strength': strength,
        'endingId': endingId,
        'awards': awards,
        'xp': xp,
        'stats': stats,
        'survivors': survivors,
        'witnesses': witnessesAlive,
      };

  factory EndingView.fromJson(Map<String, dynamic> j) => EndingView(
        verdict: j['verdict'] as String,
        team: j['team'] as String,
        secret: j['secret'] == true,
        caught: j['caught'] == true,
        truth: CaseTruthDef.fromJson((j['truth'] as Map).cast()),
        accused: j['accused'] == null ? null : AccuseVote.fromJson((j['accused'] as Map).cast()),
        strength: _i(j['strength']),
        endingId: j['endingId'] as String,
        awards: {
          for (final e in (j['awards'] as Map).entries) e.key as String: (e.value as List).cast<String>(),
        },
        xp: {for (final e in (j['xp'] as Map).entries) e.key as String: _i(e.value)},
        stats: {
          for (final e in (j['stats'] as Map).entries)
            e.key as String: {for (final f in (e.value as Map).entries) f.key as String: _i(f.value)},
        },
        survivors: (j['survivors'] as List).cast<String>(),
        witnessesAlive: _i(j['witnesses']),
      );
}

class CaseView {
  /// Steigt bei jeder Änderung.
  final int version;
  final String roomCode;
  final String hostId;
  final String? scenarioId;

  /// `story`, `random`, `daily`
  final String mode;

  /// Nur im Tagesfall gesetzt (öffentlich); sonst 0, damit kein Client die Wahrheit nachrechnen kann.
  final int seed;
  final int bots;
  final List<LobbyPlayer> lobby;
  final Phase phase;
  final int chapter;

  /// Eigene, noch nicht geteilte Hinweise.
  final List<ClueView> notebook;

  /// Geteilte Hinweise des Teams.
  final List<ClueView> board;

  /// Gefundene Kombinationen (Combo-IDs).
  final List<String> deductions;
  final int contradictions;

  /// Verdächtige (NPC-IDs), die sich bereits in Widersprüche verstrickt haben.
  final List<String> contradicted;

  /// Sichtbare Hotspots → [HotspotState].
  final Map<String, String> hotspots;

  /// Freigeschaltete Türen (Kacheln), die vorher `L` waren.
  final List<List<int>> openDoors;
  final List<ItemView> items;
  final List<String> inventory;

  /// Spuren-Optionen der aktuellen Beratung, Stimmen (Spieler → Spur) und bisher gewählte Spuren.
  final List<String> leadOptions;
  final Map<String, String> leadVotes;
  final List<String> chosenLeads;

  final Map<String, AccuseVote> accusations;

  /// Bereits gehörte Themen pro NPC (für alle sichtbar).
  final Map<String, List<String>> heard;
  final List<String> deadNpcs;

  final int abilityCooldownMs;
  final int abilityCharges;
  final int pingsLeft;
  final EndingView? ending;

  const CaseView({
    required this.version,
    required this.roomCode,
    required this.hostId,
    required this.scenarioId,
    required this.mode,
    required this.seed,
    required this.bots,
    required this.lobby,
    required this.phase,
    required this.chapter,
    required this.notebook,
    required this.board,
    required this.deductions,
    required this.contradictions,
    this.contradicted = const [],
    required this.hotspots,
    required this.openDoors,
    required this.items,
    required this.inventory,
    required this.leadOptions,
    required this.leadVotes,
    required this.chosenLeads,
    required this.accusations,
    required this.heard,
    required this.deadNpcs,
    required this.abilityCooldownMs,
    required this.abilityCharges,
    required this.pingsLeft,
    required this.ending,
  });

  ClueView? clue(String id) {
    for (final c in board) {
      if (c.id == id) return c;
    }
    for (final c in notebook) {
      if (c.id == id) return c;
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'room': roomCode,
        'host': hostId,
        'scenario': scenarioId,
        'mode': mode,
        'seed': seed,
        'bots': bots,
        'lobby': [for (final p in lobby) p.toJson()],
        'phase': phase.name,
        'chapter': chapter,
        'notebook': [for (final c in notebook) c.toJson()],
        'board': [for (final c in board) c.toJson()],
        'deductions': deductions,
        'contra': contradictions,
        'contraIds': contradicted,
        'hotspots': hotspots,
        'doors': openDoors,
        'items': [for (final i in items) i.toJson()],
        'inv': inventory,
        'leadOptions': leadOptions,
        'leadVotes': leadVotes,
        'chosenLeads': chosenLeads,
        'accuse': {for (final e in accusations.entries) e.key: e.value.toJson()},
        'heard': heard,
        'deadNpcs': deadNpcs,
        'abilityCd': abilityCooldownMs,
        'abilityCharges': abilityCharges,
        'pings': pingsLeft,
        if (ending != null) 'ending': ending!.toJson(),
      };

  factory CaseView.fromJson(Map<String, dynamic> j) => CaseView(
        version: _i(j['version']),
        roomCode: j['room'] as String,
        hostId: j['host'] as String,
        scenarioId: j['scenario'] as String?,
        mode: j['mode'] as String,
        seed: _i(j['seed']),
        bots: _i(j['bots']),
        lobby: _l(j['lobby'], LobbyPlayer.fromJson),
        phase: _phase(j['phase']),
        chapter: _i(j['chapter']),
        notebook: _l(j['notebook'], ClueView.fromJson),
        board: _l(j['board'], ClueView.fromJson),
        deductions: (j['deductions'] as List).cast<String>(),
        contradictions: _i(j['contra']),
        contradicted: ((j['contraIds'] as List?) ?? const []).cast<String>(),
        hotspots: (j['hotspots'] as Map).cast<String, String>(),
        openDoors: [for (final d in (j['doors'] as List)) (d as List).cast<int>()],
        items: _l(j['items'], ItemView.fromJson),
        inventory: (j['inv'] as List).cast<String>(),
        leadOptions: (j['leadOptions'] as List).cast<String>(),
        leadVotes: (j['leadVotes'] as Map).cast<String, String>(),
        chosenLeads: (j['chosenLeads'] as List).cast<String>(),
        accusations: {
          for (final e in (j['accuse'] as Map).entries)
            e.key as String: AccuseVote.fromJson((e.value as Map).cast()),
        },
        heard: {
          for (final e in (j['heard'] as Map).entries) e.key as String: (e.value as List).cast<String>(),
        },
        deadNpcs: (j['deadNpcs'] as List).cast<String>(),
        abilityCooldownMs: _i(j['abilityCd']),
        abilityCharges: _i(j['abilityCharges']),
        pingsLeft: _i(j['pings']),
        ending: j['ending'] == null ? null : EndingView.fromJson((j['ending'] as Map).cast()),
      );
}

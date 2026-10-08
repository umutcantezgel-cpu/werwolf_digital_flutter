library;

import 'dart:math' as math;

import '../model/rules.dart';
import '../protocol/commands.dart';
import '../protocol/events.dart';
import '../protocol/messages.dart';
import '../protocol/views.dart';
import '../scenario/catalog.dart';
import '../scenario/grid.dart';
import '../scenario/scenario_def.dart';
import '../util/geom.dart';
import '../util/rng.dart';
import 'case_generator.dart';
import 'state.dart';

part 'shadow.dart';
part 'bots.dart';
part 'endings.dart';

const _botNames = ['Mila', 'Jonas', 'Aylin', 'Theo', 'Greta', 'Emil', 'Nele', 'Karim'];
const _botClassOrder = ['profiler', 'medic', 'excop', 'journalist', 'forensic'];

class _Signal {
  final String by;
  final String kind;
  final String value;
  final double? x;
  final double? y;
  final int at;
  _Signal(this.by, this.kind, this.value, this.x, this.y, this.at);
}

class _MapItem {
  final ItemDef def;
  _MapItem(this.def);
  double get x => def.x + 0.5;
  double get y => def.y + 0.5;
}

/// Die Spiel-Engine hinter `RoomRuntime`. Alle Regeln laufen hier.
class Engine {
  Engine({required this.roomCode, required this.scenarios, int? clockSeed})
      : _rng = Rng(clockSeed ?? DateTime.now().microsecondsSinceEpoch);

  final String roomCode;
  final Map<String, ScenarioDef> scenarios;
  final Rng _rng;

  final Map<String, PlayerState> _players = {};
  final Map<String, List<GameEvent>> _queues = {};
  final Map<String, bool> _dirty = {};
  final Map<String, _Brain> _brains = {};
  String _hostId = '';
  int _now = 0;

  /// Monoton steigende Version der Fall-Ansicht (nicht die Uhr: mehrere
  /// Ansichten im selben Tick müssen unterscheidbar bleiben).
  int _caseVersion = 0;

  // Konfiguration (Lobby)
  String? _scenarioId;
  String _mode = 'story';
  int _seed = 0;
  int _botCount = 0;

  // Laufendes Spiel
  Phase _phase = Phase.lobby;
  int _phaseRemaining = 0;
  int _phaseTotal = 0;
  int _chapter = 0;
  ScenarioDef? _s;
  TileGrid? _grid;
  CaseTruth? _truth;
  Rng _rt = Rng(1);
  final List<NpcState> _npcs = [];
  final Map<String, NpcState> _npcById = {};
  final Map<String, ClueInst> _clues = {};
  final Set<String> _expired = {};
  final Map<String, String> _searchedBy = {};
  final Set<String> _unlockedHotspots = {};
  final List<String> _chosenLeads = [];
  final Set<String> _pendingHiddenLeads = {};
  List<String> _leadOptions = [];
  final Map<String, String> _leadVotes = {};
  final List<String> _deductions = [];
  final Set<String> _contradicted = {};
  final Map<String, Set<String>> _heard = {};
  final Map<String, _MapItem> _items = {};
  final Set<String> _spawnedItems = {};
  final Map<String, AccuseVote> _accuse = {};
  final List<_Signal> _signals = [];
  _Shadow? _shadow;
  EndingView? _ending;
  int _sightings = 0;
  int _nightElapsed = 0;
  int _traces = 0;

  /// Spieler-ID → Schatten-Spuren, die dieser Spieler schon gesehen hat.
  final Map<String, Set<String>> _seenTraces = {};

  // ---------------------------------------------------------------- Abfragen

  List<String> get humanPlayerIds => [for (final p in _players.values) if (!p.bot) p.id];
  bool get inLobby => _phase == Phase.lobby;
  bool get finished => _phase == Phase.ending;
  Phase get phase => _phase;
  int get chapter => _chapter;
  ScenarioDef? get scenario => _s;
  CaseTruthDef? get truth => _truth?.truth;
  EndingView? get ending => _ending;

  /// Nur für Tests und Werkzeuge: direkter Zugriff auf den Spielerzustand.
  PlayerState? debugPlayer(String playerId) => _players[playerId];

  /// Nur für Tests und Werkzeuge: lässt einen Spieler sterben (wird zum Geist).
  void debugKill(String playerId) {
    final p = _players[playerId];
    if (p != null) _die(p);
  }

  Iterable<PlayerState> get _aliveDetectives => _players.values.where((p) => p.alive);

  // ------------------------------------------------------------ Lobby / Join

  bool join(String playerId, String name) {
    final existing = _players[playerId];
    if (existing != null) {
      existing.name = name.isEmpty ? existing.name : name;
      _queues[playerId]?.clear();
      setConnected(playerId, true);
      return true;
    }
    if (_phase != Phase.lobby) return false;
    if (humanPlayerIds.length >= maxPlayersPerRoom) return false;
    final p = PlayerState(playerId, name.isEmpty ? 'Detektiv' : _clip(name, 16));
    final usedCoats = _players.values.map((e) => e.coat).toSet();
    p.coat = List.generate(detectiveCoats.length, (i) => i).firstWhere((i) => !usedCoats.contains(i), orElse: () => 0);
    p.cls = _players.isEmpty ? 'forensic' : 'profiler';
    _players[playerId] = p;
    _queues[playerId] = [];
    if (_hostId.isEmpty || !_players.containsKey(_hostId)) _hostId = playerId;
    _dirtyAll();
    return true;
  }

  void leave(String playerId) {
    final p = _players[playerId];
    if (p == null) return;
    if (_phase == Phase.lobby) {
      _players.remove(playerId);
      _queues.remove(playerId);
      _dirty.remove(playerId);
      if (_hostId == playerId) _hostId = humanPlayerIds.isEmpty ? '' : humanPlayerIds.first;
      _dirtyAll();
    } else {
      setConnected(playerId, false);
      if (_hostId == playerId) {
        final next = _players.values.where((e) => !e.bot && e.connected).map((e) => e.id);
        if (next.isNotEmpty) _hostId = next.first;
      }
    }
  }

  void setConnected(String playerId, bool connected) {
    final p = _players[playerId];
    if (p == null || p.bot) return;
    p.connected = connected;
    if (connected) {
      p.disconnectedMs = 0;
      p.autopilot = false;
      // Eingefrorenes Autopilot-Gehirn verwerfen, sonst blockiert sein altes Ziel die Bots.
      _brains.remove(playerId);
      _dirty[playerId] = true;
    }
    _dirtyAll();
  }

  /// Bot-Steuerung für einen menschlichen Spieler (Simulation, Autoplay-Screenshots).
  void setAutopilot(String playerId, bool on) {
    final p = _players[playerId];
    if (p != null) p.autopilot = on;
  }

  // ---------------------------------------------------------------- Bewegung

  void applyMove(String playerId, MoveInput m) {
    final p = _players[playerId];
    final grid = _grid;
    if (p == null || p.bot || grid == null) return;
    if (m.seq <= p.ackSeq) {
      // Veraltete Sequenz (z. B. neuer Client nach Neustart): sofort zurücksetzen
      // statt still zu verwerfen, damit der Client nicht auseinanderläuft.
      if (_phase != Phase.lobby && _phase != Phase.ending) _correct(p);
      return;
    }
    p.ackSeq = m.seq;
    if (_phase == Phase.lobby || _phase == Phase.ending) return;
    if (p.downed || p.hidden) {
      _correct(p);
      return;
    }
    final dt = (_now - p.lastMoveAt).clamp(Tuning.tickMs, 1000);
    final maxDist = Tuning.playerSpeed * math.max(1.0, p.speedMul) * dt / 1000 * Tuning.moveTolerance + 0.35;
    final d = dist(p.x, p.y, m.x, m.y);
    var ok = d <= maxDist && m.x.isFinite && m.y.isFinite;
    if (ok) {
      final (sx, sy) = grid.slide(p.x, p.y, m.x - p.x, m.y - p.y, Tuning.playerRadius * 0.85);
      ok = dist(sx, sy, m.x, m.y) < 0.2;
    }
    p.lastMoveAt = _now;
    if (!ok) {
      _correct(p);
      return;
    }
    if (d > 0.01) {
      p.moving = true;
      p.movingUntil = _now + 250;
    }
    p.x = m.x;
    p.y = m.y;
    p.facing = m.facing;
    _afterMove(p);
  }

  void _correct(PlayerState p) {
    p.correctX = p.x;
    p.correctY = p.y;
  }

  void _afterMove(PlayerState p) {
    final ch = p.channel;
    if (ch != null && dist(ch.startX, ch.startY, p.x, p.y) > 0.3) p.channel = null;
  }

  // ---------------------------------------------------------------- Befehle

  void applyCommand(String playerId, Command c) {
    final p = _players[playerId];
    if (p == null) return;
    switch (c) {
      case SetLoadout(:final cls, :final coat, :final hat):
        if (_phase != Phase.lobby && _phase != Phase.ending) return;
        if (detectiveClasses.containsKey(cls)) p.cls = cls;
        final taken = _players.values.any((o) => o != p && o.coat == coat);
        if (coat >= 0 && coat < detectiveCoats.length && !taken) p.coat = coat;
        if (detectiveHats.contains(hat)) p.hat = hat;
        _dirtyAll();
      case SetReady(:final ready):
        if (_phase == Phase.lobby || _phase == Phase.intro) {
          p.ready = ready;
          _dirtyAll();
        }
      case ConfigureGame(:final scenarioId, :final mode, :final seed, :final bots):
        if (playerId != _hostId || (_phase != Phase.lobby && _phase != Phase.ending)) return _err(p, 'not_host');
        if (!scenarios.containsKey(scenarioId)) return _err(p, 'unknown_scenario');
        _scenarioId = scenarioId;
        _mode = const {'story', 'random', 'daily'}.contains(mode) ? mode : 'random';
        // Zufallsfälle würfelt nur der Server – ein Client-Seed würde die Wahrheit vorab festlegen.
        _seed = switch (_mode) {
          'story' => 0,
          'daily' => seed ?? _rng.nextUint32(),
          _ => _rng.nextUint32(),
        };
        _botCount = bots.clamp(0, maxPlayersPerRoom - 1);
        _dirtyAll();
      case StartGame():
        if (playerId != _hostId || (_phase != Phase.lobby && _phase != Phase.ending)) return _err(p, 'not_host');
        if (_scenarioId == null) return _err(p, 'unknown_scenario');
        _startGame();
      case Interact(:final target):
        _interact(p, target);
      case CancelAction():
        p.channel = null;
      case AskTopic(:final npc, :final topic):
        _ask(p, npc, topic);
      case PresentClue(:final npc, :final clue):
        _present(p, npc, clue);
      case ShareClue(:final clue):
        _share(p, clue);
      case Combine(:final a, :final b):
        _combine(p, a, b);
      case VoteLead(:final lead):
        if (_phase != Phase.council || !_leadOptions.contains(lead) || p.downed) return;
        // Geänderte Stimme rückt ans Ende: Gleichstände entscheidet die früheste aktuelle Stimme.
        if (_leadVotes[p.id] != lead) _leadVotes.remove(p.id);
        _leadVotes[p.id] = lead;
        _dirtyAll();
      case Accuse(:final culprit, :final motive, :final weapon):
        final s = _s;
        if (_phase != Phase.accusation || s == null || !s.suspectById.containsKey(culprit)) return;
        if (_accuse[p.id]?.culprit != culprit) _accuse.remove(p.id);
        _accuse[p.id] = AccuseVote(
          culprit: culprit,
          motive: s.motiveById.containsKey(motive) ? motive : null,
          weapon: s.weaponById.containsKey(weapon) ? weapon : null,
        );
        _dirtyAll();
      case UseAbility():
        _ability(p);
      case UseItem(:final slot):
        _useItem(p, slot);
      case Signal(:final kind, :final value, :final x, :final y):
        _signal(p, kind, value, x, y);
    }
  }

  // ----------------------------------------------------------- Spielstart

  void _startGame() {
    final s = scenarios[_scenarioId]!;
    _s = s;
    _grid = TileGrid(s.map);
    _truth = CaseTruth(CaseGenerator.generate(s, mode: _mode, seed: _seed), s);
    _rt = Rng(_seed ^ _rng.nextUint32());

    // Bots neu aufstellen.
    for (final id in _players.values.where((p) => p.bot).map((p) => p.id).toList()) {
      _players.remove(id);
      _brains.remove(id);
    }
    final humans = _players.values.toList();
    final botSlots = math.min(_botCount, maxPlayersPerRoom - humans.length);
    final usedCls = humans.map((h) => h.cls).toSet();
    final usedCoats = humans.map((h) => h.coat).toSet();
    final names = List.of(_botNames)..removeWhere((n) => humans.any((h) => h.name == n));
    for (var i = 0; i < botSlots; i++) {
      final b = PlayerState('bot_$i', names[i % names.length], bot: true)..autopilot = true;
      b.cls = _botClassOrder.firstWhere((c) => !usedCls.contains(c), orElse: () => _botClassOrder[i % 5]);
      usedCls.add(b.cls);
      b.coat = List.generate(detectiveCoats.length, (k) => k).firstWhere((k) => !usedCoats.contains(k), orElse: () => i);
      usedCoats.add(b.coat);
      b.hat = detectiveHats[(i + 2) % detectiveHats.length];
      _players[b.id] = b;
    }

    // Laufzeit-Zustand zurücksetzen.
    _npcs
      ..clear()
      ..addAll(s.suspects.map(NpcState.new));
    _npcById
      ..clear()
      ..addEntries(_npcs.map((n) => MapEntry(n.id, n)));
    _clues.clear();
    _expired.clear();
    _searchedBy.clear();
    _unlockedHotspots.clear();
    _chosenLeads.clear();
    _pendingHiddenLeads.clear();
    _leadOptions = [];
    _leadVotes.clear();
    _deductions.clear();
    _contradicted.clear();
    _heard.clear();
    _items.clear();
    _spawnedItems.clear();
    _accuse.clear();
    _signals.clear();
    _brains.clear();
    _seenTraces.clear();
    _shadow = null;
    _ending = null;
    _sightings = 0;

    var i = 0;
    for (final p in _players.values) {
      final sp = s.map.spawn[i++ % s.map.spawn.length];
      p
        ..x = sp.x + 0.5
        ..y = sp.y + 0.5
        ..facing = 0
        ..life = LifeState.alive
        ..maxHp = p.detectiveClass.maxHp
        ..hp = p.detectiveClass.maxHp
        ..nerves = Tuning.nervesMax
        ..downedLeftMs = 0
        ..hidden = false
        ..channel = null
        ..abilityCdMs = 0
        ..poisonTimerMs = 0
        ..ready = false
        ..stats = PlayerStats();
      p.effects.clear();
      p.inventory.clear();
      if (p.bot) p.autopilot = true;
      _correct(p);
    }
    _chapter = 1;
    _startChapter();
  }

  void _startChapter() {
    final s = _s!;
    for (final item in s.items) {
      if (item.chapter <= _chapter && !_spawnedItems.contains(item.id) && _itemUnlocked(item.id)) {
        _spawnedItems.add(item.id);
        _items[item.id] = _MapItem(item);
      }
    }
    _revealTimeClues(_chapter);
    for (final p in _players.values) {
      p.ready = false;
      p.pingsLeft = Tuning.pingsPerChapter;
      p.abilityCharges = p.detectiveClass.chargesPerNight;
      p.effects.remove('bright');
    }
    _enterPhase(Phase.intro, Tuning.introMs);
  }

  bool _itemUnlocked(String itemId) {
    final s = _s!;
    final lockedBy = s.leadById.values.where((l) => l.unlock.items.contains(itemId));
    if (lockedBy.isEmpty) return true;
    return lockedBy.any((l) => _chosenLeads.contains(l.id));
  }

  void _enterPhase(Phase phase, int ms) {
    _phase = phase;
    _phaseRemaining = ms;
    _phaseTotal = ms;
    _emit(GameEvent(Ev.phase, args: {'phase': phase.name, 'chapter': _chapter}));
    _dirtyAll();
  }

  void _teleportToCouncil() {
    final s = _s!;
    var i = 0;
    for (final p in _players.values) {
      final sp = s.map.spawn[i++ % s.map.spawn.length];
      p
        ..x = sp.x + 0.5
        ..y = sp.y + 0.5
        ..hidden = false
        ..channel = null;
      p.effects.remove('hidden');
      _correct(p);
    }
  }

  void _advancePhase() {
    switch (_phase) {
      case Phase.intro:
        _enterPhase(Phase.investigation, Tuning.investigationMs);
      case Phase.investigation:
        _fadeExpiring();
        if (_chapter < _s!.chapters.length) {
          _enterCouncil();
        } else {
          _enterAccusation();
        }
      case Phase.council:
        _resolveLeadVote();
        _enterNight();
      case Phase.night:
        _endNight();
        _chapter++;
        _startChapter();
      case Phase.accusation:
        _finish();
      case Phase.lobby:
      case Phase.ending:
        break;
    }
  }

  void _enterCouncil() {
    _teleportToCouncil();
    _leadVotes.clear();
    _leadOptions = _computeLeadOptions();
    _enterPhase(Phase.council, _leadOptions.isEmpty ? Tuning.councilMs ~/ 3 : Tuning.councilMs);
  }

  void _enterAccusation() {
    _teleportToCouncil();
    _revealTimeClues(_chapter + 1);
    _accuse.clear();
    _enterPhase(Phase.accusation, Tuning.accusationMs);
  }

  void _enterNight() {
    _nightElapsed = 0;
    _spawnShadow();
    _enterPhase(Phase.night, Tuning.nightMs);
  }

  void _endNight() {
    _shadow = null;
    _items.removeWhere((_, i) => i.def.type == ItemType.trace);
    _seenTraces.clear();
    for (final p in _players.values) {
      if (p.downed) {
        p
          ..life = LifeState.alive
          ..hp = 1
          ..downedLeftMs = 0
          ..nerves = 40;
        _emit(GameEvent(Ev.revived, args: {'player': p.id, 'by': 'dawn'}));
      }
      p.hidden = false;
      p.effects.remove('hidden');
    }
  }

  List<String> _computeLeadOptions() {
    final s = _s!;
    final ch = s.chapters[_chapter - 1];
    final opts = <String>[];
    for (final l in ch.leads) {
      if (l.hidden) continue;
      if (l.requiresClue != null && !(_clues[l.requiresClue]?.onBoard ?? false)) continue;
      opts.add(l.id);
    }
    opts.addAll(_pendingHiddenLeads.where((id) => !opts.contains(id)));
    return opts.where((id) => !_chosenLeads.contains(id) && _leadHasNews(s.leadById[id])).toList();
  }

  bool _leadHasNews(LeadDef? l) {
    if (l == null) return false;
    final grid = _grid!;
    return l.unlock.hotspots.any((h) => !_unlockedHotspots.contains(h)) ||
        l.unlock.doors.any((d) => !grid.openDoors.contains(d)) ||
        l.unlock.items.any((i) => !_spawnedItems.contains(i));
  }

  void _resolveLeadVote() {
    if (_leadOptions.isEmpty) return;
    // Die Menschen entscheiden: Bot-/Autopilot-Stimmen zählen nur, wenn kein Mensch gewählt hat.
    // Gleichstand unter Menschen: KI-Stimmen entscheiden, danach die früheste Stimme.
    final valid = _leadVotes.entries.where((e) => _leadOptions.contains(e.value)).toList();
    final humanVotes = [for (final e in valid) if (_isHumanVoter(e.key)) e.value];
    final aiVotes = [for (final e in valid) if (!_isHumanVoter(e.key)) e.value];
    final chosen = humanVotes.isNotEmpty
        ? _decideVote(humanVotes, aiVotes)
        : _decideVote(aiVotes, const []);
    _applyLead(chosen ?? _leadOptions.first);
  }

  /// Stimme eines Menschen, der gerade selbst spielt (kein Bot, kein Autopilot).
  bool _isHumanVoter(String playerId) {
    final p = _players[playerId];
    return p != null && !p.bot && !p.autopilot;
  }

  void _applyLead(String id) {
    final l = _s!.leadById[id];
    if (l == null) return;
    _chosenLeads.add(id);
    _pendingHiddenLeads.remove(id);
    _unlockedHotspots.addAll(l.unlock.hotspots);
    for (final d in l.unlock.doors) {
      _grid!.openDoor(d);
    }
    for (final itemId in l.unlock.items) {
      final def = _s!.itemById[itemId];
      if (def != null && !_spawnedItems.contains(itemId)) {
        _spawnedItems.add(itemId);
        _items[itemId] = _MapItem(def);
      }
    }
    _emit(GameEvent(Ev.leadChosen, args: {'lead': id}));
    _dirtyAll();
  }

  void _fadeExpiring() {
    var count = 0;
    for (final def in _s!.clues) {
      final exp = def.expires;
      if (exp != null && exp <= _chapter && !_clues.containsKey(def.id) && _expired.add(def.id)) count++;
    }
    if (count > 0) _emit(GameEvent(Ev.cluesFaded, args: {'count': count}));
  }

  void _revealTimeClues(int chapter) {
    for (final c in _clues.values) {
      if (c.pending == Evolve.time && (c.revealChapter ?? 99) <= chapter) {
        _reveal(c);
      }
    }
  }

  void _reveal(ClueInst c) {
    if (c.revealed) return;
    c.stage = 1;
    c.pending = null;
    final event = GameEvent(Ev.clueEvolved, to: c.onBoard ? null : c.holder, args: {'clue': c.id});
    _emit(event);
    _dirtyAll();
  }

  // ------------------------------------------------------------------ Tick

  void tick(int dtMs) {
    if (dtMs <= 0) return;
    final dt = math.min(dtMs, 250);
    _now += dt;
    _signals.removeWhere((s) => _now - s.at > Tuning.signalLifetimeMs);
    for (final p in _players.values) {
      if (!p.bot && !p.connected) {
        p.disconnectedMs += dt;
        if (_phase != Phase.lobby && p.disconnectedMs > 8000) p.autopilot = true;
      }
    }
    if (_phase == Phase.lobby || _phase == Phase.ending) return;

    _phaseRemaining -= dt;
    _tickPlayers(dt);
    _tickBots(dt);
    if (_phase == Phase.night) {
      _nightElapsed += dt;
      _tickShadow(dt);
    }
    _updateSeenTraces();

    // Vorzeitiges Phasenende.
    final voters = _players.values.where((p) => !p.bot && p.connected && !p.downed);
    switch (_phase) {
      case Phase.intro:
        final humans = _players.values.where((p) => !p.bot && p.connected);
        if (humans.isNotEmpty && humans.every((p) => p.ready || p.autopilot) && _phaseTotal - _phaseRemaining > 1500) {
          _phaseRemaining = 0;
        }
      case Phase.council:
        if (_leadOptions.isNotEmpty && voters.isNotEmpty && voters.every((p) => _leadVotes.containsKey(p.id))) {
          _phaseRemaining = math.min(_phaseRemaining, 2500);
        }
      case Phase.accusation:
        if (voters.isNotEmpty && voters.every((p) => _accuse.containsKey(p.id))) {
          _phaseRemaining = math.min(_phaseRemaining, 2500);
        }
      default:
        break;
    }

    // Alle Ermittler tot → direkt zur Anklage (Geister stimmen ab).
    if ((_phase == Phase.investigation || _phase == Phase.night || _phase == Phase.council) &&
        !_players.values.any((p) => p.alive || p.downed)) {
      _shadow = null;
      _fadeExpiring();
      _enterAccusation();
      return;
    }

    if (_phaseRemaining <= 0) _advancePhase();
  }

  void _tickPlayers(int dt) {
    final grid = _grid!;
    final night = _phase == Phase.night;
    final shadow = _shadow;
    for (final p in _players.values) {
      // Effekte
      final expired = <String>[];
      p.effects.updateAll((k, v) {
        if (v < 0) return v;
        final nv = v - dt;
        if (nv <= 0) expired.add(k);
        return nv;
      });
      for (final e in expired) {
        p.effects.remove(e);
        _emit(GameEvent(Ev.effect, to: p.id, args: {'player': p.id, 'effect': e, 'on': false}));
        _dirty[p.id] = true;
      }
      if (p.abilityCdMs > 0) {
        final before = (p.abilityCdMs / 1000).ceil();
        p.abilityCdMs = math.max(0, p.abilityCdMs - dt);
        if ((p.abilityCdMs / 1000).ceil() != before) _dirty[p.id] = true;
      }
      if (_now >= p.movingUntil) p.moving = false;
      if (p.talkingTo != null) {
        final npc = _npcById[p.talkingTo];
        if (npc == null || _now > p.talkingUntil || dist(p.x, p.y, npc.x, npc.y) > 3.5) p.talkingTo = null;
      }

      // Ausblutzeit und Gift laufen nur in Aktionsphasen: in Einleitung, Beratung
      // und Anklage kann niemand helfen (Wiederbeleben, Items, Fähigkeiten gesperrt).
      final action = _actionPhase;
      if (p.downed) {
        if (action) {
          p.downedLeftMs -= dt;
          if (p.downedLeftMs <= 0) _die(p);
        }
        continue;
      }
      if (!p.alive) {
        // Geister dürfen Geister-Hotspots durchsuchen – ihr Kanal läuft weiter.
        final gch = p.channel;
        if (p.ghost && gch != null) {
          gch.elapsedMs += dt;
          if (gch.done) {
            p.channel = null;
            _completeChannel(p, gch);
          }
        } else {
          p.channel = null;
        }
        continue;
      }

      // Kanal
      final ch = p.channel;
      if (ch != null) {
        ch.elapsedMs += dt;
        if (ch.done) {
          p.channel = null;
          _completeChannel(p, ch);
        }
      }

      // Gift
      if (action && p.hasEffect('poisoned')) {
        p.poisonTimerMs += dt;
        if (p.poisonTimerMs >= effectCatalog['poisoned']!.mods.hpDrainMs) {
          p.poisonTimerMs = 0;
          _damage(p, 1);
          if (!p.alive) continue;
        }
      }

      // Aura Teamgeist
      final hasMate = _players.values.any((q) => q != p && q.alive && dist(p.x, p.y, q.x, q.y) <= Tuning.groupRadius);
      if (hasMate) {
        p.effects['teamgeist'] = -1;
      } else {
        p.effects.remove('teamgeist');
      }
      if (p.hidden) {
        p.effects['hidden'] = -1;
      } else {
        p.effects.remove('hidden');
      }

      // Nerven
      final room = grid.roomAtPos(p.x, p.y);
      final lit = room?.lit ?? false;
      var delta = 0.0;
      if (night && !lit && !hasMate && !p.hidden) delta -= Tuning.nervesLowAlone;
      if (night &&
          shadow != null &&
          dist(shadow.x, shadow.y, p.x, p.y) < Tuning.shadowNearRadius &&
          grid.lineOfSight(shadow.x, shadow.y, p.x, p.y)) {
        delta -= Tuning.nervesNearShadow;
      }
      if (!night || lit || hasMate) delta += Tuning.nervesRegenSafe;
      delta += p.nervesRegenBonus;
      p.nerves = clampD(p.nerves + delta * dt / 1000, 0, Tuning.nervesMax);
      if (p.nerves <= 0 && !p.hasEffect('panic')) {
        _addEffect(p, 'panic');
      } else if (p.nerves >= Tuning.panicRecoverAt && p.hasEffect('panic')) {
        _removeEffect(p, 'panic');
      }
    }
  }

  // --------------------------------------------------------- Interaktionen

  bool get _actionPhase => _phase == Phase.investigation || _phase == Phase.night;

  void _interact(PlayerState p, String target) {
    final s = _s;
    if (s == null) return;
    if (!_actionPhase) return _err(p, 'not_in_phase');
    if (p.downed) return;

    // Wiederbeleben
    final other = _players[target];
    if (other != null) {
      if (!p.alive || !other.downed || other == p) return;
      if (dist(p.x, p.y, other.x, other.y) > Tuning.interactRange + 0.4) return _err(p, 'too_far');
      final ms = (Tuning.reviveMs * p.detectiveClass.reviveMul / p.searchMul).round();
      p.channel = Channel('revive', other.id, ms, p.x, p.y);
      return;
    }

    // Verdächtige
    final npc = _npcById[target];
    if (npc != null) {
      if (!p.alive) return;
      if (dist(p.x, p.y, npc.x, npc.y) > Tuning.interactRange + 0.5) return _err(p, 'too_far');
      if (!npc.alive) {
        p.channel = Channel('search', npc.id, (Tuning.searchMs / p.searchMul).round(), p.x, p.y);
        return;
      }
      if (p.silenced) {
        _emit(GameEvent(Ev.dialogueRefused, to: p.id, args: {'npc': npc.id, 'reason': 'silenced'}));
        return;
      }
      p.talkingTo = npc.id;
      p.talkingUntil = _now + 20000;
      _emit(GameEvent(Ev.dialogueOpen, to: p.id, args: {'npc': npc.id}));
      return;
    }

    // Items
    final item = _items[target];
    if (item != null) {
      if (!p.alive) return;
      if (dist(p.x, p.y, item.x, item.y) > Tuning.interactRange + 0.5) return _err(p, 'too_far');
      if (item.def.type == ItemType.trace) {
        _items.remove(target);
        _emit(GameEvent(Ev.itemPicked, args: {'item': target, 'type': ItemType.trace, 'by': p.id}));
        final roll = _rt.nextDouble();
        if (roll < 0.5) {
          _grantSighting(p);
        } else if (roll < 0.8 && p.inventory.length < Tuning.maxInventory) {
          final type = _rt.pick(const [ItemType.flare, ItemType.medkit, ItemType.salts, ItemType.battery]);
          p.inventory.add(type);
          _emit(GameEvent(Ev.itemPicked, to: p.id, args: {'item': target, 'type': type, 'by': p.id}));
        } else {
          _emit(GameEvent(Ev.nothingFound, to: p.id, args: {'hotspot': target}));
        }
        _dirtyAll();
        return;
      }
      if (p.inventory.length >= Tuning.maxInventory) return _err(p, 'inventory_full');
      _items.remove(target);
      p.inventory.add(item.def.type);
      _emit(GameEvent(Ev.itemPicked, args: {'item': target, 'type': item.def.type, 'by': p.id}));
      _dirtyAll();
      return;
    }

    // Hotspots
    final h = s.hotspotById[target];
    if (h == null || !_hotspotVisible(p, h)) return;
    if (dist(p.x, p.y, h.x + 0.5, h.y + 0.5) > Tuning.interactRange + 0.6) return _err(p, 'too_far');
    switch (h.kind) {
      case HotspotKind.hide:
        if (!p.alive) return;
        p.hidden = !p.hidden;
        p.hideSpot = p.hidden ? h.id : null;
        p.channel = null;
        if (p.hidden) {
          p.effects['hidden'] = -1;
        } else {
          p.effects.remove('hidden');
        }
        _emit(GameEvent(Ev.hide, to: p.id, args: {'player': p.id, 'hidden': p.hidden}));
      case HotspotKind.lab:
        if (!p.alive) return;
        if (_labPending(p).isEmpty) return _err(p, 'nothing_to_analyze');
        final ms = (Tuning.labMs * p.detectiveClass.labMul / p.searchMul).round();
        p.channel = Channel('lab', h.id, ms, p.x, p.y);
      default:
        final ms = ((h.searchMs ?? Tuning.searchMs) / p.searchMul).round();
        p.channel = Channel('search', h.id, ms, p.x, p.y);
    }
  }

  List<ClueInst> _labPending(PlayerState p) => _clues.values
      .where((c) => c.pending == Evolve.lab && (c.onBoard || c.holder == p.id))
      .toList();

  void _completeChannel(PlayerState p, Channel ch) {
    switch (ch.kind) {
      case 'revive':
        final t = _players[ch.target];
        if (t == null || !t.downed) return;
        t
          ..life = LifeState.alive
          ..hp = 1
          ..downedLeftMs = 0
          ..nerves = math.max(t.nerves, 40);
        _addEffect(t, 'adrenaline');
        p.stats.revives++;
        _emit(GameEvent(Ev.revived, args: {'player': t.id, 'by': p.id}));
        _dirtyAll();
      case 'lab':
        final list = _labPending(p);
        for (final c in list) {
          _reveal(c);
        }
        _emit(GameEvent(Ev.labDone, to: p.id, args: {'count': list.length}));
      case 'search':
        final npc = _npcById[ch.target];
        final List<ClueDef> found;
        if (npc != null) {
          found = _s!.clues
              .where((d) => d.source.npc == npc.id && _clueAvailable(p, d, ignoreChapter: true))
              .toList();
        } else {
          found = _availableCluesAt(p, ch.target);
        }
        for (final d in found) {
          _grantClue(p, d);
        }
        if (found.isEmpty) {
          final prev = _searchedBy[ch.target];
          if (prev != null && prev != p.id) {
            _emit(GameEvent(Ev.hotspotEmpty, to: p.id, args: {'hotspot': ch.target, 'by': prev}));
          } else {
            _emit(GameEvent(Ev.nothingFound, to: p.id, args: {'hotspot': ch.target}));
          }
        } else {
          _searchedBy[ch.target] = p.id;
        }
        _searchedBy.putIfAbsent(ch.target, () => p.id);
        _dirtyAll();
    }
  }

  bool _reqOk(PlayerState p, Requirement r) =>
      (r.cls == null || p.cls == r.cls) &&
      (r.lead == null || _chosenLeads.contains(r.lead) || _leadUnlockedViaAlias(r.lead!));

  /// Spuren mit identischer Freischaltung (z. B. in Kapitel 2 erneut angeboten) zählen gleich.
  bool _leadUnlockedViaAlias(String leadId) {
    final l = _s!.leadById[leadId];
    if (l == null || l.unlock.hotspots.isEmpty) return false;
    return l.unlock.hotspots.every(_unlockedHotspots.contains);
  }

  bool _clueAvailable(PlayerState p, ClueDef d, {bool ignoreChapter = false}) =>
      !_clues.containsKey(d.id) &&
      !_expired.contains(d.id) &&
      (ignoreChapter || d.chapter <= _chapter) &&
      _reqOk(p, d.requires) &&
      d.ghost == p.ghost;

  List<ClueDef> _availableCluesAt(PlayerState p, String hotspotId) =>
      _s!.clues.where((d) => d.source.hotspot == hotspotId && _clueAvailable(p, d)).toList();

  bool _hotspotVisible(PlayerState p, HotspotDef h) {
    if (h.fromChapter > _chapter) return false;
    final lead = h.requires.lead;
    if (lead != null && !_chosenLeads.contains(lead) && !_unlockedHotspots.contains(h.id)) return false;
    if (h.requires.cls != null && h.requires.cls != p.cls) return false;
    if (p.ghost) return h.ghost || h.kind == HotspotKind.body;
    if (h.ghost) return false;
    if (h.kind == HotspotKind.blood) return p.sight || _searchedBy.containsKey(h.id);
    return true;
  }

  void _grantClue(PlayerState p, ClueDef d) {
    final inst = ClueInst.fromDef(d, p.id, _chapter);
    _clues[d.id] = inst;
    p.stats.found++;
    _emit(GameEvent(Ev.clueFound, to: p.id, args: {'clue': d.id}));
    if (p.ghost) {
      p.stats.ghostHelp++;
      _shareInst(p, inst);
    }
    _dirtyAll();
  }

  void _share(PlayerState p, String clueId) {
    final c = _clues[clueId];
    if (c == null || c.holder != p.id || c.onBoard) return;
    _shareInst(p, c);
  }

  /// [countStat] = false für unfreiwillige Freigaben (Tod), die nicht als eigenes Teilen zählen.
  void _shareInst(PlayerState p, ClueInst c, {bool countStat = true}) {
    c.onBoard = true;
    c.sharedBy = p.id;
    if (countStat) p.stats.shared++;
    _emit(GameEvent(Ev.clueShared, args: {'clue': c.id, 'by': p.id}));
    _dirtyAll();
  }

  void _ask(PlayerState p, String npcId, String topic) {
    final npc = _npcById[npcId];
    final truth = _truth;
    if (npc == null || truth == null || !p.alive || !_actionPhase) return;
    if (!npc.alive) {
      _emit(GameEvent(Ev.dialogueRefused, to: p.id, args: {'npc': npcId, 'reason': 'dead'}));
      return;
    }
    if (!Topic.all.contains(topic)) return;
    if (topic == Topic.rumor && !p.detectiveClass.rumors) return;
    if (dist(p.x, p.y, npc.x, npc.y) > Tuning.interactRange + 1.5) return _err(p, 'too_far');
    if (p.silenced) {
      _emit(GameEvent(Ev.dialogueRefused, to: p.id, args: {'npc': npcId, 'reason': 'silenced'}));
      return;
    }
    // Die Lügen-Variante bekommt nur, wer Lügen erkennt – sonst verriete schon der
    // Zeilen-Schlüssel den Täter.
    final showLie = topic == Topic.alibi && npc.id == truth.truth.culprit && p.detectiveClass.seesLies;
    final line = showLie ? 'alibiLie' : topic;
    (_heard[npc.id] ??= {}).add(topic);
    final grants = _s!.clues
        .where((d) => d.source.npc == npc.id && d.source.topic == topic && _clueAvailable(p, d))
        .toList();
    for (final d in grants) {
      _grantClue(p, d);
    }
    p.talkingTo = npc.id;
    p.talkingUntil = _now + 20000;
    _emit(GameEvent(Ev.dialogue, to: p.id, args: {
      'npc': npc.id,
      'topic': topic,
      'line': line,
      if (showLie) 'lie': true,
      if (grants.isNotEmpty) 'clue': grants.first.id,
    }));
    _dirtyAll();
  }

  void _present(PlayerState p, String npcId, String clueId) {
    final npc = _npcById[npcId];
    final c = _clues[clueId];
    final truth = _truth;
    if (npc == null || c == null || truth == null || !p.alive || !npc.alive) return;
    if (!_actionPhase) return _err(p, 'not_in_phase');
    if (!(c.onBoard || c.holder == p.id)) return;
    if (dist(p.x, p.y, npc.x, npc.y) > Tuning.interactRange + 1.5) return _err(p, 'too_far');
    if (p.silenced) {
      _emit(GameEvent(Ev.dialogueRefused, to: p.id, args: {'npc': npcId, 'reason': 'silenced'}));
      return;
    }
    final value = c.revealed ? truth.valueFor(c) : null;
    final isCulprit = npc.id == truth.truth.culprit;
    String reaction;
    if (!c.revealed || c.kind == ClueKind.story) {
      reaction = 'neutral';
    } else if (isCulprit) {
      final relevant = c.kind != ClueKind.alibi || c.def?.subject == npc.id;
      reaction = relevant ? 'nervous' : 'annoyed';
    } else if (c.kind == ClueKind.weapon) {
      // Wer Zugang zur Tatwaffe hatte, wird ebenso nervös – die Waffe allein entlarvt niemanden.
      reaction = npc.def.canAccessWeapon(value) ? 'nervous' : 'annoyed';
    } else {
      switch (c.kind) {
        case ClueKind.trait:
        case 'sighting':
          reaction = npc.def.traits[c.trait] == value ? 'nervous' : 'annoyed';
        case ClueKind.motive:
          reaction = npc.def.motives.contains(value) ? 'nervous' : 'annoyed';
        case ClueKind.alibi:
          reaction = c.def?.subject == npc.id ? 'neutral' : 'annoyed';
        default:
          reaction = 'annoyed';
      }
    }
    if (reaction == 'annoyed') {
      _addEffect(p, 'suspicious');
      p.nerves = math.max(0, p.nerves - 15);
    }
    _emit(GameEvent(Ev.present, to: p.id, args: {'npc': npc.id, 'clue': clueId, 'reaction': reaction}));
    // Ein Waffen-Hinweis macht auch Unschuldige mit Zugang nervös und ist daher kein Widerspruch.
    if (reaction == 'nervous' && isCulprit && c.kind != ClueKind.weapon && _contradicted.add(npc.id)) {
      p.stats.contradictions++;
      _emit(GameEvent(Ev.contradiction, args: {'npc': npc.id, 'by': p.id}));
    }
    _dirtyAll();
  }

  void _combine(PlayerState p, String a, String b) {
    final s = _s;
    if (s == null || _phase == Phase.lobby || _phase == Phase.ending) return;
    final ca = _clues[a], cb = _clues[b];
    if (ca == null || cb == null || !ca.onBoard || !cb.onBoard) return _err(p, 'not_on_board');
    final combo = s.combos.where((k) => (k.a == a && k.b == b) || (k.a == b && k.b == a)).firstOrNull;
    if (combo == null) {
      _emit(GameEvent(Ev.comboFail, to: p.id));
      return;
    }
    if (_deductions.contains(combo.id)) {
      // Richtig kombiniert, aber schon bekannt – nicht als Fehlschlag melden.
      _emit(GameEvent(Ev.comboKnown, to: p.id, args: {'combo': combo.id}));
      return;
    }
    _deductions.add(combo.id);
    for (final r in combo.reveals) {
      final c = _clues[r];
      if (c != null) _reveal(c);
    }
    final lead = combo.lead;
    if (lead != null && !_chosenLeads.contains(lead)) {
      // Neue Spuren kommen zur nächsten Beratung. Gibt es keine mehr, gilt die Spur sofort,
      // statt still zu verfallen.
      final nextCouncilChapter = (_phase == Phase.council || _phase == Phase.night) ? _chapter + 1 : _chapter;
      if (nextCouncilChapter >= s.chapters.length) {
        _applyLead(lead);
      } else {
        _pendingHiddenLeads.add(lead);
      }
    }
    p.stats.combos++;
    _emit(GameEvent(Ev.combo, args: {'combo': combo.id, 'by': p.id}));
    _dirtyAll();
  }

  void _ability(PlayerState p) {
    if (!p.alive || _s == null) return;
    if (!_actionPhase) return _err(p, 'not_in_phase');
    if (p.abilityCdMs > 0) return _err(p, 'cooldown');
    final cls = p.detectiveClass;
    switch (cls.ability) {
      case 'scan':
        _addEffect(p, 'eagle_eye');
      case 'calm':
        for (final q in _aliveDetectives) {
          if (dist(p.x, p.y, q.x, q.y) <= Tuning.groupRadius) {
            _addEffect(q, 'focused');
            _removeEffect(q, 'panic');
            q.nerves = math.min(Tuning.nervesMax, q.nerves + 30);
          }
        }
      case 'scare':
        final sh = _shadow;
        if (sh == null || dist(p.x, p.y, sh.x, sh.y) > 4.5) return _err(p, 'nothing_to_scare');
        if (cls.chargesPerNight > 0 && p.abilityCharges <= 0) return _err(p, 'no_charges');
        p.abilityCharges--;
        _shadowFlee();
        _emit(GameEvent(Ev.shadowRepelled, args: {'by': p.id, 'reason': 'scare'}));
      case 'sources':
        // Nur Fundorte, die der Spieler selbst sehen und durchsuchen kann.
        final open = _s!.clues.where((d) {
          final hid = d.source.hotspot;
          if (hid == null || d.secret || d.ghost || !_clueAvailable(p, d)) return false;
          final h = _s!.hotspotById[hid];
          return h != null && _hotspotVisible(p, h);
        }).toList();
        if (open.isEmpty) return _err(p, 'nothing_left');
        final d = _rt.pick(open);
        final h = _s!.hotspotById[d.source.hotspot]!;
        _signals.add(_Signal(p.id, 'ping', 'source', h.x + 0.5, h.y + 0.5, _now));
        _emit(GameEvent(Ev.sources, to: p.id, args: {'hotspot': h.id, 'x': h.x + 0.5, 'y': h.y + 0.5}));
      case 'firstaid':
        PlayerState? target;
        var best = double.infinity;
        for (final q in _aliveDetectives) {
          final needs = q.hp < q.maxHp || q.hasEffect('injured') || q.hasEffect('poisoned');
          final d = dist(p.x, p.y, q.x, q.y);
          if (needs && d <= 1.8 && d < best) {
            best = d;
            target = q;
          }
        }
        if (target == null) return _err(p, 'nothing_to_heal');
        target.hp = math.min(target.maxHp, target.hp + 1);
        _removeEffect(target, 'injured');
        _removeEffect(target, 'poisoned');
        p.stats.heals++;
    }
    p.abilityCdMs = cls.abilityCooldownMs;
    _emit(GameEvent(Ev.ability, args: {'player': p.id, 'ability': cls.ability}));
    _dirty[p.id] = true;
  }

  void _useItem(PlayerState p, int slot) {
    if (!p.alive || slot < 0 || slot >= p.inventory.length) return;
    if (!_actionPhase) return _err(p, 'not_in_phase');
    final type = p.inventory[slot];
    switch (type) {
      case ItemType.coffee:
        _addEffect(p, 'caffeine');
      case ItemType.battery:
        _addEffect(p, 'bright', ms: -1);
      case ItemType.salts:
        _addEffect(p, 'focused');
        _removeEffect(p, 'panic');
        p.nerves = math.min(Tuning.nervesMax, p.nerves + 40);
      case ItemType.antidote:
        if (!p.hasEffect('poisoned')) return _err(p, 'not_needed');
        _removeEffect(p, 'poisoned');
      case ItemType.medkit:
        if (p.hp >= p.maxHp && !p.hasEffect('injured')) return _err(p, 'not_needed');
        p.hp = math.min(p.maxHp, p.hp + 1);
        _removeEffect(p, 'injured');
      case ItemType.flare:
        _addEffect(p, 'bright', ms: 15000);
        final sh = _shadow;
        if (sh != null && dist(p.x, p.y, sh.x, sh.y) <= 7) {
          _shadowFlee();
          _emit(GameEvent(Ev.shadowRepelled, args: {'by': p.id, 'reason': 'flare'}));
        }
    }
    p.inventory.removeAt(slot);
    _emit(GameEvent(Ev.itemUsed, args: {'type': type, 'by': p.id}));
    _dirty[p.id] = true;
  }

  void _signal(PlayerState p, String kind, String value, double? x, double? y) {
    if (_now - p.lastSignalAt < 1200) return;
    switch (kind) {
      case 'emote':
        if (!emoteIds.contains(value)) return;
        // Nur Pings tragen Koordinaten (unendliche Werte würden jedes Snapshot-Encoding sprengen).
        x = null;
        y = null;
      case 'quick':
        if (!quickChatIds.contains(value)) return;
        x = null;
        y = null;
      case 'ping':
        if (x == null || y == null || !x.isFinite || !y.isFinite) return;
        // Der Wert eines Pings wird nicht gelesen – nicht ungeprüft an alle weiterreichen.
        value = 'ping';
        final map = _s?.map;
        if (map != null) {
          x = clampD(x, 0, map.width.toDouble());
          y = clampD(y, 0, map.height.toDouble());
        }
        if (p.ghost) {
          if (p.pingsLeft <= 0) return _err(p, 'no_pings');
          p.pingsLeft--;
          p.stats.ghostHelp++;
          _dirty[p.id] = true;
        }
      default:
        return;
    }
    p.lastSignalAt = _now;
    _signals.add(_Signal(p.id, kind, value, x, y, _now));
    _emit(GameEvent(Ev.signal, args: {'by': p.id, 'kind': kind, 'value': value, if (x != null) 'x': x, if (y != null) 'y': y}));
  }

  // ------------------------------------------------------- Leben & Effekte

  void _addEffect(PlayerState p, String id, {int? ms}) {
    final def = effectCatalog[id];
    if (def == null) return;
    final had = p.effects.containsKey(id);
    p.effects[id] = ms ?? (def.durationMs == 0 ? -1 : def.durationMs);
    if (!had) {
      if (id == 'poisoned') p.poisonTimerMs = 0;
      _emit(GameEvent(Ev.effect, to: p.id, args: {'player': p.id, 'effect': id, 'on': true}));
      _dirty[p.id] = true;
    }
  }

  void _removeEffect(PlayerState p, String id) {
    if (id == 'poisoned') p.poisonTimerMs = 0;
    if (p.effects.remove(id) != null) {
      _emit(GameEvent(Ev.effect, to: p.id, args: {'player': p.id, 'effect': id, 'on': false}));
      _dirty[p.id] = true;
    }
  }

  void _damage(PlayerState p, int amount) {
    p.hp -= amount;
    if (p.hp <= 0) {
      p.hp = 0;
      p
        ..life = LifeState.downed
        ..downedLeftMs = Tuning.downedMs
        ..hidden = false
        ..channel = null;
      p.effects.remove('hidden');
      _emit(GameEvent(Ev.downed, args: {'player': p.id}));
      _dirtyAll();
    }
  }

  void _die(PlayerState p) {
    p
      ..life = LifeState.ghost
      ..hp = 0
      ..downedLeftMs = 0
      ..hidden = false
      ..channel = null
      ..pingsLeft = Tuning.pingsPerChapter;
    p.effects.clear();
    p.inventory.clear();
    for (final c in _clues.values.where((c) => c.holder == p.id && !c.onBoard).toList()) {
      _shareInst(p, c, countStat: false);
    }
    _emit(GameEvent(Ev.died, args: {'player': p.id}));
    _dirtyAll();
  }

  // ------------------------------------------------------------- Ausgabe

  void _emit(GameEvent e) {
    final to = e.to;
    if (to != null) {
      _queues[to]?.add(e);
      return;
    }
    for (final q in _queues.values) {
      q.add(e);
    }
  }

  void _err(PlayerState p, String key) => _emit(GameEvent(Ev.error, to: p.id, args: {'key': key}));

  void _dirtyAll() {
    for (final id in _players.keys) {
      _dirty[id] = true;
    }
  }

  List<GameEvent> drainEvents(String playerId) {
    final q = _queues[playerId];
    if (q == null || q.isEmpty) return const [];
    final out = List.of(q);
    q.clear();
    return out;
  }

  WorldSnapshot worldFor(String playerId) {
    final viewer = _players[playerId];
    final grid = _grid;
    final cx = viewer?.correctX, cy = viewer?.correctY;
    if (viewer != null) {
      viewer.correctX = null;
      viewer.correctY = null;
    }
    if (_phase == Phase.lobby || grid == null) {
      return WorldSnapshot(
        t: _now, phase: _phase, chapter: _chapter, phaseRemainingMs: 0, phaseTotalMs: 0,
        detectives: const [], npcs: const [], shadow: null, signals: const [], ackSeq: viewer?.ackSeq ?? 0,
      );
    }
    final dets = <DetectiveView>[];
    for (final p in _players.values) {
      if (p.hidden && p.id != playerId) continue;
      final ch = p.channel;
      dets.add(DetectiveView(
        id: p.id,
        name: p.name,
        cls: p.cls,
        coat: p.coat,
        hat: p.hat,
        bot: p.bot,
        connected: p.bot || p.connected,
        x: p.x,
        y: p.y,
        facing: p.facing,
        life: p.life,
        hp: p.hp,
        maxHp: p.maxHp,
        nerves: p.nerves.round(),
        hidden: p.hidden,
        moving: p.moving,
        channel: ch == null ? null : ChannelView(kind: ch.kind, target: ch.target, progress: ch.progress),
        effects: p.effects.keys.toList(),
        downedLeftMs: p.downed ? p.downedLeftMs : 0,
      ));
    }
    final talking = <String, String>{};
    for (final p in _players.values) {
      if (p.talkingTo != null) talking[p.talkingTo!] = p.id;
    }
    return WorldSnapshot(
      t: _now,
      phase: _phase,
      chapter: _chapter,
      phaseRemainingMs: math.max(0, _phaseRemaining),
      phaseTotalMs: _phaseTotal,
      detectives: dets,
      npcs: [
        for (final n in _npcs) NpcView(id: n.id, x: n.x, y: n.y, alive: n.alive, talkingTo: talking[n.id]),
      ],
      shadow: viewer != null && _shadowVisibleTo(viewer)
          ? ShadowView(x: _shadow!.x, y: _shadow!.y, mode: _shadow!.mode)
          : null,
      signals: [
        for (final s in _signals) SignalView(by: s.by, kind: s.kind, value: s.value, x: s.x, y: s.y, ageMs: _now - s.at),
      ],
      ackSeq: viewer?.ackSeq ?? 0,
      correctX: cx,
      correctY: cy,
    );
  }

  bool _shadowVisibleTo(PlayerState p) {
    final sh = _shadow;
    if (sh == null) return false;
    return _perceives(p, sh.x, sh.y);
  }

  /// Kann [p] nachts den Punkt sehen bzw. hören (gleiche Regel wie für den Schatten)?
  bool _perceives(PlayerState p, double x, double y) {
    if (p.ghost) return true;
    final d = dist(p.x, p.y, x, y);
    if (d <= Tuning.hearRadius) return true;
    final radius = Tuning.nightLightRadius * p.lightMul + 0.5;
    return d <= radius && _grid!.lineOfSight(p.x, p.y, x, y);
  }

  /// Schatten-Spuren werden pro Spieler erst sichtbar, wenn er sie wahrnimmt –
  /// sonst verriete jede neue Spur allen Clients die Position des Schattens.
  void _updateSeenTraces() {
    final traces = _items.entries.where((e) => e.value.def.type == ItemType.trace).toList();
    if (traces.isEmpty) return;
    for (final p in _players.values) {
      final seen = _seenTraces.putIfAbsent(p.id, () => <String>{});
      for (final t in traces) {
        if (seen.contains(t.key)) continue;
        if (_perceives(p, t.value.x, t.value.y)) {
          seen.add(t.key);
          _dirty[p.id] = true;
        }
      }
    }
  }

  CaseView? caseFor(String playerId, {bool force = false}) {
    final p = _players[playerId];
    if (p == null) return null;
    if (!force && _dirty[playerId] != true) return null;
    _dirty[playerId] = false;
    final s = _s;
    final truth = _truth;
    ClueView view(ClueInst c) => ClueView(
          id: c.id,
          kind: c.kind,
          stage: c.stage,
          pending: c.pending,
          revealChapter: c.revealChapter,
          value: c.revealed ? truth?.valueFor(c) : null,
          trait: c.trait,
          foundBy: c.foundBy,
          sharedBy: c.sharedBy,
        );
    final hotspots = <String, String>{};
    if (s != null && _phase != Phase.lobby) {
      for (final h in s.hotspots) {
        if (!_hotspotVisible(p, h)) continue;
        if (h.kind == HotspotKind.lab || h.kind == HotspotKind.hide) {
          hotspots[h.id] = HotspotState.open;
          continue;
        }
        final searched = _searchedBy.containsKey(h.id);
        final has = _availableCluesAt(p, h.id).isNotEmpty;
        hotspots[h.id] = !searched ? HotspotState.open : (has ? HotspotState.fresh : HotspotState.searched);
      }
    }
    return CaseView(
      version: ++_caseVersion,
      roomCode: roomCode,
      hostId: _hostId,
      scenarioId: _scenarioId,
      mode: _mode,
      // Der Seed bestimmt die Wahrheit – nur der öffentliche Tagesfall-Seed geht raus.
      seed: _mode == 'daily' ? _seed : 0,
      bots: _botCount,
      lobby: [
        for (final q in _players.values)
          LobbyPlayer(
            id: q.id, name: q.name, cls: q.cls, coat: q.coat, hat: q.hat,
            ready: q.ready, bot: q.bot, connected: q.bot || q.connected,
          ),
      ],
      phase: _phase,
      chapter: _chapter,
      notebook: [for (final c in _clues.values) if (c.holder == playerId && !c.onBoard) view(c)],
      board: [for (final c in _clues.values) if (c.onBoard) view(c)],
      deductions: List.of(_deductions),
      contradictions: _contradicted.length,
      contradicted: List.of(_contradicted),
      hotspots: hotspots,
      openDoors: [for (final d in _grid?.openDoors ?? const <Pt>{}) [d.x, d.y]],
      items: [
        for (final i in _items.entries)
          if (i.value.def.type != ItemType.trace || (_seenTraces[playerId]?.contains(i.key) ?? false))
            ItemView(id: i.key, type: i.value.def.type, x: i.value.x, y: i.value.y),
      ],
      inventory: List.of(p.inventory),
      leadOptions: _phase == Phase.council ? List.of(_leadOptions) : const [],
      leadVotes: Map.of(_leadVotes),
      chosenLeads: List.of(_chosenLeads),
      accusations: Map.of(_accuse),
      heard: {for (final e in _heard.entries) e.key: e.value.toList()},
      deadNpcs: [for (final n in _npcs) if (!n.alive) n.id],
      abilityCooldownMs: p.abilityCdMs,
      abilityCharges: p.abilityCharges,
      pingsLeft: p.pingsLeft,
      ending: _ending,
    );
  }

  static String _clip(String s, int n) => s.length <= n ? s : s.substring(0, n);
}

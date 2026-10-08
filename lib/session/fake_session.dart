import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:mordakte_core/mordakte_core.dart';

import 'game_session.dart';

/// Entwicklungs-Session ohne Engine: Beispiel-Szenario, zwei herumlaufende
/// Mit-Detektive, Phase per [debugSetPhase] umschaltbar. Für Renderer- und
/// UI-Arbeit und für Screenshots (`?fake=1`).
class FakeSession implements GameSession {
  FakeSession() {
    _scenario = ScenarioDef.fromJson(jsonDecode(sampleScenarioJson) as Map<String, dynamic>);
    final spawn = _scenario.map.spawn.first;
    _x = spawn.x + 0.5;
    _y = spawn.y + 0.5;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
    _publishCase();
    _tick();
  }

  late final ScenarioDef _scenario;
  late final Timer _timer;
  final _world = ValueNotifier<WorldSnapshot?>(null);
  final _case = ValueNotifier<CaseView?>(null);
  final _events = StreamController<GameEvent>.broadcast();
  final _connected = ValueNotifier<bool>(true);

  double _x = 0, _y = 0, _f = 0;
  int _t = 0;
  int _version = 0;
  Phase _phase = Phase.investigation;
  int _chapter = 1;

  final List<ClueView> _notebook = [
    const ClueView(id: 'c_ink', kind: 'trait', trait: 'hand', stage: 1, value: 'left', foundBy: 'me'),
    const ClueView(id: 'c_ashes', kind: 'motive', stage: 0, pending: 'lab', foundBy: 'me'),
  ];
  final List<ClueView> _board = [
    const ClueView(id: 'c_autopsy', kind: 'weapon', stage: 0, pending: 'time', revealChapter: 2, foundBy: 'p2', sharedBy: 'p2'),
    const ClueView(id: 'c_receipt', kind: 'alibi', stage: 1, value: 'true', foundBy: 'p3', sharedBy: 'p3'),
  ];
  final Map<String, String> _leadVotes = {};
  final Map<String, AccuseVote> _accuse = {};
  final List<String> _inventory = ['coffee'];
  final List<SignalView> _signals = [];

  @override
  String get playerId => 'me';

  @override
  String get roomCode => 'TEST';

  @override
  bool get isOnline => false;

  @override
  ValueListenable<WorldSnapshot?> get world => _world;

  @override
  ValueListenable<CaseView?> get caseView => _case;

  @override
  Stream<GameEvent> get events => _events.stream;

  @override
  ValueListenable<bool> get connected => _connected;

  @override
  Map<String, ScenarioDef> get scenarios => {_scenario.id: _scenario};

  @override
  ScenarioDef? get scenario => _scenario;

  /// Phase für Tests der Darstellung umschalten.
  void debugSetPhase(Phase phase, {int? chapter}) {
    _phase = phase;
    if (chapter != null) _chapter = chapter;
    _events.add(GameEvent(Ev.phase, args: {'phase': phase.name, 'chapter': _chapter}));
    _publishCase();
  }

  @override
  void move(double x, double y, double facing) {
    _x = x;
    _y = y;
    _f = facing;
  }

  @override
  void send(Command command) {
    switch (command) {
      case Interact(:final target):
        if (_scenario.suspectById.containsKey(target)) {
          _events.add(GameEvent(Ev.dialogueOpen, to: playerId, args: {'npc': target}));
        } else if (_scenario.hotspotById.containsKey(target)) {
          _events.add(GameEvent(Ev.nothingFound, to: playerId, args: {'hotspot': target}));
        }
      case AskTopic(:final npc, :final topic):
        _events.add(GameEvent(Ev.dialogue, to: playerId, args: {
          'npc': npc,
          'topic': topic,
          'line': topic == Topic.alibi && npc == 'nephew' ? 'alibiLie' : topic,
          'lie': topic == Topic.alibi && npc == 'nephew',
        }));
      case ShareClue(:final clue):
        final i = _notebook.indexWhere((c) => c.id == clue);
        if (i >= 0) {
          final c = _notebook.removeAt(i);
          _board.add(ClueView(
            id: c.id, kind: c.kind, stage: c.stage, pending: c.pending, value: c.value,
            trait: c.trait, foundBy: c.foundBy, sharedBy: playerId,
          ));
          _events.add(GameEvent(Ev.clueShared, args: {'clue': clue, 'by': playerId}));
          _publishCase();
        }
      case VoteLead(:final lead):
        _leadVotes[playerId] = lead;
        _publishCase();
      case Accuse(:final culprit, :final motive, :final weapon):
        _accuse[playerId] = AccuseVote(culprit: culprit, motive: motive, weapon: weapon);
        _publishCase();
      case Signal(:final kind, :final value, :final x, :final y):
        _signals.add(SignalView(by: playerId, kind: kind, value: value, x: x, y: y, ageMs: 0));
        _events.add(GameEvent(Ev.signal, args: {'by': playerId, 'kind': kind, 'value': value, 'x': x, 'y': y}));
      default:
        break;
    }
  }

  void _tick() {
    _t += 100;
    final a = _t / 2400;
    DetectiveView det(String id, String name, String cls, int coat, String hat, double x, double y, {LifeState life = LifeState.alive}) =>
        DetectiveView(
          id: id, name: name, cls: cls, coat: coat, hat: hat, bot: id != 'me', connected: true,
          x: x, y: y, facing: 0, life: life, hp: life == LifeState.alive ? 3 : 0, maxHp: 3,
          nerves: 70, hidden: false, moving: id != 'me', channel: null,
          effects: id == 'me' ? const ['caffeine', 'teamgeist'] : const [], downedLeftMs: 0,
        );
    for (var i = _signals.length - 1; i >= 0; i--) {
      final s = _signals[i];
      if (s.ageMs > Tuning.signalLifetimeMs) {
        _signals.removeAt(i);
      } else {
        _signals[i] = SignalView(by: s.by, kind: s.kind, value: s.value, x: s.x, y: s.y, ageMs: s.ageMs + 100);
      }
    }
    final total = switch (_phase) {
      Phase.night => Tuning.nightMs,
      Phase.council => Tuning.councilMs,
      Phase.accusation => Tuning.accusationMs,
      _ => Tuning.investigationMs,
    };
    _world.value = WorldSnapshot(
      t: _t,
      phase: _phase,
      chapter: _chapter,
      phaseRemainingMs: math.max(0, total - (_t % total)),
      phaseTotalMs: total,
      detectives: [
        DetectiveView(
          id: 'me', name: 'Du', cls: 'forensic', coat: 0, hat: 'fedora', bot: false, connected: true,
          x: _x, y: _y, facing: _f, life: LifeState.alive, hp: 2, maxHp: 3, nerves: 64, hidden: false,
          moving: false, channel: null, effects: const ['caffeine', 'teamgeist'], downedLeftMs: 0,
        ),
        det('p2', 'Mila', 'profiler', 1, 'cloche', 10 + 4 * math.cos(a), 7.6 + 0.6 * math.sin(a)),
        det('p3', 'Jonas', 'excop', 2, 'cap', 9 + 6 * math.cos(a * 0.7), 11 + 1 * math.sin(a * 0.7)),
      ],
      npcs: [
        for (final s in _scenario.suspects) NpcView(id: s.id, x: s.x + 0.5, y: s.y + 0.5, alive: true),
      ],
      shadow: _phase == Phase.night
          ? ShadowView(x: 4 + 2 * math.cos(a * 1.3), y: 7.5 + 0.5 * math.sin(a), mode: 'hunt')
          : null,
      signals: List.of(_signals),
      ackSeq: 0,
    );
  }

  void _publishCase() {
    _version++;
    final ch = _scenario.chapters[(_chapter - 1).clamp(0, 2)];
    _case.value = CaseView(
      version: _version,
      roomCode: roomCode,
      hostId: playerId,
      scenarioId: _scenario.id,
      mode: 'story',
      seed: 1,
      bots: 2,
      lobby: const [
        LobbyPlayer(id: 'me', name: 'Du', cls: 'forensic', coat: 0, hat: 'fedora', ready: true, bot: false, connected: true),
        LobbyPlayer(id: 'p2', name: 'Mila', cls: 'profiler', coat: 1, hat: 'cloche', ready: true, bot: true, connected: true),
        LobbyPlayer(id: 'p3', name: 'Jonas', cls: 'excop', coat: 2, hat: 'cap', ready: true, bot: true, connected: true),
      ],
      phase: _phase,
      chapter: _chapter,
      notebook: List.of(_notebook),
      board: List.of(_board),
      deductions: const [],
      contradictions: 0,
      hotspots: {
        for (final h in _scenario.hotspots)
          if (!h.ghost && h.kind != HotspotKind.blood && h.requires.lead == null)
            h.id: h.id == 'h_desk' ? HotspotState.searched : HotspotState.open,
      },
      openDoors: const [],
      items: [
        for (final i in _scenario.items)
          if (i.chapter <= _chapter) ItemView(id: i.id, type: i.type, x: i.x + 0.5, y: i.y + 0.5),
      ],
      inventory: List.of(_inventory),
      leadOptions: [for (final l in ch.leads) l.id],
      leadVotes: Map.of(_leadVotes),
      chosenLeads: const [],
      accusations: Map.of(_accuse),
      heard: const {'housekeeper': ['alibi']},
      deadNpcs: const [],
      abilityCooldownMs: 0,
      abilityCharges: 1,
      pingsLeft: 1,
      ending: _phase == Phase.ending
          ? EndingView(
              verdict: 'solid',
              team: 'some',
              secret: false,
              caught: true,
              truth: _scenario.story,
              accused: const AccuseVote(culprit: 'nephew', motive: 'inheritance', weapon: 'candlestick'),
              strength: 4,
              endingId: 'solid.some.nephew',
              awards: const {'me': ['spurensucher'], 'p2': ['kombinierer']},
              xp: const {'me': 320, 'p2': 280, 'p3': 190},
              stats: const {
                'me': {'found': 5, 'shared': 4, 'revives': 0},
              },
              survivors: const ['me', 'p2'],
              witnessesAlive: 2,
            )
          : null,
    );
  }

  @override
  Future<void> dispose() async {
    _timer.cancel();
    await _events.close();
  }
}

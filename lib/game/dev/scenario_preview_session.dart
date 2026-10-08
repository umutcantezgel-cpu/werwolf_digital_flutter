import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../session/game_session.dart';

/// Nur für die Renderer-Vorschau: zeigt ein beliebiges Szenario mit dem
/// eigenen Detektiv am Spawn, zwei wandernden Mit-Detektiven und allen
/// Verdächtigen. Keine Spiellogik.
class ScenarioPreviewSession implements GameSession {
  ScenarioPreviewSession(this._scenario, {this.phase = Phase.investigation}) {
    final sp = _scenario.map.spawn;
    final s0 = sp.isNotEmpty ? sp.first : const Pt(1, 1);
    _x = s0.x + 0.5;
    _y = s0.y + 0.5;
    _publishCase();
    _tick();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
  }

  final ScenarioDef _scenario;
  final Phase phase;
  late final Timer _timer;
  final _world = ValueNotifier<WorldSnapshot?>(null);
  final _case = ValueNotifier<CaseView?>(null);
  final _events = StreamController<GameEvent>.broadcast();
  final _connected = ValueNotifier<bool>(true);
  double _x = 0, _y = 0, _f = 0.8;
  int _t = 0;

  void _tick() {
    _t += 100;
    final a = _t / 2400;
    final sp = _scenario.map.spawn;
    Pt spawn(int i) => sp.isEmpty ? const Pt(1, 1) : sp[i % sp.length];
    DetectiveView bot(String id, String name, int coat, String hat, Pt base, double ph) => DetectiveView(
          id: id, name: name, cls: 'profiler', coat: coat, hat: hat, bot: true, connected: true,
          x: base.x + 0.5 + 0.6 * math.cos(a + ph), y: base.y + 0.5 + 0.4 * math.sin(a + ph), facing: 0,
          life: LifeState.alive, hp: 3, maxHp: 3, nerves: 70, hidden: false, moving: true, channel: null,
          effects: const [], downedLeftMs: 0,
        );
    final victimRoom = _scenario.map.roomById[_scenario.map.councilRoom];
    _world.value = WorldSnapshot(
      t: _t,
      phase: phase,
      chapter: 1,
      phaseRemainingMs: 60000,
      phaseTotalMs: 240000,
      detectives: [
        DetectiveView(
          id: 'me', name: 'Du', cls: 'forensic', coat: 0, hat: 'fedora', bot: false, connected: true,
          x: _x, y: _y, facing: _f, life: LifeState.alive, hp: 3, maxHp: 3, nerves: 70, hidden: false,
          moving: false, channel: null, effects: const [], downedLeftMs: 0,
        ),
        bot('p2', 'Mila', 1, 'cloche', spawn(2), 0),
        bot('p3', 'Jonas', 2, 'cap', spawn(4), 2),
      ],
      npcs: [for (final s in _scenario.suspects) NpcView(id: s.id, x: s.x + 0.5, y: s.y + 0.5, alive: true)],
      shadow: phase == Phase.night && victimRoom != null
          ? ShadowView(x: _x + 3 + math.cos(a), y: _y + 1 + math.sin(a), mode: 'hunt')
          : null,
      signals: const [],
      ackSeq: 0,
    );
  }

  void _publishCase() {
    _case.value = CaseView(
      version: 1,
      roomCode: 'PREV',
      hostId: 'me',
      scenarioId: _scenario.id,
      mode: 'story',
      seed: 1,
      bots: 2,
      lobby: const [],
      phase: phase,
      chapter: 1,
      notebook: const [],
      board: const [],
      deductions: const [],
      contradictions: 0,
      hotspots: {
        for (final h in _scenario.hotspots)
          if (!h.ghost && h.kind != HotspotKind.blood && h.requires.lead == null) h.id: HotspotState.open,
      },
      openDoors: const [],
      items: [
        for (final i in _scenario.items)
          if (i.chapter <= 1) ItemView(id: i.id, type: i.type, x: i.x + 0.5, y: i.y + 0.5),
      ],
      inventory: const [],
      leadOptions: const [],
      leadVotes: const {},
      chosenLeads: const [],
      accusations: const {},
      heard: const {},
      deadNpcs: const [],
      abilityCooldownMs: 0,
      abilityCharges: 1,
      pingsLeft: 1,
      ending: null,
    );
  }

  @override
  String get playerId => 'me';

  @override
  String get roomCode => 'PREV';

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

  @override
  void move(double x, double y, double facing) {
    _x = x;
    _y = y;
    _f = facing;
  }

  @override
  void send(Command command) {}

  @override
  Future<void> dispose() async {
    _timer.cancel();
    await _events.close();
  }
}

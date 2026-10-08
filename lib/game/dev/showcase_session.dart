import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../session/fake_session.dart';
import '../../session/game_session.dart';

/// Nur für die Renderer-Vorschau: reichert die [FakeSession] mit Zuständen an,
/// die sie selbst nicht erzeugt (niedergeschlagen, Geist, Kanal, Emotes, Ping,
/// Spur des Schattens, frischer Hotspot).
class ShowcaseSession implements GameSession {
  ShowcaseSession(this.inner) {
    inner.world.addListener(_onWorld);
    inner.caseView.addListener(_onCase);
    _onCase();
    _onWorld();
  }

  final FakeSession inner;
  final _world = ValueNotifier<WorldSnapshot?>(null);
  final _case = ValueNotifier<CaseView?>(null);

  void _onWorld() {
    final w = inner.world.value;
    if (w == null) return;
    final t = w.t / 1000.0;
    final dets = <DetectiveView>[
      for (final d in w.detectives)
        if (d.id == 'p2')
          DetectiveView(
            id: d.id, name: d.name, cls: d.cls, coat: d.coat, hat: d.hat, bot: d.bot, connected: d.connected,
            x: 13.6, y: 7.6, facing: math.pi * 0.75, life: d.life, hp: d.hp, maxHp: d.maxHp, nerves: d.nerves,
            hidden: false, moving: false,
            channel: ChannelView(kind: 'search', target: 'h_wardrobe', progress: (t % 3) / 3),
            effects: d.effects, downedLeftMs: 0,
          )
        else
          d,
      DetectiveView(
        id: 'p4', name: 'Lena', cls: 'medic', coat: 3, hat: 'beret', bot: true, connected: true,
        x: 6.4, y: 7.7, facing: 0, life: LifeState.downed, hp: 0, maxHp: 3, nerves: 10, hidden: false,
        moving: false, channel: null, effects: const ['injured'], downedLeftMs: 9000,
      ),
      DetectiveView(
        id: 'p5', name: 'Otto', cls: 'journalist', coat: 4, hat: 'bowler', bot: true, connected: true,
        x: 12.5 + 1.5 * math.sin(t * 0.4), y: 11.4, facing: math.pi / 4, life: LifeState.ghost, hp: 0, maxHp: 3,
        nerves: 0, hidden: false, moving: true, channel: null, effects: const [], downedLeftMs: 0,
      ),
    ];
    final ms = w.t;
    final signals = <SignalView>[
      ...w.signals,
      SignalView(by: 'p3', kind: 'emote', value: 'wave', ageMs: ms % 6000),
      SignalView(by: 'p2', kind: 'quick', value: 'found_clue', ageMs: (ms + 2500) % 6000),
      SignalView(by: 'p3', kind: 'ping', value: 'look', x: 15.5, y: 11.5, ageMs: (ms + 1000) % 6000),
    ];
    _world.value = WorldSnapshot(
      t: w.t,
      phase: w.phase,
      chapter: w.chapter,
      phaseRemainingMs: w.phaseRemainingMs,
      phaseTotalMs: w.phaseTotalMs,
      detectives: dets,
      npcs: w.npcs,
      shadow: w.shadow,
      signals: signals,
      ackSeq: w.ackSeq,
      correctX: w.correctX,
      correctY: w.correctY,
    );
  }

  void _onCase() {
    final c = inner.caseView.value;
    if (c == null) return;
    _case.value = CaseView(
      version: c.version,
      roomCode: c.roomCode,
      hostId: c.hostId,
      scenarioId: c.scenarioId,
      mode: c.mode,
      seed: c.seed,
      bots: c.bots,
      lobby: c.lobby,
      phase: c.phase,
      chapter: c.chapter,
      notebook: c.notebook,
      board: c.board,
      deductions: c.deductions,
      contradictions: c.contradictions,
      hotspots: {...c.hotspots, 'h_fireplace': HotspotState.fresh},
      openDoors: c.openDoors,
      items: [...c.items, const ItemView(id: 'i_trace', type: 'trace', x: 3.5, y: 8.4)],
      inventory: c.inventory,
      leadOptions: c.leadOptions,
      leadVotes: c.leadVotes,
      chosenLeads: c.chosenLeads,
      accusations: c.accusations,
      heard: c.heard,
      deadNpcs: c.deadNpcs,
      abilityCooldownMs: c.abilityCooldownMs,
      abilityCharges: c.abilityCharges,
      pingsLeft: c.pingsLeft,
      ending: c.ending,
    );
  }

  @override
  String get playerId => inner.playerId;

  @override
  String get roomCode => inner.roomCode;

  @override
  bool get isOnline => false;

  @override
  ValueListenable<WorldSnapshot?> get world => _world;

  @override
  ValueListenable<CaseView?> get caseView => _case;

  @override
  Stream<GameEvent> get events => inner.events;

  @override
  ValueListenable<bool> get connected => inner.connected;

  @override
  Map<String, ScenarioDef> get scenarios => inner.scenarios;

  @override
  ScenarioDef? get scenario => inner.scenario;

  @override
  void move(double x, double y, double facing) => inner.move(x, y, facing);

  @override
  void send(Command command) => inner.send(command);

  @override
  Future<void> dispose() async {
    inner.world.removeListener(_onWorld);
    inner.caseView.removeListener(_onCase);
    await inner.dispose();
  }
}

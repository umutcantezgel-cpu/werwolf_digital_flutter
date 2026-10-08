import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

Map<String, ScenarioDef> _scenarios() {
  final out = <String, ScenarioDef>{};
  for (final f in Directory('../../content/scenarios').listSync().whereType<File>()) {
    if (!f.path.endsWith('.json')) continue;
    final s = ScenarioDef.fromJson(jsonDecode(f.readAsStringSync()) as Map<String, dynamic>);
    out[s.id] = s;
  }
  return out;
}

final _all = _scenarios();

/// Raum mit zwei Menschen (h1, h2) und optional Bots.
RoomRuntime _room(String scenario, {String mode = 'story', int bots = 0, String cls1 = 'forensic', String cls2 = 'profiler'}) {
  final rt = RoomRuntime(roomCode: 'TEST', scenarios: _all, clockSeed: 4242);
  rt.join('h1', 'Eins');
  rt.join('h2', 'Zwei');
  rt.applyCommand('h1', SetLoadout(cls: cls1, coat: 0, hat: 'fedora'));
  rt.applyCommand('h2', SetLoadout(cls: cls2, coat: 1, hat: 'fedora'));
  rt.applyCommand('h1', ConfigureGame(scenarioId: scenario, mode: mode, seed: 12345, bots: bots));
  rt.applyCommand('h1', const StartGame());
  return rt;
}

/// Tickt, bis [until] gilt; Menschen sind in der Einleitung sofort bereit.
List<GameEvent> _run(RoomRuntime rt, bool Function() until, {int maxMs = 60 * 60 * 1000, String collect = 'h1'}) {
  final events = <GameEvent>[];
  var t = 0;
  while (!until() && t < maxMs) {
    if (rt.debugEngine.phase == Phase.intro) {
      for (final id in rt.humanPlayers) {
        rt.applyCommand(id, const SetReady(true));
      }
    }
    rt.tick(Tuning.tickMs);
    t += Tuning.tickMs;
    events.addAll(rt.drainEvents(collect));
    for (final id in rt.humanPlayers) {
      if (id != collect) rt.drainEvents(id);
    }
  }
  return events;
}

void _toPhase(RoomRuntime rt, Phase phase) {
  _run(rt, () => rt.debugEngine.phase == phase);
  expect(rt.debugEngine.phase, phase);
}

void main() {
  group('Geister', () {
    for (final (scenario, hotspot) in const [
      ('ravensmoor', 'h_geist'),
      ('nachtexpress', 'h_ghost'),
      ('blue_palm', 'h_jukebox'),
    ]) {
      test('Geist findet den Geister-Hinweis ($scenario)', () {
        final rt = _room(scenario);
        _toPhase(rt, Phase.investigation);
        final e = rt.debugEngine;
        e.debugKill('h1');
        final h = e.scenario!.hotspotById[hotspot]!;
        e.debugPlayer('h1')!
          ..x = h.x + 0.5
          ..y = h.y + 0.5;
        rt.drainEvents('h1');
        rt.applyCommand('h1', Interact(hotspot));
        final events = _run(rt, () => false, maxMs: 5000);
        final ghostClues = e.scenario!.clues.where((c) => c.ghost && c.source.hotspot == hotspot).map((c) => c.id);
        final found = events.where((ev) => ev.type == Ev.clueFound).map((ev) => ev.str('clue'));
        expect(found, containsAll(ghostClues));
      });
    }
  });

  test('Lügen-Variante des Alibis nur für Profiler', () {
    final rt = _room('ravensmoor', cls1: 'medic', cls2: 'profiler');
    _toPhase(rt, Phase.investigation);
    final e = rt.debugEngine;
    final culprit = e.truth!.culprit;
    GameEvent ask(String id) {
      final npc = rt.worldFor(id).npcs.firstWhere((n) => n.id == culprit);
      e.debugPlayer(id)!
        ..x = npc.x
        ..y = npc.y;
      rt.drainEvents(id);
      rt.applyCommand(id, AskTopic(npc: culprit, topic: Topic.alibi));
      return rt.drainEvents(id).firstWhere((ev) => ev.type == Ev.dialogue);
    }

    final medic = ask('h1');
    expect(medic.str('line'), 'alibi');
    expect(medic.flag('lie'), isFalse);
    final profiler = ask('h2');
    expect(profiler.str('line'), 'alibiLie');
    expect(profiler.flag('lie'), isTrue);
  });

  test('Fall-Ansicht verrät keinen Seed (Zufallsfall)', () {
    final rt = _room('ravensmoor', mode: 'random');
    final cv = rt.caseFor('h2', force: true)!;
    expect(cv.seed, 0);
    expect(cv.toJson()['seed'], 0);
  });

  test('Fall-Ansichten im selben Tick haben verschiedene Versionen', () {
    final rt = _room('ravensmoor');
    final a = rt.caseFor('h1', force: true)!;
    final b = rt.caseFor('h1', force: true)!;
    expect(b.version, isNot(a.version));
  });

  test('Veraltete Bewegungs-Sequenz nach Neuverbindung wird korrigiert statt still verworfen', () {
    final rt = _room('ravensmoor');
    _toPhase(rt, Phase.investigation);
    final p = rt.debugEngine.debugPlayer('h1')!;
    for (var i = 1; i <= 50; i++) {
      rt.applyMove('h1', MoveInput(x: p.x, y: p.y, facing: 0, seq: i));
    }
    rt.worldFor('h1');
    rt.setConnected('h1', false);
    rt.join('h1', 'Eins');
    rt.applyMove('h1', MoveInput(x: p.x + 0.1, y: p.y, facing: 0, seq: 1));
    final w = rt.worldFor('h1');
    expect(w.ackSeq, 50, reason: 'Client synchronisiert seine Sequenz über ackSeq');
    expect(w.correctX, isNotNull);
  });

  test('Niedergeschlagene und Vergiftete sterben nicht in der Beratung', () {
    final rt = _room('ravensmoor');
    _toPhase(rt, Phase.council);
    final e = rt.debugEngine;
    final p1 = e.debugPlayer('h1')!
      ..life = LifeState.downed
      ..hp = 0
      ..downedLeftMs = 1000;
    final p2 = e.debugPlayer('h2')!
      ..hp = 1
      ..poisonTimerMs = 59000;
    p2.effects['poisoned'] = -1;
    _run(rt, () => false, maxMs: 10000);
    expect(e.phase, Phase.council);
    expect(p1.downed, isTrue);
    expect(p2.hp, 1);
  });

  test('Gegengift setzt den Gift-Timer zurück', () {
    final rt = _room('ravensmoor');
    _toPhase(rt, Phase.investigation);
    final p = rt.debugEngine.debugPlayer('h1')!
      ..poisonTimerMs = 55000;
    p.effects['poisoned'] = -1;
    p.inventory.add(ItemType.antidote);
    rt.applyCommand('h1', const UseItem(0));
    expect(p.hasEffect('poisoned'), isFalse);
    expect(p.poisonTimerMs, 0);
  });

  test('Erste Hilfe zählt nicht als Wiederbelebung', () {
    final rt = _room('ravensmoor', cls1: 'medic');
    _toPhase(rt, Phase.investigation);
    final e = rt.debugEngine;
    final medic = e.debugPlayer('h1')!;
    e.debugPlayer('h2')!
      ..x = medic.x
      ..y = medic.y
      ..hp = 1;
    rt.applyCommand('h1', const UseAbility());
    expect(medic.stats.heals, 1);
    expect(medic.stats.revives, 0);
  });

  test('Tod teilt Hinweise, ohne sie als eigenes Teilen zu zählen', () {
    final rt = _room('ravensmoor');
    _toPhase(rt, Phase.investigation);
    final e = rt.debugEngine;
    final s = e.scenario!;
    final clue = s.clues.firstWhere((c) {
      final h = s.hotspotById[c.source.hotspot];
      return h != null &&
          h.kind == HotspotKind.search &&
          h.requires.lead == null &&
          h.requires.cls == null &&
          h.fromChapter <= 1 &&
          !c.ghost &&
          !c.secret &&
          c.chapter <= 1 &&
          c.requires.lead == null &&
          c.requires.cls == null;
    });
    final h = s.hotspotById[clue.source.hotspot]!;
    final p = e.debugPlayer('h1')!
      ..x = h.x + 0.5
      ..y = h.y + 0.5;
    rt.applyCommand('h1', Interact(h.id));
    final events = _run(rt, () => p.stats.found > 0, maxMs: 10000);
    expect(events.any((ev) => ev.type == Ev.clueFound), isTrue);
    e.debugKill('h1');
    expect(p.stats.shared, 0);
    expect(rt.caseFor('h2', force: true)!.board.map((c) => c.id), contains(clue.id));
  });

  test('Signale: Emote ohne Koordinaten, Ping-Wert normalisiert', () {
    final rt = _room('ravensmoor');
    _toPhase(rt, Phase.investigation);
    rt.applyCommand('h1', const Signal(kind: 'emote', value: 'wave', x: double.infinity, y: 1));
    rt.applyCommand('h2', Signal(kind: 'ping', value: 'x' * 8000, x: 2, y: 2));
    final w = rt.worldFor('h1');
    expect(() => jsonEncode(w.toJson()), returnsNormally);
    expect(w.signals.where((s) => s.kind == 'ping').single.value, 'ping');
    expect(w.signals.where((s) => s.kind == 'emote').single.x, isNull);
  });

  test('Quelle des Journalisten zeigt nur sichtbare Fundorte', () {
    for (final scenario in const ['nachtexpress', 'blue_palm', 'ravensmoor']) {
      final rt = _room(scenario, cls1: 'journalist');
      _toPhase(rt, Phase.investigation);
      final p = rt.debugEngine.debugPlayer('h1')!;
      for (var i = 0; i < 40; i++) {
        p.abilityCdMs = 0;
        rt.drainEvents('h1');
        rt.applyCommand('h1', const UseAbility());
        final ev = rt.drainEvents('h1').where((e) => e.type == Ev.sources).firstOrNull;
        if (ev == null) continue;
        final visible = rt.caseFor('h1', force: true)!.hotspots.keys;
        expect(visible, contains(ev.str('hotspot')), reason: scenario);
      }
    }
  });

  group('Abstimmungen: Menschen entscheiden', () {
    for (final delayMs in const [0, 20000]) {
      test('Anklage gegen Bot-Mehrheit (Menschen nach ${delayMs ~/ 1000} s)', () {
        final rt = _room('ravensmoor', bots: 3);
        _toPhase(rt, Phase.accusation);
        final e = rt.debugEngine;
        final wrong = e.scenario!.suspects.firstWhere((x) => x.id != e.truth!.culprit && x.candidate).id;
        _run(rt, () => false, maxMs: delayMs);
        rt.applyCommand('h1', Accuse(culprit: wrong));
        rt.applyCommand('h2', Accuse(culprit: wrong));
        _run(rt, () => rt.finished);
        expect(e.ending!.accused!.culprit, wrong);
        expect(e.ending!.verdict, 'wrong');
      });
    }

    test('Spurenwahl folgt den Menschen', () {
      final rt = _room('ravensmoor', bots: 3);
      _toPhase(rt, Phase.council);
      final options = rt.caseFor('h1', force: true)!.leadOptions;
      expect(options, isNotEmpty);
      final pick = options.last;
      _run(rt, () => false, maxMs: 15000);
      rt.applyCommand('h1', VoteLead(pick));
      rt.applyCommand('h2', VoteLead(pick));
      _run(rt, () => rt.debugEngine.phase != Phase.council);
      expect(rt.caseFor('h1', force: true)!.chosenLeads, contains(pick));
    });

    for (final firstH1 in const [true, false]) {
      test('Anklage 1:1 unter Menschen: früheste Anklage gilt, KI-Partner zieht mit (${firstH1 ? 'h1' : 'h2'} zuerst)', () {
        final rt = _room('ravensmoor', bots: 1);
        _toPhase(rt, Phase.accusation);
        final e = rt.debugEngine;
        final candidates = e.scenario!.suspects.where((x) => x.candidate).map((x) => x.id).toList();
        final a = candidates[0], b = candidates[1];
        final (first, second) = firstH1 ? ('h1', 'h2') : ('h2', 'h1');
        rt.applyCommand(first, Accuse(culprit: a));
        _run(rt, () => false, maxMs: 1000);
        rt.applyCommand(second, Accuse(culprit: b));
        _run(rt, () => rt.finished);
        expect(e.ending!.accused!.culprit, a);
      });
    }

    test('Anklage 1:1: geänderte Stimme zählt als neue (spätere) Stimme', () {
      final rt = _room('ravensmoor', bots: 1);
      _toPhase(rt, Phase.accusation);
      final e = rt.debugEngine;
      final candidates = e.scenario!.suspects.where((x) => x.candidate).map((x) => x.id).toList();
      final a = candidates[0], b = candidates[1], c = candidates[2];
      rt.applyCommand('h1', Accuse(culprit: c));
      rt.applyCommand('h2', Accuse(culprit: b));
      rt.applyCommand('h1', Accuse(culprit: a));
      _run(rt, () => rt.finished);
      expect(e.ending!.accused!.culprit, b);
    });

    test('Spurenwahl 1:1 unter Menschen: KI-Stimme passt zum Ergebnis', () {
      final rt = _room('ravensmoor', bots: 1);
      _toPhase(rt, Phase.council);
      final options = rt.caseFor('h1', force: true)!.leadOptions;
      if (options.length < 2) return;
      rt.applyCommand('h1', VoteLead(options[1]));
      _run(rt, () => false, maxMs: 500);
      rt.applyCommand('h2', VoteLead(options[0]));
      // Die KI-Stimme schließt sich an, bevor die Beratung endet.
      Map<String, String> votes = const {};
      _run(rt, () {
        if (rt.debugEngine.phase == Phase.council) votes = Map.of(rt.caseFor('h1', force: true)!.leadVotes);
        return rt.debugEngine.phase != Phase.council;
      });
      final chosen = rt.caseFor('h1', force: true)!.chosenLeads;
      expect(chosen, contains(options[1]));
      expect(chosen, isNot(contains(options[0])));
      final counts = <String, int>{};
      for (final v in votes.values) {
        counts[v] = (counts[v] ?? 0) + 1;
      }
      expect(counts[options[1]], greaterThan(counts[options[0]] ?? 0), reason: 'Anzeige muss zum Ergebnis passen');
    });
  });

  test('Bereits gezogene Schlussfolgerung meldet combo_known statt combo_fail', () {
    final rt = _room('ravensmoor', bots: 3);
    final e = rt.debugEngine;
    _run(rt, () => (rt.caseFor('h1', force: true)?.deductions.isNotEmpty ?? false));
    final id = rt.caseFor('h1', force: true)!.deductions.first;
    final combo = e.scenario!.combos.firstWhere((k) => k.id == id);
    rt.drainEvents('h1');
    rt.applyCommand('h1', Combine(combo.b, combo.a));
    final evs = rt.drainEvents('h1').map((x) => x.type).toList();
    expect(evs, contains(Ev.comboKnown));
    expect(evs, isNot(contains(Ev.comboFail)));
  });

  test('KI-Detektive durchsuchen nie gleichzeitig denselben Ort', () {
    for (final scenario in _all.keys) {
      final rt = _room(scenario, bots: 3);
      rt.setAutopilot('h1', true);
      rt.setAutopilot('h2', true);
      var t = 0;
      while (!rt.finished && t < 40 * 60 * 1000) {
        rt.tick(Tuning.tickMs);
        t += Tuning.tickMs;
        final targets = <String>[];
        for (final id in const ['h1', 'h2', 'bot_0', 'bot_1', 'bot_2']) {
          final ch = rt.debugEngine.debugPlayer(id)?.channel;
          if (ch != null && ch.kind != 'revive') targets.add(ch.target);
        }
        expect(targets.toSet().length, targets.length, reason: '$scenario t=$t $targets');
        rt.drainEvents('h1');
        rt.drainEvents('h2');
      }
    }
  });
}

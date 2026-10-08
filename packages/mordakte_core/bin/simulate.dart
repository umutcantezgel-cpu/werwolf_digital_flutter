import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';

/// Lässt KI-Detektive ganze Fälle durchspielen (Balance-Check, Engine-Durchlauf).
///
/// `dart run bin/simulate.dart [szenario-id|alle] [runs=6] [bots=3]`
void main(List<String> args) {
  final root = _root();
  final scenarios = <String, ScenarioDef>{};
  final sample = ScenarioDef.fromJson(jsonDecode(sampleScenarioJson) as Map<String, dynamic>);
  scenarios[sample.id] = sample;
  final dir = Directory('$root/content/scenarios');
  if (dir.existsSync()) {
    for (final f in dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'))) {
      final s = ScenarioDef.fromJson(jsonDecode(f.readAsStringSync()) as Map<String, dynamic>);
      scenarios[s.id] = s;
    }
  }
  final which = args.isNotEmpty && args[0] != 'alle' ? [args[0]] : scenarios.keys.toList();
  final runs = args.length > 1 ? int.parse(args[1]) : 6;
  final bots = args.length > 2 ? int.parse(args[2]) : 3;

  for (final id in which) {
    final verdicts = <String, int>{};
    final teams = <String, int>{};
    var totalMin = 0.0, totalFound = 0, totalAttacks = 0, totalWitness = 0, totalStrength = 0;
    stdout.writeln('== $id ($runs Läufe, 1 Autopilot-Spieler + $bots Bots)');
    for (var run = 0; run < runs; run++) {
      final rt = RoomRuntime(roomCode: 'SIM$run', scenarios: scenarios, clockSeed: 1000 + run);
      rt.join('h1', 'Sim');
      rt.setAutopilot('h1', true);
      rt.applyCommand('h1', ConfigureGame(scenarioId: id, mode: run == 0 ? 'story' : 'random', seed: 77 + run * 13, bots: bots));
      rt.applyCommand('h1', const StartGame());
      var t = 0;
      final events = <String, int>{};
      while (!rt.finished && t < 60 * 60 * 1000) {
        rt.tick(Tuning.tickMs);
        t += Tuning.tickMs;
        if (t % 1000 == 0) {
          rt.worldFor('h1');
          rt.caseFor('h1');
        }
        for (final e in rt.drainEvents('h1')) {
          events[e.type] = (events[e.type] ?? 0) + 1;
        }
      }
      final ending = rt.debugEngine.ending;
      if (ending == null) {
        stdout.writeln('  Lauf $run: KEIN ENDE nach ${t ~/ 60000} Min (Phase ${rt.debugEngine.phase})');
        continue;
      }
      final total = rt.debugEngine.scenario!.clues.length;
      final found = ending.stats.values.fold<int>(0, (a, m) => a + (m['found'] ?? 0));
      verdicts[ending.verdict] = (verdicts[ending.verdict] ?? 0) + 1;
      teams[ending.team] = (teams[ending.team] ?? 0) + 1;
      totalMin += t / 60000;
      totalFound += found;
      totalAttacks += events[Ev.attacked] ?? 0;
      totalWitness += events[Ev.npcKilled] ?? 0;
      totalStrength += ending.strength;
      stdout.writeln('  Lauf $run: ${ending.endingId.padRight(32)} Täter ${ending.truth.culprit}/${ending.truth.motive}/${ending.truth.weapon}'
          ' · angeklagt ${ending.accused?.culprit}/${ending.accused?.motive}/${ending.accused?.weapon}'
          ' · Stärke ${ending.strength} · Hinweise $found/$total · Angriffe ${events[Ev.attacked] ?? 0}'
          ' · Tote ${ending.team} · Zeugen † ${events[Ev.npcKilled] ?? 0} · ${(t / 60000).toStringAsFixed(1)} Min');
    }
    final n = verdicts.values.fold(0, (a, b) => a + b);
    if (n > 0) {
      stdout.writeln('  Σ Urteile $verdicts · Teams $teams · Ø ${(totalMin / n).toStringAsFixed(1)} Min'
          ' · Ø Hinweise ${(totalFound / n).toStringAsFixed(1)} · Ø Stärke ${(totalStrength / n).toStringAsFixed(1)}'
          ' · Ø Angriffe ${(totalAttacks / n).toStringAsFixed(1)} · Ø Zeugen † ${(totalWitness / n).toStringAsFixed(1)}');
    }
  }
}

String _root() {
  var dir = File(Platform.script.toFilePath()).parent;
  for (var i = 0; i < 5; i++) {
    if (Directory('${dir.path}/content').existsSync()) return dir.path;
    dir = dir.parent;
  }
  return Directory.current.path;
}

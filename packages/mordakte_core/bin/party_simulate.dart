// Erschöpfender Simulator für den Partymodus (F-06, F-07, F-08).
//
//   dart run bin/party_simulate.dart            Bericht und Prüfung
//   dart run bin/party_simulate.dart --pruefen  nur Prüfung, Exitcode 1 bei Verstoß
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';

Map<String, Object?> _lies(String wurzel, String p) => jsonDecode(File('$wurzel/$p').readAsStringSync()) as Map<String, Object?>;

String _wurzel() {
  var d = Directory.current;
  while (!Directory('${d.path}/content/party').existsSync()) {
    final p = d.parent;
    if (p.path == d.path) throw StateError('content/party nicht gefunden');
    d = p;
  }
  return '${d.path}/content/party/schlosskeller';
}

void main(List<String> args) {
  final uhr = Stopwatch()..start();
  final w = _wurzel();
  final kanon = Kanon.lade((p) => _lies(w, p));
  final sim = Simulator(kanon);
  final verstoesse = [...sim.pruefe(), ...sim.pruefeSchwellen()];
  if (!args.contains('--pruefen')) {
    final berichte = sim.auszaehlen();
    final folgen = sim.folgen().length;
    stdout.writeln('Simulator · ${kanon.fall['titel']} · $folgen Optionsfolgen je Pfad × ${kanon.kernverdaechtige.length} Anklagen');
    stdout.writeln('Gruppenergebnisse ändern die Restmenge nie (W-1); geprüft über alle Hinweise.\n');
    for (final b in berichte.values) {
      stdout.writeln('Pfad ${b.pfad}: ${b.spiele} Spiele');
      stdout.writeln('  Enden: ${[for (final e in sim.enden.regeln) '${e.name} ${b.enden[e.id] ?? 0}'].join(' · ')}');
      stdout.writeln('  Punkte: ${[for (var p = 0; p <= 9; p++) '$p:${b.punkte[p] ?? 0}'].join(' ')}');
      stdout.writeln('  Restmenge nach Runde 3: ${[for (var n = 1; n <= 4; n++) '$n:${b.restGroesse[n] ?? 0}'].join(' ')}');
      stdout.writeln('  Rate-Enden (Anklage außerhalb der Restmenge): ${b.rateEnden}; Treffer trotz Restmenge > 1: ${b.rateTreffer}');
      stdout.writeln('  Restmenge 1 mit weniger als 9 Punkten: ${b.kuerzerAlsBest} Folgen');
      final best = sim.verlauf(b.pfad, sim.ermittlung.bestesSpiel(b.pfad));
      stdout.writeln('  Bestes Spiel: Restmenge nach Runde 1/2/3 = ${best.restNachRunde.map((r) => r.length).join('/')}');
    }
    stdout.writeln('Ratestrategien (Kanon-Reihenfolge; die App mischt die Anzeige je Fall-Code), Punkte je Pfad:');
    final e = sim.ermittlung.entscheidungen;
    final strategien = <String, List<String> Function(String)>{
      'immer erste Option': (p) => [for (final x in e) x.optionen.first.id],
      'immer letzte Option': (p) => [for (final x in e) x.optionen.last.id],
      'immer Person, sonst erste': (p) => [for (final x in e) (x.optionen.where((o) => o.ziel.containsKey('person')).firstOrNull ?? x.optionen.first).id],
    };
    for (final s in strategien.entries) {
      stdout.writeln('  ${s.key}: ${[for (final p in kanon.pfade) '$p ${sim.verlauf(p, s.value(p)).punkte}'].join(' · ')}');
    }
    stdout.writeln('');
  }
  stdout.writeln(verstoesse.isEmpty ? 'Simulator: OK (${uhr.elapsedMilliseconds} ms)' : 'Simulator: ${verstoesse.length} Verstöße');
  for (final v in verstoesse) {
    stdout.writeln('  - $v');
  }
  exitCode = verstoesse.isEmpty ? 0 : 1;
}

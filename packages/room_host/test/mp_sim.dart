import 'dart:io';

import 'package:burgstadt_core/burgstadt_core_io.dart';

import 'mp_simulation.dart';

/// Ebene 8: Mehrspieler-Simulation mit 4, 8 und 20 Teilnehmern über echte WebSockets.
/// `dart run test/mp_sim.dart [teilnehmer …]`
Future<void> main(List<String> args) async {
  final daten = ladeFallDaten(findeRepoWurzel()!);
  var fehler = 0;
  for (final t in args.isEmpty ? const [4, 8, 20] : args.map(int.parse)) {
    final e = await mpSimulation(daten, t, seed: t);
    stdout.writeln(e);
    for (final a in e.abweichungen) {
      stdout.writeln('  ABWEICHUNG $a');
    }
    if (e.ende == null || e.abweichungen.isNotEmpty || e.maxLatenzMs >= 1000 || e.bots < 1) fehler++;
  }
  stdout.writeln(fehler == 0 ? 'MP-SIM OK' : 'MP-SIM FEHLER ($fehler)');
  exitCode = fehler == 0 ? 0 : 1;
}

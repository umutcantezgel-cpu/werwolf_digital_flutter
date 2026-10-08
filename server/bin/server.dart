/// Mordakte-Online-Server.
///
/// Umgebungsvariablen:
/// - `PORT` (Standard 8080)
/// - `SCENARIO_DIR` (Standard `/app/content/scenarios` bzw. `../content/scenarios`)
/// - `INCLUDE_SAMPLE=1` lädt zusätzlich das Beispiel-Szenario `sample`
library;

import 'dart:async';
import 'dart:io';

import 'package:mordakte_server/rooms.dart';
import 'package:mordakte_server/runtime.dart';
import 'package:mordakte_server/scenarios.dart';
import 'package:mordakte_server/server.dart';

Future<void> main() async {
  final env = Platform.environment;
  final port = int.tryParse(env['PORT'] ?? '') ?? 8080;
  final scenarioDir = resolveScenarioDir(env['SCENARIO_DIR']);
  final scenarios = loadScenarios(scenarioDir, log: defaultLog, includeSample: env['INCLUDE_SAMPLE'] == '1');

  // Ein Fehler darf den Prozess nie beenden: alles (auch die Raum-Timer) läuft in dieser Zone.
  await runZonedGuarded(() async {
    final rooms = RoomManager(runtimeFactory: coreRuntimeFactory(scenarios));
    final server = await serveMordakte(rooms, port: port);
    defaultLog('Mordakte-Server lauscht auf :${server.port} – '
        '${scenarios.length} Szenario(s) [${scenarios.keys.join(', ')}] aus $scenarioDir');

    var stopping = false;
    Future<void> shutdown(ProcessSignal signal) async {
      if (stopping) return;
      stopping = true;
      defaultLog('$signal – fahre herunter');
      await rooms.close();
      await server.close(force: true);
      exit(0);
    }

    ProcessSignal.sigint.watch().listen(shutdown);
    if (!Platform.isWindows) ProcessSignal.sigterm.watch().listen(shutdown);
  }, (error, stack) {
    defaultLog('Unbehandelter Fehler: $error\n$stack');
  });
}

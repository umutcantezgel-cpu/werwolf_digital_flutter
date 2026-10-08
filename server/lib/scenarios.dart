/// Szenarien von Platte laden (`content/scenarios/*.json`).
library;

import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';

import 'rooms.dart' show Logger;

/// Ordner mit den Szenarien: `SCENARIO_DIR`, sonst `/app/content/scenarios`
/// (Container) bzw. `../content/scenarios` relativ zum `server`-Ordner.
String resolveScenarioDir(String? fromEnv) {
  if (fromEnv != null && fromEnv.trim().isNotEmpty) return fromEnv.trim();
  final candidates = <String>[
    '/app/content/scenarios',
    // bin/server.dart bzw. build/server → ../../content/scenarios = Repo-Root/content/scenarios
    if (Platform.script.scheme == 'file') Platform.script.resolve('../../content/scenarios').toFilePath(),
    '../content/scenarios',
    'content/scenarios',
  ];
  for (final c in candidates) {
    if (Directory(c).existsSync()) return Directory(c).absolute.path;
  }
  return '../content/scenarios';
}

/// Lädt alle `*.json` in [dirPath]. Ungültige Dateien werden geloggt und übersprungen.
/// Ist nichts da (oder [includeSample]), kommt das Beispiel-Szenario dazu –
/// genau wie in der App (`ScenarioRepository`).
Map<String, ScenarioDef> loadScenarios(String dirPath, {required Logger log, bool includeSample = false}) {
  final result = <String, ScenarioDef>{};
  final dir = Directory(dirPath);
  if (!dir.existsSync()) {
    log('Szenario-Ordner fehlt: $dirPath');
  } else {
    final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json')).toList()
      ..sort((a, b) => a.path.compareTo(b.path));
    for (final file in files) {
      try {
        final def = ScenarioDef.fromJson(jsonDecode(file.readAsStringSync()) as Map<String, dynamic>);
        if (result.containsKey(def.id)) log('Szenario-ID "${def.id}" doppelt – ${file.path} ersetzt die frühere Datei');
        result[def.id] = def;
      } catch (e) {
        log('Szenario übersprungen (${file.path}): $e');
      }
    }
  }
  if (includeSample || result.isEmpty) {
    final sample = ScenarioDef.fromJson(jsonDecode(sampleScenarioJson) as Map<String, dynamic>);
    result.putIfAbsent(sample.id, () => sample);
  }
  return result;
}

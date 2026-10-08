import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mordakte_core/mordakte_core.dart';

/// Lädt alle Szenarien aus `content/scenarios/*.json` (Assets).
class ScenarioRepository {
  ScenarioRepository._(this.scenarios);

  final Map<String, ScenarioDef> scenarios;

  static Future<ScenarioRepository> load({bool includeSample = false}) async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((p) => p.startsWith('content/scenarios/') && p.endsWith('.json'))
        .toList()
      ..sort();
    final result = <String, ScenarioDef>{};
    for (final path in paths) {
      final raw = await rootBundle.loadString(path);
      final def = ScenarioDef.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      result[def.id] = def;
    }
    if (includeSample || result.isEmpty) {
      final sample = ScenarioDef.fromJson(jsonDecode(sampleScenarioJson) as Map<String, dynamic>);
      result[sample.id] = sample;
    }
    return ScenarioRepository._(result);
  }
}

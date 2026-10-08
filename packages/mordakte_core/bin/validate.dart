import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';

/// Prüft Szenario-Dateien: `dart run bin/validate.dart [datei.json|ordner …]`
/// Ohne Argumente: `../../content/scenarios` und das eingebaute Beispiel.
void main(List<String> args) {
  final targets = args.isEmpty ? ['${_root()}/content/scenarios'] : args;
  final files = <File>[];
  for (final t in targets) {
    final type = FileSystemEntity.typeSync(t);
    if (type == FileSystemEntityType.directory) {
      files.addAll(Directory(t).listSync().whereType<File>().where((f) => f.path.endsWith('.json')));
    } else if (type == FileSystemEntityType.file) {
      files.add(File(t));
    }
  }
  files.sort((a, b) => a.path.compareTo(b.path));
  final sources = <String, String>{
    if (args.isEmpty) 'sample (eingebaut)': sampleScenarioJson,
    for (final f in files) f.path: f.readAsStringSync(),
  };
  var failed = false;
  for (final e in sources.entries) {
    stdout.writeln('== ${e.key}');
    ScenarioDef s;
    try {
      s = ScenarioDef.fromJson(jsonDecode(e.value) as Map<String, dynamic>);
    } catch (err) {
      stdout.writeln('  FEHLER  $err');
      failed = true;
      continue;
    }
    final r = validateScenario(s);
    for (final m in r.errors) {
      stdout.writeln('  FEHLER  $m');
    }
    for (final m in r.warnings) {
      stdout.writeln('  Hinweis $m');
    }
    final variants = CaseGenerator.allTruths(s).length;
    stdout.writeln(r.ok
        ? '  OK – ${s.clues.length} Hinweise, ${s.suspects.length} Verdächtige, $variants Fall-Varianten'
        : '  ${r.errors.length} Fehler');
    failed |= !r.ok;
  }
  exitCode = failed ? 1 : 0;
}

String _root() {
  var dir = File(Platform.script.toFilePath()).parent;
  for (var i = 0; i < 5; i++) {
    if (Directory('${dir.path}/content').existsSync()) return dir.path;
    dir = dir.parent;
  }
  return Directory.current.path;
}

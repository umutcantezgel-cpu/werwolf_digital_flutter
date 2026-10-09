// Plausibilitätsprüfer des Partymodus (F-04): prüft die Tatnacht aller Pfade.
// Aufruf (im Paketordner): dart run bin/party_pruefen.dart [--fall schlosskeller] [--matrix <pfad>] [--wissen]
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/src/party/kanon/kanon.dart';
import 'package:mordakte_core/src/party/plausibilitaet.dart';

void main(List<String> args) {
  String? wert(String name) {
    final i = args.indexOf(name);
    return i >= 0 && i + 1 < args.length ? args[i + 1] : null;
  }

  final fall = wert('--fall') ?? 'schlosskeller';
  final ordner = '${_wurzel()}/content/party/$fall';
  final kanon = Kanon.lade((p) => jsonDecode(File('$ordner/$p').readAsStringSync()) as Map<String, Object?>);
  final pruefer = Plausibilitaet(kanon);
  final matrix = wert('--matrix');
  if (matrix != null) {
    stdout.write(pruefer.matrixMarkdown(matrix));
    return;
  }
  if (args.contains('--wissen')) {
    for (final e in pruefer.wissensUnterschiede().entries) {
      stdout.writeln('== ${e.key}');
      for (final m in e.value.entries) {
        stdout.writeln('   ${m.key}  → nur in ${m.value.join(', ')}');
      }
    }
    return;
  }
  final v = pruefer.pruefe();
  for (final x in v) {
    stdout.writeln(x);
  }
  stdout.writeln(v.isEmpty ? 'Plausibilität: OK (${kanon.pfade.length} Pfade, ${kanon.personen.length} Personen)' : 'Plausibilität: ${v.length} Verstöße');
  exitCode = v.isEmpty ? 0 : 1;
}

String _wurzel() {
  var d = Directory.current;
  while (!File('${d.path}/content/party/schema/README.md').existsSync() && !Directory('${d.path}/content/party').existsSync()) {
    final p = d.parent;
    if (p.path == d.path) break;
    d = p;
  }
  return d.path;
}

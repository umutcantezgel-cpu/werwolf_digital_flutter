// Story-Bibel des Partymodus: schreibt oder prüft content/party/<fall>/STORY-BIBEL.md.
// Aufruf (im Paketordner): dart run bin/party_bibel.dart [--fall schlosskeller] [--pruefen]
// Ohne --pruefen wird die Datei geschrieben. Mit --pruefen wird nur verglichen;
// ist die Datei veraltet, endet das Programm mit Code 1.
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/src/party/bibel.dart';
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
  final bibel = storyBibel(kanon, Plausibilitaet(kanon));
  final datei = File('$ordner/STORY-BIBEL.md');

  if (args.contains('--pruefen')) {
    final aktuell = datei.existsSync() && datei.readAsStringSync() == bibel;
    if (aktuell) {
      stdout.writeln('Story-Bibel ist aktuell: ${datei.path}');
    } else {
      stderr.writeln('Story-Bibel ist veraltet: ${datei.path}. Neu erzeugen: dart run bin/party_bibel.dart --fall $fall');
      exitCode = 1;
    }
    return;
  }

  datei.writeAsStringSync(bibel);
  stdout.writeln('Geschrieben: ${datei.path} (${bibel.split('\n').length - 1} Zeilen)');
}

/// Repo-Wurzel: der erste Vorfahr, unter dem content/party liegt.
String _wurzel() {
  var d = Directory.current;
  while (!Directory('${d.path}/content/party').existsSync()) {
    final p = d.parent;
    if (p.path == d.path) throw StateError('content/party nicht gefunden');
    d = p;
  }
  return d.path;
}

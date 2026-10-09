// Erzeugt die Bildprompts des Partymodus (F3-BAUMEISTER-02) aus bild.json und dem Kanon.
// Aufruf (im Paketordner): dart run bin/party_prompts.dart [--fall schlosskeller] [--pruefen]
// Ohne --pruefen wird content/party/<fall>/bildprompts.json geschrieben. Mit --pruefen nur der
// Vergleich; Exitcode 1, wenn die Datei nicht dem Ergebnis entspricht.
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';

const _hinweis = 'Erzeugt, nicht von Hand ändern: dart run bin/party_prompts.dart';

void main(List<String> args) {
  String? wert(String name) {
    final i = args.indexOf(name);
    return i >= 0 && i + 1 < args.length ? args[i + 1] : null;
  }

  final fall = wert('--fall') ?? 'schlosskeller';
  final ordner = '${_wurzel()}/content/party/$fall';
  Map<String, Object?> lies(String pfad) => jsonDecode(File('$ordner/$pfad').readAsStringSync()) as Map<String, Object?>;

  final kanon = Kanon.lade(lies);
  final prompts = bildprompts(kanon, lies('bild.json'));
  final json = const JsonEncoder.withIndent('  ').convert({
    'hinweis': _hinweis,
    'prompts': [for (final p in prompts) {'id': p.id, 'art': p.art, 'prompt': p.prompt}],
  });
  final inhalt = '$json\n';
  final datei = File('$ordner/bildprompts.json');

  if (args.contains('--pruefen')) {
    final aktuell = datei.existsSync() && datei.readAsStringSync() == inhalt;
    stdout.writeln(aktuell
        ? 'Bildprompts: aktuell (${prompts.length} Prompts)'
        : 'Bildprompts: veraltet, neu erzeugen mit: dart run bin/party_prompts.dart');
    exitCode = aktuell ? 0 : 1;
    return;
  }
  datei.writeAsStringSync(inhalt);
  stdout.writeln('Bildprompts geschrieben: ${datei.path} (${prompts.length} Prompts)');
}

String _wurzel() {
  var d = Directory.current;
  while (!Directory('${d.path}/content/party').existsSync()) {
    final p = d.parent;
    if (p.path == d.path) throw StateError('content/party nicht gefunden');
    d = p;
  }
  return d.path;
}

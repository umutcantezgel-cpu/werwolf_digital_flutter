// BOLLWERK · Kanon einbetten (A-5 L3 Schritt 1). Schreibt die Kanon-Dateien des
// Schlosskellers als Dart-Konstanten, damit der Determinismus-Test ohne dart:io auch
// auf Node und Chrome läuft.
// Aufruf: dart run tool/bollwerk/kanon_einbetten.dart [--pruefe]
//   --pruefe: rot (Exit 1), wenn die eingecheckte Datei nicht dem Kanon entspricht.
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';

const ziel = 'packages/mordakte_core/test/web/kanon_eingebettet.g.dart';

void main(List<String> args) {
  final bw = File(Platform.script.toFilePath()).parent.parent.parent.path;
  final ordner = '$bw/content/party/schlosskeller';
  final pfade = (jsonDecode(File('$ordner/fall.json').readAsStringSync()) as Map)['pfade'] as List;
  final dateien = [...Kanon.dateien, for (final p in pfade) 'tatmatrix/$p.json'];
  final aus = StringBuffer()
    ..writeln('// GENERIERT von tool/bollwerk/kanon_einbetten.dart – nicht von Hand ändern.')
    ..writeln('// Kanon 1.0 des Schlosskellers als Konstanten für Tests ohne dart:io (L3).')
    ..writeln('// ignore_for_file: prefer_single_quotes, lines_longer_than_80_chars')
    ..writeln()
    ..writeln('const Map<String, String> kanonEingebettet = {');
  for (final d in dateien) {
    final text = File('$ordner/$d').readAsStringSync();
    aus.writeln('  ${jsonEncode(d)}: ${jsonEncode(text).replaceAll(r'$', r'\$')},');
  }
  aus.writeln('};');
  final f = File('$bw/$ziel');
  if (args.contains('--pruefe')) {
    final gleich = f.existsSync() && f.readAsStringSync() == aus.toString();
    stdout.writeln('Kanon eingebettet: ${gleich ? 'gleich' : 'ABWEICHEND'} (${dateien.length} Dateien)');
    exit(gleich ? 0 : 1);
  }
  f.parent.createSync(recursive: true);
  f.writeAsStringSync(aus.toString());
  stdout.writeln('geschrieben: $ziel (${dateien.length} Dateien)');
}

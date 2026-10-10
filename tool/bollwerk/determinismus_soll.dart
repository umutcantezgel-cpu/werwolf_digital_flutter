// BOLLWERK · Soll-Liste für L3 schreiben (einmal; Vergleichsstand, nie neu schreiben,
// um ein Tor grün zu machen – A-2 A4.4). Aufruf: dart run tool/bollwerk/determinismus_soll.dart --schreibe
import 'dart:io';

import '../../packages/mordakte_core/test/runden/determinismus_lauf.dart';

void main(List<String> args) {
  if (!args.contains('--schreibe')) {
    stdout.writeln('Aufruf: dart run tool/bollwerk/determinismus_soll.dart --schreibe');
    exit(2);
  }
  final bw = File(Platform.script.toFilePath()).parent.parent.parent.path;
  final f = File('$bw/packages/mordakte_core/test/runden/determinismus_soll.g.dart');
  if (f.existsSync()) {
    stdout.writeln('Soll-Liste existiert schon – Vergleichsstände werden nie neu geschrieben.');
    exit(1);
  }
  final l = determinismusListe();
  final aus = StringBuffer()
    ..writeln('// GENERIERT von tool/bollwerk/determinismus_soll.dart (VM) – Vergleichsstand für L3, nie neu schreiben.')
    ..writeln('const List<int> determinismusSoll = [');
  for (var i = 0; i < l.length; i += 8) {
    aus.writeln('  ${l.skip(i).take(8).join(', ')},');
  }
  aus.writeln('];');
  f.writeAsStringSync(aus.toString());
  stdout.writeln('geschrieben: ${l.length} Summen');
}

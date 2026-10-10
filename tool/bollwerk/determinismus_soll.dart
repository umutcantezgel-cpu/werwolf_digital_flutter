// BOLLWERK · Soll-Liste für L3 schreiben (einmal je Kern-Version; Vergleichsstand, nie neu schreiben,
// um ein Tor grün zu machen – A-2 A4.4). Eine neue Kern-Version (ENTSCHEIDUNGSLOG „KERN 1.x“) ändert
// das Protokoll gewollt und bekommt eine eigene Datei; ältere Listen bleiben unverändert liegen.
// Aufruf: dart run tool/bollwerk/determinismus_soll.dart --schreibe [--kern <1.x>]
import 'dart:io';

import '../../packages/mordakte_core/test/runden/determinismus_lauf.dart';

void main(List<String> args) {
  if (!args.contains('--schreibe')) {
    stdout.writeln('Aufruf: dart run tool/bollwerk/determinismus_soll.dart --schreibe [--kern <1.x>]');
    exit(2);
  }
  final bw = File(Platform.script.toFilePath()).parent.parent.parent.path;
  final ki = args.indexOf('--kern');
  final kern = ki >= 0 ? args[ki + 1] : '1.0';
  final name = kern == '1.0' ? 'determinismus_soll.g.dart' : 'determinismus_soll_k${kern.replaceAll('.', '')}.g.dart';
  final f = File('$bw/packages/mordakte_core/test/runden/$name');
  if (f.existsSync()) {
    stdout.writeln('Soll-Liste existiert schon – Vergleichsstände werden nie neu geschrieben.');
    exit(1);
  }
  final l = determinismusListe();
  final aus = StringBuffer()
    ..writeln('// GENERIERT von tool/bollwerk/determinismus_soll.dart (VM, Kern $kern) – Vergleichsstand für L3, nie neu schreiben.')
    ..writeln('const List<int> determinismusSoll = [');
  for (var i = 0; i < l.length; i += 8) {
    aus.writeln('  ${l.skip(i).take(8).join(', ')},');
  }
  aus.writeln('];');
  f.writeAsStringSync(aus.toString());
  stdout.writeln('geschrieben: ${l.length} Summen');
}

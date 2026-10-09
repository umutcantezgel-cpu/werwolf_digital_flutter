// Entwicklerwerkzeug: ASCII-Karte des Raumkanons mit Standorten (Ziffern/Buchstaben).
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/src/party/raumgraph.dart';

void main() {
  final g = RaumGraph.fromJson(jsonDecode(File('../../content/party/schlosskeller/raeume.json').readAsStringSync()) as Map<String, Object?>);
  final zeilen = [for (final r in g.karte.rows) r.split('')];
  for (final p in g.karte.props) {
    zeilen[p.y][p.x] = 'o';
  }
  const zeichen = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  var i = 0;
  final legende = <String>[];
  for (final o in g.orte.values) {
    final c = zeichen[i++ % zeichen.length];
    zeilen[o.y.floor()][o.x.floor()] = c;
    legende.add('$c=${o.id}');
  }
  stdout.writeln('   ${List.generate(g.breite, (x) => (x % 10).toString()).join()}');
  for (var y = 0; y < zeilen.length; y++) {
    stdout.writeln('${y.toString().padLeft(2)} ${zeilen[y].join()}');
  }
  stdout.writeln(legende.join('  '));
}

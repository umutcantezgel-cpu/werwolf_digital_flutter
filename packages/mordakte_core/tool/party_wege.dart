// Entwicklerwerkzeug: Weglängen und Sichtlinien zwischen Standorten des Raumkanons.
// Aufruf: dart run tool/party_wege.dart <ort> [<ort> ...]
// Ohne zweites Argument: Entfernungen vom ersten Ort zu allen anderen.
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/src/party/raumgraph.dart';

void main(List<String> args) {
  final pfad = '../../content/party/schlosskeller/raeume.json';
  final g = RaumGraph.fromJson(jsonDecode(File(pfad).readAsStringSync()) as Map<String, Object?>);
  if (args.isEmpty) {
    stdout.writeln(g.orte.keys.join(' '));
    return;
  }
  final ziele = args.length > 1 ? args.sublist(1) : g.orte.keys.toList();
  for (final z in ziele) {
    final w = g.weg(args.first, z);
    stdout.writeln('${args.first} -> $z: ${w?.toStringAsFixed(2) ?? "kein Weg"} m, Sicht: ${g.sichtlinie(args.first, z)}');
  }
}

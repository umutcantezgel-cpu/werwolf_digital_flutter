// Entwicklerwerkzeug: Wahrnehmungen eines Pfads in einem Zeitfenster ausgeben.
// Aufruf: dart run tool/party_tatnacht.dart <pfad> [von] [bis] [person ...]
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/src/party/raumgraph.dart';
import 'package:mordakte_core/src/party/tatmatrix.dart';
import 'package:mordakte_core/src/party/wahrnehmung.dart';
import 'package:mordakte_core/src/party/zeit.dart';

Map<String, Object?> lies(String p) => jsonDecode(File('../../content/party/schlosskeller/$p').readAsStringSync()) as Map<String, Object?>;

void main(List<String> args) {
  final pfad = args.isEmpty ? 'can' : args[0];
  final von = Uhrzeit.parse(args.length > 1 ? args[1] : '23:58:00');
  final bis = Uhrzeit.parse(args.length > 2 ? args[2] : '00:00:00');
  final nur = args.length > 3 ? args.sublist(3).toSet() : <String>{};
  final g = RaumGraph.fromJson(lies('raeume.json'));
  final r = WahrnehmungsRegeln.fromJson(lies('wahrnehmung.json'));
  final m = Tatmatrix.zusammen(TatmatrixDatei.fromJson(lies('tatmatrix/basis.json')), TatmatrixDatei.fromJson(lies('tatmatrix/$pfad.json')));
  final a = Ablauf(g, m, start: r.planVon, ende: r.planBis);
  for (final f in a.fehler) {
    stdout.writeln('FEHLER $f');
  }
  final w = WahrnehmungsRechner(g, a, r).berechne();
  for (final x in w) {
    if (x.bis < von || x.von > bis) continue;
    if (nur.isNotEmpty && !nur.contains(x.wer)) continue;
    if (x.sinn == 'sehen' && x.detail == 'erkannt' && x.von < Uhrzeit.parse('23:58:00')) continue;
    stdout.writeln(x);
  }
}

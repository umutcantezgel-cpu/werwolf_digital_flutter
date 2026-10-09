// Entwicklerwerkzeug: Was nimmt jede Person je Pfad anders wahr?
// Vergleicht die Wahrnehmungen 23:58:00–0:00:00 über die Pfade, in denen die Person unschuldig ist.
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/src/party/raumgraph.dart';
import 'package:mordakte_core/src/party/tatmatrix.dart';
import 'package:mordakte_core/src/party/wahrnehmung.dart';
import 'package:mordakte_core/src/party/zeit.dart';

Map<String, Object?> lies(String p) => jsonDecode(File('../../content/party/schlosskeller/$p').readAsStringSync()) as Map<String, Object?>;

const pfade = ['ahmet', 'fatma', 'olli', 'can'];

void main(List<String> args) {
  final g = RaumGraph.fromJson(lies('raeume.json'));
  final r = WahrnehmungsRegeln.fromJson(lies('wahrnehmung.json'));
  final basis = TatmatrixDatei.fromJson(lies('tatmatrix/basis.json'));
  final von = Uhrzeit.parse('23:58:00'), bis = Uhrzeit.parse('00:00:00');
  final wissen = <String, Map<String, Set<String>>>{}; // person -> pfad -> merkmale
  for (final p in pfade) {
    final m = Tatmatrix.zusammen(basis, TatmatrixDatei.fromJson(lies('tatmatrix/$p.json')));
    final a = Ablauf(g, m, start: r.planVon, ende: r.planBis);
    for (final f in a.fehler) {
      stdout.writeln('FEHLER [$p] $f');
    }
    final ws = WahrnehmungsRechner(g, a, r).berechne();
    final scheppern = Uhrzeit.parse('23:58:40');
    for (final w in ws) {
      if (w.bis < von || w.von > bis) continue;
      if (w.sinn == 'riechen') continue;
      final hoertScheppern = ws.any((x) => x.wer == w.wer && x.quelle == 'ev_scheppern');
      final lage = !hoertScheppern ? '' : (w.bis < scheppern ? ' VOR' : (w.von > scheppern ? ' NACH' : ' WÄHREND'));
      final art = w.quelle.contains(':') ? w.quelle.split(':').first : w.quelle;
      final wer = (w.detail == 'anonym' || w.detail == 'umriss' || w.detail == 'leuchten')
          ? (w.sinn == 'fuehlen' ? 'jemand' : art)
          : w.quelle;
      final raum = w.person == null ? '' : ' @${a.zustand(w.person!, w.von)?.raum ?? '?'}';
      final merkmal = '${w.sinn} $wer ${w.detail}$raum$lage';
      ((wissen[w.wer] ??= {})[p] ??= {}).add(merkmal);
    }
  }
  for (final person in wissen.keys.toList()..sort()) {
    final je = wissen[person]!;
    final relevant = [for (final p in pfade) if (p != person) p];
    final alle = <String>{for (final p in relevant) ...?je[p]};
    final unterschiede = <String, List<String>>{};
    for (final mk in alle) {
      final in_ = [for (final p in relevant) if (je[p]?.contains(mk) ?? false) p];
      if (in_.length != relevant.length) (unterschiede[mk] = in_);
    }
    if (unterschiede.isEmpty) continue;
    stdout.writeln('== $person (unschuldig in ${relevant.join(", ")})');
    for (final e in unterschiede.entries) {
      stdout.writeln('   ${e.key}  → nur in ${e.value.join(", ")}');
    }
  }
}

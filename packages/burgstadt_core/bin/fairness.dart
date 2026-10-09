/// Fairness-Werkzeug (Auftrag A-404a): prüft für N = 4…20 die Absicherung der
/// notwendigen Schlüsse S-1…S-7 mit `pruefeFairness` (Regeln wie kanon.py).
///
/// Aufruf im Paket: `dart run bin/fairness.dart`
/// Ausgabe: Tabelle N × S mit der Zahl zählender Hinweise, dann „FAIRNESS OK“ oder
/// „FAIRNESS FEHLER (n)“ mit der Befundliste. Exit-Code 1 bei Befunden.
library;

import 'dart:convert';
import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';

void main() {
  final wurzel = findeRepoWurzel();
  if (wurzel == null) {
    stderr.writeln('Repo-Wurzel (Ordner mit nachtlauf/ und packages/) nicht gefunden.');
    exit(2);
  }
  final daten = ladeFallDaten(wurzel);
  final welt = _baueWelt('$wurzel/packages/burgstadt_core/data');
  final berichte = [for (var n = 4; n <= 20; n++) pruefeFairness(daten, welt, n)];
  final schluesse = daten.notwendig.toList()
    ..sort((a, b) => int.parse(a.substring(2)).compareTo(int.parse(b.substring(2))));

  stdout.writeln('Zählende Hinweise je Besetzung (N) und notwendigem Schluss:');
  stdout.writeln('N   ${[for (final s in schluesse) s.padLeft(5)].join()}');
  for (final b in berichte) {
    stdout.writeln('${b.n.toString().padLeft(2)}  ${[for (final s in schluesse) '${b.zaehlend(s)}'.padLeft(5)].join()}');
  }

  final befunde = <String>{for (final b in berichte) ...b.befunde}.toList()..sort();
  if (befunde.isEmpty) {
    stdout.writeln('FAIRNESS OK');
    exit(0);
  }
  stdout.writeln('FAIRNESS FEHLER (${befunde.length})');
  for (final x in befunde) {
    stdout.writeln('  - $x');
  }
  exit(1);
}

/// Welt wie im Stadt-Test: Burg, Innenräume aus Daten und Stadt mit Fall-Orten.
Map<String, Bereich> _baueWelt(String daten) {
  final innen = [
    for (final f in Directory('$daten/innenraeume').listSync().whereType<File>())
      if (f.path.endsWith('.json')) jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
  ];
  final haeuser = [
    for (final h in (jsonDecode(File('$daten/stadt/haeuser.json').readAsStringSync()) as Map)['haeuser'] as List)
      h as Map<String, dynamic>,
  ];
  return baueWelt(innen, haeuser: haeuser);
}

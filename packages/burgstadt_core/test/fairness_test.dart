import 'dart:convert';
import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:test/test.dart';

/// Fairness-Löser (Auftrag A-404a): alle Besetzungen N = 4…20 abgesichert, dazu Gegenproben.
void main() {
  final wurzel = findeRepoWurzel()!;

  test('N = 4…20: jeder notwendige Schluss S-1…S-7 ist ohne Befund abgesichert', () {
    final d = ladeFallDaten(wurzel);
    final welt = _ladeWelt(wurzel);
    for (var n = 4; n <= 20; n++) {
      final b = pruefeFairness(d, welt, n);
      expect(b.schluesse.keys, equals(['S-1', 'S-2', 'S-3', 'S-4', 'S-5', 'S-6', 'S-7']), reason: 'N=$n');
      expect(b.befunde, isEmpty, reason: 'N=$n');
    }
  });

  test('Gesprächsquelle: Ersatzfall zählt nur, wenn das reguläre Ziel fehlt (N=4: H-108 ja, H-107 nein)', () {
    final b = pruefeFairness(ladeFallDaten(wurzel), _ladeWelt(wurzel), 4);
    expect(b.schluesse['S-6']!.zaehlend, contains('H-108'));
    expect(b.schluesse['S-6']!.zaehlend, isNot(contains('H-107')));
  });

  test('Gegenprobe: ein entfernter Hinweis führt bei N=4 zum Befund (unabhängige Orte)', () {
    // S-1 hat bei N=4 drei Quellen, aber nur zwei Orte: BS-11 (H-01, H-02) und den
    // Erzähler (H-03). Ohne H-03 bleibt nur der Ort BS-11.
    final d = ladeFallDaten(wurzel)..hinweise.remove('H-03');
    final b = pruefeFairness(d, _ladeWelt(wurzel), 4);
    expect(b.befunde, contains('ABSICHERUNG S-1 N=4: 1 unabhängige Orte (Soll 2)'));
  });

  test('Gegenprobe: eine Station, die in der Welt fehlt, führt zum Befund', () {
    final welt = _ladeWelt(wurzel);
    for (final bereich in welt.values) {
      bereich.dinge.removeWhere((ding) => ding.legende.station == 'BS-11');
    }
    final b = pruefeFairness(ladeFallDaten(wurzel), welt, 4);
    expect(b.befunde, contains('S-1: Station BS-11 für H-01 fehlt in der Welt'));
    expect(b.befunde, contains('S-1: Station BS-11 für H-02 fehlt in der Welt'));
  });
}

/// Welt wie im Stadt-Test: Burg, Innenräume aus Daten und Stadt mit Fall-Orten.
Map<String, Bereich> _ladeWelt(String wurzel) {
  final daten = '$wurzel/packages/burgstadt_core/data';
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

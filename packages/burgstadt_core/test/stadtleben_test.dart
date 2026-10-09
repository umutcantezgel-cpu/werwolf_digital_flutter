import 'dart:convert';
import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:test/test.dart';

import 'fall_daten_test.dart' show ladeFall;

/// Stadtbewohner (Z-03: mindestens 40) leben nach ihrem Nachtplan in der generierten Oberstadt.
void main() {
  final w = findeRepoWurzel()!;
  final innen = [
    for (final f in Directory('$w/packages/burgstadt_core/data/innenraeume').listSync().whereType<File>())
      if (f.path.endsWith('.json')) jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
  ];
  List<Map<String, dynamic>> liste(String datei, String feld) => [
        for (final h in (jsonDecode(File('$w/packages/burgstadt_core/data/stadt/$datei').readAsStringSync()) as Map)[feld] as List)
          h as Map<String, dynamic>,
      ];
  final haeuser = liste('haeuser.json', 'haeuser');
  final bewohnerDaten = liste('bewohner.json', 'bewohner');
  final welt = Welt(baueWelt(innen, haeuser: haeuser));
  final daten = ladeFall();

  Simulation neu() => Simulation(welt, FallZustand(daten, 8)..starte(), bewohnerDaten: bewohnerDaten, haeuser: haeuser);

  bool stehtFrei(Figur f) => welt.bereiche[f.bereich]!.frei(f.x, f.z, r: 0.15);

  test('Alle 44 Bewohner sind in der Simulation (Z-03: ≥ 40), keiner bekommt Fallaufgaben', () {
    final sim = neu();
    expect(sim.bewohner.length, bewohnerDaten.length);
    expect(sim.bewohner.length, greaterThanOrEqualTo(40));
    for (final id in sim.bewohner.keys) {
      expect(sim.figuren[id]!.bewohner, isTrue);
      expect(sim.fall.rollen, isNot(contains(id)));
    }
  });

  test('Nachtplan: sichtbar nur, wer wach ist; jeder Sichtbare steht frei in einem echten Bereich', () {
    final sim = neu();
    final sichtbar = sim.figuren.values.where((f) => f.bewohner && !f.verborgen).toList();
    expect(sichtbar, isNotEmpty);
    for (final f in sichtbar) {
      final b = sim.bewohner[f.id]!;
      expect(b.nacht[b.eintragUm(sim.fall.uhr)].zustand, isNot('schläft'), reason: f.id);
      expect(stehtFrei(f), isTrue, reason: '${f.id} in ${f.bereich} bei ${f.x}/${f.z}');
    }
  });

  test('Im Lauf der Nacht: Pläne wechseln, Streifende bewegen sich, niemand steht in einer Wand', () {
    final sim = neu();
    final start = {for (final f in sim.figuren.values.where((f) => f.bewohner)) f.id: (f.bereich, f.x, f.z)};
    final gesehen = <String>{};
    var bewegt = 0;
    for (var i = 0; i < 30 * 600; i++) {
      // eine Echtsekunde = 1/30 · tempo Spielminuten; Uhr direkt vorstellen, damit die ganze Nacht läuft
      sim.fall.uhr += 0.02;
      sim.tick(1 / 30);
      if (i % 300 == 0) {
        for (final f in sim.figuren.values.where((f) => f.bewohner && !f.verborgen)) {
          gesehen.add(f.id);
          expect(stehtFrei(f), isTrue, reason: '${f.id} in ${f.bereich} bei ${f.x}/${f.z} um ${sim.fall.uhr}');
        }
      }
    }
    for (final f in sim.figuren.values.where((f) => f.bewohner)) {
      final s = start[f.id]!;
      if (s.$1 != f.bereich || s.$2 != f.x || s.$3 != f.z) bewegt++;
    }
    expect(gesehen.length, greaterThanOrEqualTo(20), reason: 'mindestens 20 Bewohner zeigen sich in der Nacht');
    expect(bewegt, greaterThanOrEqualTo(10));
  });

  test('Ansprechen: ein Bewohner erzählt, was er gerade tut', () {
    final sim = neu();
    final f = sim.figuren.values.firstWhere((f) => f.bewohner && !f.verborgen);
    final e = sim.detektivFragt(f.id);
    expect(e.single.art, 'erzaehler');
    expect(e.single.text, startsWith(sim.bewohner[f.id]!.name));
  });

  test('Deterministisch', () {
    String lage(Simulation s) => [for (final f in s.figuren.values.where((f) => f.bewohner)) '${f.id}:${f.bereich}:${f.x}:${f.z}'].join('|');
    final a = neu(), b = neu();
    for (var i = 0; i < 600; i++) {
      a.tick(1 / 30);
      b.tick(1 / 30);
    }
    expect(lage(a), lage(b));
  });
}

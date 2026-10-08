/// Laden von Kanon und Figurendaten über dart:io (Werkzeuge, Tests, Desktop).
library;

import 'dart:convert';
import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:pixel_engine/pixel_engine.dart';

import 'src/figuren_lager.dart';
import 'src/spiel.dart';
import 'src/texte.dart';

/// Lädt Kanon + Overlay, Figurenteile und Steckbriefe/Karten aus dem Repo in [spiel].
void ladeAusRepo(Spiel spiel) {
  final w = findeRepoWurzel()!;
  final k = kanonLesen('$w/krimidinner/spuk-im-gewoelbe/10_kanon')
      .mitOverlay(File('$w/nachtlauf/kanon/ANPASSUNG.md').readAsStringSync(), datei: 'ANPASSUNG.md');
  spiel.fallDaten = FallDaten(k);
  final innen = Directory('$w/packages/burgstadt_core/data/innenraeume');
  if (innen.existsSync()) {
    List<Map<String, dynamic>>? liste(String datei, String feld) {
      final f = File('$w/packages/burgstadt_core/data/stadt/$datei');
      return f.existsSync() ? [for (final h in (jsonDecode(f.readAsStringSync()) as Map)[feld] as List) h as Map<String, dynamic>] : null;
    }

    final haeuser = liste('haeuser.json', 'haeuser');
    spiel.haeuserDaten = haeuser ?? const [];
    spiel.bewohnerDaten = liste('bewohner.json', 'bewohner') ?? const [];
    spiel.setzeWelt(baueWelt([
      for (final f in innen.listSync().whereType<File>())
        if (f.path.endsWith('.json')) jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
    ], haeuser: haeuser));
  }
  final texte = '$w/packages/burgstadt_spiel/data/texte';
  if (File('$texte/erzaehler.json').existsSync()) {
    spiel.erzaehler = Erzaehler.ausJson(jsonDecode(File('$texte/erzaehler.json').readAsStringSync()) as Map<String, dynamic>);
  }
  if (File('$texte/tutorial.json').existsSync()) {
    spiel.tutorial = Tutorial.ausJson(jsonDecode(File('$texte/tutorial.json').readAsStringSync()) as Map<String, dynamic>);
  }
  final fig = '$w/packages/pixel_engine/data/figuren';
  for (final name in ['teile_koepfe.json', 'teile_kleidung.json']) {
    final f = File('$fig/$name');
    if (f.existsSync()) spiel.teile.addAll(teileAusJson(jsonDecode(f.readAsStringSync()) as Map<String, dynamic>));
  }
  final karten = File('$fig/karten.json');
  if (karten.existsSync()) {
    for (final k in (jsonDecode(karten.readAsStringSync()) as Map)['karten'] as List) {
      final karte = Figurenkarte.ausJson(k as Map<String, dynamic>);
      spiel.karten[karte.id] = karte;
    }
  } else {
    for (final s in (jsonDecode(File('$fig/rollen.json').readAsStringSync()) as Map)['figuren'] as List) {
      final karte = karteAusSteckbrief(s as Map<String, dynamic>);
      spiel.karten[karte.id] = karte;
    }
  }
}

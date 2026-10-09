import 'dart:convert';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:flutter/services.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Lädt Kanon + Overlay und Figurendaten aus den App-Assets in [spiel].
/// Solo-Spiel: der volle Kanon liegt auf dem Gerät (Entscheidungslog, Spoilerschutz nur im Mehrspieler).
Future<void> ladeSpielDaten(Spiel spiel) async {
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  const kanonPfad = 'krimidinner/spuk-im-gewoelbe/10_kanon/';
  final dateien = <String, String>{};
  for (final a in manifest.listAssets().where((a) => a.startsWith(kanonPfad))) {
    final name = a.substring(kanonPfad.length);
    if (istKanonDatei(name)) dateien[name] = await rootBundle.loadString(a);
  }
  final overlay = await rootBundle.loadString('nachtlauf/kanon/ANPASSUNG.md');
  final kanon = Kanon.ausText(dateien).mitOverlay(overlay, datei: 'ANPASSUNG.md');
  const fig = 'packages/pixel_engine/data/figuren/';
  final da = manifest.listAssets().toSet();
  for (final name in ['teile_koepfe.json', 'teile_kleidung.json']) {
    if (!da.contains('$fig$name')) continue;
    spiel.teile.addAll(teileAusJson(jsonDecode(await rootBundle.loadString('$fig$name')) as Map<String, dynamic>));
  }
  if (da.contains('${fig}karten.json')) {
    final j = jsonDecode(await rootBundle.loadString('${fig}karten.json')) as Map;
    for (final k in j['karten'] as List) {
      final karte = Figurenkarte.ausJson(k as Map<String, dynamic>);
      spiel.karten[karte.id] = karte;
    }
  } else {
    final j = jsonDecode(await rootBundle.loadString('${fig}rollen.json')) as Map;
    for (final s in j['figuren'] as List) {
      final karte = karteAusSteckbrief(s as Map<String, dynamic>);
      spiel.karten[karte.id] = karte;
    }
  }
  final fall = FallDaten(kanon);
  const faehigkeitenPfad = 'packages/burgstadt_core/data/rollen/faehigkeiten.json';
  if (da.contains(faehigkeitenPfad)) {
    fall.faehigkeiten.addAll(faehigkeitenAusJson(jsonDecode(await rootBundle.loadString(faehigkeitenPfad)) as Map<String, dynamic>));
  }
  spiel.fallDaten = fall;
  const innenPfad = 'packages/burgstadt_core/data/innenraeume/';
  final innen = [
    for (final a in da.where((a) => a.startsWith(innenPfad) && a.endsWith('.json')))
      jsonDecode(await rootBundle.loadString(a)) as Map<String, dynamic>,
  ];
  // Oberstadt aus dem Generator (Häuserliste); fehlt sie, bleibt es beim Marktplatz.
  const haeuserPfad = 'packages/burgstadt_core/data/stadt/haeuser.json';
  final haeuser = da.contains(haeuserPfad)
      ? [
          for (final h in (jsonDecode(await rootBundle.loadString(haeuserPfad)) as Map)['haeuser'] as List)
            h as Map<String, dynamic>,
        ]
      : null;
  spiel.haeuserDaten = haeuser ?? const [];
  const bewohnerPfad = 'packages/burgstadt_core/data/stadt/bewohner.json';
  if (da.contains(bewohnerPfad)) {
    spiel.bewohnerDaten = [
      for (final b in (jsonDecode(await rootBundle.loadString(bewohnerPfad)) as Map)['bewohner'] as List) b as Map<String, dynamic>,
    ];
  }
  spiel.setzeWelt(baueWelt(innen, haeuser: haeuser));
  spiel.geometrieVorbauen(); // Ladezeit statt Nachladespitze beim ersten Betreten
  const texte = 'packages/burgstadt_spiel/data/texte/';
  if (da.contains('${texte}erzaehler.json')) {
    spiel.erzaehler = Erzaehler.ausJson(jsonDecode(await rootBundle.loadString('${texte}erzaehler.json')) as Map<String, dynamic>);
  }
  if (da.contains('${texte}tutorial.json')) {
    spiel.tutorial = Tutorial.ausJson(jsonDecode(await rootBundle.loadString('${texte}tutorial.json')) as Map<String, dynamic>);
  }
}

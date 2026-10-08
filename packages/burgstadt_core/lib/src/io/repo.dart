import 'dart:convert';
import 'dart:io';

import '../fall/faehigkeiten.dart';
import '../fall/fall_daten.dart';
import '../kanon/kanon.dart';

/// Sucht vom Startordner (Standard: aktuelles Verzeichnis) nach oben den Repo-
/// Ordner, der `nachtlauf/` und `packages/` enthält. `null`, wenn keiner passt.
String? findeRepoWurzel({String? von}) {
  var dir = Directory(von ?? Directory.current.path).absolute;
  while (true) {
    final p = dir.path;
    if (Directory('$p/nachtlauf').existsSync() && Directory('$p/packages').existsSync()) return p;
    final eltern = dir.parent;
    if (eltern.path == p) return null;
    dir = eltern;
  }
}

/// Liest alle `K*.md` aus [kanonOrdner] (Unterordner wie `entwuerfe/` fallen weg).
Kanon kanonLesen(String kanonOrdner) {
  final inhalte = <String, String>{};
  for (final eintrag in Directory(kanonOrdner).listSync()) {
    if (eintrag is! File) continue;
    final name = eintrag.uri.pathSegments.last;
    if (istKanonDatei(name)) inhalte[name] = eintrag.readAsStringSync();
  }
  return Kanon.ausText(inhalte);
}

/// Falldaten aus dem Repo [wurzel]: Kanon + Anpassung (Overlay) + Rollen-Fähigkeiten.
FallDaten ladeFallDaten(String wurzel) {
  final k = kanonLesen('$wurzel/krimidinner/spuk-im-gewoelbe/10_kanon')
      .mitOverlay(File('$wurzel/nachtlauf/kanon/ANPASSUNG.md').readAsStringSync(), datei: 'ANPASSUNG.md');
  final d = FallDaten(k);
  final f = File('$wurzel/packages/burgstadt_core/data/rollen/faehigkeiten.json');
  if (f.existsSync()) d.faehigkeiten.addAll(faehigkeitenAusJson(jsonDecode(f.readAsStringSync()) as Map<String, dynamic>));
  return d;
}

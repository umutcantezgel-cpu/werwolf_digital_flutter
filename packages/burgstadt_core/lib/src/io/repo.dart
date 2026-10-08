import 'dart:io';

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

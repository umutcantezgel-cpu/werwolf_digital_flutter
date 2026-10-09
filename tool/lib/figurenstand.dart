/// Figurenstand (Entscheidung E-039) für die HD-Abnahme `tool/hd_abnahme.dart`.
///
/// Ein Hash über alle Dateien, die das Aussehen der Figuren bestimmen. Die Sichtprüfer tragen ihn
/// als Zusatzzeile „Figurenstand `<hash>`“ in ihren Bericht ein. Ändert sich eine erfasste Datei,
/// ändert sich der Hash, und Berichte zu einem älteren Stand zählen für den neuen nicht mehr.
library;

import 'dart:io';

/// Erfasste Dateien relativ zur Repo-Wurzel: Figurendaten (Karten, Rollen, Teile), die Figuren in
/// HD-Dichte und die Figur-Engine.
final _muster = <RegExp>[
  RegExp(r'^packages/pixel_engine/data/figuren/karten\.json$'),
  RegExp(r'^packages/pixel_engine/data/figuren/rollen\.json$'),
  RegExp(r'^packages/pixel_engine/data/figuren/teile_[^/]+\.json$'),
  RegExp(r'^packages/pixel_engine/data/figuren_hd/.+$'),
  RegExp(r'^packages/pixel_engine/lib/src/figur/[^/]+\.dart$'),
];

/// Die erfassten Dateien, nach Pfad sortiert. Quelle ist `git ls-files` (nur verfolgte Dateien).
/// Ein Verzeichnis `figuren_hd/` darf fehlen oder leer sein.
List<String> figurenDateien(String wurzel) {
  final r = Process.runSync('git', ['ls-files'], workingDirectory: wurzel);
  if (r.exitCode != 0) {
    throw StateError('git ls-files fehlgeschlagen: ${r.stderr}');
  }
  final pfade = [
    for (final zeile in (r.stdout as String).split('\n'))
      if (zeile.isNotEmpty && _muster.any((m) => m.hasMatch(zeile))) zeile,
  ]..sort();
  return pfade;
}

/// Der Figurenstand: die ersten 10 Hex-Zeichen von `git hash-object --stdin` über den Text mit einer
/// Zeile `<pfad> <blobhash>` je erfasster Datei (nach Pfad sortiert). Der Blob-Hash ist der Hash
/// der Datei im Arbeitsbaum, Änderungen ohne Commit wirken also sofort.
String figurenstand(String wurzel) {
  final pfade = figurenDateien(wurzel);
  final hashes = <String>[];
  if (pfade.isNotEmpty) {
    final r = Process.runSync('git', ['hash-object', '--', ...pfade], workingDirectory: wurzel);
    if (r.exitCode != 0) {
      throw StateError('git hash-object fehlgeschlagen: ${r.stderr}');
    }
    hashes.addAll((r.stdout as String).trim().split('\n'));
  }
  if (hashes.length != pfade.length) {
    throw StateError('git hash-object lieferte ${hashes.length} Hashes für ${pfade.length} Dateien');
  }
  final text = StringBuffer();
  for (var i = 0; i < pfade.length; i++) {
    text.write('${pfade[i]} ${hashes[i]}\n');
  }
  // Process.runSync kennt keine Eingabe; der Text geht daher über eine Umgebungsvariable an git.
  final h = Process.runSync(
    'sh',
    ['-c', r'printf "%s" "$FIGURENSTAND_TEXT" | git hash-object --stdin'],
    workingDirectory: wurzel,
    environment: {'FIGURENSTAND_TEXT': text.toString()},
  );
  final hash = (h.stdout as String).trim();
  if (h.exitCode != 0 || !RegExp(r'^[0-9a-f]{40}$').hasMatch(hash)) {
    throw StateError('Figurenstand: git hash-object --stdin fehlgeschlagen');
  }
  return hash.substring(0, 10);
}

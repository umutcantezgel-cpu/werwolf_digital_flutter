import 'dart:io';

import 'package:burgstadt_core/burgstadt_core_io.dart';

/// Leitplanken-Scan (Auftrag A-406).
///
/// `dart run bin/leitplanken.dart [--burgstadt | pfade …]`
/// Ohne Argumente wird der wirksame Spieltext-Bestand geprüft; `--burgstadt`
/// prüft ihn ohne die Szenarien der „Klassischen Fälle“ (`content/`). Exit 1, sobald
/// ein Fehler gefunden wird; reine Warnungen ergeben Exit 0.
void main(List<String> args) {
  final wurzel = findeRepoWurzel();
  final nurBurgstadt = args.contains('--burgstadt');
  if (nurBurgstadt) args = const [];
  if (args.isEmpty && wurzel == null) {
    stderr.writeln(
      'Repo-Wurzel (Ordner mit nachtlauf/ und packages/) nicht gefunden.',
    );
    exitCode = 2;
    return;
  }
  final pfade = args.isEmpty
      ? spieltextBestand(wurzel!).where((p) => !nurBurgstadt || !p.contains('/content/')).toList()
      : args;
  List<String> dateien;
  try {
    dateien = sammleDateien(pfade);
  } on FileSystemException catch (e) {
    stderr.writeln('Pfad nicht gefunden: ${e.path}');
    exitCode = 2;
    return;
  }

  final treffer = scanneDateien(dateien);
  for (final t in treffer) {
    final stufe = t.fehler ? 'FEHLER ' : 'Warnung';
    stdout.writeln(
      '${t.datei}:${t.zeile}  $stufe  ${t.wort}  „${t.ausschnitt}“',
    );
  }
  final fehler = treffer.where((t) => t.fehler).length;
  stdout.writeln('Geprüfte Dateien: ${dateien.length}');
  stdout.writeln(
    'Summe: ${treffer.length} Treffer · $fehler Fehler · '
    '${treffer.length - fehler} Warnungen',
  );
  exitCode = fehler > 0 ? 1 : 0;
}

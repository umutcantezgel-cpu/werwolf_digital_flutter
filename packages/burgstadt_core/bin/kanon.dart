/// Kanon-Werkzeug, Dart-Gegenstück zu `90_werkzeug/kanon.py`.
///
/// Aufruf im Paket: `dart run bin/kanon.dart --pruefe | --wirksam | --diff`
/// Pfade sind relativ zum Repo-Wurzelordner (der Ordner mit `krimidinner/`).
library;

import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';

const _kanonOrdner = 'krimidinner/spuk-im-gewoelbe/10_kanon';
const _overlayDatei = 'nachtlauf/kanon/ANPASSUNG.md';

void main(List<String> args) {
  const befehle = {'--pruefe', '--wirksam', '--diff'};
  final befehl = args.isEmpty ? '' : args.first;
  if (!befehle.contains(befehl)) {
    stderr.writeln(
      'Aufruf: dart run bin/kanon.dart --pruefe | --wirksam | --diff',
    );
    exit(2);
  }
  final wurzel = findeRepoWurzel();
  if (wurzel == null) {
    stderr.writeln(
      'Kein Ordner krimidinner/ oberhalb von ${Directory.current.path} gefunden.',
    );
    exit(2);
  }
  try {
    final original = kanonLesen('$wurzel/$_kanonOrdner');
    final overlay = File('$wurzel/$_overlayDatei').readAsStringSync();
    final wirksam = original.mitOverlay(overlay, datei: _overlayDatei);
    switch (befehl) {
      case '--pruefe':
        exit(_pruefe(original, wirksam));
      case '--wirksam':
        _warneLesefehler(wirksam);
        for (final d in wirksam.datensaetze.values) {
          stdout.writeln(d.alsZeile);
        }
      case '--diff':
        for (final z in overlayDiff(original, wirksam)) {
          stdout.writeln(z);
        }
    }
  } on FormatException catch (e) {
    stderr.writeln('SYNTAX-Fehler: ${e.message}');
    exit(1);
  } on FileSystemException catch (e) {
    stderr.writeln(
      'Datei oder Ordner nicht lesbar: ${e.path ?? ''} (${e.message})',
    );
    exit(2);
  }
}

/// Prüft den Original- und den wirksamen Kanon; Exit-Code 1 bei Befunden.
int _pruefe(Kanon original, Kanon wirksam) {
  final diff = overlayDiff(original, wirksam);
  final neu = diff.where((z) => z.startsWith('+ ')).length;
  final geaendert = {
    for (final z in diff)
      if (z.contains(' · ')) z.split(' · ').first,
  }.length;
  stdout.writeln(
    'Original (10_kanon): ${original.datensaetze.length} Datensätze',
  );
  var gesamt = _proben(original);
  stdout.writeln(
    'Wirksam (Original + $_overlayDatei): ${wirksam.datensaetze.length} Datensätze · '
    '$neu neu · $geaendert geändert · ${wirksam.ersetzungen.length} ERSETZE',
  );
  gesamt += _proben(wirksam);
  return gesamt > 0 ? 1 : 0;
}

/// Alle Proben eines Kanons in der Ausgabeform von kanon.py; liefert die Befundzahl.
int _proben(Kanon k) {
  var gesamt = 0;
  for (final eintrag in alleProben(k).entries) {
    gesamt += eintrag.value.length;
    stdout.writeln('== ${eintrag.key}: ${eintrag.value.length} Befunde');
    for (final x in eintrag.value.take(400)) {
      stdout.writeln('  $x');
    }
  }
  stdout.writeln(
    '== SUMME: $gesamt Befunde · ${k.datensaetze.length} Datensätze',
  );
  return gesamt;
}

void _warneLesefehler(Kanon k) {
  for (final x in k.lesefehler) {
    stderr.writeln('WARNUNG $x');
  }
}

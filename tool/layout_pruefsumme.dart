/// Layout-Prüfsumme für Burgstadt HD: baut die Welt genau wie das Spiel (ladeAusRepo)
/// und hasht ihre kanonische Form. Aufruf aus der Repo-Wurzel:
///   /opt/flutter/bin/dart run tool/layout_pruefsumme.dart [--pruefe|--schreibe]
library;

import 'dart:convert';
import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';

const _ausgang = 'hd/belege/layout_ausgang.txt';

void main(List<String> args) {
  if (args.length > 1 || (args.isNotEmpty && args.first != '--pruefe' && args.first != '--schreibe')) {
    stderr.writeln('Aufruf: dart run tool/layout_pruefsumme.dart [--pruefe|--schreibe]');
    exit(64);
  }
  final wurzel = findeRepoWurzel();
  if (wurzel == null) {
    stderr.writeln('Repo-Wurzel nicht gefunden (nachtlauf/ und packages/ fehlen).');
    exit(2);
  }
  final zeile = _messe(wurzel);
  stdout.writeln(zeile);
  final modus = args.isEmpty ? '' : args.first;
  if (modus == '--schreibe') {
    File('$wurzel/$_ausgang').writeAsStringSync('$zeile\n');
    stdout.writeln('LAYOUT GESCHRIEBEN: $_ausgang');
  } else if (modus == '--pruefe') {
    final datei = File('$wurzel/$_ausgang');
    if (!datei.existsSync()) {
      stdout.writeln('LAYOUT FEHLT: $_ausgang ist nicht vorhanden – erst mit --schreibe anlegen');
      exit(2);
    }
    final erwartet = datei.readAsStringSync().trim();
    if (erwartet == zeile) {
      stdout.writeln('LAYOUT GLEICH');
    } else {
      stdout.writeln('LAYOUT ABWEICHUNG: erwartet $erwartet, ist $zeile');
      exit(1);
    }
  }
}

/// Baut die Welt wie `ladeAusRepo` in `burgstadt_spiel_io.dart` und liefert die Zeile.
String _messe(String w) {
  final innenOrdner = Directory('$w/packages/burgstadt_core/data/innenraeume');
  if (!innenOrdner.existsSync()) {
    stderr.writeln('Innenräume fehlen: ${innenOrdner.path}');
    exit(2);
  }
  List<Map<String, dynamic>>? liste(String datei, String feld) {
    final f = File('$w/packages/burgstadt_core/data/stadt/$datei');
    return f.existsSync() ? [for (final h in (jsonDecode(f.readAsStringSync()) as Map)[feld] as List) h as Map<String, dynamic>] : null;
  }

  final dateien = [
    for (final f in innenOrdner.listSync().whereType<File>())
      if (f.path.endsWith('.json')) f,
  ]..sort((a, b) => a.path.compareTo(b.path));
  final haeuser = liste('haeuser.json', 'haeuser');
  final bewohner = liste('bewohner.json', 'bewohner') ?? const <Map<String, dynamic>>[];

  Zufall.aufrufe = 0;
  final welt = baueWelt([
    for (final f in dateien) jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
  ], haeuser: haeuser);
  final aufrufe = Zufall.aufrufe;

  final text = kanonischeForm(welt) + kanonischeZuordnung(welt, haeuser: haeuser, bewohner: bewohner);
  final hash = fnv1a64(text);
  final kacheln = welt.values.fold<int>(0, (s, b) => s + b.breite * b.tiefe);
  final dinge = welt.values.fold<int>(0, (s, b) => s + b.dinge.length);
  return 'LAYOUT $hash · Bereiche ${welt.length} · Kacheln $kacheln · Dinge $dinge · Zufallsaufrufe $aufrufe';
}

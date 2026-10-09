import 'dart:convert';
import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';

/// Erkundungsbots (Auftrag A-307a): `dart run bin/erkundung.dart`
/// Baut die generierte Burgstadt wie der Stadt-Test, lässt 4 Bots in Phase 3 alle
/// offenen Türen zu Fuß erreichen und druckt den Bericht. Exit 1 bei Befunden.
void main() {
  final wurzel = findeRepoWurzel();
  if (wurzel == null) {
    stderr.writeln('Repo-Wurzel (Ordner mit nachtlauf/ und packages/) nicht gefunden.');
    exitCode = 2;
    return;
  }
  final daten = '$wurzel/packages/burgstadt_core/data';
  final innen = [
    for (final f in Directory('$daten/innenraeume').listSync().whereType<File>())
      if (f.path.endsWith('.json')) jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
  ];
  final haeuser = [
    for (final h in (jsonDecode(File('$daten/stadt/haeuser.json').readAsStringSync()) as Map)['haeuser'] as List)
      h as Map<String, dynamic>,
  ];
  final welt = baueWelt(innen, haeuser: haeuser);
  final bericht = erkunde(welt, phase: 3, bots: 4, seed: 1752);

  stdout.writeln('Erkundung · Phase ${bericht.phase} · ${bericht.bots.length} Bots · Seed ${bericht.seed}');
  stdout.writeln('Türen ${bericht.erreicht}/${bericht.tuerenGesamt} erreicht');
  stdout.writeln('Nicht erreicht: ${bericht.nichtErreicht.length}');
  for (final n in bericht.nichtErreicht) {
    stdout.writeln('  - $n');
  }
  stdout.writeln('Steckenbleiber: ${bericht.steckenbleiber.length}');
  for (final s in bericht.steckenbleiber) {
    stdout.writeln('  - $s');
  }
  for (final b in bericht.bots) {
    stdout.writeln('${b.name}: ${b.bereich.id} ${b.kachel.$1}/${b.kachel.$2} · frei ${b.frei ? 'ja' : 'NEIN'}');
  }
  stdout.writeln('Spielzeit ${bericht.spielzeit.toStringAsFixed(1)} s');
  stdout.writeln('Rechenzeit ${(bericht.rechenzeit.inMilliseconds / 1000).toStringAsFixed(2)} s');
  exitCode = bericht.ohneBefund ? 0 : 1;
}

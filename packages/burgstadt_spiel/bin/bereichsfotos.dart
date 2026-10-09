import 'dart:io';

import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Fotos jedes Bereichs (Ich-Sicht von einer Marke zur Raummitte) mit Paletten- und
/// Blocktest. `dart run bin/bereichsfotos.dart <ordner> [breite höhe]`
void main(List<String> args) {
  final ordner = args.isEmpty ? '.' : args[0];
  final w = args.length > 2 ? int.parse(args[1]) : 1280, h = args.length > 2 ? int.parse(args[2]) : 720;
  Directory(ordner).createSync(recursive: true);
  final spiel = Spiel()..groesse(w, h);
  ladeAusRepo(spiel);
  final e = Eingabe();
  var fehler = 0;
  for (final b in spiel.stadt.bereiche.values) {
    final marke = b.marken.containsKey('t') ? 't' : (b.marken.containsKey('b') ? 'b' : b.marken.keys.first);
    final erk = Erkundung(ort: b.id, marke: marke);
    spiel.wechsle(erk);
    for (var i = 0; i < 12; i++) {
      spiel.tick(1 / 30, e);
    }
    erk.pitch = b.innen ? -0.05 : 0.05;
    spiel.tick(1 / 30, e);
    final rgba = komponiere(spiel.welt, spiel.ui, spiel.skala!);
    File('$ordner/bereich_${b.id}.png').writeAsBytesSync(encodePngRgba(w, h, rgba, zlib: zlib.encode));
    final pal = countOffPalette(rgba);
    final blk = blockTest(rgba, w, h, spiel.skala!.kUi);
    if (pal != 0 || blk.ratio != 1) fehler++;
    stdout.writeln('${b.id}: Marke $marke · ${spiel.renderer.stats} · Palette ${pal == 0 ? 'OK' : 'FEHLER'} · Block $blk');
  }
  exitCode = fehler == 0 ? 0 : 1;
}

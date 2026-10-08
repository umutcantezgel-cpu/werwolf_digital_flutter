import 'dart:io';
import 'dart:math' as math;

import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Ansichten der Oberstadt (Ich-Sicht) mit Paletten-/Blocktest und Bildzeit.
/// `dart run bin/stadtfotos.dart <ordner> [breite höhe]`
void main(List<String> args) {
  final ordner = args.isEmpty ? '.' : args[0];
  final w = args.length > 2 ? int.parse(args[1]) : 1280, h = args.length > 2 ? int.parse(args[2]) : 720;
  Directory(ordner).createSync(recursive: true);
  final spiel = Spiel()..groesse(w, h);
  ladeAusRepo(spiel);
  final s = spiel.stadt.bereiche['stadt']!;
  final e = Eingabe();
  final (bx, bz) = s.markePos('b');
  final ansichten = <(String, double, double, double)>[
    ('burgtor_hauptgasse', bx, bz + 1, math.pi / 2),
    ('marktplatz', 80 - 10, 68 + 9, -0.6),
    ('kirchhuegel', 46, 60, math.pi),
    ('gasse_ost', 125, 68.5, 0.0),
    ('untere_stadt', 80, 110, math.pi / 2 + 0.3),
  ];
  var fehler = 0;
  for (final (name, x, z, yaw) in ansichten) {
    final erk = Erkundung(ort: 'stadt', marke: 'b');
    spiel.wechsle(erk);
    erk.x = x;
    erk.z = z;
    erk.yaw = yaw;
    // Einblendung beim Betreten abwarten (≈ 0,33 s)
    for (var i = 0; i < 15; i++) {
      spiel.tick(1 / 30, e);
    }
    // Bildzeit messen (nur Welt)
    final uhr = Stopwatch()..start();
    for (var i = 0; i < 20; i++) {
      erk.zeichneWelt(spiel);
    }
    final ms = uhr.elapsedMicroseconds / 20 / 1000;
    final rgba = komponiere(spiel.welt, spiel.ui, spiel.skala!);
    File('$ordner/stadt_$name.png').writeAsBytesSync(encodePngRgba(w, h, rgba, zlib: zlib.encode));
    final pal = countOffPalette(rgba);
    final blk = blockTest(rgba, w, h, spiel.skala!.kUi);
    if (pal != 0 || blk.ratio != 1) fehler++;
    stdout.writeln('$name: ${ms.toStringAsFixed(2)} ms · ${spiel.renderer.stats} · Palette ${pal == 0 ? 'OK' : 'FEHLER'} · Block ${(blk.ratio * 100).toStringAsFixed(1)} %');
  }
  exitCode = fehler == 0 ? 0 : 1;
}

// FEINKORN K0 · Prototyp Darstellungsweg A (Block-Sprites): backt den Testraum je Skala, misst Backzeit,
// Flächen, Bildgrößen und Speicher und schreibt ein Gesamtbild.
// Aufruf: dart run bin/feinkorn_k0.dart <ausgabeOrdner> [skala ...]
import 'dart:io';
import 'dart:typed_data';

import 'package:pixel_engine/feinkorn.dart';
import 'package:pixel_engine/pixel_engine.dart' show encodePngRgba;

void main(List<String> args) {
  final aus = Directory(args.isEmpty ? 'k0' : args[0])..createSync(recursive: true);
  final skalen = args.length > 1 ? args.skip(1).map(double.parse).toList() : [1.0, 2.0, 3.0];
  final sw = Stopwatch()..start();
  final raum = Testraum();
  final alle = raum.alle;
  for (final p in alle) {
    p.koerper.bloecke; // Aufbau erzwingen
  }
  final aufbau = sw.elapsedMilliseconds;
  final namen = ['boden', 'wandNord', 'wandWest', 'tisch', 'figur'];
  var blockSumme = 0, speicher = 0;
  for (var i = 0; i < alle.length; i++) {
    final k = alle[i].koerper;
    blockSumme += k.bloecke;
    speicher += k.speicherBytes;
    stdout.writeln('KOERPER ${namen[i]} · ${k.blockgroesse * 100} cm · ${k.breite}×${k.tiefe}×${k.hoehe} · Blöcke ${k.bloecke} · Daten ${(k.speicherBytes / 1024).round()} KB');
  }
  stdout.writeln('AUFBAU $aufbau ms · Blöcke $blockSumme · Daten ${(speicher / 1048576).toStringAsFixed(1)} MB');
  for (final sk in skalen) {
    final ansicht = IsoAnsicht(skala: sk);
    final bilder = <IsoBild>[];
    var flaechen = 0, pixel = 0;
    final t0 = sw.elapsedMilliseconds;
    final karte = Schattenkarte.bau(alle, const Backlicht().richtung);
    stdout.writeln('  SCHATTENKARTE ${sw.elapsedMilliseconds - t0} ms · ${(karte.speicherBytes / 1048576).toStringAsFixed(1)} MB');
    for (var i = 0; i < alle.length; i++) {
      final t = sw.elapsedMilliseconds;
      final b = backe(alle[i], ansicht, schatten: karte);
      bilder.add(b);
      flaechen += b.flaechen;
      pixel += b.breite * b.hoehe;
      stdout.writeln('  BACKEN skala $sk · ${namen[i]} · ${sw.elapsedMilliseconds - t} ms · ${b.breite}×${b.hoehe} · Flächen ${b.flaechen}');
    }
    stdout.writeln('BACKEN skala $sk · gesamt ${sw.elapsedMilliseconds - t0} ms · Flächen $flaechen · Bildspeicher ${(pixel * 4 / 1048576).toStringAsFixed(1)} MB');
    // Gesamtbild: Sprites in Zeichenreihenfolge übereinander
    var minL = double.infinity, minO = double.infinity, maxR = -double.infinity, maxU = -double.infinity;
    for (final b in bilder) {
      minL = b.links < minL ? b.links : minL;
      minO = b.oben < minO ? b.oben : minO;
      final r = b.links + b.breite / sk, u = b.oben + b.hoehe / sk;
      maxR = r > maxR ? r : maxR;
      maxU = u > maxU ? u : maxU;
    }
    final w = ((maxR - minL) * sk).ceil(), h = ((maxU - minO) * sk).ceil();
    final ges = Uint8List(w * h * 4);
    for (var i = 0; i < ges.length; i += 4) {
      ges[i] = 12;
      ges[i + 1] = 13;
      ges[i + 2] = 18;
      ges[i + 3] = 255;
    }
    for (final b in bilder) {
      final ox = ((b.links - minL) * sk).round(), oy = ((b.oben - minO) * sk).round();
      for (var y = 0; y < b.hoehe; y++) {
        for (var x = 0; x < b.breite; x++) {
          final q = (y * b.breite + x) * 4;
          if (b.rgba[q + 3] == 0) continue;
          final zx = ox + x, zy = oy + y;
          if (zx < 0 || zy < 0 || zx >= w || zy >= h) continue;
          final z = (zy * w + zx) * 4;
          ges[z] = b.rgba[q];
          ges[z + 1] = b.rgba[q + 1];
          ges[z + 2] = b.rgba[q + 2];
        }
      }
    }
    File('${aus.path}/testraum_skala$sk.png').writeAsBytesSync(encodePngRgba(w, h, ges, zlib: zlib.encode));
  }
}

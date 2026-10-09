import 'dart:convert';
import 'dart:io';

import 'package:pixel_engine/pixel_engine.dart';

/// Figuren-Aufstellung (Auftrag A-601b): alle Karten aus data/figuren/karten.json in Reihen,
/// je Figur Front (Richtung 0), Seite (Richtung 2) und Rücken (Richtung 4), darunter die ID, ×2.
/// `dart run bin/aufstellung.dart <png>`
void main(List<String> args) {
  final ziel = args.isEmpty ? 'aufstellung.png' : args[0];
  final bibliothek = {
    ...kTeileBasis,
    ...teileAusJson(_lies('data/figuren/teile_koepfe.json')),
    ...teileAusJson(_lies('data/figuren/teile_kleidung.json')),
  };
  final karten = [
    for (final k in _lies('data/figuren/karten.json')['karten'] as List) Figurenkarte.ausJson(k as Map<String, dynamic>),
  ];
  final baker = FigurBaker(bibliothek);
  final font = BitmapFont.parse(kSchriftNormal);
  const bw = FigurBaker.breite, bh = FigurBaker.hoehe;
  const ansichten = [0, 2, 4];
  const spalten = 9, skala = 2;
  const zellBreite = 3 * bw + 2 * 4 + 12, zellHoehe = bh + 14;
  final zeilen = (karten.length + spalten - 1) ~/ spalten;
  final fb = PixelBuffer(spalten * zellBreite, zeilen * zellHoehe)..clear(Ramp.at(Ramp.neutral, 4)); // heller als Nacht- und Nebelblau, damit dunkle Kleidung sichtbar bleibt
  final sw = Stopwatch()..start();
  for (var i = 0; i < karten.length; i++) {
    final k = karten[i];
    final satz = baker.backe(k, animationen: ['stehen']);
    final x0 = (i % spalten) * zellBreite + 6, y0 = (i ~/ spalten) * zellHoehe + 2;
    for (var a = 0; a < ansichten.length; a++) {
      _blit(fb, satz.bild('stehen', 0, ansichten[a]), x0 + a * (bw + 4), y0);
    }
    final breite = font.measure(k.id);
    font.draw(fb, k.id, x0 + (3 * bw + 8 - breite) ~/ 2, y0 + bh + 3, Pal.parchment, shadow: Pal.black);
  }
  sw.stop();
  final rgba = upscaleRgba(fb.toRgbaBytes(), fb.width, fb.height, skala);
  File(ziel).writeAsBytesSync(encodePngRgba(fb.width * skala, fb.height * skala, rgba, zlib: zlib.encode));
  stdout.writeln('${karten.length} Figuren × ${ansichten.length} Ansichten in ${sw.elapsedMilliseconds} ms → $ziel');
}

Map<String, dynamic> _lies(String pfad) => jsonDecode(File(pfad).readAsStringSync()) as Map<String, dynamic>;

void _blit(PixelBuffer fb, SpriteImage s, int x0, int y0) {
  for (var y = 0; y < s.height; y++) {
    for (var x = 0; x < s.width; x++) {
      final c = s.pixels[y * s.width + x];
      if (c != kTransparent) fb.set(x0 + x, y0 + y, c);
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:pixel_engine/pixel_engine.dart';

/// Porträt-Bogen (Auftrag A-601c): alle Karten aus data/figuren/karten.json in Dreier-Reihen, je Figur
/// die vier Ausdrücke nebeneinander (neu = neutral, fre = freundlich, nac = nachdenklich,
/// ers = erschrocken), darunter die ID; ×2. `dart run bin/portraetprobe.dart <png>`
void main(List<String> args) {
  final ziel = args.isEmpty ? 'portraets.png' : args[0];
  final bibliothek = {
    ...kTeileBasis,
    ...teileAusJson(_lies('data/figuren/teile_koepfe.json')),
    ...teileAusJson(_lies('data/figuren/teile_kleidung.json')),
  };
  final karten = [
    for (final k in _lies('data/figuren/karten.json')['karten'] as List) Figurenkarte.ausJson(k as Map<String, dynamic>),
  ];
  const beschriftung = ['neu', 'fre', 'nac', 'ers'];
  final font = BitmapFont.parse(kSchriftNormal);
  const pb = kPortraetBreite, ph = kPortraetHoehe;
  const spalten = 3, skala = 2, abstand = 4, rand = 8;
  const zellBreite = 4 * pb + 3 * abstand + 2 * rand;
  const zellHoehe = ph + 26;
  final zeilen = (karten.length + spalten - 1) ~/ spalten;
  final fb = PixelBuffer(spalten * zellBreite, zeilen * zellHoehe)..clear(Pal.nightBlue);
  final sw = Stopwatch()..start();
  for (var i = 0; i < karten.length; i++) {
    final k = karten[i];
    final x0 = (i % spalten) * zellBreite + rand, y0 = (i ~/ spalten) * zellHoehe + 2;
    for (final a in Ausdruck.values) {
      final xa = x0 + a.index * (pb + abstand);
      _blit(fb, portraet(k, a, bibliothek: bibliothek), xa, y0);
      final kurz = beschriftung[a.index];
      font.draw(fb, kurz, xa + (pb - font.measure(kurz)) ~/ 2, y0 + ph + 2, Pal.parchment, shadow: Pal.black);
    }
    final breite = font.measure(k.id);
    font.draw(fb, k.id, x0 + (4 * pb + 3 * abstand - breite) ~/ 2, y0 + ph + 13, Pal.parchment, shadow: Pal.black);
  }
  sw.stop();
  final rgba = upscaleRgba(fb.toRgbaBytes(), fb.width, fb.height, skala);
  File(ziel).writeAsBytesSync(encodePngRgba(fb.width * skala, fb.height * skala, rgba, zlib: zlib.encode));
  stdout.writeln('${karten.length} Figuren × ${Ausdruck.values.length} Ausdrücke in ${sw.elapsedMilliseconds} ms → $ziel');
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

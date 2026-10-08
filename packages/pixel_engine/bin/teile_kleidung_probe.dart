import 'dart:convert';
import 'dart:io';

import 'package:pixel_engine/pixel_engine.dart';

/// Kontaktbogen der Kleidungs- und Zubehörteile (A-108b): jedes Teil auf einer neutralen
/// Probe-Figur, je Zeile 8 Richtungen + 1 Gehbild, beschriftet, ×3 als PNG.
/// `dart run bin/teile_kleidung_probe.dart <png> [filter]` – filter: Art (z. B. `oberteil`)
/// oder Anfang der Teile-ID (z. B. `schuhe-`), für Detailansichten.
/// Die Probe-Figur hat keine Figurenfarben: die Materialien sind nur so gewählt, dass
/// Teile in der Vorschau voneinander abgesetzt sind (keine Festlegung für das Spiel).
const Map<String, Material> _neutral = {
  'haut': Material(7, 5),
  'haar': Material(1, 1),
  'oberteil': Material(1, 6),
  'darunter': Material(0, 7),
  'weste': Material(2, 3),
  'hose': Material(1, 2),
  'schuhe': Material(1, 0),
  'akzent': Material(4, 4),
  'tasche': Material(2, 2),
  'schal': Material(3, 5),
  'strumpf': Material(0, 5),
  'metall': Material(0, 2),
};

void main(List<String> args) {
  final ziel = args.isEmpty ? 'teile_kleidung.png' : args[0];
  final filter = args.length > 1 ? args[1] : null;
  final json = jsonDecode(File('data/figuren/teile_kleidung.json').readAsStringSync()) as Map<String, dynamic>;
  final neue = teileAusJson(json);
  final gewaehlt = [
    for (final t in neue.values)
      if (filter == null || t.art == filter || t.id.startsWith(filter)) t,
  ];
  final baker = FigurBaker({...kTeileBasis, ...neue});
  final font = BitmapFont.parse(kSchriftNormal);
  const bw = FigurBaker.breite, bh = FigurBaker.hoehe;
  const zelleBreite = 9 * bw + 16, zeileHoehe = bh + 12;
  final spalten = gewaehlt.length > 12 ? 3 : (gewaehlt.length > 6 ? 2 : 1);
  final zeilen = (gewaehlt.length + spalten - 1) ~/ spalten;
  final fb = PixelBuffer(spalten * zelleBreite, zeilen * zeileHoehe)..clear(Pal.nightBlue);
  final sw = Stopwatch()..start();
  for (var i = 0; i < gewaehlt.length; i++) {
    final t = gewaehlt[i];
    // Spaltenweise füllen: die Reihenfolge der Datei läuft oben nach unten.
    final x0 = (i ~/ zeilen) * zelleBreite, y0 = (i % zeilen) * zeileHoehe;
    final karte = Figurenkarte(id: 'probe-${t.id}', name: t.id, materialien: _neutral, teile: ['frisur-kurz', t.id]);
    final satz = baker.backe(karte, animationen: ['stehen', 'gehen']);
    font.draw(fb, t.id, x0 + 2, y0 + 1, Pal.parchment, shadow: Pal.black);
    for (var r = 0; r < 8; r++) {
      _blit(fb, satz.bild('stehen', 0, r), x0 + r * bw, y0 + 12);
    }
    _blit(fb, satz.bild('gehen', 0, 2), x0 + 8 * bw, y0 + 12);
  }
  sw.stop();
  final rgba = upscaleRgba(fb.toRgbaBytes(), fb.width, fb.height, 3);
  File(ziel).writeAsBytesSync(encodePngRgba(fb.width * 3, fb.height * 3, rgba, zlib: zlib.encode));
  stdout.writeln('${gewaehlt.length} Teile × 9 Bilder in ${sw.elapsedMilliseconds} ms → $ziel');
}

void _blit(PixelBuffer fb, SpriteImage s, int x0, int y0) {
  for (var y = 0; y < s.height; y++) {
    for (var x = 0; x < s.width; x++) {
      final c = s.pixels[y * s.width + x];
      if (c != kTransparent) fb.set(x0 + x, y0 + y, c);
    }
  }
}

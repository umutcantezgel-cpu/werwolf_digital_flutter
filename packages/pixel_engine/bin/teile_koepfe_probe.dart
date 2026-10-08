import 'dart:convert';
import 'dart:io';

import 'package:pixel_engine/pixel_engine.dart';

/// Kontaktbogen der Kopf-Teile (Frisuren, Bärte, Kopfbedeckungen): je Teil eine Zeile,
/// auf einer neutralen Probe-Figur 8 Richtungen (stehen, Spalten 0–7) und ein Gehbild (G, Richtung 2).
/// `dart run bin/teile_koepfe_probe.dart <png> [skala] [präfixe] [von] [bis]`: Präfixe kommagetrennt,
/// z. B. `frisur-` (eine Gruppe) oder `frisur-afro,bart-walross` (einzelne Teile). `von`/`bis` begrenzen
/// die Sprite-Zeilen (Standard 0–80), z. B. 12 52 für Kopf und Schultern.
void main(List<String> args) {
  final ziel = args.isEmpty ? 'teile_koepfe.png' : args[0];
  final skala = args.length > 1 ? int.parse(args[1]) : 3;
  final praefixe = args.length > 2 ? args[2].split(',') : const <String>[''];
  final von = args.length > 3 ? int.parse(args[3]) : 0;
  final bis = args.length > 4 ? int.parse(args[4]) : FigurBaker.hoehe;
  final json = jsonDecode(File('data/figuren/teile_koepfe.json').readAsStringSync()) as Map<String, dynamic>;
  final alle = teileAusJson(json);
  final teile = [for (final t in alle.values) if (praefixe.any(t.id.startsWith)) t];
  if (teile.isEmpty) {
    stderr.writeln('Kein Teil zu den Präfixen „${praefixe.join(',')}“');
    exitCode = 1;
    return;
  }
  final baker = FigurBaker({...kTeileBasis, ...alle});
  final sw = Stopwatch()..start();
  final saetze = [
    for (final t in teile)
      baker.backe(
        Figurenkarte(id: 'probe-${t.id}', name: t.id, materialien: kProbeMaterialien, teile: [t.id]),
        animationen: const ['stehen', 'gehen'],
      ),
  ];
  sw.stop();

  final font = BitmapFont.parse(kSchriftNormal);
  const bw = FigurBaker.breite;
  final hoehe = bis - von;
  final labelBreite = [for (final t in teile) font.measure(t.id)].reduce((a, b) => a > b ? a : b) + 8;
  final blockBreite = labelBreite + 9 * bw + 12;
  final blockZahl = teile.length <= 13 ? 1 : (teile.length <= 26 ? 2 : 3);
  final proBlock = (teile.length / blockZahl).ceil();
  const kopfHoehe = 12;
  final zeilenHoehe = hoehe + 2;
  final fb = PixelBuffer(blockZahl * blockBreite, kopfHoehe + proBlock * zeilenHoehe)..clear(Pal.nightBlue);

  for (var b = 0; b < blockZahl; b++) {
    final x0 = b * blockBreite + labelBreite;
    for (var r = 0; r < 8; r++) {
      font.draw(fb, '$r', x0 + r * bw + 20, 2, Pal.candle);
    }
    font.draw(fb, 'G', x0 + 8 * bw + 20, 2, Pal.candle);
  }
  for (var i = 0; i < saetze.length; i++) {
    final b = i ~/ proBlock, r = i % proBlock;
    final x0 = b * blockBreite + labelBreite, y0 = kopfHoehe + r * zeilenHoehe;
    font.draw(fb, teile[i].id, b * blockBreite + 2, y0 + hoehe ~/ 2 - 3, Pal.parchment);
    for (var richtung = 0; richtung < 8; richtung++) {
      _blit(fb, saetze[i].bild('stehen', 0, richtung), x0 + richtung * bw, y0, von, bis);
    }
    _blit(fb, saetze[i].bild('gehen', 0, 2), x0 + 8 * bw, y0, von, bis);
  }

  final rgba = upscaleRgba(fb.toRgbaBytes(), fb.width, fb.height, skala);
  File(ziel).writeAsBytesSync(encodePngRgba(fb.width * skala, fb.height * skala, rgba, zlib: zlib.encode));
  final bilder = saetze.fold<int>(0, (a, s) => a + s.bilder.values.fold<int>(0, (b, l) => b + l.length * 8));
  stdout.writeln('${teile.length} Teile, $bilder Bilder in ${sw.elapsedMilliseconds} ms → $ziel');
}

/// Neutrale Probe-Figur: Körper in Steinschwarz, Teile in klaren Tönen (ohne Rampe 0).
const kProbeMaterialien = {
  'haut': Material(7, 5),
  'haar': Material(2, 3),
  'bart': Material(4, 5),
  'kopfbedeckung': Material(6, 4),
  'akzent': Material(3, 4),
  'metall': Material(1, 6),
  'oberteil': Material(1, 3),
  'hose': Material(1, 2),
  'schuhe': Material(1, 1),
};

void _blit(PixelBuffer fb, SpriteImage s, int x0, int y0, int von, int bis) {
  for (var y = von; y < bis; y++) {
    for (var x = 0; x < s.width; x++) {
      final c = s.pixels[y * s.width + x];
      if (c != kTransparent) fb.set(x0 + x, y0 + y - von, c);
    }
  }
}

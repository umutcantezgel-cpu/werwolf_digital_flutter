import 'dart:io';

import 'package:pixel_engine/pixel_engine.dart';

/// Figuren-Aufstellung als PNG: je Figur 8 Richtungen (Stehen) + 4 Gehbilder.
/// `dart run bin/figurenprobe.dart <png> [skala]`
void main(List<String> args) {
  final ziel = args.isEmpty ? 'figurenprobe.png' : args[0];
  final skala = args.length > 1 ? int.parse(args[1]) : 3;
  final karten = <Figurenkarte>[
    const Figurenkarte(id: 'probe1', name: 'Strickjacke', groesse: 1.67, breite: 0.92, materialien: {
      'haut': Material(7, 5), 'haar': Material(2, 5), 'oberteil': Material(5, 2), 'darunter': Material(0, 7),
      'hose': Material(6, 3), 'schuhe': Material(2, 3),
    }, teile: ['frisur-schulterlang', 'oberteil-strickjacke', 'schuhe-stiefel', 'notizbuch']),
    const Figurenkarte(id: 'probe2', name: 'Burgwart', groesse: 1.74, breite: 1.18, materialien: {
      'haut': Material(7, 5), 'haar': Material(0, 7), 'oberteil': Material(0, 6), 'weste': Material(2, 4),
      'hose': Material(2, 2), 'schuhe': Material(0, 2),
    }, teile: ['frisur-haarkranz', 'bart-kurz', 'oberteil-weste', 'brille-stirn']),
    const Figurenkarte(id: 'probe3', name: 'Mantel', groesse: 1.82, materialien: {
      'haut': Material(7, 3), 'haar': Material(0, 1), 'oberteil': Material(6, 2), 'hose': Material(0, 2),
      'schuhe': Material(0, 1), 'akzent': Material(3, 4),
    }, teile: ['frisur-kurz', 'oberteil-mantel', 'schal', 'laterne']),
    const Figurenkarte(id: 'probe4', name: 'Rock', groesse: 1.6, breite: 0.95, materialien: {
      'haut': Material(7, 4), 'haar': Material(0, 1), 'oberteil': Material(3, 3), 'hose': Material(2, 2),
      'schuhe': Material(0, 2), 'strumpf': Material(0, 2), 'kopfbedeckung': Material(4, 4),
    }, teile: ['frisur-zopf', 'unterteil-rock', 'kopf-muetze', 'umhaengetasche']),
  ];
  final baker = FigurBaker(kTeileBasis);
  final sw = Stopwatch()..start();
  final saetze = [for (final k in karten) baker.backe(k)];
  sw.stop();
  const bw = FigurBaker.breite, bh = FigurBaker.hoehe;
  final spalten = 12;
  final fb = PixelBuffer(spalten * bw, saetze.length * bh)..clear(Pal.nightBlue);
  for (var i = 0; i < saetze.length; i++) {
    for (var r = 0; r < 8; r++) {
      _blit(fb, saetze[i].bild('stehen', 0, r), r * bw, i * bh);
    }
    for (var g = 0; g < 4; g++) {
      _blit(fb, saetze[i].bild('gehen', g, 2), (8 + g) * bw, i * bh);
    }
  }
  final rgba = upscaleRgba(fb.toRgbaBytes(), fb.width, fb.height, skala);
  File(ziel).writeAsBytesSync(encodePngRgba(fb.width * skala, fb.height * skala, rgba, zlib: zlib.encode));
  final bilder = saetze.fold<int>(0, (a, s) => a + s.bilder.values.fold<int>(0, (b, l) => b + l.length * 8));
  stdout.writeln('${saetze.length} Figuren, $bilder Bilder in ${sw.elapsedMilliseconds} ms → $ziel');
}

void _blit(PixelBuffer fb, SpriteImage s, int x0, int y0) {
  for (var y = 0; y < s.height; y++) {
    for (var x = 0; x < s.width; x++) {
      final c = s.pixels[y * s.width + x];
      if (c != kTransparent) fb.set(x0 + x, y0 + y, c);
    }
  }
}

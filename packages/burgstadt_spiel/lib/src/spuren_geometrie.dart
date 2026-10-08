import 'dart:math' as math;
import 'dart:typed_data';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Texturen der Spuren (durchsichtig, leuchtende Farben des Detektivblicks).
List<IndexedTexture> baueSpurTexturen() {
  const t = kTransparent, c = Pal.ghostCyan, h = Pal.skyBlue, w = Pal.white;
  IndexedTexture aus(List<String> zeilen) {
    final n = zeilen.length;
    final px = Uint8List(n * n)..fillRange(0, n * n, t);
    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        px[y * n + x] = switch (zeilen[y][x]) { 'c' => c, 'h' => h, 'w' => w, _ => t };
      }
    }
    return IndexedTexture(n, n, px, maxLevels: 1);
  }

  return [
    // fussspur: Sohle mit Stollenprofil (Spitze nach rechts = +u)
    aus(const [
      '................', '................', '................', '..hhhh....hhhh..',
      '.hcwchh..hcwcwh.', '.hcccch.hcccccch', '.hwcwch.hwcwcwch', '.hcccch.hcccccch',
      '.hcwcwh.hcwcwch.', '..hhhh...hhhhh..', '................', '................',
      '................', '................', '................', '................',
    ]),
    // wachs: Tropfen
    aus(const [
      '................', '.....hh.........', '....hwwh....hh..', '....hcch...hwch.',
      '.....hh.....hh..', '..........h.....', '..hh.....hwh....', '.hwch.....h.....',
      '..hh............', '.......hh.......', '......hwwh...hh.', '......hcch..hwh.',
      '.......hh....h..', '...h............', '..hwh...........', '...h............',
    ]),
    // faser: gewellter Faden
    aus(const [
      '................', '................', '................', '................',
      '........ww......', '.......w..w.....', '..ww..w....w....', '.w..ww......w...',
      '.............w..', '..............w.', '................', '................',
      '................', '................', '................', '................',
    ]),
    // staub: verwischte Punkte
    aus(const [
      '.h..c.....h..c..', '....h..c.....h..', 'c.....h...c.....', '..h.......h..c..',
      '......cccc......', '.h...cwwwwc...h.', '....cwwwwwwc....', '..c.cwwwwwwc.c..',
      '....cwwwwwwc....', '.h...cwwwwc..h..', '......cccc......', '..c.......h..c..',
      'h.....h...c.....', '....h..c.....h..', '.c..........c...', '....h.....h.....',
    ]),
    // fingerabdruck: Wirbel
    aus(const [
      '................', '.....hhhhhh.....', '....h......h....', '...h..cccc..h...',
      '..h..c....c..h..', '..h.c..ww..c.h..', '..h.c.w..w.c.h..', '..h.c.w..w.c.h..',
      '..h.c..ww..c.h..', '..h..c....c..h..', '...h..cccc..h...', '....h......h....',
      '.....hhhhhh.....', '................', '................', '................',
    ]),
    // schleifspur: parallele Kratzer
    aus(const [
      '................', '................', 'hhhhhhhhhhhhhhhh', 'cwcwcwcwcwcwcwcw',
      '................', '................', 'hhhhhhhhhhhhhhhh', 'wcwcwcwcwcwcwcwc',
      '................', '................', 'hhhhhhhhhhhhhhhh', 'cwcwcwcwcwcwcwcw',
      '................', '................', '................', '................',
    ]),
    // verwischt: gestrichelte Fläche
    aus(const [
      'h.h.h.h.h.h.h.h.', '.h.h.h.h.h.h.h.h', 'h.c.c.c.c.c.c.h.', '.h.c.c.c.c.c.c.h',
      'h.c.h.h.h.h.c.h.', '.h.c.h.h.h.c.h.h', 'h.c.h.w.w.h.c.h.', '.h.c.h.w.h.c.h.h',
      'h.c.h.w.w.h.c.h.', '.h.c.h.h.h.c.h.h', 'h.c.h.h.h.h.c.h.', '.h.c.c.c.c.c.c.h',
      'h.c.c.c.c.c.c.h.', '.h.h.h.h.h.h.h.h', 'h.h.h.h.h.h.h.h.', '.h.h.h.h.h.h.h.h',
    ]),
  ];
}

/// Mesh der Spuren eines Bereichs für Phase [phase] und Sichtschicht [schicht].
Mesh? baueSpurenMesh(List<Spur> spuren, String bereich, int phase, String schicht, int texBasis) {
  final m = MeshBuilder();
  for (final s in spuren) {
    if (s.bereich != bereich || s.abPhase > phase || !s.sicht.contains(schicht)) continue;
    final tex = texBasis + s.art.index;
    final (lang, breit) = switch (s.art) {
      SpurArt.fussspur => (0.32, 0.32),
      SpurArt.wachs => (0.3, 0.3),
      SpurArt.faser => (0.2, 0.2),
      SpurArt.staub => (0.6, 0.6),
      SpurArt.fingerabdruck => (0.14, 0.14),
      SpurArt.schleifspur => (0.7, 0.35),
      SpurArt.verwischt => (0.6, 0.6),
    };
    final ca = math.cos(s.drehung), sa = math.sin(s.drehung);
    const uMax = 16.0;
    if (s.hoehe <= 0.02 || s.art == SpurArt.staub) {
      // Bodenabziehbild, entlang der Drehung ausgerichtet
      final y = s.hoehe + 0.015;
      (double, double) p(double u, double v) => (s.x + ca * u - sa * v, s.z + sa * u + ca * v);
      final ecken = [p(-lang / 2, -breit / 2), p(lang / 2, -breit / 2), p(lang / 2, breit / 2), p(-lang / 2, breit / 2)];
      final uv = const [(0.0, 0.0), (uMax, 0.0), (uMax, uMax), (0.0, uMax)];
      final ids = [for (var i = 0; i < 4; i++) m.vertex(ecken[i].$1, y, ecken[i].$2, uv[i].$1, uv[i].$2, warm: 0, cold: 1)];
      m.quad(ids[0], ids[3], ids[2], ids[1], tex, doubleSided: true);
    } else {
      // senkrecht an einer Fläche, Normale = Drehung
      final tx = -sa, tz = ca; // Tangente
      final x0 = s.x - tx * lang / 2, z0 = s.z - tz * lang / 2, x1 = s.x + tx * lang / 2, z1 = s.z + tz * lang / 2;
      m.wall(x0, z0, x1, z1, s.hoehe - breit / 2, s.hoehe + breit / 2, tex, cold: 1, doubleSided: true);
    }
  }
  return m.triangleCount == 0 ? null : m.build();
}

/// Detektivblick-Filter: Welt kalt und entsättigt (Blaurampe nach Helligkeit).
final Uint8List blickFilter = () {
  final t = Uint8List(256);
  for (var i = 0; i < 256; i++) {
    if (i >= 64) {
      t[i] = i;
      continue;
    }
    final r = paletteR(i), g = paletteG(i), b = paletteB(i);
    final lum = (0.3 * r + 0.59 * g + 0.11 * b) / 255;
    t[i] = Ramp.at(Ramp.blue, (lum * 5).floor().clamp(0, 4));
  }
  return t;
}();

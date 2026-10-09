import 'dart:math' as math;
import 'dart:typed_data';

import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

Renderer _renderer(PixelBuffer fb, List<IndexedTexture> tex) => Renderer(fb, LightTable.night(), tex);

void main() {
  test('Palette v2: 160 Farben (10 Rampen × 16 Stufen), K8-Kernfarben exakt enthalten', () {
    expect(paletteRgb.length, 160);
    expect(Ramp.count * Ramp.shades, 160);
    expect(paletteRgb.toSet().length, 160, reason: 'keine doppelten Farben');
    for (final k8 in const [0x22201E, 0x6B6660, 0x9C4A23, 0xC8642B, 0xE8A33D, 0x4A5A3C, 0x1E2A3A, 0xA9D6D9, 0xE9DCC0]) {
      expect(paletteRgb, contains(k8), reason: 'K8-Kernfarbe ${k8.toRadixString(16)}');
    }
  });

  // Wächter (E-035): Die 64 Farben der Palette v1 liegen unverändert auf Ramp.at(r, s) = r·16 + 2s + 1,
  // und jede benannte Farbe behält ihren RGB-Wert. So bleiben Bestandsbilder farbgleich.
  test('Palette v2: Palette v1 auf den ungeraden Stufen, Ramp.at-Semantik und Pal-Namen unverändert', () {
    const v1 = [
      0x0B0C10, 0x16171D, 0x22201E, 0x34353B, 0x4B4D55, 0x6E717A, 0xA3A6AE, 0xE4E6EA,
  0x1C1A18, 0x2C2926, 0x403B37, 0x55504A, 0x6B6660, 0x8A847C, 0xADA69C, 0xD4CEC3,
  0x1E120B, 0x2E1C11, 0x45291A, 0x5E3A24, 0x7A4E31, 0x976743, 0xB98A5E, 0xD9B88E,
  0x200C0A, 0x3A1410, 0x5A1E16, 0x7E2A1C, 0x9C4A23, 0xC8642B, 0xE08A4A, 0xF2B37A,
  0x2A1D08, 0x4A330E, 0x6E4C14, 0x94661A, 0xBC8424, 0xE8A33D, 0xF2C46A, 0xFBE6A8,
  0x0D140D, 0x172317, 0x22331F, 0x2F4429, 0x4A5A3C, 0x5F7A48, 0x7E9C5C, 0xA9C083,
  0x0A0F18, 0x121A28, 0x1E2A3A, 0x2A3B55, 0x3A5378, 0x56739B, 0x7F9DBF, 0xA9D6D9,
  0x2B1A12, 0x4A2E20, 0x6E4632, 0x93624A, 0xB98466, 0xD8A888, 0xEBC9AA, 0xE9DCC0,
    ];
    for (var r = 0; r < 8; r++) {
      for (var s = 0; s < 8; s++) {
        expect(paletteRgb[Ramp.at(r, s)], v1[r * 8 + s], reason: 'Rampe $r Stufe $s');
        expect(Ramp.at(r, s), Ramp.at16(r, 2 * s + 1));
        expect(rampeVon(Ramp.at(r, s)), r);
        expect(stufe8Von(Ramp.at(r, s)), s);
      }
    }
    const pal = {
      Pal.black: 0x0B0C10, Pal.iron: 0x22201E, Pal.darkGrey: 0x34353B, Pal.grey: 0x6E717A,
      Pal.lightGrey: 0xA3A6AE, Pal.white: 0xE4E6EA, Pal.stone: 0x6B6660, Pal.woodDark: 0x5E3A24,
      Pal.wood: 0x976743, Pal.bordeaux: 0x7E2A1C, Pal.punch: 0x9C4A23, Pal.ember: 0xC8642B,
      Pal.orange: 0xE08A4A, Pal.mustard: 0xBC8424, Pal.candle: 0xE8A33D, Pal.candleLight: 0xF2C46A,
      Pal.paleGold: 0xFBE6A8, Pal.moss: 0x4A5A3C, Pal.green: 0x5F7A48, Pal.nightBlue: 0x1E2A3A,
      Pal.midBlue: 0x2A3B55, Pal.blue: 0x3A5378, Pal.skyBlue: 0x7F9DBF, Pal.ghostCyan: 0xA9D6D9,
      Pal.parchment: 0xE9DCC0, Pal.ink: 0x16171D,
    };
    for (final e in pal.entries) {
      expect(paletteRgb[e.key], e.value, reason: 'Pal-Index ${e.key}');
    }
    // Neue Rampen: je 16 Stufen, von dunkel nach hell (Luma steigt streng)
    for (final r in [Ramp.altrosa, Ramp.tuerkis]) {
      double luma(int i) => 0.2126 * paletteR(i) + 0.7152 * paletteG(i) + 0.0722 * paletteB(i);
      for (var s = 1; s < 16; s++) {
        expect(luma(Ramp.at16(r, s)), greaterThan(luma(Ramp.at16(r, s - 1))), reason: 'Rampe $r Stufe $s');
      }
    }
  });

  test('Lichttabelle bleibt in der Palette und dunkelt im Farbton ab', () {
    final lt = LightTable.night();
    expect(lt.table.every((i) => i < paletteRgb.length), isTrue);
    // Kerzenbernstein unter schwachem Warmlicht bleibt in der Bernstein-Rampe.
    final dim = lt.lookup(Pal.candle, 3, 0, 0);
    expect(rampeVon(dim), Ramp.amber);
  });

  test('Szene rendern: Palettentest und Blocktest (×3) bestehen', () {
    final scene = DemoScene.build();
    final fb = PixelBuffer(320, 180);
    final r = _renderer(fb, scene.textures)..flashStrength = 0.8;
    r.camera
      ..x = 1
      ..z = 5
      ..yaw = -math.pi / 2;
    r.begin();
    r.drawSky();
    for (final m in scene.meshes) {
      r.drawMesh(m);
    }
    expect(fb.color.every((c) => c < paletteRgb.length), isTrue, reason: 'kein Pixel ohne Farbe');
    final rgba = fb.toRgbaBytes();
    expect(countOffPalette(rgba), 0);
    final big = upscaleRgba(rgba, 320, 180, 3);
    final b = blockTest(big, 960, 540, 3);
    expect(b.ratio, 1.0);
    // Verschobenes Raster darf nicht bestehen (der Test misst wirklich etwas).
    expect(blockTest(big, 960, 540, 3, ox: 1, oy: 1).ratio, lessThan(0.9));
    expect(r.stats.trianglesDrawn, greaterThan(50));
  });

  test('Determinismus: gleiches Bild, gleicher Hash', () {
    int render() {
      final scene = DemoScene.build(seed: 3);
      final fb = PixelBuffer(240, 135);
      final r = _renderer(fb, scene.textures);
      r.camera
        ..x = -3
        ..z = 2
        ..yaw = 0.3;
      r.begin();
      r.drawSky();
      for (final m in scene.meshes) {
        r.drawMesh(m);
      }
      return fnv1a(fb.color);
    }

    expect(render(), render());
  });

  test('Wand ist nur von vorne sichtbar, beidseitig von beiden Seiten', () {
    final tex = [IndexedTexture.solid(Pal.stone)];
    int drawn(bool doubleSided, double camZ, double yaw) {
      final b = MeshBuilder()..wall(-2, 0, 2, 0, 0, 3, 0, doubleSided: doubleSided, cold: 1);
      final fb = PixelBuffer(64, 36);
      final r = _renderer(fb, tex);
      r.camera
        ..x = 0
        ..z = camZ
        ..yaw = yaw;
      r.begin();
      r.drawMesh(b.build());
      return r.stats.pixelsWritten;
    }

    // Wand von West nach Ost: Vorderseite zeigt nach Süden (+z).
    expect(drawn(false, 4, -math.pi / 2), greaterThan(100));
    expect(drawn(false, -4, math.pi / 2), 0);
    expect(drawn(true, -4, math.pi / 2), greaterThan(100));
  });

  test('Near-Clipping: Kamera knapp über dem Boden zeichnet ohne Lücken', () {
    final tex = [IndexedTexture.solid(Pal.stone)];
    final b = MeshBuilder()..floor(-5, -5, 5, 5, 0, 0, cold: 1);
    final fb = PixelBuffer(64, 36);
    final r = _renderer(fb, tex);
    r.camera
      ..x = 0
      ..z = 0
      ..y = 0.3
      ..pitch = -1.2;
    r.begin();
    r.drawMesh(b.build());
    expect(r.stats.pixelsWritten, 64 * 36);
  });

  test('Sprite: Tiefentest gegen Wand, Durchsichtiges bleibt frei', () {
    final px = Uint8List(8 * 16)..fillRange(0, 8 * 16, Pal.white);
    for (var i = 0; i < 16; i++) {
      px[i * 8] = kTransparent;
    }
    final s = SpriteImage(8, 16, px, footX: 4, footY: 15);
    final fb = PixelBuffer(64, 36);
    final r = _renderer(fb, [IndexedTexture.solid(Pal.iron)]);
    r.camera
      ..x = 0
      ..z = 0
      ..yaw = 0;
    r.begin();
    final wall = MeshBuilder()..wall(3, -2, 3, 2, 0, 3, 0, cold: 0.5);
    r.drawMesh(wall.build());
    final before = Uint8List.fromList(fb.color);
    r.drawSprite(s, 5, 0, 0); // hinter der Wand
    expect(fb.color, before);
    r.drawSprite(s, 2, 0.5, 0); // vor der Wand
    expect(r.stats.spritesDrawn, 2);
    expect(fb.color, isNot(before));
  });

  test('PNG: Signatur und Kopf', () {
    final png = encodePngRgba(3, 2, Uint8List(3 * 2 * 4));
    expect(png.sublist(0, 8), [137, 80, 78, 71, 13, 10, 26, 10]);
    expect(String.fromCharCodes(png.sublist(12, 16)), 'IHDR');
  });
}

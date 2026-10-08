import 'dart:math' as math;
import 'dart:typed_data';

import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

Renderer _renderer(PixelBuffer fb, List<IndexedTexture> tex) => Renderer(fb, LightTable.night(), tex);

void main() {
  test('Palette: 64 Farben, K8-Kernfarben exakt enthalten', () {
    expect(paletteRgb.length, 64);
    expect(paletteRgb.toSet().length, 64, reason: 'keine doppelten Farben');
    for (final k8 in const [0x22201E, 0x6B6660, 0x9C4A23, 0xC8642B, 0xE8A33D, 0x4A5A3C, 0x1E2A3A, 0xA9D6D9, 0xE9DCC0]) {
      expect(paletteRgb, contains(k8));
    }
  });

  test('Lichttabelle bleibt in der Palette und dunkelt im Farbton ab', () {
    final lt = LightTable.night();
    expect(lt.table.every((i) => i < 64), isTrue);
    // Kerzenbernstein unter schwachem Warmlicht bleibt in der Bernstein-Rampe.
    final dim = lt.lookup(Pal.candle, 3, 0, 0);
    expect(dim >> 3, Ramp.amber);
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
    expect(fb.color.every((c) => c < 64), isTrue, reason: 'kein Pixel ohne Farbe');
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

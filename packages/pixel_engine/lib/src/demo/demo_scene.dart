import 'dart:math' as math;
import 'dart:typed_data';

import '../palette.dart';
import '../raster/mesh.dart';
import '../raster/texture.dart';

/// Kleine Prüfszene (Gassen, Giebelhäuser, Mauer) für Benchmark und Pixeltests.
/// Die echte Stadt baut `burgstadt_core`; das hier ist nur Messlast.
class DemoScene {
  final List<IndexedTexture> textures;
  final List<Mesh> meshes;
  DemoScene(this.textures, this.meshes);

  static const texCobble = 0, texPlasterOchre = 1, texPlasterRose = 2, texRoof = 3, texWood = 4, texStone = 5, texWindow = 6;

  factory DemoScene.build({int seed = 1, int blocks = 6}) {
    final tex = <IndexedTexture>[
      _cobble(),
      _plaster(Ramp.amber, 3, seed + 1),
      _plaster(Ramp.skin, 3, seed + 2),
      _roof(),
      _wood(),
      _stoneWall(),
      _window(),
    ];
    final meshes = <Mesh>[];
    var s = seed * 2654435761 & 0xffffffff;
    double rnd() {
      s = (s * 1103515245 + 12345) & 0x7fffffff;
      return s / 0x7fffffff;
    }

    // Boden in Kacheln (je Block ein Mesh → Culling greift)
    for (var bz = -blocks; bz < blocks; bz++) {
      for (var bx = -blocks; bx < blocks; bx++) {
        final b = MeshBuilder();
        b.floor(bx * 8.0, bz * 8.0, bx * 8.0 + 8, bz * 8.0 + 8, 0, texCobble,
            step: 2, warmAt: (x, z) => _lantern(x, z), coldAt: (x, z) => 0.05);
        meshes.add(b.build());
      }
    }
    // Häuserzeilen beiderseits der Gassen (Gassen auf x = 8k ± 2)
    for (var bz = -blocks; bz < blocks; bz++) {
      for (var bx = -blocks; bx < blocks; bx++) {
        if ((bx == 0 || bx == -1) && (bz == 0 || bz == -1)) continue; // Marktplatz
        final b = MeshBuilder();
        final x0 = bx * 8.0 + 2.2, z0 = bz * 8.0 + 2.2;
        final w = 3.6, d = 3.6;
        final h = 4.5 + rnd() * 2.5;
        final plaster = rnd() < 0.5 ? texPlasterOchre : texPlasterRose;
        final warm = rnd() < 0.25 ? 0.35 : 0.0;
        b.box(x0, 0, z0, x0 + w, h, z0 + d, plaster, texTop: texRoof, warm: warm, cold: 0.12);
        _gableRoof(b, x0 - 0.3, z0 - 0.3, x0 + w + 0.3, z0 + d + 0.3, h, 2.6, texRoof, texPlasterOchre);
        // Fenster als vorgesetzte Flächen
        for (var i = 0; i < 2; i++) {
          final fx = x0 + 0.6 + i * 1.6;
          b.wall(fx, z0 + d + 0.02, fx + 0.9, z0 + d + 0.02, 1.4, 2.6, texWindow, warm: warm * 2, cold: 0.1);
          b.wall(fx, z0 + d + 0.02, fx + 0.9, z0 + d + 0.02, 3.2, 4.2, texWindow, warm: 0, cold: 0.1);
        }
        meshes.add(b.build());
      }
    }
    // Stadtmauer rundum
    final r = blocks * 8.0;
    final wallB = MeshBuilder();
    for (final seg in [
      [-r, -r, r, -r],
      [r, -r, r, r],
      [r, r, -r, r],
      [-r, r, -r, -r],
    ]) {
      // innen sichtbar: rechte Seite in Laufrichtung zeigt nach innen
      wallB.wall(seg[0], seg[1], seg[2], seg[3], 0, 7, texStone, cold: 0.15);
    }
    meshes.add(wallB.build());
    return DemoScene(tex, meshes);
  }

  static double _lantern(double x, double z) {
    // Kerzenlicht am Markt (Mitte) – fällt nach außen ab.
    final d = math.sqrt(x * x + z * z);
    return d > 9 ? 0 : (1 - d / 9) * 0.7;
  }

  static void _gableRoof(MeshBuilder b, double x0, double z0, double x1, double z1, double y, double rise, int roof, int gable) {
    final zm = (z0 + z1) / 2;
    final top = y + rise;
    // Dachflächen (Firstlinie West–Ost)
    final half = math.sqrt((zm - z0) * (zm - z0) + rise * rise) * kDichteWelt;
    final len = (x1 - x0) * kDichteWelt;
    // Südseite
    var a = b.vertex(x0, y, z1, 0, half, cold: 0.15);
    var c = b.vertex(x1, y, z1, len, half, cold: 0.15);
    var d = b.vertex(x1, top, zm, len, 0, cold: 0.2);
    var e = b.vertex(x0, top, zm, 0, 0, cold: 0.2);
    b.quad(a, c, d, e, roof);
    // Nordseite
    a = b.vertex(x1, y, z0, 0, half, cold: 0.1);
    c = b.vertex(x0, y, z0, len, half, cold: 0.1);
    d = b.vertex(x0, top, zm, len, 0, cold: 0.15);
    e = b.vertex(x1, top, zm, 0, 0, cold: 0.15);
    b.quad(a, c, d, e, roof);
    // Giebeldreiecke
    final gw = (z1 - z0) * kDichteWelt;
    var p = b.vertex(x1, y, z1, 0, rise * kDichteWelt, cold: 0.1);
    var q = b.vertex(x1, y, z0, gw, rise * kDichteWelt, cold: 0.1);
    var t = b.vertex(x1, top, zm, gw / 2, 0, cold: 0.12);
    b.triangle(p, q, t, gable);
    p = b.vertex(x0, y, z0, 0, rise * kDichteWelt, cold: 0.1);
    q = b.vertex(x0, y, z1, gw, rise * kDichteWelt, cold: 0.1);
    t = b.vertex(x0, top, zm, gw / 2, 0, cold: 0.12);
    b.triangle(p, q, t, gable);
  }

  // ------------------------------------------------------------ Texturen

  static IndexedTexture _cobble() {
    const n = 32;
    final px = Uint8List(n * n);
    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        final row = y ~/ 8;
        final ox = (x + (row.isOdd ? 4 : 0)) % 8;
        final oy = y % 8;
        final edge = ox == 0 || oy == 0;
        final corner = (ox == 1 || ox == 7) && (oy == 1 || oy == 7);
        final hl = oy == 1 && ox > 1 && ox < 6;
        final h = (x * 7 + y * 13 + (x ~/ 8) * 31) % 5;
        px[y * n + x] = edge || corner
            ? Ramp.at(Ramp.stone, 1)
            : (hl ? Ramp.at(Ramp.stone, 5) : Ramp.at(Ramp.stone, 3 + (h == 0 ? 1 : 0)));
      }
    }
    return IndexedTexture(n, n, px);
  }

  static IndexedTexture _plaster(int ramp, int base, int seed) {
    const n = 32;
    final px = Uint8List(n * n);
    var s = seed;
    for (var i = 0; i < n * n; i++) {
      s = (s * 1103515245 + 12345) & 0x7fffffff;
      final v = s % 11;
      px[i] = Ramp.at(ramp, base + (v == 0 ? -1 : (v == 1 ? 1 : 0)));
    }
    return IndexedTexture(n, n, px);
  }

  static IndexedTexture _roof() {
    const n = 16;
    final px = Uint8List(n * n);
    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        final oy = y % 4;
        final ox = (x + ((y ~/ 4).isOdd ? 2 : 0)) % 4;
        px[y * n + x] = oy == 3 ? Ramp.at(Ramp.red, 1) : (ox == 0 ? Ramp.at(Ramp.red, 2) : Ramp.at(Ramp.red, oy == 0 ? 4 : 3));
      }
    }
    return IndexedTexture(n, n, px);
  }

  static IndexedTexture _wood() {
    const n = 16;
    final px = Uint8List(n * n);
    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        px[y * n + x] = x % 4 == 0 ? Ramp.at(Ramp.wood, 1) : Ramp.at(Ramp.wood, 3 + ((x + y * 3) % 7 == 0 ? 1 : 0));
      }
    }
    return IndexedTexture(n, n, px);
  }

  static IndexedTexture _stoneWall() {
    const n = 32;
    final px = Uint8List(n * n);
    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        final row = y ~/ 6;
        final ox = (x + row * 5) % 11;
        final oy = y % 6;
        final edge = ox == 0 || oy == 0;
        px[y * n + x] = edge ? Ramp.at(Ramp.neutral, 2) : Ramp.at(Ramp.stone, 2 + ((x * 3 + y) % 9 == 0 ? 1 : 0) + (oy == 1 ? 1 : 0));
      }
    }
    return IndexedTexture(n, n, px);
  }

  static IndexedTexture _window() {
    const w = 16, h = 16;
    final px = Uint8List(w * h);
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        final frame = x < 2 || x > 13 || y < 2 || y > 13 || x == 7 || x == 8 || y == 7;
        px[y * w + x] = frame ? Ramp.at(Ramp.wood, 2) : Ramp.at(Ramp.blue, 1);
      }
    }
    return IndexedTexture(w, h, px);
  }
}

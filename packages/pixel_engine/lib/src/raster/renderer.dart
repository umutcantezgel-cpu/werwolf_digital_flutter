import 'dart:math' as math;
import 'dart:typed_data';

import '../dither.dart';
import '../lighting.dart';
import '../palette.dart';
import '../pixel_buffer.dart';
import 'camera.dart';
import 'mesh.dart';
import 'texture.dart';

/// Ein Sprite-Bild (indiziert, [kTransparent] = durchsichtig) mit Fußpunkt.
/// Texel-Dichte wie die Welt: [kTexelsPerMeter].
class SpriteImage {
  final int width;
  final int height;
  final Uint8List pixels;

  /// Fußpunkt in Texeln (Mitte unten des Bodenschattens).
  final int footX;
  final int footY;
  late final List<Uint8List> _mips = _buildMips();
  late final List<int> _mw = [for (var i = 0; i < _mips.length; i++) math.max(1, width >> i)];
  late final List<int> _mh = [for (var i = 0; i < _mips.length; i++) math.max(1, height >> i)];

  SpriteImage(this.width, this.height, this.pixels, {required this.footX, required this.footY});

  List<Uint8List> _buildMips() {
    final out = <Uint8List>[pixels];
    var w = width, h = height;
    var cur = pixels;
    while (out.length < 4 && w >= 4 && h >= 4) {
      final nw = w >> 1, nh = h >> 1;
      final n = Uint8List(nw * nh);
      for (var y = 0; y < nh; y++) {
        for (var x = 0; x < nw; x++) {
          final a = cur[(2 * y) * w + 2 * x], b = cur[(2 * y) * w + 2 * x + 1];
          final c = cur[(2 * y + 1) * w + 2 * x], d = cur[(2 * y + 1) * w + 2 * x + 1];
          // Sichtbare Pixel bevorzugen (Silhouette bleibt), dunkle Kontur bevorzugen.
          var best = kTransparent;
          var count = 0;
          for (final v in [a, b, c, d]) {
            if (v != kTransparent) {
              count++;
              if (best == kTransparent || (v & 15) < (best & 15)) best = v;
            }
          }
          n[y * nw + x] = count >= 2 ? best : kTransparent;
        }
      }
      out.add(n);
      cur = n;
      w = nw;
      h = nh;
    }
    return out;
  }
}

/// Zählwerte eines Bildes (für Leistungsbudgets je Qualitätsstufe).
class FrameStats {
  int meshesSubmitted = 0;
  int meshesDrawn = 0;
  int trianglesSubmitted = 0;
  int trianglesDrawn = 0;
  int spritesDrawn = 0;
  int pixelsWritten = 0;

  void reset() {
    meshesSubmitted = meshesDrawn = trianglesSubmitted = trianglesDrawn = spritesDrawn = pixelsWritten = 0;
  }

  @override
  String toString() =>
      'Meshes $meshesDrawn/$meshesSubmitted · Dreiecke $trianglesDrawn/$trianglesSubmitted · Sprites $spritesDrawn · Pixel $pixelsWritten';
}

/// Software-Rasterer: perspektivisch korrekte, texturierte Dreiecke mit Z-Puffer,
/// Licht über [LightTable] (warm/kalt/Nebel) und Bayer-Dithering, Billboard-Sprites,
/// Nachthimmel mit Mond und Bergkulisse. Alles bleibt in der Palette.
class Renderer {
  final PixelBuffer fb;
  final LightTable lights;
  final List<IndexedTexture> textures;
  final Camera camera = Camera();
  final FrameStats stats = FrameStats();

  /// Handylicht: Stärke 0..1 (kaltes Licht im Bildkegel), Reichweite in Metern.
  double flashStrength = 0;
  double flashRange = 14;
  double flashRadius = 0.55; // Anteil der halben Bildhöhe

  /// Nebel (Meter) und Höhennebel (stärker am Boden).
  double fogStart = 8;
  double fogEnd = 46;
  double groundFog = 0.25;

  /// Grundlicht, das jede Fläche zusätzlich bekommt (Mondschimmer).
  double ambientCold = 0.10;

  /// Stärke des Bayer-Ditherings zwischen Lichtstufen (0 = harte Stufen, 1 = voll).
  double ditherStrength = 0.5;
  final Float32List _dith = Float32List(16);

  Float32List _cone = Float32List(0);
  int _coneW = 0, _coneH = 0;
  double _coneFor = -1;
  Float32List _v = Float32List(3 * 1024); // Kameraraum je Vertex
  final _clip = List<double>.filled(4 * 7 * 2, 0);
  final _poly = List<double>.filled(4 * 7, 0);
  final _tmp = List<double>.filled(3, 0);

  Renderer(this.fb, this.lights, this.textures);

  int get width => fb.width;
  int get height => fb.height;

  /// Bildbeginn: Kamera aktualisieren, Tiefenpuffer leeren, Zähler zurücksetzen.
  void begin() {
    camera.update(fb.width, fb.height);
    fb.clearDepth();
    stats.reset();
    for (var i = 0; i < 16; i++) {
      _dith[i] = 0.5 + ((bayer4[i] + 0.5) / 16 - 0.5) * ditherStrength;
    }
    if (_coneW != fb.width || _coneH != fb.height || _coneFor != flashRadius) _buildCone();
  }

  void _buildCone() {
    _coneW = fb.width;
    _coneH = fb.height;
    _coneFor = flashRadius;
    _cone = Float32List(_coneW * _coneH);
    final r = flashRadius * _coneH / 2;
    final cx = _coneW / 2, cy = _coneH / 2 + _coneH * 0.04;
    for (var y = 0; y < _coneH; y++) {
      for (var x = 0; x < _coneW; x++) {
        final dx = (x + 0.5 - cx) / r, dy = (y + 0.5 - cy) / r;
        final d = dx * dx + dy * dy;
        _cone[y * _coneW + x] = d >= 1 ? 0 : (1 - d) * (1 - d);
      }
    }
  }

  // ------------------------------------------------------------------ Himmel

  /// Nachthimmel mit Sternen, Mond und Karpaten-artiger Bergkulisse (eigene Form).
  void drawSky({double moonAzimuth = -2.2, double moonElevation = 0.42, int seed = 7}) {
    final cam = camera;
    final w = fb.width, h = fb.height;
    final col = fb.color;
    for (var y = 0; y < h; y++) {
      // Höhenwinkel der Zeile
      final ang = math.atan2(cam.cy - (y + 0.5), cam.focal) + cam.pitch;
      final t = ((ang + 0.15) / 0.9).clamp(0.0, 1.0);
      for (var x = 0; x < w; x++) {
        final d = bayer4[((y & 3) << 2) | (x & 3)] / 16.0;
        final level = (1 - t) * 3 + d; // 0..3 → Blau 50..53 nahe Horizont heller
        final s = level.floor().clamp(0, 3);
        col[y * w + x] = Ramp.at(Ramp.blue, s == 0 ? 0 : (s == 1 ? 1 : (s == 2 ? 2 : 3)));
      }
    }
    // Sterne (fest an der Himmelsrichtung)
    for (var x = 0; x < w; x++) {
      final az = cam.yaw + math.atan2(x + 0.5 - cam.cx, cam.focal);
      final key = ((az * 180 / math.pi) * 4).floor();
      final hsh = _hash(key * 7919 + seed);
      if (hsh % 23 == 0) {
        final elev = 0.18 + (hsh >> 8) % 1000 / 1000 * 0.6;
        final y = (cam.cy - math.tan(elev - cam.pitch) * cam.focal).round();
        if (y >= 0 && y < h) col[y * w + x] = (hsh >> 4) % 3 == 0 ? Pal.white : Pal.lightGrey;
      }
    }
    // Mond
    final rel = _wrapAngle(moonAzimuth - cam.yaw);
    if (rel.abs() < 1.4) {
      final mx = cam.cx + math.tan(rel) * cam.focal;
      final my = cam.cy - math.tan(moonElevation - cam.pitch) * cam.focal;
      final mr = math.max(2.0, h * 0.035);
      for (var y = (my - mr - 1).floor(); y <= (my + mr + 1).ceil(); y++) {
        for (var x = (mx - mr - 1).floor(); x <= (mx + mr + 1).ceil(); x++) {
          if (x < 0 || y < 0 || x >= w || y >= h) continue;
          final dx = x + 0.5 - mx, dy = y + 0.5 - my;
          final d = math.sqrt(dx * dx + dy * dy);
          if (d <= mr) {
            final shade = (dx + dy) > mr * 0.6 ? Pal.lightGrey : Pal.white;
            col[y * w + x] = shade;
          } else if (d <= mr + 1.5 && bayer4[((y & 3) << 2) | (x & 3)] < 6) {
            col[y * w + x] = Ramp.at(Ramp.blue, 4);
          }
        }
      }
    }
    // Bergkulisse: zwei Ketten mit eigener Silhouette (Parallaxe über Azimut)
    for (var layer = 0; layer < 2; layer++) {
      final baseElev = layer == 0 ? 0.11 : 0.05;
      final amp = layer == 0 ? 0.09 : 0.05;
      final c = layer == 0 ? Ramp.at(Ramp.blue, 1) : Ramp.at(Ramp.neutral, 1);
      for (var x = 0; x < w; x++) {
        final az = cam.yaw + math.atan2(x + 0.5 - cam.cx, cam.focal);
        final e = baseElev + amp * _ridge(az * (layer == 0 ? 3.0 : 5.0) + layer * 11);
        final top = (cam.cy - math.tan(e - cam.pitch) * cam.focal).round();
        for (var y = math.max(0, top); y < h; y++) {
          col[y * w + x] = c;
        }
      }
    }
  }

  static double _ridge(double a) {
    final v = 0.55 * math.sin(a) + 0.3 * math.sin(a * 2.3 + 1.7) + 0.15 * math.sin(a * 5.1 + 0.4);
    return 0.5 + 0.5 * v.abs() * (v > 0 ? 1 : 0.6);
  }

  static double _wrapAngle(double a) {
    var r = a % (2 * math.pi);
    if (r > math.pi) r -= 2 * math.pi;
    if (r < -math.pi) r += 2 * math.pi;
    return r;
  }

  static int _hash(int x) {
    var h = x & 0x7fffffff;
    h = ((h >> 16) ^ h) * 0x45d9f3b & 0x7fffffff;
    h = ((h >> 16) ^ h) * 0x45d9f3b & 0x7fffffff;
    return (h >> 16) ^ h;
  }

  // ------------------------------------------------------------------ Meshes

  /// Zeichnet ein Mesh (mit Kugel-Culling).
  void drawMesh(Mesh m) {
    stats.meshesSubmitted++;
    final cam = camera;
    if (!cam.sphereVisible(m.bx, m.by, m.bz, m.br)) return;
    final dxm = m.bx - cam.x, dzm = m.bz - cam.z;
    if (math.sqrt(dxm * dxm + dzm * dzm) - m.br > cam.far) return;
    stats.meshesDrawn++;
    final vc = m.vertexCount;
    if (_v.length < vc * 3) _v = Float32List(vc * 3 * 2);
    final pos = m.pos;
    final v = _v;
    final rx = cam.rx, rz = cam.rz, fx = cam.fx, fz = cam.fz, cp = cam.cp, sp = cam.sp;
    final ex = cam.x, ey = cam.y, ez = cam.z;
    for (var i = 0, o = 0; i < vc; i++, o += 3) {
      final dx = pos[o] - ex, dy = pos[o + 1] - ey, dz = pos[o + 2] - ez;
      final vz0 = dx * fx + dz * fz;
      v[o] = dx * rx + dz * rz;
      v[o + 1] = dy * cp - vz0 * sp;
      v[o + 2] = vz0 * cp + dy * sp;
    }
    final tri = m.tri;
    final tc = m.triangleCount;
    stats.trianglesSubmitted += tc;
    final near = cam.near, far = cam.far;
    for (var t = 0; t < tc; t++) {
      final a = tri[t * 3], b = tri[t * 3 + 1], c = tri[t * 3 + 2];
      final za = v[a * 3 + 2], zb = v[b * 3 + 2], zc = v[c * 3 + 2];
      if (za < near && zb < near && zc < near) continue;
      if (za > far && zb > far && zc > far) continue;
      _drawTriangle(m, a, b, c, t);
    }
  }

  void _loadVertex(Mesh m, int vi, List<double> out, int o) {
    out[o] = _v[vi * 3];
    out[o + 1] = _v[vi * 3 + 1];
    out[o + 2] = _v[vi * 3 + 2];
    out[o + 3] = m.uv[vi * 2];
    out[o + 4] = m.uv[vi * 2 + 1];
    out[o + 5] = m.light[vi * 2];
    out[o + 6] = m.light[vi * 2 + 1];
  }

  void _drawTriangle(Mesh m, int a, int b, int c, int t) {
    final poly = _poly;
    _loadVertex(m, a, poly, 0);
    _loadVertex(m, b, poly, 7);
    _loadVertex(m, c, poly, 14);
    var n = 3;
    final near = camera.near;
    // Near-Clipping (Sutherland–Hodgman an z = near)
    if (poly[2] < near || poly[9] < near || poly[16] < near) {
      final out = _clip;
      var k = 0;
      for (var i = 0; i < 3; i++) {
        final j = (i + 1) % 3;
        final zi = poly[i * 7 + 2], zj = poly[j * 7 + 2];
        final iin = zi >= near, jin = zj >= near;
        if (iin) {
          for (var q = 0; q < 7; q++) {
            out[k * 7 + q] = poly[i * 7 + q];
          }
          k++;
        }
        if (iin != jin) {
          final f = (near - zi) / (zj - zi);
          for (var q = 0; q < 7; q++) {
            out[k * 7 + q] = poly[i * 7 + q] + (poly[j * 7 + q] - poly[i * 7 + q]) * f;
          }
          k++;
        }
      }
      if (k < 3) return;
      for (var i = 0; i < k * 7; i++) {
        poly[i] = out[i];
      }
      n = k;
    }
    // Projektion
    final cam = camera;
    final f = cam.focal, cx = cam.cx, cy = cam.cy;
    // in-place: [sx, sy, iz, u*iz, v*iz, warm, cold]
    for (var i = 0; i < n; i++) {
      final o = i * 7;
      final iz = 1 / poly[o + 2];
      final sx = cx + poly[o] * f * iz;
      final sy = cy - poly[o + 1] * f * iz;
      poly[o] = sx;
      poly[o + 1] = sy;
      poly[o + 2] = iz;
      poly[o + 3] = poly[o + 3] * iz;
      poly[o + 4] = poly[o + 4] * iz;
    }
    // Rückseiten-Culling (Fläche im Bildraum)
    final area = (poly[7] - poly[0]) * (poly[15] - poly[1]) - (poly[14] - poly[0]) * (poly[8] - poly[1]);
    if (area.abs() < 1e-9) return;
    if (area > 0 && m.flags[t] == 0) return;
    final tex = textures[m.tex[t]];
    stats.trianglesDrawn++;
    _rasterTri(poly, 0, 7, 14, tex);
    if (n == 4) _rasterTri(poly, 0, 14, 21, tex);
  }

  void _rasterTri(List<double> p, int i0, int i1, int i2, IndexedTexture tex) {
    // Nach y sortieren
    var a = i0, b = i1, c = i2;
    if (p[b + 1] < p[a + 1]) {
      final t = a;
      a = b;
      b = t;
    }
    if (p[c + 1] < p[a + 1]) {
      final t = a;
      a = c;
      c = t;
    }
    if (p[c + 1] < p[b + 1]) {
      final t = b;
      b = c;
      c = t;
    }
    final x0 = p[a], y0 = p[a + 1], x1 = p[b], y1 = p[b + 1], x2 = p[c], y2 = p[c + 1];
    final det = (x1 - x0) * (y2 - y0) - (x2 - x0) * (y1 - y0);
    if (det.abs() < 1e-9) return;
    final idet = 1 / det;
    // Gradienten der Attribute (Ebene): iz, uiz, viz, warm, cold
    double gx(int q) => ((p[b + q] - p[a + q]) * (y2 - y0) - (p[c + q] - p[a + q]) * (y1 - y0)) * idet;
    double gy(int q) => ((p[c + q] - p[a + q]) * (x1 - x0) - (p[b + q] - p[a + q]) * (x2 - x0)) * idet;
    final dIzx = gx(2), dIzy = gy(2);
    final dUx = gx(3), dUy = gy(3);
    final dVx = gx(4), dVy = gy(4);
    final dWx = gx(5), dWy = gy(5);
    final dCx = gx(6), dCy = gy(6);
    final iz0 = p[a + 2], u0 = p[a + 3], v0 = p[a + 4], w0 = p[a + 5], c0 = p[a + 6];

    final w = fb.width, h = fb.height;
    final yStart = math.max(0, (y0 - 0.5).ceil());
    final yEnd = math.min(h - 1, (y2 - 0.5).ceil() - 1);
    if (yStart > yEnd) return;

    final col = fb.color, dep = fb.depth;
    final cone = _cone;
    final table = lights.table;
    final flash = flashStrength;
    final flashRange2 = flashRange * flashRange;
    final fogS = fogStart, fogInv = 1 / (fogEnd - fogStart);
    final amb = ambientCold;
    final transparent = tex.hasTransparency;
    final camY = camera.y, focal = camera.focal, ccy = camera.cy;
    final gFog = groundFog;
    final dith = _dith;
    final lut = LightTable.levelLut;
    // Mip-Schwellen nach Tiefe: Texel pro Bildpixel = Dichte * z / focal
    final m1 = focal / kTexelsPerMeter * 2, m2 = m1 * 2, m3 = m2 * 2;
    final levels = tex.levels;
    final nLv = levels.length;
    var written = 0;

    final invL02 = 1 / (y2 - y0);
    final hasTop = y1 - y0 > 1e-9;
    final hasBot = y2 - y1 > 1e-9;
    final invL01 = hasTop ? 1 / (y1 - y0) : 0.0;
    final invL12 = hasBot ? 1 / (y2 - y1) : 0.0;

    for (var y = yStart; y <= yEnd; y++) {
      final yc = y + 0.5;
      final xl02 = x0 + (x2 - x0) * (yc - y0) * invL02;
      double xs;
      if (yc < y1) {
        xs = hasTop ? x0 + (x1 - x0) * (yc - y0) * invL01 : x1;
      } else {
        xs = hasBot ? x1 + (x2 - x1) * (yc - y1) * invL12 : x1;
      }
      var xa = xl02, xb = xs;
      if (xa > xb) {
        final t = xa;
        xa = xb;
        xb = t;
      }
      var xStart = (xa - 0.5).ceil();
      var xEnd = (xb - 0.5).ceil() - 1;
      if (xStart < 0) xStart = 0;
      if (xEnd > w - 1) xEnd = w - 1;
      if (xStart > xEnd) continue;
      final dxs = xStart + 0.5 - x0, dys = yc - y0;
      var iz = iz0 + dxs * dIzx + dys * dIzy;
      var uz = u0 + dxs * dUx + dys * dUy;
      var vz = v0 + dxs * dVx + dys * dVy;
      var wl = w0 + dxs * dWx + dys * dWy;
      var cl = c0 + dxs * dCx + dys * dCy;
      var idx = y * w + xStart;
      final rowB = (y & 3) << 2;
      // Höhe über Kamera je Zeile (für Bodennebel), ohne Neigung genähert
      final rowSlope = (ccy - yc) / focal;
      for (var x = xStart; x <= xEnd; x++, idx++) {
        if (iz > dep[idx]) {
          final z = 1 / iz;
          var lv = z < m1 ? 0 : (z < m2 ? 1 : (z < m3 ? 2 : 3));
          if (lv >= nLv) lv = nLv - 1;
          final tw = tex.widths[lv], th = tex.heights[lv];
          final tu = ((uz * z).floor() >> lv) & (tw - 1);
          final tv = ((vz * z).floor() >> lv) & (th - 1);
          final texel = levels[lv][tv * tw + tu];
          if (!(transparent && texel == kTransparent)) {
            final d = dith[rowB | (x & 3)];
            var cold = cl + amb;
            if (flash > 0) {
              final cf = cone[idx];
              if (cf > 0) cold += flash * cf * flashRange2 / (flashRange2 + z * z * 6);
            }
            var fog = (z - fogS) * fogInv;
            if (gFog > 0) {
              final hy = camY + rowSlope * z;
              if (hy < 1.2) fog += gFog * (1.2 - hy) / 1.2 * (z > 3 ? 1 : z / 3);
            }
            var wi = (wl * 1024).toInt();
            wi = wi < 0 ? 0 : (wi > 1024 ? 1024 : wi);
            var ci = (cold * 1024).toInt();
            ci = ci < 0 ? 0 : (ci > 1024 ? 1024 : ci);
            var wq = (lut[wi] + d).toInt();
            var cq = (lut[ci] + d).toInt();
            var fq = (fog * 3 + d).floor();
            wq = wq < 0 ? 0 : (wq > 7 ? 7 : wq);
            cq = cq < 0 ? 0 : (cq > 7 ? 7 : cq);
            fq = fq < 0 ? 0 : (fq > 3 ? 3 : fq);
            col[idx] = table[((fq * 8 + wq) * 8 + cq) * LightTable.colors + texel];
            dep[idx] = iz;
            written++;
          }
        }
        iz += dIzx;
        uz += dUx;
        vz += dVx;
        wl += dWx;
        cl += dCx;
      }
    }
    stats.pixelsWritten += written;
  }

  // ------------------------------------------------------------------ Sprites

  /// Billboard-Sprite am Fußpunkt (x, y, z), immer zur Kamera gedreht.
  void drawSprite(SpriteImage s, double x, double y, double z, {double warm = 0, double cold = 0, bool lit = true}) {
    final cam = camera;
    cam.toView(x, y, z, _tmp, 0);
    final vz = _tmp[2];
    if (vz < cam.near * 2 || vz > cam.far) return;
    final iz = 1 / vz;
    final sx = cam.cx + _tmp[0] * cam.focal * iz;
    final sy = cam.cy - _tmp[1] * cam.focal * iz;
    final scale = cam.focal * iz / kTexelsPerMeter; // Bildpixel pro Texel
    final left = sx - s.footX * scale, top = sy - s.footY * scale;
    final right = left + s.width * scale, bottom = top + s.height * scale;
    final w = fb.width, h = fb.height;
    final x0 = math.max(0, (left - 0.5).ceil()), x1 = math.min(w - 1, (right - 0.5).ceil() - 1);
    final y0 = math.max(0, (top - 0.5).ceil()), y1 = math.min(h - 1, (bottom - 0.5).ceil() - 1);
    if (x0 > x1 || y0 > y1) return;
    var lv = 0;
    if (scale < 1) {
      lv = (math.log(1 / scale) / math.ln2).floor();
      if (lv >= s._mips.length) lv = s._mips.length - 1;
    }
    final px = s._mips[lv], mw = s._mw[lv], mh = s._mh[lv];
    final col = fb.color, dep = fb.depth, table = lights.table, cone = _cone;
    final fog = (vz - fogStart) / (fogEnd - fogStart);
    final flash = flashStrength, fr2 = flashRange * flashRange;
    stats.spritesDrawn++;
    var wi = (warm * 1024).toInt();
    wi = wi < 0 ? 0 : (wi > 1024 ? 1024 : wi);
    for (var yy = y0; yy <= y1; yy++) {
      final ty = ((yy + 0.5 - top) / scale).floor() >> lv;
      if (ty < 0 || ty >= mh) continue;
      final rowB = (yy & 3) << 2;
      for (var xx = x0; xx <= x1; xx++) {
        final idx = yy * w + xx;
        if (dep[idx] >= iz) continue;
        final tx = ((xx + 0.5 - left) / scale).floor() >> lv;
        if (tx < 0 || tx >= mw) continue;
        final c = px[ty * mw + tx];
        if (c == kTransparent) continue;
        if (!lit) {
          col[idx] = c;
          dep[idx] = iz;
          continue;
        }
        final d = _dith[rowB | (xx & 3)];
        var cl = cold + ambientCold;
        if (flash > 0 && cone[idx] > 0) cl += flash * cone[idx] * fr2 / (fr2 + vz * vz * 6);
        var ci = (cl * 1024).toInt();
        ci = ci < 0 ? 0 : (ci > 1024 ? 1024 : ci);
        var wq = (LightTable.levelLut[wi] + d).toInt(), cq = (LightTable.levelLut[ci] + d).toInt(), fq = (fog * 3 + d).floor();
        wq = wq < 0 ? 0 : (wq > 7 ? 7 : wq);
        cq = cq < 0 ? 0 : (cq > 7 ? 7 : cq);
        fq = fq < 0 ? 0 : (fq > 3 ? 3 : fq);
        col[idx] = table[((fq * 8 + wq) * 8 + cq) * LightTable.colors + c];
        dep[idx] = iz;
      }
    }
  }
}

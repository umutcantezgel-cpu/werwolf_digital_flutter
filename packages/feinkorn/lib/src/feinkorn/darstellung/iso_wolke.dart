import 'dart:math' as math;
import 'dart:typed_data';

import 'iso_backen.dart';

/// Bewegte Blöcke als Würfelwolke backen (Prototyp für bewegte Körper und Partikel): je Punkt ein
/// achsenparalleler Würfel der Kante [groesse] mit drei sichtbaren Seiten, Tiefenpuffer, Seitenlicht.
/// Mittelpunkte in Weltmetern ([x], [y], [z]), Farbe 0xRRGGBB.
IsoBild backeWolke(Float64List x, Float64List y, Float64List z, Float64List groesse, Int32List farbe, int anzahl,
    IsoAnsicht ansicht, {double oben = 1.0, double links = 0.82, double rechts = 0.55}) {
  if (anzahl == 0) return IsoBild(1, 1, Uint8List(4), 0, 0, ansicht.skala, 0);
  var minX = double.infinity, minY = double.infinity, maxX = -double.infinity, maxY = -double.infinity;
  for (var i = 0; i < anzahl; i++) {
    final g = groesse[i];
    final px = ansicht.sx(x[i], y[i]), py = ansicht.sy(x[i], y[i], z[i]);
    final r = g * 60 * ansicht.skala;
    minX = math.min(minX, px - r);
    maxX = math.max(maxX, px + r);
    minY = math.min(minY, py - r);
    maxY = math.max(maxY, py + r);
  }
  final x0 = minX.floor(), y0 = minY.floor();
  final w = maxX.ceil() - x0 + 1, h = maxY.ceil() - y0 + 1;
  final rgba = Uint8List(w * h * 4);
  final tiefe = Float32List(w * h)..fillRange(0, w * h, -1e30);
  final sk = ansicht.skala, zf = ansicht.hochZ / (2 * ansicht.halbH);
  var flaechen = 0;
  void flaeche(double px, double py, double e1x, double e1y, double e2x, double e2y, double d, int argb, double hell) {
    flaechen++;
    final det = e1x * e2y - e1y * e2x;
    if (det.abs() < 1e-12) return;
    final inv = 1 / det;
    final bx0 = math.min(px, math.min(px + e1x, math.min(px + e2x, px + e1x + e2x)));
    final bx1 = math.max(px, math.max(px + e1x, math.max(px + e2x, px + e1x + e2x)));
    final by0 = math.min(py, math.min(py + e1y, math.min(py + e2y, py + e1y + e2y)));
    final by1 = math.max(py, math.max(py + e1y, math.max(py + e2y, py + e1y + e2y)));
    final r = (((argb >> 16) & 0xFF) * hell).round().clamp(0, 255), g = (((argb >> 8) & 0xFF) * hell).round().clamp(0, 255);
    final b = ((argb & 0xFF) * hell).round().clamp(0, 255);
    for (var iy = math.max(0, (by0 - y0 - 0.5).ceil()); iy <= math.min(h - 1, (by1 - y0 - 0.5).floor()); iy++) {
      final qy = iy + y0 + 0.5 - py;
      for (var ix = math.max(0, (bx0 - x0 - 0.5).ceil()); ix <= math.min(w - 1, (bx1 - x0 - 0.5).floor()); ix++) {
        final qx = ix + x0 + 0.5 - px;
        final a = (qx * e2y - qy * e2x) * inv;
        if (a < -1e-4 || a >= 1 + 1e-4) continue;
        final c = (e1x * qy - e1y * qx) * inv;
        if (c < -1e-4 || c >= 1 + 1e-4) continue;
        final o = iy * w + ix;
        if (d <= tiefe[o]) continue;
        tiefe[o] = d;
        rgba[o * 4] = r;
        rgba[o * 4 + 1] = g;
        rgba[o * 4 + 2] = b;
        rgba[o * 4 + 3] = 255;
      }
    }
  }

  for (var i = 0; i < anzahl; i++) {
    final s = groesse[i], hs = s / 2;
    final ax = x[i] - hs, ay = y[i] - hs, az = z[i] - hs;
    final uxX = ansicht.halbB * s * sk, uxY = ansicht.halbH * s * sk, uyX = -uxX, uyY = uxY, uzY = -ansicht.hochZ * s * sk;
    final f = farbe[i];
    flaeche(ansicht.sx(ax, ay), ansicht.sy(ax, ay, az + s), uxX, uxY, uyX, uyY, x[i] + y[i] + (z[i] + hs) * zf, f, oben);
    flaeche(ansicht.sx(ax, ay + s), ansicht.sy(ax, ay + s, az), uxX, uxY, 0, uzY, x[i] + y[i] + hs + z[i] * zf, f, links);
    flaeche(ansicht.sx(ax + s, ay), ansicht.sy(ax + s, ay, az), uyX, uyY, 0, uzY, x[i] + hs + y[i] + z[i] * zf, f, rechts);
  }
  return IsoBild(w, h, rgba, x0 / sk, y0 / sk, sk, flaechen);
}

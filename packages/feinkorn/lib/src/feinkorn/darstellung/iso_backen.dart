import 'dart:math' as math;
import 'dart:typed_data';

import '../daten/blockkoerper.dart';
import '../daten/material.dart';
import '../daten/muster.dart';
import 'schattenkarte.dart';

/// Isometrische Ansicht wie die Spielszene (2:1): je Meter Welt `x` → (+[halbB], +[halbH]),
/// `y` → (−[halbB], +[halbH]), `z` → (0, −[hochZ]) logische Pixel, mal [skala] Bildpixel je logischem Pixel.
class IsoAnsicht {
  const IsoAnsicht({this.halbB = 32, this.halbH = 16, this.hochZ = 40, this.skala = 1});

  final double halbB, halbH, hochZ, skala;

  double sx(double x, double y) => (x - y) * halbB * skala;
  double sy(double x, double y, double z) => ((x + y) * halbH - z * hochZ) * skala;

  /// Tiefe (größer = näher am Betrachter): Blickrichtung (1, 1, hochZ / (2 · halbH)).
  double tiefe(double x, double y, double z) => x + y + z * hochZ / (2 * halbH);
}

/// Grundbeleuchtung zum Backen ruhender Körper (7.3: Licht für Ruhendes darf vorberechnet werden).
/// [richtung] zeigt zum Licht (45° Höhe von links-vorn: Oberseiten hell, linke Seiten mittel, rechte dunkel).
class Backlicht {
  const Backlicht({this.richtung = const [-0.5, 0.5, 0.70710678], this.grund = 0.5, this.schatten = true, this.verdeckung = 0.06});

  final List<double> richtung;

  /// Anteil des Grundlichts (Schatten und abgewandte Seiten).
  final double grund;
  final bool schatten;

  /// Abdunklung je belegtem Nachbarn um eine Fläche (dunklere Fugen und Ecken).
  final double verdeckung;
}

/// Ein Blockkörper an seinem Platz in der Welt (Ecke von Block 0,0,0 bei [x], [y], [z] Metern).
class Platzierung {
  const Platzierung(this.koerper, this.x, this.y, this.z);

  final Blockkoerper koerper;
  final double x, y, z;

  /// Belegt die Welt an (wx, wy, wz) Metern einen Block dieses Körpers?
  bool belegt(double wx, double wy, double wz) {
    final s = koerper.blockgroesse;
    final i = ((wx - x) / s).floor(), j = ((wy - y) / s).floor(), k = ((wz - z) / s).floor();
    return koerper.wert(i, j, k) != 0;
  }
}

/// Ein gebackenes Bild: RGBA (nicht vormultipliziert), [links]/[oben] = logische Bildschirmlage der linken
/// oberen Ecke relativ zum Bildpunkt des Weltursprungs; ein Bildpixel ist 1/[skala] logische Pixel.
class IsoBild {
  IsoBild(this.breite, this.hoehe, this.rgba, this.links, this.oben, this.skala, this.flaechen);

  final int breite, hoehe;
  final Uint8List rgba;
  final double links, oben, skala;

  /// Gezeichnete Blockflächen (Maß für die Backkosten).
  final int flaechen;
}

int _mul32(int a, int b) {
  final aLo = a & 0xFFFF, aHi = (a >> 16) & 0xFFFF;
  final bLo = b & 0xFFFF, bHi = (b >> 16) & 0xFFFF;
  return (aLo * bLo + ((((aHi * bLo) + (aLo * bHi)) & 0xFFFF) << 16)) & 0xFFFFFFFF;
}

/// Hash eines Blocks (VM und Web gleich): 0..65535.
int blockHash(int x, int y, int z, int saat) {
  var h = _mul32((x & 0xFFFF) ^ _mul32(y & 0xFFFF, 0x9E3779B1) ^ _mul32(z & 0xFFFF, 0x85EBCA77), 0xC2B2AE3D) ^ saat;
  h ^= h >> 15;
  h = _mul32(h, 0x2C1B3C6D);
  h ^= h >> 12;
  return h & 0xFFFF;
}

/// Backt [p] in die Iso-[ansicht]: sichtbare Seiten (oben, Süd = links, Ost = rechts) jedes
/// Oberflächenblocks als Parallelogramm mit Tiefenpuffer; Helligkeit aus Seite, Schatten ([schatten] der
/// ganzen Szene, gebaut mit derselben Lichtrichtung), Umgebungsverdeckung und Streuung des Materials.
/// Mit [flaecheAus] werden die Flächen nicht gerastert, sondern übergeben (Prototyp Weg C):
/// Bildpunkt, zwei Kanten, Tiefe, Farbe 0xAARRGGBB.
IsoBild backe(Platzierung p, IsoAnsicht ansicht,
    {Backlicht licht = const Backlicht(),
    Schattenkarte? schatten,
    int saat = 1,
    void Function(double px, double py, double e1x, double e1y, double e2x, double e2y, double tiefe, int argb)? flaecheAus}) {
  final k = p.koerper;
  final s = k.blockgroesse;
  // Bildgrenzen aus den 8 Ecken
  var minX = double.infinity, minY = double.infinity, maxX = -double.infinity, maxY = -double.infinity;
  for (final cx in [p.x, p.x + k.breite * s]) {
    for (final cy in [p.y, p.y + k.tiefe * s]) {
      for (final cz in [p.z, p.z + k.hoehe * s]) {
        final px = ansicht.sx(cx, cy), py = ansicht.sy(cx, cy, cz);
        minX = math.min(minX, px);
        maxX = math.max(maxX, px);
        minY = math.min(minY, py);
        maxY = math.max(maxY, py);
      }
    }
  }
  final x0 = minX.floor(), y0 = minY.floor();
  final w = maxX.ceil() - x0 + 1, h = maxY.ceil() - y0 + 1;
  final rgba = Uint8List(w * h * 4);
  final tiefe = Float32List(w * h)..fillRange(0, w * h, -1e30);

  // Kantenvektoren eines Blocks in Bildpixeln
  final sk = ansicht.skala;
  final uxX = ansicht.halbB * s * sk, uxY = ansicht.halbH * s * sk; // +x
  final uyX = -ansicht.halbB * s * sk, uyY = ansicht.halbH * s * sk; // +y
  const uzX = 0.0;
  final uzY = -ansicht.hochZ * s * sk; // +z
  final zFaktor = ansicht.hochZ / (2 * ansicht.halbH);

  // Licht je Seite (Lambert, oben normiert auf 1)
  final l = licht.richtung;
  final oben = l[2];
  double seite(double ndl) => licht.grund + (1 - licht.grund) * math.max(0.0, ndl) / oben;
  final hellOben = seite(l[2]), hellSued = seite(l[1]), hellOst = seite(l[0]);

  // Abfrage eine halbe Blockgröße vor der Fläche (Normalenversatz), Toleranz eine Blockgröße
  // Toleranz mit der Neigung der Fläche zum Licht (flach einfallendes Licht braucht mehr Abstand gegen
  // Schatten-Akne): Oberseiten 1,5 Blöcke, senkrechte Seiten 3,5 Blöcke.
  bool imSchatten(double wx, double wy, double wz, [double faktor = 1.5]) =>
      licht.schatten && schatten != null && schatten.imSchatten(wx, wy, wz, s * faktor);

  var flaechen = 0;
  // Parallelogramm ab Bildpunkt (px, py) mit Kanten (e1, e2) zeichnen, wo es näher ist als der Puffer
  void flaeche(double px, double py, double e1x, double e1y, double e2x, double e2y, double d, int r, int g, int b) {
    flaechen++;
    final det = e1x * e2y - e1y * e2x;
    if (det.abs() < 1e-12) return;
    final inv = 1 / det;
    final bx0 = math.min(px, math.min(px + e1x, math.min(px + e2x, px + e1x + e2x)));
    final bx1 = math.max(px, math.max(px + e1x, math.max(px + e2x, px + e1x + e2x)));
    final by0 = math.min(py, math.min(py + e1y, math.min(py + e2y, py + e1y + e2y)));
    final by1 = math.max(py, math.max(py + e1y, math.max(py + e2y, py + e1y + e2y)));
    final ix0 = math.max(0, (bx0 - x0 - 0.5).ceil()), ix1 = math.min(w - 1, (bx1 - x0 - 0.5).floor());
    final iy0 = math.max(0, (by0 - y0 - 0.5).ceil()), iy1 = math.min(h - 1, (by1 - y0 - 0.5).floor());
    for (var iy = iy0; iy <= iy1; iy++) {
      final qy = iy + y0 + 0.5 - py;
      for (var ix = ix0; ix <= ix1; ix++) {
        final qx = ix + x0 + 0.5 - px;
        final a = (qx * e2y - qy * e2x) * inv;
        // kleine Toleranz: Pixelmitten genau auf gemeinsamen Kanten fallen sonst durch Rundung in keine Fläche
        if (a < -1e-4 || a >= 1 + 1e-4) continue;
        final c = (e1x * qy - e1y * qx) * inv;
        if (c < -1e-4 || c >= 1 + 1e-4) continue;
        final o = iy * w + ix;
        if (d <= tiefe[o]) continue;
        tiefe[o] = d;
        final o4 = o << 2;
        rgba[o4] = r;
        rgba[o4 + 1] = g;
        rgba[o4 + 2] = b;
        rgba[o4 + 3] = 255;
      }
    }
  }

  int nachbarn(int x, int y, int z, int ax, int ay, int az) {
    // belegte Zellen in der Schicht vor der Fläche (Achse a), 8 Nachbarn
    var n = 0;
    for (var u = -1; u <= 1; u++) {
      for (var v = -1; v <= 1; v++) {
        if (u == 0 && v == 0) continue;
        int dx = 0, dy = 0, dz = 0;
        if (ax != 0) {
          dy = u;
          dz = v;
        } else if (ay != 0) {
          dx = u;
          dz = v;
        } else {
          dx = u;
          dy = v;
        }
        if (k.wert(x + ax + dx, y + ay + dy, z + az + dz) != 0) n++;
      }
    }
    return n;
  }

  final ort = MusterOrt(), wert = MusterWert();
  k.jederBlock((x, y, z, wTafel) {
    final obenFrei = k.wert(x, y, z + 1) == 0;
    final suedFrei = k.wert(x, y + 1, z) == 0;
    final ostFrei = k.wert(x + 1, y, z) == 0;
    if (!obenFrei && !suedFrei && !ostFrei) return;
    final e = k.tafel[wTafel]!;
    final m = materialVon(e.material)!;
    final muster = musterVon(m.id);
    final wx = p.x + x * s, wy = p.y + y * s, wz = p.z + z * s;
    ort
      ..x = x
      ..y = y
      ..z = z
      ..s = s
      ..wx = wx
      ..wy = wy
      ..wz = wz
      ..hash = blockHash(x, y, z, saat);
    void male(Seite seite, double hell, double px, double py, double e1x, double e1y, double e2x, double e2y, double cx, double cy, double cz) {
      ort.seite = seite;
      muster(ort, m, wert);
      final r0 = ((e.farbe >> 16) & 0xFF) + wert.dr, g0 = ((e.farbe >> 8) & 0xFF) + wert.dg, b0 = (e.farbe & 0xFF) + wert.db;
      final f = (m.leuchten > 0 ? math.max(hell, 0.6 + m.leuchten * 0.6) : hell) * wert.hell;
      int c(num v) => (v * f).round().clamp(0, 255);
      final aus = flaecheAus;
      if (aus != null) {
        flaechen++;
        aus(px, py, e1x, e1y, e2x, e2y, cx + cy + cz * zFaktor, 0xFF000000 | (c(r0) << 16) | (c(g0) << 8) | c(b0));
        return;
      }
      flaeche(px, py, e1x, e1y, e2x, e2y, cx + cy + cz * zFaktor, c(r0), c(g0), c(b0));
    }

    if (obenFrei) {
      var hell = hellOben * (1 - licht.verdeckung * nachbarn(x, y, z, 0, 0, 1));
      if (imSchatten(wx + s / 2, wy + s / 2, wz + s * 1.5)) hell = licht.grund * (1 - licht.verdeckung * nachbarn(x, y, z, 0, 0, 1));
      male(Seite.oben, hell, ansicht.sx(wx, wy), ansicht.sy(wx, wy, wz + s), uxX, uxY, uyX, uyY, wx + s / 2, wy + s / 2, wz + s);
    }
    if (suedFrei) {
      var hell = hellSued * (1 - licht.verdeckung * nachbarn(x, y, z, 0, 1, 0));
      if (l[1] > 0 && imSchatten(wx + s / 2, wy + s * 1.5, wz + s / 2, 3.5)) hell = licht.grund * (1 - licht.verdeckung * nachbarn(x, y, z, 0, 1, 0));
      male(Seite.sued, hell, ansicht.sx(wx, wy + s), ansicht.sy(wx, wy + s, wz), uxX, uxY, uzX, uzY, wx + s / 2, wy + s, wz + s / 2);
    }
    if (ostFrei) {
      var hell = hellOst * (1 - licht.verdeckung * nachbarn(x, y, z, 1, 0, 0));
      if (l[0] > 0 && imSchatten(wx + s * 1.5, wy + s / 2, wz + s / 2, 3.5)) hell = licht.grund * (1 - licht.verdeckung * nachbarn(x, y, z, 1, 0, 0));
      male(Seite.ost, hell, ansicht.sx(wx + s, wy), ansicht.sy(wx + s, wy, wz), uyX, uyY, uzX, uzY, wx + s, wy + s / 2, wz + s / 2);
    }
  });
  // Lage des Bildes in logischen Pixeln relativ zum Bildpunkt des Weltursprungs
  return IsoBild(w, h, rgba, x0 / sk, y0 / sk, sk, flaechen);
}

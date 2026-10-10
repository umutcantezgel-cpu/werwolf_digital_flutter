// FEINKORN K0 · Prototyp Bewegung: gehende Figur aus 1-cm-Blöcken mit Skelett (11 Knochen), Gangzyklus in
// 8 Bildern, zwei Gelenkwege (starr = Vorwärtsabbildung, rück = Rückabtastung + Gelenkkugeln), je Bild
// Aufbauzeit und Lückenprüfung; Bildstreifen beider Wege.
// Aufruf: dart run bin/feinkorn_k0_figur.dart <ausgabeOrdner>
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:pixel_engine/feinkorn.dart';
import 'package:pixel_engine/pixel_engine.dart' show encodePngRgba;

const s = 0.01;
const hose = Farbeintrag(8, 0x2B3A55), jacke = Farbeintrag(8, 0xB8A48A), haut = Farbeintrag(9, 0xC89A78);
const haar = Farbeintrag(8, 0x2A211C), schuh = Farbeintrag(9, 0x1E1A18), knopf = Farbeintrag(4, 0x3C3C40);
const auge = Farbeintrag(8, 0x16120F);

/// Teilmodell aus Kapseln (Knochenraum, Gelenk im Ursprung): (ax, ay, az, bx, by, bz, r, Farbe).
(Blockkoerper, double, double, double) teil(List<(double, double, double, double, double, double, double, Farbeintrag)> kapseln) {
  var x0 = double.infinity, y0 = double.infinity, z0 = double.infinity, x1 = -double.infinity, y1 = -double.infinity, z1 = -double.infinity;
  for (final c in kapseln) {
    x0 = math.min(x0, math.min(c.$1, c.$4) - c.$7);
    y0 = math.min(y0, math.min(c.$2, c.$5) - c.$7);
    z0 = math.min(z0, math.min(c.$3, c.$6) - c.$7);
    x1 = math.max(x1, math.max(c.$1, c.$4) + c.$7);
    y1 = math.max(y1, math.max(c.$2, c.$5) + c.$7);
    z1 = math.max(z1, math.max(c.$3, c.$6) + c.$7);
  }
  final nx = ((x1 - x0) / s).ceil(), ny = ((y1 - y0) / s).ceil(), nz = ((z1 - z0) / s).ceil();
  final k = Blockkoerper(blockgroesse: s, breite: nx, tiefe: ny, hoehe: nz);
  for (final c in kapseln) {
    final w = k.eintrag(c.$8);
    final dx = c.$4 - c.$1, dy = c.$5 - c.$2, dz = c.$6 - c.$3, ll = dx * dx + dy * dy + dz * dz;
    for (var z = 0; z < nz; z++) {
      for (var y = 0; y < ny; y++) {
        for (var x = 0; x < nx; x++) {
          final px = x0 + (x + 0.5) * s - c.$1, py = y0 + (y + 0.5) * s - c.$2, pz = z0 + (z + 0.5) * s - c.$3;
          final t = ll == 0 ? 0.0 : ((px * dx + py * dy + pz * dz) / ll).clamp(0.0, 1.0);
          final qx = px - dx * t, qy = py - dy * t, qz = pz - dz * t;
          if (qx * qx + qy * qy + qz * qz <= c.$7 * c.$7) k.setze(x, y, z, w);
        }
      }
    }
  }
  return (k, x0, y0, z0);
}

Skelett baueSkelett() {
  Knochen kn(String name, int e, double ox, double oy, double oz, List<(double, double, double, double, double, double, double, Farbeintrag)> c) {
    final (k, x, y, z) = teil(c);
    return Knochen(name, e, ox, oy, oz, k, x, y, z);
  }

  return Skelett([
    kn('becken', -1, 0, 0, 0.95, [(-0.11, 0, 0, 0.11, 0, 0, 0.1, hose)]),
    kn('rumpf', 0, 0, 0, 0.04, [
      (0, 0, 0.04, 0, 0, 0.44, 0.165, jacke),
      (0, 0.158, 0.16, 0, 0.158, 0.17, 0.012, knopf),
      (0, 0.162, 0.26, 0, 0.162, 0.27, 0.012, knopf),
      (0, 0.162, 0.36, 0, 0.162, 0.37, 0.012, knopf),
    ]),
    kn('kopf', 1, 0, 0, 0.5, [
      (0, 0, 0, 0, 0, 0.07, 0.05, haut),
      (0, 0, 0.14, 0, 0, 0.2, 0.1, haut),
      (0, -0.01, 0.2, 0, -0.02, 0.23, 0.098, haar),
      (-0.035, 0.092, 0.175, -0.035, 0.092, 0.18, 0.012, auge),
      (0.035, 0.092, 0.175, 0.035, 0.092, 0.18, 0.012, auge),
    ]),
    kn('oberarmL', 1, -0.215, 0, 0.42, [(0, 0, 0, 0, 0, -0.27, 0.055, jacke)]),
    kn('unterarmL', 3, 0, 0, -0.28, [(0, 0, 0, 0, 0, -0.23, 0.05, jacke), (0, 0, -0.26, 0, 0.01, -0.3, 0.042, haut)]),
    kn('oberarmR', 1, 0.215, 0, 0.42, [(0, 0, 0, 0, 0, -0.27, 0.055, jacke)]),
    kn('unterarmR', 5, 0, 0, -0.28, [(0, 0, 0, 0, 0, -0.23, 0.05, jacke), (0, 0, -0.26, 0, 0.01, -0.3, 0.042, haut)]),
    kn('oberschenkelL', 0, -0.09, 0, -0.03, [(0, 0, 0, 0, 0, -0.42, 0.075, hose)]),
    kn('unterschenkelL', 7, 0, 0, -0.42, [(0, 0, 0, 0, 0, -0.4, 0.065, hose), (0, 0.0, -0.44, 0, 0.09, -0.45, 0.042, schuh)]),
    kn('oberschenkelR', 0, 0.09, 0, -0.03, [(0, 0, 0, 0, 0, -0.42, 0.075, hose)]),
    kn('unterschenkelR', 9, 0, 0, -0.42, [(0, 0, 0, 0, 0, -0.4, 0.065, hose), (0, 0.0, -0.44, 0, 0.09, -0.45, 0.042, schuh)]),
  ]);
}

/// Gangzyklus, Phase 0..1 (Figur blickt nach +y).
Pose gehen(Skelett sk, double phase) {
  final p = Pose(sk.knochen.length);
  final w = 2 * math.pi * phase;
  final schwung = math.sin(w);
  p.beugen[sk.index('oberschenkelL')] = 0.45 * schwung;
  p.beugen[sk.index('oberschenkelR')] = -0.45 * schwung;
  p.beugen[sk.index('unterschenkelL')] = -(0.05 + 0.65 * math.max(0.0, -math.sin(w + 0.6)));
  p.beugen[sk.index('unterschenkelR')] = -(0.05 + 0.65 * math.max(0.0, math.sin(w + 0.6)));
  p.beugen[sk.index('oberarmL')] = -0.35 * schwung;
  p.beugen[sk.index('oberarmR')] = 0.35 * schwung;
  p.beugen[sk.index('unterarmL')] = 0.25 + 0.2 * math.max(0.0, -schwung);
  p.beugen[sk.index('unterarmR')] = 0.25 + 0.2 * math.max(0.0, schwung);
  p.seitlich[sk.index('oberarmL')] = -0.08;
  p.seitlich[sk.index('oberarmR')] = 0.08;
  p.beugen[sk.index('rumpf')] = 0.05;
  p.wurzelZ = -0.025 * (1 - math.cos(2 * w)) / 2;
  return p;
}

void main(List<String> args) {
  final aus = Directory(args.isEmpty ? 'k0_figur' : args[0])..createSync(recursive: true);
  final sk = baueSkelett();
  final radien = <int, double>{for (var b = 1; b < sk.knochen.length; b++) b: 0.055};
  radien[sk.index('kopf')] = 0.05;
  final zeilen = <List<IsoBild>>[];
  for (final weg in Gelenkweg.values) {
    final bilder = <IsoBild>[];
    var ms = 0.0, zu = 0;
    final befunde = <String>[];
    for (var i = 0; i < 8; i++) {
      final pose = gehen(sk, i / 8);
      sk.stelle(pose, 1, 1, 0);
      final sw = Stopwatch()..start();
      final a = baueFigur(sk, s, weg, gelenkRadius: weg == Gelenkweg.rueck ? radien : const {});
      ms += sw.elapsedMicroseconds / 1000;
      final b = pruefeLuecken(a, sk);
      if (b.geschlossen) zu++;
      befunde.add('Bild $i: $b');
      final p = Platzierung(a.koerper, a.x, a.y, a.z);
      bilder.add(backe(p, const IsoAnsicht(skala: 4), schatten: Schattenkarte.bau([p], const Backlicht().richtung, texel: 0.005)));
    }
    stdout.writeln('GELENKWEG ${weg.name} · Aufbau ${(ms / 8).toStringAsFixed(2)} ms/Bild · geschlossen $zu von 8');
    for (final b in befunde) {
      stdout.writeln('  $b');
    }
    zeilen.add(bilder);
  }
  // Streifen: Zeile je Gelenkweg
  final sk4 = zeilen.first.first.skala;
  var bw = 0, bh = 0;
  for (final z in zeilen) {
    for (final b in z) {
      bw = math.max(bw, b.breite);
      bh = math.max(bh, b.hoehe);
    }
  }
  final w = bw * 8, h = bh * zeilen.length;
  final px = Uint8List(w * h * 4);
  for (var i = 0; i < px.length; i += 4) {
    px[i] = 20;
    px[i + 1] = 21;
    px[i + 2] = 28;
    px[i + 3] = 255;
  }
  for (var r = 0; r < zeilen.length; r++) {
    for (var c = 0; c < zeilen[r].length; c++) {
      final b = zeilen[r][c];
      final ox = c * bw + (bw - b.breite) ~/ 2, oy = r * bh + (bh - b.hoehe);
      for (var y = 0; y < b.hoehe; y++) {
        for (var x = 0; x < b.breite; x++) {
          final q = (y * b.breite + x) * 4;
          if (b.rgba[q + 3] == 0) continue;
          final z = ((oy + y) * w + ox + x) * 4;
          px[z] = b.rgba[q];
          px[z + 1] = b.rgba[q + 1];
          px[z + 2] = b.rgba[q + 2];
        }
      }
    }
  }
  File('${aus.path}/figur_gehen.png').writeAsBytesSync(encodePngRgba(w, h, px, zlib: zlib.encode));
  stdout.writeln('BILDSTREIFEN ${aus.path}/figur_gehen.png · Skala $sk4');
}

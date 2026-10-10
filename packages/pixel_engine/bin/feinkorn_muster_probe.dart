// FEINKORN · Materialprobe (K1-MATERIALMACHER): je Material eine Wand (1 × 1 m, Südseite sichtbar), eine
// Bodenfläche (1 × 1 m) und eine Kante, in 2,5 cm, 1 cm und 0,5 cm Blockgröße, gebacken mit Licht; dazu ein
// 4×-Ausschnitt. Ohne Spielinhalt.
// Aufruf: dart run bin/feinkorn_muster_probe.dart <ausgabe.png> [materialKennungen, z. B. 1,2]
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:pixel_engine/feinkorn.dart';
import 'package:pixel_engine/pixel_engine.dart' show encodePngRgba;

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Aufruf: dart run bin/feinkorn_muster_probe.dart <ausgabe.png> [kennungen]');
    exit(2);
  }
  registriereAlleMuster();
  final ids = args.length > 1 ? args[1].split(',').map(int.parse).toList() : [for (final m in kMaterialien) m.id];
  const ansicht = IsoAnsicht(skala: 3);
  final zellen = <IsoBild>[];
  for (final id in ids) {
    for (final s in const [0.025, 0.01, 0.005]) {
      final n = (1.0 / s).round(), d = (0.1 / s).round();
      final k = Blockkoerper(blockgroesse: s, breite: n, tiefe: n, hoehe: n);
      final w = k.eintrag(Farbeintrag.material(id));
      k.fuelle(0, 0, 0, n, n, d, w); // Boden
      k.fuelle(0, 0, 0, n, d, n, w); // Wand hinten (Südseite sichtbar)
      k.fuelle(0, 0, 0, d, n, n ~/ 2, w); // halbe Wand links (Ostseite sichtbar)
      final p = Platzierung(k, 0, 0, 0);
      zellen.add(backe(p, ansicht, schatten: Schattenkarte.bau([p], const Backlicht().richtung, texel: s / 2)));
    }
    stdout.writeln('PROBE ${materialVon(id)!.name} · Muster ${kMuster.containsKey(id) ? 'eingetragen' : 'Standard'}');
  }
  var bw = 0, bh = 0;
  for (final b in zellen) {
    bw = math.max(bw, b.breite);
    bh = math.max(bh, b.hoehe);
  }
  // Spalten: 3 Blockgrößen + 4×-Ausschnitt der 1-cm-Fassung
  const zoom = 4, aus = 120;
  final w = bw * 3 + aus * zoom, h = math.max(bh, aus * zoom) * ids.length;
  final zh = math.max(bh, aus * zoom);
  final px = Uint8List(w * h * 4);
  for (var i = 0; i < px.length; i += 4) {
    px[i] = 12;
    px[i + 1] = 13;
    px[i + 2] = 18;
    px[i + 3] = 255;
  }
  void setze(int x, int y, Uint8List q, int o) {
    if (x < 0 || y < 0 || x >= w || y >= h) return;
    final z = (y * w + x) * 4;
    px[z] = q[o];
    px[z + 1] = q[o + 1];
    px[z + 2] = q[o + 2];
  }

  for (var r = 0; r < ids.length; r++) {
    for (var c = 0; c < 3; c++) {
      final b = zellen[r * 3 + c];
      for (var y = 0; y < b.hoehe; y++) {
        for (var x = 0; x < b.breite; x++) {
          final o = (y * b.breite + x) * 4;
          if (b.rgba[o + 3] != 0) setze(c * bw + x, r * zh + y, b.rgba, o);
        }
      }
    }
    final b = zellen[r * 3 + 1];
    final x0 = b.breite ~/ 2 - aus ~/ 2, y0 = b.hoehe ~/ 2 - aus ~/ 2;
    for (var y = 0; y < aus * zoom; y++) {
      for (var x = 0; x < aus * zoom; x++) {
        final sx = x0 + x ~/ zoom, sy = y0 + y ~/ zoom;
        if (sx < 0 || sy < 0 || sx >= b.breite || sy >= b.hoehe) continue;
        final o = (sy * b.breite + sx) * 4;
        if (b.rgba[o + 3] != 0) setze(3 * bw + x, r * zh + y, b.rgba, o);
      }
    }
  }
  File(args[0]).writeAsBytesSync(encodePngRgba(w, h, px, zlib: zlib.encode));
  stdout.writeln('MATERIALPROBE ${args[0]} · ${ids.length} Materialien');
}

// FEINKORN K0 · Prototyp Physik: ein Messing-Kerzenständer mit drei Wachskerzen kippt von einer Anrichte
// (0,9 m), schlägt auf, Wachs krümelt ab, Staub steigt auf, Partikel kommen zur Ruhe und lagern sich ab.
// Misst Schrittzeit, Determinismus (zwei Läufe, drei Bildraten) und Fallzeit aus 1 m.
// Aufruf: dart run bin/feinkorn_k0_physik.dart <ausgabeOrdner>
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:pixel_engine/feinkorn.dart';
import 'package:pixel_engine/pixel_engine.dart' show encodePngRgba;

const s = 0.005; // Indiz-Blockgröße 0,5 cm

Blockkoerper kerzenstaender() {
  final nx = (0.18 / s).round(), ny = (0.08 / s).round(), nz = (0.46 / s).round();
  final k = Blockkoerper(blockgroesse: s, breite: nx, tiefe: ny, hoehe: nz);
  final messing = k.eintrag(Farbeintrag.material(5));
  final wachs = k.eintrag(Farbeintrag.material(7));
  final docht = k.eintrag(const Farbeintrag(12, 0x1E1C1B));
  final cx = nx / 2, cy = ny / 2;
  void zylinder(double mx, double my, int z0, int z1, double r, int w) {
    for (var z = z0; z < z1; z++) {
      for (var y = 0; y < ny; y++) {
        for (var x = 0; x < nx; x++) {
          final dx = x + 0.5 - mx, dy = y + 0.5 - my;
          if (dx * dx + dy * dy <= r * r) k.setze(x, y, z, w);
        }
      }
    }
  }

  zylinder(cx, cy, 0, 2, 7.5, messing); // Fuß
  zylinder(cx, cy, 2, 4, 5.5, messing);
  zylinder(cx, cy, 4, 52, 2.0, messing); // Schaft 24 cm
  zylinder(cx, cy, 30, 33, 3.2, messing); // Knauf
  k.fuelle((cx - 15).round(), (cy - 1).round(), 52, (cx + 15).round(), (cy + 1).round(), 54, messing); // Querarm
  for (final ax in [cx - 14, cx, cx + 14]) {
    zylinder(ax, cy, 54, 57, 3.0, messing); // Tülle
    zylinder(ax, cy, 57, 89, 2.2, wachs); // Kerze 16 cm
    zylinder(ax, cy, 89, 91, 0.6, docht);
  }
  return k;
}

class Lauf {
  Lauf(int rate, int saat) : welt = Physikwelt(rate: rate, saat: saat) {
    welt.kaesten.add(const Kasten(0, 0, 0, 0.6, 0.5, 0.9)); // Anrichte
    kerze = Starrkoerper(kerzenstaender(), x: 0, y: 0, z: 0);
    // Fuß auf der Anrichte an der Kante, Schwerpunkt darüber
    kerze.px = 0.5;
    kerze.py = 0.25;
    kerze.pz = 0.9 + kerze.sz + 0.001;
    kerze.wy = 2.2; // Stoß: kippt nach +x über die Kante
    kerze.vx = 0.35;
    welt.koerper.add(kerze);
    welt.aufprall = (k, x, y, z, impuls) {
      if (impuls < 0.4) return;
      stoesse.add('${(welt.schritte / welt.rate).toStringAsFixed(3)} s · Impuls ${impuls.toStringAsFixed(2)} · z ${z.toStringAsFixed(2)}');
      _bruch(k, x, y, z, impuls);
    };
  }

  final Physikwelt welt;
  late final Starrkoerper kerze;
  final stoesse = <String>[];
  var abgeloest = 0;

  /// Wachs krümelt (7.4): Wachsblöcke im Umkreis der Aufschlagstelle lösen sich als Krümel; Staub steigt auf.
  void _bruch(Starrkoerper k, double x, double y, double z, double impuls) {
    final m = Float64List(9);
    k.matrix(m);
    final dx = x - k.px, dy = y - k.py, dz = z - k.pz;
    // Weltpunkt → Körperblock: Rᵀ · d + Schwerpunkt
    final lx = m[0] * dx + m[3] * dy + m[6] * dz + k.sx, ly = m[1] * dx + m[4] * dy + m[7] * dz + k.sy, lz = m[2] * dx + m[5] * dy + m[8] * dz + k.sz;
    final r = math.min(0.06, 0.02 + 0.02 * impuls);
    final kb = k.koerper;
    final z0 = ((lz - r) / s).floor(), z1 = ((lz + r) / s).ceil();
    final y0 = ((ly - r) / s).floor(), y1 = ((ly + r) / s).ceil();
    final x0 = ((lx - r) / s).floor(), x1 = ((lx + r) / s).ceil();
    for (var bz = z0; bz <= z1; bz++) {
      for (var by = y0; by <= y1; by++) {
        for (var bx = x0; bx <= x1; bx++) {
          final w = kb.wert(bx, by, bz);
          if (w == 0 || kb.tafel[w]!.material != 7) continue;
          final ex = (bx + 0.5) * s - lx, ey = (by + 0.5) * s - ly, ez = (bz + 0.5) * s - lz;
          if (ex * ex + ey * ey + ez * ez > r * r) continue;
          kb.setze(bx, by, bz, 0);
          abgeloest++;
          // nur jeder dritte Block wird ein sichtbarer Krümel (Krümel bestehen aus mehreren Blöcken)
          if (abgeloest % 3 != 0) continue;
          // Weltlage des Blocks: Lage + R · (Block − Schwerpunkt)
          final qx = (bx + 0.5) * s - k.sx, qy = (by + 0.5) * s - k.sy, qz = (bz + 0.5) * s - k.sz;
          final wx = k.px + m[0] * qx + m[1] * qy + m[2] * qz, wy = k.py + m[3] * qx + m[4] * qy + m[5] * qz;
          final wz = math.max(0.004, k.pz + m[6] * qx + m[7] * qy + m[8] * qz);
          final zf = welt.zufall;
          welt.teilchen.neu(wx, wy, wz, k.vx * 0.3 + zf.zwischen() * 0.8, k.vy * 0.3 + zf.zwischen() * 0.8, 0.6 + zf.naechste() * 1.4,
              s * (1 + zf.naechste()), 0xC23B2E, 7);
        }
      }
    }
    for (var i = 0; i < 40; i++) {
      final z = welt.zufall;
      welt.teilchen.neu(x + z.zwischen() * 0.05, y + z.zwischen() * 0.05, 0.005, z.zwischen() * 0.3, z.zwischen() * 0.3, 0.3 + z.naechste() * 0.5,
          s * 0.8, 0x8F8678, 13);
    }
  }
}

void main(List<String> args) {
  final aus = Directory(args.isEmpty ? 'k0_physik' : args[0])..createSync(recursive: true);
  // 1. Lauf mit Bildfolge und Zeitmessung
  final lauf = Lauf(120, 7);
  final sw = Stopwatch();
  final bilder = <IsoBild>[];
  final ansicht = const IsoAnsicht(skala: 3);
  var schrittMax = 0;
  for (var bild = 0; bild < 36; bild++) {
    sw.start();
    final t0 = sw.elapsedMicroseconds;
    lauf.welt.vor(1 / 12);
    final d = sw.elapsedMicroseconds - t0;
    sw.stop();
    schrittMax = math.max(schrittMax, d);
    if (bild % 3 == 0) bilder.add(_bildVon(lauf, ansicht));
  }
  final schritte = lauf.welt.schritte;
  stdout.writeln('PHYSIK · ${lauf.welt.rate} Hz · Schritte $schritte · Rechenzeit ${(sw.elapsedMicroseconds / 1000).toStringAsFixed(1)} ms '
      '(${(sw.elapsedMicroseconds / schritte).toStringAsFixed(1)} µs/Schritt, Spitze je Bild ${(schrittMax / 1000).toStringAsFixed(2)} ms) · '
      'Kontaktpunkte ${lauf.kerze.punkte.length ~/ 3} · abgelöste Wachsblöcke ${lauf.abgeloest} · Partikel fliegend ${lauf.welt.teilchen.fliegend}, abgelagert ${lauf.welt.teilchen.abgelagert}');
  for (final st in lauf.stoesse.take(6)) {
    stdout.writeln('  STOSS $st');
  }
  final endlage = 'Kerzenständer Schwerpunkt (${lauf.kerze.px.toStringAsFixed(3)}, ${lauf.kerze.py.toStringAsFixed(3)}, ${lauf.kerze.pz.toStringAsFixed(3)}) · schläft ${lauf.kerze.schlaeft}';
  stdout.writeln('ENDLAGE $endlage');
  // 2. Determinismus: gleicher Startwert, drei Bildraten (feste Physikrate) → gleiche Prüfsumme
  final summen = <int>[];
  for (final fps in [30, 60, 120]) {
    final l = Lauf(120, 7);
    for (var i = 0; i < 3 * fps; i++) {
      l.welt.vor(1 / fps);
    }
    summen.add(l.welt.pruefsumme());
  }
  final l2 = Lauf(120, 7);
  for (var i = 0; i < 36; i++) {
    l2.welt.vor(1 / 12);
  }
  stdout.writeln('DETERMINISMUS · Bildraten 30/60/120: ${summen.map((v) => v.toRadixString(16)).join(' / ')} · '
      '${summen.toSet().length == 1 ? 'GLEICH' : 'VERSCHIEDEN'} · Wiederholung ${l2.welt.pruefsumme() == lauf.welt.pruefsumme() ? 'GLEICH' : 'VERSCHIEDEN'}');
  // 3. Fallzeit aus 1 m (Messingwürfel 4 cm): bis zum ersten Bodenkontakt
  final fall = Physikwelt(rate: 120);
  final wuerfel = Blockkoerper(blockgroesse: 0.01, breite: 4, tiefe: 4, hoehe: 4);
  wuerfel.fuelle(0, 0, 0, 4, 4, 4, wuerfel.eintrag(Farbeintrag.material(5)));
  final wk = Starrkoerper(wuerfel, x: 0, y: 0, z: 0)..pz = 1.0 + 0.02;
  fall.koerper.add(wk);
  var t = 0.0;
  while (wk.pz - 0.02 > 0 && t < 2) {
    fall.schritt();
    t += fall.dt;
  }
  final soll = math.sqrt(2 * 1.0 / Physikwelt.schwere);
  stdout.writeln('FALLZEIT 1 m · gemessen ${t.toStringAsFixed(4)} s · Formel ${soll.toStringAsFixed(4)} s · Abweichung ${((t - soll).abs() / soll * 100).toStringAsFixed(2)} %');
  // Bildstreifen
  _streifen(bilder, '${aus.path}/kerzenstaender_fall.png');
}

IsoBild _bildVon(Lauf lauf, IsoAnsicht ansicht) {
  final k = lauf.kerze, kb = k.koerper;
  final m = Float64List(9);
  k.matrix(m);
  final xs = <double>[], ys = <double>[], zs = <double>[], gs = <double>[], fs = <int>[];
  kb.jederBlock((x, y, z, w) {
    final frei = kb.wert(x + 1, y, z) == 0 || kb.wert(x - 1, y, z) == 0 || kb.wert(x, y + 1, z) == 0 || kb.wert(x, y - 1, z) == 0 ||
        kb.wert(x, y, z + 1) == 0 || kb.wert(x, y, z - 1) == 0;
    if (!frei) return;
    final lx = (x + 0.5) * s - k.sx, ly = (y + 0.5) * s - k.sy, lz = (z + 0.5) * s - k.sz;
    xs.add(k.px + m[0] * lx + m[1] * ly + m[2] * lz);
    ys.add(k.py + m[3] * lx + m[4] * ly + m[5] * lz);
    zs.add(k.pz + m[6] * lx + m[7] * ly + m[8] * lz);
    gs.add(s * 1.15);
    fs.add(kb.tafel[w]!.farbe);
  });
  // Anrichte (grob) und Boden als Würfel, Partikel
  for (var x = 0.0; x < 0.6; x += 0.05) {
    for (var y = 0.0; y < 0.5; y += 0.05) {
      xs.add(x + 0.025);
      ys.add(y + 0.025);
      zs.add(0.875);
      gs.add(0.05);
      fs.add(0x6B4A2E);
    }
  }
  for (var x = -0.2; x < 1.4; x += 0.05) {
    for (var y = -0.2; y < 1.0; y += 0.05) {
      xs.add(x + 0.025);
      ys.add(y + 0.025);
      zs.add(-0.025);
      gs.add(0.05);
      fs.add(((x * 20).round() + (y * 20).round()).isEven ? 0x9C8A6E : 0x948266);
    }
  }
  final t = lauf.welt.teilchen;
  for (var i = 0; i < t.kapazitaet; i++) {
    if (t.zustand[i] == 0) continue;
    xs.add(t.x[i]);
    ys.add(t.y[i]);
    zs.add(t.z[i] + t.groesse[i] / 2);
    gs.add(t.groesse[i]);
    fs.add(t.farbe[i]);
  }
  final n = xs.length;
  return backeWolke(Float64List.fromList(xs), Float64List.fromList(ys), Float64List.fromList(zs), Float64List.fromList(gs),
      Int32List.fromList(fs), n, ansicht);
}

void _streifen(List<IsoBild> bilder, String pfad) {
  // gemeinsamer Ausschnitt: Vereinigung der Bildgrenzen
  var l = double.infinity, o = double.infinity, r = -double.infinity, u = -double.infinity;
  final sk = bilder.first.skala;
  for (final b in bilder) {
    l = math.min(l, b.links);
    o = math.min(o, b.oben);
    r = math.max(r, b.links + b.breite / sk);
    u = math.max(u, b.oben + b.hoehe / sk);
  }
  final bw = ((r - l) * sk).ceil(), bh = ((u - o) * sk).ceil();
  final spalten = 4, zeilen = (bilder.length + spalten - 1) ~/ spalten;
  final w = bw * spalten, h = bh * zeilen;
  final px = Uint8List(w * h * 4);
  for (var i = 0; i < px.length; i += 4) {
    px[i] = 12;
    px[i + 1] = 13;
    px[i + 2] = 18;
    px[i + 3] = 255;
  }
  for (var n = 0; n < bilder.length; n++) {
    final b = bilder[n];
    final ox = (n % spalten) * bw + ((b.links - l) * sk).round(), oy = (n ~/ spalten) * bh + ((b.oben - o) * sk).round();
    for (var y = 0; y < b.hoehe; y++) {
      for (var x = 0; x < b.breite; x++) {
        final q = (y * b.breite + x) * 4;
        if (b.rgba[q + 3] == 0) continue;
        final zx = ox + x, zy = oy + y;
        if (zx < 0 || zy < 0 || zx >= w || zy >= h) continue;
        final z = (zy * w + zx) * 4;
        px[z] = b.rgba[q];
        px[z + 1] = b.rgba[q + 1];
        px[z + 2] = b.rgba[q + 2];
      }
    }
  }
  File(pfad).writeAsBytesSync(encodePngRgba(w, h, px, zlib: zlib.encode));
  stdout.writeln('BILDFOLGE $pfad · ${bilder.length} Bilder');
}

import 'dart:math' as math;

import '../daten/blockkoerper.dart';
import '../darstellung/iso_backen.dart';

/// Testraum für Prototypen und Prüfstand (K0): 10 × 10 × 4 m, ohne Spielinhalt.
/// Boden und zwei Wände aus Sandstein mit Kalkmörtelfugen (2,5 cm), ein Eichentisch (1 cm) und eine
/// Rohfigur aus Kapseln (1 cm). Alle Maße in Metern, Blöcke nach Körper.
class Testraum {
  Testraum({this.gebaeude = 0.025, this.ausstattung = 0.01});

  final double gebaeude, ausstattung;

  late final Platzierung boden = Platzierung(_boden(), 0, 0, -0.1);
  late final Platzierung wandNord = Platzierung(_wand(10, 0.4, 4), 0, -0.4, 0);
  late final Platzierung wandWest = Platzierung(_wand(0.4, 10, 4), -0.4, 0, 0);
  late final Platzierung tisch = Platzierung(_tisch(), 4, 4, 0);
  late final Platzierung figur = Platzierung(baueRohfigur(ausstattung), 6, 5.5, 0);

  List<Platzierung> get alle => [boden, wandNord, wandWest, tisch, figur];

  /// Bodenplatten 50 × 50 cm, Fugen 1 Block, 4 Blöcke dick.
  Blockkoerper _boden() {
    final s = gebaeude;
    final n = (10 / s).round(), d = (0.1 / s).round();
    final k = Blockkoerper(blockgroesse: s, breite: n, tiefe: n, hoehe: d);
    final stein = k.eintrag(Farbeintrag.material(1));
    final moertel = k.eintrag(Farbeintrag.material(2));
    k.fuelle(0, 0, 0, n, n, d, stein);
    final platte = (0.5 / s).round();
    for (var i = 0; i < n; i += platte) {
      k.fuelle(i, 0, d - 1, i + 1, n, d, moertel);
      k.fuelle(0, i, d - 1, n, i + 1, d, moertel);
    }
    // vertiefte Fugen: oberste Mörtelschicht entfernen
    for (var i = 0; i < n; i += platte) {
      for (var j = 0; j < n; j++) {
        k.setze(i, j, d - 1, 0);
        k.setze(j, i, d - 1, 0);
      }
    }
    return k;
  }

  /// Quadermauer: Steine 40 × 25 cm im Verband, Fugen 1 Block tief zurückgesetzt, Kantenabrieb an Ecken.
  Blockkoerper _wand(double bx, double by, double bz) {
    final s = gebaeude;
    final nx = (bx / s).round(), ny = (by / s).round(), nz = (bz / s).round();
    final k = Blockkoerper(blockgroesse: s, breite: nx, tiefe: ny, hoehe: nz);
    final stein = k.eintrag(Farbeintrag.material(1));
    final steinHell = k.eintrag(const Farbeintrag(1, 0xA8977A));
    final moertel = k.eintrag(Farbeintrag.material(2));
    k.fuelle(0, 0, 0, nx, ny, nz, moertel);
    final laenge = (0.4 / s).round(), lage = (0.25 / s).round();
    final langX = nx >= ny;
    final n = langX ? nx : ny;
    for (var z0 = 0; z0 < nz; z0 += lage) {
      final versatz = (z0 ~/ lage).isOdd ? laenge ~/ 2 : 0;
      for (var a0 = -versatz; a0 < n; a0 += laenge) {
        final a = math.max(0, a0), b = math.min(n, a0 + laenge - 1);
        final hell = blockHash(a0, z0, 7, 3) % 3 == 0;
        final w = hell ? steinHell : stein;
        // Stein: volle Dicke minus 1 Block an der Sichtseite für die Fuge rundum
        if (langX) {
          k.fuelle(a, 0, z0, b, ny, math.min(nz, z0 + lage - 1), w);
        } else {
          k.fuelle(0, a, z0, nx, b, math.min(nz, z0 + lage - 1), w);
        }
      }
    }
    // Fugen an der Sichtseite 1 Block zurücksetzen (Sichtseite: +y für Nordwand, +x für Westwand)
    for (var z = 0; z < nz; z++) {
      for (var a = 0; a < n; a++) {
        final x = langX ? a : nx - 1, y = langX ? ny - 1 : a;
        if (k.tafel[k.wert(x, y, z)]?.material == 2) k.setze(x, y, z, 0);
      }
    }
    return k;
  }

  /// Tisch 1,6 × 0,8 × 0,78 m aus Eiche: Platte mit Maserung, Zarge, vier Beine.
  Blockkoerper _tisch() {
    final s = ausstattung;
    final nx = (1.6 / s).round(), ny = (0.8 / s).round(), nz = (0.78 / s).round();
    final k = Blockkoerper(blockgroesse: s, breite: nx, tiefe: ny, hoehe: nz);
    final eiche = k.eintrag(Farbeintrag.material(3));
    final maser = k.eintrag(const Farbeintrag(3, 0x5A3D25));
    final platte = (0.05 / s).round();
    k.fuelle(0, 0, nz - platte, nx, ny, nz, eiche);
    // Maserung: dunkle Linien längs (x), leicht gewellt
    for (var j = 3; j < ny; j += 7) {
      for (var i = 0; i < nx; i++) {
        final jj = j + (math.sin(i * 0.08 + j) * 1.5).round();
        if (jj >= 0 && jj < ny) k.setze(i, jj, nz - 1, maser);
      }
    }
    final zarge = (0.08 / s).round(), dick = (0.03 / s).round(), rein = (0.03 / s).round();
    k.fuelle(rein, rein, nz - platte - zarge, nx - rein, rein + dick, nz - platte, eiche);
    k.fuelle(rein, ny - rein - dick, nz - platte - zarge, nx - rein, ny - rein, nz - platte, eiche);
    k.fuelle(rein, rein, nz - platte - zarge, rein + dick, ny - rein, nz - platte, eiche);
    k.fuelle(nx - rein - dick, rein, nz - platte - zarge, nx - rein, ny - rein, nz - platte, eiche);
    final bein = (0.07 / s).round();
    for (final (bx, by) in [(rein, rein), (nx - rein - bein, rein), (rein, ny - rein - bein), (nx - rein - bein, ny - rein - bein)]) {
      k.fuelle(bx, by, 0, bx + bein, by + bein, nz - platte, eiche);
    }
    return k;
  }
}

/// Rohfigur (1,75 m) aus Kapseln, ohne Skelett: Beine, Rumpf, Arme, Kopf; Stoff in drei Farben.
Blockkoerper baueRohfigur(double s) {
  final nx = (0.6 / s).round(), ny = (0.4 / s).round(), nz = (1.8 / s).round();
  final k = Blockkoerper(blockgroesse: s, breite: nx, tiefe: ny, hoehe: nz);
  final hose = k.eintrag(const Farbeintrag(8, 0x2B3A55));
  final jacke = k.eintrag(const Farbeintrag(8, 0xB8A48A));
  final haut = k.eintrag(const Farbeintrag(9, 0xC89A78));
  final haar = k.eintrag(const Farbeintrag(8, 0x2A211C));
  final schuh = k.eintrag(const Farbeintrag(9, 0x1E1A18));
  void kapsel(double ax, double ay, double az, double bx, double by, double bz, double r, int w) {
    final x0 = ((math.min(ax, bx) - r) / s).floor(), x1 = ((math.max(ax, bx) + r) / s).ceil();
    final y0 = ((math.min(ay, by) - r) / s).floor(), y1 = ((math.max(ay, by) + r) / s).ceil();
    final z0 = ((math.min(az, bz) - r) / s).floor(), z1 = ((math.max(az, bz) + r) / s).ceil();
    final dx = bx - ax, dy = by - ay, dz = bz - az, ll = dx * dx + dy * dy + dz * dz;
    for (var z = z0; z <= z1; z++) {
      for (var y = y0; y <= y1; y++) {
        for (var x = x0; x <= x1; x++) {
          final px = (x + 0.5) * s - ax, py = (y + 0.5) * s - ay, pz = (z + 0.5) * s - az;
          final t = ll == 0 ? 0.0 : ((px * dx + py * dy + pz * dz) / ll).clamp(0.0, 1.0);
          final qx = px - dx * t, qy = py - dy * t, qz = pz - dz * t;
          if (qx * qx + qy * qy + qz * qz <= r * r) k.setze(x, y, z, w);
        }
      }
    }
  }

  const mx = 0.3, my = 0.2;
  kapsel(mx - 0.09, my, 0.05, mx - 0.09, my, 0.85, 0.075, hose);
  kapsel(mx + 0.09, my, 0.05, mx + 0.09, my, 0.85, 0.075, hose);
  kapsel(mx - 0.09, my + 0.04, 0.03, mx - 0.09, my + 0.1, 0.03, 0.045, schuh);
  kapsel(mx + 0.09, my + 0.04, 0.03, mx + 0.09, my + 0.1, 0.03, 0.045, schuh);
  kapsel(mx, my, 0.9, mx, my, 1.38, 0.17, jacke);
  kapsel(mx - 0.24, my, 1.38, mx - 0.26, my + 0.02, 0.9, 0.055, jacke);
  kapsel(mx + 0.24, my, 1.38, mx + 0.26, my + 0.02, 0.9, 0.055, jacke);
  kapsel(mx - 0.26, my + 0.02, 0.86, mx - 0.26, my + 0.02, 0.84, 0.045, haut);
  kapsel(mx + 0.26, my + 0.02, 0.86, mx + 0.26, my + 0.02, 0.84, 0.045, haut);
  kapsel(mx, my, 1.42, mx, my, 1.5, 0.06, haut);
  kapsel(mx, my, 1.6, mx, my, 1.64, 0.11, haut);
  kapsel(mx, my - 0.02, 1.68, mx, my - 0.03, 1.7, 0.105, haar);
  return k;
}

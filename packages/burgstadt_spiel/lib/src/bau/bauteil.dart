import 'dart:math' as math;

import 'package:pixel_engine/pixel_engine.dart';

/// Eine Fassadenfläche, auf der Bauteile sitzen (Burgstadt HD): Grundlinie von (x0, z0) nach
/// (x1, z1) in Metern, Unterkante [y0], Oberkante [y1], Außennormale ([nx], [nz]) und Licht.
class Wandflaeche {
  const Wandflaeche({
    required this.x0,
    required this.z0,
    required this.x1,
    required this.z1,
    required this.y0,
    required this.y1,
    required this.nx,
    required this.nz,
    this.warm = 0,
    this.kalt = 0,
  });

  final double x0, z0, x1, z1, y0, y1, nx, nz, warm, kalt;

  double get laenge => math.sqrt((x1 - x0) * (x1 - x0) + (z1 - z0) * (z1 - z0));

  /// Weltpunkt (x, z) an der Stelle [u] Meter entlang der Grundlinie, [aussen] Meter vor der Fläche.
  (double, double) punkt(double u, [double aussen = 0]) {
    final l = laenge;
    final f = l == 0 ? 0.0 : u / l;
    return (x0 + (x1 - x0) * f + nx * aussen, z0 + (z1 - z0) * f + nz * aussen);
  }
}

/// Ort eines Bauteils: Fläche, Mittelpunkt entlang der Fläche [u], Unterkante [y], Maße, Texturen
/// und eine stabile Kennung für Varianten über [hashTeil].
class BauteilOrt {
  const BauteilOrt({
    required this.flaeche,
    required this.u,
    required this.y,
    required this.breite,
    required this.hoehe,
    required this.kennung,
    this.texturen = const {},
  });

  final Wandflaeche flaeche;
  final double u, y, breite, hoehe;
  final String kennung;

  /// Rollen → Texturindex (z. B. `glas`, `rahmen`, `laibung`, `sims`).
  final Map<String, int> texturen;

  int hash(int teil) => hashTeil(kennung, teil);
}

/// Ein Fassaden-Bauteil (Fenster, Laden, Gaube …): erzeugt Geometrie vor oder in der Fläche.
/// Vorsprünge unter 2,3 m höchstens 0,10 m, nie in Tür- oder Wegkacheln (Stilblatt §6).
abstract interface class Bauteil {
  String get name;

  void baue(MeshBuilder m, BauteilOrt o);
}

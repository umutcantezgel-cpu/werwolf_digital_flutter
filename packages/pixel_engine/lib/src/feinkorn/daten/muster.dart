/// Oberflächenmuster der Materialien (7.6: Farbe und Streuung, Rauheit): je Block und sichtbarer Seite ein
/// Helligkeitsfaktor und eine leichte Farbverschiebung. So trägt jeder Block sein Material sichtbar –
/// Maserung in Eiche, Körnung und Lagen im Sandstein, Glanz auf Messing – ohne Bilddateien.
///
/// Regeln für Musterfunktionen (Materialmacher):
/// - rein und deterministisch: nur aus [MusterOrt] (keine globalen Zustände, kein dart:math Random);
/// - Merkmale in METERN ausdrücken (über [MusterOrt.s] umrechnen), damit sie bei jeder Blockgröße
///   gleich groß wirken (2,5 cm, 1 cm, 0,5 cm);
/// - Helligkeit in 0,6 … 1,4, Farbverschiebung je Kanal in −24 … +24;
/// - kein Rauschteppich: Variation in Strukturen (Lagen, Fasern, Flecken), Einzelblock-Streuung ≤ Material.streuung.
library;

import 'material.dart';

/// Sichtbare Seite eines Blocks in der Iso-Ansicht.
enum Seite { oben, sued, ost }

/// Ort eines Blocks für die Musterfunktion: Blockkoordinate im Körper ([x], [y], [z]), Blockgröße [s] in
/// Metern, Weltlage der Blockecke ([wx], [wy], [wz]) in Metern, [seite] und ein Blockhash [hash] (0..65535).
class MusterOrt {
  MusterOrt();
  int x = 0, y = 0, z = 0, hash = 0;
  double s = 0.01, wx = 0, wy = 0, wz = 0;
  Seite seite = Seite.oben;

  /// Hash 0..1 als Kommazahl.
  double get zufall => hash / 65535;
}

/// Ergebnis einer Musterfunktion; wird wiederverwendet (keine Erzeugung je Block).
class MusterWert {
  double hell = 1;
  int dr = 0, dg = 0, db = 0;

  void setze(double h, [int r = 0, int g = 0, int b = 0]) {
    hell = h;
    dr = r;
    dg = g;
    db = b;
  }
}

/// Musterfunktion: füllt [aus] für [ort] und Material [m].
typedef Muster = void Function(MusterOrt ort, Material m, MusterWert aus);

/// Standardmuster: Einzelblock-Streuung nach Material (Startwert aus K0).
void standardMuster(MusterOrt ort, Material m, MusterWert aus) => aus.setze(1 + m.streuung * (ort.zufall - 0.5));

/// Register der Muster nach Materialkennung (gemeinsamer Wert; Einträge setzt der Orchestrator).
final Map<int, Muster> kMuster = {};

/// Muster für Material [id] (Standard, wenn keins eingetragen ist).
Muster musterVon(int id) => kMuster[id] ?? standardMuster;

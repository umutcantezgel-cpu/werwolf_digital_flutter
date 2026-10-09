import 'dart:math' as math;

import 'package:pixel_engine/pixel_engine.dart';

/// Hilfen der Banding-Messung v2 (HZ-02, REP-02) für bin/banding.dart: Prüfwand, Profil, Kennzahlen.
/// Eigene Datei; die gemeinsame bin/mess/hilfen.dart (REP-01) bleibt unberührt.

/// Handylicht beim Einschalten (erkundung.dart:404: `flash = licht ? 0.9 : 0.0`).
const handyLicht = 0.9;

/// Kamerahöhe wie im Spiel (erkundung.dart:397–403).
const kamHoehe = 1.62;

/// Zeilen um die Bildmitte, über die Modus und Luma je Spalte gebildet werden (Dither mittelt sich heraus).
const pruefZeilen = 16;

/// Grundfarben der Prüfwand (Auftrag REP-02).
final List<({String name, int index})> pruefFarben = [
  (name: 'stein', index: Ramp.at(Ramp.stone, 4)),
  (name: 'putz-ocker', index: Ramp.at(Ramp.amber, 4)),
  (name: 'holz', index: Ramp.at(Ramp.wood, 4)),
];

/// Luma (0..255) einer Palettenfarbe nach Rec. 709 (0,2126 R + 0,7152 G + 0,0722 B).
double lumaVon(int index) => 0.2126 * paletteR(index) + 0.7152 * paletteG(index) + 0.0722 * paletteB(index);

/// Dezimalzahl mit Komma und [stellen] Nachkommastellen.
String dez(double v, [int stellen = 2]) => v.toStringAsFixed(stellen).replaceAll('.', ',');

/// Rendert die Prüfwand in der Farbe [farbe] in einen Puffer von [bw] × [bh].
/// Wand: 6 m breit, 0 bis 3 m hoch, bei z = 2 m. Kamera (0; 1,62; 0) blickt senkrecht entlang +z,
/// also 2,0 m auf dem Mittelstrahl. Die Wand läuft von x = 3 nach x = −3, damit ihre Vorderseite zur
/// Kamera zeigt; das Rückseiten-Culling (renderer.dart:325–328) verwirft sonst alle Dreiecke.
/// Vertex-Licht warm 0 / kalt 0,05 an allen Ecken. Nebel wie innen (spiel.dart:294–296), Handylicht [handyLicht].
PixelBuffer rendrePruefwand(int farbe, int bw, int bh) {
  final wand = (MeshBuilder()..wall(3, 2, -3, 2, 0, 3, 0, warm: 0, cold: 0.05)).build();
  final fb = PixelBuffer(bw, bh)..clear(Pal.black);
  final r = Renderer(fb, LightTable.night(), [IndexedTexture.solid(farbe)])
    ..fogStart = 3
    ..fogEnd = 20
    ..groundFog = 0
    ..flashStrength = handyLicht;
  r.camera
    ..x = 0
    ..y = kamHoehe
    ..z = 0
    ..yaw = math.pi / 2
    ..pitch = 0;
  r.begin();
  r.drawMesh(wand);
  return fb;
}

/// Spalte des Profils: Bildspalte [x], Modus (häufigster Palettenindex über die Zeilen) und Luma-Mittel.
typedef PruefSpalte = ({int x, int modus, double luma});

/// Profil von der Bildmitte bis zum rechten Rand. Je Spalte Modus und Luma-Mittel über [pruefZeilen]
/// Zeilen um die Bildmitte (Zeilen mitte−8 … mitte+7). Bei Gleichstand gewinnt der kleinere Index.
/// Setzt eine Bildhöhe von mindestens [pruefZeilen] voraus.
List<PruefSpalte> messeProfil(PixelBuffer fb) {
  final bw = fb.width, mitte = fb.height ~/ 2, cx = bw ~/ 2;
  final oben = mitte - pruefZeilen ~/ 2;
  final zaehl = List<int>.filled(256, 0);
  final profil = <PruefSpalte>[];
  for (var x = cx; x < bw; x++) {
    zaehl.fillRange(0, 256, 0);
    var summe = 0.0;
    for (var y = oben; y < oben + pruefZeilen; y++) {
      final c = fb.color[y * bw + x];
      zaehl[c]++;
      summe += lumaVon(c);
    }
    var modus = 0;
    for (var i = 1; i < 256; i++) {
      if (zaehl[i] > zaehl[modus]) modus = i;
    }
    profil.add((x: x, modus: modus, luma: summe / pruefZeilen));
  }
  return profil;
}

/// Kennzahlen eines Profils.
class PruefWerte {
  const PruefWerte({
    required this.stufen,
    required this.groesterSprung,
    required this.lumaSprung,
    required this.sprungUeber1,
  });

  /// Zahl verschiedener Modus-Indizes im Profil.
  final int stufen;

  /// Größte Differenz von `stufeVon` zwischen benachbarten Modus-Indizes derselben Rampe.
  final int groesterSprung;

  /// Größte Differenz benachbarter Luma-Mittel.
  final double lumaSprung;

  /// Anzahl benachbarter Modus-Paare mit `stufeVon`-Differenz > 1 (alle Rampen).
  final int sprungUeber1;
}

/// Kennzahlen eines Profils nach Auftrag REP-02: [PruefWerte.groesterSprung] nur über Nachbarpaare
/// derselben Rampe; [PruefWerte.sprungUeber1] über alle Nachbarpaare mit `stufeVon`-Differenz > 1 (ohne
/// Rampenbedingung); [PruefWerte.lumaSprung] über alle Nachbarpaare.
PruefWerte bewertePruefprofil(List<PruefSpalte> profil) {
  final modi = profil.map((s) => s.modus).toSet();
  var groesster = 0, ueber1 = 0;
  var lumaSprung = 0.0;
  for (var j = 0; j + 1 < profil.length; j++) {
    final a = profil[j], b = profil[j + 1];
    lumaSprung = math.max(lumaSprung, (b.luma - a.luma).abs());
    final ds = (stufeVon(b.modus) - stufeVon(a.modus)).abs();
    if (ds > 1) ueber1++;
    if (rampeVon(a.modus) == rampeVon(b.modus)) groesster = math.max(groesster, ds);
  }
  return PruefWerte(
    stufen: modi.length,
    groesterSprung: groesster,
    lumaSprung: lumaSprung,
    sprungUeber1: ueber1,
  );
}

/// CSV je Farbe: Kopf `x;modus;stufe;luma`, eine Zeile je Bildspalte.
String profilCsv(List<PruefSpalte> profil) {
  final b = StringBuffer('x;modus;stufe;luma\n');
  for (final s in profil) {
    b.writeln('${s.x};${s.modus};${stufeVon(s.modus)};${dez(s.luma)}');
  }
  return b.toString();
}

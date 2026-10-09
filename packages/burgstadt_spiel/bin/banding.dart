import 'dart:io';
import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';

import 'mess/banding_hilfen.dart';

/// Banding-Messung v2 (HZ-02, REP-02): wie fein das Licht auf einer glatten Fläche abgestuft ist,
/// getrennt von der Textur. Standard ist eine eigene Prüfwand (6 × 3 m, Kamera 2,0 m davor auf 1,62 m,
/// Vertex-Licht warm 0 / kalt 0,05, eine Textur je Grundfarbe), mit Handylicht und Nebel wie innen.
///
/// `dart run bin/banding.dart [--welt BxH] [--csv ordner] [--png ordner]`
///   Standard Welt 320x180. `--csv` schreibt je Farbe `<farbe>.csv`, `--png` je Farbe `<farbe>.png`.
/// `dart run bin/banding.dart --spielwand [breite höhe] [--qualitaet sparsam|mittel|hoch] [--csv datei] [--png datei]`
///   Bisherige Messung an einer Spielwand (Standard 1280 720, Qualität mittel). `--csv` und `--png` sind dort Dateien.

const _nutzung = 'Aufruf: dart run bin/banding.dart [--welt BxH] [--csv ordner] [--png ordner]\n'
    '       dart run bin/banding.dart --spielwand [breite höhe] [--qualitaet sparsam|mittel|hoch] [--csv datei] [--png datei]';

/// Kopie aus bin/belegfotos.dart (dort unverändert): freie Sichtweite ab (x, z) in Blickrichtung [yaw].
double sichtweite(Bereich b, double x, double z, double yaw, {double max = 14}) {
  final dx = math.cos(yaw), dz = math.sin(yaw);
  for (var t = 0.1; t <= max; t += 0.1) {
    final kx = ((x + dx * t) / kKachel).floor(), kz = ((z + dz * t) / kKachel).floor();
    if (!b.begehbar(kx, kz)) return t - 0.1;
  }
  return max;
}

/// Wandstandort: Kamera (x, z), Blickrichtung [yaw] und der Bereich.
class Wandwahl {
  Wandwahl(this.bereich, this.x, this.z, this.yaw, this.abstand);
  final Bereich bereich;
  final double x, z, yaw;

  /// Abstand Kamera–Wand auf dem Mittelstrahl (m).
  final double abstand;
}

/// Prüft, ob der Mittelstrahl an einer glatten Wandkachel endet: ±1 m seitlich liegen weitere Wandkacheln
/// (lange Wand), und die Strahlen bis ±30° sind mindestens 1,8 m frei.
bool wandSenkrecht(Bereich b, double x, double z, double yaw, double s) {
  final dx = math.cos(yaw), dz = math.sin(yaw);
  int kachel(double v) => (v / kKachel).floor();
  final px = x + dx * (s + 0.1), pz = z + dz * (s + 0.1); // erste blockierte Stelle des Mittelstrahls
  if (b.art(kachel(px), kachel(pz)) != KachelArt.wand) return false;
  for (final o in const [-1.0, -0.5, 0.5, 1.0]) {
    if (b.art(kachel(px - dz * o), kachel(pz + dx * o)) != KachelArt.wand) return false;
  }
  for (final d in const [-math.pi / 6, math.pi / 6]) {
    if (sichtweite(b, x, z, yaw + d) < 1.8) return false;
  }
  return true;
}

/// Sucht in den Innenräumen mit Putzwand (`wandTextur` beginnt mit `putz`, also glatt) die Kamera, deren
/// Mittelstrahl 2,0 m vor einer Wand endet. Gewählt wird die kleinste Abweichung von 2,0 m; bei Gleichstand
/// gewinnt die erste Fundstelle in Reihenfolge der Bereichs-ID (Raster 0,25 m, Blick entlang der Achsen).
Wandwahl? waehleWand(Spiel spiel) {
  final ids = spiel.stadt.bereiche.keys.toList()..sort();
  Wandwahl? beste;
  var bestAbw = double.infinity;
  for (final id in ids) {
    final b = spiel.stadt.bereiche[id]!;
    if (!b.innen || !b.wandTextur.startsWith('putz')) continue;
    for (var ix = 0; ix < b.breite * 2; ix++) {
      for (var iz = 0; iz < b.tiefe * 2; iz++) {
        final x = ix * 0.25, z = iz * 0.25;
        if (!b.frei(x, z)) continue;
        for (var k = 0; k < 4; k++) {
          final yaw = k * math.pi / 2;
          final s = sichtweite(b, x, z, yaw);
          final abstand = s + 0.1; // erste blockierte Stelle = Wandfläche (sichtweite gibt den letzten freien Schritt)
          if (abstand < 1.8 || abstand > 2.5) continue;
          if (!wandSenkrecht(b, x, z, yaw, s)) continue;
          final abw = (abstand - 2.0).abs();
          if (abw < bestAbw) {
            bestAbw = abw;
            beste = Wandwahl(b, x, z, yaw, abstand);
          }
        }
      }
    }
  }
  return beste;
}

Never _abbruch(String meldung) {
  stderr.writeln('$meldung\n$_nutzung');
  exit(2);
}

void main(List<String> args) {
  final zahlen = <int>[];
  var qualitaet = Qualitaet.mittel, qualitaetGesetzt = false;
  String? csv, png, welt;
  var spielwand = false;
  for (var i = 0; i < args.length; i++) {
    final a = args[i];
    if (a == '--spielwand') {
      spielwand = true;
    } else if (a == '--qualitaet' || a == '--csv' || a == '--png' || a == '--welt') {
      if (i + 1 >= args.length) _abbruch('$a braucht einen Wert');
      final wert = args[++i];
      switch (a) {
        case '--csv':
          csv = wert;
        case '--png':
          png = wert;
        case '--welt':
          welt = wert;
        default:
          qualitaet = Qualitaet.values.asNameMap()[wert] ??
              _abbruch('unbekannte Qualität „$wert“ (sparsam, mittel, hoch)');
          qualitaetGesetzt = true;
      }
    } else {
      final n = int.tryParse(a);
      if (n == null || n <= 0) _abbruch('Größe muss eine positive ganze Zahl sein, nicht „$a“');
      zahlen.add(n);
    }
  }

  if (spielwand) {
    if (welt != null) _abbruch('--welt gibt es nur ohne --spielwand');
    _spielwand(zahlen, qualitaet, csv, png);
  } else {
    if (zahlen.isNotEmpty || qualitaetGesetzt) _abbruch('Breite, Höhe und --qualitaet gibt es nur mit --spielwand');
    final (bw, bh) = welt == null ? (320, 180) : _welt(welt);
    _pruefwand(bw, bh, csv, png);
  }
}

/// `--welt BxH`, z. B. 320x180 oder 640x360.
(int, int) _welt(String wert) {
  final teile = wert.toLowerCase().split('x');
  final b = teile.length == 2 ? int.tryParse(teile[0]) : null;
  final h = teile.length == 2 ? int.tryParse(teile[1]) : null;
  if (b == null || h == null || b < 2 || h < pruefZeilen) {
    _abbruch('--welt erwartet BxH mit B ≥ 2 und H ≥ $pruefZeilen, z. B. 320x180, nicht „$wert“');
  }
  return (b, h);
}

/// Prüfwand: je Grundfarbe ein Bild, Profil und Kennzahlen; Ausgabe je Farbe und eine Gesamtzeile.
void _pruefwand(int bw, int bh, String? csv, String? png) {
  if (csv != null) Directory(csv).createSync(recursive: true);
  if (png != null) Directory(png).createSync(recursive: true);
  final werte = <PruefWerte>[];
  for (final farbe in pruefFarben) {
    final fb = rendrePruefwand(farbe.index, bw, bh);
    final profil = messeProfil(fb);
    final w = bewertePruefprofil(profil);
    werte.add(w);
    stdout.writeln('BANDING ${farbe.name} · Stufen ${w.stufen} · größter Sprung ${w.groesterSprung} Stufen · '
        'Luma-Sprung ${dez(w.lumaSprung, 1)} · Sprünge>1 ${w.sprungUeber1}');
    if (csv != null) File('$csv/${farbe.name}.csv').writeAsStringSync(profilCsv(profil));
    if (png != null) {
      File('$png/${farbe.name}.png').writeAsBytesSync(encodePngRgba(bw, bh, fb.toRgbaBytes(), zlib: zlib.encode));
    }
  }
  final minStufen = werte.map((w) => w.stufen).reduce((a, b) => math.min(a, b));
  final maxSprung = werte.map((w) => w.groesterSprung).reduce((a, b) => math.max(a, b));
  stdout.writeln('BANDING v2 · Stufen (min) $minStufen · größter Sprung (max) $maxSprung · Welt ${bw}x$bh');
}

/// Bisherige Messung an einer Spielwand (unverändert in der Wirkung; `stufeVon` aus pixel_engine).
void _spielwand(List<int> zahlen, Qualitaet qualitaet, String? csv, String? png) {
  if (zahlen.isNotEmpty && zahlen.length != 2) _abbruch('Breite und Höhe nur gemeinsam angeben');
  final w = zahlen.isEmpty ? 1280 : zahlen[0];
  final h = zahlen.isEmpty ? 720 : zahlen[1];

  final spiel = Spiel();
  spiel.optionen.qualitaet = qualitaet;
  spiel.groesse(w, h);
  ladeAusRepo(spiel);

  stdout.writeln('SKALA ${spiel.skala}');
  final wahl = waehleWand(spiel);
  if (wahl == null) _abbruch('keine Wandkamera in den Innenräumen gefunden');
  stdout.writeln('WAND ${wahl.bereich.id} · x ${dez(wahl.x)} · z ${dez(wahl.z)} · yaw ${dez(wahl.yaw, 4)} rad · '
      'Abstand ${dez(wahl.abstand, 2)} m');

  final r = spiel.renderer;
  r.camera
    ..x = wahl.x
    ..y = kamHoehe
    ..z = wahl.z
    ..yaw = wahl.yaw
    ..pitch = 0;
  r.flashStrength = handyLicht;
  spiel.zeichneBereich(wahl.bereich.id);

  final bw = spiel.welt.width, bh = spiel.welt.height;
  final farben = spiel.welt.color;
  if (bh < 8 || bw < 2) _abbruch('Bild zu klein für das Profil');
  if (png != null) {
    File(png).parent.createSync(recursive: true);
    File(png).writeAsBytesSync(encodePngRgba(bw, bh, spiel.welt.toRgbaBytes(), zlib: zlib.encode));
  }

  final mitte = bh ~/ 2, cx = bw ~/ 2;
  final n = bw - cx;
  final index = List<int>.filled(n, 0);
  final luma = List<double>.filled(n, 0);
  for (var j = 0; j < n; j++) {
    final x = cx + j;
    index[j] = farben[mitte * bw + x];
    var summe = 0.0;
    for (var y = mitte - 4; y <= mitte + 3; y++) {
      summe += lumaVon(farben[y * bw + x]);
    }
    luma[j] = summe / 8;
  }

  final stufen = index.toSet().length;
  var groessterLuma = 0.0, groessterStufe = 0, sprungUeber1 = 0;
  for (var j = 0; j + 1 < n; j++) {
    groessterLuma = math.max(groessterLuma, (luma[j + 1] - luma[j]).abs());
    final ds = (stufeVon(index[j + 1]) - stufeVon(index[j])).abs();
    groessterStufe = math.max(groessterStufe, ds);
    if (ds > 1) sprungUeber1++;
  }
  stdout.writeln('BANDING · Stufen $stufen · größter Sprung ${dez(groessterLuma, 1)} Luma / '
      '$groessterStufe Stufen · Sprünge>1 $sprungUeber1');

  if (csv != null) {
    final zeilen = StringBuffer('x;luma;index\n');
    for (var j = 0; j < n; j++) {
      zeilen.writeln('${cx + j};${dez(luma[j], 2)};${index[j]}');
    }
    File(csv).parent.createSync(recursive: true);
    File(csv).writeAsStringSync(zeilen.toString());
  }
}

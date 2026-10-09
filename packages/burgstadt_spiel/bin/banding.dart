import 'dart:io';
import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Banding-Messung (P0-AUTOR-03, HZ-03): radiales Helligkeitsprofil des Handylichts auf einer glatten
/// Wand. Kamera 2,0 m vor einer Wand, senkrecht darauf blickend, Handylicht an, Raumlicht wie im Spiel.
///
/// `dart run bin/banding.dart [breite höhe] [--qualitaet name] [--csv pfad] [--png pfad]`
/// Standard 1280 720 und Qualität `mittel`. Profil: Mittelzeile (y = Höhe/2) von der Bildmitte nach rechts
/// bis zum Rand. Luma je Spalte = Mittel über 8 Zeilen um die Mitte; Stufen und Sprünge je Spalte
/// aus dem Palettenindex der Mittelzeile.

const _nutzung = 'Aufruf: dart run bin/banding.dart [breite höhe] [--qualitaet sparsam|mittel|hoch] [--csv pfad] [--png pfad]';

/// Handylicht beim Einschalten (erkundung.dart:404: `flash = licht ? 0.9 : 0.0`), ohne Flackern (Option `flackernAus`).
const handyLicht = 0.9;

/// Kamerahöhe wie im Spiel (erkundung.dart:397–403).
const kamHoehe = 1.62;

/// Stufe innerhalb der eigenen Rampe (0 = dunkelste Stufe der Rampe).
/// Heute 8 Stufen je Rampe, Index = Rampe·8 + Stufe (pixel_engine palette.dart): `& 7`.
/// Bei 16 Stufen je Rampe (Palette v2, STILBLATT §2: Index = Rampe·16 + Stufe) wird daraus `& 15`;
/// nur diese Funktion ändert sich.
int stufeVon(int index) => index & 7;

/// Luma (0..255) einer Palettenfarbe nach Rec. 709 (0,2126 R + 0,7152 G + 0,0722 B).
double lumaVon(int index) => 0.2126 * paletteR(index) + 0.7152 * paletteG(index) + 0.0722 * paletteB(index);

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

/// Dezimalzahl mit Komma und [stellen] Nachkommastellen.
String dez(double v, [int stellen = 2]) => v.toStringAsFixed(stellen).replaceAll('.', ',');

Never _abbruch(String meldung) {
  stderr.writeln('$meldung\n$_nutzung');
  exit(2);
}

void main(List<String> args) {
  final zahlen = <int>[];
  var qualitaet = Qualitaet.mittel;
  String? csv, png;
  for (var i = 0; i < args.length; i++) {
    final a = args[i];
    if (a == '--qualitaet' || a == '--csv' || a == '--png') {
      if (i + 1 >= args.length) _abbruch('$a braucht einen Wert');
      final wert = args[++i];
      switch (a) {
        case '--csv':
          csv = wert;
        case '--png':
          png = wert;
        default:
          qualitaet = Qualitaet.values.asNameMap()[wert] ??
              _abbruch('unbekannte Qualität „$wert“ (sparsam, mittel, hoch)');
      }
    } else {
      final n = int.tryParse(a);
      if (n == null || n <= 0) _abbruch('Größe muss eine positive ganze Zahl sein, nicht „$a“');
      zahlen.add(n);
    }
  }
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

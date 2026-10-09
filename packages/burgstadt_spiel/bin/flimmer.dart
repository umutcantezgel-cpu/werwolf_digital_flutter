import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Flimmer-Messung (P0-AUTOR-03, HZ-02): Anteil der Bodenpixel, deren Palettenindex sich bei einer
/// Vorwärtsbewegung von 0,1 m ändert, obwohl die Szene ruhig ist (Moiré, Texel-Schwimmen beim Gehen).
///
/// `dart run bin/flimmer.dart [breite höhe] [--qualitaet name] [--png pfad]`
/// Standard 1280 720 und Qualität `mittel`. `--png` speichert Szene A, Bild 1 als Welt-Puffer (RGBA).
/// Ohne Figuren, Handylicht aus, ohne Zeitschritt: zweimal gestartet kommen dieselben Zahlen heraus.

const _nutzung = 'Aufruf: dart run bin/flimmer.dart [breite höhe] [--qualitaet sparsam|mittel|hoch] [--png pfad]';

/// Vorwärtsbewegung zwischen den beiden Bildern einer Szene (m).
const schrittM = 0.1;

/// Ab dieser Tiefe (m) zählt ein Bodenpixel zur Ferne (dort entsteht Moiré).
const fernM = 6.0;

/// Kamerahöhe wie in `Erkundung.zeichneWelt` (erkundung.dart:397–403).
const kamHoehe = 1.62;

/// Weltpunkte unterhalb dieser Höhe (m) gelten als Boden.
const bodenHoeheM = 0.05;

/// Obergrenze der Sichtsuche (m), damit die längste Richtung eindeutig ist (Nebelende liegt bei 46 m).
const sichtMax = 60.0;

/// Kopie aus bin/belegfotos.dart (dort unverändert): freie Sichtweite ab (x, z) in Blickrichtung
/// [yaw] bis zur ersten nicht begehbaren Kachel.
double sichtweite(Bereich b, double x, double z, double yaw, {double max = 14}) {
  final dx = math.cos(yaw), dz = math.sin(yaw);
  for (var t = 0.1; t <= max; t += 0.1) {
    final kx = ((x + dx * t) / kKachel).floor(), kz = ((z + dz * t) / kKachel).floor();
    if (!b.begehbar(kx, kz)) return t - 0.1;
  }
  return max;
}

/// Blickrichtung wie beim Betreten eines Bereichs (erkundung.dart `_setzeAn`): zur Mitte des Raums.
double blickZurMitte(Bereich b, double x, double z) {
  final cx = b.breite * kKachel / 2, cz = b.tiefe * kKachel / 2;
  return math.atan2(cz - z, cx - x);
}

/// Zustand der Welt nach dem Zeichnen eines Bildes (Kopie, weil das nächste Bild den Puffer überschreibt).
class Bild {
  Bild(this.farben, this.tiefe, this.kamHoehe, this.cy, this.focal);

  /// Palettenindizes je Welt-Pixel.
  final Uint8List farben;

  /// Tiefenpuffer: 1/z je Pixel (Blickrichtung ohne Neigung), 0 = keine Geometrie.
  final Float32List tiefe;
  final double kamHoehe, cy, focal;
}

/// Zeichnet Bereich [b] von (x, z) in Blickrichtung [yaw] ohne Figuren und ohne Handylicht.
Bild rendere(Spiel spiel, Bereich b, double x, double z, double yaw) {
  final r = spiel.renderer;
  r.camera
    ..x = x
    ..y = kamHoehe
    ..z = z
    ..yaw = yaw
    ..pitch = 0;
  r.flashStrength = 0;
  spiel.zeichneBereich(b.id);
  final c = r.camera; // von begin() gesetzt
  return Bild(Uint8List.fromList(spiel.welt.color), Float32List.fromList(spiel.welt.depth), c.y, c.cy, c.focal);
}

/// Tiefe z (m) je Pixel, wenn der Pixel Boden ist: unterhalb des Horizonts (y > cy) und der zugehörige
/// Weltpunkt liegt tiefer als 0,05 m (hy = camY + (cy − (y+0.5)) / focal · z). Sonst 0.
Float32List bodenTiefe(Bild bild, int w, int h) {
  final out = Float32List(w * h);
  for (var y = 0; y < h; y++) {
    if (!(y > bild.cy)) continue;
    for (var x = 0; x < w; x++) {
      final iz = bild.tiefe[y * w + x];
      if (iz <= 0) continue;
      final z = 1 / iz;
      final hy = bild.kamHoehe + (bild.cy - (y + 0.5)) / bild.focal * z;
      if (hy < bodenHoeheM) out[y * w + x] = z;
    }
  }
  return out;
}

/// Eine Messszene: Name, Bereich, Standort (m), Blickrichtung (rad) und Herkunft der Wahl (Ausgabe).
class Szene {
  Szene(this.name, this.bereich, this.x, this.z, this.yaw, this.herkunft);
  final String name;
  final Bereich bereich;
  final double x, z, yaw;
  final String herkunft;

  /// Freie Sicht in Blickrichtung (m) bis 60 m, gleiche Logik wie belegfotos.dart.
  double get sicht => sichtweite(bereich, x, z, yaw, max: sichtMax);
}

/// Szene A: Oberstadt an der Marke `b`, Blick in die längste freie Richtung (16 Richtungen).
Szene oberstadtSzene(Spiel spiel) {
  final stadt = spiel.stadt.bereiche['stadt']!;
  final (x, z) = stadt.markePos('b');
  var bestYaw = 0.0, bestSicht = -1.0;
  for (var k = 0; k < 16; k++) {
    final yaw = k / 8 * math.pi;
    final s = sichtweite(stadt, x, z, yaw, max: sichtMax);
    if (s > bestSicht) {
      bestSicht = s;
      bestYaw = yaw;
    }
  }
  return Szene('A-Oberstadt', stadt, x, z, bestYaw, 'Marke b, längste freie Richtung');
}

/// Szene B: der größte Innenraum mit Steinboden (innen == true, Boden Schiefer oder Pflaster), gemessen
/// an den begehbaren Kacheln; Standort die Ankunftsmarke `t`, Blick zur Raummitte wie beim Betreten.
Szene innenSzene(Spiel spiel) {
  const steinBoden = {'schieferPlatten', 'pflaster', 'pflasterGross'};
  Bereich? gross;
  var grossFlaeche = -1;
  final ids = spiel.stadt.bereiche.keys.toList()..sort();
  for (final id in ids) {
    final kandidat = spiel.stadt.bereiche[id]!;
    if (!kandidat.innen || !steinBoden.contains(kandidat.bodenTextur)) continue;
    var flaeche = 0;
    for (var z = 0; z < kandidat.tiefe; z++) {
      for (var x = 0; x < kandidat.breite; x++) {
        if (kandidat.begehbar(x, z)) flaeche++;
      }
    }
    if (flaeche > grossFlaeche) {
      grossFlaeche = flaeche;
      gross = kandidat;
    }
  }
  final b = gross!;
  final (x, z) = b.markePos('t');
  return Szene('B-Innenraum', b, x, z, blickZurMitte(b, x, z), 'Marke t, $grossFlaeche begehbare Kacheln');
}

/// Szene C: Hofebene des Turms (`hofebene`), Ankunft über die Hoftür (Marke `h`), Blick zur Raummitte.
Szene hofSzene(Spiel spiel) {
  final b = spiel.stadt.bereiche['hofebene']!;
  final (x, z) = b.markePos('h');
  return Szene('C-Burghof', b, x, z, blickZurMitte(b, x, z), 'Marke h');
}

/// Messwerte einer Szene: Bodenpixel in beiden Bildern, davon geändert, davon in der Ferne (z > 6 m, nach Bild 1).
class Messung {
  Messung(this.boden, this.geaendert, this.fern, this.fernGeaendert);
  final int boden, geaendert, fern, fernGeaendert;

  double get anteil => boden == 0 ? 0 : geaendert / boden;
  double get fernAnteil => fern == 0 ? 0 : fernGeaendert / fern;
}

Messung messe(Bild eins, Bild zwei, int w, int h) {
  final ze = bodenTiefe(eins, w, h), zz = bodenTiefe(zwei, w, h);
  var boden = 0, geaendert = 0, fern = 0, fernGeaendert = 0;
  for (var i = 0; i < w * h; i++) {
    if (ze[i] == 0 || zz[i] == 0) continue;
    boden++;
    final aendert = eins.farben[i] != zwei.farben[i];
    if (aendert) geaendert++;
    if (ze[i] > fernM) {
      fern++;
      if (aendert) fernGeaendert++;
    }
  }
  return Messung(boden, geaendert, fern, fernGeaendert);
}

/// Dezimalzahl im Format `p,ppp` (Komma, drei Nachkommastellen).
String dez(double v, [int stellen = 3]) => v.toStringAsFixed(stellen).replaceAll('.', ',');

Never _abbruch(String meldung) {
  stderr.writeln('$meldung\n$_nutzung');
  exit(2);
}

void main(List<String> args) {
  final zahlen = <int>[];
  var qualitaet = Qualitaet.mittel;
  String? png;
  for (var i = 0; i < args.length; i++) {
    final a = args[i];
    if (a == '--qualitaet' || a == '--png') {
      if (i + 1 >= args.length) _abbruch('$a braucht einen Wert');
      final wert = args[++i];
      if (a == '--png') {
        png = wert;
      } else {
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
  final fw = spiel.welt.width, fh = spiel.welt.height;
  stdout.writeln('SKALA ${spiel.skala}');

  final szenen = [oberstadtSzene(spiel), innenSzene(spiel), hofSzene(spiel)];
  final anteile = <double>[], fernAnteile = <double>[];
  for (var i = 0; i < szenen.length; i++) {
    final s = szenen[i];
    final eins = rendere(spiel, s.bereich, s.x, s.z, s.yaw);
    final fernsterBoden = bodenTiefe(eins, fw, fh).reduce(math.max);
    stdout.writeln('SZENE ${s.name} · Bereich ${s.bereich.id} (${s.herkunft}) · '
        'x ${dez(s.x, 2)} · z ${dez(s.z, 2)} · yaw ${dez(s.yaw, 4)} rad · Sicht ${dez(s.sicht, 1)} m · '
        'Boden bis ${dez(fernsterBoden, 1)} m');
    if (i == 0 && png != null) {
      File(png).parent.createSync(recursive: true);
      File(png).writeAsBytesSync(encodePngRgba(fw, fh, spiel.welt.toRgbaBytes(), zlib: zlib.encode));
    }
    final zwei = rendere(spiel, s.bereich, s.x + math.cos(s.yaw) * schrittM, s.z + math.sin(s.yaw) * schrittM, s.yaw);
    final m = messe(eins, zwei, fw, fh);
    anteile.add(m.anteil);
    fernAnteile.add(m.fernAnteil);
    stdout.writeln('FLIMMERN ${s.name} · Boden ${m.boden} Pixel · Änderung ${dez(m.anteil)} · Ferne ${dez(m.fernAnteil)}');
  }
  final mittel = anteile.reduce((a, b) => a + b) / anteile.length;
  final fernMittel = fernAnteile.reduce((a, b) => a + b) / fernAnteile.length;
  stdout.writeln('FLIMMERN MITTEL ${dez(mittel)} · FERNE ${dez(fernMittel)}');
}

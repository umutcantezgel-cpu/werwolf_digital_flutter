// Szenenwahl für bin/szenen_mess.dart (REP-03): die fünf festen Messszenen und die Figurenplätze
// der Figurenszene. Ausgelagert, damit szenen_mess.dart unter 400 Zeilen bleibt.
// Kamerawahl aus bin/belegfotos.dart übernommen.

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';

/// Zahl der Figuren in der Figurenszene (Rollenkarten der Sitzung).
const figurenZahl = 8;

const _bildStrahlen = [-0.8, -0.53, -0.27, 0.0, 0.27, 0.53, 0.8];
const _mindestSicht = 2.5;
const _mitteMindestStadt = 6.0;

typedef Richt = ({double yaw, double min, double mittel, double wert});
typedef Blick = ({String marke, double x, double z, double yaw, double min, double mittel});

/// Figur auf festem Platz (nur Figurenszene): Figurenkarte, Standort, Blickrichtung.
typedef Platz = ({String figur, double x, double z, double yaw});

/// Messszene. Mit [figuren] (nicht null) feste Kamera; dann zeichnet die Szene nur diese Figuren.
typedef Szene = ({String name, Bereich bereich, double x, double z, double yaw, String marke, List<Platz>? figuren});

T _oder<T>(T? wert, String meldung) => wert ?? (throw StateError(meldung));

/// Freie Sichtweite ab (x, z) in Richtung [yaw] bis zur ersten nicht begehbaren Kachel.
double sichtweite(Bereich b, double x, double z, double yaw, {double max = 14}) {
  final dx = math.cos(yaw), dz = math.sin(yaw);
  for (var t = 0.1; t <= max; t += 0.1) {
    if (!b.begehbar(((x + dx * t) / kKachel).floor(), ((z + dz * t) / kKachel).floor())) return t - 0.1;
  }
  return max;
}

/// Beste Blickrichtung (16 Richtungen): kleinste Bildsicht >= mindest, Mittelstrahl >= mitteMindest.
Richt? besterBlick(Bereich b, double x, double z, double bevorzugt, double mindest, double mitteMindest) {
  Richt? beste;
  for (var k = 0; k < 16; k++) {
    final yaw = k / 8 * math.pi;
    final s = [for (final d in _bildStrahlen) sichtweite(b, x, z, yaw + d)];
    final mn = s.reduce(math.min), mt = s.reduce((a, c) => a + c) / s.length;
    if (mn < mindest || sichtweite(b, x, z, yaw) < mitteMindest) continue;
    final wert = mt + 0.01 * math.cos(yaw - bevorzugt);
    if (beste == null || wert > beste.wert) beste = (yaw: yaw, min: mn, mittel: mt, wert: wert);
  }
  return beste;
}

/// Raster 0,25 m bis 2 m um (x0, z0): Standort x, Standort z, Abstand zur Mitte.
Iterable<(double, double, double)> raster(double x0, double z0) sync* {
  for (var ox = -2.0; ox <= 2.0 + 1e-9; ox += 0.25) {
    for (var oz = -2.0; oz <= 2.0 + 1e-9; oz += 0.25) {
      final d = math.sqrt(ox * ox + oz * oz);
      if (d <= 2.0 + 1e-9) yield (x0 + ox, z0 + oz, d);
    }
  }
}

/// Blick vor einer Haustür (stadtBlick aus belegfotos.dart).
Blick? stadtBlick(Bereich b, String marke) {
  final (tx, tz) = b.marken[marke]!;
  final (px, pz) = b.markePos(marke);
  for (final (dx, dz) in const [(0, -1), (0, 1), (-1, 0), (1, 0)]) {
    if (b.dingAn(tx - dx, tz - dz)?.legende.art != KachelArt.tuer) continue;
    final bevorzugt = math.atan2(dz.toDouble(), dx.toDouble());
    Blick? beste;
    for (final (x, z, d) in raster(px, pz)) {
      final ox = x - px, oz = z - pz;
      if (d < 1.0 - 1e-9 || d > 2.0 + 1e-9 || ox * dx + oz * dz < 0 || !b.frei(x, z)) continue;
      final r = besterBlick(b, x, z, bevorzugt, _mindestSicht, _mitteMindestStadt);
      if (r != null && (beste == null || r.mittel > beste.mittel)) beste = (marke: marke, x: x, z: z, yaw: r.yaw, min: r.min, mittel: r.mittel);
    }
    return beste;
  }
  return null;
}

/// Blick vom Ankunftspunkt nahe der Marke (innenBlick aus belegfotos.dart; hier auch für den Burghof).
Blick? ankunftBlick(Bereich b, String marke) {
  final (mx, mz) = b.markePos(marke);
  Blick? beste;
  var bestAbstand = double.infinity;
  for (final (x, z, abst) in raster(mx, mz)) {
    if (abst > bestAbstand + 1e-9 || !b.frei(x, z)) continue;
    final mitte = math.atan2(b.tiefe * kKachel / 2 - z, b.breite * kKachel / 2 - x);
    final r = besterBlick(b, x, z, mitte, _mindestSicht, 0);
    if (r != null && (beste == null || abst < bestAbstand - 1e-9 || r.mittel > beste.mittel)) {
      beste = (marke: marke, x: x, z: z, yaw: r.yaw, min: r.min, mittel: r.mittel);
      bestAbstand = abst;
    }
  }
  return beste;
}

/// Nächste begehbare Stelle um (x0, z0).
(double, double)? naechsterFreier(Bereich b, double x0, double z0) {
  (double, double)? beste;
  var bestAbstand = double.infinity;
  for (final (x, z, a) in raster(x0, z0)) {
    if (a < bestAbstand - 1e-9 && b.frei(x, z)) {
      bestAbstand = a;
      beste = (x, z);
    }
  }
  return beste;
}

double abstand(double ax, double az, double bx, double bz) => math.sqrt((ax - bx) * (ax - bx) + (az - bz) * (az - bz));

/// Figurenplätze der Figurenszene: [figurenZahl] Figuren, Winkel gleichmäßig über 80 % des halben
/// Bildwinkels [halbX] um [yaw], Abstände 3–9 m (acht verschiedene Stufen, je Figur eine). Liegt eine
/// Wand im Weg, wandert die Richtung in 0,02-rad-Schritten zur Blickmitte, bis die Sicht reicht; der
/// Abstand wird dann auf die freie Sicht gekürzt (nicht unter 3 m). Blickrichtung je Figur um 45° weiter.
List<Platz> figurenPlatz(Bereich b, double x, double z, double yaw, double halbX, List<String> ids) {
  final liste = <Platz>[];
  for (var k = 0; k < figurenZahl; k++) {
    var th = yaw + 0.8 * halbX * (2 * k / (figurenZahl - 1) - 1);
    final ziel = 3 + 6 * ((k * 5) % 8) / 7;
    for (var schritt = 0; schritt < 40 && sichtweite(b, x, z, th, max: 9.5) < ziel + 1.0; schritt++) {
      th += (yaw - th).sign * 0.02;
    }
    // Standort auf dem Strahl: freier Punkt zwischen 3 m und freier Sicht (–0,3 m), nahe am Ziel
    final oben = math.min(9.0, sichtweite(b, x, z, th, max: 9.5) - 0.3);
    var d = -1.0;
    for (var t = 3.0; t <= oben + 1e-9; t += 0.1) {
      if (!b.frei(x + math.cos(th) * t, z + math.sin(th) * t)) continue;
      if (d < 0 || (t - ziel).abs() < (d - ziel).abs()) d = t;
    }
    if (d < 0) throw StateError('Figurenplatz $k: kein freier Standort zwischen 3 m und ${oben.toStringAsFixed(1)} m');
    liste.add((figur: ids[k], x: x + math.cos(th) * d, z: z + math.sin(th) * d, yaw: 2 * math.pi * k / figurenZahl));
  }
  return liste;
}

/// Die fünf festen Szenen: 1 Marktplatz, 2 Oberstadt zweite Stelle, 3 Innenraum (größter Fall-Ort),
/// 4 Burghof, 5 Figuren (Marktplatz, Kamera fest, [figurIds] auf festen Plätzen). Wirft [StateError].
List<Szene> waehleSzenen(Spiel spiel, List<String> figurIds, double halbX) {
  final stadt = spiel.stadt.bereiche['stadt']!;
  final (bx, bz) = stadt.markePos('b');
  final (mx, mz) = _oder(naechsterFreier(stadt, bx, bz), 'Marke b in stadt: kein freier Standort');
  // 1. Marktplatz: Marke b, Startblick in die längste freie Gasse (bis 60 m)
  var langYaw = 0.0, langSicht = -1.0;
  for (var k = 0; k < 16; k++) {
    final yaw = k / 8 * math.pi, t = sichtweite(stadt, mx, mz, yaw, max: 60);
    if (t > langSicht) { langSicht = t; langYaw = yaw; }
  }
  final szenen = <Szene>[(name: 'Marktplatz', bereich: stadt, x: mx, z: mz, yaw: langYaw, marke: 'b', figuren: null)];
  // 2. Zweite Stelle: Haustür-Marke mit dem weitesten Blick, mindestens 5 m vom Marktplatz
  Blick? zweite;
  for (final m in stadt.marken.keys.toList()..sort()) {
    final k = m.startsWith('vor-') ? stadtBlick(stadt, m) : null;
    if (k == null || abstand(k.x, k.z, mx, mz) < 5) continue;
    if (zweite == null || k.mittel > zweite.mittel) zweite = k;
  }
  final z2 = _oder(zweite, 'Keine Oberstadt-Marke mit freiem Blick');
  szenen.add((name: 'Oberstadt zweite Stelle', bereich: stadt, x: z2.x, z: z2.z, yaw: z2.yaw, marke: z2.marke, figuren: null));
  // 3. Größter Fall-Ort aus fallorte.json (Rasterfläche Breite × Tiefe)
  final fallDatei = jsonDecode(File('${findeRepoWurzel()!}/packages/burgstadt_core/data/innenraeume/fallorte.json').readAsStringSync()) as Map;
  Bereich? gross;
  for (final e in fallDatei['bereiche'] as List) {
    final b = spiel.stadt.bereiche[(e as Map)['id'] as String];
    if (b != null && (gross == null || b.breite * b.tiefe > gross.breite * gross.tiefe)) gross = b;
  }
  final innen = _oder(gross, 'Kein Fall-Ort in fallorte.json');
  // Ankunftsmarke: Tür aus der Oberstadt in den Raum (wie belegfotos.dart)
  var marke = stadt.dinge.where((d) => d.legende.art == KachelArt.tuer && d.legende.ziel == innen.id && d.legende.zielMarke != null)
      .map((d) => d.legende.zielMarke!).firstOrNull ?? 't';
  if (!innen.marken.containsKey(marke)) marke = (innen.marken.keys.toList()..sort()).first;
  final ki = _oder(ankunftBlick(innen, marke), 'Kein Blick im Raum ${innen.id}');
  szenen.add((name: 'Innenraum ${innen.name}', bereich: innen, x: ki.x, z: ki.z, yaw: ki.yaw, marke: marke, figuren: null));
  // 4. Burghof: Ankunftsmarke b am Burgtor
  final hof = _oder(spiel.stadt.bereiche['hof'], 'Bereich hof fehlt');
  final hm = hof.marken.containsKey('b') ? 'b' : (hof.marken.keys.toList()..sort()).first;
  final kh = _oder(ankunftBlick(hof, hm), 'Kein Blick im Burghof');
  szenen.add((name: 'Burghof', bereich: hof, x: kh.x, z: kh.z, yaw: kh.yaw, marke: hm, figuren: null));
  // 5. Figuren: Marktplatz mit fester Kamera (Blick wie Marktplatz), acht Figuren im Blickfeld
  szenen.add((name: 'Figuren', bereich: stadt, x: mx, z: mz, yaw: langYaw, marke: 'b', figuren: figurenPlatz(stadt, mx, mz, langYaw, halbX, figurIds)));
  return szenen;
}

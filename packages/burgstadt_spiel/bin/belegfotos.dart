import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Ab diesem Anteil reinen Schwarzes gilt ein Bild als Aufnahme aus der Schwarzblende.
/// Der Raumwechsel blendet in etwa 10 Bildern aus Schwarz auf; die Aufnahmen warten 12 Bilder.
const schwarzGrenze = 0.2;

/// Mindestsicht (m): kein Bildstrahl darf kürzer frei sein, sonst steht eine Wand im Bild.
const mindestSichtStadt = 2.5;
const mindestSichtInnen = 2.5;

/// Mittelstrahl (m) in der Oberstadt: der Blick geht die Gasse entlang, nicht auf eine nahe Hauswand.
const mitteMindestStadt = 6.0;

/// Strahlen über die Bildbreite (Abweichung von der Blickrichtung in rad, ±0,8 ≈ ±46°).
const bildStrahlen = [-0.8, -0.53, -0.27, 0.0, 0.27, 0.53, 0.8];

/// Kamera eines Belegfotos: Marke, Position (m), Blickwinkel (rad), kleinste freie Sicht über die
/// Bildbreite (m) und deren Mittel (m; größer = weiterer Blick, z. B. eine Gasse statt Sackgasse).
class Kamerablick {
  final String marke;
  final double x, z, yaw, sicht, mittel;
  const Kamerablick(this.marke, this.x, this.z, this.yaw, this.sicht, this.mittel);
}

/// Richtung mit Sichtwerten (siehe [Kamerablick]); `wert` steuert die Auswahl.
class Richtung {
  final double yaw, min, mittel, wert;
  const Richtung(this.yaw, this.min, this.mittel, this.wert);
}

/// Freie Sichtweite ab (x, z) in Blickrichtung [yaw] bis zur ersten nicht begehbaren Kachel.
double sichtweite(Bereich b, double x, double z, double yaw, {double max = 14}) {
  final dx = math.cos(yaw), dz = math.sin(yaw);
  for (var t = 0.1; t <= max; t += 0.1) {
    final kx = ((x + dx * t) / kKachel).floor(), kz = ((z + dz * t) / kKachel).floor();
    if (!b.begehbar(kx, kz)) return t - 0.1;
  }
  return max;
}

/// Kleinste und mittlere freie Sicht über alle Bildstrahlen einer Blickrichtung.
(double, double) bildSicht(Bereich b, double x, double z, double yaw) {
  final s = [for (final d in bildStrahlen) sichtweite(b, x, z, yaw + d)];
  return (s.reduce(math.min), s.reduce((a, c) => a + c) / s.length);
}

/// Beste Blickrichtung (16 Richtungen): unter den Richtungen, deren kleinste Sicht über die Bildbreite
/// [mindest] erreicht und deren Mittelstrahl mindestens [mitteMindest] m frei ist, die mit der größten
/// mittleren Sicht (bei Gleichstand nahe [bevorzugt]). Ohne solche Richtung: null.
Richtung? besterBlick(Bereich b, double x, double z, double bevorzugt, double mindest, double mitteMindest) {
  Richtung? beste;
  for (var k = 0; k < 16; k++) {
    final yaw = k / 8 * math.pi;
    final (mn, mt) = bildSicht(b, x, z, yaw);
    if (mn < mindest || sichtweite(b, x, z, yaw) < mitteMindest) continue;
    final r = Richtung(yaw, mn, mt, mt + 0.01 * math.cos(yaw - bevorzugt));
    if (beste == null || r.wert > beste.wert) beste = r;
  }
  return beste;
}

/// Blick vor einer Haustür: Kamera 1–2 m vor der Marke (auf der Seite von der Tür weg), Richtung mit der
/// größten mittleren Sicht. Seitlich versetzte Standorte sind zulässig, weil die Gassen vor den Türen eng sind.
Kamerablick? stadtBlick(Bereich b, String marke) {
  final (tx, tz) = b.marken[marke]!;
  final (px, pz) = b.markePos(marke);
  for (final (dx, dz) in const [(0, -1), (0, 1), (-1, 0), (1, 0)]) {
    if (b.dingAn(tx - dx, tz - dz)?.legende.art != KachelArt.tuer) continue;
    final bevorzugt = math.atan2(dz.toDouble(), dx.toDouble());
    Kamerablick? beste;
    for (var ox = -2.0; ox <= 2.0 + 1e-9; ox += 0.25) {
      for (var oz = -2.0; oz <= 2.0 + 1e-9; oz += 0.25) {
        final d = math.sqrt(ox * ox + oz * oz);
        if (d < 1.0 - 1e-9 || d > 2.0 + 1e-9 || ox * dx + oz * dz < 0) continue;
        final x = px + ox, z = pz + oz;
        if (!b.frei(x, z)) continue;
        final r = besterBlick(b, x, z, bevorzugt, mindestSichtStadt, mitteMindestStadt);
        if (r == null) continue;
        if (beste == null || r.mittel > beste.mittel) beste = Kamerablick(marke, x, z, r.yaw, r.min, r.mittel);
      }
    }
    return beste;
  }
  return null;
}

/// Blick vom Ankunftspunkt eines Innenraums in den Raum: die Kamera steht so nah wie möglich an der
/// Ankunftsmarke (bis 2 m), an der alle Bildstrahlen mindestens [mindestSichtInnen] m frei lassen.
Kamerablick? innenBlick(Bereich b, String marke) {
  final (mx, mz) = b.markePos(marke);
  Kamerablick? beste;
  var bestAbstand = double.infinity;
  for (var ox = -2.0; ox <= 2.0 + 1e-9; ox += 0.25) {
    for (var oz = -2.0; oz <= 2.0 + 1e-9; oz += 0.25) {
      final abstand = math.sqrt(ox * ox + oz * oz);
      if (abstand > 2.0 + 1e-9 || abstand > bestAbstand + 1e-9) continue;
      final x = mx + ox, z = mz + oz;
      if (!b.frei(x, z)) continue;
      final mitte = math.atan2(b.tiefe * kKachel / 2 - z, b.breite * kKachel / 2 - x);
      final r = besterBlick(b, x, z, mitte, mindestSichtInnen, 0);
      if (r == null) continue;
      if (beste == null || abstand < bestAbstand - 1e-9 || r.mittel > beste.mittel) {
        beste = Kamerablick(marke, x, z, r.yaw, r.min, r.mittel);
        bestAbstand = abstand;
      }
    }
  }
  return beste;
}

/// Anteil deckender reiner Schwarzpixel.
double schwarzAnteil(Uint8List rgba) {
  var schwarz = 0, deckend = 0;
  for (var i = 0; i < rgba.length; i += 4) {
    if (rgba[i + 3] == 0) continue;
    deckend++;
    if (rgba[i] == 0 && rgba[i + 1] == 0 && rgba[i + 2] == 0) schwarz++;
  }
  return deckend == 0 ? 1 : schwarz / deckend;
}

String slug(String s) => s
    .toLowerCase()
    .replaceAll('ä', 'ae')
    .replaceAll('ö', 'oe')
    .replaceAll('ü', 'ue')
    .replaceAll('ß', 'ss')
    .replaceAll(RegExp('[^a-z0-9]+'), '_');

/// Belegfotos aller Viertel, Innenräume und Bildschirme (Auftrag A-606a), je mit Paletten- und Blocktest.
/// `dart run bin/belegfotos.dart <ordner> [breite höhe]`
void main(List<String> args) {
  final ordner = args.isEmpty ? '.' : args[0];
  final w = args.length > 2 ? int.parse(args[1]) : 1280;
  final h = args.length > 2 ? int.parse(args[2]) : 720;
  Directory(ordner).createSync(recursive: true);
  final spiel = Spiel()..groesse(w, h);
  ladeAusRepo(spiel);
  final stadt = spiel.stadt.bereiche['stadt']!;
  final e = Eingabe();

  var bilder = 0, fehler = 0, bildschirmFotos = 0, viertelFotos = 0, innenFotos = 0;

  void tick([int k = 1]) {
    for (var i = 0; i < k; i++) {
      spiel.tick(1 / 30, e);
    }
  }

  void druecke(Taste t) {
    e.tasteRunter(t);
    tick();
    e.tasteHoch(t);
    tick();
  }

  void foto(String name, String ansicht) {
    final rgba = komponiere(spiel.welt, spiel.ui, spiel.skala!);
    final pal = countOffPalette(rgba);
    final blk = blockTest(rgba, w, h, spiel.skala!.kUi);
    final schwarz = schwarzAnteil(rgba);
    final ok = pal == 0 && blk.ratio == 1 && schwarz <= schwarzGrenze;
    File('$ordner/$name.png').writeAsBytesSync(encodePngRgba(w, h, rgba, zlib: zlib.encode));
    bilder++;
    if (!ok) fehler++;
    stdout.writeln('$name: $ansicht · Palette ${pal == 0 ? 'OK' : 'FEHLER'} · Block ${(blk.ratio * 100).toStringAsFixed(1)} % · '
        'Schwarz ${(schwarz * 100).toStringAsFixed(1)} %${ok ? '' : ' · FEHLER'}');
  }

  /// Erkundung an einem Ort mit Kamera [k] aufbauen; 12 Bilder warten (Einblendung aus Schwarz).
  void ortsansicht(String ort, Kamerablick k) {
    final erk = Erkundung()
      ..ort = ort
      ..x = k.x
      ..z = k.z
      ..yaw = k.yaw
      ..pitch = 0;
    spiel.wechsle(erk);
    tick(12);
  }

  // ------------------------------------------------------------ Menüs und Bildschirme
  tick(3);
  foto('01_hauptmenue', 'Hauptmenü');
  bildschirmFotos++;
  spiel.oeffne(OptionenBildschirm());
  tick();
  foto('02_optionen', 'Optionen über dem Hauptmenü');
  bildschirmFotos++;
  spiel.schliesse();

  // Fall: Erkundung mit Tutorial-Karte, Pausenmenü (Taste Menü), dann Zeitraffer bis zum Ende
  final s = spiel.starteFall()!;
  spiel.besucht.clear();
  spiel.tutorial.gezeigt.clear();
  spiel.wechsle(Erkundung(sitzung: s));
  tick(12);
  foto('03_erkundung_tutorial', 'Erkundung mit Tutorial-Karte');
  bildschirmFotos++;
  druecke(Taste.menue);
  foto('04_pausenmenue', 'Pausenmenü über der Erkundung');
  bildschirmFotos++;
  druecke(Taste.menue);

  s.sim.tempo = 65 / 20;
  final lagerPhasen = <int>{};
  var akteGezeigt = false, eingrenzungGezeigt = false;
  for (var schritt = 0; schritt < 20000 && s.fall.abschnitt != Abschnitt.ende; schritt++) {
    tick();
    final b = spiel.bildschirm;
    if (b is LagerundeBildschirm) {
      if (lagerPhasen.add(s.fall.phase)) {
        foto('lagerunde_phase${s.fall.phase}', 'Lagerunde Phase ${s.fall.phase} mit Entscheidung');
        bildschirmFotos++;
      }
      // Detektiv wählt die echte Spur, wenn er einen begründenden Hinweis kennt (wie ein aufmerksamer Spieler)
      if (b.aktuell != null && b.ergebnis == null) {
        final d = b.aktuell!;
        s.melde(s.fall.waehleDetektiv(d.id, s.sim.bots.detektivWahl(d)));
        b.ergebnis = 'gewählt';
      } else if (b.ergebnis != null) {
        b.ergebnis = null;
        b.aktuell = s.fall.detektivEntscheidungen().firstOrNull;
      } else {
        s.melde(s.fall.weiter());
        if (s.fall.abschnitt == Abschnitt.eingrenzung) {
          spiel.wechsle(AnklageBildschirm(s));
        } else {
          spiel.schliesse();
        }
      }
    } else if (b is AnklageBildschirm && s.fall.abschnitt == Abschnitt.eingrenzung) {
      tick();
      if (!eingrenzungGezeigt) {
        eingrenzungGezeigt = true;
        foto('eingrenzung', 'Eingrenzung (Anklage-Auswahl)');
        bildschirmFotos++;
      }
      s.melde(s.fall.klageAn(s.sim.bots.anklage()));
    } else if (b is Erkundung && !akteGezeigt && s.fall.wissen['DET']!.length >= 3) {
      // Drei Notizen an die Fallakte heften (wie „An die Akte heften“), dann die Akte zeigen
      akteGezeigt = true;
      for (final hid in s.fall.wissen['DET']!.take(3).toList()) {
        s.melde(s.fall.teile('DET', 'akte', hid));
      }
      druecke(Taste.akte);
      tick();
      foto('fallakte', 'Fallakte mit Einträgen');
      bildschirmFotos++;
      druecke(Taste.zurueck);
    }
  }
  if (s.fall.abschnitt != Abschnitt.ende) {
    fehler++;
    stdout.writeln('Fall: Ende nicht erreicht (${s.fall.abschnitt.name}) · FEHLER');
  }
  tick(2);
  foto('ende', 'Ende (Morgengrauen)');
  bildschirmFotos++;

  // ------------------------------------------------------------ Oberstadt: je Viertel eine Marke
  const viertelReihe = ['Burgberg', 'Mauerviertel', 'Kirchhügel', 'Handwerkergasse', 'Untere Stadt', 'Marktviertel'];
  final haeuserNachViertel = <String, List<String>>{};
  for (final hd in spiel.haeuserDaten) {
    haeuserNachViertel.putIfAbsent(hd['viertel'] as String, () => []).add(hd['id'] as String);
  }
  for (final v in viertelReihe) {
    Kamerablick? beste;
    for (final id in [...?haeuserNachViertel[v]]..sort()) {
      final marke = 'vor-$id';
      if (!stadt.marken.containsKey(marke)) continue;
      final k = stadtBlick(stadt, marke);
      if (k != null && (beste == null || k.mittel > beste.mittel)) beste = k;
    }
    if (beste == null) {
      fehler++;
      stdout.writeln('Viertel $v: keine Marke mit freiem Blick · FEHLER');
      continue;
    }
    ortsansicht('stadt', beste);
    final (mx, mz) = stadt.markePos(beste.marke);
    final abstand = math.sqrt((beste.x - mx) * (beste.x - mx) + (beste.z - mz) * (beste.z - mz));
    foto('viertel_${slug(v)}',
        'Viertel $v · Marke ${beste.marke} · Kamera ${abstand.toStringAsFixed(2)} m vor der Marke · '
        'Sicht ${beste.sicht.toStringAsFixed(1)} m (Mittel ${beste.mittel.toStringAsFixed(1)} m)');
    viertelFotos++;
  }

  // ------------------------------------------------------------ Innenräume: je Raum die Ankunftsmarke der Stadttür
  final tuerZuInnen = {
    for (final d in stadt.dinge)
      if (d.legende.art == KachelArt.tuer && d.legende.ziel != null && d.legende.ziel != 'stadt')
        d.legende.ziel!: d.legende.zielMarke ?? 't',
  };
  final innenRaeume = [
    for (final b in spiel.stadt.bereiche.values)
      if (b.innen && (b.id.startsWith('innen-') || b.id.startsWith('haus-')) && tuerZuInnen.containsKey(b.id)) b,
  ]..sort((a, c) => a.id.compareTo(c.id));
  // Räume mit einem Blick von mindestens [mindestSichtInnen] m; daraus zehn gleichmäßig verteilt.
  final tauglich = <(Bereich, String, Kamerablick)>[];
  for (final b in innenRaeume) {
    final marke = tuerZuInnen[b.id]!;
    final k = b.marken.containsKey(marke) ? innenBlick(b, marke) : null;
    if (k == null) {
      stdout.writeln('${b.id}: kein Blick mit mindestens $mindestSichtInnen m Sicht · übersprungen');
      continue;
    }
    tauglich.add((b, marke, k));
  }
  final anzahlInnen = math.min(10, tauglich.length);
  for (var i = 0; i < anzahlInnen; i++) {
    final (b, marke, k) = tauglich[i * tauglich.length ~/ anzahlInnen];
    final (mx, mz) = b.markePos(marke);
    final abstand = math.sqrt((k.x - mx) * (k.x - mx) + (k.z - mz) * (k.z - mz));
    ortsansicht(b.id, k);
    foto('innen_${slug(b.id)}',
        'Innenraum ${b.name} · Ankunft $marke · Kamera ${abstand.toStringAsFixed(2)} m von der Marke · '
        'Sicht ${k.sicht.toStringAsFixed(1)} m (Mittel ${k.mittel.toStringAsFixed(1)} m)');
    innenFotos++;
  }

  // ------------------------------------------------------------ Abnahme
  if (viertelFotos != 6) {
    fehler++;
    stdout.writeln('Viertel: $viertelFotos von 6 · FEHLER');
  }
  if (innenFotos != 10) {
    fehler++;
    stdout.writeln('Innenräume: $innenFotos von 10 · FEHLER');
  }
  if (bildschirmFotos < 8) {
    fehler++;
    stdout.writeln('Bildschirme: $bildschirmFotos von mindestens 8 · FEHLER');
  }
  stdout.writeln(fehler == 0 ? 'BELEGFOTOS OK ($bilder Bilder)' : 'BELEGFOTOS FEHLER ($fehler)');
  exitCode = fehler == 0 ? 0 : 1;
}

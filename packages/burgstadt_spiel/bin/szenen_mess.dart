// Szenenmessung (P0-AUTOR-04, HZ-12): Bildkosten je Arbeitsschritt in vier festen Spielszenen.
// Aufruf aus packages/burgstadt_spiel: dart run bin/szenen_mess.dart [breite höhe] [--welt BxH] [--bilder N] [--json <pfad>] [--probe <pfad>]
// Schritte aus Spiel.zeichneBereich (lib/src/spiel.dart) einzeln gemessen, Kamera und Sitzung wie Erkundung.zeichneWelt.
// Kamerawahl aus bin/belegfotos.dart übernommen. lib/ bleibt unverändert.

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:burgstadt_spiel/src/spuren_geometrie.dart';
import 'package:pixel_engine/pixel_engine.dart';

const _aufwaermen = 60;
const _schritt = 1 / 30; // Simulationsschritt je Bild wie im Spiel
const _kopfHoehe = 1.62; // Kamerahöhe wie Erkundung.zeichneWelt
const _mindestSicht = 2.5;
const _mitteMindestStadt = 6.0;
const _bildStrahlen = [-0.8, -0.53, -0.27, 0.0, 0.27, 0.53, 0.8];

typedef _Richt = ({double yaw, double min, double mittel, double wert});
typedef _Blick = ({String marke, double x, double z, double yaw, double min, double mittel});
typedef _Szene = ({String name, Bereich bereich, double x, double z, double yaw, String marke});

// ------------------------------------------------------------ Kamerawahl (aus bin/belegfotos.dart)

/// Freie Sichtweite ab (x, z) in Richtung [yaw] bis zur ersten nicht begehbaren Kachel.
double _sichtweite(Bereich b, double x, double z, double yaw, {double max = 14}) {
  final dx = math.cos(yaw), dz = math.sin(yaw);
  for (var t = 0.1; t <= max; t += 0.1) {
    if (!b.begehbar(((x + dx * t) / kKachel).floor(), ((z + dz * t) / kKachel).floor())) return t - 0.1;
  }
  return max;
}

/// Beste Blickrichtung (16 Richtungen): kleinste Bildsicht >= mindest, Mittelstrahl >= mitteMindest.
_Richt? _besterBlick(Bereich b, double x, double z, double bevorzugt, double mindest, double mitteMindest) {
  _Richt? beste;
  for (var k = 0; k < 16; k++) {
    final yaw = k / 8 * math.pi;
    final s = [for (final d in _bildStrahlen) _sichtweite(b, x, z, yaw + d)];
    final mn = s.reduce(math.min), mt = s.reduce((a, c) => a + c) / s.length;
    if (mn < mindest || _sichtweite(b, x, z, yaw) < mitteMindest) continue;
    final wert = mt + 0.01 * math.cos(yaw - bevorzugt);
    if (beste == null || wert > beste.wert) beste = (yaw: yaw, min: mn, mittel: mt, wert: wert);
  }
  return beste;
}

/// Raster 0,25 m bis 2 m um (x0, z0): Standort x, Standort z, Abstand zur Mitte.
Iterable<(double, double, double)> _raster(double x0, double z0) sync* {
  for (var ox = -2.0; ox <= 2.0 + 1e-9; ox += 0.25) {
    for (var oz = -2.0; oz <= 2.0 + 1e-9; oz += 0.25) {
      final d = math.sqrt(ox * ox + oz * oz);
      if (d <= 2.0 + 1e-9) yield (x0 + ox, z0 + oz, d);
    }
  }
}

/// Blick vor einer Haustür (stadtBlick aus belegfotos.dart).
_Blick? _stadtBlick(Bereich b, String marke) {
  final (tx, tz) = b.marken[marke]!;
  final (px, pz) = b.markePos(marke);
  for (final (dx, dz) in const [(0, -1), (0, 1), (-1, 0), (1, 0)]) {
    if (b.dingAn(tx - dx, tz - dz)?.legende.art != KachelArt.tuer) continue;
    final bevorzugt = math.atan2(dz.toDouble(), dx.toDouble());
    _Blick? beste;
    for (final (x, z, d) in _raster(px, pz)) {
      final ox = x - px, oz = z - pz;
      if (d < 1.0 - 1e-9 || d > 2.0 + 1e-9 || ox * dx + oz * dz < 0 || !b.frei(x, z)) continue;
      final r = _besterBlick(b, x, z, bevorzugt, _mindestSicht, _mitteMindestStadt);
      if (r != null && (beste == null || r.mittel > beste.mittel)) beste = (marke: marke, x: x, z: z, yaw: r.yaw, min: r.min, mittel: r.mittel);
    }
    return beste;
  }
  return null;
}

/// Blick vom Ankunftspunkt nahe der Marke (innenBlick aus belegfotos.dart; hier auch für den Burghof).
_Blick? _ankunftBlick(Bereich b, String marke) {
  final (mx, mz) = b.markePos(marke);
  _Blick? beste;
  var bestAbstand = double.infinity;
  for (final (x, z, abstand) in _raster(mx, mz)) {
    if (abstand > bestAbstand + 1e-9 || !b.frei(x, z)) continue;
    final mitte = math.atan2(b.tiefe * kKachel / 2 - z, b.breite * kKachel / 2 - x);
    final r = _besterBlick(b, x, z, mitte, _mindestSicht, 0);
    if (r != null && (beste == null || abstand < bestAbstand - 1e-9 || r.mittel > beste.mittel)) {
      beste = (marke: marke, x: x, z: z, yaw: r.yaw, min: r.min, mittel: r.mittel);
      bestAbstand = abstand;
    }
  }
  return beste;
}

/// Nächste begehbare Stelle um (x0, z0).
(double, double)? _naechsterFreier(Bereich b, double x0, double z0) {
  (double, double)? beste;
  var bestAbstand = double.infinity;
  for (final (x, z, a) in _raster(x0, z0)) {
    if (a < bestAbstand - 1e-9 && b.frei(x, z)) {
      bestAbstand = a;
      beste = (x, z);
    }
  }
  return beste;
}

double _abstand(double ax, double az, double bx, double bz) => math.sqrt((ax - bx) * (ax - bx) + (az - bz) * (az - bz));

// ------------------------------------------------------------ Messung

/// Ein Bild: Zeiten in Mikrosekunden und Zählwerte aus renderer.stats.
class _Bild {
  int himmel = 0, meshes = 0, sprites = 0, fledermaeuse = 0, rgba = 0, filter = 0, spurenMesh = 0;
  int meshesG = 0, meshesE = 0, dreieckeG = 0, dreieckeE = 0, spritesG = 0, pixel = 0;

  /// Summe der Schritte 1–4 und 6 (Kosten je Weltpixel).
  int get bild => himmel + meshes + sprites + fledermaeuse + rgba;
}

/// Misst die Schritte von Spiel.zeichneBereich je Bild; die Simulation läuft ungemessen weiter.
class _Messer {
  _Messer(this.spiel, this.s, this.sz, this.r, this.buf, this.rgba, this.spurenMesh)
      : g = spiel.geometrie(sz.bereich.id),
        fled = sz.bereich.id == 'stadt' ? Fledermaeuse(sz.bereich) : null {
    // Nebel und Fackellicht wie Spiel.zeichneBereich und Erkundung.zeichneWelt
    r.fogStart = sz.bereich.innen ? 3 : 8;
    r.fogEnd = sz.bereich.innen ? 20 : 46;
    r.groundFog = sz.bereich.innen ? 0 : 0.25;
    r.flashStrength = 0.9;
  }

  final Spiel spiel;
  final Fallsitzung s;
  final _Szene sz;
  final Renderer r;
  final PixelBuffer buf;
  final Uint8List rgba;
  final Mesh? spurenMesh;
  final BereichGeometrie g;
  final Fledermaeuse? fled;
  final _sw = Stopwatch();

  /// Dauer von [tu] in Mikrosekunden.
  int _zeit(void Function() tu) {
    _sw..reset()..start();
    tu();
    return (_sw..stop()).elapsedMicroseconds;
  }

  _Bild bild(double yaw, {bool blick = false}) {
    final z = _Bild();
    // Ungemessen: Simulation weiter, Detektiv am Kamerapunkt (wie Erkundung.tick)
    s.tick(_schritt);
    s.position(sz.bereich.id, sz.x, sz.z, yaw, 'stehen', _schritt);
    fled?.tick(_schritt);
    final c = r.camera..x = sz.x..z = sz.z..y = _kopfHoehe..yaw = yaw..pitch = 0;
    // 1. Löschen bzw. Himmel
    z.himmel = _zeit(() {
      r.begin();
      if (sz.bereich.innen) { buf.clear(Pal.black); } else { r.drawSky(); }
    });
    // 2. Meshes des Bereichs
    z.meshes = _zeit(() { for (final m in g.meshes) { r.drawMesh(m); } });
    // 3. Figuren als Sprites
    z.sprites = _zeit(() {
      for (final f in s.sim.figuren.values) {
        if (f.id == s.ich || f.bereich != sz.bereich.id) continue;
        final sprite = s.figuren.bild(f.id, f.animation, f.animZeit, FigurenLager.richtung(f.yaw, f.x, f.z, c.x, c.z));
        if (sprite == null) continue;
        final (w, k) = g.licht(f.x, 1.0, f.z);
        r.drawSprite(sprite, f.x, 0, f.z, warm: w, cold: k);
      }
    });
    // 4. Fledermäuse (nur Oberstadt)
    final fl = fled;
    z.fledermaeuse = fl == null ? 0 : _zeit(() => fl.zeichne(r));
    final st = r.stats;
    z.meshesG = st.meshesDrawn; z.meshesE = st.meshesSubmitted;
    z.dreieckeG = st.trianglesDrawn; z.dreieckeE = st.trianglesSubmitted;
    z.spritesG = st.spritesDrawn; z.pixel = st.pixelsWritten;
    if (!blick) {
      // 6. Umwandlung nach RGBA in den vorhandenen Puffer
      z.rgba = _zeit(() => buf.toRgba(rgba));
    } else {
      // 5. Detektivblick: Welt entsättigen, dann Spuren darüber (wie Spiel.zeichneBereich)
      z.filter = _zeit(() { final col = buf.color; for (var i = 0; i < col.length; i++) { col[i] = blickFilter[col[i]]; } });
      final m = spurenMesh;
      if (m != null) {
        final alt = r.ambientCold;
        r.ambientCold = 0.6;
        z.spurenMesh = _zeit(() => r.drawMesh(m));
        r.ambientCold = alt;
      }
    }
    return z;
  }
}

// ------------------------------------------------------------ Auswertung

Never _abbrechen(String meldung) {
  stderr.writeln(meldung);
  exit(1);
}

double _mittel(Iterable<num> xs) {
  final l = xs.toList();
  return l.fold<double>(0, (a, b) => a + b) / l.length;
}

String _f(double x, [int n = 2]) => x.toStringAsFixed(n);

/// Mittelwerte einer Bildfolge: Zeiten in ms, Zählwerte je Bild, Überdeckung und ns je Weltpixel.
Map<String, double> _kenn(List<_Bild> liste, int n) {
  double us(num Function(_Bild) f) => _mittel(liste.map(f));
  final bild = us((z) => z.bild);
  return {
    'bildMs': bild / 1000,
    'himmelMs': us((z) => z.himmel) / 1000,
    'meshesMs': us((z) => z.meshes) / 1000,
    'spritesMs': us((z) => z.sprites) / 1000,
    'fledermaeuseMs': us((z) => z.fledermaeuse) / 1000,
    'rgbaMs': us((z) => z.rgba) / 1000,
    'meshesGezeichnet': us((z) => z.meshesG),
    'meshesEingereicht': us((z) => z.meshesE),
    'dreieckeGezeichnet': us((z) => z.dreieckeG),
    'dreieckeEingereicht': us((z) => z.dreieckeE),
    'spritesGezeichnet': us((z) => z.spritesG),
    'ueberdeckung': us((z) => z.pixel) / n,
    'nsProPixel': bild * 1000 / n,
  };
}

/// Kleinste Quadrate ohne Achsenabschnitt: Zeit (µs) = a·Dreiecke + b'·Pixel. Liefert a (µs/Dreieck), b (ns/Pixel).
(double, double) _regression(List<_Bild> liste) {
  var s11 = 0.0, s12 = 0.0, s22 = 0.0, r1 = 0.0, r2 = 0.0;
  for (final z in liste) {
    final x1 = z.dreieckeG.toDouble(), x2 = z.pixel.toDouble(), y = z.meshes.toDouble();
    s11 += x1 * x1; s12 += x1 * x2; s22 += x2 * x2;
    r1 += x1 * y; r2 += x2 * y;
  }
  final det = s11 * s22 - s12 * s12;
  return ((r1 * s22 - r2 * s12) / det, (s11 * r2 - s12 * r1) / det * 1000);
}

void main(List<String> args) {
  var breite = 1280, hoehe = 720, bilder = 120;
  int? weltB, weltH;
  String? jsonPfad, probePfad;
  final zahlen = <int>[];
  for (var i = 0; i < args.length; i++) {
    final a = args[i];
    if (a == '--welt') {
      final t = args[++i].split('x');
      weltB = int.parse(t[0]);
      weltH = int.parse(t[1]);
    } else if (a == '--bilder') {
      bilder = int.parse(args[++i]);
    } else if (a == '--json') {
      jsonPfad = args[++i];
    } else if (a == '--probe') {
      probePfad = args[++i];
    } else {
      zahlen.add(int.parse(a));
    }
  }
  if (zahlen.length == 2) { breite = zahlen[0]; hoehe = zahlen[1]; }
  else if (zahlen.isNotEmpty) { _abbrechen('Aufruf: dart run bin/szenen_mess.dart [breite höhe] [--welt BxH] [--bilder N] [--json <pfad>] [--probe <pfad>]'); }

  // Welt und Fall wie in bin/leistung.dart: Phase 2, Oberstadt offen, Figuren und Bewohner da
  final spiel = Spiel()..groesse(breite, hoehe);
  ladeAusRepo(spiel);
  spiel.besetzung = 20;
  final s = spiel.starteFall() ?? _abbrechen('Kein Fall geladen');
  s.fall.phase = 2;
  s.fall.uhr = 100;
  spiel.wechsle(Erkundung(sitzung: s));
  s.figuren.alleBacken(); // Sprites vorab brennen, damit die Sprite-Zeit kein Brennen enthält

  // Zeichenziel: Welt des Spiels, oder eigener Puffer bei --welt (Sichtfeld wie Spiel._sichtfeld)
  final PixelBuffer buf;
  final Renderer r;
  if (weltB == null) {
    buf = spiel.welt;
    r = spiel.renderer;
  } else {
    buf = PixelBuffer(weltB, weltH!);
    r = Renderer(buf, spiel.licht, spiel.texturen);
    final fovX = spiel.optionen.sichtfeldGrad * math.pi / 180 * 1.25;
    var fovY = spiel.optionen.sichtfeldGrad * math.pi / 180;
    final ausX = 2 * math.atan(math.tan(fovX / 2) / (buf.width / buf.height));
    if (ausX > fovY) fovY = math.min(ausX, 100 * math.pi / 180);
    r.camera.fovY = fovY;
  }

  // Die vier festen Szenen
  final stadt = spiel.stadt.bereiche['stadt']!;
  final (bx, bz) = stadt.markePos('b');
  final (mx, mz) = _naechsterFreier(stadt, bx, bz) ?? _abbrechen('Marke b in stadt: kein freier Standort');
  // 1. Marktplatz: Marke b, Startblick in die längste freie Gasse (bis 60 m)
  var langYaw = 0.0, langSicht = -1.0;
  for (var k = 0; k < 16; k++) {
    final yaw = k / 8 * math.pi, t = _sichtweite(stadt, mx, mz, yaw, max: 60);
    if (t > langSicht) { langSicht = t; langYaw = yaw; }
  }
  final szenen = <_Szene>[(name: 'Marktplatz', bereich: stadt, x: mx, z: mz, yaw: langYaw, marke: 'b')];
  // 2. Zweite Stelle: Haustür-Marke mit dem weitesten Blick, mindestens 5 m vom Marktplatz
  _Blick? zweite;
  for (final m in stadt.marken.keys.toList()..sort()) {
    final k = m.startsWith('vor-') ? _stadtBlick(stadt, m) : null;
    if (k == null || _abstand(k.x, k.z, mx, mz) < 5) continue;
    if (zweite == null || k.mittel > zweite.mittel) zweite = k;
  }
  final z2 = zweite ?? _abbrechen('Keine Oberstadt-Marke mit freiem Blick');
  szenen.add((name: 'Oberstadt zweite Stelle', bereich: stadt, x: z2.x, z: z2.z, yaw: z2.yaw, marke: z2.marke));
  // 3. Größter Fall-Ort aus fallorte.json (Rasterfläche Breite × Tiefe)
  final fallDatei = jsonDecode(File('${findeRepoWurzel()!}/packages/burgstadt_core/data/innenraeume/fallorte.json').readAsStringSync()) as Map;
  Bereich? gross;
  for (final e in fallDatei['bereiche'] as List) {
    final b = spiel.stadt.bereiche[(e as Map)['id'] as String];
    if (b != null && (gross == null || b.breite * b.tiefe > gross.breite * gross.tiefe)) gross = b;
  }
  final innen = gross ?? _abbrechen('Kein Fall-Ort in fallorte.json');
  // Ankunftsmarke: Tür aus der Oberstadt in den Raum (wie belegfotos.dart)
  var marke = stadt.dinge.where((d) => d.legende.art == KachelArt.tuer && d.legende.ziel == innen.id && d.legende.zielMarke != null)
      .map((d) => d.legende.zielMarke!).firstOrNull ?? 't';
  if (!innen.marken.containsKey(marke)) marke = (innen.marken.keys.toList()..sort()).first;
  final ki = _ankunftBlick(innen, marke) ?? _abbrechen('Kein Blick im Raum ${innen.id}');
  szenen.add((name: 'Innenraum ${innen.name}', bereich: innen, x: ki.x, z: ki.z, yaw: ki.yaw, marke: marke));
  // 4. Burghof: Ankunftsmarke b am Burgtor
  final hof = spiel.stadt.bereiche['hof'] ?? _abbrechen('Bereich hof fehlt');
  final hm = hof.marken.containsKey('b') ? 'b' : (hof.marken.keys.toList()..sort()).first;
  final kh = _ankunftBlick(hof, hm) ?? _abbrechen('Kein Blick im Burghof');
  szenen.add((name: 'Burghof', bereich: hof, x: kh.x, z: kh.z, yaw: kh.yaw, marke: hm));

  final welt = '${buf.width}x${buf.height}', n = buf.width * buf.height;
  final rgba = Uint8List(n * 4);
  stdout.writeln('Sitzung: 20 Rollen · Bewohner ${s.sim.bewohner.length} · Phase ${s.fall.phase} · Welt $welt'
      '${weltB == null ? ' (Qualität ${spiel.optionen.qualitaet.name})' : ' (erzwungen)'} · $bilder Bilder je Szene · Aufwärmen $_aufwaermen');
  final alle = <_Bild>[];
  final szenenJson = <Map<String, Object?>>[];
  for (final (idx, sz) in szenen.indexed) {
    final spurMesh = baueSpurenMesh(spiel.spurenFuer(s), sz.bereich.id, s.fall.phase, 'detektiv', TexturId.values.length);
    final m = _Messer(spiel, s, sz, r, buf, rgba, spurMesh);
    double winkel(int i) => sz.yaw + 2 * math.pi * (i % bilder) / bilder;
    for (var i = 0; i < _aufwaermen; i++) {
      m.bild(winkel(i));
    }
    // Auch der Blickpfad läuft vorab, sonst misst die Blickzeile das JIT mit
    m.bild(sz.yaw, blick: true);
    m.bild(sz.yaw, blick: true);
    final liste = <_Bild>[];
    for (var i = 0; i < bilder; i++) {
      liste.add(m.bild(winkel(i)));
      if (idx == 0 && i == 0 && probePfad != null) {
        File(probePfad).parent.createSync(recursive: true);
        File(probePfad).writeAsBytesSync(encodePngRgba(buf.width, buf.height, rgba, zlib: zlib.encode));
        stdout.writeln('PROBE $probePfad');
      }
    }
    final blick = m.bild(sz.yaw, blick: true);
    alle.addAll(liste);
    final k = _kenn(liste, n);
    final filterMs = blick.filter / 1000, spurMs = blick.spurenMesh / 1000;
    stdout.writeln('SZENE ${sz.name} · Welt $welt · Bild ${_f(k['bildMs']!)} · Himmel ${_f(k['himmelMs']!)} · '
        'Meshes ${_f(k['meshesMs']!)} · Sprites ${_f(k['spritesMs']!)} · Fledermäuse ${_f(k['fledermaeuseMs']!)} · '
        'RGBA ${_f(k['rgbaMs']!)} · Blickfilter ${_f(filterMs + spurMs)} · '
        'Meshes ${_f(k['meshesGezeichnet']!, 1)}/${_f(k['meshesEingereicht']!, 1)} · '
        'Dreiecke ${_f(k['dreieckeGezeichnet']!, 0)}/${_f(k['dreieckeEingereicht']!, 0)} · '
        'Überdeckung ${_f(k['ueberdeckung']!)} · ns/Pixel ${_f(k['nsProPixel']!, 1)}');
    szenenJson.add({'name': sz.name, 'marke': sz.marke, 'x': sz.x, 'z': sz.z, 'yaw0': sz.yaw, ...k, 'blickfilterMs': filterMs, 'spurenMeshMs': spurMs});
  }

  final kG = _kenn(alle, n);
  final (a, bNs) = _regression(alle);
  stdout.writeln('SZENENMESSUNG Mittel Bild ${_f(kG['bildMs']!)} · ns/Pixel ${_f(kG['nsProPixel']!, 1)} · '
      'Überdeckung ${_f(kG['ueberdeckung']!)} · a ${_f(a)} · b ${_f(bNs)}');
  if (jsonPfad != null) {
    File(jsonPfad).parent.createSync(recursive: true);
    File(jsonPfad).writeAsStringSync(JsonEncoder.withIndent('  ').convert({
      'welt': {'b': buf.width, 'h': buf.height, 'erzwungen': weltB != null},
      'bilder': bilder,
      'aufwaermen': _aufwaermen,
      'anzahlBilder': alle.length,
      'szenen': szenenJson,
      'gesamt': {...kG, 'a_us_pro_dreieck': a, 'b_ns_pro_pixel': bNs},
    }));
  }
}

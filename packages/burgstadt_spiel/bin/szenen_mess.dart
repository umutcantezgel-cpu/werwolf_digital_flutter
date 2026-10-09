// Szenenmessung (P0-AUTOR-04, HZ-12; REP-03 Szenenmessung v2): Bildkosten je Arbeitsschritt in fünf
// festen Spielszenen, je Szene R = 3 Läufe; je Schritt der Median der Läufe, Spanne der Bildzeit in %.
// Zeit: Prozessorzeit des Threads (Linux, bin/mess/cpu_uhr.dart), sonst Wanduhr.
// Aufruf aus packages/burgstadt_spiel:
//   dart run bin/szenen_mess.dart [breite höhe] [--welt BxH] [--bilder N] [--handylicht an|aus] [--json <pfad>] [--probe <pfad>]
// Schritte aus Spiel.zeichneBereich (lib/src/spiel.dart) einzeln gemessen, Kamera und Sitzung wie Erkundung.zeichneWelt.
// Szenenwahl in bin/mess/szenen.dart. lib/ bleibt unverändert.

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:burgstadt_spiel/src/spuren_geometrie.dart';
import 'package:pixel_engine/pixel_engine.dart';

import 'mess/cpu_uhr.dart';
import 'mess/szenen.dart';

const _aufwaermen = 60;
const _laeufe = 3; // R: jede Szene R-mal komplett gemessen
const _schritt = 1 / 30; // Simulationsschritt je Bild wie im Spiel
const _kopfHoehe = 1.62; // Kamerahöhe wie Erkundung.zeichneWelt

/// Ein Bild: Zeiten in Mikrosekunden und Zählwerte aus renderer.stats.
class _Bild {
  int himmel = 0, meshes = 0, sprites = 0, fledermaeuse = 0, rgba = 0, filter = 0, spurenMesh = 0;
  int meshesG = 0, meshesE = 0, dreieckeG = 0, dreieckeE = 0, spritesG = 0, pixel = 0;

  /// Summe der Schritte 1–4 und 6 (Kosten je Weltpixel).
  int get bild => himmel + meshes + sprites + fledermaeuse + rgba;
}

/// Zeitmessung in Mikrosekunden: Prozessorzeit des Threads, sonst Wanduhr.
class _Uhr {
  _Uhr(this._cpu);
  final double Function()? _cpu;
  final Stopwatch _sw = Stopwatch();
  String get name => _cpu == null ? 'Wanduhr' : 'Thread-CPU';

  /// Dauer von [tu] in Mikrosekunden.
  int messe(void Function() tu) {
    final cpu = _cpu;
    if (cpu == null) {
      _sw..reset()..start();
      tu();
      return (_sw..stop()).elapsedMicroseconds;
    }
    final t0 = cpu();
    tu();
    return ((cpu() - t0) * 1000).round();
  }
}

/// Misst die Schritte von Spiel.zeichneBereich je Bild; die Simulation läuft ungemessen weiter.
class _Messer {
  _Messer(this.spiel, this.s, this.sz, this.r, this.buf, this.rgba, this.spurenMesh, this.uhr, bool licht)
      : g = spiel.geometrie(sz.bereich.id),
        fled = sz.bereich.id == 'stadt' ? Fledermaeuse(sz.bereich) : null {
    // Nebel und Fackellicht wie Spiel.zeichneBereich und Erkundung.zeichneWelt; Handylicht per --handylicht
    r.fogStart = sz.bereich.innen ? 3 : 8;
    r.fogEnd = sz.bereich.innen ? 20 : 46;
    r.groundFog = sz.bereich.innen ? 0 : 0.25;
    r.flashStrength = licht ? 0.9 : 0.0;
  }

  final Spiel spiel;
  final Fallsitzung s;
  final Szene sz;
  final Renderer r;
  final PixelBuffer buf;
  final Uint8List rgba;
  final Mesh? spurenMesh;
  final _Uhr uhr;
  final BereichGeometrie g;
  final Fledermaeuse? fled;

  /// Ein Sprite an (x, z) mit Blick [yaw]: Richtung zur Kamera, Licht am Standort wie Spiel.zeichneBereich.
  void _figur(String id, String anim, double t, double yaw, double x, double z) {
    final c = r.camera;
    final bild = s.figuren.bild(id, anim, t, FigurenLager.richtung(yaw, x, z, c.x, c.z));
    if (bild == null) return;
    final (w, k) = g.licht(x, 1.0, z);
    r.drawSprite(bild, x, 0, z, warm: w, cold: k);
  }

  _Bild bild(double yaw, {bool blick = false}) {
    final z = _Bild();
    // Ungemessen: Simulation weiter, Detektiv am Kamerapunkt (wie Erkundung.tick)
    s.tick(_schritt);
    s.position(sz.bereich.id, sz.x, sz.z, yaw, 'stehen', _schritt);
    fled?.tick(_schritt);
    r.camera..x = sz.x..z = sz.z..y = _kopfHoehe..yaw = yaw..pitch = 0;
    // 1. Löschen bzw. Himmel
    z.himmel = uhr.messe(() {
      r.begin();
      if (sz.bereich.innen) { buf.clear(Pal.black); } else { r.drawSky(); }
    });
    // 2. Meshes des Bereichs
    z.meshes = uhr.messe(() { for (final m in g.meshes) { r.drawMesh(m); } });
    // 3. Figuren als Sprites: Figurenszene feste Plätze, sonst die Figuren der Simulation
    z.sprites = uhr.messe(() {
      final feste = sz.figuren;
      if (feste != null) {
        for (final p in feste) { _figur(p.figur, 'stehen', 0, p.yaw, p.x, p.z); }
        return;
      }
      for (final f in s.sim.figuren.values) {
        if (f.id == s.ich || f.bereich != sz.bereich.id) continue;
        _figur(f.id, f.animation, f.animZeit, f.yaw, f.x, f.z);
      }
    });
    // 4. Fledermäuse (nur Oberstadt)
    final fl = fled;
    z.fledermaeuse = fl == null ? 0 : uhr.messe(() => fl.zeichne(r));
    final st = r.stats;
    z.meshesG = st.meshesDrawn; z.meshesE = st.meshesSubmitted;
    z.dreieckeG = st.trianglesDrawn; z.dreieckeE = st.trianglesSubmitted;
    z.spritesG = st.spritesDrawn; z.pixel = st.pixelsWritten;
    if (!blick) {
      // 6. Umwandlung nach RGBA in den vorhandenen Puffer
      z.rgba = uhr.messe(() => buf.toRgba(rgba));
    } else {
      // 5. Detektivblick: Welt entsättigen, dann Spuren darüber (wie Spiel.zeichneBereich)
      z.filter = uhr.messe(() { final col = buf.color; for (var i = 0; i < col.length; i++) { col[i] = blickFilter[col[i]]; } });
      final m = spurenMesh;
      if (m != null) {
        final alt = r.ambientCold;
        r.ambientCold = 0.6;
        z.spurenMesh = uhr.messe(() => r.drawMesh(m));
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

/// Median; bei gerader Anzahl das Mittel der beiden mittleren Werte.
double _median(List<double> xs) {
  final s = [...xs]..sort();
  final m = s.length ~/ 2;
  return s.length.isOdd ? s[m] : (s[m - 1] + s[m]) / 2;
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

/// Je Kennzahl der Median über die Läufe einer Szene.
Map<String, double> _medianKarte(List<Map<String, double>> laeufe) =>
    {for (final k in laeufe.first.keys) k: _median([for (final l in laeufe) l[k]!])};

/// Löst A·x = b (3×3) mit Gauß und Teilpivotierung; bricht bei singulärer Matrix ab.
List<double> _gauss(List<List<double>> a, List<double> b) {
  const n = 3;
  final m = [for (var i = 0; i < n; i++) [...a[i], b[i]]];
  for (var c = 0; c < n; c++) {
    var p = c;
    for (var r = c + 1; r < n; r++) {
      if (m[r][c].abs() > m[p][c].abs()) p = r;
    }
    if (m[p][c].abs() < 1e-12) _abbrechen('Regression singulär (Spalte $c)');
    final tausch = m[c];
    m[c] = m[p];
    m[p] = tausch;
    for (var r = c + 1; r < n; r++) {
      final f = m[r][c] / m[c][c];
      for (var k = c; k <= n; k++) {
        m[r][k] -= f * m[c][k];
      }
    }
  }
  final x = List.filled(n, 0.0);
  for (var r = n - 1; r >= 0; r--) {
    var s = m[r][n];
    for (var k = r + 1; k < n; k++) {
      s -= m[r][k] * x[k];
    }
    x[r] = s / m[r][r];
  }
  return x;
}

/// Kleinste Quadrate ohne Achsenabschnitt: Meshes-Zeit (µs) = a·Dreiecke + b'·Pixel + c·Meshes
/// (je Bild). Normalgleichungen 3×3 mit Spaltenskalierung. Liefert a (µs/Dreieck), b (ns/Pixel),
/// c (µs/Mesh) und R² = 1 − Σ(Rest²)/Σ(y − ȳ)², zentriert, weil der unzentrierte Wert ohne
/// Achsenabschnitt stets nahe 1 läge.
(double, double, double, double) _regression(List<_Bild> liste) {
  final x = [for (final z in liste) [z.dreieckeG.toDouble(), z.pixel.toDouble(), z.meshesG.toDouble()]];
  final y = [for (final z in liste) z.meshes.toDouble()];
  final skal = [for (var j = 0; j < 3; j++) math.sqrt(x.fold(0.0, (s, r) => s + r[j] * r[j]))];
  final ata = [for (var j = 0; j < 3; j++) List.filled(3, 0.0)];
  final atb = List.filled(3, 0.0);
  for (var i = 0; i < x.length; i++) {
    final u = [for (var j = 0; j < 3; j++) x[i][j] / skal[j]];
    for (var j = 0; j < 3; j++) {
      atb[j] += u[j] * y[i];
      for (var k = 0; k < 3; k++) {
        ata[j][k] += u[j] * u[k];
      }
    }
  }
  final g = _gauss(ata, atb);
  final beta = [for (var j = 0; j < 3; j++) g[j] / skal[j]];
  final mittel = _mittel(y);
  var rest = 0.0, streu = 0.0;
  for (var i = 0; i < x.length; i++) {
    final rechnung = beta[0] * x[i][0] + beta[1] * x[i][1] + beta[2] * x[i][2];
    rest += (y[i] - rechnung) * (y[i] - rechnung);
    streu += (y[i] - mittel) * (y[i] - mittel);
  }
  return (beta[0], beta[1] * 1000, beta[2], 1 - rest / streu);
}

void main(List<String> args) {
  var breite = 1280, hoehe = 720, bilder = 120, licht = true;
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
    } else if (a == '--handylicht') {
      final wert = args[++i];
      if (wert != 'an' && wert != 'aus') _abbrechen('--handylicht erwartet an oder aus');
      licht = wert == 'an';
    } else if (a == '--json') {
      jsonPfad = args[++i];
    } else if (a == '--probe') {
      probePfad = args[++i];
    } else {
      zahlen.add(int.parse(a));
    }
  }
  if (zahlen.length == 2) { breite = zahlen[0]; hoehe = zahlen[1]; }
  else if (zahlen.isNotEmpty) { _abbrechen('Aufruf: dart run bin/szenen_mess.dart [breite höhe] [--welt BxH] [--bilder N] [--handylicht an|aus] [--json <pfad>] [--probe <pfad>]'); }

  final cpuUhr = threadCpuUhr();
  final uhr = _Uhr(cpuUhr);
  // Welt und Fall wie in bin/leistung.dart: Phase 2, Oberstadt offen, Figuren und Bewohner da
  final spiel = Spiel()..groesse(breite, hoehe);
  ladeAusRepo(spiel);
  spiel.besetzung = 20;
  final s = spiel.starteFall() ?? _abbrechen('Kein Fall geladen');
  s.fall.phase = 2;
  s.fall.uhr = 100;
  spiel.wechsle(Erkundung(sitzung: s));
  s.figuren.alleBacken(); // Sprites vorab brennen (auch die der Figurenszene), damit die Sprite-Zeit kein Brennen enthält

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

  // Die fünf festen Szenen; Figurenszene mit den ersten acht Rollenkarten der Sitzung
  final halbX = math.atan(math.tan(r.camera.fovY / 2) * buf.width / buf.height);
  final figurIds = [for (final id in s.fall.rollen) if (s.figuren.karten.containsKey(id)) id].take(figurenZahl).toList();
  if (figurIds.length < figurenZahl) _abbrechen('Figurenszene: ${figurIds.length} Rollenkarten statt $figurenZahl');
  late final List<Szene> szenen;
  try {
    szenen = waehleSzenen(spiel, figurIds, halbX);
  } on StateError catch (e) {
    _abbrechen(e.message);
  }
  // Figurenszene: alle Figuren gebrannt (alleBacken oben), vor der Messung geprüft
  final fest = szenen.firstWhere((sz) => sz.figuren != null);
  final ohneBild = [for (final p in fest.figuren!) if (s.figuren.bild(p.figur, 'stehen', 0, FigurenLager.richtung(p.yaw, p.x, p.z, fest.x, fest.z)) == null) p.figur];
  if (ohneBild.isNotEmpty) _abbrechen('Figuren ohne Brand: ${ohneBild.join(', ')}');

  final welt = '${buf.width}x${buf.height}', n = buf.width * buf.height;
  final rgba = Uint8List(n * 4);
  final spurMeshes = [for (final sz in szenen) baueSpurenMesh(spiel.spurenFuer(s), sz.bereich.id, s.fall.phase, 'detektiv', TexturId.values.length)];
  stdout.writeln('Sitzung: 20 Rollen · Bewohner ${s.sim.bewohner.length} · Phase ${s.fall.phase} · Welt $welt'
      '${weltB == null ? ' (Qualität ${spiel.optionen.qualitaet.name})' : ' (erzwungen)'} · $bilder Bilder je Szene · Aufwärmen $_aufwaermen · '
      '$_laeufe Läufe je Szene · Handylicht ${licht ? 'an' : 'aus'} · Uhr ${uhr.name}');
  if (cpuUhr == null) stdout.writeln('Hinweis: keine Prozessorzeit-Uhr (kein Linux oder libc nicht ladbar), Wanduhr statt Thread-CPU.');
  stdout.writeln('Figuren ${fest.figuren!.length} · Abstand m ${[for (final p in fest.figuren!) _f(abstand(p.x, p.z, fest.x, fest.z), 1)].join(' · ')}');

  // Messung: je Lauf alle Szenen (Läufe außen, damit Lastschwankungen auf alle Szenen verteilt wirken)
  final alle = <_Bild>[];
  final laeufe = [for (final _ in szenen) <Map<String, double>>[]];
  for (var lauf = 0; lauf < _laeufe; lauf++) {
    for (final (idx, sz) in szenen.indexed) {
      final m = _Messer(spiel, s, sz, r, buf, rgba, spurMeshes[idx], uhr, licht);
      // Festes Bild (Figurenszene) oder Umlauf um 360°
      double winkel(int i) => sz.figuren != null ? sz.yaw : sz.yaw + 2 * math.pi * (i % bilder) / bilder;
      for (var i = 0; i < _aufwaermen; i++) {
        m.bild(winkel(i));
      }
      // Auch der Blickpfad läuft vorab, sonst misst die Blickzeile das JIT mit
      m.bild(sz.yaw, blick: true);
      m.bild(sz.yaw, blick: true);
      final liste = <_Bild>[];
      for (var i = 0; i < bilder; i++) {
        liste.add(m.bild(winkel(i)));
        if (lauf == 0 && idx == 0 && i == 0 && probePfad != null) {
          File(probePfad).parent.createSync(recursive: true);
          File(probePfad).writeAsBytesSync(encodePngRgba(buf.width, buf.height, rgba, zlib: zlib.encode));
          stdout.writeln('PROBE $probePfad');
        }
      }
      final blick = m.bild(sz.yaw, blick: true);
      alle.addAll(liste);
      laeufe[idx].add({
        ..._kenn(liste, n),
        'blickfilterMs': (blick.filter + blick.spurenMesh) / 1000,
        'spurenMeshMs': blick.spurenMesh / 1000,
      });
    }
  }

  // Auswertung je Szene: Median je Schritt über die Läufe, Spanne der Bildzeit in % der Bildzeit
  final mittel = <Map<String, double>>[];
  final szenenJson = <Map<String, Object?>>[];
  for (final (idx, sz) in szenen.indexed) {
    final med = _medianKarte(laeufe[idx]);
    med['bildMs'] = med['himmelMs']! + med['meshesMs']! + med['spritesMs']! + med['fledermaeuseMs']! + med['rgbaMs']!;
    med['nsProPixel'] = med['bildMs']! * 1e6 / n; // ms → ns
    final bildLauf = [for (final l in laeufe[idx]) l['bildMs']!];
    final spanne = (bildLauf.reduce(math.max) - bildLauf.reduce(math.min)) / med['bildMs']! * 100;
    mittel.add(med);
    stdout.writeln('SZENE ${sz.name} · Welt $welt · Bild ${_f(med['bildMs']!)} · Himmel ${_f(med['himmelMs']!)} · '
        'Meshes ${_f(med['meshesMs']!)} · Sprites ${_f(med['spritesMs']!)} · Fledermäuse ${_f(med['fledermaeuseMs']!)} · '
        'RGBA ${_f(med['rgbaMs']!)} · Blickfilter ${_f(med['blickfilterMs']!)} · '
        'Meshes ${_f(med['meshesGezeichnet']!, 1)}/${_f(med['meshesEingereicht']!, 1)} · '
        'Dreiecke ${_f(med['dreieckeGezeichnet']!, 0)}/${_f(med['dreieckeEingereicht']!, 0)} · '
        'Überdeckung ${_f(med['ueberdeckung']!)} · ns/Pixel ${_f(med['nsProPixel']!, 1)} · Spanne ${_f(spanne, 1)} %');
    szenenJson.add({'name': sz.name, 'marke': sz.marke, 'x': sz.x, 'z': sz.z, 'yaw0': sz.yaw, 'figuren': sz.figuren?.length,
      ...med, 'spanneProzent': spanne, 'bildMsLaeufe': bildLauf});
  }

  double mittelVon(String k) => _mittel([for (final m in mittel) m[k]!]);
  final mittelBild = mittelVon('bildMs'), nsPx = mittelBild * 1e6 / n, ueber = mittelVon('ueberdeckung');
  final (a, bNs, c, r2) = _regression(alle);
  stdout.writeln('SZENENMESSUNG v2 Mittel Bild ${_f(mittelBild)} · ns/Pixel ${_f(nsPx, 1)} · '
      'Überdeckung ${_f(ueber)} · a ${_f(a, 3)} · b ${_f(bNs)} · c ${_f(c, 3)} · R² ${_f(r2, 3)} · Uhr ${uhr.name}');
  if (jsonPfad != null) {
    File(jsonPfad).parent.createSync(recursive: true);
    File(jsonPfad).writeAsStringSync(JsonEncoder.withIndent('  ').convert({
      'welt': {'b': buf.width, 'h': buf.height, 'erzwungen': weltB != null},
      'bilder': bilder,
      'laeufe': _laeufe,
      'aufwaermen': _aufwaermen,
      'handylicht': licht,
      'uhr': uhr.name,
      'anzahlBilder': alle.length,
      'szenen': szenenJson,
      'gesamt': {'bildMs': mittelBild, 'nsProPixel': nsPx, 'ueberdeckung': ueber, 'a_us_pro_dreieck': a, 'b_ns_pro_pixel': bNs, 'c_us_pro_mesh': c, 'r2': r2},
    }));
  }
}

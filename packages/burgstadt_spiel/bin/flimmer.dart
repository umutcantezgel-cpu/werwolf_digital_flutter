import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';

import 'mess/hilfen.dart';

/// Flimmerüberschuss v2 (REP-01, HZ-03): wie viel mehr Pixelwechsel das Spielbild beim Gehen zeigt als eine
/// überabgetastete Referenz derselben Szene. Die normale Bewegung fällt dadurch heraus, jede Auflösung wird
/// gegen ihre eigene Referenz gemessen.
///
/// Je Szene K = 9 Bilder, die Kamera rückt je Bild 0,025 m in Blickrichtung (0,2 m insgesamt).
/// Testfolge: normales Rendern in der Weltgröße der Qualität bzw. `--welt BxH`.
/// Referenzfolge: dieselbe Szene in 4-facher Breite und Höhe, je 4×4-Block der häufigste Palettenindex
/// (bei Gleichstand der kleinere), dann auf die Testgröße gebracht.
/// Bodenmaske: Pixel, deren Tiefe zu einem Weltpunkt mit Höhe < 0,05 m gehört, in allen K Bildern.
/// Wechsel je Pixel: Übergänge i→i+1 mit geändertem Index. Überschuss = Ct / Cr − 1 (pixelgewichtet).
/// FERNE: dasselbe nur für Bodenpixel mit z > 6 m.
///
/// `dart run bin/flimmer.dart [breite höhe] [--qualitaet name] [--welt BxH] [--png ordner] [--selbsttest]`
/// Ohne Figuren, Handylicht aus, ohne Zeitschritt und ohne Zufall: gleiche Aufrufe, gleiche Zahlen.

const _nutzung = 'Aufruf: dart run bin/flimmer.dart [breite höhe] [--qualitaet sparsam|mittel|hoch] '
    '[--welt BxH] [--png ordner] [--selbsttest]';

/// Bilder je Szene (K) und Vorwärtsschritt je Bild (m); insgesamt 8 Schritte, also 0,2 m.
const kBilder = 9;
const schrittJeBild = 0.025;

/// Kantenlänge des Überabtastungsblocks der Referenz (4-fache Breite und Höhe).
const ueberabtastung = 4;

/// Ab dieser Tiefe (m) zählt ein Bodenpixel zur Ferne.
const fernM = 6.0;

/// Weltpunkte unterhalb dieser Höhe (m) gelten als Boden.
const bodenHoeheM = 0.05;

/// Dezimalzahl im Format `p,ppp` (Komma, drei Nachkommastellen).
String dez(double v, [int stellen = 3]) => v.toStringAsFixed(stellen).replaceAll('.', ',');

Never _abbruch(String meldung) {
  stderr.writeln('$meldung\n$_nutzung');
  exit(2);
}

/// Überschuss Ct / Cr − 1, oder null, wenn Cr = 0.
double? verhaeltnis(int ct, int cr) => cr == 0 ? null : ct / cr - 1;

/// Ein Bild der Testfolge: Palettenindizes, Tiefenpuffer (1/z, 0 = keine Geometrie) und Kameradaten.
class Bild {
  Bild(this.farben, this.tiefe, this.kamHoehe, this.cy, this.focal);

  /// Palettenindizes je Pixel (Kopie, weil der Puffer für das nächste Bild überschrieben wird).
  final Uint8List farben;
  final Float32List tiefe;
  final double kamHoehe, cy, focal;
}

/// Tiefe z (m) je Pixel, wenn der Pixel Boden ist: unterhalb des Horizonts (y > cy) und der zugehörige
/// Weltpunkt liegt tiefer als 0,05 m (hy = Kamerahöhe + (cy − (y+0.5)) / focal · z). Sonst 0.
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

/// Messszene: Name, Bereich, Standort (m), Blickrichtung (rad), Marke und Herkunft der Wahl (Ausgabe).
class Szene {
  Szene(this.name, this.bereich, this.x, this.z, this.yaw, this.marke, this.herkunft);
  final String name;
  final Bereich bereich;
  final double x, z, yaw;
  final String marke, herkunft;

  /// Freie Sicht in Blickrichtung (m), höchstens [sichtMaxM].
  double get sicht => sichtweite(bereich, x, z, yaw, max: sichtMaxM);
}

/// Szene A: Oberstadt an der Marke `b`, Blick in die längste freie Richtung.
Szene oberstadtSzene(Spiel spiel) {
  final stadt = spiel.stadt.bereiche['stadt']!;
  final (x, z) = stadt.markePos('b');
  final (yaw, _) = laengsteRichtung(stadt, x, z);
  return Szene('A-Oberstadt', stadt, x, z, yaw, 'b', 'Marke b, längste freie Richtung');
}

/// Szene B: Innenraum `innen-kirche`, Standort Marke `t`, Blick zur Raummitte.
Szene innenSzene(Spiel spiel) {
  final b = spiel.stadt.bereiche['innen-kirche'] ?? _abbruch('Bereich innen-kirche fehlt');
  final (x, z) = b.markePos('t');
  return Szene('B-Innenraum', b, x, z, blickZurMitte(b, x, z), 't', 'Marke t, Blick zur Raummitte');
}

/// Szene C: Burghof `hof` (innen == false), Marke `b`, Blick in die längste freie Richtung.
Szene hofSzene(Spiel spiel) {
  final hof = spiel.stadt.bereiche['hof'] ?? _abbruch('Bereich hof fehlt');
  if (hof.innen) _abbruch('Bereich hof ist ein Innenraum');
  final (x, z) = hof.markePos('b');
  final (yaw, _) = laengsteRichtung(hof, x, z);
  return Szene('C-Burghof', hof, x, z, yaw, 'b', 'Marke b, längste freie Richtung');
}

/// Szene D: zweite Oberstadt-Stelle, Marke `vor-H-…` mit der größten freien Sicht (über 20 m).
Szene zweiteOberstadtSzene(Spiel spiel) {
  final stadt = spiel.stadt.bereiche['stadt']!;
  String? beste;
  var bestSicht = -1.0, bestYaw = 0.0;
  for (final m in stadt.marken.keys.toList()..sort()) {
    if (!m.startsWith('vor-H-')) continue;
    final (x, z) = stadt.markePos(m);
    if (!stadt.frei(x, z)) continue;
    final (yaw, sicht) = laengsteRichtung(stadt, x, z);
    if (sicht > bestSicht) {
      beste = m;
      bestSicht = sicht;
      bestYaw = yaw;
    }
  }
  if (beste == null || bestSicht <= 20) _abbruch('Keine Marke vor-H-… mit freier Sicht über 20 m in stadt');
  final (x, z) = stadt.markePos(beste);
  return Szene('D-Oberstadt-2', stadt, x, z, bestYaw, beste, 'Marke $beste, längste freie Richtung');
}

/// Zeichnet Szene [s] von (x, z) aus in den Puffer von [r]: dieselben Schritte wie Spiel.zeichneBereich
/// (lib/src/spiel.dart:289–322), ohne Figuren und ohne Detektivblick. Nebel, Himmel und Fledermäuse wie dort.
void zeichneSzene(Spiel spiel, Renderer r, Szene s, double x, double z, Fledermaeuse? fled) {
  final b = s.bereich;
  setzeKamera(r, x, z, s.yaw);
  r.flashStrength = 0;
  if (b.innen) {
    r.fogStart = 3;
    r.fogEnd = 20;
    r.groundFog = 0;
  } else {
    r.fogStart = 8;
    r.fogEnd = 46;
    r.groundFog = 0.25;
  }
  r.begin();
  if (b.innen) {
    r.fb.clear(Pal.black);
  } else {
    r.drawSky();
  }
  for (final m in spiel.geometrie(b.id).meshes) {
    r.drawMesh(m);
  }
  fled?.zeichne(r);
}

/// Verkleinert [gross] um [faktor]: je Block der häufigste Palettenindex, bei Gleichstand der kleinere.
PixelBuffer modusBloecke(PixelBuffer gross, int faktor) {
  final out = PixelBuffer(gross.width ~/ faktor, gross.height ~/ faktor);
  final zaehl = Int32List(256);
  for (var by = 0; by < out.height; by++) {
    for (var bx = 0; bx < out.width; bx++) {
      final start = by * faktor * gross.width + bx * faktor;
      for (var dy = 0; dy < faktor; dy++) {
        for (var dx = 0; dx < faktor; dx++) {
          zaehl[gross.color[start + dy * gross.width + dx]]++;
        }
      }
      var best = 0, bestN = 0;
      for (var dy = 0; dy < faktor; dy++) {
        for (var dx = 0; dx < faktor; dx++) {
          final c = gross.color[start + dy * gross.width + dx];
          final n = zaehl[c];
          if (n > bestN || (n == bestN && c < best)) {
            best = c;
            bestN = n;
          }
        }
      }
      for (var dy = 0; dy < faktor; dy++) {
        for (var dx = 0; dx < faktor; dx++) {
          zaehl[gross.color[start + dy * gross.width + dx]] = 0;
        }
      }
      out.color[by * out.width + bx] = best;
    }
  }
  return out;
}

/// Ergebnis einer Szene: Bodenpixel der Maske, Wechsel der Test- und Referenzfolge, Fernteilmenge.
class Messung {
  Messung({
    required this.boden,
    required this.ct,
    required this.cr,
    required this.fern,
    required this.fernCt,
    required this.fernCr,
    required this.fernster,
    required this.test0,
    required this.ref0,
  });

  final int boden, ct, cr, fern, fernCt, fernCr;

  /// Größte Tiefe (m) eines Bodenpixels im ersten Testbild.
  final double fernster;

  /// Erstes Bild der Test- und der Referenzfolge (für --png).
  final Uint8List test0, ref0;
}

/// Misst Szene [s]: Testfolge in [testPuffer] mit [rTest], Referenzfolge in [refPuffer] (4-fach) mit [rRef].
Messung messeSzene(Spiel spiel, Szene s, Renderer rTest, PixelBuffer testPuffer, Renderer rRef, PixelBuffer refPuffer,
    Fledermaeuse? fled) {
  final bw = testPuffer.width, bh = testPuffer.height, n = bw * bh;
  final dx = math.cos(s.yaw) * schrittJeBild, dz = math.sin(s.yaw) * schrittJeBild;
  final test = <Bild>[], ref = <Uint8List>[];
  for (var i = 0; i < kBilder; i++) {
    final x = s.x + i * dx, z = s.z + i * dz;
    zeichneSzene(spiel, rTest, s, x, z, fled);
    final c = rTest.camera;
    test.add(Bild(Uint8List.fromList(testPuffer.color), Float32List.fromList(testPuffer.depth), c.y, c.cy, c.focal));
    zeichneSzene(spiel, rRef, s, x, z, fled);
    ref.add(modusBloecke(refPuffer, ueberabtastung).color);
  }

  final boden0 = bodenTiefe(test[0], bw, bh);
  final maske = Uint8List(n)..fillRange(0, n, 1);
  for (var i = 0; i < kBilder; i++) {
    final bt = i == 0 ? boden0 : bodenTiefe(test[i], bw, bh);
    for (var p = 0; p < n; p++) {
      if (bt[p] == 0) maske[p] = 0;
    }
  }

  var boden = 0, fern = 0, fernster = 0.0;
  for (var p = 0; p < n; p++) {
    if (maske[p] == 0) continue;
    boden++;
    if (boden0[p] > fernM) fern++;
  }
  for (var p = 0; p < n; p++) {
    if (boden0[p] > fernster) fernster = boden0[p];
  }

  var ct = 0, cr = 0, fct = 0, fcr = 0;
  for (var i = 0; i < kBilder - 1; i++) {
    final ta = test[i].farben, tb = test[i + 1].farben, ra = ref[i], rb = ref[i + 1];
    for (var p = 0; p < n; p++) {
      if (maske[p] == 0) continue;
      final wt = ta[p] != tb[p] ? 1 : 0, wr = ra[p] != rb[p] ? 1 : 0;
      ct += wt;
      cr += wr;
      if (boden0[p] > fernM) {
        fct += wt;
        fcr += wr;
      }
    }
  }
  return Messung(
    boden: boden,
    ct: ct,
    cr: cr,
    fern: fern,
    fernCt: fct,
    fernCr: fcr,
    fernster: fernster,
    test0: test[0].farben,
    ref0: ref[0],
  );
}

void main(List<String> args) {
  final zahlen = <int>[];
  var qualitaet = Qualitaet.mittel;
  String? png;
  int? weltB, weltH;
  var selbsttest = false;
  for (var i = 0; i < args.length; i++) {
    final a = args[i];
    if (a == '--selbsttest') {
      selbsttest = true;
    } else if (a == '--qualitaet' || a == '--png' || a == '--welt') {
      if (i + 1 >= args.length) _abbruch('$a braucht einen Wert');
      final wert = args[++i];
      if (a == '--png') {
        png = wert;
      } else if (a == '--welt') {
        final t = wert.split('x');
        final b = t.length == 2 ? int.tryParse(t[0]) : null;
        final h = t.length == 2 ? int.tryParse(t[1]) : null;
        if (b == null || h == null || b <= 0 || h <= 0) _abbruch('--welt erwartet BxH, nicht „$wert“');
        weltB = b;
        weltH = h;
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
  final skala = spiel.skala!;
  final tb = weltB ?? skala.weltW, th = weltH ?? skala.weltH;
  stdout.writeln('SKALA $skala');
  stdout.writeln('Test ${tb}x$th${weltB == null ? ' (Qualität ${qualitaet.name})' : ' (erzwungen)'} · '
      'Referenz ${tb * ueberabtastung}x${th * ueberabtastung} · $kBilder Bilder je Szene · Schritt je Bild '
      '${dez(schrittJeBild)} m');

  final texturen = selbsttest
      ? List<IndexedTexture>.generate(spiel.texturen.length, (_) => IndexedTexture.solid(Pal.grey), growable: false)
      : spiel.texturen;
  final testPuffer = PixelBuffer(tb, th);
  final rTest = baueRenderer(spiel, testPuffer, texturen);
  final refPuffer = PixelBuffer(tb * ueberabtastung, th * ueberabtastung);
  // Referenz ohne Bayer-Dither: der 4×4-Modus würde sonst Dither-Muster als Wechsel zählen (E-050)
  final rRef = baueRenderer(spiel, refPuffer, texturen)..ditherStrength = 0;

  if (selbsttest) {
    final a = oberstadtSzene(spiel);
    final m = messeSzene(spiel, a, rTest, testPuffer, rRef, refPuffer, Fledermaeuse(a.bereich));
    if (m.boden > 0 && m.ct == 0 && m.cr == 0) {
      stdout.writeln('SELBSTTEST OK · Szene A · Boden ${m.boden} · Wechsel Test 0 · Referenz 0');
    } else {
      stdout.writeln('SELBSTTEST FEHLER · Szene A · Boden ${m.boden} · Wechsel Test ${m.ct} · Referenz ${m.cr} '
          '(erwartet Boden > 0, Test 0, Referenz 0)');
      exit(1);
    }
    return;
  }

  final szenen = [oberstadtSzene(spiel), innenSzene(spiel), hofSzene(spiel), zweiteOberstadtSzene(spiel)];
  const kurz = ['A', 'B', 'C', 'D'];
  var summeCt = 0, summeCr = 0, fernSummeCt = 0, fernSummeCr = 0;
  for (var i = 0; i < szenen.length; i++) {
    final s = szenen[i];
    final fled = s.bereich.id == 'stadt' ? Fledermaeuse(s.bereich) : null;
    final m = messeSzene(spiel, s, rTest, testPuffer, rRef, refPuffer, fled);
    final ueber = verhaeltnis(m.ct, m.cr);
    final fernUeber = m.fern > 0 ? verhaeltnis(m.fernCt, m.fernCr) : null;
    stdout.writeln('SZENE ${s.name} · Bereich ${s.bereich.id} (${s.herkunft}) · x ${dez(s.x, 2)} · z ${dez(s.z, 2)} · '
        'yaw ${dez(s.yaw, 4)} rad · Sicht ${dez(s.sicht, 1)} m · Boden bis ${dez(m.fernster, 1)} m · '
        'Fernpixel ${m.fern}');
    stdout.writeln('FLIMMERN ${s.name} · Boden ${m.boden} · Wechsel Test ${m.ct} · Referenz ${m.cr} · '
        'Überschuss ${ueber == null ? '–' : dez(ueber)} · FERNE ${fernUeber == null ? '–' : dez(fernUeber)}');
    summeCt += m.ct;
    summeCr += m.cr;
    if (fernUeber != null) {
      fernSummeCt += m.fernCt;
      fernSummeCr += m.fernCr;
    }
    if (png != null) {
      final testBild = PixelBuffer(tb, th)..color.setAll(0, m.test0);
      final refBild = PixelBuffer(tb, th)..color.setAll(0, m.ref0);
      schreibePng('$png/${kurz[i]}_test.png', testBild);
      schreibePng('$png/${kurz[i]}_referenz.png', refBild);
      stdout.writeln('PNG $png/${kurz[i]}_test.png · $png/${kurz[i]}_referenz.png');
    }
  }
  final gesamt = verhaeltnis(summeCt, summeCr);
  final fernGesamt = verhaeltnis(fernSummeCt, fernSummeCr);
  stdout.writeln('FLIMMERN v2 · Überschuss ${gesamt == null ? '–' : dez(gesamt)} · '
      'FERNE ${fernGesamt == null ? '–' : dez(fernGesamt)} · Welt ${tb}x$th');
}

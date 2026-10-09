import 'dart:io';
import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Gemeinsame Hilfen der Messwerkzeuge in `bin/` (Flimmer-Messung v2). Lib/ bleibt unverändert.

/// Kamerahöhe wie in `Erkundung.zeichneWelt` (erkundung.dart:397–403).
const kamHoeheM = 1.62;

/// Obergrenze der Sichtsuche (m), damit die längste Richtung eindeutig ist (Nebelende liegt bei 46 m).
const sichtMaxM = 60.0;

/// Freie Sichtweite ab (x, z) in Blickrichtung [yaw] bis zur ersten nicht begehbaren Kachel (Schritt 0,1 m).
/// Kopie aus bin/belegfotos.dart (dort unverändert).
double sichtweite(Bereich b, double x, double z, double yaw, {double max = 14}) {
  final dx = math.cos(yaw), dz = math.sin(yaw);
  for (var t = 0.1; t <= max; t += 0.1) {
    final kx = ((x + dx * t) / kKachel).floor(), kz = ((z + dz * t) / kKachel).floor();
    if (!b.begehbar(kx, kz)) return t - 0.1;
  }
  return max;
}

/// Längste freie Blickrichtung unter 16 Richtungen (k/8·π): (Blickwinkel in rad, freie Sicht in m).
(double, double) laengsteRichtung(Bereich b, double x, double z, {double max = sichtMaxM}) {
  var bestYaw = 0.0, bestSicht = -1.0;
  for (var k = 0; k < 16; k++) {
    final yaw = k / 8 * math.pi;
    final s = sichtweite(b, x, z, yaw, max: max);
    if (s > bestSicht) {
      bestSicht = s;
      bestYaw = yaw;
    }
  }
  return (bestYaw, bestSicht);
}

/// Blickrichtung wie beim Betreten eines Bereichs (erkundung.dart `_setzeAn`): zur Mitte des Raums.
double blickZurMitte(Bereich b, double x, double z) {
  final cx = b.breite * kKachel / 2, cz = b.tiefe * kKachel / 2;
  return math.atan2(cz - z, cx - x);
}

/// Vertikales Sichtfeld (rad) für einen Puffer der Größe [breite]×[hoehe]: dieselbe Formel wie
/// `Spiel._sichtfeld` (lib/src/spiel.dart:173–183) und `bin/szenen_mess.dart` bei `--welt`.
double sichtfeldFuer(Spiel spiel, int breite, int hoehe) {
  final fovX = spiel.optionen.sichtfeldGrad * math.pi / 180 * 1.25;
  var fovY = spiel.optionen.sichtfeldGrad * math.pi / 180;
  final ausX = 2 * math.atan(math.tan(fovX / 2) / (breite / hoehe));
  if (ausX > fovY) fovY = math.min(ausX, 100 * math.pi / 180);
  return fovY;
}

/// Eigener Renderer auf [puffer] mit den Texturen [texturen], dem Licht des Spiels und dem Sichtfeld des Spiels.
Renderer baueRenderer(Spiel spiel, PixelBuffer puffer, List<IndexedTexture> texturen) {
  final r = Renderer(puffer, spiel.licht, texturen);
  r.camera.fovY = sichtfeldFuer(spiel, puffer.width, puffer.height);
  return r;
}

/// Kamera auf Ort (x, z) mit Kamerahöhe und Blickrichtung [yaw] ohne Neigung.
void setzeKamera(Renderer r, double x, double z, double yaw) {
  r.camera
    ..x = x
    ..y = kamHoeheM
    ..z = z
    ..yaw = yaw
    ..pitch = 0;
}

/// Schreibt [puffer] als RGBA-PNG nach [pfad]; der Ordner wird angelegt.
void schreibePng(String pfad, PixelBuffer puffer) {
  File(pfad).parent.createSync(recursive: true);
  File(pfad).writeAsBytesSync(encodePngRgba(puffer.width, puffer.height, puffer.toRgbaBytes(), zlib: zlib.encode));
}

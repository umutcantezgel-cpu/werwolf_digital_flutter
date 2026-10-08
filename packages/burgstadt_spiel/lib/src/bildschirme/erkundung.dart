import 'dart:math' as math;

import 'package:pixel_engine/pixel_engine.dart';

import '../spiel.dart';
import '../steuerung.dart';
import 'hauptmenue.dart';
import 'optionen_bildschirm.dart';

/// Ich-Perspektive: frei laufen und umsehen (Durchstich-Vorstufe in der Prüfszene).
class Erkundung extends Bildschirm {
  double x = 0, z = 4, yaw = -math.pi / 2, pitch = 0;
  double _wippen = 0;
  bool licht = true;
  final Steuerung steuerung = Steuerung();
  String meldung = 'Willkommen in Schartenfels. Es ist dunkel.';
  double _meldungZeit = 4;

  static const gehen = 1.7, rennen = 3.4;

  @override
  bool get menueNavigation => false;

  double _schrittWeg = 0;
  int _schrittNr = 0;

  @override
  void betreten(Spiel spiel) {
    spiel.ton.schleife('musik', null);
    spiel.ton.schleife('umgebung', 'wind_schleife', lautstaerke: 0.45);
    spiel.ton.spiele('uhrturm_schlag', lautstaerke: 0.8);
  }

  @override
  void tick(Spiel spiel, double dt, Eingabe e) {
    final s = spiel.skala!;
    steuerung.verarbeite(e, spiel.pixelUi, s.uiW, dt, empfindlichkeit: spiel.optionen.blickEmpfindlichkeit);
    yaw += steuerung.drehen;
    pitch = (pitch + steuerung.nicken).clamp(-1.1, 1.1);
    final v = e.haelt(Taste.rennen) ? rennen : gehen;
    final fx = math.cos(yaw), fz = math.sin(yaw);
    final rx = -fz, rz = fx;
    final gx = steuerung.gehenX, gy = steuerung.gehenY;
    final nx = x + (fx * gy + rx * gx) * v * dt, nz = z + (fz * gy + rz * gx) * v * dt;
    final x0 = x, z0 = z;
    if (_frei(nx, z)) x = nx;
    if (_frei(x, nz)) z = nz;
    _schrittWeg += math.sqrt((x - x0) * (x - x0) + (z - z0) * (z - z0));
    if (_schrittWeg > 0.72) {
      _schrittWeg = 0;
      spiel.ton.spiele('schritt_pflaster_${_schrittNr++ % 4 + 1}', lautstaerke: 0.5);
    }
    final bewegt = (gx.abs() + gy.abs()) > 0.05;
    if (bewegt) _wippen += dt * v * 3.2;
    if (e.gedrueckt(Taste.licht)) {
      licht = !licht;
      spiel.ton.spiele('handylicht_klick');
    }
    if (e.gedrueckt(Taste.menue) || e.gedrueckt(Taste.zurueck)) spiel.oeffne(_Pause());
    if (steuerung.tippAktion || e.gedrueckt(Taste.aktion)) _meldung('Hier ist nichts Besonderes.');
    _meldungZeit -= dt;
  }

  void _meldung(String m) {
    meldung = m;
    _meldungZeit = 3;
  }

  /// Einfache Kollision mit den Häuserblöcken der Prüfszene.
  bool _frei(double px, double pz) {
    const r = 0.3;
    if (px.abs() > 47.5 || pz.abs() > 47.5) return false;
    final bx = (px / 8).floor(), bz = (pz / 8).floor();
    if ((bx == 0 || bx == -1) && (bz == 0 || bz == -1)) return true;
    final lx = px - bx * 8, lz = pz - bz * 8;
    return !(lx > 2.2 - r && lx < 5.8 + r && lz > 2.2 - r && lz < 5.8 + r);
  }

  @override
  void zeichneWelt(Spiel spiel) {
    final r = spiel.renderer;
    final wipp = spiel.optionen.kopfwippen ? math.sin(_wippen) * 0.035 : 0.0;
    r.camera
      ..x = x
      ..z = z
      ..y = 1.62 + wipp
      ..yaw = yaw
      ..pitch = pitch;
    var flash = licht ? 0.85 : 0.0;
    if (licht && !spiel.optionen.flackernAus) flash *= 0.97 + 0.03 * math.sin(spiel.zeit * 23);
    r.flashStrength = flash;
    spiel.zeichneSzene();
  }

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    // Fadenkreuz
    final cx = w ~/ 2, cy = h ~/ 2;
    ui.fb.fillRect(cx - 3, cy, 2, 1, UiFarbe.text);
    ui.fb.fillRect(cx + 2, cy, 2, 1, UiFarbe.text);
    ui.fb.fillRect(cx, cy - 3, 1, 2, UiFarbe.text);
    ui.fb.fillRect(cx, cy + 2, 1, 2, UiFarbe.text);
    // Kopfzeile: Uhr und Ort
    ui.text('00:25 · Phase 1', 4, 3, farbe: UiFarbe.text);
    final ort = 'Prüfgassen';
    ui.text(ort, w - ui.font.measure(ort) - 4, 3, farbe: UiFarbe.textGedimmt);
    // Knöpfe rechts
    const bw = 44, bh = 17;
    var by = h - (bh + 4) * 3 - 4;
    if (ui.knopf(Rechteck(w - bw - 4, by, bw, bh), licht ? 'Licht' : 'Licht', hervorgehoben: licht)) licht = !licht;
    by += bh + 4;
    if (ui.knopf(Rechteck(w - bw - 4, by, bw, bh), 'Akte')) _meldung('Die Fallakte ist noch leer.');
    by += bh + 4;
    if (ui.knopf(Rechteck(w - bw - 4, by, bw, bh), 'Menü')) spiel.oeffne(_Pause());
    // Joystick
    final j = steuerung.joystick;
    if (j != null) {
      ui.kreis(j.$1, j.$2, Steuerung.joyRadius.round(), UiFarbe.rand);
      ui.kreis(j.$3, j.$4, 6, UiFarbe.text, gefuellt: true);
    }
    if (_meldungZeit > 0) {
      final tw = ui.font.measure(meldung);
      final r = Rechteck((w - tw) ~/ 2 - 6, h - 40, tw + 12, ui.font.height + 6);
      ui.panel(r, fangen: false);
      ui.text(meldung, r.x + 6, r.y + 3);
    }
  }
}

class _Pause extends Bildschirm {
  @override
  void tick(Spiel spiel, double dt, Eingabe e) {
    if (e.gedrueckt(Taste.menue) || e.gedrueckt(Taste.zurueck)) spiel.schliesse();
  }

  @override
  void zeichneWelt(Spiel spiel) => spiel.zeichneSzene();

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    final p = Rechteck(w ~/ 2 - 90, h ~/ 2 - 60, 180, 120);
    ui.panel(p);
    ui.textMittig('Pause', w ~/ 2, p.y + 6, farbe: UiFarbe.akzent);
    switch (ui.menue(const ['Weiter', 'Optionen', 'Hauptmenü'], w ~/ 2, p.y + 24, breite: 150)) {
      case 0:
        spiel.schliesse();
      case 1:
        spiel.oeffne(OptionenBildschirm());
      case 2:
        spiel.wechsle(Hauptmenue());
    }
  }
}

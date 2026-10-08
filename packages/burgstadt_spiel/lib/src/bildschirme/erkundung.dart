import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

import '../spiel.dart';
import '../steuerung.dart';
import 'hauptmenue.dart';
import 'optionen_bildschirm.dart';

/// Ich-Perspektive in der Burg: laufen, umsehen, Türen benutzen, untersuchen.
class Erkundung extends Bildschirm {
  String ort;
  double x = 0, z = 0, yaw = -math.pi / 2, pitch = 0;
  double _wippen = 0;
  bool licht = true;
  final Steuerung steuerung = Steuerung();
  String meldung = '';
  double _meldungZeit = 0;
  double _blende = 1; // 1 = schwarz, blendet auf
  Ding? ziel; // Ding im Blick (Tür, Möbel, Station)

  static const gehen = 1.6, rennen = 3.2, reichweite = 1.5;

  Erkundung({this.ort = 'gewoelbe', String marke = 'm'}) {
    _setzeAn(ort, marke);
  }

  late Bereich _bereich;

  void _setzeAn(String id, String marke) {
    ort = id;
    _bereich = _welt!.bereiche[id]!;
    final (mx, mz) = _bereich.markePos(marke);
    x = mx;
    z = mz;
    // Blick in den Raum: zur Mitte des Bereichs
    final cx = _bereich.breite * kKachel / 2, cz = _bereich.tiefe * kKachel / 2;
    yaw = math.atan2(cz - z, cx - x);
    pitch = 0;
  }

  // Die Welt wird beim ersten Tick gesetzt (Bildschirme kennen das Spiel erst dann).
  static Welt? _welt = Welt(baueBurg());

  @override
  bool get menueNavigation => false;

  double _schrittWeg = 0;
  int _schrittNr = 0;

  @override
  void betreten(Spiel spiel) {
    _welt = spiel.stadt;
    _bereich = spiel.stadt.bereiche[ort]!;
    spiel.ton.schleife('musik', _bereich.innen ? 'musik_gewoelbe_schleife' : null, lautstaerke: 0.3);
    spiel.ton.schleife('umgebung', _bereich.innen ? 'kaminglut_schleife' : 'wind_schleife', lautstaerke: _bereich.innen ? 0.2 : 0.45);
    if (_meldungZeit <= 0) _meldung(_bereich.name);
  }

  @override
  void tick(Spiel spiel, double dt, Eingabe e) {
    final s = spiel.skala!;
    _blende = math.max(0, _blende - dt * 3);
    steuerung.verarbeite(e, spiel.pixelUi, s.uiW, dt, empfindlichkeit: spiel.optionen.blickEmpfindlichkeit);
    yaw += steuerung.drehen;
    pitch = (pitch + steuerung.nicken).clamp(-1.1, 1.1);
    final v = e.haelt(Taste.rennen) ? rennen : gehen;
    final fx = math.cos(yaw), fz = math.sin(yaw);
    final rx = -fz, rz = fx;
    final gx = steuerung.gehenX, gy = steuerung.gehenY;
    final nx = x + (fx * gy + rx * gx) * v * dt, nz = z + (fz * gy + rz * gx) * v * dt;
    final x0 = x, z0 = z;
    if (_bereich.frei(nx, z)) x = nx;
    if (_bereich.frei(x, nz)) z = nz;
    final weg = math.sqrt((x - x0) * (x - x0) + (z - z0) * (z - z0));
    if (weg > 0.0005) _wippen += weg * 5.5;
    _schrittWeg += weg;
    if (_schrittWeg > 0.72) {
      _schrittWeg = 0;
      final boden = _bereich.innen ? 'stein' : (_bereich.id == 'wehrgang' ? 'holz' : 'pflaster');
      spiel.ton.spiele('schritt_${boden}_${_schrittNr++ % 4 + 1}', lautstaerke: 0.45);
    }
    ziel = _blickziel();
    if (e.gedrueckt(Taste.licht)) {
      licht = !licht;
      spiel.ton.spiele('handylicht_klick');
    }
    if (e.gedrueckt(Taste.menue) || e.gedrueckt(Taste.zurueck)) spiel.oeffne(_Pause());
    if (steuerung.tippAktion || e.gedrueckt(Taste.aktion)) _handle(spiel);
    _meldungZeit -= dt;
  }

  /// Erstes Ding in Blickrichtung bis [reichweite] (Tür, Möbel, Station).
  Ding? _blickziel() {
    final fx = math.cos(yaw), fz = math.sin(yaw);
    for (var t = 0.2; t <= reichweite; t += 0.1) {
      final px = x + fx * t, pz = z + fz * t;
      final kx = (px / kKachel).floor(), kz = (pz / kKachel).floor();
      final a = _bereich.art(kx, kz);
      final d = _bereich.dingAn(kx, kz);
      if (d != null && (a == KachelArt.tuer || a == KachelArt.objekt || a == KachelArt.station)) {
        if (a == KachelArt.objekt && d.legende.station == null && d.legende.form != 'tuerdeko') {
          return d; // Möbel: benennbar
        }
        return d;
      }
      if (a == KachelArt.wand || a == KachelArt.leer) return null;
    }
    return null;
  }

  void _handle(Spiel spiel) {
    final d = ziel;
    if (d == null) {
      _meldung('Hier ist nichts Besonderes.');
      return;
    }
    final l = d.legende;
    switch (l.art) {
      case KachelArt.tuer:
        if (l.verschlossen) {
          spiel.ton.spiele('schluessel_klimpern', lautstaerke: 0.4);
          _meldung('${l.name}: verschlossen.');
          return;
        }
        spiel.ton.spiele(l.textur == 'eisenGitter' ? 'tuer_eisen' : (l.textur == 'stufenStein' ? 'schritt_stein_1' : 'tuer_eiche_auf'), lautstaerke: 0.7);
        _setzeAn(l.ziel!, l.zielMarke!);
        _blende = 1;
        betreten(spiel);
      case KachelArt.station:
      case KachelArt.objekt:
        _meldung(l.station != null ? '${l.name}: Hier lohnt ein genauer Blick.' : l.name);
      default:
        _meldung(l.name);
    }
  }

  void _meldung(String m) {
    meldung = m;
    _meldungZeit = 3;
  }

  @override
  void zeichneWelt(Spiel spiel) {
    final r = spiel.renderer;
    final wipp = spiel.optionen.kopfwippen ? math.sin(_wippen) * 0.03 : 0.0;
    r.camera
      ..x = x
      ..z = z
      ..y = 1.62 + wipp
      ..yaw = yaw
      ..pitch = pitch;
    var flash = licht ? 0.9 : 0.0;
    if (licht && !spiel.optionen.flackernAus) flash *= 0.97 + 0.03 * math.sin(spiel.zeit * 23);
    r.flashStrength = flash;
    spiel.zeichneBereich(ort);
  }

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    if (_blende > 0) {
      // Überblendung beim Raumwechsel: Dither-Vorhang
      final stufe = (_blende * 16).round();
      for (var y = 0; y < h; y++) {
        for (var xx = 0; xx < w; xx++) {
          if (bayer4[((y & 3) << 2) | (xx & 3)] < stufe) ui.fb.color[y * w + xx] = Pal.black;
        }
      }
    }
    final cx = w ~/ 2, cy = h ~/ 2;
    final farbe = ziel != null ? UiFarbe.akzent : UiFarbe.text;
    ui.fb.fillRect(cx - 3, cy, 2, 1, farbe);
    ui.fb.fillRect(cx + 2, cy, 2, 1, farbe);
    ui.fb.fillRect(cx, cy - 3, 1, 2, farbe);
    ui.fb.fillRect(cx, cy + 2, 1, 2, farbe);
    ui.text('00:25 · Phase 1', 4, 3);
    final ortName = _bereich.name;
    ui.text(ortName, w - ui.font.measure(ortName) - 4, 3, farbe: UiFarbe.textGedimmt);
    // Blickziel benennen
    final d = ziel;
    if (d != null) {
      final l = d.legende;
      final was = switch (l.art) {
        KachelArt.tuer => l.verschlossen ? '${l.name} (verschlossen)' : l.name,
        _ => l.name,
      };
      ui.textMittig(was, cx, cy + 10, farbe: UiFarbe.akzent);
    }
    // Knöpfe rechts
    const bw = 48, bh = 17;
    var by = h - (bh + 4) * 4 - 4;
    if (ui.knopf(Rechteck(w - bw - 4, by, bw, bh), d == null ? 'Aktion' : (d.legende.art == KachelArt.tuer ? 'Öffnen' : 'Ansehen'),
        hervorgehoben: d != null)) {
      _handle(spiel);
    }
    by += bh + 4;
    if (ui.knopf(Rechteck(w - bw - 4, by, bw, bh), 'Licht', hervorgehoben: licht)) {
      licht = !licht;
      spiel.ton.spiele('handylicht_klick');
    }
    by += bh + 4;
    if (ui.knopf(Rechteck(w - bw - 4, by, bw, bh), 'Akte')) _meldung('Die Fallakte ist noch leer.');
    by += bh + 4;
    if (ui.knopf(Rechteck(w - bw - 4, by, bw, bh), 'Menü')) spiel.oeffne(_Pause());
    final j = steuerung.joystick;
    if (j != null) {
      ui.kreis(j.$1, j.$2, Steuerung.joyRadius.round(), UiFarbe.rand);
      ui.kreis(j.$3, j.$4, 6, UiFarbe.text, gefuellt: true);
    }
    if (_meldungZeit > 0 && meldung.isNotEmpty) {
      final tw = ui.font.measure(meldung);
      final r = Rechteck((w - tw) ~/ 2 - 6, h - 40, tw + 12, ui.font.height + 6);
      ui.panel(r, fangen: false);
      ui.text(meldung, r.x + 6, r.y + 3);
    }
  }
}

class _Pause extends Bildschirm {
  @override
  bool get zeigtWelt => false;

  @override
  void tick(Spiel spiel, double dt, Eingabe e) {
    if (e.gedrueckt(Taste.menue) || e.gedrueckt(Taste.zurueck)) spiel.schliesse();
  }

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

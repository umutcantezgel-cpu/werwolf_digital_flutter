import 'dart:math' as math;

import '../font/bitmap_font.dart';
import '../palette.dart';
import '../pixel_buffer.dart';
import 'eingabe.dart';

/// Rechteck in UI-Pixeln.
class Rechteck {
  final int x, y, w, h;
  const Rechteck(this.x, this.y, this.w, this.h);
  bool enthaelt(double px, double py) => px >= x && py >= y && px < x + w && py < y + h;
  int get rechts => x + w;
  int get unten => y + h;
  Rechteck einwaerts(int d) => Rechteck(x + d, y + d, w - 2 * d, h - 2 * d);
}

/// Farben der Pixel-Oberfläche (nur Palette, K8-Stilblatt).
abstract final class UiFarbe {
  static const grund = Pal.nightBlue; // Nachtblau
  static const grundDunkel = 49;
  static const rand = Pal.stone; // Bruchstein
  static const randHell = 14;
  static const text = Pal.parchment; // Pergament
  static const textGedimmt = 13;
  static const akzent = Pal.candle; // Kerzenbernstein
  static const akzentDunkel = 35;
  static const schatten = Pal.black;
  static const spuk = Pal.ghostCyan; // Spukcyan, sparsam
}

/// Immediate-Mode-Pixeloberfläche: Panels, Knöpfe, Texte, Listen; Treffer per
/// Zeiger (Tippen/Klicken) und Fokus per Tastatur/Gamepad.
class PixelUi {
  final BitmapFont font;
  late PixelBuffer fb;
  late Eingabe _ein;

  // Zeiger: Startposition je id (für „Tippen innerhalb desselben Knopfs“)
  final Map<int, (double, double)> _start = {};
  final Map<int, (double, double)> _jetzt = {};
  final List<(double, double, double, double)> _tips = []; // start x,y / ende x,y

  // Treffer-Flächen des letzten Bildes (entscheiden, ob ein Zeiger der UI gehört)
  List<Rechteck> _flaechenAlt = [];
  List<Rechteck> _flaechen = [];

  // Fokus (Tastatur/Gamepad)
  int fokus = 0;
  int _fokusAnzahl = 0;
  int _fokusAnzahlAlt = 0;
  bool fokusSichtbar = false;
  int _bild = 0;

  /// Pfeiltasten/Gamepad bewegen den Fokus (in Menüs an, im Spiel-HUD aus).
  bool navigation = true;

  /// Anzahl ausgelöster Knöpfe in diesem Bild (für Klickgeräusche).
  int ausgeloestImBild = 0;

  PixelUi(this.font);

  int get zeilenHoehe => font.height + 2;

  /// Bildbeginn: Puffer setzen (wird mit [kTransparent] geleert) und Eingabe auswerten.
  void beginne(PixelBuffer ziel, Eingabe ein, {bool leeren = true}) {
    fb = ziel;
    _ein = ein;
    _bild++;
    if (leeren) fb.color.fillRange(0, fb.color.length, kTransparent);
    _tips.clear();
    ausgeloestImBild = 0;
    for (final z in ein.zeiger) {
      switch (z.art) {
        case ZeigerArt.runter:
          _start[z.id] = (z.x, z.y);
          _jetzt[z.id] = (z.x, z.y);
          fokusSichtbar = false;
        case ZeigerArt.bewegt:
          if (_start.containsKey(z.id)) _jetzt[z.id] = (z.x, z.y);
        case ZeigerArt.hoch:
          final s = _start.remove(z.id);
          _jetzt.remove(z.id);
          if (s != null) _tips.add((s.$1, s.$2, z.x, z.y));
        case ZeigerArt.abbruch:
          _start.remove(z.id);
          _jetzt.remove(z.id);
      }
    }
    _fokusAnzahlAlt = _fokusAnzahl;
    _fokusAnzahl = 0;
    if (!navigation) fokusSichtbar = false;
    if (_fokusAnzahlAlt > 0 && navigation) {
      if (ein.gedrueckt(Taste.runter) || ein.gedrueckt(Taste.tab)) {
        fokus = fokusSichtbar ? (fokus + 1) % _fokusAnzahlAlt : fokus;
        fokusSichtbar = true;
      }
      if (ein.gedrueckt(Taste.hoch)) {
        fokus = fokusSichtbar ? (fokus - 1 + _fokusAnzahlAlt) % _fokusAnzahlAlt : fokus;
        fokusSichtbar = true;
      }
      if (fokus >= _fokusAnzahlAlt) fokus = _fokusAnzahlAlt - 1;
    }
    _flaechenAlt = _flaechen;
    _flaechen = [];
  }

  /// Gehört ein Zeiger an (x, y) der Oberfläche (statt Joystick/Blick)?
  bool trifftUi(double x, double y) => _flaechenAlt.any((r) => r.enthaelt(x, y));

  /// Anzahl der Bilder seit Start (für Blinken/Animationen).
  int get bild => _bild;

  // ---------------------------------------------------------------- Zeichnen

  void flaeche(Rechteck r, int farbe) => fb.fillRect(r.x, r.y, r.w, r.h, farbe);

  /// Panel mit 1-px-Rand, heller Oberkante und Schatten (Licht von links oben).
  void panel(Rechteck r, {int grund = UiFarbe.grund, int rand = UiFarbe.rand, bool fangen = true}) {
    if (fangen) _flaechen.add(r);
    fb.fillRect(r.x + 1, r.y + 1, r.w, r.h, UiFarbe.schatten);
    fb.fillRect(r.x, r.y, r.w, r.h, rand);
    fb.fillRect(r.x + 1, r.y + 1, r.w - 2, r.h - 2, grund);
    fb.fillRect(r.x + 1, r.y + 1, r.w - 2, 1, UiFarbe.randHell);
  }

  int text(String s, int x, int y, {int farbe = UiFarbe.text, int? schatten = UiFarbe.schatten, int skala = 1}) =>
      font.draw(fb, s, x, y, farbe, shadow: schatten, scale: skala);

  int textMittig(String s, int cx, int y, {int farbe = UiFarbe.text, int skala = 1}) =>
      text(s, cx - font.measure(s) * skala ~/ 2, y, farbe: farbe, skala: skala);

  /// Fließtext mit Umbruch; gibt die benutzte Höhe zurück.
  int absatz(String s, Rechteck r, {int farbe = UiFarbe.text, int erste = 0}) {
    final zeilen = font.wrap(s, r.w);
    var y = r.y;
    for (var i = erste; i < zeilen.length; i++) {
      if (y + font.height > r.unten) break;
      text(zeilen[i], r.x, y, farbe: farbe);
      y += zeilenHoehe;
    }
    return y - r.y;
  }

  /// Knopf; liefert true, wenn er in diesem Bild ausgelöst wurde (Tippen/Klick
  /// oder Bestätigen bei Fokus).
  bool knopf(Rechteck r, String beschriftung, {bool aktiv = true, bool hervorgehoben = false, int? taste}) {
    _flaechen.add(r);
    final idx = _fokusAnzahl++;
    final hatFokus = fokusSichtbar && idx == fokus;
    var gedrueckt = false;
    for (final p in _jetzt.entries) {
      final s = _start[p.key];
      if (s != null && r.enthaelt(s.$1, s.$2) && r.enthaelt(p.value.$1, p.value.$2)) gedrueckt = true;
    }
    var ausgeloest = false;
    if (aktiv) {
      for (final t in _tips) {
        if (r.enthaelt(t.$1, t.$2) && r.enthaelt(t.$3, t.$4)) ausgeloest = true;
      }
      if (hatFokus && _ein.gedrueckt(Taste.bestaetigen)) ausgeloest = true;
    }
    if (ausgeloest) ausgeloestImBild++;
    final grund = !aktiv
        ? UiFarbe.grundDunkel
        : (gedrueckt ? UiFarbe.akzentDunkel : (hervorgehoben ? 51 : UiFarbe.grund));
    final rand = hatFokus ? UiFarbe.akzent : (hervorgehoben ? UiFarbe.akzent : UiFarbe.rand);
    final dy = gedrueckt ? 1 : 0;
    if (!gedrueckt) fb.fillRect(r.x + 1, r.y + 1, r.w, r.h, UiFarbe.schatten);
    fb.fillRect(r.x + dy, r.y + dy, r.w, r.h, rand);
    fb.fillRect(r.x + 1 + dy, r.y + 1 + dy, r.w - 2, r.h - 2, grund);
    if (!gedrueckt) fb.fillRect(r.x + 1, r.y + 1, r.w - 2, 1, hatFokus ? UiFarbe.akzent : UiFarbe.randHell);
    final tw = font.measure(beschriftung);
    final farbe = aktiv ? (hatFokus || gedrueckt ? UiFarbe.akzent : UiFarbe.text) : UiFarbe.textGedimmt;
    text(beschriftung, r.x + (r.w - tw) ~/ 2 + dy, r.y + (r.h - font.height) ~/ 2 + dy + 1, farbe: farbe);
    if (hatFokus) {
      // kleiner Pfeil links als Fokuszeichen (Form statt nur Farbe)
      final ay = r.y + r.h ~/ 2;
      for (var i = 0; i < 3; i++) {
        fb.fillRect(r.x - 5 + i, ay - 2 + i, 1, 5 - 2 * i, UiFarbe.akzent);
      }
    }
    return ausgeloest;
  }

  /// Tippfläche ohne Zeichnung (z. B. Listeneintrag); true bei Auslösung.
  bool tippflaeche(Rechteck r) {
    _flaechen.add(r);
    for (final t in _tips) {
      if (r.enthaelt(t.$1, t.$2) && r.enthaelt(t.$3, t.$4)) return true;
    }
    return false;
  }

  /// Senkrechte Knopfleiste (Menüs). Gibt den Index des ausgelösten Knopfs oder −1.
  int menue(List<String> eintraege, int cx, int y, {int breite = 0, int hoehe = 0, List<bool>? aktiv}) {
    final w = breite > 0 ? breite : eintraege.map(font.measure).fold(0, math.max) + 24;
    final h = hoehe > 0 ? hoehe : font.height + 8;
    var gewaehlt = -1;
    for (var i = 0; i < eintraege.length; i++) {
      final r = Rechteck(cx - w ~/ 2, y + i * (h + 4), w, h);
      if (knopf(r, eintraege[i], aktiv: aktiv == null || aktiv[i])) gewaehlt = i;
    }
    return gewaehlt;
  }

  /// Rahmenlinie (1 px).
  void rahmen(Rechteck r, int farbe) {
    fb.fillRect(r.x, r.y, r.w, 1, farbe);
    fb.fillRect(r.x, r.unten - 1, r.w, 1, farbe);
    fb.fillRect(r.x, r.y, 1, r.h, farbe);
    fb.fillRect(r.rechts - 1, r.y, 1, r.h, farbe);
  }

  /// Gefüllter Pixelkreis (Joystick, Kompass).
  void kreis(int cx, int cy, int radius, int farbe, {bool gefuellt = false}) {
    for (var y = -radius; y <= radius; y++) {
      for (var x = -radius; x <= radius; x++) {
        final d = x * x + y * y;
        if (gefuellt ? d <= radius * radius : (d <= radius * radius && d > (radius - 1) * (radius - 1))) {
          fb.set(cx + x, cy + y, farbe);
        }
      }
    }
  }
}

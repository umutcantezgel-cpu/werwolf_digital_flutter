import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

import '../fallsitzung.dart';
import '../spiel.dart';
import 'hauptmenue.dart';

/// Eingrenzung, Anklage und Ende (Endmatrix EM-1…EM-4, Auflösung).
class AnklageBildschirm extends Bildschirm {
  final Fallsitzung s;
  AnklageBildschirm(this.s);
  bool _standGeloescht = false;

  /// Gewählte Person; die Anklage ist endgültig und wird deshalb noch einmal bestätigt (A-703a).
  String? _gewaehlt;

  @override
  bool get zeigtTutorial => true;

  @override
  bool get zeigtWelt => false;

  @override
  void betreten(Spiel spiel) => spiel.ton.schleife('musik', 'musik_morgengrauen', lautstaerke: 0.5);

  @override
  void tick(Spiel spiel, double dt, Eingabe e) {
    if (s.imNetz) s.tick(dt); // Gastgeber: Ereignisse abholen; der Raum entscheidet
  }

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    final f = s.fall;
    _hintergrund(ui.fb, f.abschnitt == Abschnitt.ende);
    final p = Rechteck(6, 6, w - 12, h - 12);
    ui.panel(p, grund: UiFarbe.grundDunkel);
    var y = p.y + 4;
    if (f.abschnitt == Abschnitt.ende) {
      if (!_standGeloescht && !s.imNetz) {
        _standGeloescht = true;
        spiel.spielstand?.loesche();
        spiel.letzterStand = null;
      }
      final titel = f.daten.kanon.datensaetze[f.ende]?.feld('Ende') ?? f.ende!;
      ui.text('Morgengrauen · Ende: $titel', p.x + 6, y, farbe: UiFarbe.akzent);
      _trennlinie(ui, p, y + ui.font.height + 1);
      y += ui.zeilenHoehe + 4;
      final teile = <String>[
        'Angeklagt: ${f.daten.rollen[f.angeklagt]?.name ?? f.angeklagt}. Punkte: ${f.punkte} von 9.',
        for (final sId in ['S-2', 'S-3', 'S-4', 'S-5', 'S-7']) f.daten.schlussText[sId] ?? '',
        f.daten.kanon.datensaetze['GS-1']?.feld('Kern') ?? '',
        f.daten.kanon.datensaetze['GS-2']?.feld('Kern') ?? '',
      ];
      for (final t in teile) {
        if (y > p.unten - 40) break;
        y += ui.absatz(t, Rechteck(p.x + 8, y, p.w - 16, p.unten - y - 30)) + 3;
      }
      if (ui.knopf(Rechteck(w ~/ 2 - 60, p.unten - 24, 120, 18), 'Zum Hauptmenü')) {
        s.beenden?.call(); // WLAN-Raum schließen bzw. Verbindung trennen
        spiel.wechsle(Hauptmenue());
      }
      return;
    }
    ui.text('Eingrenzung', p.x + 6, y, farbe: UiFarbe.akzent);
    _trennlinie(ui, p, y + ui.font.height + 1);
    y += ui.zeilenHoehe + 2;
    y += ui.absatz(f.eingrenzungsText, Rechteck(p.x + 8, y, p.w - 16, 100)) + 8;
    if (s.ich != FallZustand.detektiv) {
      ui.absatz('Der Detektiv grenzt ein und erhebt gleich die Anklage …', Rechteck(p.x + 8, y, p.w - 16, 30), farbe: UiFarbe.textGedimmt);
      return;
    }
    ui.text('Wen klagst du an?', p.x + 8, y, farbe: UiFarbe.akzent);
    _trennlinie(ui, p, y + ui.font.height + 1);
    y += ui.zeilenHoehe + 4;
    final hoch = h > w;
    final kh = hoch ? 26 : 18;
    final g = _gewaehlt;
    if (g != null) {
      final yq = y;
      final hq = ui.absatz('Anklage gegen ${f.daten.rollen[g]?.name ?? g} erheben? Das ist endgültig.', Rechteck(p.x + 8, y, p.w - 16, 30));
      ui.rahmen(Rechteck(p.x + 6, yq - 1, p.w - 12, hq + 3), UiFarbe.akzent);
      y += hq + 6;
      if (ui.knopf(Rechteck(p.x + 8, y, 160, kh), 'Ja, anklagen')) {
        s.klageAn(g);
        _gewaehlt = null;
        spiel.ton.spiele('schreck', lautstaerke: 0.6);
      }
      if (ui.knopf(Rechteck(p.x + 176, y, 120, kh), 'Abbrechen')) _gewaehlt = null;
      return;
    }
    for (final r in f.verdaechtigenkreis) {
      final kn = Rechteck(p.x + 8, y, math.min(260, p.w - 16), kh);
      if (ui.knopf(kn, f.daten.rollen[r]?.name ?? r)) _gewaehlt = r;
      _siegel(ui, kn);
      y += kh + 4;
    }
  }

  /// Hintergrund unter dem Panel (Burgstadt HD, P7-AUTOR-10): im Abschnitt Ende ein
  /// Morgengrauen-Himmel mit Bayer-Übergängen, sonst ein ruhiges Nachtblau-Raster.
  /// Nur Palettenindizes, kein Rauschen.
  void _hintergrund(PixelBuffer fb, bool ende) {
    final w = fb.width, h = fb.height;
    if (!ende) {
      fb.fillRect(0, 0, w, h, Ramp.at16(Ramp.blue, 1));
      for (var y = 0; y < h; y += 4) {
        for (var x = 0; x < w; x += 4) {
          fb.set(x, y, Ramp.at16(Ramp.blue, 2));
        }
      }
      return;
    }
    // Bänder von oben nach unten: Blau 1, Blau 4, Rot 4, Bernstein 5. Jede Grenze ist ein
    // Übergang aus zwei Zeilen: erste Zeile 75 % oberes Band, zweite 25 % (bayer4).
    final grenzen = [h * 2 ~/ 5, h * 3 ~/ 5, h * 4 ~/ 5];
    final baender = [Ramp.at16(Ramp.blue, 1), Ramp.at16(Ramp.blue, 4), Ramp.at16(Ramp.red, 4), Ramp.at16(Ramp.amber, 5)];
    for (var y = 0; y < h; y++) {
      final k = grenzen.indexWhere((g) => y >= g && y < g + 2);
      if (k >= 0) {
        final obenAnteil = y == grenzen[k] ? 12 : 4;
        for (var x = 0; x < w; x++) {
          fb.set(x, y, bayer4[((y & 3) << 2) | (x & 3)] < obenAnteil ? baender[k] : baender[k + 1]);
        }
      } else {
        fb.fillRect(0, y, w, 1, baender[grenzen.where((g) => y >= g).length]);
      }
    }
  }

  /// Trennlinie unter einer Überschrift: 1 px in `randDunkel`, darunter 1 px `randHell` (Fase).
  void _trennlinie(PixelUi ui, Rechteck p, int y) {
    ui.fb.fillRect(p.x + 6, y, p.w - 12, 1, UiFarbe.randDunkel);
    ui.fb.fillRect(p.x + 6, y + 1, p.w - 12, 1, UiFarbe.randHell);
  }

  /// Pixel-Siegel links im Verdächtigen-Knopf (Feld 10×10, reine Zier): roter Kreis Ø 8 mit
  /// 1-px-Glanz oben links. Beschriftung und Trefferfläche bleiben unverändert.
  void _siegel(PixelUi ui, Rechteck r) {
    final x0 = r.x + 4, y0 = r.y + (r.h - 10) ~/ 2;
    for (var y = 0; y < 8; y++) {
      for (var x = 0; x < 8; x++) {
        final dx = 2 * x - 7, dy = 2 * y - 7;
        if (dx * dx + dy * dy <= 64) ui.fb.set(x0 + 1 + x, y0 + 1 + y, Ramp.at16(Ramp.red, 6));
      }
    }
    ui.fb.set(x0 + 3, y0 + 3, Ramp.at16(Ramp.red, 9));
  }
}

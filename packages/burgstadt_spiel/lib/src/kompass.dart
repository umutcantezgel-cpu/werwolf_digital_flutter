import 'dart:math' as math;

import 'package:pixel_engine/pixel_engine.dart';

/// Kompass-Streifen fürs HUD: waagerecht, mit N/O/S/W und Strichen, die sich mit der
/// Blickrichtung verschieben. Norden ist −z (also `yaw = −π/2`), `yaw = 0` blickt nach
/// Osten (+x). Sichtbar ist ±100° um die Blickrichtung. Nur Palettenfarben.

/// Eine Marke des Streifens: [x] ab linker Kante, [text] nur bei N/O/S/W, [lang] für die
/// Striche alle 45° (sonst alle 15°).
typedef KompassMarke = ({int x, String? text, bool lang});

const double _halbSicht = 100 * math.pi / 180;

/// Winkel auf [−π, π).
double _winkel(double a) => (a + math.pi) % (2 * math.pi) - math.pi;

/// Marken für die Blickrichtung [yaw] auf einem Streifen von [breite] Pixeln; die Mitte
/// der Blickrichtung liegt bei `breite ~/ 2`.
List<KompassMarke> kompassMarken(double yaw, int breite) {
  final mitte = breite ~/ 2;
  final proRad = (breite / 2) / _halbSicht;
  final out = <KompassMarke>[];
  for (var j = 0; j < 24; j++) {
    // j = 0 ist Norden; je 15° weiter im Uhrzeigersinn (von oben gesehen).
    final rel = _winkel(-math.pi / 2 + j * math.pi / 12 - yaw);
    if (rel.abs() > _halbSicht) continue;
    final text = switch (j) {
      0 => 'N',
      6 => 'O',
      12 => 'S',
      18 => 'W',
      _ => null,
    };
    out.add((x: mitte + (rel * proRad).round(), text: text, lang: j % 3 == 0));
  }
  return out;
}

/// Innenfarbe der Zeile [y]: oben Licht (Blau 4), unten Schatten (Blau 1), sonst Hintergrund.
int _innenFarbe(Rechteck r, int y) => y == r.y + 1
    ? Ramp.at16(Ramp.blue, 4)
    : y == r.unten - 2
        ? Ramp.at16(Ramp.blue, 1)
        : UiFarbe.grundDunkel;

/// Schachbrett an den Rändern: in den ersten und letzten 6 Innenspalten bleibt jedes zweite
/// Pixel leer, damit Striche und Buchstaben weich auslaufen statt hart abgeschnitten zu wirken.
void _randAbblenden(PixelBuffer fb, Rechteck r) {
  for (var y = r.y + 1; y < r.unten - 1; y++) {
    for (var i = 0; i < 6; i++) {
      for (final x in [r.x + 1 + i, r.rechts - 2 - i]) {
        if ((x + y).isEven) fb.set(x, y, _innenFarbe(r, y));
      }
    }
  }
}

/// Zeichnet den Streifen [r] für die Blickrichtung [yaw] (Höhe mindestens 14 Pixel).
/// Die Himmelsrichtung nahe der Mitte steht in Akzentfarbe, „N“ immer in Nordmarke-Rot.
void zeichneKompass(PixelUi ui, double yaw, Rechteck r) {
  final fb = ui.fb;
  final mitte = r.w ~/ 2;
  final marken = kompassMarken(yaw, r.w);
  // Innenfläche: Licht oben, Schatten unten; Rand 1 px, Ecken bleiben frei
  for (var y = r.y + 1; y < r.unten - 1; y++) {
    fb.fillRect(r.x + 1, y, r.w - 2, 1, _innenFarbe(r, y));
  }
  // Striche, unten bündig: N/O/S/W 5 px, 45° 4 px, 15° 2 px
  for (final m in marken) {
    final hoehe = m.text != null ? 5 : (m.lang ? 4 : 2);
    final farbe = m.lang ? UiFarbe.randHell : Ramp.at16(Ramp.stone, 9);
    fb.fillRect(r.x + m.x, r.unten - 1 - hoehe, 1, hoehe, farbe);
  }
  // Mittelmarke: Dreieck unter dem Rand, darunter eine Linie bis zur Strichzone
  final cx = r.x + mitte;
  fb.fillRect(cx - 1, r.y + 1, 3, 1, UiFarbe.akzent);
  fb.fillRect(cx, r.y + 2, 1, 1, UiFarbe.akzent);
  fb.fillRect(cx, r.y + 3, 1, r.h - 9, UiFarbe.akzent);
  // Buchstaben wie bisher; der Buchstabe nahe der Mitte in Akzent, „N“ immer in Nordmarke-Rot
  for (final m in marken) {
    final t = m.text;
    if (t == null || m.x < 3 || m.x >= r.w - 3) continue;
    final nah = (m.x - mitte).abs() <= 4;
    final farbe = t == 'N' ? Ramp.at16(Ramp.red, 11) : (nah ? UiFarbe.akzent : UiFarbe.text);
    ui.textMittig(t, r.x + m.x, r.y + 1, farbe: farbe);
  }
  _randAbblenden(fb, r);
  // Rand zuletzt, damit Striche in den Randspalten ihn nicht überschreiben
  fb.fillRect(r.x + 1, r.y, r.w - 2, 1, UiFarbe.rand);
  fb.fillRect(r.x + 1, r.unten - 1, r.w - 2, 1, UiFarbe.rand);
  fb.fillRect(r.x, r.y + 1, 1, r.h - 2, UiFarbe.rand);
  fb.fillRect(r.rechts - 1, r.y + 1, 1, r.h - 2, UiFarbe.rand);
}

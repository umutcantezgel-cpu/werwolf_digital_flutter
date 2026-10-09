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

/// Zeichnet den Streifen [r] für die Blickrichtung [yaw] (Höhe mindestens 14 Pixel).
/// Die Himmelsrichtung in der Mitte steht in Akzentfarbe.
void zeichneKompass(PixelUi ui, double yaw, Rechteck r) {
  final fb = ui.fb;
  fb.fillRect(r.x, r.y, r.w, r.h, UiFarbe.grundDunkel);
  ui.rahmen(r, UiFarbe.rand);
  final mitte = r.w ~/ 2;
  for (final m in kompassMarken(yaw, r.w)) {
    final x = r.x + m.x;
    final oben = r.unten - (m.lang ? 5 : 3);
    fb.fillRect(x, oben, 1, r.unten - 1 - oben, m.lang ? UiFarbe.randHell : UiFarbe.rand);
    final t = m.text;
    if (t != null && m.x >= 3 && m.x < r.w - 3) {
      final nah = (m.x - mitte).abs() <= 4;
      ui.textMittig(t, x, r.y + 1, farbe: nah ? UiFarbe.akzent : UiFarbe.text);
    }
  }
}

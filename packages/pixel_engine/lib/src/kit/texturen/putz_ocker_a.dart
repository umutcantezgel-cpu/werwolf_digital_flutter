import '../../palette.dart';
import '../../raster/texture.dart';
import '../werkzeug.dart';

/// Ockerfarbener Fassadenputz des Marktviertels, Variante A (Burgstadt HD, P1-AUTOR-05; Kandidat für putzOcker).
/// Gealterter Kalkputz: Grund Amber 8, darauf drei dunklere (Stufe 7) und zwei hellere (Stufe 9) weiche Wolken,
/// zwei Ausbesserungsflecken, zwei abgeplatzte Stellen mit durchscheinendem Bruchstein und zwei feine Haarrisse.
/// 128×128 (2 m), kachelbar, Licht von oben links. Zufall nur über [Lcg] mit festem Seed.
IndexedTexture putzOckerV2A() {
  const n = 128;
  final t = Tex(n);
  final r = Lcg(5105);
  t.fill(Ramp.at16(Ramp.amber, 8));
  for (final (x, y) in const [(18, 30), (84, 50), (44, 108)]) {
    _wolke(t, r, x, y, Ramp.at16(Ramp.amber, 7));
  }
  for (final (x, y) in const [(66, 20), (104, 110)]) {
    _wolke(t, r, x, y, Ramp.at16(Ramp.amber, 9));
  }
  _ausbesserung(t, 8, 70, 14, 11);
  _ausbesserung(t, 78, 72, 11, 13);
  _abplatzung(t, 92, 34, 9, 8);
  _abplatzung(t, 28, 52, 7, 9);
  _haarriss(t, r, 50, 40, 6 + r.below(7), Ramp.at16(Ramp.amber, 5));
  _haarriss(t, r, 30, 90, 6 + r.below(7), Ramp.at16(Ramp.amber, 5));
  return t.build();
}

/// Weiche Wolke: zusammenhängende Fläche von 20–40 Texeln um (cx, cy). Sie wächst zufällig in die
/// Nachbarschaft, daher hängt jeder Texel mit der Wolke zusammen und es entstehen keine Einzelpixel.
void _wolke(Tex t, Lcg r, int cx, int cy, int c) {
  final n = t.n;
  const schritte = [(1, 0), (-1, 0), (0, 1), (0, -1)];
  final felder = <(int, int)>{(cx, cy)};
  final ziel = 20 + r.below(21);
  while (felder.length < ziel) {
    final liste = felder.toList();
    final (x, y) = liste[r.below(liste.length)];
    final (dx, dy) = schritte[r.below(schritte.length)];
    felder.add(((x + dx + n) % n, (y + dy + n) % n));
  }
  for (final (x, y) in felder) {
    t.p(x, y, c);
  }
}

/// Ausbesserungsfleck: Rechteck w×h in Stufe 9; oben und links eine Texel-Kante in Stufe 10 (Licht),
/// unten und rechts eine in Stufe 6 (Schatten).
void _ausbesserung(Tex t, int x0, int y0, int w, int h) {
  final mitte = Ramp.at16(Ramp.amber, 9);
  final licht = Ramp.at16(Ramp.amber, 10);
  final schatten = Ramp.at16(Ramp.amber, 6);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      if (y == 0 || x == 0) {
        t.p(x0 + x, y0 + y, licht);
      } else if (y == h - 1 || x == w - 1) {
        t.p(x0 + x, y0 + y, schatten);
      } else {
        t.p(x0 + x, y0 + y, mitte);
      }
    }
  }
}

/// Abgeplatzte Stelle: Ellipse w×h, in der der Bruchstein durchscheint. Oben und links die Bruchkante
/// in Amber 10, unten und rechts Amber 5. Im Stein Stufe 7 oben links, 6 in der Mitte, 5 unten rechts.
void _abplatzung(Tex t, int x0, int y0, int w, int h) {
  bool innen(int x, int y) {
    final u = 2 * x - (w - 1), v = 2 * y - (h - 1);
    return u * u * h * h + v * v * w * w <= w * w * h * h;
  }

  final kante = Ramp.at16(Ramp.amber, 10);
  final schatten = Ramp.at16(Ramp.amber, 5);
  final drittel = (w + h) ~/ 3;
  final diagonale = w + h - 2;
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      if (!innen(x, y)) continue;
      if (!innen(x, y - 1) || !innen(x - 1, y)) {
        t.p(x0 + x, y0 + y, kante);
      } else if (!innen(x, y + 1) || !innen(x + 1, y)) {
        t.p(x0 + x, y0 + y, schatten);
      } else {
        final s = x + y;
        if (s < drittel) {
          t.p(x0 + x, y0 + y, Ramp.at16(Ramp.stone, 7));
        } else if (s >= diagonale - drittel) {
          t.p(x0 + x, y0 + y, Ramp.at16(Ramp.stone, 5));
        } else {
          t.p(x0 + x, y0 + y, Ramp.at16(Ramp.stone, 6));
        }
      }
    }
  }
}

/// Feiner Haarriss: 4-verbundene Linie (je Schritt nach rechts oder unten), damit kein Einzelpixel entsteht.
void _haarriss(Tex t, Lcg r, int x0, int y0, int laenge, int c) {
  var x = x0, y = y0;
  for (var i = 0; i < laenge; i++) {
    t.p(x, y, c);
    if (r.below(2) == 0) {
      x++;
    } else {
      y++;
    }
  }
}

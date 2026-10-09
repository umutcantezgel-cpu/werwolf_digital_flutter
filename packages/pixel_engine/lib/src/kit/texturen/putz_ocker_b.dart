import '../../palette.dart';
import '../../raster/texture.dart';
import '../werkzeug.dart';

/// Ockerfarbener Fassadenputz des Marktviertels, Variante B (Burgstadt HD, P1-VAR-02; Kandidat für putzOcker).
/// Kalkputz mit Kellenzügen: sechs waagerechte Bänder aus überlappenden, flach gewölbten Streifen
/// (3–5 Texel hoch, Bogenhöhe 2–3 Texel, 30–50 Texel lang). Grund Amber 8, Oberkante je Streifen Amber 9,
/// Unterkante Amber 7. Dazu ein Feuchtigkeitsfleck unten mit gewellter Oberkante.
/// 128×128 (2 m), kachelbar, Licht von oben links. Zufall nur über [Lcg] mit festem Seed.
IndexedTexture putzOckerV2B() {
  const n = 128;
  const baender = 6;
  final t = Tex(n);
  final r = Lcg(6207);
  t.fill(Ramp.at16(Ramp.amber, 8));
  for (var b = 0; b < baender; b++) {
    final yBand = (b * n) ~/ baender + r.below(7) - 3;
    var x = r.below(n);
    final ende = x + n;
    while (x < ende) {
      final laenge = 30 + r.below(21);
      final hoehe = 3 + r.below(3);
      final bogen = 2 + r.below(2);
      _kellenzug(t, x, yBand, laenge, hoehe, bogen);
      x += laenge - (4 + r.below(5));
    }
  }
  _feuchtigkeit(t, r.below(n), 106 + r.below(6), 20 + r.below(11), r.below(7));
  _einzelpixelWeg(t);
  return t.build();
}

/// Einzelpixel, die beim Überlagern zweier Streifen übrig bleiben (Körper zwischen Ober- und Unterkante),
/// nehmen die Farbe ihres oberen Nachbarn an. Die Prüfung in kit/textur_pruefung.dart bleibt damit ohne Befund.
void _einzelpixelWeg(Tex t) {
  for (var y = 0; y < t.n; y++) {
    for (var x = 0; x < t.n; x++) {
      final c = t.g(x, y);
      if (t.g(x, y - 1) != c && t.g(x, y + 1) != c && t.g(x - 1, y) != c && t.g(x + 1, y) != c) {
        t.p(x, y, t.g(x, y - 1));
      }
    }
  }
}

/// Ein Kellenzug: flach gewölbter Streifen ab Spalte [x0]. Die Oberkante liegt am Rand [bogen] Texel
/// tiefer als in der Mitte. Der Körper ist Grund, die Oberkante Amber 9, die Unterkante Amber 7.
/// Ein Streifen überdeckt, was vorher gezeichnet war, so entsteht die Schuppenlage.
void _kellenzug(Tex t, int x0, int y0, int laenge, int hoehe, int bogen) {
  final grund = Ramp.at16(Ramp.amber, 8);
  final licht = Ramp.at16(Ramp.amber, 9);
  final schatten = Ramp.at16(Ramp.amber, 7);
  final oben = <int>[
    for (var k = 0; k < laenge; k++) y0 + bogen - (4 * bogen * k * (laenge - k)) ~/ (laenge * laenge),
  ];
  for (var k = 0; k < laenge; k++) {
    for (var j = 0; j < hoehe; j++) {
      t.p(x0 + k, oben[k] + j, grund);
    }
  }
  _kante(t, x0, oben, licht);
  _kante(t, x0, [for (final y in oben) y + hoehe - 1], schatten);
}

/// Verbindet die Punkte (x0 + k, ys[k]) lückenlos: je Spalte alle Zeilen zwischen ihrem Punkt und dem der
/// Vorgängerspalte. So bleibt die Linie 4-verbunden und es entstehen keine Einzelpixel.
void _kante(Tex t, int x0, List<int> ys, int c) {
  for (var k = 0; k < ys.length; k++) {
    final vorher = k == 0 ? ys[0] : ys[k - 1];
    final lo = vorher < ys[k] ? vorher : ys[k];
    final hi = vorher < ys[k] ? ys[k] : vorher;
    for (var y = lo; y <= hi; y++) {
      t.p(x0 + k, y, c);
    }
  }
}

/// Feuchtigkeitsfleck in Amber 7: [breite] Texel breit, Oberkante gewellt (0–2 Texel), Unterkante 7–9 Texel
/// unter dem Anfang. Je Spalte 6–10 Texel hoch, zusammenhängend.
void _feuchtigkeit(Tex t, int x0, int y0, int breite, int phase) {
  final c = Ramp.at16(Ramp.amber, 7);
  for (var k = 0; k < breite; k++) {
    final oben = y0 + _welle(k, 6, 0);
    final unten = y0 + 7 + _welle(k, 7, phase);
    for (var y = oben; y <= unten; y++) {
      t.p(x0 + k, y, c);
    }
  }
}

/// Dreieckswelle mit Werten 0 … 2 über die Periode [periode] (6 oder 7), verschoben um [phase].
int _welle(int k, int periode, int phase) {
  final m = (k + phase) % periode;
  final dreieck = m <= periode ~/ 2 ? m : periode - m;
  return (dreieck * 2) ~/ 3;
}

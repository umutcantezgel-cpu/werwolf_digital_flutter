import '../../palette.dart';
import '../../raster/texture.dart';
import '../werkzeug.dart';

/// Pflaster v2, Variante B (★ P1-VAR-01, Burgstadt HD): Segmentbogenpflaster als Fächer, 128 × 128 (2 m).
///
/// Jede Kachel hat zwei Bogenreihen zu je 64 × 64 Texel. Ein Bogen ist ein Halbkreis mit 64 Texel
/// Bogenbreite: Scheitel oben, die Öffnung zeigt nach unten auf die Linie der Reihe. Der Bogen ist ein
/// Fächer aus vier Halbringen (je 8 Texel breit), radial in Steine geteilt, die im Mittelpunkt auf
/// der Bogenlinie zusammenlaufen. Die Zwickel zwischen den Bögen füllt ein versetztes Raster kleiner
/// Steine (8 × 8 Texel).
///
/// Fugen sind 2 Texel breit und Stufe 3. Der Steinkörper hat Stufe 7 bis 9, je Stein gezogen über Lcg.
/// Licht oben links: Oberkante und linke Kante +2 Stufen, Unterkante und rechte Kante −2 Stufen.
/// Alles ist ganzzahlig und deterministisch: die Fächerwinkel kommen aus festen Strahlen, ohne Trigonometrie.
/// Kein Grün, keine Einzelpixel.

/// Kachelgröße in Texel.
const int _n = 128;

/// Halber Bogen: Radius des Bogens in Texel (Bogenbreite 64).
const int _bogen = 32;

/// Strahlen des Fächers in 15°-Schritten von 15° bis 165° (Richtung ganzzahlig, Maßstab 1000).
const List<(int, int)> _strahlen = [
  (966, 259), (866, 500), (707, 707), (500, 866), (259, 966), (0, 1000),
  (-259, 966), (-500, 866), (-707, 707), (-866, 500), (-966, 259),
];

/// Strahlen des Außenrings in 20°-Schritten von 20° bis 160° (neun Steine je Bogen).
const List<(int, int)> _strahlen20 = [
  (940, 342), (766, 643), (500, 866), (174, 985), (-174, 985), (-500, 866), (-766, 643), (-940, 342),
];

/// Fächerbreite der inneren Halbringe in 15°-Schritten: Kern 6 (2 Steine), Ring 1 (4), Ring 2 (6).
const List<int> _breite = [6, 3, 2];

/// Stufe der Fugen (Stein-Rampe, 16er-Skala).
const int _fugeStufe = 3;

/// Index in der Kachel, mit Umbruch.
int _i(int x, int y) => ((y % _n) + _n) % _n * _n + ((x % _n) + _n) % _n;

/// Fächerwinkel eines Punkts über dem Bogenmittelpunkt (dx nach rechts, dy nach oben, dy ≥ 1):
/// Anzahl der Strahlen aus [strahlen], die der Punkt links von sich hat. 0 am rechten Fuß, Anzahl am linken Fuß.
int _fach(int dx, int dy, List<(int, int)> strahlen) {
  var f = 0;
  for (final (ax, ay) in strahlen) {
    if (ax * dy - ay * dx > 0) f++;
  }
  return f;
}

/// Ring des Bogens nach Abstand² vom Mittelpunkt: 0 Kern (bis 8), 1 (bis 16), 2 (bis 24), 3 Außenring (bis 32).
int _ring(int r2) {
  if (r2 < 64) return 0;
  if (r2 < 256) return 1;
  if (r2 < 576) return 2;
  return 3;
}

/// Stein-Nummer eines Texels vor dem Fugenschnitt: Bogenstein (Bogen, Ring, Fächerstrahl) oder Zwickelstein.
/// [versatz] gibt je Zwickelreihe (8 Texel hoch) den horizontalen Versatz 0–7 an.
int _stein(int x, int y, List<int> versatz) {
  final dx = x % 64 - 32, dy = 64 - y % 64;
  final bogenNr = x ~/ 64 + 2 * (y ~/ 64);
  final r2 = dx * dx + dy * dy;
  if (r2 <= _bogen * _bogen) {
    final ring = _ring(r2);
    final sektor = ring == 3 ? _fach(dx, dy, _strahlen20) : _fach(dx, dy, _strahlen) ~/ _breite[ring];
    return bogenNr * 100 + ring * 10 + sektor;
  }
  final reihe = y ~/ 8;
  final gx = (x + versatz[reihe]) % _n;
  return 1000 + reihe * 16 + gx ~/ 8;
}

/// Pixeltextur Pflaster v2 Variante B (Kandidat `pflaster_b`).
IndexedTexture pflasterV2B() {
  final vr = Lcg(4099);
  final reihenVersatz = List<int>.generate(_n ~/ 8, (_) => vr.below(8));
  final id = List<int>.generate(_n * _n, (k) => _stein(k % _n, k ~/ _n, reihenVersatz));

  // Reste unter 24 Texel (Zwickelstücke am Bogenrand) gelten als Fuge.
  final groesse = <int, int>{};
  for (final s in id) {
    groesse[s] = (groesse[s] ?? 0) + 1;
  }
  for (var k = 0; k < id.length; k++) {
    if (groesse[id[k]]! < 24) id[k] = -1;
  }

  // Fuge: Texel ohne Stein oder mit einem Nachbarn aus einem anderen Stein. So sind Fugen 2 Texel breit.
  final fuge = List<bool>.generate(_n * _n, (k) {
    final x = k % _n, y = k ~/ _n;
    final s = id[k];
    return s < 0 || id[_i(x - 1, y)] != s || id[_i(x + 1, y)] != s || id[_i(x, y - 1)] != s || id[_i(x, y + 1)] != s;
  });

  final r = Lcg(4217);
  final koerper = <int, int>{};
  final t = Tex(_n);
  for (var y = 0; y < _n; y++) {
    for (var x = 0; x < _n; x++) {
      if (fuge[_i(x, y)]) {
        t.p(x, y, Ramp.at16(Ramp.stone, _fugeStufe));
        continue;
      }
      final k = koerper.putIfAbsent(id[_i(x, y)], () => 7 + r.below(3));
      final oben = fuge[_i(x, y - 1)] || fuge[_i(x - 1, y)];
      final unten = fuge[_i(x, y + 1)] || fuge[_i(x + 1, y)];
      final stufe = oben ? k + 2 : (unten ? k - 2 : k);
      t.p(x, y, Ramp.at16(Ramp.stone, stufe));
    }
  }
  return t.build();
}

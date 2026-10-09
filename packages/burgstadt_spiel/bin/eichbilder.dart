// Eichbilder (P0-AUTOR-05, HZ-04): 18 Prüfbilder mit bekanntem Befund, mit denen die
// Haiku-Sichtprüfer geeicht werden. Aufruf aus packages/burgstadt_spiel:
//   dart run bin/eichbilder.dart <bildordner> <loesungsdatei>
// Schreibt eich_01.png … eich_18.png in fester, gemischter Reihenfolge und die Lösung als
// Markdown-Tabelle. Alles ist deterministisch: eigener LCG mit festem Seed, keine Uhr.

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';

const _breite = 640;
const _hoehe = 360;
const _blockKante = 256; // Kantenlänge eines Kachelblocks: Kacheln × Texel × Zoom
const _zoom = 2; // Spielmaßstab: Welt-Pixel = 2 Bildpixel
const _blockX = (_breite - _blockKante) ~/ 2; // 192
const _blockY = (_hoehe - _blockKante) ~/ 2; // 52
const _nutzung = 'Aufruf (aus packages/burgstadt_spiel):\n'
    '  dart run bin/eichbilder.dart <bildordner> <loesungsdatei>';

/// Stufen je Rampe in der Stufung der Palette v1 (`Ramp.at`): Der Eichsatz bleibt bildgleich.
const _stufenV1 = 8;

final _helleFarbe = Ramp.at(Ramp.stone, 6);
final _dunkleFarbe = Ramp.at(Ramp.stone, 2);

/// Eigener LCG mit festem Seed (kein dart:math Random).
class _Lcg {
  _Lcg(this._s);
  int _s;

  int next() {
    _s = (_s * 1664525 + 1013904223) % 4294967296;
    return _s ~/ 65536;
  }

  int below(int k) => next() % k;
}

/// Ein Prüfbild mit seiner Lösung (eine Zeile der Tabelle).
class _Bild {
  _Bild(this.rgba, this.art, this.ort, this.beschreibung);
  final Uint8List rgba;
  final String art, ort, beschreibung;
}

void main(List<String> args) {
  if (args.length != 2) {
    stderr.writeln('Bildordner und Lösungsdatei fehlen.\n$_nutzung');
    exit(2);
  }
  final bilder = _Werkstatt().alle();
  final reihe = _mischung(bilder.length);
  final ordner = Directory(args[0])..createSync(recursive: true);
  final tabelle = StringBuffer('| Bild | fehlerfrei/Fehlerart | Ort im Bild | Beschreibung |\n|---|---|---|---|\n');
  for (var i = 0; i < reihe.length; i++) {
    final b = bilder[reihe[i]];
    final name = 'eich_${(i + 1).toString().padLeft(2, '0')}.png';
    File('${ordner.path}/$name').writeAsBytesSync(encodePngRgba(_breite, _hoehe, b.rgba, zlib: zlib.encode));
    tabelle.writeln('| $name | ${b.art} | ${b.ort} | ${b.beschreibung} |');
  }
  File(args[1]).parent.createSync(recursive: true);
  File(args[1]).writeAsStringSync(tabelle.toString());
  stdout.writeln('${bilder.length} Bilder geschrieben.');
}

/// Feste, gemischte Reihenfolge (Fisher-Yates mit eigenem LCG): Position i zeigt reihe[i].
List<int> _mischung(int n) {
  final reihe = [for (var i = 0; i < n; i++) i];
  final r = _Lcg(4711);
  for (var i = n - 1; i > 0; i--) {
    final j = r.below(i + 1);
    final t = reihe[i];
    reihe[i] = reihe[j];
    reihe[j] = t;
  }
  return reihe;
}

String _markeVon(Bereich b) => b.marken.containsKey('t') ? 't' : (b.marken.containsKey('b') ? 'b' : b.marken.keys.first);

PixelBuffer _leinwand() => PixelBuffer(_breite, _hoehe)..clear(Pal.black);

/// Kachelt Stufe [stufe] von [t] n×n-fach, jeder Texel um [zoom] vergrößert, nach [ziel] bei (x0, y0).
void _kachel(PixelBuffer ziel, IndexedTexture t, int stufe, int zoom, int x0, int y0, {required int n}) {
  final w = t.widths[stufe], h = t.heights[stufe], px = t.levels[stufe];
  for (var y = 0; y < n * h * zoom; y++) {
    for (var x = 0; x < n * w * zoom; x++) {
      final c = px[((y ~/ zoom) % h) * w + (x ~/ zoom) % w];
      if (c != kTransparent) ziel.set(x0 + x, y0 + y, c);
    }
  }
}

/// Kacheln je Seite eines Blocks bei Vergrößerung ×2 (Spielmaßstab): 4 bei 32 Texeln, 2 bei 64.
int _kachelnFuer(IndexedTexture t) => _blockKante ~/ (_zoom * t.width);

/// Farbe derselben Rampe wie [alt], nie [alt] selbst.
int _andereFarbe(int alt, int rampe, _Lcg r) {
  var c = Ramp.at(rampe, r.below(_stufenV1));
  if (c == alt) c = Ramp.at(rampe, (stufe8Von(c) + 1) % _stufenV1);
  return c;
}

/// Rauschen in einer Textur: jeder Pixel mit 30 % Wahrscheinlichkeit durch eine andere Farbe
/// derselben Rampe ersetzt. Gibt die Textur und die Zahl der geänderten Pixel zurück.
(IndexedTexture, int) _rauschenTextur(IndexedTexture t, int rampe, _Lcg r) {
  final px = Uint8List.fromList(t.levels[0]);
  var geaendert = 0;
  for (var i = 0; i < px.length; i++) {
    if (r.below(100) < 30) {
      px[i] = _andereFarbe(px[i], rampe, r);
      geaendert++;
    }
  }
  return (IndexedTexture(t.width, t.height, px), geaendert);
}

/// Rauschen auf einer Bildfläche der Welt: dominante Rampe der Fläche, 30 % der Pixel ersetzt.
int _rauschenFlaeche(PixelBuffer b, int x0, int y0, int w, int h, _Lcg r) {
  final zaehl = List<int>.filled(Ramp.count, 0);
  for (var y = y0; y < y0 + h; y++) {
    for (var x = x0; x < x0 + w; x++) {
      zaehl[rampeVon(b.get(x, y))]++;
    }
  }
  var rampe = 0;
  for (var k = 1; k < Ramp.count; k++) {
    if (zaehl[k] > zaehl[rampe]) rampe = k;
  }
  var geaendert = 0;
  for (var y = y0; y < y0 + h; y++) {
    for (var x = x0; x < x0 + w; x++) {
      if (r.below(100) < 30) {
        final i = y * b.width + x;
        b.color[i] = _andereFarbe(b.color[i], rampe, r);
        geaendert++;
      }
    }
  }
  return geaendert;
}

/// Boden im Spiel-Raster (Welt, Blick waagerecht): jede Zeile ist eine Tiefe z, jede Spalte eine
/// Stelle auf dem Boden. Texel nearest, keine Mip-Stufe; oben liegt der dunkle Himmel.
void _boden(PixelBuffer b, IndexedTexture t, double fovY) {
  const augenHoehe = 1.62, texelProMeter = 32.0;
  final cx = b.width / 2, cy = b.height / 2;
  final brennweite = cy / math.tan(fovY / 2);
  final w = t.widths[0], h = t.heights[0], px = t.levels[0];
  for (var y = 0; y < b.height; y++) {
    final dy = y + 0.5 - cy;
    if (dy <= 0) {
      b.fillRect(0, y, b.width, 1, Pal.nightBlue);
      continue;
    }
    final z = augenHoehe * brennweite / dy;
    final zeile = (z * texelProMeter).floor() % h;
    for (var x = 0; x < b.width; x++) {
      final seite = (x + 0.5 - cx) * z / brennweite;
      b.set(x, y, px[zeile * w + (seite * texelProMeter).floor() % w]);
    }
  }
}

/// 1-Texel-Streifen im Wechsel (senkrecht), 32×32.
IndexedTexture _streifen() => IndexedTexture(32, 32, Uint8List.fromList([for (var y = 0; y < 32; y++) for (var x = 0; x < 32; x++) x.isEven ? _helleFarbe : _dunkleFarbe]));

/// Feines Schachbrett aus 1-Texel-Feldern, 32×32.
IndexedTexture _schach() => IndexedTexture(32, 32, Uint8List.fromList([for (var y = 0; y < 32; y++) for (var x = 0; x < 32; x++) (x + y).isEven ? _helleFarbe : _dunkleFarbe]));

/// Putz mit weichem Verlauf: 16 Stufen aus zwei Rampen, von links nach rechts nach Helligkeit.
IndexedTexture _verlaufPutz() {
  final stufen = [for (final r in [Ramp.skin, Ramp.amber]) for (var s = 0; s < _stufenV1; s++) Ramp.at(r, s)]
    ..sort((a, b) => _helligkeit(a).compareTo(_helligkeit(b)));
  const n = 32;
  final px = Uint8List(n * n);
  for (var y = 0; y < n; y++) {
    for (var x = 0; x < n; x++) {
      px[y * n + x] = stufen[x * (stufen.length - 1) ~/ (n - 1)];
    }
  }
  return IndexedTexture(n, n, px);
}

int _helligkeit(int i) => 2126 * paletteR(i) + 7152 * paletteG(i) + 722 * paletteB(i);

/// Textur um beide Achsen gedreht: das Licht kommt nun von unten rechts.
IndexedTexture _gedreht(IndexedTexture t) {
  final n = t.width, px = t.levels[0];
  final out = Uint8List(n * n);
  for (var y = 0; y < n; y++) {
    for (var x = 0; x < n; x++) {
      out[y * n + x] = px[(n - 1 - y) * n + (n - 1 - x)];
    }
  }
  return IndexedTexture(n, n, out);
}

/// Mauer mit 1-Texel-Fugen in der dunkelsten Stufe der Rampe. Die Fugen liegen so, dass die
/// 2×2-Mehrheit der Mip-1-Stufe sie überall verdrängt (wird unten im Code geprüft).
IndexedTexture _fugenDuenn() {
  const n = 32;
  final koerper = Ramp.at(Ramp.stone, 4), fuge = Ramp.at(Ramp.stone, 0);
  final px = Uint8List(n * n)..fillRange(0, n * n, koerper);
  for (var band = 0; band < 4; band++) {
    final y0 = band * 8;
    for (var x = 0; x < n; x++) {
      px[(y0 + 7) * n + x] = fuge;
    }
    final s = band.isEven ? 5 : 13;
    for (var y = y0; y < y0 + 6; y++) {
      px[y * n + s] = fuge;
      px[y * n + s + 16] = fuge;
    }
  }
  final t = IndexedTexture(n, n, px);
  if (t.levels[1].contains(fuge)) throw StateError('Fuge überlebt in Mip 1');
  return t;
}

/// Werkstatt: Spiel mit geladener Stadt, daraus die 18 Bilder.
class _Werkstatt {
  _Werkstatt() {
    ladeAusRepo(spiel);
  }

  final Spiel spiel = Spiel()..groesse(_breite, _hoehe);
  final Eingabe _e = Eingabe();
  final List<IndexedTexture> _tex = baueAlleTexturen();

  IndexedTexture _t(TexturId id) => _tex[id.index];

  /// Szene wie in bin/bereichsfotos.dart: Erkundung an Ort und Marke, eingeblendet, leicht geneigt.
  void _szene(String ort, String marke) {
    // Die Erkundung liest ihre Welt erst beim Betreten; davor gilt die Burg als Startwert.
    spiel.wechsle(Erkundung(ort: 'gewoelbe', marke: _markeVon(spiel.stadt.bereiche['gewoelbe']!)));
    final erk = Erkundung(ort: ort, marke: marke);
    spiel.wechsle(erk);
    for (var i = 0; i < 12; i++) {
      spiel.tick(1 / 30, _e);
    }
    erk.pitch = spiel.stadt.bereiche[ort]!.innen ? -0.05 : 0.05;
    spiel.tick(1 / 30, _e);
  }

  Uint8List _bild() => komponiere(spiel.welt, spiel.ui, spiel.skala!);

  _Bild _szeneFrei(String ort, String marke, String text) {
    _szene(ort, marke);
    return _Bild(_bild(), 'fehlerfrei', 'gesamtes Bild', text);
  }

  /// Ein Block von 256×256 Pixeln in der Bildmitte mit der Textur (Stufe [stufe], Zoom ×2).
  _Bild _block(IndexedTexture t, int stufe, _Bild Function(Uint8List) baue) {
    final c = _leinwand();
    _kachel(c, t, stufe, _zoom, _blockX, _blockY, n: _kachelnFuer(t));
    return baue(c.toRgbaBytes());
  }

  static const _ortBlock = 'Block in der Bildmitte (x 192–447, y 52–307)';

  _Bild _texturFrei(TexturId id, String text) => _block(_t(id), 0, (rgba) => _Bild(rgba, 'fehlerfrei', _ortBlock, text));

  _Bild _texturRauschen(TexturId id, int rampe, int seed, String text) {
    final (neu, geaendert) = _rauschenTextur(_t(id), rampe, _Lcg(seed));
    _pruefeAnteil(geaendert, neu.width * neu.height, text);
    return _block(neu, 0, (rgba) => _Bild(rgba, 'Rauschen', _ortBlock, text));
  }

  _Bild _rauschenSzene() {
    _szene('stadt', 'untertor');
    final geaendert = _rauschenFlaeche(spiel.welt, 145, 131, 50, 24, _Lcg(777));
    _pruefeAnteil(geaendert, 50 * 24, 'Pflasterfläche');
    return _Bild(_bild(), 'Rauschen', 'Pflasterboden unten Mitte (x 290–389, y 262–309)',
        'Pflasterfläche des Bodens mit zufälligen Farben derselben Rampe überstreut (30 % der Pixel); Verstoß gegen Stilblatt §3 (keine Rauschflächen).');
  }

  /// Moiré: Boden im Spiel-Raster mit 1-Texel-Muster, keine Mip-Stufe.
  _Bild _moire(IndexedTexture muster, String text) {
    _boden(spiel.welt, muster, spiel.renderer.camera.fovY);
    spiel.ui.color.fillRange(0, spiel.ui.color.length, kTransparent);
    return _Bild(_bild(), 'Moiré', 'Boden von der Bildmitte (y 180) bis etwa y 280', text);
  }

  _Bild _verlaufBlock() => _block(_verlaufPutz(), 0,
      (rgba) => _Bild(rgba, 'Stilbruch', _ortBlock,
          'Putz mit weichem Verlauf über 16 Stufen aus zwei Rampen von links nach rechts (Airbrush); Verstoß gegen Stilblatt §3 (höchstens 8 Stufen, nur Rampen des Materials).'));

  _Bild _lichtBlock() {
    final t = _gedreht(_t(TexturId.quaderMauer));
    return _block(t, 0,
        (rgba) => _Bild(rgba, 'Stilbruch', _ortBlock,
            'Mauer mit Licht von unten rechts (Lichtkante unten/rechts, Schatten oben/links); Verstoß gegen Stilblatt §3 (Licht von oben links).'));
  }

  _Bild _fugenBlock() {
    final t = _fugenDuenn();
    final c = _leinwand();
    _kachel(c, t, 0, _zoom, 32, _blockY, n: 4);
    _kachel(c, t, 1, 2 * _zoom, 352, _blockY, n: 4);
    return _Bild(c.toRgbaBytes(), 'Stilbruch', 'links Mip 0 (x 32–287), rechts Mip 1 (x 352–607), y 52–307',
        'Fugen 1 Texel breit in der dunkelsten Stufe der Rampe; in Mip 1 verschwunden. Verstoß gegen Stilblatt §3 (Fugen nie die dunkelste Stufe; in Mip 1 mindestens 2 Texel breit).');
  }

  /// Fremdfarbe: 6×6 Bildpixel in einer Farbe außerhalb der Palette, Ort zufällig, nicht am Rand.
  _Bild _fremdfarbe(String ort, String marke, int rgb, String name, _Lcg r) {
    _szene(ort, marke);
    final rgba = _bild();
    final x0 = 24 + r.below(_breite - 54), y0 = 24 + r.below(_hoehe - 54);
    for (var y = y0; y < y0 + 6; y++) {
      for (var x = x0; x < x0 + 6; x++) {
        final i = (y * _breite + x) * 4;
        rgba[i] = rgb >> 16;
        rgba[i + 1] = (rgb >> 8) & 0xFF;
        rgba[i + 2] = rgb & 0xFF;
        rgba[i + 3] = 0xFF;
      }
    }
    return _Bild(rgba, 'Fremdfarbe', 'Fläche 6×6 Bildpixel, x $x0–${x0 + 5}, y $y0–${y0 + 5}',
        'Fläche in $name (RGB ${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}) außerhalb der Palette; Verstoß gegen Stilblatt §1 (jedes Pixel ist ein Palettenindex)${rgb == 0x00FF66 ? ' und §4 (Grünregel)' : ''}.');
  }

  /// UI-Panel läuft über den rechten Bildrand, der Text ist mitten im Wort abgeschnitten.
  _Bild _panelRand() {
    _szene('innen-bibliothek', 't');
    final ui = spiel.pixelUi;
    // Der Bildrand schneidet zwei Pixel hinter „Archivschr“ durch das Wort „Archivschrank“.
    const vorn = 'Der Schlüssel zum Archivschr';
    final x = _breite - ui.font.measure(vorn) - 2;
    ui.panel(Rechteck(x - 10, 60, 300, 30));
    ui.text('Der Schlüssel zum Archivschrank liegt im Fundus unter dem Tuch', x, 70);
    return _Bild(_bild(), 'abgeschnitten', 'Panel rechts oben (y 60–89), Text bei x $x, Schnitt bei x 640',
        'UI-Panel reicht über den rechten Bildrand; der Text ist mitten im Wort abgeschnitten (Oberfläche).');
  }

  /// Kachelbild mit 9 Spalten zu je 64 Pixeln im Abstand 76: die letzte Spalte ist nur zur Hälfte im Bild.
  _Bild _tafelAbgeschnitten() {
    final c = _leinwand();
    final t = _t(TexturId.pflaster);
    for (var zeile = 0; zeile < 4; zeile++) {
      for (var spalte = 0; spalte < 9; spalte++) {
        _kachel(c, t, 0, _zoom, spalte * 76, 34 + zeile * 76, n: 1);
      }
    }
    return _Bild(c.toRgbaBytes(), 'abgeschnitten', 'letzte Spalte ganz rechts (x 608–639), alle Zeilen',
        'Kachel-Tafel: die letzte Spalte Kacheln ist nur zur Hälfte im Bild (Bildrand schneidet sie ab).');
  }

  void _pruefeAnteil(int geaendert, int flaeche, String was) {
    final anteil = geaendert / flaeche;
    if (anteil < 0.25 || anteil > 0.35) throw StateError('$was: Rauschanteil ${(anteil * 100).toStringAsFixed(1)} % außerhalb 25–35 %');
  }

  List<_Bild> alle() => [
        _szeneFrei('stadt', 'b', 'Oberstadt, Marke b, Ich-Sicht; keine Abweichung.'),
        _szeneFrei('innen-uhrturm', 't', 'Uhrwerk-Kammer im Uhrturm; keine Abweichung.'),
        _szeneFrei('gewoelbe', 't', 'Kamin-Gewölbe der Burg; keine Abweichung.'),
        _texturFrei(TexturId.quaderMauer, 'Quadermauer, 2×2 Kacheln bei ×2; keine Abweichung.'),
        _texturFrei(TexturId.holzDielen, 'Holzdielen, 4×4 Kacheln bei ×2; keine Abweichung.'),
        _texturFrei(TexturId.fachwerkPutz, 'Fachwerkputz, 2×2 Kacheln bei ×2; keine Abweichung.'),
        _texturRauschen(TexturId.putzOcker, Ramp.amber, 1234,
            'Ockerputz: 30 % der Texel durch zufällige Farben der Ockerrampe ersetzt; Verstoß gegen Stilblatt §3 (keine Rauschflächen, keine reinen Zufallsmuster).'),
        _rauschenSzene(),
        _texturRauschen(TexturId.holzBohlen, Ramp.wood, 4321,
            'Holzbohlen: 30 % der Texel durch zufällige Farben der Holzrampe ersetzt; Verstoß gegen Stilblatt §3 (keine Rauschflächen, keine reinen Zufallsmuster).'),
        _moire(_streifen(), '1-Texel-Streifen im Wechsel auf dem Boden, nearest ohne Mip; in der Ferne Interferenzmuster. Verstoß gegen Stilblatt §3 (Mip-Lesbarkeit) und §1 (Abtastung).'),
        _moire(_schach(), 'Feines 1-Texel-Schachbrett auf dem Boden, nearest ohne Mip; in der Ferne Interferenzmuster. Verstoß gegen Stilblatt §3 (Mip-Lesbarkeit) und §1 (Abtastung).'),
        _verlaufBlock(),
        _lichtBlock(),
        _fugenBlock(),
        _fremdfarbe('innen-rathaus', 't', 0xFF00FF, 'Magenta', _Lcg(31)),
        _fremdfarbe('stadt', 'obertor', 0x00FF66, 'Neongrün', _Lcg(57)),
        _panelRand(),
        _tafelAbgeschnitten(),
      ];
}

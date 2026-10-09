import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// Texturen, die Grün (Rampe 5) tragen dürfen: Moos und Wiese.
const _gruenErlaubt = {'dachBiberschwanzMoos', 'wiese', 'bruchsteinMauer'};

/// Zeichendichte der HD-Fassungen (Texel pro Meter). Alle anderen Texturen sind Bestand (32).
const _hdDichte = 64;

/// „Gleich oder benachbart“: gleicher Index, oder gleiche Rampe mit höchstens zwei Stufen Unterschied.
bool _benachbart(int a, int b) => a == b || (rampeVon(a) == rampeVon(b) && (stufeVon(a) - stufeVon(b)).abs() <= 2);

/// Palettenindex an (x, y) mit Umbruch.
int _px(IndexedTexture t, int x, int y) {
  final n = t.width;
  final xm = ((x % n) + n) % n, ym = ((y % n) + n) % n;
  return t.levels[0][ym * n + xm];
}

/// Anteil der Randpaare (links/rechts und oben/unten), die gleich oder benachbart sind.
double _kantenAnteil(IndexedTexture t) {
  final n = t.width, px = t.levels[0];
  var gut = 0, alle = 0;
  for (var i = 0; i < n; i++) {
    alle++;
    if (_benachbart(px[i * n], px[i * n + n - 1])) gut++;
    alle++;
    if (_benachbart(px[i], px[(n - 1) * n + i])) gut++;
  }
  return gut / alle;
}

/// Luma eines Palettenindex (ganzzahlig, 0–255, Gewichte 299/587/114).
int _luma(int c) => (299 * paletteR(c) + 587 * paletteG(c) + 114 * paletteB(c)) ~/ 1000;

/// Streupixel (Regel 7, E-047): Anteil der Pixel, deren vier Nachbarn (mit Umbruch) alle einen anderen Index haben.
double _streuAnteil(IndexedTexture t) {
  final n = t.width;
  var streu = 0;
  for (var y = 0; y < n; y++) {
    for (var x = 0; x < n; x++) {
      final c = _px(t, x, y);
      if (_px(t, x, y - 1) != c && _px(t, x, y + 1) != c && _px(t, x - 1, y) != c && _px(t, x + 1, y) != c) {
        streu++;
      }
    }
  }
  return streu / (n * n);
}

/// Mittlere Luma je Kantenseite und Anzahl der Kantenpixel je Seite.
typedef _Lichtkanten = ({
  double oben,
  double unten,
  double links,
  double rechts,
  int nOben,
  int nUnten,
  int nLinks,
  int nRechts,
});

/// Lichtkanten (Regel 8, E-047). Kante in einer Richtung = Pixel, dessen Nachbar in dieser Richtung um
/// mindestens 12 Luma dunkler ist (mit Umbruch). Oberkante: oberer Nachbar dunkler; Unterkante: unterer
/// Nachbar dunkler; ebenso Links- und Rechtskante.
_Lichtkanten _lichtkanten(IndexedTexture t) {
  final n = t.width;
  var sOben = 0, nOben = 0, sUnten = 0, nUnten = 0, sLinks = 0, nLinks = 0, sRechts = 0, nRechts = 0;
  for (var y = 0; y < n; y++) {
    for (var x = 0; x < n; x++) {
      final l = _luma(_px(t, x, y));
      if (l - _luma(_px(t, x, y - 1)) >= 12) {
        sOben += l;
        nOben++;
      }
      if (l - _luma(_px(t, x, y + 1)) >= 12) {
        sUnten += l;
        nUnten++;
      }
      if (l - _luma(_px(t, x - 1, y)) >= 12) {
        sLinks += l;
        nLinks++;
      }
      if (l - _luma(_px(t, x + 1, y)) >= 12) {
        sRechts += l;
        nRechts++;
      }
    }
  }
  double mittel(int s, int k) => k == 0 ? 0.0 : s / k;
  return (
    oben: mittel(sOben, nOben),
    unten: mittel(sUnten, nUnten),
    links: mittel(sLinks, nLinks),
    rechts: mittel(sRechts, nRechts),
    nOben: nOben,
    nUnten: nUnten,
    nLinks: nLinks,
    nRechts: nRechts,
  );
}

/// Licht von oben links: Oberkanten heller als Unterkanten und Linkskanten heller als Rechtskanten.
bool _lichtVonObenLinks(_Lichtkanten k) => k.oben >= k.unten && k.links >= k.rechts;

/// Zahl mit einer Nachkommastelle und deutschem Komma.
String _zahl(double x) => x.toStringAsFixed(1).replaceAll('.', ',');

/// Anteil als Prozent mit einer Nachkommastelle, z. B. „12,5 %“.
String _prozent(double anteil) => '${_zahl(anteil * 100)} %';

/// Lichtkanten als Text, z. B. „oben 113,4, unten 97,0, links 111,2, rechts 97,5“.
String _lichtText(_Lichtkanten k) =>
    'oben ${_zahl(k.oben)}, unten ${_zahl(k.unten)}, links ${_zahl(k.links)}, rechts ${_zahl(k.rechts)}';

/// Gegenprobe: Textur um 180° gedreht, Pixel (x, y) → (n−1−x, n−1−y).
IndexedTexture _gedreht180(IndexedTexture t) {
  final n = t.width;
  final out = Tex(n);
  for (var y = 0; y < n; y++) {
    for (var x = 0; x < n; x++) {
      out.p(x, y, _px(t, n - 1 - x, n - 1 - y));
    }
  }
  return out.build();
}

/// Selbstprobe (a) für Regel 8: Steine mit Licht oben links, 64×64.
IndexedTexture _pruefSteine() {
  final t = Tex(64);
  steine(
    t,
    Lcg(301),
    rampe: Ramp.stone,
    koerper: 5,
    fuge: Ramp.at(Ramp.stone, 1),
    zeilen: [3, 19, 35, 51],
    spalten: [
      [4, 20, 36, 52],
      [12, 28, 44, 60],
      [4, 20, 36, 52],
      [12, 28, 44, 60],
    ],
  );
  return t.build();
}

/// Selbstprobe (c) für Regel 7: Grundfläche mit 30 % zufällig gesetzten Pixeln einer Rampe (Lcg, fester Seed).
IndexedTexture _pruefStreu() {
  final t = Tex(64), r = Lcg(401);
  t.fill(Ramp.at(Ramp.stone, 4));
  for (var y = 0; y < 64; y++) {
    for (var x = 0; x < 64; x++) {
      if (r.below(100) < 30) t.p(x, y, Ramp.at16(Ramp.stone, r.below(16)));
    }
  }
  return t.build();
}

void main() {
  test('Katalog: mindestens 36 Texturen, Index = TexturId.index, Länge = baueAlleTexturen()', () {
    expect(TexturId.values.length, greaterThanOrEqualTo(36));
    final alle = baueAlleTexturen();
    expect(alle.length, TexturId.values.length);
    for (final id in TexturId.values) {
      expect(alle[id.index].width, baueTextur(id).width, reason: id.name);
      expect(alle[id.index].levels[0], orderedEquals(baueTextur(id).levels[0]), reason: id.name);
    }
  });

  test('Selbstprobe Regel 8: Lichtkante besteht bei Licht oben links (a), besteht nicht bei 180° gedreht (b)', () {
    final a = _lichtkanten(_pruefSteine());
    print(
      'Selbstprobe (a) Steine Licht oben links: ${_lichtText(a)} → ${_lichtVonObenLinks(a) ? 'bestanden' : 'nicht bestanden'}',
    );
    expect(_lichtVonObenLinks(a), isTrue, reason: _lichtText(a));
    final b = _lichtkanten(_gedreht180(_pruefSteine()));
    print(
      'Selbstprobe (b) Steine 180° gedreht: ${_lichtText(b)} → ${_lichtVonObenLinks(b) ? 'bestanden' : 'nicht bestanden'}',
    );
    expect(_lichtVonObenLinks(b), isFalse, reason: 'gedreht: ${_lichtText(b)}');
  });

  test('Selbstprobe Regel 7: 30 % zufällige Pixel einer Rampe ergeben Streupixel > 8 % (c)', () {
    final anteil = _streuAnteil(_pruefStreu());
    print('Selbstprobe (c) 30 % Zufallspixel: Streupixel ${_prozent(anteil)}');
    expect(anteil, greaterThan(0.08));
  });

  for (final id in TexturId.values) {
    final hd = texturEintrag(id).dichte == _hdDichte;
    group(id.name, () {
      test(
        hd ? 'Größe ist 64×64 oder 128×128 (HD, quadratisch)' : 'Größe ist 32×32 oder 64×64 (Bestand, quadratisch)',
        () {
          final t = baueTextur(id);
          expect(hd ? [64, 128] : [32, 64], contains(t.width));
          expect(t.height, t.width);
        },
      );

      test('nur Palettenindizes der Palette, keine Transparenz', () {
        final t = baueTextur(id);
        for (final lv in t.levels) {
          expect(lv.every((c) => c < paletteRgb.length), isTrue, reason: 'Index außerhalb der Palette oder 255');
        }
        expect(t.hasTransparency, isFalse);
      });

      test('kachelbar: Randpaare gleich oder benachbart ≥ 60 %', () {
        final anteil = _kantenAnteil(baueTextur(id));
        expect(
          anteil,
          greaterThanOrEqualTo(0.6),
          reason: '${(anteil * 100).toStringAsFixed(1)} % der Randpaare passen',
        );
      });

      test(
        hd
            ? 'Stufen (HD): je Rampe höchstens 8, höchstens 3 Rampen, insgesamt höchstens 14 Indizes'
            : 'höchstens 5 verschiedene Farben (Bestand)',
        () {
          final farben = baueTextur(id).levels[0].toSet();
          if (!hd) {
            expect(farben.length, lessThanOrEqualTo(5), reason: '${farben.length} Farben: $farben');
            return;
          }
          final proRampe = <int, Set<int>>{};
          for (final c in farben) {
            proRampe.putIfAbsent(rampeVon(c), () => <int>{}).add(stufeVon(c));
          }
          expect(proRampe.values.every((s) => s.length <= 8), isTrue, reason: 'Stufen je Rampe: $proRampe');
          expect(proRampe.length, lessThanOrEqualTo(3), reason: 'Rampen: ${proRampe.keys}');
          expect(farben.length, lessThanOrEqualTo(14), reason: '${farben.length} Indizes: $farben');
        },
      );

      test('keine Grüntöne (Rampe 5) außer Moos, Wiese und Bruchsteinmauer', () {
        if (_gruenErlaubt.contains(id.name)) return;
        final gruen = baueTextur(id).levels[0].where((c) => rampeVon(c) == Ramp.green);
        expect(gruen, isEmpty);
      });

      if (hd) {
        test('Streupixel ≤ 8 % (HD)', () {
          final anteil = _streuAnteil(baueTextur(id));
          expect(anteil, lessThanOrEqualTo(0.08), reason: 'Streupixel ${_prozent(anteil)}');
        });

        test('Lichtkante (HD): ≥ 20 Kantenpixel je Seite, Licht oben links', () {
          final k = _lichtkanten(baueTextur(id));
          expect(
            [k.nOben, k.nUnten, k.nLinks, k.nRechts].every((n) => n >= 20),
            isTrue,
            reason: 'Kantenpixel oben/unten/links/rechts: ${k.nOben}/${k.nUnten}/${k.nLinks}/${k.nRechts}',
          );
          expect(
            _lichtVonObenLinks(k),
            isTrue,
            reason: 'oben ${k.oben}, unten ${k.unten}, links ${k.links}, rechts ${k.rechts}',
          );
        });

        test('Mip (HD): mindestens 5 Mip-Stufen', () {
          expect(baueTextur(id).levels.length, greaterThanOrEqualTo(5));
        });
      }

      test('deterministisch: zweimal bauen ergibt identische Bytes', () {
        final a = baueTextur(id), b = baueTextur(id);
        expect(a.levels.length, b.levels.length);
        for (var i = 0; i < a.levels.length; i++) {
          expect(a.levels[i], orderedEquals(b.levels[i]));
        }
      });
    });
  }

  test('Bestand-Bericht: Streupixel und Lichtkante je Bestandstextur (nur Ausgabe, keine Prüfung)', () {
    for (final id in TexturId.values) {
      if (texturEintrag(id).dichte == _hdDichte) continue;
      final t = baueTextur(id);
      final k = _lichtkanten(t);
      print('${id.name} Streupixel ${_prozent(_streuAnteil(t))}');
      print(
        '${id.name} Lichtkante ${_lichtText(k)} '
        '(Kantenpixel ${k.nOben}/${k.nUnten}/${k.nLinks}/${k.nRechts}), Licht oben links: '
        '${_lichtVonObenLinks(k) ? 'ja' : 'nein'}',
      );
    }
  });
}

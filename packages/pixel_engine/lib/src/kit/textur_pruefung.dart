import '../palette.dart';
import '../raster/texture.dart';

/// Strukturmessungen und Stilblatt-Prüfung für Texturen (Burgstadt HD; texturen_test v2, E-047).
/// Werkzeuge und Tests nutzen dieselben Funktionen, damit Kontaktbogen und Test gleich urteilen.

/// Texturen, die Grün (Rampe 5) tragen dürfen (Grünregel E-025).
const Set<String> kGruenErlaubt = {'dachBiberschwanzMoos', 'wiese', 'bruchsteinMauer'};

/// „Gleich oder benachbart“: gleicher Index oder gleiche Rampe mit höchstens zwei 16er-Stufen Abstand.
bool benachbart(int a, int b) => a == b || (rampeVon(a) == rampeVon(b) && (stufeVon(a) - stufeVon(b)).abs() <= 2);

int _px(IndexedTexture t, int x, int y) {
  final n = t.width;
  final xm = ((x % n) + n) % n, ym = ((y % n) + n) % n;
  return t.levels[0][ym * n + xm];
}

/// Luma eines Palettenindex (ganzzahlig, 0–255, Gewichte 299/587/114).
int luma(int c) => (299 * paletteR(c) + 587 * paletteG(c) + 114 * paletteB(c)) ~/ 1000;

/// Anteil der Randpaare (links/rechts und oben/unten), die gleich oder benachbart sind.
double kantenAnteil(IndexedTexture t) {
  final n = t.width, px = t.levels[0];
  var gut = 0, alle = 0;
  for (var i = 0; i < n; i++) {
    alle += 2;
    if (benachbart(px[i * n], px[i * n + n - 1])) gut++;
    if (benachbart(px[i], px[(n - 1) * n + i])) gut++;
  }
  return gut / alle;
}

/// Streupixel: Anteil der Pixel, deren vier Nachbarn (mit Umbruch) alle einen anderen Index haben.
double streuAnteil(IndexedTexture t) {
  final n = t.width;
  var streu = 0;
  for (var y = 0; y < n; y++) {
    for (var x = 0; x < n; x++) {
      final c = _px(t, x, y);
      if (_px(t, x, y - 1) != c && _px(t, x, y + 1) != c && _px(t, x - 1, y) != c && _px(t, x + 1, y) != c) streu++;
    }
  }
  return streu / (n * n);
}

/// Mittlere Luma der Kantenpixel je Seite und deren Anzahl.
typedef Lichtkanten = ({double oben, double unten, double links, double rechts, int nOben, int nUnten, int nLinks, int nRechts});

/// Lichtkanten: Oberkante = Pixel, dessen oberer Nachbar um ≥ 12 Luma dunkler ist (mit Umbruch);
/// Unter-, Links- und Rechtskante entsprechend.
Lichtkanten lichtkanten(IndexedTexture t) {
  final n = t.width;
  var sO = 0, nO = 0, sU = 0, nU = 0, sL = 0, nL = 0, sR = 0, nR = 0;
  for (var y = 0; y < n; y++) {
    for (var x = 0; x < n; x++) {
      final l = luma(_px(t, x, y));
      if (l - luma(_px(t, x, y - 1)) >= 12) {
        sO += l;
        nO++;
      }
      if (l - luma(_px(t, x, y + 1)) >= 12) {
        sU += l;
        nU++;
      }
      if (l - luma(_px(t, x - 1, y)) >= 12) {
        sL += l;
        nL++;
      }
      if (l - luma(_px(t, x + 1, y)) >= 12) {
        sR += l;
        nR++;
      }
    }
  }
  double m(int s, int k) => k == 0 ? 0.0 : s / k;
  return (oben: m(sO, nO), unten: m(sU, nU), links: m(sL, nL), rechts: m(sR, nR), nOben: nO, nUnten: nU, nLinks: nL, nRechts: nR);
}

/// Licht von oben links (Bestand-Maß, ohne Abstand): Oberkanten ≥ Unterkanten, Linkskanten ≥ Rechtskanten.
bool lichtVonObenLinks(Lichtkanten k) => k.oben >= k.unten && k.links >= k.rechts;

/// Stilblatt-Prüfung einer HD-Textur (Zeichendichte 64). Liefert die Befunde (leer = bestanden).
/// Lichtkante: je Achse nur, wenn beide Seiten ≥ 20 Kantenpixel haben; dann Ober- bzw. Linkskanten um
/// mindestens 2 Luma heller als Unter- bzw. Rechtskanten (Licht oben links, Stilblatt §3).
List<String> pruefeHdTextur(String name, IndexedTexture t, {bool? gruenErlaubt}) {
  final b = <String>[];
  if (!(t.width == 64 || t.width == 128) || t.height != t.width) b.add('Größe ${t.width}×${t.height} (erlaubt 64 oder 128, quadratisch)');
  for (final lv in t.levels) {
    if (lv.any((c) => c >= paletteRgb.length)) {
      b.add('Index außerhalb der Palette oder durchsichtig');
      break;
    }
  }
  if (t.hasTransparency) b.add('durchsichtige Texel');
  final ka = kantenAnteil(t);
  if (ka < 0.6) b.add('nicht kachelbar: ${(ka * 100).toStringAsFixed(1)} % Randpaare passen (≥ 60 %)');
  final farben = t.levels[0].toSet();
  final proRampe = <int, Set<int>>{};
  for (final c in farben) {
    proRampe.putIfAbsent(rampeVon(c), () => <int>{}).add(stufeVon(c));
  }
  for (final e in proRampe.entries) {
    if (e.value.length > 8) b.add('Rampe ${e.key}: ${e.value.length} Stufen (höchstens 8)');
  }
  if (proRampe.length > 3) b.add('${proRampe.length} Rampen (höchstens 3)');
  if (farben.length > 14) b.add('${farben.length} Indizes (höchstens 14)');
  final gruen = gruenErlaubt ?? kGruenErlaubt.any(name.startsWith);
  if (!gruen && proRampe.containsKey(Ramp.green)) b.add('Grün (Rampe 5) außerhalb der Grünregel');
  final s = streuAnteil(t);
  if (s > 0.08) b.add('Streupixel ${(s * 100).toStringAsFixed(1)} % (höchstens 8 %)');
  final k = lichtkanten(t);
  if (k.nOben >= 20 && k.nUnten >= 20 && k.oben < k.unten + 2) {
    b.add('Lichtkante: oben ${k.oben.toStringAsFixed(1)} nicht heller als unten ${k.unten.toStringAsFixed(1)}');
  }
  if (k.nLinks >= 20 && k.nRechts >= 20 && k.links < k.rechts + 2) {
    b.add('Lichtkante: links ${k.links.toStringAsFixed(1)} nicht heller als rechts ${k.rechts.toStringAsFixed(1)}');
  }
  if (t.levels.length < 5) b.add('${t.levels.length} Mip-Stufen (mindestens 5)');
  return b;
}

import 'dart:io';

import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:burgstadt_spiel/src/blasen_layout.dart';
import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// Zufall mit festem Seed (Lehmer-Generator, ohne dart:math Random).
class _Lcg {
  int _s;
  _Lcg(this._s);

  /// Ganzzahl in 0 ≤ n < [n].
  int bis(int n) {
    _s = _s * 48271 % 2147483647;
    return _s % n;
  }
}

/// UI-Raster: Querformat, Hochformat und Querformat knapp über 800 Pixel Breite.
const _bilder = [(640, 360), (360, 800), (801, 361)];

/// Kopfkoordinate: am Rand, außerhalb des Bildes oder im Bild (0,1 px genau).
double _kopf(_Lcg l, int groesse) {
  switch (l.bis(10)) {
    case 0:
      return 0;
    case 1:
      return groesse - 1.0;
    case 2:
      return -30.0 - l.bis(60);
    case 3:
      return groesse + 1.0 + l.bis(60);
    default:
      return l.bis(groesse * 10) / 10;
  }
}

/// Zeitzeile wie im Spiel: „HH:MM · Phase n“ oder „Freie Erkundung“.
String _zeit(_Lcg l) {
  if (l.bis(5) == 0) return 'Freie Erkundung';
  final m = l.bis(24 * 60);
  final hh = (m ~/ 60).toString().padLeft(2, '0'), mm = (m % 60).toString().padLeft(2, '0');
  return '$hh:$mm · Phase ${1 + l.bis(3)}';
}

/// Echte Überlappung zweier Flächen.
bool _schneidet(Rechteck a, Rechteck b) => a.x < b.rechts && b.x < a.rechts && a.y < b.unten && b.y < a.unten;

/// Fläche a liegt näher als [kBlasenAbstand] an b.
bool _nah(Rechteck a, Rechteck b) =>
    a.x < b.rechts + kBlasenAbstand &&
    b.x < a.rechts + kBlasenAbstand &&
    a.y < b.unten + kBlasenAbstand &&
    b.y < a.unten + kBlasenAbstand;

/// Liegt die Fläche mit 2 px Rand im Bild?
bool _imBild(Rechteck f, int w, int h) => f.x >= 2 && f.y >= 2 && f.rechts <= w - 2 && f.unten <= h - 2;

/// Vergleichbare Form der Plätze (Rechteck hat kein ==).
List<(int, int, int, int)?> _form(List<Rechteck?> plaetze) => [for (final r in plaetze) r == null ? null : (r.x, r.y, r.w, r.h)];

void main() {
  late BitmapFont font;
  late List<String> orte;

  setUpAll(() {
    final spiel = Spiel();
    ladeAusRepo(spiel);
    font = BitmapFont.parse(kSchriftNormal);
    orte = [for (final b in spiel.stadt.bereiche.values) b.name]..sort();
  });

  group('Sprechblasen-Layout', () {
    test('1.000 Lagen: 0 Überlappungen, 0 Schnitte, 0 HUD-Kollisionen; nächster Sprecher bekommt Platz', () {
      final lcg = _Lcg(20260315);
      var gesamt = 0, platziert = 0, ueberlappungen = 0, nahe = 0, hud = 0, geschnitten = 0;
      var sprecherGeprueft = 0, sprecherOhnePlatz = 0;
      for (var lage = 0; lage < 1000; lage++) {
        final (w, h) = _bilder[lcg.bis(_bilder.length)];
        final draussen = lcg.bis(2) == 0;
        final ort = orte[lcg.bis(orte.length)];
        final sperren = hudSperren(font, w, h, draussen: draussen, ort: ort, zeit: _zeit(lcg));
        final n = 1 + lcg.bis(6);
        final wuensche = [
          for (var i = 0; i < n; i++) BlasenWunsch(_kopf(lcg, w), _kopf(lcg, h), 40 + lcg.bis(141), 14 + lcg.bis(47)),
        ];
        final plaetze = ordneBlasen(wuensche, w, h, sperren);
        expect(plaetze, hasLength(n));

        final belegt = <(Rechteck, Rechteck)>[]; // (Körper, Fläche mit Zipfel und Schatten)
        for (var i = 0; i < n; i++) {
          gesamt++;
          final r = plaetze[i];
          if (r == null) continue;
          platziert++;
          final f = blasenFlaeche(r, zipfelVon(wuensche[i], r));
          if (!_imBild(r, w, h) || !_imBild(f, w, h)) geschnitten++;
          for (final s in sperren) {
            if (_schneidet(r, s) || _schneidet(f, s)) hud++;
          }
          for (final (r2, f2) in belegt) {
            if (_schneidet(r, r2)) ueberlappungen++;
            if (_nah(f, f2)) nahe++;
          }
          belegt.add((r, f));
        }

        // Nächster Sprecher: Kopf im Bild und eine freie Bildecke, in die die Blase passt -> Platz
        final kopf = wuensche[0];
        if (kopf.sx >= 0 && kopf.sx < w && kopf.sy >= 0 && kopf.sy < h) {
          final bw = kopf.breite, bh = kopf.hoehe;
          final ecken = [
            Rechteck(2, 2, bw, bh),
            Rechteck(w - bw - 3, 2, bw, bh),
            Rechteck(2, h - bh - 6, bw, bh),
            Rechteck(w - bw - 3, h - bh - 6, bw, bh),
          ];
          final freieEcke = ecken.any((c) {
            final f = blasenFlaeche(c, zipfelVon(kopf, c));
            return _imBild(f, w, h) && !sperren.any((s) => _schneidet(f, s));
          });
          if (freieEcke) {
            sprecherGeprueft++;
            if (plaetze[0] == null) sprecherOhnePlatz++;
          }
        }
      }
      stdout.writeln('ui_test: 1.000 Lagen, $gesamt Blasen-Wünsche, $platziert platziert, '
          '$sprecherGeprueft nächste Sprecher mit freier Ecke, davon $sprecherOhnePlatz ohne Platz');
      expect(ueberlappungen, 0, reason: 'Blasen überlappen einander');
      expect(nahe, 0, reason: 'Blasen (mit Zipfel und Schatten) weniger als 2 px auseinander');
      expect(hud, 0, reason: 'Blasen überlappen HUD-Flächen');
      expect(geschnitten, 0, reason: 'Blase nicht vollständig im Bild');
      expect(sprecherOhnePlatz, 0, reason: 'nächster Sprecher ohne Platz, obwohl eine Ecke frei ist');
      expect(platziert, greaterThan(gesamt ~/ 2), reason: 'Plausibilität: die Mehrheit der Blasen wird platziert');
    });

    test('gleiche Eingabe, gleiche Plätze', () {
      final sperren = hudSperren(font, 640, 360, draussen: true, ort: orte.first, zeit: '12:00 · Phase 2');
      final wuensche = [BlasenWunsch(300, 200, 120, 40), BlasenWunsch(310, 190, 90, 30), BlasenWunsch(20, 350, 60, 20)];
      expect(_form(ordneBlasen(wuensche, 640, 360, sperren)), _form(ordneBlasen(wuensche, 640, 360, sperren)));
    });

    test('ein Sprecher ohne Hindernisse: zentriert über dem Kopf, Zipfel nach unten', () {
      const wunsch = BlasenWunsch(320, 200, 100, 30);
      final r = ordneBlasen([wunsch], 640, 360, const [])[0]!;
      expect((r.x, r.y, r.w, r.h), (270, 167, 100, 30));
      expect(zipfelVon(wunsch, r), Zipfel.unten);
    });

    test('zu kleines Bild: kein Platz, die Blase entfällt', () {
      expect(ordneBlasen([const BlasenWunsch(50, 20, 180, 60)], 100, 40, const []), [null]);
    });
  });
}

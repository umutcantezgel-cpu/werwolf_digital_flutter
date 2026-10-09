import 'dart:math' as math;

import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// Kasten (minX, minY, maxX, maxY) aller Pixel mit der Farbe [farbe], oder null.
(int, int, int, int)? _kasten(PixelBuffer b, int farbe) {
  int? x0, y0, x1, y1;
  for (var y = 0; y < b.height; y++) {
    for (var x = 0; x < b.width; x++) {
      if (b.get(x, y) != farbe) continue;
      x0 = x0 == null || x < x0 ? x : x0;
      x1 = x1 == null || x > x1 ? x : x1;
      y0 = y0 == null || y < y0 ? y : y0;
      y1 = y1 == null || y > y1 ? y : y1;
    }
  }
  return x0 == null ? null : (x0, y0!, x1!, y1!);
}

(double, double) _mitte((int, int, int, int) k) => ((k.$1 + k.$3) / 2, (k.$2 + k.$4) / 2);

/// Spiel mit der echten Welt; Erkundung in der Oberstadt (vor Haus H-027), Karte offen.
({Spiel spiel, Erkundung erk, List<String> reisen}) _szene(int w, int h, {List<String> besucht = const []}) {
  final spiel = Spiel()..groesse(w, h);
  ladeAusRepo(spiel);
  final erk = Erkundung();
  erk.ort = 'stadt';
  final (x, z) = spiel.stadt.bereiche['stadt']!.markePos('vor-H-027');
  erk.x = x;
  erk.z = z;
  erk.yaw = -1.2;
  spiel.wechsle(erk);
  spiel.besucht.addAll(besucht);
  final reisen = <String>[];
  spiel.oeffne(StadtkarteBildschirm(erk, reise: reisen.add));
  return (spiel: spiel, erk: erk, reisen: reisen);
}

/// Tippen (Zeiger runter, dann hoch) an der Stelle [x], [y] in UI-Pixeln.
void _tippe(Spiel spiel, double x, double y) {
  final e = Eingabe();
  e.zeiger.add(ZeigerEreignis(1, ZeigerArt.runter, x, y));
  spiel.tick(1 / 30, e);
  e.zeiger.add(ZeigerEreignis(1, ZeigerArt.hoch, x, y));
  spiel.tick(1 / 30, e);
}

PixelUi _ui() => PixelUi(BitmapFont.parse(kSchriftNormal));

void main() {
  group('Stadtkarte', () {
    for (final (w, h) in const [(1280, 720), (1080, 2400)]) {
      test('zeichnet bei $w×$h ohne Fehler: nur Palettenfarben, Blocktest 100 %', () {
        final s = _szene(w, h, besucht: const ['innen-museum', 'haus-H-001']);
        s.spiel.tick(1 / 30, Eingabe());
        expect(s.spiel.bildschirm, isA<StadtkarteBildschirm>());
        final rgba = komponiere(s.spiel.welt, s.spiel.ui, s.spiel.skala!);
        expect(countOffPalette(rgba), 0, reason: '$w×$h');
        final k = s.spiel.skala!.kUi;
        expect(blockTest(rgba, w, h, k, areaW: w ~/ k * k, areaH: h ~/ k * k).ratio, 1.0, reason: '$w×$h');
      });
    }

    test('Schnellreise: Tipp auf besuchten Fall-Ort ruft die Marke vor der Haustür und schließt die Karte', () {
      final s = _szene(1280, 720, besucht: const ['innen-museum']);
      s.spiel.tick(1 / 30, Eingabe());
      // Hellgold (Palette 38) ist allein der besuchte Fall-Ort (Stadtmuseum, H-027)
      final (x, y) = _mitte(_kasten(s.spiel.ui, Pal.candleLight)!);
      _tippe(s.spiel, x, y);
      expect(s.reisen, ['vor-H-027']);
      expect(s.spiel.bildschirm, same(s.erk));
    });

    test('Tipp auf ein besuchtes normales Haus oder auf einen unbesuchten Fall-Ort ruft nichts', () {
      final besucht = _szene(1280, 720, besucht: const ['innen-museum', 'haus-H-001']);
      besucht.spiel.tick(1 / 30, Eingabe());
      final gold = _mitte(_kasten(besucht.spiel.ui, Pal.candleLight)!);
      final ocker = _mitte(_kasten(besucht.spiel.ui, Ramp.at(Ramp.amber, 3))!);
      _tippe(besucht.spiel, ocker.$1, ocker.$2);
      expect(besucht.reisen, isEmpty);
      expect(besucht.spiel.bildschirm, isA<StadtkarteBildschirm>());

      // Gleiche Stelle, aber nichts besucht: der Fall-Ort ist nur „?“ und nicht erreichbar.
      final unbesucht = _szene(1280, 720);
      unbesucht.spiel.tick(1 / 30, Eingabe());
      _tippe(unbesucht.spiel, gold.$1, gold.$2);
      expect(unbesucht.reisen, isEmpty);
      expect(unbesucht.spiel.bildschirm, isA<StadtkarteBildschirm>());
    });

    test('Taste M, Escape und Taste zurück schließen die Karte', () {
      for (final t in [Taste.karte, Taste.menue, Taste.zurueck]) {
        final s = _szene(1280, 720);
        s.spiel.tick(1 / 30, Eingabe());
        final e = Eingabe()..tasteRunter(t);
        s.spiel.tick(1 / 30, e);
        expect(s.spiel.bildschirm, same(s.erk), reason: '$t');
      }
    });

    test('Knopf „Zurück“ über Fokus und Bestätigen schließt die Karte', () {
      final s = _szene(1280, 720);
      final e = Eingabe();
      s.spiel.tick(1 / 30, e);
      e.tasteRunter(Taste.runter);
      s.spiel.tick(1 / 30, e);
      e.tasteHoch(Taste.runter);
      e.tasteRunter(Taste.bestaetigen);
      s.spiel.tick(1 / 30, e);
      expect(s.spiel.bildschirm, same(s.erk));
    });
  });

  group('Kompass', () {
    test('zeigt bei yaw = −π/2 „N“ in der Mitte', () {
      final buf = PixelBuffer(200, 16);
      final ui = _ui()..beginne(buf, Eingabe());
      zeichneKompass(ui, -math.pi / 2, const Rechteck(0, 0, 200, 16));
      final k = _kasten(buf, UiFarbe.akzent)!;
      expect(_mitte(k).$1, closeTo(100, 1));
      expect(kompassMarken(-math.pi / 2, 200).singleWhere((m) => m.text == 'N').x, 100);
    });

    test('Himmelsrichtungen laufen mit der Blickrichtung mit', () {
      final norden = {for (final m in kompassMarken(-math.pi / 2, 200)) if (m.text != null) m.text!: m.x};
      expect(norden['N'], 100);
      expect(norden['O']!, greaterThan(100), reason: 'Blick nach Norden: Osten ist rechts');
      expect(norden['W']!, lessThan(100));
      final osten = {for (final m in kompassMarken(0, 200)) if (m.text != null) m.text!: m.x};
      expect(osten['O'], 100);
      expect(osten['N']!, lessThan(100), reason: 'Blick nach Osten: Norden ist links');
    });

    test('nur Palettenfarben', () {
      for (final yaw in [-math.pi / 2, 0.0, 1.0, math.pi, -3.0]) {
        final buf = PixelBuffer(200, 16);
        final ui = _ui()..beginne(buf, Eingabe());
        zeichneKompass(ui, yaw, const Rechteck(0, 0, 200, 16));
        expect(buf.color.every((c) => c == kTransparent || c < 64), isTrue, reason: 'yaw $yaw');
      }
    });
  });
}

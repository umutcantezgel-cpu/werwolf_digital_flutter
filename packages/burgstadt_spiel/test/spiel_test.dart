import 'dart:math' as math;

import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Skalierung', () {
    test('Welt-Faktor gerade, UI = Hälfte, Bild deckt den Schirm', () {
      for (final (w, h) in const [(1280, 720), (2401, 1081), (1081, 2401), (1920, 1080), (800, 600), (360, 640), (2732, 2048)]) {
        for (final q in Qualitaet.values) {
          final s = Skalierung.fuer(w, h, q);
          expect(s.kWelt.isEven, isTrue, reason: '$w×$h $q');
          expect(s.kUi * 2, s.kWelt);
          expect(s.weltW * s.kWelt, greaterThanOrEqualTo(w));
          expect(s.weltH * s.kWelt, greaterThanOrEqualTo(h));
          expect(s.weltW * s.kWelt - w, lessThan(s.kWelt));
          expect(s.uiW * s.kUi - w, lessThan(s.kUi));
        }
      }
      expect(Skalierung.fuer(1280, 720, Qualitaet.mittel).weltH, 180);
      expect(Skalierung.fuer(2401, 1081, Qualitaet.mittel).weltH, 181);
    });
  });

  test('Alle Bildschirme bestehen Paletten- und Blocktest (mehrere Geräte)', () {
    for (final (w, h) in const [(1280, 720), (2401, 1081), (1081, 2401)]) {
      final spiel = Spiel()..groesse(w, h);
      final e = Eingabe();
      void pruefe(String name) {
        spiel.tick(1 / 30, e);
        final rgba = komponiere(spiel.welt, spiel.ui, spiel.skala!);
        expect(countOffPalette(rgba), 0, reason: '$name $w×$h');
        expect(blockTest(rgba, w, h, spiel.skala!.kUi, areaW: w ~/ spiel.skala!.kUi * spiel.skala!.kUi, areaH: h ~/ spiel.skala!.kUi * spiel.skala!.kUi).ratio, 1.0,
            reason: '$name $w×$h');
      }

      pruefe('Hauptmenü');
      spiel.oeffne(OptionenBildschirm());
      pruefe('Optionen');
      spiel.wechsle(Erkundung());
      pruefe('Erkundung');
    }
  });

  test('Tastatur: Fokus sichtbar machen, bestätigen → Erkundung; W läuft vorwärts', () {
    final spiel = Spiel()..groesse(1280, 720);
    final e = Eingabe();
    spiel.tick(1 / 30, e);
    e.tasteRunter(Taste.runter);
    spiel.tick(1 / 30, e);
    e.tasteHoch(Taste.runter);
    e.tasteRunter(Taste.bestaetigen);
    spiel.tick(1 / 30, e);
    e.tasteHoch(Taste.bestaetigen);
    expect(spiel.bildschirm, isA<Erkundung>());
    final erk = spiel.bildschirm as Erkundung;
    final z0 = erk.z, x0 = erk.x;
    e.tasteRunter(Taste.hoch);
    for (var i = 0; i < 30; i++) {
      spiel.tick(1 / 30, e);
    }
    final weg = math.sqrt(math.pow(erk.z - z0, 2) + math.pow(erk.x - x0, 2));
    expect(weg, closeTo(Erkundung.gehen, 0.2));
  });

  test('Touch: Tippen auf „Allein spielen“, Joystick links bewegt, Wischen rechts dreht', () {
    final spiel = Spiel()..groesse(1280, 720);
    final e = Eingabe();
    spiel.tick(1 / 30, e);
    // Knopf „Allein spielen“ liegt mittig; Position aus dem Layout: erste Menüzeile
    final ui = spiel.ui;
    // Suche die erste Knopfzeile über den Rand (Bruchstein) in der Bildmitte.
    var ky = -1;
    for (var y = 0; y < ui.height; y++) {
      if (ui.get(ui.width ~/ 2, y) == UiFarbe.rand) {
        ky = y + 6;
        break;
      }
    }
    expect(ky, greaterThan(0));
    e.zeiger.add(ZeigerEreignis(1, ZeigerArt.runter, ui.width / 2, ky.toDouble()));
    spiel.tick(1 / 30, e);
    e.zeiger.add(ZeigerEreignis(1, ZeigerArt.hoch, ui.width / 2, ky.toDouble()));
    spiel.tick(1 / 30, e);
    expect(spiel.bildschirm, isA<Erkundung>());
    final erk = spiel.bildschirm as Erkundung;
    final z0 = erk.z, x0 = erk.x, yaw0 = erk.yaw;
    e.zeiger.add(const ZeigerEreignis(2, ZeigerArt.runter, 100, 250));
    spiel.tick(1 / 30, e);
    for (var i = 0; i < 20; i++) {
      e.zeiger.add(const ZeigerEreignis(2, ZeigerArt.bewegt, 100, 200));
      spiel.tick(1 / 30, e);
    }
    e.zeiger.add(const ZeigerEreignis(2, ZeigerArt.hoch, 100, 200));
    spiel.tick(1 / 30, e);
    expect(math.sqrt(math.pow(erk.z - z0, 2) + math.pow(erk.x - x0, 2)), greaterThan(0.5));
    e.zeiger.add(const ZeigerEreignis(3, ZeigerArt.runter, 500, 150));
    spiel.tick(1 / 30, e);
    e.zeiger.add(const ZeigerEreignis(3, ZeigerArt.bewegt, 560, 150));
    spiel.tick(1 / 30, e);
    e.zeiger.add(const ZeigerEreignis(3, ZeigerArt.hoch, 560, 150));
    spiel.tick(1 / 30, e);
    expect(erk.yaw, isNot(closeTo(yaw0, 0.01)));
  });

  test('Ton: Musik im Menü, Uhrturm beim Betreten, Schritte beim Gehen, Klick bei Knöpfen', () {
    final ton = MerkendeTonausgabe();
    final spiel = Spiel()
      ..ton = ton
      ..groesse(1280, 720)
      ..starteTon();
    expect(ton.kanaele['musik'], 'musik_gassen_schleife');
    final e = Eingabe();
    spiel.tick(1 / 30, e);
    e.tasteRunter(Taste.runter);
    spiel.tick(1 / 30, e);
    e.tasteHoch(Taste.runter);
    e.tasteRunter(Taste.bestaetigen);
    spiel.tick(1 / 30, e);
    e.tasteHoch(Taste.bestaetigen);
    expect(ton.gespielt, contains('ui_klick'));
    expect(ton.kanaele['musik'], 'musik_gewoelbe_schleife');
    e.tasteRunter(Taste.hoch);
    for (var i = 0; i < 60; i++) {
      spiel.tick(1 / 30, e);
    }
    expect(ton.gespielt.where((n) => n.startsWith('schritt_')).length, greaterThanOrEqualTo(3));
  });

  test('Türen: Turmtür führt zum Turm-Fuß, verschlossenes Burgtor bleibt zu', () {
    final spiel = Spiel()..groesse(640, 360);
    final e = Eingabe();
    final erk = Erkundung(ort: 'gewoelbe', marke: 't');
    spiel.wechsle(erk);
    // Blick nach Norden zur Turmtür (Marke t liegt direkt davor)
    erk.yaw = -math.pi / 2;
    spiel.tick(1 / 30, e);
    expect(erk.ziel?.legende.name, 'Turmtür');
    e.tasteRunter(Taste.aktion);
    spiel.tick(1 / 30, e);
    e.tasteHoch(Taste.aktion);
    expect(erk.ort, 'turmfuss');
    final hof = Erkundung(ort: 'hof', marke: 'b');
    spiel.wechsle(hof);
    hof.yaw = math.pi / 2; // nach Süden zum Burgtor
    spiel.tick(1 / 30, e);
    expect(hof.ziel?.legende.name, startsWith('Burgtor'));
    e.tasteRunter(Taste.aktion);
    spiel.tick(1 / 30, e);
    expect(hof.ort, 'hof');
  });

  test('Fall solo: Start aus dem Menü, Figuren gebrannt und sichtbar, Ansprechen liefert Aussage', () {
    final spiel = Spiel()..groesse(640, 360);
    ladeAusRepo(spiel);
    final e = Eingabe();
    spiel.tick(1 / 30, e);
    e.tasteRunter(Taste.runter);
    spiel.tick(1 / 30, e);
    e.tasteHoch(Taste.runter);
    e.tasteRunter(Taste.bestaetigen);
    spiel.tick(1 / 30, e);
    e.tasteHoch(Taste.bestaetigen);
    final erk = spiel.bildschirm as Erkundung;
    final s = erk.sitzung!;
    expect(s.fall.n, 4);
    s.figuren.alleBacken();
    expect(s.figuren.offen, 0);
    final fig = s.sim.figuren['R01']!;
    erk.x = fig.x - 1.2;
    erk.z = fig.z;
    erk.yaw = 0;
    fig.x = erk.x + 1.2; // stillhalten
    spiel.tick(1 / 30, e);
    expect(erk.zielFigur?.id, 'R01');
    expect(spiel.renderer.stats.spritesDrawn, greaterThan(0));
    e.tasteRunter(Taste.aktion);
    spiel.tick(1 / 30, e);
    spiel.tick(1 / 30, e);
    expect(erk.karten.any((x) => x.art == 'aussage' && x.von == 'R01'), isTrue);
  });
}

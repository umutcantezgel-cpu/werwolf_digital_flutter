import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// Ein Zeitschritt bei 30 Bildern je Sekunde.
const double _dt = 1 / 30;

/// Die Oberstadt aus dem Repo, wie im Spiel geladen.
Bereich _oberstadt() {
  final spiel = Spiel()..groesse(1280, 720);
  ladeAusRepo(spiel);
  return spiel.stadt.bereiche['stadt']!;
}

/// Orte aller Tiere nach jedem von [schritte] Ticks.
List<List<(double, double, double)>> _spur(Fledermaeuse f, int schritte) {
  final out = <List<(double, double, double)>>[];
  for (var i = 0; i < schritte; i++) {
    f.tick(_dt);
    out.add(f.orte);
  }
  return out;
}

void main() {
  late Bereich stadt;
  setUpAll(() => stadt = _oberstadt());

  test('gleicher Seed, gleiche Bahn: 600 Ticks ergeben identische Positionen', () {
    final a = _spur(Fledermaeuse(stadt, seed: 3), 600);
    final b = _spur(Fledermaeuse(stadt, seed: 3), 600);
    expect(b, equals(a));
    final c = _spur(Fledermaeuse(stadt, seed: 4), 600);
    expect(c, isNot(equals(a)));
  });

  test('600 Ticks: Höhe 8–18 m, Tiere bleiben innerhalb der Stadt und fliegen', () {
    final f = Fledermaeuse(stadt);
    final start = f.orte;
    for (var i = 0; i < 600; i++) {
      f.tick(_dt);
      for (final (x, y, z) in f.orte) {
        expect(y, inInclusiveRange(8, 18), reason: 'Tick $i: Höhe');
        expect(x, inInclusiveRange(0, stadt.breite * kKachel), reason: 'Tick $i: x');
        expect(z, inInclusiveRange(0, stadt.tiefe * kKachel), reason: 'Tick $i: z');
        final c = stadt.zeichen((x / kKachel).floor(), (z / kKachel).floor());
        expect(c, isNot(anyOf(equals(' '), equals('#'))), reason: 'Tick $i: außerhalb bei $x/$z');
      }
    }
    expect(f.orte, isNot(equals(start)));
  });

  test('Sprites bestehen die Palettenprüfung', () {
    expect(Fledermaeuse.bilder, hasLength(3));
    for (final (i, b) in Fledermaeuse.bilder.indexed) {
      expect(b.width, 9, reason: 'Bild $i: Breite');
      expect(b.height, 5, reason: 'Bild $i: Höhe');
      expect(b.footX, 4, reason: 'Bild $i: Fußpunkt x');
      expect(b.footY, 2, reason: 'Bild $i: Fußpunkt y');
      var sichtbar = 0;
      for (var y = 0; y < b.height; y++) {
        for (var x = 0; x < b.width; x++) {
          final c = b.pixels[y * b.width + x];
          if (c == kTransparent) continue;
          sichtbar++;
          expect(c, lessThan(paletteRgb.length), reason: 'Bild $i bei $x/$y: Index außerhalb der Palette');
          final rand = x == 0 ||
              y == 0 ||
              x == b.width - 1 ||
              y == b.height - 1 ||
              b.pixels[y * b.width + x - 1] == kTransparent ||
              b.pixels[y * b.width + x + 1] == kTransparent ||
              b.pixels[(y - 1) * b.width + x] == kTransparent ||
              b.pixels[(y + 1) * b.width + x] == kTransparent;
          if (rand) expect(c & 7, lessThanOrEqualTo(4), reason: 'Bild $i bei $x/$y: helle Kontur');
        }
      }
      expect(sichtbar, greaterThanOrEqualTo(15), reason: 'Bild $i: zu wenig Pixel');
    }
    expect({for (final b in Fledermaeuse.bilder) b.pixels.join(',')}, hasLength(3), reason: 'Flügelbilder gleich');
  });

  test('gerendertes Bild: nur Palettenfarben, höchstens 12 Sprites je Bild', () {
    final fb = PixelBuffer(240, 135);
    final r = Renderer(fb, LightTable.night(), const <IndexedTexture>[]);
    final f = Fledermaeuse(stadt, anzahl: 40);
    r.camera
      ..x = 70
      ..z = 77
      ..yaw = -0.6
      ..pitch = 0.15;
    var gezeichnet = 0;
    for (var i = 0; i < 600; i++) {
      f.tick(_dt);
      r.begin();
      r.drawSky();
      f.zeichne(r);
      expect(r.stats.spritesDrawn, lessThanOrEqualTo(12), reason: 'Tick $i');
      gezeichnet += r.stats.spritesDrawn;
      if (i % 60 == 0) expect(countOffPalette(fb.toRgbaBytes()), 0, reason: 'Tick $i: Farbe außerhalb der Palette');
    }
    expect(gezeichnet, greaterThan(0), reason: 'kein Tier im Bild');
  });

  test('Anzahl: höchstens 12 Tiere, nie weniger als 0', () {
    expect(Fledermaeuse(stadt, anzahl: 40).anzahl, 12);
    expect(Fledermaeuse(stadt).anzahl, 9);
    expect(Fledermaeuse(stadt, anzahl: -3).anzahl, 0);
  });

  test('sichtbar nur draußen im Bereich stadt', () {
    final f = Fledermaeuse(stadt);
    expect(f.sichtbarIn(stadt), isTrue);
    final innen = Bereich(id: 'stadt', name: 'Innen', innen: true, karte: ['.'], legende: {});
    expect(f.sichtbarIn(innen), isFalse);
    final gaenge = Bereich(id: 'gaenge', name: 'Gänge', innen: false, karte: ['.'], legende: {});
    expect(f.sichtbarIn(gaenge), isFalse);
  });

  test('kleine Stadt: Bahnen schrumpfen, Tiere bleiben innerhalb', () {
    // 10 × 10 m Stadt: der Bahnradius 8,5 m passt nicht hinein und muss kleiner werden.
    final klein = Bereich(id: 'stadt', name: 'Klein', innen: false, karte: [for (var z = 0; z < 20; z++) '.' * 20], legende: {});
    final f = Fledermaeuse(klein, seed: 5);
    for (var i = 0; i < 600; i++) {
      f.tick(_dt);
      for (final (x, y, z) in f.orte) {
        expect(x, inInclusiveRange(0, 10), reason: 'Tick $i: x');
        expect(z, inInclusiveRange(0, 10), reason: 'Tick $i: z');
        expect(y, inInclusiveRange(8, 18), reason: 'Tick $i: Höhe');
      }
    }
  });

  test('Gruppenwechsel und Bahnen ohne Sprünge (3000 Ticks, rund 100 s)', () {
    // Ein Wechsel fliegt über rund 9 s; je Tick (30 Hz) darf kein Tier mehr als 0,6 m springen.
    final f = Fledermaeuse(stadt, seed: 7);
    var vorher = f.orte;
    var groesster = 0.0;
    for (var i = 0; i < 3000; i++) {
      f.tick(_dt);
      final jetzt = f.orte;
      for (var k = 0; k < jetzt.length; k++) {
        final (ax, ay, az) = vorher[k];
        final (bx, by, bz) = jetzt[k];
        final schritt = math.sqrt((bx - ax) * (bx - ax) + (by - ay) * (by - ay) + (bz - az) * (bz - az));
        groesster = math.max(groesster, schritt);
      }
      vorher = jetzt;
    }
    expect(groesster, lessThan(0.6));
  });

  test('Kosten: höchstens 0,05 ms je Tick', () {
    final f = Fledermaeuse(stadt);
    for (var i = 0; i < 100; i++) {
      f.tick(_dt); // Aufwärmen
    }
    final uhr = Stopwatch()..start();
    for (var i = 0; i < 600; i++) {
      f.tick(_dt);
    }
    uhr.stop();
    final msJeTick = uhr.elapsedMicroseconds / 600 / 1000;
    expect(msJeTick, lessThan(0.05));
  });
}

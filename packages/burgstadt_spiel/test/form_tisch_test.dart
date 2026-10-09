import 'dart:math' as math;
import 'dart:typed_data';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// Auftragsfälle (Grundfläche Länge × Tiefe in m, Höhe m, lichtWarm, Budget in Dreiecken):
/// Tisch mit Kerze, Festtafel, Lesepult mit Kerze, Nachttisch. Budget = 60 + 24 je weiterem Beinpaar + 30 je Kerze.
const _faelle = <(String, double, double, double, double, int)>[
  ('Tisch mit Kerze 1,92 × 0,92 × 0,8', 1.92, 0.92, 0.8, 0.6, 90),
  ('Festtafel 6,92 × 0,92 × 0,78', 6.92, 0.92, 0.78, 0.0, 132),
  ('Lesepult mit Kerze 0,92 × 0,92 × 1,0', 0.92, 0.92, 1.0, 0.6, 90),
  ('Nachttisch 0,42 × 0,42 × 0,6', 0.42, 0.42, 0.6, 0.0, 60),
];

/// Wie Float32-Speicher einen Wert rundet: Eckpunkte liegen als Float32 im Mesh.
double _f(double v) => Float32List.fromList([v])[0];

/// Ding mit Legende wie in `bereich.dart` gebaut (Kachelgrenzen inklusive); für die Form zählen Licht und Höhe.
Ding _ding(double lichtWarm, double hoehe) => Ding(
      'T',
      Legende(KachelArt.objekt, 'Tisch', form: 'tisch', hoehe: hoehe, textur: 'holzDielen', lichtWarm: lichtWarm),
      2,
      4,
      2,
      4,
    );

/// Form-Ort mit Grundfläche [laenge] × [tiefe] ab (1,0 / 2,0), Höhe [hoehe], Textur [textur], Wand [rueckseite].
FormOrt _ort(String bereich, double laenge, double tiefe, double hoehe, double lichtWarm, int textur, int rueckseite) =>
    FormOrt(
      ding: _ding(lichtWarm, hoehe),
      bereichId: bereich,
      x0: 1.0,
      z0: 2.0,
      x1: 1.0 + laenge,
      z1: 2.0 + tiefe,
      hoehe: hoehe,
      textur: textur,
      warm: 0.35,
      kalt: 0.15,
      rueckseite: rueckseite,
    );

Mesh _baue(FormOrt o) {
  final m = MeshBuilder();
  kFormen['tisch']!.baue(m, o);
  return m.build();
}

/// Eckpunkte außerhalb von Grundfläche und Höhe (Float32-Grenzen, Toleranz 1e-9).
List<String> _ausserhalb(Mesh mesh, FormOrt o) {
  // Eine Kerze darf 0,16 m über der Platte (= Datenhöhe) stehen.
  final kerze = o.ding.legende.lichtWarm > 0 ? 0.16 : 0.0;
  final xLo = _f(o.x0), xHi = _f(o.x1), zLo = _f(o.z0), zHi = _f(o.z1), yHi = _f(o.hoehe + kerze);
  final liste = <String>[];
  for (var i = 0; i < mesh.vertexCount; i++) {
    final x = mesh.pos[3 * i], y = mesh.pos[3 * i + 1], z = mesh.pos[3 * i + 2];
    if (x < xLo - 1e-9 || x > xHi + 1e-9 || z < zLo - 1e-9 || z > zHi + 1e-9 || y < -1e-9 || y > yHi + 1e-9) {
      liste.add('($x, $y, $z)');
    }
  }
  return liste;
}

/// Anzahl der Dreiecke mit Textur [tex].
int _tris(Mesh mesh, int tex) => mesh.tex.where((t) => t == tex).length;

void main() {
  final holz = TexturId.holzDielen.index;
  final flamme = TexturId.fensterKerze.index;
  final erlaubt = {holz, TexturId.putzCreme.index, TexturId.ziegelKamin.index, flamme};

  for (final (name, laenge, tiefe, hoehe, lichtWarm, budget) in _faelle) {
    for (final r in [0, 1, 2, 3]) {
      test('$name, rueckseite $r: Grenzen, Dreiecke, Kennung, Texturen', () {
        final o = _ort('test', laenge, tiefe, hoehe, lichtWarm, holz, r);
        final mesh = _baue(o);

        // (a) alle Eckpunkte in Grundfläche und Höhe
        expect(_ausserhalb(mesh, o), isEmpty, reason: 'Eckpunkte außerhalb Grundfläche/Höhe');

        // (b) Dreiecke zwischen 12 und Budget
        expect(mesh.triangleCount, greaterThanOrEqualTo(12));
        expect(mesh.triangleCount, lessThanOrEqualTo(budget), reason: 'Dreiecksbudget');

        // (c) gleiche Kennung (gleiches Ding) → identisches Mesh
        final zweit = _baue(_ort('test', laenge, tiefe, hoehe, lichtWarm, holz, r));
        expect(zweit.pos, equals(mesh.pos));
        expect(zweit.uv, equals(mesh.uv));
        expect(zweit.tri, equals(mesh.tri));
        expect(zweit.tex, equals(mesh.tex));

        // (d) nur erlaubte Texturen
        expect(mesh.tex.toSet().difference(erlaubt), isEmpty);
      });
    }
  }

  test('ohne lichtWarm keine Flamme (fensterKerze-Dreiecke)', () {
    for (final r in [0, 1, 2, 3]) {
      final mesh = _baue(_ort('test', 1.92, 0.92, 0.8, 0, holz, r));
      expect(_tris(mesh, flamme), 0, reason: 'rueckseite $r');
    }
  });

  test('mit lichtWarm genau 1 Flamme bei 1,92 m Länge (ein Quader = 10 Dreiecke)', () {
    for (final r in [0, 1, 2, 3]) {
      final mesh = _baue(_ort('test', 1.92, 0.92, 0.8, 0.6, holz, r));
      expect(_tris(mesh, flamme), 10, reason: 'rueckseite $r');
    }
  });

  test('Kerzen: je angefangene 2 m Tischlänge, höchstens 3', () {
    expect(_tris(_baue(_ort('test', 6.92, 0.92, 0.78, 0.6, holz, 0)), flamme), 30);
    expect(_tris(_baue(_ort('test', 2.42, 0.92, 0.8, 0.6, holz, 0)), flamme), 20);
  });

  test('Lesepult: Pultplatte oben an der Rückseite, 15° nach vorne abfallend', () {
    for (final r in [0, 1, 2, 3]) {
      final o = _ort('test', 0.92, 0.92, 1.0, 0, holz, r);
      final mesh = _baue(o);
      final tiefe = r.isEven ? o.tiefe : o.breite;
      double abstand(double x, double z) => switch (r) {
            0 => z - o.z0,
            1 => o.x1 - x,
            2 => o.z1 - z,
            _ => x - o.x0,
          };
      final hinten = <double>[], vorne = <double>[];
      for (var i = 0; i < mesh.vertexCount; i++) {
        final x = mesh.pos[3 * i], y = mesh.pos[3 * i + 1], z = mesh.pos[3 * i + 2];
        final a = abstand(x, z);
        if (a.abs() < 1e-6) hinten.add(y);
        if ((a - tiefe).abs() < 1e-6) vorne.add(y);
      }
      expect(hinten, anyElement(closeTo(1.0, 1e-6)), reason: 'rueckseite $r: Oberkante an der Wand');
      expect(vorne, anyElement(closeTo(1.0 - tiefe * math.tan(math.pi / 12), 1e-4)),
          reason: 'rueckseite $r: Vorderkante 15° tiefer');
    }
  });

  test('Varianten: Bauerntisch (hash 0) und Beine kommen beide vor, beide in Grenzen und Budget', () {
    final bauern = <bool>{};
    for (final id in ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']) {
      final o = _ort(id, 6.92, 0.92, 0.78, 0, holz, 0);
      bauern.add(o.hash(0) % 3 == 0);
      final mesh = _baue(o);
      expect(_ausserhalb(mesh, o), isEmpty, reason: 'Bereich $id: Grenzen');
      expect(mesh.triangleCount, lessThanOrEqualTo(132), reason: 'Bereich $id: Budget');
    }
    expect(bauern, {true, false});
  });
}

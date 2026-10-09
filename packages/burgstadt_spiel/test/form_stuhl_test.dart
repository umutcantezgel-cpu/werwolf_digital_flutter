import 'dart:typed_data';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// Auftragsfälle (Grundfläche m × m, Höhe m, Budget in Dreiecken): Hocker, Stuhl mit Lehne, Sessel.
const _faelle = <(String, double, double, int)>[
  ('Hocker 0,42 × 0,42 × 0,5', 0.42, 0.5, 70),
  ('Stuhl 0,42 × 0,42 × 0,9', 0.42, 0.9, 70),
  ('Sessel 0,92 × 0,92 × 0,9', 0.92, 0.9, 90),
];

/// Wie Float32-Speicher einen Wert rundet: Eckpunkte liegen als Float32 im Mesh.
double _f(double v) => Float32List.fromList([v])[0];

/// Ding mit Legende wie in `bereich.dart` gebaut (Kachelgrenzen inklusive).
Ding _ding(double hoehe) => Ding(
      'S',
      Legende(KachelArt.objekt, 'Stuhl', form: 'stuhl', hoehe: hoehe, textur: 'holzBohlen'),
      2,
      4,
      2,
      4,
    );

/// Form-Ort mit Grundfläche [grund] × [grund] ab (1,0 / 2,0), Höhe [hoehe], Textur [textur], Lehne [rueckseite].
FormOrt _ort(double grund, double hoehe, int textur, int rueckseite) => FormOrt(
      ding: _ding(hoehe),
      bereichId: 'test',
      x0: 1.0,
      z0: 2.0,
      x1: 1.0 + grund,
      z1: 2.0 + grund,
      hoehe: hoehe,
      textur: textur,
      warm: 0.35,
      kalt: 0.15,
      rueckseite: rueckseite,
    );

Mesh _baue(FormOrt o) {
  final m = MeshBuilder();
  kFormen['stuhl']!.baue(m, o);
  return m.build();
}

void main() {
  final tex = TexturId.holzBohlen.index;

  for (final (name, grund, hoehe, budget) in _faelle) {
    for (final r in [0, 1, 2, 3]) {
      test('$name, rueckseite $r: Grenzen, Dreiecke, Kennung, Texturen', () {
        final o = _ort(grund, hoehe, tex, r);
        final mesh = _baue(o);

        // (a) alle Eckpunkte in Grundfläche und Höhe (Toleranz 1e-9, Grenzen als Float32 wie das Mesh)
        final xLo = _f(o.x0), xHi = _f(o.x1), zLo = _f(o.z0), zHi = _f(o.z1), yHi = _f(o.hoehe);
        final ausserhalb = <String>[];
        for (var i = 0; i < mesh.vertexCount; i++) {
          final x = mesh.pos[3 * i], y = mesh.pos[3 * i + 1], z = mesh.pos[3 * i + 2];
          if (x < xLo - 1e-9 || x > xHi + 1e-9 || z < zLo - 1e-9 || z > zHi + 1e-9 || y < -1e-9 || y > yHi + 1e-9) {
            ausserhalb.add('($x, $y, $z)');
          }
        }
        expect(ausserhalb, isEmpty, reason: 'Eckpunkte außerhalb Grundfläche/Höhe');

        // (b) Dreiecke zwischen 12 und Budget
        expect(mesh.triangleCount, greaterThanOrEqualTo(12));
        expect(mesh.triangleCount, lessThanOrEqualTo(budget), reason: 'Dreiecksbudget');

        // (c) gleiche Kennung (gleiches Ding) → identisches Mesh
        final zweit = _baue(_ort(grund, hoehe, tex, r));
        expect(zweit.pos, equals(mesh.pos));
        expect(zweit.uv, equals(mesh.uv));
        expect(zweit.tri, equals(mesh.tri));
        expect(zweit.tex, equals(mesh.tex));

        // (d) nur die erlaubte Textur (o.textur)
        expect(mesh.tex.toSet(), equals({tex}));
      });
    }
  }

  test('Stuhl mit Lehne: Lehne liegt an der Seite rueckseite (Teile über Sitzhöhe 0,5 m)', () {
    for (final r in [0, 1, 2, 3]) {
      final o = _ort(0.42, 0.9, tex, r);
      final mesh = _baue(o);
      final tiefen = <double>[];
      for (var i = 0; i < mesh.vertexCount; i++) {
        final x = mesh.pos[3 * i], y = mesh.pos[3 * i + 1], z = mesh.pos[3 * i + 2];
        if (y <= 0.5) continue;
        // Abstand von der Rückseite (Wand) in m
        tiefen.add(switch (r) {
          1 => o.x1 - x,
          2 => o.z1 - z,
          3 => x - o.x0,
          _ => z - o.z0,
        });
      }
      expect(tiefen, isNotEmpty, reason: 'rueckseite $r: keine Lehnenteile über 0,5 m');
      expect(tiefen.reduce((a, b) => a > b ? a : b), lessThanOrEqualTo(0.1 + 1e-6), reason: 'rueckseite $r');
    }
  });
}

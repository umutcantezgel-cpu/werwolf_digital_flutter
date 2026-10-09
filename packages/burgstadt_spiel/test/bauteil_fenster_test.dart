import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/src/bau/teile/fenster.dart';
import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// Texturrollen eines Fensters: Glas, Rahmen, Sims (Sturz nutzt den Sims).
Map<String, int> _texturen() => {
      'glas': TexturId.fensterDunkel.index,
      'rahmen': TexturId.putzKalkweiss.index,
      'sims': TexturId.quaderMauer.index,
    };

/// Fenster 0,9 × 1,1 m, Unterkante 1,3 m, mittig auf der Fläche, Kennung [kennung].
Mesh _baue(Wandflaeche w, String kennung) {
  final m = MeshBuilder();
  FensterV1().baue(
    m,
    BauteilOrt(
      flaeche: w,
      u: w.laenge / 2,
      y: 1.3,
      breite: 0.9,
      hoehe: 1.1,
      kennung: kennung,
      texturen: _texturen(),
    ),
  );
  return m.build();
}

/// Wand nach Süden: Normale (0, 1), Grundlinie von x = −2 bis x = 2.
const _sued = Wandflaeche(x0: -2, z0: 0, x1: 2, z1: 0, y0: 0, y1: 3, nx: 0, nz: 1, warm: 0.2, kalt: 0.3);

/// Wand nach Osten: Normale (1, 0), Grundlinie von z = 2 bis z = −2.
const _ost = Wandflaeche(x0: 0, z0: 2, x1: 0, z1: -2, y0: 0, y1: 3, nx: 1, nz: 0, warm: 0.2, kalt: 0.3);

/// Abstand (Meter) eines Eckpunkts von der Wand in Normalenrichtung.
double _vorWand(Wandflaeche w, double x, double z) => (x - w.x0) * w.nx + (z - w.z0) * w.nz;

/// Abstand (Meter) eines Eckpunkts vom Wandanfang entlang der Grundlinie.
double _entlang(Wandflaeche w, double x, double z) {
  final l = w.laenge;
  return ((x - w.x0) * (w.x1 - w.x0) + (z - w.z0) * (w.z1 - w.z0)) / l;
}

void main() {
  for (final (name, w) in [('Süden', _sued), ('Osten', _ost)]) {
    test('(a) Fenster nach $name: Dreiecke, Grenzen vor der Wand und entlang der Fensterbreite', () {
      final mesh = _baue(w, 'test|$name');
      expect(mesh.triangleCount, greaterThan(20));
      final mitte = w.laenge / 2;
      for (var i = 0; i < mesh.vertexCount; i++) {
        final x = mesh.pos[3 * i], z = mesh.pos[3 * i + 2];
        final vor = _vorWand(w, x, z);
        expect(vor, inInclusiveRange(-0.01, 0.13), reason: 'Eckpunkt $i vor der Wand');
        expect((_entlang(w, x, z) - mitte).abs(), lessThanOrEqualTo(0.9 / 2 + 0.2), reason: 'Eckpunkt $i entlang');
      }
    });
  }

  test('(b) Vorsprung unter 2,3 m höchstens 0,10 m (Stilblatt §6)', () {
    for (final w in [_sued, _ost]) {
      final mesh = _baue(w, 'vorsprung|${w.nx}');
      var unter = 0;
      for (var i = 0; i < mesh.vertexCount; i++) {
        final y = mesh.pos[3 * i + 1];
        if (y >= 2.3) continue;
        unter++;
        expect(_vorWand(w, mesh.pos[3 * i], mesh.pos[3 * i + 2]), lessThanOrEqualTo(0.10), reason: 'Eckpunkt $i');
      }
      expect(unter, greaterThan(0));
    }
  });

  test('(c) gleiche Kennung ergibt identische Meshes', () {
    final a = _baue(_sued, 'bauteil-test|7');
    final b = _baue(_sued, 'bauteil-test|7');
    expect(a.pos, equals(b.pos));
    expect(a.uv, equals(b.uv));
    expect(a.light, equals(b.light));
    expect(a.tri, equals(b.tri));
    expect(a.tex, equals(b.tex));
    expect(a.flags, equals(b.flags));
  });
}

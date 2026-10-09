import 'dart:typed_data';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/src/bau/form.dart';
import 'package:burgstadt_spiel/src/bau/formen/bank.dart';
import 'package:burgstadt_spiel/src/bau/formen/register.dart';
import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// Testgrundfläche aus dem Auftrag: Grenzen in Metern (schon um 0,04 m eingerückt) und Höhe.
class _Grund {
  const _Grund(this.name, this.x0, this.z0, this.x1, this.z1, this.hoehe);

  final String name;
  final double x0, z0, x1, z1, hoehe;

  /// Länge der längeren Seite (laufender Meter für das Budget).
  double get lang => (x1 - x0) > (z1 - z0) ? x1 - x0 : z1 - z0;
}

const _grundflaechen = [
  _Grund('2,42 × 0,42 × 0,45', 0.04, 0.04, 2.46, 0.46, 0.45),
  _Grund('0,42 × 3,92 × 0,45 (längs in z)', 0.04, 0.04, 0.46, 3.96, 0.45),
  _Grund('1,42 × 0,42 × 0,7 (Sägebock)', 0.04, 0.04, 1.46, 0.46, 0.7),
  _Grund('3,92 × 0,92 × 0,9 (Bankreihe)', 0.04, 0.04, 3.96, 0.96, 0.9),
];

/// Erlaubte Texturen: nur die Textur des Dings.
final _textur = TexturId.holzBohlen.index;

FormOrt _ort(_Grund g, int rueckseite, {String bereich = 'test-bank', int kachelX = 0}) {
  final legende = Legende(KachelArt.objekt, 'Bank', form: 'bank', hoehe: g.hoehe, textur: 'holzBohlen');
  final ding = Ding('B', legende, kachelX, 0, kachelX, 0);
  return FormOrt(
    ding: ding,
    bereichId: bereich,
    x0: g.x0,
    z0: g.z0,
    x1: g.x1,
    z1: g.z1,
    hoehe: g.hoehe,
    textur: _textur,
    warm: 0.35,
    kalt: 0.15,
    rueckseite: rueckseite,
  );
}

Mesh _baue(FormOrt o) {
  final m = MeshBuilder();
  const BankForm().baue(m, o);
  return m.build();
}

/// Wert auf Float32 gerundet, weil das Mesh Positionen in Float32 speichert.
double _f32(double v) => Float32List.fromList([v])[0];

void main() {
  test('Name und Registereintrag', () {
    expect(const BankForm().name, 'bank');
    expect(kFormen['bank'], isA<BankForm>());
  });

  for (final g in _grundflaechen) {
    for (var rs = 0; rs < 4; rs++) {
      group('${g.name} · rueckseite $rs', () {
        final o = _ort(g, rs);
        final mesh = _baue(o);

        test('(a) alle Eckpunkte in Grundfläche und Höhe', () {
          const tol = 1e-9;
          for (var i = 0; i < mesh.vertexCount; i++) {
            final x = mesh.pos[3 * i], y = mesh.pos[3 * i + 1], z = mesh.pos[3 * i + 2];
            expect(x, inInclusiveRange(_f32(g.x0) - tol, _f32(g.x1) + tol), reason: 'x von Eckpunkt $i');
            expect(z, inInclusiveRange(_f32(g.z0) - tol, _f32(g.z1) + tol), reason: 'z von Eckpunkt $i');
            expect(y, inInclusiveRange(0 - tol, _f32(g.hoehe) + tol), reason: 'y von Eckpunkt $i');
          }
        });

        test('(b) Dreiecke zwischen 12 und Budget (24 je Meter + 40)', () {
          expect(mesh.triangleCount, greaterThanOrEqualTo(12));
          expect(mesh.triangleCount, lessThanOrEqualTo(24 * g.lang + 40));
        });

        test('(c) gleiche Kennung ergibt identisches Mesh', () {
          final b = _baue(_ort(g, rs));
          expect(b.pos, orderedEquals(mesh.pos));
          expect(b.uv, orderedEquals(mesh.uv));
          expect(b.tri, orderedEquals(mesh.tri));
          expect(b.tex, orderedEquals(mesh.tex));
        });

        test('(d) Texturindizes nur aus der erlaubten Menge', () {
          expect(mesh.tex.toSet(), {_textur});
        });
      });
    }
  }

  group('Budget über alle Längen und beide Varianten', () {
    // Sitzbank 0,42 tief, Sägebock 0,42 tief, Bankreihe 0,92 tief; Längen 2 bis 8 Kacheln (Kachel 0,5 m).
    const arten = [(0.45, 0.42), (0.7, 0.42), (0.9, 0.92)];
    for (final (hoehe, tiefe) in arten) {
      for (var kacheln = 2; kacheln <= 8; kacheln++) {
        final lang = kacheln * kKachel - 0.08;
        final g = _Grund('h $hoehe · $kacheln Kacheln', 0.04, 0.04, 0.04 + lang, 0.04 + tiefe, hoehe);
        test('${g.name}: beide Sitzbrett-Varianten im Budget', () {
          final varianten = <int>{};
          for (var i = 0; i < 16; i++) {
            final o = _ort(g, 0, bereich: 'test-$i', kachelX: i);
            varianten.add(o.hash(0) % 2);
            final mesh = _baue(o);
            expect(mesh.triangleCount, greaterThanOrEqualTo(12));
            expect(mesh.triangleCount, lessThanOrEqualTo(24 * lang + 40), reason: 'Kennung test-$i');
          }
          expect(varianten, {0, 1});
        });
      }
    }
  });
}

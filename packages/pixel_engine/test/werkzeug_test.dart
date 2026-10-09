import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

void main() {
  // Golden-Werte: auf der Dart-VM und per dart2js (Node) identisch gemessen (P1-OPUS-01, N-19).
  test('hashTeil: Golden-Werte (VM = Web)', () {
    const golden = {
      ('', 0): 91794203,
      ('H-001', 0): 2134525537,
      ('H-001', 1): 1110042783,
      ('H-001', 2): 1698396510,
      ('haus-H-155', 7): 1542450800,
      ('stadt|fenster', 123456): 1929464221,
      ('Ünïcödé', 42): 181973872,
      ('innen-kirche', -1): 1701518416,
    };
    for (final e in golden.entries) {
      expect(hashTeil(e.key.$1, e.key.$2), e.value, reason: '${e.key}');
    }
  });

  test('hashTeil: nicht negativ, gleichmäßig verteilt (16 Fächer, je ±15 %)', () {
    final faecher = List<int>.filled(16, 0);
    for (var i = 0; i < 16000; i++) {
      final h = hashTeil('H-${i ~/ 8}', i % 8);
      expect(h, greaterThanOrEqualTo(0));
      faecher[h % 16]++;
    }
    for (final f in faecher) {
      expect(f, inInclusiveRange(850, 1150));
    }
  });

  test('Lcg und Tex: Wrap und Wiederholbarkeit', () {
    final a = Lcg(7), b = Lcg(7);
    for (var i = 0; i < 100; i++) {
      expect(a.next(), b.next());
    }
    final t = Tex(8)..p(-1, -1, 5);
    expect(t.g(7, 7), 5);
    expect(t.build().width, 8);
  });

  test('Textur-Register: Bestand mit Dichte 32, Bauer liefert gleiche Bytes', () {
    for (final id in TexturId.values) {
      final e = texturEintrag(id);
      expect(e.dichte, anyOf(32, 64));
      expect(e.bauer().levels[0], baueTextur(id).levels[0]);
    }
  });
}

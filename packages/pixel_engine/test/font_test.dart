import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

void main() {
  final font = BitmapFont.parse(kSchriftNormal);

  test('Spielschrift ist vollständig und regelkonform', () {
    final befunde = font.validate();
    expect(befunde, isEmpty, reason: befunde.join('\n'));
  });

  test('Text messen, umbrechen und zeichnen', () {
    expect(font.measure('A'), font.glyphs[0x41]!.width);
    final lines = font.wrap('Spuk im Gewölbe der Burgstadt Schartenfels', 60);
    expect(lines.length, greaterThan(1));
    for (final l in lines) {
      expect(font.measure(l), lessThanOrEqualTo(60));
    }
    final fb = PixelBuffer(120, 16)..clear(Pal.black);
    final w = font.draw(fb, 'Hallo', 2, 2, Pal.parchment, shadow: Pal.iron);
    expect(w, font.measure('Hallo'));
    expect(fb.color.where((c) => c == Pal.parchment).length, greaterThan(10));
  });
}

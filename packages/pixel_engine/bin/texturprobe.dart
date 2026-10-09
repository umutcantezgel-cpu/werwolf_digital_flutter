import 'dart:io';

import 'package:pixel_engine/pixel_engine.dart';

/// Kontaktbogen aller Texturen als PNG (×2): `dart run bin/texturprobe.dart datei.png`
/// Je Textur 2×2 gekachelt, Name darunter (BitmapFont), Hintergrund Pal.nightBlue.
void main(List<String> args) {
  final texturen = baueAlleTexturen();
  final font = BitmapFont.parse(_probeSchrift());
  const spalten = 5, zelleB = 136, zelleH = 146, rand = 6;
  final zeilen = (texturen.length + spalten - 1) ~/ spalten;
  final w = rand + spalten * zelleB, h = rand + zeilen * zelleH;
  final fb = PixelBuffer(w, h)..clear(Pal.nightBlue);
  for (var i = 0; i < texturen.length; i++) {
    final t = texturen[i];
    final x0 = rand + (i % spalten) * zelleB, y0 = rand + (i ~/ spalten) * zelleH;
    final px = t.levels[0], n = t.width;
    for (var ty = 0; ty < 2; ty++) {
      for (var tx = 0; tx < 2; tx++) {
        for (var y = 0; y < n; y++) {
          for (var x = 0; x < n; x++) {
            fb.set(x0 + tx * n + x, y0 + ty * n + y, px[y * n + x]);
          }
        }
      }
    }
    font.draw(fb, TexturId.values[i].name, x0, y0 + 2 * n + 5, Pal.parchment);
  }
  final out = upscaleRgba(fb.toRgbaBytes(), w, h, 2);
  final pfad = args.isEmpty ? 'texturen.png' : args.first;
  File(pfad).writeAsBytesSync(encodePngRgba(w * 2, h * 2, out, zlib: zlib.encode));
  stdout.writeln('Kontaktbogen: ${texturen.length} Texturen → $pfad (${w * 2}×${h * 2})');
}

/// Probeschrift (3×5) für die Namen. Die Spielschrift A-104a fehlt noch; Groß- und
/// Kleinbuchstaben teilen sich hier die Formen, das reicht für die Beschriftung.
String _probeSchrift() {
  final b = StringBuffer('hoehe 5\noberlinie 0\nx-hoehe 0\ngrundlinie 4\nabstand 1\n');
  _formen.forEach((zeichen, zeilen) {
    for (final c in [zeichen, zeichen.toLowerCase()]) {
      b.writeln('zeichen $c');
      for (final z in zeilen) {
        b.writeln(z);
      }
    }
  });
  return b.toString();
}

const Map<String, List<String>> _formen = {
  'A': ['.#.', '#.#', '###', '#.#', '#.#'],
  'B': ['##.', '#.#', '##.', '#.#', '##.'],
  'C': ['.##', '#..', '#..', '#..', '.##'],
  'D': ['##.', '#.#', '#.#', '#.#', '##.'],
  'E': ['###', '#..', '##.', '#..', '###'],
  'F': ['###', '#..', '##.', '#..', '#..'],
  'G': ['.##', '#..', '#.#', '#.#', '.##'],
  'H': ['#.#', '#.#', '###', '#.#', '#.#'],
  'I': ['###', '.#.', '.#.', '.#.', '###'],
  'K': ['#.#', '#.#', '##.', '#.#', '#.#'],
  'L': ['#..', '#..', '#..', '#..', '###'],
  'M': ['#.#', '###', '###', '#.#', '#.#'],
  'N': ['##.', '#.#', '#.#', '#.#', '#.#'],
  'O': ['.#.', '#.#', '#.#', '#.#', '.#.'],
  'P': ['##.', '#.#', '##.', '#..', '#..'],
  'Q': ['###', '#.#', '#.#', '###', '..#'],
  'R': ['##.', '#.#', '##.', '#.#', '#.#'],
  'S': ['.##', '#..', '.#.', '..#', '##.'],
  'T': ['###', '.#.', '.#.', '.#.', '.#.'],
  'U': ['#.#', '#.#', '#.#', '#.#', '###'],
  'V': ['#.#', '#.#', '#.#', '#.#', '.#.'],
  'W': ['#.#', '#.#', '###', '###', '#.#'],
  'Z': ['###', '..#', '.#.', '#..', '###'],
};

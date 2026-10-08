import 'dart:io';

import 'package:pixel_engine/pixel_engine.dart';

/// Schriftprobe als PNG (×3 vergrößert): `dart run bin/schriftprobe.dart datei.png`
void main(List<String> args) {
  final font = BitmapFont.parse(kSchriftNormal);
  final text = [
    BitmapFont.requiredChars.substring(0, 48),
    BitmapFont.requiredChars.substring(48, 95),
    BitmapFont.requiredChars.substring(95),
    'Spuk im Gewölbe · Burgstadt Schartenfels',
    '„Glück auf … wer hat mir das Licht ausgeknipst?“',
    'Phase 1 – 00:25 bis 01:30 · ½ Kühlpack → Apotheke',
  ];
  const w = 320, h = 90;
  final fb = PixelBuffer(w, h)..clear(Pal.nightBlue);
  for (var i = 0; i < text.length; i++) {
    font.draw(fb, text[i], 4, 3 + i * 14, Pal.parchment, shadow: Pal.black);
  }
  final out = upscaleRgba(fb.toRgbaBytes(), w, h, 3);
  File(args.isEmpty ? 'schriftprobe.png' : args.first).writeAsBytesSync(encodePngRgba(w * 3, h * 3, out));
  final befunde = font.validate();
  stdout.writeln(befunde.isEmpty ? 'Schrift OK (${font.glyphs.length} Zeichen)' : '${befunde.length} Befunde, z. B. ${befunde.take(5).join(' · ')}');
}

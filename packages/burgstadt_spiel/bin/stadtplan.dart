import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:burgstadt_spiel/burgstadt_spiel_io.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Stadtplan (Draufsicht, 1 Kachel = 2×2 px) und Zahlen der generierten Oberstadt.
/// `dart run bin/stadtplan.dart <png>`
void main(List<String> args) {
  final spiel = Spiel();
  ladeAusRepo(spiel);
  final s = spiel.stadt.bereiche['stadt']!;
  final fb = PixelBuffer(s.breite, s.tiefe)..clear(Pal.black);
  for (var z = 0; z < s.tiefe; z++) {
    for (var x = 0; x < s.breite; x++) {
      final d = s.dingAn(x, z);
      final c = switch (s.zeichen(x, z)) {
        '#' => Pal.stone,
        '.' => Ramp.at(Ramp.stone, 3),
        'L' => Pal.wood,
        'G' => Ramp.at(Ramp.green, 2),
        'D' => Pal.candle,
        'U' || 'K' => Pal.white,
        'H' => d == null ? Pal.punch : Ramp.at(Ramp.red, 2 + (d.x0 * 3 + d.z0) % 3),
        'O' => Pal.lightGrey,
        _ => Pal.black,
      };
      fb.set(x, z, c);
    }
  }
  File(args.isEmpty ? 'stadtplan.png' : args[0])
      .writeAsBytesSync(encodePngRgba(s.breite * 2, s.tiefe * 2, upscaleRgba(fb.toRgbaBytes(), s.breite, s.tiefe, 2), zlib: zlib.encode));
  final haeuser = s.dinge.where((d) => d.legende.form == 'haus').length;
  final tueren = s.dinge.where((d) => d.legende.art == KachelArt.tuer && !d.legende.verschlossen).length;
  final innen = spiel.stadt.bereiche.values.where((b) => b.innen && (b.id.startsWith('innen-') || b.id.startsWith('haus-'))).length;
  stdout.writeln('Oberstadt ${s.breite * kKachel} × ${s.tiefe * kKachel} m · Häuser $haeuser (+ Uhrturm) · offene Türen $tueren · Innenräume $innen · Bereiche gesamt ${spiel.stadt.bereiche.length}');
}

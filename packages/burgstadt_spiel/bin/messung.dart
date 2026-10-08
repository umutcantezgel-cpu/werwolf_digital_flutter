import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Zeit je Spiel-Bild (ohne Bildausgabe) für Hauptmenü und Erkundung.
void main(List<String> args) {
  final w = args.isNotEmpty ? int.parse(args[0]) : 1280, h = args.length > 1 ? int.parse(args[1]) : 720;
  final spiel = Spiel()..groesse(w, h);
  final e = Eingabe();
  final sw = Stopwatch();
  for (final name in ['Hauptmenü', 'Erkundung']) {
    if (name == 'Erkundung') spiel.wechsle(Erkundung());
    for (var i = 0; i < 30; i++) {
      spiel.tick(1 / 60, e);
    }
    final rw = spiel.renderer;
    sw
      ..reset()
      ..start();
    var welt = 0;
    for (var i = 0; i < 120; i++) {
      spiel.tick(1 / 60, e);
    }
    sw.stop();
    final t0 = Stopwatch()..start();
    for (var i = 0; i < 120; i++) {
      spiel.bildschirm.zeichneWelt(spiel);
      welt++;
    }
    t0.stop();
    print('MESSUNG $name ${spiel.skala} · Bild ${(sw.elapsedMicroseconds / 120 / 1000).toStringAsFixed(2)} ms · '
        'nur Welt ${(t0.elapsedMicroseconds / welt / 1000).toStringAsFixed(2)} ms · ${rw.stats}');
  }
}

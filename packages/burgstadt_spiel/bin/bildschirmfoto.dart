import 'dart:io';

import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:pixel_engine/pixel_engine.dart';

import 'mess/qualitaet_arg.dart';

/// Rendert Bildschirme headless als PNG in physischer Größe.
/// `dart run bin/bildschirmfoto.dart <ordner> [breite höhe] [--qualitaet name]`
void main(List<String> alleArgs) {
  final (q, args) = qualitaetAusArgs(alleArgs);
  final ordner = args.isEmpty ? '.' : args[0];
  final w = args.length > 2 ? int.parse(args[1]) : 1280;
  final h = args.length > 2 ? int.parse(args[2]) : 720;
  Directory(ordner).createSync(recursive: true);
  final spiel = Spiel(optionen: Optionen()..qualitaet = q)..groesse(w, h);
  void foto(String name) {
    final rgba = komponiere(spiel.welt, spiel.ui, spiel.skala!);
    File('$ordner/$name.png').writeAsBytesSync(encodePngRgba(w, h, rgba, zlib: zlib.encode));
    final b = blockTest(rgba, w, h, spiel.skala!.kUi);
    stdout.writeln('$name: ${spiel.skala} · Palette ${countOffPalette(rgba) == 0 ? 'OK' : 'FEHLER'} · Block $b${b.ratio == 1 ? '' : ' FEHLER'}');
  }

  final e = Eingabe();
  for (var i = 0; i < 3; i++) {
    spiel.tick(1 / 30, e);
  }
  foto('hauptmenue');
  spiel.oeffne(OptionenBildschirm());
  spiel.tick(1 / 30, e);
  foto('optionen');
  spiel.wechsle(Erkundung());
  for (var i = 0; i < 40; i++) {
    e.tasteRunter(Taste.hoch);
    spiel.tick(1 / 30, e);
  }
  e.tasteHoch(Taste.hoch);
  spiel.tick(1 / 30, e);
  foto('erkundung');
}

import 'dart:math' as math;

import 'package:pixel_engine/pixel_engine.dart';

import '../spiel.dart';
import 'erkundung.dart';
import 'optionen_bildschirm.dart';

/// Hauptmenü über der nächtlichen Stadt (Kamera kreist langsam).
class Hauptmenue extends Bildschirm {
  String? hinweis;

  @override
  void betreten(Spiel spiel) {
    spiel.ton.schleife('musik', 'musik_gassen_schleife', lautstaerke: 0.5);
    spiel.ton.schleife('umgebung', 'wind_schleife', lautstaerke: 0.35);
  }

  @override
  void zeichneWelt(Spiel spiel) {
    final c = spiel.renderer.camera;
    final a = spiel.zeit * 0.05;
    c
      ..x = math.cos(a) * 9
      ..z = math.sin(a) * 9
      ..y = 2.2
      ..yaw = a + math.pi * 0.62
      ..pitch = 0.05;
    spiel.renderer.flashStrength = 0;
    spiel.zeichneSzene();
  }

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    final cx = w ~/ 2;
    final hoch = h > w;
    final skalaTitel = w >= 300 ? 2 : 1;
    var y = hoch ? h ~/ 8 : h ~/ 10;
    ui.textMittig('BURGSTADT SCHARTENFELS', cx, y, farbe: UiFarbe.akzent, skala: skalaTitel);
    y += ui.font.height * skalaTitel + 4;
    ui.textMittig('Spuk im Gewölbe', cx, y, farbe: UiFarbe.text);
    y += ui.zeilenHoehe + (hoch ? 24 : 12);
    final breite = math.min(w - 32, 180);
    final wahl = ui.menue(const [
      'Allein spielen',
      'Im WLAN spielen',
      'Optionen',
      'Klassische Fälle',
    ], cx, y, breite: breite);
    switch (wahl) {
      case 0:
        spiel.wechsle(Erkundung());
      case 1:
        hinweis = 'WLAN-Spiel kommt in Phase 5 des Nachtlaufs.';
      case 2:
        spiel.oeffne(OptionenBildschirm());
      case 3:
        spiel.beiAktion?.call('klassisch');
    }
    if (hinweis != null) ui.textMittig(hinweis!, cx, h - ui.zeilenHoehe * 3, farbe: UiFarbe.spuk);
    ui.textMittig('Tippen, klicken oder Pfeiltasten + Eingabe', cx, h - ui.zeilenHoehe - 2, farbe: UiFarbe.textGedimmt);
  }
}

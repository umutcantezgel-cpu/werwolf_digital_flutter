import 'dart:math' as math;

import 'package:pixel_engine/pixel_engine.dart';

import '../spiel.dart';
import 'erkundung.dart';
import 'optionen_bildschirm.dart';
import 'wlan.dart';

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
    // Langsamer Schwenk über den nächtlichen Burghof
    final c = spiel.renderer.camera;
    final a = spiel.zeit * 0.04;
    c
      ..x = 8 + math.cos(a) * 3
      ..z = 6.5 + math.sin(a) * 1.5
      ..y = 2.4
      ..yaw = 0.9 + 0.5 * math.sin(a * 0.7)
      ..pitch = 0.08;
    spiel.renderer.flashStrength = 0;
    spiel.zeichneBereich('hof');
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
    const neu = 'Allein spielen (Detektiv)', weiter = 'Fortsetzen';
    final besetzung = 'Besetzung: ${spiel.besetzung} Rollen';
    final eintraege = [
      if (spiel.letzterStand != null) weiter,
      neu,
      besetzung,
      'Im WLAN spielen',
      'Optionen',
      'Klassische Fälle',
    ];
    final wahl = ui.menue(eintraege, cx, y, breite: breite);
    switch (wahl < 0 ? '' : eintraege[wahl]) {
      case weiter:
        final e = Erkundung.fortsetzen(spiel);
        if (e == null) {
          hinweis = 'Der Spielstand passt nicht mehr zu dieser Version.';
          spiel.letzterStand = null;
        } else {
          spiel.wechsle(e);
        }
      case neu:
        final s = spiel.starteFall();
        spiel.besucht.clear();
        spiel.tutorial.gezeigt.clear();
        if (s == null) {
          spiel.wechsle(Erkundung());
        } else {
          spiel.wechsle(Erkundung(sitzung: s));
        }
      case 'Im WLAN spielen':
        spiel.oeffne(WlanBildschirm());
      case 'Optionen':
        spiel.oeffne(OptionenBildschirm());
      case 'Klassische Fälle':
        spiel.beiAktion?.call('klassisch');
      default:
        if (wahl >= 0 && eintraege[wahl] == besetzung) spiel.besetzung = spiel.besetzung >= 20 ? 4 : spiel.besetzung + 2;
    }
    if (hinweis != null) ui.textMittig(hinweis!, cx, h - ui.zeilenHoehe * 3, farbe: UiFarbe.spuk);
    ui.textMittig('Tippen, klicken oder Pfeiltasten + Eingabe', cx, h - ui.zeilenHoehe - 2, farbe: UiFarbe.textGedimmt);
  }
}

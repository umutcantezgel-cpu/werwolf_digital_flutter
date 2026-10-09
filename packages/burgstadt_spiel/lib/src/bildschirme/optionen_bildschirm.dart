import 'dart:math' as math;

import 'package:pixel_engine/pixel_engine.dart';

import '../skalierung.dart';
import '../spiel.dart';

/// Optionen: Bildqualität, Sichtfeld, Kopfwippen, Flackern, Blick-Empfindlichkeit, Lautstärke,
/// Tutorial. Änderungen meldet [Spiel.optionenGeaendert] (die App speichert sie).
class OptionenBildschirm extends Bildschirm {
  @override
  void tick(Spiel spiel, double dt, Eingabe e) {
    if (e.gedrueckt(Taste.zurueck) || e.gedrueckt(Taste.menue)) spiel.schliesse();
  }

  @override
  bool get zeigtWelt => false;

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final o = spiel.optionen;
    final w = ui.fb.width, h = ui.fb.height;
    final pw = math.min(w - 16, 260);
    final ph = math.min(h - 16, 240);
    final p = Rechteck((w - pw) ~/ 2, (h - ph) ~/ 2, pw, ph);
    ui.panel(p);
    ui.textMittig('Optionen', w ~/ 2, p.y + 6, farbe: UiFarbe.akzent);
    final eintraege = [
      'Bild: ${switch (o.qualitaet) { Qualitaet.sparsam => 'sparsam', Qualitaet.mittel => 'mittel', Qualitaet.hoch => 'hoch' }}',
      'Sichtfeld: ${o.sichtfeldGrad.round()}°',
      'Kopfwippen: ${o.kopfwippen ? 'an' : 'aus'}',
      'Flackern: ${o.flackernAus ? 'aus' : 'an'}',
      'Blick-Empfindlichkeit: ${o.blickEmpfindlichkeit.toStringAsFixed(2)}',
      'Lautstärke: ${o.lautstaerke}',
      'Tutorial: ${o.tutorial ? 'an' : 'aus'}',
      'Zurück',
    ];
    final wahl = ui.menue(eintraege, w ~/ 2, p.y + 6 + ui.zeilenHoehe + 6, breite: pw - 24, hoehe: ui.font.height + 6);
    switch (wahl) {
      case 0:
        spiel.qualitaetSetzen(Qualitaet.values[(o.qualitaet.index + 1) % Qualitaet.values.length]);
      case 1:
        o.sichtfeldGrad = o.sichtfeldGrad >= 80 ? 54 : o.sichtfeldGrad + 6;
        spiel.sichtfeldAktualisieren();
      case 2:
        o.kopfwippen = !o.kopfwippen;
      case 3:
        o.flackernAus = !o.flackernAus;
      case 4:
        o.blickEmpfindlichkeit = o.blickEmpfindlichkeit >= 2 ? 0.5 : o.blickEmpfindlichkeit + 0.25;
      case 5:
        o.lautstaerke = (o.lautstaerke + 2) % 12;
      case 6:
        o.tutorial = !o.tutorial;
      case 7:
        spiel.schliesse();
    }
    if (wahl >= 0 && wahl < 7) spiel.optionenGeaendert?.call();
  }
}

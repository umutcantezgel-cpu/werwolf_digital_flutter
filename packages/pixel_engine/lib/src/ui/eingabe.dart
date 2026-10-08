/// Geräteunabhängige Eingabe eines Bildes (Tastatur, Maus, Touch, Gamepad, Neigen).
/// Die Flutter-Hülle füllt sie; Spiel und Pixel-UI lesen sie.
library;

enum Taste { hoch, runter, links, rechts, drehLinks, drehRechts, aktion, licht, blick, akte, karte, menue, zurueck, bestaetigen, tab, rennen }

enum ZeigerArt { runter, bewegt, hoch, abbruch }

/// Zeiger-Ereignis in UI-Pixelkoordinaten.
class ZeigerEreignis {
  final int id;
  final ZeigerArt art;
  final double x, y;
  final bool maus;
  const ZeigerEreignis(this.id, this.art, this.x, this.y, {this.maus = false});
}

class Eingabe {
  /// Bewegung aus Tastatur/Gamepad (x rechts, y vorwärts), je −1..1.
  double gehenX = 0, gehenY = 0;

  /// Blick-Änderung seit dem letzten Bild (Radiant), aus Maus/Gamepad/Neigen.
  double blickDx = 0, blickDy = 0;

  /// Mausrad seit dem letzten Bild.
  double rad = 0;

  final Set<Taste> gehalten = {};
  final Set<Taste> neu = {};
  final List<ZeigerEreignis> zeiger = [];

  /// Eingetippter Text (verstecktes Textfeld) seit dem letzten Bild.
  String text = '';
  bool textLoeschen = false;

  bool gedrueckt(Taste t) => neu.contains(t);
  bool haelt(Taste t) => gehalten.contains(t);

  void tasteRunter(Taste t) {
    if (gehalten.add(t)) neu.add(t);
  }

  void tasteHoch(Taste t) => gehalten.remove(t);

  /// Nach jedem Bild aufrufen: Einmal-Ereignisse leeren.
  void bildEnde() {
    neu.clear();
    zeiger.clear();
    blickDx = blickDy = rad = 0;
    text = '';
    textLoeschen = false;
  }
}

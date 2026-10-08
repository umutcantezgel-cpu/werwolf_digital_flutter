import 'dart:math' as math;

/// Qualitätsstufe = kurze Bildseite der Welt in Pixeln.
enum Qualitaet {
  sparsam(135),
  mittel(180),
  hoch(216);

  final int kurzeSeite;
  const Qualitaet(this.kurzeSeite);
}

/// Ganzzahlige Skalierung: Welt-Pixel = [kWelt] physische Pixel, UI-Pixel = [kUi].
/// [kWelt] ist immer gerade und [kUi] = [kWelt] / 2: so liegt jedes Welt-Pixel
/// exakt auf 2×2 UI-Pixeln, und das zusammengesetzte Bild besteht den Blocktest
/// im UI-Raster überall.
class Skalierung {
  final int physW, physH;
  final int kWelt, kUi;
  final int weltW, weltH, uiW, uiH;

  const Skalierung._(this.physW, this.physH, this.kWelt, this.kUi, this.weltW, this.weltH, this.uiW, this.uiH);

  factory Skalierung.fuer(int physW, int physH, Qualitaet q) {
    final kurz = math.min(physW, physH);
    // gerades k, dessen kurze Weltseite dem Ziel am nächsten liegt
    var kw = 2;
    var beste = double.infinity;
    for (var k = 2; k <= 32; k += 2) {
      final d = (kurz / k - q.kurzeSeite).abs();
      if (d < beste) {
        beste = d;
        kw = k;
      }
    }
    final ku = kw ~/ 2;
    int auf(int a, int k) => (a + k - 1) ~/ k;
    return Skalierung._(physW, physH, kw, ku, auf(physW, kw), auf(physH, kw), auf(physW, ku), auf(physH, ku));
  }

  bool get hochkant => physH > physW;

  @override
  String toString() => 'Welt ${weltW}x$weltH ×$kWelt · UI ${uiW}x$uiH ×$kUi';
}

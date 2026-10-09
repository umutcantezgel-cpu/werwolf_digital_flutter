import 'dart:math' as math;

/// Qualitätsstufe. [kurzeSeite] = Zielzeilen der kurzen Bildseite für die gerade Rasterwahl.
/// - `sparsam`, `mittel`: Welt gerades k, UI k/2 (unverändert seit dem Nachtlauf).
/// - `scharf` (Burgstadt HD): UI-Raster wie `mittel`, Welt im UI-Raster (kWelt = kUi) –
///   doppelte lineare Weltauflösung, Oberfläche identisch zu `mittel`.
/// - `auto`: wählt zur Laufzeit eine dieser Stufen (bis zur automatischen Wahl wie `mittel`).
enum Qualitaet {
  sparsam(135),
  mittel(180),
  scharf(180),
  auto(180);

  final int kurzeSeite;
  const Qualitaet(this.kurzeSeite);

  /// Gespeicherter Name → Stufe; das frühere „hoch“ wird zu `auto` (E-022).
  static Qualitaet? ausName(String? name) =>
      name == 'hoch' ? Qualitaet.auto : Qualitaet.values.where((q) => q.name == name).firstOrNull;
}

/// Obergrenze für `scharf`: höchstens so viele Weltpixel, sonst gilt `mittel` (E-042).
const int kScharfMaxWeltpixel = 380000;

/// Ganzzahlige Skalierung: Welt-Pixel = [kWelt] physische Pixel, UI-Pixel = [kUi].
/// Bei `sparsam`/`mittel` ist [kWelt] gerade und [kUi] = [kWelt] / 2; bei `scharf` ist
/// [kWelt] = [kUi]. In beiden Fällen liegt jedes Welt-Pixel exakt auf ganzen UI-Pixeln, und das
/// zusammengesetzte Bild besteht den Blocktest im UI-Raster überall.
class Skalierung {
  final int physW, physH;
  final int kWelt, kUi;
  final int weltW, weltH, uiW, uiH;

  /// Die tatsächlich wirksame Stufe (`scharf` fällt an der Obergrenze auf `mittel` zurück).
  final Qualitaet stufe;

  const Skalierung._(this.physW, this.physH, this.kWelt, this.kUi, this.weltW, this.weltH, this.uiW, this.uiH, this.stufe);

  factory Skalierung.fuer(int physW, int physH, Qualitaet q) {
    final basis = q == Qualitaet.sparsam ? Qualitaet.sparsam : Qualitaet.mittel;
    final kurz = math.min(physW, physH);
    // gerades k, dessen kurze Weltseite dem Ziel am nächsten liegt
    var kw = 2;
    var beste = double.infinity;
    for (var k = 2; k <= 32; k += 2) {
      final d = (kurz / k - basis.kurzeSeite).abs();
      if (d < beste) {
        beste = d;
        kw = k;
      }
    }
    final ku = kw ~/ 2;
    int auf(int a, int k) => (a + k - 1) ~/ k;
    if (q == Qualitaet.scharf && ku >= 2 && auf(physW, ku) * auf(physH, ku) <= kScharfMaxWeltpixel) {
      return Skalierung._(physW, physH, ku, ku, auf(physW, ku), auf(physH, ku), auf(physW, ku), auf(physH, ku), Qualitaet.scharf);
    }
    return Skalierung._(physW, physH, kw, ku, auf(physW, kw), auf(physH, kw), auf(physW, ku), auf(physH, ku), basis);
  }

  bool get hochkant => physH > physW;

  @override
  String toString() => 'Welt ${weltW}x$weltH ×$kWelt · UI ${uiW}x$uiH ×$kUi${stufe == Qualitaet.scharf ? ' · scharf' : ''}';
}

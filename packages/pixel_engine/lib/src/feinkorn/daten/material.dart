/// Materialien der Pixel-Blöcke (FEINKORN, 7.6): jedes Material bestimmt Aussehen (Farbe, Streuung,
/// Rauheit, Leuchten), Physik (Dichte, Härte, Reibung, Bruchmuster, Böschungswinkel) und Klang.
/// Die Tabelle [kMaterialien] ist ein gemeinsamer Wert und wird nur vom Orchestrator geändert.
library;

/// Wie ein Blockkörper aus diesem Material zerbricht (7.4).
enum Bruchmuster {
  /// Bricht nicht (Eisen, Messing).
  keins,

  /// Holz splittert entlang der Faser: längliche Splitter in Faserrichtung.
  faser,

  /// Glas springt in Scherben: flache, kantige Stücke.
  scherben,

  /// Stein bröckelt an den Kanten: kleine Brocken von Ecken und Kanten.
  kanten,

  /// Wachs krümelt: viele kleine, runde Krümel.
  kruemel,

  /// Schüttgut zerfällt in einzelne Körner (Staub, Ruß, Erde).
  koerner,

  /// Weiches Material reißt (Stoff, Papier, Leder).
  reissen,
}

/// Klangfamilie eines Aufpralls (7.4: „Messing scheppert, Holz poltert, Glas klirrt“).
enum Klang { keiner, scheppern, poltern, klirren, klacken, dumpf, rascheln, rieseln }

/// Ein Material. Farben als 0xRRGGBB (sRGB). Werte ohne Einheit liegen in 0..1.
class Material {
  const Material({
    required this.id,
    required this.name,
    required this.farbe,
    required this.streuung,
    required this.rauheit,
    this.leuchten = 0,
    required this.dichte,
    required this.haerte,
    required this.reibung,
    required this.bruch,
    required this.klang,
    this.boeschungGrad = 0,
    this.abprall = 0.2,
  });

  /// Index im Blockspeicher (1..255; 0 ist Luft).
  final int id;
  final String name;

  /// Grundfarbe 0xRRGGBB.
  final int farbe;

  /// Helligkeitsstreuung je Block (0 = einheitlich, 0,2 = ±10 %).
  final double streuung;

  /// Rauheit: 0 = glatt (Glanzkante), 1 = rau (keine Glanzkante, stärkere Fugen).
  final double rauheit;

  /// Eigenleuchten 0..1 (Flamme, Leuchtfarbe, Schild); ungedämpft vom Raumlicht.
  final double leuchten;

  /// Dichte in kg/m³.
  final double dichte;

  /// Härte 0..1: wie leicht der Körper beim Aufprall zerbricht (1 = nie).
  final double haerte;

  /// Reibungszahl (Gleiten auf anderem Material, gemittelt).
  final double reibung;
  final Bruchmuster bruch;
  final Klang klang;

  /// Böschungswinkel in Grad für Schüttgut (0 = kein Schüttgut).
  final double boeschungGrad;

  /// Rückprallzahl 0..1.
  final double abprall;

  int get rot => (farbe >> 16) & 0xFF;
  int get gruen => (farbe >> 8) & 0xFF;
  int get blau => farbe & 0xFF;
}

/// Luft (kein Block).
const kLuft = 0;

/// Materialbibliothek (7.6), Startwerte aus K0. Kennungen sind stabil (gespeicherte Modelle nutzen sie).
const List<Material> kMaterialien = [
  Material(id: 1, name: 'Sandstein', farbe: 0x9C8A6E, streuung: 0.16, rauheit: 0.9, dichte: 2300, haerte: 0.7,
      reibung: 0.7, bruch: Bruchmuster.kanten, klang: Klang.dumpf, abprall: 0.1),
  Material(id: 2, name: 'Kalkmörtel', farbe: 0x7D7464, streuung: 0.10, rauheit: 1.0, dichte: 1800, haerte: 0.4,
      reibung: 0.8, bruch: Bruchmuster.kanten, klang: Klang.dumpf, abprall: 0.05),
  Material(id: 3, name: 'Eiche', farbe: 0x6B4A2E, streuung: 0.12, rauheit: 0.6, dichte: 750, haerte: 0.55,
      reibung: 0.5, bruch: Bruchmuster.faser, klang: Klang.poltern, abprall: 0.25),
  Material(id: 4, name: 'Eisen', farbe: 0x3C3C40, streuung: 0.08, rauheit: 0.5, dichte: 7870, haerte: 1.0,
      reibung: 0.45, bruch: Bruchmuster.keins, klang: Klang.klacken, abprall: 0.3),
  Material(id: 5, name: 'Messing', farbe: 0xB08D3C, streuung: 0.06, rauheit: 0.2, dichte: 8500, haerte: 1.0,
      reibung: 0.35, bruch: Bruchmuster.keins, klang: Klang.scheppern, abprall: 0.35),
  Material(id: 6, name: 'Glas', farbe: 0x9DB8BE, streuung: 0.04, rauheit: 0.0, dichte: 2500, haerte: 0.15,
      reibung: 0.3, bruch: Bruchmuster.scherben, klang: Klang.klirren, abprall: 0.3),
  Material(id: 7, name: 'Wachs', farbe: 0xC23B2E, streuung: 0.06, rauheit: 0.3, dichte: 900, haerte: 0.2,
      reibung: 0.6, bruch: Bruchmuster.kruemel, klang: Klang.dumpf, boeschungGrad: 38, abprall: 0.05),
  Material(id: 8, name: 'Stoff', farbe: 0x5A5F6E, streuung: 0.10, rauheit: 1.0, dichte: 300, haerte: 0.9,
      reibung: 0.8, bruch: Bruchmuster.reissen, klang: Klang.rascheln, abprall: 0.05),
  Material(id: 9, name: 'Leder', farbe: 0x5B3A24, streuung: 0.08, rauheit: 0.7, dichte: 860, haerte: 0.9,
      reibung: 0.7, bruch: Bruchmuster.reissen, klang: Klang.dumpf, abprall: 0.1),
  Material(id: 10, name: 'Porzellan', farbe: 0xE6E2D8, streuung: 0.03, rauheit: 0.1, dichte: 2400, haerte: 0.2,
      reibung: 0.35, bruch: Bruchmuster.scherben, klang: Klang.klirren, abprall: 0.25),
  Material(id: 11, name: 'Papier', farbe: 0xD8CDB4, streuung: 0.05, rauheit: 0.9, dichte: 700, haerte: 0.95,
      reibung: 0.6, bruch: Bruchmuster.reissen, klang: Klang.rascheln, abprall: 0.02),
  Material(id: 12, name: 'Ruß', farbe: 0x1E1C1B, streuung: 0.10, rauheit: 1.0, dichte: 400, haerte: 0.0,
      reibung: 0.9, bruch: Bruchmuster.koerner, klang: Klang.rieseln, boeschungGrad: 42, abprall: 0.0),
  Material(id: 13, name: 'Staub', farbe: 0x8F8678, streuung: 0.10, rauheit: 1.0, dichte: 600, haerte: 0.0,
      reibung: 0.9, bruch: Bruchmuster.koerner, klang: Klang.rieseln, boeschungGrad: 40, abprall: 0.0),
  Material(id: 14, name: 'Erde', farbe: 0x4E3B2A, streuung: 0.14, rauheit: 1.0, dichte: 1500, haerte: 0.0,
      reibung: 0.9, bruch: Bruchmuster.koerner, klang: Klang.rieseln, boeschungGrad: 35, abprall: 0.0),
];

/// Material nach Kennung (0 = Luft → null).
Material? materialVon(int id) => id <= 0 || id > kMaterialien.length ? null : kMaterialien[id - 1];

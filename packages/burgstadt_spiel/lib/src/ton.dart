/// Tonausgabe (Klänge aus `assets/burgstadt/ton/<name>.wav`). Die App-Hülle
/// liefert die echte Ausgabe; Tests nutzen [MerkendeTonausgabe].
abstract class Tonausgabe {
  /// Einmaliger Klang.
  void spiele(String name, {double lautstaerke = 1});

  /// Schleife auf einem Kanal (`musik`, `umgebung`); `null` stoppt den Kanal.
  void schleife(String kanal, String? name, {double lautstaerke = 1});

  /// Gesamtlautstärke 0..1.
  void gesamt(double wert);
}

/// Merkt sich alle Aufrufe (für Tests und headless).
class MerkendeTonausgabe implements Tonausgabe {
  final List<String> gespielt = [];
  final Map<String, String?> kanaele = {};
  double lautstaerke = 1;

  @override
  void spiele(String name, {double lautstaerke = 1}) => gespielt.add(name);

  @override
  void schleife(String kanal, String? name, {double lautstaerke = 1}) => kanaele[kanal] = name;

  @override
  void gesamt(double wert) => lautstaerke = wert;
}

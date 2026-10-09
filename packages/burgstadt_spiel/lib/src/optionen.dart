import 'skalierung.dart';

/// Spieler-Optionen (Barrierefreiheit und Leistung).
class Optionen {
  Qualitaet qualitaet = Qualitaet.mittel;
  bool kopfwippen = true;
  bool flackernAus = false;
  /// Neigen zum Umsehen: vorgesehen, aber ohne Sensor-Anbindung (bräuchte eine neue
  /// Abhängigkeit) – nicht in den Optionen angeboten.
  bool neigen = false;
  double sichtfeldGrad = 62;
  double blickEmpfindlichkeit = 1.0;
  int lautstaerke = 8; // 0..10
  bool tutorial = true;

  Map<String, Object> zuJson() => {
        'qualitaet': qualitaet.name,
        'kopfwippen': kopfwippen,
        'flackernAus': flackernAus,
        'neigen': neigen,
        'sichtfeldGrad': sichtfeldGrad,
        'blickEmpfindlichkeit': blickEmpfindlichkeit,
        'lautstaerke': lautstaerke,
        'tutorial': tutorial,
      };

  void ausJson(Map<String, dynamic> j) {
    qualitaet = Qualitaet.ausName(j['qualitaet'] as String?) ?? qualitaet;
    kopfwippen = j['kopfwippen'] as bool? ?? kopfwippen;
    flackernAus = j['flackernAus'] as bool? ?? flackernAus;
    neigen = j['neigen'] as bool? ?? neigen;
    tutorial = j['tutorial'] as bool? ?? tutorial;
    sichtfeldGrad = (j['sichtfeldGrad'] as num?)?.toDouble() ?? sichtfeldGrad;
    blickEmpfindlichkeit = (j['blickEmpfindlichkeit'] as num?)?.toDouble() ?? blickEmpfindlichkeit;
    lautstaerke = (j['lautstaerke'] as num?)?.toInt() ?? lautstaerke;
  }
}

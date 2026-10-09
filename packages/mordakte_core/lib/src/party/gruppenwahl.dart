import 'kanon/kanon.dart';

/// Qualität des Bonus-Hinweises einer Runde (Master 7.8).
enum Qualitaet { wahr, neutral, falsch }

/// Gruppenwahl und Bonus-Hinweise (F-08, G-1, W-1).
class Gruppenwahl {
  final Kanon kanon;
  late final int _wahrFaktor, _wahrGegen, _neutralFaktor, _neutralGegen;

  Gruppenwahl(this.kanon) {
    final s = kanon.fall['schwellen'] as Map;
    _wahrFaktor = (s['wahr'] as Map)['faktor'] as int;
    _wahrGegen = (s['wahr'] as Map)['gegen'] as int;
    _neutralFaktor = (s['neutral'] as Map)['faktor'] as int;
    _neutralGegen = (s['neutral'] as Map)['gegen'] as int;
  }

  /// Ganzzahlige Wertung: wahr, wenn 5 × kooperativ ≥ 3 × Rollen; sonst
  /// neutral, wenn 5 × kooperativ ≥ 2 × Rollen; sonst falsche Fährte.
  Qualitaet qualitaet(int kooperativ, int rollen) {
    if (_wahrFaktor * kooperativ >= _wahrGegen * rollen) return Qualitaet.wahr;
    if (_neutralFaktor * kooperativ >= _neutralGegen * rollen) return Qualitaet.neutral;
    return Qualitaet.falsch;
  }

  /// Wirksame kooperative Stimmen: Sabotage der Täterrolle zählt 0 und hebt
  /// zusätzlich eine kooperative Stimme auf (netto −1, G-1).
  static int wirksam({required int kooperativ, required bool sabotage}) {
    final k = kooperativ - (sabotage ? 1 : 0);
    return k < 0 ? 0 : k;
  }

  /// Qualität aus einer Stimmabgabe: [kooperativ] zählt alle A-Stimmen ohne
  /// die Täterrolle; [taeterSabotiert] gibt an, ob die Täterrolle B wählt.
  Qualitaet auswerten({required int rollen, required int kooperativ, required bool taeterSabotiert}) =>
      qualitaet(wirksam(kooperativ: kooperativ + (taeterSabotiert ? 0 : 1), sabotage: taeterSabotiert), rollen);

  /// Sichtbar ist nur, ob die Gruppe zusammengehalten hat (E-024).
  static bool zusammengehalten(Qualitaet q) => q == Qualitaet.wahr;

  List<Map<String, Object?>> get wahlen => [for (final w in kanon.gruppenwahlJson['wahlen'] as List) (w as Map).cast<String, Object?>()];

  Map<String, Object?> wahl(String rolle, int runde) => wahlen.firstWhere((w) => w['rolle'] == rolle && w['runde'] == runde);

  List<Map<String, Object?>> get hinweise => [for (final h in kanon.bonusJson['hinweise'] as List) (h as Map).cast<String, Object?>()];

  Map<String, Object?> hinweis(String pfad, int runde, Qualitaet q) =>
      hinweise.firstWhere((h) => h['pfad'] == pfad && h['runde'] == runde && h['qualitaet'] == q.name);
}

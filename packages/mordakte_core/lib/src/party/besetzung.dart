import 'kanon/kanon.dart';

/// Besetzung für 4 bis 20 Rollen (Master 7.10, F-09): feste Reihenfolge,
/// Ersatzpartner für Gespräche, unbesetzte Gäste als NPC.
class Besetzung {
  final Kanon kanon;
  final List<String> reihenfolge;
  final Map<String, List<String>> ersatz;
  final int minRollen, maxRollen;

  Besetzung(this.kanon)
      : reihenfolge = [for (final r in kanon.besetzungJson['reihenfolge'] as List) r as String],
        ersatz = {
          for (final e in ((kanon.besetzungJson['ersatzpartner'] as Map?) ?? const {}).entries)
            e.key as String: [for (final r in e.value as List) r as String],
        },
        minRollen = kanon.besetzungJson['minRollen'] as int,
        maxRollen = kanon.besetzungJson['maxRollen'] as int;

  static const detektiv = 'detective';

  /// Besetzte Rollen bei [n] Rollen (ohne Geburtstagskind).
  List<String> besetzt(int n) {
    if (n < minRollen || n > maxRollen) throw RangeError.range(n, minRollen, maxRollen, 'Rollen');
    return reihenfolge.take(n).toList();
  }

  bool istBesetzt(String rolle, int n) => rolle == detektiv || besetzt(n).contains(rolle);

  /// Unbesetzte Gäste: NPC mit Karte (W1).
  List<String> npc(int n) => [for (final r in reihenfolge) if (!besetzt(n).contains(r)) r];

  /// Gesprächspartner für [wunsch] bei [n] Rollen: die Rolle selbst, sonst der
  /// erste besetzte Ersatz, der nicht [sprecher] ist, sonst der Detektiv.
  String partner(String wunsch, int n, {String? sprecher}) {
    if (istBesetzt(wunsch, n) && wunsch != sprecher) return wunsch;
    for (final e in ersatz[wunsch] ?? const <String>[]) {
      if (e != sprecher && istBesetzt(e, n)) return e;
    }
    return detektiv;
  }
}

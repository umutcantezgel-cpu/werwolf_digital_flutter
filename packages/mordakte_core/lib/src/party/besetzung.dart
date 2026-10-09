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
  /// Ohne Blick auf die Last; am Abend gilt [gespraechsplan].
  String partner(String wunsch, int n, {String? sprecher}) {
    if (istBesetzt(wunsch, n) && wunsch != sprecher) return wunsch;
    for (final e in ersatz[wunsch] ?? const <String>[]) {
      if (e != sprecher && istBesetzt(e, n)) return e;
    }
    return detektiv;
  }

  /// Höchstlast je Runde (V-19, E-028): Pflichtgespräche, an denen eine Person
  /// beteiligt ist, als Sprecher oder als Partner.
  static const lastRolle = 7, lastDetektiv = 6;

  static int grenze(String person) => person == detektiv ? lastDetektiv : lastRolle;

  int _platz(String p) => p == detektiv ? reihenfolge.length : reihenfolge.indexOf(p);

  /// Tatsächliche Partner aller Pflichtgespräche bei [n] Rollen (E-028):
  /// Kennung → Partner. Gespräche unbesetzter Rollen fallen weg.
  ///
  /// Ein besetzter Wunschpartner bleibt. Für einen fehlenden kommt der erste
  /// besetzte Ersatz mit freier Last, sonst die besetzte Person mit der
  /// kleinsten Last; neue Paare gehen vor Wiederholungen. Gleichstand
  /// entscheidet der Besetzungsplatz, der Detektiv steht zuletzt.
  Map<String, String> gespraechsplan(Iterable<GespraechsWunsch> wuensche, int n) {
    final personen = [...besetzt(n), detektiv];
    final plan = <String, String>{};
    for (final runde in {for (final w in wuensche) w.runde}.toList()..sort()) {
      final liste = [
        for (final w in wuensche)
          if (w.runde == runde && istBesetzt(w.rolle, n)) w,
      ]..sort((a, b) => _platz(a.rolle) != _platz(b.rolle) ? _platz(a.rolle) - _platz(b.rolle) : a.nr - b.nr);
      final last = {for (final p in personen) p: 0};
      final paare = <String>{};
      String paar(String a, String b) => a.compareTo(b) < 0 ? '$a|$b' : '$b|$a';
      void setze(GespraechsWunsch w, String p) {
        plan[w.id] = p;
        last[p] = last[p]! + 1;
        paare.add(paar(w.rolle, p));
      }

      for (final w in liste) {
        last[w.rolle] = last[w.rolle]! + 1;
      }
      final offen = <GespraechsWunsch>[];
      for (final w in liste) {
        if (w.partner != w.rolle && istBesetzt(w.partner, n)) {
          setze(w, w.partner);
        } else {
          offen.add(w);
        }
      }
      for (final w in offen) {
        bool frei(String p) => p != w.rolle && last[p]! < grenze(p);
        bool neu(String p) => !paare.contains(paar(w.rolle, p));
        final ersatzFrei = [
          for (final e in ersatz[w.partner] ?? const <String>[])
            if (istBesetzt(e, n) && frei(e) && neu(e)) e,
        ];
        String kleinste(Iterable<String> l) =>
            l.reduce((a, b) => last[a]! != last[b]! ? (last[a]! < last[b]! ? a : b) : (_platz(a) <= _platz(b) ? a : b));
        final freiNeu = personen.where((p) => frei(p) && neu(p));
        final freiAlt = personen.where(frei);
        setze(
          w,
          ersatzFrei.isNotEmpty
              ? ersatzFrei.first
              : freiNeu.isNotEmpty
                  ? kleinste(freiNeu)
                  : freiAlt.isNotEmpty
                      ? kleinste(freiAlt)
                      : kleinste(personen.where((p) => p != w.rolle)),
        );
      }
    }
    return plan;
  }

  /// Personen über der Höchstlast in [plan] bei [n] Rollen (leer heißt grün).
  List<String> lastVerstoesse(Iterable<GespraechsWunsch> wuensche, Map<String, String> plan, int n) {
    final f = <String>[];
    for (final runde in {for (final w in wuensche) w.runde}) {
      final last = <String, int>{};
      for (final w in wuensche) {
        final p = plan[w.id];
        if (w.runde != runde || p == null) continue;
        last[w.rolle] = (last[w.rolle] ?? 0) + 1;
        last[p] = (last[p] ?? 0) + 1;
      }
      for (final e in last.entries) {
        if (e.value > grenze(e.key)) f.add('$n Rollen, Runde $runde: ${e.key} hat ${e.value} Gespräche (höchstens ${grenze(e.key)})');
      }
    }
    return f;
  }
}

/// Ein Pflichtgespräch, wie es geschrieben ist: Sprecher, Runde, Nummer, Wunschpartner.
typedef GespraechsWunsch = ({String id, String rolle, int runde, int nr, String partner});

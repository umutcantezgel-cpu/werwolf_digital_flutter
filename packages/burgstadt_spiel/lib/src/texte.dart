/// Erzähler-Texte (Uhrturm, Ortsansagen, Ladesprüche) und Tutorial-Schritte aus
/// `data/texte/erzaehler.json` und `data/texte/tutorial.json`.
library;

class Erzaehler {
  final Map<String, List<String>> uhrturm, orte;
  final List<String> laden;
  const Erzaehler(this.uhrturm, this.orte, this.laden);

  static Map<String, List<String>> _listen(Object? j) => {
        for (final e in ((j as Map?) ?? const {}).entries) e.key as String: [for (final t in e.value as List) t as String],
      };

  factory Erzaehler.ausJson(Map<String, dynamic> j) =>
      Erzaehler(_listen(j['uhrturm']), _listen(j['orte']), [for (final t in (j['laden'] as List?) ?? const []) t as String]);

  static String? _waehle(List<String>? l, int n) => l == null || l.isEmpty ? null : l[n % l.length];

  /// Uhrturm-Text für `einfuehrung`, `phase1` … `phase3`, `morgengrauen`.
  String? uhr(String abschnitt, int n) => _waehle(uhrturm[abschnitt], n);

  /// Ortsansage für einen Bereich (Bereichs-ID oder Fall-Ort `ORT-nn`).
  String? ort(String schluessel, int n) => _waehle(orte[schluessel], n);
}

class TutorialSchritt {
  final String id, ausloeser, titel, text;
  final Map<String, String> eingabe;
  const TutorialSchritt(this.id, this.ausloeser, this.titel, this.text, this.eingabe);

  factory TutorialSchritt.ausJson(Map<String, dynamic> j) => TutorialSchritt(
        j['id'] as String,
        j['ausloeser'] as String,
        j['titel'] as String,
        j['text'] as String,
        {for (final e in ((j['eingabe'] as Map?) ?? const {}).entries) e.key as String: e.value as String},
      );
}

/// Zeigt jeden Tutorial-Schritt einmal, wenn sein Auslöser zum ersten Mal eintritt.
class Tutorial {
  final List<TutorialSchritt> schritte;
  final Set<String> gezeigt = {};
  final List<TutorialSchritt> _warteschlange = [];
  TutorialSchritt? aktuell;
  double _zeit = 0;

  Tutorial(this.schritte);

  factory Tutorial.ausJson(Map<String, dynamic> j) =>
      Tutorial([for (final s in j['schritte'] as List) TutorialSchritt.ausJson(s as Map<String, dynamic>)]);

  /// Auslöser eingetreten (z. B. `licht`, `erste_figur`); [an] = Option „Tutorial“.
  void ausloesen(String ausloeser, {bool an = true}) {
    if (!an || !gezeigt.add(ausloeser)) return;
    final s = schritte.where((s) => s.ausloeser == ausloeser).firstOrNull;
    if (s != null) _warteschlange.add(s);
  }

  /// Weiterzählen; jede Karte bleibt [dauer] Sekunden.
  void tick(double dt, {double dauer = 7}) {
    _zeit -= dt;
    if (aktuell != null && _zeit > 0) return;
    aktuell = _warteschlange.isEmpty ? null : _warteschlange.removeAt(0);
    if (aktuell != null) _zeit = dauer;
  }

  /// Aktuelle Karte wegklicken.
  void weiter() => _zeit = 0;
}

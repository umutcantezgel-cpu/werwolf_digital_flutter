/// Neutrale Ansichtsmodelle des Begleiters: Ein Renderer bedient Bildschirm und Druck.
library;

/// Wie ein [Eintrag] dargestellt wird.
enum EintragArt {
  /// Fließtext, optional mit Label darüber.
  absatz,

  /// Listenpunkt; ein Label steht davor (etwa eine Uhrzeit).
  punkt,

  /// Spielhinweis (etwa „Sag die Wahrheit.“), hervorgehoben.
  hinweis,

  /// Zwischenüberschrift innerhalb eines Abschnitts.
  zwischentitel,
}

/// Eine Zeile einer Ansicht: optional ein Label, dazu der Text.
class Eintrag {
  const Eintrag(
    this.text, {
    this.label,
    this.art = EintragArt.absatz,
    this.block = false,
  });

  /// Kurze Überschrift oder Vorspann (Bedientext oder Feldname), nie Kanonprosa.
  final String? label;

  /// Der Text (aus dem Kanon wörtlich oder gekürzt, oder ein Bedientext).
  final String text;

  final EintragArt art;

  /// Beginnt einen neuen Block (etwa ein neues Gespräch): mehr Abstand davor.
  final bool block;

  @override
  String toString() => label == null ? text : '$label: $text';
}

/// Ein Abschnitt: Titel, optional Kopf (Initiale, Untertitel, Kopfzeile) und Einträge.
///
/// Dasselbe Modell trägt Überblicksabschnitte, Steckbriefkarten, Besetzungszeilen
/// und die Abschnitte einer Mappe.
class Abschnitt {
  const Abschnitt({
    required this.titel,
    this.eintraege = const [],
    this.untertitel,
    this.kopfzeile,
    this.initiale,
    this.aufklappbar = false,
    this.neueSeite = false,
    this.schluessel,
  });

  final String titel;
  final List<Eintrag> eintraege;

  /// Zweite Kopfzeile, etwa die Aussprache eines Namens.
  final String? untertitel;

  /// Kurze Kopfzeile unter dem Titel, etwa „33 Jahre · bosnisch · Beruf“.
  final String? kopfzeile;

  /// Buchstabe für das runde Namensschild einer Karte.
  final String? initiale;

  /// Auf dem Bildschirm zunächst zugeklappt.
  final bool aufklappbar;

  /// Im Druck beginnt der Abschnitt auf einer neuen Seite.
  final bool neueSeite;

  /// Interne Zuordnung (etwa `R01`, `DET`, `BW` oder `P1`); wird nie angezeigt.
  final String? schluessel;

  /// Alle sichtbaren Texte (für Tests und Suche).
  Iterable<String> get texte sync* {
    yield titel;
    if (untertitel != null) yield untertitel!;
    if (kopfzeile != null) yield kopfzeile!;
    if (initiale != null) yield initiale!;
    for (final e in eintraege) {
      if (e.label != null) yield e.label!;
      yield e.text;
    }
  }
}

/// Eine Rollenmappe: für wen sie ist und was darin steht.
class Mappe {
  const Mappe({
    required this.schluessel,
    required this.nummer,
    required this.name,
    required this.anrede,
    required this.abschnitte,
  });

  /// `R01` … `R20` oder `DET`.
  final String schluessel;

  /// Laufende Nummer für Dateinamen: 1 … 20, das Geburtstagskind hat 0.
  final int nummer;

  /// Voller Name der Rolle oder „das Geburtstagskind“.
  final String name;

  /// Kurzer Name für die Ansprache beim Weitergeben (Vorname oder „das Geburtstagskind“).
  final String anrede;

  final List<Abschnitt> abschnitte;

  /// Alle sichtbaren Texte (für Tests und Suche).
  Iterable<String> get texte sync* {
    for (final a in abschnitte) {
      yield* a.texte;
    }
  }
}

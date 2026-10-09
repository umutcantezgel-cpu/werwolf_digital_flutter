import '../util/rng.dart';
import 'besetzung.dart';
import 'enden.dart';
import 'entscheidungen.dart';
import 'erzaehler.dart';
import 'fall_code.dart';
import 'gruppenwahl.dart';
import 'kanon/kanon.dart';

/// Abschnitte eines Partyabends (Master 7.6).
enum PartyPhase { titel, einrichtung, rollen, intro, gespraeche, entscheidungen, gruppenwahl, bonus, resuemee, anklage, finale, aufloesung, ende }

/// Einstellungen der Einrichtung (Master 7.6, Schritt 2).
class Einstellungen {
  final int rollen;
  final String detektiv;
  final FallCode code;
  final bool druck;
  final int rundendauerMinuten;
  const Einstellungen({required this.rollen, required this.detektiv, required this.code, this.druck = false, this.rundendauerMinuten = 30});
}

/// Der Spielablauf als reiner Zustandsautomat. Alle Story-Texte kommen als
/// Baustein-Kennungen aus dem Erzähler; nichts wird erzeugt (Master 7.12).
class Spiel {
  final Kanon kanon;
  final Ermittlung ermittlung;
  final Gruppenwahl gruppe;
  final Enden enden;
  final Besetzung besetzung;
  final Erzaehler erzaehler;

  PartyPhase phase = PartyPhase.titel;
  Einstellungen? _einstellungen;
  String? _pfad;
  int runde = 0;
  final Map<String, String> gewaehlt = {};
  final Map<int, Qualitaet> qualitaeten = {};
  String? angeklagt;

  /// Alle bisher ausgegebenen Bausteine in Reihenfolge.
  final List<String> bausteine = [];

  Spiel(this.kanon, {Ermittlung? ermittlung})
      : ermittlung = ermittlung ?? Ermittlung(kanon),
        gruppe = Gruppenwahl(kanon),
        enden = Enden(kanon),
        besetzung = Besetzung(kanon),
        erzaehler = Erzaehler(kanon);

  Einstellungen get einstellungen => _einstellungen ?? (throw StateError('Spiel ist noch nicht eingerichtet'));

  /// Aktiver Täter-Pfad (nur für App-Logik; nie anzeigen vor dem Finale).
  String get pfad => _pfad ?? (throw StateError('Spiel ist noch nicht eingerichtet'));

  List<String> get besetzt => besetzung.besetzt(einstellungen.rollen);

  void _erwarte(PartyPhase p) {
    if (phase != p) throw StateError('erwartet $p, ist $phase');
  }

  /// Einrichtung abschließen: Fall-Code legt den Pfad fest.
  void einrichten(Einstellungen e) {
    if (phase == PartyPhase.titel) phase = PartyPhase.einrichtung;
    _erwarte(PartyPhase.einrichtung);
    besetzung.besetzt(e.rollen);
    if (e.detektiv != 'm' && e.detektiv != 'w') throw ArgumentError('Detektiv m oder w');
    _einstellungen = e;
    _pfad = e.code.pfad(kanon.pfade);
    phase = PartyPhase.rollen;
  }

  /// Zum nächsten Abschnitt, sobald der aktuelle erledigt ist.
  void weiter() {
    switch (phase) {
      case PartyPhase.titel:
        phase = PartyPhase.einrichtung;
      case PartyPhase.einrichtung:
        throw StateError('Einrichtung über einrichten() abschließen');
      case PartyPhase.rollen:
        phase = PartyPhase.intro;
        bausteine.addAll(erzaehler.intro(this));
      case PartyPhase.intro:
        runde = 1;
        phase = PartyPhase.gespraeche;
        bausteine.addAll(erzaehler.rundenStart(runde));
      case PartyPhase.gespraeche:
        phase = PartyPhase.entscheidungen;
      case PartyPhase.entscheidungen:
        final offen = [for (final e in ermittlung.runde(runde)) if (!gewaehlt.containsKey(e.id)) e.id];
        if (offen.isNotEmpty) throw StateError('offene Entscheidungen: $offen');
        phase = PartyPhase.gruppenwahl;
      case PartyPhase.gruppenwahl:
        if (!qualitaeten.containsKey(runde)) throw StateError('Gruppenwahl fehlt');
        phase = PartyPhase.bonus;
        bausteine.addAll(erzaehler.bonus(this));
      case PartyPhase.bonus:
        phase = PartyPhase.resuemee;
        bausteine.addAll(erzaehler.resuemee(this));
      case PartyPhase.resuemee:
        if (runde < 3) {
          runde++;
          phase = PartyPhase.gespraeche;
          bausteine.addAll(erzaehler.rundenStart(runde));
        } else {
          phase = PartyPhase.anklage;
          bausteine.addAll(erzaehler.anklage());
        }
      case PartyPhase.anklage:
        if (angeklagt == null) throw StateError('Anklage fehlt');
        phase = PartyPhase.finale;
        bausteine.addAll(erzaehler.finale(this));
      case PartyPhase.finale:
        phase = PartyPhase.aufloesung;
        bausteine.addAll(erzaehler.aufloesung(this));
      case PartyPhase.aufloesung:
        phase = PartyPhase.ende;
      case PartyPhase.ende:
        throw StateError('Spiel ist zu Ende');
    }
  }

  /// Anzeigereihenfolge der Optionen: je Fall-Code gemischt, damit die Lage
  /// im Kanon nichts verrät (E-025). Gleicher Code, gleiche Reihenfolge.
  List<EntscheidungsOption> optionen(String entscheidungId) {
    final e = ermittlung.entscheidung(entscheidungId);
    final liste = [...e.optionen];
    Rng(einstellungen.code.seed ^ Rng.hashString(entscheidungId)).shuffle(liste);
    return liste;
  }

  /// Eine Entscheidung der laufenden Runde treffen.
  List<Aufdeckung> waehle(String entscheidungId, String optionId) {
    _erwarte(PartyPhase.entscheidungen);
    final e = ermittlung.entscheidung(entscheidungId);
    if (e.runde != runde) throw StateError('$entscheidungId gehört zu Runde ${e.runde}');
    if (gewaehlt.containsKey(entscheidungId)) throw StateError('$entscheidungId ist schon entschieden');
    e.option(optionId);
    gewaehlt[entscheidungId] = optionId;
    return ermittlung.aufdecken(optionId, pfad);
  }

  /// Gruppenwahl der laufenden Runde: [kooperativ] zählt die A-Stimmen ohne
  /// die Täterrolle. Die Zahl wird nie angezeigt.
  Qualitaet abstimmen({required int kooperativ, required bool taeterSabotiert}) {
    _erwarte(PartyPhase.gruppenwahl);
    final andere = einstellungen.rollen - 1;
    if (kooperativ < 0 || kooperativ > andere) throw RangeError.range(kooperativ, 0, andere, 'kooperativ');
    return qualitaeten[runde] = gruppe.auswerten(rollen: einstellungen.rollen, kooperativ: kooperativ, taeterSabotiert: taeterSabotiert);
  }

  void anklagen(String person) {
    _erwarte(PartyPhase.anklage);
    if (!kanon.kernverdaechtige.contains(person)) throw ArgumentError('Anklage nur gegen Kernverdächtige');
    angeklagt = person;
  }

  /// Fakten, die der Detektiv bis einschließlich Runde [bis] aufgedeckt hat.
  Set<String> bekannteFakten([int bis = 3]) => {
        for (final e in gewaehlt.entries)
          if (ermittlung.entscheidung(e.key).runde <= bis) ...ermittlung.faktenVon(e.value, pfad),
      };

  Set<String> restmenge([int bis = 3]) => ermittlung.restmenge(bekannteFakten(bis));

  int get punkte => [for (final e in gewaehlt.entries) if (ermittlung.istRichtig(e.key, e.value, pfad)) e].length;

  EndeRegel get ende => enden.ende(punkte, angeklagt == pfad);
}

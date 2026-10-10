import '../party/entscheidungen.dart';
import '../party/simulator.dart';
import 'wuerfel.dart';

/// Kosten und Grenzen der Zugschicht in Nachtminuten (K-01, K-11, K-12; Satz 6 des Meta-Simulators).
class ZugParameter {
  final int rundenzeit;
  final int pflicht;
  final int zweit;
  final int dritt;
  final int umweg;
  final int gruendlich;
  final int erfolgGewinn;
  final int abstecher;
  final int abstecherPechZeit;
  final int markenMax;

  const ZugParameter({
    this.rundenzeit = 45,
    this.pflicht = 6,
    this.zweit = 3,
    this.dritt = 3,
    this.umweg = 3,
    this.gruendlich = 2,
    this.erfolgGewinn = 7,
    this.abstecher = 7,
    this.abstecherPechZeit = 3,
    this.markenMax = 3,
  });

  /// Schlechteste Kosten eines Pflichtzugs: 6 + 2 + 3 + 3 = 14 (K-11).
  int get schlechtesterPflichtzug => pflicht + gruendlich + 2 * umweg;

  /// Budget-Ungleichung je Runde (C2): 3 × 14 ≤ 45.
  bool budgetUngleichung(int pflichtzuegeJeRunde) => pflichtzuegeJeRunde * schlechtesterPflichtzug <= rundenzeit;
}

/// Kettensperre auf Entscheidungsebene (C2, K-13): Vorgänger je Pflichtentscheidung.
const Map<String, List<String>> kettensperre = {
  'e2_1': ['e1_1', 'e1_2', 'e1_3'],
  'e2_2': ['e1_2'],
  'e2_3': ['e1_3'],
  'e3_1': ['e1_1', 'e1_2', 'e1_3', 'e2_1', 'e2_2', 'e2_3'],
  'e3_2': ['e2_1', 'e2_2', 'e2_3'],
  'e3_3': ['e1_1', 'e2_1'],
};

/// Tischruf nach Pech (K-10): Nochmal oder Umweg zur selben Kanon-Quelle.
enum Tischruf { nochmal, umweg }

/// Würfelt eine Pflichtentscheidung? Ja, sobald eine Option einen Gegenstand,
/// Raum oder Ort zum Ziel hat (K-05); dann für alle Optionen. Befragen nie.
bool istSuche(Entscheidung e) =>
    e.optionen.any((o) => o.ziel.keys.any((k) => k == 'gegenstand' || k == 'raum' || k == 'ort'));

/// Zustand einer laufenden Untersuchung (Pflichtzug mit Wurf).
class _Untersuchung {
  final String id;
  final String option;
  final bool gruendlich;
  int anlauf = 1;
  int pechFolge = 0;
  bool wartetAufTischruf = false;
  _Untersuchung(this.id, this.option, this.gruendlich);
}

/// Die Zugschicht „Würfel stark“ über dem Kanon 1.0 (A-4, WÜ-1…6).
///
/// Wahl vor Wurf: Die Option steht fest, bevor gewürfelt wird; der Würfel ändert
/// nur, wann das Wissen kommt, was es kostet und was dazukommt – nie die Wahl,
/// die Fakten oder die Wertung (WÜ-4). `gewaehlt` und `aufgedeckt` sind getrennt.
class Zugschicht {
  final Ermittlung ermittlung;
  final WuerfelQuelle quelle;
  final ZugParameter p;

  /// Gewählte Option je Pflichtentscheidung (ein `Spiel.waehle` je Entscheidung).
  final Map<String, String> gewaehlt = {};

  /// Pflichtentscheidungen, deren Anlauf abgeschlossen ist.
  final Set<String> aufgedeckt = {};

  /// Fakten-Ids, die der Detektiv kennt, in der Reihenfolge des Aufdeckens.
  final Set<String> fakten = {};

  /// Faktenstand beim Öffnen jeder Pflichtentscheidung (K-14).
  final Map<String, Set<String>> standBeimOeffnen = {};

  final List<Wurf> wuerfe = [];
  final List<String> ereignisse = [];

  int runde = 0;
  int rest = 0;
  List<String> offen = [];

  /// Verbrauchte Seifenblasen-Marken der Partie (höchstens [ZugParameter.markenMax]).
  int marken = 0;
  int kettenverletzungen = 0;
  int budgetUeber = 0;
  int pechSzenen = 0;
  int erfolgeMitZusatz = 0;
  int maxPechFolge = 0;
  _Untersuchung? _lauf;
  String? _pfad;

  Zugschicht(this.ermittlung, this.quelle, {this.p = const ZugParameter()});

  /// Pfad nur für die Fakten der Kanon-Engine; der Würfel sieht ihn nie.
  void setzePfad(String pfad) => _pfad = pfad;

  Entscheidung _e(String id) => ermittlung.entscheidung(id);

  /// Schlechteste Kosten aller offenen Pflichtzüge (Reserve-Regel, K-12).
  int get reserveBedarf => offen.length * p.schlechtesterPflichtzug;

  void beginneRunde(int r) {
    if (_lauf != null) throw StateError('Untersuchung ${_lauf!.id} läuft noch');
    runde = r;
    rest = p.rundenzeit;
    offen = [for (final e in ermittlung.runde(r)) e.id];
    ereignisse.add('runde:$r');
  }

  /// Auftakt-Suche in Runde 1 (nichtwertend, 0 Nachtminuten, K-03): ein Wurf ohne Modifikator.
  Wurf auftakt() {
    final w = Wurf.werfen(quelle, 'auftakt', 1, 0, garantie: false);
    wuerfe.add(w);
    if (w.stufe == Stufe.pech) {
      pechSzenen++;
      marken = marken + 1 > p.markenMax ? p.markenMax : marken + 1;
    }
    if (w.stufe == Stufe.erfolg) erfolgeMitZusatz++;
    ereignisse.add('auftakt:${w.stufe.kurz}');
    return w;
  }

  /// Darf jetzt ein Abstecher beginnen? Nur, wenn danach Restzeit − Pech-Zuschlag
  /// die schlechtesten Kosten aller offenen Pflichtzüge deckt (K-12).
  bool abstecherErlaubt() => _lauf == null && rest - p.abstecher - p.abstecherPechZeit >= reserveBedarf;

  /// Darf eine Seifenblasen-Marke eingesetzt werden?
  bool get markeVerfuegbar => marken < p.markenMax;

  /// Ein Abstecher (nichtwertend, nie `fakt:`-Glieder). Ohne [mitWurf] Rückgabe null.
  Wurf? abstecher(String id, {bool mitWurf = false, bool werkzeug = false, bool gruendlich = false, bool marke = false}) {
    if (!abstecherErlaubt()) throw StateError('Reserve-Regel sperrt Abstecher $id');
    rest -= p.abstecher;
    if (!mitWurf) {
      ereignisse.add('$id:-');
      return null;
    }
    final w = _werfen(id, 1, werkzeug: werkzeug, gruendlich: gruendlich, marke: marke, garantie: false);
    if (w.stufe == Stufe.pech) {
      pechSzenen++;
      rest -= p.abstecherPechZeit;
    }
    if (w.stufe == Stufe.erfolg) {
      erfolgeMitZusatz++;
      rest += p.erfolgGewinn;
    }
    ereignisse.add('$id:${w.stufe.kurz}');
    return w;
  }

  Wurf _werfen(String id, int anlauf, {required bool werkzeug, required bool gruendlich, required bool marke, required bool garantie}) {
    final m = marke && markeVerfuegbar;
    if (m) marken++;
    final mod = WuerfelRegel.modifikator(werkzeug: werkzeug, gruendlich: gruendlich, marke: m);
    final w = Wurf.werfen(quelle, id, anlauf, mod, garantie: garantie);
    wuerfe.add(w);
    return w;
  }

  /// Öffnet die nächste Pflichtentscheidung der Runde in Kanon-Reihenfolge und
  /// wählt endgültig [option] (Wahl vor Wurf). Gibt zurück, ob gewürfelt wird.
  bool waehle(String option, {bool gruendlich = false}) {
    if (_lauf != null) throw StateError('Untersuchung ${_lauf!.id} läuft noch');
    final id = offen.removeAt(0);
    final e = _e(id);
    e.option(option); // wirft bei fremder Option
    standBeimOeffnen[id] = Set.of(fakten);
    for (final v in kettensperre[id] ?? const <String>[]) {
      if (!aufgedeckt.contains(v)) kettenverletzungen++;
    }
    gewaehlt[id] = option;
    rest -= p.pflicht + (gruendlich ? p.gruendlich : 0);
    if (!istSuche(e)) {
      _decke(id);
      ereignisse.add('$option:B');
      return false;
    }
    _lauf = _Untersuchung(id, option, gruendlich);
    return true;
  }

  /// Nächster Anlauf der laufenden Untersuchung. Pech-Garantie: ab dem dritten
  /// Anlauf oder nach zwei Pech in Folge mindestens Teilerfolg (K-10).
  Wurf anlauf({bool werkzeug = false, bool marke = false}) {
    final u = _lauf ?? (throw StateError('keine Untersuchung offen'));
    if (u.wartetAufTischruf) throw StateError('Tischruf fehlt');
    final w = _werfen(u.id, u.anlauf,
        werkzeug: werkzeug, gruendlich: u.gruendlich, marke: marke, garantie: u.anlauf >= 3 || u.pechFolge >= 2);
    ereignisse.add('${u.option}:${u.anlauf}${w.stufe.kurz}');
    switch (w.stufe) {
      case Stufe.pech:
        pechSzenen++;
        u.pechFolge++;
        if (u.pechFolge > maxPechFolge) maxPechFolge = u.pechFolge;
        u.wartetAufTischruf = true;
      case Stufe.erfolg:
        erfolgeMitZusatz++;
        rest += p.erfolgGewinn;
        _decke(u.id);
        _lauf = null;
      case Stufe.teilerfolg:
        _decke(u.id);
        _lauf = null;
    }
    return w;
  }

  /// Tischruf nach Pech. Reicht die Restzeit nicht (Rundenschranke), gilt die
  /// Untersuchung als Teilerfolg; Rückgabe dann `false`.
  bool tischruf(Tischruf ruf) {
    final u = _lauf ?? (throw StateError('keine Untersuchung offen'));
    if (!u.wartetAufTischruf) throw StateError('kein Pech offen');
    u.anlauf++;
    final zusatz = ruf == Tischruf.umweg ? p.umweg : (u.anlauf == 2 ? p.zweit : p.dritt);
    u.wartetAufTischruf = false;
    if (rest - zusatz < 0) {
      _decke(u.id);
      _lauf = null;
      ereignisse.add('${u.option}:schranke');
      return false;
    }
    rest -= zusatz;
    return true;
  }

  bool get untersuchungOffen => _lauf != null;
  bool get wartetAufTischruf => _lauf?.wartetAufTischruf ?? false;

  void _decke(String id) {
    aufgedeckt.add(id);
    final pf = _pfad;
    if (pf != null) fakten.addAll(ermittlung.faktenVon(gewaehlt[id]!, pf));
  }

  void beendeRunde() {
    if (_lauf != null || offen.isNotEmpty) throw StateError('Runde $runde nicht fertig');
    if (rest < 0) budgetUeber++;
  }

  /// Gewählte Optionen in Kanon-Reihenfolge (für die echte Wertung).
  List<String> get optionsfolge => [for (final e in ermittlung.entscheidungen) gewaehlt[e.id]!];

  /// Wertung nur aus der Wahl, über die Kanon-Engine (WÜ-4, Z-04).
  Verlauf wertung(Simulator sim, String pfad) => sim.verlauf(pfad, optionsfolge);

  /// Kanonisches Würfelprotokoll (WÜ-6).
  String get protokoll => wuerfe.map((w) => w.zeile).join(';');
}

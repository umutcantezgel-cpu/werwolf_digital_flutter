/// Fairness-Löser für „Burgstadt Schartenfels“ (Auftrag A-404a).
///
/// Prüft für eine Besetzung mit [n] Rollen, ob jeder notwendige Schluss S-1…S-7 mit
/// erreichbaren Hinweisen abgesichert ist. Die Regeln entsprechen der Probe
/// `absicherung` in `krimidinner/spuk-im-gewoelbe/90_werkzeug/kanon.py`; die
/// Zeilenangaben in den Befundregeln unten beziehen sich auf diese Datei.
///
/// Übernommene Regeln aus kanon.py:
/// - Erreichbarkeit (`verfuegbar`, Zeilen 169–182): Hat der Hinweis eine Gesprächsquelle,
///   entscheidet `FallDaten.imSpiel` (Gespräch mit Ziel bzw. Ersatzziel, Zeilen 171–180).
///   Sonst gilt Min (Zeilen 181–182).
/// - Unblockierbar (Zeile 198): Der HW-Datensatz hat „Blockierbar durch: nein …“.
/// - Mindestens ein unblockierbarer Hinweis je Schluss (Zeilen 199–200).
/// - Unabhängige Quellen (Zeile 204): verschiedene Quelltexte, Leerraum normalisiert.
/// - Soll (Zeile 205): 2 Quellen, bei N = 20 3 Quellen.
///
/// Zusätzlich aus dem Auftrag und als Verschärfung gegenüber kanon.py:
/// - Eine Station muss in der Welt existieren (`legende.station` eines Dings). Die
///   Station `BW` ist der Burgwart; er ist in jeder Besetzung in der Burg.
/// - Eine Quelle ohne Gespräch, Station, Erzähler, Meldekarte oder Detektiv-Mappe
///   gilt als nicht zuzuordnen und ist ein Befund.
/// - Je N muss mindestens ein unblockierbarer Hinweis erreichbar sein, nicht nur
///   irgendwo im Kanon (die N-Fassung der Zeilen 199–200).
/// - Unabhängige Orte: Hinweise, die am selben Ort entstehen (dieselbe Station oder
///   dasselbe Gespräch), zählen nur einmal. kanon.py zählt Quelltexte (Zeile 204); so
///   stammen z. B. H-01 und H-02 beide von der Station BS-11 und zählen dort doppelt.
///   Die Orts-Regel nimmt diesen Fall auf. Sie hat denselben Soll-Wert.
library;

import '../welt/bereich.dart';
import 'fall_daten.dart';

const _burgwart = 'BW';

/// Ein notwendiger Schluss bei einer Besetzung.
class SchlussPruefung {
  SchlussPruefung(this.schluss, this.zaehlend, this.quellen, this.orte, this.unblockierbar, this.soll);

  final String schluss;

  /// Kennungen der bei dieser Besetzung erreichbaren Hinweise, in Kanon-Reihenfolge.
  final List<String> zaehlend;

  /// Zahl unabhängiger Quellen (verschiedene Quelltexte, Regel kanon.py Zeile 204).
  final int quellen;

  /// Zahl unabhängiger Orte (Gespräch oder Station je einmal, Zusatzregel).
  final int orte;

  /// Zahl erreichbarer unblockierbarer Hinweise.
  final int unblockierbar;

  /// Mindestzahl unabhängiger Quellen bei dieser Besetzung.
  final int soll;
}

/// Ergebnis der Prüfung einer Besetzung.
class FairnessBericht {
  FairnessBericht(this.n, this.schluesse, this.befunde);

  final int n;

  /// Je notwendigem Schluss, in der Reihenfolge S-1…S-7.
  final Map<String, SchlussPruefung> schluesse;

  /// Befundtexte. Leer heißt: abgesichert.
  final List<String> befunde;

  bool get ok => befunde.isEmpty;

  /// Anzahl zählender Hinweise eines Schlusses (0, wenn der Schluss unbekannt ist).
  int zaehlend(String schluss) => schluesse[schluss]?.zaehlend.length ?? 0;
}

/// Prüft die Absicherung aller notwendigen Schlüsse bei [n] Rollen.
///
/// [welt] ist die Welt wie von `baueWelt(innen, haeuser: …)` gebaut; ihre Stationen
/// bestimmen, ob ein Stations-Hinweis existiert.
FairnessBericht pruefeFairness(FallDaten d, Map<String, Bereich> welt, int n) {
  final stationen = _weltStationen(welt);
  final befunde = <String>[];
  final schluesse = <String, SchlussPruefung>{};
  final notwendig = d.notwendig.toList()..sort((a, b) => _schlussNummer(a).compareTo(_schlussNummer(b)));
  final soll = n == 20 ? 3 : 2;

  for (final s in notwendig) {
    final ids = (d.schluesse[s] ?? const <String>{}).toList()
      ..sort((a, b) => Hinweis.reihenfolge(a).compareTo(Hinweis.reihenfolge(b)));
    final hs = <Hinweis>[];
    for (final id in ids) {
      final h = d.hinweise[id];
      if (h == null) {
        befunde.add('$s: Hinweis $id fehlt im Kanon');
        continue;
      }
      hs.add(h);
    }

    // Zeile 199–200 in kanon.py: je Schluss mindestens ein unblockierbarer Hinweis.
    final gibtUnblockierbare = hs.any((h) => _unblockierbar(d, h));
    if (!gibtUnblockierbare) befunde.add('ABSICHERUNG $s: kein unblockierbarer Hinweis');

    final da = [for (final h in hs) if (_erreichbar(d, stationen, h, n, befunde, s)) h];
    // Zeile 204: unabhängige Quellen sind verschiedene Quelltexte.
    final quellen = {for (final h in da) h.quelle.replaceAll(_leerraum, ' ')};
    // Zusatz (Verschärfung): unabhängige Orte. Station oder Gespräch zählen je einmal.
    final orte = {for (final h in da) _ort(d, h)};
    final ub = da.where((h) => _unblockierbar(d, h)).length;
    if (quellen.length < soll) {
      befunde.add('ABSICHERUNG $s N=$n: ${quellen.length} unabhängige Quellen (Soll $soll)');
    }
    if (orte.length < soll) {
      befunde.add('ABSICHERUNG $s N=$n: ${orte.length} unabhängige Orte (Soll $soll)');
    }
    if (gibtUnblockierbare && ub == 0) {
      befunde.add('ABSICHERUNG $s N=$n: kein unblockierbarer Hinweis erreichbar');
    }
    schluesse[s] = SchlussPruefung(s, [for (final h in da) h.id], quellen.length, orte.length, ub, soll);
  }
  return FairnessBericht(n, schluesse, befunde);
}

/// Ist [h] bei [n] Rollen erreichbar? Ergänzt `imSpiel` um die Welt-Prüfung.
bool _erreichbar(FallDaten d, Set<String> stationen, Hinweis h, int n, List<String> befunde, String schluss) {
  final g = h.gespraech;
  if (g != null && d.gespraeche.containsKey(g)) return d.imSpiel(h, n);
  final st = h.station;
  if (st != null) {
    if (st == _burgwart) return h.min <= n;
    if (!stationen.contains(st)) {
      befunde.add('$schluss: Station $st für ${h.id} fehlt in der Welt');
      return false;
    }
    return h.min <= n;
  }
  if (h.erzaehler || h.meldekarte || h.detektivMappe) return h.min <= n;
  befunde.add('$schluss: Quelle von ${h.id} ist nicht zuzuordnen („${h.quelle}“)');
  return false;
}

/// Ort eines Hinweises für die Orts-Regel: das Gespräch, die Station, sonst der Quelltext
/// (Erzähler, Meldekarte, Detektiv-Mappe sind je eigene Quelle).
String _ort(FallDaten d, Hinweis h) {
  final g = h.gespraech;
  if (g != null && d.gespraeche.containsKey(g)) return 'Gespräch $g';
  if (h.station != null) return 'Station ${h.station}';
  return h.quelle.replaceAll(_leerraum, ' ');
}

/// Zeile 198 in kanon.py: Der HW-Datensatz nennt „nein“ bei „Blockierbar durch“.
bool _unblockierbar(FallDaten d, Hinweis h) {
  final hw = d.kanon.datensaetze['HW-${h.id.substring(2)}'];
  return hw != null && (hw.feld('Blockierbar durch') ?? '').toLowerCase().startsWith('nein');
}

/// Alle Stationen-Kennungen, die mindestens ein Ding der Welt trägt.
Set<String> _weltStationen(Map<String, Bereich> welt) => {
      for (final b in welt.values)
        for (final ding in b.dinge)
          if (ding.legende.station != null) ding.legende.station!,
    };

int _schlussNummer(String s) => int.tryParse(s.substring(2)) ?? 0;

final _leerraum = RegExp(r'\s+');

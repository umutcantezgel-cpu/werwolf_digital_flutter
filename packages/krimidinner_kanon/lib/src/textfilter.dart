/// Textfilter für Besetzung N: kürzt Kanontexte, formuliert sie aber nie um.
///
/// - F1 entfernt den Marker `[NUR WENN ROLLE nn NICHT BESETZT]`.
/// - F2 teilt Listenfelder an ` ; `; ein Eintrag mit `(nur wenn Rolle nn besetzt)`
///   verliert den Marker, wenn nn ≤ N, sonst fällt er ganz weg.
/// - F3 macht aus `(ist Rolle nn besetzt, X)` ein `(X)`, wenn nn ≤ N, sonst fällt
///   die Klammer weg; `(ist Rolle nn nicht besetzt, X)` umgekehrt.
/// - F4 entfernt Produktionskennungen in Klammern, etwa `(H-17)`, `(Hinweis H-121)`,
///   `(Hinweise H-105 und H-107)` oder `(R10)`, und Querverweise wie `nach ZM-2`.
/// - F5 löst Verbindungen auf: `Rnn (…)` fällt weg, wenn nn > N; ein führendes
///   `Rnn`, `DET` oder `BW` wird zum Namen.
/// - F6 glättet Leerzeichen und Satzzeichen.
library;

final _ersatzMarker = RegExp(r'\s*\[NUR WENN ROLLE \d\d NICHT BESETZT\]\s*');
final _nurWenn = RegExp(r'\s*\(nur wenn Rolle (\d\d) besetzt\)');
final _istBesetzt = RegExp(r'\s*\(ist Rolle (\d\d) besetzt, ([^()]*)\)');
final _istNichtBesetzt = RegExp(
  r'\s*\(ist Rolle (\d\d) nicht besetzt, ([^()]*)\)',
);

/// Eine Produktionskennung: Hinweise, Wahrheiten, Beweisstücke, Schlüsse,
/// Gespräche, Entscheidungen, Regeln, Rollen und Ansagen.
const _kennung =
    r'(?:(?:H|HW|BS|BSO|S|K|Z|PF|OA|LR|ZM|AK|IF|EM|AB|GS|GL|LA|LF)-\d+[a-z]?'
    r'|(?:DW|MK|[GDE])\d-(?:R?\d+)'
    r'|R\d\d|A-E\d+)';
final _kennungsKlammer = RegExp(
  r'\s*\((?:Hinweise?\s+)?' +
      _kennung +
      r'(?:\s*(?:,|und|bis|/)\s*' +
      _kennung +
      r')*\)',
);
final _querverweis = RegExp(r'\s+nach (?:ZM|LR|AK|IF)-\d+');

final _listenTrenner = RegExp(r'\s+;\s+');
final _leer = RegExp(r'\s+');
final _vorSatzzeichen = RegExp(r'\s+([,.;:!?)\]“])');
final _nachKlammer = RegExp(r'([(\[„])\s+');
final _leereKlammer = RegExp(r'\s*\(\s*\)');
final _doppelKomma = RegExp(r',\s*([,.;:!?])');

/// F1: entfernt `[NUR WENN ROLLE nn NICHT BESETZT]`.
String ohneErsatzMarker(String s) => glaetten(s.replaceAll(_ersatzMarker, ' '));

/// F3: löst Besetzungsklammern für Besetzung [n] auf.
String besetzungsKlammern(String s, int n) {
  var t = s.replaceAllMapped(
    _istBesetzt,
    (m) => int.parse(m[1]!) <= n ? ' (${m[2]!.trim()})' : '',
  );
  t = t.replaceAllMapped(
    _istNichtBesetzt,
    (m) => int.parse(m[1]!) > n ? ' (${m[2]!.trim()})' : '',
  );
  return glaetten(t);
}

/// F4: entfernt Produktionskennungen in Klammern und Querverweise auf Regeln.
String ohneKennungen(String s) =>
    glaetten(s.replaceAll(_kennungsKlammer, '').replaceAll(_querverweis, ''));

/// F6: glättet Leerzeichen und Satzzeichen.
String glaetten(String s) {
  var t = s.replaceAll(_leer, ' ');
  t = t.replaceAll(_leereKlammer, '');
  t = t.replaceAllMapped(_vorSatzzeichen, (m) => m[1]!);
  t = t.replaceAllMapped(_nachKlammer, (m) => m[1]!);
  t = t.replaceAllMapped(_doppelKomma, (m) => m[1]!);
  return t.trim();
}

/// F1, F3, F4 und F6 auf Fließtext bei Besetzung [n].
///
/// Ein Marker `(nur wenn Rolle nn besetzt)` verliert sich im Fließtext nur, wenn
/// die Rolle besetzt ist; Listen behandelt [filtereListe].
String filtereText(String s, int n) {
  var t = s.replaceAll(_ersatzMarker, ' ');
  t = t.replaceAllMapped(_nurWenn, (m) => int.parse(m[1]!) <= n ? '' : m[0]!);
  t = besetzungsKlammern(t, n);
  return ohneKennungen(t);
}

/// F2: teilt ein Listenfeld an ` ; ` und filtert jeden Eintrag für Besetzung [n].
List<String> filtereListe(String s, int n) {
  final out = <String>[];
  for (final roh in s.split(_listenTrenner)) {
    final m = _nurWenn.firstMatch(roh);
    if (m != null && int.parse(m[1]!) > n) continue;
    final t = filtereText(roh.replaceAll(_nurWenn, ''), n);
    if (t.isNotEmpty) out.add(t);
  }
  return out;
}

/// Eine aufgelöste Verbindung: Name der Person und die Erläuterung (oder `null`).
typedef Verbindung = ({String name, String? erlaeuterung});

final _verbindung = RegExp(r'^(R(\d\d)|DET|BW)\b\s*(?:\((.*)\))?\s*\.?$');

/// F5: löst ein Feld `Verbindungen` für Besetzung [n] auf.
///
/// [name] liefert zu einer Rollennummer den Vornamen. `DET` wird zu
/// [geburtstagskind], `BW` zu [burgwart]. Der Sammelverweis auf die
/// Erweiterungsrollen fällt weg.
List<Verbindung> filtereVerbindungen(
  String s,
  int n, {
  required String Function(int nummer) name,
  required String geburtstagskind,
  required String burgwart,
}) {
  final out = <Verbindung>[];
  for (final roh in filtereListe(s, n)) {
    if (roh.startsWith('Erweiterungsrollen siehe')) continue;
    final m = _verbindung.firstMatch(roh);
    if (m == null) {
      out.add((name: roh, erlaeuterung: null));
      continue;
    }
    final nr = m[2] == null ? null : int.parse(m[2]!);
    if (nr != null && nr > n) continue;
    final wer = switch (m[1]!) {
      'DET' => geburtstagskind,
      'BW' => burgwart,
      _ => name(nr!),
    };
    final rest = m[3]?.trim();
    out.add((
      name: wer,
      erlaeuterung: rest == null || rest.isEmpty ? null : rest,
    ));
  }
  return out;
}

final _nummeriert = RegExp(r'(?:^|\s)(\d)\)\s+');

/// Teilt einen Wert der Form `1) … 2) … 3) …` in Zeilen (ohne die Nummern-Klammern
/// zu verlieren). Ohne Nummerierung bleibt der Wert eine Zeile.
List<String> nummerierteZeilen(String s) {
  final treffer = _nummeriert.allMatches(s).toList();
  if (treffer.length < 2 || treffer.first.start != 0) return [s.trim()];
  final out = <String>[];
  for (var i = 0; i < treffer.length; i++) {
    final von = treffer[i].start;
    final bis = i + 1 < treffer.length ? treffer[i + 1].start : s.length;
    out.add(s.substring(von, bis).trim());
  }
  return out;
}

final _uhrzeitVorne = RegExp(
  r'^(\d\d:\d\d(?::\d\d)?(?:–\d\d:\d\d(?::\d\d)?)?)\s+(.+)$',
);

/// Trennt eine führende Uhrzeit ab: `23:52 Merle geht …` → (`23:52`, `Merle geht …`).
(String?, String) uhrzeitVorne(String s) {
  final m = _uhrzeitVorne.firstMatch(s);
  return m == null ? (null, s) : (m[1], m[2]!);
}

/// Kanon „Spuk im Gewölbe“: Datensätze einlesen, Overlay anwenden, abfragen.
///
/// Portiert das Einlesen aus `90_werkzeug/kanon.py`; die Overlay-Regeln stehen in
/// `nachtlauf/kanon/ANPASSUNG.md`.
library;

import 'dart:convert';

/// Sichtklasse eines Datensatzes: `O` öffentlich, `G` Rollengeheimnis, `L` Lösung.
enum Sicht {
  o,
  g,
  l;

  /// Kürzel wie im Kanon (`O`, `G` oder `L`).
  String get kuerzel => name.toUpperCase();
}

/// Ein Datensatz: eine Zeile `@ID [S] | Feld: Wert | …`.
class KanonDatensatz {
  KanonDatensatz({
    required this.id,
    required this.sicht,
    required this.felder,
    required this.datei,
    required this.zeile,
  });

  final String id;
  final Sicht sicht;

  /// Felder in Dateireihenfolge. Ein Wert `–` steht als leerer Text.
  final Map<String, String> felder;

  /// Datei und Zeile (1-basiert) der Definition.
  final String datei;
  final int zeile;

  /// Wert des Feldes [name]; `null`, wenn das Feld fehlt.
  String? feld(String name) => felder[name];

  /// Die Zeile im Kanon-Format; leere Werte stehen wieder als `–`.
  String get alsZeile {
    final buf = StringBuffer('@$id [${sicht.kuerzel}]');
    felder.forEach(
      (name, wert) => buf.write(' | $name: ${wert.isEmpty ? '–' : wert}'),
    );
    return buf.toString();
  }
}

/// Der Kanon: alle Datensätze in Lesereihenfolge, optional mit angewandtem Overlay.
class Kanon {
  Kanon._(this.datensaetze, this.lesefehler, this.ersetzungen);

  /// Datensätze nach Kennung. ERSETZE-Datensätze sind nicht enthalten.
  final Map<String, KanonDatensatz> datensaetze;

  /// Syntaxbefunde beim Einlesen (Kopf unlesbar, Feld ohne Doppelpunkt, Overlay).
  final List<String> lesefehler;

  /// Angewandte ERSETZE-Datensätze in Nummernfolge (leer ohne Overlay).
  final List<KanonDatensatz> ersetzungen;

  /// Liest Kanon-Dateien aus einer Map von Dateiname zu Inhalt, in Namensreihenfolge.
  ///
  /// Doppelte Kennungen werfen eine [FormatException] mit Datei und Zeile.
  static Kanon ausText(Map<String, String> dateiInhalte) {
    final recs = <String, KanonDatensatz>{};
    final fehler = <String>[];
    final namen = dateiInhalte.keys.where(istKanonDatei).toList()..sort();
    for (final name in namen) {
      final zeilen = const LineSplitter().convert(dateiInhalte[name]!);
      for (var i = 0; i < zeilen.length; i++) {
        final satz = _lesZeile(zeilen[i], name, i + 1, fehler);
        if (satz == null) continue;
        final alt = recs[satz.id];
        if (alt != null) {
          throw FormatException(
            'DOPPELT ${satz.id}: ${alt.datei}:${alt.zeile} und $name:${satz.zeile}',
          );
        }
        recs[satz.id] = satz;
      }
    }
    return Kanon._(recs, fehler, const []);
  }

  /// Wendet das Overlay [overlayText] an und liefert den wirksamen Kanon.
  ///
  /// Gleiche Kennung: die genannten Felder ersetzen die Originalfelder, `Löschen: …`
  /// entfernt Felder (nach dem Ersetzen). Die Sicht bleibt beim Original; eine abweichende
  /// Sicht im Overlay wird als Lesebefund gemeldet. Neue Kennung: neuer Datensatz. Danach
  /// ersetzt `@ERSETZE-nn` exakt (groß/klein-genau) in allen Feldwerten, in Nummernfolge.
  Kanon mitOverlay(String overlayText, {String datei = 'ANPASSUNG.md'}) {
    final recs = {
      for (final e in datensaetze.entries)
        e.key: KanonDatensatz(
          id: e.value.id,
          sicht: e.value.sicht,
          felder: Map.of(e.value.felder),
          datei: e.value.datei,
          zeile: e.value.zeile,
        ),
    };
    final fehler = [...lesefehler];
    final gesehen = <String>{};
    final ersetze = <int, KanonDatensatz>{};
    final zeilen = const LineSplitter().convert(overlayText);
    for (var i = 0; i < zeilen.length; i++) {
      final nr = i + 1;
      final satz = _lesZeile(zeilen[i], datei, nr, fehler);
      if (satz == null) continue;
      if (!gesehen.add(satz.id)) {
        throw FormatException('DOPPELT im Overlay ${satz.id}: $datei:$nr');
      }
      final ersetzeNr = _ersetzeNummer(satz.id);
      if (ersetzeNr != null) {
        final von = satz.feld('Von');
        final nach = satz.feld('Nach');
        if (von == null || von.isEmpty || nach == null) {
          fehler.add('SYNTAX $datei:$nr: ERSETZE ohne Von/Nach');
        } else if (ersetze.containsKey(ersetzeNr)) {
          throw FormatException('DOPPELT ERSETZE-$ersetzeNr: $datei:$nr');
        } else {
          ersetze[ersetzeNr] = satz;
        }
        continue;
      }
      final loeschen = satz.felder.remove('Löschen');
      final alt = recs[satz.id];
      if (alt != null && alt.sicht != satz.sicht) {
        fehler.add(
          'OVERLAY $datei:$nr: Sicht [${satz.sicht.kuerzel}] weicht vom Original '
          '[${alt.sicht.kuerzel}] ab (${satz.id})',
        );
      }
      final felder = alt?.felder ?? <String, String>{};
      felder.addAll(satz.felder);
      if (loeschen != null) {
        for (final name in _loeschNamen(loeschen, felder.keys.toList())) {
          felder.remove(name);
        }
      }
      recs[satz.id] = KanonDatensatz(
        id: satz.id,
        sicht: alt?.sicht ?? satz.sicht,
        felder: felder,
        datei: alt?.datei ?? datei,
        zeile: alt?.zeile ?? nr,
      );
    }
    final nummern = ersetze.keys.toList()..sort();
    for (final n in nummern) {
      final von = ersetze[n]!.feld('Von')!;
      final nach = ersetze[n]!.feld('Nach')!;
      for (final r in recs.values) {
        for (final name in r.felder.keys.toList()) {
          r.felder[name] = r.felder[name]!.replaceAll(von, nach);
        }
      }
    }
    return Kanon._(recs, fehler, [for (final n in nummern) ersetze[n]!]);
  }

  /// Datensätze, deren Kennung mit [praefix] beginnt.
  Iterable<KanonDatensatz> mitPraefix(String praefix) =>
      datensaetze.values.where((d) => d.id.startsWith(praefix));
}

final _kopf = RegExp(
  r'^@([A-Za-zÄÖÜäöü0-9\-_.]+)\s*\[([OGL])\]\s*(.*)$',
  dotAll: true,
);
final _ersetze = RegExp(r'^ERSETZE-(\d+)$');

/// Gehört die Datei [name] zum Kanon (`K*.md`, nicht FORMAT/PROTOKOLL)?
bool istKanonDatei(String name) =>
    name.startsWith('K') && name.endsWith('.md');

int? _ersetzeNummer(String id) {
  final m = _ersetze.firstMatch(id);
  return m == null ? null : int.parse(m.group(1)!);
}

/// Liest eine Zeile. `null` für Zeilen ohne `@`; Syntaxbefunde gehen nach [fehler].
KanonDatensatz? _lesZeile(
  String zeile,
  String datei,
  int nr,
  List<String> fehler,
) {
  if (!zeile.startsWith('@')) return null;
  final kopf = _kopf.firstMatch(zeile);
  if (kopf == null) {
    fehler.add('SYNTAX $datei:$nr: Kopf unlesbar: ${_kuerzen(zeile, 80)}');
    return null;
  }
  final id = kopf.group(1)!;
  final felder = <String, String>{};
  var rest = kopf.group(3)!.trim();
  if (rest.startsWith('|')) rest = rest.substring(1);
  for (final teil in rest.split(' | ')) {
    if (teil.trim().isEmpty) continue;
    final t = teil.trim().replaceFirst(RegExp(r'^\|+'), '').trim();
    final paar = _feldPaar(t);
    if (paar == null) {
      fehler.add(
        'SYNTAX $datei:$nr: Feld ohne Doppelpunkt in $id: ${_kuerzen(t, 60)}',
      );
      continue;
    }
    felder[paar.$1] = paar.$2;
  }
  return KanonDatensatz(
    id: id,
    sicht: switch (kopf.group(2)!) {
      'O' => Sicht.o,
      'G' => Sicht.g,
      _ => Sicht.l,
    },
    felder: felder,
    datei: datei,
    zeile: nr,
  );
}

/// Trennt `Name: Wert` am ersten `: `; steht der Doppelpunkt am Ende, ist der Wert leer.
(String, String)? _feldPaar(String t) {
  final i = t.indexOf(': ');
  if (i >= 0) return (t.substring(0, i).trim(), _wert(t.substring(i + 2)));
  if (t.endsWith(':')) return (t.substring(0, t.length - 1).trim(), '');
  return null;
}

/// Getrimmter Wert; `–` bedeutet leer.
String _wert(String s) {
  final v = s.trim();
  return v == '–' ? '' : v;
}

/// Feldnamen aus `Löschen: …`. Namen mit Komma (etwa „Name, Alter, Geschlecht“) werden
/// anhand der vorhandenen Felder erkannt, sonst am nächsten Komma getrennt.
List<String> _loeschNamen(String wert, List<String> vorhanden) {
  final bekannt = vorhanden.where((b) => b.isNotEmpty).toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  final namen = <String>[];
  var rest = wert.trim();
  while (rest.isNotEmpty) {
    String? treffer;
    for (final b in bekannt) {
      if (!rest.startsWith(b)) continue;
      final nach = rest.substring(b.length).trimLeft();
      if (nach.isEmpty || nach.startsWith(',')) {
        treffer = b;
        break;
      }
    }
    final laenge =
        treffer?.length ??
        (rest.contains(',') ? rest.indexOf(',') : rest.length);
    final name = treffer ?? rest.substring(0, laenge).trim();
    if (name.isNotEmpty) namen.add(name);
    rest = rest.substring(laenge).trimLeft();
    if (rest.startsWith(',')) rest = rest.substring(1).trimLeft();
  }
  return namen;
}

/// Kürzt [s] auf höchstens [n] Zeichen (Unicode-Zeichen, nicht Code-Units).
String _kuerzen(String s, int n) =>
    s.runes.length <= n ? s : String.fromCharCodes(s.runes.take(n));

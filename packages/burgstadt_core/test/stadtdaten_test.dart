import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

/// Maschinelle Abnahme der Stadtdaten (Auftrag A-305a, Abschnitt 9).
const _dateiHaeuser = 'data/stadt/haeuser.json';
const _dateiBewohner = 'data/stadt/bewohner.json';

const _viertelSoll = <String, int>{
  'Marktviertel': 30,
  'Handwerkergasse': 28,
  'Mauerviertel': 26,
  'Kirchhügel': 22,
  'Untere Stadt': 32,
  'Burgberg': 22,
};

const _ortViertel = <String, String>{
  'ORT-01': 'Marktviertel',
  'ORT-02': 'Marktviertel',
  'ORT-03': 'Marktviertel',
  'ORT-04': 'Handwerkergasse',
  'ORT-05': 'Kirchhügel',
  'ORT-06': 'Mauerviertel',
  'ORT-07': 'Marktviertel',
  'ORT-08': 'Untere Stadt',
  'ORT-09': 'Marktviertel',
  'ORT-10': 'Kirchhügel',
  'ORT-11': 'Untere Stadt',
  'ORT-12': 'Kirchhügel',
};

const _typen = <String>{
  'Giebelhaus', 'Eckhaus', 'Laubenhaus', 'Zunftturm', 'Werkstatt', 'Speicher', 'Pfarrhaus',
  'Torhaus', 'Turm', 'Laden', 'Amtshaus', 'Kirche', 'Museum', 'Pension', 'Teestube', 'Bäckerei',
  'Apotheke', 'Bibliothek', 'Stromhaus', 'Uhrturm', 'Theater',
};

const _innenraeume = <String>{
  'Wohnstube', 'Werkstatt', 'Laden', 'Speicher', 'Bäckerei', 'Teestube', 'Apotheke', 'Museum',
  'Bibliothek', 'Pension', 'Kirche', 'Amtsstube', 'Fundus', 'Schaltraum', 'Uhrwerk', 'Schreinerei',
  'Archiv',
};

const _haarfarben = <String>{'schwarz', 'braun', 'blond', 'rot', 'grau', 'weiß', 'keins'};
const _frisuren = <String>{'kurz', 'lang', 'zopf', 'dutt', 'locken', 'glatze', 'kraus'};
const _kopfbedeckungen = <String>{'keine', 'mütze', 'hut', 'kopftuch', 'nachtmütze', 'haube'};
const _rampen = <String>{'neutral', 'stein', 'holz', 'rot', 'bernstein', 'blau', 'haut'};
const _zustaende = <String>{'schläft', 'wach', 'arbeitet', 'unterwegs'};

/// Verbotswörter aus den Leitplanken (ganze Wörter, groß/klein egal; „weinen“ ist erlaubt).
const _verboten = <String>[
  'Wein', 'Bier', 'Met', 'Sekt', 'Schnaps', 'Glühwein', 'Likör', 'Cocktail', 'Bar', 'Kneipe',
  'Prost', 'anstoßen', 'betrunken', 'beschwipst', 'Kater', 'Promille', 'Rausch', 'Joint', 'kiffen',
];

/// Begriffe, die kein Text nennen darf (Figuren und Gegenstände des Falls).
const _gesperrt = <String>[
  'Merle', 'Jonas', 'Adnan', 'Rojda', 'Taler', 'Kerzenständer', 'Laken', 'Stablampe', 'Schlüsselbund',
];

final _satzEnde = RegExp(r'(?<=[.!?])\s+');
final _vierstellig = RegExp(r'\d{4}');
final _uhrzeit = RegExp(r'^\d{2}:\d{2}$');

/// Ganzes Wort, groß/klein egal (Umlaute zählen als Buchstaben).
RegExp _ganzesWort(String wort) =>
    RegExp('(?<!\\p{L})${RegExp.escape(wort)}(?!\\p{L})', caseSensitive: false, unicode: true);

int _satzzahl(String text) =>
    text.trim().split(_satzEnde).where((s) => s.trim().isNotEmpty).length;

int _minuten(String hhmm) {
  final teile = hhmm.split(':');
  return int.parse(teile[0]) * 60 + int.parse(teile[1]);
}

Map<String, dynamic> _lade(String pfad) {
  final inhalt = File(pfad).readAsStringSync();
  return jsonDecode(inhalt) as Map<String, dynamic>;
}

List<Map<String, dynamic>> _liste(Object? wert) =>
    (wert as List<dynamic>).cast<Map<String, dynamic>>();

/// Alle Spieltexte mit Fundstelle, für die Wort- und Namensprüfung.
Map<String, String> _alleTexte(List<Map<String, dynamic>> haeuser, List<Map<String, dynamic>> bewohner) {
  final texte = <String, String>{};
  for (final h in haeuser) {
    final id = h['id'] as String;
    texte['$id name'] = h['name'] as String;
    texte['$id inschrift'] = h['inschrift'] as String;
    texte['$id geschichte'] = h['geschichte'] as String;
  }
  for (final b in bewohner) {
    final id = b['id'] as String;
    texte['$id name'] = b['name'] as String;
    texte['$id beruf'] = b['beruf'] as String;
    texte['$id wesen'] = b['wesen'] as String;
    texte['$id gerede'] = b['gerede'] as String;
    final saetze = b['saetze'] as List<dynamic>;
    for (var i = 0; i < saetze.length; i++) {
      texte['$id satz$i'] = saetze[i] as String;
    }
    for (var i = 0; i < _liste(b['nacht']).length; i++) {
      texte['$id tut$i'] = _liste(b['nacht'])[i]['tut'] as String;
    }
    final aussehen = b['aussehen'] as Map<String, dynamic>;
    final zubehoer = aussehen['zubehoer'] as List<dynamic>;
    for (var i = 0; i < zubehoer.length; i++) {
      texte['$id zubehoer$i'] = zubehoer[i] as String;
    }
    final kleidung = _liste(aussehen['kleidung']);
    for (var i = 0; i < kleidung.length; i++) {
      texte['$id kleidung$i'] = kleidung[i]['teil'] as String;
    }
  }
  return texte;
}

void main() {
  late final List<Map<String, dynamic>> haeuser;
  late final List<Map<String, dynamic>> bewohner;
  late final Map<String, Map<String, dynamic>> hausById;
  late final Map<String, Map<String, dynamic>> bewById;
  late final Map<String, String> texte;

  setUpAll(() {
    final h = _lade(_dateiHaeuser);
    final b = _lade(_dateiBewohner);
    expect(h['version'], 1);
    expect(b['version'], 1);
    haeuser = _liste(h['haeuser']);
    bewohner = _liste(b['bewohner']);
    hausById = {for (final x in haeuser) x['id'] as String: x};
    bewById = {for (final x in bewohner) x['id'] as String: x};
    texte = _alleTexte(haeuser, bewohner);
  });

  test('Anzahlen: 160 Häuser und 44 Bewohner', () {
    expect(haeuser, hasLength(160));
    expect(bewohner, hasLength(44));
  });

  test('IDs eindeutig und lückenlos (H-001 bis H-160, B01 bis B44)', () {
    final hIds = haeuser.map((h) => h['id'] as String).toList();
    final bIds = bewohner.map((b) => b['id'] as String).toList();
    expect(hIds.toSet(), hasLength(160));
    expect(bIds.toSet(), hasLength(44));
    expect(hIds, [for (var i = 1; i <= 160; i++) 'H-${i.toString().padLeft(3, '0')}']);
    expect(bIds, [for (var i = 1; i <= 44; i++) 'B${i.toString().padLeft(2, '0')}']);
  });

  test('Viertel-Verteilung exakt', () {
    final zaehl = <String, int>{};
    for (final h in haeuser) {
      final v = h['viertel'] as String;
      zaehl[v] = (zaehl[v] ?? 0) + 1;
    }
    expect(zaehl, _viertelSoll);
  });

  test('Typen, Innenräume und Viertel gehören zu den erlaubten Werten', () {
    for (final h in haeuser) {
      final id = h['id'] as String;
      expect(_viertelSoll.containsKey(h['viertel']), isTrue, reason: '$id: Viertel');
      expect(_typen.contains(h['typ']), isTrue, reason: '$id: Typ ${h['typ']}');
      final innen = h['innenraum'];
      if (innen != null) {
        expect(_innenraeume.contains(innen), isTrue, reason: '$id: Innenraum $innen');
      }
      expect(h['betretbar'] is bool, isTrue, reason: '$id: betretbar');
      expect(h['betretbar'] as bool, innen != null, reason: '$id: betretbar passt nicht zum Innenraum');
    }
  });

  test('Betretbare Innenräume: mindestens 44, alle 12 Fall-Orte darunter', () {
    final betretbar = haeuser.where((h) => h['betretbar'] == true).length;
    expect(betretbar, greaterThanOrEqualTo(44));
    for (final ort in _ortViertel.keys) {
      final haus = haeuser.where((h) => h['ort'] == ort).toList();
      expect(haus, hasLength(1), reason: '$ort kommt nicht genau einmal vor');
      expect(haus.single['betretbar'], isTrue, reason: '$ort ist nicht betretbar');
    }
  });

  test('Fall-Orte: ORT-01 bis ORT-12 je genau einmal und im richtigen Viertel', () {
    final gefunden = haeuser.where((h) => h['ort'] != null).map((h) => h['ort'] as String).toList();
    expect(gefunden.toSet(), _ortViertel.keys.toSet());
    expect(gefunden, hasLength(12));
    for (final h in haeuser) {
      final ort = h['ort'] as String?;
      if (ort != null) {
        expect(h['viertel'], _ortViertel[ort], reason: '$ort liegt im falschen Viertel');
      }
    }
  });

  test('Inschrift: höchstens 60 Zeichen, genau eine Jahreszahl von 1500 bis 1930', () {
    for (final h in haeuser) {
      final id = h['id'] as String;
      final inschrift = h['inschrift'] as String;
      expect(inschrift.length, lessThanOrEqualTo(60), reason: '$id: Inschrift zu lang');
      final jahre = _vierstellig.allMatches(inschrift).map((m) => int.parse(m.group(0)!)).toList();
      expect(jahre, hasLength(1), reason: '$id: Jahreszahl fehlt oder mehrfach');
      expect(jahre.single, inInclusiveRange(1500, 1930), reason: '$id: Jahr außerhalb 1500-1930');
    }
  });

  test('Geschichte: 1 bis 2 Sätze, höchstens 220 Zeichen, jede verschieden', () {
    final gesehen = <String>{};
    for (final h in haeuser) {
      final id = h['id'] as String;
      final geschichte = h['geschichte'] as String;
      expect(geschichte.length, lessThanOrEqualTo(220), reason: '$id: Geschichte zu lang');
      expect(_satzzahl(geschichte), inInclusiveRange(1, 2), reason: '$id: Satzzahl');
      expect(gesehen.add(geschichte), isTrue, reason: '$id: Geschichte doppelt');
    }
    expect(gesehen, hasLength(160));
  });

  test('Bewohner: Felder und Wertebereiche', () {
    for (final b in bewohner) {
      final id = b['id'] as String;
      expect(b['alter'], isA<int>(), reason: '$id: Alter');
      expect(['w', 'm'].contains(b['geschlecht']), isTrue, reason: '$id: Geschlecht');
      final aussehen = b['aussehen'] as Map<String, dynamic>;
      expect(_haarfarben.contains(aussehen['haar']), isTrue, reason: '$id: Haar');
      expect(_frisuren.contains(aussehen['frisur']), isTrue, reason: '$id: Frisur');
      expect(_kopfbedeckungen.contains(aussehen['kopf']), isTrue, reason: '$id: Kopf');
      for (final k in _liste(aussehen['kleidung'])) {
        expect(_rampen.contains(k['rampe']), isTrue, reason: '$id: Rampe ${k['rampe']}');
        expect(k['rampe'], isNot('grün'), reason: '$id: grüne Kleidung');
        expect(k['stufe'], isA<int>(), reason: '$id: Stufe');
        expect(k['stufe'] as int, inInclusiveRange(0, 7), reason: '$id: Stufe außerhalb 0-7');
        expect(k['rampe'] == 'neutral' && k['stufe'] == 1, isFalse, reason: '$id: Neutral 1 ist die Augenfarbe');
      }
      expect(aussehen['zubehoer'], isA<List<dynamic>>(), reason: '$id: Zubehör');
    }
  });

  test('Verweise: Wohn- und Arbeitshaus existieren, Bewohner und Haus stimmen überein', () {
    for (final b in bewohner) {
      final id = b['id'] as String;
      final wohnhaus = b['wohnhaus'] as String?;
      expect(wohnhaus, isNotNull, reason: '$id hat kein Wohnhaus');
      expect(hausById.containsKey(wohnhaus), isTrue, reason: '$id: Wohnhaus $wohnhaus fehlt');
      expect(
        (hausById[wohnhaus]!['bewohner'] as List<dynamic>).contains(id),
        isTrue,
        reason: '$id fehlt in den Bewohnern von $wohnhaus',
      );
      final arbeitshaus = b['arbeitshaus'] as String?;
      if (arbeitshaus != null) {
        expect(hausById.containsKey(arbeitshaus), isTrue, reason: '$id: Arbeitshaus $arbeitshaus fehlt');
      }
    }
    for (final h in haeuser) {
      final id = h['id'] as String;
      for (final bid in h['bewohner'] as List<dynamic>) {
        expect(bewById.containsKey(bid), isTrue, reason: '$id führt unbekannten Bewohner $bid');
        expect(bewById[bid]!['wohnhaus'], id, reason: '$bid wohnt nicht in $id');
      }
    }
  });

  test('Tagesverlauf: lückenlos von 00:30 bis 05:30, aufsteigend', () {
    for (final b in bewohner) {
      final id = b['id'] as String;
      final nacht = _liste(b['nacht']);
      expect(nacht, isNotEmpty, reason: '$id: kein Tagesverlauf');
      expect(nacht.first['von'], '00:30', reason: '$id: Start');
      expect(nacht.last['bis'], '05:30', reason: '$id: Ende');
      for (var i = 0; i < nacht.length; i++) {
        final von = nacht[i]['von'] as String;
        final bis = nacht[i]['bis'] as String;
        expect(_uhrzeit.hasMatch(von) && _uhrzeit.hasMatch(bis), isTrue, reason: '$id: Format');
        expect(_minuten(von) < _minuten(bis), isTrue, reason: '$id: $von bis $bis nicht aufsteigend');
        expect(_zustaende.contains(nacht[i]['zustand']), isTrue, reason: '$id: Zustand');
        if (i + 1 < nacht.length) {
          expect(nacht[i + 1]['von'], bis, reason: '$id: Lücke nach $bis');
        }
      }
    }
  });

  test('Aufenthaltsorte nachts sind gültig', () {
    for (final b in bewohner) {
      final id = b['id'] as String;
      for (final s in _liste(b['nacht'])) {
        final wo = s['wo'] as String;
        if (wo == 'arbeitshaus') {
          expect(b['arbeitshaus'], isNotNull, reason: '$id: Arbeitshaus im Tagesverlauf, aber keines angegeben');
        } else if (wo.startsWith('gasse:')) {
          final viertel = wo.substring('gasse:'.length);
          expect(_viertelSoll.containsKey(viertel), isTrue, reason: '$id: unbekanntes Viertel in $wo');
          expect(viertel, isNot('Burgberg'), reason: '$id: Burgberg-Gasse verboten');
        } else {
          expect(['wohnhaus', 'fenster'].contains(wo), isTrue, reason: '$id: Ort $wo');
        }
      }
    }
  });

  test('Mindestens 12 Bewohner sind irgendwann wach oder unterwegs', () {
    var zahl = 0;
    for (final b in bewohner) {
      final wach = _liste(b['nacht']).any((s) => s['zustand'] == 'wach' || s['zustand'] == 'unterwegs');
      if (wach) zahl++;
    }
    expect(zahl, greaterThanOrEqualTo(12));
  });

  test('Sätze: 3 bis 5 je Bewohner, höchstens 120 Zeichen; Gerede 1 Satz bis 140 Zeichen', () {
    for (final b in bewohner) {
      final id = b['id'] as String;
      final saetze = b['saetze'] as List<dynamic>;
      expect(saetze, hasLength(inInclusiveRange(3, 5)), reason: '$id: Satzzahl');
      for (final s in saetze) {
        expect((s as String).length, lessThanOrEqualTo(120), reason: '$id: Satz zu lang');
      }
      final gerede = b['gerede'] as String;
      expect(gerede.length, lessThanOrEqualTo(140), reason: '$id: Gerede zu lang');
      expect(_satzzahl(gerede), 1, reason: '$id: Gerede ist kein einzelner Satz');
    }
  });

  test('Verbotswörter kommen in keinem Text vor', () {
    final befunde = <String>[];
    texte.forEach((ort, text) {
      for (final wort in _verboten) {
        if (_ganzesWort(wort).hasMatch(text)) befunde.add('$ort: $wort');
      }
    });
    expect(befunde, isEmpty);
  });

  test('Pflege, Reinigung und Bedienung nicht nur mit Frauen besetzt (E54)', () {
    for (final beruf in ['Pfleg', 'Reinigung', 'Bedienung']) {
      final g = {for (final b in bewohner) if ((b['beruf'] as String).contains(beruf)) b['geschlecht']};
      expect(g, contains('m'), reason: beruf);
    }
    // Ausgleich: das Verhältnis bleibt wie vorher (21 Frauen, 23 Männer)
    expect(bewohner.where((b) => b['geschlecht'] == 'w').length, 21);
  });

  test('Dutt, Haube und Glatze nicht nur bei Älteren (E54)', () {
    int juengste(bool Function(Map<String, dynamic> a) passt) => bewohner
        .where((b) => passt(b['aussehen'] as Map<String, dynamic>))
        .map((b) => b['alter'] as int)
        .reduce((x, y) => x < y ? x : y);
    expect(juengste((a) => a['frisur'] == 'dutt'), lessThan(50));
    expect(juengste((a) => a['kopf'] == 'haube'), lessThan(55));
    expect(juengste((a) => a['frisur'] == 'glatze'), lessThan(50));
  });

  test('Keine Alters- oder Gruppenwörter in Bewohnertexten (E54)', () {
    const woerter = ['brummig', 'brummelig', 'grummelig', 'hört schlecht', 'Hörrohr', 'Schützlinge'];
    // „die Alten“, „aller Alten“ als Gruppenwort (groß geschrieben); „die alten Zeiten“ ist kein Befund
    final gruppenwort = RegExp(r'\bAlten\b');
    final befunde = <String>[];
    texte.forEach((ort, text) {
      if (!ort.startsWith('B')) return;
      for (final w in woerter) {
        if (text.toLowerCase().contains(w.toLowerCase())) befunde.add('$ort: $w');
      }
      if (gruppenwort.hasMatch(text)) befunde.add('$ort: die Alten');
    });
    expect(befunde, isEmpty);
  });

  test('Niemand wird als „der/die alte …“ bezeichnet, sondern mit Namen (E40, E50)', () {
    final namen = {for (final b in bewohner) ...(b['name'] as String).split(' ')};
    final befunde = <String>[];
    texte.forEach((ort, text) {
      for (final n in namen) {
        if (RegExp('\\b(der|die|den|dem|des) alten? ${RegExp.escape(n)}\\b', caseSensitive: false).hasMatch(text)) befunde.add('$ort: alte $n');
      }
    });
    expect(befunde, isEmpty);
  });

  test('Gesperrte Namen und Gegenstände kommen in keinem Text vor', () {
    final befunde = <String>[];
    texte.forEach((ort, text) {
      for (final wort in _gesperrt) {
        if (_ganzesWort(wort).hasMatch(text)) befunde.add('$ort: $wort');
      }
    });
    expect(befunde, isEmpty);
  });
}

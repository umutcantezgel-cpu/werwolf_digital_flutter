import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

/// Eingefrorenes Format (A-601a, Abschnitt 6): erlaubte Werte.
const _frisuren = {
  'kurz', 'kurz-locken', 'schulterlang', 'schulterlang-spange', 'lang-offen', 'zopf', 'dutt',
  'pferdeschwanz', 'glatze', 'stoppel', 'seitenscheitel',
};
const _baerte = {'keiner', 'stoppel', 'kurz', 'voll', 'schnurrbart'};
const _statur = {'schmal', 'normal', 'kräftig'};
const _geschlechter = {'w', 'm'};
const _oberteile = {
  'strickjacke-zopf', 'strickjacke', 'pullover', 'fleece', 'hemd', 'bluse', 't-shirt',
  'weste-strick', 'jacke', 'mantel', 'kleid', 'hoodie', 'sakko',
};
const _darunter = {'bluse', 'hemd', 't-shirt', 'keins'};
const _unterteile = {'jeans', 'hose', 'cordhose', 'rock', 'leggings'};
const _schuhe = {'wanderstiefel', 'sneaker', 'arbeitsschuhe', 'halbschuhe', 'stiefel'};
const _koepfe = {'keine', 'muetze', 'kappe', 'hut', 'haarreif', 'stirnband'};
const _zubehoer = {
  'brille', 'brille-stirn', 'notizbuch', 'kamera', 'umhaengetasche', 'rucksack', 'schal',
  'halstuch', 'uhr', 'ohrringe', 'handy',
};
const _pflichtfelder = [
  'id', 'name', 'alter', 'geschlecht', 'groesse', 'statur', 'haut', 'haar', 'oberteil',
  'darunter', 'unterteil', 'schuhe', 'kopf', 'zubehoer', 'merkmale', 'quelle', 'erfunden',
];
const _teile = ['haar', 'oberteil', 'darunter', 'unterteil', 'schuhe'];

/// Reihenfolge laut Auftrag: BW, dann R01 … R20.
final _reihenfolge = ['BW', for (var i = 1; i <= 20; i++) 'R${i.toString().padLeft(2, '0')}'];

/// Leitplanken (Auftrag A-601a, Abschnitt 8): ganze Wörter, ohne Groß-/Kleinschreibung.
const _verboten = [
  'Wein', 'Bier', 'Met', 'Sekt', 'Schnaps', 'Glühwein', 'Likör', 'Cocktail', 'Bar', 'Kneipe',
  'Prost', 'anstoßen', 'betrunken', 'beschwipst', 'Kater', 'Promille', 'Rausch', 'Joint',
  'kiffen', 'Blut', 'Hexe', 'Walpurgis', 'Teufel',
];

/// Alle Datensatz-Kennungen aus dem Kanon und dem Overlay (Zeilen `@ID [O|G|L] | …`).
Set<String> _kanonKennungen() {
  final dateien = <File>[
    for (final f in Directory('../../krimidinner/spuk-im-gewoelbe/10_kanon').listSync())
      if (f is File && f.path.endsWith('.md')) f,
    File('../../nachtlauf/kanon/ANPASSUNG.md'),
  ];
  final zeile = RegExp(r'^@(\S+) \[', multiLine: true);
  final ids = <String>{};
  for (final datei in dateien) {
    for (final m in zeile.allMatches(datei.readAsStringSync())) {
      ids.add(m.group(1)!);
    }
  }
  return ids;
}

/// Kennung aus einem Quellenverweis wie `@R03-STAMM Kleidung` oder `@H-15 (Wanderstiefel)`.
String _kennung(String quelle) => quelle.split(' ').first.replaceFirst('@', '');

/// Sammelt alle Textwerte eines JSON-Baums (ohne Schlüssel).
void _textWerte(Object? knoten, List<String> sammler) {
  if (knoten is String) {
    sammler.add(knoten);
  } else if (knoten is List) {
    for (final e in knoten) {
      _textWerte(e, sammler);
    }
  } else if (knoten is Map) {
    for (final e in knoten.values) {
      _textWerte(e, sammler);
    }
  }
}

void main() {
  late Object? version;
  late List<Map<String, dynamic>> figuren;
  late Set<String> kanon;

  setUpAll(() {
    final daten =
        jsonDecode(File('data/figuren/rollen.json').readAsStringSync()) as Map<String, dynamic>;
    version = daten['version'];
    figuren = (daten['figuren'] as List).cast<Map<String, dynamic>>();
    kanon = _kanonKennungen();
  });

  Map<String, dynamic> finde(String id) => figuren.firstWhere((f) => f['id'] == id);

  test('JSON gültig, Version 1, 21 Einträge in Reihenfolge BW, R01 … R20', () {
    expect(version, 1);
    expect(figuren.length, 21);
    expect(figuren.map((f) => f['id']).toList(), _reihenfolge);
  });

  test('Pflichtfelder vorhanden, Werte aus den erlaubten Listen', () {
    for (final f in figuren) {
      final id = f['id'];
      for (final feld in _pflichtfelder) {
        expect(f.containsKey(feld), isTrue, reason: '$id: Feld "$feld" fehlt');
      }
      expect(_geschlechter, contains(f['geschlecht']), reason: '$id: geschlecht');
      expect(_statur, contains(f['statur']), reason: '$id: statur');
      final haar = f['haar'] as Map<String, dynamic>;
      expect(_frisuren, contains(haar['frisur']), reason: '$id: haar.frisur');
      expect(_baerte, contains(haar['bart']), reason: '$id: haar.bart');
      expect(_oberteile, contains((f['oberteil'] as Map)['typ']), reason: '$id: oberteil.typ');
      expect(_darunter, contains((f['darunter'] as Map)['typ']), reason: '$id: darunter.typ');
      expect(_unterteile, contains((f['unterteil'] as Map)['typ']), reason: '$id: unterteil.typ');
      expect(_schuhe, contains((f['schuhe'] as Map)['typ']), reason: '$id: schuhe.typ');
      expect(_koepfe, contains(f['kopf']), reason: '$id: kopf');
      for (final z in f['zubehoer'] as List) {
        expect(_zubehoer, contains(z), reason: '$id: zubehoer "$z"');
      }
    }
  });

  test('Rampen und Stufen 0–7, haut 2–6 (Rampe 7), groesse 1,50–1,95 m', () {
    for (final f in figuren) {
      final id = f['id'];
      for (final teil in _teile) {
        final m = f[teil] as Map<String, dynamic>;
        expect(m['rampe'], inInclusiveRange(0, 7), reason: '$id: $teil.rampe');
        expect(m['stufe'], inInclusiveRange(0, 7), reason: '$id: $teil.stufe');
      }
      expect(f['haut'], inInclusiveRange(2, 6), reason: '$id: haut');
      expect(f['groesse'], inInclusiveRange(1.50, 1.95), reason: '$id: groesse');
    }
  });

  test('Grün (Rampe 5) tragen nur R03 Merle und R04 Jonas', () {
    for (final f in figuren) {
      final id = f['id'];
      if (id == 'R03' || id == 'R04') {
        expect((f['oberteil'] as Map)['rampe'], 5, reason: '$id: Grün im Oberteil');
      } else {
        final traegtGruen = _teile.any((t) => (f[t] as Map)['rampe'] == 5);
        expect(traegtGruen, isFalse, reason: '$id: darf keine Rampe 5 (Grün) tragen');
      }
    }
  });

  test('Merle und Jonas: gleicher Schuhtyp wanderstiefel mit gleicher Rampe/Stufe', () {
    expect(finde('R03')['schuhe'], equals(finde('R04')['schuhe']));
    expect((finde('R03')['schuhe'] as Map)['typ'], 'wanderstiefel');
  });

  test('Wanderstiefel nur bei R03 und R04 (Sohlen-Indiz H-15)', () {
    for (final f in figuren.where((f) => f['id'] != 'R03' && f['id'] != 'R04')) {
      expect((f['schuhe'] as Map)['typ'], isNot('wanderstiefel'),
          reason: '${f['id']} trägt Wanderstiefel');
    }
  });

  test('Rojda trägt sneaker, Adnan arbeitsschuhe', () {
    expect((finde('R02')['schuhe'] as Map)['typ'], 'sneaker');
    expect((finde('R01')['schuhe'] as Map)['typ'], 'arbeitsschuhe');
  });

  test('jede quelle nennt existierende Datensatz-IDs (Kanon und Overlay)', () {
    for (final f in figuren) {
      for (final q in (f['quelle'] as List).cast<String>()) {
        expect(q, startsWith('@'), reason: '${f['id']}: quelle "$q"');
        expect(kanon, contains(_kennung(q)), reason: '${f['id']}: unbekannte ID in "$q"');
      }
    }
  });

  test('zustand: Uhrzeit HH:MM, Quelle ist eine bekannte Kennung', () {
    final zeit = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');
    for (final f in figuren) {
      final zustand = (f['zustand'] as List?) ?? const [];
      for (final z in zustand.cast<Map<String, dynamic>>()) {
        expect(z['ab'], matches(zeit), reason: '${f['id']}: ab "${z['ab']}"');
        expect(kanon, contains(_kennung(z['quelle'] as String)),
            reason: '${f['id']}: zustand-quelle "${z['quelle']}"');
      }
    }
  });

  test('Leitplanken: keine verbotenen Wörter in den Texten', () {
    for (final f in figuren) {
      final texte = <String>[];
      _textWerte(f, texte);
      for (final wort in _verboten) {
        final muster = RegExp('(?<!\\p{L})${RegExp.escape(wort)}(?!\\p{L})',
            caseSensitive: false, unicode: true);
        for (final t in texte) {
          expect(muster.hasMatch(t), isFalse, reason: '${f['id']}: "$wort" in "$t"');
        }
      }
    }
  });
}

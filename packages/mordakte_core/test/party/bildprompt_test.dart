// F3-BAUMEISTER-02: Bildprompts für Personen, Räume und Spuren (TON-LEITFADEN §9).
// Rot-Probe: BILD_JSON=<pfad> prüft eine andere bild.json, etwa eine Kopie mit gekürzter Negativliste.
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

/// Stilanker und Negativliste, wortgleich aus TON-LEITFADEN §9.
const _stil = 'cinematic documentary film still, 35mm, natural dramatic lighting, real-life texture, no CGI, no cartoon';
const _negativ =
    'no text, no letters, no logos, no brand names, no real people, no celebrities, no alcohol, no wine, no beer, no bottles, no bar counter, no barrels, no cigarettes, no smoke from pipes, no vape, no blood, no injuries';

/// Herkunfts-, Religions- und Ethnienwörter, englisch und deutsch, nur als ganze Wörter.
const _verboteneHerkunft = {
  'german', 'germany', 'turkish', 'turkey', 'turk', 'polish', 'poland', 'bosnian', 'bosnia', 'kurdish', 'kurd',
  'immigrant', 'migrant', 'refugee', 'foreigner', 'origin', 'heritage', 'muslim', 'islam', 'christian', 'jewish',
  'jew', 'catholic', 'protestant', 'religious', 'religion', 'hijab', 'burqa', 'burka', 'niqab', 'mosque', 'church',
  'ethnic', 'ethnicity', 'race', 'racial', 'arab', 'african', 'asian', 'european', 'caucasian', 'oriental', 'foreign',
  'deutsch', 'türkisch', 'polnisch', 'bosnisch', 'kurdisch', 'muslimisch', 'kopftuch', 'herkunft',
};

/// Das Wort im Prompt, das zu look.kopf gehört (none hat keines).
const _kopfWort = {'kopftuch': 'headscarf', 'detektivhut': 'hat', 'cap': 'cap', 'bun': 'bun'};

/// Das Wort im Prompt, das zu look.statur gehört („… build“).
const _staturWort = {'slim': 'slim', 'normal': 'average', 'broad': 'broad', 'tall': 'tall', 'small': 'small'};

void main() {
  final pfad = Platform.environment['BILD_JSON'] ?? '$repoWurzel/content/party/schlosskeller/bild.json';
  final bild = leseJson(pfad);
  final prompts = bildprompts(kanon, bild);
  final personen = [for (final p in prompts) if (p.art == 'person') p];
  final raeume = [for (final p in prompts) if (p.art == 'raum') p];
  final beweise = [for (final p in prompts) if (p.art == 'beweis') p];

  test('Anzahl: 23 Personenprompts (Detektiv m und w), 7 Räume, 12 Spuren', () {
    expect(personen, hasLength(23));
    expect(raeume, hasLength(7));
    expect(beweise, hasLength(12));
  });

  test('jede Person hat genau einen Prompt, der Detektiv zwei (m und w)', () {
    for (final f in _figuren()) {
      for (final id in _kennungen(f)) {
        expect(personen.where((p) => p.id == id), hasLength(1), reason: id);
      }
    }
    expect(prompts.map((p) => p.id).toSet(), hasLength(prompts.length), reason: 'Kennungen nicht eindeutig');
  });

  test('bild.json und Kanon nennen dieselben Personen und Räume', () {
    final kanonRaeume = [for (final r in kanon.json['raeume.json']!['rooms'] as List) (r as Map)['id']];
    expect(_nachId(bild['personen'] as List).keys.toSet(), kanon.personen.toSet());
    expect(_nachId(bild['raeume'] as List).keys.toSet(), kanonRaeume.toSet());
    expect(raeume.map((p) => p.id).toList(), kanonRaeume);
  });

  test('Stil und Negativliste wie im TON-LEITFADEN §9, wortgleich in jedem Prompt', () {
    expect(bild['stil'], _stil);
    expect(bild['negativ'], _negativ);
    for (final p in prompts) {
      expect(p.prompt, startsWith('$_stil. '), reason: p.id);
      expect(p.prompt, endsWith(' $_negativ'), reason: p.id);
    }
  });

  test('kein Prompt nennt Herkunft, Religion oder Ethnie', () {
    for (final p in prompts) {
      expect(_worte(p.prompt).intersection(_verboteneHerkunft), isEmpty, reason: p.id);
    }
  });

  test('kein Motiv enthält ein verbotenes Wort aus textregeln.json', () {
    final datei = File('$repoWurzel/content/party/textregeln.json');
    if (!datei.existsSync()) return;
    final regeln = leseJson(datei.path);
    final verboten = {
      for (final gruppe in (regeln['verboten'] as Map).values)
        for (final w in gruppe as List) (w as String).toLowerCase(),
    };
    final ausnahmen = {
      for (final a in regeln['ausnahmen'] as List)
        if (!(a as String).contains(':')) a.toLowerCase(),
    };
    for (final p in prompts) {
      final treffer = _worte(_motiv(p.prompt)).intersection(verboten).difference(ausnahmen);
      expect(treffer, isEmpty, reason: p.id);
    }
  });

  test('figuren_konsistenz: Farbname, Geschlecht, Kopf und Statur stehen im Prompt', () {
    for (final f in _figuren()) {
      final look = (f['look'] as Map).cast<String, Object?>();
      final farbe = farbnameFuer(f['colorCode'] as String);
      final geschlechter = f.containsKey('selectableGenders')
          ? (f['selectableGenders'] as List).cast<String>()
          : [f['geschlecht'] as String];
      for (final g in geschlechter) {
        final id = _kennungen(f)[geschlechter.indexOf(g)];
        final p = personen.singleWhere((p) => p.id == id);
        // Die Signaturfarbe steht an der Kleidung: am ersten Stück oder dort, wo bild.json `{farbe}` setzt (E-028, E-029).
        expect(p.prompt.substring(p.prompt.indexOf('wearing ')), contains('$farbe '), reason: id);
        expect(p.prompt, isNot(contains('{farbe}')), reason: id);
        expect(_worte(p.prompt), contains(g == 'w' ? 'woman' : 'man'), reason: id);
        final kopf = _kopfWort[look['kopf']];
        if (kopf != null) expect(_worte(p.prompt), contains(kopf), reason: '$id (kopf ${look['kopf']})');
        expect(p.prompt, contains('${_staturWort[look['statur']]} build'), reason: id);
      }
    }
  });

  test('Alter in bild.json passt zum Alter in figuren.json', () {
    final bildPersonen = _nachId(bild['personen'] as List);
    for (final f in _figuren()) {
      if (!f.containsKey('age')) continue;
      final id = f['id'] as String;
      final alter = bildPersonen[id]!['alter'] as String;
      expect(alter.replaceAll(' ', '-'), _altersphrase(f['age'] as int), reason: id);
    }
  });

  test('Farbtabelle: mindestens 30 Namen, gleich farbnamen.json, jede Farbe findet sich selbst', () {
    final datei = leseJson('$repoWurzel/content/party/farbnamen.json');
    final farben = [for (final f in datei['farben'] as List) (f as Map).cast<String, Object?>()];
    expect(farben.length, greaterThanOrEqualTo(30));
    expect(farben.map((f) => f['name']).toSet(), hasLength(farben.length), reason: 'Namen doppelt');
    expect({for (final f in farben) f['hex']: f['name']}, farbnamenTabelle);
    for (final e in farbnamenTabelle.entries) {
      expect(farbnameFuer(e.key), e.value, reason: e.key);
    }
  });

  test('bildprompts.json ist aktuell', () {
    final datei = File('$repoWurzel/content/party/schlosskeller/bildprompts.json');
    expect(datei.existsSync(), isTrue, reason: 'erzeugen mit: dart run bin/party_prompts.dart');
    final json = leseJson(datei.path);
    expect(json['hinweis'], 'Erzeugt, nicht von Hand ändern: dart run bin/party_prompts.dart');
    expect(json['prompts'], [for (final p in prompts) {'id': p.id, 'art': p.art, 'prompt': p.prompt}]);
  });
}

/// Figuren des Kanons: Detektiv, Opfer, 20 Rollen.
List<Map<String, Object?>> _figuren() => [
      kanon.figurenJson['detektiv'] as Map<String, Object?>,
      kanon.figurenJson['opfer'] as Map<String, Object?>,
      ...kanon.figuren,
    ];

/// Kennungen der Prompts einer Figur: der Detektiv je Geschlecht, sonst die Figur-Kennung.
List<String> _kennungen(Map<String, Object?> f) {
  final id = f['id'] as String;
  return f.containsKey('selectableGenders') ? [for (final g in f['selectableGenders'] as List) '${id}_$g'] : [id];
}

/// Kleingeschriebene Wörter eines Textes; Bindestriche verbinden („late-twenties“).
Set<String> _worte(String text) => {
      for (final m in RegExp(r'[\p{L}\p{N}]+(?:-[\p{L}\p{N}]+)*', unicode: true).allMatches(text.toLowerCase()))
        m.group(0)!,
    };

/// Der Prompt ohne Stilanker und Negativliste, also nur das Motiv.
String _motiv(String prompt) => prompt.replaceFirst(_stil, '').replaceFirst(_negativ, '');

/// Altersphrase in der Schreibweise der bild.json („early-sixties“): 0–3 early, 4–6 mid, 7–9 late.
String _altersphrase(int alter) {
  const dekaden = {2: 'twenties', 3: 'thirties', 4: 'forties', 5: 'fifties', 6: 'sixties', 7: 'seventies'};
  final stufe = switch (alter % 10) {
    <= 3 => 'early',
    <= 6 => 'mid',
    _ => 'late',
  };
  return '$stufe-${dekaden[alter ~/ 10]}';
}

/// Einträge einer bild.json-Liste nach `id`.
Map<String, Map<String, Object?>> _nachId(List liste) {
  final ausgabe = <String, Map<String, Object?>>{};
  for (final e in liste) {
    final m = (e as Map).cast<String, Object?>();
    ausgabe[m['id'] as String] = m;
  }
  return ausgabe;
}

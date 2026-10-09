// Bildprompts des Partymodus (F3-BAUMEISTER-02, TON-LEITFADEN §9): englische Prompts für Personen,
// Räume und beweisrelevante Spuren. Stil, Negativliste und Beschreibungen stehen in bild.json,
// die Statur in figuren.json, der Farbname kommt aus der Tabelle unten.
import 'farbe.dart';
import 'kanon/kanon.dart';

/// Ein Bildprompt. `art` ist `person`, `raum` oder `beweis`; `id` ist die Kennung der Figur,
/// des Raums oder der Spur. Der Detektiv hat `detective_m` und `detective_w`.
class Bildprompt {
  final String id;
  final String art;
  final String prompt;

  const Bildprompt({required this.id, required this.art, required this.prompt});
}

/// Feste Farbtabelle Hex → englischer Name. Spiegel von content/party/farbnamen.json;
/// test/party/bildprompt_test.dart prüft die Gleichheit.
const Map<String, String> farbnamenTabelle = {
  '#000000': 'black',
  '#36454F': 'charcoal',
  '#808080': 'grey',
  '#5F6B7A': 'slate grey',
  '#C0C0C0': 'silver',
  '#D3D3D3': 'light grey',
  '#FFFFFF': 'white',
  '#FFFDD0': 'cream',
  '#F5F5DC': 'beige',
  '#C2B280': 'sand',
  '#D2B48C': 'tan',
  '#8B5A2B': 'brown',
  '#4A3224': 'dark brown',
  '#8B0000': 'dark red',
  '#C81E1E': 'red',
  '#DC143C': 'crimson',
  '#6B1D2F': 'dark berry red',
  '#800020': 'carmine red',
  '#800000': 'maroon',
  '#D2691E': 'rust orange',
  '#FF8C00': 'orange',
  '#FFD400': 'yellow',
  '#556B2F': 'olive',
  '#2F4F3F': 'dark green',
  '#008000': 'green',
  '#3EB489': 'mint green',
  '#008080': 'teal',
  '#1F3A5F': 'navy',
  '#0000FF': 'blue',
  '#3E5573': 'steel blue',
  '#4F7BAA': 'dove blue',
  '#2B4C7E': 'denim blue',
  '#4169E1': 'royal blue',
  '#ADD8E6': 'light blue',
  '#800080': 'purple',
  '#8F00FF': 'violet',
  '#8E4585': 'plum',
  '#FFC0CB': 'pink',
  '#F4C2C2': 'pastel pink',
};

/// Statur aus look.statur (figuren.json) als Wortgruppe im Prompt.
const Map<String, String> _statur = {
  'slim': 'slim build',
  'normal': 'average build',
  'broad': 'broad build',
  'tall': 'tall build',
  'small': 'small build',
};

/// Englischer Farbname zu einem Hex-Wert: der Name mit dem kleinsten Abstand
/// (CIEDE2000 im Lab-Raum). Bei Gleichstand gewinnt der frühere Eintrag der Tabelle.
String farbnameFuer(String hex) {
  final lab = labAusHex(hex);
  var bester = '';
  var besterAbstand = double.infinity;
  for (final e in farbnamenTabelle.entries) {
    final abstand = deltaE2000Lab(lab, labAusHex(e.key));
    if (abstand < besterAbstand) {
      bester = e.value;
      besterAbstand = abstand;
    }
  }
  return bester;
}

/// Alle Bildprompts: Personen (Detektiv je m und w), Räume aus raeume.json, Spuren aus bild.json.
List<Bildprompt> bildprompts(Kanon kanon, Map<String, Object?> bild) {
  final stil = bild['stil'] as String;
  final negativ = bild['negativ'] as String;
  final personen = _nachId(bild['personen'] as List);
  final raeume = _nachId(bild['raeume'] as List);
  final prompts = <Bildprompt>[];

  final figuren = [
    kanon.figurenJson['detektiv'] as Map<String, Object?>,
    kanon.figurenJson['opfer'] as Map<String, Object?>,
    ...kanon.figuren,
  ];
  for (final f in figuren) {
    final id = f['id'] as String;
    final eintrag = personen[id] ?? (throw StateError('bild.json: keine Beschreibung für Person $id'));
    final waehlbar = f.containsKey('selectableGenders');
    final geschlechter = waehlbar
        ? [for (final g in f['selectableGenders'] as List) g as String]
        : [f['geschlecht'] as String];
    for (final g in geschlechter) {
      prompts.add(Bildprompt(
        id: waehlbar ? '${id}_$g' : id,
        art: 'person',
        prompt: _prompt(stil, _personMotiv(f, eintrag, g), negativ),
      ));
    }
  }

  for (final r in kanon.json['raeume.json']!['rooms'] as List) {
    final id = (r as Map)['id'] as String;
    final eintrag = raeume[id] ?? (throw StateError('bild.json: keine Beschreibung für Raum $id'));
    prompts.add(Bildprompt(
      id: id,
      art: 'raum',
      prompt: _prompt(stil, eintrag['beschreibung'] as String, negativ),
    ));
  }

  for (final b in bild['beweise'] as List) {
    final m = (b as Map).cast<String, Object?>();
    prompts.add(Bildprompt(
      id: m['spur'] as String,
      art: 'beweis',
      prompt: _prompt(stil, m['beschreibung'] as String, negativ),
    ));
  }
  return prompts;
}

/// Motiv einer Person nach TON-LEITFADEN §9: Alter, Geschlecht, Haar, Kopf, Statur,
/// Kleidung in Farbe, Merkmal, Haltung, Ort und Licht.
String _personMotiv(Map<String, Object?> figur, Map<String, Object?> eintrag, String geschlecht) {
  final alter = eintrag['alter'] as String;
  final kopf = eintrag['kopf'] as String;
  final kleidung = eintrag['kleidung'] as String;
  final look = figur['look'] as Map;
  final wort = switch (geschlecht) {
    'w' => 'woman',
    'm' => 'man',
    _ => 'person',
  };
  final farbe = farbnameFuer(figur['colorCode'] as String);
  return [
    'portrait of ${_artikel(alter)} ${alter.replaceAll(' ', '-')} $wort',
    eintrag['haar'] as String,
    if (kopf != 'no headwear') kopf,
    _statur[look['statur']] ?? (throw StateError('Statur unbekannt: ${look['statur']}')),
    'wearing ${_eingefaerbt(kleidung, farbe)}',
    eintrag['merkmal'] as String,
    eintrag['haltung'] as String,
    'in a vaulted castle cellar at night, warm candle light',
  ].join(', ');
}

/// Die Signaturfarbe gehört zum ersten Kleidungsstück (E-028): `{farbe}` in
/// der Kleidung wird ersetzt, sonst steht die Farbe vor dem ersten Stück.
String _eingefaerbt(String kleidung, String farbe) => kleidung.contains('{farbe}') ? kleidung.replaceAll('{farbe}', farbe) : '$farbe $kleidung';

/// Unbestimmter Artikel vor dem Alter („an early-sixties“, „a late-twenties“).
String _artikel(String wort) => RegExp('^[aeiou]').hasMatch(wort) ? 'an' : 'a';

/// Prompt = Stilanker, Motiv, Negativliste. Stil und Negativliste bleiben wortgleich.
String _prompt(String stil, String motiv, String negativ) => '${_ohnePunkt(stil)}. ${_ohnePunkt(motiv)}. $negativ';

String _ohnePunkt(String text) => text.trim().replaceFirst(RegExp(r'\.$'), '');

/// Einträge der bild.json-Liste, nach `id` geordnet.
Map<String, Map<String, Object?>> _nachId(List liste) {
  final ausgabe = <String, Map<String, Object?>>{};
  for (final e in liste) {
    final m = (e as Map).cast<String, Object?>();
    ausgabe[m['id'] as String] = m;
  }
  return ausgabe;
}

import 'dart:convert';
import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:test/test.dart';

/// Maschinelle Abnahme der Wohn- und Werkstatt-Innenräume (Auftrag A-303b, Abschnitt 9).
const _datei = 'data/innenraeume/haeuser.json';

/// Die 30 vorgesehenen Bereiche.
final _soll = <String>{
  for (var i = 1; i <= 10; i++) 'innen-wohnstube-$i',
  for (var i = 1; i <= 6; i++) 'innen-werkstatt-$i',
  for (var i = 1; i <= 6; i++) 'innen-laden-$i',
  for (var i = 1; i <= 4; i++) 'innen-speicher-$i',
  for (var i = 1; i <= 4; i++) 'innen-zunftstube-$i',
};

/// Erlaubte Objektformen (FORMAT-BEREICHE.md).
const _formen = <String>{
  'tisch', 'stuhl', 'bank', 'regal', 'truhe', 'kasten', 'kiste', 'fass', 'bett', 'ofen', 'kamin',
  'theke', 'vitrine', 'kessel', 'wand', 'saeule', 'tuerdeko', 'brunnen',
};

/// Verbotswörter der Leitplanken und Gegenstände des Falls; nur ganze Wörter zählen.
const _verboten = <String>[
  'Wein', 'Bier', 'Met', 'Sekt', 'Schnaps', 'Glühwein', 'Likör', 'Cocktail', 'Bar', 'Kneipe',
  'Prost', 'anstoßen', 'betrunken', 'beschwipst', 'Kater', 'Promille', 'Rausch', 'Joint', 'kiffen',
  'Alkohol', 'Blut', 'Hexe', 'Teufel', 'Walpurgis', 'Vampir', 'Leiche', 'Gasthaus', 'Taverne',
  'Brauerei', 'Wirt', 'Wirtin', 'Drink', 'Gelage', 'Clan',
  'Taler', 'Schlüsselbund', 'Schlüssel', 'Laken', 'Leinen', 'Kerzenständer', 'Zettel', 'Stablampe',
  'Taschenlampe', 'Batterie', 'Wachsabdruck', 'Wachsspritzer', 'Gespenst', 'Merle', 'Jonas', 'Adnan',
  'Rojda',
];

const _richtungen = [(1, 0), (-1, 0), (0, 1), (0, -1)];

RegExp _ganzesWort(String wort) =>
    RegExp('(?<!\\p{L})${RegExp.escape(wort)}(?!\\p{L})', caseSensitive: false, unicode: true);

bool _istMarke(String c) => RegExp(r'^[a-z]$').hasMatch(c);

/// Namen aus dem Enum TexturId in pixel_engine (per Regex gelesen).
Set<String> _texturNamen() {
  final wurzel = findeRepoWurzel();
  if (wurzel == null) fail('Repo-Wurzel nicht gefunden');
  final text = File('$wurzel/packages/pixel_engine/lib/src/kit/texturen.dart').readAsStringSync();
  final block = RegExp(r'enum TexturId \{(.*?)\}', dotAll: true).firstMatch(text)!.group(1)!;
  return {for (final m in RegExp(r'^\s*([a-zA-Z]\w*),', multiLine: true).allMatches(block)) m.group(1)!};
}

/// Marke, die orthogonal direkt vor einer Tür des Bereichs liegt (Ankunft von außen).
(int, int)? _markeVor(Bereich b, Ding tuer) {
  for (var z = tuer.z0; z <= tuer.z1; z++) {
    for (var x = tuer.x0; x <= tuer.x1; x++) {
      for (final (dx, dz) in _richtungen) {
        final nx = x + dx, nz = z + dz;
        final c = b.zeichen(nx, nz);
        if (_istMarke(c) && b.marken[c] == (nx, nz)) return (nx, nz);
      }
    }
  }
  return null;
}

/// Flutfüllung über begehbare Kacheln ab [start]; Türen werden nicht überschritten.
Set<int> _erreichbar(Bereich b, (int, int) start) {
  final besucht = <int>{};
  final offen = <(int, int)>[start];
  while (offen.isNotEmpty) {
    final (x, z) = offen.removeLast();
    if (!besucht.add(z * b.breite + x)) continue;
    for (final (dx, dz) in _richtungen) {
      final nx = x + dx, nz = z + dz;
      if (nx >= 0 && nz >= 0 && nx < b.breite && nz < b.tiefe && b.begehbar(nx, nz)) {
        offen.add((nx, nz));
      }
    }
  }
  return besucht;
}

/// Pseudo-Bereich „stadt“: je Außentür eine Marke `tuer-<raum-id>`.
Bereich _stadt(List<Bereich> alle) {
  final s = Bereich(
    id: 'stadt',
    name: 'Stadt',
    innen: false,
    karte: ['.' * alle.length],
    legende: <String, Legende>{},
  );
  for (var i = 0; i < alle.length; i++) {
    s.marken['tuer-${alle[i].id}'] = (i, 0);
  }
  return s;
}

void main() {
  final inhalt = File(_datei).readAsStringSync();
  final daten = jsonDecode(inhalt) as Map<String, dynamic>;
  final bereiche = [
    for (final e in daten['bereiche'] as List) Bereich.ausJson(e as Map<String, dynamic>),
  ];
  final nachId = {for (final b in bereiche) b.id: b};
  final texturen = _texturNamen();

  test('JSON lädt über Bereich.ausJson: genau 30 Bereiche mit den vorgesehenen IDs', () {
    expect(bereiche, hasLength(30));
    expect(nachId.keys.toSet(), _soll);
  });

  test('Karten: alle Zeilen gleich breit, je Seite 8–28 Kacheln', () {
    for (final b in bereiche) {
      for (final z in b.karte) {
        expect(z.length, b.breite, reason: '${b.id}: ungleiche Zeilenbreite');
      }
      expect(b.breite, greaterThanOrEqualTo(8), reason: '${b.id}: zu schmal');
      expect(b.breite, lessThanOrEqualTo(28), reason: '${b.id}: zu breit');
      expect(b.tiefe, greaterThanOrEqualTo(8), reason: '${b.id}: zu flach');
      expect(b.tiefe, lessThanOrEqualTo(28), reason: '${b.id}: zu tief');
    }
  });

  test('Jedes Zeichen hat Legende; die 30 Karten sind verschieden', () {
    for (final b in bereiche) {
      for (final z in b.karte) {
        for (final c in z.split('')) {
          if ('#. '.contains(c) || _istMarke(c)) continue;
          expect(b.legende.containsKey(c), isTrue, reason: '${b.id}: Zeichen „$c“ ohne Legende');
        }
      }
    }
    expect(bereiche.map((b) => b.karte.join('\n')).toSet(), hasLength(30));
  });

  test('Türen: Ziel stadt, Zielmarke tuer-<raum-id>, Marke direkt davor im eigenen Bereich', () {
    for (final b in bereiche) {
      final tueren = b.dinge.where((d) => d.legende.art == KachelArt.tuer).toList();
      expect(tueren, isNotEmpty, reason: '${b.id}: keine Tür');
      for (final d in tueren) {
        expect(d.legende.ziel, 'stadt', reason: '${b.id}: Ziel der Tür');
        expect(d.legende.zielMarke, 'tuer-${b.id}', reason: '${b.id}: Zielmarke der Tür');
        expect(_markeVor(b, d), isNotNull, reason: '${b.id}: keine Marke direkt vor der Tür');
      }
    }
  });

  test('Welt mit Pseudo-Bereich „stadt“ ist ohne Befund', () {
    final welt = Welt({...nachId, 'stadt': _stadt(bereiche)});
    expect(welt.pruefe(), isEmpty);
  });

  test('Flutfüllung: alle begehbaren Kacheln und jede Station von der Eingangsmarke erreichbar', () {
    for (final b in bereiche) {
      final tueren = b.dinge.where((d) => d.legende.art == KachelArt.tuer).toList();
      final start = tueren.isEmpty ? null : _markeVor(b, tueren.first);
      expect(start, isNotNull, reason: '${b.id}: keine Eingangsmarke');
      if (start == null) continue;
      final besucht = _erreichbar(b, start);
      for (var z = 0; z < b.tiefe; z++) {
        for (var x = 0; x < b.breite; x++) {
          if (b.begehbar(x, z)) {
            expect(besucht.contains(z * b.breite + x), isTrue, reason: '${b.id}: Kachel $x/$z unerreichbar');
          }
        }
      }
      for (final d in b.dinge.where((d) => d.legende.station != null)) {
        final kacheln = [
          for (var z = d.z0; z <= d.z1; z++)
            for (var x = d.x0; x <= d.x1; x++) z * b.breite + x,
        ];
        expect(kacheln.any((k) => besucht.contains(k)), isTrue,
            reason: '${b.id}: Station ${d.legende.station} unerreichbar');
      }
    }
  });

  test('Texturen existieren in TexturId; Objektformen laut FORMAT', () {
    for (final b in bereiche) {
      for (final t in [b.wandTextur, b.bodenTextur, b.deckenTextur]) {
        expect(texturen, contains(t), reason: '${b.id}: Textur $t');
      }
      for (final l in b.legende.values) {
        if (l.textur != null) expect(texturen, contains(l.textur), reason: '${b.id}: Textur ${l.textur}');
        if (l.art == KachelArt.objekt) expect(_formen, contains(l.form), reason: '${b.id}: Form ${l.form}');
      }
    }
  });

  test('Leitplanken: keine Verbotswörter und keine gesperrten Gegenstände in Namen', () {
    final befunde = <String>[];
    for (final b in bereiche) {
      final namen = [b.name, for (final l in b.legende.values) l.name];
      for (final n in namen) {
        for (final wort in _verboten) {
          if (_ganzesWort(wort).hasMatch(n)) befunde.add('${b.id}: „$n“ enthält $wort');
        }
      }
    }
    expect(befunde, isEmpty);
  });

  test('Leitplanken-Scanner meldet im Datenbestand keinen Fehler', () {
    final fehler = scanneText(inhalt, datei: _datei).where((t) => t.fehler).map((t) => t.toString());
    expect(fehler, isEmpty);
  });

  test('Stromausfall: Raumhöhe 2,4–3,4 m, grundKalt 0,03–0,08, je Raum eine Lichtquelle', () {
    for (final b in bereiche) {
      expect(b.raumHoehe, greaterThanOrEqualTo(2.4), reason: '${b.id}: Raumhöhe');
      expect(b.raumHoehe, lessThanOrEqualTo(3.4), reason: '${b.id}: Raumhöhe');
      expect(b.grundKalt, greaterThanOrEqualTo(0.03), reason: '${b.id}: grundKalt');
      expect(b.grundKalt, lessThanOrEqualTo(0.08), reason: '${b.id}: grundKalt');
      expect(b.legende.values.any((l) => l.lichtWarm > 0 || l.lichtKalt > 0), isTrue,
          reason: '${b.id}: keine Lichtquelle');
    }
  });
}

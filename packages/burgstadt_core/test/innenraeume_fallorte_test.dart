import 'dart:convert';
import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:test/test.dart';

/// Die zwölf Fall-Orte (IDs fest, Auftrag A-303a).
const _ids = <String>[
  'innen-uhrturm', 'innen-museum', 'innen-pension', 'innen-schreinerei',
  'innen-fundus', 'innen-stromhaus', 'innen-teestube', 'innen-baeckerei',
  'innen-rathaus', 'innen-bibliothek', 'innen-apotheke', 'innen-kirche',
];

/// Fundstellen: Kennung → Raum. Jeder Fall-Ort hat eine Station (Stadt-Hinweise H-S, A-401a).
const _stationen = <String, String>{
  'ORT-01': 'innen-uhrturm',
  'ORT-02': 'innen-museum',
  'ORT-03': 'innen-pension',
  'ORT-04': 'innen-schreinerei',
  'ORT-05': 'innen-fundus',
  'ORT-06': 'innen-stromhaus',
  'ORT-07': 'innen-teestube',
  'ORT-08': 'innen-baeckerei',
  'ORT-09': 'innen-rathaus',
  'ORT-10': 'innen-bibliothek',
  'ORT-11': 'innen-apotheke',
  'ORT-12': 'innen-kirche',
};

/// Objektformen laut FORMAT-BEREICHE.md.
const _formen = <String>{
  'tisch', 'stuhl', 'bank', 'regal', 'truhe', 'kasten', 'kiste', 'fass', 'bett',
  'ofen', 'kamin', 'theke', 'vitrine', 'kessel', 'wand', 'saeule', 'tuerdeko', 'brunnen',
};

/// Lösungsrelevante Gegenstände, die der Auftrag ausdrücklich verbietet.
const _verboteneGegenstaende = <String>[
  'taler', 'schlüssel', 'laken', 'kerzenständer', 'zettel', 'stablampe', 'taschenlampe',
];

const _richtungen = [(1, 0), (-1, 0), (0, 1), (0, -1)];

bool _markenZeichen(String c) => RegExp(r'^[a-z]$').hasMatch(c);

/// Marke direkt vor einer Tür: ein Nachbar der Tür ist eine Marke, und auf der
/// Gegenseite liegt nichts Begehbares (also innen, Ankunft von außen).
(int, int)? _markeVorTuer(Bereich b, Ding d) {
  for (var z = d.z0; z <= d.z1; z++) {
    for (var x = d.x0; x <= d.x1; x++) {
      for (final (dx, dz) in _richtungen) {
        final nx = x + dx, nz = z + dz;
        if (_markenZeichen(b.zeichen(nx, nz)) && !b.begehbar(x - dx, z - dz)) {
          return (nx, nz);
        }
      }
    }
  }
  return null;
}

(int, int)? _eingangsMarke(Bereich b) {
  for (final d in b.dinge) {
    if (d.legende.art == KachelArt.tuer) {
      final m = _markeVorTuer(b, d);
      if (m != null) return m;
    }
  }
  return null;
}

/// Flutfüllung über begehbare Kacheln ab [start].
Set<(int, int)> _erreichbar(Bereich b, (int, int) start) {
  final besucht = <(int, int)>{};
  final offen = <(int, int)>[start];
  while (offen.isNotEmpty) {
    final p = offen.removeLast();
    if (!besucht.add(p)) continue;
    for (final (dx, dz) in _richtungen) {
      final n = (p.$1 + dx, p.$2 + dz);
      if (b.begehbar(n.$1, n.$2)) offen.add(n);
    }
  }
  return besucht;
}

/// Namen aller Texturen aus dem `enum TexturId` in pixel_engine.
Set<String> _texturNamen(String pfad) {
  final quelle = File(pfad).readAsStringSync();
  final block = RegExp(r'enum TexturId\s*\{([^}]*)\}').firstMatch(quelle);
  if (block == null) throw StateError('enum TexturId fehlt in $pfad');
  final ohneKommentare = block.group(1)!.replaceAll(RegExp(r'//[^\n]*'), '');
  return {
    for (final t in ohneKommentare.split(',')) if (t.trim().isNotEmpty) t.trim(),
  };
}

void main() {
  final wurzel = findeRepoWurzel()!;
  final text = File('$wurzel/packages/burgstadt_core/data/innenraeume/fallorte.json')
      .readAsStringSync();
  final json = jsonDecode(text) as Map<String, dynamic>;
  final bereiche = [
    for (final e in json['bereiche'] as List) Bereich.ausJson(e as Map<String, dynamic>),
  ];
  final nachId = {for (final b in bereiche) b.id: b};
  final texturen = _texturNamen('$wurzel/packages/pixel_engine/lib/src/kit/texturen.dart');

  test('Datei: Version 1, genau die zwölf Fall-Orte mit festen IDs', () {
    expect(json['version'], 1);
    expect(bereiche, hasLength(12));
    expect(nachId.keys, unorderedEquals(_ids));
  });

  test('Alle Zeilen einer Karte sind gleich breit', () {
    for (final b in bereiche) {
      for (final z in b.karte) {
        expect(z.length, b.breite, reason: '${b.id}: ungleiche Zeilenbreite');
      }
    }
  });

  test('Raumgröße 8–28 Kacheln je Seite, Raumhöhe 2,4–3,4 m, innen', () {
    for (final b in bereiche) {
      expect(b.breite, inInclusiveRange(8, 28), reason: '${b.id}: Breite');
      expect(b.tiefe, inInclusiveRange(8, 28), reason: '${b.id}: Tiefe');
      expect(b.raumHoehe, inInclusiveRange(2.4, 3.4), reason: '${b.id}: Raumhöhe');
      expect(b.innen, isTrue, reason: '${b.id}: innen');
    }
  });

  test('Drinnen nur Mondlicht als Grundhelligkeit (grundKalt 0,03–0,08)', () {
    for (final b in bereiche) {
      expect(b.grundKalt, inInclusiveRange(0.03, 0.08), reason: '${b.id}: grundKalt');
    }
  });

  test('Jedes Zeichen der Karte hat eine Legende (außer #, Boden, Leerzeichen, Marken)', () {
    for (final b in bereiche) {
      for (var z = 0; z < b.tiefe; z++) {
        for (var x = 0; x < b.breite; x++) {
          final c = b.zeichen(x, z);
          if (c == '#' || c == '.' || c == ' ' || _markenZeichen(c)) continue;
          expect(b.legende.containsKey(c), isTrue,
              reason: '${b.id}: Zeichen „$c“ bei $x/$z ohne Legende');
        }
      }
    }
  });

  test('Texturnamen existieren in TexturId', () {
    expect(texturen, hasLength(greaterThan(30)));
    for (final b in bereiche) {
      for (final t in [b.wandTextur, b.bodenTextur, b.deckenTextur]) {
        expect(texturen, contains(t), reason: '${b.id}: Textur $t');
      }
      for (final l in b.legende.values) {
        final t = l.textur;
        if (t != null) {
          expect(texturen, contains(t), reason: '${b.id}: Textur $t bei „${l.name}“');
        }
      }
    }
  });

  test('Objektformen gehören zum eingefrorenen Format', () {
    for (final b in bereiche) {
      for (final l in b.legende.values) {
        if (l.art == KachelArt.objekt) {
          expect(_formen, contains(l.form), reason: '${b.id}: Form „${l.form}“ bei „${l.name}“');
        }
      }
    }
  });

  test('Jede Tür ist eine Außentür (ziel stadt, zielMarke tuer-<raum-id>) mit Marke davor', () {
    for (final b in bereiche) {
      final tueren = b.dinge.where((d) => d.legende.art == KachelArt.tuer).toList();
      expect(tueren, isNotEmpty, reason: '${b.id}: mindestens eine Tür');
      for (final d in tueren) {
        final l = d.legende;
        expect(l.ziel, 'stadt', reason: '${b.id}: Tür „${l.name}“ zielt nicht auf stadt');
        expect(l.zielMarke, 'tuer-${b.id}', reason: '${b.id}: Zielmarke der Tür „${l.name}“');
        expect(_markeVorTuer(b, d), isNotNull,
            reason: '${b.id}: Tür „${l.name}“ hat keine Marke direkt davor');
      }
    }
  });

  test('Ziel „stadt“: Pseudo-Bereich mit allen Marken tuer-* ergibt Welt.pruefe() leer', () {
    final stadt = Bereich(
      id: 'stadt',
      name: 'Stadt',
      innen: false,
      karte: const ['.'],
      legende: const {},
    );
    for (final id in _ids) {
      stadt.marken['tuer-$id'] = (0, 0);
    }
    final welt = Welt({...nachId, 'stadt': stadt});
    expect(welt.pruefe(), isEmpty);
  });

  test('Flutfüllung: alle begehbaren Kacheln und jede Station von der Eingangsmarke erreichbar', () {
    for (final b in bereiche) {
      final eingang = _eingangsMarke(b);
      expect(eingang, isNotNull, reason: '${b.id}: keine Eingangsmarke');
      final besucht = _erreichbar(b, eingang!);
      final begehbar = <(int, int)>{};
      for (var z = 0; z < b.tiefe; z++) {
        for (var x = 0; x < b.breite; x++) {
          if (b.begehbar(x, z)) begehbar.add((x, z));
        }
      }
      expect(besucht.containsAll(begehbar), isTrue,
          reason: '${b.id}: unerreichbare Kacheln ${begehbar.difference(besucht)}');
      for (final d in b.dinge.where((d) => d.legende.station != null)) {
        for (var z = d.z0; z <= d.z1; z++) {
          for (var x = d.x0; x <= d.x1; x++) {
            expect(besucht.contains((x, z)), isTrue,
                reason: '${b.id}: Station ${d.legende.station} unerreichbar');
          }
        }
      }
    }
  });

  test('Fundstellen: genau ORT-01 bis ORT-12 in den vorgesehenen Räumen, begehbar', () {
    final gefunden = <String, String>{};
    for (final b in bereiche) {
      for (final d in b.dinge) {
        final k = d.legende.station;
        if (k == null) continue;
        expect(d.legende.art, KachelArt.station, reason: '${b.id}: Station $k muss begehbar sein');
        gefunden[k] = b.id;
      }
    }
    expect(gefunden, equals(_stationen));
  });

  test('Keine Lichtquellen außer Kerze, Ofen und Notleuchte (Strom ist aus)', () {
    final muster = RegExp(r'kerze|ofen|notleuchte|notdienstlampe', caseSensitive: false);
    for (final b in bereiche) {
      for (final l in b.legende.values) {
        if (l.lichtWarm > 0 || l.lichtKalt > 0) {
          expect(muster.hasMatch(l.name), isTrue, reason: '${b.id}: Lichtquelle „${l.name}“');
        }
      }
    }
  });

  test('Leitplanken: keine Verbotswörter (ganze Wörter) in Namen', () {
    final namen = [
      for (final b in bereiche) ...[b.name, for (final l in b.legende.values) l.name],
    ];
    final treffer = [for (final n in namen) ...scanneText(n)];
    expect(treffer, isEmpty, reason: treffer.join('\n'));
  });

  test('Leitplanken: die ganze Datei ist frei von Verbotswörtern (Scanner A-406)', () {
    expect(scanneText(text, datei: 'fallorte.json'), isEmpty);
  });

  test('Keine lösungsrelevanten Gegenstände in Namen (Taler, Schlüsselbund, Laken, …)', () {
    for (final b in bereiche) {
      for (final n in [b.name, for (final l in b.legende.values) l.name]) {
        final klein = n.toLowerCase();
        for (final w in _verboteneGegenstaende) {
          expect(klein.contains(w), isFalse, reason: '${b.id}: „$n“ enthält „$w“');
        }
      }
    }
  });
}

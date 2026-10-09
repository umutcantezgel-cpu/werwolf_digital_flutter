import 'dart:convert';
import 'dart:io';

import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// Tutorial- und Erzähler-Texte (Auftrag A-602a): Format, Längen, Leitplanken,
/// Pixelschrift, Rollennamen der Clique und verbotene Wörter.
void main() {
  final wurzel = findeRepoWurzel()!;
  final ordner = '$wurzel/packages/burgstadt_spiel/data/texte';
  final tutorialRoh = File('$ordner/tutorial.json').readAsStringSync();
  final erzaehlerRoh = File('$ordner/erzaehler.json').readAsStringSync();
  final tutorial = jsonDecode(tutorialRoh) as Map<String, dynamic>;
  final erzaehler = jsonDecode(erzaehlerRoh) as Map<String, dynamic>;
  final dateien = {'tutorial.json': tutorialRoh, 'erzaehler.json': erzaehlerRoh};
  final schritte = (tutorial['schritte'] as List).cast<Map<String, dynamic>>();
  final uhrturm = erzaehler['uhrturm'] as Map<String, dynamic>;
  final orte = erzaehler['orte'] as Map<String, dynamic>;
  final laden = (erzaehler['laden'] as List).cast<String>();

  group('tutorial.json', () {
    const ausloeser = [
      'start', 'erste_bewegung', 'licht', 'erste_figur', 'gespraech', 'erste_station', //
      'erster_fund', 'blick', 'akte', 'heften', 'faden', 'teilen', 'lagerunde', //
      'phase2', 'stadt', 'anklage',
    ];

    test('Format und Version', () {
      expect(tutorial.keys.toSet(), {'version', 'schritte'});
      expect(tutorial['version'], 1);
      for (final s in schritte) {
        expect(s.keys.toSet(), {'id', 'ausloeser', 'titel', 'text', 'eingabe'}, reason: '${s['id']}');
        expect((s['eingabe'] as Map).keys.toSet(), {'touch', 'tastatur', 'gamepad'}, reason: '${s['id']}');
      }
    });

    test('14 bis 18 Schritte mit eindeutigen IDs', () {
      expect(schritte.length, inInclusiveRange(14, 18));
      final ids = schritte.map((s) => s['id'] as String).toList();
      expect(ids.toSet().length, ids.length);
      expect(ids.every((id) => RegExp(r'^T\d\d$').hasMatch(id)), isTrue);
    });

    test('Auslöser sind erlaubt und kommen höchstens einmal vor', () {
      final werte = schritte.map((s) => s['ausloeser'] as String).toList();
      for (final a in werte) {
        expect(ausloeser, contains(a));
      }
      expect(werte.toSet().length, werte.length, reason: 'Auslöser mehrfach');
    });

    test('Längen: Titel ≤ 28, Text und Eingabe ≤ 140, nicht leer', () {
      for (final s in schritte) {
        final titel = s['titel'] as String;
        expect(titel.isNotEmpty && titel.length <= 28, isTrue, reason: '${s['id']} Titel „$titel“');
        final text = s['text'] as String;
        expect(text.isNotEmpty && text.length <= 140, isTrue, reason: '${s['id']} Text „$text“');
        for (final e in (s['eingabe'] as Map).values.cast<String>()) {
          expect(e.isNotEmpty && e.length <= 140, isTrue, reason: '${s['id']} Eingabe „$e“');
        }
      }
    });
  });

  group('erzaehler.json', () {
    test('Format und Version', () {
      expect(erzaehler.keys.toSet(), {'version', 'uhrturm', 'orte', 'laden'});
      expect(erzaehler['version'], 1);
      expect(uhrturm.keys.toSet(), {'einfuehrung', 'phase1', 'phase2', 'phase3', 'morgengrauen'});
    });

    test('Uhrturm: 5 Einträge mit je 3 Varianten', () {
      expect(uhrturm.length, 5);
      for (final e in uhrturm.entries) {
        expect((e.value as List).length, 3, reason: e.key);
      }
    });

    test('Ortsansagen: 7 Burg-Bereiche und ORT-01…ORT-12 mit je 2 Varianten', () {
      final erwartet = {
        'gewoelbe', 'speisekammer', 'turm', 'hof', 'torhaus', 'wehrgang', 'stadt', //
        for (var i = 1; i <= 12; i++) 'ORT-${i.toString().padLeft(2, '0')}',
      };
      expect(erwartet.length, 19);
      expect(orte.keys.toSet(), erwartet);
      for (final e in orte.entries) {
        expect((e.value as List).length, 2, reason: e.key);
      }
    });

    test('15 Ladesprüche', () {
      expect(laden.length, 15);
    });

    test('Längen: alle Texte ≤ 140 Zeichen und nicht leer', () {
      for (final t in _alleTexte(erzaehler)) {
        expect(t.isNotEmpty && t.length <= 140, isTrue, reason: '„$t“');
      }
    });
  });

  group('Leitplanken, Schrift, Figuren und Stil', () {
    for (final e in dateien.entries) {
      test('${e.key}: Leitplanken-Scan ohne Fehler und Warnungen', () {
        final treffer = scanneText(e.value, datei: e.key);
        expect(treffer, isEmpty, reason: treffer.join('\n'));
      });
    }

    test('jedes Zeichen ist in der Pixelschrift', () {
      final font = BitmapFont.parse(kSchriftNormal);
      final alle = [..._alleTexte(tutorial), ..._alleTexte(erzaehler)];
      for (final t in alle) {
        for (final rune in t.runes) {
          expect(
            font.glyphs.containsKey(rune),
            isTrue,
            reason: 'Zeichen U+${rune.toRadixString(16).padLeft(4, '0')} fehlt in „$t“',
          );
        }
      }
    });

    test('kein Text nennt Rollennamen der Clique (der Burgwart darf genannt werden)', () {
      final figuren = (jsonDecode(
        File('$wurzel/packages/pixel_engine/data/figuren/rollen.json').readAsStringSync(),
      ) as Map<String, dynamic>)['figuren'] as List;
      final namen = <String>{};
      for (final f in figuren.cast<Map<String, dynamic>>()) {
        if (f['id'] == 'BW') continue;
        final name = f['name'] as String;
        namen.add(name);
        namen.addAll(name.split(' '));
      }
      expect(namen.length, greaterThan(20));
      final grenze = r'[\p{L}\p{N}_]';
      for (final t in [..._alleTexte(tutorial), ..._alleTexte(erzaehler)]) {
        final klein = t.toLowerCase();
        for (final n in namen) {
          final muster = RegExp('(?<!$grenze)${RegExp.escape(n.toLowerCase())}(?!$grenze)', unicode: true);
          expect(muster.hasMatch(klein), isFalse, reason: 'Name „$n“ in „$t“');
        }
      }
    });

    test('keine verbotenen Wörter der Spielwelt', () {
      const verboten = [
        'Taler', 'Schlüsselbund', 'Laken', 'Stablampe', 'Kerzenständer', 'Zettel', //
        'Gespenst-Kostüm', 'Täter', 'Täterin',
      ];
      for (final t in [..._alleTexte(tutorial), ..._alleTexte(erzaehler)]) {
        final klein = t.toLowerCase();
        for (final w in verboten) {
          expect(klein.contains(w.toLowerCase()), isFalse, reason: '„$w“ in „$t“');
        }
      }
    });

    test('Stil: „…“ statt „...“', () {
      for (final t in [..._alleTexte(tutorial), ..._alleTexte(erzaehler)]) {
        expect(t.contains('...'), isFalse, reason: '„$t“');
      }
    });
  });
}

/// Alle Zeichenketten-Werte eines JSON-Baums (Schlüssel ausgenommen).
Iterable<String> _alleTexte(Object? knoten) sync* {
  if (knoten is String) {
    yield knoten;
  } else if (knoten is List) {
    for (final k in knoten) {
      yield* _alleTexte(k);
    }
  } else if (knoten is Map) {
    for (final v in knoten.values) {
      yield* _alleTexte(v);
    }
  }
}

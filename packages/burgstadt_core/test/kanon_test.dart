import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:test/test.dart';

/// Kleiner, absichtlich kaputter Kanon. Die Befundtexte stammen aus `kanon.py` (gleicher Text).
Kanon kleinesKanon() => Kanon.ausText({
  'K1-KLEIN.md': [
    '@Z-1 [L] | Zeit: 23:47 | Wer: R03 | Ort: Hof | Was: a',
    '@Z-2 [L] | Zeit: 23:47 | Wer: R03, R04 | Ort: Speisekammer | Was: b',
    '@S-1 [L] | Schlussfolgerung: x | Notwendig: ja | Hinweise: H-05',
    '@H-05 [O] | Inhalt: x | Form: Karte | Quelle: Station Burgtor | Phase: 1 | Min: 4',
  ].join('\n'),
  'K4-KLEIN.md':
      '@G1-01 [G] | Von: R03 | Ziel: R07 | Ersatz: – | Min: 5 | Bedingung: x | '
      'Frage: x | Antwort: x | Antwortart: wahr | Gibt heraus: H-101 | '
      'Ersatz-Bedingung: – | Ersatz-Frage: – | Ersatz-Antwort: – | Ersatz-Antwortart: – | '
      'Ersatz gibt heraus: nichts | Zusammenfall: nein',
  'K5-KLEIN.md': [
    '@D1-1 [O] | Phase: 1 | Frage: x | Option A: R05 kommt | Option B: y | Option C: z | '
        'Begründbar durch: H-05',
    '@DW1-1 [L] | Echte Spur: A | Falsche Fährte: B | Ablenkung: C | Ergebnis A: a | '
        'Ergebnis B: b | Ergebnis C: c',
    '@E1-07 [G] | Rolle: R07 | Lage: x | Option 1: a → Folge: b | Umsetzung: Kartenaktion',
  ].join('\n'),
});

/// Felder gleich in Namen, Reihenfolge und Werten.
bool gleicheFelder(Map<String, String> a, Map<String, String> b) {
  if (a.length != b.length) return false;
  final ka = a.keys.toList();
  final kb = b.keys.toList();
  for (var i = 0; i < ka.length; i++) {
    if (ka[i] != kb[i] || a[ka[i]] != b[kb[i]]) return false;
  }
  return true;
}

bool enthaelt(Kanon k, String text) => k.datensaetze.values.any(
  (d) => d.felder.values.any((v) => v.contains(text)),
);

late Kanon original;
late Kanon wirksam;

void main() {
  setUpAll(() {
    final wurzel = findeRepoWurzel();
    if (wurzel == null) {
      throw StateError('Kein Ordner krimidinner/ oberhalb des Tests.');
    }
    original = kanonLesen('$wurzel/krimidinner/spuk-im-gewoelbe/10_kanon');
    final overlay = File(
      '$wurzel/nachtlauf/kanon/ANPASSUNG.md',
    ).readAsStringSync();
    wirksam = original.mitOverlay(overlay);
  });

  group('Zeilen-Parser', () {
    test('Felder am ersten ": ", Werte getrimmt, – ist leer', () {
      final k = Kanon.ausText({
        'K1-T.md':
            '@A-1 [O] | Name:  Anna  | Leer: – | Frage: Wie: spät? | Zeit:12:30: Ende\n',
      });
      final a = k.datensaetze['A-1']!;
      expect(a.sicht, Sicht.o);
      expect(a.felder.keys.toList(), ['Name', 'Leer', 'Frage', 'Zeit:12:30']);
      expect(a.feld('Name'), 'Anna');
      expect(a.feld('Leer'), '');
      expect(a.feld('Frage'), 'Wie: spät?');
      expect(a.feld('Zeit:12:30'), 'Ende');
      expect(a.feld('Fehlt'), isNull);
      expect(k.lesefehler, isEmpty);
    });

    test('Zeilen ohne @ fallen weg, Kopf- und Feldfehler melden Lesebefunde', () {
      final k = Kanon.ausText({
        'K1-T.md':
            'Überschrift\n@X 2 [O] | A: b\n@X-3 [O] Kaputt\n@X-4 [O] | Name: ok\n',
      });
      expect(k.datensaetze.keys.toList(), ['X-3', 'X-4']);
      expect(k.lesefehler, [
        'SYNTAX K1-T.md:2: Kopf unlesbar: @X 2 [O] | A: b',
        'SYNTAX K1-T.md:3: Feld ohne Doppelpunkt in X-3: Kaputt',
      ]);
    });

    test('doppelte Kennung wirft FormatException mit Datei und Zeile', () {
      expect(
        () => Kanon.ausText({
          'K1-A.md': '@D-1 [O] | A: 1\n',
          'K2-B.md': '\n@D-1 [G] | A: 2\n',
        }),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'DOPPELT D-1: K1-A.md:1 und K2-B.md:2',
          ),
        ),
      );
    });

    test('liest nur K*.md in Namensreihenfolge', () {
      final k = Kanon.ausText({
        'PROTOKOLL.md': '@P-1 [O] | A: b\n',
        'K2-B.md': '@B-1 [O] | A: x\n',
        'K1-A.md': '@A-1 [O] | A: y\n',
      });
      expect(k.datensaetze.keys.toList(), ['A-1', 'B-1']);
    });

    test('alsZeile schreibt leere Werte wieder als –', () {
      final k = Kanon.ausText({'K1-T.md': '@A-1 [G] | X: – | Y: v\n'});
      expect(k.datensaetze['A-1']!.alsZeile, '@A-1 [G] | X: – | Y: v');
    });
  });

  group('Echter Kanon', () {
    // Kanon v1.0 (main, PR #42): 1211 Datensätze wie `kanon.py pruefe` (vorher 1207, +4 L-Datensätze)
    test('1211 Datensätze, keine Lesebefunde', () {
      expect(original.datensaetze.length, 1211);
      expect(original.lesefehler, isEmpty);
    });

    test(
      'Sichtklassen wie die Zeilen-Regex von kanon.py: O 223 · G 559 · L 429',
      () {
        int zaehle(Sicht s) =>
            original.datensaetze.values.where((d) => d.sicht == s).length;
        expect(
          [zaehle(Sicht.o), zaehle(Sicht.g), zaehle(Sicht.l)],
          [223, 559, 429],
        );
      },
    );

    test('alle Proben am Original: 0 Befunde', () {
      final befunde = alleProben(original);
      expect(befunde.values.expand((x) => x), isEmpty);
    });

    test('Repo-Wurzel wird gefunden', () {
      final w = findeRepoWurzel();
      expect(w, isNotNull);
      expect(Directory('$w/krimidinner').existsSync(), isTrue);
    });
  });

  group('Overlay', () {
    test('ersetzt die Felder von @K-001, nicht genannte Felder bleiben', () {
      final vorher = original.datensaetze['K-001']!;
      final nachher = wirksam.datensaetze['K-001']!;
      expect(nachher.felder.keys.toList(), vorher.felder.keys.toList());
      expect(
        nachher.feld('Tatsache'),
        startsWith('Burg Schartenfels (SCHAR-ten-fels) ist die kleine'),
      );
      expect(nachher.feld('Tatsache'), isNot(vorher.feld('Tatsache')));

      final bwV = original.datensaetze['BW-STAMM']!;
      final bwN = wirksam.datensaetze['BW-STAMM']!;
      expect(bwN.feld('Herkunft'), 'Schartenfels, Bergland');
      for (final name in bwV.felder.keys.where(
        (n) => n != 'Herkunft' && n != 'Leben',
      )) {
        expect(bwN.feld(name), bwV.feld(name), reason: name);
      }
    });

    test('legt @STADT-01 neu an', () {
      expect(original.datensaetze.containsKey('STADT-01'), isFalse);
      final s = wirksam.datensaetze['STADT-01']!;
      expect(s.sicht, Sicht.o);
      expect(s.feld('Tatsache'), startsWith('Die Stadttore der Oberstadt'));
    });

    test('Löschen: entfernt die genannten Felder, auch mit Komma im Namen', () {
      final basis = Kanon.ausText({
        'K1-T.md':
            '@L-1 [O] | Name, Alter, Geschlecht: Anna | Alter: 30 | Ort: Burg | Notiz: x\n',
      });
      final w = basis.mitOverlay(
        '@L-1 [O] | Löschen: Name, Alter, Geschlecht, Notiz\n',
      );
      expect(w.datensaetze['L-1']!.felder.keys.toList(), ['Alter', 'Ort']);
      expect(w.lesefehler, isEmpty);

      final w2 = basis.mitOverlay('@L-1 [O] | Löschen: Ort, Alter\n');
      expect(w2.datensaetze['L-1']!.felder.keys.toList(), [
        'Name, Alter, Geschlecht',
        'Notiz',
      ]);
    });

    test(
      'ERSETZE: exakt, in Nummernfolge, ERSETZE-Datensätze nicht im Kanon',
      () {
        final basis = Kanon.ausText({'K1-T.md': '@T-1 [O] | Text: A und a\n'});
        final w = basis.mitOverlay(
          '@ERSETZE-02 [O] | Von: B | Nach: C\n@ERSETZE-01 [O] | Von: A | Nach: B\n',
        );
        expect(w.datensaetze['T-1']!.feld('Text'), 'C und a');
        expect(w.datensaetze.containsKey('ERSETZE-01'), isFalse);
        expect(w.ersetzungen.map((e) => e.id), ['ERSETZE-01', 'ERSETZE-02']);
      },
    );

    test(
      'ERSETZE am echten Kanon: kein Brockengespenst mehr, Nebelriese vorhanden',
      () {
        expect(enthaelt(wirksam, 'Brockengespenst'), isFalse);
        expect(enthaelt(wirksam, 'Nebelriese'), isTrue);
        expect(wirksam.ersetzungen.length, 38); // 16 Harz-Bezüge + „bewusstlos“ (A-702d) + Osterode (E42) + 3 × Punsch alkoholfrei + R02-Anrede (E43) + Lampenmarke, Aussprache, „Quelle des Schreis“ (E46) + Firmenname, 2 × Färbung, 2 × Punsch (E47) + „nachtragend“, 2 × Blazer ohne Weinnamen (E50) + 5 × Haarfarbe im Look-Anker (E54)
        // Genus: der Nebelriese (männlich) – keine sächlichen Reste aus „das Brockengespenst“.
        for (final falsch in ['das Nebelriese', 'Das Nebelriese', 'dem Nebelriese ', 'seinem Nebelriese ']) {
          expect(enthaelt(wirksam, falsch), isFalse, reason: falsch);
        }
        expect(
          wirksam.datensaetze.keys.where((id) => id.startsWith('ERSETZE')),
          isEmpty,
        );
      },
    );

    test(
      'H-01…H-29 und S-1…S-7 bleiben inhaltlich unverändert (Felder identisch)',
      () {
        final ids = [
          for (var n = 1; n <= 29; n++) 'H-${n.toString().padLeft(2, '0')}',
          for (var n = 1; n <= 7; n++) 'S-$n',
        ];
        // Einzige Ausnahme (E46): Die Eigentumsmarke der Lampe in H-28 steht ohne Nachnamen.
        String ohneNachname(String v) => v.replaceAll('HODŽIĆ VT · 3', 'VT · 3');
        for (final id in ids) {
          final o = original.datensaetze[id]!;
          final w = wirksam.datensaetze[id]!;
          expect(w.sicht, o.sicht, reason: id);
          final erwartet = {for (final e in o.felder.entries) e.key: ohneNachname(e.value)};
          expect(gleicheFelder(w.felder, erwartet), isTrue, reason: id);
        }
      },
    );

    test('Lampenmarke ohne Nachnamen, „Quelle des Schreis“, kein „bewusstlos“ (E46, ERSETZE-17)', () {
      for (final weg in ['HODŽIĆ VT', 'HOD-schitsch fau-te', 'Herkunft des Schreis', 'bewusstlos', 'Hodžić Veranstaltungstechnik', 'kalt und berechnend', 'in Beträgen', 'rachsüchtig', 'bordeaux', 'Übernachtung der Clique']) {
        expect(enthaelt(wirksam, weg), isFalse, reason: weg);
      }
      for (final id in ['H-28', 'BSO-03', 'E1-01', 'GL-19', 'DW1-1', 'BS-03']) {
        expect(wirksam.datensaetze[id]!.felder.values.any((v) => v.contains('„VT · 3“')), isTrue, reason: id);
      }
      expect(wirksam.datensaetze['GL-19']!.feld('Aussprache'), 'fau-te drei');
      expect(wirksam.datensaetze['R02-LÜGE']!.felder.values.any((v) => v.contains('Quelle des Schreis')), isTrue);
      // Die Lampe bleibt R01 zugeordnet: Firma im Beruf, „deine Lampe“ in den Rollentexten.
      expect(wirksam.datensaetze['R01-STAMM']!.feld('Beruf'), contains('Veranstaltungstechnik'));
    });

    test('Herkunft ist nicht Teil der Spieldaten (E48, Nutzerentscheidung N-02)', () {
      for (var n = 1; n <= 20; n++) {
        final id = 'R${n.toString().padLeft(2, '0')}-STAMM';
        expect(wirksam.datensaetze[id]!.felder.containsKey('Wurzeln'), isFalse, reason: id);
        // Der Kanon des Krimidinners behält die Angabe; nur das Spiel lässt sie weg.
        expect(original.datensaetze[id]!.felder.containsKey('Wurzeln'), isTrue, reason: '$id im Kanon');
      }
      final herkunft = RegExp(r'bosnisch|kurdisch|türkisch|polnisch|Tuzla|Opole|Zenica|Masur', caseSensitive: false);
      for (final d in wirksam.datensaetze.values) {
        if (d.sicht == Sicht.l && !d.id.startsWith('DW')) continue;
        for (final e in d.felder.entries) {
          expect(herkunft.hasMatch(e.value), isFalse, reason: '${d.id} · ${e.key}: ${e.value}');
        }
      }
    });

    test('Haarfarben gemischt (E54) und DW3-3 nennt nur die Spur (E54)', () {
      const anker = {
        'LF-R07': 'wavy light brown hair',
        'LF-R12': 'short dark blond hair',
        'LF-R14': 'short dark brown hair',
        'LF-R17': 'black hair and a short beard',
        'LF-R19': 'short light brown hair',
      };
      anker.forEach((id, text) {
        expect(wirksam.datensaetze[id]!.feld('Anker (EN)'), contains(text), reason: id);
      });
      final c = wirksam.datensaetze['DW3-3']!.feld('Ergebnis C')!;
      expect(c, isNot(contains('Merle')));
      expect(c, contains('fehlt am linken Absatz ein Stollen'));
      // Der Hinweis H-15 des Kanons bleibt (trägt S-5); siehe den Test zu H-01…H-29.
    });

    test('Elternberufe in den Familienfeldern nicht nach Geschlecht getrennt (E57)', () {
      const technik = ['techniker', 'tronik', 'schlosser', 'linienbus', 'elektrik', 'polier', 'fliesen', 'schweiß', 'mechanik', 'stahlwerk', 'lagerist', 'lokführer'];
      const sorge = ['pfleg', 'erzieh', 'assistent', 'koch', 'lehr', 'unterricht', 'helfer', 'sekretär', 'kita', 'schule'];
      final mutterTechnik = <String>[], vaterSorge = <String>[];
      for (var r = 1; r <= 20; r++) {
        final id = 'R${r.toString().padLeft(2, '0')}-STAMM';
        final f = wirksam.datensaetze[id]!.feld('Familie')!.toLowerCase();
        final mutter = RegExp(r'die mutter ([^,.;]+)').firstMatch(f)?.group(1) ?? '';
        final vater = RegExp(r'der vater ([^,.;]+)').firstMatch(f)?.group(1) ?? '';
        if (technik.any(mutter.contains)) mutterTechnik.add(id);
        if (sorge.any(vater.contains)) vaterSorge.add(id);
      }
      expect(mutterTechnik.length, greaterThanOrEqualTo(3), reason: 'Mütter in Technik/Handwerk: $mutterTechnik');
      expect(vaterSorge.length, greaterThanOrEqualTo(3), reason: 'Väter in Pflege/Bildung/Küche: $vaterSorge');
    });

    test('Punsch ist in jedem angezeigten Text alkoholfrei (O, G und Detektiv-Ergebnisse DW, E47)', () {
      for (final d in wirksam.datensaetze.values) {
        if (d.sicht == Sicht.l && !d.id.startsWith('DW')) continue;
        for (final e in d.felder.entries) {
          final ohneKessel = e.value.replaceAll('Punschkessel', '');
          if (ohneKessel.contains('Punsch')) {
            expect(e.value, contains('alkoholfrei'), reason: '${d.id} · ${e.key}');
          }
        }
      }
    });

    test(
      'Sicht bleibt beim Original; eine abweichende Sicht wird gemeldet',
      () {
        final basis = Kanon.ausText({'K1-T.md': '@T-1 [O] | A: x\n'});
        final w = basis.mitOverlay('@T-1 [G] | A: y\n');
        expect(w.datensaetze['T-1']!.sicht, Sicht.o);
        expect(
          w.lesefehler.single,
          'OVERLAY ANPASSUNG.md:1: Sicht [G] weicht vom Original [O] ab (T-1)',
        );
      },
    );

    test('alle Proben am wirksamen Kanon (Original + Overlay): 0 Befunde', () {
      final befunde = alleProben(wirksam);
      expect(befunde.values.expand((x) => x), isEmpty);
      expect(wirksam.datensaetze.length, 1276); // 1228 + 48 Stadt-Hinweise (A-401a)
    });

    test('mitPraefix liefert die Datensätze mit dem Präfix', () {
      expect(wirksam.mitPraefix('ORT-').length, 12);
      expect(wirksam.mitPraefix('STADT-').map((d) => d.id).toList(), [
        'STADT-01',
        'STADT-02',
        'STADT-03',
        'STADT-04',
        'STADT-05',
      ]);
    });
  });

  group('overlayDiff', () {
    test(
      'geänderte Felder als ID · Feld: alt → neu, neue Datensätze als + ID',
      () {
        final basis = Kanon.ausText({'K1-T.md': '@T-1 [O] | A: alt | B: x\n'});
        final w = basis.mitOverlay(
          '@T-1 [O] | A: neu | Löschen: B\n@T-2 [O] | A: y\n',
        );
        expect(overlayDiff(basis, w), [
          'T-1 · A: alt → neu',
          'T-1 · B: x → –',
          '+ T-2',
        ]);
      },
    );

    test('am echten Kanon: 65 neue Datensätze (17 + 48 Stadt-Hinweise)', () {
      final diff = overlayDiff(original, wirksam);
      expect(diff.where((z) => z.startsWith('+ ')).length, 65);
      expect(diff, contains('+ ORT-12'));
    });
  });

  group('Proben wie kanon.py (gleiche Befundtexte)', () {
    test('Gespräch mit falschem Min und fehlendem Ersatzziel', () {
      expect(probeErsatz(kleinesKanon()), [
        'ERSATZ G1-01: Ziel R07 > R03 braucht Ersatzziel',
        'SPIEGEL G1-01: Ersatz-Bedingung fehlt',
        'SPIEGEL G1-01: Ersatz-Frage fehlt',
        'SPIEGEL G1-01: Ersatz-Antwort fehlt',
        'SPIEGEL G1-01: Ersatz-Antwortart fehlt',
        'MIN G1-01: Min 5 statt 7',
      ]);
    });

    test('fehlender HW-Datensatz und Absicherung', () {
      expect(probeAbsicherung(kleinesKanon()), [
        'ABSICHERUNG S-1: kein unblockierbarer Hinweis',
        for (var n = 4; n <= 19; n++)
          'ABSICHERUNG S-1 N=$n: 1 unabhängige Quellen (Soll 2)',
        'ABSICHERUNG S-1 N=20: 1 unabhängige Quellen (Soll 3)',
        'HINWEIS H-05: Wahrheitsdatensatz HW-05 fehlt',
      ]);
    });

    test('Zeitkonflikt einer Person zur selben Minute', () {
      expect(probeZeit(kleinesKanon()), [
        'ZEIT R03 23:47:00: Hof (Z-1) und Speisekammer (Z-2)',
      ]);
    });

    test('Erweiterungsrolle in einer Option des Detektiv-Entscheids', () {
      expect(
        probeD(kleinesKanon()).where((z) => z.startsWith('D1-1')).toList(),
        ['D1-1: Option A nennt Erweiterungsrolle R05'],
      );
    });

    test('Ereignis mit nur einer Option', () {
      expect(
        probeE(kleinesKanon()).where((z) => z.startsWith('E1-07')).toList(),
        ['E1-07: 1 Optionen (2–3 verlangt)'],
      );
    });

    test('unbekannte Kennung im Verweis', () {
      expect(probeSyntax(kleinesKanon()), [
        'VERWEIS G1-01.Gibt heraus: unbekannte Kennung H-101',
      ]);
    });
  });
}

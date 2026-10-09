import 'dart:io';

import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:test/test.dart';

/// Erwartung für einen Einzelfall.
enum _E { fehler, warnung, keiner }

/// (Text, Erwartung, erwartetes Wort; bei `keiner` leer).
const _faelle = <(String, _E, String)>[
  // ---- Fehler: Alkohol ----
  ('Ein Glas Wein, bitte.', _E.fehler, 'Wein'),
  ('Prost!', _E.fehler, 'Prost'),
  ('Der Glühweinstand am Markt.', _E.fehler, 'Glühweinstand'),
  ('Am Tresen stand ein Bier.', _E.fehler, 'Bier'),
  ('Die Biere waren kalt.', _E.fehler, 'Biere'),
  ('Der Weinkeller ist offen.', _E.fehler, 'Weinkeller'),
  ('Ein Rotwein für den Gast.', _E.fehler, 'Rotwein'),
  ('Der Schnaps brennt im Hals.', _E.fehler, 'Schnaps'),
  ('Noch ein Sekt, bitte.', _E.fehler, 'Sekt'),
  ('Die Kneipe am Hafen ist voll.', _E.fehler, 'Kneipe'),
  ('Eine Cocktailbar am Hafen.', _E.fehler, 'Cocktailbar'),
  ('Er war betrunken.', _E.fehler, 'betrunken'),
  ('Sie wirkte beschwipst.', _E.fehler, 'beschwipst'),
  ('Der Promillewert war hoch.', _E.fehler, 'Promillewert'),
  ('Ein Joint lag auf dem Tisch.', _E.fehler, 'Joint'),
  ('Die Bar war voll.', _E.fehler, 'Bar'),
  ('Ein Krug Met, bitte.', _E.fehler, 'Met'),
  ('Ein Schuss Rum.', _E.fehler, 'Rum'),
  ('Rumpunsch im Kessel.', _E.fehler, 'Rumpunsch'),
  ('Ein Alkoholiker am Tisch.', _E.fehler, 'Alkoholiker'),
  ('Der Trinkspruch war lang.', _E.fehler, 'Trinkspruch'),
  ('Ein Wodka für den Gast.', _E.fehler, 'Wodka'),
  ('Er zechte bis zum Morgen.', _E.fehler, 'zechte'),
  ('Honigmet im Krug.', _E.fehler, 'Honigmet'),
  ('Ein Gin Tonic.', _E.fehler, 'Gin'),
  ('Ein Champagner zum Abschluss.', _E.fehler, 'Champagner'),
  ('Auf ex trinken.', _E.fehler, 'Auf ex'),
  ('Wir wollen anstoßen.', _E.fehler, 'anstoßen'),
  // ---- Fehler: Rausch und Drogen ----
  ('Sie wollten kiffen.', _E.fehler, 'kiffen'),
  ('Drogen unter dem Bett.', _E.fehler, 'Drogen'),
  ('Haschisch im Beutel.', _E.fehler, 'Haschisch'),
  ('Die Spur führt zum Kokain.', _E.fehler, 'Kokain'),
  ('Ein Rauschgiftring im Hafen.', _E.fehler, 'Rauschgiftring'),
  ('Der Glücksrausch der Nacht.', _E.fehler, 'Glücksrausch'),
  // ---- Fehler: Film-Vampire, Hexen, Teufel, Blut, Leiche, Herkunft ----
  ('Dracula wartet im Keller.', _E.fehler, 'Dracula'),
  ('Nosferatu klopft an.', _E.fehler, 'Nosferatu'),
  ('Graf Orlok kommt.', _E.fehler, 'Orlok'),
  ('Ein Vlad Țepeș im Film.', _E.fehler, 'Țepeș'),
  ('Die Hexe lacht im Turm.', _E.fehler, 'Hexe'),
  ('Die Hexerei ist vorbei.', _E.fehler, 'Hexerei'),
  ('In der Walpurgisnacht brennt Licht.', _E.fehler, 'Walpurgisnacht'),
  ('Der Teufel lacht.', _E.fehler, 'Teufel'),
  ('Das war teuflisch.', _E.fehler, 'teuflisch'),
  ('Der Teufelskreis beginnt.', _E.fehler, 'Teufelskreis'),
  ('Blut an der Hand.', _E.fehler, 'Blut'),
  ('Blutstropfen im Gang.', _E.fehler, 'Blutstropfen'),
  ('Der Stoff war blutig.', _E.fehler, 'blutig'),
  ('Ein Blutfleck auf dem Teppich.', _E.fehler, 'Blutfleck'),
  ('Die Leiche liegt im Gang.', _E.fehler, 'Leiche'),
  ('Ein Zigeuner am Tor.', _E.fehler, 'Zigeuner'),
  ('Das war ein Ehrenmord.', _E.fehler, 'Ehrenmord'),
  // ---- Warnungen ----
  ('Der Kater schnurrt.', _E.warnung, 'Kater'),
  ('Blutdruck messen.', _E.warnung, 'Blutdruck'),
  ('Die Gaststätte ist offen.', _E.warnung, 'Gaststätte'),
  ('Im Gasthaus am Platz.', _E.warnung, 'Gasthaus'),
  ('Ein Vampir im Wald.', _E.warnung, 'Vampir'),
  ('Hexenschuss im Rücken.', _E.warnung, 'Hexenschuss'),
  ('Sie stießen an.', _E.warnung, 'stießen an'),
  ('Der Anstoß war pünktlich.', _E.warnung, 'Anstoß'),
  ('Das Trinkgelage dauerte lange.', _E.warnung, 'Trinkgelage'),
  ('Der Wirt grüßt.', _E.warnung, 'Wirt'),
  ('Der Clan tagt im Rathaus.', _E.warnung, 'Clan'),
  ('Eine Großfamilie zieht ein.', _E.warnung, 'Großfamilie'),
  // ---- kein Treffer: harmlose Wörter und erlaubte Getränke ----
  ('Er weint.', _E.keiner, ''),
  ('Ich weine nicht.', _E.keiner, ''),
  ('Sie weinte leise.', _E.keiner, ''),
  ('Der Bowler liegt im Schrank.', _E.keiner, ''),
  ('Die Kennung h_leiche steht im Feld id.', _E.keiner, ''),
  ('Sie weinen beide.', _E.keiner, ''),
  ('Im Bargeld steckt Geld.', _E.keiner, ''),
  ('Sie zahlte bar.', _E.keiner, ''),
  ('Wir wollen bar bezahlen.', _E.keiner, ''),
  ('Ein Barren Gold.', _E.keiner, ''),
  ('Die Barock-Fassade ist alt.', _E.keiner, ''),
  ('Ein warmer, alkoholfreier Punsch.', _E.keiner, ''),
  ('Apfel-Zimt-Punsch, warm und alkoholfrei.', _E.keiner, ''),
  ('Wasser, Tee oder Ayran.', _E.keiner, ''),
  ('Die Teestube hat offen.', _E.keiner, ''),
  ('Wir sitzen im Café.', _E.keiner, ''),
  ('Die Bäckerei öffnet früh.', _E.keiner, ''),
  ('Das Wildschwein läuft durch den Wald.', _E.keiner, ''),
  ('Das Schwein grunzt.', _E.keiner, ''),
  ('Das Insekt krabbelt über die Mauer.', _E.keiner, ''),
  ('Die Sektion ist geschlossen.', _E.keiner, ''),
  ('Der Sektor B ist frei.', _E.keiner, ''),
  ('Die Drogerie hat geöffnet.', _E.keiner, ''),
  ('Ein Besuch in Rumänien.', _E.keiner, ''),
  ('Das Metall glänzt.', _E.keiner, ''),
  ('Der Komet leuchtet.', _E.keiner, ''),
  ('Es rauschen die Blätter.', _E.keiner, ''),
  ('Das Hexagon ist groß.', _E.keiner, ''),
  ('Mit Leichtigkeit gelöst.', _E.keiner, ''),
  ('Er ist tot.', _E.keiner, ''),
  ('Die Schnapszahl steht an der Tür.', _E.keiner, ''),
  ('Zum Wohl der Stadt.', _E.keiner, ''),
  ('Der Kneipp-Tag im Park.', _E.keiner, ''),
  ('Der Schenkel ist verletzt.', _E.keiner, ''),
  ('Das Katerchen schläft.', _E.keiner, ''),
  ('Die Prostata ist unauffällig.', _E.keiner, ''),
  ('Er blickte bierernst drein.', _E.keiner, ''),
  ('Die Zeche liegt im Berg.', _E.keiner, ''),
  ('Ein Metzger aus der Stadt.', _E.keiner, ''),
  ('Das Teeservice steht bereit.', _E.keiner, ''),
  ('Der Uhrturm schlägt Mitternacht.', _E.keiner, ''),
];

LeitplankenTreffer _t(String datei, String wort) => LeitplankenTreffer(
  datei: datei,
  zeile: 1,
  wort: wort,
  fehler: true,
  ausschnitt: '',
);

void main() {
  group('Einzelfälle', () {
    for (final (text, erwartet, wort) in _faelle) {
      test('${erwartet.name}: $text', () {
        final treffer = scanneText(text);
        if (erwartet == _E.keiner) {
          expect(treffer, isEmpty);
          return;
        }
        expect(treffer, hasLength(1));
        expect(treffer.single.wort, wort);
        expect(treffer.single.fehler, erwartet == _E.fehler);
      });
    }
  });

  group('Zeilen und Quelltexte', () {
    test('Zeilen zählen ab 1, CRLF wird toleriert', () {
      final t = scanneText('Erste Zeile.\r\nZweite Zeile mit Wein.');
      expect(t, hasLength(1));
      expect(t.single.zeile, 2);
    });

    test('Verbots-Zitate am Zeilenanfang werden übersprungen', () {
      expect(
        scanneText('- Kein Alkohol, keine Drogen: Wein, Bier, Met.'),
        isEmpty,
      );
      expect(scanneText('   Verboten sind Wein und Bier.'), isEmpty);
    });

    test('Verbotswort mitten im Satz zählt', () {
      expect(scanneText('Sie sagte: Verboten sind Wein.'), hasLength(1));
    });

    test('Der Ausschnitt enthält das Wort', () {
      final t = scanneText('Im Keller stand ein Glas Wein neben der Tür.');
      expect(t.single.ausschnitt, contains('Wein'));
    });

    test('Dart: Code und Kommentare werden nicht geprüft', () {
      expect(scanneDart('final bier = 1; // Wein'), isEmpty);
      expect(scanneDart('/* Prost */ const x = 1;'), isEmpty);
    });

    test('Dart: Inhalt von String-Literalen wird geprüft', () {
      final t = scanneDart("const s = 'Ein Glas Wein';", datei: 'a.dart');
      expect(t.single.wort, 'Wein');
      expect(t.single.datei, 'a.dart');
    });

    test('Dart: rohe und mehrzeilige Literale mit richtiger Zeile', () {
      expect(scanneDart("const r = r'Prost';").single.wort, 'Prost');
      expect(scanneDart("const t = '''Erste\nWein''';").single.zeile, 2);
    });

    test('Unicode-Escapes werden vor der Prüfung aufgelöst', () {
      expect(scanneText(r'{"text": "Glühwein"}').single.wort, 'Glühwein');
      expect(scanneText(r'{"text": "Gl\u{fc}hwein"}').single.wort, 'Glühwein');
    });
  });

  group('Ausnahmen-Datei', () {
    test('Eintrag befreit genau Datei und Wort', () {
      final a = LeitplankenAusnahmen.parse(
        '# Kopf\nkrimi/a.md | Wein | Zitat der Regel\n',
      );
      expect(a.befreit(_t('krimi/a.md', 'Wein')), isTrue);
      expect(a.befreit(_t('krimi/b.md', 'Wein')), isFalse);
      expect(a.befreit(_t('krimi/a.md', 'Bier')), isFalse);
    });

    test('Zeilen ohne Begründung und die Kopfzeile zählen nicht', () {
      final a = LeitplankenAusnahmen.parse(
        'krimi/a.md | Wein |\nDatei | Wort | Begründung\n',
      );
      expect(a.befreit(_t('krimi/a.md', 'Wein')), isFalse);
      expect(a.befreit(_t('Datei', 'Wort')), isFalse);
    });
  });

  group('Dateien und Bestand', () {
    late Directory tmp;
    setUp(() {
      tmp = Directory.systemTemp.createTempSync('leitplanken_');
    });
    tearDown(() {
      tmp.deleteSync(recursive: true);
    });

    void schreibe(String rel, String inhalt) {
      File('${tmp.path}/$rel')
        ..createSync(recursive: true)
        ..writeAsStringSync(inhalt);
    }

    test('Repo-Wurzel wird nach oben gesucht', () {
      Directory('${tmp.path}/nachtlauf').createSync();
      Directory('${tmp.path}/packages').createSync();
      Directory('${tmp.path}/a/b').createSync(recursive: true);
      expect(findeRepoWurzel(von: '${tmp.path}/a/b'), tmp.path);
    });

    test('Standardbestand umfasst nur die vorgesehenen Dateien', () {
      schreibe('nachtlauf/kanon/ANPASSUNG.md', 'x');
      schreibe(
        'krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md',
        'x',
      );
      schreibe('krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN.md', 'x');
      schreibe('krimidinner/spuk-im-gewoelbe/10_kanon/FORMAT.md', 'x');
      schreibe('krimidinner/spuk-im-gewoelbe/10_kanon/entwuerfe/K9.md', 'x');
      schreibe('krimidinner/spuk-im-gewoelbe/10_kanon/PROTOKOLL.md', 'x');
      schreibe('packages/burgstadt_core/data/welt.json', 'x');
      schreibe('lib/burgstadt/orte.dart', 'x');
      schreibe('lib/burgstadt/notiz.txt', 'x');
      schreibe('content/szenario.json', 'x');
      final rel = spieltextBestand(
        tmp.path,
      ).map((p) => p.substring(tmp.path.length + 1)).toList();
      expect(
        rel,
        unorderedEquals([
          'nachtlauf/kanon/ANPASSUNG.md',
          'krimidinner/spuk-im-gewoelbe/10_kanon/K1-GRUNDWAHRHEIT.md',
          'krimidinner/spuk-im-gewoelbe/10_kanon/K2-ROLLEN.md',
          'packages/burgstadt_core/data/welt.json',
          'lib/burgstadt/orte.dart',
          'content/szenario.json',
        ]),
      );
    });

    test('scanneDateien wendet die Ausnahmen-Datei an', () {
      schreibe('texte/a.md', 'Ein Glas Wein.\nZwei Gläser Bier.\n');
      final pfad = '${tmp.path}/texte/a.md';
      final ohne = scanneDateien([
        pfad,
      ], ausnahmenDatei: '${tmp.path}/fehlt.md');
      expect(ohne.map((t) => t.wort), ['Wein', 'Bier']);
      schreibe('ausnahmen.md', '$pfad | Wein | Zitat der Regel\n');
      final mit = scanneDateien([
        pfad,
      ], ausnahmenDatei: '${tmp.path}/ausnahmen.md');
      expect(mit.map((t) => t.wort), ['Bier']);
    });

    test('Unbekannte Pfade lösen eine Ausnahme aus', () {
      expect(
        () => sammleDateien(['${tmp.path}/gibt/es/nicht.md']),
        throwsA(isA<FileSystemException>()),
      );
    });
  });
}

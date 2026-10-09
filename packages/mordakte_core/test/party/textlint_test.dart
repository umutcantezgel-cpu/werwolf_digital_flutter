// F3-BAUMEISTER-01: Textlint gegen den Kanon (Uhrzeiten, Raumwörter, alte Personennamen).
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

Map<String, Object?> _regeln() => leseJson('$repoWurzel/content/party/textregeln.json');

List<TextBefund> _lint(String text) =>
    textLint(kanon, [TextQuelle(ort: 'probe.json#x', text: text, vorlesen: false)], regeln: _regeln());

List<String> _regelnVon(String text) => [for (final b in _lint(text)) b.regel];

void main() {
  group('Uhrzeiten (§4)', () {
    test('eine Uhrzeit aus dem Kanon ist frei, eine fremde wird gemeldet', () {
      expect(_regelnVon('Um 23:58 wird es still.'), isEmpty);
      expect(_regelnVon('Um 0:20 steht Herr Schneider auf.'), isEmpty);
      expect(_regelnVon('Um 4:44 wird es still.'), ['Uhrzeit']);
      expect(_regelnVon('Um 17:17 wird es still.'), ['Uhrzeit']);
    });

    test('Sekunden zählen nicht mit, die Uhrzeit wird als H:MM geprüft', () {
      expect(_regelnVon('Um 23:58:40 wird es still.'), isEmpty);
      expect(_regelnVon('Um 4:44:10 wird es still.'), ['Uhrzeit']);
    });
  });

  group('Raumwörter (raeume.json, raumAusnahmen)', () {
    test('Raum- und Anzeigenamen sind frei', () {
      expect(_regelnVon('Im Kaminsaal und im Turmgang ist es still.'), isEmpty);
      expect(_regelnVon('Der Buffetsaal ist voll, der Ostsaal leer.'), isEmpty);
      expect(_regelnVon('Im West-Saal brennt das Feuer.'), isEmpty);
      expect(_regelnVon('Im Vorratsraum liegt die Torte.'), isEmpty);
    });

    test('Raumwörter ohne Raum werden gemeldet', () {
      expect(_regelnVon('Im Gewölbegang wartet niemand.'), ['Raumwort']);
      expect(_regelnVon('Der Saal ist leer.'), ['Raumwort']);
      expect(_regelnVon('Eine Vorratskammer gibt es nicht.'), ['Raumwort']);
    });

    test('ein Wort aus einer Ortswendung ist kein Raumname', () {
      expect(_regelnVon('In der Waschküche ist es kalt.'), ['Raumwort']);
      expect(_regelnVon('Oben im Turm ist die Toilette.'), isEmpty);
      expect(_regelnVon('Im Turmgang ist es kalt.'), isEmpty);
    });

    test('Schauplatz- und Außenorte stehen in raumAusnahmen', () {
      expect(_regelnVon('Marek parkt im Schlosshof.'), isEmpty);
      expect(_regelnVon('Der Keller ist kalt.'), isEmpty);
      expect(_regelnVon('Unter dem Schlossturm liegt der Gewölbekeller.'), isEmpty);
    });
  });

  group('Alte Personennamen (figuren.json, quelle.name)', () {
    test('ein alter Name ist verboten, der heutige Name ist frei', () {
      expect(_regelnVon('Murat hat das Essen gebracht.'), ['Altname']);
      expect(_regelnVon('Marek hat das Essen gebracht.'), isEmpty);
      expect(_regelnVon('Leyla hat gefragt.'), ['Altname']);
    });
  });
}

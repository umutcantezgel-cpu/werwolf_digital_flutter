// F-01: Ein Kanon – Schema und Querverweise.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

void main() {
  final schemaOrdner = '$repoWurzel/content/party/schema';
  final zuordnung = <String, String>{
    'fall.json': 'fall',
    'setting.json': 'setting',
    'raeume.json': 'raeume',
    'wahrnehmung.json': 'wahrnehmung',
    'figuren.json': 'figuren',
    'gegenstaende.json': 'gegenstaende',
    'zeitleiste.json': 'zeitleiste',
    'beobachtungen.json': 'beobachtungen',
    'besetzung.json': 'besetzung',
    'tatmatrix/basis.json': 'tatmatrix',
    'tatmatrix/ahmet.json': 'tatmatrix',
    'tatmatrix/fatma.json': 'tatmatrix',
    'tatmatrix/olli.json': 'tatmatrix',
    'tatmatrix/can.json': 'tatmatrix',
  };

  group('Schema', () {
    for (final e in zuordnung.entries) {
      test('${e.key} passt zu ${e.value}.schema.json', () {
        final schema = SchemaPruefer(leseJson('$schemaOrdner/${e.value}.schema.json'));
        final fehler = schema.pruefe(kanon.json[e.key]);
        expect(fehler, isEmpty, reason: fehler.join('\n'));
      });
    }
  });

  test('alle Querverweise zeigen auf Vorhandenes, alle Kennungen eindeutig', () {
    final befunde = kanonVerweise(kanon);
    expect(befunde, isEmpty, reason: befunde.join('\n'));
  });

  test('Besetzung: Reihenfolge = Besetzungsplätze, Bilanz stimmt, ab 5 Rollen höchstens 1 Unterschied', () {
    final b = kanon.json['besetzung.json']!;
    final reihe = (b['reihenfolge'] as List).cast<String>();
    for (var i = 0; i < reihe.length; i++) {
      expect(kanon.figur(reihe[i])!['besetzungsplatz'], i + 1, reason: reihe[i]);
    }
    for (final z in (b['geschlechterBilanz'] as List).cast<Map>()) {
      final n = z['rollen'] as int;
      final m = reihe.take(n).where((id) => kanon.figur(id)!['geschlecht'] == 'm').length;
      expect([z['m'], z['w']], [m, n - m], reason: 'Bilanz bei $n Rollen');
      if (n >= 5) expect((m - (n - m)).abs(), lessThanOrEqualTo(1), reason: 'Ausgewogenheit bei $n Rollen');
    }
    expect(reihe.take(4).toSet(), kanon.kernverdaechtige.toSet());
  });

  test('jede Pfaddatei ist geladen', () {
    expect(kanon.pfade, ['ahmet', 'fatma', 'olli', 'can']);
    for (final p in kanon.pfade) {
      expect(kanon.json['tatmatrix/$p.json'], isNotNull);
    }
  });
}

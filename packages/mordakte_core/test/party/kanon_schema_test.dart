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

  test('jede Pfaddatei ist geladen', () {
    expect(kanon.pfade, ['ahmet', 'fatma', 'olli', 'can']);
    for (final p in kanon.pfade) {
      expect(kanon.json['tatmatrix/$p.json'], isNotNull);
    }
  });
}

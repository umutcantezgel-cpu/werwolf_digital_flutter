import 'dart:io';

import 'package:mordakte_core/src/party/bibel.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

void main() {
  final bibelDatei = File('$repoWurzel/content/party/schlosskeller/STORY-BIBEL.md');

  test('Story-Bibel ist aktuell', () {
    expect(storyBibel(kanon, pruefer), bibelDatei.readAsStringSync());
  });

  test('enthält jede Figur, jeden Raum, jede Beobachtung', () {
    final text = storyBibel(kanon, pruefer);
    final figuren = [kanon.figurenJson['detektiv'], kanon.figurenJson['opfer'], ...kanon.figuren];
    for (final f in figuren) {
      final m = (f as Map).cast<String, Object?>();
      expect(text, contains('${m['id']}'), reason: 'Kennung ${m['id']}');
      if (m['name'] != null) expect(text, contains('${m['name']}'), reason: 'Name ${m['name']}');
    }
    final raeume = (kanon.json['raeume.json']!['rooms'] as List).cast<Map<String, Object?>>();
    for (final r in raeume) {
      expect(text, contains('${r['id']}'), reason: 'Raum ${r['id']}');
      expect(text, contains('${r['anzeigename']}'), reason: 'Anzeigename ${r['anzeigename']}');
    }
    for (final b in kanon.beobachtungen) {
      expect(text, contains('${b['id']}'), reason: 'Beobachtung ${b['id']}');
    }
  });
}

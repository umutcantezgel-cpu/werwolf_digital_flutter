// F-05: Schlüsselbeweis und Zusatzindiz entstehen nur im eigenen Pfad.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

void main() {
  late Beweise beweise;
  setUpAll(() => beweise = Beweise(kanon, pruefer));

  test('Beweisprüfung ohne Befund', () {
    final f = beweise.pruefe();
    expect(f, isEmpty, reason: f.join('\n'));
  });

  test('in jedem Pfad greift nur die Täterperson den Kerzenständer', () {
    for (final p in kanon.pfade) {
      expect(beweise.greifer(p), {p});
    }
  });

  test('der Bund liegt je Pfad an einem anderen Ort', () {
    final enden = {for (final p in kanon.pfade) beweise.bundEnde(p)};
    expect(enden, hasLength(kanon.pfade.length));
    expect(enden, isNot(contains('schneider')));
  });

  test('jede pfadabhängige Spur hat eine harmlose Fassung', () {
    for (final g in kanon.gegenstaende) {
      for (final s in (g['spuren'] as List? ?? const [])) {
        final m = s as Map;
        if ((m['entstehtWenn'] as Map)['immer'] == true) continue;
        expect((m['harmlos'] as String?)?.isNotEmpty, isTrue, reason: '${m['id']}');
      }
    }
  });

  test('D-Vorbereitung: Schlüsselbeweise liegen in allen Pfaden an Orten, die es immer gibt (Karte pfadgleich)', () {
    for (final g in kanon.gegenstaende) {
      final lage = g['lage'] as Map;
      if (lage['versteckt'] == true) continue;
      expect(lage['ort'] ?? lage['einrichtung'] ?? lage['traeger'], isNotNull, reason: '${g['id']}');
    }
  });
}

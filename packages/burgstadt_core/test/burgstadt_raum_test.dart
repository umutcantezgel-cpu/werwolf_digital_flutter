import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:test/test.dart';

import 'fall_daten_test.dart' show ladeFall;

/// Mehrspieler-Raum ohne Netz: Lobby, Rollenvergabe, Bots, Spoilerschutz (Ebene 8, Teil).
void main() {
  final d = ladeFall();

  BurgstadtRaum raumMit(int menschen, int n) {
    final r = BurgstadtRaum(d, Welt(baueBurg()));
    for (var i = 1; i <= menschen; i++) {
      r.beitreten('S$i', 'Spieler $i');
      r.verbunden('S$i', true);
    }
    r.nachricht('S1', {'art': 'start', 'n': n});
    return r;
  }

  test('Lobby: Gastgeber startet, Rollen in Kanon-Reihenfolge, Detektiv = Gastgeber, Bots füllen auf', () {
    final r = raumMit(3, 6);
    expect(r.rolleVon, {'S1': 'DET', 'S2': 'R01', 'S3': 'R02'});
    expect(r.fall!.rollen, hasLength(6));
    final bots = [for (final x in r.fall!.rollen) if (r.spielerVon(x) == null) x];
    expect(bots, hasLength(4));
    for (final b in bots) {
      expect(r.sim!.figuren[b]!.bot, isTrue);
    }
    expect(r.sim!.figuren['R01']!.bot, isFalse);
    expect(r.beitreten('S9', 'zu spät'), isFalse);
  });

  test('Nur der Gastgeber startet; N wird auf 4…20 und auf die Zahl der Menschen begrenzt', () {
    final r = BurgstadtRaum(d, Welt(baueBurg()));
    for (var i = 1; i <= 8; i++) {
      r.beitreten('S$i', 'S$i');
    }
    r.nachricht('S2', {'art': 'start', 'n': 4});
    expect(r.fall, isNull);
    r.nachricht('S1', {'art': 'start', 'n': 2});
    expect(r.n, 7, reason: '8 Menschen = Detektiv + 7 Rollen');
  });

  test('Spoilerschutz: Funde nur an den Finder; Akte an alle; Texte nur für Bekanntes', () {
    final r = raumMit(3, 4);
    r.tick(0.1);
    for (final id in ['S1', 'S2', 'S3']) {
      r.ereignisseFuer(id);
    }
    r.nachricht('S2', {'art': 'untersuche', 'station': 'BS-01'});
    final s2 = r.ereignisseFuer('S2'), s3 = r.ereignisseFuer('S3');
    final fund = s2.firstWhere((e) => e['art'] == 'fund');
    expect(s3.where((e) => e['art'] == 'fund'), isEmpty);
    expect(s3.where((e) => e['art'] == 'texte' && (e['texte'] as Map).containsKey(fund['hinweis'])), isEmpty);
    // An die Akte geteilt: jetzt erfahren es alle
    r.nachricht('S2', {'art': 'teile', 'an': 'akte', 'hinweis': fund['hinweis']});
    expect(r.ereignisseFuer('S3').where((e) => e['art'] == 'akte' && e['hinweis'] == fund['hinweis']), hasLength(1));
    // Zustand: Wissen eines Spielers enthält nur seins
    final z3 = r.zustandFuer('S3');
    expect((z3['wissen'] as List).toSet(), r.fall!.wissen['R02']);
    expect(z3['rolle'], 'R02');
  });

  test('Teilen an Einzelne: nur der Empfänger bekommt den Hinweis', () {
    final r = raumMit(3, 4);
    r.nachricht('S2', {'art': 'untersuche', 'station': 'BS-01'});
    final h = r.ereignisseFuer('S2').firstWhere((e) => e['art'] == 'fund')['hinweis'] as String;
    r.ereignisseFuer('S1');
    r.ereignisseFuer('S3');
    r.nachricht('S2', {'art': 'teile', 'an': 'R02', 'hinweis': h});
    expect(r.ereignisseFuer('S3').where((e) => e['art'] == 'teilen' && e['hinweis'] == h), hasLength(1));
    expect(r.ereignisseFuer('S1').where((e) => e['hinweis'] == h), isEmpty);
    expect(r.fall!.wissen['R02'], contains(h));
  });
}

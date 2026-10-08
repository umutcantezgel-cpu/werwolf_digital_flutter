import 'dart:convert';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:test/test.dart';

import 'fall_daten_test.dart' show ladeFall;

void main() {
  final d = ladeFall();

  test('Start: Detektiv-Mappe beim Detektiv, Erzähler-Hinweise in der Akte, Phase 1 um 00:25', () {
    final z = FallZustand(d, 4)..starte();
    expect(z.phase, 1);
    expect(z.uhr, 25);
    expect(z.abschnitt, Abschnitt.ermittlung);
    final mappe = d.hinweise.values.where((h) => h.detektivMappe).map((h) => h.id);
    expect(z.wissen['DET'], containsAll(mappe));
    expect(z.akte.every((h) => d.hinweise[h]!.erzaehler), isTrue);
  });

  test('Station: Wachsspritzer (BS-01) liefert ihren Hinweis nur dem Untersuchenden', () {
    final z = FallZustand(d, 4)..starte();
    final e = z.untersuche('R02', 'BS-01');
    expect(e, isNotEmpty);
    final h = e.first.hinweis!;
    expect(d.hinweise[h]!.station, 'BS-01');
    expect(z.wissen['R02'], contains(h));
    expect(z.wissen['DET'], isNot(contains(h)));
  });

  test('Gespräch gibt Hinweis an den Fragenden; Zuhörer erfährt ihn mit (IF-1)', () {
    final z = FallZustand(d, 4)..starte();
    final (g, ziel, _) = z.offeneGespraeche('R03').first;
    expect(ziel, isNot('R03'));
    final e = z.fuehreGespraech('R03', g.id, zuhoerer: const ['DET']);
    expect(e.first.art, 'gespraech');
    for (final h in g.gibt) {
      expect(z.wissen['R03'], contains(h));
      expect(z.wissen['DET'], contains(h));
    }
    expect(z.offeneGespraeche('R03').any((t) => t.$1.id == g.id), isFalse);
    expect(z.fuehreGespraech('R03', g.id), isEmpty, reason: 'nicht zweimal');
  });

  test('Ersatzregel: Bei N=4 führen Rollen-Gespräche mit Zielen über 4 zum Ersatzziel', () {
    final z = FallZustand(d, 4)..starte();
    for (final r in z.rollen) {
      for (final (_, ziel, _) in z.offeneGespraeche(r)) {
        final nr = int.parse(ziel.substring(1));
        expect(nr, lessThanOrEqualTo(4));
      }
    }
  });

  test('Teilen: nur Bekanntes; an Einzelne oder an die Fallakte; Faden zwischen Akteneinträgen', () {
    final z = FallZustand(d, 6)..starte();
    final h = z.untersuche('R01', 'BS-03').first.hinweis!;
    expect(z.teile('R02', 'DET', h), isEmpty, reason: 'R02 kennt ihn nicht');
    expect(z.teile('R01', 'DET', h).single.art, 'teilen');
    expect(z.kennt('DET', h), isTrue);
    expect(z.kennt('R04', h), isFalse);
    expect(z.teile('R01', 'akte', h).single.art, 'akte');
    expect(z.kennt('R04', h), isTrue);
    final h2 = z.akte.firstWhere((x) => x != h);
    expect(z.verbinde('DET', h, h2), isNotEmpty);
    expect(z.faeden.length, 1);
  });

  test('Lagerunde: Meldekarten öffentlich, Rollen- und Detektiv-Entscheidungen, Phase 2', () {
    final z = FallZustand(d, 4)..starte();
    z.zeitVergeht(70);
    expect(z.abschnitt, Abschnitt.lagerunde);
    expect(z.protokoll.where((e) => e.art == 'meldekarte').length, 4);
    for (final e in z.rollenEntscheidungen()) {
      z.waehleRolle(e.id, 0);
    }
    z.zurDetektivWahl();
    expect(z.detektivEntscheidungen().length, 3);
    final ds = z.detektivEntscheidungen();
    for (final e in ds) {
      z.waehleDetektiv(e.id, e.echte);
    }
    expect(z.punkte, 3);
    z.weiter();
    expect(z.phase, 2);
    expect(z.uhr, 90);
  });

  test('Speichern und Laden ergibt denselben Zustand', () {
    final z = FallZustand(d, 8)..starte();
    z.untersuche('DET', 'BS-01');
    final (g, _, _) = z.offeneGespraeche('R01').first;
    z.fuehreGespraech('R01', g.id);
    final j = jsonEncode(z.zuJson());
    final z2 = FallZustand.ausJson(d, jsonDecode(j) as Map<String, dynamic>);
    expect(jsonEncode(z2.zuJson()), j);
  });

  test('Endmatrix: Täterin mit hoher Punktzahl → EM-1, Unschuldige → EM-3/EM-4', () {
    final gut = spieleDurch(d, 4, seed: 3);
    expect(gut.ende, 'EM-1');
    final z = FallZustand(d, 4)..starte();
    for (var p = 1; p <= 3; p++) {
      z.zeitVergeht(200);
      for (final e in z.rollenEntscheidungen()) {
        z.waehleRolle(e.id, 0);
      }
      z.zurDetektivWahl();
      for (final e in z.detektivEntscheidungen()) {
        z.waehleDetektiv(e.id, e.ablenkung);
      }
      z.weiter();
    }
    expect(z.abschnitt, Abschnitt.eingrenzung);
    expect(z.verdaechtigenkreis, ['R01', 'R02', 'R03', 'R04']);
    z.klageAn('R01');
    expect(z.ende, 'EM-4');
  });

  test('Ebene 3/4: Durchspiel 4…20 löst den Fall; Teilen spart mindestens 30 % Schritte', () {
    var mit = 0, ohne = 0;
    for (final n in [4, 8, 12, 16, 20]) {
      for (final seed in [1, 2]) {
        final a = spieleDurch(d, n, seed: seed);
        final b = spieleDurch(d, n, seed: seed, teilen: false);
        expect(a.ende, 'EM-1', reason: 'N=$n seed=$seed');
        expect(a.geloestBei, isNotNull);
        mit += a.geloestBei!;
        ohne += b.geloestBei ?? 2 * a.geloestBei!;
      }
    }
    expect(1 - mit / ohne, greaterThanOrEqualTo(0.30));
  });
}

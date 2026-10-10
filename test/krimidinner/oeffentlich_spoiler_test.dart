// Spoiler-Test der öffentlichen Ansichten im Widget-Baum: Überblick, Besetzung,
// Steckbriefe (alle aufgeklappt), Mappen-Liste und Druck für N 4, 9 und 20.
// Gleiche Regeln wie packages/krimidinner_kanon/test/spoiler_test.dart.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mordakte/krimidinner/gewoelbe_seite.dart';

import 'hilfe.dart';

Future<List<String>> texteVon(WidgetTester tester, GewoelbeTeil teil, int n) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pumpWidget(gewoelbeApp(teil: teil, n: n));
  await bilder(tester);
  if (teil == GewoelbeTeil.steckbriefe) {
    await tester.tap(find.text('Alle aufklappen'));
    await bilder(tester);
    expect(find.text('Alle zuklappen'), findsOneWidget);
  }
  if (teil == GewoelbeTeil.ueberblick) {
    await tester.tap(find.text('Die Burg'));
    await bilder(tester);
  }
  return alleTexte(tester);
}

void main() {
  testWidgets('die Regeln schlagen bei einem Leck an (Gegenprobe)', (tester) async {
    expect(spoilerBefunde([feld('R03-GEHEIM', 'Motiv')], 8), isNotEmpty);
    expect(spoilerBefunde([feld('K-090', 'Tatsache')], 8), isNotEmpty);
    expect(spoilerBefunde(['Karte (H-17)'], 8), isNotEmpty);
    expect(spoilerBefunde(['Zofia'], 8), isNotEmpty);
    expect(spoilerBefunde(['Zofia'], 18), isNotEmpty);
    expect(spoilerBefunde(['Zofia'], 20), isEmpty);
    expect(spoilerBefunde(['alle besetzten Rollen'], 8), isEmpty);
  });

  for (final n in [4, 9, 20]) {
    testWidgets('öffentliche Ansichten bei N=$n verraten nichts', (tester) async {
      groesse(tester, const Size(1280, 12000));
      final texte = <String>[];
      for (final teil in GewoelbeTeil.values) {
        final t = await texteVon(tester, teil, n);
        expect(t, isNotEmpty, reason: teil.name);
        texte.addAll(t);
      }
      // Die Steckbriefe sind wirklich aufgeklappt, die Liste ist wirklich da.
      expect(texte.any((t) => t == feld('R01-ÖFFENTLICH', 'Behauptetes Alibi')), isTrue);
      expect(texte.any((t) => t == feld('R04-STAMM', 'Name')), isTrue);
      expect(spoilerBefunde(texte, n), isEmpty);
      expect(tester.takeException(), isNull);
    });
  }
}

// Besetzung: Startwert 8, Grenzen 4 und 20, N Namen in Kanonreihenfolge.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mordakte/krimidinner/gewoelbe_seite.dart';

import 'hilfe.dart';

String name(int r) => feld('R${r.toString().padLeft(2, '0')}-STAMM', 'Name');

int zahl(WidgetTester tester) => int.parse(tester.widget<Text>(find.byKey(const ValueKey('gewoelbe-rollenzahl'))).data!);

IconButton knopf(WidgetTester tester, String tooltip) =>
    tester.widget<IconButton>(find.ancestor(of: find.byTooltip(tooltip), matching: find.byType(IconButton)).first);

void pruefeListe(WidgetTester tester, int n) {
  expect(find.text('$n Rollen und das Geburtstagskind – ${n + 1} Personen'), findsOneWidget);
  double? vorher;
  for (var r = 1; r <= 20; r++) {
    if (r <= n) {
      expect(find.text(name(r)), findsOneWidget, reason: 'R$r bei N=$n');
      final y = tester.getTopLeft(find.text(name(r))).dy;
      if (vorher != null) expect(y, greaterThan(vorher), reason: 'Reihenfolge R$r');
      vorher = y;
    } else {
      expect(find.text(name(r)), findsNothing, reason: 'R$r bei N=$n');
    }
  }
}

void main() {
  testWidgets('Startwert 8, Minus bis 4 sperrt, Plus bis 20 sperrt', (tester) async {
    groesse(tester, const Size(800, 4000));
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.besetzung));
    await bilder(tester);

    expect(zahl(tester), 8);
    expect(find.text('Die Rollen werden immer in dieser Reihenfolge besetzt.'), findsOneWidget);
    pruefeListe(tester, 8);

    for (var i = 0; i < 4; i++) {
      await tester.tap(find.byTooltip('Eine Rolle weniger'));
      await bilder(tester, 1);
    }
    expect(zahl(tester), 4);
    expect(knopf(tester, 'Eine Rolle weniger').onPressed, isNull);
    expect(knopf(tester, 'Eine Rolle mehr').onPressed, isNotNull);
    pruefeListe(tester, 4);

    for (var i = 0; i < 16; i++) {
      await tester.tap(find.byTooltip('Eine Rolle mehr'));
      await bilder(tester, 1);
    }
    expect(zahl(tester), 20);
    expect(knopf(tester, 'Eine Rolle mehr').onPressed, isNull);
    expect(knopf(tester, 'Eine Rolle weniger').onPressed, isNotNull);
    pruefeListe(tester, 20);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Zeilen zeigen Aussprache, Geschlecht, Alter und Beruf', (tester) async {
    groesse(tester, const Size(390, 3000));
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.besetzung, n: 5));
    await bilder(tester);
    expect(find.text(feld('R01-STAMM', 'Aussprache')), findsOneWidget);
    expect(find.text('Mann · 33 Jahre'), findsOneWidget);
    expect(find.text(feld('R05-STAMM', 'Beruf')), findsOneWidget);
    expect(find.text('Frau · ${feld('R05-STAMM', 'Alter')} Jahre'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('der Schieberegler setzt die Zahl der Rollen', (tester) async {
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.besetzung));
    await bilder(tester);
    final slider = find.byType(Slider);
    await tester.tapAt(Offset(tester.getCenter(slider).dx + tester.getSize(slider).width * 0.4, tester.getCenter(slider).dy));
    await bilder(tester);
    expect(zahl(tester), greaterThan(8));
    tester.widget<Slider>(slider).onChanged!(4);
    await bilder(tester);
    expect(zahl(tester), 4);
  });
}

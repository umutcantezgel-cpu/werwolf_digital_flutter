// Steckbriefe: N Karten plus Geburtstagskind und Burgwart, aufklappbar, eine oder zwei Spalten.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mordakte/krimidinner/abschnitt_ansicht.dart';
import 'package:mordakte/krimidinner/gewoelbe_seite.dart';

import 'hilfe.dart';

int karten(WidgetTester tester) => tester.widgetList(find.byType(AbschnittAnsicht)).length;

void main() {
  testWidgets('N Karten plus Geburtstagskind und Burgwart', (tester) async {
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.steckbriefe));
    await bilder(tester);
    expect(karten(tester), 10);
    expect(find.text('Das Geburtstagskind'), findsOneWidget);
    expect(find.text('Der Burgwart'), findsOneWidget);
    expect(find.text('Adnan Hodžić'), findsOneWidget);
    expect(find.text(feld('R08-STAMM', 'Name')), findsOneWidget);
    expect(find.text(feld('R09-STAMM', 'Name')), findsNothing);
  });

  testWidgets('Aufklappen zeigt das Behauptete Alibi von R01 wörtlich', (tester) async {
    groesse(tester, const Size(390, 2400));
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.steckbriefe, n: 4));
    await bilder(tester);
    final alibi = feld('R01-ÖFFENTLICH', 'Behauptetes Alibi');
    expect(find.text(alibi), findsNothing);
    await tester.tap(find.text('Adnan Hodžić'));
    await bilder(tester);
    expect(find.text(alibi), findsOneWidget);
    expect(find.text('Behauptetes Alibi'), findsOneWidget);
    expect(find.text(feld('R01-STAMM', 'Kleidung')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ein Tipp auf die Kurzzeile oder den Rand öffnet die Karte, wie der Hinweis sagt', (tester) async {
    groesse(tester, const Size(390, 2400));
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.steckbriefe, n: 4));
    await bilder(tester);
    final bw = gewoelbe().burgwartSteckbrief;
    final inhalt = bw.eintraege.first.text;
    expect(sichtbar(tester, inhalt), isFalse);
    // Kurzzeile „71 Jahre · …“
    await tester.tap(find.text(bw.kopfzeile!));
    await bilder(tester);
    expect(sichtbar(tester, inhalt), isTrue);
    // Offen klappt nur der Kopf wieder zu; ein Tipp in den Text lässt sie offen.
    await tester.tap(find.text(inhalt).first, warnIfMissed: false);
    await bilder(tester);
    expect(sichtbar(tester, inhalt), isTrue);
    await tester.tap(find.text('Der Burgwart'));
    await bilder(tester);
    expect(sichtbar(tester, inhalt), isFalse);
    // Rand der zugeklappten Karte (links oben, innerhalb der Tafel)
    final karte = find.ancestor(of: find.text('Der Burgwart'), matching: find.byType(AbschnittAnsicht));
    await tester.tapAt(tester.getTopLeft(karte) + const Offset(4, 4));
    await bilder(tester);
    expect(sichtbar(tester, inhalt), isTrue);
  });

  testWidgets('ein Wechsel von N ändert die Zahl der Karten', (tester) async {
    groesse(tester, const Size(800, 3000));
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.steckbriefe, n: 5));
    await bilder(tester);
    expect(karten(tester), 7);
    await tester.tap(find.text('Besetzung ändern'));
    await bilder(tester);
    await tester.tap(find.byTooltip('Eine Rolle mehr'));
    await bilder(tester, 1);
    await tester.tap(find.byTooltip('Eine Rolle mehr'));
    await bilder(tester);
    await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text('Steckbriefe')));
    await bilder(tester);
    expect(karten(tester), 9);
  });

  testWidgets('alle aufklappen; eine Spalte am Telefon, zwei ab 600 px', (tester) async {
    groesse(tester, const Size(390, 9000));
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.steckbriefe, n: 6));
    await bilder(tester);
    final xTelefon = {for (final e in tester.elementList(find.byType(AbschnittAnsicht))) tester.getTopLeft(find.byWidget(e.widget)).dx};
    expect(xTelefon, hasLength(1));
    await tester.tap(find.text('Alle aufklappen'));
    await bilder(tester);
    for (var r = 1; r <= 6; r++) {
      final rr = 'R${r.toString().padLeft(2, '0')}';
      expect(find.text(feld('$rr-ÖFFENTLICH', 'Behauptetes Alibi')), findsOneWidget, reason: rr);
    }
    expect(tester.takeException(), isNull);

    groesse(tester, const Size(1280, 6000));
    await bilder(tester);
    final xBreit = {for (final e in tester.elementList(find.byType(AbschnittAnsicht))) tester.getTopLeft(find.byWidget(e.widget)).dx};
    expect(xBreit, hasLength(2));
    expect(tester.takeException(), isNull);
  });
}

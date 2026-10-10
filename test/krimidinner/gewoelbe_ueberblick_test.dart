// Überblick: Titel, Geschichte, Wer mitspielt, Ablauf, Dauer, Hinweis auf den fehlenden Abend.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mordakte/krimidinner/gewoelbe_seite.dart';

import 'hilfe.dart';

void main() {
  testWidgets('Überblick zeigt Titel, Geschichte, Mitspielende, Ablauf und Dauer', (tester) async {
    await tester.pumpWidget(gewoelbeApp());
    await bilder(tester);

    expect(find.text('Spuk im Gewölbe'), findsOneWidget);
    expect(find.text('Krimidinner auf Burg Schartenfels'), findsOneWidget);
    expect(
      sichtbar(tester, 'Den geführten Abend mit Erzähler gibt es hier noch nicht. Besetzung, Steckbriefe und Rollenmappen kannst du schon nutzen.'),
      isTrue,
    );
    expect(find.text(feld('FÜNF-SÄTZE', 'Text')), findsOneWidget);
    expect(find.text('4 bis 20 Rollen und das Geburtstagskind als Detektiv'), findsOneWidget);
    for (final teil in feld('ZM-3', 'Ablauf').split(' · ')) {
      final ohneZeit = teil.replaceFirst(RegExp(r'^\d{1,2}:\d\d\s+'), '').replaceAll(RegExp(r' nach ZM-\d'), '');
      expect(sichtbar(tester, ohneZeit), isTrue, reason: teil);
    }
    expect(find.text(feld('ZM-4', 'Dauer')), findsOneWidget);
    expect(find.text(feld('ZM-1', 'Regel')), findsOneWidget);
    expect(find.text(feld('LR-1', 'Regel')), findsOneWidget);
    expect(find.text(feld('BW-ZUSTAND', 'Zustand')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('„Die Burg“ ist aufklappbar', (tester) async {
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.ueberblick));
    await bilder(tester);
    final k001 = feld('K-001', 'Tatsache');
    expect(find.text(k001), findsNothing);
    await tester.ensureVisible(find.text('Die Burg'));
    await bilder(tester);
    await tester.tap(find.text('Die Burg'));
    await bilder(tester);
    expect(find.text(k001), findsOneWidget);
    expect(find.text(feld('K-008', 'Tatsache')), findsOneWidget);
    await tester.ensureVisible(find.text('Die Burg'));
    await bilder(tester);
    await tester.tap(find.text('Die Burg'));
    await bilder(tester);
    expect(find.text(k001), findsNothing);
  });

  testWidgets('fünf Teile in der Navigation, Telefonformat ohne Überlauf', (tester) async {
    groesse(tester, const Size(390, 844));
    await tester.pumpWidget(gewoelbeApp());
    await bilder(tester);
    for (final teil in ['Überblick', 'Besetzung', 'Steckbriefe', 'Mappen', 'Druck']) {
      expect(find.descendant(of: find.byType(NavigationBar), matching: find.text(teil)), findsOneWidget, reason: teil);
    }
    for (final icon in [
      Icons.auto_stories_rounded,
      Icons.groups_rounded,
      Icons.badge_rounded,
      Icons.visibility_off_rounded,
      Icons.print_rounded,
    ]) {
      expect(find.descendant(of: find.byType(NavigationBar), matching: find.byIcon(icon)), findsOneWidget);
    }
    for (final teil in ['Besetzung', 'Steckbriefe', 'Mappen', 'Druck', 'Überblick']) {
      await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text(teil)));
      await bilder(tester);
      expect(tester.takeException(), isNull, reason: teil);
    }
  });

  testWidgets('Einstieg über die Adresse: ?teil= und ?n=', (tester) async {
    await tester.pumpWidget(MaterialApp(home: GewoelbeSeite.ausUrl(const {'teil': 'besetzung', 'n': '12'}).kopieMitKanon()));
    await bilder(tester);
    expect(find.text('12 Rollen und das Geburtstagskind – 13 Personen'), findsOneWidget);
  });

  testWidgets('Ladefehler zeigt eine Tafel mit Text und Zurück', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: GewoelbeSeite(laden: () => Future.error(StateError('kaputt')))),
    );
    await bilder(tester);
    expect(find.text('Der Kanon des Krimidinners ließ sich nicht lesen.'), findsOneWidget);
    expect(find.text('Zurück'), findsOneWidget);
  });
}

extension on GewoelbeSeite {
  /// Dieselben Startwerte, aber mit dem echten Kanon aus dem Test.
  GewoelbeSeite kopieMitKanon() {
    final app = gewoelbeApp(teil: startTeil, n: startRollen) as MaterialApp;
    return app.home! as GewoelbeSeite;
  }
}

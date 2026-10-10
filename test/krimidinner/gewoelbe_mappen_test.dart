// Rollenmappen mit „Gerät reihum“: neutrale Liste, Zwischenstufe, offene Mappe,
// Zudecken von Hand, beim Teilwechsel, bei neuer Besetzung und wenn die App verschwindet.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mordakte/krimidinner/gewoelbe_seite.dart';

import 'hilfe.dart';

/// Ein unverwechselbarer Teil des Geheimnisses einer Rolle.
String geheim(String rolle) {
  final g = feld('$rolle-GEHEIM', 'Geheimnis').replaceAll(RegExp(r'^1\) '), '');
  return g.substring(0, 60);
}

Future<void> nav(WidgetTester tester, String teil) async {
  await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text(teil)));
  await bilder(tester);
}

Future<void> oeffne(WidgetTester tester, String name, String anrede) async {
  await tester.tap(find.text(name));
  await bilder(tester);
  await tester.tap(find.text('Ich bin $anrede – Mappe öffnen'));
  await bilder(tester);
}

bool irgendeinGeheimnis(WidgetTester tester, int n) {
  for (var r = 1; r <= n; r++) {
    if (sichtbar(tester, geheim('R${r.toString().padLeft(2, '0')}'))) return true;
  }
  return sichtbar(tester, feld('DET-B1', 'Beobachtung'));
}

void main() {
  testWidgets('Liste und Zwischenstufe zeigen keine Geheimnisse; erst „Mappe öffnen“ zeigt sie', (tester) async {
    groesse(tester, const Size(800, 2400));
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.mappen, n: 8));
    await bilder(tester);

    expect(find.text('Das Geburtstagskind'), findsOneWidget);
    for (var r = 1; r <= 8; r++) {
      expect(find.text(feld('R${r.toString().padLeft(2, '0')}-STAMM', 'Name')), findsOneWidget);
    }
    expect(find.text(feld('R09-STAMM', 'Name')), findsNothing);
    expect(find.text('gesehen'), findsNothing);
    expect(irgendeinGeheimnis(tester, 8), isFalse);

    await tester.tap(find.text('Adnan Hodžić'));
    await bilder(tester);
    expect(find.text('Gib das Gerät an Adnan. Nur Adnan schaut jetzt hin.'), findsOneWidget);
    expect(find.text('Ich bin Adnan – Mappe öffnen'), findsOneWidget);
    expect(find.text('Zurück'), findsOneWidget);
    expect(irgendeinGeheimnis(tester, 8), isFalse);

    await tester.tap(find.text('Zurück'));
    await bilder(tester);
    expect(find.text('Gib das Gerät an Adnan. Nur Adnan schaut jetzt hin.'), findsNothing);

    await oeffne(tester, 'Adnan Hodžić', 'Adnan');
    expect(sichtbar(tester, geheim('R01')), isTrue);
    expect(find.text('Mappe zudecken'), findsNWidgets(2));
    expect(find.byType(NavigationBar), findsOneWidget);
    for (final titel in ['Dein Steckbrief', 'Was du anziehst', 'Dein Geheimnis', 'Was du weißt', 'Wen du kennst', 'Lügen und Wahrheit']) {
      expect(find.text(titel), findsOneWidget, reason: titel);
    }
    for (var p = 1; p <= 3; p++) {
      expect(find.text('Deine Gespräche · Phase $p'), findsOneWidget);
    }
    expect(sichtbar(tester, geheim('R02')), isFalse, reason: 'nur das eigene Geheimnis');
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Mappe zudecken').first);
    await bilder(tester);
    expect(sichtbar(tester, geheim('R01')), isFalse);
    expect(find.text('Die Mappe von Adnan ist wieder zugedeckt.'), findsOneWidget);
    expect(find.text('gesehen'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Die Mappe von Adnan ist wieder zugedeckt.'), findsNothing);
    expect(find.text('gesehen'), findsOneWidget);
  });

  testWidgets('Teilwechsel deckt zu', (tester) async {
    groesse(tester, const Size(800, 2400));
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.mappen, n: 6));
    await bilder(tester);
    await oeffne(tester, 'Rojda Baran', 'Rojda');
    expect(sichtbar(tester, geheim('R02')), isTrue);
    await nav(tester, 'Überblick');
    expect(sichtbar(tester, geheim('R02')), isFalse);
    await nav(tester, 'Mappen');
    expect(sichtbar(tester, geheim('R02')), isFalse);
    expect(find.text('gesehen'), findsOneWidget);
  });

  testWidgets('App verborgen (AppLifecycle hidden) deckt zu', (tester) async {
    groesse(tester, const Size(800, 2400));
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.mappen, n: 6));
    await bilder(tester);
    await oeffne(tester, 'Merle Hartwig', 'Merle');
    expect(sichtbar(tester, geheim('R03')), isTrue);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    await bilder(tester);
    expect(sichtbar(tester, geheim('R03')), isFalse);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await bilder(tester);
    expect(sichtbar(tester, geheim('R03')), isFalse);
    expect(find.text('gesehen'), findsOneWidget);
  });

  testWidgets('neue Besetzung deckt zu; Zurück-Geste deckt zuerst zu', (tester) async {
    groesse(tester, const Size(800, 2400));
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.mappen, n: 6));
    await bilder(tester);
    await oeffne(tester, 'Jonas Brinkmann', 'Jonas');
    expect(sichtbar(tester, geheim('R04')), isTrue);
    final ok = await tester.binding.handlePopRoute();
    await bilder(tester);
    expect(ok, isTrue);
    expect(sichtbar(tester, geheim('R04')), isFalse);
    expect(find.byType(GewoelbeSeite), findsOneWidget);
    expect(find.text('Die Mappe von Jonas ist wieder zugedeckt.'), findsOneWidget);

    await oeffne(tester, 'Jonas Brinkmann', 'Jonas');
    await nav(tester, 'Besetzung');
    await tester.tap(find.byTooltip('Eine Rolle mehr'));
    await bilder(tester);
    await nav(tester, 'Mappen');
    expect(sichtbar(tester, geheim('R04')), isFalse);
    expect(find.text('gesehen'), findsNothing, reason: 'neue Besetzung, neue Mappen');
    expect(find.text(feld('R07-STAMM', 'Name')), findsOneWidget);
  });

  testWidgets('Detektiv-Mappe: Beobachtungen und Entscheidungen, keine Lösung', (tester) async {
    groesse(tester, const Size(800, 2400));
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.mappen, n: 4));
    await bilder(tester);
    await tester.tap(find.text('Das Geburtstagskind'));
    await bilder(tester);
    expect(find.text('Gib das Gerät an das Geburtstagskind. Nur das Geburtstagskind schaut jetzt hin.'), findsOneWidget);
    await tester.tap(find.text('Ich bin das Geburtstagskind – Mappe öffnen'));
    await bilder(tester);
    for (var i = 1; i <= 6; i++) {
      expect(sichtbar(tester, feld('DET-B$i', 'Beobachtung')), isTrue, reason: 'DET-B$i');
    }
    expect(find.text('Deine neun Entscheidungen'), findsOneWidget);
    expect(sichtbar(tester, feld('D3-1', 'Frage')), isTrue);
    expect(sichtbar(tester, 'Was deine Wahl ergibt, erfährst du am Abend.'), isTrue);
    expect(find.text('So läuft die Anklage'), findsOneWidget);
    for (var p = 1; p <= 3; p++) {
      for (var i = 1; i <= 3; i++) {
        for (final o in ['A', 'B', 'C']) {
          expect(sichtbar(tester, feld('DW$p-$i', 'Ergebnis $o')), isFalse, reason: 'DW$p-$i $o');
        }
      }
    }
    final loesung = [
      for (final d in echterKanon().datensaetze.values)
        if (RegExp(r'^(DW|AB|EM|GS|K-09)').hasMatch(d.id))
          for (final v in d.felder.values)
            if (v.length >= 12) normal(v),
    ];
    expect(loesung, isNotEmpty);
    final text = normal(alleTexte(tester).join(' ¦ '));
    expect(loesung.where(text.contains), isEmpty);
    // Der untere Knopf am Ende der Mappe deckt ebenso zu.
    await tester.ensureVisible(find.text('Mappe zudecken').last);
    await bilder(tester);
    await tester.tap(find.text('Mappe zudecken').last);
    await bilder(tester);
    expect(find.text('Die Mappe des Geburtstagskinds ist wieder zugedeckt.'), findsOneWidget);
    expect(sichtbar(tester, feld('DET-B1', 'Beobachtung')), isFalse);
  });

  testWidgets('offene Mappe im Telefonformat ohne Überlauf', (tester) async {
    groesse(tester, const Size(390, 844));
    await tester.pumpWidget(gewoelbeApp(teil: GewoelbeTeil.mappen, n: 20));
    await bilder(tester);
    await tester.tap(find.text('Rojda Baran'));
    await bilder(tester);
    await tester.tap(find.text('Ich bin Rojda – Mappe öffnen'));
    await bilder(tester);
    expect(tester.takeException(), isNull);
  });
}

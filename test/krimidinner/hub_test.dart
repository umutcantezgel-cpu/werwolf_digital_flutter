// Hub: drei gleichrangige Bereiche, beide Partyabende nebeneinander, Wege zu
// /party und /gewoelbe, kein Überlauf bei 360 px.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mordakte/krimidinner/gewoelbe_seite.dart';
import 'package:mordakte/krimidinner/kanon_laden.dart';
import 'package:mordakte/ui/screens/hub_screen.dart';
import 'package:mordakte/ui/widgets/bento.dart';

import 'hilfe.dart';

Finder kachel(String titel) => find.ancestor(of: find.text(titel), matching: find.byType(BentoTile));

String pfad(WidgetTester tester) => GoRouter.of(tester.element(find.byType(Navigator).first)).state.matchedLocation;

void main() {
  setUpAll(schriftenLaden);

  // Zuerst: Der zwischengespeicherte Kanon wird hier echt geladen (runAsync), danach
  // nutzt der Tipp auf „Spuk im Gewölbe“ dasselbe fertige Ergebnis.
  testWidgets('der Kanon kommt aus dem Asset-Bündel (nur K*.md)', (tester) async {
    final k = await tester.runAsync(ladeGewoelbeKanon);
    expect(k, isNotNull);
    expect(k!.datensaetze.length, greaterThanOrEqualTo(1200));
    expect(k.lesefehler, isEmpty);
    expect(k.datensaetze.values.map((d) => d.datei).every((d) => d.startsWith('K')), isTrue);
    expect(identical(await tester.runAsync(ladeGewoelbeKanon), k), isTrue, reason: 'zwischengespeichert');
  });

  testWidgets('Bereiche in Reihenfolge, Partyabende gleich breit über den Fallakten', (tester) async {
    groesse(tester, const Size(430, 1400));
    await tester.pumpWidget(hubApp());
    await bilder(tester, 8);

    final party = tester.getTopLeft(find.text('Partyabende')).dy;
    final klassisch = tester.getTopLeft(find.text('Klassische Fälle')).dy;
    final meta = tester.getTopLeft(find.text('Sammlung und Profil')).dy;
    expect(party, lessThan(klassisch));
    expect(klassisch, lessThan(meta));

    final keller = kachel('Spuk im Schlosskeller');
    final gewoelbe = kachel('Spuk im Gewölbe');
    expect(keller, findsOneWidget);
    expect(gewoelbe, findsOneWidget);
    expect(tester.getTopLeft(keller).dy, tester.getTopLeft(gewoelbe).dy);
    expect(tester.getSize(keller).width, closeTo(tester.getSize(gewoelbe).width, 0.5));
    expect(tester.getSize(keller).height, tester.getSize(gewoelbe).height);
    expect(tester.getTopLeft(keller).dx, lessThan(tester.getTopLeft(gewoelbe).dx));
    expect(tester.widget<BentoTile>(keller).highlight, isTrue);
    expect(tester.widget<BentoTile>(gewoelbe).highlight, isTrue);

    final fallakten = kachel('Fallakten');
    expect(fallakten, findsOneWidget);
    expect(tester.getTopLeft(gewoelbe).dy, lessThan(tester.getTopLeft(fallakten).dy));
    expect(tester.getTopLeft(fallakten).dy, greaterThan(klassisch));
    for (final titel in ['Online spielen', 'Sammlung', 'Profil']) {
      expect(kachel(titel), findsOneWidget, reason: titel);
      expect(tester.getTopLeft(kachel(titel)).dy, greaterThan(klassisch), reason: titel);
    }
    expect(tester.getTopLeft(kachel('Sammlung')).dy, greaterThan(meta));
    // Die alte Partykachel ist weg.
    expect(find.text('Partyabend: Spuk im Schlosskeller'), findsNothing);
  });

  testWidgets('Tipp auf „Spuk im Gewölbe“ öffnet den Begleiter', (tester) async {
    groesse(tester, const Size(430, 1400));
    await tester.pumpWidget(hubApp());
    await bilder(tester, 6);
    await tester.tap(find.text('Spuk im Gewölbe'));
    await bilder(tester, 6);
    expect(find.byType(GewoelbeSeite), findsOneWidget);
    expect(pfad(tester), '/gewoelbe');
  });

  testWidgets('Tipp auf „Spuk im Schlosskeller“ führt zu /party', (tester) async {
    groesse(tester, const Size(430, 1400));
    await tester.pumpWidget(hubApp());
    await bilder(tester, 6);
    await tester.tap(find.text('Spuk im Schlosskeller'));
    await bilder(tester, 6);
    expect(pfad(tester), '/party');
    expect(find.byType(HubScreen, skipOffstage: false), findsOneWidget, reason: 'push: Der Hub bleibt darunter');
  });

  testWidgets('bei 360 px Breite kein Überlauf', (tester) async {
    groesse(tester, const Size(360, 780));
    await tester.pumpWidget(hubApp());
    await bilder(tester, 8);
    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -900));
    await bilder(tester, 4);
    expect(tester.takeException(), isNull);
  });
}

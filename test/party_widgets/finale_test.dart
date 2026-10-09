// F4-BAUMEISTER-06: Anklage, Finale mit Rückblende, Auflösung und Ende.
// Jeder Test prüft eine Sache. Die Rückblende wird am Ende abgebaut, damit kein Timer offen bleibt.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte/party/bildschirme/anklage.dart';
import 'package:mordakte/party/bildschirme/aufloesung.dart';
import 'package:mordakte/party/bildschirme/finale.dart';
import 'package:mordakte/party/sitzung.dart';

import 'hilfe.dart';

/// Sieben Personen mit festen Spielernamen, Täter-Pfad Ahmet.
PartySitzung mitNamen() {
  final s = PartySitzung(partyDaten);
  s.einrichten(
    rollen: 7,
    detektiv: 'w',
    code: FallCode.fuerPfad('ahmet', partyDaten.kanon.pfade).code,
    namen: {for (final r in s.rollenBei(7)) r: 'Name-$r'},
  );
  return s;
}

void main() {
  testWidgets('Anklage zeigt die vier Kernpersonen mit ihrem Namen', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.anklage);
    await t.pumpWidget(rahmen(AnklageBildschirm(sitzung: s)));
    expect(s.kernverdaechtige, hasLength(4));
    for (final p in s.kernverdaechtige) {
      expect(find.text(s.figurName(p)), findsOneWidget, reason: p);
    }
  });

  testWidgets('ohne Auswahl ist Weiter gesperrt', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.anklage);
    await t.pumpWidget(rahmen(AnklageBildschirm(sitzung: s)));
    final weiter = t.widget<FilledButton>(find.widgetWithText(FilledButton, s.ui('ui.allgemein.weiter')));
    expect(weiter.onPressed, isNull);
  });

  testWidgets('Antippen, Anklagen und Ja setzen die Anklage', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.anklage);
    await t.pumpWidget(rahmen(AnklageBildschirm(sitzung: s)));
    final p = s.kernverdaechtige.first;
    await t.tap(find.text(s.figurName(p)));
    await t.pump();
    await t.tap(find.text(s.ui('ui.anklage.anklagen')));
    await t.pumpAndSettle();
    await t.tap(find.text(s.ui('ui.anklage.ja')));
    await t.pumpAndSettle();
    expect(s.angeklagt, p);
  });

  testWidgets('„Noch nicht“ in der Bestätigung klagt niemanden an', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.anklage);
    await t.pumpWidget(rahmen(AnklageBildschirm(sitzung: s)));
    await t.tap(find.text(s.figurName(s.kernverdaechtige.first)));
    await t.pump();
    await t.tap(find.text(s.ui('ui.anklage.anklagen')));
    await t.pumpAndSettle();
    await t.tap(find.text(s.ui('ui.anklage.nein')));
    await t.pumpAndSettle();
    expect(s.angeklagt, isNull);
  });

  testWidgets('nach der Anklage ist der Knopf Anklagen gesperrt', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.anklage);
    await t.pumpWidget(rahmen(AnklageBildschirm(sitzung: s)));
    await t.tap(find.text(s.figurName(s.kernverdaechtige.first)));
    await t.pump();
    await t.tap(find.text(s.ui('ui.anklage.anklagen')));
    await t.pumpAndSettle();
    await t.tap(find.text(s.ui('ui.anklage.ja')));
    await t.pumpAndSettle();
    final anklagen = t.widget<FilledButton>(find.widgetWithText(FilledButton, s.ui('ui.anklage.anklagen')));
    expect(anklagen.onPressed, isNull);
  });

  testWidgets('Weiter nach der Anklage führt ins Finale', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.anklage);
    s.anklagen(s.kernverdaechtige.first);
    await t.pumpWidget(rahmen(AnklageBildschirm(sitzung: s)));
    await t.tap(find.text(s.ui('ui.allgemein.weiter')));
    await t.pump();
    expect(s.phase, PartyPhase.finale);
  });

  testWidgets('Finale zeigt den Namen des Endes und den Finaltext', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.finale);
    await t.pumpWidget(rahmen(FinaleBildschirm(sitzung: s)));
    await t.pump(const Duration(milliseconds: 200));
    expect(find.text(s.ende.name), findsOneWidget);
    expect(find.text(s.text('finale.${s.pfad}.${s.ende.id}')), findsOneWidget);
    await t.pumpWidget(const SizedBox());
  });

  testWidgets('Auflösung zeigt für jede besetzte Rolle den Spielernamen', (t) async {
    final s = mitNamen();
    spieleBis(s, PartyPhase.aufloesung);
    await t.pumpWidget(rahmen(AufloesungBildschirm(sitzung: s)));
    for (final r in s.besetzt) {
      expect(find.text(s.spielerName(r)), findsOneWidget, reason: r);
    }
  });

  testWidgets('Ende zeigt „9 von 9“ bei bester Wahl', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.ende);
    await t.pumpWidget(rahmen(AufloesungBildschirm(sitzung: s)));
    expect(find.text('9 von 9'), findsOneWidget);
  });

  testWidgets('Ende zeigt den Fall-Code', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.ende);
    await t.pumpWidget(rahmen(AufloesungBildschirm(sitzung: s)));
    expect(find.text(s.fallCode.code), findsOneWidget);
  });

  testWidgets('im Ende gibt es keinen Weiter-Knopf', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.ende);
    await t.pumpWidget(rahmen(AufloesungBildschirm(sitzung: s)));
    expect(find.widgetWithText(FilledButton, s.ui('ui.allgemein.weiter')), findsNothing);
  });

  for (final g in [const Size(1280, 800), const Size(390, 844)]) {
    testWidgets('kein Überlauf bei ${g.width.toInt()} x ${g.height.toInt()}', (t) async {
      t.view.physicalSize = g;
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      final s = neueSitzung(rollen: 7);
      spieleBis(s, PartyPhase.anklage);
      await t.pumpWidget(rahmen(AnklageBildschirm(sitzung: s)));
      expect(t.takeException(), isNull, reason: 'Anklage bei $g');
      s.anklagen(s.kernverdaechtige.first);
      await t.pump();
      expect(t.takeException(), isNull, reason: 'Anklage bestätigt bei $g');
      s.weiter();
      await t.pumpWidget(rahmen(FinaleBildschirm(sitzung: s)));
      await t.pump(const Duration(milliseconds: 200));
      expect(t.takeException(), isNull, reason: 'Finale bei $g');
      await t.pumpWidget(const SizedBox());
      s.weiter();
      await t.pumpWidget(rahmen(AufloesungBildschirm(sitzung: s)));
      expect(t.takeException(), isNull, reason: 'Auflösung bei $g');
      s.weiter();
      await t.pumpWidget(rahmen(AufloesungBildschirm(sitzung: s)));
      expect(t.takeException(), isNull, reason: 'Ende bei $g');
    });
  }
}

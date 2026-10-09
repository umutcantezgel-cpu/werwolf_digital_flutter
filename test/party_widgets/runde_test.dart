// F4-BAUMEISTER-03: Rundenzentrale mit Uhr und Pflichtgesprächen (Master 7.6 Schritt 5).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte/party/bildschirme/runde.dart';
import 'package:mordakte/party/sitzung.dart';

import 'hilfe.dart';

/// Runde 1 mit einer Uhr von fünf Sekunden auf dem Bildschirm.
Future<PartySitzung> _uhrBild(WidgetTester t) async {
  final s = neueSitzung(rollen: 7);
  spieleBis(s, PartyPhase.gespraeche);
  s.rundendauer = const Duration(seconds: 5);
  await t.pumpWidget(rahmen(RundeBildschirm(sitzung: s)));
  return s;
}

/// Tippt einen Knopf der Uhr. Der Bildschirm ist lang, daher erst in den Blick scrollen.
Future<void> _tippe(WidgetTester t, String tipp) async {
  final knopf = find.byTooltip(tipp);
  await t.ensureVisible(knopf);
  await t.tap(knopf);
}

void main() {
  testWidgets('Runde 1 zeigt Rundennamen und Uhrzeit 00:30', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.gespraeche, runde: 1);
    await t.pumpWidget(rahmen(RundeBildschirm(sitzung: s)));
    expect(find.text(s.rundenName), findsOneWidget);
    expect(find.textContaining('00:30'), findsOneWidget);
  });

  testWidgets('Runde 2 zeigt Uhrzeit 01:15', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.gespraeche, runde: 2);
    await t.pumpWidget(rahmen(RundeBildschirm(sitzung: s)));
    expect(find.text(s.rundenName), findsOneWidget);
    expect(find.textContaining('01:15'), findsOneWidget);
  });

  testWidgets('Uhr startet bei der Rundendauer', (t) async {
    await _uhrBild(t);
    expect(find.text('00:05'), findsOneWidget);
  });

  testWidgets('Uhr läuft nach Start herunter', (t) async {
    final s = await _uhrBild(t);
    await _tippe(t, s.ui('ui.runde.start'));
    await t.pump(const Duration(seconds: 2));
    expect(find.text('00:03'), findsOneWidget);
  });

  testWidgets('Pause hält die Uhr an', (t) async {
    final s = await _uhrBild(t);
    await _tippe(t, s.ui('ui.runde.start'));
    await t.pump(const Duration(seconds: 2));
    await _tippe(t, s.ui('ui.runde.pause'));
    await t.pump(const Duration(seconds: 3));
    expect(find.text('00:03'), findsOneWidget);
  });

  testWidgets('Zurücksetzen stellt die Rundendauer wieder her', (t) async {
    final s = await _uhrBild(t);
    await _tippe(t, s.ui('ui.runde.start'));
    await t.pump(const Duration(seconds: 2));
    await _tippe(t, s.ui('ui.runde.zuruecksetzen'));
    await t.pump();
    expect(find.text('00:05'), findsOneWidget);
  });

  testWidgets('bei 0 erscheint der Baustein Die Zeit ist um', (t) async {
    final s = await _uhrBild(t);
    await _tippe(t, s.ui('ui.runde.start'));
    await t.pump(const Duration(seconds: 6));
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text(s.ui('ui.runde.zeit_um')), findsOneWidget);
  });

  testWidgets('bei 0 bleibt die Uhr stehen und schaltet nicht weiter', (t) async {
    final s = await _uhrBild(t);
    await _tippe(t, s.ui('ui.runde.start'));
    await t.pump(const Duration(seconds: 9));
    expect(find.text('00:00'), findsOneWidget);
    expect(s.phase, PartyPhase.gespraeche);
  });

  testWidgets('jede Gesprächszeile nennt Sprecher und Partner mit Namen', (t) async {
    final s = PartySitzung(partyDaten);
    s.einrichten(
      rollen: 7,
      detektiv: 'w',
      code: FallCode.fuerPfad('ahmet', partyDaten.kanon.pfade).code,
      namen: {'ahmet': 'Lena'},
    );
    spieleBis(s, PartyPhase.gespraeche);
    await t.pumpWidget(rahmen(RundeBildschirm(sitzung: s)));
    final gespraeche = s.gespraeche(s.runde);
    expect(gespraeche, isNotEmpty);
    for (final z in gespraeche) {
      final zeile = find.byKey(ValueKey(z.gespraech.id));
      final paarung = s.ui('ui.runde.paarung', {
        'sprecher': s.spielerName(z.gespraech.rolle),
        'partner': s.personAmTisch(z.partner),
      });
      expect(find.descendant(of: zeile, matching: find.text(paarung)), findsOneWidget, reason: z.gespraech.id);
    }
    expect(find.textContaining('Lena'), findsWidgets);
  });

  testWidgets('kein Ziel eines Gesprächs ist sichtbar', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.gespraeche, runde: 2);
    await t.pumpWidget(rahmen(RundeBildschirm(sitzung: s)));
    final gespraeche = s.gespraeche(2);
    expect(gespraeche, isNotEmpty);
    for (final z in gespraeche) {
      expect(z.gespraech.ziel, isNotEmpty);
      expect(find.textContaining(z.gespraech.ziel), findsNothing, reason: z.gespraech.id);
    }
  });

  testWidgets('kein Eröffnungssatz eines Gesprächs ist sichtbar', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.gespraeche, runde: 2);
    await t.pumpWidget(rahmen(RundeBildschirm(sitzung: s)));
    final gespraeche = s.gespraeche(2);
    expect(gespraeche, isNotEmpty);
    for (final z in gespraeche) {
      expect(z.gespraech.text, isNotEmpty);
      expect(find.textContaining(z.gespraech.text), findsNothing, reason: z.gespraech.id);
    }
  });

  testWidgets('Weiter führt zur Ermittlung auf der Karte', (t) async {
    final s = neueSitzung(rollen: 7);
    spieleBis(s, PartyPhase.gespraeche);
    await t.pumpWidget(rahmen(RundeBildschirm(sitzung: s)));
    await t.tap(find.text(s.ui('ui.runde.weiter')));
    expect(s.phase, PartyPhase.entscheidungen);
  });

  testWidgets('kein Überlauf auf 1280 × 800 mit 20 Rollen', (t) async {
    t.view.physicalSize = const Size(1280, 800);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    final s = neueSitzung(rollen: 20);
    spieleBis(s, PartyPhase.gespraeche);
    expect(s.besetzt, hasLength(20));
    await t.pumpWidget(rahmen(RundeBildschirm(sitzung: s)));
    expect(t.takeException(), isNull);
  });

  testWidgets('kein Überlauf auf 390 × 844 mit 20 Rollen', (t) async {
    t.view.physicalSize = const Size(390, 844);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    final s = neueSitzung(rollen: 20);
    spieleBis(s, PartyPhase.gespraeche);
    expect(s.besetzt, hasLength(20));
    await t.pumpWidget(rahmen(RundeBildschirm(sitzung: s)));
    expect(t.takeException(), isNull);
  });
}

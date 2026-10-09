// F5-BAUMEISTER-04: Druckfassung in der App (Master 7.6, 7.14). Die Tafel steht
// nur bei eingestelltem Druck in der Rollenvergabe und bietet die acht Dateien an.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte/party/bildschirme/rollen.dart';
import 'package:mordakte/party/sitzung.dart';

import 'hilfe.dart';

PartySitzung _sitzung({required bool druck}) => PartySitzung(partyDaten)
  ..einrichten(rollen: 5, detektiv: 'w', code: FallCode.fuerPfad('olli', partyDaten.kanon.pfade).code, druck: druck);

Future<void> _zeige(WidgetTester t, PartySitzung s) async {
  t.view.physicalSize = const Size(1280, 1600);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
  await t.pumpWidget(rahmen(RollenBildschirm(sitzung: s)));
}

const _teile = ['spielleitung', 'detektivbogen', 'rollenhefte', 'fassungen', 'stimmkarten', 'indizkarten', 'umschlaege', 'aufloesung'];

void main() {
  testWidgets('ohne Druck gibt es keine Druckfassung', (t) async {
    final s = _sitzung(druck: false);
    await _zeige(t, s);
    expect(find.text(s.ui('ui.druck.app.titel')), findsNothing);
    expect(find.text(s.ui('ui.druck.app.erstellen')), findsNothing);
  });

  testWidgets('mit Druck steht die Tafel mit Fall-Code und Knopf in der Rollenvergabe', (t) async {
    final s = _sitzung(druck: true);
    await _zeige(t, s);
    expect(find.text(s.ui('ui.druck.app.titel')), findsOneWidget);
    expect(find.text(s.ui('ui.druck.app.hinweis', {'code': s.fallCode.code})), findsOneWidget);
    expect(find.text(s.ui('ui.druck.app.erstellen')), findsOneWidget);
    // Neutral: kein Dateiknopf vor dem Erstellen, kein Pfad, kein Tätername im Hinweis.
    for (final teil in _teile) {
      expect(find.text(s.ui('ui.druck.datei.$teil')), findsNothing, reason: teil);
    }
  });

  testWidgets('Erstellen bietet die acht Dateien an; ohne Browser kommt der Hinweis', (t) async {
    final s = _sitzung(druck: true);
    await _zeige(t, s);
    await t.tap(find.text(s.ui('ui.druck.app.erstellen')));
    await t.pump();
    expect(find.text(s.ui('ui.druck.app.laedt')), findsOneWidget);
    for (var i = 0; i < 300 && find.text(s.ui('ui.druck.datei.spielleitung')).evaluate().isEmpty; i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
      await t.pump(const Duration(milliseconds: 20));
    }
    for (final teil in _teile) {
      expect(find.text(s.ui('ui.druck.datei.$teil')), findsOneWidget, reason: teil);
    }
    await t.ensureVisible(find.text(s.ui('ui.druck.datei.aufloesung')));
    await t.tap(find.text(s.ui('ui.druck.datei.aufloesung')));
    await t.pump();
    expect(find.text(s.ui('ui.druck.app.nur_browser')), findsOneWidget);
  });
}

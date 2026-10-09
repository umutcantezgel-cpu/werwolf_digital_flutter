// F4-BAUMEISTER-09: Fundkarte nach einer Entscheidung (Master 7.7, 7.10). Personen- und
// Ortskarte aus dem Kanon, Fundtexte wortgleich, Verstanden ruft die Ansicht einmal auf.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte/party/bildschirme/npc_karte.dart';
import 'package:mordakte/party/sitzung.dart';

import 'hilfe.dart';

/// Ziel einer Option auf der Karte (aus dem Kanon).
KartenZiel _ziel(String option) => partyDaten.karte.ziele[option]!;

/// Die Fundkarte wie im Kartenbildschirm: zentriert, in Tafelbreite, scrollbar.
Widget _karte(PartySitzung s, String option, {String pfad = 'ahmet', VoidCallback? onGelesen}) => rahmen(
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: FundKarte(
                sitzung: s,
                ziel: _ziel(option),
                funde: partyDaten.karte.ermittlung.aufdecken(option, pfad),
                onGelesen: onGelesen ?? () {},
              ),
            ),
          ),
        ),
      ),
    );

/// Fenstergröße in logischen Pixeln (Dichte 1), am Testende zurückgesetzt.
void _fenster(WidgetTester t, Size groesse) {
  t.view.physicalSize = groesse;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.resetPhysicalSize);
  addTearDown(t.view.resetDevicePixelRatio);
}

/// Pumpt jede Fundkarte aller Optionen in allen Pfaden und prüft nach jeder, ob ein Fehler auftrat.
Future<void> _alleKarten(WidgetTester t, PartySitzung s) async {
  for (final pfad in partyDaten.kanon.pfade) {
    for (final ziel in partyDaten.karte.ziele.values) {
      await t.pumpWidget(_karte(s, ziel.option, pfad: pfad));
      expect(t.takeException(), isNull, reason: '${ziel.option} · $pfad');
    }
  }
}

void main() {
  testWidgets('Personenziel Damir zeigt den Namen der Figur', (t) async {
    final s = neueSitzung(rollen: 4);
    await t.pumpWidget(_karte(s, 'e1_1_damir'));
    expect(find.text(s.figurName('enes')), findsOneWidget);
  });

  testWidgets('Unbesetzte Person (4 Rollen) zeigt den Baustein ohne Gast', (t) async {
    final s = neueSitzung(rollen: 4);
    await t.pumpWidget(_karte(s, 'e1_1_damir'));
    expect(find.text(s.ui('ui.npc.unbesetzt')), findsOneWidget);
  });

  testWidgets('Besetzte Person (20 Rollen) spricht den Spielernamen an', (t) async {
    final s = PartySitzung(partyDaten)
      ..einrichten(rollen: 20, detektiv: 'w', code: FallCode.fuerPfad('ahmet', partyDaten.kanon.pfade).code, namen: {'enes': 'Lukas'});
    await t.pumpWidget(_karte(s, 'e1_1_damir'));
    expect(find.text(s.ui('ui.npc.besetzt', {'name': 'Lukas'})), findsOneWidget);
  });

  testWidgets('Gegenstand an einer Person zeigt den Namen des Trägers', (t) async {
    final s = neueSitzung(rollen: 4);
    await t.pumpWidget(_karte(s, 'e2_1_bauchtasche'));
    expect(find.text(s.figurName('can')), findsOneWidget);
  });

  testWidgets('Gegenstand an einer Person zeigt den Gegenstand als Unterzeile', (t) async {
    final s = neueSitzung(rollen: 4);
    await t.pumpWidget(_karte(s, 'e2_1_bauchtasche'));
    expect(find.text(_ziel('e2_1_bauchtasche').name), findsOneWidget);
  });

  testWidgets('Ortsziel Turmgang zeigt den Raumnamen', (t) async {
    final s = neueSitzung(rollen: 4);
    await t.pumpWidget(_karte(s, 'e3_1_turmgang'));
    expect(find.text(s.kanon.graph.raeume['turmgang']!.anzeigename), findsOneWidget);
  });

  testWidgets('Gegenstand im Raum zeigt den Raumnamen als leise Zeile', (t) async {
    final s = neueSitzung(rollen: 4);
    await t.pumpWidget(_karte(s, 'e2_1_ascheneimer'));
    expect(find.text(s.kanon.graph.raeume[_ziel('e2_1_ascheneimer').raum]!.anzeigename), findsOneWidget);
  });

  testWidgets('Alle Fundtexte erscheinen wortgleich in allen vier Pfaden', (t) async {
    final s = neueSitzung(rollen: 7);
    var geprueft = 0;
    for (final pfad in partyDaten.kanon.pfade) {
      for (final ziel in partyDaten.karte.ziele.values) {
        await t.pumpWidget(_karte(s, ziel.option, pfad: pfad));
        for (final f in partyDaten.karte.ermittlung.aufdecken(ziel.option, pfad)) {
          expect(find.text(f.text), findsOneWidget, reason: '${ziel.option} · $pfad · ${f.fakt}');
          geprueft++;
        }
      }
    }
    expect(geprueft, greaterThan(0), reason: 'keine Fundtexte geprüft');
  });

  testWidgets('Verstanden ruft onGelesen genau einmal', (t) async {
    final s = neueSitzung(rollen: 4);
    var gelesen = 0;
    await t.pumpWidget(_karte(s, 'e2_1_bauchtasche', onGelesen: () {
      gelesen++;
    }));
    await t.ensureVisible(find.text(s.ui('ui.karte.gelesen')));
    await t.tap(find.text(s.ui('ui.karte.gelesen')));
    await t.pump();
    expect(gelesen, 1);
  });

  testWidgets('Fundkarte läuft bei 1280 × 800 ohne Überlauf', (t) async {
    _fenster(t, const Size(1280, 800));
    await _alleKarten(t, neueSitzung(rollen: 20));
  });

  testWidgets('Fundkarte läuft bei 390 × 844 ohne Überlauf', (t) async {
    _fenster(t, const Size(390, 844));
    await _alleKarten(t, neueSitzung(rollen: 20));
  });
}

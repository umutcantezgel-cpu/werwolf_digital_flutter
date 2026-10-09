// F4-ORCH-02: Der Abend läuft über die Sitzung vom Titel bis zum Ende, jeder
// Abschnitt hat einen Bildschirm, und vor dem Finale gibt die Sitzung den
// Pfad nur in der verdeckten Ansicht preis (E-008).
import 'package:flutter_test/flutter_test.dart';
import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte/party/party_seite.dart';

import 'hilfe.dart';

void main() {
  test('Sitzung: Titel bis Ende mit bester Wahl ergibt das Meister-Ende', () {
    final s = neueSitzung();
    spieleBis(s, PartyPhase.ende);
    expect(s.ende.id, 'ende_meister');
    expect(s.funde, hasLength(9));
  });

  test('vor dem Finale kein Pfad außerhalb der verdeckten Ansicht', () {
    final s = neueSitzung(rollen: 7);
    expect(() => s.pfad, throwsStateError);
    expect(() => s.istTaeter('ahmet'), throwsStateError);
    expect(() => s.dossier('ahmet'), throwsStateError);
    s.zeigeVerdeckt('ahmet');
    expect(s.istTaeter('ahmet'), isTrue);
    expect(s.dossier('ahmet').taeter, isTrue);
    s.verdecken();
    expect(() => s.wahl('fatma'), throwsStateError);
  });

  test('Gruppenwahl: Sabotage ist das B der Täterrolle, nie eine Zahl', () {
    final s = neueSitzung(rollen: 4);
    spieleBis(s, PartyPhase.gruppenwahl);
    s.zeigeVerdeckt('ahmet');
    final w = s.wahl('ahmet');
    expect(w.b, s.daten.texte.sammlung.wahlen['gw_ahmet_1']!.sabotage);
    s.stimme('ahmet', kooperativ: false);
    for (final r in ['fatma', 'olli', 'can']) {
      s.zeigeVerdeckt(r);
      expect(s.wahl(r).b, s.daten.texte.sammlung.wahlen['gw_${r}_1']!.b);
      s.stimme(r, kooperativ: true);
    }
    expect(s.alleGestimmt, isTrue);
    expect(s.kannWeiter, isTrue);
  });

  testWidgets('jeder Abschnitt außer der Karte baut einen Bildschirm', (t) async {
    final s = neueSitzung();
    for (final p in PartyPhase.values) {
      if (p == PartyPhase.entscheidungen || p == PartyPhase.finale) continue;
      spieleBis(s, p);
      await t.pumpWidget(rahmen(bildschirm(s)));
      expect(t.takeException(), isNull, reason: p.name);
    }
  });
}

// L2 · Eigenschaften der Zugschicht (A-5). Fallzahl je Eigenschaft über
// BOLLWERK_FAELLE (schnell 500, phase 2.000, nacht 10.000); Generator über Rng,
// bei einem Fehler steht der Seed in der Meldung.
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte_core/src/runden/wuerfel.dart';
import 'package:mordakte_core/src/runden/zugschicht.dart';
import 'package:test/test.dart';

import '../party/kanon_hilfe.dart';

final int faelle = int.tryParse(Platform.environment['BOLLWERK_FAELLE'] ?? '') ?? 500;

/// Eine Partie mit zufälligen Wahlen, Strategien und Tischrufen; Würfel aus [quelle].
Zugschicht spiele(Ermittlung erm, String pfad, Map<String, String> wahl, WuerfelQuelle quelle, Rng r) {
  final z = Zugschicht(erm, quelle)..setzePfad(pfad);
  for (final runde in [1, 2, 3]) {
    z.beginneRunde(runde);
    if (runde == 1) z.auftakt();
    var a = 0;
    while (z.offen.isNotEmpty) {
      while (z.abstecherErlaubt() && r.chance(0.6)) {
        z.abstecher('a${runde}_${a++}', mitWurf: r.chance(0.3), werkzeug: r.chance(0.3), marke: r.chance(0.3));
      }
      final eid = z.offen.first;
      if (z.waehle(wahl[eid]!, gruendlich: r.chance(0.2))) {
        while (z.untersuchungOffen) {
          z.anlauf(werkzeug: r.chance(0.3), marke: r.chance(0.3));
          if (z.wartetAufTischruf) z.tischruf(r.chance(0.5) ? Tischruf.nochmal : Tischruf.umweg);
        }
      }
    }
    z.beendeRunde();
  }
  return z;
}

Map<String, String> zufallsWahl(Ermittlung erm, Rng r) =>
    {for (final e in erm.entscheidungen) e.id: e.optionen[r.nextInt(e.optionen.length)].id};

void main() {
  final erm = Ermittlung(kanon);
  final sim = Simulator(kanon);

  test('Pech-Garantie: höchstens zwei Pech in Folge, jede Untersuchung endet ($faelle Fälle)', () {
    for (var i = 0; i < faelle; i++) {
      final r = Rng(Rng.hashString('L2:garantie:$i'));
      final pfad = kanon.pfade[r.nextInt(4)];
      final z = spiele(erm, pfad, zufallsWahl(erm, r), const FesterWuerfel.pech(), r);
      expect(z.maxPechFolge, lessThanOrEqualTo(2), reason: 'Seed L2:garantie:$i');
      expect(z.aufgedeckt.length, 9, reason: 'Seed L2:garantie:$i');
      expect(z.budgetUeber, 0, reason: 'Seed L2:garantie:$i');
      expect(z.kettenverletzungen, 0, reason: 'Seed L2:garantie:$i');
    }
  });

  test('Wahl vor Wurf und Wertung unantastbar (WÜ-4, $faelle Fälle)', () {
    for (var i = 0; i < faelle; i++) {
      final r = Rng(Rng.hashString('L2:wertung:$i'));
      final pfad = kanon.pfade[r.nextInt(4)];
      final wahl = zufallsWahl(erm, r);
      final z = spiele(erm, pfad, wahl, SalzWuerfel('salz$i'), r);
      expect(z.gewaehlt, wahl, reason: 'Seed L2:wertung:$i');
      final ohne = sim.verlauf(pfad, [for (final e in erm.entscheidungen) wahl[e.id]!]);
      final mit = z.wertung(sim, pfad);
      expect(mit.punkte, ohne.punkte, reason: 'Seed L2:wertung:$i');
      expect(mit.fakten, ohne.fakten, reason: 'Seed L2:wertung:$i');
      expect(mit.rest, ohne.rest, reason: 'Seed L2:wertung:$i');
      expect(z.fakten, ohne.fakten, reason: 'Seed L2:wertung:$i');
    }
  });

  test('Faktenstand beim Öffnen gleich dem Lauf ohne Würfel (K-14, $faelle Fälle)', () {
    for (var i = 0; i < faelle; i++) {
      final r = Rng(Rng.hashString('L2:stand:$i'));
      final pfad = kanon.pfade[r.nextInt(4)];
      final wahl = zufallsWahl(erm, r);
      final neutral = spiele(erm, pfad, wahl, const FesterWuerfel.neutral(), Rng(1));
      final mit = spiele(erm, pfad, wahl, SalzWuerfel('s$i'), r);
      for (final e in neutral.standBeimOeffnen.entries) {
        expect(mit.standBeimOeffnen[e.key], e.value, reason: 'Seed L2:stand:$i ${e.key}');
      }
    }
  });

  test('Seed nach WÜ-1: gleiche Augen je Entscheidung und Anlauf, unabhängig von der Option ($faelle Fälle)', () {
    for (var i = 0; i < faelle; i++) {
      final q = SalzWuerfel('salz$i');
      final e = erm.entscheidungen[i % 9];
      final a = q.augen(e.id, 1 + i % 3);
      expect(q.augen(e.id, 1 + i % 3), a);
      expect(a.$1, inInclusiveRange(1, 6));
      expect(a.$2, inInclusiveRange(1, 6));
      expect(SalzWuerfel.seedText('salz$i', e.id, 1), 'wuerfel:salz$i:${e.id}:1');
    }
  });

  test('Chancen vor dem Wurf: Summe 100, gleiche Chance für alle Optionen, Garantie ohne Pech', () {
    for (var mod = 0; mod <= 2; mod++) {
      final c = WuerfelRegel.chancenProzent(mod);
      expect(c.values.fold(0, (a, b) => a + b), 100);
      expect(WuerfelRegel.chancen36(mod, garantie: true)[Stufe.pech], 0);
    }
    expect(WuerfelRegel.chancen36(0)[Stufe.pech], 15);
    expect(WuerfelRegel.chancen36(1)[Stufe.pech], 10);
    expect(WuerfelRegel.chancen36(2)[Stufe.pech], 6);
    expect(WuerfelRegel.modifikator(werkzeug: true, gruendlich: true, marke: true), 2);
  });

  test('Budget-Ungleichung und Suchen-Regel (K-05, K-11)', () {
    const p = ZugParameter();
    expect(p.schlechtesterPflichtzug, 14);
    expect(p.budgetUngleichung(3), isTrue);
    final suchen = [for (final e in erm.entscheidungen) if (istSuche(e)) e.id];
    expect(suchen, ['e2_1', 'e2_2', 'e2_3', 'e3_1', 'e3_2']);
  });

  test('Determinismus: gleiche Eingaben ergeben dasselbe Würfelprotokoll (WÜ-6)', () {
    for (var i = 0; i < faelle ~/ 10; i++) {
      final wahl = zufallsWahl(erm, Rng(i));
      final a = spiele(erm, 'can', wahl, SalzWuerfel('d$i'), Rng(Rng.hashString('det$i')));
      final b = spiele(erm, 'can', wahl, SalzWuerfel('d$i'), Rng(Rng.hashString('det$i')));
      expect(a.protokoll, b.protokoll);
    }
  });
}

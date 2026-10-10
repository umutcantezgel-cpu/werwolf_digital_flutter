// Kern 1.1 (E-G2-01): Seifenblasen-Marken (K-07, K-10), „gründlich“ im Abstecher (K-07, K-12),
// Vorschau vor dem Wurf (WÜ-2) und Seifenblasen-Bilanz (K-24).
import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte_core/src/runden/wuerfel.dart';
import 'package:mordakte_core/src/runden/zugschicht.dart';
import 'package:test/test.dart';

import '../party/kanon_hilfe.dart';
import 'treiber.dart';

/// Zählt, wie oft ein Anlauf gewürfelt wurde, und liefert Augen aus einer festen Liste.
class ListenWuerfel implements WuerfelQuelle {
  final List<(int, int)> liste;
  var i = 0;
  ListenWuerfel(this.liste);
  @override
  (int, int) augen(String id, int anlauf) => liste[i++ % liste.length];
}

void main() {
  final erm = Ermittlung(kanon);
  final faelle = 500;

  test('Jedes Pech bringt genau eine Marke; eingelöst ≤ 1 je Wurf, ≤ 2 je Ziel, ≤ 3 je Partie ($faelle Fälle)', () {
    for (var i = 0; i < faelle; i++) {
      final r = Rng(Rng.hashString('K11:marken:$i'));
      final pfad = kanon.pfade[r.nextInt(4)];
      final z = spiele(erm, pfad, zufallsWahl(erm, r), SalzWuerfel('k11-$i'), r);
      // Bestand + eingelöst = Zahl der Pech-Szenen (keine Marke ohne Pech, keine verfällt)
      expect(z.markenBestand + z.markenEingeloest, z.pechSzenen, reason: 'Seed K11:marken:$i');
      expect(z.markenEingeloest, lessThanOrEqualTo(const ZugParameter().markenMax), reason: 'Seed K11:marken:$i');
      // je Wurf höchstens eine Marke: Modifikator nie über dem Deckel und nie Marke ohne Bestand
      for (final w in z.wuerfe) {
        expect(w.mod, inInclusiveRange(0, WuerfelRegel.modMax));
      }
      expect(z.markenBestand, greaterThanOrEqualTo(0));
    }
  });

  test('Ohne Pech gibt es keine Marke zum Einlösen (der erste Wurf nimmt nie eine)', () {
    final opt = {for (final e in erm.entscheidungen) e.id: e.richtig['can']!};
    final z = Zugschicht(erm, const FesterWuerfel.erfolg())..setzePfad('can');
    z.beginneRunde(1);
    z.auftakt();
    z.waehle(opt['e1_1']!);
    z.waehle(opt['e1_2']!);
    expect(z.markenBestand, 0);
    expect(z.markeVerfuegbar, isFalse);
    final w = z.abstecher('a1_0', mitWurf: true, marke: true)!;
    expect(w.mod, 0);
    expect(z.markenEingeloest, 0);
  });

  test('Auftakt-Pech bringt eine Marke, die der nächste Wurf einlösen kann', () {
    final opt = {for (final e in erm.entscheidungen) e.id: e.richtig['can']!};
    final q = ListenWuerfel([(1, 1), (3, 3)]);
    final z = Zugschicht(erm, q)..setzePfad('can');
    z.beginneRunde(1);
    z.auftakt();
    z.waehle(opt['e1_1']!);
    z.waehle(opt['e1_2']!);
    expect(z.markenBestand, 1);
    final w = z.abstecher('a1_0', mitWurf: true, marke: true)!;
    expect(w.mod, 1);
    expect(z.markenBestand, 0);
    expect(z.markenEingeloest, 1);
  });

  test('Eine Marke über dem Deckel +2 wirkt nicht und wird nicht verbraucht', () {
    final opt = {for (final e in erm.entscheidungen) e.id: e.richtig['can']!};
    final z = Zugschicht(erm, const FesterWuerfel.pech())..setzePfad('can');
    z.beginneRunde(1);
    z.auftakt();
    expect(z.markenBestand, 1);
    for (final id in ['e1_1', 'e1_2', 'e1_3']) {
      z.waehle(opt[id]!);
    }
    z.beendeRunde();
    z.beginneRunde(2);
    expect(z.waehle(opt['e2_1']!, gruendlich: true), isTrue);
    final v = z.vorschau(marke: true);
    expect(v.mod, 2);
    expect(v.markeWirkt, isFalse);
    z.anlauf(marke: true);
    expect(z.markenEingeloest, 0);
    expect(z.markenBestand, 2, reason: 'alte Marke bleibt, Pech bringt eine neue');
  });

  test('Je Wissensziel höchstens zwei eingelöste Marken (K-07)', () {
    final opt = {for (final e in erm.entscheidungen) e.id: e.richtig['can']!};
    final z = Zugschicht(erm, const FesterWuerfel.pech())..setzePfad('can');
    z.beginneRunde(1);
    z.auftakt();
    z.waehle(opt['e1_1']!);
    z.waehle(opt['e1_2']!);
    z.abstecher('a1_0', mitWurf: true);
    expect(z.markenBestand, 2);
    z.waehle(opt['e1_3']!);
    z.beendeRunde();
    z.beginneRunde(2);
    expect(z.waehle(opt['e2_1']!), isTrue);
    final anlaeufe = <int>[];
    while (z.untersuchungOffen) {
      final w = z.anlauf(marke: true);
      anlaeufe.add(w.mod);
      if (z.wartetAufTischruf) z.tischruf(Tischruf.nochmal);
    }
    expect(anlaeufe, [1, 1, 0], reason: 'dritter Anlauf: zwei Marken am Ziel schon eingelöst');
    expect(z.markenEingeloest, 2);
  });

  test('Gier mit „gründlich“ im Abstecher überschreitet nie das Rundenbudget ($faelle Fälle)', () {
    for (var i = 0; i < faelle; i++) {
      final r = Rng(Rng.hashString('K11:gier:$i'));
      final pfad = kanon.pfade[r.nextInt(4)];
      final wahl = zufallsWahl(erm, r);
      final z = Zugschicht(erm, SalzWuerfel('gier$i'))..setzePfad(pfad);
      for (final runde in [1, 2, 3]) {
        z.beginneRunde(runde);
        if (runde == 1) z.auftakt();
        var a = 0;
        while (z.offen.isNotEmpty) {
          while (z.abstecherErlaubt(gruendlich: true)) {
            z.abstecher('a${runde}_${a++}', mitWurf: true, gruendlich: true, marke: true);
          }
          if (z.waehle(wahl[z.offen.first]!, gruendlich: true)) {
            while (z.untersuchungOffen) {
              z.anlauf(marke: true);
              if (z.wartetAufTischruf) z.tischruf(Tischruf.umweg);
            }
          }
        }
        z.beendeRunde();
      }
      expect(z.budgetUeber, 0, reason: 'Seed K11:gier:$i');
      expect(z.aufgedeckt, hasLength(9), reason: 'Seed K11:gier:$i');
    }
  });

  test('Vorschau stimmt mit dem folgenden Wurf überein (WÜ-2)', () {
    for (var i = 0; i < faelle; i++) {
      final r = Rng(Rng.hashString('K11:vorschau:$i'));
      final z = Zugschicht(erm, SalzWuerfel('v$i'))..setzePfad(kanon.pfade[r.nextInt(4)]);
      final wahl = zufallsWahl(erm, r);
      for (final runde in [1, 2, 3]) {
        z.beginneRunde(runde);
        if (runde == 1) z.auftakt();
        while (z.offen.isNotEmpty) {
          if (z.waehle(wahl[z.offen.first]!, gruendlich: r.chance(0.2))) {
            while (z.untersuchungOffen) {
              final werkzeug = r.chance(0.3), marke = r.chance(0.5);
              final v = z.vorschau(werkzeug: werkzeug, marke: marke);
              final w = z.anlauf(werkzeug: werkzeug, marke: marke);
              expect(w.mod, v.mod, reason: 'Seed K11:vorschau:$i');
              expect(w.garantie, v.garantie, reason: 'Seed K11:vorschau:$i');
              expect(v.prozent.values.fold(0, (a, b) => a + b), 100);
              if (z.wartetAufTischruf) z.tischruf(r.chance(0.5) ? Tischruf.nochmal : Tischruf.umweg);
            }
          }
        }
        z.beendeRunde();
      }
    }
  });

  test('Seifenblasen-Bilanz ist getrennt von der Wertung und zählt Lupe, Abstecher, Marken, Restminuten (K-24)', () {
    final z = spiele(erm, 'olli', zufallsWahl(erm, Rng(1)), SalzWuerfel('bilanz'), Rng(2));
    expect(z.restJeRunde, hasLength(3));
    final soll = z.erfolgeMitZusatz + z.abstecherZahl + z.markenBestand + z.restJeRunde.fold(0, (s, r) => s + (r > 0 ? r ~/ 5 : 0));
    expect(z.seifenblasenBilanz, soll);
    expect(z.ereignisse.where((e) => e.contains(':ruf:')).length, z.pechSzenen - z.ereignisse.where((e) => e.startsWith('auftakt:P') || RegExp(r'^a\d_\d+:P$').hasMatch(e)).length);
  });
}

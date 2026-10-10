// C8 Nr. 1a (WÜ-3) und K-23/WÜ-5: erschöpfender Folgenbeweis je Suche und Würfel-Id je Entscheidung.
import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte_core/src/runden/wuerfel.dart';
import 'package:mordakte_core/src/runden/zugschicht.dart';
import 'package:test/test.dart';

import '../party/kanon_hilfe.dart';
import 'treiber.dart';

/// Würfel mit festem Skript je Entscheidung: Buchstabe je Anlauf (E 6+6, T 3+4, P 1+1), sonst neutral.
class SkriptWuerfel implements WuerfelQuelle {
  final String id;
  final String folge;
  const SkriptWuerfel(this.id, this.folge);
  @override
  (int, int) augen(String i, int anlauf) {
    if (i != id || anlauf > folge.length) return (3, 4);
    return switch (folge[anlauf - 1]) { 'E' => (6, 6), 'P' => (1, 1), _ => (3, 4) };
  }
}

void main() {
  final erm = Ermittlung(kanon);
  final suchen = [for (final e in erm.entscheidungen) if (istSuche(e)) e];
  // PPP: der dritte Anlauf hat Garantie und endet mindestens als Teilerfolg (PPPE wäre gleich PPP, Befund F-6).
  const folgen = ['E', 'T', 'PE', 'PT', 'PPE', 'PPT', 'PPP'];

  test('C8 1a: jede Ausgangsfolge × Tischruf × gründlich deckt auf, kostet ≤ 14 min, Fakten wie im Kanon', () {
    var faelle = 0;
    for (final pfad in kanon.pfade) {
      final wahl = {for (final e in erm.entscheidungen) e.id: e.richtig[pfad]!};
      for (final e in suchen) {
        for (final folge in folgen) {
          for (final ruf in Tischruf.values) {
            for (final gruendlich in [false, true]) {
              final z = Zugschicht(erm, SkriptWuerfel(e.id, folge))..setzePfad(pfad);
              for (final runde in [1, 2, 3]) {
                z.beginneRunde(runde);
                if (runde == 1) z.auftakt();
                while (z.offen.isNotEmpty) {
                  final id = z.offen.first;
                  final vor = z.rest;
                  if (z.waehle(wahl[id]!, gruendlich: id == e.id && gruendlich)) {
                    while (z.untersuchungOffen) {
                      z.anlauf();
                      if (z.wartetAufTischruf) z.tischruf(ruf);
                    }
                  }
                  if (id == e.id) {
                    final kosten = vor - z.rest;
                    expect(kosten, lessThanOrEqualTo(const ZugParameter().schlechtesterPflichtzug), reason: '$pfad ${e.id} $folge $ruf $gruendlich');
                    expect(z.aufgedeckt, contains(e.id));
                    expect(z.fakten, containsAll(erm.faktenVon(wahl[id]!, pfad)));
                  }
                }
                z.beendeRunde();
              }
              expect(z.aufgedeckt, hasLength(9));
              expect(z.maxPechFolge, lessThanOrEqualTo(2), reason: folge);
              final amZiel = [for (final w in z.wuerfe) if (w.id == e.id) w];
              expect(amZiel.length, lessThanOrEqualTo(3), reason: folge);
              if (folge == 'PPP') {
                expect(amZiel.last.garantie, isTrue);
                expect(amZiel.last.stufe, Stufe.teilerfolg);
              }
              faelle++;
            }
          }
        }
      }
    }
    expect(faelle, 4 * 5 * folgen.length * 2 * 2);
  });

  test('K-23/WÜ-5: andere Wahl oder anderer Pfad ändern das Würfelprotokoll nie', () {
    for (var i = 0; i < 200; i++) {
      final w1 = zufallsWahl(erm, Rng(Rng.hashString('id-a:$i')));
      final w2 = zufallsWahl(erm, Rng(Rng.hashString('id-b:$i')));
      final a = spiele(erm, 'ahmet', w1, SalzWuerfel('id$i'), Rng(Rng.hashString('id-s:$i')));
      final b = spiele(erm, 'can', w2, SalzWuerfel('id$i'), Rng(Rng.hashString('id-s:$i')));
      expect(b.protokoll, a.protokoll, reason: 'Seed id$i');
      for (final w in a.wuerfe) {
        // Würfel-Id ist die Entscheidung (nie die Option) bzw. der Abstecher
        expect(w.id == 'auftakt' || RegExp(r'^(e\d_\d|a\d_\d+)$').hasMatch(w.id), isTrue, reason: w.id);
      }
    }
  });
}

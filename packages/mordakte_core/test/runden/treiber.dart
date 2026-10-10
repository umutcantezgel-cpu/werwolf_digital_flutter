// Gemeinsamer Treiber für Rundentests ohne dart:io (VM, Node, Chrome).
import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte_core/src/runden/wuerfel.dart';
import 'package:mordakte_core/src/runden/zugschicht.dart';

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

// L3 · Determinismus (WÜ-6): 1.000 Codes, je Partie eine FNV-Summe über die
// kanonische JSON-Zeile je Zug. Ohne dart:io, damit VM, Node und Chrome dasselbe rechnen.
import 'dart:convert';

import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte_core/src/runden/wuerfel.dart';

import '../web/kanon_eingebettet.g.dart';
import 'treiber.dart';

Kanon eingebetteterKanon() => Kanon.lade((p) => jsonDecode(kanonEingebettet[p]!) as Map<String, Object?>);

/// FNV-Summen der Partien für die Codes 0 … [n] − 1.
List<int> determinismusListe([int n = 1000]) {
  final kanon = eingebetteterKanon();
  final erm = Ermittlung(kanon);
  final aus = <int>[];
  for (var i = 0; i < n; i++) {
    final pfad = kanon.pfade[i % kanon.pfade.length];
    final wahl = zufallsWahl(erm, Rng(Rng.hashString('det-wahl:$i')));
    final z = spiele(erm, pfad, wahl, SalzWuerfel('code$i'), Rng(Rng.hashString('det-strat:$i')));
    var h = Rng.hashString(pfad);
    for (final w in z.wuerfe) {
      h = Rng.hashString('$h|${jsonEncode(w.toJson())}');
    }
    final rest = [...z.fakten]..sort();
    h = Rng.hashString('$h|${jsonEncode({'gewaehlt': z.optionsfolge, 'fakten': rest, 'rest': z.rest, 'marken': z.markenEingeloest, 'bestand': z.markenBestand})}');
    aus.add(h);
  }
  return aus;
}

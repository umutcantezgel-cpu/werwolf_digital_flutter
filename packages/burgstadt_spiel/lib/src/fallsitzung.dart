import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

import 'figuren_lager.dart';

/// Eine laufende Fallsitzung (Solo: Detektiv = Mensch, alle Rollen = Bots).
class Fallsitzung {
  final FallZustand fall;
  final Simulation sim;
  final FigurenLager figuren;

  /// Ereignisse, die dem Detektiv gezeigt werden (Hinweiskarten, Aussagen).
  final List<Ereignis> anzeige = [];
  int neueAkte = 0;

  Fallsitzung(this.fall, this.sim, this.figuren);

  factory Fallsitzung.starte(FallDaten daten, Welt welt, int n, Map<String, Teil> teile, Map<String, Figurenkarte> karten,
      {int seed = 7,
      double tempo = 65 / 480,
      List<Map<String, dynamic>> bewohner = const [],
      List<Map<String, dynamic>> haeuser = const []}) {
    final fall = FallZustand(daten, n);
    final start = fall.starte();
    final sim = Simulation(welt, fall, seed: seed, tempo: tempo, bewohnerDaten: bewohner, haeuser: haeuser);
    final lager = FigurenLager(teile);
    for (final id in ['BW', ...fall.rollen, ...sim.bewohner.keys]) {
      final k = karten[id];
      if (k != null) lager.karte(k);
    }
    final s = Fallsitzung(fall, sim, lager);
    s._uebernimm(start);
    return s;
  }

  /// Simulation weiterführen und Ereignisse für die Anzeige sammeln.
  void tick(double dt) {
    sim.tick(dt);
    _uebernimm(sim.abholen());
  }

  final Set<String> _gezeigt = {};

  void _uebernimm(List<Ereignis> es) {
    for (final e in es) {
      // Denselben Hinweis nicht zweimal als Karte zeigen (erst mitgehört, dann in der Akte)
      if (e.hinweis != null && !_gezeigt.add(e.hinweis!)) {
        if (e.art == 'akte') neueAkte++;
        continue;
      }
      final fuerMich = switch (e.art) {
        'belauscht' || 'teilen' || 'fund' => e.von == 'DET' || e.an == 'DET',
        'akte' || 'erzaehler' || 'phase' || 'aussage' || 'meldekarte' || 'detektiv' || 'eingrenzung' || 'ende' => true,
        _ => false,
      };
      if (e.art == 'akte') neueAkte++;
      if (fuerMich) anzeige.add(e);
    }
  }

  /// Ereignisse aus direkten Aktionen des Spielers übernehmen.
  void melde(List<Ereignis> es) => _uebernimm(es);

  String get uhrText {
    final m = fall.uhr.floor();
    return '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}';
  }
}

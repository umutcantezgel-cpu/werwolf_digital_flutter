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

  final int seed;
  final double tempo;

  Fallsitzung(this.fall, this.sim, this.figuren, {this.seed = 7, this.tempo = 65 / 480});

  /// Schema des Spielstands; ändert es sich, passen alte Stände nicht mehr.
  static const schema = 1;

  /// Fingerabdruck der Falldaten (Kanon + Anpassung): passt der Stand zu diesen Daten?
  static String fingerabdruck(FallDaten d) => '${d.kanon.datensaetze.length}:${d.hinweise.length}:${d.gespraeche.length}';

  Map<String, Object?> zuJson() => {
        'schema': schema,
        'daten': fingerabdruck(fall.daten),
        'seed': seed,
        'tempo': tempo,
        'fall': fall.zuJson(),
        'figuren': sim.figurenZuJson(),
      };

  /// Stellt eine Sitzung aus [j] wieder her; `null`, wenn der Stand nicht passt.
  static Fallsitzung? ausJson(FallDaten daten, Welt welt, Map<String, Teil> teile, Map<String, Figurenkarte> karten,
      Map<String, dynamic> j,
      {List<Map<String, dynamic>> bewohner = const [], List<Map<String, dynamic>> haeuser = const []}) {
    if (j['schema'] != schema || j['daten'] != fingerabdruck(daten)) return null;
    final fall = FallZustand.ausJson(daten, j['fall'] as Map<String, dynamic>);
    final seed = (j['seed'] as num).toInt(), tempo = (j['tempo'] as num).toDouble();
    final sim = Simulation(welt, fall, seed: seed, tempo: tempo, bewohnerDaten: bewohner, haeuser: haeuser);
    sim.figurenAusJson(j['figuren'] as Map<String, dynamic>);
    sim.abholen(); // Start-Ereignisse der Simulation sind beim Fortsetzen schon bekannt
    final lager = FigurenLager(teile);
    for (final id in ['BW', ...fall.rollen, ...sim.bewohner.keys]) {
      final k = karten[id];
      if (k != null) lager.karte(k);
    }
    return Fallsitzung(fall, sim, lager, seed: seed, tempo: tempo);
  }

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
    final s = Fallsitzung(fall, sim, lager, seed: seed, tempo: tempo);
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

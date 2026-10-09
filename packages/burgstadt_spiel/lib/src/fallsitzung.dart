import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

import 'figuren_lager.dart';

/// Wie die Sitzung läuft: allein mit Bots, als Gastgeber eines WLAN-Raums (maßgeblicher
/// Zustand im eigenen Gerät) oder als Gast (Spiegel des Zustands vom Gastgeber).
enum Modus { solo, gastgeber, gast }

/// Eine laufende Fallsitzung (Solo: Detektiv = Mensch, alle Rollen = Bots).
class Fallsitzung {
  final FallZustand fall;
  final Simulation sim;
  final FigurenLager figuren;

  Modus modus = Modus.solo;

  /// Die Rolle des Spielers an diesem Gerät (`DET` oder `R01` …).
  String ich = FallZustand.detektiv;

  /// Gastgeber: der Raum und die eigene Spieler-ID darin.
  BurgstadtRaum? raum;
  String? spielerId;

  /// Gast: schickt eine Nachricht an den Gastgeber.
  void Function(Map<String, Object?> nachricht)? senden;

  /// Im WLAN-Spiel: Raum schließen bzw. Verbindung trennen (beim Verlassen der Partie).
  void Function()? beenden;

  /// Gast: offene eigene Rollen-Entscheidungen (vom Gastgeber) und letzte Mitspielerliste.
  List<Map<String, Object?>> offeneEntscheidungen = const [];
  List<Map<String, Object?>> mitspieler = const [];

  /// Ergebnis der letzten Detektiv-Entscheidung (für die Lagerunde).
  String? letztesErgebnis;

  bool get imNetz => modus != Modus.solo;

  /// Ereignisse, die dem Spieler gezeigt werden (Hinweiskarten, Aussagen).
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

  /// Gastgeber im WLAN-Spiel: Fall und Simulation gehören dem Raum (maßgeblich); diese
  /// Sitzung zeigt sie aus der Sicht des eigenen Teilnehmers [spielerId].
  factory Fallsitzung.imRaum(BurgstadtRaum raum, String spielerId, Map<String, Teil> teile, Map<String, Figurenkarte> karten) {
    final lager = FigurenLager(teile);
    final s = Fallsitzung(raum.fall!, raum.sim!, lager, seed: raum.seed, tempo: raum.tempo)
      ..modus = Modus.gastgeber
      ..raum = raum
      ..spielerId = spielerId
      ..ich = raum.rolleVon[spielerId] ?? FallZustand.detektiv;
    for (final id in [FallZustand.detektiv, 'BW', ...s.fall.rollen, ...s.sim.bewohner.keys]) {
      final k = karten[id];
      if (k != null && id != s.ich) lager.karte(k);
    }
    return s;
  }

  /// Gast im WLAN-Spiel: ein lokaler Spiegel (Fall + Figuren), den [spiegele] mit dem Zustand
  /// des Gastgebers füllt; Aktionen gehen über [senden] an den Gastgeber.
  factory Fallsitzung.alsGast(FallDaten daten, Welt welt, Map<String, Object?> zustand, Map<String, Teil> teile,
      Map<String, Figurenkarte> karten,
      {List<Map<String, dynamic>> bewohner = const [], List<Map<String, dynamic>> haeuser = const []}) {
    final fall = FallZustand(daten, (zustand['n'] as num).toInt())..starte();
    final sim = Simulation(welt, fall, bewohnerDaten: bewohner, haeuser: haeuser);
    sim.abholen();
    final lager = FigurenLager(teile);
    final s = Fallsitzung(fall, sim, lager)
      ..modus = Modus.gast
      ..ich = zustand['rolle'] as String;
    for (final id in [FallZustand.detektiv, 'BW', ...fall.rollen, ...sim.bewohner.keys]) {
      final k = karten[id];
      if (k != null && id != s.ich) lager.karte(k);
    }
    s.spiegele(zustand);
    return s;
  }

  /// Simulation weiterführen und Ereignisse für die Anzeige sammeln. Im WLAN-Spiel führt
  /// der Raum-Host den Takt; hier werden nur die eigenen Ereignisse abgeholt.
  void tick(double dt) {
    switch (modus) {
      case Modus.solo:
        sim.tick(dt);
        _uebernimm(sim.abholen());
      case Modus.gastgeber:
        _empfangeEreignisse(raum!.ereignisseFuer(spielerId!));
      case Modus.gast:
        break; // kommt über [empfange]
    }
  }

  void _sende(Map<String, Object?> n) {
    if (modus == Modus.gastgeber) raum!.nachricht(spielerId!, n);
    if (modus == Modus.gast) senden?.call(n);
  }

  // ------------------------------------------------------------------ Aktionen des Spielers

  /// Station untersuchen. Solo: liefert die Funde sofort; im Netz kommen sie als Ereignis.
  List<Ereignis> untersuche(String station) {
    if (imNetz) {
      _sende({'art': 'untersuche', 'station': station});
      return const [];
    }
    final e = fall.untersuche(ich, station);
    melde(e);
    return e;
  }

  /// Eine Figur ansprechen.
  void frage(String figur) {
    if (imNetz) return _sende({'art': 'frage', 'figur': figur});
    sim.detektivFragt(figur);
    melde(sim.abholen());
  }

  /// Hinweis teilen: an eine Rolle oder an die Fallakte (`akte`).
  void teile(String an, String hinweis) {
    if (imNetz) return _sende({'art': 'teile', 'an': an, 'hinweis': hinweis});
    melde(fall.teile(ich, an, hinweis));
  }

  void verbinde(String a, String b) {
    if (imNetz) return _sende({'art': 'verbinde', 'a': a, 'b': b});
    melde(fall.verbinde(ich, a, b));
  }

  void waehleRolle(String entscheidung, int option) {
    if (imNetz) return _sende({'art': 'wahl', 'entscheidung': entscheidung, 'option': option});
    melde(fall.waehleRolle(entscheidung, option));
  }

  /// Detektiv-Entscheidung; liefert den Ergebnistext.
  String waehleDetektiv(String entscheidung, String option) {
    if (imNetz) {
      _sende({'art': 'detektiv', 'entscheidung': entscheidung, 'option': option});
      return fall.daten.detektivEntscheidungen[entscheidung]?.ergebnisse[option] ?? '';
    }
    final e = fall.waehleDetektiv(entscheidung, option);
    melde(e);
    return e.isEmpty ? '' : e.first.text;
  }

  /// Lagerunde → Detektiv-Entscheidungen → nächste Phase bzw. Eingrenzung.
  void weiter() {
    if (imNetz) return _sende({'art': 'weiter'});
    if (fall.abschnitt == Abschnitt.lagerunde) {
      melde(fall.zurDetektivWahl());
    } else {
      melde(fall.weiter());
    }
  }

  void klageAn(String rolle) {
    if (imNetz) return _sende({'art': 'anklage', 'rolle': rolle});
    melde(fall.klageAn(rolle));
  }

  double _positionSeit = 1;

  /// Eigene Lage (für Mitspieler sichtbar). Gast: höchstens zehnmal je Sekunde senden.
  void position(String bereich, double x, double z, double yaw, String animation, double dt) {
    final f = sim.figuren[ich];
    if (f != null) {
      f
        ..bereich = bereich
        ..x = x
        ..z = z
        ..yaw = yaw
        ..animation = animation;
    }
    if (modus != Modus.gast) return;
    _positionSeit += dt;
    if (_positionSeit < 0.1) return;
    _positionSeit = 0;
    _sende({'art': 'position', 'bereich': bereich, 'x': x, 'z': z, 'yaw': yaw, 'animation': animation});
  }

  // ------------------------------------------------------------------ Netz: Empfang

  void _empfangeEreignisse(List<Map<String, Object?>> es) {
    final neu = [
      for (final e in es)
        if (e['art'] != 'texte') Ereignis.ausJson(e.cast<String, dynamic>()),
    ];
    if (modus == Modus.gast) fall.protokoll.addAll(neu); // Gastgeber: der Raum führt das Protokoll
    _uebernimm(neu);
  }

  /// Gast: Nachricht vom Gastgeber (`zustand` oder `ereignisse`).
  void empfange(Map<String, Object?> n) {
    switch (n['t']) {
      case 'ereignisse':
        _empfangeEreignisse([for (final e in n['liste'] as List) (e as Map).cast<String, Object?>()]);
      case 'zustand':
        if (n['lobby'] != true) spiegele(n);
    }
  }

  /// Gast: den Zustand des Gastgebers in den lokalen Spiegel übernehmen.
  void spiegele(Map<String, Object?> z) {
    final f = fall;
    f.phase = (z['phase'] as num).toInt();
    f.uhr = (z['uhr'] as num).toDouble();
    f.abschnitt = Abschnitt.values.byName(z['abschnitt'] as String);
    f.ende = z['ende'] as String?;
    (f.wissen[ich] ??= <String>{})
      ..clear()
      ..addAll([for (final h in z['wissen'] as List) h as String]);
    f.akte
      ..clear()
      ..addAll([for (final h in z['akte'] as List) h as String]);
    f.faeden
      ..clear()
      ..addAll([for (final x in z['faeden'] as List) ((x as List)[0] as String, x[1] as String)]);
    f.detektivWahl
      ..clear()
      ..addAll({for (final e in ((z['detektivWahl'] as Map?) ?? const {}).entries) e.key as String: e.value as String});
    // Welche Rollen-Entscheidungen gefallen sind (die Option bleibt beim Gastgeber)
    f.rollenWahl
      ..clear()
      ..addAll({for (final id in (z['rollenEntschieden'] as List?) ?? const []) id as String: -1});
    f.angeklagt = z['angeklagt'] as String?;
    offeneEntscheidungen = [for (final e in (z['entscheidungen'] as List?) ?? const []) (e as Map).cast<String, Object?>()];
    mitspieler = [for (final m in (z['mitspieler'] as List?) ?? const []) (m as Map).cast<String, Object?>()];
    final gesehen = <String>{ich};
    for (final x in (z['figuren'] as List?) ?? const []) {
      final m = (x as Map).cast<String, Object?>();
      final id = m['id'] as String;
      gesehen.add(id);
      final fig = sim.figuren.putIfAbsent(id, () => Figur(id, '', 0, 0, bot: false, bewohner: id.startsWith('B') && id != 'BW'));
      fig
        ..bereich = m['bereich'] as String
        ..x = (m['x'] as num).toDouble()
        ..z = (m['z'] as num).toDouble()
        ..yaw = (m['yaw'] as num).toDouble()
        ..animation = m['animation'] as String? ?? 'stehen'
        ..animZeit += 1 / 10;
      final blase = m['blase'] as String?;
      if (blase != null) {
        fig
          ..sprechblase = blase
          ..blasenZeit = 0.5;
      }
    }
    for (final fig in sim.figuren.values) {
      if (!gesehen.contains(fig.id)) fig.bereich = ''; // außerhalb des eigenen Bereichs unbekannt
    }
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
        'belauscht' || 'teilen' || 'fund' => e.von == ich || e.an == ich,
        'sicht' || 'verwischt' => e.an == ich,
        'akte' || 'erzaehler' || 'phase' || 'aussage' || 'meldekarte' || 'detektiv' || 'eingrenzung' || 'ende' => true,
        _ => false,
      };
      if (e.art == 'akte') neueAkte++;
      if (e.art == 'detektiv') letztesErgebnis = e.text;
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

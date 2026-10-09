import 'fall_daten.dart';

/// Abschnitte einer Fallphase.
enum Abschnitt { einfuehrung, ermittlung, lagerunde, detektivWahl, eingrenzung, ende }

/// Etwas, das passiert ist (für Anzeige, Protokoll und Netz-Deltas).
class Ereignis {
  final String art; // erzaehler, fund, gespraech, belauscht, teilen, akte, faden, meldekarte, rolle, detektiv, phase, eingrenzung, ende
  final String text;
  final String? von, an, hinweis;
  final double uhr;
  const Ereignis(this.art, this.text, {this.von, this.an, this.hinweis, this.uhr = 0});

  Map<String, Object?> zuJson() => {'art': art, 'text': text, 'von': von, 'an': an, 'hinweis': hinweis, 'uhr': uhr};
  factory Ereignis.ausJson(Map<String, dynamic> j) => Ereignis(j['art'] as String, j['text'] as String,
      von: j['von'] as String?, an: j['an'] as String?, hinweis: j['hinweis'] as String?, uhr: (j['uhr'] as num).toDouble());
}

/// Maßgeblicher Fallzustand („KanonRuntime“): Phasen, Wissen je Spieler, Fallakte,
/// Teilen, Gespräche, Stationen, Entscheidungen, Punkte, Eingrenzung, Endmatrix.
/// Reine Logik, deterministisch, serialisierbar. Spieler-IDs: `DET`, `R01`…`R20`.
class FallZustand {
  final FallDaten daten;
  final int n;
  static const detektiv = 'DET';
  static const taeterin = 'R03'; // aus K1/K6 (Lösung, nur für Bots/Auflösung)
  static const verdaechtige = ['R01', 'R02', 'R03', 'R04'];
  // Phase 1 (Ermittlung) beginnt um 00:30 (Kanon Z-0030), nach dem Auftrag des Burgwarts um 00:25 (OA-29)
  static const phasenStart = {1: 30.0, 2: 90.0, 3: 180.0, 4: 270.0};

  int phase = 0;
  Abschnitt abschnitt = Abschnitt.einfuehrung;
  double uhr = 30;
  final Map<String, Set<String>> wissen = {};
  final Set<String> akte = {};
  final List<(String, String)> faeden = [];
  final Set<String> erledigt = {};
  final Set<String> untersucht = {};

  /// Rollen, deren Fähigkeit schon gewirkt hat (je Rolle einmal).
  final Set<String> faehigkeitGenutzt = {};

  /// Von der Täterin verwischte Spuren (Stations-IDs).
  final Set<String> verwischt = {};
  final Map<String, int> rollenWahl = {};
  final Map<String, String> detektivWahl = {};
  final List<Ereignis> protokoll = [];
  String? angeklagt;
  String? ende;

  FallZustand(this.daten, this.n) {
    if (n < 4 || n > 20) throw ArgumentError('Besetzung 4–20, nicht $n');
    for (final s in spieler) {
      wissen[s] = {};
    }
  }

  List<String> get rollen => daten.rollenBis(n);
  List<String> get spieler => [detektiv, ...rollen];

  int get punkte => detektivWahl.entries.fold(0, (s, e) => s + (daten.detektivEntscheidungen[e.key]?.punkte[e.value] ?? 0));

  bool kennt(String wer, String h) => akte.contains(h) || (wissen[wer]?.contains(h) ?? false);

  /// Alles, was [wer] weiß (eigenes Wissen + Fallakte).
  Set<String> bekannt(String wer) => {...?wissen[wer], ...akte};

  List<Ereignis> _neu(List<Ereignis> e) {
    protokoll.addAll(e);
    return e;
  }

  Ereignis _e(String art, String text, {String? von, String? an, String? hinweis}) =>
      Ereignis(art, text, von: von, an: an, hinweis: hinweis, uhr: uhr);

  // ------------------------------------------------------------ Ablauf

  /// Einführung → Phase 1.
  List<Ereignis> starte() {
    final out = <Ereignis>[];
    final a0 = daten.burgwartAussagen[0];
    if (a0 != null) out.add(_e('erzaehler', 'Der Burgwart: $a0'));
    for (final h in daten.hinweise.values.where((h) => h.detektivMappe)) {
      wissen[detektiv]!.add(h.id);
    }
    out.addAll(_phaseBeginn(1));
    return _neu(out);
  }

  List<Ereignis> _phaseBeginn(int p) {
    phase = p;
    abschnitt = Abschnitt.ermittlung;
    uhr = phasenStart[p]!;
    final out = <Ereignis>[_e('phase', 'Der Uhrturm schlägt. Phase $p beginnt.')];
    final a = daten.burgwartAussagen[p];
    if (a != null) out.add(_e('erzaehler', 'Der Burgwart: $a'));
    for (final h in daten.hinweise.values.where((h) => h.erzaehler && h.phase == p && daten.imSpiel(h, n))) {
      akte.add(h.id);
      out.add(_e('akte', h.inhalt, hinweis: h.id));
    }
    // Meldekarten der Phase kennt die eigene Rolle von Anfang an
    for (final h in daten.hinweise.values.where((h) => h.meldekarte && h.phase == p)) {
      final r = h.rolle ?? RegExp(r'R\d\d').firstMatch(h.quelle)?.group(0);
      if (r != null && wissen.containsKey(r)) wissen[r]!.add(h.id);
    }
    return out;
  }

  /// Uhr vorstellen (Spielminuten); endet die Ermittlungszeit, beginnt die Lagerunde.
  List<Ereignis> zeitVergeht(double minuten) {
    if (abschnitt != Abschnitt.ermittlung) return const [];
    uhr += minuten;
    if (uhr >= phasenStart[phase + 1]!) {
      uhr = phasenStart[phase + 1]!;
      return beendeErmittlung();
    }
    return const [];
  }

  // ------------------------------------------------------------ Ermittlung

  /// Gespräche, die [rolle] in dieser Phase noch führen soll: (Gespräch, Ziel, Ersatzfall).
  List<(Gespraech, String, bool)> offeneGespraeche(String rolle) => [
        for (final t in daten.gespraecheFuer(phase, n))
          if (t.$1.von == rolle && !erledigt.contains(t.$1.id)) t,
      ];

  /// Hinweise an einer Station (ab ihrer Phase, bei dieser Besetzung).
  List<Hinweis> stationsHinweise(String station) => [
        for (final h in daten.hinweise.values)
          if (h.station == station && h.phase <= phase && daten.imSpiel(h, n) && !(h.aufVerlangen && h.phase > phase)) h,
      ];

  /// [wer] untersucht [station] und erfährt deren Hinweise.
  List<Ereignis> untersuche(String wer, String station) {
    if (abschnitt != Abschnitt.ermittlung) return const [];
    final out = <Ereignis>[];
    untersucht.add('$wer|$station|$phase');
    for (final h in stationsHinweise(station)) {
      if (wissen[wer]!.add(h.id)) out.add(_e('fund', h.inhalt, von: wer, hinweis: h.id));
    }
    return [..._neu(out), ..._faehigkeit(wer, station: station)];
  }

  // ------------------------------------------------------------ Fähigkeiten (Z-05)

  /// Die Fähigkeit von [rolle] wirkt, wenn ihr Auslöser passt (einmal je Rolle):
  /// Ereignis `sicht` nur an die Rolle selbst.
  List<Ereignis> _faehigkeit(String rolle, {String? station, String? mit, String? bereich}) {
    final f = daten.faehigkeiten[rolle];
    if (f == null || !rollen.contains(rolle) || faehigkeitGenutzt.contains(rolle)) return const [];
    final passt = (station != null && (f.station == station || f.werkzeug == station)) ||
        (mit != null && f.gespraech && (f.gespraechMit == null || f.gespraechMit == mit)) ||
        (bereich != null && f.bereich == bereich);
    if (!passt) return const [];
    faehigkeitGenutzt.add(rolle);
    return _neu([_e('sicht', f.text, von: rolle, an: rolle)]);
  }

  /// [rolle] begegnet [mit] (im Gespräch oder in Rufweite).
  List<Ereignis> begegnung(String rolle, String mit) => _faehigkeit(rolle, mit: mit);

  /// [rolle] betritt [bereich].
  List<Ereignis> betritt(String rolle, String bereich) => _faehigkeit(rolle, bereich: bereich);

  /// Gegenspiel der Täterin: Wer die Werkzeug-Fähigkeit für [station] hat, verwischt die
  /// Abdruckspur dort. Sie bleibt im Detektivblick als „verwischt“ erkennbar.
  List<Ereignis> verwische(String rolle, String station) {
    final f = daten.faehigkeiten[rolle];
    if (abschnitt != Abschnitt.ermittlung || f == null || f.werkzeug != station || !rollen.contains(rolle)) return const [];
    if (!verwischt.add(station)) return const [];
    return _neu([_e('verwischt', 'Du wischst über den Abdruck. Ganz weg ist er nicht.', von: rolle, an: rolle)]);
  }

  /// [von] führt Gespräch [gid] mit seinem Ziel. [zuhoerer] (z. B. der Detektiv in
  /// Hörweite) erfahren die Antwort ebenfalls (IF-1).
  List<Ereignis> fuehreGespraech(String von, String gid, {Iterable<String> zuhoerer = const []}) {
    if (abschnitt != Abschnitt.ermittlung || erledigt.contains(gid)) return const [];
    final t = daten.gespraecheFuer(phase, n).where((t) => t.$1.id == gid).firstOrNull;
    if (t == null || t.$1.von != von) return const [];
    final (g, ziel, ersatz) = t;
    erledigt.add(gid);
    if (g.zusammenfall != null) erledigt.add(g.zusammenfall!);
    final frage = ersatz ? g.ersatzFrage : g.frage;
    final antwort = ersatz ? g.ersatzAntwort : g.antwort;
    final gibt = ersatz ? g.ersatzGibt : g.gibt;
    final out = <Ereignis>[_e('gespraech', '${_name(von)}: $frage\n${_name(ziel)}: $antwort', von: von, an: ziel)];
    for (final h in gibt) {
      wissen[von]!.add(h);
      for (final z in zuhoerer) {
        if (z != von && wissen[z]!.add(h)) out.add(_e('belauscht', daten.hinweise[h]!.inhalt, von: z, hinweis: h));
      }
    }
    return [..._neu(out), ..._faehigkeit(von, mit: ziel)];
  }

  /// [von] teilt Hinweis [h] mit [an] (Spieler-ID oder `akte`). Nur Bekanntes lässt sich teilen.
  List<Ereignis> teile(String von, String an, String h) {
    if (!kennt(von, h)) return const [];
    if (an == 'akte') {
      if (!akte.add(h)) return const [];
      return _neu([_e('akte', daten.hinweise[h]!.inhalt, von: von, an: 'akte', hinweis: h)]);
    }
    if (!wissen.containsKey(an) || !wissen[an]!.add(h)) return const [];
    return _neu([_e('teilen', daten.hinweise[h]!.inhalt, von: von, an: an, hinweis: h)]);
  }

  /// Faden zwischen zwei Hinweisen in der Fallakte.
  List<Ereignis> verbinde(String wer, String a, String b) {
    if (!akte.contains(a) || !akte.contains(b) || a == b) return const [];
    final k = a.compareTo(b) < 0 ? (a, b) : (b, a);
    if (faeden.contains(k)) return const [];
    faeden.add(k);
    return _neu([_e('faden', '$a ↔ $b', von: wer, hinweis: a)]);
  }

  // ------------------------------------------------------------ Lagerunde

  List<Ereignis> beendeErmittlung() {
    if (abschnitt != Abschnitt.ermittlung) return const [];
    abschnitt = Abschnitt.lagerunde;
    final out = <Ereignis>[_e('phase', 'Lagerunde im Gewölbe.')];
    for (final r in rollen.take(4)) {
      final mk = daten.meldekarten['MK$phase-$r'];
      if (mk == null) continue;
      out.add(_e('meldekarte', '${_name(r)}: $mk', von: r));
      for (final h in daten.hinweise.values.where((h) => h.meldekarte && h.phase == phase && h.quelle.contains(r))) {
        if (akte.add(h.id)) out.add(_e('akte', h.inhalt, von: r, hinweis: h.id));
      }
    }
    return _neu(out);
  }

  /// Rollen-Entscheidungen dieser Phase für besetzte Rollen.
  List<RollenEntscheidung> rollenEntscheidungen() => [
        for (final e in daten.rollenEntscheidungen.values)
          if (e.phase == phase && rollen.contains(e.rolle) && !rollenWahl.containsKey(e.id)) e,
      ];

  /// Rolle wählt Option [i] (0-basiert). Öffentliche Folgen legen genannte Hinweise in die Akte (IF-5/IF-8).
  List<Ereignis> waehleRolle(String eid, int i) {
    final e = daten.rollenEntscheidungen[eid];
    if (e == null || abschnitt != Abschnitt.lagerunde || rollenWahl.containsKey(eid) || i < 0 || i >= e.optionen.length) {
      return const [];
    }
    rollenWahl[eid] = i;
    final o = e.optionen[i];
    final out = <Ereignis>[_e('rolle', '${_name(e.rolle)} entscheidet sich.', von: e.rolle)];
    if (o.oeffentlich) {
      for (final h in o.hinweise) {
        if (daten.hinweise.containsKey(h) && kennt(e.rolle, h) && akte.add(h)) {
          out.add(_e('akte', daten.hinweise[h]!.inhalt, von: e.rolle, hinweis: h));
        }
      }
    }
    return _neu(out);
  }

  /// Nach der Lagerunde: Detektiv-Entscheidungen.
  List<Ereignis> zurDetektivWahl() {
    if (abschnitt != Abschnitt.lagerunde) return const [];
    abschnitt = Abschnitt.detektivWahl;
    return const [];
  }

  List<DetektivEntscheidung> detektivEntscheidungen() => [
        for (final d in daten.detektivEntscheidungen.values)
          if (d.phase == phase && !detektivWahl.containsKey(d.id)) d,
      ];

  List<Ereignis> waehleDetektiv(String did, String option) {
    final d = daten.detektivEntscheidungen[did];
    if (d == null || abschnitt != Abschnitt.detektivWahl || detektivWahl.containsKey(did) || !d.optionen.containsKey(option)) {
      return const [];
    }
    detektivWahl[did] = option;
    return _neu([_e('detektiv', d.ergebnisse[option] ?? '', von: detektiv)]);
  }

  /// Nächste Phase (oder Eingrenzung nach Phase 3).
  List<Ereignis> weiter() {
    if (abschnitt != Abschnitt.detektivWahl || detektivEntscheidungen().isNotEmpty) return const [];
    if (phase < 3) return _neu(_phaseBeginn(phase + 1));
    abschnitt = Abschnitt.eingrenzung;
    return _neu([_e('eingrenzung', eingrenzungsText)]);
  }

  // ------------------------------------------------------------ Auflösung

  /// Verbleibender Verdächtigenkreis nach Punkten (AB-*).
  List<String> get verdaechtigenkreis {
    final p = punkte;
    if (p >= 7) return const ['R03', 'R04'];
    if (p >= 4) return const ['R01', 'R03', 'R04'];
    return verdaechtige;
  }

  String get eingrenzungsText {
    final p = punkte;
    final id = p >= 9 ? 'AB-9' : (p >= 7 ? 'AB-7-8' : (p >= 4 ? 'AB-4-6' : 'AB-0-3'));
    return daten.kanon.datensaetze[id]?.feld('Erzähler nennt') ?? '';
  }

  /// Anklage: Endmatrix EM-1…EM-4.
  List<Ereignis> klageAn(String rolle) {
    if (abschnitt != Abschnitt.eingrenzung || !verdaechtigenkreis.contains(rolle)) return const [];
    angeklagt = rolle;
    final p = punkte;
    ende = rolle == taeterin ? (p >= 7 ? 'EM-1' : 'EM-2') : (p >= 4 ? 'EM-3' : 'EM-4');
    abschnitt = Abschnitt.ende;
    final text = daten.kanon.datensaetze[ende]?.feld('Ende') ?? ende!;
    return _neu([_e('ende', text, an: rolle)]);
  }

  String _name(String id) => id == detektiv ? 'Du' : (daten.rollen[id]?.name.split(' ').first ?? id);

  // ------------------------------------------------------------ Speichern

  Map<String, Object?> zuJson() => {
        'n': n,
        'phase': phase,
        'abschnitt': abschnitt.name,
        'uhr': uhr,
        'wissen': {for (final e in wissen.entries) e.key: (e.value.toList()..sort())},
        'akte': akte.toList()..sort(),
        'faeden': [for (final f in faeden) [f.$1, f.$2]],
        'erledigt': erledigt.toList()..sort(),
        'untersucht': untersucht.toList()..sort(),
        'faehigkeitGenutzt': faehigkeitGenutzt.toList()..sort(),
        'verwischt': verwischt.toList()..sort(),
        'rollenWahl': rollenWahl,
        'detektivWahl': detektivWahl,
        'angeklagt': angeklagt,
        'ende': ende,
        'protokoll': [for (final e in protokoll) e.zuJson()],
      };

  factory FallZustand.ausJson(FallDaten daten, Map<String, dynamic> j) {
    final z = FallZustand(daten, j['n'] as int)
      ..phase = j['phase'] as int
      ..abschnitt = Abschnitt.values.byName(j['abschnitt'] as String)
      ..uhr = (j['uhr'] as num).toDouble()
      ..angeklagt = j['angeklagt'] as String?
      ..ende = j['ende'] as String?;
    for (final e in (j['wissen'] as Map).entries) {
      z.wissen[e.key as String] = {for (final h in e.value as List) h as String};
    }
    z.akte.addAll([for (final h in j['akte'] as List) h as String]);
    z.faeden.addAll([for (final f in j['faeden'] as List) ((f as List)[0] as String, f[1] as String)]);
    z.erledigt.addAll([for (final g in j['erledigt'] as List) g as String]);
    z.untersucht.addAll([for (final g in j['untersucht'] as List) g as String]);
    z.faehigkeitGenutzt.addAll([for (final g in (j['faehigkeitGenutzt'] as List?) ?? const []) g as String]);
    z.verwischt.addAll([for (final g in (j['verwischt'] as List?) ?? const []) g as String]);
    z.rollenWahl.addAll({for (final e in (j['rollenWahl'] as Map).entries) e.key as String: e.value as int});
    z.detektivWahl.addAll({for (final e in (j['detektivWahl'] as Map).entries) e.key as String: e.value as String});
    z.protokoll.addAll([for (final e in j['protokoll'] as List) Ereignis.ausJson(e as Map<String, dynamic>)]);
    return z;
  }
}

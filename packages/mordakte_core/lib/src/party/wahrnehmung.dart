import '../util/geom.dart';
import 'raumgraph.dart';
import 'tatmatrix.dart';
import 'zeit.dart';

/// Regeln für Wege und Wahrnehmung (`wahrnehmung.json`).
class WahrnehmungsRegeln {
  final double tempoDunkel, tempoHell, tempoRennen;
  final double erkennenSchwachBis;
  final Zeitfenster tumult;
  final Set<String> tumultRaeume;
  final double tumultLautBis, tumultLeiseBis;
  final double leiseBis;
  final double lautTuerBis;
  final double fuehlenBis;
  final int riechenNachwirken;
  final Map<String, ({bool sieht, String hoert})> haltungen;
  final Uhrzeit planVon, planBis, fensterVon, fensterBis;
  final int matrixSchritt;

  WahrnehmungsRegeln({
    required this.tempoDunkel,
    required this.tempoHell,
    required this.tempoRennen,
    required this.erkennenSchwachBis,
    required this.tumult,
    required this.tumultRaeume,
    required this.tumultLautBis,
    required this.tumultLeiseBis,
    required this.leiseBis,
    required this.lautTuerBis,
    required this.fuehlenBis,
    required this.riechenNachwirken,
    required this.haltungen,
    required this.planVon,
    required this.planBis,
    required this.fensterVon,
    required this.fensterBis,
    required this.matrixSchritt,
  });

  factory WahrnehmungsRegeln.fromJson(Map j) {
    final tempo = j['tempo'] as Map;
    final licht = j['licht'] as Map;
    final hoeren = j['hoeren'] as Map;
    final tumult = hoeren['tumult'] as Map;
    final abt = j['abtastung'] as Map;
    final plan = abt['planFenster'] as List, fenster = abt['fenster'] as List;
    return WahrnehmungsRegeln(
      tempoDunkel: (tempo['dunkel'] as num).toDouble(),
      tempoHell: (tempo['hell'] as num).toDouble(),
      tempoRennen: (tempo['rennen'] as num).toDouble(),
      erkennenSchwachBis: (licht['erkennenSchwachBis'] as num).toDouble(),
      tumult: Zeitfenster(Uhrzeit.parse(tumult['von'] as String), Uhrzeit.parse(tumult['bis'] as String)),
      tumultRaeume: (tumult['raeume'] as List).cast<String>().toSet(),
      tumultLautBis: (tumult['lautBis'] as num).toDouble(),
      tumultLeiseBis: (tumult['leiseBis'] as num).toDouble(),
      leiseBis: 3.0,
      lautTuerBis: 3.0,
      fuehlenBis: ((j['fuehlen'] as Map)['bis'] as num).toDouble(),
      riechenNachwirken: ((j['riechen'] as Map)['nachwirkenSekunden'] as num).toInt(),
      haltungen: {
        for (final e in (j['haltungen'] as Map).entries)
          e.key as String: (sieht: (e.value as Map)['sieht'] as bool, hoert: (e.value as Map)['hoert'] as String),
        'geht': (sieht: true, hoert: 'alles'),
        'rennt': (sieht: true, hoert: 'alles'),
        'faellt': (sieht: false, hoert: 'nichts'),
      },
      planVon: Uhrzeit.parse(plan[0] as String),
      planBis: Uhrzeit.parse(plan[1] as String),
      fensterVon: Uhrzeit.parse(fenster[0] as String),
      fensterBis: Uhrzeit.parse(fenster[1] as String),
      matrixSchritt: (abt['matrixSchritt'] as num).toInt(),
    );
  }

  bool imTumult(String? raum, Uhrzeit t) => raum != null && tumultRaeume.contains(raum) && tumult.enthaelt(t);
}

enum LichtStufe { dunkel, rest, schwach, voll }

/// Eine Wahrnehmung einer Person, zusammengefasst über ein Zeitintervall.
class Wahrnehmung {
  final String wer;
  final String sinn; // sehen, hoeren, fuehlen, riechen
  final String quelle; // Person, Ereignis oder Geräuschquelle (z. B. `rennen:can`)
  final String detail; // erkannt, umriss, leuchten, sprecher, anonym
  final String? person; // betroffene Person (Ziel, Sprecher, Läufer)
  final String text;
  final Uhrzeit von;
  Uhrzeit bis;

  Wahrnehmung({required this.wer, required this.sinn, required this.quelle, required this.detail, required this.person, required this.text, required this.von, required this.bis});

  String get schluessel => '$wer|$sinn|$quelle|$detail';

  @override
  String toString() => '$von–$bis $wer $sinn $quelle ($detail) $text';
}

/// Ein Geräusch zu einem Zeitpunkt (für das Hören).
class _Geraeusch {
  final String quelle;
  final String lautstaerke;
  final double x, y;
  final String? raum;
  final String? person;
  final bool sprecher;
  final String text;
  _Geraeusch(this.quelle, this.lautstaerke, this.x, this.y, this.raum, this.person, this.sprecher, this.text);
}

/// Rechnet alle Wahrnehmungen eines Pfads aus dem [Ablauf] aus.
class WahrnehmungsRechner {
  final RaumGraph graph;
  final Ablauf ablauf;
  final WahrnehmungsRegeln regeln;
  late final Map<String, List<(Uhrzeit, bool)>> _lichtSchalter = _sammleLichtSchalter();
  late final Map<String, List<(Uhrzeit, String)>> _tuerZustaende = _sammleTueren();

  WahrnehmungsRechner(this.graph, this.ablauf, this.regeln);

  Tatmatrix get matrix => ablauf.matrix;

  Map<String, List<(Uhrzeit, bool)>> _sammleLichtSchalter() {
    final out = <String, List<(Uhrzeit, bool)>>{};
    for (final plan in matrix.plaene.values) {
      for (final s in plan) {
        if (s.licht != null && s.an != null) (out[s.licht!] ??= []).add((s.t, s.an!));
      }
    }
    for (final l in out.values) {
      l.sort((a, b) => a.$1.compareTo(b.$1));
    }
    return out;
  }

  Map<String, List<(Uhrzeit, String)>> _sammleTueren() {
    final out = <String, List<(Uhrzeit, String)>>{};
    for (final e in matrix.ereignisse) {
      if (e.art == 'tuer' && e.tuer != null && e.zustand != null) (out[e.tuer!] ??= []).add((e.t, e.zustand!));
    }
    return out;
  }

  /// Zustand einer Tür zur Zeit [t] (Ausgang aus raeume.json, Änderungen aus der Tatmatrix).
  String tuerZustand(Tuer tuer, Uhrzeit t) {
    var z = tuer.zustand;
    for (final (zeit, neu) in _tuerZustaende[tuer.id] ?? const <(Uhrzeit, String)>[]) {
      if (zeit <= t) z = neu;
    }
    return z;
  }

  bool _tuerLaesstSichtDurch(Tuer t, Uhrzeit zeit) => tuerZustand(t, zeit).startsWith('offen');
  bool _tuerLaesstHoerenDurch(Tuer t, Uhrzeit zeit) {
    final z = tuerZustand(t, zeit);
    return z.startsWith('offen') || z.startsWith('angelehnt');
  }

  /// Brennt eine Lichtquelle zur Zeit [t]? Getragene Lichter folgen den Schaltern im Plan.
  bool brennt(Lichtquelle l, Uhrzeit t) {
    final schalter = _lichtSchalter[l.id];
    if (schalter != null && schalter.isNotEmpty) {
      var an = false;
      for (final (zeit, wert) in schalter) {
        if (zeit <= t) an = wert;
      }
      return an;
    }
    return l.an.isEmpty ? false : l.an.any((f) => f.enthaelt(t));
  }

  (double, double)? _lichtPos(Lichtquelle l, Uhrzeit t) {
    if (l.traeger != null) {
      final z = ablauf.zustand(l.traeger!, t);
      return z == null ? null : (z.x, z.y);
    }
    if (l.ort != null) {
      final o = graph.orte[l.ort];
      return o == null ? null : (o.x, o.y);
    }
    return null;
  }

  /// Freie Sichtlinie: Wände, verschlossene und geschlossene Türen blockieren.
  bool sichtFrei(double ax, double ay, double bx, double by, Uhrzeit t) {
    if (!graph.raster.lineOfSight(ax, ay, bx, by)) return false;
    final d = dist(ax, ay, bx, by);
    final schritte = (d / 0.25).ceil();
    for (var i = 1; i < schritte; i++) {
      final f = i / schritte;
      final x = (ax + (bx - ax) * f).floor(), y = (ay + (by - ay) * f).floor();
      for (final tuer in graph.tueren.values) {
        for (final k in tuer.kacheln) {
          if (k.x == x && k.y == y && !_tuerLaesstSichtDurch(tuer, t)) return false;
        }
      }
    }
    return true;
  }

  /// Lichtstufe an einem Punkt (ohne das Nachleuchten der Maske, das nur ihren Träger zeigt).
  LichtStufe lichtStufe(double x, double y, String? raum, Uhrzeit t) {
    var stufe = LichtStufe.dunkel;
    for (final l in graph.lichtquellen.values) {
      if (!brennt(l, t)) continue;
      if (l.art == 'elektrisch') {
        if (raum != null && l.raeume.contains(raum)) return LichtStufe.voll;
        continue;
      }
      if (l.art == 'nachleuchten') continue;
      final p = _lichtPos(l, t);
      if (p == null) continue;
      if (dist(p.$1, p.$2, x, y) > l.radius) continue;
      if (!sichtFrei(p.$1, p.$2, x, y, t)) continue;
      final s = l.art == 'notlicht' ? LichtStufe.rest : LichtStufe.schwach;
      if (s.index > stufe.index) stufe = s;
    }
    return stufe;
  }

  /// Leuchtet bei Person [p] ein getragenes Nachleuchten (Maske)?
  bool leuchtet(String p, Uhrzeit t) {
    for (final l in graph.lichtquellen.values) {
      if (l.art == 'nachleuchten' && l.traeger == p && brennt(l, t)) return true;
    }
    return false;
  }

  List<_Geraeusch> _geraeusche(Uhrzeit t) {
    final out = <_Geraeusch>[];
    for (final e in matrix.ereignisse) {
      if (e.t != t) continue;
      if (e.art == 'tuer' && e.tuer != null && (graph.tueren[e.tuer]?.quietscht ?? false)) {
        final o = graph.orte[e.ort];
        if (o != null) out.add(_Geraeusch('${e.id}:quietschen', 'laut', o.x, o.y, o.raum, e.person, false, 'Eine Tür quietscht.'));
      }
      if (e.lautstaerke == null) continue;
      final o = graph.orte[e.ort];
      if (o == null) continue;
      out.add(_Geraeusch(e.id, e.lautstaerke!, o.x, o.y, o.raum, e.person, false, e.text));
    }
    for (final p in matrix.plaene.entries) {
      for (final s in p.value) {
        if (s.t != t || (s.sagt == null && s.geraeusch == null)) continue;
        final z = ablauf.zustand(p.key, t);
        if (z == null) continue;
        if (s.sagt != null) {
          out.add(_Geraeusch('sagt:${p.key}', s.lautstaerke, z.x, z.y, z.raum, p.key, true, '„${s.sagt}“'));
        } else {
          out.add(_Geraeusch('geraeusch:${p.key}', s.lautstaerke, z.x, z.y, z.raum, p.key, false, s.geraeusch!));
        }
      }
    }
    for (final p in ablauf.personen) {
      final z = ablauf.zustand(p, t);
      if (z == null || !z.bewegtSich) continue;
      if (z.tempo == 'faellt') continue; // Das Poltern des Sturzes ist Teil des Schepperns.
      if (z.tempo == 'rennen') {
        out.add(_Geraeusch('rennen:$p', 'laut', z.x, z.y, z.raum, p, false, 'Jemand rennt.'));
      } else {
        out.add(_Geraeusch('schritte:$p', 'leise', z.x, z.y, z.raum, p, false, 'Schritte.'));
      }
    }
    return out;
  }

  Tuer? _tuerZwischen(String a, String b) {
    for (final t in graph.tueren.values) {
      if ((t.von == a && t.nach == b) || (t.von == b && t.nach == a)) return t;
    }
    return null;
  }

  /// Hört Person [z] das Geräusch [g] zur Zeit [t]?
  bool _hoert(PersonZustand z, _Geraeusch g, Uhrzeit t) {
    final h = regeln.haltungen[z.haltung]?.hoert ?? 'alles';
    if (h == 'nichts') return false;
    if (h == 'nur_sehr_laut' && g.lautstaerke != 'sehr_laut') return false;
    if (z.raum == null || g.raum == null) return false;
    final d = dist(z.x, z.y, g.x, g.y);
    final tumult = regeln.imTumult(z.raum, t);
    if (z.raum == g.raum) {
      switch (g.lautstaerke) {
        case 'sehr_laut':
          return true;
        case 'laut':
          return !tumult || d <= regeln.tumultLautBis;
        default:
          return d <= (tumult ? regeln.tumultLeiseBis : regeln.leiseBis);
      }
    }
    final tuer = _tuerZwischen(z.raum!, g.raum!);
    if (tuer == null || !_tuerLaesstHoerenDurch(tuer, t)) return false;
    if (g.lautstaerke == 'sehr_laut') return true;
    if (g.lautstaerke == 'laut') {
      final k = tuer.kacheln.first;
      return dist(z.x, z.y, k.x + 0.5, k.y + 0.5) <= regeln.lautTuerBis;
    }
    return false;
  }

  /// Alle Wahrnehmungen im Planfenster, je Sekunde abgetastet und zu Intervallen zusammengefasst.
  List<Wahrnehmung> berechne() {
    final offen = <String, Wahrnehmung>{};
    final fertig = <Wahrnehmung>[];
    void merke(String wer, String sinn, String quelle, String detail, String? person, String text, Uhrzeit t) {
      final key = '$wer|$sinn|$quelle|$detail';
      final w = offen[key];
      if (w != null && t.minus(w.bis) <= 1) {
        w.bis = t;
        return;
      }
      if (w != null) fertig.add(w);
      offen[key] = Wahrnehmung(wer: wer, sinn: sinn, quelle: quelle, detail: detail, person: person, text: text, von: t, bis: t);
    }

    final personen = ablauf.personen.toList();
    for (var t = regeln.planVon; t <= regeln.planBis; t = t.plus(1)) {
      final zustaende = {for (final p in personen) p: ablauf.zustand(p, t)};
      final licht = <String, LichtStufe>{};
      for (final p in personen) {
        final z = zustaende[p];
        if (z != null) licht[p] = lichtStufe(z.x, z.y, z.raum, t);
      }
      // Sehen
      for (final o in personen) {
        final zo = zustaende[o];
        if (zo == null || !(regeln.haltungen[zo.haltung]?.sieht ?? true)) continue;
        for (final p in personen) {
          if (p == o) continue;
          final zp = zustaende[p];
          if (zp == null) continue;
          final stufe = licht[p]!;
          final glimmt = leuchtet(p, t);
          if (stufe == LichtStufe.dunkel && !glimmt) continue;
          if (!sichtFrei(zo.x, zo.y, zp.x, zp.y, t)) continue;
          final d = dist(zo.x, zo.y, zp.x, zp.y);
          final String detail;
          switch (stufe) {
            case LichtStufe.voll:
              detail = 'erkannt';
            case LichtStufe.schwach:
              detail = d <= regeln.erkennenSchwachBis ? 'erkannt' : 'umriss';
            case LichtStufe.rest:
              detail = glimmt ? 'leuchten' : 'umriss';
            case LichtStufe.dunkel:
              detail = 'leuchten';
          }
          merke(o, 'sehen', p, detail, p, detail == 'leuchten' ? 'ein leuchtendes Gesicht' : 'sieht $p ($detail)', t);
        }
      }
      // Hören
      final gs = _geraeusche(t);
      for (final g in gs) {
        for (final o in personen) {
          if (o == g.person) continue;
          final zo = zustaende[o];
          if (zo == null || !_hoert(zo, g, t)) continue;
          merke(o, 'hoeren', g.quelle, g.sprecher ? 'sprecher' : 'anonym', g.person, g.text, t);
        }
      }
      // Fühlen
      for (var i = 0; i < personen.length; i++) {
        final a = zustaende[personen[i]];
        if (a == null) continue;
        for (var k = i + 1; k < personen.length; k++) {
          final b = zustaende[personen[k]];
          if (b == null) continue;
          if (dist(a.x, a.y, b.x, b.y) > regeln.fuehlenBis) continue;
          if (a.raum != b.raum) continue;
          if (a.haltung != 'liegt') merke(a.person, 'fuehlen', b.person, 'anonym', b.person, 'jemand ist ganz nah', t);
          if (b.haltung != 'liegt') merke(b.person, 'fuehlen', a.person, 'anonym', a.person, 'jemand ist ganz nah', t);
        }
      }
      // Riechen
      for (final e in matrix.ereignisse) {
        if (e.art != 'geruch') continue;
        final seit = t.minus(e.t);
        if (seit < 0 || seit > regeln.riechenNachwirken) continue;
        final quelleRaum = graph.orte[e.ort]?.raum;
        if (quelleRaum == null) continue;
        for (final o in personen) {
          final zo = zustaende[o];
          if (zo == null || zo.raum == null || zo.haltung == 'liegt') continue;
          final traegt = zo.raum == quelleRaum || graph.luftzug.any((l) => l.traegt(quelleRaum, zo.raum!, t));
          if (traegt) merke(o, 'riechen', e.id, 'anonym', null, e.text, t);
        }
      }
    }
    fertig.addAll(offen.values);
    fertig.sort((a, b) {
      final c = a.von.compareTo(b.von);
      return c != 0 ? c : a.wer.compareTo(b.wer);
    });
    return fertig;
  }
}

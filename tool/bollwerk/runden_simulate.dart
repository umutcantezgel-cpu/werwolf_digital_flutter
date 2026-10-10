// BOLLWERK · Runden-Simulator (Schicht L4; Z-03…Z-08, Z-12).
// Port von planung/bollwerk/proben/wuerfel_sim.py, aber gegen den Würfelkern
// (packages/mordakte_core/lib/src/runden/) und die echte Kanon-Engine (Ermittlung,
// Simulator.verlauf) statt eines eigenen Modells. Die Strategie-Zufallszahlen kommen
// aus einem Nachbau von Pythons random.Random, damit am Seed-Satz des Meta-Laufs
// dieselben Zahlen entstehen (Modus meta-gleich).
//
// Aufruf: dart run tool/bollwerk/runden_simulate.dart --modus <m> [--seeds N] [--json <aus>] [--kanon <ordner>]
//   Modi: meta-gleich (JSON wie wuerfel_sim.py) · erschoepfend (Z-03) · wertung (Z-04) · baender (Z-05) ·
//         ueberschneidung (Z-08); fairness, dauer: OFFEN bis zum Zeitmodell (L-2).
// Exit 0 nur, wenn die Schwellen des Modus halten; letzte Zeile „L4 <modus> GRÜN|ROT|OFFEN …“.
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte_core/src/runden/wuerfel.dart';
import 'package:mordakte_core/src/runden/zugschicht.dart';

import 'lib/py_random.dart';

/// Strategie-Parameter des Meta-Simulators (Satz 6, E-M2-01); nicht Teil der Regeln.
const Map<String, num> strategieParameter = {
  'p_helfer': 0.30,
  'p_gruendlich': 0.20,
  'abstecher_je_runde': 8,
  'anteil_abstecher_mit_wurf': 0.2,
};
const pfadeMeta = ['ahmet', 'fatma', 'olli', 'can'];

/// Würfelstrom „zufall“ wie `Strom` im Python-Simulator: zwei randint(1, 6) je Wurf.
class PyStrom implements WuerfelQuelle {
  final PyRandom r;
  PyStrom(int seed) : r = PyRandom(seed);
  @override
  (int, int) augen(String id, int anlauf) {
    final a = r.randint(1, 6);
    return (a, r.randint(1, 6));
  }
}

class Partie {
  int zuege = 0, wuerfe = 0, erstePech = 0, ersteWuerfe = 0, abstecher = 0, befragungBesetzt = 0;
  double geraetS = 0;
  final List<String> szenen = [];
  final List<int> wurfsummen = [];
  final Set<int> wurfRunde = {};
  late Zugschicht z;
  int punkte = 0;
  int get pechSzenen => z.pechSzenen;
  int get erfolgeZusatz => z.erfolgeMitZusatz;
  int get maxPechFolge => z.maxPechFolge;
  bool get sackgasse => z.aufgedeckt.length != 9;
}

class Welt {
  final Kanon kanon;
  final Ermittlung ermittlung;
  final Simulator sim;
  final Map<String, int> minp;
  final Map<String, Set<String>> gespraech = {};
  final Map<String, List<String>> ziele = {};
  Welt(this.kanon)
      : ermittlung = Ermittlung(kanon),
        sim = Simulator(kanon),
        minp = {for (final f in kanon.figuren) f['id'] as String: f['minPlayers'] as int} {
    for (final e in ermittlung.entscheidungen) {
      gespraech[e.id] = {
        for (final b in e.begruendung.values)
          for (final k in b.kette)
            if (k.split(':').first == 'beobachtung' || k.split(':').first == 'luege') k,
      };
      ziele[e.id] = [for (final o in e.optionen) o.ziel.values.first];
    }
  }

  List<String> runde(int r) => [for (final e in ermittlung.runde(r)) e.id];
}

/// Eine Partie nach dem Ablauf des Meta-Simulators, gespielt über die Zugschicht.
Partie spiele(Welt w, String pfad, int n, String form, Map<String, String> wahl, WuerfelQuelle strom, String strategie,
    PyRandom rs) {
  final pt = Partie();
  final z = pt.z = Zugschicht(w.ermittlung, strom)..setzePfad(pfad);
  bool besetzt(String r) => form != 'solo' && (w.minp[r] ?? 99) <= n;
  final lust = {'gier': 1.0, 'neutral': 1.0, 'geiz': 0.0}[strategie]!;
  final pHelfer = strategieParameter['p_helfer']!.toDouble();
  final pGruendlich = strategieParameter['p_gruendlich']!.toDouble();
  final anteilWurf = strategieParameter['anteil_abstecher_mit_wurf']!.toDouble();
  var gezaehlt = 0;
  void nimmWuerfe(int runde) {
    for (; gezaehlt < z.wuerfe.length; gezaehlt++) {
      final wu = z.wuerfe[gezaehlt];
      if (wu.id == 'auftakt') continue;
      pt.wurfsummen.add(wu.a + wu.b);
      pt.wurfRunde.add(runde);
    }
  }

  bool marke() => z.markeVerfuegbar && rs.random() < 0.3;
  for (final runde in [1, 2, 3]) {
    z.beginneRunde(runde);
    if (form == 'solo') {
      final g = {for (final eid in w.runde(runde)) ...w.gespraech[eid]!}.toList()..sort();
      for (final k in g) {
        pt.geraetS += 25;
        pt.szenen.add('g:$k');
      }
    }
    final angebot = [for (var i = 0; i < strategieParameter['abstecher_je_runde']!; i++) 'a${runde}_$i'];
    rs.shuffle(angebot);
    if (runde == 1) {
      pt.zuege++;
      pt.wuerfe++;
      pt.ersteWuerfe++;
      pt.geraetS += 20;
      final a = z.auftakt();
      gezaehlt = z.wuerfe.length;
      pt.wurfRunde.add(1);
      if (a.stufe == Stufe.pech) pt.erstePech++;
      pt.szenen.add('auftakt:${a.stufe.kurz}');
    }
    while (z.offen.isNotEmpty) {
      while (angebot.isNotEmpty && z.abstecherErlaubt() && rs.random() < lust) {
        final a = angebot.removeLast();
        pt.zuege++;
        pt.abstecher++;
        pt.geraetS += 30;
        if (rs.random() < anteilWurf) {
          pt.wuerfe++;
          pt.ersteWuerfe++;
          pt.geraetS += 6;
          final werkzeug = rs.random() < pHelfer;
          final wu = z.abstecher(a, mitWurf: true, werkzeug: werkzeug, gruendlich: strategie == 'gier', marke: marke())!;
          nimmWuerfe(runde);
          if (wu.stufe == Stufe.pech) pt.erstePech++;
          if (wu.stufe == Stufe.erfolg) angebot.add('${a}f');
          pt.szenen.add('$a:${wu.stufe.kurz}');
        } else {
          z.abstecher(a);
          pt.szenen.add('$a:-');
        }
      }
      final eid = z.offen.first;
      final opt = wahl[eid]!;
      final ziel = w.ziele[eid]![w.ermittlung.entscheidung(eid).optionen.indexWhere((o) => o.id == opt)];
      final gruendlich = strategie == 'gier' || rs.random() < pGruendlich;
      pt.zuege++;
      pt.geraetS += 30;
      final suche = z.waehle(opt, gruendlich: gruendlich);
      if (!suche) {
        if (besetzt(ziel)) pt.befragungBesetzt++;
        pt.szenen.add('$opt:B');
        continue;
      }
      var anlauf = 1;
      while (true) {
        pt.wuerfe++;
        pt.geraetS += 6;
        if (anlauf == 1) pt.ersteWuerfe++;
        final werkzeug = rs.random() < pHelfer;
        final wu = z.anlauf(werkzeug: werkzeug, marke: marke());
        nimmWuerfe(runde);
        if (anlauf == 1 && wu.stufe == Stufe.pech) pt.erstePech++;
        pt.szenen.add('$opt:$anlauf${wu.stufe.kurz}');
        if (wu.stufe != Stufe.pech) break;
        anlauf++;
        if (!z.tischruf(strategie == 'gier' ? Tischruf.umweg : Tischruf.nochmal)) break;
        pt.geraetS += 20;
      }
    }
    z.beendeRunde();
  }
  pt.punkte = z.wertung(w.sim, pfad).punkte;
  return pt;
}

Iterable<Map<String, String>> alleFolgen(Welt w) sync* {
  for (final f in w.sim.folgen()) {
    yield {for (var i = 0; i < f.length; i++) w.ermittlung.entscheidungen[i].id: f[i]};
  }
}

double median(List<num> l) {
  final s = [...l]..sort();
  final m = s.length ~/ 2;
  return s.length.isOdd ? s[m].toDouble() : (s[m - 1] + s[m]) / 2;
}

double mean(Iterable<num> l) {
  var s = 0.0;
  var n = 0;
  for (final x in l) {
    s += x;
    n++;
  }
  return s / n;
}

/// round(x, n) wie Python (Halbe zur geraden Ziffer am exakten Binärwert).
double pyRound(double x, int n) {
  final f = [1, 10, 100, 1000, 10000][n];
  final y = x * f;
  final fl = y.floorToDouble();
  final d = y - fl;
  double r;
  if (d == 0.5) {
    r = fl % 2 == 0 ? fl : fl + 1;
  } else {
    r = y.roundToDouble();
  }
  return double.parse((r / f).toStringAsFixed(n));
}

Map<String, Object> erschoepfend(Welt w) {
  var sack = 0, kette = 0, budget = 0, wertAbw = 0, standAbw = 0, bestLuecke = 0, laeufe = 0;
  final folgen = alleFolgen(w).toList();
  for (final pfad in pfadeMeta) {
    for (final wahl in folgen) {
      int? neutralPunkte;
      Map<String, Set<String>>? neutralStand;
      final best = wahl.entries.every((e) => w.ermittlung.entscheidung(e.key).richtig[pfad] == e.value);
      for (var n = 4; n <= 20; n++) {
        for (final art in ['pech', 'erfolg', 'neutral']) {
          for (final strat in ['neutral', 'gier']) {
            final strom = art == 'pech'
                ? const FesterWuerfel.pech()
                : art == 'erfolg'
                    ? const FesterWuerfel.erfolg()
                    : const FesterWuerfel.neutral();
            final lg = spiele(w, pfad, n, 'party', wahl, strom, strat, PyRandom(pySeed([pfad, n, art, strat])));
            laeufe++;
            if (lg.sackgasse) sack++;
            kette += lg.z.kettenverletzungen;
            budget += lg.z.budgetUeber;
            neutralPunkte ??= lg.punkte;
            neutralStand ??= lg.z.standBeimOeffnen;
            if (lg.punkte != neutralPunkte) wertAbw++;
            if (!_standGleich(lg.z.standBeimOeffnen, neutralStand)) standAbw++;
            if (best) {
              for (final e in lg.z.standBeimOeffnen.entries) {
                final b = w.ermittlung.entscheidung(e.key).begruendungFuer(pfad);
                for (final k in b?.kette ?? const <String>[]) {
                  if (k.startsWith('fakt:') && !e.value.contains(k.substring(5))) bestLuecke++;
                }
              }
            }
          }
        }
      }
    }
  }
  return {
    'laeufe': laeufe,
    'sackgassen': sack,
    'kettenverletzungen': kette,
    'budget_ueber': budget,
    'wertung_abweichend': wertAbw,
    'faktenstand_abweichend_vom_neutralwurf': standAbw,
    'bestes_spiel_fehlende_kettenglieder': bestLuecke,
  };
}

bool _standGleich(Map<String, Set<String>> a, Map<String, Set<String>> b) {
  if (a.length != b.length) return false;
  for (final e in a.entries) {
    final o = b[e.key];
    if (o == null || o.length != e.value.length || !o.containsAll(e.value)) return false;
  }
  return true;
}

List<Partie> zufall(Welt w, String form, int n, int k) {
  final out = <Partie>[];
  for (var i = 0; i < k; i++) {
    final pfad = pfadeMeta[i % 4];
    final s = pySeed(['bollwerk-meta', form, n, pfad, i]);
    final rs = PyRandom(s);
    final wahl = {for (final e in w.ermittlung.entscheidungen) e.id: rs.choice([for (final o in e.optionen) o.id])};
    out.add(spiele(w, pfad, n, form, wahl, PyStrom(s), 'neutral', rs));
  }
  return out;
}

Map<String, Object?> band(Welt w, String form, int n, int k) {
  final l = zufall(w, form, n, k);
  int summe(int Function(Partie) f) => l.fold<int>(0, (a, p) => a + f(p));
  final anteil = [for (final p in l) p.wuerfe / p.zuege];
  final anteilErste = summe((p) => p.ersteWuerfe) / summe((p) => p.zuege);
  final anteilStreng = summe((p) => p.ersteWuerfe) / summe((p) => p.zuege - p.befragungBesetzt);
  final pech1 = summe((p) => p.erstePech) / (summe((p) => p.ersteWuerfe) < 1 ? 1 : summe((p) => p.ersteWuerfe));
  final idx = List.generate(l.length, (i) => i);
  double gm(Partie p) => p.wurfsummen.isEmpty ? 7 : mean(p.wurfsummen);
  final key = [for (final p in l) gm(p)];
  idx.sort((a, b) {
    final c = key[a].compareTo(key[b]);
    return c != 0 ? c : a.compareTo(b);
  });
  final q = l.length ~/ 4;
  final unten = [for (final i in idx.take(q)) l[i]];
  final oben = [for (final i in idx.skip(idx.length - q)) l[i]];
  final abU = mean(unten.map((p) => p.abstecher)), abO = mean(oben.map((p) => p.abstecher));
  final zfU = mean(unten.map((p) => p.erfolgeZusatz)), zfO = mean(oben.map((p) => p.erfolgeZusatz));
  final geraet = [for (final p in l) p.geraetS / 3 / 60]..sort();
  final rr = PyRandom(pySeed(['c9', form, n]));
  final jac = <double>[];
  for (var t = 0; t < (l.length < 1000 ? l.length : 1000); t++) {
    final ab = rr.sample(l, 2);
    final a = ab[0].szenen.toSet(), b = ab[1].szenen.toSet();
    jac.add(a.intersection(b).length / a.union(b).length);
  }
  return {
    'partien': l.length,
    'anteil_wurf_erste_anlaeufe': pyRound(anteilErste, 3),
    'anteil_wurf_streng': pyRound(anteilStreng, 3),
    'anteil_wurf_median': pyRound(median(anteil), 3),
    'pech_erster_anlauf': pyRound(pech1, 3),
    'max_pech_folge': l.map((p) => p.maxPechFolge).reduce((a, b) => a > b ? a : b),
    'anteil_jede_runde_mit_wurf': pyRound(l.where((p) => p.wurfRunde.containsAll({1, 2, 3})).length / l.length, 4),
    'pech_szenen_median': median([for (final p in l) p.pechSzenen]),
    'erfolge_zusatz_median': median([for (final p in l) p.erfolgeZusatz]),
    'abstecher_unten': pyRound(abU, 2),
    'abstecher_oben': pyRound(abO, 2),
    'abstecher_minus': abO != 0 ? pyRound(1 - abU / abO, 3) : null,
    'zusatz_unten': pyRound(zfU, 2),
    'zusatz_oben': pyRound(zfO, 2),
    'zusatz_minus': zfO != 0 ? pyRound(1 - zfU / zfO, 3) : null,
    'geraet_min_je_runde_median': pyRound(median(geraet), 2),
    'geraet_min_je_runde_p95': pyRound(geraet[(0.95 * geraet.length).toInt()], 2),
    'sackgassen': l.where((p) => p.sackgasse).length,
    'c9_jaccard_median': pyRound(median(jac), 3),
    'punkte_mittel': pyRound(mean(l.map((p) => p.punkte)), 2),
  };
}

Map<String, Object?> baender(Welt w, int seeds) => {
      for (final form in ['party', 'solo'])
        for (final n in [4, 8, 12, 16, 20]) '${form}_n$n': band(w, form, n, seeds),
    };

String _wurzel() {
  var d = Directory.current;
  while (!Directory('${d.path}/content/party').existsSync()) {
    if (d.parent.path == d.path) throw StateError('content/party nicht gefunden');
    d = d.parent;
  }
  return d.path;
}

void main(List<String> args) {
  String? arg(String name) {
    final i = args.indexOf(name);
    return i >= 0 && i + 1 < args.length ? args[i + 1] : null;
  }

  final modus = arg('--modus') ?? 'meta-gleich';
  final seeds = int.parse(arg('--seeds') ?? '200');
  final ordner = arg('--kanon') ?? '${_wurzel()}/content/party/schlosskeller';
  final kanon = Kanon.lade((p) => jsonDecode(File('$ordner/$p').readAsStringSync()) as Map<String, Object?>);
  final w = Welt(kanon);
  final p = const ZugParameter();
  final rot = <String>[];
  Object? ergebnis;
  switch (modus) {
    case 'meta-gleich':
      final c81a = {
        'worst': p.schlechtesterPflichtzug,
        'budget_ungleichung': '3*${p.schlechtesterPflichtzug}=${3 * p.schlechtesterPflichtzug} <= ${p.rundenzeit}',
        'ok': p.budgetUngleichung(3),
      };
      ergebnis = {
        'folgen': alleFolgen(w).length,
        'c8_1a': c81a,
        'c8_1b_c8_2': erschoepfend(w),
        'baender': baender(w, seeds),
      };
    case 'erschoepfend':
      final e = erschoepfend(w);
      ergebnis = e;
      for (final k in ['sackgassen', 'kettenverletzungen', 'budget_ueber', 'faktenstand_abweichend_vom_neutralwurf', 'bestes_spiel_fehlende_kettenglieder']) {
        if (e[k] != 0) rot.add('$k=${e[k]}');
      }
      if (!p.budgetUngleichung(3)) rot.add('budget_ungleichung');
    case 'wertung':
      final e = erschoepfend(w);
      ergebnis = {'laeufe': e['laeufe'], 'wertung_abweichend': e['wertung_abweichend']};
      if (e['wertung_abweichend'] != 0) rot.add('wertung_abweichend=${e['wertung_abweichend']}');
    case 'baender':
      final b = baender(w, seeds);
      ergebnis = b;
      for (final e in b.entries) {
        final v = e.value as Map<String, Object?>;
        double d(String k) => (v[k] as num).toDouble();
        if (d('anteil_wurf_erste_anlaeufe') < 0.30 || d('anteil_wurf_erste_anlaeufe') > 0.60) rot.add('${e.key}:anteil');
        if (d('anteil_wurf_streng') < 0.30 || d('anteil_wurf_streng') > 0.60) rot.add('${e.key}:anteil_streng');
        if (d('pech_erster_anlauf') < 0.20 || d('pech_erster_anlauf') > 0.35) rot.add('${e.key}:pech1');
        if (d('max_pech_folge') > 2) rot.add('${e.key}:pechfolge');
        if (d('pech_szenen_median') < 2 || d('erfolge_zusatz_median') < 2) rot.add('${e.key}:spuerbar');
        if (d('abstecher_minus') < 0.25 || d('zusatz_minus') < 0.25) rot.add('${e.key}:quartil');
      }
    case 'ueberschneidung':
      final b = baender(w, seeds);
      ergebnis = {for (final e in b.entries) e.key: (e.value as Map)['c9_jaccard_median']};
      for (final e in (ergebnis as Map).entries) {
        if ((e.value as num) > 0.45) rot.add('${e.key}:jaccard');
      }
    default:
      stdout.writeln(const JsonEncoder.withIndent(' ').convert({'modus': modus}));
      stdout.writeln('L4 $modus OFFEN · Zeitmodell bzw. Fairness-Bots folgen (Lichtung L-2)');
      exit(1);
  }
  final json = const JsonEncoder.withIndent(' ').convert(ergebnis);
  final aus = arg('--json');
  if (aus != null) File(aus).writeAsStringSync(json);
  stdout.writeln(json);
  stdout.writeln(rot.isEmpty ? 'L4 $modus GRÜN' : 'L4 $modus ROT · ${rot.join(' ')}');
  exit(rot.isEmpty ? 0 : 1);
}

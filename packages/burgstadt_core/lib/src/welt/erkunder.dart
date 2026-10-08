/// Erkundungsbots (Auftrag A-307a, Ebene 6): Bots laufen mit derselben Kollision wie der
/// Spieler (`Bereich.frei`, Radius 0,22 m) durch die Welt, benutzen jede offene Tür
/// (Anlaufen, Durchgang, Ankunft an der Zielmarke) und melden Türen, die sie nicht
/// erreichen, sowie Stellen, an denen ein Bot 3 s lang nicht vorankommt.
library;

import 'dart:math' as math;

import '../zufall.dart';
import 'bereich.dart';
import 'navigation.dart';

/// Schrittweite der Simulation (30 Hz) und Gehtempo (m/s), wie beim Spieler.
const double kErkundungDt = 1 / 30;
const double kGehTempo = 1.4;

/// Ankunft an einem Wegpunkt (m) und Abstand zur Tür, ab dem sie benutzt wird (m).
const double _kAnkunft = 0.06;
const double _kDurchgang = 0.30;

/// Steckenbleiben: mindestens so viel Fortschritt (m) binnen so viel Spielzeit (s).
const double kFortschrittM = 0.2;
const double kStecktS = 3.0;

/// Abstand der Abtastpunkte bei der Sichtlinienprüfung (m) und Vorausschau (Schritte).
const double _kAbtast = 0.05;
const int _kVorausschau = 8;

/// Sicherung gegen Endlosläufe: höchstens so viel Simulationszeit (s).
const double _kZeitGrenze = 4 * 3600.0;

/// Zustand einer offenen Tür in der Erkundung.
enum TuerStand { offen, erreicht, gescheitert }

/// Eine offene Tür (Ding der Art `tuer`), die am Ende erreicht sein soll.
class ErkundungsTuer {
  ErkundungsTuer({required this.von, required this.ding, required this.nach, required this.nachKachel});

  /// Bereich, in dem die Tür liegt, und ihr Ding (Kacheln, Legende).
  final Bereich von;
  final Ding ding;

  /// Zielbereich und Kachel der Zielmarke; null, wenn das Ziel fehlt.
  final Bereich? nach;
  final (int, int)? nachKachel;

  TuerStand stand = TuerStand.offen;
  Erkunder? zugewiesenAn;

  /// Ankunftspunkt in Metern (Mitte der Zielkachel).
  (double, double)? get nachPos {
    final k = nachKachel;
    return k == null ? null : ((k.$1 + 0.5) * kKachel, (k.$2 + 0.5) * kKachel);
  }

  String get bezeichnung => '${von.id} „${ding.legende.name}“ (${ding.x0}/${ding.z0})';
}

/// Ein Schritt eines Weges: zu einer Stelle gehen oder durch eine Tür gehen.
sealed class Schritt {}

class GehSchritt extends Schritt {
  GehSchritt(this.bereich, this.x, this.z);
  final Bereich bereich;
  final double x, z;
}

class DurchgangSchritt extends Schritt {
  DurchgangSchritt(this.tuer);
  final ErkundungsTuer tuer;
}

/// ErkundungsEreignisse eines Zeitschritts.
sealed class ErkundungsEreignis {}

/// Ein Bot ist durch [tuer] gegangen und an der Zielmarke frei angekommen.
class TuerErreicht extends ErkundungsEreignis {
  TuerErreicht(this.tuer);
  final ErkundungsTuer tuer;
}

/// Ein Bot kommt nicht voran (oder steht an der Zielmarke nicht frei).
class Steckenbleiber extends ErkundungsEreignis {
  Steckenbleiber({
    required this.bot,
    required this.bereich,
    required this.kachel,
    required this.tuer,
    required this.grund,
  });

  final String bot;
  final String bereich;
  final (int, int) kachel;
  final ErkundungsTuer tuer;
  final String grund;

  @override
  String toString() =>
      '$bot in $bereich auf ${kachel.$1}/${kachel.$2} · Ziel ${tuer.bezeichnung} · $grund';
}

/// Ein Erkundungsbot: Position in einem Bereich (Meter) und ein Weg aus Schritten.
class Erkunder {
  Erkunder({required this.name, required this.bereich, required this.x, required this.z});

  final String name;
  Bereich bereich;
  double x, z;

  /// Simulierte Zeit (s), in der dieser Bot unterwegs war.
  double spielzeit = 0;

  /// Keine erreichbare Tür mehr für diesen Bot.
  bool fertig = false;

  /// Endziel des aktuellen Weges (null, wenn untätig).
  ErkundungsTuer? ziel;

  final List<Schritt> _plan = [];
  double _bestDistanz = double.infinity;
  double _bestZeit = 0;

  bool get untaetig => _plan.isEmpty;
  bool get frei => bereich.frei(x, z);
  (int, int) get kachel => ((x / kKachel).floor(), (z / kKachel).floor());
  Ort get ort => (bereich.id, kachel.$1, kachel.$2);

  /// Setzt einen neuen Weg zum Endziel [endziel] (ersetzt einen alten).
  void zielSetzen(ErkundungsTuer endziel, List<Schritt> schritte) {
    ziel = endziel;
    _plan
      ..clear()
      ..addAll(schritte);
    if (_plan.isNotEmpty) _starteSchritt();
  }

  /// Bewegt den Bot um [dt] Sekunden. Liefert ein ErkundungsEreignis, sobald eine Tür
  /// durchschritten oder ein Steckenbleiben festgestellt wurde.
  ErkundungsEreignis? schritt(double dt) {
    if (_plan.isEmpty) return null;
    spielzeit += dt;
    final s = _plan.first;
    return switch (s) {
      GehSchritt g => _gehen(g, dt),
      DurchgangSchritt d => _durchgang(d, dt),
    };
  }

  ErkundungsEreignis? _gehen(GehSchritt s, double dt) {
    if (!identical(s.bereich, bereich)) return _aufgeben('Weg führt in fremden Bereich');
    if (_abstand(s.x, s.z) <= _kAnkunft) {
      _naechster();
      return null;
    }
    _laufeZu(s.x, s.z, dt);
    if (_steckt(_abstand(s.x, s.z))) return _aufgeben('kein Fortschritt zum Wegpunkt');
    return null;
  }

  ErkundungsEreignis? _durchgang(DurchgangSchritt s, double dt) {
    final t = s.tuer;
    if (_anTuer(t)) {
      final nach = t.nach;
      final pos = t.nachPos;
      if (nach == null || pos == null) return _aufgeben('Zielmarke fehlt');
      if (!nach.frei(pos.$1, pos.$2)) return _aufgeben('Ankunft an der Zielmarke nicht frei');
      bereich = nach;
      x = pos.$1;
      z = pos.$2;
      _naechster();
      return TuerErreicht(t);
    }
    final (mx, mz) = (t.ding.mitteX, t.ding.mitteZ);
    _laufeZu(mx, mz, dt);
    if (_steckt(_abstand(mx, mz))) return _aufgeben('kein Fortschritt zur Tür');
    return null;
  }

  /// Benutzt eine Tür: der Bot steht auf einer Kachel direkt vor ihr und ist nah genug.
  bool _anTuer(ErkundungsTuer t) {
    if (!identical(bereich, t.von)) return false;
    final d = t.ding;
    final (kx, kz) = kachel;
    final davor = (kz >= d.z0 && kz <= d.z1 && (kx == d.x0 - 1 || kx == d.x1 + 1)) ||
        (kx >= d.x0 && kx <= d.x1 && (kz == d.z0 - 1 || kz == d.z1 + 1));
    if (!davor) return false;
    final ddx = math.max(0.0, math.max(d.x0 * kKachel - x, x - (d.x1 + 1) * kKachel));
    final ddz = math.max(0.0, math.max(d.z0 * kKachel - z, z - (d.z1 + 1) * kKachel));
    return math.sqrt(ddx * ddx + ddz * ddz) <= _kDurchgang;
  }

  /// Ein Schritt in Richtung (tx, tz) mit Kollision: erst ganz, dann nur x, dann nur z.
  void _laufeZu(double tx, double tz, double dt) {
    final dx = tx - x, dz = tz - z;
    final d = math.sqrt(dx * dx + dz * dz);
    if (d == 0) return;
    final s = math.min(kGehTempo * dt, d);
    final mx = dx / d * s, mz = dz / d * s;
    if (bereich.frei(x + mx, z + mz)) {
      x += mx;
      z += mz;
    } else if (bereich.frei(x + mx, z)) {
      x += mx;
    } else if (bereich.frei(x, z + mz)) {
      z += mz;
    }
  }

  /// Prüft Fortschritt zum Ziel: steckt, wenn binnen [kStecktS] kein Gewinn von
  /// [kFortschrittM] gegenüber der letzten Marke zustande kam.
  bool _steckt(double distanz) {
    if (distanz <= _bestDistanz - kFortschrittM) {
      _bestDistanz = distanz;
      _bestZeit = spielzeit;
    }
    return spielzeit - _bestZeit >= kStecktS;
  }

  double _abstand(double tx, double tz) {
    final dx = tx - x, dz = tz - z;
    return math.sqrt(dx * dx + dz * dz);
  }

  /// Sichtlinie von der aktuellen Position zu (tx, tz) ohne Kollision.
  bool _sichtlinie(double tx, double tz) {
    final dx = tx - x, dz = tz - z;
    final n = (math.sqrt(dx * dx + dz * dz) / _kAbtast).ceil();
    for (var i = 1; i <= n; i++) {
      final f = i / n;
      if (!bereich.frei(x + dx * f, z + dz * f)) return false;
    }
    return true;
  }

  void _naechster() {
    _plan.removeAt(0);
    if (_plan.isNotEmpty) {
      _starteSchritt();
    } else {
      ziel = null;
    }
  }

  /// Startet den ersten Schritt. Gehschritte werden abgekürzt: der weiteste nahe
  /// Gehschritt in freier Sichtlinie wird direkt angesteuert.
  void _starteSchritt() {
    _bestDistanz = double.infinity;
    _bestZeit = spielzeit;
    if (_plan.first is! GehSchritt) return;
    var weiteste = 0;
    for (var k = 1; k < _plan.length && k <= _kVorausschau; k++) {
      final t = _plan[k];
      if (t is! GehSchritt || !identical(t.bereich, bereich)) break;
      if (_sichtlinie(t.x, t.z)) weiteste = k;
    }
    _plan.removeRange(0, weiteste);
  }

  Steckenbleiber _aufgeben(String grund) {
    final endziel = ziel!;
    _plan.clear();
    ziel = null;
    return Steckenbleiber(
      bot: name,
      bereich: bereich.id,
      kachel: kachel,
      tuer: endziel,
      grund: grund,
    );
  }
}

/// Ergebnis der Erkundung.
class ErkundungsBericht {
  ErkundungsBericht({
    required this.phase,
    required this.seed,
    required this.tuerenGesamt,
    required this.erreicht,
    required this.nichtErreicht,
    required this.steckenbleiber,
    required this.spielzeit,
    required this.rechenzeit,
    required this.bots,
  });

  final int phase;
  final int seed;
  final int tuerenGesamt;
  final int erreicht;

  /// Türen ohne Durchgang: Bezeichnung und Grund.
  final List<String> nichtErreicht;
  final List<Steckenbleiber> steckenbleiber;

  /// Simulierte Spielzeit (s) bis der letzte Bot fertig war.
  final double spielzeit;

  /// Rechenzeit (Wanduhr) der Erkundung.
  final Duration rechenzeit;
  final List<Erkunder> bots;

  /// Keine Tür offen, kein Steckenbleiber, alle Bots stehen frei.
  bool get ohneBefund => nichtErreicht.isEmpty && steckenbleiber.isEmpty && bots.every((b) => b.frei);
}

/// Erkundet die Welt [welt] (wie von `baueWelt`) in Fallphase [phase] mit [bots] Bots.
/// Die Bots teilen sich alle offenen Türen: Jeder untätige Bot nimmt die nächste freie
/// Tür, läuft mit Kollision hin, geht hindurch und prüft die Ankunft. [seed] wählt die
/// Startmarken; gleicher Seed ergibt denselben Lauf.
ErkundungsBericht erkunde(Map<String, Bereich> welt, {int phase = 3, int bots = 4, required int seed}) {
  final sw = Stopwatch()..start();
  final navigation = Navigation(Welt(welt), phase: phase);

  final tueren = <ErkundungsTuer>[];
  final anDing = <Ding, ErkundungsTuer>{};
  for (final b in welt.values) {
    for (final d in b.dinge) {
      final l = d.legende;
      final zielId = l.ziel;
      final zielMarke = l.zielMarke;
      if (l.art != KachelArt.tuer || !Bereich.offen(l, phase)) continue;
      final nach = zielId == null ? null : welt[zielId];
      final kachel = (nach == null || zielMarke == null) ? null : nach.marken[zielMarke];
      final t = ErkundungsTuer(von: b, ding: d, nach: nach, nachKachel: kachel);
      tueren.add(t);
      anDing[d] = t;
    }
  }

  final zufall = Zufall(seed);
  final startMarken = [for (final b in welt.values) for (final m in b.marken.values) (b, m)];
  final botListe = <Erkunder>[];
  for (var i = 0; i < bots; i++) {
    final (b, (mx, mz)) = startMarken[zufall.ganz(startMarken.length)];
    botListe.add(Erkunder(name: 'Bot ${i + 1}', bereich: b, x: (mx + 0.5) * kKachel, z: (mz + 0.5) * kKachel));
  }

  final steckenbleiber = <Steckenbleiber>[];
  var zeit = 0.0;
  while (zeit < _kZeitGrenze) {
    var aktiv = false;
    for (final bot in botListe) {
      if (bot.untaetig && !bot.fertig) {
        final weg = _plane(bot, navigation, welt, anDing);
        if (weg == null) {
          bot.fertig = true;
        } else {
          weg.$1.zugewiesenAn = bot;
          bot.zielSetzen(weg.$1, weg.$2);
        }
      }
      if (!bot.untaetig) aktiv = true;
    }
    if (!aktiv) break;
    for (final bot in botListe) {
      final e = bot.schritt(kErkundungDt);
      if (e is TuerErreicht) {
        e.tuer
          ..stand = TuerStand.erreicht
          ..zugewiesenAn = null;
      } else if (e is Steckenbleiber) {
        steckenbleiber.add(e);
        if (e.tuer.stand != TuerStand.erreicht) e.tuer.stand = TuerStand.gescheitert;
        e.tuer.zugewiesenAn = null;
      }
    }
    zeit += kErkundungDt;
  }

  final nichtErreicht = <String>[];
  for (final t in tueren) {
    if (t.stand == TuerStand.erreicht) continue;
    final grund = switch (t.stand) {
      _ when t.nachPos == null => 'Zielbereich oder Zielmarke fehlt',
      TuerStand.gescheitert => 'Steckenbleiber',
      _ => 'keine Route gefunden',
    };
    nichtErreicht.add('${t.bezeichnung} → ${t.ding.legende.ziel ?? '-'}: $grund');
  }

  return ErkundungsBericht(
    phase: phase,
    seed: seed,
    tuerenGesamt: tueren.length,
    erreicht: tueren.where((t) => t.stand == TuerStand.erreicht).length,
    nichtErreicht: nichtErreicht,
    steckenbleiber: steckenbleiber,
    spielzeit: zeit,
    rechenzeit: sw.elapsed,
    bots: botListe,
  );
}

/// Plant den Weg eines untätigen Bots zur nächsten verfügbaren Tür (Breitensuche über
/// Kacheln und offene Türen). Liefert Endziel und Schritte, null ohne Route.
(ErkundungsTuer, List<Schritt>)? _plane(
  Erkunder bot,
  Navigation nav,
  Map<String, Bereich> welt,
  Map<Ding, ErkundungsTuer> anDing,
) {
  bool verfuegbar(ErkundungsTuer t) => t.stand == TuerStand.offen && t.zugewiesenAn == null && t.nachPos != null;

  final pfad = nav.weg(bot.ort, (o) => _tuerNeben(welt[o.$1]!, o.$2, o.$3, anDing, verfuegbar) != null,
      grenze: 100000000);
  if (pfad == null) return null;

  final letzter = pfad.last;
  final endziel = _tuerNeben(welt[letzter.$1]!, letzter.$2, letzter.$3, anDing, verfuegbar)!;
  final schritte = <Schritt>[];
  for (var i = 1; i < pfad.length; i++) {
    final vor = pfad[i - 1];
    final nach = pfad[i];
    final bereich = welt[nach.$1]!;
    if (vor.$1 == nach.$1) {
      schritte.add(GehSchritt(bereich, (nach.$2 + 0.5) * kKachel, (nach.$3 + 0.5) * kKachel));
    } else {
      final durch = _tuerNeben(
        welt[vor.$1]!,
        vor.$2,
        vor.$3,
        anDing,
        (t) => identical(t.nach, bereich) && t.nachKachel == (nach.$2, nach.$3),
      )!;
      schritte.add(DurchgangSchritt(durch));
    }
  }
  schritte.add(DurchgangSchritt(endziel));
  return (endziel, schritte);
}

/// Erste Tür (in Richtung O, W, S, N) direkt neben der Kachel (x, z), die [passt] erfüllt.
ErkundungsTuer? _tuerNeben(
  Bereich b,
  int x,
  int z,
  Map<Ding, ErkundungsTuer> anDing,
  bool Function(ErkundungsTuer t) passt,
) {
  for (final (dx, dz) in const [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
    final d = b.dingAn(x + dx, z + dz);
    final t = d == null ? null : anDing[d];
    if (t != null && passt(t)) return t;
  }
  return null;
}

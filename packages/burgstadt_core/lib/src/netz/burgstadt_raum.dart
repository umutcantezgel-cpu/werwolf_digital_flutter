/// Der Fall als Mehrspieler-Raum (maßgeblich auf dem Host). Setzt die Schnittstelle
/// `RaumSpiel` aus `room_host` um (gleiche Methoden; das Paket bleibt ohne Abhängigkeit).
///
/// Lobby: Der erste Teilnehmer ist Gastgeber und Detektiv (das Geburtstagskind); er legt
/// die Rollenzahl N = 4…20 fest und startet. Weitere Teilnehmer bekommen die Rollen
/// R01… in Kanon-Reihenfolge, Bots füllen bis N auf.
///
/// Spoilerschutz: Jeder bekommt nur Ereignisse, die ihn betreffen, und Hinweistexte nur
/// für Hinweise, die er kennt oder die in der gemeinsamen Fallakte liegen.
library;

import 'dart:math' as math;

import '../fall/fall_daten.dart';
import '../fall/fall_zustand.dart';
import '../fall/simulation.dart';
import '../welt/bereich.dart';

class BurgstadtRaum {
  final FallDaten daten;
  final Welt welt;
  final List<Map<String, dynamic>> bewohner, haeuser;
  final int seed;
  final double tempo;

  /// Sekunden, nach denen offene Rollen-Entscheidungen von Menschen ein Bot trifft.
  final double wahlFrist;

  BurgstadtRaum(this.daten, this.welt,
      {this.bewohner = const [], this.haeuser = const [], this.seed = 7, this.tempo = 65 / 480, this.wahlFrist = 90});

  static const maxTeilnehmer = 21;

  final List<String> reihenfolge = [];
  final Map<String, String> namen = {};
  final Map<String, String> rolleVon = {};
  final Set<String> online = {};
  final Map<String, List<Map<String, Object?>>> _postfach = {};

  /// Hinweise, deren Text der Spieler schon bekommen hat.
  final Map<String, Set<String>> _textGesendet = {};
  int n = 4;
  FallZustand? fall;
  Simulation? sim;
  double _lagerundeSeit = 0;

  bool get beendet => fall?.abschnitt == Abschnitt.ende;
  String? get gastgeber => reihenfolge.isEmpty ? null : reihenfolge.first;

  /// Spieler-ID der Rolle (null = Bot).
  String? spielerVon(String rolle) {
    for (final e in rolleVon.entries) {
      if (e.value == rolle) return e.key;
    }
    return null;
  }

  // ------------------------------------------------------------------ Lobby

  bool beitreten(String id, String name) {
    if (fall != null || reihenfolge.length >= maxTeilnehmer) return false;
    reihenfolge.add(id);
    namen[id] = name;
    _postfach[id] = [];
    return true;
  }

  void verlassen(String id) {
    if (fall != null) return; // in der Partie bleibt die Rolle (Bot übernimmt nicht automatisch)
    reihenfolge.remove(id);
    namen.remove(id);
    _postfach.remove(id);
  }

  void verbunden(String id, bool ja) {
    if (ja) {
      online.add(id);
      final f = fall;
      final r = rolleVon[id];
      // Nach (Wieder-)Verbinden: alle bekannten Hinweistexte auf einmal
      if (f != null && r != null) {
        final t = _texte(f, r);
        _postfach[id]!.add({'art': 'texte', 'texte': t});
        (_textGesendet[id] ??= {}).addAll(t.keys);
      }
    } else {
      online.remove(id);
    }
  }

  Map<String, String> _texte(FallZustand f, String r) => {
        for (final h in {...f.wissen[r] ?? const <String>{}, ...f.akte}) h: f.daten.hinweise[h]?.inhalt ?? '',
      };

  void _starte(int gewuenscht) {
    n = math.max(gewuenscht.clamp(4, 20), reihenfolge.length - 1).clamp(4, 20);
    final f = FallZustand(daten, n);
    final start = f.starte();
    final rollen = ['DET', ...f.rollen];
    for (var i = 0; i < reihenfolge.length && i < rollen.length; i++) {
      rolleVon[reihenfolge[i]] = rollen[i];
    }
    fall = f;
    sim = Simulation(welt, f,
        seed: seed, tempo: tempo, menschen: {...rolleVon.values}, bewohnerDaten: bewohner, haeuser: haeuser);
    _verteile(start);
    for (final id in reihenfolge) {
      if (online.contains(id)) verbunden(id, true);
    }
  }

  // ------------------------------------------------------------------ Nachrichten

  void nachricht(String id, Map<String, Object?> m) {
    final f = fall, s = sim;
    final art = m['art'] as String?;
    if (f == null || s == null) {
      if (art == 'start' && id == gastgeber) _starte((m['n'] as num?)?.toInt() ?? 4);
      return;
    }
    final r = rolleVon[id];
    if (r == null) return;
    final fig = s.figuren[r];
    switch (art) {
      case 'position':
        final b = m['bereich'] as String?;
        if (fig == null || b == null || !welt.bereiche.containsKey(b)) return;
        final x = (m['x'] as num).toDouble(), z = (m['z'] as num).toDouble();
        if (fig.bereich != b && r != FallZustand.detektiv) _verteile(f.betritt(r, b));
        fig
          ..bereich = b
          ..x = x
          ..z = z
          ..yaw = (m['yaw'] as num?)?.toDouble() ?? fig.yaw
          ..animation = m['animation'] as String? ?? 'stehen';
      case 'untersuche':
        _verteile(f.untersuche(r, m['station'] as String));
      case 'teile':
        _verteile(f.teile(r, m['an'] as String, m['hinweis'] as String));
      case 'verbinde':
        _verteile(f.verbinde(r, m['a'] as String, m['b'] as String));
      case 'verwische':
        _verteile(f.verwische(r, m['station'] as String));
      case 'gespraech':
        // Menschliche Rolle führt ihr Gespräch; wer in Hörweite steht, hört mit (IF-1)
        final zuhoerer = [
          for (final o in s.figuren.values)
            if (fig != null && o.id != r && f.wissen.containsKey(o.id) && o.bereich == fig.bereich &&
                math.sqrt(math.pow(o.x - fig.x, 2) + math.pow(o.z - fig.z, 2)) < Simulation.hoerweite)
              o.id,
        ];
        _verteile(f.fuehreGespraech(r, m['gespraech'] as String, zuhoerer: zuhoerer));
      case 'frage':
        final ziel = m['figur'] as String;
        if (s.bewohner.containsKey(ziel)) {
          _verteile([for (final e in s.bewohnerErzaehlt(ziel)) Ereignis(e.art, e.text, von: e.von, an: r, uhr: e.uhr)]);
        } else if (r == FallZustand.detektiv && spielerVon(ziel) == null) {
          _verteile(s.detektivFragt(ziel)); // Bot-Rolle: Alibi + was sie teilt
        } else if (r == FallZustand.detektiv) {
          // Menschliche Rolle: nur das öffentliche Alibi – teilen entscheidet der Mensch selbst
          final rolle = f.daten.rollen[ziel];
          if (rolle != null && rolle.behauptetesAlibi.isNotEmpty) {
            _verteile([Ereignis('aussage', '${rolle.name.split(' ').first}: ${rolle.behauptetesAlibi}', von: ziel, uhr: f.uhr)]);
          }
        }
        s.abholen(); // schon verteilt
      case 'wahl':
        final e = f.daten.rollenEntscheidungen[m['entscheidung']];
        if (e != null && e.rolle == r) _verteile(f.waehleRolle(e.id, (m['option'] as num).toInt()));
      case 'detektiv':
        if (r == FallZustand.detektiv) _verteile(f.waehleDetektiv(m['entscheidung'] as String, m['option'] as String));
      case 'weiter':
        if (r != FallZustand.detektiv) return;
        if (f.abschnitt == Abschnitt.lagerunde && f.rollenEntscheidungen().isEmpty) {
          _verteile(f.zurDetektivWahl());
        } else if (f.abschnitt == Abschnitt.detektivWahl) {
          _verteile(f.weiter());
        }
      case 'anklage':
        if (r == FallZustand.detektiv) _verteile(f.klageAn(m['rolle'] as String));
    }
  }

  // ------------------------------------------------------------------ Takt

  void tick(double dt) {
    final f = fall, s = sim;
    if (f == null || s == null) return;
    s.tick(dt);
    _verteile(s.abholen());
    if (f.abschnitt == Abschnitt.lagerunde) {
      _lagerundeSeit += dt;
      for (final e in f.rollenEntscheidungen()) {
        // Bots entscheiden sofort, Menschen haben [wahlFrist] Sekunden
        if (spielerVon(e.rolle) == null || _lagerundeSeit > wahlFrist) _verteile(f.waehleRolle(e.id, s.bots.rollenWahl(e)));
      }
    } else {
      _lagerundeSeit = 0;
    }
  }

  // ------------------------------------------------------------------ Verteilen

  /// Sieht Rolle [r] dieses Ereignis?
  static bool sichtbar(Ereignis e, String r) => switch (e.art) {
        'fund' || 'belauscht' => e.von == r,
        'teilen' || 'gespraech' => e.von == r || e.an == r,
        'sicht' || 'verwischt' => e.an == r,
        'erzaehler' => e.an == null ? r == FallZustand.detektiv : e.an == r,
        'akte' || 'phase' || 'meldekarte' || 'eingrenzung' || 'ende' || 'rolle' => true,
        _ => r == FallZustand.detektiv,
      };

  void _verteile(List<Ereignis> es) {
    if (es.isEmpty) return;
    for (final e in rolleVon.entries) {
      final post = _postfach[e.key]!;
      final gesendet = _textGesendet[e.key] ??= {};
      for (final x in es) {
        if (!sichtbar(x, e.value)) continue;
        post.add(x.zuJson());
        if (x.hinweis != null) gesendet.add(x.hinweis!);
      }
    }
    _texteNachliefern();
  }

  /// Wer einen Hinweis kennt (z. B. aus dem eigenen Gespräch) oder in der Akte sieht,
  /// ohne seinen Text bekommen zu haben, erhält ihn nach.
  void _texteNachliefern() {
    final f = fall;
    if (f == null) return;
    for (final e in rolleVon.entries) {
      final gesendet = _textGesendet[e.key] ??= {};
      final fehlt = {...f.wissen[e.value] ?? const <String>{}, ...f.akte}.difference(gesendet);
      if (fehlt.isEmpty) continue;
      _postfach[e.key]!.add({
        'art': 'texte',
        'texte': {for (final h in fehlt) h: f.daten.hinweise[h]?.inhalt ?? ''},
      });
      gesendet.addAll(fehlt);
    }
  }

  List<Map<String, Object?>> ereignisseFuer(String id) {
    final p = _postfach[id];
    if (p == null || p.isEmpty) return const [];
    final out = List<Map<String, Object?>>.of(p);
    p.clear();
    return out;
  }

  Map<String, Object?> zustandFuer(String id) {
    final f = fall, s = sim;
    final mitspieler = [
      for (final p in reihenfolge) {'id': p, 'name': namen[p], 'rolle': rolleVon[p]},
    ];
    if (f == null || s == null) {
      return {'lobby': true, 'ich': id, 'gastgeber': gastgeber, 'mitspieler': mitspieler};
    }
    final r = rolleVon[id];
    final ich = r == null ? null : s.figuren[r];
    return {
      'lobby': false,
      'ich': id,
      'rolle': r,
      'n': n,
      'phase': f.phase,
      'abschnitt': f.abschnitt.name,
      'uhr': f.uhr,
      'mitspieler': mitspieler,
      'wissen': r == null ? const [] : (f.wissen[r]!.toList()..sort()),
      'akte': f.akte.toList()..sort(),
      'faeden': [for (final x in f.faeden) [x.$1, x.$2]],
      // Für den Spiegel beim Gast: Detektiv-Wahlen sind am Tisch öffentlich, von den
      // Rollen-Entscheidungen nur, welche schon gefallen sind (nicht die gewählte Option)
      'detektivWahl': f.detektivWahl,
      'rollenEntschieden': f.rollenWahl.keys.toList()..sort(),
      'angeklagt': f.angeklagt,
      // Interessenfilter: nur Figuren im eigenen Bereich
      'figuren': [
        for (final o in s.figuren.values)
          if (ich != null && o.id != r && !o.verborgen && o.bereich == ich.bereich)
            {'id': o.id, 'bereich': o.bereich, 'x': o.x, 'z': o.z, 'yaw': o.yaw, 'animation': o.animation, 'blase': o.blasenZeit > 0 ? o.sprechblase : null},
      ],
      if (r != null && r != FallZustand.detektiv)
        'gespraeche': [for (final (g, ziel, _) in f.offeneGespraeche(r)) {'id': g.id, 'ziel': ziel}],
      if (r != null && f.abschnitt == Abschnitt.lagerunde)
        'entscheidungen': [
          for (final e in f.rollenEntscheidungen())
            if (e.rolle == r) {'id': e.id, 'lage': e.lage, 'optionen': [for (final o in e.optionen) o.text]},
        ],
      if (r == FallZustand.detektiv && f.abschnitt == Abschnitt.detektivWahl)
        'detektivEntscheidungen': [
          for (final d in f.detektivEntscheidungen()) {'id': d.id, 'frage': d.frage, 'optionen': d.optionen},
        ],
      if (r == FallZustand.detektiv && f.abschnitt == Abschnitt.eingrenzung) 'verdaechtige': f.verdaechtigenkreis,
      'ende': f.ende,
    };
  }
}

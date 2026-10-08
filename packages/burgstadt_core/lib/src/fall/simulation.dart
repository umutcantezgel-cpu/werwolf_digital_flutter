import 'dart:math' as math;

import '../welt/bereich.dart';
import '../welt/navigation.dart';
import '../zufall.dart';
import 'bots.dart';
import 'fall_zustand.dart';
import 'stadtleben.dart';

/// Eine Figur in der Welt (Rolle, Burgwart, Detektiv oder Stadtbewohner).
class Figur {
  final String id;

  /// Stadtbewohner (nicht Teil des Falls, folgt seinem Nachtplan).
  final bool bewohner;
  String bereich;
  double x, z, yaw;
  String animation = 'stehen';
  double animZeit = 0;
  final bool bot;

  // Bot-Plan
  List<Ort> pfad = [];
  String? auftrag; // z. B. 'gespraech:G1-07', 'station:BS-01', 'warten'
  double warten = 0;
  String? sprechblase;
  double blasenZeit = 0;

  Figur(this.id, this.bereich, this.x, this.z, {this.yaw = 0, this.bot = true, this.bewohner = false});

  /// Unsichtbar (z. B. Bewohner schläft im Haus ohne Innenraum).
  bool get verborgen => bereich.isEmpty;

  (int, int) get kachel => ((x / kKachel).floor(), (z / kKachel).floor());
}

/// Echtzeit-Simulation des Falls: Uhr, Figuren, Bot-Handlungen (Gespräche,
/// Stationen, Teilen), Hörweite des Detektivs. Maßgeblich auf dem Host.
class Simulation {
  final Welt welt;
  final FallZustand fall;
  final FallBots bots;
  final Navigation nav;
  final Zufall zufall;
  final Map<String, Figur> figuren = {};
  final List<Ereignis> neu = []; // seit dem letzten Abholen

  /// Spielminuten je Echtsekunde (Phase 1 = 65 Spielminuten).
  double tempo;

  /// Hörweite für Gespräche (m).
  static const hoerweite = 4.0;
  static const gehtempo = 1.25;

  /// Stadtbewohner nach ID (leer ohne generierte Oberstadt).
  final Map<String, Bewohner> bewohner = {};
  final Map<String, List<String>> _vorMarkenImViertel = {};

  Simulation(this.welt, this.fall,
      {int seed = 7,
      this.tempo = 65 / 480,
      Set<String> menschen = const {'DET'},
      List<Map<String, dynamic>> bewohnerDaten = const [],
      List<Map<String, dynamic>> haeuser = const []})
      : bots = FallBots(fall, seed: seed),
        nav = Navigation(welt),
        zufall = Zufall(seed * 31 + 5) {
    // Startplätze: alle im Gewölbe (Lagerunde-Aufstellung), Burgwart auf der Bank am Kamin
    final g = welt.bereiche['gewoelbe']!;
    final frei = <(int, int)>[];
    for (var z = 0; z < g.tiefe; z++) {
      for (var x = 0; x < g.breite; x++) {
        if (g.begehbar(x, z) && g.art(x, z) == KachelArt.boden) frei.add((x, z));
      }
    }
    final ids = ['BW', ...fall.rollen];
    for (var i = 0; i < ids.length; i++) {
      final (kx, kz) = frei[(i * 37 + 11) % frei.length];
      figuren[ids[i]] = Figur(ids[i], 'gewoelbe', (kx + 0.5) * kKachel, (kz + 0.5) * kKachel,
          yaw: zufall.kommazahl() * math.pi * 2, bot: !menschen.contains(ids[i]));
    }
    final (mx, mz) = g.markePos('m');
    figuren['DET'] = Figur('DET', 'gewoelbe', mx, mz, bot: !menschen.contains('DET'));
    _stadtlebenAnlegen(bewohnerDaten, haeuser);
  }

  // ---------------------------------------------------------------- Stadtleben

  void _stadtlebenAnlegen(List<Map<String, dynamic>> daten, List<Map<String, dynamic>> haeuser) {
    final stadt = welt.bereiche['stadt'];
    if (stadt == null || daten.isEmpty) return;
    for (final h in haeuser) {
      final id = h['id'] as String, v = h['viertel'] as String? ?? '';
      if (stadt.marken.containsKey('vor-$id')) _vorMarkenImViertel.putIfAbsent(v, () => []).add('vor-$id');
    }
    for (final j in daten) {
      final b = Bewohner.ausJson(j);
      if (!stadt.marken.containsKey('vor-${b.wohnhaus}')) continue;
      bewohner[b.id] = b;
      figuren[b.id] = Figur(b.id, '', 0, 0, bewohner: true);
    }
    for (final f in figuren.values.where((f) => f.bewohner)) {
      _bewohner(f, 0);
    }
  }

  /// Innenraum eines Hauses (über die gemeinsame Marke vor der Tür), sonst null.
  String? _innenraumVon(String hausId) {
    final stadt = welt.bereiche['stadt']!;
    final vor = stadt.marken['vor-$hausId'];
    if (vor == null) return null;
    for (final e in stadt.marken.entries) {
      if (e.key.startsWith('tuer-') && e.value == vor && welt.bereiche.containsKey(e.key.substring(5))) return e.key.substring(5);
    }
    return null;
  }

  int _hash(String s) => s.codeUnits.fold(17, (h, c) => (h * 31 + c) & 0x7FFFFFFF);

  void _platziere(Figur f, Bewohner b, NachtEintrag e, int index) {
    f.pfad = [];
    f.warten = 0;
    f.animation = 'stehen';
    final stadt = welt.bereiche['stadt']!;
    void verbergen() => f.bereich = '';
    if (e.zustand == 'schläft') return verbergen();
    if (e.wo == 'wohnhaus' || e.wo == 'arbeitshaus') {
      final innen = _innenraumVon(e.wo == 'wohnhaus' ? b.wohnhaus : b.arbeitshaus);
      final r = innen == null ? null : welt.bereiche[innen];
      if (r == null) return verbergen();
      final frei = <(int, int)>[
        for (var z = 0; z < r.tiefe; z++)
          for (var x = 0; x < r.breite; x++)
            if (r.art(x, z) == KachelArt.boden && r.frei((x + 0.5) * kKachel, (z + 0.5) * kKachel, r: 0.3)) (x, z),
      ];
      if (frei.isEmpty) return verbergen();
      final (x, z) = frei[_hash('${b.id}|$index') % frei.length];
      f
        ..bereich = innen!
        ..x = (x + 0.5) * kKachel
        ..z = (z + 0.5) * kKachel
        ..yaw = (_hash(b.id) % 628) / 100
        ..animation = e.zustand == 'arbeitet' ? 'untersuchen' : 'stehen';
      return;
    }
    // In der Haustür (Fenster) oder unterwegs in der Gasse: Start vor dem eigenen Haus
    final (mx, mz) = stadt.marken['vor-${b.wohnhaus}']!;
    f
      ..bereich = 'stadt'
      ..x = (mx + 0.5) * kKachel
      ..z = (mz + 0.5) * kKachel;
    // Blick von der Haustür weg auf die Gasse
    for (final (dx, dz) in const [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
      if (stadt.art(mx + dx, mz + dz) == KachelArt.tuer || stadt.zeichen(mx + dx, mz + dz) == 'D') {
        f.yaw = math.atan2(-dz.toDouble(), -dx.toDouble());
      }
    }
  }

  void _bewohner(Figur f, double dt) {
    final b = bewohner[f.id]!;
    f.animZeit += dt;
    final i = b.eintragUm(fall.uhr);
    final e = b.nacht[i];
    if (f.auftrag != 'plan:$i') {
      f.auftrag = 'plan:$i';
      _platziere(f, b, e, i);
    }
    if (!e.wo.startsWith('gasse:') || f.bereich != 'stadt') return;
    // Streifen durch das Viertel: von Haustür zu Haustür, kurz stehen bleiben
    if (f.pfad.isEmpty) {
      if (f.warten > 0) {
        f.warten -= dt;
        f.animation = 'stehen';
        return;
      }
      final marken = _vorMarkenImViertel[e.wo.substring(6)] ?? const [];
      if (marken.isEmpty) return;
      final stadt = welt.bereiche['stadt']!;
      final (zx, zz) = stadt.marken[zufall.waehle(marken)]!;
      f.pfad = nav.weg(('stadt', f.kachel.$1, f.kachel.$2), (o) => o.$1 == 'stadt' && o.$2 == zx && o.$3 == zz, grenze: 60000) ?? [];
      f.warten = 3 + zufall.kommazahl() * 6;
      if (f.pfad.isEmpty) return;
    }
    _folgePfad(f, dt);
  }

  /// Was ein Bewohner gerade tut (für das Ansprechen).
  List<Ereignis> bewohnerErzaehlt(String id) {
    final b = bewohner[id];
    if (b == null) return const [];
    final e = b.nacht[b.eintragUm(fall.uhr)];
    final out = [Ereignis('erzaehler', '${b.name}, ${b.beruf}. ${e.tut}', von: id, uhr: fall.uhr)];
    _melde(out);
    return out;
  }

  Figur get detektiv => figuren['DET']!;

  List<Ereignis> abholen() {
    final out = List<Ereignis>.of(neu);
    neu.clear();
    return out;
  }

  void _melde(List<Ereignis> e) => neu.addAll(e);

  /// Ein Zeitschritt (Echtsekunden).
  void tick(double dt) {
    nav.phase = fall.phase;
    if (fall.abschnitt == Abschnitt.ermittlung) {
      _melde(fall.zeitVergeht(dt * tempo));
    }
    for (final f in figuren.values) {
      if (f.blasenZeit > 0) f.blasenZeit -= dt;
      if (f.bewohner) {
        _bewohner(f, dt);
        continue;
      }
      if (!f.bot || f.id == 'BW') {
        f.animZeit += dt;
        continue;
      }
      if (fall.abschnitt == Abschnitt.ermittlung) _bot(f, dt);
    }
  }

  bool _imGespraech(Figur f) => f.auftrag != null && f.auftrag!.startsWith('spricht');

  void _bot(Figur f, double dt) {
    f.animZeit += dt;
    if (f.warten > 0) {
      f.warten -= dt;
      if (f.warten <= 0 && _imGespraech(f)) {
        f.auftrag = null;
        f.animation = 'stehen';
      }
      return;
    }
    // Neuen Auftrag wählen
    if (f.auftrag == null) {
      final offen = fall.offeneGespraeche(f.id);
      if (offen.isNotEmpty) {
        f.auftrag = 'gespraech:${offen.first.$1.id}:${offen.first.$2}';
      } else {
        final stationen = [
          for (final b in welt.bereiche.values)
            for (final d in b.dinge)
              if (d.legende.station != null && d.legende.station!.startsWith('BS')) (b.id, d.legende.station!),
        ];
        final s = zufall.waehle(stationen);
        f.auftrag = 'station:${s.$1}:${s.$2}';
      }
      f.pfad = [];
    }
    final teile = f.auftrag!.split(':');
    if (teile[0] == 'gespraech') {
      final ziel = figuren[teile[2]];
      if (ziel == null) {
        f.auftrag = null;
        return;
      }
      final abstand = _abstand(f, ziel);
      if (abstand != null && abstand < 1.4 && !_imGespraech(ziel)) {
        _sprich(f, ziel, teile[1]);
        return;
      }
      // Ziel ansteuern (Pfad alle paar Sekunden neu)
      if (f.pfad.isEmpty || zufall.chance(dt * 0.6)) {
        final zk = ziel.kachel;
        f.pfad = nav.weg((f.bereich, f.kachel.$1, f.kachel.$2),
                (o) => o.$1 == ziel.bereich && (o.$2 - zk.$1).abs() + (o.$3 - zk.$2).abs() <= 2) ??
            [];
        if (f.pfad.isEmpty) {
          f.auftrag = null; // unerreichbar → später erneut
          f.warten = 2;
        }
      }
    } else if (teile[0] == 'station') {
      final b = welt.bereiche[teile[1]]!;
      final d = b.dinge.firstWhere((d) => d.legende.station == teile[2]);
      if (Navigation.nebenDing(b, d, (f.bereich, f.kachel.$1, f.kachel.$2))) {
        _melde(fall.untersuche(f.id, teile[2]));
        f.animation = 'untersuchen';
        f.warten = 3;
        f.auftrag = 'spricht'; // kurz still stehen
        _melde(bots.teileNeues(f.id));
        return;
      }
      if (f.pfad.isEmpty) {
        f.pfad = nav.weg((f.bereich, f.kachel.$1, f.kachel.$2), (o) => Navigation.nebenDing(b, d, o)) ?? [];
        if (f.pfad.isEmpty) {
          f.auftrag = null;
          f.warten = 2;
          return;
        }
      }
    }
    _folgePfad(f, dt);
  }

  void _folgePfad(Figur f, double dt) {
    if (f.pfad.isEmpty) {
      f.animation = 'stehen';
      return;
    }
    // ersten Punkt überspringen, wenn erreicht
    while (f.pfad.isNotEmpty) {
      final p = f.pfad.first;
      if (p.$1 != f.bereich) {
        // Türsprung
        f.bereich = p.$1;
        f.x = (p.$2 + 0.5) * kKachel;
        f.z = (p.$3 + 0.5) * kKachel;
        f.pfad.removeAt(0);
        continue;
      }
      final tx = (p.$2 + 0.5) * kKachel, tz = (p.$3 + 0.5) * kKachel;
      final dx = tx - f.x, dz = tz - f.z;
      final d = math.sqrt(dx * dx + dz * dz);
      if (d < 0.05) {
        f.pfad.removeAt(0);
        continue;
      }
      final s = math.min(d, gehtempo * dt);
      f.x += dx / d * s;
      f.z += dz / d * s;
      f.yaw = math.atan2(dz, dx);
      f.animation = 'gehen';
      return;
    }
    f.animation = 'stehen';
  }

  double? _abstand(Figur a, Figur b) {
    if (a.bereich != b.bereich) return null;
    final dx = a.x - b.x, dz = a.z - b.z;
    return math.sqrt(dx * dx + dz * dz);
  }

  void _sprich(Figur von, Figur an, String gid) {
    final det = detektiv;
    final hoert = _abstand(von, det) != null && _abstand(von, det)! < hoerweite;
    final e = fall.fuehreGespraech(von.id, gid, zuhoerer: hoert ? const ['DET'] : const []);
    _melde(e);
    for (final f in [von, an]) {
      f.auftrag = 'spricht';
      f.warten = 5;
      f.animation = 'sprechen';
      f.pfad = [];
    }
    von.yaw = math.atan2(an.z - von.z, an.x - von.x);
    an.yaw = math.atan2(von.z - an.z, von.x - an.x);
    final g = e.where((x) => x.art == 'gespraech').firstOrNull;
    if (g != null) {
      final zeilen = g.text.split('\n');
      von.sprechblase = zeilen.first.replaceFirst(RegExp(r'^[^:]+: '), '');
      von.blasenZeit = 2.5;
      an.sprechblase = zeilen.length > 1 ? zeilen[1].replaceFirst(RegExp(r'^[^:]+: '), '') : null;
      an.blasenZeit = 5;
    }
    _melde(bots.teileNeues(von.id));
  }

  /// Der Detektiv spricht [rolle] an: öffentliches Alibi + was die Rolle teilt.
  /// Stadtbewohner erzählen nur, was sie gerade tun.
  List<Ereignis> detektivFragt(String rolle) {
    if (bewohner.containsKey(rolle)) return bewohnerErzaehlt(rolle);
    final out = <Ereignis>[];
    final r = fall.daten.rollen[rolle];
    if (r != null && r.behauptetesAlibi.isNotEmpty) {
      out.add(Ereignis('aussage', '${r.name.split(' ').first}: ${r.behauptetesAlibi}', von: rolle, uhr: fall.uhr));
    }
    out.addAll(bots.teileNeues(rolle, an: 'DET'));
    _melde(out);
    final f = figuren[rolle];
    if (f != null) {
      f.animation = 'sprechen';
      f.warten = 3;
      f.auftrag = 'spricht';
      f.yaw = math.atan2(detektiv.z - f.z, detektiv.x - f.x);
    }
    return out;
  }
}

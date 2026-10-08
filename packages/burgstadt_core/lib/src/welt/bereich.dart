/// Weltmodell: Bereiche (Innenräume, Hof, Gassen) als Kachelraster mit 0,5 m
/// Kantenlänge, gelesen aus Textkarten mit Legende (Format: FORMAT-BEREICHE.md).
library;

import 'dart:math' as math;

const double kKachel = 0.5;

enum KachelArt { leer, boden, wand, objekt, tuer, station }

/// Eintrag der Legende (ein Zeichen der Karte).
class Legende {
  final KachelArt art;
  final String name;

  /// Tür: Zielbereich und Zielmarke (Kleinbuchstabe) im Zielbereich.
  final String? ziel;
  final String? zielMarke;
  final bool verschlossen;

  /// Tür öffnet sich ab dieser Fallphase (z. B. Burgtor ab Phase 2, Kanon STADT-03).
  final int? offenAbPhase;

  /// Objekt: Form (z. B. tisch, fass, kamin, regal, truhe, brunnen, kasten) und Höhe in m.
  final String form;
  final double hoehe;
  final String? textur;

  /// Station: Kennung (z. B. `speisekammer`) – das Fallsystem ordnet Hinweise zu.
  final String? station;

  /// Lichtquelle an dieser Kachel: warm (Kerze, Glut) / kalt (Mond, Solar), Stärke, Reichweite (m).
  final double lichtWarm, lichtKalt, lichtWeite;

  const Legende(this.art, this.name,
      {this.ziel,
      this.zielMarke,
      this.verschlossen = false,
      this.offenAbPhase,
      this.form = '',
      this.hoehe = 1,
      this.textur,
      this.station,
      this.lichtWarm = 0,
      this.lichtKalt = 0,
      this.lichtWeite = 0});

  factory Legende.ausJson(Map<String, dynamic> j) => Legende(
        KachelArt.values.byName(j['art'] as String),
        j['name'] as String? ?? '',
        ziel: j['ziel'] as String?,
        zielMarke: j['zielMarke'] as String?,
        verschlossen: j['verschlossen'] as bool? ?? false,
        offenAbPhase: (j['offenAbPhase'] as num?)?.toInt(),
        form: j['form'] as String? ?? '',
        hoehe: (j['hoehe'] as num?)?.toDouble() ?? 1,
        textur: j['textur'] as String?,
        station: j['station'] as String?,
        lichtWarm: (j['lichtWarm'] as num?)?.toDouble() ?? 0,
        lichtKalt: (j['lichtKalt'] as num?)?.toDouble() ?? 0,
        lichtWeite: (j['lichtWeite'] as num?)?.toDouble() ?? 0,
      );
}

/// Ein zusammenhängendes Objekt/Tür/Station (alle gleichen Zeichen, die sich berühren).
class Ding {
  final String zeichen;
  final Legende legende;
  final int x0, z0, x1, z1; // Kachelgrenzen (inklusive)
  Ding(this.zeichen, this.legende, this.x0, this.z0, this.x1, this.z1);

  double get mitteX => (x0 + x1 + 1) / 2 * kKachel;
  double get mitteZ => (z0 + z1 + 1) / 2 * kKachel;
  double get breiteM => (x1 - x0 + 1) * kKachel;
  double get tiefeM => (z1 - z0 + 1) * kKachel;
}

/// Ein Bereich: Raster [breite]×[tiefe] Kacheln. Weltkoordinaten: x nach Osten
/// (Spalten), z nach Süden (Zeilen), Ursprung in der Nordwest-Ecke, Meter.
class Bereich {
  final String id;
  final String name;
  final bool innen;
  final double raumHoehe;
  final String wandTextur, bodenTextur, deckenTextur;
  final double grundWarm, grundKalt;
  final List<String> karte;
  final Map<String, Legende> legende;
  late final int breite = karte.fold(0, (m, z) => math.max(m, z.length));
  late final int tiefe = karte.length;
  final List<Ding> dinge = [];
  final Map<String, (int, int)> marken = {};

  /// Ist die Tür [l] in Fallphase [phase] offen?
  static bool offen(Legende l, int phase) =>
      l.art == KachelArt.tuer && (l.offenAbPhase != null ? phase >= l.offenAbPhase! : !l.verschlossen);

  Bereich({
    required this.id,
    required this.name,
    required this.innen,
    this.raumHoehe = 3,
    this.wandTextur = 'burgBruchstein',
    this.bodenTextur = 'schieferPlatten',
    this.deckenTextur = 'gewoelbeDecke',
    this.grundWarm = 0,
    this.grundKalt = 0.1,
    required this.karte,
    required this.legende,
    Map<String, (int, int)> namensMarken = const {},
  }) {
    _finde();
    marken.addAll(namensMarken);
  }

  factory Bereich.ausJson(Map<String, dynamic> j) => Bereich(
        id: j['id'] as String,
        name: j['name'] as String,
        innen: j['innen'] as bool? ?? true,
        raumHoehe: (j['raumHoehe'] as num?)?.toDouble() ?? 3,
        wandTextur: j['wandTextur'] as String? ?? 'burgBruchstein',
        bodenTextur: j['bodenTextur'] as String? ?? 'schieferPlatten',
        deckenTextur: j['deckenTextur'] as String? ?? 'gewoelbeDecke',
        grundWarm: (j['grundWarm'] as num?)?.toDouble() ?? 0,
        grundKalt: (j['grundKalt'] as num?)?.toDouble() ?? 0.1,
        karte: [for (final z in j['karte'] as List) z as String],
        legende: {
          for (final e in (j['legende'] as Map).entries) e.key as String: Legende.ausJson(e.value as Map<String, dynamic>),
        },
        namensMarken: {
          for (final e in ((j['marken'] as Map?) ?? const {}).entries)
            e.key as String: (((e.value as List)[0] as num).toInt(), ((e.value as List)[1] as num).toInt()),
        },
      );

  String zeichen(int x, int z) {
    if (z < 0 || z >= tiefe || x < 0) return ' ';
    final zeile = karte[z];
    return x < zeile.length ? zeile[x] : ' ';
  }

  KachelArt art(int x, int z) {
    final c = zeichen(x, z);
    if (c == ' ') return KachelArt.leer;
    if (c == '#') return KachelArt.wand;
    if (c == '.' || _istMarke(c)) return KachelArt.boden;
    return legende[c]?.art ?? KachelArt.boden;
  }

  static bool _istMarke(String c) => c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A;

  /// Begehbar? Boden, Marken, offene Türen und Stationen (Stationen liegen auf dem Boden).
  bool begehbar(int x, int z) {
    final a = art(x, z);
    if (a == KachelArt.boden || a == KachelArt.station) return true;
    return false;
  }

  /// Kreis (Radius r) an Weltpunkt frei? (Spieler/Figuren)
  bool frei(double wx, double wz, {double r = 0.22}) {
    final x0 = ((wx - r) / kKachel).floor(), x1 = ((wx + r) / kKachel).floor();
    final z0 = ((wz - r) / kKachel).floor(), z1 = ((wz + r) / kKachel).floor();
    for (var z = z0; z <= z1; z++) {
      for (var x = x0; x <= x1; x++) {
        if (begehbar(x, z)) continue;
        // Abstand Kreis–Kachel
        final cx = wx.clamp(x * kKachel, (x + 1) * kKachel), cz = wz.clamp(z * kKachel, (z + 1) * kKachel);
        final dx = wx - cx, dz = wz - cz;
        if (dx * dx + dz * dz < r * r) return false;
      }
    }
    return true;
  }

  /// Ding an Kachel (oder null).
  Ding? dingAn(int x, int z) {
    for (final d in dinge) {
      if (x >= d.x0 && x <= d.x1 && z >= d.z0 && z <= d.z1) return d;
    }
    return null;
  }

  /// Mitte einer Marke in Metern.
  (double, double) markePos(String m) {
    final p = marken[m];
    if (p == null) throw ArgumentError('Marke „$m“ fehlt in $id');
    return ((p.$1 + 0.5) * kKachel, (p.$2 + 0.5) * kKachel);
  }

  void _finde() {
    final gesehen = <int>{};
    for (var z = 0; z < tiefe; z++) {
      for (var x = 0; x < breite; x++) {
        final c = zeichen(x, z);
        if (_istMarke(c)) {
          marken[c] = (x, z);
          continue;
        }
        final l = legende[c];
        if (l == null || gesehen.contains(z * breite + x)) continue;
        // zusammenhängendes Rechteck gleicher Zeichen
        var x1 = x, z1 = z;
        while (zeichen(x1 + 1, z) == c) {
          x1++;
        }
        while (true) {
          var ok = true;
          for (var xx = x; xx <= x1; xx++) {
            if (zeichen(xx, z1 + 1) != c) ok = false;
          }
          if (!ok) break;
          z1++;
        }
        for (var zz = z; zz <= z1; zz++) {
          for (var xx = x; xx <= x1; xx++) {
            gesehen.add(zz * breite + xx);
          }
        }
        dinge.add(Ding(c, l, x, z, x1, z1));
      }
    }
  }

  /// Prüft die Karte; leere Liste = in Ordnung.
  List<String> pruefe(Map<String, Bereich> alle) {
    final out = <String>[];
    for (var z = 0; z < tiefe; z++) {
      for (var x = 0; x < karte[z].length; x++) {
        final c = karte[z][x];
        if (c == '#' || c == '.' || c == ' ' || _istMarke(c)) continue;
        if (!legende.containsKey(c)) out.add('$id: Zeichen „$c“ bei $x/$z ohne Legende');
      }
    }
    for (final d in dinge) {
      final l = d.legende;
      if (l.art == KachelArt.tuer) {
        final ziel = alle[l.ziel];
        if (ziel == null) {
          out.add('$id: Tür „${l.name}“ zielt auf unbekannten Bereich ${l.ziel}');
        } else if (!ziel.marken.containsKey(l.zielMarke)) {
          out.add('$id: Tür „${l.name}“: Marke ${l.zielMarke} fehlt in ${l.ziel}');
        }
      }
    }
    return out;
  }
}

/// Die ganze Welt: alle Bereiche.
class Welt {
  final Map<String, Bereich> bereiche;
  Welt(this.bereiche);

  List<String> pruefe() => [for (final b in bereiche.values) ...b.pruefe(bereiche)];
}

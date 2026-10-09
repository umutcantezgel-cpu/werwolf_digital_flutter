import '../scenario/catalog.dart';
import '../scenario/grid.dart';
import '../scenario/scenario_def.dart';
import '../util/geom.dart';
import '../util/ltext.dart';
import 'zeit.dart';

/// Raumkanon des Partymodus (`raeume.json`): Räume, Türen, Einrichtung,
/// Standorte, Lichtquellen, Luftzug und Geräuschwege.
///
/// Der Graph erzeugt daraus ein Kachelraster ([karte], [raster]), auf dem
/// Weglängen und Sichtlinien berechnet werden. Dieselbe Karte nutzt später
/// der 2.5D-Renderer.
class RaumGraph {
  final Map<String, Raum> raeume;
  final Map<String, Tuer> tueren;
  final Map<String, Einrichtung> einrichtung;
  final Map<String, Ort> orte;
  final Map<String, Lichtquelle> lichtquellen;
  final List<Luftzug> luftzug;
  final Set<(String, String)> nachbarn;
  final Set<(String, String)> geschlosseneNachbarn;
  final int breite;
  final int hoehe;

  late final MapDef karte = _baueKarte();
  late final TileGrid raster = TileGrid(karte);

  RaumGraph._({
    required this.raeume,
    required this.tueren,
    required this.einrichtung,
    required this.orte,
    required this.lichtquellen,
    required this.luftzug,
    required this.nachbarn,
    required this.geschlosseneNachbarn,
    required this.breite,
    required this.hoehe,
  });

  factory RaumGraph.fromJson(Map<String, Object?> j) {
    final raster = j['raster'] as Map;
    Set<(String, String)> paare(Object? l) => {
          for (final p in (l as List? ?? const [])) _paar((p as List)[0] as String, p[1] as String),
        };
    final g = j['geraeusch'] as Map? ?? const {};
    return RaumGraph._(
      raeume: {for (final r in (j['rooms'] as List).map((e) => Raum.fromJson(e as Map))) r.id: r},
      tueren: {for (final t in (j['tueren'] as List).map((e) => Tuer.fromJson(e as Map))) t.id: t},
      einrichtung: {for (final e in (j['einrichtung'] as List? ?? const []).map((e) => Einrichtung.fromJson(e as Map))) e.id: e},
      orte: {for (final o in (j['orte'] as List).map((e) => Ort.fromJson(e as Map))) o.id: o},
      lichtquellen: {
        for (final l in (j['lichtquellen'] as List? ?? const []).map((e) => Lichtquelle.fromJson(e as Map))) l.id: l,
      },
      luftzug: [for (final l in (j['luftzug'] as List? ?? const [])) Luftzug.fromJson(l as Map)],
      nachbarn: paare(g['nachbarn']),
      geschlosseneNachbarn: paare(g['geschlossen']),
      breite: (raster['breite'] as num).toInt(),
      hoehe: (raster['hoehe'] as num).toInt(),
    );
  }

  static (String, String) _paar(String a, String b) => a.compareTo(b) <= 0 ? (a, b) : (b, a);

  Raum? raumAn(double x, double y) {
    final tx = x.floor(), ty = y.floor();
    for (final r in raeume.values) {
      if (tx >= r.x && ty >= r.y && tx < r.x + r.b && ty < r.y + r.l) return r;
    }
    return null;
  }

  /// Hörbarkeit zwischen zwei Räumen: 0 = gleicher Raum, 1 = Nachbar über offene
  /// Tür, sonst 2 (zwei Räume weiter oder hinter geschlossener Tür).
  int hoerAbstand(String a, String b) {
    if (a == b) return 0;
    final p = _paar(a, b);
    if (nachbarn.contains(p) && !geschlosseneNachbarn.contains(p)) return 1;
    return 2;
  }

  /// Kürzeste begehbare Weglänge in Metern zwischen zwei Standorten
  /// (A* über das Raster, Zusatzwege wie die Turmtreppe eingerechnet).
  /// `null`, wenn kein Weg existiert.
  double? weg(String vonOrt, String nachOrt) {
    final a = orte[vonOrt], b = orte[nachOrt];
    if (a == null || b == null) return null;
    if (a.id == b.id) return 0;
    final zusatz = a.zusatzweg + b.zusatzweg;
    final start = Pt(a.x.floor(), a.y.floor()), ziel = Pt(b.x.floor(), b.y.floor());
    if (start == ziel) return zusatz;
    final pfad = raster.findPath(start, ziel);
    if (pfad == null) return null;
    var laenge = 0.0;
    var px = a.x, py = a.y;
    for (var i = 0; i < pfad.length; i++) {
      final last = i == pfad.length - 1;
      final nx = last ? b.x : pfad[i].x + 0.5, ny = last ? b.y : pfad[i].y + 0.5;
      laenge += dist(px, py, nx, ny);
      px = nx;
      py = ny;
    }
    return laenge + zusatz;
  }

  /// Freie Sichtlinie zwischen zwei Standorten (Wände und Türkanten blockieren).
  bool sichtlinie(String vonOrt, String nachOrt) {
    final a = orte[vonOrt], b = orte[nachOrt];
    if (a == null || b == null) return false;
    return raster.lineOfSight(a.x, a.y, b.x, b.y);
  }

  /// Lichtquellen, die zur Zeit [t] brennen und einen Standort [ort] im Radius
  /// erreichen (nur ortsfeste Quellen; getragene Lichter prüft die Tatmatrix).
  List<Lichtquelle> lichtAm(String ort, Uhrzeit t) {
    final o = orte[ort];
    if (o == null) return const [];
    final out = <Lichtquelle>[];
    for (final l in lichtquellen.values) {
      if (!l.brennt(t)) continue;
      if (l.raeume.contains(o.raum)) {
        out.add(l);
        continue;
      }
      final lo = l.ort == null ? null : orte[l.ort];
      if (lo == null) continue;
      if (dist(lo.x, lo.y, o.x, o.y) <= l.radius && raster.lineOfSight(lo.x, lo.y, o.x, o.y)) out.add(l);
    }
    return out;
  }

  MapDef _baueKarte() {
    final zeilen = List.generate(hoehe, (_) => List.filled(breite, TileChar.void_));
    for (final r in raeume.values) {
      for (var y = r.y; y < r.y + r.l; y++) {
        for (var x = r.x; x < r.x + r.b; x++) {
          zeilen[y][x] = TileChar.floor;
        }
      }
    }
    // Wände: jede Leere, die an Boden grenzt (auch diagonal).
    for (var y = 0; y < hoehe; y++) {
      for (var x = 0; x < breite; x++) {
        if (zeilen[y][x] != TileChar.void_) continue;
        var grenzt = false;
        for (var dy = -1; dy <= 1 && !grenzt; dy++) {
          for (var dx = -1; dx <= 1; dx++) {
            final nx = x + dx, ny = y + dy;
            if (nx < 0 || ny < 0 || nx >= breite || ny >= hoehe) continue;
            if (zeilen[ny][nx] == TileChar.floor) {
              grenzt = true;
              break;
            }
          }
        }
        if (grenzt) zeilen[y][x] = TileChar.wall;
      }
    }
    for (final t in tueren.values) {
      for (final k in t.kacheln) {
        zeilen[k.y][k.x] = t.verschlossen ? TileChar.lockedDoor : TileChar.door;
      }
    }
    return MapDef(
      rows: [for (final z in zeilen) z.join()],
      rooms: [
        for (final r in raeume.values)
          RoomDef(
            id: r.id,
            name: LText({'de': r.anzeigename}),
            x: r.x,
            y: r.y,
            w: r.b,
            h: r.l,
            floor: r.boden,
            lit: false,
            outdoor: false,
          ),
      ],
      props: [
        for (final e in einrichtung.values)
          if (e.blockiert) PropDef(type: propCatalog.containsKey(e.typ) ? e.typ : 'crate', x: e.x, y: e.y),
      ],
      spawn: const [],
      councilRoom: raeume.keys.first,
    );
  }
}

class Raum {
  final String id;
  final String name;
  final String anzeigename;
  final int x, y, b, l;
  final String boden;
  final List<String> features;
  final String beschreibung;

  Raum({
    required this.id,
    required this.name,
    required this.anzeigename,
    required this.x,
    required this.y,
    required this.b,
    required this.l,
    required this.boden,
    required this.features,
    required this.beschreibung,
  });

  factory Raum.fromJson(Map j) {
    final r = j['rechteck'] as Map;
    return Raum(
      id: j['id'] as String,
      name: j['name'] as String,
      anzeigename: j['anzeigename'] as String,
      x: (r['x'] as num).toInt(),
      y: (r['y'] as num).toInt(),
      b: (r['b'] as num).toInt(),
      l: (r['l'] as num).toInt(),
      boden: j['boden'] as String,
      features: (j['features'] as List).cast<String>(),
      beschreibung: j['beschreibung'] as String,
    );
  }
}

class Tuer {
  final String id;
  final String name;
  final String von;
  final String nach;
  final List<Pt> kacheln;
  final String art;
  final String zustand;
  final bool quietscht;
  final String? schluessel;

  Tuer({
    required this.id,
    required this.name,
    required this.von,
    required this.nach,
    required this.kacheln,
    required this.art,
    required this.zustand,
    required this.quietscht,
    required this.schluessel,
  });

  bool get verschlossen => zustand.startsWith('verschlossen');

  factory Tuer.fromJson(Map j) => Tuer(
        id: j['id'] as String,
        name: j['name'] as String,
        von: j['von'] as String,
        nach: j['nach'] as String,
        kacheln: [for (final k in j['kacheln'] as List) Pt.fromJson(k)],
        art: j['art'] as String,
        zustand: j['zustand'] as String,
        quietscht: j['quietscht'] as bool,
        schluessel: j['schluessel'] as String?,
      );
}

class Einrichtung {
  final String id;
  final String name;
  final String typ;
  final int x, y;
  final bool blockiert;

  Einrichtung({required this.id, required this.name, required this.typ, required this.x, required this.y, required this.blockiert});

  factory Einrichtung.fromJson(Map j) => Einrichtung(
        id: j['id'] as String,
        name: j['name'] as String,
        typ: j['typ'] as String,
        x: (j['x'] as num).toInt(),
        y: (j['y'] as num).toInt(),
        blockiert: j['blockiert'] as bool,
      );
}

/// Ein Standort, an dem eine Person stehen kann (begehbare Kachel).
class Ort {
  final String id;
  final String raum;
  final double x, y;
  final String name;

  /// Zusätzlicher Weg in Metern, der nicht auf der Karte liegt (z. B. Turmtreppe zum WC).
  final double zusatzweg;

  Ort({required this.id, required this.raum, required this.x, required this.y, required this.name, this.zusatzweg = 0});

  factory Ort.fromJson(Map j) => Ort(
        id: j['id'] as String,
        raum: j['raum'] as String,
        x: (j['x'] as num).toDouble(),
        y: (j['y'] as num).toDouble(),
        name: j['name'] as String,
        zusatzweg: (j['zusatzweg'] as num?)?.toDouble() ?? 0,
      );
}

class Lichtquelle {
  final String id;
  final String art;
  final String name;
  final List<String> raeume;
  final String? ort;
  final String? traeger;
  final String? farbe;
  final double radius;
  final double flackern;
  final List<Zeitfenster> an;

  Lichtquelle({
    required this.id,
    required this.art,
    required this.name,
    required this.raeume,
    required this.ort,
    required this.traeger,
    required this.farbe,
    required this.radius,
    required this.flackern,
    required this.an,
  });

  /// Brennt die Quelle zur Zeit [t]? Getragene Quellen ohne Zeitfenster (Maske) leuchten immer.
  bool brennt(Uhrzeit t) => an.isEmpty ? traeger != null : an.any((f) => f.enthaelt(t));

  factory Lichtquelle.fromJson(Map j) => Lichtquelle(
        id: j['id'] as String,
        art: j['art'] as String,
        name: j['name'] as String,
        raeume: (j['raeume'] as List? ?? const []).cast<String>(),
        ort: j['ort'] as String?,
        traeger: j['traeger'] as String?,
        farbe: j['farbe'] as String?,
        radius: (j['radius'] as num?)?.toDouble() ?? 0,
        flackern: (j['flackern'] as num?)?.toDouble() ?? 0,
        an: [for (final f in (j['an'] as List? ?? const [])) Zeitfenster.parse(f as List)],
      );
}

class Luftzug {
  final Uhrzeit ab;
  final List<String> weg;
  final String grund;

  Luftzug({required this.ab, required this.weg, required this.grund});

  /// Trägt der Luftzug Gerüche von Raum [von] zu Raum [nach]?
  bool traegt(String von, String nach, Uhrzeit t) {
    if (t < ab) return false;
    final i = weg.indexOf(von), k = weg.indexOf(nach);
    return i >= 0 && k >= 0 && k >= i;
  }

  factory Luftzug.fromJson(Map j) =>
      Luftzug(ab: Uhrzeit.parse(j['ab'] as String), weg: (j['weg'] as List).cast<String>(), grund: j['grund'] as String);
}

/// Hilfsfunktion: Mindestdauer in Sekunden für einen Weg der Länge [meter].
int mindestSekunden(double meter, double geschwindigkeit) => (meter / geschwindigkeit).ceil();

/// Grenzgeschwindigkeiten (m/s) laut Master-Prompt 7.4.
abstract final class Tempo {
  static const dunkel = 1.0;
  static const hell = 1.5;
  static const rennen = 2.5;
}

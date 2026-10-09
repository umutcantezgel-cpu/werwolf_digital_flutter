import 'dart:math' as math;

import 'blockkoerper.dart';
import 'material.dart';

/// Rezept (6. Begriffe, 7.2): Bauanleitung als Daten, aus der ein Modell entsteht. Maße in Metern, Achsen
/// x Ost, y Süd, z oben; Ursprung = Ecke des Körpers. JSON-taugliche Struktur (nur Map/List/num/String):
///
/// ```
/// { "blockgroesse": 0.01, "groesse": [1.6, 0.8, 0.78],
///   "farben": { "eiche": {"material": 3}, "dunkel": {"material": 3, "farbe": "#5A3D25"} },
///   "schritte": [
///     {"art": "quader",   "von": [x,y,z], "bis": [x,y,z], "farbe": "eiche"},
///     {"art": "kapsel",   "a": [x,y,z], "b": [x,y,z], "r": 0.05, "farbe": "eiche"},
///     {"art": "kugel",    "m": [x,y,z], "r": 0.1, "farbe": "eiche"},
///     {"art": "zylinder", "m": [x,y], "z": [z0,z1], "r": 0.03, "farbe": "eiche"},
///     {"art": "fugen",    "von": [..], "bis": [..], "raster": [dx, dz], "versatz": dx2, "farbe": "moertel", "tiefe": 1},
///     {"art": "setze",    "bloecke": [[i,j,k], …], "farbe": "dunkel"}   // Feinschliff von Hand
///   ] }
/// ```
/// `"farbe": null` (oder fehlend bei Formen) leert die Form. Schritte wirken in Reihenfolge; Feinschliff wird
/// als „setze“-Schritt gespeichert, damit Rezept und Ergebnis zusammenpassen (7.6).
class Rezept {
  Rezept(this.daten);

  final Map<String, Object?> daten;

  double get blockgroesse => (daten['blockgroesse'] as num).toDouble();

  /// Baut den Blockkörper. [blockgroesse] überschreibt die Blockgröße des Rezepts (Geräteklasse).
  Blockkoerper baue({double? blockgroesse}) {
    final s = blockgroesse ?? this.blockgroesse;
    final g = (daten['groesse'] as List).map((v) => (v as num).toDouble()).toList();
    final k = Blockkoerper(blockgroesse: s, breite: math.max(1, (g[0] / s).round()), tiefe: math.max(1, (g[1] / s).round()), hoehe: math.max(1, (g[2] / s).round()));
    final farben = <String, int>{};
    ((daten['farben'] as Map?) ?? const {}).forEach((name, e) {
      final m = e as Map;
      final mat = (m['material'] as num).toInt();
      final hex = m['farbe'] as String?;
      final eintrag = hex == null ? Farbeintrag.material(mat) : Farbeintrag(mat, int.parse(hex.substring(1), radix: 16));
      farben[name as String] = k.eintrag(eintrag);
    });
    int wert(Map s) {
      final f = s['farbe'];
      if (f == null) return 0;
      final w = farben[f];
      if (w == null) throw FormatException('unbekannte Farbe „$f“ im Rezept');
      return w;
    }

    List<double> v(Object? o) => (o as List).map((e) => (e as num).toDouble()).toList();
    int b(double m) => (m / s).round();
    for (final schritt in (daten['schritte'] as List)) {
      final st = schritt as Map;
      final w = wert(st);
      switch (st['art']) {
        case 'quader':
          final von = v(st['von']), bis = v(st['bis']);
          k.fuelle(b(von[0]), b(von[1]), b(von[2]), b(bis[0]), b(bis[1]), b(bis[2]), w);
        case 'kapsel':
          _kapsel(k, v(st['a']), v(st['b']), (st['r'] as num).toDouble(), w);
        case 'kugel':
          final m = v(st['m']);
          _kapsel(k, m, m, (st['r'] as num).toDouble(), w);
        case 'zylinder':
          _zylinder(k, v(st['m']), v(st['z']), (st['r'] as num).toDouble(), w);
        case 'fugen':
          _fugen(k, v(st['von']), v(st['bis']), v(st['raster']), ((st['versatz'] ?? 0) as num).toDouble(), ((st['tiefe'] ?? 1) as num).toInt(), w);
        case 'setze':
          for (final p in (st['bloecke'] as List)) {
            final q = (p as List).map((e) => (e as num).toInt()).toList();
            k.setze(q[0], q[1], q[2], w);
          }
        default:
          throw FormatException('unbekannte Schrittart „${st['art']}“');
      }
    }
    return k;
  }

  static void _kapsel(Blockkoerper k, List<double> a, List<double> b, double r, int w) {
    final s = k.blockgroesse;
    final x0 = ((math.min(a[0], b[0]) - r) / s).floor(), x1 = ((math.max(a[0], b[0]) + r) / s).ceil();
    final y0 = ((math.min(a[1], b[1]) - r) / s).floor(), y1 = ((math.max(a[1], b[1]) + r) / s).ceil();
    final z0 = ((math.min(a[2], b[2]) - r) / s).floor(), z1 = ((math.max(a[2], b[2]) + r) / s).ceil();
    final dx = b[0] - a[0], dy = b[1] - a[1], dz = b[2] - a[2], ll = dx * dx + dy * dy + dz * dz;
    for (var z = z0; z <= z1; z++) {
      for (var y = y0; y <= y1; y++) {
        for (var x = x0; x <= x1; x++) {
          final px = (x + 0.5) * s - a[0], py = (y + 0.5) * s - a[1], pz = (z + 0.5) * s - a[2];
          final t = ll == 0 ? 0.0 : ((px * dx + py * dy + pz * dz) / ll).clamp(0.0, 1.0);
          final qx = px - dx * t, qy = py - dy * t, qz = pz - dz * t;
          if (qx * qx + qy * qy + qz * qz <= r * r) k.setze(x, y, z, w);
        }
      }
    }
  }

  static void _zylinder(Blockkoerper k, List<double> m, List<double> zz, double r, int w) {
    final s = k.blockgroesse;
    for (var z = (zz[0] / s).round(); z < (zz[1] / s).round(); z++) {
      for (var y = ((m[1] - r) / s).floor(); y <= ((m[1] + r) / s).ceil(); y++) {
        for (var x = ((m[0] - r) / s).floor(); x <= ((m[0] + r) / s).ceil(); x++) {
          final dx = (x + 0.5) * s - m[0], dy = (y + 0.5) * s - m[1];
          if (dx * dx + dy * dy <= r * r) k.setze(x, y, z, w);
        }
      }
    }
  }

  /// Mauerfugen: in der Fläche von–bis (eine Achse mit Dicke 0 = Sichtseite) ein Raster aus Lagen
  /// ([raster] = Steinlänge, Lagenhöhe) mit Halbversatz [versatz] je zweiter Lage; Fugen [tiefe] Blöcke tief.
  static void _fugen(Blockkoerper k, List<double> von, List<double> bis, List<double> raster, double versatz, int tiefe, int w) {
    final s = k.blockgroesse;
    final langX = (bis[0] - von[0]).abs() >= (bis[1] - von[1]).abs();
    final a0 = ((langX ? von[0] : von[1]) / s).round(), a1 = ((langX ? bis[0] : bis[1]) / s).round();
    final z0 = (von[2] / s).round(), z1 = (bis[2] / s).round();
    final quer = ((langX ? von[1] : von[0]) / s).round();
    final laenge = math.max(2, (raster[0] / s).round()), lage = math.max(2, (raster[1] / s).round()), halb = (versatz / s).round();
    for (var z = z0; z < z1; z++) {
      final lagenNr = (z - z0) ~/ lage;
      final fugeWaag = (z - z0) % lage == 0;
      for (var a = a0; a < a1; a++) {
        final fugeSenk = (a - a0 + (lagenNr.isOdd ? halb : 0)) % laenge == 0;
        if (!fugeWaag && !fugeSenk) continue;
        for (var t = 0; t < tiefe; t++) {
          final q = quer - t; // in den Körper hinein (Sichtseite = größte Koordinate)
          if (langX) {
            k.setze(a, q, z, w);
          } else {
            k.setze(q, a, z, w);
          }
        }
      }
    }
  }
}

/// Materialkennung nach Name (für Rezepte, die Namen statt Zahlen nutzen).
int materialNachName(String name) {
  for (final m in kMaterialien) {
    if (m.name.toLowerCase() == name.toLowerCase()) return m.id;
  }
  throw ArgumentError.value(name, 'name', 'unbekanntes Material');
}

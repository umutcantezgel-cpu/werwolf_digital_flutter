import 'dart:collection';

import 'bereich.dart';

/// Ein Wegpunkt: Bereich + Kachel.
typedef Ort = (String bereich, int x, int z);

/// Wegsuche über Kacheln (4er-Nachbarschaft) und offene Türen zwischen Bereichen.
class Navigation {
  final Welt welt;
  Navigation(this.welt);

  /// Kürzester Weg von [start] zu einer Kachel, für die [ziel] wahr ist (Breitensuche).
  /// Türübergänge springen auf die Zielmarke. Liefert null, wenn unerreichbar.
  List<Ort>? weg(Ort start, bool Function(Ort o) ziel, {int grenze = 20000}) {
    final vor = <Ort, Ort?>{start: null};
    final q = Queue<Ort>()..add(start);
    var n = 0;
    while (q.isNotEmpty && n++ < grenze) {
      final o = q.removeFirst();
      if (ziel(o)) {
        final pfad = <Ort>[];
        Ort? k = o;
        while (k != null) {
          pfad.add(k);
          k = vor[k];
        }
        return pfad.reversed.toList();
      }
      final b = welt.bereiche[o.$1]!;
      for (final (dx, dz) in const [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
        final nx = o.$2 + dx, nz = o.$3 + dz;
        Ort? nach;
        if (b.begehbar(nx, nz)) {
          nach = (o.$1, nx, nz);
        } else {
          final d = b.dingAn(nx, nz);
          final l = d?.legende;
          if (l != null && l.art == KachelArt.tuer && !l.verschlossen) {
            final zb = welt.bereiche[l.ziel];
            final m = zb?.marken[l.zielMarke];
            if (m != null) nach = (zb!.id, m.$1, m.$2);
          }
        }
        if (nach != null && !vor.containsKey(nach)) {
          vor[nach] = o;
          q.add(nach);
        }
      }
    }
    return null;
  }

  /// Kachel neben einer Station/einem Ding (begehbar), für Annäherung.
  static bool nebenDing(Bereich b, Ding d, Ort o) {
    if (o.$1 != b.id) return false;
    final x = o.$2, z = o.$3;
    if (d.legende.art == KachelArt.station && x >= d.x0 && x <= d.x1 && z >= d.z0 && z <= d.z1) return true;
    return x >= d.x0 - 1 && x <= d.x1 + 1 && z >= d.z0 - 1 && z <= d.z1 + 1 && b.begehbar(x, z);
  }
}

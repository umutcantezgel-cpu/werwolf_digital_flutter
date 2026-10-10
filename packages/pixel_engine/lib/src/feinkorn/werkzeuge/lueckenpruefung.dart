import 'dart:typed_data';

import '../bewegung/figur_aufbau.dart';
import '../bewegung/skelett.dart';

/// Lückenprüfung an Gelenken (8. Prüfwerkzeuge, K-06): Zusammenhang der Figur, geschlossene Gelenke und
/// Nadellöcher (leere Blöcke, die rundum von belegten umgeben sind).
class Lueckenbefund {
  Lueckenbefund(this.komponenten, this.offeneGelenke, this.nadelloecher, this.bloecke);

  /// Zahl der 6-zusammenhängenden Teile (Soll: 1).
  final int komponenten;

  /// Knochen, deren Teil das Elternteil nicht berührt (Soll: leer).
  final List<String> offeneGelenke;

  /// Leere Blöcke mit sechs belegten Nachbarn (Soll: 0).
  final int nadelloecher;
  final int bloecke;

  bool get geschlossen => komponenten == 1 && offeneGelenke.isEmpty && nadelloecher == 0;

  @override
  String toString() => 'Teile $komponenten · offene Gelenke ${offeneGelenke.isEmpty ? 0 : offeneGelenke.join(',')} · Nadellöcher $nadelloecher · Blöcke $bloecke';
}

Lueckenbefund pruefeLuecken(Aufgebaut a, Skelett skelett) {
  final k = a.koerper, nx = k.breite, ny = k.tiefe, nz = k.hoehe;
  final belegt = Uint8List(nx * ny * nz);
  var bloecke = 0;
  for (var z = 0; z < nz; z++) {
    for (var y = 0; y < ny; y++) {
      for (var x = 0; x < nx; x++) {
        if (k.wert(x, y, z) != 0) {
          belegt[(z * ny + y) * nx + x] = 1;
          bloecke++;
        }
      }
    }
  }
  // Komponenten per Breitensuche
  final marke = Int32List(nx * ny * nz);
  final schlange = Int32List(nx * ny * nz);
  var komponenten = 0;
  for (var i = 0; i < belegt.length; i++) {
    if (belegt[i] == 0 || marke[i] != 0) continue;
    komponenten++;
    var kopf = 0, ende = 0;
    schlange[ende++] = i;
    marke[i] = komponenten;
    while (kopf < ende) {
      final j = schlange[kopf++];
      final x = j % nx, y = (j ~/ nx) % ny, z = j ~/ (nx * ny);
      for (final (dx, dy, dz) in const [(1, 0, 0), (-1, 0, 0), (0, 1, 0), (0, -1, 0), (0, 0, 1), (0, 0, -1)]) {
        final xx = x + dx, yy = y + dy, zz = z + dz;
        if (xx < 0 || yy < 0 || zz < 0 || xx >= nx || yy >= ny || zz >= nz) continue;
        final n = (zz * ny + yy) * nx + xx;
        if (belegt[n] == 0 || marke[n] != 0) continue;
        marke[n] = komponenten;
        schlange[ende++] = n;
      }
    }
  }
  // Gelenke: berührt ein Block des Kindteils einen Block des Elternteils?
  final offen = <String>[];
  for (var b = 0; b < skelett.knochen.length; b++) {
    final e = skelett.knochen[b].eltern;
    if (e < 0) continue;
    var zu = false;
    for (var i = 0; i < belegt.length && !zu; i++) {
      if (a.teilVon[i] != b + 1) continue;
      final x = i % nx, y = (i ~/ nx) % ny, z = i ~/ (nx * ny);
      for (final (dx, dy, dz) in const [(0, 0, 0), (1, 0, 0), (-1, 0, 0), (0, 1, 0), (0, -1, 0), (0, 0, 1), (0, 0, -1)]) {
        final xx = x + dx, yy = y + dy, zz = z + dz;
        if (xx < 0 || yy < 0 || zz < 0 || xx >= nx || yy >= ny || zz >= nz) continue;
        if (a.teilVon[(zz * ny + yy) * nx + xx] == e + 1) {
          zu = true;
          break;
        }
      }
    }
    if (!zu) offen.add(skelett.knochen[b].name);
  }
  var loecher = 0;
  for (var z = 1; z < nz - 1; z++) {
    for (var y = 1; y < ny - 1; y++) {
      for (var x = 1; x < nx - 1; x++) {
        final i = (z * ny + y) * nx + x;
        if (belegt[i] != 0) continue;
        if (belegt[i + 1] != 0 && belegt[i - 1] != 0 && belegt[i + nx] != 0 && belegt[i - nx] != 0 && belegt[i + nx * ny] != 0 && belegt[i - nx * ny] != 0) loecher++;
      }
    }
  }
  return Lueckenbefund(komponenten, offen, loecher, bloecke);
}

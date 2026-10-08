import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Lichtquelle in Weltkoordinaten (Meter).
class Lichtpunkt {
  final double x, y, z, warm, kalt, weite;
  const Lichtpunkt(this.x, this.y, this.z, this.warm, this.kalt, this.weite);
}

/// Baut aus einem [Bereich] die Meshes (Boden, Decke, Wände, Türen, Möbel) mit
/// Vertex-Licht aus Grundlicht und Lichtquellen.
class BereichGeometrie {
  final Bereich bereich;
  final List<Mesh> meshes = [];
  final List<Lichtpunkt> lichter = [];

  BereichGeometrie(this.bereich) {
    _lichter();
    _bauen();
  }

  static int tex(String? name, [TexturId ersatz = TexturId.quaderMauer]) {
    if (name == null) return ersatz.index;
    for (final t in TexturId.values) {
      if (t.name == name) return t.index;
    }
    return ersatz.index;
  }

  void _lichter() {
    for (final d in bereich.dinge) {
      final l = d.legende;
      if (l.lichtWarm > 0 || l.lichtKalt > 0) {
        lichter.add(Lichtpunkt(d.mitteX, l.hoehe + 0.3, d.mitteZ, l.lichtWarm, l.lichtKalt, l.lichtWeite));
      }
    }
  }

  /// Licht (warm, kalt) an einem Weltpunkt.
  (double, double) licht(double x, double y, double z) {
    var w = bereich.grundWarm, k = bereich.grundKalt;
    for (final l in lichter) {
      final dx = x - l.x, dy = (y - l.y) * 0.7, dz = z - l.z;
      final d = math.sqrt(dx * dx + dy * dy + dz * dz);
      if (d >= l.weite) continue;
      final f = (1 - d / l.weite);
      w += l.warm * f * f;
      k += l.kalt * f * f;
    }
    return (w.clamp(0.0, 1.0), k.clamp(0.0, 1.0));
  }

  void _bauen() {
    final b = bereich;
    const s = kKachel;
    final breite = b.breite * s, tiefe = b.tiefe * s;
    final h = b.raumHoehe;
    // Boden und Decke
    final boden = MeshBuilder();
    boden.floor(0, 0, breite, tiefe, 0, tex(b.bodenTextur, TexturId.schieferPlatten), step: 1,
        warmAt: (x, z) => licht(x, 0, z).$1, coldAt: (x, z) => licht(x, 0, z).$2);
    // Raureif-Stationen: heller Boden
    for (final d in b.dinge.where((d) => d.legende.form == 'raureif')) {
      boden.floor(d.x0 * s, d.z0 * s, (d.x1 + 1) * s, (d.z1 + 1) * s, 0.01, TexturId.putzKalkweiss.index, step: 1,
          warmAt: (x, z) => licht(x, 0, z).$1, coldAt: (x, z) => licht(x, 0, z).$2 + 0.1);
    }
    meshes.add(boden.build());
    if (b.innen) {
      final decke = MeshBuilder();
      decke.floor(0, 0, breite, tiefe, h, tex(b.deckenTextur, TexturId.gewoelbeDecke), up: false, step: 1,
          warmAt: (x, z) => licht(x, h, z).$1, coldAt: (x, z) => licht(x, h, z).$2);
      meshes.add(decke.build());
    }
    // Wände: Kanten zwischen Wand/Tür-Kacheln und begehbaren/Objekt-Kacheln
    final waende = MeshBuilder();
    final wandTex = tex(b.wandTextur, TexturId.burgBruchstein);
    bool massiv(int x, int z) {
      final a = b.art(x, z);
      return a == KachelArt.wand || a == KachelArt.tuer || a == KachelArt.leer;
    }

    bool innenraum(int x, int z) {
      final a = b.art(x, z);
      return a == KachelArt.boden || a == KachelArt.station || a == KachelArt.objekt;
    }

    for (var z = 0; z < b.tiefe; z++) {
      for (var x = 0; x < b.breite; x++) {
        if (!massiv(x, z) || b.art(x, z) == KachelArt.leer) continue;
        final tuer = b.art(x, z) == KachelArt.tuer ? b.dingAn(x, z) : null;
        // vier Seiten; sichtbar von der Nachbarkachel aus
        for (final (dx, dz) in const [(0, 1), (0, -1), (1, 0), (-1, 0)]) {
          if (!innenraum(x + dx, z + dz)) continue;
          // Kante in Laufrichtung so, dass die Vorderseite zum Nachbarn zeigt
          double x0, z0, x1, z1;
          if (dz == 1) {
            x0 = x * s; z0 = (z + 1) * s; x1 = (x + 1) * s; z1 = (z + 1) * s; // Süd: West→Ost
          } else if (dz == -1) {
            x0 = (x + 1) * s; z0 = z * s; x1 = x * s; z1 = z * s; // Nord: Ost→West
          } else if (dx == 1) {
            x0 = (x + 1) * s; z0 = (z + 1) * s; x1 = (x + 1) * s; z1 = z * s; // Ost: Süd→Nord
          } else {
            x0 = x * s; z0 = z * s; x1 = x * s; z1 = (z + 1) * s; // West: Nord→Süd
          }
          final mx = (x0 + x1) / 2, mz = (z0 + z1) / 2;
          final (wu, ku) = licht(mx, 0.3, mz);
          final (wo, ko) = licht(mx, h, mz);
          final u0 = (x * 7 + z * 3) % 4 * 16.0;
          if (tuer != null) {
            final th = math.min(tuer.legende.hoehe, h);
            final tt = tex(tuer.legende.textur, TexturId.eichenTuer);
            // Türblatt: Textur pro Kachel fortlaufend
            final tu = (dz != 0 ? (x - tuer.x0) : (z - tuer.z0)) * s * kTexelsPerMeter;
            waende.wall(x0, z0, x1, z1, 0, th, tt, warm: wu, cold: ku, warmTop: wo, coldTop: ko, u0: tu);
            if (h > th) waende.wall(x0, z0, x1, z1, th, h, wandTex, warm: wo, cold: ko, u0: u0);
          } else {
            waende.wall(x0, z0, x1, z1, 0, h, wandTex, warm: wu, cold: ku, warmTop: wo, coldTop: ko, u0: u0);
          }
        }
      }
    }
    meshes.add(waende.build());
    // Möbel und Bauten als Quader
    for (final d in b.dinge) {
      final l = d.legende;
      if (l.art != KachelArt.objekt) continue;
      final m = MeshBuilder();
      final t = tex(l.textur, TexturId.holzDielen);
      final x0 = d.x0 * s + 0.04, z0 = d.z0 * s + 0.04, x1 = (d.x1 + 1) * s - 0.04, z1 = (d.z1 + 1) * s - 0.04;
      final (w, k) = licht(d.mitteX, l.hoehe / 2, d.mitteZ);
      switch (l.form) {
        case 'tisch':
          m.box(x0, l.hoehe - 0.06, z0, x1, l.hoehe, z1, t, warm: w, cold: k);
          for (final (lx, lz) in [(x0 + 0.1, z0 + 0.1), (x1 - 0.18, z0 + 0.1), (x0 + 0.1, z1 - 0.18), (x1 - 0.18, z1 - 0.18)]) {
            m.box(lx, 0, lz, lx + 0.08, l.hoehe - 0.06, lz + 0.08, t, warm: w * 0.8, cold: k);
          }
        case 'zinnen':
          m.box(x0 - 0.04, 0, z0 - 0.04, x1 + 0.04, 0.9, z1 + 0.04, t, warm: w, cold: k);
          for (var xx = d.x0; xx <= d.x1; xx += 4) {
            m.box(xx * s, 0.9, d.z0 * s, xx * s + 1.0, l.hoehe + 0.5, (d.z1 + 1) * s, t, warm: w, cold: k);
          }
        case 'turm':
        case 'haus':
          m.box(x0 - 0.04, 0, z0 - 0.04, x1 + 0.04, l.hoehe, z1 + 0.04, t, warm: w, cold: k, texTop: TexturId.dachBiberschwanz.index);
        case 'kamin':
          m.box(x0, 0, z0, x1, l.hoehe, z1, t, warm: w, cold: k);
          // Glut: warmes Feld vor der Öffnung
          m.box(x0 + 0.3, 0.05, z1, x1 - 0.3, 0.6, z1 + 0.02, TexturId.fensterKerze.index, warm: 1, cold: 0);
        default:
          m.box(x0, 0, z0, x1, l.hoehe, z1, t, warm: w, cold: k);
      }
      meshes.add(m.build());
    }
  }
}

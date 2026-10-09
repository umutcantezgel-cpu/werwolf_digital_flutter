import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

import 'bau/form.dart';
import 'bau/formen/register.dart';

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

  /// Seite, an der [d] anliegt (für [FormOrt.rueckseite]): die Seite mit den meisten nicht begehbaren
  /// Nachbarkacheln; bei Gleichstand die erste in der Reihenfolge −z, +x, +z, −x. Reine Darstellung.
  static int rueckseite(Bereich b, Ding d) {
    var beste = 0, besteZahl = -1;
    for (var s = 0; s < 4; s++) {
      var n = 0;
      if (s == 0 || s == 2) {
        final z = s == 0 ? d.z0 - 1 : d.z1 + 1;
        for (var x = d.x0; x <= d.x1; x++) {
          if (!b.begehbar(x, z)) n++;
        }
      } else {
        final x = s == 3 ? d.x0 - 1 : d.x1 + 1;
        for (var z = d.z0; z <= d.z1; z++) {
          if (!b.begehbar(x, z)) n++;
        }
      }
      final l = (s == 0 || s == 2) ? d.x1 - d.x0 + 1 : d.z1 - d.z0 + 1;
      // Anteil der Seite, damit kurze und lange Seiten vergleichbar sind
      final anteil = n * 1000 ~/ l;
      if (anteil > besteZahl) {
        besteZahl = anteil;
        beste = s;
      }
    }
    return beste;
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

  /// Giebelhaus: Putzwände, Fensterreihen, Satteldach mit Dachgauben-„Augen“.
  void _haus(MeshBuilder m, Ding d, double x0, double z0, double x1, double z1, double h, int putz) {
    final (w, k) = licht((x0 + x1) / 2, h / 2, (z0 + z1) / 2);
    m.box(x0, 0, z0, x1, h, z1, putz, warm: w, cold: k);
    final fenster = TexturId.fensterDunkel.index, kerze = TexturId.fensterKerze.index;
    var nr = d.x0 * 7 + d.z0 * 13;
    // Fenster auf allen vier Seiten (leicht vor der Wand)
    void reihe(double ax, double az, double bx, double bz, double nx, double nz) {
      final len = (bx - ax).abs() + (bz - az).abs();
      final anzahl = (len / 2.2).floor();
      if (anzahl < 1) return;
      for (var stock = 0; stock < (h / 3).floor(); stock++) {
        final y0 = 1.3 + stock * 3.0, y1 = y0 + 1.1;
        if (y1 > h - 0.4) break;
        for (var i = 0; i < anzahl; i++) {
          final f = (i + 0.5) / anzahl;
          final mx = ax + (bx - ax) * f, mz = az + (bz - az) * f;
          final dx = (bx - ax) / len * 0.45, dz = (bz - az) / len * 0.45;
          final tex = (nr++ % 9 == 0) ? kerze : fenster;
          final warmF = tex == kerze ? 0.8 : w;
          m.wall(mx - dx + nx * 0.03, mz - dz + nz * 0.03, mx + dx + nx * 0.03, mz + dz + nz * 0.03, y0, y1, tex, warm: warmF, cold: k);
        }
      }
    }

    reihe(x0, z1, x1, z1, 0, 1); // Süd
    reihe(x1, z0, x0, z0, 0, -1); // Nord
    reihe(x1, z1, x1, z0, 1, 0); // Ost
    reihe(x0, z0, x0, z1, -1, 0); // West
    // Satteldach entlang der längeren Seite, steil (Burgstadt-Stil)
    final dach = TexturId.dachBiberschwanz.index;
    final entlangX = (x1 - x0) >= (z1 - z0);
    final halb = entlangX ? (z1 - z0) / 2 : (x1 - x0) / 2;
    final first = h + halb * 1.5;
    final hang = (halb * halb + (first - h) * (first - h));
    final hv = math.sqrt(hang) * kDichteWelt;
    if (entlangX) {
      final zm = (z0 + z1) / 2, len = (x1 - x0) * kDichteWelt;
      var a = m.vertex(x0 - 0.2, h, z1 + 0.2, 0, hv, cold: k);
      var b2 = m.vertex(x1 + 0.2, h, z1 + 0.2, len, hv, cold: k);
      var c = m.vertex(x1 + 0.2, first, zm, len, 0, cold: k + 0.08);
      var e = m.vertex(x0 - 0.2, first, zm, 0, 0, cold: k + 0.08);
      m.quad(a, b2, c, e, dach);
      a = m.vertex(x1 + 0.2, h, z0 - 0.2, 0, hv, cold: k * 0.7);
      b2 = m.vertex(x0 - 0.2, h, z0 - 0.2, len, hv, cold: k * 0.7);
      c = m.vertex(x0 - 0.2, first, zm, len, 0, cold: k);
      e = m.vertex(x1 + 0.2, first, zm, 0, 0, cold: k);
      m.quad(a, b2, c, e, dach);
      for (final (gx, s1, s2) in [(x1, z1, z0), (x0, z0, z1)]) {
        final p = m.vertex(gx, h, s1, 0, (first - h) * kDichteWelt, warm: w, cold: k);
        final q = m.vertex(gx, h, s2, (z1 - z0) * kDichteWelt, (first - h) * kDichteWelt, warm: w, cold: k);
        final tt = m.vertex(gx, first, zm, (z1 - z0) * kDichteWelt / 2, 0, warm: w, cold: k);
        m.triangle(p, q, tt, putz);
      }
      // Dachgauben-„Augen“: zwei dunkle Schlitze auf der Südseite
      for (final f in const [0.33, 0.67]) {
        final ex = x0 + (x1 - x0) * f;
        final ey = h + (first - h) * 0.45, ez = z1 - halb * 0.45 + 0.05;
        m.wall(ex - 0.45, ez, ex + 0.45, ez, ey, ey + 0.35, fenster, warm: 0, cold: k * 0.5);
      }
    } else {
      final xm = (x0 + x1) / 2, len = (z1 - z0) * kDichteWelt;
      var a = m.vertex(x1 + 0.2, h, z1 + 0.2, 0, hv, cold: k);
      var b2 = m.vertex(x1 + 0.2, h, z0 - 0.2, len, hv, cold: k);
      var c = m.vertex(xm, first, z0 - 0.2, len, 0, cold: k + 0.08);
      var e = m.vertex(xm, first, z1 + 0.2, 0, 0, cold: k + 0.08);
      m.quad(a, b2, c, e, dach);
      a = m.vertex(x0 - 0.2, h, z0 - 0.2, 0, hv, cold: k * 0.7);
      b2 = m.vertex(x0 - 0.2, h, z1 + 0.2, len, hv, cold: k * 0.7);
      c = m.vertex(xm, first, z1 + 0.2, len, 0, cold: k);
      e = m.vertex(xm, first, z0 - 0.2, 0, 0, cold: k);
      m.quad(a, b2, c, e, dach);
      for (final (gz, s1, s2) in [(z1, x0, x1), (z0, x1, x0)]) {
        final p = m.vertex(s1, h, gz, 0, (first - h) * kDichteWelt, warm: w, cold: k);
        final q = m.vertex(s2, h, gz, (x1 - x0) * kDichteWelt, (first - h) * kDichteWelt, warm: w, cold: k);
        final tt = m.vertex(xm, first, gz, (x1 - x0) * kDichteWelt / 2, 0, warm: w, cold: k);
        m.triangle(p, q, tt, putz);
      }
    }
  }

  void _bauen() {
    final b = bereich;
    const s = kKachel;
    final breite = b.breite * s, tiefe = b.tiefe * s;
    final h = b.raumHoehe;
    // Boden und Decke in Blöcken (16 m), damit große Bereiche weggeschnitten werden
    const block = 16.0;
    final gross = breite * tiefe > 2500;
    final schritt = gross ? 2.0 : 1.0;
    bool leer(double x0, double z0, double x1, double z1) {
      for (var z = (z0 / s).floor(); z < (z1 / s).ceil(); z += 2) {
        for (var x = (x0 / s).floor(); x < (x1 / s).ceil(); x += 2) {
          if (b.art(x, z) != KachelArt.leer) return false;
        }
      }
      return true;
    }

    for (var bz = 0.0; bz < tiefe; bz += block) {
      for (var bx = 0.0; bx < breite; bx += block) {
        final x1 = math.min(bx + block, breite), z1 = math.min(bz + block, tiefe);
        if (leer(bx, bz, x1, z1)) continue;
        final boden = MeshBuilder();
        boden.floor(bx, bz, x1, z1, 0, tex(b.bodenTextur, TexturId.schieferPlatten), step: schritt,
            warmAt: (x, z) => licht(x, 0, z).$1, coldAt: (x, z) => licht(x, 0, z).$2);
        meshes.add(boden.build());
        if (b.innen) {
          final decke = MeshBuilder();
          decke.floor(bx, bz, x1, z1, h, tex(b.deckenTextur, TexturId.gewoelbeDecke), up: false, step: schritt,
              warmAt: (x, z) => licht(x, h, z).$1, coldAt: (x, z) => licht(x, h, z).$2);
          meshes.add(decke.build());
        }
      }
    }
    // Raureif-Stationen: heller Boden
    final reif = MeshBuilder();
    for (final d in b.dinge.where((d) => d.legende.form == 'raureif')) {
      reif.floor(d.x0 * s, d.z0 * s, (d.x1 + 1) * s, (d.z1 + 1) * s, 0.01, TexturId.putzKalkweiss.index, step: 1,
          warmAt: (x, z) => licht(x, 0, z).$1, coldAt: (x, z) => licht(x, 0, z).$2 + 0.1);
    }
    if (reif.triangleCount > 0) meshes.add(reif.build());
    // Wände: Kanten zwischen Wand/Tür-Kacheln und begehbaren/Objekt-Kacheln
    final wandBloecke = <int, MeshBuilder>{};
    MeshBuilder wandBlock(int x, int z) => wandBloecke.putIfAbsent((z ~/ 32) * 1000 + x ~/ 32, MeshBuilder.new);
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
        final waende = wandBlock(x, z);
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
          final u0 = (x * 7 + z * 3) % 4 * 0.5 * kDichteWelt; // Versatz in 0,5-m-Schritten
          if (tuer != null) {
            final th = math.min(tuer.legende.hoehe, h);
            final tt = tex(tuer.legende.textur, TexturId.eichenTuer);
            // Türblatt: Textur pro Kachel fortlaufend
            final tu = (dz != 0 ? (x - tuer.x0) : (z - tuer.z0)) * s * kDichteWelt;
            waende.wall(x0, z0, x1, z1, 0, th, tt, warm: wu, cold: ku, warmTop: wo, coldTop: ko, u0: tu);
            if (h > th) waende.wall(x0, z0, x1, z1, th, h, wandTex, warm: wo, cold: ko, u0: u0);
          } else {
            waende.wall(x0, z0, x1, z1, 0, h, wandTex, warm: wu, cold: ku, warmTop: wo, coldTop: ko, u0: u0);
          }
        }
      }
    }
    for (final w in wandBloecke.values) {
      if (w.triangleCount > 0) meshes.add(w.build());
    }
    // Möbel und Bauten als Quader (Gärten je Block gebündelt)
    final gartenBloecke = <int, MeshBuilder>{};
    for (final d in b.dinge) {
      final l = d.legende;
      if (l.form == 'laube') {
        _laube(d);
        continue;
      }
      if (l.art != KachelArt.objekt) continue;
      if (l.form == 'garten') {
        final g = gartenBloecke.putIfAbsent((d.z0 ~/ 32) * 1000 + d.x0 ~/ 32, MeshBuilder.new);
        final (w, k) = licht(d.mitteX, 1, d.mitteZ);
        g.box(d.x0 * s, 0, d.z0 * s, (d.x1 + 1) * s, l.hoehe, (d.z1 + 1) * s, tex(l.textur, TexturId.bruchsteinMauer),
            warm: w, cold: k, texTop: TexturId.wiese.index);
        continue;
      }
      final m = MeshBuilder();
      final t = tex(l.textur, TexturId.holzDielen);
      final x0 = d.x0 * s + 0.04, z0 = d.z0 * s + 0.04, x1 = (d.x1 + 1) * s - 0.04, z1 = (d.z1 + 1) * s - 0.04;
      final (w, k) = licht(d.mitteX, l.hoehe / 2, d.mitteZ);
      final form = kFormen[l.form];
      if (form != null) {
        form.baue(m, FormOrt(ding: d, bereichId: b.id, x0: x0, z0: z0, x1: x1, z1: z1, hoehe: l.hoehe, textur: t, warm: w, kalt: k,
            rueckseite: rueckseite(b, d)));
        meshes.add(m.build());
        continue;
      }
      switch (l.form) {
        case 'zinnen':
          m.box(x0 - 0.04, 0, z0 - 0.04, x1 + 0.04, 0.9, z1 + 0.04, t, warm: w, cold: k);
          for (var xx = d.x0; xx <= d.x1; xx += 4) {
            m.box(xx * s, 0.9, d.z0 * s, xx * s + 1.0, l.hoehe + 0.5, (d.z1 + 1) * s, t, warm: w, cold: k);
          }
        case 'haus':
          _haus(m, d, x0 - 0.04, z0 - 0.04, x1 + 0.04, z1 + 0.04, l.hoehe, t);
        case 'turm':
          m.box(x0 - 0.04, 0, z0 - 0.04, x1 + 0.04, l.hoehe, z1 + 0.04, t, warm: w, cold: k, texTop: TexturId.dachBiberschwanz.index);
          // Spitzhelm
          final cx = (x0 + x1) / 2, cz = (z0 + z1) / 2, top = l.hoehe + (x1 - x0) * 1.2;
          final dach = TexturId.dachBiberschwanz.index;
          for (final (ax, az, bx, bz) in [(x0, z1, x1, z1), (x1, z1, x1, z0), (x1, z0, x0, z0), (x0, z0, x0, z1)]) {
            final a = m.vertex(ax, l.hoehe, az, 0, (top - l.hoehe) * kDichteWelt, cold: k + 0.05);
            final b2 = m.vertex(bx, l.hoehe, bz, (x1 - x0) * kDichteWelt, (top - l.hoehe) * kDichteWelt, cold: k + 0.05);
            final c = m.vertex(cx, top, cz, (x1 - x0) * kDichteWelt / 2, 0, cold: k + 0.1);
            m.triangle(a, b2, c, dach);
          }
        case 'kamin':
          m.box(x0, 0, z0, x1, l.hoehe, z1, t, warm: w, cold: k);
          // Glut: warmes Feld vor der Öffnung
          m.box(x0 + 0.3, 0.05, z1, x1 - 0.3, 0.6, z1 + 0.02, TexturId.fensterKerze.index, warm: 1, cold: 0);
        default:
          m.box(x0, 0, z0, x1, l.hoehe, z1, t, warm: w, cold: k);
      }
      meshes.add(m.build());
    }
    for (final g in gartenBloecke.values) {
      meshes.add(g.build());
    }
  }

  /// Überdachter Laubengang / Holztreppe: Pfosten an den Längsseiten, Dach darüber (begehbar).
  void _laube(Ding d) {
    const s = kKachel;
    final m = MeshBuilder();
    final l = d.legende;
    final x0 = d.x0 * s, z0 = d.z0 * s, x1 = (d.x1 + 1) * s, z1 = (d.z1 + 1) * s;
    final holz = tex(l.textur, TexturId.holzBohlen);
    final (w, k) = licht(d.mitteX, 1, d.mitteZ);
    final laengsX = (x1 - x0) >= (z1 - z0);
    if (laengsX) {
      for (var x = x0; x <= x1 - 0.1; x += 2) {
        for (final z in [z0, z1 - 0.12]) {
          m.box(x, 0, z, x + 0.12, l.hoehe, z + 0.12, holz, warm: w, cold: k);
        }
      }
    } else {
      for (var z = z0; z <= z1 - 0.1; z += 2) {
        for (final x in [x0, x1 - 0.12]) {
          m.box(x, 0, z, x + 0.12, l.hoehe, z + 0.12, holz, warm: w, cold: k);
        }
      }
    }
    m.box(x0 - 0.2, l.hoehe, z0 - 0.2, x1 + 0.2, l.hoehe + 0.15, z1 + 0.2, holz, warm: w, cold: k, texTop: TexturId.dachBiberschwanz.index);
    m.floor(x0, z0, x1, z1, l.hoehe - 0.01, holz, up: false, step: 2, warmAt: (_, _) => w, coldAt: (_, _) => k * 0.6);
    meshes.add(m.build());
  }
}

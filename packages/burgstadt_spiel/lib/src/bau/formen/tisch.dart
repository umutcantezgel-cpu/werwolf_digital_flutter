import 'dart:math' as math;

import 'package:pixel_engine/pixel_engine.dart';

import '../form.dart';

/// Höhe einer Kerze über der Platte: Tonschale 0,02 + Wachsstumpf 0,10 + Flamme 0,04 m. Die Kerze bleibt in der
/// Höhe des Dings (Regel 1), daher liegt die Platte bei Kerzentischen um diesen Betrag tiefer.
const double _kerzeHoehe = 0.16;

/// Neigung der Lesepult-Platte: 15° zur Rückseite hin ansteigend.
final double _neigung = math.tan(math.pi / 12);

/// Richtung zur Wand je `rueckseite` (0 = −z, 1 = +x, 2 = +z, 3 = −x).
const List<(double, double)> _normale = [(0.0, -1.0), (1.0, 0.0), (0.0, 1.0), (-1.0, 0.0)];

/// Seiten eines Quaders in Weltrichtung (Bitmaske); `_oben` ist die Deckfläche.
const int _nord = 1, _ost = 2, _sued = 4, _west = 8, _oben = 16;
const int _waende = _nord | _ost | _sued | _west;

/// Tisch (HZ-07, Auftrag P4-AUTOR-04, Form v2).
///
/// Platte 0,05 m mit 0,03 m Überstand über die Zarge (0,08 hoch, 0,03 dick, 0,03 eingerückt). Vier Beine 0,07 × 0,07 m
/// an den Ecken; bei `hash(0) % 3 == 0` stattdessen zwei Wangen mit Fußkufe und ein Längssteg. Über 2,2 m Länge
/// zusätzliche Beinpaare alle ≤ 2 m. Lesepult (Höhe ≥ 1,0 m, Grundfläche ≤ 1,0 m): geneigte Pultplatte mit Mittelfuß
/// und Kreuzfuß. Kerzen nur, wenn das Ding schon eine Lichtquelle des Bestands ist (`lichtWarm > 0`).
class TischForm implements Moebelform {
  const TischForm();

  @override
  String get name => 'tisch';

  @override
  void baue(MeshBuilder m, FormOrt o) {
    final w = o.warm, k = o.kalt;
    final laenge = math.max(o.breite, o.tiefe);
    final kerzen = o.ding.legende.lichtWarm > 0 ? math.min(3, math.max(1, (laenge / 2).ceil())) : 0;
    // Die Platte liegt auf der Datenhöhe; eine Kerze steht darauf und darf bis [_kerzeHoehe] darüber ragen
    // (reine Darstellung, die Kollision ist zweidimensional).
    final oben = o.hoehe;
    if (o.hoehe >= 1.0 && laenge <= 1.0) {
      _lesepult(m, o, oben, kerzen, w, k);
    } else {
      _tisch(m, o, oben, kerzen, w, k);
    }
  }

  void _tisch(MeshBuilder m, FormOrt o, double oben, int kerzen, double w, double k) {
    final tex = o.textur, wd = _c01(w * 0.8), kh = _c01(k + 0.05);
    final lang = o.breite >= o.tiefe;
    final laenge = math.max(o.breite, o.tiefe);
    final u0 = lang ? o.x0 : o.z0, u1 = lang ? o.x1 : o.z1; // Längsachse
    final v0 = lang ? o.z0 : o.x0, v1 = lang ? o.z1 : o.x1; // quer dazu

    // Platte: volle Grundfläche, Oberseite heller
    _kasten(m, o.x0, oben - 0.05, o.z0, o.x1, oben, o.z1, tex,
        warm: w, cold: k, topCold: kh, seiten: _waende | _oben);
    // Zarge unter der Platte: nur Außenflächen (die Innenflächen liegen unter der Platte, von oben nicht sichtbar)
    _kasten(m, o.x0 + 0.03, oben - 0.13, o.z0 + 0.03, o.x1 - 0.03, oben - 0.05, o.z1 - 0.03, tex,
        warm: wd, cold: k, seiten: _waende);

    void bein(double a0, double a1, double b0, double b1) =>
        _quaderUV(m, lang, a0, a1, b0, b1, 0, oben - 0.13, tex, warm: wd, cold: k, seiten: _waende);

    if (o.hash(0) % 3 == 0) {
      for (final hi in [false, true]) {
        // Brettwange 0,05 dick am Ende, darunter die Fußkufe 0,08 × 0,08 über die ganze Tiefe
        _quaderUV(m, lang, hi ? u1 - 0.08 : u0 + 0.03, hi ? u1 - 0.03 : u0 + 0.08, v0 + 0.03, v1 - 0.03, 0.08,
            oben - 0.13, tex, warm: wd, cold: k,
            seiten: _seiteU(lang, hi) | _seiteV(lang, false) | _seiteV(lang, true));
        _quaderUV(m, lang, hi ? u1 - 0.11 : u0 + 0.03, hi ? u1 - 0.03 : u0 + 0.11, v0, v1, 0, 0.08, tex,
            warm: wd, cold: k, topCold: kh,
            seiten: _seiteU(lang, hi) | _seiteV(lang, false) | _seiteV(lang, true) | _oben);
      }
      // Längssteg zwischen den Wangen, Oberkante auf 0,15 m
      final vm = (v0 + v1) / 2;
      _quaderUV(m, lang, u0 + 0.08, u1 - 0.08, vm - 0.025, vm + 0.025, 0.10, 0.15, tex,
          warm: wd, cold: k, seiten: _seiteV(lang, false) | _seiteV(lang, true));
    } else {
      // vier Eckbeine 0,07 × 0,07 m, bündig mit der Zarge
      for (final (a0, a1) in [(u0 + 0.03, u0 + 0.10), (u1 - 0.10, u1 - 0.03)]) {
        bein(a0, a1, v0 + 0.03, v0 + 0.10);
        bein(a0, a1, v1 - 0.10, v1 - 0.03);
      }
    }
    // Über 2,2 m Länge zusätzliche Beinpaare, Abstand ≤ 2 m zwischen den Eckbeinen
    if (laenge > 2.2) {
      final spanne = (u1 - 0.065) - (u0 + 0.065);
      final abschnitte = (spanne / 2).ceil();
      for (var i = 1; i < abschnitte; i++) {
        final c = u0 + 0.065 + spanne * i / abschnitte;
        bein(c - 0.035, c + 0.035, v0 + 0.03, v0 + 0.10);
        bein(c - 0.035, c + 0.035, v1 - 0.10, v1 - 0.03);
      }
    }
    for (final (x, z) in _kerzenOrte(o, kerzen)) {
      _kerze(m, x, oben, z, w, k);
    }
  }

  void _lesepult(MeshBuilder m, FormOrt o, double oben, int kerzen, double w, double k) {
    final tex = o.textur, wd = _c01(w * 0.8), kh = _c01(k + 0.05);
    final cx = (o.x0 + o.x1) / 2, cz = (o.z0 + o.z1) / 2;
    final (nx, nz) = _normale[o.rueckseite];
    final (lx, lz) = (nz, -nx); // links, vom Raum aus zur Wand gesehen
    final dn = (nx != 0 ? o.breite : o.tiefe) / 2; // halbe Tiefe, Richtung Rückseite
    final wl = (nx != 0 ? o.tiefe : o.breite) / 2; // halbe Breite, Richtung links
    const dicke = 0.04;

    // Höhe der Pultplatte über (x, z): an der Rückseite `oben`, 15° nach vorne abfallend
    double hoch(double x, double z) => oben - ((cx + nx * dn - x) * nx + (cz + nz * dn - z) * nz) * _neigung;

    final hl = (cx + nx * dn + lx * wl, cz + nz * dn + lz * wl); // hinten links
    final hr = (cx + nx * dn - lx * wl, cz + nz * dn - lz * wl); // hinten rechts
    final vl = (cx - nx * dn + lx * wl, cz - nz * dn + lz * wl); // vorne links
    final vr = (cx - nx * dn - lx * wl, cz - nz * dn - lz * wl); // vorne rechts
    (double, double, double) ob((double, double) p) => (p.$1, hoch(p.$1, p.$2), p.$2);
    (double, double, double) un((double, double) p) => (p.$1, hoch(p.$1, p.$2) - dicke, p.$2);

    // Pultplatte: dünne, geneigte Platte (Oberseite heller); die Wandkante bleibt unsichtbar
    _flaeche(m, [ob(hl), ob(hr), ob(vr), ob(vl)], tex, warm: w, cold: kh, oben: true);
    _flaeche(m, [ob(vl), ob(vr), un(vr), un(vl)], tex, warm: w, cold: k, oben: false);
    _flaeche(m, [ob(hl), ob(vl), un(vl), un(hl)], tex, warm: w, cold: k, oben: false);
    _flaeche(m, [ob(hr), ob(vr), un(vr), un(hr)], tex, warm: w, cold: k, oben: false);

    // Mittelfuß 0,12 × 0,12 m unter der Pultplatte, Kreuzfuß aus zwei Leisten 0,06 × 0,04 m
    _kasten(m, cx - 0.06, 0, cz - 0.06, cx + 0.06, hoch(cx, cz) - dicke, cz + 0.06, tex,
        warm: wd, cold: k, seiten: _waende);
    _kasten(m, o.x0 + 0.06, 0, cz - 0.03, o.x1 - 0.06, 0.04, cz + 0.03, tex,
        warm: wd, cold: k, topCold: kh, seiten: _waende | _oben);
    _kasten(m, cx - 0.03, 0, o.z0 + 0.06, cx + 0.03, 0.04, o.z1 - 0.06, tex,
        warm: wd, cold: k, topCold: kh, seiten: _waende | _oben);

    for (final (x, z) in _kerzenOrte(o, kerzen)) {
      _kerze(m, x, hoch(x, z), z, w, k);
    }
  }

  /// Kerze: Tonschale, Wachsstumpf und Flamme, je ein Quader (zusammen 30 Dreiecke), Mitte (x, z) auf Höhe [y].
  void _kerze(MeshBuilder m, double x, double y, double z, double w, double k) {
    _kasten(m, x - 0.06, y, z - 0.06, x + 0.06, y + 0.02, z + 0.06, TexturId.ziegelKamin.index,
        warm: w, cold: k, topCold: _c01(k + 0.05), seiten: _waende | _oben);
    _kasten(m, x - 0.025, y + 0.02, z - 0.025, x + 0.025, y + 0.12, z + 0.025, TexturId.putzCreme.index,
        warm: 1.0, cold: 0.0, seiten: _waende | _oben);
    _kasten(m, x - 0.01, y + 0.12, z - 0.01, x + 0.01, y + _kerzeHoehe, z + 0.01, TexturId.fensterKerze.index,
        warm: 1.0, cold: 0.0, seiten: _waende | _oben);
  }

  /// Orte der Kerzen (Mitte, Welt): die erste liegt 0,15 m von der hinteren Ecke an der Rückseite, 0,15 m von der
  /// Seite entfernt; Variante über `hash(1)` (gerade = links, ungerade = rechts). Weitere Kerzen verteilen sich
  /// gleichmäßig längs der Tischlänge, von der Ecke weg.
  List<(double, double)> _kerzenOrte(FormOrt o, int n) {
    final orte = <(double, double)>[];
    if (n == 0) return orte;
    final (nx, nz) = _normale[o.rueckseite];
    final (lx, lz) = (nz, -nx);
    final cx = (o.x0 + o.x1) / 2, cz = (o.z0 + o.z1) / 2;
    final dn = (nx != 0 ? o.breite : o.tiefe) / 2, wl = (nx != 0 ? o.tiefe : o.breite) / 2;
    final s = o.hash(1) % 2 == 0 ? 1.0 : -1.0;
    final px = cx + nx * dn + s * lx * wl, pz = cz + nz * dn + s * lz * wl; // hintere Ecke auf der Variantenseite
    final ax = px - nx * 0.15 - s * lx * 0.15, az = pz - nz * 0.15 - s * lz * 0.15;
    final lang = o.breite >= o.tiefe;
    final laenge = lang ? o.breite : o.tiefe;
    final richtung = lang ? (px < cx ? 1.0 : -1.0) : (pz < cz ? 1.0 : -1.0);
    for (var i = 0; i < n; i++) {
      final t = n == 1 ? 0.0 : i * (laenge - 0.30) / (n - 1);
      orte.add(lang ? (ax + richtung * t, az) : (ax, az + richtung * t));
    }
    return orte;
  }

  /// Quader in Weltkoordinaten mit den Seiten [seiten]; Wände mit der Richtung des Box-Helfers (außen sichtbar).
  void _kasten(MeshBuilder m, double x0, double y0, double z0, double x1, double y1, double z1, int tex,
      {required double warm, required double cold, required int seiten, double? topCold}) {
    if (seiten & _sued != 0) m.wall(x0, z1, x1, z1, y0, y1, tex, warm: warm, cold: cold);
    if (seiten & _ost != 0) m.wall(x1, z1, x1, z0, y0, y1, tex, warm: warm, cold: cold);
    if (seiten & _nord != 0) m.wall(x1, z0, x0, z0, y0, y1, tex, warm: warm, cold: cold);
    if (seiten & _west != 0) m.wall(x0, z0, x0, z1, y0, y1, tex, warm: warm, cold: cold);
    if (seiten & _oben != 0) m.floor(x0, z0, x1, z1, y1, tex, warm: warm, cold: topCold ?? cold, step: 4);
  }

  /// Quader in Tischkoordinaten: [a] längs der Tischachse, [b] quer dazu.
  void _quaderUV(MeshBuilder m, bool lang, double a0, double a1, double b0, double b1, double y0, double y1, int tex,
      {required double warm, required double cold, required int seiten, double? topCold}) {
    if (lang) {
      _kasten(m, a0, y0, b0, a1, y1, b1, tex, warm: warm, cold: cold, topCold: topCold, seiten: seiten);
    } else {
      _kasten(m, b0, y0, a0, b1, y1, a1, tex, warm: warm, cold: cold, topCold: topCold, seiten: seiten);
    }
  }

  /// Welt-Seite der Außenfläche am niedrigen (hi = false) bzw. hohen (hi = true) Ende der Tischachse.
  int _seiteU(bool lang, bool hi) => lang ? (hi ? _ost : _west) : (hi ? _sued : _nord);

  /// Welt-Seite der Außenfläche am niedrigen bzw. hohen Rand quer zur Tischachse.
  int _seiteV(bool lang, bool hi) => lang ? (hi ? _sued : _nord) : (hi ? _ost : _west);

  /// Viereck (vier Punkte in zyklischer Folge), beidseitig; Oberseiten mit Welt-Texelkoordinaten x, z.
  void _flaeche(MeshBuilder m, List<(double, double, double)> ps, int tex,
      {required double warm, required double cold, required bool oben}) {
    final ids = [
      for (final (x, y, z) in ps)
        m.vertex(x, y, z, oben ? x * kDichteWelt : (x + z) * kDichteWelt, oben ? z * kDichteWelt : y * kDichteWelt,
            warm: warm, cold: cold),
    ];
    m.quad(ids[0], ids[1], ids[2], ids[3], tex, doubleSided: true);
  }
}

double _c01(double v) => v < 0 ? 0 : (v > 1 ? 1 : v);

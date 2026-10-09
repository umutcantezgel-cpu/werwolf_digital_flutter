import 'package:pixel_engine/pixel_engine.dart';

import '../bauteil.dart';

// Maße in Metern (Stilblatt §6: Fenster 0,9 × 1,1, Sims 0,06 hoch × 0,08 vor).
const double _glasTiefe = 0.01;
const double _rahmenBreite = 0.12;
const double _rahmenTiefe = 0.04;
const double _simsHoehe = 0.06;
const double _simsTiefe = 0.08;
const double _sturzHoehe = 0.06;
const double _sturzTiefe = 0.05;

/// Fenster v1 (Burgstadt HD, P1-AUTOR-08, HZ-05): aufgesetztes Relief auf einer noch geschlossenen
/// Fassade. Glas 0,01 m vor der Wand; Putzrahmen 0,12 m breit und 0,04 m vor der Wand; Sims unter dem
/// Rahmen (0,08 m vor, je 0,04 m über den Rahmen hinaus); Sturz darüber (0,05 m vor). Bei
/// `hash(0) % 5 == 0` entfällt der Sturz. Die Maße in [BauteilOrt.breite] und [BauteilOrt.hoehe] sind
/// die des Glases, [BauteilOrt.y] ist dessen Unterkante.
class FensterV1 implements Bauteil {
  const FensterV1();

  @override
  String get name => 'fenster';

  @override
  void baue(MeshBuilder m, BauteilOrt o) {
    final f = o.flaeche, k = f.kalt;
    final glas = o.texturen['glas'] ?? TexturId.fensterDunkel.index;
    final rahmen = _rolle(o, 'rahmen');
    final sims = _rolle(o, 'sims');
    final b = o.breite, h = o.hoehe, u = o.u, y = o.y;

    // Glas: Texturkoordinaten ab der linken oberen Ecke, damit die Sprossentextur maßstabsgetreu kachelt.
    final gl = u - b / 2, gr = u + b / 2, gu = y, go = y + h;
    _front(m, f, gl, gr, gu, go, _glasTiefe, glas, k);

    // Umlaufender Putzrahmen aus vier Kästen; das Glas bleibt zwischen ihnen frei.
    final rl = gl - _rahmenBreite, rr = gr + _rahmenBreite;
    final ru = gu - _rahmenBreite, ro = go + _rahmenBreite;
    _kasten(m, f, rl, rr, ru, gu, _rahmenTiefe, rahmen, k);
    _kasten(m, f, rl, rr, go, ro, _rahmenTiefe, rahmen, k);
    _kasten(m, f, rl, gl, gu, go, _rahmenTiefe, rahmen, k);
    _kasten(m, f, gr, rr, gu, go, _rahmenTiefe, rahmen, k);

    // Sims und Sturz: Breite = Glas + 2 × 0,12 + 2 × 0,04. Unterseiten im Schatten, Oberseiten etwas heller.
    final sb = b + 2 * _rahmenBreite + 2 * _rahmenTiefe;
    final sl = u - sb / 2, sr = u + sb / 2;
    final kOben = _licht(k + 0.05), kUnten = _licht(k * 0.6);
    _kasten(m, f, sl, sr, ru - _simsHoehe, ru, _simsTiefe, sims, k, oben: kOben, unten: kUnten);
    if (o.hash(0) % 5 != 0) {
      _kasten(m, f, sl, sr, ro, ro + _sturzHoehe, _sturzTiefe, sims, k, oben: kOben, unten: kUnten);
    }
  }
}

/// Eckpunkt eines Vierecks: Stelle [u] entlang der Fläche, Höhe [y], Tiefe [tiefe] vor der Wand und
/// Texturkoordinaten [s], [t] in Metern (× kDichteWelt beim Bau).
class _Ecke {
  const _Ecke(this.u, this.y, this.tiefe, this.s, this.t);

  final double u, y, tiefe, s, t;
}

/// Textur-Rolle aus dem Ort; fehlt sie, ist der Aufruf falsch und bricht ab.
int _rolle(BauteilOrt o, String rolle) {
  final t = o.texturen[rolle];
  if (t == null) throw StateError('Fenster: Textur-Rolle „$rolle“ fehlt in BauteilOrt.texturen');
  return t;
}

/// Lichtwert auf 0..1 begrenzt.
double _licht(double x) => x < 0.0 ? 0.0 : (x > 1.0 ? 1.0 : x);

/// Welt-Position (x, y, z) einer Ecke.
(double, double, double) _welt(Wandflaeche f, _Ecke e) {
  final (x, z) = f.punkt(e.u, e.tiefe);
  return (x, e.y, z);
}

/// Viereck aus vier Ecken, am Rand entlang. Die Reihenfolge wird so gewählt, dass (b−a)×(c−a) in Richtung
/// [n] zeigt, also zur sichtbaren Seite (Konvention von `MeshBuilder.wall`).
void _viereck(MeshBuilder m, Wandflaeche f, List<_Ecke> ecken, (double, double, double) n, int tex,
    {required double warm, required double kalt}) {
  final p = [for (final e in ecken) _welt(f, e)];
  final ux = p[1].$1 - p[0].$1, uy = p[1].$2 - p[0].$2, uz = p[1].$3 - p[0].$3;
  final vx = p[2].$1 - p[0].$1, vy = p[2].$2 - p[0].$2, vz = p[2].$3 - p[0].$3;
  final dot = (uy * vz - uz * vy) * n.$1 + (uz * vx - ux * vz) * n.$2 + (ux * vy - uy * vx) * n.$3;
  final ordnung = dot >= 0 ? const [0, 1, 2, 3] : const [3, 2, 1, 0];
  final i = [
    for (final j in ordnung)
      m.vertex(p[j].$1, p[j].$2, p[j].$3, ecken[j].s * kDichteWelt, ecken[j].t * kDichteWelt,
          warm: _licht(warm), cold: _licht(kalt)),
  ];
  m.quad(i[0], i[1], i[2], i[3], tex);
}

/// Vorderseite eines Rechtecks (Stellen [u0]..[u1], Höhen [y0]..[y1]) in Tiefe [tiefe] vor der Wand.
/// Texturkoordinaten in Metern ab der linken oberen Ecke.
void _front(MeshBuilder m, Wandflaeche f, double u0, double u1, double y0, double y1, double tiefe, int tex,
    double kalt) {
  final bt = u1 - u0, ht = y1 - y0;
  _viereck(m, f, [
    _Ecke(u0, y0, tiefe, 0, ht),
    _Ecke(u1, y0, tiefe, bt, ht),
    _Ecke(u1, y1, tiefe, bt, 0),
    _Ecke(u0, y1, tiefe, 0, 0),
  ], (f.nx, 0.0, f.nz), tex, warm: f.warm, kalt: kalt);
}

/// Flacher Kasten auf der Fläche: Stellen [u0]..[u1], Höhen [y0]..[y1], Tiefe 0..[tiefe] vor der Wand.
/// Die Rückseite liegt an der Wand und entfällt. Vorder- und Seitenflächen haben [kalt], Ober- und
/// Unterseite [oben] und [unten] (Standard: [kalt]).
void _kasten(MeshBuilder m, Wandflaeche f, double u0, double u1, double y0, double y1, double tiefe, int tex,
    double kalt, {double? oben, double? unten}) {
  final bt = u1 - u0, ht = y1 - y0;
  final tx = (f.x1 - f.x0) / f.laenge, tz = (f.z1 - f.z0) / f.laenge;
  _front(m, f, u0, u1, y0, y1, tiefe, tex, kalt);
  _viereck(m, f, [
    _Ecke(u0, y1, 0, 0, 0),
    _Ecke(u1, y1, 0, bt, 0),
    _Ecke(u1, y1, tiefe, bt, tiefe),
    _Ecke(u0, y1, tiefe, 0, tiefe),
  ], (0.0, 1.0, 0.0), tex, warm: f.warm, kalt: oben ?? kalt);
  _viereck(m, f, [
    _Ecke(u0, y0, 0, 0, 0),
    _Ecke(u1, y0, 0, bt, 0),
    _Ecke(u1, y0, tiefe, bt, tiefe),
    _Ecke(u0, y0, tiefe, 0, tiefe),
  ], (0.0, -1.0, 0.0), tex, warm: f.warm, kalt: unten ?? kalt);
  _viereck(m, f, [
    _Ecke(u1, y0, 0, 0, ht),
    _Ecke(u1, y0, tiefe, tiefe, ht),
    _Ecke(u1, y1, tiefe, tiefe, 0),
    _Ecke(u1, y1, 0, 0, 0),
  ], (tx, 0, tz), tex, warm: f.warm, kalt: kalt);
  _viereck(m, f, [
    _Ecke(u0, y0, 0, 0, ht),
    _Ecke(u0, y0, tiefe, tiefe, ht),
    _Ecke(u0, y1, tiefe, tiefe, 0),
    _Ecke(u0, y1, 0, 0, 0),
  ], (-tx, 0, -tz), tex, warm: f.warm, kalt: kalt);
}

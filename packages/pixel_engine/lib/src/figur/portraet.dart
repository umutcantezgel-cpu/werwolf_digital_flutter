/// Porträt-Generator (Auftrag A-601c): aus jeder Figurenkarte ein 64×64-Brustbild in vier
/// Gesichtsausdrücken (Gesprächsfenster, Fallakte, Lagerunde).
///
/// Körper, Haar, Bart, Kopfbedeckung, Brille, Schal und Oberteil kommen aus denselben Teilen
/// und Materialien wie die Ganzkörperfiguren (FigurBaker), aber mit einer Nahansicht: Der Kopf
/// füllt 60 % der Höhe, die Schultern werden unten beschnitten, leichte Dreiviertelansicht nach
/// rechts. Gegenstände (Zubehör, Kanon K9 §8) werden nie gezeichnet. Nur das Gesicht wechselt
/// mit dem Ausdruck; Index 1 (Pupille) ist den Augen vorbehalten.
library;

import 'dart:math' as math;
import 'dart:typed_data';

import '../palette.dart';
import '../raster/renderer.dart' show SpriteImage;
import 'baker.dart' show FigurBaker;
import 'figur.dart';
import 'mathe.dart';
import 'teile_basis.dart';

/// Gesichtsausdruck eines Porträts.
enum Ausdruck { neutral, freundlich, nachdenklich, erschrocken }

const int kPortraetBreite = 64;
const int kPortraetHoehe = 64;

/// Fußpunkt wie bei Sprites: Mitte unten.
const int _fussX = 32, _fussY = 63;

/// Der Kopf (Kinn bis Scheitel) füllt 60 % der Bildhöhe; sein Mittelpunkt liegt auf dieser Zeile.
const double _kopfHoehePx = 0.6 * kPortraetHoehe;
const double _kopfMitteZeile = 23.0;

/// Blick waagerecht (Augenlinie bleibt gerade) und Dreiviertelansicht nach rechts (wie FigurBaker, Richtung 2).
const double _erhebung = 0;
const double _gierung = 0.42;

/// Licht von links oben vorne, im Ansichtsraum (wie FigurBaker).
const (double, double, double) _licht = (-0.55, 0.62, 0.56);

/// Kopf-Ellipsoid aus kKoerper: Mitte und Halbachsen in Einheiten von 1 m bei 1,75 m Größe.
final Grundkoerper _kopfK = kKoerper.koerper.firstWhere((g) => g.knochen == 'kopf');

/// Nur diese Knochen liegen im Bildausschnitt (Kopf, Rumpf, Schultern).
const Set<String> _sichtbar = {'kopf', 'rumpf', 'schulterL', 'schulterR'};

/// Im Porträt erscheinen nur Haar, Bart, Kopfbedeckung, Brille, Oberteile, Schal und
/// Unterteil-Kleid. Zubehör und Gegenstände bleiben weg.
bool _imPortraet(Teil t) {
  switch (t.art) {
    case 'frisur' || 'gesicht' || 'kopf' || 'oberteil':
      return true;
    default:
      return const {'brille', 'brille-stirn', 'schal', 'unterteil-kleid'}.contains(t.id);
  }
}

bool _frontLeiste(Grundkoerper g) =>
    g.knochen == 'rumpf' && g.material == 'darunter' && g.groesse[0] < 0.05 && g.groesse[2] < 0.03 && g.groesse[1] > 0.1;

/// Gesichtsmuster in Pixeln relativ zum Anker: Pupillen je Auge, Brauen über dem Auge, Mund in der Mitte.
/// Pupillen (Index 1) und Brauen/Mund (Index 0) sind die dunkelsten Töne: lesbar in Licht und Schatten.
class _Gesicht {
  final List<(int, int)> pupillen;
  final List<(int, int)> braueL;
  final List<(int, int)> braueR;
  final List<(int, int)> mund;
  const _Gesicht(this.pupillen, this.braueL, this.braueR, this.mund);
}

const Map<Ausdruck, _Gesicht> _gesichter = {
  // gerader Mund, ruhige Brauen, Augen 2×2
  Ausdruck.neutral: _Gesicht(
    [(0, 0), (1, 0), (0, 1), (1, 1)],
    [(-1, -3), (0, -3), (1, -3)],
    [(-1, -3), (0, -3), (1, -3)],
    [(-2, 0), (-1, 0), (0, 0), (1, 0), (2, 0)],
  ),
  // Mundwinkel hoch, Augen schmaler (2×1), Brauen leicht angehoben
  Ausdruck.freundlich: _Gesicht(
    [(0, 1), (1, 1)],
    [(-1, -4), (0, -4), (1, -4)],
    [(-1, -4), (0, -4), (1, -4)],
    [(-3, -1), (-2, 0), (-1, 1), (0, 1), (1, 1), (2, 0), (3, -1)],
  ),
  // eine Braue hoch, Blick zur Seite (Augen nach rechts versetzt), Mund schief
  Ausdruck.nachdenklich: _Gesicht(
    [(1, 0), (2, 0), (1, 1), (2, 1)],
    [(-1, -3), (0, -3), (1, -3)],
    [(-1, -5), (0, -5), (1, -5)],
    [(-2, 1), (-1, 1), (0, 0), (1, 0), (2, -1)],
  ),
  // große Augen (2×3), Brauen hoch, kleiner dunkler Mund (offen, kein Blut, keine Tränen)
  Ausdruck.erschrocken: _Gesicht(
    [(0, -1), (1, -1), (0, 0), (1, 0), (0, 1), (1, 1)],
    [(-1, -6), (0, -6), (1, -6)],
    [(-1, -6), (0, -6), (1, -6)],
    [(-1, 0), (0, 0), (-1, 1), (0, 1)],
  ),
};

/// Hals: Zylinder aus Haut vom Kinn bis in den Rumpf (verbindet Kopf und Oberkörper im Porträt).
const Teil _hals = Teil('hals', 'koerper', [Grundkoerper(Form.zylinder, 'kopf', [0, -0.12, -0.01], [0.04, 0.10, 0.04], 'haut')]);

/// Ein Porträt-Bild in vier Ausdrücken. [bibliothek] enthält alle Teile der Karte
/// (Grundbibliothek plus `teile_koepfe.json` und `teile_kleidung.json`); fehlt ein Teil, wirft die
/// Funktion einen [ArgumentError]. Deterministisch: gleiche Karte und Ausdruck ergeben gleiche Bytes.
SpriteImage portraet(Figurenkarte k, Ausdruck ausdruck, {Map<String, Teil>? bibliothek}) {
  final bib = bibliothek ?? kTeileBasis;
  final welt = _skelett(k, k.groesse / 1.75);
  final ansicht = _Ansicht.fuer(k, welt);
  final (pix, brille) = _koerper(k, bib, welt, ansicht);
  _gesicht(pix, brille, ansicht, _gesichter[ausdruck]!);
  return SpriteImage(kPortraetBreite, kPortraetHoehe, pix, footX: _fussX, footY: _fussY);
}

/// Kamera und Kopfgeometrie: Die Kopfmitte liegt in Pixelmitte (32, [_kopfMitteZeile]).
class _Ansicht {
  final Mat34 w; // Figur → Ansicht
  final Mat34 wi; // Ansicht → Figur
  final Mat34 kopf; // Kopfknochen im Figurenraum
  final double s; // Größenfaktor
  final double kf; // Kopfgrößenfaktor (Karte × Stilisierung)
  final double ppm; // Pixel je Meter
  final double vcx, vcy; // Kopfmitte im Ansichtsraum

  _Ansicht._(this.w, this.wi, this.kopf, this.s, this.kf, this.ppm, this.vcx, this.vcy);

  factory _Ansicht.fuer(Figurenkarte k, Map<String, Mat34> welt) {
    final s = k.groesse / 1.75;
    final kf = k.kopf * FigurBaker.kopfStil;
    final e = _erhebung, th = _gierung;
    final w = Mat34([1, 0, 0, 0, 0, math.cos(e), -math.sin(e), 0, 0, math.sin(e), math.cos(e), 0]) *
        Mat34([math.cos(th), 0, math.sin(th), 0, 0, 1, 0, 0, -math.sin(th), 0, math.cos(th), 0]);
    final kopf = welt['kopf']!;
    final sk = s * kf;
    final (cx, cy, cz) = kopf.punkt(_kopfK.mitte[0] * sk, _kopfK.mitte[1] * sk, _kopfK.mitte[2] * sk);
    final (vcx, vcy, _) = w.punkt(cx, cy, cz);
    final ppm = _kopfHoehePx / (2 * _kopfK.groesse[1] * sk);
    return _Ansicht._(w, w.invers(), kopf, s, kf, ppm, vcx, vcy);
  }

  /// Pixelkoordinate (vor dem Abrunden) eines Punkts im Ansichtsraum.
  (double, double) bild(double vx, double vy) => (32 + (vx - vcx) * ppm, _kopfMitteZeile - (vy - vcy) * ppm);

  /// Pixel eines Punkts auf der Vorderseite des Kopfes; (u, v) im Einheitsraum des Kopf-Ellipsoids
  /// (u nach rechts der Figur, v nach oben, vorne = positive Tiefe).
  (int, int) kopfPunkt(double u, double v) {
    final zf = math.sqrt(math.max(0.0, 1 - u * u - v * v));
    final sk = s * kf;
    final (x, y, z) = kopf.punkt(
      (_kopfK.mitte[0] + _kopfK.groesse[0] * u) * sk,
      (_kopfK.mitte[1] + _kopfK.groesse[1] * v) * sk,
      (_kopfK.mitte[2] + _kopfK.groesse[2] * zf) * sk,
    );
    final (vx, vy, _) = w.punkt(x, y, z);
    final (px, py) = bild(vx, vy);
    return (px.floor(), py.floor());
  }
}

/// Knochen in Figurenkoordinaten (Pose „stehen“, Bild 0, ohne Bodenausgleich).
Map<String, Mat34> _skelett(Figurenkarte k, double s) {
  final pose = kAnimationen['stehen']![0];
  final welt = <String, Mat34>{};
  for (final kn in kSkelett) {
    final d = pose.dreh[kn.name] ?? const [0.0, 0.0, 0.0];
    const rad = math.pi / 180;
    final bx = kn.eltern == 'rumpf' || kn.eltern == 'becken' ? k.breite : 1.0;
    final lokal = Mat34.verschiebung(kn.x * s * bx, kn.y * s + (kn.eltern == null ? pose.hebung : 0), kn.z * s) *
        Mat34.drehung(d[0] * rad, d[1] * rad, d[2] * rad);
    welt[kn.name] = kn.eltern == null ? lokal : welt[kn.eltern]! * lokal;
  }
  return welt;
}

/// Ein Körperteil (Grundkörper eines Teils) als Strahlwurf-Ziel.
class _Prim {
  final Mat34 inv; // Figur-Raum → Einheitskörper
  final Form form;
  final Material material;
  final bool brille; // Brillenglas-Rahmen: im Augenbereich heller (Pupillen bleiben lesbar)
  final double cx, cy, cz, r; // Begrenzungskugel im Figur-Raum
  _Prim(this.inv, this.form, this.material, this.brille, this.cx, this.cy, this.cz, this.r);
}

/// Körper ohne Gesicht: Strahlwurf auf die Teile, Schattierung in der Materialrampe mit
/// geordnetem Dithering, 1-px-Kontur in der dunkelsten Stufe der Rampe.
(Uint8List, Uint8List) _koerper(Figurenkarte k, Map<String, Teil> bib, Map<String, Mat34> welt, _Ansicht a) {
  final teile = <Teil>[kKoerper, _hals];
  for (final id in k.teile) {
    final t = bib[id] ?? (throw ArgumentError('Teil „$id“ fehlt'));
    if (_imPortraet(t)) teile.add(t);
  }
  final umleitung = <String, String>{};
  for (final t in teile) {
    umleitung.addAll(t.umleitung);
  }

  final prims = <_Prim>[];
  final s = a.s;
  for (final t in teile) {
    for (final g in t.koerper) {
      // Schmale helle Front-Leisten (Bluse unter der Strickjacke) wirken im Brustbild wie ein
      // Zettel (K9 §8) – im Porträt weglassen.
      if (_frontLeiste(g)) continue;
      if (!_sichtbar.contains(g.knochen)) continue;
      final b = welt[g.knochen]!;
      final istKopf = g.knochen == 'kopf';
      final kf = istKopf ? a.kf : 1.0;
      final istRumpf = g.knochen == 'rumpf';
      final bf = istRumpf ? k.breite * FigurBaker.rumpfStil : 1.0;
      final gl = !istKopf && !istRumpf ? FigurBaker.gliedStil : 1.0;
      const rad = math.pi / 180;
      final m = b *
          Mat34.verschiebung(g.mitte[0] * s * kf * bf, g.mitte[1] * s * kf, g.mitte[2] * s * kf) *
          Mat34.drehung(g.dreh[0] * rad, g.dreh[1] * rad, g.dreh[2] * rad) *
          Mat34.skalierung(
            g.groesse[0] * s * kf * bf * gl,
            g.groesse[1] * s * kf,
            g.groesse[2] * s * kf * gl * (bf > 1 ? (1 + (bf - 1) * 0.6) : 1),
          );
      final (cx, cy, cz) = m.punkt(0, 0, 0);
      var r = 0.0;
      for (final ax in const [(1.0, 0.0, 0.0), (0.0, 1.0, 0.0), (0.0, 0.0, 1.0)]) {
        final (x, y, z) = m.richtung(ax.$1, ax.$2, ax.$3);
        r = math.max(r, math.sqrt(x * x + y * y + z * z));
      }
      if (g.form != Form.ellipsoid) r *= math.sqrt(3);
      prims.add(_Prim(m.invers(), g.form, _material(g.material, k, umleitung), g.material == 'brille', cx, cy, cz, r * 1.001));
    }
  }

  const ww = kPortraetBreite, hh = kPortraetHoehe;
  const n = ww * hh;
  final tiefe = Float64List(n)..fillRange(0, n, double.infinity);
  final treffer = Int16List(n)..fillRange(0, n, -1);
  final lam = Float64List(n);
  final wi = a.wi;
  final (dfx, dfy, dfz) = wi.richtung(0, 0, -1);
  final (lx0, ly0, lz0) = _licht;
  final ll = math.sqrt(lx0 * lx0 + ly0 * ly0 + lz0 * lz0);
  final lx = lx0 / ll, ly = ly0 / ll, lz = lz0 / ll;

  for (var py = 0; py < hh; py++) {
    final vy = a.vcy + (_kopfMitteZeile - (py + 0.5)) / a.ppm;
    for (var px = 0; px < ww; px++) {
      final vx = a.vcx + (px + 0.5 - 32) / a.ppm;
      final (ox, oy, oz) = wi.punkt(vx, vy, 5);
      var bestT = double.infinity;
      var best = -1;
      var bnx = 0.0, bny = 0.0, bnz = 0.0;
      for (var j = 0; j < prims.length; j++) {
        final pr = prims[j];
        final qx = pr.cx - ox, qy = pr.cy - oy, qz = pr.cz - oz;
        final proj = qx * dfx + qy * dfy + qz * dfz;
        if (qx * qx + qy * qy + qz * qz - proj * proj > pr.r * pr.r) continue;
        final inv = pr.inv;
        final (ux, uy, uz) = inv.punkt(ox, oy, oz);
        final (rx, ry, rz) = inv.richtung(dfx, dfy, dfz);
        final hit = _schneide(pr.form, ux, uy, uz, rx, ry, rz);
        if (hit == null || hit.$1 >= bestT) continue;
        bestT = hit.$1;
        best = j;
        final (nx, ny, nz) = inv.normaleAusInverser(hit.$2, hit.$3, hit.$4);
        final (vnx, vny, vnz) = a.w.richtung(nx, ny, nz);
        final l = math.sqrt(vnx * vnx + vny * vny + vnz * vnz);
        bnx = vnx / l;
        bny = vny / l;
        bnz = vnz / l;
      }
      if (best < 0) continue;
      final i = py * ww + px;
      tiefe[i] = bestT;
      treffer[i] = best;
      lam[i] = bnx * lx + bny * ly + bnz * lz;
    }
  }

  final pix = Uint8List(n)..fillRange(0, n, kTransparent);
  final brille = Uint8List(n);
  const bayer = [0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5];
  for (var py = 0; py < hh; py++) {
    for (var px = 0; px < ww; px++) {
      final i = py * ww + px;
      final j = treffer[i];
      if (j < 0) continue;
      final mm = prims[j].material;
      brille[i] = prims[j].brille ? 1 : 0;
      var rand = false, innen = false;
      for (final (dx, dy) in const [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
        final x2 = px + dx, y2 = py + dy;
        // Bildrand: der Körper wird beschnitten, dort gibt es keine Kontur.
        if (x2 < 0 || y2 < 0 || x2 >= ww || y2 >= hh) continue;
        final q = y2 * ww + x2;
        if (treffer[q] < 0) {
          rand = true;
        } else if (tiefe[q] < tiefe[i] - 0.07) {
          innen = true;
        }
      }
      // Stufe als Fließkommazahl; geordnetes Dithering zwischen den Stufen (keine Verläufe).
      final c = mm.stufe + 3.0 * (lam[i] - 0.5);
      final schwelle = (bayer[(py & 3) * 4 + (px & 3)] + 0.5) / 16;
      final int idx;
      if (rand) {
        idx = Ramp.at(mm.rampe, 0);
      } else if (innen) {
        idx = Ramp.at(mm.rampe, (c - 2 + schwelle).floor());
      } else {
        idx = Ramp.at(mm.rampe, (c + schwelle).floor());
      }
      pix[i] = idx == 1 ? 2 : idx; // Index 1 ist den Augen vorbehalten
    }
  }
  return (pix, brille);
}

/// Material eines Grundkörpers mit Umleitungen und Ersatzregeln wie FigurBaker. Die Brille hat im
/// Porträt Stufe 3 statt der Standardstufe 1 (Index 1 bleibt den Augen).
Material _material(String name, Figurenkarte k, Map<String, String> umleitung) {
  var n = name;
  for (var i = 0; i < 8; i++) {
    final u = umleitung[n];
    if (u == null || u == n) break;
    n = u;
  }
  for (var i = 0; i < 8 && !k.materialien.containsKey(n) && !kMaterialStandard.containsKey(n); i++) {
    final e = kMaterialErsatz[n];
    if (e == null) break;
    n = e;
  }
  return k.materialien[n] ??
      (n == 'brille' ? const Material(Ramp.neutral, 3) : kMaterialStandard[n]) ??
      const Material(Ramp.neutral, 4);
}

/// Gesicht: Pupillen (Index 1), Brauen und Mund (Index 0). Die Linien bleiben auch im Schatten der
/// rechten Gesichtshälfte lesbar; abgedunkelte Hauttöne würden dort verschwinden.
void _gesicht(Uint8List pix, Uint8List brille, _Ansicht a, _Gesicht g) {
  for (final u in const [-0.38, 0.38]) {
    final (ax, ay) = a.kopfPunkt(u, 0.07);
    // Brillenrahmen um das Auge werden hell (Glanz): dunkle Pupillen bleiben lesbar.
    for (var dy = -2; dy <= 2; dy++) {
      for (var dx = -2; dx <= 3; dx++) {
        final x = ax + dx, y = ay + dy;
        if (x < 0 || y < 0 || x >= kPortraetBreite || y >= kPortraetHoehe) continue;
        final i = y * kPortraetBreite + x;
        if (brille[i] == 1 && pix[i] != kTransparent) pix[i] = Ramp.at(Ramp.neutral, 6);
      }
    }
    for (final (dx, dy) in g.pupillen) {
      _tupfen(pix, ax + dx, ay + dy, (_) => 1);
    }
    for (final (dx, dy) in u < 0 ? g.braueL : g.braueR) {
      _tupfen(pix, ax + dx, ay + dy, (_) => 0);
    }
  }
  final (mx, my) = a.kopfPunkt(0, -0.45);
  for (final (dx, dy) in g.mund) {
    _tupfen(pix, mx + dx, my + dy, (_) => 0);
  }
}

void _tupfen(Uint8List pix, int x, int y, int Function(int alt) neu) {
  if (x < 0 || y < 0 || x >= kPortraetBreite || y >= kPortraetHoehe) return;
  final i = y * kPortraetBreite + x;
  if (pix[i] == kTransparent) return;
  pix[i] = neu(pix[i]);
}

/// Schnitt mit dem Einheitskörper; liefert (t, nx, ny, nz) im Einheitsraum.
(double, double, double, double)? _schneide(Form f, double ox, double oy, double oz, double dx, double dy, double dz) {
  switch (f) {
    case Form.ellipsoid:
      final a = dx * dx + dy * dy + dz * dz;
      final b = 2 * (ox * dx + oy * dy + oz * dz);
      final c = ox * ox + oy * oy + oz * oz - 1;
      final disk = b * b - 4 * a * c;
      if (disk < 0) return null;
      final t = (-b - math.sqrt(disk)) / (2 * a);
      if (t < 0) return null;
      return (t, ox + t * dx, oy + t * dy, oz + t * dz);
    case Form.quader:
      var tmin = -double.infinity, tmax = double.infinity;
      var achse = 0;
      var vorz = 1.0;
      final o = [ox, oy, oz], d = [dx, dy, dz];
      for (var k = 0; k < 3; k++) {
        if (d[k].abs() < 1e-12) {
          if (o[k] < -1 || o[k] > 1) return null;
          continue;
        }
        var t1 = (-1 - o[k]) / d[k], t2 = (1 - o[k]) / d[k];
        var s = -1.0;
        if (t1 > t2) {
          final tmp = t1;
          t1 = t2;
          t2 = tmp;
          s = 1.0;
        }
        if (t1 > tmin) {
          tmin = t1;
          achse = k;
          vorz = s;
        }
        if (t2 < tmax) tmax = t2;
        if (tmin > tmax) return null;
      }
      if (tmin < 0) return null;
      return (tmin, achse == 0 ? vorz : 0, achse == 1 ? vorz : 0, achse == 2 ? vorz : 0);
    case Form.zylinder:
      double? best;
      var nx = 0.0, ny = 0.0, nz = 0.0;
      final a = dx * dx + dz * dz;
      if (a > 1e-12) {
        final b = 2 * (ox * dx + oz * dz);
        final c = ox * ox + oz * oz - 1;
        final disk = b * b - 4 * a * c;
        if (disk >= 0) {
          final t = (-b - math.sqrt(disk)) / (2 * a);
          final y = oy + t * dy;
          if (t >= 0 && y >= -1 && y <= 1) {
            best = t;
            nx = ox + t * dx;
            nz = oz + t * dz;
          }
        }
      }
      if (dy.abs() > 1e-12) {
        for (final cap in const [-1.0, 1.0]) {
          final t = (cap - oy) / dy;
          if (t < 0 || (best != null && t >= best)) continue;
          final x = ox + t * dx, z = oz + t * dz;
          if (x * x + z * z <= 1) {
            best = t;
            nx = 0;
            ny = cap;
            nz = 0;
          }
        }
      }
      return best == null ? null : (best, nx, ny, nz);
  }
}

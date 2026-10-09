import 'dart:math' as math;
import 'dart:typed_data';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Fledermaus-Schwarm über der Oberstadt (Auftrag A-306a).
///
/// Drei Gruppen kreisen über Burgberg, Marktplatz und Kirchhügel in 8–18 m Höhe
/// (Grundhöhe 10–14 m, leichtes Flattern). Ein Tier wechselt gelegentlich die
/// Gruppe. Alles ist deterministisch aus [seed]: gleicher Seed und gleiche
/// Zeitschritte ergeben gleiche Positionen.
///
/// Schnittstelle: [tick] und [zeichne] nur aufrufen, wenn [sichtbarIn] gilt
/// (draußen, Bereich `stadt`). Gezeichnet werden höchstens [kMaxSprites] Billboards.
class Fledermaeuse {
  /// Höchstzahl der Sprites je Bild (Kostenbudget).
  static const int kMaxSprites = 12;

  /// Die drei Flügelbilder: 0 = oben, 1 = mitte, 2 = unten. Je 9×5 Texel, Fußpunkt Mitte.
  static final List<SpriteImage> bilder = [
    _malen(const ['o.......o', 'oo.ooo.oo', '.ooooooo.', '...ooo...', '....o....']),
    _malen(const ['.o.....o.', 'oo.ooo.oo', 'ooooooooo', '...ooo...', '....o....']),
    _malen(const ['...o.o...', '.ooooooo.', 'oo.ooo.oo', 'o.ooooo.o', '....o....']),
  ];

  /// Flügelfolge je Schlagzyklus: mitte, oben, mitte, unten.
  static const List<int> _folge = [1, 0, 1, 2];

  /// Bereich, in dem die Tiere fliegen. Außerhalb der Karte (`' '`) und auf der Mauer (`'#'`) fliegt niemand.
  final Bereich stadt;

  /// Gruppen: Mittelpunkt (x, z) in Metern und Bahnradius, der in die Stadt passt.
  final List<(double, double, double)> _gruppen;
  final Zufall _zufall;
  final List<_Tier> _tiere = [];
  double _zeit = 0;

  Fledermaeuse(this.stadt, {int seed = 3, int anzahl = 9})
      : _gruppen = _gruppenFuer(stadt),
        _zufall = Zufall(seed) {
    for (var i = 0; i < 16; i++) {
      _zufall.naechste(); // Anlauf: die ersten Werte eines kleinen Seeds sind noch schwach
    }
    final n = math.min(math.max(anzahl, 0), kMaxSprites);
    for (var i = 0; i < n; i++) {
      final g = i % _gruppen.length;
      final t = _Tier(
        gruppe: g,
        phase: _zufall.kommazahl() * 2 * math.pi,
        radius: _gruppen[g].$3 * (0.8 + 0.2 * _zufall.kommazahl()),
        elly: 0.8 + 0.2 * _zufall.kommazahl(),
        omega: (_zufall.chance(0.5) ? 1.0 : -1.0) * (0.22 + 0.14 * _zufall.kommazahl()),
        hoehe: 10.0 + 4.0 * _zufall.kommazahl(),
        flatter: _zufall.kommazahl() * 2 * math.pi,
        takt: 1.1 + 0.3 * _zufall.kommazahl(),
        flug: _zufall.kommazahl(),
        wechselBei: 20.0 + 25.0 * _zufall.kommazahl(),
      );
      _tiere.add(t);
      _bahn(t);
      t.x = t.ox;
      t.y = t.oy;
      t.z = t.oz;
    }
  }

  /// Anzahl der Tiere (höchstens [kMaxSprites]).
  int get anzahl => _tiere.length;

  /// Aktuelle Orte (Meter: x Osten, y Höhe, z Süden). Für Tests und Werkzeuge.
  List<(double, double, double)> get orte => [for (final t in _tiere) (t.x, t.y, t.z)];

  /// Gilt der Schwarm hier? Nur draußen (`innen == false`) im Bereich [stadt].
  bool sichtbarIn(Bereich aktuell) => !aktuell.innen && aktuell.id == stadt.id;

  /// Ein Zeitschritt: Bahnen, Flattern, Flügelschlag, Gruppenwechsel.
  void tick(double dt) {
    _zeit += dt;
    for (final t in _tiere) {
      t.phase = (t.phase + t.omega * dt) % (2 * math.pi);
      t.flug = (t.flug + dt * t.takt) % 1;
      if (_zeit >= t.wechselBei) _wechseln(t);
      if (t.uebergang < 1) t.uebergang = math.min(1.0, t.uebergang + dt / _uebergangS);
      _bahn(t);
      var nx = t.ox, ny = t.oy, nz = t.oz;
      if (t.uebergang < 1) {
        final s = t.uebergang * t.uebergang * (3.0 - 2.0 * t.uebergang); // Glättung (Smoothstep)
        nx = t.vonX + (nx - t.vonX) * s;
        ny = t.vonY + (ny - t.vonY) * s;
        nz = t.vonZ + (nz - t.vonZ) * s;
      }
      if (_innen(nx, nz)) {
        t.x = nx;
        t.y = ny;
        t.z = nz;
      } else {
        // An der Stadtgrenze: wenden, an der letzten gültigen Stelle bleiben.
        t.omega = -t.omega;
        t.uebergang = 1;
      }
      t.bild = _folge[(t.flug * 4).floor()];
    }
  }

  /// Zeichnet die Tiere als Billboards. Nach den Meshes des Bereichs aufrufen (Tiefentest).
  void zeichne(Renderer r) {
    for (final t in _tiere) {
      // Mondlicht (Kaltlicht 0,6), damit die dunklen Tiere gegen den Nachthimmel lesbar bleiben.
      r.drawSprite(bilder[t.bild], t.x, t.y, t.z, cold: 0.6);
    }
  }

  /// Zielort auf der Bahn der Gruppe (Ort + Flattern) zum Zeitpunkt [_zeit].
  void _bahn(_Tier t) {
    final (gx, gz, _) = _gruppen[t.gruppe];
    final f = t.flatter, zt = _zeit;
    t.ox = gx + t.radius * math.cos(t.phase) + 0.35 * math.sin(3.1 * zt + f);
    t.oz = gz + t.radius * t.elly * math.sin(t.phase) + 0.3 * math.sin(2.3 * zt + 1.7 * f);
    t.oy = t.hoehe + 0.7 * math.sin(0.9 * zt + f) + 0.2 * math.sin(7 * zt + 2 * f);
  }

  /// Wechsel in eine andere Gruppe: sanfter Übergang über [_uebergangS] Sekunden.
  void _wechseln(_Tier t) {
    final n = _gruppen.length;
    if (n < 2) return;
    t.gruppe = (t.gruppe + 1 + _zufall.ganz(n - 1)) % n;
    t.vonX = t.x;
    t.vonY = t.y;
    t.vonZ = t.z;
    t.uebergang = 0;
    t.wechselBei = _zeit + 25.0 + 20.0 * _zufall.kommazahl();
  }

  /// Liegt der Kachelpunkt (x, z) innerhalb der Stadt (nicht außerhalb, nicht auf der Mauer)?
  bool _innen(double x, double z) => _innenIn(stadt, x, z);
}

/// Größter Bahnradius (Meter) und Dauer eines Gruppenwechsels (Sekunden).
const double _bahnRadius = 8.5;
const double _uebergangS = 9;

/// Drei Gruppen über Burgberg, Marktplatz und Kirchhügel: Mittelpunkt aus Marken des
/// Bereichs, sonst aus der Bereichsmitte. Der Radius wird so klein wie nötig, bis die
/// Bahn samt Flatterrand in der Stadt liegt.
List<(double, double, double)> _gruppenFuer(Bereich stadt) {
  final mx = stadt.breite * kKachel / 2, mz = stadt.tiefe * kKachel / 2;
  (double, double) marke(String id, (double, double) sonst) => stadt.marken.containsKey(id) ? stadt.markePos(id) : sonst;
  final (bx, bz) = marke('b', (mx, 0.0)); // Burgtor im Norden
  final markt = marke('tuer-innen-uhrturm', (mx, mz)); // Uhrturm auf dem Marktplatz
  final kirche = marke('tuer-innen-kirche', (mx / 2, mz)); // Kirchentür im Westen
  final mitten = [((bx + mx) / 2, (bz + mz) / 2), markt, kirche]; // Burgberg: halbwegs Burgtor–Mitte
  return [for (final (x, z) in mitten) (x, z, _passenderRadius(stadt, x, z))];
}

/// Größter Radius bis [_bahnRadius], bei dem der Kreis um (gx, gz) mit 1 m Flatterrand
/// in der Stadt liegt. Nötigenfalls 0,5 m.
double _passenderRadius(Bereich stadt, double gx, double gz) {
  for (var r = _bahnRadius; r >= 0.5; r -= 0.5) {
    var passt = true;
    for (var k = 0; k < 24 && passt; k++) {
      final a = 2 * math.pi * k / 24;
      passt = _innenIn(stadt, gx + (r + 1) * math.cos(a), gz + (r + 1) * math.sin(a));
    }
    if (passt) return r;
  }
  return 0.5;
}

/// Liegt der Ort (x, z) in Metern innerhalb der Stadt? Außen ist `' '`, die Mauer `'#'`.
bool _innenIn(Bereich stadt, double x, double z) {
  final c = stadt.zeichen((x / kKachel).floor(), (z / kKachel).floor());
  return c != ' ' && c != '#';
}

/// Ein Tier: Gruppe, Bahn und Zustand (alles veränderbar, damit tick ohne Neuanlage läuft).
class _Tier {
  _Tier({
    required this.gruppe,
    required this.phase,
    required this.radius,
    required this.elly,
    required this.omega,
    required this.hoehe,
    required this.flatter,
    required this.takt,
    required this.flug,
    required this.wechselBei,
  });

  int gruppe;
  double phase, radius, elly, omega, hoehe, flatter, takt, flug, wechselBei;

  /// Ziel auf der Bahn der Gruppe, vor dem Übergang.
  double ox = 0, oy = 0, oz = 0;

  /// Aktuelle Position.
  double x = 0, y = 0, z = 0;

  /// Ort zu Beginn des Gruppenwechsels.
  double vonX = 0, vonY = 0, vonZ = 0;

  /// Fortschritt des Übergangs: 0..1, 1 = auf der Bahn.
  double uebergang = 1;

  /// Index in [Fledermaeuse.bilder].
  int bild = 1;
}

/// Malt ein Flügelbild: `o` = Tier, `.` = durchsichtig. Die 1-px-Kontur liegt am Rand der
/// Silhouette (Stufe 3 der neutralen Rampe), der Körper in Stufe 5. Die Kontur bleibt dunkler
/// als der Körper; so bleibt in den Mip-Stufen der Ferne ein sichtbarer Ton gegen den
/// Nachthimmel übrig (die Mip-Bildung nimmt stets den dunkelsten Bildpunkt).
SpriteImage _malen(List<String> zeilen) {
  final h = zeilen.length, w = zeilen.first.length;
  bool tier(int x, int y) => x >= 0 && y >= 0 && x < w && y < h && zeilen[y][x] == 'o';
  final pix = Uint8List(w * h);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      if (!tier(x, y)) {
        pix[y * w + x] = kTransparent;
        continue;
      }
      final rand = !tier(x - 1, y) || !tier(x + 1, y) || !tier(x, y - 1) || !tier(x, y + 1);
      pix[y * w + x] = Ramp.at(Ramp.neutral, rand ? 3 : 5);
    }
  }
  return SpriteImage(w, h, pix, footX: 4, footY: 2);
}

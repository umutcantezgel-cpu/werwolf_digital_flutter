import 'dart:math' as math;
import 'dart:typed_data';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

import '../spiel.dart';
import 'erkundung.dart';

/// Stadtkarte der Oberstadt: Draufsicht (1 Kachel = 0,5 m) mit eigener Lage als Pfeil,
/// besuchten Häusern in Farbe und unbesuchten Fall-Orten nur als „?“. Ein Tipp auf einen
/// besuchten Fall-Ort ruft [reise] mit dessen Marke vor der Haustür und schließt die Karte.
class StadtkarteBildschirm extends Bildschirm {
  final Erkundung erk;

  /// Schnellreise: die Erkundung steht danach auf dieser Marke im Bereich `stadt`
  /// (z. B. `vor-H-027`).
  final void Function(String marke) reise;

  StadtkarteBildschirm(this.erk, {required this.reise});

  _Modell? _modellCache;
  Welt? _modellWelt;
  List<Map<String, dynamic>>? _modellHaeuser;

  @override
  bool get zeigtWelt => false;

  /// Tastatur/Gamepad: gewählter besuchter Fall-Ort (Index in [_ziele]); −1 = keine Auswahl.
  int _wahl = -1;

  List<_Haus> _ziele(Spiel spiel) {
    final m = _modell(spiel);
    if (m == null) return const [];
    return [for (final x in m.haeuser) if (x.fallOrt && x.marke != null && _besucht(spiel, x)) x];
  }

  @override
  void tick(Spiel spiel, double dt, Eingabe e) {
    if (e.gedrueckt(Taste.karte) || e.gedrueckt(Taste.menue) || e.gedrueckt(Taste.zurueck)) {
      spiel.schliesse();
      return;
    }
    // Pfeile/Steuerkreuz wählen einen besuchten Fall-Ort, Bestätigen reist dorthin
    final ziele = _ziele(spiel);
    if (ziele.isEmpty) return;
    final vor = e.gedrueckt(Taste.runter) || e.gedrueckt(Taste.rechts) || e.gedrueckt(Taste.drehRechts);
    final zurueck = e.gedrueckt(Taste.hoch) || e.gedrueckt(Taste.links) || e.gedrueckt(Taste.drehLinks);
    if (vor) _wahl = (_wahl + 1) % ziele.length;
    if (zurueck) _wahl = (_wahl - 1 + ziele.length) % ziele.length;
    if (e.gedrueckt(Taste.bestaetigen) && _wahl >= 0 && _wahl < ziele.length) {
      reise(ziele[_wahl].marke!);
      if (identical(spiel.bildschirm, this)) spiel.schliesse();
    }
  }

  /// Kartenmodell, einmal je Welt aufgebaut.
  _Modell? _modell(Spiel spiel) {
    if (!identical(_modellWelt, spiel.stadt) || !identical(_modellHaeuser, spiel.haeuserDaten)) {
      _modellWelt = spiel.stadt;
      _modellHaeuser = spiel.haeuserDaten;
      _modellCache = _Modell.baue(spiel.stadt, spiel.haeuserDaten);
    }
    return _modellCache;
  }

  bool _besucht(Spiel spiel, _Haus h) => h.innen != null && spiel.besucht.contains(h.innen);

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    final p = Rechteck(6, 6, w - 12, h - 12);
    ui.panel(p, grund: UiFarbe.grundDunkel);
    ui.text('Stadtkarte', p.x + 6, p.y + 4, farbe: UiFarbe.akzent);
    final m = _modell(spiel);
    final fallOrte = m == null ? const <_Haus>[] : [for (final x in m.haeuser) if (x.fallOrt) x];
    final besuchte = fallOrte.where((x) => _besucht(spiel, x)).length;
    final kopf = '$besuchte von ${fallOrte.length} Fall-Orten besucht';
    ui.text(kopf, p.rechts - ui.font.measure(kopf) - 6, p.y + 4, farbe: UiFarbe.textGedimmt);
    final zurueck = ui.knopf(Rechteck(p.rechts - 66, p.unten - 19, 60, 15), 'Zurück');
    _Layout? l;
    if (m == null) {
      ui.absatz('Die Oberstadt ist nicht geladen.', Rechteck(p.x + 6, p.y + 20, p.w - 12, 30));
    } else {
      // Erklärung unten (umbrochen, an der Knopfzeile ausgerichtet), darüber die Karte.
      final erklaerung = ui.font.wrap(_erklaerung, p.w - 90);
      final y0 = p.unten - 4 - erklaerung.length * ui.zeilenHoehe;
      l = _Layout.fuer(m.w, m.h, Rechteck(p.x + 4, p.y + 16, p.w - 8, y0 - 2 - (p.y + 16)));
      _zeichneKarte(ui, spiel, m, l, fallOrte);
      final ziele = _ziele(spiel);
      if (_wahl >= 0 && _wahl < ziele.length) {
        final x = ziele[_wahl];
        final r = l.rechteck(x.x0, x.z0, x.x1, x.z1);
        ui.rahmen(Rechteck(r.x - 3, r.y - 3, r.w + 6, r.h + 6), UiFarbe.akzent);
        final name = '${x.ort}: Bestätigen reist hin';
        ui.text(name, p.x + 6, p.y + 4 + ui.zeilenHoehe, farbe: UiFarbe.akzent);
      }
      for (var i = 0; i < erklaerung.length; i++) {
        ui.text(erklaerung[i], p.x + 6, y0 + i * ui.zeilenHoehe, farbe: UiFarbe.textGedimmt);
      }
    }
    if (zurueck) {
      spiel.schliesse();
      return;
    }
    if (l != null && _tippen(ui, spiel, fallOrte, l)) return;
  }

  void _zeichneKarte(PixelUi ui, Spiel spiel, _Modell m, _Layout l, List<_Haus> fallOrte) {
    final farbeHaus = [for (final x in m.haeuser) _hausFarbe(_besucht(spiel, x), x.fallOrt)];
    _zeichneGelaende(ui, m, l, farbeHaus);
    _zeichneViertel(ui, l);
    for (final x in fallOrte) {
      if (_besucht(spiel, x)) continue;
      final r = l.rechteck(x.x0, x.z0, x.x1, x.z1);
      ui.textMittig('?', r.x + r.w ~/ 2, r.y + r.h ~/ 2 - 5);
    }
    _zeichneLage(ui, m, l);
  }

  /// Tippen auf einen besuchten Fall-Ort: Schnellreise. True, wenn gesprungen wurde.
  bool _tippen(PixelUi ui, Spiel spiel, List<_Haus> fallOrte, _Layout l) {
    for (final x in fallOrte) {
      final marke = x.marke;
      if (marke == null || !_besucht(spiel, x)) continue;
      final r = l.rechteck(x.x0, x.z0, x.x1, x.z1);
      // etwas größer als das Haus, damit man es mit dem Finger trifft
      if (ui.tippflaeche(Rechteck(r.x - 3, r.y - 3, r.w + 6, r.h + 6))) {
        reise(marke);
        // Schließen nur, wenn der Rückruf den Bildschirm nicht schon gewechselt hat.
        if (identical(spiel.bildschirm, this)) spiel.schliesse();
        return true;
      }
    }
    return false;
  }

  int _hausFarbe(bool besucht, bool fallOrt) => switch ((besucht, fallOrt)) {
        (true, true) => _Farbe.fallOrtBesucht,
        (true, false) => _Farbe.besucht,
        _ => _Farbe.haus,
      };

  /// Gelände und Häuser Kachel für Kachel, ganzzahlig eingepasst, nur Palettenfarben.
  void _zeichneGelaende(PixelUi ui, _Modell m, _Layout l, List<int> farbeHaus) {
    final fb = ui.fb;
    final breite = fb.width;
    if (l.ox < 0 || l.oy < 0) return;
    for (var j = 0; j < l.pxH; j++) {
      final cz = math.min(m.h - 1, (j * l.n + l.n ~/ 2) ~/ l.s);
      final zeile = (l.oy + j) * breite + l.ox;
      for (var i = 0; i < l.pxW; i++) {
        final cx = math.min(m.w - 1, (i * l.n + l.n ~/ 2) ~/ l.s);
        final c = cz * m.w + cx;
        final hi = m.hausAt[c];
        fb.color[zeile + i] = hi >= 0 && m.grund[c] == _Farbe.haus ? farbeHaus[hi] : m.grund[c];
      }
    }
  }

  /// Viertelnamen an festen Stellen der Oberstadt; überlappende rücken eine Zeile weiter.
  void _zeichneViertel(PixelUi ui, _Layout l) {
    final belegt = <Rechteck>[];
    for (final (name, kx, kz) in _viertelNamen) {
      final tw = ui.font.measure(name);
      final cx = l.pxX(kx), cy = l.pxY(kz) - ui.font.height ~/ 2;
      for (final zeilen in const [0, 1, -1, 2, -2]) {
        final r = Rechteck(cx - tw ~/ 2 - 1, cy + zeilen * ui.zeilenHoehe, tw + 2, ui.font.height + 1);
        if (belegt.any((b) => _ueberlappt(b, r))) continue;
        ui.text(name, cx - tw ~/ 2, r.y);
        belegt.add(r);
        break;
      }
    }
  }

  /// Eigene Lage: in der Oberstadt der Standort, in einem Haus dessen Fußabdruck; sonst kein Pfeil.
  void _zeichneLage(PixelUi ui, _Modell m, _Layout l) {
    double kx, kz;
    if (erk.ort == 'stadt') {
      kx = erk.x / kKachel;
      kz = erk.z / kKachel;
    } else {
      final haus = m.nachInnen[erk.ort];
      if (haus == null) return;
      kx = haus.mx;
      kz = haus.mz;
    }
    _pfeil(ui, l.pxX(kx), l.pxY(kz), erk.yaw);
  }
}

/// Palettenfarben der Karte (nur Palettenindizes).
abstract final class _Farbe {
  static final aussen = Ramp.at(Ramp.blue, 1);
  static final gasse = Ramp.at(Ramp.stone, 6);
  static final haus = Ramp.at(Ramp.stone, 2);
  static final mauer = Pal.ember;
  static final garten = Ramp.at(Ramp.green, 2);
  static final tuer = Ramp.at(Ramp.wood, 6);
  static final holz = Ramp.at(Ramp.wood, 4);
  static final wasser = Ramp.at(Ramp.blue, 5);
  static final stein = Ramp.at(Ramp.stone, 4);
  static final besucht = Ramp.at(Ramp.amber, 3);
  static final fallOrtBesucht = Pal.candleLight;
  static final lage = Pal.white;
  static final umriss = Pal.black;
}

const _erklaerung = 'Gold: besuchter Fall-Ort · Ocker: besuchtes Haus · ?: unbekannter Fall-Ort · '
    'Pfeil: du · Tippen auf Gold: Schnellreise';

/// Viertelnamen an festen Stellen der Oberstadt (Kachelkoordinaten, Mitte); die Lage folgt
/// der Zonen-Einteilung des Stadtgenerators (Burgberg im Norden, Mauerviertel am Ring …).
const _viertelNamen = <(String, double, double)>[
  ('Burgberg', 160.0, 56.0),
  ('Kirchhügel', 80.0, 112.0),
  ('Marktviertel', 160.0, 118.0),
  ('Handwerkergasse', 252.0, 128.0),
  ('Mauerviertel', 280.0, 176.0),
  ('Untere Stadt', 160.0, 214.0),
];

/// Ein Haus-Fußabdruck der Oberstadt mit seinen Bezügen zu Haus-Daten und Innenraum.
class _Haus {
  final int x0, z0, x1, z1;
  final String? id, ort, innen;
  const _Haus(this.x0, this.z0, this.x1, this.z1, {this.id, this.ort, this.innen});

  /// Fall-Ort: Haus mit `ort`-Eintrag (ORT-01 … ORT-12).
  bool get fallOrt => ort != null;

  /// Marke vor der Haustür (Bereich `stadt`), Ziel der Schnellreise.
  String? get marke => id == null ? null : 'vor-$id';

  double get mx => (x0 + x1 + 1) / 2;
  double get mz => (z0 + z1 + 1) / 2;
}

/// Kartenmodell der Oberstadt: Gelände je Kachel, Haus-Zuordnung je Kachel, Häuser mit
/// Fall-Ort- und Innenraum-Bezug.
class _Modell {
  final int w, h;
  final Uint8List grund;
  final Int32List hausAt;
  final List<_Haus> haeuser;
  final Map<String, _Haus> nachInnen;

  _Modell._(this.w, this.h, this.grund, this.hausAt, this.haeuser, this.nachInnen);

  /// Baut das Modell aus dem Bereich `stadt`. Die Haus-Marke `vor-<Haus-ID>` liegt vor der
  /// Tür; die Tür (Zeichen `D`) liegt im Fußabdruck des Hauses und die Innenraum-Marke
  /// `tuer-<Bereich>` an derselben Stelle wie `vor-<Haus-ID>`.
  static _Modell? baue(Welt welt, List<Map<String, dynamic>> haeuserDaten) {
    final s = welt.bereiche['stadt'];
    if (s == null) return null;
    final w = s.breite, h = s.tiefe;

    // Gebäude-Fußabdrücke (Haus und Uhrturm) und ihre Kachel-Zuordnung
    final fps = [for (final d in s.dinge) if (d.legende.form == 'haus' || d.legende.form == 'turm') d];
    final hausAt = Int32List(w * h)..fillRange(0, w * h, -1);
    for (var i = 0; i < fps.length; i++) {
      final d = fps[i];
      for (var z = d.z0; z <= d.z1; z++) {
        for (var x = d.x0; x <= d.x1; x++) {
          hausAt[z * w + x] = i;
        }
      }
    }

    // Innenraum-Marken: Position → Bereichs-ID
    final tuerPos = <(int, int), String>{
      for (final e in s.marken.entries)
        if (e.key.startsWith('tuer-')) e.value: e.key.substring(5),
    };

    // Haus-ID je Fußabdruck: die Tür im Fußabdruck liegt neben der Marke vor dem Haus.
    final daten = {for (final x in haeuserDaten) x['id'] as String: x};
    final ids = List<String?>.filled(fps.length, null);
    for (final e in s.marken.entries) {
      if (!e.key.startsWith('vor-')) continue;
      final (mx, mz) = e.value;
      for (final (dx, dz) in const [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
        final nx = mx + dx, nz = mz + dz;
        if (nx < 0 || nz < 0 || nx >= w || nz >= h || s.zeichen(nx, nz) != 'D') continue;
        final i = hausAt[nz * w + nx];
        if (i >= 0 && ids[i] == null) {
          ids[i] = e.key.substring(4);
          break;
        }
      }
    }

    final haeuser = <_Haus>[];
    final nachInnen = <String, _Haus>{};
    for (var i = 0; i < fps.length; i++) {
      final d = fps[i];
      final id = ids[i];
      final haus = id == null ? null : daten[id];
      final innen = id == null ? null : tuerPos[s.marken['vor-$id']!];
      final ha = _Haus(d.x0, d.z0, d.x1, d.z1, id: id, ort: haus?['ort'] as String?, innen: innen);
      haeuser.add(ha);
      if (innen != null) nachInnen[innen] = ha;
    }

    // Gelände je Kachel (Häuser bekommen ihre Farbe erst beim Zeichnen)
    final grund = Uint8List(w * h);
    for (var z = 0; z < h; z++) {
      for (var x = 0; x < w; x++) {
        grund[z * w + x] = switch (s.zeichen(x, z)) {
          ' ' => _Farbe.aussen,
          '#' => _Farbe.mauer,
          'G' => _Farbe.garten,
          'D' => _Farbe.tuer,
          'L' => _Farbe.holz,
          'O' => s.dingAn(x, z)?.legende.form == 'brunnen' ? _Farbe.wasser : _Farbe.stein,
          'H' || 'K' || 'U' => _Farbe.haus,
          _ => _Farbe.gasse,
        };
      }
    }
    return _Modell._(w, h, grund, hausAt, haeuser, nachInnen);
  }
}

/// Einpassung der Karte in eine Fläche: ganzzahliger Maßstab [s] (UI-Pixel je Kachel) oder,
/// wenn die Karte so nicht passt, [n] Kacheln je UI-Pixel.
class _Layout {
  final int s, n, ox, oy, pxW, pxH;
  const _Layout._(this.s, this.n, this.ox, this.oy, this.pxW, this.pxH);

  factory _Layout.fuer(int w, int h, Rechteck f) {
    final fw = math.max(1, f.w), fh = math.max(1, f.h);
    var s = math.min(fw ~/ w, fh ~/ h);
    var n = 1;
    if (s < 1) {
      s = 1;
      n = math.max((w + fw - 1) ~/ fw, (h + fh - 1) ~/ fh);
    }
    final pxW = (w * s + n - 1) ~/ n, pxH = (h * s + n - 1) ~/ n;
    return _Layout._(s, n, f.x + (f.w - pxW) ~/ 2, f.y + (f.h - pxH) ~/ 2, pxW, pxH);
  }

  /// UI-Spalte einer Kachel-Koordinate (Kommastellen erlaubt).
  int pxX(double kx) => ox + (kx * s / n).floor();

  /// UI-Zeile einer Kachel-Koordinate (Kommastellen erlaubt).
  int pxY(double kz) => oy + (kz * s / n).floor();

  /// UI-Rechteck eines Kachelbereichs (Grenzen inklusive).
  Rechteck rechteck(int x0, int z0, int x1, int z1) {
    final a = ox + (x0 * s) ~/ n, b = oy + (z0 * s) ~/ n;
    final c = ox + ((x1 + 1) * s - 1) ~/ n, d = oy + ((z1 + 1) * s - 1) ~/ n;
    return Rechteck(a, b, c - a + 1, d - b + 1);
  }
}

bool _ueberlappt(Rechteck a, Rechteck b) => a.x < b.rechts && b.x < a.rechts && a.y < b.unten && b.y < a.unten;

/// Pfeil in Blickrichtung [yaw] (8 Richtungen), Spitze bei (x, y), dunkler Umriss.
void _pfeil(PixelUi ui, int x, int y, double yaw) {
  const richtungen = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)];
  final (dx, dy) = richtungen[(yaw / (math.pi / 4)).round() % 8];
  const spitze = 5;
  final schaft = [for (var k = 0; k <= spitze; k++) (k * dx, k * dy)];
  final bx = (spitze - 1) * dx, by = (spitze - 1) * dy;
  final alle = [...schaft, (bx - dy, by + dx), (bx + dy, by - dx)];
  for (final (px, py) in alle) {
    for (final (ox, oy) in const [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
      ui.fb.set(x + px + ox, y + py + oy, _Farbe.umriss);
    }
  }
  for (final (px, py) in alle) {
    ui.fb.set(x + px, y + py, _Farbe.lage);
  }
}

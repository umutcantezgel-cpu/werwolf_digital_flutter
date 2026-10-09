import 'dart:math' as math;

import 'package:pixel_engine/pixel_engine.dart';

import '../form.dart';

/// Bank (Burgstadt HD, P4-AUTOR-03, HZ-07). Drei Bauarten nach Höhe: Sitzbank ohne Lehne (≤ 0,55 m),
/// Sägebock (0,55 bis 0,85 m), Bankreihe mit Lehne (≥ 0,85 m). Die Längsrichtung ist die längere Seite
/// der Grundfläche (Achse L), die andere Seite ist die Querachse S.
///
/// Rahmen-Koordinaten: u entlang L, d = Abstand von der Rückseite (d = 0 an der Wand, d = Tiefe vorn),
/// y Höhe. Alle Maße in Metern. Nur die Textur `o.textur` wird verwendet.
class BankForm implements Moebelform {
  const BankForm();

  @override
  String get name => 'bank';

  @override
  void baue(MeshBuilder m, FormOrt o) {
    final r = _Rahmen(o);
    if (o.hoehe <= 0.55) {
      _sitzbank(m, o, r);
    } else if (o.hoehe < 0.85) {
      _saegebock(m, o, r);
    } else {
      _bankreihe(m, o, r);
    }
  }
}

/// Punkt oder Richtung in Rahmen-Koordinaten (u, d, y).
typedef _Lok = (double, double, double);

/// Punkt in Weltkoordinaten (x, y nach oben, z).
class _V {
  const _V(this.x, this.y, this.z);

  final double x, y, z;

  _V operator -(_V o) => _V(x - o.x, y - o.y, z - o.z);

  _V kreuz(_V o) => _V(y * o.z - z * o.y, z * o.x - x * o.z, x * o.y - y * o.x);

  double skalar(_V o) => x * o.x + y * o.y + z * o.z;

  double get laenge => math.sqrt(skalar(this));
}

/// Achsen und Lage der Form. Liegt die Rückseite an einer kurzen Seite (`rueckseite` 0 oder 2 bei
/// Längsachse x), gilt die Seite mit dem kleineren S-Wert als Wand, weil der Auftrag dafür keine Lage nennt.
class _Rahmen {
  _Rahmen._(this.o, this.laengsX, this.u0, this.u1, this.sRueck, this.sRichtung);

  factory _Rahmen(FormOrt o) {
    final laengsX = o.x1 - o.x0 >= o.z1 - o.z0;
    final rueckMax = laengsX ? o.rueckseite == 2 : o.rueckseite == 1;
    final s0 = laengsX ? o.z0 : o.x0;
    final s1 = laengsX ? o.z1 : o.x1;
    return _Rahmen._(
      o,
      laengsX,
      laengsX ? o.x0 : o.z0,
      laengsX ? o.x1 : o.z1,
      rueckMax ? s1 : s0,
      rueckMax ? -1 : 1,
    );
  }

  final FormOrt o;
  final bool laengsX;
  final double u0, u1;
  final double sRueck;
  final double sRichtung;

  double get laenge => u1 - u0;

  double get tiefe => laengsX ? o.z1 - o.z0 : o.x1 - o.x0;

  _V punkt(double u, double d, double y) {
    final s = sRueck + sRichtung * d;
    return laengsX ? _V(u, y, s) : _V(s, y, u);
  }

  _V richtung(_Lok n) {
    final s = sRichtung * n.$2;
    return laengsX ? _V(n.$1, n.$3, s) : _V(s, n.$3, n.$1);
  }
}

/// Lichtart einer Fläche: Seiten normal, Oberseiten etwas heller, Unterseiten und Innenflächen dunkler.
enum _Licht { seite, oben, dunkel }

/// Seiten eines Quaders in Rahmen-Koordinaten: u0/u1 = Stirnseiten, d0 = Rückseite, d1 = Vorderseite.
enum _Seite { u0, u1, d0, d1, oben, unten }

(double, double) _licht(FormOrt o, _Licht l) {
  double c(double v) => v < 0 ? 0 : (v > 1 ? 1 : v);
  return switch (l) {
    _Licht.seite => (c(o.warm), c(o.kalt)),
    _Licht.oben => (c(o.warm), c(o.kalt + 0.05)),
    _Licht.dunkel => (c(o.warm * 0.8), c(o.kalt * 0.8)),
  };
}

/// Eine ebene Fläche aus vier zyklisch geordneten Eckpunkten mit der Außenrichtung [n]. Die Windung
/// folgt dem Kreuzprodukt (b − a) × (c − a), wie `MeshBuilder.wall`, damit die sichtbare Seite nach außen zeigt.
void _flaeche(MeshBuilder m, _Rahmen r, _Licht licht, _Lok n, List<_Lok> ecken) {
  var w = [for (final e in ecken) r.punkt(e.$1, e.$2, e.$3)];
  if ((w[1] - w[0]).kreuz(w[2] - w[0]).skalar(r.richtung(n)) < 0) {
    w = [w[1], w[0], w[3], w[2]];
  }
  final (warm, kalt) = _licht(r.o, licht);
  final du = (w[1] - w[0]).laenge * kDichteWelt;
  final dv = (w[3] - w[0]).laenge * kDichteWelt;
  final i = [
    m.vertex(w[0].x, w[0].y, w[0].z, 0, 0, warm: warm, cold: kalt),
    m.vertex(w[1].x, w[1].y, w[1].z, du, 0, warm: warm, cold: kalt),
    m.vertex(w[2].x, w[2].y, w[2].z, du, dv, warm: warm, cold: kalt),
    m.vertex(w[3].x, w[3].y, w[3].z, 0, dv, warm: warm, cold: kalt),
  ];
  m.quad(i[0], i[1], i[2], i[3], r.o.textur);
}

/// Rechteck in der Ebene u = [u] mit den Bereichen [d0]–[d1] und [y0]–[y1].
void _rechteck(MeshBuilder m, _Rahmen r, double u, _Licht licht, double n, double d0, double d1, double y0,
    double y1) {
  _flaeche(m, r, licht, (n, 0, 0), [(u, d0, y0), (u, d1, y0), (u, d1, y1), (u, d0, y1)]);
}

/// Quader [u0,u1]×[d0,d1]×[y0,y1]. Gebaut werden nur die Seiten aus [seiten], jeweils mit ihrer Lichtart.
void _kasten(MeshBuilder m, _Rahmen r, double u0, double u1, double d0, double d1, double y0, double y1,
    Map<_Seite, _Licht> seiten) {
  for (final e in seiten.entries) {
    final l = e.value;
    switch (e.key) {
      case _Seite.u0:
        _flaeche(m, r, l, (-1, 0, 0), [(u0, d0, y0), (u0, d1, y0), (u0, d1, y1), (u0, d0, y1)]);
      case _Seite.u1:
        _flaeche(m, r, l, (1, 0, 0), [(u1, d0, y0), (u1, d1, y0), (u1, d1, y1), (u1, d0, y1)]);
      case _Seite.d0:
        _flaeche(m, r, l, (0, -1, 0), [(u0, d0, y0), (u1, d0, y0), (u1, d0, y1), (u0, d0, y1)]);
      case _Seite.d1:
        _flaeche(m, r, l, (0, 1, 0), [(u0, d1, y0), (u1, d1, y0), (u1, d1, y1), (u0, d1, y1)]);
      case _Seite.oben:
        _flaeche(m, r, l, (0, 0, 1), [(u0, d0, y1), (u1, d0, y1), (u1, d1, y1), (u0, d1, y1)]);
      case _Seite.unten:
        _flaeche(m, r, l, (0, 0, -1), [(u0, d0, y0), (u1, d0, y0), (u1, d1, y0), (u0, d1, y0)]);
    }
  }
}

/// Variante des Sitzbretts (Kennung der Form): zwei Bretter mit 0,01 m Fuge oder ein Brett.
bool _zweiBretter(FormOrt o) => o.hash(0) % 2 == 1;

/// Sitzbank ohne Lehne (≤ 0,55 m): Sitzbrett, Wangen mit Ausschnitt, Längszarge an der Rückseite.
void _sitzbank(MeshBuilder m, FormOrt o, _Rahmen r) {
  final h = o.hoehe;
  final tief = r.tiefe;
  final sitzUnten = h - 0.05;
  final zargeUnten = math.max(h - 0.13, 0.0);

  // Wangen: Mittenabstand höchstens 1,2 m, die Enden stehen bündig mit der Grundfläche.
  final k = math.max(1, ((r.laenge - 0.04) / 1.2).ceil());
  final schritt = (r.laenge - 0.04) / k;
  for (var i = 0; i <= k; i++) {
    _wangeSitz(m, r, r.u0 + i * schritt, tief, zargeUnten, sitzUnten);
  }

  // Längszarge 0,08 m hoch direkt unter dem Sitz, 0,04 m dick, an der Rückseite.
  _kasten(m, r, r.u0, r.u1, 0, 0.04, zargeUnten, sitzUnten, {
    _Seite.u0: _Licht.seite,
    _Seite.u1: _Licht.seite,
    _Seite.d1: _Licht.seite,
  });

  // Sitzbrett über die ganze Länge, 0,05 m dick.
  if (_zweiBretter(o)) {
    _kasten(m, r, r.u0, r.u1, 0, tief / 2 - 0.005, sitzUnten, h, {
      _Seite.oben: _Licht.oben,
      _Seite.u0: _Licht.seite,
      _Seite.u1: _Licht.seite,
    });
    _kasten(m, r, r.u0, r.u1, tief / 2 + 0.005, tief, sitzUnten, h, {
      _Seite.oben: _Licht.oben,
      _Seite.d1: _Licht.seite,
      _Seite.u0: _Licht.seite,
      _Seite.u1: _Licht.seite,
    });
  } else {
    _kasten(m, r, r.u0, r.u1, 0, tief, sitzUnten, h, {
      _Seite.oben: _Licht.oben,
      _Seite.d1: _Licht.seite,
      _Seite.u0: _Licht.seite,
      _Seite.u1: _Licht.seite,
    });
  }
}

/// Wange der Sitzbank bei u = [p], 0,04 m dick, Tiefe ohne die Zarge (d 0,04 bis Tiefe). Ausschnitt unten:
/// zwei Stollen 0,08 breit, Querholz 0,08 hoch darüber. Oben schließt der Sitz.
void _wangeSitz(MeshBuilder m, _Rahmen r, double p, double tief, double qu, double qo) {
  final q = p + 0.04;
  _kasten(m, r, p, q, 0.04, 0.12, 0, qo, {
    _Seite.u0: _Licht.seite,
    _Seite.u1: _Licht.seite,
    _Seite.d1: _Licht.dunkel,
  });
  _kasten(m, r, p, q, tief - 0.08, tief, 0, qo, {
    _Seite.u0: _Licht.seite,
    _Seite.u1: _Licht.seite,
    _Seite.d0: _Licht.dunkel,
    _Seite.d1: _Licht.seite,
  });
  _kasten(m, r, p, q, 0.12, tief - 0.08, qu, qo, {
    _Seite.u0: _Licht.seite,
    _Seite.u1: _Licht.seite,
  });
}

/// Sägebock (0,55 bis 0,85 m): Balken 0,1 × 0,1 oben, zwei gespreizte Beinpaare.
void _saegebock(MeshBuilder m, FormOrt o, _Rahmen r) {
  final h = o.hoehe;
  final mitte = r.tiefe / 2;
  final balkenUnten = h - 0.1;
  _kasten(m, r, r.u0, r.u1, mitte - 0.05, mitte + 0.05, balkenUnten, h, {
    _Seite.oben: _Licht.oben,
    _Seite.u0: _Licht.seite,
    _Seite.u1: _Licht.seite,
    _Seite.d0: _Licht.seite,
    _Seite.d1: _Licht.seite,
  });
  for (final uc in [r.u0 + 0.25, r.u1 - 0.25]) {
    for (final s in [-1.0, 1.0]) {
      _bein(m, r, uc, mitte + s * 0.04, mitte + s * 0.10, balkenUnten, s);
    }
  }
}

/// Ein schräges Bein 0,08 × 0,08: oben unter dem Balken bei d = [dOben], unten bei d = [dUnten] (0,06 m
/// weiter außen). [s] = −1 oder +1 je nach Seite des Beinpaars.
void _bein(MeshBuilder m, _Rahmen r, double uc, double dOben, double dUnten, double yOben, double s) {
  final a = uc - 0.04;
  final b = uc + 0.04;
  _flaeche(m, r, _Licht.oben, (0, 0, 1), [
    (a, dOben - 0.04, yOben),
    (b, dOben - 0.04, yOben),
    (b, dOben + 0.04, yOben),
    (a, dOben + 0.04, yOben),
  ]);
  for (final u in [a, b]) {
    _flaeche(m, r, _Licht.seite, (u == a ? -1 : 1, 0, 0), [
      (u, dOben - 0.04, yOben),
      (u, dOben + 0.04, yOben),
      (u, dUnten + 0.04, 0),
      (u, dUnten - 0.04, 0),
    ]);
  }
  // Außenseite (zeigt von der Mitte weg) und Innenseite (zur Mitte, dunkler).
  _flaeche(m, r, _Licht.seite, (0, s, 0), [
    (a, dOben + s * 0.04, yOben),
    (b, dOben + s * 0.04, yOben),
    (b, dUnten + s * 0.04, 0),
    (a, dUnten + s * 0.04, 0),
  ]);
  _flaeche(m, r, _Licht.dunkel, (0, -s, 0), [
    (a, dOben - s * 0.04, yOben),
    (b, dOben - s * 0.04, yOben),
    (b, dUnten - s * 0.04, 0),
    (a, dUnten - s * 0.04, 0),
  ]);
}

/// Bankreihe (≥ 0,85 m): Sitz auf 0,45 m, Rückenlehne an der Rückseite bis zur Höhe, Wangen an den Enden.
void _bankreihe(MeshBuilder m, FormOrt o, _Rahmen r) {
  final h = o.hoehe;
  final tief = r.tiefe;
  final a = r.u0 + 0.04;
  final b = r.u1 - 0.04;

  // Sitz zwischen den Wangen: Oberkante 0,45 m, Dicke 0,05 m.
  if (_zweiBretter(o)) {
    _kasten(m, r, a, b, 0, tief / 2 - 0.005, 0.40, 0.45, {_Seite.oben: _Licht.oben});
    _kasten(m, r, a, b, tief / 2 + 0.005, tief, 0.40, 0.45, {
      _Seite.oben: _Licht.oben,
      _Seite.d1: _Licht.seite,
    });
  } else {
    _kasten(m, r, a, b, 0, tief, 0.40, 0.45, {
      _Seite.oben: _Licht.oben,
      _Seite.d1: _Licht.seite,
    });
  }

  // Lehne: Brett 0,03 m, unten 0,04 m von der Rückseite abgesetzt, oben 0,04 m weiter nach hinten.
  _flaeche(m, r, _Licht.seite, (0, 1, 0), [(a, 0.07, 0.45), (b, 0.07, 0.45), (b, 0.03, h), (a, 0.03, h)]);
  _flaeche(m, r, _Licht.oben, (0, 0, 1), [(a, 0, h), (b, 0, h), (b, 0.03, h), (a, 0.03, h)]);

  _wangeLehne(m, r, r.u0, true, tief, h);
  _wangeLehne(m, r, r.u1 - 0.04, false, tief, h);
}

/// Wange der Bankreihe bei u = [p] (0,04 m dick, volle Tiefe, Rückseite an der Wand). Der Abschluss vorn oben
/// ist zweistufig gerundet: Stufen je 0,03 m breit und 0,04 m hoch. [links] = Wange am linken Ende,
/// deren Innenseite zeigt nach +u.
void _wangeLehne(MeshBuilder m, _Rahmen r, double p, bool links, double tief, double h) {
  final q = p + 0.04;
  for (final u in [p, q]) {
    final innen = (u == q) == links;
    final licht = innen ? _Licht.dunkel : _Licht.seite;
    final n = u == p ? -1.0 : 1.0;
    _rechteck(m, r, u, licht, n, 0, tief, 0, h - 0.08);
    _rechteck(m, r, u, licht, n, 0, tief - 0.03, h - 0.08, h - 0.04);
    _rechteck(m, r, u, licht, n, 0, tief - 0.06, h - 0.04, h);
  }
  // Sichtbare Kanten: Vorderseite, Stufen und Oberkante.
  _flaeche(m, r, _Licht.seite, (0, 1, 0), [(p, tief, 0), (q, tief, 0), (q, tief, h - 0.08), (p, tief, h - 0.08)]);
  _flaeche(m, r, _Licht.oben, (0, 0, 1), [
    (p, tief - 0.03, h - 0.08),
    (q, tief - 0.03, h - 0.08),
    (q, tief, h - 0.08),
    (p, tief, h - 0.08),
  ]);
  _flaeche(m, r, _Licht.seite, (0, 1, 0), [
    (p, tief - 0.03, h - 0.08),
    (q, tief - 0.03, h - 0.08),
    (q, tief - 0.03, h - 0.04),
    (p, tief - 0.03, h - 0.04),
  ]);
  _flaeche(m, r, _Licht.oben, (0, 0, 1), [
    (p, tief - 0.06, h - 0.04),
    (q, tief - 0.06, h - 0.04),
    (q, tief - 0.03, h - 0.04),
    (p, tief - 0.03, h - 0.04),
  ]);
  _flaeche(m, r, _Licht.seite, (0, 1, 0), [
    (p, tief - 0.06, h - 0.04),
    (q, tief - 0.06, h - 0.04),
    (q, tief - 0.06, h),
    (p, tief - 0.06, h),
  ]);
  _flaeche(m, r, _Licht.oben, (0, 0, 1), [(p, 0, h), (q, 0, h), (q, tief - 0.06, h), (p, tief - 0.06, h)]);
}

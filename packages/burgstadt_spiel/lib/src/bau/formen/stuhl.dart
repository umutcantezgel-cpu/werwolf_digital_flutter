import 'package:pixel_engine/pixel_engine.dart';

import '../form.dart';

/// Stuhl, Hocker, Schemel und Sessel (P4-AUTOR-02, HZ-07). Drei Bauarten:
/// - hoehe ≤ 0,55 (Hocker, Schemel): Sitzplatte, vier Beine oder bei gerader `hash(0)` drei (Dreieck),
///   eine Querstrebe auf 0,15 m, keine Lehne. Budget 70 Dreiecke.
/// - hoehe > 0,55 (Stuhl mit Lehne): Sitz auf 0,45 m, die hinteren Beine als Lehnenpfosten bis hoehe,
///   Brett oben, bei gerader `hash(1)` eine zweite Sprosse darunter. Budget 70 Dreiecke.
/// - Sessel (hoehe ≥ 0,9 und Grundfläche ≥ 0,9 m in einer Richtung oder Textur ≠ holzBohlen): breiter Sitz,
///   Armlehnen (0,06 m breit, Oberkante 0,65 m), hohe geschlossene Lehne. Budget 90 Dreiecke.
/// Die Lehne liegt an der Seite [FormOrt.rueckseite], die Sitzvorderkante zeigt in den Raum.
/// Alle Teile nutzen nur `o.textur`. Maße in Metern, Kanten: Oberseiten heller, Beine dunkler.
class StuhlForm implements Moebelform {
  const StuhlForm();

  @override
  String get name => 'stuhl';

  @override
  void baue(MeshBuilder m, FormOrt o) {
    final sitz = o.hoehe < _sitzHoehe ? o.hoehe : _sitzHoehe; // min(0,45, hoehe)
    if (o.hoehe <= 0.55) {
      _hocker(m, o, sitz);
    } else if (o.hoehe >= 0.9 && (o.breite >= 0.9 || o.tiefe >= 0.9 || o.textur != TexturId.holzBohlen.index)) {
      _sessel(m, o, sitz);
    } else {
      _stuhl(m, o, sitz);
    }
  }
}

const double _sitzHoehe = 0.45;
const double _sitzDicke = 0.05;

/// Sitzplatte und Grundfläche: 0,02 m nach innen eingerückt.
const double _einzug = 0.02;

/// Beine: 0,05 m dick, 0,03 m nach innen versetzt.
const double _bein = 0.05;
const double _versatz = 0.03;

/// Wärmeseite der Beine und Querstrebe (Innenteile): 0,8 × warm, wie im Muster `tisch.dart`.
const double _dunkel = 0.8;

/// Breite der Wand entlang der Lehne (x bei rueckseite 0 und 2, z bei 1 und 3).
double _querMass(FormOrt o) => o.rueckseite == 0 || o.rueckseite == 2 ? o.breite : o.tiefe;

/// Tiefe von der Rückseite zur Vorderkante.
double _tiefMass(FormOrt o) => o.rueckseite == 0 || o.rueckseite == 2 ? o.tiefe : o.breite;

/// Grundrechteck für Tiefe [t0, t1] ab der Rückseite und Breite [q0, q1] entlang der Wand.
/// rueckseite 0 = −z, 1 = +x, 2 = +z, 3 = −x (Lehne an der Wand).
(double, double, double, double) _grund(FormOrt o, double t0, double t1, double q0, double q1) {
  switch (o.rueckseite) {
    case 1:
      return (o.x1 - t1, o.z0 + q0, o.x1 - t0, o.z0 + q1);
    case 2:
      return (o.x0 + q0, o.z1 - t1, o.x0 + q1, o.z1 - t0);
    case 3:
      return (o.x0 + t0, o.z0 + q0, o.x0 + t1, o.z0 + q1);
    default:
      return (o.x0 + q0, o.z0 + t0, o.x0 + q1, o.z0 + t1);
  }
}

double _kl(double v) => v < 0 ? 0 : (v > 1 ? 1 : v);

/// Quader (10 Dreiecke: vier Seiten, Oberseite; Unterseite steht auf dem Boden bzw. auf Beinen).
/// Oberseite etwas heller (cold + 0,05), Seiten mit Grundlicht; [dunkel] senkt die Wärme der Innenteile.
void _kasten(MeshBuilder m, FormOrt o, double t0, double t1, double q0, double q1, double y0, double y1,
    {double dunkel = 1}) {
  final (x0, z0, x1, z1) = _grund(o, t0, t1, q0, q1);
  final t = o.textur;
  final warm = _kl(o.warm * dunkel), kalt = _kl(o.kalt);
  m.wall(x0, z1, x1, z1, y0, y1, t, warm: warm, cold: kalt);
  m.wall(x1, z1, x1, z0, y0, y1, t, warm: warm, cold: kalt);
  m.wall(x1, z0, x0, z0, y0, y1, t, warm: warm, cold: kalt);
  m.wall(x0, z0, x0, z1, y0, y1, t, warm: warm, cold: kalt);
  m.floor(x0, z0, x1, z1, y1, t, warm: warm, cold: _kl(kalt + 0.05), step: 4);
}

/// Bein in einer Ecke (hinten = Lehnenseite, rechts = zweite Seite entlang der Wand), von 0 bis [oben].
void _bein4(MeshBuilder m, FormOrt o, {required bool hinten, required bool rechts, required double oben,
    double dunkel = _dunkel}) {
  final quer = _querMass(o), tief = _tiefMass(o);
  final t0 = hinten ? _versatz : tief - _versatz - _bein;
  final q0 = rechts ? quer - _versatz - _bein : _versatz;
  _kasten(m, o, t0, t0 + _bein, q0, q0 + _bein, 0, oben, dunkel: dunkel);
}

/// Hocker und Schemel: Sitz, vier oder drei Beine, Querstrebe zwischen den vorderen Beinen auf 0,15 m.
void _hocker(MeshBuilder m, FormOrt o, double sitz) {
  final ob = sitz - _sitzDicke; // Unterkante der Sitzplatte
  final quer = _querMass(o), tief = _tiefMass(o);
  _kasten(m, o, _einzug, tief - _einzug, _einzug, quer - _einzug, ob, sitz);
  if (o.hash(0) % 2 == 0) {
    // Melkschemel: zwei Beine vorn, eines mittig hinten (Dreieck, Spitze zur Wand)
    _bein4(m, o, hinten: false, rechts: false, oben: ob);
    _bein4(m, o, hinten: false, rechts: true, oben: ob);
    _kasten(m, o, _versatz, _versatz + _bein, quer / 2 - _bein / 2, quer / 2 + _bein / 2, 0, ob, dunkel: _dunkel);
  } else {
    _bein4(m, o, hinten: true, rechts: false, oben: ob);
    _bein4(m, o, hinten: true, rechts: true, oben: ob);
    _bein4(m, o, hinten: false, rechts: false, oben: ob);
    _bein4(m, o, hinten: false, rechts: true, oben: ob);
  }
  // Querstrebe zwischen den vorderen Beinen, Mitte 0,15 m, 0,03 m dick
  final mitte = tief - _versatz - _bein / 2;
  _kasten(m, o, mitte - 0.015, mitte + 0.015, _versatz + _bein, quer - _versatz - _bein, 0.135, 0.165,
      dunkel: _dunkel);
}

/// Stuhl mit Lehne: vier Beine (die hinteren als Lehnenpfosten bis hoehe), Brett 0,25 m hoch, 0,03 m dick.
void _stuhl(MeshBuilder m, FormOrt o, double sitz) {
  final ob = sitz - _sitzDicke;
  final quer = _querMass(o), tief = _tiefMass(o);
  _kasten(m, o, _einzug, tief - _einzug, _einzug, quer - _einzug, ob, sitz);
  _bein4(m, o, hinten: false, rechts: false, oben: ob);
  _bein4(m, o, hinten: false, rechts: true, oben: ob);
  _bein4(m, o, hinten: true, rechts: false, oben: o.hoehe, dunkel: 1);
  _bein4(m, o, hinten: true, rechts: true, oben: o.hoehe, dunkel: 1);
  // Brett oben zwischen den Pfosten (Tiefe 0,04–0,07 m von der Rückseite)
  final brettUnten = o.hoehe - 0.25;
  _kasten(m, o, 0.04, 0.07, _versatz + _bein, quer - _versatz - _bein, brettUnten, o.hoehe);
  if (o.hash(1) % 2 == 0) {
    // zweite schmale Sprosse darunter, 0,03 m hoch, 0,06 m Abstand zum Brett
    final spUnten = brettUnten - 0.06 - 0.03;
    _kasten(m, o, 0.04, 0.07, _versatz + _bein, quer - _versatz - _bein, spUnten, spUnten + 0.03);
  }
}

/// Sessel: breiter Sitz über die ganze Grundfläche, vier Beine, geschlossene Lehne bis hoehe,
/// zwei Armlehnen (0,06 m breit, Oberkante 0,65 m) von der Lehne bis zur Vorderkante.
void _sessel(MeshBuilder m, FormOrt o, double sitz) {
  final ob = sitz - _sitzDicke;
  final quer = _querMass(o), tief = _tiefMass(o);
  _kasten(m, o, _einzug, tief - _einzug, _einzug, quer - _einzug, ob, sitz);
  _bein4(m, o, hinten: true, rechts: false, oben: ob);
  _bein4(m, o, hinten: true, rechts: true, oben: ob);
  _bein4(m, o, hinten: false, rechts: false, oben: ob);
  _bein4(m, o, hinten: false, rechts: true, oben: ob);
  // geschlossene Lehne: volle Breite, Tiefe 0,02–0,08 m von der Rückseite
  _kasten(m, o, _einzug, 0.08, _einzug, quer - _einzug, ob, o.hoehe);
  // Armlehnen an den beiden Seiten quer zur Lehne
  _kasten(m, o, 0.08, tief - _einzug, _einzug, _einzug + 0.06, sitz, 0.65);
  _kasten(m, o, 0.08, tief - _einzug, quer - _einzug - 0.06, quer - _einzug, sitz, 0.65);
}

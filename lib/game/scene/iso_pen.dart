import 'dart:typed_data';
import 'dart:ui';

import '../iso_math.dart';
import 'palette.dart';

/// Zeichenhilfe für Objekte auf einer Kachel.
///
/// Lokale Koordinaten (u, v, z): `u` läuft quer über die Vorderseite (links →
/// rechts, wie man sie sieht), `v` von hinten (0) nach vorne (1), `z` nach oben.
/// [east] = Vorderseite zeigt nach Osten statt nach Süden (Objekt an Westwand).
class IsoPen {
  final Canvas c;
  final double ox;
  final double oy;
  final bool east;

  IsoPen(this.c, this.ox, this.oy, {this.east = false});

  static const double rx = Iso.groundScale; // Pixel pro Kachel in der Ellipsen-Breite
  static const double ry = Iso.groundScale / 2;

  double lx(double u, double v) => east ? v : u;
  double ly(double u, double v) => east ? 1 - u : v;

  /// Lokaler Punkt → Bildschirm.
  Offset p(double u, double v, double z) => Iso.toScreen(ox + lx(u, v), oy + ly(u, v), z);

  /// Tiefe eines lokalen Punkts (für die Reihenfolge von Teilen).
  double depth(double u, double v) => lx(u, v) + ly(u, v);

  /// Die sichtbare Seitenfläche liegt bei u1 (Süd-Orientierung) bzw. u0 (Ost).
  double sideU(double u0, double u1) => east ? u0 : u1;

  /// Zeichnet in der Ebene der Vorderseite bei Tiefe [v]: lokale Canvas-
  /// Koordinaten (u, z), z zeigt nach oben. Kreise werden zu Ellipsen in der Ebene.
  void onFront(double v, void Function() draw) => _onPlane(p(0, v, 0), p(1, v, 0), p(0, v, 1), draw);

  /// Wie [onFront], aber auf der sichtbaren Seitenfläche bei [u]: (v, z).
  void onSide(double u, void Function() draw) => _onPlane(p(u, 0, 0), p(u, 1, 0), p(u, 0, 1), draw);

  void _onPlane(Offset o, Offset ua, Offset za, void Function() draw) {
    final u = ua - o, z = za - o;
    c.save();
    c.transform(Float64List.fromList([u.dx, u.dy, 0, 0, z.dx, z.dy, 0, 0, 0, 0, 1, 0, o.dx, o.dy, 0, 1]));
    draw();
    c.restore();
  }

  /// Sammelt Teile und zeichnet sie von hinten nach vorne.
  final List<(double, void Function())> _parts = [];

  void part(double u, double v, void Function() draw) => _parts.add((depth(u, v), draw));

  void flush() {
    _parts.sort((a, b) => a.$1.compareTo(b.$1));
    for (final p in _parts) {
      p.$2();
    }
    _parts.clear();
  }

  /// Welt-lokaler Punkt (ohne Orientierung) → Bildschirm.
  Offset w(double x, double y, double z) => Iso.toScreen(ox + x, oy + y, z);

  void poly(List<Offset> pts, Paint paint) {
    final path = Path()..addPolygon(pts, true);
    c.drawPath(path, paint);
  }

  Paint fill(Color col) => Paint()..color = col;

  Paint stroke(Color col, double width) => Paint()
    ..color = col
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  /// Quader mit Ober-, Süd- und Ostseite.
  void box(
    double u0,
    double v0,
    double u1,
    double v1,
    double z0,
    double z1,
    Color col, {
    Color? top,
    Color? south,
    Color? eastC,
    bool drawTop = true,
    Color? edge,
  }) {
    final ax = lx(u0, v0), bx = lx(u1, v1);
    final ay = ly(u0, v0), by = ly(u1, v1);
    final x0 = ax < bx ? ax : bx, x1 = ax < bx ? bx : ax;
    final y0 = ay < by ? ay : by, y1 = ay < by ? by : ay;
    worldBox(x0, y0, x1, y1, z0, z1, col, top: top, south: south, eastC: eastC, drawTop: drawTop, edge: edge);
  }

  /// Quader in welt-lokalen Koordinaten.
  void worldBox(
    double x0,
    double y0,
    double x1,
    double y1,
    double z0,
    double z1,
    Color col, {
    Color? top,
    Color? south,
    Color? eastC,
    bool drawTop = true,
    Color? edge,
  }) {
    if (z1 > z0) {
      poly([w(x0, y1, z0), w(x1, y1, z0), w(x1, y1, z1), w(x0, y1, z1)], fill(south ?? col));
      poly([w(x1, y0, z0), w(x1, y1, z0), w(x1, y1, z1), w(x1, y0, z1)], fill(eastC ?? shade(col, -0.28)));
    }
    if (drawTop) {
      poly([w(x0, y0, z1), w(x1, y0, z1), w(x1, y1, z1), w(x0, y1, z1)], fill(top ?? shade(col, 0.12)));
    }
    if (edge != null) {
      final e = stroke(edge, 0.8);
      c.drawLine(w(x0, y1, z1), w(x1, y1, z1), e);
      c.drawLine(w(x1, y1, z1), w(x1, y0, z1), e);
      if (z1 > z0) c.drawLine(w(x1, y1, z1), w(x1, y1, z0), e);
    }
  }

  /// Viereck auf einer Vorderseiten-Ebene (Tiefe [v]).
  List<Offset> frontQuad(double u0, double u1, double z0, double z1, double v) =>
      [p(u0, v, z0), p(u1, v, z0), p(u1, v, z1), p(u0, v, z1)];

  void frontRect(double u0, double u1, double z0, double z1, double v, Paint paint) =>
      poly(frontQuad(u0, u1, z0, z1, v), paint);

  /// Viereck auf der Oberseite (Höhe [z]).
  List<Offset> topQuad(double u0, double v0, double u1, double v1, double z) =>
      [p(u0, v0, z), p(u1, v0, z), p(u1, v1, z), p(u0, v1, z)];

  void topRect(double u0, double v0, double u1, double v1, double z, Paint paint) =>
      poly(topQuad(u0, v0, u1, v1, z), paint);

  /// Ellipse auf einer horizontalen Ebene.
  Rect groundOval(double u, double v, double z, double r) {
    final o = p(u, v, z);
    return Rect.fromCenter(center: o, width: r * 2 * rx, height: r * 2 * ry);
  }

  void oval(double u, double v, double z, double r, Paint paint) => c.drawOval(groundOval(u, v, z, r), paint);

  /// Stehender Zylinder.
  void cylinder(double u, double v, double r, double z0, double z1, Color col, {Color? top, double rTop = -1}) {
    final rt = rTop < 0 ? r : rTop;
    final b = p(u, v, z0), t = p(u, v, z1);
    final bw = r * rx, bh = r * ry, tw = rt * rx, th = rt * ry;
    final path = Path()
      ..moveTo(t.dx - tw, t.dy)
      ..lineTo(b.dx - bw, b.dy)
      ..arcToPoint(Offset(b.dx + bw, b.dy), radius: Radius.elliptical(bw, bh), clockwise: false)
      ..lineTo(t.dx + tw, t.dy)
      ..close();
    final paint = Paint()
      ..shader = Gradient.linear(
        Offset(b.dx - bw, 0),
        Offset(b.dx + bw, 0),
        [shade(col, 0.18), col, shade(col, -0.38)],
        const [0.0, 0.45, 1.0],
      );
    c.drawPath(path, paint);
    c.drawOval(Rect.fromCenter(center: t, width: tw * 2, height: th * 2), fill(top ?? shade(col, 0.15)));
  }

  /// Kugel/Blob mit Glanzlicht.
  void sphere(double u, double v, double z, double r, Color col, {double squash = 1}) {
    final o = p(u, v, z);
    final rad = r * rx;
    final rect = Rect.fromCenter(center: o, width: rad * 2, height: rad * 2 * squash);
    c.drawOval(
      rect,
      Paint()
        ..shader = Gradient.radial(
          o.translate(-rad * 0.35, -rad * 0.4 * squash),
          rad * 1.3,
          [shade(col, 0.22), col, shade(col, -0.4)],
          const [0.0, 0.5, 1.0],
        ),
    );
  }
}

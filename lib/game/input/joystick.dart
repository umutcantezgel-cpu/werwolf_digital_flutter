import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Zustand des virtuellen Joysticks (dynamischer Ursprung).
class JoystickState extends ChangeNotifier {
  static const double radius = 56;
  static const double deadZone = 0.14;

  int? pointer;
  Offset origin = Offset.zero;
  Offset knob = Offset.zero;

  bool get active => pointer != null;

  /// Richtung in Bildschirmkoordinaten, Länge 0..1 (mit Totzone).
  Offset get vector {
    if (!active) return Offset.zero;
    final v = knob / radius;
    final l = v.distance;
    if (l < deadZone) return Offset.zero;
    final k = ((l - deadZone) / (1 - deadZone)).clamp(0.0, 1.0);
    return v / l * k;
  }

  void start(int p, Offset at) {
    pointer = p;
    origin = at;
    knob = Offset.zero;
    notifyListeners();
  }

  void move(Offset at) {
    var d = at - origin;
    final l = d.distance;
    if (l > radius) {
      // Ursprung folgt dem Daumen, wenn er weit hinauszieht.
      final over = d / l * (l - radius);
      if (l > radius * 1.6) origin += over * 0.5;
      d = at - origin;
      final l2 = d.distance;
      if (l2 > radius) d = d / l2 * radius;
    }
    knob = d;
    notifyListeners();
  }

  void end() {
    pointer = null;
    knob = Offset.zero;
    notifyListeners();
  }
}

/// Zeichnet den Joystick (aktiv) bzw. einen dezenten Hinweis (Ruhe).
class JoystickPainter extends CustomPainter {
  final JoystickState joy;
  final Offset restPosition;
  final Color accent;

  JoystickPainter(this.joy, this.restPosition, this.accent) : super(repaint: joy);

  @override
  void paint(Canvas canvas, Size size) {
    if (!joy.active) {
      final o = restPosition;
      canvas.drawCircle(o, JoystickState.radius * 0.8, Paint()
        ..color = const Color(0x22FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5);
      canvas.drawCircle(o, 18, Paint()..color = const Color(0x1AFFFFFF));
      final tri = Paint()..color = const Color(0x30FFFFFF);
      for (var i = 0; i < 4; i++) {
        final a = i * math.pi / 2;
        final dir = Offset(math.cos(a), math.sin(a));
        final tip = o + dir * (JoystickState.radius * 0.8 - 8);
        final n = Offset(-dir.dy, dir.dx);
        canvas.drawPath(
          Path()
            ..moveTo(tip.dx, tip.dy)
            ..lineTo(tip.dx - dir.dx * 7 + n.dx * 5, tip.dy - dir.dy * 7 + n.dy * 5)
            ..lineTo(tip.dx - dir.dx * 7 - n.dx * 5, tip.dy - dir.dy * 7 - n.dy * 5)
            ..close(),
          tri,
        );
      }
      return;
    }
    final o = joy.origin;
    canvas.drawCircle(o, JoystickState.radius + 6, Paint()..color = const Color(0x33000000));
    canvas.drawCircle(o, JoystickState.radius, Paint()
      ..color = const Color(0x55FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2);
    final k = o + joy.knob;
    canvas.drawCircle(k, 26, Paint()..color = const Color(0x66000000));
    canvas.drawCircle(k, 24, Paint()
      ..shader = RadialGradient(colors: [Color.lerp(accent, const Color(0xFFFFFFFF), 0.35)!.withValues(alpha: 0.85), accent.withValues(alpha: 0.6)])
          .createShader(Rect.fromCircle(center: k.translate(-6, -6), radius: 30)));
    canvas.drawCircle(k, 24, Paint()
      ..color = const Color(0x88FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(JoystickPainter old) => old.restPosition != restPosition || old.accent != accent;
}

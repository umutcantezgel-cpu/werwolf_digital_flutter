import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../app/theme.dart';

/// Code-gezeichnete Büste einer Figur (Verdächtige, Detektive).
class Portrait extends StatelessWidget {
  const Portrait({
    super.key,
    required this.look,
    this.size = 96,
    this.background = true,
    this.accent = Noir.brass,
    this.dead = false,
    this.circle = false,
  });

  final LookDef look;
  final double size;
  final bool background;
  final Color accent;
  final bool dead;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    Widget p = CustomPaint(
      size: Size.square(size),
      painter: PortraitPainter(look: look, background: background, accent: accent),
    );
    if (dead) {
      p = ColorFiltered(
        colorFilter: const ColorFilter.matrix(_grey),
        child: Opacity(opacity: 0.6, child: p),
      );
    }
    if (circle) p = ClipOval(child: p);
    return SizedBox.square(dimension: size, child: p);
  }
}

const _grey = <double>[
  0.33, 0.33, 0.33, 0, 0, //
  0.33, 0.33, 0.33, 0, 0, //
  0.33, 0.33, 0.33, 0, 0, //
  0, 0, 0, 1, 0,
];

/// Mini-Avatar eines Detektivs (Mantelfarbe + Hut).
class DetectiveAvatar extends StatelessWidget {
  const DetectiveAvatar({
    super.key,
    required this.coat,
    required this.hat,
    this.size = 40,
    this.ring,
    this.ghost = false,
  });

  final int coat;
  final String hat;
  final double size;
  final Color? ring;
  final bool ghost;

  @override
  Widget build(BuildContext context) {
    final c = detectiveCoats[coat.clamp(0, detectiveCoats.length - 1)];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Noir.night3,
        border: Border.all(color: ring ?? hexColor(c).withValues(alpha: 0.8), width: size > 36 ? 2 : 1.5),
      ),
      child: ClipOval(
        child: Opacity(
          opacity: ghost ? 0.45 : 1,
          child: Portrait(
            look: LookDef(coat: c, hat: hat, hair: '#3b2a20'),
            size: size,
            background: false,
          ),
        ),
      ),
    );
  }
}

/// Zeichenfarben der Figuren (Standardwerte und Details).
abstract final class _Fig {
  static const coat = Color(0xFF3A3A44);
  static const skin = Color(0xFFE0B89A);
  static const hair = Color(0xFF3B2A20);
  static const hatBlack = Color(0xFF0E0C0B);
  static const backdrop = Color(0xFF07080E);
  static const shirt = Color(0xFFE9E2D2);
  static const tie = Color(0xFF6E1414);
  static const eye = Color(0xFF1A1412);
  static const lips = Color(0xFF5A1E1E);
  static const black = Color(0xFF000000);
  static const brooch = Color(0xFFB8963A);
}

class PortraitPainter extends CustomPainter {
  PortraitPainter({required this.look, this.background = true, this.accent = Noir.brass});

  final LookDef look;
  final bool background;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final coat = hexColor(look.coat, fallback: _Fig.coat);
    final skin = hexColor(look.skin, fallback: _Fig.skin);
    final hair = hexColor(look.hair, fallback: _Fig.hair);
    final hatColor = Color.lerp(coat, _Fig.hatBlack, 0.62)!;

    if (background) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.3, -0.4),
            radius: 0.95,
            colors: [Color.lerp(accent, Noir.night3, 0.72)!, Noir.night2, _Fig.backdrop],
            stops: const [0, 0.6, 1],
          ).createShader(Offset.zero & size),
      );
    }

    // Körperbau
    var shoulder = 0.80;
    var head = 0.31;
    var scale = 1.0;
    var neckLen = 0.0;
    switch (look.build) {
      case 'slim':
        shoulder = 0.68;
        head = 0.29;
      case 'broad':
        shoulder = 0.96;
        head = 0.335;
      case 'tall':
        shoulder = 0.74;
        head = 0.29;
        neckLen = 0.025;
      case 'small':
        scale = 0.9;
        shoulder = 0.72;
    }
    canvas.save();
    // klein: alles etwas tiefer und kleiner
    canvas.translate(cx * (1 - scale), h * (1 - scale));
    canvas.scale(scale);

    final hw = head * w; // Kopfbreite
    final hh = hw * 1.22; // Kopfhöhe
    final headCy = h * 0.43 - neckLen * h;
    final headTop = headCy - hh / 2;
    final shoulderTop = h * 0.71;
    final sw = shoulder * w;

    final lit = Paint()..isAntiAlias = true;

    // Haar hinten
    if (look.hat != 'cloche') {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, headCy - hh * 0.06), width: hw * 1.1, height: hh * 1.02),
        lit..color = Color.lerp(hair, Colors.black, 0.25)!,
      );
    }

    // Hals
    final neck = Rect.fromLTRB(cx - hw * 0.2, headCy + hh * 0.25, cx + hw * 0.2, shoulderTop + h * 0.04);
    canvas.drawRect(neck, lit..color = Color.lerp(skin, Colors.black, 0.28)!);

    // Mantel / Schultern
    final body = Path()
      ..moveTo(cx - sw / 2, h + 2)
      ..lineTo(cx - sw / 2, shoulderTop + h * 0.12)
      ..quadraticBezierTo(cx - sw / 2, shoulderTop, cx - sw * 0.24, shoulderTop - h * 0.01)
      ..lineTo(cx - hw * 0.22, shoulderTop - h * 0.035)
      ..lineTo(cx + hw * 0.22, shoulderTop - h * 0.035)
      ..lineTo(cx + sw * 0.24, shoulderTop - h * 0.01)
      ..quadraticBezierTo(cx + sw / 2, shoulderTop, cx + sw / 2, shoulderTop + h * 0.12)
      ..lineTo(cx + sw / 2, h + 2)
      ..close();
    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          colors: [Color.lerp(coat, Colors.white, 0.18)!, coat, Color.lerp(coat, Colors.black, 0.45)!],
          stops: const [0, 0.45, 1],
        ).createShader(Rect.fromLTWH(cx - sw / 2, shoulderTop, sw, h - shoulderTop)),
    );

    // Hemd + Krawatte
    final vTop = shoulderTop - h * 0.03;
    final shirt = Path()
      ..moveTo(cx - hw * 0.26, vTop)
      ..lineTo(cx + hw * 0.26, vTop)
      ..lineTo(cx, h * 0.93)
      ..close();
    canvas.drawPath(shirt, lit..color = _Fig.shirt);
    final tie = Path()
      ..moveTo(cx - hw * 0.06, vTop + h * 0.015)
      ..lineTo(cx + hw * 0.06, vTop + h * 0.015)
      ..lineTo(cx + hw * 0.08, h * 0.88)
      ..lineTo(cx, h * 0.93)
      ..lineTo(cx - hw * 0.08, h * 0.88)
      ..close();
    canvas.drawPath(tie, lit..color = Color.lerp(coat, _Fig.tie, 0.6)!);

    // Revers
    final lapelColor = Color.lerp(coat, Colors.black, 0.3)!;
    final lapelL = Path()
      ..moveTo(cx - hw * 0.3, vTop - h * 0.005)
      ..lineTo(cx - sw * 0.2, shoulderTop + h * 0.02)
      ..lineTo(cx - hw * 0.12, h * 0.98)
      ..lineTo(cx - hw * 0.02, h * 0.93)
      ..close();
    final lapelR = Path()
      ..moveTo(cx + hw * 0.3, vTop - h * 0.005)
      ..lineTo(cx + sw * 0.2, shoulderTop + h * 0.02)
      ..lineTo(cx + hw * 0.12, h * 0.98)
      ..lineTo(cx + hw * 0.02, h * 0.93)
      ..close();
    canvas.drawPath(lapelL, lit..color = lapelColor);
    canvas.drawPath(lapelR, lit..color = Color.lerp(lapelColor, Colors.black, 0.2)!);

    // Ohren
    final ear = Color.lerp(skin, Colors.black, 0.12)!;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - hw * 0.5, headCy + hh * 0.04), width: hw * 0.16, height: hh * 0.2),
      lit..color = ear,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + hw * 0.5, headCy + hh * 0.04), width: hw * 0.16, height: hh * 0.2),
      lit..color = Color.lerp(ear, Colors.black, 0.25)!,
    );

    // Kopf
    final headRect = Rect.fromCenter(center: Offset(cx, headCy), width: hw, height: hh);
    canvas.drawOval(
      headRect,
      Paint()
        ..shader = LinearGradient(
          colors: [Color.lerp(skin, Colors.white, 0.12)!, skin, Color.lerp(skin, Colors.black, 0.38)!],
          stops: const [0, 0.5, 1],
        ).createShader(headRect),
    );

    // Haar oben
    if (look.hat == 'none' || look.hat == 'bun' || look.hat == 'beret') {
      final top = Path()
        ..addArc(
          Rect.fromCenter(center: Offset(cx, headCy - hh * 0.02), width: hw * 1.06, height: hh * 1.02),
          math.pi * 1.02,
          math.pi * 0.96,
        )
        ..quadraticBezierTo(cx + hw * 0.1, headTop + hh * 0.22, cx - hw * 0.5, headCy - hh * 0.05)
        ..close();
      canvas.drawPath(top, lit..color = hair);
    } else {
      // Koteletten unter dem Hut
      canvas.drawRect(
        Rect.fromLTWH(cx - hw * 0.5, headCy - hh * 0.2, hw * 0.08, hh * 0.25),
        lit..color = hair.withValues(alpha: 0.9),
      );
      canvas.drawRect(
        Rect.fromLTWH(cx + hw * 0.42, headCy - hh * 0.2, hw * 0.08, hh * 0.25),
        lit..color = hair.withValues(alpha: 0.9),
      );
    }
    if (look.hat == 'bun') {
      canvas.drawCircle(Offset(cx + hw * 0.05, headTop - hh * 0.04), hw * 0.2, lit..color = hair);
      canvas.drawCircle(
        Offset(cx + hw * 0.0, headTop - hh * 0.07),
        hw * 0.06,
        lit..color = Color.lerp(hair, Colors.white, 0.15)!,
      );
    }

    // Gesicht
    final eyeY = headCy + hh * 0.02;
    final eye = Paint()..color = _Fig.eye;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - hw * 0.18, eyeY), width: hw * 0.1, height: hh * 0.045), eye);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + hw * 0.18, eyeY), width: hw * 0.1, height: hh * 0.045), eye);
    final brow = Paint()
      ..color = Color.lerp(hair, Colors.black, 0.2)!
      ..strokeWidth = math.max(1, hw * 0.045)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - hw * 0.27, eyeY - hh * 0.07), Offset(cx - hw * 0.09, eyeY - hh * 0.085), brow);
    canvas.drawLine(Offset(cx + hw * 0.09, eyeY - hh * 0.085), Offset(cx + hw * 0.27, eyeY - hh * 0.07), brow);
    final shade = Paint()
      ..color = Color.lerp(skin, Colors.black, 0.35)!
      ..strokeWidth = math.max(1, hw * 0.035)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx + hw * 0.02, eyeY + hh * 0.04), Offset(cx + hw * 0.06, eyeY + hh * 0.15), shade);
    canvas.drawLine(
      Offset(cx - hw * 0.1, eyeY + hh * 0.26),
      Offset(cx + hw * 0.1, eyeY + hh * 0.25),
      shade..color = Color.lerp(skin, _Fig.lips, 0.55)!,
    );

    // Hut
    _hat(canvas, look.hat, cx, headTop, hw, hh, hatColor);

    canvas.restore();

    // Noir-Seitenlicht über alles
    if (background) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..shader = const LinearGradient(
            colors: [Noir.clear, Noir.clear, Noir.shadow],
            stops: [0, 0.55, 1],
          ).createShader(Offset.zero & size),
      );
    }
  }

  void _hat(Canvas canvas, String hat, double cx, double top, double hw, double hh, Color color) {
    final p = Paint()..color = color;
    final hi = Paint()..color = Color.lerp(color, Colors.white, 0.14)!;
    final band = Paint()..color = Color.lerp(color, _Fig.black, 0.55)!;
    switch (hat) {
      case 'fedora':
        final brimY = top + hh * 0.17;
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, brimY), width: hw * 1.62, height: hh * 0.17), p);
        final crown = Path()
          ..moveTo(cx - hw * 0.46, brimY)
          ..lineTo(cx - hw * 0.4, top - hh * 0.2)
          ..quadraticBezierTo(cx - hw * 0.2, top - hh * 0.3, cx, top - hh * 0.22)
          ..quadraticBezierTo(cx + hw * 0.2, top - hh * 0.3, cx + hw * 0.4, top - hh * 0.2)
          ..lineTo(cx + hw * 0.46, brimY)
          ..close();
        canvas.drawPath(crown, p);
        canvas.drawRect(Rect.fromLTRB(cx - hw * 0.45, brimY - hh * 0.09, cx + hw * 0.45, brimY - hh * 0.01), band);
        canvas.drawLine(
          Offset(cx - hw * 0.3, top - hh * 0.18),
          Offset(cx - hw * 0.34, brimY - hh * 0.1),
          hi..strokeWidth = math.max(1, hw * 0.04),
        );
      case 'bowler':
        final brimY = top + hh * 0.15;
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, brimY), width: hw * 1.3, height: hh * 0.12), p);
        canvas.drawArc(
          Rect.fromCenter(center: Offset(cx, brimY), width: hw * 1.04, height: hh * 0.78),
          math.pi,
          math.pi,
          true,
          p,
        );
        canvas.drawRect(Rect.fromLTRB(cx - hw * 0.52, brimY - hh * 0.07, cx + hw * 0.52, brimY - hh * 0.01), band);
        canvas.drawArc(
          Rect.fromCenter(center: Offset(cx - hw * 0.12, brimY - hh * 0.1), width: hw * 0.5, height: hh * 0.4),
          math.pi * 1.1,
          math.pi * 0.35,
          false,
          hi
            ..style = PaintingStyle.stroke
            ..strokeWidth = math.max(1, hw * 0.04),
        );
        hi.style = PaintingStyle.fill;
      case 'cap':
        final capPath = Path()
          ..moveTo(cx - hw * 0.55, top + hh * 0.2)
          ..quadraticBezierTo(cx - hw * 0.6, top - hh * 0.14, cx, top - hh * 0.12)
          ..quadraticBezierTo(cx + hw * 0.62, top - hh * 0.12, cx + hw * 0.58, top + hh * 0.2)
          ..close();
        canvas.drawPath(capPath, p);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, top + hh * 0.2), width: hw * 1.18, height: hh * 0.1), band);
      case 'top':
        final brimY = top + hh * 0.16;
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, brimY), width: hw * 1.45, height: hh * 0.13), p);
        canvas.drawRect(Rect.fromLTRB(cx - hw * 0.42, top - hh * 0.62, cx + hw * 0.42, brimY), p);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, top - hh * 0.62), width: hw * 0.84, height: hh * 0.08), hi);
        canvas.drawRect(Rect.fromLTRB(cx - hw * 0.42, brimY - hh * 0.13, cx + hw * 0.42, brimY - hh * 0.04), band);
      case 'beret':
        canvas.save();
        canvas.translate(cx + hw * 0.08, top + hh * 0.02);
        canvas.rotate(-0.16);
        canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: hw * 1.25, height: hh * 0.34), p);
        canvas.drawOval(Rect.fromCenter(center: Offset(-hw * 0.1, -hh * 0.05), width: hw * 0.7, height: hh * 0.12), hi);
        canvas.drawRect(Rect.fromLTWH(-hw * 0.02, -hh * 0.24, hw * 0.05, hh * 0.08), p);
        canvas.restore();
      case 'cloche':
        final bell = Path()
          ..moveTo(cx - hw * 0.62, top + hh * 0.36)
          ..quadraticBezierTo(cx - hw * 0.62, top - hh * 0.2, cx, top - hh * 0.2)
          ..quadraticBezierTo(cx + hw * 0.62, top - hh * 0.2, cx + hw * 0.62, top + hh * 0.36)
          ..quadraticBezierTo(cx, top + hh * 0.26, cx - hw * 0.62, top + hh * 0.36)
          ..close();
        canvas.drawPath(bell, p);
        canvas.drawPath(
          Path()
            ..moveTo(cx - hw * 0.58, top + hh * 0.2)
            ..quadraticBezierTo(cx, top + hh * 0.1, cx + hw * 0.58, top + hh * 0.2)
            ..lineTo(cx + hw * 0.6, top + hh * 0.27)
            ..quadraticBezierTo(cx, top + hh * 0.17, cx - hw * 0.6, top + hh * 0.27)
            ..close(),
          band,
        );
        canvas.drawCircle(Offset(cx + hw * 0.35, top + hh * 0.16), hw * 0.07, Paint()..color = _Fig.brooch);
    }
  }

  @override
  bool shouldRepaint(covariant PortraitPainter old) =>
      old.look.coat != look.coat ||
      old.look.hat != look.hat ||
      old.look.hair != look.hair ||
      old.look.skin != look.skin ||
      old.look.build != look.build ||
      old.background != background ||
      old.accent != accent;
}

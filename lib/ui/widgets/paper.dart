import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Papierkarte (Akte, Notizzettel) mit leichtem Verlauf und Schatten.
class PaperCard extends StatelessWidget {
  const PaperCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = Noir.paper,
    this.tilt = 0,
    this.ruled = false,
    this.clip = false,
    this.tape = false,
    this.onTap,
    this.border,
    this.radius = 3,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double tilt;
  final bool ruled;
  final bool clip;
  final bool tape;
  final VoidCallback? onTap;
  final BoxBorder? border;
  final double radius;

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: border,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(color, Colors.white, 0.08)!, color, Color.lerp(color, Noir.paperShade, 0.45)!],
          stops: const [0, 0.55, 1],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x99000000), blurRadius: 14, offset: Offset(0, 6)),
          BoxShadow(color: Color(0x44000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: CustomPaint(
        painter: _PaperPainter(ruled: ruled),
        child: Padding(padding: padding, child: child),
      ),
    );
    if (onTap != null) {
      card = Material(
        type: MaterialType.transparency,
        child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(radius), child: card),
      );
    }
    if (clip || tape) {
      card = Stack(
        clipBehavior: Clip.none,
        children: [
          card,
          if (tape)
            Positioned(
              top: -9,
              left: 0,
              right: 0,
              child: Center(
                child: Transform.rotate(
                  angle: -0.04,
                  child: Container(
                    width: 74,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0x99E9DFB8),
                      border: Border.all(color: const Color(0x33FFFFFF)),
                    ),
                  ),
                ),
              ),
            ),
          if (clip) const Positioned(top: -10, left: 18, child: PaperClip()),
        ],
      );
    }
    if (tilt != 0) card = Transform.rotate(angle: tilt, child: card);
    return card;
  }
}

class _PaperPainter extends CustomPainter {
  _PaperPainter({required this.ruled});

  final bool ruled;

  @override
  void paint(Canvas canvas, Size size) {
    final r = math.Random(size.width.toInt() * 31 + size.height.toInt());
    final speck = Paint()..color = const Color(0x14000000);
    for (var i = 0; i < (size.width * size.height / 900).clamp(0, 400); i++) {
      canvas.drawCircle(Offset(r.nextDouble() * size.width, r.nextDouble() * size.height), r.nextDouble() * 0.8, speck);
    }
    if (ruled) {
      final line = Paint()
        ..color = const Color(0x2A2D5A8A)
        ..strokeWidth = 1;
      for (var y = 30.0; y < size.height - 6; y += 22) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
      }
      canvas.drawLine(
        const Offset(26, 0),
        Offset(26, size.height),
        Paint()
          ..color = const Color(0x55B23A3A)
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PaperPainter old) => old.ruled != ruled;
}

/// Gezeichnete Büroklammer.
class PaperClip extends StatelessWidget {
  const PaperClip({super.key, this.color = const Color(0xFFB8BCC6)});

  final Color color;

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: 16, height: 40, child: CustomPaint(painter: _ClipPainter(color)));
}

class _ClipPainter extends CustomPainter {
  _ClipPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.3, h * 0.75)
      ..lineTo(w * 0.3, h * 0.2)
      ..arcToPoint(Offset(w * 0.75, h * 0.2), radius: Radius.circular(w * 0.23))
      ..lineTo(w * 0.75, h * 0.9)
      ..arcToPoint(Offset(w * 0.1, h * 0.9), radius: Radius.circular(w * 0.33))
      ..lineTo(w * 0.1, h * 0.12);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _ClipPainter old) => false;
}

/// Gummistempel mit doppeltem Rahmen und abgenutzter Farbe.
class Stamp extends StatelessWidget {
  const Stamp({
    super.key,
    required this.text,
    this.color = Noir.bloodBright,
    this.fontSize = 22,
    this.angle = -0.1,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
  });

  final String text;
  final Color color;
  final double fontSize;
  final double angle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final style = Noir.title(fontSize, color: color, spacing: fontSize * 0.14);
    final tp = TextPainter(text: TextSpan(text: text.toUpperCase(), style: style), textDirection: TextDirection.ltr)
      ..layout();
    final size = Size(tp.width + padding.horizontal + 8, tp.height + padding.vertical + 8);
    return Transform.rotate(
      angle: angle,
      child: SizedBox.fromSize(size: size, child: CustomPaint(painter: _StampPainter(tp, color, padding))),
    );
  }
}

class _StampPainter extends CustomPainter {
  _StampPainter(this.tp, this.color, this.padding);

  final TextPainter tp;
  final Color color;
  final EdgeInsets padding;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.saveLayer(rect, Paint());
    final outer = RRect.fromRectAndRadius(rect.deflate(1.5), const Radius.circular(4));
    final inner = RRect.fromRectAndRadius(rect.deflate(5), const Radius.circular(2));
    final p = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(outer, p..strokeWidth = 2.6);
    canvas.drawRRect(inner, p..strokeWidth = 1.1);
    tp.paint(canvas, Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2 + 1));
    // Abnutzung
    final r = math.Random(tp.plainText.hashCode);
    final erase = Paint()..blendMode = BlendMode.dstOut;
    for (var i = 0; i < (size.width * size.height / 28).clamp(0, 900); i++) {
      erase.color = Color.fromRGBO(0, 0, 0, 0.35 + r.nextDouble() * 0.6);
      canvas.drawCircle(Offset(r.nextDouble() * size.width, r.nextDouble() * size.height), r.nextDouble() * 1.1, erase);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StampPainter old) => old.tp.plainText != tp.plainText || old.color != color;
}

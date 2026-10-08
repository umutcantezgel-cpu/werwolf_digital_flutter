import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Dunkler Noir-Hintergrund: Laternen-Schein, Regen, Körnung, Vignette.
class NoirBackdrop extends StatefulWidget {
  const NoirBackdrop({super.key, required this.child, this.accent = Noir.brass, this.rain = true});

  final Widget child;
  final Color accent;
  final bool rain;

  @override
  State<NoirBackdrop> createState() => _NoirBackdropState();
}

class _NoirBackdropState extends State<NoirBackdrop> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));

  @override
  void initState() {
    super.initState();
    if (widget.rain) _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -1.1),
              radius: 1.5,
              colors: [Color(0xFF262B4A), Noir.night, Color(0xFF06070D)],
              stops: [0, 0.55, 1],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.95, -0.95),
              radius: 0.9,
              colors: [widget.accent.withValues(alpha: 0.16), widget.accent.withValues(alpha: 0)],
            ),
          ),
        ),
        if (widget.rain)
          RepaintBoundary(
            child: CustomPaint(painter: _RainPainter(_c)),
          ),
        const RepaintBoundary(child: CustomPaint(painter: GrainPainter())),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 1.05,
              colors: [Color(0x00000000), Color(0x99000000)],
              stops: [0.55, 1],
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _RainPainter extends CustomPainter {
  _RainPainter(this.anim) : super(repaint: anim);

  final Animation<double> anim;
  static final _drops = List.generate(70, (i) {
    final r = math.Random(i * 7919 + 13);
    return (r.nextDouble(), r.nextDouble(), 0.5 + r.nextDouble() * 0.8, 0.04 + r.nextDouble() * 0.08);
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    for (final (x0, y0, speed, alpha) in _drops) {
      final len = 18 * speed + 8;
      final t = (y0 + anim.value * speed) % 1.0;
      final y = t * (size.height + 60) - 30;
      final x = (x0 * (size.width + 80) - 40) + y * 0.12;
      p.color = Color.fromRGBO(200, 210, 255, alpha);
      canvas.drawLine(Offset(x, y), Offset(x + len * 0.12, y + len), p);
    }
  }

  @override
  bool shouldRepaint(covariant _RainPainter old) => false;
}

/// Feine Filmkörnung.
class GrainPainter extends CustomPainter {
  const GrainPainter({this.opacity = 0.05, this.density = 0.0035});

  final double opacity;
  final double density;

  @override
  void paint(Canvas canvas, Size size) {
    final r = math.Random(42);
    final n = (size.width * size.height * density).clamp(0, 6000).toInt();
    final light = Paint()..color = Color.fromRGBO(255, 255, 255, opacity);
    final dark = Paint()..color = Color.fromRGBO(0, 0, 0, opacity * 2);
    for (var i = 0; i < n; i++) {
      final o = Offset(r.nextDouble() * size.width, r.nextDouble() * size.height);
      canvas.drawCircle(o, r.nextDouble() * 0.9 + 0.3, i.isEven ? light : dark);
    }
  }

  @override
  bool shouldRepaint(covariant GrainPainter old) => false;
}

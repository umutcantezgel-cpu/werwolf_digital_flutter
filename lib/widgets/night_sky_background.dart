import 'dart:math';
import 'package:flutter/material.dart';
import '../config/design_tokens.dart';

class NightSkyBackground extends StatefulWidget {
  final Widget? child;
  final int starCount;
  final bool isTesting;

  const NightSkyBackground({
    super.key,
    this.child,
    this.starCount = 100,
    this.isTesting = false,
  });

  @override
  State<NightSkyBackground> createState() => _NightSkyBackgroundState();
}

class _NightSkyBackgroundState extends State<NightSkyBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Star> _stars;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60), // Long loop
    );
    if (!widget.isTesting) {
      _controller.repeat();
    }

    _initStars();
  }

  void _initStars() {
    _stars = List.generate(widget.starCount, (index) {
      return Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2.0 + 0.5,
        baseOpacity: _random.nextDouble() * 0.5 + 0.2,
        twinkleSpeed: _random.nextDouble() * 2 + 0.5,
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 0.05, // Slow horizontal drift
          (_random.nextDouble() - 0.5) * 0.02, // Very slow vertical
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Gradient & Particles
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: NightSkyPainter(
                  stars: _stars,
                  animationValue: _controller.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        ),
        // Child Content
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class Star {
  double x;
  double y;
  final double size;
  final double baseOpacity;
  final double twinkleSpeed;
  final Offset velocity;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.baseOpacity,
    required this.twinkleSpeed,
    required this.velocity,
  });
}

class NightSkyPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  NightSkyPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Night Gradient
    final Rect rect = Offset.zero & size;
    const Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        DesignColors.nightBlack, // Deepest black at top
        DesignColors.nightMid, // Lighter horizon
      ],
      stops: [0.0, 1.0],
    );

    final Paint bgPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // 2. Draw Stars
    final Paint starPaint = Paint()..color = Colors.white;

    for (var i = 0; i < stars.length; i++) {
      final star = stars[i];

      // Update position (simple wrap-around physics)
      // Note: In paint(), we shouldn't mutate state ideally, but for simple particles it's often done
      // or passed pre-calculated. For strict correctness we should update in controller listener.
      // But for performance in this specific MVP architecture, calculating "current" pos based on time is better.

      // Calculate twinkling
      // Sine wave based on time + star's unique speed
      final double twinkle =
          sin((animationValue * 2 * pi) * star.twinkleSpeed + i);
      final double opacity =
          (star.baseOpacity + (twinkle * 0.2)).clamp(0.1, 1.0);

      // Calculate drift position based on animation loop
      // We essentially scroll them slowly
      double currentX = star.x +
          (star.velocity.dx *
              animationValue *
              10); // Multiplier for noticeable movement
      double currentY = star.y + (star.velocity.dy * animationValue * 10);

      // Wrap logic (modulo)
      currentX = currentX % 1.0;
      currentY = currentY % 1.0;
      if (currentX < 0) currentX += 1.0;
      if (currentY < 0) currentY += 1.0;

      final double drawX = currentX * size.width;
      final double drawY = currentY * size.height;

      starPaint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(drawX, drawY), star.size, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant NightSkyPainter oldDelegate) {
    return true; // Repaint every frame for animation
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
// import '../config/theme.dart'; // Unused
import '../config/constants.dart';

class AmbientBackground extends StatefulWidget {
  final GamePhase phase;
  final Widget child;

  const AmbientBackground({
    super.key,
    required this.phase,
    required this.child,
  });

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  bool get _isNight =>
      widget.phase == GamePhase.night ||
      widget.phase == GamePhase.roleDistribution ||
      widget.phase == GamePhase.firstNight; // Add firstNight if implementing

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Loop duration
    )..repeat();

    // Generate initial particles
    _generateParticles();
  }

  void _generateParticles() {
    _particles.clear();
    int count = _isNight ? 50 : 30; // More stars at night, fewer motes at day
    for (int i = 0; i < count; i++) {
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: _random.nextDouble() * 0.2 + 0.05,
        size: _random.nextDouble() * 3 + 1,
        opacity: _random.nextDouble() * 0.5 + 0.1,
      ));
    }
  }

  @override
  void didUpdateWidget(AmbientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.phase != oldWidget.phase) {
      // Regenerate particles logic if needed, or transition
      // For now, simpler regeneration
      _generateParticles();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define Gradients
    final LinearGradient gradient = _isNight
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0E21), // Deep Navy
              Color(0xFF1A1F3C), // Lighter Navy
              Color(0xFF2D1B4E), // Deep Purple hint at bottom
            ],
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // Sky Blue top
              Color(0xFFFFF7E6), // Warm White bottom
            ],
          );

    return Stack(
      children: [
        // Background Gradient
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: gradient),
          ),
        ),

        // Particles (Stars/Motes)
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  particles: _particles,
                  progress: _controller.value,
                  isNight: _isNight,
                ),
              );
            },
          ),
        ),

        // Celestial Body (Sun/Moon)
        // Positioned based on time/phase could go here.
        // For now, keep it simple.

        // Content
        Positioned.fill(child: widget.child),
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  double speed;
  double size;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final bool isNight;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.isNight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      // Move particle
      double dy = 0;
      if (isNight) {
        // Stars twinkle but don't move much, or slow drift
        // Let's make them blink by using progress
        double flicker =
            sin(progress * 2 * pi * particle.speed + particle.x * 10);
        paint.color = Colors.white.withValues(
            alpha: (particle.opacity + flicker * 0.1).clamp(0.0, 1.0));
      } else {
        // Day particles (dust) float up
        dy = -(progress * particle.speed);
        // Wrap around
        double currentY = (particle.y + dy) % 1.0;
        if (currentY < 0) currentY += 1.0;

        paint.color = Colors.amber.withValues(alpha: particle.opacity);

        // Draw at currentY
        canvas.drawCircle(
          Offset(particle.x * size.width, currentY * size.height),
          particle.size,
          paint,
        );
        continue; // Skip the draw below
      }

      // Draw particle (Night stars or simple fallback)
      if (isNight) {
        canvas.drawCircle(
          Offset(particle.x * size.width, particle.y * size.height),
          particle.size,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return true; // Always repaint for animation
  }
}

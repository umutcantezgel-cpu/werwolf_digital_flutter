import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:werwolf_digital_flutter/config/design_tokens.dart';

class MoonWidget extends StatelessWidget {
  final double size;

  const MoonWidget({
    super.key,
    this.size = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DesignColors.moonPrimary, // Pale yellow/white
            DesignColors.moonGlow, // Slightly darker crater shade
          ],
        ),
        boxShadow: [
          // Inner Glow
          BoxShadow(
            color: DesignColors.moonPrimary.withValues(alpha: 0.8),
            blurRadius: 20,
            spreadRadius: -5,
          ),
          // Outer Glow (Halo)
          BoxShadow(
            color: DesignColors.moonPrimary.withValues(alpha: 0.2),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            duration: 3000.ms,
            curve: Curves.easeInOut)
        .boxShadow(
            begin: BoxShadow(
              color: DesignColors.moonPrimary.withValues(alpha: 0.2),
              blurRadius: 40,
              spreadRadius: 10,
            ),
            end: BoxShadow(
              color: DesignColors.moonPrimary.withValues(alpha: 0.35),
              blurRadius: 50,
              spreadRadius: 15,
            ),
            duration: 3000.ms,
            curve: Curves.easeInOut);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/design_tokens.dart';

class HeartbeatOverlay extends StatelessWidget {
  const HeartbeatOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.transparent,
              DesignColors.wolfRed.withValues(alpha: 0.0), // center
              DesignColors.wolfRed.withValues(alpha: 0.4), // edge
            ],
            stops: const [0.0, 0.4, 1.0],
            radius: 1.2,
          ),
        ),
      )
          .animate(onPlay: (controller) => controller.repeat())
          // Lub-dub... Lub-dub...
          .fadeIn(duration: 200.ms, curve: Curves.easeIn)
          .fadeOut(delay: 200.ms, duration: 200.ms)
          .fadeIn(delay: 400.ms, duration: 200.ms) // Lub
          .fadeOut(delay: 600.ms, duration: 600.ms), // Dub... wait
    );
  }
}

class SeerMistOverlay extends StatelessWidget {
  const SeerMistOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              DesignColors.roleSeherin.withValues(alpha: 0.1),
              Colors.transparent,
            ],
            center: Alignment.bottomCenter,
            radius: 1.5,
          ),
        ),
      )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.2, 1.2),
              duration: 4.seconds,
              curve: Curves.easeInOut)
          .fade(
              begin: 0.3,
              end: 0.6,
              duration: 4.seconds,
              curve: Curves.easeInOut),
    );
  }
}

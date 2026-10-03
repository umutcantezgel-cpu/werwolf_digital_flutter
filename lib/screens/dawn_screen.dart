import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import 'package:werwolf_digital_flutter/config/design_tokens.dart';

/// Screen showing the dawn transition with sunrise and night results
class DawnScreen extends StatefulWidget {
  const DawnScreen({super.key});

  @override
  State<DawnScreen> createState() => _DawnScreenState();
}

class _DawnScreenState extends State<DawnScreen> {
  bool _autoAdvanceScheduled = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final narration = gameProvider.gameState.narration;
        final round = gameProvider.gameState.round;

        // Auto-advance in solo mode after 5 seconds
        _scheduleAutoAdvance(gameProvider);

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFF8C00), // Orange sunrise
                Color(0xFFFFD700), // Golden
                Color(0xFF87CEEB), // Sky blue
              ],
              stops: [0.0, 0.4, 1.0],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Sun Icon
                  const Icon(
                    Icons.wb_sunny,
                    size: 100,
                    color: DesignColors.dayLighter,
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.0, 1.0),
                        duration: 1.5.seconds,
                        curve: Curves.easeOutBack,
                      )
                      .fadeIn(),

                  const SizedBox(height: 40),

                  // Title
                  Text(
                    'MORGENDÄMMERUNG',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: DesignColors.textNightPrimary,
                      letterSpacing: 4.0,
                      shadows: [
                        Shadow(
                          color: DesignColors.nightBlack.withValues(alpha: 0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 8),

                  Text(
                    'Runde $round',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: DesignColors.textNightPrimary,
                    ),
                  ).animate(delay: 700.ms).fadeIn(),

                  const SizedBox(height: 32),

                  // Narration (night results)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: DesignColors.nightSubtle,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      narration.isNotEmpty
                          ? narration
                          : 'Die Nacht ist vorbei.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: DesignColors.textNightPrimary,
                        height: 1.4,
                      ),
                    ),
                  ).animate(delay: 1.seconds).fadeIn(),

                  const SizedBox(height: 40),

                  // Hint for solo mode
                  if (gameProvider.isSoloMode)
                    Text(
                      'Der Tag beginnt...',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: DesignColors.textNightSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ).animate(delay: 3.seconds).fadeIn(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _scheduleAutoAdvance(GameProvider gameProvider) {
    if (gameProvider.isSoloMode && !_autoAdvanceScheduled) {
      _autoAdvanceScheduled = true;
      Future.delayed(const Duration(seconds: 7), () {
        if (mounted && gameProvider.isSoloMode) {
          gameProvider.nextPhase();
        }
      });
    }
  }
}

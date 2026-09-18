import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/design_tokens.dart';
import '../providers/game_provider.dart';

/// Screen showing the result of a vote execution
class ExecutionScreen extends StatefulWidget {
  const ExecutionScreen({super.key});

  @override
  State<ExecutionScreen> createState() => _ExecutionScreenState();
}

class _ExecutionScreenState extends State<ExecutionScreen> {
  bool _autoAdvanceScheduled = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final narration = gameProvider.gameState.narration;

        // Auto-advance in solo mode after 4 seconds
        _scheduleAutoAdvance(gameProvider);

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A1A2E),
                Color(0xFF0F0F1A),
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Gavel / Execution Icon
                  const Icon(
                    Icons.gavel,
                    size: 80,
                    color: DesignColors.dayWarm,
                  )
                      .animate()
                      .scale(duration: 500.ms, curve: Curves.elasticOut)
                      .then()
                      .shake(duration: 300.ms),

                  const SizedBox(height: 40),

                  // Title
                  Text(
                    'DAS URTEIL',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: DesignColors.dayWarm,
                      letterSpacing: 4.0,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 24),

                  // Narration (result)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: DesignColors.dayWarm.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      narration.isNotEmpty
                          ? narration
                          : 'Das Dorf hat entschieden.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ).animate(delay: 400.ms).fadeIn(),

                  const SizedBox(height: 40),

                  // Waiting indicator
                  if (gameProvider.isSoloMode)
                    Text(
                      'Weiter geht\'s...',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                      ),
                    ).animate(delay: 2.seconds).fadeIn(),
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
      Future.delayed(const Duration(seconds: 6), () {
        if (mounted && gameProvider.isSoloMode) {
          gameProvider.nextPhase();
        }
      });
    }
  }
}

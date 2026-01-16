import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';

class PhaseIndicator extends StatelessWidget {
  const PhaseIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final narration = gameProvider.gameState.narration;
        final phase = gameProvider.gameState.gamePhase;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: double.infinity,
          color: Theme.of(context)
              .appBarTheme
              .backgroundColor
              ?.withValues(alpha: 0.5),
          child: Column(
            children: [
              Text(
                'Phase: ${phase.toString().split('.').last}',
                style: TextStyle(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                narration,
                style: TextStyle(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

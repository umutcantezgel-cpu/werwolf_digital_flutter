import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:go_router/go_router.dart';

class GameEndScreen extends StatelessWidget {
  const GameEndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final winnerNarration = gameProvider.gameState.narration;

        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Spiel vorbei!',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    winnerNarration,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () {
                      gameProvider.resetGame(); // Reset game state
                      context.go('/'); // Go back to home screen
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    child: const Text('Neues Spiel starten'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/config/design_tokens.dart';
import 'package:werwolf_digital_flutter/services/haptic_manager.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LobbyScreen extends StatelessWidget {
  final String roomCode;

  const LobbyScreen({super.key, required this.roomCode});

  void _startGame(BuildContext context, GameProvider gameProvider) {
    HapticManager().impactLight();
    if (gameProvider.gameState.players.isEmpty) {
      // NOTE: Set back to 5 for production!
      HapticManager().impactHeavy();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Es wird mindestens 1 Spieler benötigt.')),
      );
      return;
    }
    gameProvider.startGame();
    context.go('/role-reveal');
  }

  @override
  Widget build(BuildContext context) {
    // using DesignTokens directly

    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final currentPlayer = gameProvider.gameState.players.isNotEmpty
            ? gameProvider.gameState.players.last
            : null;
        final isHost = currentPlayer?.isHost ?? false;

        return Scaffold(
          backgroundColor: DesignColors.nightBlack,
          appBar: AppBar(
            backgroundColor: DesignColors.nightDeep,
            title: const Text(
              'LOBBY',
              style: TextStyle(
                fontFamily: DesignTypography.fontDisplay,
                color: DesignColors.moonPrimary,
                letterSpacing: 2,
              ),
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(DesignSpacings.s16),
            child: Column(
              children: [
                Text('RAUM-CODE',
                    style: TextStyle(
                      fontFamily: DesignTypography.fontBody,
                      color: DesignColors.moonPrimary.withValues(alpha: 0.6),
                      letterSpacing: 1,
                    )).animate().fadeIn(),
                SelectableText(
                  gameProvider.gameState.roomCode,
                  style: const TextStyle(
                    fontFamily: DesignTypography.fontDisplay,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: DesignColors.dayBright,
                    letterSpacing: 4,
                  ),
                ).animate().fadeIn().scale(),
                const SizedBox(height: DesignSpacings.s24),
                Text('SPIELER (${gameProvider.gameState.players.length}/15)',
                    style: const TextStyle(
                      fontFamily: DesignTypography.fontDisplay,
                      fontSize: DesignTypography.textLg,
                      color: DesignColors.moonPrimary,
                    )).animate().fadeIn(),
                const SizedBox(height: DesignSpacings.s8),
                Expanded(
                  child: ListView.builder(
                    itemCount: gameProvider.gameState.players.length,
                    itemBuilder: (context, index) {
                      final player = gameProvider.gameState.players[index];
                      return Container(
                        margin:
                            const EdgeInsets.only(bottom: DesignSpacings.s8),
                        decoration: BoxDecoration(
                            color: DesignColors.nightSubtle,
                            borderRadius:
                                BorderRadius.circular(DesignSpacings.s8),
                            border: Border.all(
                              color: player.isHost
                                  ? DesignColors.dayBright.withValues(alpha: 0.3)
                                  : Colors.transparent,
                            )),
                        child: ListTile(
                          leading: Icon(
                            player.isHost ? Icons.star : Icons.person,
                            color: player.isHost
                                ? DesignColors.dayBright
                                : DesignColors.moonPrimary.withValues(alpha: 0.7),
                          ),
                          title: Text(
                            player.name,
                            style: TextStyle(
                              color: DesignColors.moonPrimary,
                              fontWeight: player.isHost
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      )
                          .animate(delay: Duration(milliseconds: 50 * index))
                          .fadeIn()
                          .slideX();
                    },
                  ),
                ),
                const SizedBox(height: DesignSpacings.s24),
                if (isHost)
                  ElevatedButton(
                    onPressed: () => _startGame(context, gameProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DesignColors.dayWarm,
                      foregroundColor: DesignColors.nightBlack,
                      minimumSize: const Size(double.infinity, 50),
                      textStyle: const TextStyle(
                        fontFamily: DesignTypography.fontBody,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    child: const Text('SPIEL STARTEN'),
                  ).animate().fadeIn().slideY(begin: 0.2)
                else
                  Container(
                    padding: const EdgeInsets.all(DesignSpacings.s16),
                    decoration: BoxDecoration(
                      color: DesignColors.nightDeep,
                      borderRadius: BorderRadius.circular(DesignSpacings.s8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    DesignColors.moonPrimary.withValues(alpha: 0.5))),
                        const SizedBox(width: DesignSpacings.s16),
                        Text(
                          'Warte auf Host...',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: DesignColors.moonPrimary.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(),
              ],
            ),
          ),
        );
      },
    );
  }
}

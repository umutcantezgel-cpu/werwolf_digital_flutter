import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/config/constants.dart';
import 'package:werwolf_digital_flutter/models/role.dart';
import '../widgets/cinematic_role_reveal.dart';
import '../widgets/role_card.dart';
import '../widgets/night_sky_background.dart';

class RoleRevealScreen extends StatefulWidget {
  final bool isTesting;
  const RoleRevealScreen({super.key, this.isTesting = false});

  @override
  State<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        // Find the human player using myPlayerId
        final myId = gameProvider.myPlayerId;
        final me = gameProvider.gameState.players.firstWhere(
          (p) => p.id == myId,
          orElse: () => gameProvider.gameState.players.isNotEmpty
              ? gameProvider.gameState.players.first
              : throw Exception('No players in game'),
        );

        final role = roles[me.role] ?? roles[RoleType.unassigned];

        if (role == null) {
          return const Scaffold(
              body: Center(child: Text('Fehler: Rolle nicht gefunden.')));
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: NightSkyBackground(
            isTesting: widget.isTesting,
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: CinematicRoleReveal(
                    isTesting: widget.isTesting,
                    // Front is the Result (Revealed)
                    front: RoleCard(
                      role: role,
                      isRevealed: true,
                      isTesting: widget.isTesting,
                      onConfirm: () {
                        if (!widget.isTesting) {
                          if (gameProvider.isSoloMode) {
                            gameProvider.nextPhase();
                          }
                          final roomCode = gameProvider.gameState.roomCode;
                          context.go('/game/$roomCode');
                        }
                      },
                    ),
                    // Back is the Initial State (Hidden)
                    back: RoleCard(
                      role: role,
                      isRevealed: false,
                      isTesting: widget.isTesting,
                    ),
                    onRevealComplete: () {
                      // Don't auto-navigate here - let the user click VERSTANDEN button
                      // The onConfirm callback in RoleCard handles navigation
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/models/role.dart' hide ActionType;
import 'package:werwolf_digital_flutter/models/night_action.dart';
import 'package:werwolf_digital_flutter/models/player.dart';
import 'package:werwolf_digital_flutter/widgets/player_avatar.dart';
import 'package:werwolf_digital_flutter/widgets/night_sky_background.dart';
import 'package:werwolf_digital_flutter/widgets/moon_widget.dart';
import 'package:werwolf_digital_flutter/widgets/night_effects.dart';
import 'package:werwolf_digital_flutter/config/design_tokens.dart';

class NightScreen extends StatefulWidget {
  const NightScreen({super.key});

  @override
  State<NightScreen> createState() => _NightScreenState();
}

class _NightScreenState extends State<NightScreen> {
  String? _selectedPlayerId; // To track chosen target
  bool _autoAdvanceScheduled = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final gameState = gameProvider.gameState;
        final players = gameState.players;
        final me = gameProvider.myPlayerId != null
            ? players.firstWhere((p) => p.id == gameProvider.myPlayerId,
                orElse: () => Player(
                    id: 'unknown', name: 'Unknown', role: RoleType.unassigned))
            : null;

        // If generic night (not my turn or dead)
        if (me == null || !me.isAlive) {
          // Auto-advance for passive roles in solo mode
          _scheduleAutoAdvance(gameProvider);
          return _buildImmersiveScaffold(
            child: _buildPassiveContent(context),
          );
        }

        bool isActiveRole = false;
        String actionPrompt = '';
        List<Player> targetablePlayers = [];
        Widget? roleOverlay;

        // Logic
        if (me.role == RoleType.werwolf) {
          isActiveRole = true;
          actionPrompt = 'Wähle ein Opfer';
          roleOverlay = const HeartbeatOverlay();
          targetablePlayers = players
              .where((p) => p.isAlive && p.role != RoleType.werwolf)
              .toList();
        } else if (me.role == RoleType.seherin) {
          isActiveRole = true;
          actionPrompt = 'Wessen Identität möchtest du sehen?';
          roleOverlay = const SeerMistOverlay();
          targetablePlayers = players.where((p) => p.isAlive).toList();
        }

        if (isActiveRole) {
          return _buildImmersiveScaffold(
            overlay: roleOverlay,
            child: _buildActiveContent(
                context, actionPrompt, targetablePlayers, gameProvider),
          );
        } else {
          // Passive role (Dorfbewohner, etc.) - auto-advance in solo mode
          _scheduleAutoAdvance(gameProvider);
          return _buildImmersiveScaffold(
            child: _buildPassiveContent(context),
          );
        }
      },
    );
  }

  void _scheduleAutoAdvance(GameProvider gameProvider) {
    if (gameProvider.isSoloMode && !_autoAdvanceScheduled) {
      _autoAdvanceScheduled = true;
      // Wait 8 seconds to let the user experience the Night atmosphere
      Future.delayed(const Duration(seconds: 8), () {
        if (mounted && gameProvider.isSoloMode) {
          gameProvider.nextPhase();
        }
      });
    }
  }

  Widget _buildImmersiveScaffold({required Widget child, Widget? overlay}) {
    return Scaffold(
      backgroundColor: DesignColors.nightBlack,
      body: NightSkyBackground(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Moon
            const Positioned(
              top: 80,
              child: MoonWidget(size: 140),
            ),

            if (overlay != null) Positioned.fill(child: overlay),

            // Main Content Area
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassiveContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 120), // Spacer for Moon
          Text(
            "DIE NACHT",
            style: GoogleFonts.spaceGrotesk(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: DesignColors.textNightPrimary,
              letterSpacing: 8.0,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 2.seconds)
              .shimmer(duration: 5.seconds, color: DesignColors.moonGlow),

          const SizedBox(height: 20),

          Text(
            "Schließe deine Augen...",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              color: DesignColors.textNightSecondary,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 1.seconds).fadeIn(duration: 1.seconds),
        ],
      ),
    );
  }

  Widget _buildActiveContent(BuildContext context, String prompt,
      List<Player> targetablePlayers, GameProvider gameProvider) {
    return Column(
      children: [
        const SizedBox(height: 220), // Push below moon

        // Prompt
        Text(
          prompt.toUpperCase(),
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: DesignColors.textNightPrimary,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn().slideY(begin: 0.2, end: 0),

        const SizedBox(height: 30),

        // Player Grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 25, // More breathing room
              childAspectRatio: 0.75,
            ),
            itemCount: targetablePlayers.length,
            itemBuilder: (context, index) {
              final player = targetablePlayers[index];
              return PlayerAvatar(
                playerName: player.name,
                isAlive: player.isAlive,
                isSelected: _selectedPlayerId == player.id,
                onTap: () {
                  setState(() {
                    _selectedPlayerId = player.id;
                  });
                },
              ).animate(delay: (index * 100).ms).fadeIn().scale();
            },
          ),
        ),

        // Action Button
        if (_selectedPlayerId != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              onPressed: () {
                // Determine action type based on player role
                final me = gameProvider.gameState.players.firstWhere(
                  (p) => p.id == gameProvider.myPlayerId,
                );
                ActionType actionType;
                if (me.role == RoleType.werwolf) {
                  actionType = ActionType.kill;
                } else if (me.role == RoleType.seherin) {
                  actionType = ActionType.see;
                } else if (me.role == RoleType.hexe) {
                  // Witch can heal or poison; for simplicity, default to heal
                  actionType = ActionType.heal;
                } else {
                  actionType = ActionType.none;
                }

                // Submit night action to GameProvider
                gameProvider.submitNightAction(actionType, _selectedPlayerId);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Aktion für ${targetablePlayers.firstWhere((p) => p.id == _selectedPlayerId).name} gewählt.',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );

                // In solo mode, auto-advance to next phase after action
                if (gameProvider.isSoloMode) {
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    if (mounted) {
                      gameProvider.nextPhase();
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DesignColors.wolfRed, // Dramatic action color
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 10,
                shadowColor: DesignColors.wolfRed.withOpacity(0.5),
              ),
              child: Text(
                'BESTÄTIGEN',
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
              ),
            )
                .animate()
                .scale(curve: Curves.elasticOut, duration: 300.ms)
                .shimmer(),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/widgets/player_avatar.dart';
import 'package:werwolf_digital_flutter/widgets/tension_timer_widget.dart';
import 'package:werwolf_digital_flutter/config/design_tokens.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  String? _selectedPlayerId;
  bool _hasVoted = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final livingPlayers =
            gameProvider.gameState.players.where((p) => p.isAlive).toList();

        return Scaffold(
          backgroundColor: DesignColors.dayLighter,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Title
                  Text(
                    'ABSTIMMUNG',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: DesignColors.dayDark,
                      letterSpacing: 1.5,
                    ),
                  ).animate().fadeIn().slideY(begin: -0.5, end: 0),

                  const SizedBox(height: 8),

                  Text(
                    'Wen wollt ihr hängen?',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: DesignColors.textDaySecondary,
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 16),

                  // Timer
                  TensionTimerWidget(
                    duration: gameProvider.isSoloMode ? 10.seconds : 15.seconds,
                    onTimerFinished: () {
                      // Auto-advance in solo mode (skip if no vote)
                      if (gameProvider.isSoloMode && !_hasVoted) {
                        gameProvider.nextPhase();
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  // Players Grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 25,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: livingPlayers.length,
                      itemBuilder: (context, index) {
                        final player = livingPlayers[index];
                        final isSelected = _selectedPlayerId == player.id;

                        return GestureDetector(
                          onTap: _hasVoted
                              ? null
                              : () {
                                  setState(() {
                                    _selectedPlayerId = player.id;
                                  });
                                },
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              PlayerAvatar(
                                playerName: player.name,
                                isAlive: true,
                                isSelected: isSelected,
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: DesignColors.dayOrange,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ).animate().scale(curve: Curves.elasticOut),
                                ),
                            ],
                          ),
                        ).animate(delay: (index * 50).ms).scale();
                      },
                    ),
                  ),

                  // Confirm Button
                  if (_selectedPlayerId != null && !_hasVoted)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DesignColors.dayOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          textStyle: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Submit vote to GameProvider
                          gameProvider.submitVote(_selectedPlayerId!);
                          setState(() {
                            _hasVoted = true;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Stimme abgegeben.',
                                style: GoogleFonts.inter(),
                              ),
                              backgroundColor: DesignColors.dayDark,
                              duration: const Duration(seconds: 1),
                            ),
                          );

                          // In solo mode, auto-advance after voting
                          if (gameProvider.isSoloMode) {
                            Future.delayed(const Duration(milliseconds: 1500),
                                () {
                              if (context.mounted) {
                                gameProvider.nextPhase();
                              }
                            });
                          }
                        },
                        child: const Text('BESTÄTIGEN'),
                      ).animate().fadeIn().slideY(begin: 1, end: 0),
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

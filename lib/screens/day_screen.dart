import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/widgets/player_avatar.dart';
import 'package:werwolf_digital_flutter/widgets/death_announcement_overlay.dart';
import 'package:werwolf_digital_flutter/widgets/tension_timer_widget.dart';
import 'package:werwolf_digital_flutter/config/design_tokens.dart';
import 'package:werwolf_digital_flutter/widgets/in_game_chat.dart';

class DayScreen extends StatefulWidget {
  const DayScreen({super.key});

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  bool _showAnnouncement = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final players = gameProvider.gameState.players;
        final livingPlayers = players.where((p) => p.isAlive).toList();
        final deadPlayers = players.where((p) => !p.isAlive).toList();

        // In a real implementation, we'd check `gameState.deadPlayerIdsThisRound`
        // For MVP, we'll confirm dead players if any exist
        final deadNames = gameProvider.gameState.deadPlayerIdsThisRound
            .map((id) => players.firstWhere((p) => p.id == id).name)
            .toList();

        return Scaffold(
          body: Stack(
            children: [
              // Safe, Bright Day Background
              Container(
                color: DesignColors.dayLighter,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Header
                        Text(
                          'DISKUSSION',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: DesignColors.dayDark,
                            letterSpacing: 1.5,
                          ),
                        ).animate().fadeIn().slideY(begin: -0.5, end: 0),

                        const SizedBox(height: 8),

                        Text(
                          "Wer ist der Werwolf?",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: DesignColors.textDaySecondary,
                          ),
                        ).animate().fadeIn(delay: 200.ms),

                        const SizedBox(height: 16),

                        // Discussion Timer
                        TensionTimerWidget(
                          duration: gameProvider.isSoloMode
                              ? 30.seconds // Improved pacing for solo
                              : 30.seconds,
                          onTimerFinished: () {
                            // Auto-advance to voting in solo mode
                            if (gameProvider.isSoloMode) {
                              gameProvider.nextPhase();
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        // Living Players Grid
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
                              return PlayerAvatar(
                                playerName: player.name,
                                isAlive: true,
                                // Day theme: bright avatars
                              )
                                  .animate(delay: (index * 100).ms)
                                  .scale(curve: Curves.easeOutBack);
                            },
                          ),
                        ),

                        // Graveyard (Bottom)
                        if (deadPlayers.isNotEmpty) ...[
                          const Divider(color: DesignColors.dayDark),
                          Text(
                            "Friedhof (${deadPlayers.length})",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: DesignColors.textDayMuted,
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: deadPlayers.map((player) {
                              return Chip(
                                label: Text(player.name),
                                backgroundColor: Colors.grey[300],
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Death Announcement Overlay (fires once on entry)
              if (_showAnnouncement)
                DeathAnnouncementOverlay(
                  deadPlayerNames: deadNames, // Pass actual dead
                  onDismissed: () {
                    setState(() {
                      _showAnnouncement = false;
                    });
                  },
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: DesignColors.nightBlack,
            child: const Icon(Icons.chat_bubble_outline,
                color: DesignColors.dayBright),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 50,
                  ),
                  child: const InGameChat(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

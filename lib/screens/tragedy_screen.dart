import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';

class TragedyScreen extends StatefulWidget {
  final bool isTesting;
  const TragedyScreen({super.key, this.isTesting = false});

  @override
  State<TragedyScreen> createState() => _TragedyScreenState();
}

class _TragedyScreenState extends State<TragedyScreen> {
  @override
  void initState() {
    super.initState();
    _playTragedySequence();
  }

  Future<void> _playTragedySequence() async {
    // 1. Initial Impact
    if (!widget.isTesting) await HapticFeedback.heavyImpact();

    // 2. Wait for reading
    if (!widget.isTesting) await Future.delayed(const Duration(seconds: 5));

    // 3. Auto-advance to Day (Host Only) - Clients wait for state update
    if (mounted) {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      // We don't auto-advance here because GameEngine might handle it or we need a button.
      // However, for "Cinematic" flow, auto-advance is better.
      // Only HOST should advance.
      if (gameProvider.isHost && !widget.isTesting) {
        gameProvider.nextPhase();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameProvider>().gameState;

    // Identify the victim
    final victimId = gameState.lastKilledPlayerId;
    final victim = (victimId != null && victimId.isNotEmpty)
        ? gameState.players.firstWhere((p) => p.id == victimId,
            orElse: () => gameState.players.first)
        : null;

    return Scaffold(
      backgroundColor: Colors.black, // Fallback
      body: Stack(
        children: [
          // 1. Red Pulse Background
          if (!widget.isTesting)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.2),
                    radius: 1.2,
                    colors: [
                      Color(0xFF8B0000), // Dark Red
                      Colors.black,
                    ],
                    stops: [0.2, 1.0],
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 2.seconds),
            )
          else
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.2),
                    radius: 1.2,
                    colors: [
                      Color(0xFF8B0000), // Dark Red
                      Colors.black,
                    ],
                    stops: [0.2, 1.0],
                  ),
                ),
              ),
            ),

          // 2. Blood Overlay (Optional, using opacity)
          Positioned.fill(
            child: Container(color: Colors.red.withOpacity(0.1)),
          ),

          // 3. Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // "TRAGÖDIE"
                if (!widget.isTesting)
                  Text(
                    "TRAGÖDIE",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.red.withOpacity(0.8),
                      // shadows: [ ... ]
                    ),
                  ).animate().shake(duration: 500.ms, hz: 5).scale(
                      begin: const Offset(2, 2),
                      end: const Offset(1, 1),
                      duration: 600.ms,
                      curve: Curves.easeOutBack)
                else
                  Text(
                    "TRAGÖDIE",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.red.withOpacity(0.8),
                    ),
                  ),

                const SizedBox(height: 40),

                if (victim != null) ...[
                  // Victim Name
                  if (!widget.isTesting)
                    Text(
                      victim.name.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5, end: 0)
                  else
                    Text(
                      victim.name.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                  const SizedBox(height: 10),

                  if (!widget.isTesting)
                    Text(
                      "ist tot.",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.white70,
                      ),
                    ).animate().fadeIn(delay: 800.ms)
                  else
                    Text(
                      "ist tot.",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.white70,
                      ),
                    ),

                  /* 
                   // Optional: Reveal Role Card
                   const SizedBox(height: 30),
                   Transform.scale(
                     scale: 0.6,
                     child: RoleCard(role: roles[victim.role]!, isRevealed: true),
                   ).animate().fadeIn(delay: 1500.ms),
                   */
                ] else ...[
                  if (!widget.isTesting)
                    Text(
                      "Niemand ist gestorben.",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn(delay: 500.ms)
                  else
                    Text(
                      "Niemand ist gestorben.",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                ]
              ],
            ),
          )
        ],
      ),
    );
  }

  bool stringIsNotEmpty(String? s) => s != null && s.isNotEmpty;
}

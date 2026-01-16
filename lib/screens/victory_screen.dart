import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../config/design_tokens.dart';
import '../providers/game_provider.dart';
import '../screens/home_screen.dart';

class VictoryScreen extends StatefulWidget {
  final bool isTesting;
  const VictoryScreen({super.key, this.isTesting = false});

  @override
  State<VictoryScreen> createState() => _VictoryScreenState();
}

class _VictoryScreenState extends State<VictoryScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    if (!widget.isTesting) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameProvider>().gameState;

    // Determine winner from narration or checking alive players
    // GameEngine sets narration to "The Village/Werewolves has won!"
    final isVillageWin = gameState.narration.contains("Dorf");

    final Color primaryColor =
        isVillageWin ? DesignColors.dayBright : DesignColors.wolfRed;
    final String title =
        isVillageWin ? "SIEG FÜR DAS DORF" : "DIE WÖLFE HERRSCHEN";
    final String subtitle =
        isVillageWin ? "Das Böse wurde vertrieben." : "Niemand hat überlebt.";

    return Scaffold(
      backgroundColor: isVillageWin
          ? const Color(0xFF1E1E2C)
          : Colors.black, // Dark background
      body: Stack(
        children: [
          // Background Effect
          if (isVillageWin && !widget.isTesting)
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                  gradient: RadialGradient(
                center: const Alignment(0, -0.4),
                radius: 1.5,
                colors: [
                  Colors.orange.withValues(alpha: 0.3),
                  Colors.blue.withValues(alpha: 0.1),
                  Colors.black,
                ],
              )),
            )
                    .animate(
                        onPlay: (c) =>
                            c.repeat(reverse: true)) // Assume !isTesting
                    .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.05, 1.05),
                        duration: 4.seconds))
          else if (isVillageWin)
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                  gradient: RadialGradient(
                center: const Alignment(0, -0.4),
                radius: 1.5,
                colors: [
                  Colors.orange.withValues(alpha: 0.3),
                  Colors.blue.withValues(alpha: 0.1),
                  Colors.black,
                ],
              )),
            )),
          if (!isVillageWin && !widget.isTesting)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.4),
                    radius: 1.0,
                    colors: [
                      Color(0xFF50C878), // Emerald Green
                      Colors.black,
                    ],
                    stops: [0.3, 1.0],
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 3.seconds),
            )
          else if (!isVillageWin)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.4),
                    radius: 1.0,
                    colors: [
                      Color(0xFF50C878), // Emerald Green
                      Colors.black,
                    ],
                    stops: [0.3, 1.0],
                  ),
                ),
              ),
            ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!widget.isTesting)
                  Icon(
                    isVillageWin ? Icons.wb_sunny : Icons.nights_stay,
                    size: 100,
                    color: primaryColor,
                  )
                      .animate()
                      .scale(duration: 1.seconds, curve: Curves.elasticOut)
                else
                  Icon(
                    isVillageWin ? Icons.wb_sunny : Icons.nights_stay,
                    size: 100,
                    color: primaryColor,
                  ),
                const SizedBox(height: 30),
                if (!widget.isTesting)
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        letterSpacing: 2.0,
                        shadows: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.5),
                            blurRadius: 20,
                          )
                        ]),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .slideY(begin: 0.5, end: 0)
                else
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        letterSpacing: 2.0,
                        shadows: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.5),
                            blurRadius: 20,
                          )
                        ]),
                  ),
                if (!widget.isTesting) ...[
                  const SizedBox(height: 16),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 60),
                ] else ...[
                  const SizedBox(height: 16),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
                widget.isTesting
                    ? ElevatedButton(
                        onPressed: () {}, // No-op or navigate
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          textStyle: GoogleFonts.spaceGrotesk(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: const Text("ZURÜCK ZUM MENÜ"),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          textStyle: GoogleFonts.spaceGrotesk(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: const Text("ZURÜCK ZUM MENÜ"),
                      ).animate().fadeIn(delay: 2.seconds).scale(),
              ],
            ),
          ),

          // Confetti
          if (!widget.isTesting)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true,
                colors: isVillageWin
                    ? const [
                        Colors.green,
                        Colors.blue,
                        Colors.pink,
                        Colors.orange,
                        Colors.purple
                      ]
                    : const [Colors.red, Colors.grey, Colors.black],
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/design_tokens.dart';

class DeathAnnouncementOverlay extends StatefulWidget {
  final List<String> deadPlayerNames;
  final VoidCallback onDismissed;

  const DeathAnnouncementOverlay({
    super.key,
    required this.deadPlayerNames,
    required this.onDismissed,
  });

  @override
  State<DeathAnnouncementOverlay> createState() =>
      _DeathAnnouncementOverlayState();
}

class _DeathAnnouncementOverlayState extends State<DeathAnnouncementOverlay> {
  @override
  void initState() {
    super.initState();
    // Auto-dismiss after a few seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) widget.onDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.deadPlayerNames.isEmpty) {
      // No deaths - show peaceful sunrise
      return Container(
        color: DesignColors.dayLighter.withValues(alpha: 0.9),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wb_sunny,
                      size: 80, color: DesignColors.dayBright)
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.easeOutBack)
                  .fadeIn(),
              const SizedBox(height: 20),
              Text(
                "EIN NEUER MORGEN",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: DesignColors.dayDark,
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 10),
              Text(
                "Niemand ist gestorben.",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: DesignColors.textDaySecondary,
                ),
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      );
    }

    // Tragedy - Deaths occurred
    return Container(
      color: DesignColors.blood.withValues(alpha: 0.95), // Blood red overlay
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.gavel,
                    size: 80, color: Colors.white) // Or Skull icon if available
                .animate()
                .shake(duration: 500.ms)
                .scale(
                    begin: const Offset(2, 2),
                    end: const Offset(1, 1),
                    duration: 200.ms,
                    curve: Curves.bounceOut),
            const SizedBox(height: 20),
            Text(
              "TRAGÖDIE!",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
              ),
            )
                .animate()
                .fadeIn()
                .tint(color: Colors.black, duration: 300.ms), // Flash effect
            const SizedBox(height: 30),
            ...widget.deadPlayerNames.map((name) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "$name ist tot.",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideX(),
                )),
          ],
        ),
      ),
    );
  }
}

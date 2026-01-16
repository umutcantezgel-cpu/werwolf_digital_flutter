import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/role.dart';
import '../config/design_tokens.dart';
import '../config/custom_theme_extension.dart';
import '../providers/skin_provider.dart';

class RoleCard extends StatelessWidget {
  final Role role;
  final bool isRevealed;
  final VoidCallback? onConfirm;
  final bool isTesting;

  const RoleCard({
    super.key,
    required this.role,
    required this.isRevealed,
    this.onConfirm,
    this.isTesting = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isRevealed) {
      return _buildCardBack(context);
    }
    return _buildCardFront(context);
  }

  Widget _buildCardBack(BuildContext context) {
    // Watch SkinProvider for changes
    final skinProvider = context.watch<SkinProvider>();
    final cardBackAsset = skinProvider.selectedCardBack.assetPath;

    return Container(
      width: 320,
      height: 560,
      decoration: BoxDecoration(
        color: DesignColors.nightBlack,
        borderRadius: BorderRadius.circular(DesignSpacings.s12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000), // Darker shadow
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 10),
          )
        ],
        border: Border.all(color: DesignColors.nightMid, width: 2),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(DesignSpacings.s12 - 2), // Adjust for border
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Full Card Back Image from SkinProvider
            Positioned.fill(
              child: Image.asset(
                cardBackAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: DesignColors.nightDeep,
                  child: const Center(
                      child: Icon(Icons.style,
                          size: 64, color: DesignColors.nightSubtle)),
                ),
              ),
            ),

            // Use an overlay gradient to ensure text readability if needed,
            // but usually card backs are just art.
            // If the design requires the "DEIN SCHICKSAL" text ON TOP of the card back art, keep it.
            // The original code had a stack with text.
            // If the card back is just the pattern, we keep the text.
            // Assuming "Card Back" skins might be just the background pattern.

            // Adding a dark overlay to ensure the text pops if it's there
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.nightlight_round,
                  size: 64,
                  color: DesignColors.moonPrimary,
                )
                    .animate(
                        onPlay: (c) => isTesting
                            ? null
                            : c.repeat()) // Disable loop in test
                    .shimmer(
                        duration: 2000.ms,
                        color: Colors.white.withValues(alpha: 0.5))
                    .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.1, 1.1),
                        duration: 3000.ms,
                        curve: Curves.easeInOut)
                    .then()
                    .scale(
                        begin: const Offset(1.1, 1.1),
                        end: const Offset(1, 1),
                        duration: 3000.ms,
                        curve: Curves.easeInOut),
                const SizedBox(height: DesignSpacings.s24),
                Text(
                  "DEIN SCHICKSAL",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: DesignTypography.textLg,
                    fontWeight: FontWeight.bold,
                    color: DesignColors.moonPrimary
                        .withValues(alpha: 0.9), // Increased opacity
                    letterSpacing: DesignTypography.spacingWide,
                    shadows: [
                      const Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront(BuildContext context) {
    final werwolfTheme = context.werwolfTheme;
    final roleColor = _getRoleColor(role.type, werwolfTheme);

    // Staggered Animation Logic handled by flutter_animate
    // 1. Art fade-in
    // 2. Title slide-in
    // 3. Description fade-in
    // 4. Button pulse

    return Container(
      width: 320,
      height: 560,
      decoration: BoxDecoration(
        color: DesignColors.nightDeep, // Base card color
        borderRadius: BorderRadius.circular(DesignSpacings.s12),
        boxShadow: [
          BoxShadow(
            color: roleColor.withValues(alpha: 0.3), // Glow of role color
            blurRadius: 30,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignSpacings.s12),
        child: Stack(
          children: [
            // 1. Background Tint Gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      roleColor.withValues(alpha: 0.2), // Light tint top
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8), // Dark bottom
                    ],
                  ),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 2. Character Illustration (Top 45%)
                Expanded(
                  flex: 9, // 45%
                  child: Hero(
                    tag: 'role_image_${role.type}',
                    child: Image.asset(
                      role.imageUrl,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (ctx, _, __) => Container(
                        color: roleColor.withValues(alpha: 0.1),
                        child: Icon(Icons.person, size: 80, color: roleColor),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                        .scale(
                            begin: const Offset(1.1, 1.1),
                            end: const Offset(1.0, 1.0),
                            duration: 5.seconds), // Cinematic slow zoom
                  ),
                ),

                // 3. Info Section
                Expanded(
                  flex: 11, // 55%
                  child: Padding(
                    padding: const EdgeInsets.all(DesignSpacings.s20),
                    child: Column(
                      children: [
                        // Role Name
                        Text(
                          role.name.toUpperCase(),
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 32, // Large
                              fontWeight: FontWeight.w800,
                              color: roleColor, // Role Color
                              height: 0.9,
                              letterSpacing: -1.0, // Tight and dramatic
                              shadows: [
                                Shadow(
                                  color: roleColor.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                )
                              ]),
                          textAlign: TextAlign.center,
                        )
                            .animate()
                            .slideY(
                                begin: 0.5,
                                end: 0,
                                delay: 200.ms,
                                duration: 600.ms,
                                curve: Curves.easeOutBack)
                            .fadeIn(delay: 200.ms),

                        const SizedBox(height: DesignSpacings.s12),

                        // Team Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: roleColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: roleColor.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                role.icon ??
                                    (role.team == Team.werwolf
                                        ? Icons.nights_stay
                                        : Icons.home),
                                size: 14,
                                color: roleColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                role.team == Team.werwolf
                                    ? "TEAM WERWOLF"
                                    : "TEAM DORF",
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: roleColor,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ).animate().scale(
                            delay: 400.ms,
                            duration: 400.ms,
                            curve: Curves.elasticOut),

                        const SizedBox(height: DesignSpacings.s24),

                        // Scrollable Description
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Text(
                                  role.description,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: DesignColors.textNightPrimary
                                        .withValues(alpha: 0.9),
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (role.flavorText.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    "\"${role.flavorText}\"",
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: DesignColors.textNightSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: 600.ms),

                        const SizedBox(height: DesignSpacings.s16),

                        // Confirm Button
                        if (onConfirm != null)
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: onConfirm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: roleColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shadowColor: roleColor.withValues(alpha: 0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "VERSTANDEN",
                                style: GoogleFonts.spaceGrotesk(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          )
                              .animate(
                                  onPlay: (controller) => isTesting
                                      ? null
                                      : controller.repeat(reverse: true))
                              .boxShadow(
                                begin: BoxShadow(
                                    color: roleColor.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                    spreadRadius: 0),
                                end: BoxShadow(
                                    color: roleColor.withValues(alpha: 0.6),
                                    blurRadius: 12,
                                    spreadRadius: 2),
                                duration: 1500.ms,
                              )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(RoleType type, WerwolfThemeExtension theme) {
    if (role.color != null) return role.color!;

    // Fallback mapping if role.color is not set (e.g. for dynamic roles?)
    switch (type) {
      case RoleType.werwolf:
        return theme.roleWerwolf;
      case RoleType.seherin:
        return theme.roleSeherin;
      case RoleType.hexe:
        return theme.roleHexe;
      case RoleType.amor:
        return const Color(0xFFE91E63);
      case RoleType.jager:
        return const Color(0xFF8B4513);
      case RoleType.dorfbewohner:
      default:
        return theme.villageGreen;
    }
  }
}

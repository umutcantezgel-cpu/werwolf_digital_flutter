/// Solo Mode Screen
///
/// Entry point for Solo Player Mode with bot configuration options.
/// Allows setting up player count, difficulty, and game options.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../config/design_tokens.dart';
import '../models/bot_player.dart';
import '../providers/game_provider.dart';
import '../services/bot_manager.dart';
import '../widgets/night_sky_background.dart';

class SoloModeScreen extends StatefulWidget {
  const SoloModeScreen({super.key});

  @override
  State<SoloModeScreen> createState() => _SoloModeScreenState();
}

class _SoloModeScreenState extends State<SoloModeScreen> {
  int _totalPlayers = 8;
  DifficultyLevel _difficulty = DifficultyLevel.normal;
  bool _showBotThoughts = false;
  bool _disableTimeLimits = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          const NightSkyBackground(),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),

                  const SizedBox(height: 40),

                  // Main content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Player count
                          _buildPlayerCountSection(),

                          const SizedBox(height: 32),

                          // Difficulty
                          _buildDifficultySection(),

                          const SizedBox(height: 32),

                          // Advanced options
                          _buildAdvancedOptions(),
                        ],
                      ),
                    ),
                  ),

                  // Start button
                  _buildStartButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🤖 SOLO MODUS',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ).animate().fadeIn().slideX(begin: -0.2),
              const SizedBox(height: 4),
              Text(
                'Spiele gegen intelligente KI-Bots',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCountSection() {
    final botCount = _totalPlayers - 1; // 1 human player

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SPIELERANZAHL',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white54,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),

        // Player count slider
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: DesignColors.nightMid.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_totalPlayers Spieler',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: DesignColors.roleWerwolf.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$botCount Bots',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: DesignColors.roleWerwolf,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Slider(
                value: _totalPlayers.toDouble(),
                min: 5,
                max: 15,
                divisions: 10,
                activeColor: DesignColors.roleSeherin,
                inactiveColor: Colors.white24,
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _totalPlayers = value.round();
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('5',
                      style: GoogleFonts.inter(
                          color: Colors.white38, fontSize: 12)),
                  Text('15',
                      style: GoogleFonts.inter(
                          color: Colors.white38, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SCHWIERIGKEIT',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white54,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),

        // Difficulty buttons
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: DifficultyLevel.values.map((level) {
            final isSelected = _difficulty == level;
            return _buildDifficultyButton(level, isSelected);
          }).toList(),
        ),

        // Description
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Container(
            key: ValueKey(_difficulty),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _getDifficultyIcon(_difficulty),
                  color: _getDifficultyColor(_difficulty),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _difficulty.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyButton(DifficultyLevel level, bool isSelected) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _difficulty = level;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? _getDifficultyColor(level).withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _getDifficultyColor(level) : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          level.displayName,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? _getDifficultyColor(level) : Colors.white54,
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ERWEITERTE OPTIONEN',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white54,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),

        // Options
        _buildToggleOption(
          'Bot-Gedankengänge anzeigen',
          'Nach dem Spiel siehst du, wie die Bots gedacht haben.',
          _showBotThoughts,
          (value) => setState(() => _showBotThoughts = value),
        ),

        const SizedBox(height: 12),

        _buildToggleOption(
          'Zeitlimits deaktivieren',
          'Unbegrenzte Zeit für Diskussionen und Abstimmungen.',
          _disableTimeLimits,
          (value) => setState(() => _disableTimeLimits = value),
        ),
      ],
    );
  }

  Widget _buildToggleOption(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignColors.nightMid.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              HapticFeedback.selectionClick();
              onChanged(newValue);
            },
            activeThumbColor: DesignColors.roleSeherin,
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _startSoloGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: DesignColors.roleWerwolf,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 8,
                shadowColor: DesignColors.roleWerwolf.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow_rounded, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'SPIEL STARTEN',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/training'),
              style: OutlinedButton.styleFrom(
                foregroundColor: DesignColors.moonPrimary,
                side: BorderSide(
                  color: DesignColors.moonPrimary.withOpacity(0.5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'TUTORIAL SPIELEN',
                style: TextStyle(
                  fontFamily: DesignTypography.fontDisplay,
                  fontSize: DesignTypography.textBase,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/challenges'),
              style: OutlinedButton.styleFrom(
                foregroundColor: DesignColors.dayBright,
                side: BorderSide(
                  color: DesignColors.dayBright.withValues(alpha: 0.5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'HERAUSFORDERUNGEN',
                style: TextStyle(
                  fontFamily: DesignTypography.fontDisplay,
                  fontSize: DesignTypography.textBase,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2);
  }

  Color _getDifficultyColor(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.leicht:
        return Colors.green;
      case DifficultyLevel.normal:
        return Colors.blue;
      case DifficultyLevel.schwer:
        return Colors.orange;
      case DifficultyLevel.experte:
        return Colors.red;
    }
  }

  IconData _getDifficultyIcon(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.leicht:
        return Icons.child_care;
      case DifficultyLevel.normal:
        return Icons.person;
      case DifficultyLevel.schwer:
        return Icons.fitness_center;
      case DifficultyLevel.experte:
        return Icons.whatshot;
    }
  }

  void _startSoloGame() async {
    HapticFeedback.heavyImpact();

    final gameProvider = context.read<GameProvider>();

    // Create solo mode config
    final config = SoloModeConfig(
      totalPlayers: _totalPlayers,
      humanPlayers: 1, // Solo = 1 human
      difficulty: _difficulty,
      showBotThoughts: _showBotThoughts,
      disableTimeLimits: _disableTimeLimits,
    );

    // Initialize game in solo mode
    await gameProvider.startSoloGame(config);

    // Navigate to solo lobby
    if (mounted) {
      context.go('/solo-lobby');
    }
  }
}

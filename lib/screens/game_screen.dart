import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/providers/theme_provider.dart';
import 'package:werwolf_digital_flutter/providers/tts_provider.dart'; // Import TtsProvider
import 'package:werwolf_digital_flutter/providers/audio_provider.dart';
import 'package:werwolf_digital_flutter/config/constants.dart';
import 'night_screen.dart';
import 'day_screen.dart';
import 'voting_screen.dart';
import 'game_end_screen.dart';
import 'tragedy_screen.dart';
import 'victory_screen.dart';
import 'execution_screen.dart';
import 'dawn_screen.dart';
import '../widgets/phase_indicator.dart';
import '../widgets/ambient_background.dart';
import '../widgets/phase_transition.dart';
import '../widgets/role_icon.dart';
import '../models/role.dart';

class GameScreen extends StatefulWidget {
  final String roomCode;

  const GameScreen({super.key, required this.roomCode});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late TtsProvider _ttsProvider;
  late GameProvider _gameProvider;

  // Track the last spoken narration to avoid speaking the same message repeatedly
  String _lastSpokenNarration = '';
  // Track the last played sound effect to avoid loops
  String? _lastPlayedSoundEffect;
  GamePhase _lastPhase = GamePhase.lobby;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ttsProvider = Provider.of<TtsProvider>(context, listen: false);
    _gameProvider = Provider.of<GameProvider>(context, listen: false);

    // Add a listener to GameProvider's gameState
    _gameProvider.addListener(_handleGameStateChange);
    // Speak the initial narration when the screen loads
    _handleGameStateChange();
  }

  void _handleGameStateChange() {
    final gameState = _gameProvider.gameState;

    // Handle Narration
    final currentNarration = gameState.narration;
    if (currentNarration.isNotEmpty &&
        currentNarration != _lastSpokenNarration) {
      _speakNarration(currentNarration);
    }

    // Handle SFX
    final currentSfx = gameState.lastSoundEffect;
    if (currentSfx != null && currentSfx != _lastPlayedSoundEffect) {
      _playSfx(currentSfx);
    }

    // Handle Phase Change Haptics
    final currentPhase = gameState.gamePhase;
    if (currentPhase != _lastPhase) {
      if (currentPhase == GamePhase.night || currentPhase == GamePhase.day) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
      _lastPhase = currentPhase;
    }
  }

  void _speakNarration(String narration) {
    _ttsProvider.ttsService.speak(narration);
    _lastSpokenNarration = narration;
  }

  void _playSfx(String sfx) {
    Provider.of<AudioProvider>(context, listen: false).playSoundEffect(sfx);
    _lastPlayedSoundEffect = sfx;
  }

  @override
  void dispose() {
    _gameProvider.removeListener(_handleGameStateChange);
    _ttsProvider.ttsService
        .stop(); // Stop any ongoing speech when leaving the screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final gamePhase = gameProvider.gameState.gamePhase;

        // Find the current player using myPlayerId
        final myId = gameProvider.myPlayerId;
        final currentPlayer = gameProvider.gameState.players.isNotEmpty
            ? gameProvider.gameState.players.firstWhere(
                (p) => p.id == myId,
                orElse: () => gameProvider.gameState.players.first,
              )
            : null;

        // In solo mode, human is always host. Otherwise check isHost flag.
        final bool isHost =
            gameProvider.isSoloMode || (currentPlayer?.isHost ?? false);

        // Update themes and audio based on the game phase
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final themeProvider =
              Provider.of<ThemeProvider>(context, listen: false);
          themeProvider.updateThemeForPhase(gamePhase);

          final audioProvider =
              Provider.of<AudioProvider>(context, listen: false);
          audioProvider.updateAudioForPhase(gamePhase);
        });

        return AmbientBackground(
          phase: gamePhase,
          child: Scaffold(
            backgroundColor:
                Colors.transparent, // Allow ambient background to show
            appBar: AppBar(
              title: Text(
                  'Spiel: ${widget.roomCode}'), // Use widget.roomCode for StatelessWidget properties
              automaticallyImplyLeading: false,
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: PhaseIndicator(), // Custom widget for phase display
              ),
            ),
            body: Stack(
              // Use Stack to place the phase transition and FAB on top
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _buildBodyForPhase(gamePhase),
                ),

                // My Role Icon
                if (currentPlayer != null)
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: RoleIcon(
                        role: roles[currentPlayer.role] ??
                            roles[RoleType.dorfbewohner]!),
                  ),

                // Host controls
                if (isHost && _canAdvancePhase(gamePhase))
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton.extended(
                      onPressed: () => gameProvider.nextPhase(),
                      label: const Text('Weiter'),
                      icon: const Icon(Icons.arrow_forward),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),

                // Transition Overlay
                Positioned.fill(
                  child: PhaseTransitionOverlay(phase: gamePhase),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _canAdvancePhase(GamePhase phase) {
    return phase != GamePhase.lobby && phase != GamePhase.gameOver;
  }

  Widget _buildBodyForPhase(GamePhase phase) {
    switch (phase) {
      case GamePhase.night:
      case GamePhase.firstNight: // Handle first night same as night for now
        return const NightScreen();
      case GamePhase.dawn:
        return const DawnScreen();
      case GamePhase.day:
        return const DayScreen();
      case GamePhase.voting:
        return const VotingScreen();
      case GamePhase.execution:
        return const ExecutionScreen();
      case GamePhase.gameOver:
        return const GameEndScreen();
      case GamePhase.tragedy:
        return const TragedyScreen();
      case GamePhase.victory:
        return const VictoryScreen();
      case GamePhase.roleDistribution:
      case GamePhase.roleReveal:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Warte auf andere Spieler...',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }
}

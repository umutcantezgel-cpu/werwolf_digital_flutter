import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/config/design_tokens.dart';
import 'package:werwolf_digital_flutter/services/haptic_manager.dart';
import 'package:werwolf_digital_flutter/screens/skin_selection_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _roomCodeController = TextEditingController();
  bool _showJoinInput = false;

  void _createGame(GameProvider gameProvider) async {
    HapticManager().impactLight();
    if (_nameController.text.isEmpty) {
      HapticManager().impactHeavy();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte gib deinen Namen ein.')),
      );
      return;
    }
    // A unique ID for the player.
    final playerId = 'player_${DateTime.now().millisecondsSinceEpoch}';

    gameProvider.createLobby(_nameController.text, playerId);

    // Wait for the room code to be set by the server
    // Poll until roomCode is no longer empty (with timeout)
    int attempts = 0;
    while (gameProvider.gameState.roomCode.isEmpty && attempts < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    if (!mounted) return;

    final roomCode = gameProvider.gameState.roomCode;
    if (roomCode.isNotEmpty) {
      context.go('/lobby/$roomCode');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fehler beim Erstellen des Raums.')),
      );
    }
  }

  void _joinGame(GameProvider gameProvider) {
    HapticManager().impactLight();
    if (_nameController.text.isEmpty || _roomCodeController.text.isEmpty) {
      HapticManager().impactHeavy();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte gib Namen und Raum-Code ein.')),
      );
      return;
    }
    final playerId = 'player_${DateTime.now().millisecondsSinceEpoch}';
    final roomCode = _roomCodeController.text.toUpperCase();

    gameProvider.joinLobby(_nameController.text, playerId, roomCode);

    context.go('/lobby/$roomCode');
  }

  @override
  Widget build(BuildContext context) {
    // using DesignTokens directly rather than theme for custom Weltklasse look
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: DesignColors.nightBlack,
      floatingActionButton: FloatingActionButton(
        backgroundColor: DesignColors.nightSubtle,
        onPressed: () {
          HapticManager().selection();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SkinSelectionScreen()),
          );
        },
        child: const Icon(Icons.style, color: DesignColors.dayBright),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignSpacings.s24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Hero(
                tag: 'app_title',
                child: Text(
                  'WERWOLF DIGITAL',
                  style: TextStyle(
                    fontFamily: DesignTypography.fontDisplay,
                    fontSize: 36,
                    color: DesignColors.moonPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: DesignSpacings.s48),

              // Input Fields
              Container(
                decoration: BoxDecoration(
                  color: DesignColors.nightDeep,
                  borderRadius: BorderRadius.circular(DesignSpacings.s8),
                ),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(color: DesignColors.moonPrimary),
                  decoration: InputDecoration(
                    labelText: 'Dein Name',
                    labelStyle: TextStyle(
                        color: DesignColors.moonPrimary.withOpacity(0.5)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(DesignSpacings.s16),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: DesignDurations.normal)
                  .slideY(begin: 0.2),

              const SizedBox(height: DesignSpacings.s16),

              if (_showJoinInput)
                Container(
                  decoration: BoxDecoration(
                    color: DesignColors.nightDeep,
                    borderRadius: BorderRadius.circular(DesignSpacings.s8),
                  ),
                  child: TextField(
                    controller: _roomCodeController,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(color: DesignColors.moonPrimary),
                    decoration: InputDecoration(
                      labelText: 'Raum-Code',
                      labelStyle: TextStyle(
                          color: DesignColors.moonPrimary.withOpacity(0.5)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(DesignSpacings.s16),
                    ),
                  ),
                ).animate().fadeIn().slideY(begin: 0.2),

              const SizedBox(height: DesignSpacings.s32),

              // Buttons
              if (!_showJoinInput) ...[
                ElevatedButton(
                  onPressed: () => _createGame(gameProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignColors.dayWarm,
                    foregroundColor: DesignColors.nightBlack,
                    minimumSize: const Size(double.infinity, 50),
                    textStyle: const TextStyle(
                      fontFamily: DesignTypography.fontBody,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('NEUES SPIEL ERSTELLEN'),
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
                const SizedBox(height: DesignSpacings.s16),

                // Solo Mode Button
                ElevatedButton.icon(
                  onPressed: () {
                    HapticManager().impactLight();
                    context.go('/solo');
                  },
                  icon: const Icon(Icons.smart_toy_outlined),
                  label: const Text('SOLO MODUS'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignColors.roleSeherin,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    textStyle: const TextStyle(
                      fontFamily: DesignTypography.fontBody,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2),
                const SizedBox(height: DesignSpacings.s16),

                TextButton(
                  onPressed: () {
                    HapticManager().selection();
                    setState(() => _showJoinInput = true);
                  },
                  child: Text('SPIEL BEITRETEN',
                      style: TextStyle(
                        color: DesignColors.moonPrimary.withOpacity(0.7),
                        letterSpacing: 1,
                      )),
                ).animate().fadeIn(delay: 200.ms),
              ] else ...[
                ElevatedButton(
                  onPressed: () => _joinGame(gameProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignColors.dayWarm,
                    foregroundColor: DesignColors.nightBlack,
                    minimumSize: const Size(double.infinity, 50),
                    textStyle: const TextStyle(
                      fontFamily: DesignTypography.fontBody,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('BEITRETEN'),
                ).animate().fadeIn().slideY(begin: 0.2),
                const SizedBox(height: DesignSpacings.s16),
                TextButton(
                  onPressed: () {
                    HapticManager().selection();
                    setState(() => _showJoinInput = false);
                  },
                  child: Text('ZURÜCK',
                      style: TextStyle(
                        color: DesignColors.moonPrimary.withOpacity(0.7),
                        letterSpacing: 1,
                      )),
                ).animate().fadeIn(delay: 100.ms),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

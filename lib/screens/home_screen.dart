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


  Widget _buildBentoButton({
    required String title,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    required int delay,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onTapDown: (_) => HapticManager().selection(),
        borderRadius: BorderRadius.circular(DesignSpacings.s16),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(DesignSpacings.s16),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
          ),
          padding: const EdgeInsets.all(DesignSpacings.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: textColor, size: 28),
              Text(
                title,
                style: TextStyle(
                  fontFamily: DesignTypography.fontBody,
                  fontWeight: FontWeight.bold,
                  fontSize: DesignTypography.textSm,
                  color: textColor,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.2),
      ),
    );
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

                            Wrap(
                spacing: DesignSpacings.s16,
                runSpacing: DesignSpacings.s16,
                alignment: WrapAlignment.center,
                children: [
                  // Name Input Tile
                  Container(
                    width: MediaQuery.of(context).size.width > 600 ? 300 : double.infinity,
                    decoration: BoxDecoration(
                      color: DesignColors.nightDeep,
                      borderRadius: BorderRadius.circular(DesignSpacings.s12),
                      border: Border.all(color: DesignColors.nightSubtle, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: DesignColors.dayWarm.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(color: DesignColors.moonPrimary),
                      decoration: InputDecoration(
                        labelText: 'Dein Name',
                        labelStyle: TextStyle(
                            color: DesignColors.moonPrimary.withValues(alpha: 0.5)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: DesignSpacings.s20,
                            vertical: DesignSpacings.s16),
                      ),
                    ),
                  ).animate().fadeIn(duration: DesignDurations.normal).slideY(begin: 0.1),

                  if (_showJoinInput)
                    Container(
                      width: MediaQuery.of(context).size.width > 600 ? 300 : double.infinity,
                      decoration: BoxDecoration(
                        color: DesignColors.nightDeep,
                        borderRadius: BorderRadius.circular(DesignSpacings.s12),
                        border: Border.all(color: DesignColors.nightSubtle, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: DesignColors.dayWarm.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _roomCodeController,
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(color: DesignColors.moonPrimary),
                        decoration: InputDecoration(
                          labelText: 'Raum-Code',
                          labelStyle: TextStyle(
                              color: DesignColors.moonPrimary.withValues(alpha: 0.5)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: DesignSpacings.s20,
                              vertical: DesignSpacings.s16),
                        ),
                      ),
                    ).animate().fadeIn().slideY(begin: 0.1),

                  // Action Buttons in Bento Grid style
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Row(
                      children: [
                        if (!_showJoinInput) ...[
                          Expanded(
                            flex: 2,
                            child: _buildBentoButton(
                              title: 'NEUES SPIEL\nERSTELLEN',
                              icon: Icons.add_circle_outline,
                              color: DesignColors.dayWarm,
                              textColor: DesignColors.nightBlack,
                              onTap: () => _createGame(gameProvider),
                              delay: 100,
                            ),
                          ),
                          const SizedBox(width: DesignSpacings.s16),
                          Expanded(
                            flex: 1,
                            child: _buildBentoButton(
                              title: 'SOLO\nMODUS',
                              icon: Icons.smart_toy_outlined,
                              color: DesignColors.roleSeherin,
                              textColor: DesignColors.textNightPrimary,
                              onTap: () {
                                HapticManager().impactLight();
                                context.go('/solo');
                              },
                              delay: 150,
                            ),
                          ),
                        ] else ...[
                          Expanded(
                            child: _buildBentoButton(
                              title: 'BEITRETEN',
                              icon: Icons.login,
                              color: DesignColors.dayWarm,
                              textColor: DesignColors.nightBlack,
                              onTap: () => _joinGame(gameProvider),
                              delay: 100,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Secondary Action Text
                  if (!_showJoinInput)
                    Padding(
                      padding: const EdgeInsets.only(top: DesignSpacings.s8),
                      child: TextButton(
                        onPressed: () {
                          HapticManager().selection();
                          setState(() => _showJoinInput = true);
                        },
                        child: Text('SPIEL BEITRETEN',
                            style: TextStyle(
                              color: DesignColors.moonPrimary.withValues(alpha: 0.7),
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                            )),
                      ).animate().fadeIn(delay: 200.ms),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: DesignSpacings.s8),
                      child: TextButton(
                        onPressed: () {
                          HapticManager().selection();
                          setState(() => _showJoinInput = false);
                        },
                        child: Text('ZURÜCK',
                            style: TextStyle(
                              color: DesignColors.moonPrimary.withValues(alpha: 0.7),
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                            )),
                      ).animate().fadeIn(delay: 100.ms),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

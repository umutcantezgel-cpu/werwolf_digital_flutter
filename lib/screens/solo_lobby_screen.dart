import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/config/design_tokens.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/widgets/night_sky_background.dart';
import 'package:werwolf_digital_flutter/widgets/player_avatar.dart';
import 'package:werwolf_digital_flutter/models/bot_player.dart';
import 'package:werwolf_digital_flutter/models/bot_personality.dart';

class SoloLobbyScreen extends StatefulWidget {
  const SoloLobbyScreen({super.key});

  @override
  State<SoloLobbyScreen> createState() => _SoloLobbyScreenState();
}

class _SoloLobbyScreenState extends State<SoloLobbyScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final bots = provider.botManager?.bots ?? [];

    return Scaffold(
      body: Stack(
        children: [
          const NightSkyBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      // Human Player
                      _buildHumanPlayer(provider),

                      const SizedBox(height: 24),

                      Text(
                        'BOTS (${bots.length})',
                        style: const TextStyle(
                          fontFamily: DesignTypography.fontDisplay,
                          fontSize: DesignTypography.textSm,
                          color: DesignColors.nightSubtle,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Bots Grid
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children:
                            bots.map((bot) => _buildBotCard(bot)).toList(),
                      ),
                    ],
                  ),
                ),
                _buildStartButton(context, provider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: DesignColors.moonPrimary),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
          const Text(
            'LOBBY',
            style: TextStyle(
              fontFamily: DesignTypography.fontDisplay,
              fontSize: DesignTypography.text2xl,
              color: DesignColors.moonPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHumanPlayer(GameProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignColors.nightMid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DesignColors.roleSeherin.withOpacity(0.5)),
      ),
      child: const Row(
        children: [
          PlayerAvatar(
            playerName: 'Du',
            isAlive: true,
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Du (Spieler)',
                style: TextStyle(
                  fontFamily: DesignTypography.fontDisplay,
                  fontSize: DesignTypography.textLg,
                  color: DesignColors.moonPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Host',
                style: TextStyle(
                  fontFamily: DesignTypography.fontBody,
                  fontSize: DesignTypography.textSm,
                  color: DesignColors.roleSeherin,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBotCard(BotPlayer bot) {
    // bot is BotPlayer
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DesignColors.nightMid.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          PlayerAvatar(
            playerName: bot.name,
            isAlive: true,
          ),
          const SizedBox(height: 8),
          Text(
            bot.name,
            style: const TextStyle(
              fontFamily: DesignTypography.fontBody,
              fontSize: DesignTypography.textBase,
              color: DesignColors.moonPrimary,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            bot.personality.displayName,
            style: const TextStyle(
              fontFamily: DesignTypography.fontBody,
              fontSize: DesignTypography.textXs,
              color: DesignColors.nightSubtle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, GameProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: DesignColors.nightBlack,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: ElevatedButton(
        onPressed: () {
          provider.startSoloMatch();
          context.go('/role-reveal'); // Navigate after starting match
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignColors.roleWerwolf,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'SPIEL STARTEN',
          style: TextStyle(
            fontFamily: DesignTypography.fontDisplay,
            fontSize: DesignTypography.textLg,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

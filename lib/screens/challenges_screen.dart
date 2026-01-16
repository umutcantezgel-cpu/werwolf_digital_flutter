import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/config/design_tokens.dart';
import 'package:werwolf_digital_flutter/services/challenge_manager.dart';
import 'package:werwolf_digital_flutter/providers/game_provider.dart';
import 'package:werwolf_digital_flutter/widgets/night_sky_background.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ChallengeManager(), // In a real app, this would be provided higher up
      child: const _ChallengesScreenContent(),
    );
  }
}

class _ChallengesScreenContent extends StatelessWidget {
  const _ChallengesScreenContent();

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ChallengeManager>();
    final challenges = manager.challenges;
    final scenarios = manager.scenarios;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            const NightSkyBackground(),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: DesignColors.nightMid.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: DesignColors.moonPrimary,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelColor: DesignColors.nightBlack,
                        unselectedLabelColor: DesignColors.textNightSecondary,
                        tabs: const [
                          Tab(text: 'HERAUSFORDERUNGEN'),
                          Tab(text: 'SZENARIEN'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Challenges Tab
                        ListView.builder(
                          padding: const EdgeInsets.all(24),
                          itemCount: challenges.length,
                          itemBuilder: (context, index) {
                            final challenge = challenges[index];
                            return _buildChallengeCard(challenge, index);
                          },
                        ),
                        // Scenarios Tab
                        ListView.builder(
                          padding: const EdgeInsets.all(24),
                          itemCount: scenarios.length,
                          itemBuilder: (context, index) {
                            final scenario = scenarios[index];
                            return _buildScenarioCard(context, scenario, index);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
            'HERAUSFORDERUNGEN',
            style: TextStyle(
              fontFamily: DesignTypography.fontDisplay,
              fontSize: DesignTypography.textLg,
              color: DesignColors.moonPrimary,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ).animate().fadeIn().slideX(begin: -0.2),
    );
  }

  Widget _buildChallengeCard(Challenge challenge, int index) {
    final isCompleted = challenge.isCompleted;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: DesignColors.nightMid.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? DesignColors.roleDorfbewohnerAccent.withValues(alpha: 0.5)
              : DesignColors.moonPrimary.withValues(alpha: 0.1),
        ),
        boxShadow: [
          if (isCompleted)
            BoxShadow(
              color: DesignColors.roleDorfbewohner.withValues(alpha: 0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Row(
        children: [
          // Icon / Badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? DesignColors.roleDorfbewohner.withValues(alpha: 0.2)
                  : DesignColors.nightSubtle,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.emoji_events : Icons.lock_clock,
              color: isCompleted
                  ? DesignColors.roleDorfbewohnerAccent
                  : DesignColors.textNightMuted,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.title,
                  style: TextStyle(
                    fontFamily: DesignTypography.fontDisplay,
                    fontSize: DesignTypography.textBase,
                    color: isCompleted
                        ? DesignColors.moonPrimary
                        : DesignColors.textNightSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  challenge.description,
                  style: const TextStyle(
                    fontFamily: DesignTypography.fontBody,
                    fontSize: DesignTypography.textXs,
                    color: DesignColors.textNightMuted,
                  ),
                ),
                const SizedBox(height: 12),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: challenge.progress,
                    backgroundColor: DesignColors.nightBlack,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted
                          ? DesignColors.roleDorfbewohnerAccent
                          : DesignColors.moonGlow,
                    ),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // XP Reward
          Column(
            children: [
              Text(
                '${challenge.rewardXp}',
                style: TextStyle(
                  fontFamily: DesignTypography.fontDisplay,
                  fontSize: DesignTypography.textLg,
                  color: isCompleted
                      ? DesignColors.dayBright
                      : DesignColors.textNightMuted,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'XP',
                style: TextStyle(
                  fontFamily: DesignTypography.fontDisplay,
                  fontSize: DesignTypography.textXs,
                  color: DesignColors.textNightMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2);
  }

  Widget _buildScenarioCard(
      BuildContext context, Scenario scenario, int index) {
    return GestureDetector(
      onTap: () {
        // Start Scenario
        final gameProvider = context.read<GameProvider>();
        // Using dynamic dispatch for now or we update GameProvider import
        // Assuming startSoloGame handles passed config
        gameProvider.startSoloGame(scenario.setupConfig,
            fixedRole: scenario.fixedPlayerRole);
        context.push('/solo-lobby');
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: DesignColors.nightMid.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: DesignColors.moonPrimary.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    scenario.title.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: DesignTypography.fontDisplay,
                      fontSize: DesignTypography.textLg,
                      color: DesignColors.moonPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: DesignColors.wolfRed.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: DesignColors.wolfRed.withValues(alpha: 0.5)),
                  ),
                  child: const Text(
                    'SCHWER', // Placeholder, could be from config
                    style: TextStyle(
                      fontFamily: DesignTypography.fontBody,
                      fontSize: DesignTypography.textXs,
                      color: DesignColors.wolfRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              scenario.description,
              style: const TextStyle(
                fontFamily: DesignTypography.fontBody,
                fontSize: DesignTypography.textSm,
                color: DesignColors.textNightSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.person,
                    size: 16, color: DesignColors.textNightMuted),
                const SizedBox(width: 6),
                Text(
                  '${scenario.setupConfig.totalPlayers} Spieler',
                  style: const TextStyle(
                    color: DesignColors.textNightMuted,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.play_circle_fill,
                    color: DesignColors.moonPrimary, size: 32),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2),
    );
  }
}

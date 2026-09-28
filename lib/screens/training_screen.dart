import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:werwolf_digital_flutter/config/design_tokens.dart';
import 'package:werwolf_digital_flutter/services/tutorial_manager.dart';
import 'package:werwolf_digital_flutter/widgets/night_sky_background.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TutorialManager(),
      child: const _TrainingScreenContent(),
    );
  }
}

class _TrainingScreenContent extends StatelessWidget {
  const _TrainingScreenContent();

  @override
  Widget build(BuildContext context) {
    final tutorial = context.watch<TutorialManager>();
    final message = tutorial.currentMessage;

    return Scaffold(
      body: Stack(
        children: [
          const NightSkyBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: DesignColors.nightMid.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: DesignColors.moonPrimary.withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Step Indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: DesignColors.nightSubtle,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'SCHRITT ${tutorial.currentStep.index + 1} / ${TutorialStep.values.length}',
                              style: const TextStyle(
                                fontFamily: DesignTypography.fontDisplay,
                                fontSize: DesignTypography.textXs,
                                color: DesignColors.moonGlow,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Title
                          Text(
                            message.title,
                            style: const TextStyle(
                              fontFamily: DesignTypography.fontDisplay,
                              fontSize: DesignTypography.text2xl,
                              color: DesignColors.moonPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          // Content
                          Text(
                            message.content,
                            style: const TextStyle(
                              fontFamily: DesignTypography.fontBody,
                              fontSize: DesignTypography.textBase,
                              color: DesignColors.textNightSecondary,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          // Action Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (tutorial.currentStep ==
                                    TutorialStep.conclusion) {
                                  context.pop();
                                } else {
                                  tutorial.nextStep();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DesignColors.moonPrimary,
                                foregroundColor: DesignColors.nightBlack,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                message.actionLabel ?? 'WEITER',
                                style: const TextStyle(
                                  fontFamily: DesignTypography.fontDisplay,
                                  fontSize: DesignTypography.textBase,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
            icon: const Icon(Icons.close, color: DesignColors.moonPrimary),
            onPressed: () => context.pop(),
          ),
          const Spacer(),
          const Text(
            'TUTORIAL',
            style: TextStyle(
              fontFamily: DesignTypography.fontDisplay,
              fontSize: DesignTypography.textSm,
              color: DesignColors.moonGlow,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48), // Balance for close button
        ],
      ),
    );
  }
}

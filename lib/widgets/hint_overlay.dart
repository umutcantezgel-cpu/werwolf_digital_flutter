import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:werwolf_digital_flutter/config/design_tokens.dart';

class HintOverlay extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onDismiss;
  final String? dismissLabel;

  const HintOverlay({
    super.key,
    required this.title,
    required this.content,
    this.onDismiss,
    this.dismissLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100, // Position it generally near top or make it flexible
      right: 24,
      left: 24,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: DesignColors.nightDeep.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: DesignColors.dayBright.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: DesignColors.dayBright.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.lightbulb,
                      color: DesignColors.dayBright, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: DesignTypography.fontDisplay,
                        fontSize: DesignTypography.textSm,
                        fontWeight: FontWeight.bold,
                        color: DesignColors.dayBright,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  if (onDismiss != null)
                    GestureDetector(
                      onTap: onDismiss,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: DesignColors.nightBlack.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            size: 16, color: DesignColors.textNightMuted),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: const TextStyle(
                  fontFamily: DesignTypography.fontBody,
                  fontSize: DesignTypography.textSm,
                  color: DesignColors.moonPrimary,
                  height: 1.5,
                ),
              ),
              if (dismissLabel != null && onDismiss != null) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onDismiss,
                    child: Text(
                      dismissLabel!,
                      style: const TextStyle(
                        fontFamily: DesignTypography.fontDisplay,
                        color: DesignColors.dayBright,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
    );
  }
}

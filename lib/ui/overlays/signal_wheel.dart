import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../app/theme.dart';
import '../../l10n/lookup.dart';
import '../icons.dart';

/// Signal-Rad: 6 Gesten innen, 8 Schnellchat-Phrasen außen.
class SignalWheel extends StatelessWidget {
  const SignalWheel({super.key, required this.onSignal, required this.onClose, this.accent = Noir.brass});

  final void Function(String kind, String value) onSignal;
  final VoidCallback onClose;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return GestureDetector(
      onTap: onClose,
      child: ColoredBox(
        color: const Color(0xB3000000),
        child: LayoutBuilder(
          builder: (context, box) {
            final c = Offset(box.maxWidth / 2, box.maxHeight / 2);
            final outer = math.min(150.0, math.min(box.maxWidth, box.maxHeight) / 2 - 62);
            final inner = outer * 0.47;
            final children = <Widget>[];
            // Ringe
            children.add(
              Positioned(
                left: c.dx - outer - 50,
                top: c.dy - outer - 50,
                child: IgnorePointer(
                  child: Container(
                    width: (outer + 50) * 2,
                    height: (outer + 50) * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [accent.withValues(alpha: 0.12), const Color(0x00000000)]),
                    ),
                  ),
                ),
              ),
            );
            for (var i = 0; i < quickChatIds.length; i++) {
              final a = -math.pi / 2 + i * 2 * math.pi / quickChatIds.length;
              final p = c + Offset(math.cos(a), math.sin(a)) * outer;
              final id = quickChatIds[i];
              children.add(
                Positioned(
                  left: (p.dx - 62).clamp(4.0, box.maxWidth - 128),
                  top: p.dy - 24,
                  width: 124,
                  height: 48,
                  child: _QuickPill(
                    icon: GameIcons.quick(id),
                    text: l.quickText(id),
                    danger: id == 'help' || id == 'danger',
                    onTap: () => onSignal('quick', id),
                  ).animate().fadeIn(delay: (20 * i).ms, duration: 160.ms).scale(begin: const Offset(0.8, 0.8)),
                ),
              );
            }
            for (var i = 0; i < emoteIds.length; i++) {
              final a = -math.pi / 2 + i * 2 * math.pi / emoteIds.length;
              final p = c + Offset(math.cos(a), math.sin(a)) * inner;
              final id = emoteIds[i];
              children.add(
                Positioned(
                  left: p.dx - 25,
                  top: p.dy - 25,
                  width: 50,
                  height: 50,
                  child: Tooltip(
                    message: l.emoteLabel(id),
                    child: _EmoteButton(icon: GameIcons.emote(id), accent: accent, onTap: () => onSignal('emote', id)),
                  ).animate().fadeIn(duration: 140.ms).scale(begin: const Offset(0.6, 0.6)),
                ),
              );
            }
            children.add(
              Positioned(
                left: c.dx - 26,
                top: c.dy - 26,
                width: 52,
                height: 52,
                child: GestureDetector(
                  onTap: onClose,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Noir.night,
                      border: Border.all(color: const Color(0x55E8E0D0)),
                    ),
                    child: const Icon(Icons.close_rounded, color: Noir.smoke),
                  ),
                ),
              ),
            );
            children.add(
              Positioned(
                left: 0,
                right: 0,
                top: c.dy - outer - 78,
                child: Column(
                  children: [
                    Text(l.hud_signals, textAlign: TextAlign.center, style: Noir.title(22)),
                    const SizedBox(height: 2),
                    Text(
                      '${l.hud_emotes} · ${l.hud_quick_chat}',
                      textAlign: TextAlign.center,
                      style: Noir.label(11, color: Noir.smoke, spacing: 1.2),
                    ),
                  ],
                ),
              ),
            );
            return Stack(children: children);
          },
        ),
      ),
    );
  }
}

class _EmoteButton extends StatelessWidget {
  const _EmoteButton({required this.icon, required this.accent, required this.onTap});

  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xEE1D2138),
          border: Border.all(color: accent.withValues(alpha: 0.7), width: 1.5),
          boxShadow: const [BoxShadow(color: Color(0x88000000), blurRadius: 8)],
        ),
        child: Icon(icon, color: Noir.cream, size: 24),
      ),
    );
  }
}

class _QuickPill extends StatelessWidget {
  const _QuickPill({required this.icon, required this.text, required this.onTap, this.danger = false});

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final c = danger ? Noir.bloodBright : Noir.paper;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: danger ? const Color(0xEE3A0E10) : const Color(0xEEE8E0D0),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: c.withValues(alpha: 0.8)),
          boxShadow: const [BoxShadow(color: Color(0x88000000), blurRadius: 8, offset: Offset(0, 3))],
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: danger ? Noir.bloodBright : Noir.blood),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Noir.text(11, color: danger ? Noir.cream : Noir.ink, weight: FontWeight.w600, height: 1.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

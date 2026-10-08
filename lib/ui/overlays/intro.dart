import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../app/theme.dart';
import '../../l10n/lookup.dart';
import '../widgets/buttons.dart';
import '../widgets/noir_backdrop.dart';
import '../widgets/paper.dart';
import '../widgets/portrait.dart';
import '../widgets/typewriter.dart';
import 'game_context.dart';

/// Kapitel-Einleitung: Titel, Intro-Text (Schreibmaschine), im ersten Kapitel das Opfer.
class IntroOverlay extends StatelessWidget {
  const IntroOverlay({super.key, required this.g});

  final GameCtx g;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final s = g.scenario;
    final ch = s == null ? null : s.chapters[(g.cv.chapter - 1).clamp(0, s.chapters.length - 1)];
    final me = g.player(g.me);
    final ready = me?.ready ?? false;
    final bg = s == null ? Noir.night : Color(s.theme.color('background'));
    return NoirBackdrop(
      accent: g.accent,
      child: DecoratedBox(
        decoration: BoxDecoration(color: bg.withValues(alpha: 0.55)),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, box) => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: box.maxHeight - 44),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                (s?.title.resolve() ?? '').toUpperCase(),
                                textAlign: TextAlign.center,
                                style: Noir.label(12, color: g.accent, spacing: 3.2, weight: FontWeight.w700),
                              ).animate().fadeIn(duration: 500.ms),
                              const SizedBox(height: 14),
                              Text(
                                ch?.title.resolve() ?? l.hud_chapter(g.cv.chapter),
                                textAlign: TextAlign.center,
                                style: Noir.title(29, spacing: 0.8),
                              ).animate().fadeIn(delay: 200.ms, duration: 700.ms).slideY(begin: 0.15),
                              const SizedBox(height: 10),
                              Center(child: Container(width: 60, height: 2, color: Noir.blood)),
                              const SizedBox(height: 24),
                              PaperCard(
                                tape: true,
                                padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                                child: TypewriterText(
                                  ch?.intro.resolve() ?? '',
                                  style: Noir.typed(16.5, color: Noir.ink, height: 1.6),
                                  delay: const Duration(milliseconds: 700),
                                  charMs: 30,
                                ),
                              ).animate().fadeIn(delay: 450.ms, duration: 500.ms),
                              if (s != null && g.cv.chapter == 1) ...[
                                const SizedBox(height: 22),
                                _VictimCard(
                                  scenario: s,
                                  accent: g.accent,
                                ).animate().fadeIn(delay: 1600.ms, duration: 600.ms).slideY(begin: 0.1),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder<WorldSnapshot?>(
                valueListenable: g.session.world,
                builder: (context, w, _) {
                  final rem = w?.phaseRemainingMs ?? 0;
                  final tot = (w?.phaseTotalMs ?? 1).clamp(1, 1 << 30);
                  return LinearProgressIndicator(
                    value: (rem / tot).clamp(0.0, 1.0),
                    minHeight: 2,
                    backgroundColor: Noir.lineSoft,
                    color: g.accent,
                  );
                },
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                color: Noir.barSoft,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: ready
                        ? Row(
                            children: [
                              Expanded(
                                child: Text(l.intro_waiting, style: Noir.text(14, color: Noir.smoke)),
                              ),
                              for (final p in g.cv.lobby)
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      DetectiveAvatar(coat: p.coat, hat: p.hat, size: 34),
                                      if (p.ready || p.bot)
                                        const Positioned(
                                          right: -3,
                                          bottom: -3,
                                          child: Icon(Icons.check_circle_rounded, size: 15, color: Noir.buff),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          )
                        : NoirButton(
                            label: l.intro_ready,
                            icon: Icons.check_rounded,
                            accent: g.accent,
                            onPressed: () => g.send(const SetReady(true)),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VictimCard extends StatelessWidget {
  const _VictimCard({required this.scenario, required this.accent});

  final ScenarioDef scenario;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final v = scenario.victim;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Noir.glass,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Noir.blood.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            color: Noir.paper,
            child: Portrait(look: v.look, size: 76, accent: Noir.blood, dead: true),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.intro_victim.toUpperCase(),
                  style: Noir.label(10.5, color: Noir.bloodBright, spacing: 2, weight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(v.name.resolve(), style: Noir.title(19)),
                const SizedBox(height: 4),
                Text(v.text.resolve(), style: Noir.text(12.5, color: Noir.smoke, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

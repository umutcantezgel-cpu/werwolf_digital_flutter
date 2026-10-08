import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:mordakte_core/mordakte_core.dart';
import 'package:provider/provider.dart';

import '../../app/app_state.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../l10n/lookup.dart';
import '../../meta/meta_store.dart';
import '../widgets/buttons.dart';
import '../widgets/noir_backdrop.dart';
import '../widgets/panels.dart';
import '../widgets/paper.dart';

class CasesScreen extends StatefulWidget {
  const CasesScreen({super.key});

  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen> {
  final Map<String, String> _mode = {};
  String? _starting;

  Future<void> _start(ScenarioDef s, String mode) async {
    setState(() => _starting = s.id);
    final app = context.read<AppState>();
    await app.startSolo(s, mode);
    if (mounted) context.go(Routes.lobby);
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final app = context.read<AppState>();
    final meta = context.watch<MetaStore>();
    final list = app.sortedScenarios;
    final daily = app.daily;
    return Scaffold(
      body: NoirBackdrop(
        rain: false,
        child: SafeArea(
          child: Column(
            children: [
              ContentWidth(
                child: NoirTopBar(
                  title: l.cases_title,
                  subtitle: l.cases_subtitle,
                  onBack: () => context.go(Routes.hub),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final s = list[i];
                    final isDaily = daily.scenarioId == s.id;
                    final mode = _mode[s.id] ?? (meta.storySolved(s.id) ? 'random' : 'story');
                    return ContentWidth(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 26),
                            child: _CaseFile(
                              scenario: s,
                              index: i + 1,
                              daily: isDaily,
                              mode: mode,
                              endings: meta.endingsFor(s.id).length,
                              storySolved: meta.storySolved(s.id),
                              busy: _starting == s.id,
                              onMode: (m) => setState(() => _mode[s.id] = m),
                              onStart: _starting == null ? () => _start(s, mode) : null,
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: (120 * i).ms, duration: 450.ms)
                        .slideY(begin: 0.06, curve: Curves.easeOutCubic);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CaseFile extends StatelessWidget {
  const _CaseFile({
    required this.scenario,
    required this.index,
    required this.daily,
    required this.mode,
    required this.endings,
    required this.storySolved,
    required this.busy,
    required this.onMode,
    required this.onStart,
  });

  final ScenarioDef scenario;
  final int index;
  final bool daily;
  final String mode;
  final int endings;
  final bool storySolved;
  final bool busy;
  final ValueChanged<String> onMode;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final accent = accentOf(scenario);
    final dark = Color(scenario.theme.color('background'));
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reiter der Mappe
            Container(
              margin: const EdgeInsets.only(left: 14),
              padding: const EdgeInsets.fromLTRB(14, 6, 18, 5),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
              ),
              child: Text(
                l.case_file_no(index.toString().padLeft(2, '0')).toUpperCase(),
                style: Noir.label(
                  11,
                  color: Color.lerp(accent, Colors.black, 0.75)!,
                  spacing: 2,
                  weight: FontWeight.w700,
                ),
              ),
            ),
            PaperCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Kopf in Szenario-Farben
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color.lerp(dark, accent, 0.18)!, dark],
                      ),
                      border: Border(bottom: BorderSide(color: accent, width: 3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(scenario.title.resolve(), style: Noir.title(27, color: Noir.cream, spacing: 0.8)),
                        const SizedBox(height: 6),
                        Text(
                          scenario.tagline.resolve(),
                          style: Noir.text(14, color: accent, weight: FontWeight.w600, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(scenario.synopsis.resolve(), style: Noir.typed(14, color: Noir.ink, height: 1.5)),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 14,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${l.case_difficulty} ', style: Noir.label(11, color: Noir.inkSoft, spacing: 0.4)),
                                DifficultyDots(value: scenario.difficulty, color: Noir.blood),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.schedule_rounded, size: 15, color: Noir.inkSoft),
                                const SizedBox(width: 3),
                                Text(
                                  l.common_minutes(scenario.minutes),
                                  style: Noir.label(12, color: Noir.inkSoft, spacing: 0.3),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.auto_stories_rounded, size: 15, color: Noir.inkSoft),
                                const SizedBox(width: 4),
                                Text(l.case_endings(endings), style: Noir.label(12, color: Noir.inkSoft, spacing: 0.3)),
                              ],
                            ),
                            if (storySolved)
                              TagChip(l.case_story_solved, color: const Color(0xFF3F7D45), icon: Icons.check_rounded),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _ModePicker(mode: mode, daily: daily, accent: accent, onMode: onMode),
                        const SizedBox(height: 8),
                        Text(
                          mode == 'daily' && !daily ? l.mode_daily_other : l.modeDesc(mode),
                          style: Noir.text(12.5, color: Noir.inkSoft, height: 1.35),
                        ),
                        const SizedBox(height: 14),
                        NoirButton(
                          label: busy ? l.case_starting : l.case_start,
                          icon: Icons.folder_open_rounded,
                          style: NoirButtonStyle.danger,
                          busy: busy,
                          onPressed: mode == 'daily' && !daily ? null : onStart,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (daily)
          Positioned(
            right: 10,
            top: 2,
            child: Stamp(text: l.mode_daily, fontSize: 13, angle: 0.08, color: Noir.brassLight),
          ),
      ],
    );
  }
}

class _ModePicker extends StatelessWidget {
  const _ModePicker({required this.mode, required this.daily, required this.accent, required this.onMode});

  final String mode;
  final bool daily;
  final Color accent;
  final ValueChanged<String> onMode;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    Widget seg(String id, IconData icon, {bool enabled = true}) {
      final sel = mode == id;
      return Expanded(
        child: GestureDetector(
          onTap: enabled ? () => onMode(id) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: sel ? Noir.ink : Colors.transparent,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: sel ? accent : (enabled ? Noir.inkSoft : Noir.inkSoft.withValues(alpha: 0.35)),
                ),
                const SizedBox(height: 3),
                Text(
                  l.modeName(id),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Noir.label(
                    11.5,
                    color: sel ? Noir.cream : (enabled ? Noir.ink : Noir.inkSoft.withValues(alpha: 0.4)),
                    spacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0x14000000),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0x33000000)),
      ),
      child: Row(
        children: [
          seg('story', Icons.menu_book_rounded),
          seg('random', Icons.casino_rounded),
          seg('daily', Icons.today_rounded, enabled: daily),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../app/app_state.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../l10n/lookup.dart';
import '../../meta/meta_store.dart';
import '../../meta/progression.dart';
import '../widgets/buttons.dart';
import '../widgets/logo.dart';
import '../widgets/meters.dart';
import '../widgets/noir_backdrop.dart';
import '../widgets/panels.dart';
import '../widgets/paper.dart';

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  bool _starting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!context.read<MetaStore>().hasName) showNameDialog(context, first: true);
    });
  }

  Future<void> _playDaily() async {
    final app = context.read<AppState>();
    final id = app.daily.scenarioId;
    final s = id == null ? null : app.scenarios[id];
    if (s == null) return;
    setState(() => _starting = true);
    await app.startSolo(s, 'daily');
    if (mounted) context.go(Routes.lobby);
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final meta = context.watch<MetaStore>();
    final app = context.read<AppState>();
    final daily = app.daily;
    final dailyScenario = daily.scenarioId == null ? null : app.scenarios[daily.scenarioId];
    final accent = accentOf(dailyScenario);
    final now = DateTime.now();

    return Scaffold(
      body: NoirBackdrop(
        accent: accent,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: ContentWidth(
              maxWidth: 520,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 18),
                  Center(child: MordakteLogo(size: 44, subtitle: l.appSubtitle))
                      .animate()
                      .fadeIn(duration: 700.ms)
                      .slideY(begin: -0.08, curve: Curves.easeOutCubic),
                  const SizedBox(height: 36),
                  _BadgeCard(meta: meta).animate().fadeIn(delay: 150.ms, duration: 500.ms),
                  const SizedBox(height: 16),
                  if (dailyScenario != null)
                    _DailyCard(
                      title: dailyScenario.title.resolve(),
                      tagline: dailyScenario.tagline.resolve(),
                      date: DateFormat('d. MMMM', 'de').format(now),
                      accent: accent,
                      done: meta.dailyDone(now),
                      busy: _starting,
                      onPlay: _playDaily,
                    ).animate().fadeIn(delay: 250.ms, duration: 500.ms).slideY(begin: 0.05),
                  const SizedBox(height: 22),
                  NoirButton(
                    label: l.hub_cases,
                    subtitle: l.hub_cases_sub,
                    icon: Icons.folder_open_rounded,
                    height: 62,
                    onPressed: () => context.go(Routes.cases),
                  ).animate().fadeIn(delay: 350.ms),
                  const SizedBox(height: 12),
                  NoirButton(
                    label: l.hub_online,
                    subtitle: l.hub_online_sub,
                    icon: Icons.public_rounded,
                    style: NoirButtonStyle.secondary,
                    height: 58,
                    onPressed: () => context.go(Routes.online),
                  ).animate().fadeIn(delay: 420.ms),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: NoirButton(
                          label: l.hub_collection,
                          icon: Icons.collections_bookmark_rounded,
                          style: NoirButtonStyle.secondary,
                          height: 50,
                          onPressed: () => context.go(Routes.collection),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: NoirButton(
                          label: l.hub_profile,
                          icon: Icons.badge_rounded,
                          style: NoirButtonStyle.secondary,
                          height: 50,
                          onPressed: () => context.go(Routes.profile),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 490.ms),
                  const SizedBox(height: 28),
                  Text(
                    '„${l.hub_motto}“',
                    textAlign: TextAlign.center,
                    style: Noir.typed(13, color: Noir.smokeDim),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.meta});

  final MetaStore meta;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final streak = meta.streak;
    return GlassPanel(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              RankBadge(rank: meta.rank, size: 50),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => showNameDialog(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              meta.name ?? l.name_default,
                              style: Noir.title(21),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.edit_rounded, size: 14, color: Noir.smokeDim),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(l.rankName(meta.rank).toUpperCase(),
                        style: Noir.label(11.5, color: Noir.brass, spacing: 2.4, weight: FontWeight.w700)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: streak > 0 ? const Color(0x33D9822B) : const Color(0x14E8E0D0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: streak > 0 ? const Color(0xAAD9822B) : Noir.line),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department_rounded,
                        size: 17, color: streak > 0 ? const Color(0xFFF0A040) : Noir.smokeDim),
                    const SizedBox(width: 4),
                    Text('$streak', style: Noir.label(14, color: Noir.cream, spacing: 0, weight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          XpBar(xp: meta.xp),
          const SizedBox(height: 4),
          Text(l.hub_streak(streak), style: Noir.text(11.5, color: Noir.smokeDim)),
        ],
      ),
    );
  }
}

class _DailyCard extends StatelessWidget {
  const _DailyCard({
    required this.title,
    required this.tagline,
    required this.date,
    required this.accent,
    required this.done,
    required this.busy,
    required this.onPlay,
  });

  final String title;
  final String tagline;
  final String date;
  final Color accent;
  final bool done;
  final bool busy;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return PaperCard(
      clip: true,
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 7, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(l.hub_daily_title.toUpperCase(),
                            style: Noir.label(11, color: Noir.blood, spacing: 2, weight: FontWeight.w700)),
                        const Spacer(),
                        Text(date, style: Noir.typed(12, color: Noir.inkSoft)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(title, style: Noir.title(22, color: Noir.ink, spacing: 0.6)),
                    const SizedBox(height: 4),
                    Text(tagline, style: Noir.typed(13.5, color: Noir.inkSoft)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (done)
                          Row(children: [
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF3F7D45), size: 18),
                            const SizedBox(width: 6),
                            Text(l.hub_daily_done, style: Noir.label(13, color: const Color(0xFF3F7D45), spacing: 0.3)),
                          ])
                        else
                          TagChip(l.hub_daily_bonus(dailyBonusXp), color: Noir.blood, icon: Icons.bolt_rounded),
                        const Spacer(),
                        SizedBox(
                          width: 140,
                          child: NoirButton(
                            label: l.hub_daily_play,
                            height: 42,
                            accent: accent,
                            busy: busy,
                            icon: Icons.search_rounded,
                            onPressed: onPlay,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fragt den Spielernamen ab (beim ersten Start Pflicht).
Future<void> showNameDialog(BuildContext context, {bool first = false}) async {
  final meta = context.read<MetaStore>();
  final l = L.of(context);
  final ctrl = TextEditingController(text: meta.name ?? '');
  await showDialog<void>(
    context: context,
    barrierDismissible: !first,
    barrierColor: const Color(0xCC000000),
    builder: (c) {
      void save() {
        final v = ctrl.text.trim();
        meta.name = v.isEmpty ? l.name_default : (v.length > 16 ? v.substring(0, 16) : v);
        Navigator.of(c).pop();
      }

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: PaperCard(
            clip: true,
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(first ? l.name_prompt_title : l.name_edit, style: Noir.title(22, color: Noir.ink, spacing: 0.5)),
                const SizedBox(height: 6),
                Text(l.name_prompt_text, style: Noir.typed(13.5, color: Noir.inkSoft)),
                const SizedBox(height: 18),
                TextField(
                  controller: ctrl,
                  autofocus: true,
                  maxLength: 16,
                  textCapitalization: TextCapitalization.words,
                  style: Noir.typed(20, color: Noir.ink),
                  cursorColor: Noir.blood,
                  decoration: InputDecoration(
                    hintText: l.name_prompt_hint,
                    counterText: '',
                    filled: true,
                    fillColor: const Color(0x14000000),
                    hintStyle: Noir.typed(20, color: Noir.inkSoft.withValues(alpha: 0.5)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Noir.inkSoft)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Noir.blood, width: 2)),
                  ),
                  onSubmitted: (_) => save(),
                ),
                const SizedBox(height: 20),
                NoirButton(
                  label: first ? l.name_prompt_confirm : l.common_save,
                  icon: Icons.badge_rounded,
                  style: NoirButtonStyle.danger,
                  onPressed: save,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

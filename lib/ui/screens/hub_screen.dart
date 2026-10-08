import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../session/session_factory.dart';

import '../../app/app_state.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../l10n/lookup.dart';
import '../../meta/meta_store.dart';
import '../../meta/progression.dart';
import '../widgets/bento.dart';
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
  String? _lastRoom;

  @override
  void initState() {
    super.initState();
    SessionFactory.storedOnlineRoom().then((code) {
      if (mounted && code != null) setState(() => _lastRoom = code);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final app = context.read<AppState>();
      final lost = app.lostKey;
      if (lost != null) {
        app.lostKey = null;
        final l = L.of(context);
        showNoirSnack(
          context,
          '${l.error_room_lost} ${l.errorText(lost)}',
          icon: Icons.wifi_off_rounded,
          color: Noir.bloodBright,
        );
      }
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
    const gap = 12.0;
    var step = 0;
    // Gestaffeltes Einblenden der Kacheln.
    Widget stagger(Widget w) => w
        .animate()
        .fadeIn(delay: (120 + 70 * step++).ms, duration: 420.ms)
        .slideY(begin: 0.08, curve: Curves.easeOutCubic);

    return Scaffold(
      body: NoirBackdrop(
        accent: accent,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 26),
            child: ContentWidth(
              maxWidth: 520,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 14),
                  Center(child: MordakteLogo(size: 44, subtitle: l.appSubtitle))
                      .animate()
                      .fadeIn(duration: 700.ms)
                      .slideY(begin: -0.08, curve: Curves.easeOutCubic),
                  const SizedBox(height: 30),
                  // Reihe 1: Dienstmarke (2/3) + Serie (1/3)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 2, child: stagger(_BadgeTile(meta: meta))),
                        const SizedBox(width: gap),
                        Expanded(child: stagger(_StreakTile(streak: meta.streak))),
                      ],
                    ),
                  ),
                  const SizedBox(height: gap),
                  // Reihe 2: Fall des Tages (volle Breite)
                  if (dailyScenario != null) ...[
                    stagger(
                      _DailyCard(
                        title: dailyScenario.title.resolve(),
                        tagline: dailyScenario.tagline.resolve(),
                        date: DateFormat('d. MMMM', 'de').format(now),
                        accent: accent,
                        done: meta.dailyDone(now),
                        busy: _starting,
                        onPlay: _playDaily,
                      ),
                    ),
                    const SizedBox(height: gap + 4),
                  ],
                  // Reihe 3: Fallakten (Hauptkachel mit Glow) + Online
                  SizedBox(
                    height: 156,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: stagger(
                            BentoTile(
                                  highlight: true,
                                  onTap: () => context.go(Routes.cases),
                                  padding: const EdgeInsets.all(16),
                                  child: _TileBody(
                                    icon: Icons.folder_open_rounded,
                                    title: l.hub_cases,
                                    subtitle: l.hub_cases_sub,
                                    dark: true,
                                    big: true,
                                  ),
                                )
                                .animate(onPlay: (c) => c.repeat())
                                .shimmer(
                                  delay: 2600.ms,
                                  duration: 1800.ms,
                                  color: Noir.whiteSoft.withValues(alpha: 0.35),
                                ),
                          ),
                        ),
                        const SizedBox(width: gap),
                        Expanded(
                          flex: 2,
                          child: stagger(
                            BentoTile(
                              onTap: () => context.go(Routes.online),
                              child: _TileBody(
                                icon: Icons.public_rounded,
                                title: l.hub_online,
                                subtitle: _lastRoom == null ? l.hub_online_sub : l.hub_online_rejoin(_lastRoom!),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: gap),
                  // Reihe 4: Sammlung + Profil
                  SizedBox(
                    height: 112,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: stagger(
                            BentoTile(
                              onTap: () => context.go(Routes.collection),
                              child: _TileBody(
                                icon: Icons.collections_bookmark_rounded,
                                title: l.hub_collection,
                                subtitle: l.collection_discovered(meta.totalEndings),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: gap),
                        Expanded(
                          child: stagger(
                            BentoTile(
                              onTap: () => context.go(Routes.profile),
                              child: _TileBody(
                                icon: Icons.badge_rounded,
                                title: l.hub_profile,
                                subtitle: l.collection_achievements_count(
                                  meta.achievements.length,
                                  achievementIds.length,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    '„${l.hub_motto}“',
                    textAlign: TextAlign.center,
                    style: Noir.typed(13, color: Noir.smokeDim),
                  ).animate().fadeIn(delay: 900.ms, duration: 600.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Inhalt einer Bento-Kachel: Symbol oben, Titel + Untertitel unten.
class _TileBody extends StatelessWidget {
  const _TileBody({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.dark = false,
    this.big = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool dark;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Noir.night : Noir.cream;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TileIcon(icon, onDark: !dark, size: big ? 24 : 20),
            const Spacer(),
            Icon(Icons.arrow_forward_rounded, size: 18, color: fg.withValues(alpha: 0.55)),
          ],
        ),
        const Spacer(),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            maxLines: 1,
            style: Noir.title(big ? 26 : 18, color: fg, spacing: big ? 1.4 : 0.8),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Noir.text(12, color: fg.withValues(alpha: dark ? 0.75 : 0.62), height: 1.25),
        ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.meta});

  final MetaStore meta;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return BentoTile(
      onTap: () => showNameDialog(context),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              RankBadge(rank: meta.rank, size: 46),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            meta.name ?? l.name_default,
                            style: Noir.title(20),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.edit_rounded, size: 13, color: Noir.smokeDim),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.rankName(meta.rank).toUpperCase(),
                      style: Noir.label(11, color: Noir.brass, spacing: 2.2, weight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          XpBar(xp: meta.xp),
        ],
      ),
    );
  }
}

class _StreakTile extends StatelessWidget {
  const _StreakTile({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final on = streak > 0;
    Widget flame = Icon(Icons.local_fire_department_rounded, size: 34, color: on ? Noir.flame : Noir.smokeDim);
    if (on) {
      flame = flame
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scaleXY(begin: 0.92, end: 1.08, duration: 900.ms, curve: Curves.easeInOut);
    }
    return BentoTile(
      accent: Noir.flame,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          flame,
          const SizedBox(height: 2),
          Text('$streak', style: Noir.title(28, color: on ? Noir.cream : Noir.smoke)),
          Text(
            l.hub_streak_label(streak),
            textAlign: TextAlign.center,
            maxLines: 2,
            style: Noir.label(10, color: Noir.smoke, spacing: 0.3, weight: FontWeight.w500),
          ),
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
      tape: true,
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
                        Text(
                          l.hub_daily_title.toUpperCase(),
                          style: Noir.label(11, color: Noir.blood, spacing: 2, weight: FontWeight.w700),
                        ),
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
                          Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Noir.success, size: 18),
                              const SizedBox(width: 6),
                              Text(l.hub_daily_done, style: Noir.label(13, color: Noir.success, spacing: 0.3)),
                            ],
                          )
                        else
                          TagChip(l.hub_daily_bonus(dailyBonusXp), color: Noir.blood, icon: Icons.bolt_rounded),
                        const Spacer(),
                        SizedBox(
                          width: 148,
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
    barrierColor: Noir.scrim,
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
                    fillColor: Noir.shadeFaint,
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

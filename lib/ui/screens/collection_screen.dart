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
import '../../meta/progression.dart';
import '../icons.dart';
import '../overlays/ending.dart' show verdictColor;
import '../widgets/buttons.dart';
import '../widgets/noir_backdrop.dart';
import '../widgets/panels.dart';
import '../widgets/paper.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final meta = context.watch<MetaStore>();
    final app = context.read<AppState>();
    return Scaffold(
      body: NoirBackdrop(
        rain: false,
        child: SafeArea(
          child: Column(
            children: [
              ContentWidth(
                child: NoirTopBar(
                  title: l.collection_title,
                  subtitle: l.collection_discovered(meta.totalEndings),
                  onBack: () => context.go(Routes.hub),
                ),
              ),
              ContentWidth(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
                  child: _Tabs(
                    tab: _tab,
                    labels: [l.collection_endings, l.collection_achievements],
                    onTab: (t) => setState(() => _tab = t),
                  ),
                ),
              ),
              Expanded(
                child: _tab == 0
                    ? ListView(
                        padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
                        children: [
                          for (final (i, s) in app.sortedScenarios.indexed)
                            ContentWidth(
                              child: _ScenarioEndings(scenario: s, found: meta.endingsFor(s.id)),
                            ).animate().fadeIn(delay: (100 * i).ms).slideY(begin: 0.05),
                        ],
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
                        children: [ContentWidth(child: AchievementList(meta: meta))],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.tab, required this.labels, required this.onTab});

  final int tab;
  final List<String> labels;
  final ValueChanged<int> onTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Noir.panel,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Noir.lineSoft),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onTab(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: tab == i ? Noir.brass : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: Noir.label(13, color: tab == i ? Noir.night : Noir.smoke, spacing: 0.4),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScenarioEndings extends StatelessWidget {
  const _ScenarioEndings({required this.scenario, required this.found});

  final ScenarioDef scenario;
  final Set<String> found;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final accent = accentOf(scenario);
    final keys = found.map(EndingKey.parse).toList()
      ..sort((a, b) => EndingsDef.verdictKeys.indexOf(a.verdict).compareTo(EndingsDef.verdictKeys.indexOf(b.verdict)));
    final combos = {for (final k in keys) '${k.verdict}.${k.team}'};
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: GlassPanel(
        accent: accent,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [accent.withValues(alpha: 0.22), Colors.transparent]),
                border: Border(bottom: BorderSide(color: accent.withValues(alpha: 0.4))),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(scenario.title.resolve(), style: Noir.title(20))),
                  TagChip(l.collection_discovered(found.length), color: accent),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.collection_grid.toUpperCase(), style: Noir.label(10, color: Noir.smoke, spacing: 1.8)),
                  const SizedBox(height: 8),
                  _Grid(combos: combos, scenario: scenario),
                  const SizedBox(height: 14),
                  if (keys.isEmpty)
                    Text(l.collection_no_endings, style: Noir.typed(13.5, color: Noir.smoke))
                  else
                    for (final k in keys) _EndingRow(k: k, scenario: scenario),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.combos, required this.scenario});

  final Set<String> combos;
  final ScenarioDef scenario;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    const teams = EndingsDef.teamKeys;
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 86),
            for (final t in teams)
              Expanded(
                child: Text(
                  l.teamLabel(t),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: Noir.label(8.5, color: Noir.smokeDim, spacing: 0.2, weight: FontWeight.w500),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (final v in EndingsDef.verdictKeys)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 86,
                  child: Text(
                    l.verdictStamp(v),
                    style: Noir.label(10.5, color: verdictColor(v), spacing: 0.4),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                for (final t in teams)
                  Expanded(
                    child: Container(
                      height: 18,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: combos.contains('$v.$t') ? verdictColor(v) : Noir.lineFaint,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: Noir.lineSoft),
                      ),
                      child: combos.contains('$v.$t')
                          ? const Icon(Icons.check_rounded, size: 12, color: Noir.night)
                          : null,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _EndingRow extends StatelessWidget {
  const _EndingRow({required this.k, required this.scenario});

  final EndingKey k;
  final ScenarioDef scenario;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final verdict = scenario.endings.verdict[k.verdict]?.title.resolve() ?? l.verdictStamp(k.verdict);
    final culprit = k.culprit == null ? null : scenario.suspectById[k.culprit]?.name.resolve();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: PaperCard(
        padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
        child: Row(
          children: [
            Container(width: 4, height: 34, color: verdictColor(k.verdict)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(verdict, style: Noir.title(15, color: Noir.ink, spacing: 0.2)),
                  Text([l.teamLabel(k.team), ?culprit].join(' · '), style: Noir.text(11.5, color: Noir.inkSoft)),
                ],
              ),
            ),
            if (k.secret) TagChip(l.collection_secret, color: Noir.blood, icon: Icons.lock_open_rounded),
          ],
        ),
      ),
    );
  }
}

/// Liste aller Erfolge (auch im Profil verwendet).
class AchievementList extends StatelessWidget {
  const AchievementList({super.key, required this.meta, this.compact = false});

  final MetaStore meta;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final done = meta.achievements;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.collection_achievements_count(done.length, achievementIds.length),
          style: Noir.label(12, color: Noir.smoke, spacing: 0.4),
        ),
        const SizedBox(height: 10),
        for (final id in achievementIds)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: done.contains(id) ? Noir.brassWash : Noir.panel,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: done.contains(id) ? Noir.brass.withValues(alpha: 0.6) : Noir.lineSoft),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: done.contains(id)
                        ? const RadialGradient(colors: [Noir.brassLight, Noir.brass, Noir.brassDim])
                        : null,
                    color: done.contains(id) ? null : Noir.lineSoft,
                  ),
                  child: Icon(
                    done.contains(id) ? GameIcons.achievement(id) : Icons.lock_rounded,
                    size: 20,
                    color: done.contains(id) ? Noir.night : Noir.smokeDim,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.achievementName(id),
                        style: Noir.text(
                          14.5,
                          weight: FontWeight.w600,
                          color: done.contains(id) ? Noir.cream : Noir.smoke,
                        ),
                      ),
                      Text(l.achievementDesc(id), style: Noir.text(12, color: Noir.smokeDim, height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

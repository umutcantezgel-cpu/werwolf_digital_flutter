import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../app/theme.dart';
import '../../l10n/lookup.dart';
import '../../meta/meta_store.dart';
import '../../meta/progression.dart';
import '../icons.dart';
import '../widgets/buttons.dart';
import '../widgets/meters.dart';
import '../widgets/noir_backdrop.dart';
import '../widgets/paper.dart';
import '../widgets/portrait.dart';
import 'game_context.dart';

Color verdictColor(String v) => switch (v) {
      'perfect' => Noir.brassLight,
      'solid' => const Color(0xFF7CC47F),
      'partial' => const Color(0xFFE0A050),
      'wrong' => Noir.bloodBright,
      _ => Noir.smoke,
    };

/// Zusammengesetztes Ende: Urteil, Team, Täter-Epilog, Geheimnis, Auflösung, Auszeichnungen, XP.
class EndingOverlay extends StatelessWidget {
  const EndingOverlay({
    super.key,
    required this.g,
    required this.ending,
    required this.result,
    required this.onNewCase,
    required this.onHub,
  });

  final GameCtx g;
  final EndingView ending;
  final GameResult? result;
  final VoidCallback onNewCase;
  final VoidCallback onHub;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final s = g.scenario;
    final vColor = verdictColor(ending.verdict);
    final verdict = s?.endings.verdict[ending.verdict];
    final culpritDef = s?.suspectById[ending.truth.culprit];
    final epilogue = s?.endings.culprit[ending.truth.culprit]?[ending.caught ? 'caught' : 'escaped']?.resolve();
    final teamText = s?.endings.team[ending.team]?.resolve();
    var delay = 0;
    int next([int step = 160]) => delay += step;

    return NoirBackdrop(
      accent: vColor,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${l.ending_case_closed} · ${s?.title.resolve() ?? ''}'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Noir.label(11, color: Noir.smoke, spacing: 2.4),
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 22),
                    Center(
                      child: Stamp(text: l.verdictStamp(ending.verdict), color: vColor, fontSize: 34, angle: -0.06),
                    ).animate().scale(begin: const Offset(2.4, 2.4), duration: 420.ms, curve: Curves.easeIn).fadeIn(),
                    const SizedBox(height: 18),
                    Text(verdict?.title.resolve() ?? '', textAlign: TextAlign.center, style: Noir.title(28))
                        .animate()
                        .fadeIn(delay: next(400).ms),
                    const SizedBox(height: 8),
                    Text(
                      verdict?.text.resolve() ?? '',
                      textAlign: TextAlign.center,
                      style: Noir.typed(15, color: Noir.paper, height: 1.55),
                    ).animate().fadeIn(delay: next().ms),
                    const SizedBox(height: 24),
                    // Epilog
                    PaperCard(
                      clip: true,
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(l.ending_team.toUpperCase(), style: Noir.label(10.5, color: Noir.blood, spacing: 2)),
                            const Spacer(),
                            TagChip(l.teamLabel(ending.team), color: Noir.ink),
                          ]),
                          const SizedBox(height: 6),
                          Text(teamText ?? '', style: Noir.typed(14.5, color: Noir.ink)),
                          const SizedBox(height: 16),
                          Text(l.ending_epilogue.toUpperCase(), style: Noir.label(10.5, color: Noir.blood, spacing: 2)),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (culpritDef != null)
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  color: Noir.ink,
                                  child: Portrait(look: culpritDef.look, size: 64, accent: vColor),
                                ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(culpritDef?.name.resolve() ?? '', style: Noir.title(16, color: Noir.ink, spacing: 0.2)),
                                    const SizedBox(height: 4),
                                    Text(epilogue ?? '', style: Noir.typed(14, color: Noir.ink)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: next().ms).slideY(begin: 0.06),
                    if (ending.secret) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1508),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Noir.brassLight, width: 1.5),
                          boxShadow: [BoxShadow(color: Noir.brass.withValues(alpha: 0.35), blurRadius: 20)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Icon(Icons.lock_open_rounded, color: Noir.brassLight, size: 18),
                              const SizedBox(width: 8),
                              Text(l.ending_secret.toUpperCase(),
                                  style: Noir.label(11, color: Noir.brassLight, spacing: 2.2, weight: FontWeight.w700)),
                            ]),
                            const SizedBox(height: 8),
                            Text(s?.endings.secret.resolve() ?? '', style: Noir.typed(14.5, color: Noir.cream)),
                          ],
                        ),
                      ).animate().fadeIn(delay: next().ms).shimmer(delay: 800.ms, duration: 1400.ms, color: Noir.brassLight),
                    ],
                    const SizedBox(height: 22),
                    SectionLabel(l.ending_resolution),
                    _Resolution(g: g, ending: ending).animate().fadeIn(delay: next().ms),
                    const SizedBox(height: 18),
                    Row(children: [
                      Text(l.ending_strength.toUpperCase(), style: Noir.label(11, color: Noir.smoke, spacing: 1.8)),
                      const Spacer(),
                      Text('${ending.strength}', style: Noir.title(20, color: Noir.cream)),
                    ]),
                    const SizedBox(height: 8),
                    StrengthMeter(
                      value: ending.strength,
                      max: math.max(Tuning.strengthPerfect + 2, ending.strength),
                      solid: Tuning.strengthSolid,
                      perfect: Tuning.strengthPerfect,
                    ),
                    if (ending.survivors.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        l.ending_survivors(ending.survivors.map((id) => g.nameOf(id)).join(', ')),
                        style: Noir.text(12.5, color: Noir.smoke),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SectionLabel(l.ending_awards),
                    _Awards(g: g, ending: ending).animate().fadeIn(delay: next().ms),
                    const SizedBox(height: 24),
                    if (result != null) ...[
                      SectionLabel(l.ending_xp),
                      _XpSection(result: result!, l: l).animate().fadeIn(delay: next().ms),
                      const SizedBox(height: 26),
                    ],
                    NoirButton(label: l.ending_new_case, icon: Icons.folder_open_rounded, onPressed: onNewCase),
                    const SizedBox(height: 12),
                    NoirButton(
                      label: l.ending_hub,
                      icon: Icons.home_rounded,
                      style: NoirButtonStyle.secondary,
                      onPressed: onHub,
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

class _Resolution extends StatelessWidget {
  const _Resolution({required this.g, required this.ending});

  final GameCtx g;
  final EndingView ending;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final s = g.scenario;
    final t = ending.truth;
    final a = ending.accused;
    String motive(String? id) => id == null ? l.ending_none : (s?.motiveById[id]?.name.resolve() ?? id);
    String weapon(String? id) => id == null ? l.ending_none : (s?.weaponById[id]?.name.resolve() ?? id);
    String culprit(String? id) => id == null ? l.ending_none : g.npcName(id);
    TableRow row(String label, String truth, String accused, bool ok) => TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(label, style: Noir.label(11.5, color: Noir.smoke, spacing: 0.6)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              child: Text(truth, style: Noir.text(13.5, weight: FontWeight.w600)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              child: Row(children: [
                Icon(ok ? Icons.check_circle_rounded : Icons.cancel_rounded, size: 16, color: ok ? Noir.buff : Noir.debuff),
                const SizedBox(width: 5),
                Flexible(child: Text(accused, style: Noir.text(13.5, color: ok ? Noir.cream : Noir.smoke))),
              ]),
            ),
          ],
        );
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
      decoration: BoxDecoration(
        color: const Color(0xCC0E101C),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0x2EE8E0D0)),
      ),
      child: Table(
        columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth(), 2: FlexColumnWidth()},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x22E8E0D0)))),
            children: [
              const SizedBox(),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
                child: Text(l.ending_truth.toUpperCase(), style: Noir.label(10, color: Noir.brass, spacing: 1.6)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
                child: Text(l.ending_accusation.toUpperCase(), style: Noir.label(10, color: Noir.brass, spacing: 1.6)),
              ),
            ],
          ),
          row(l.ending_culprit, culprit(t.culprit), culprit(a?.culprit), a?.culprit == t.culprit),
          row(l.ending_motive, motive(t.motive), motive(a?.motive), a?.motive == t.motive),
          row(l.ending_weapon, weapon(t.weapon), weapon(a?.weapon), a?.weapon == t.weapon),
        ],
      ),
    );
  }
}

class _Awards extends StatelessWidget {
  const _Awards({required this.g, required this.ending});

  final GameCtx g;
  final EndingView ending;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final entries = ending.awards.entries.where((e) => e.value.isNotEmpty).toList()
      ..sort((a, b) => a.key == g.me ? -1 : (b.key == g.me ? 1 : 0));
    if (entries.isEmpty) return Text(l.ending_no_awards, style: Noir.text(13, color: Noir.smoke));
    return Column(
      children: [
        for (final e in entries)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: e.key == g.me ? const Color(0x22C9A227) : const Color(0xCC0E101C),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: e.key == g.me ? Noir.brass.withValues(alpha: 0.6) : const Color(0x22E8E0D0)),
            ),
            child: Row(
              children: [
                DetectiveAvatar(coat: g.coatOf(e.key), hat: g.hatOf(e.key), size: 40),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.nameOf(e.key), style: Noir.text(14, weight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final a in e.value)
                            Tooltip(
                              message: l.awardDesc(a),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Color(0xFFE6C766), Noir.brass]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  Icon(GameIcons.award(a), size: 13, color: Noir.night),
                                  const SizedBox(width: 4),
                                  Text(l.awardName(a), style: Noir.label(11, color: Noir.night, spacing: 0.3)),
                                ]),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (ending.xp[e.key] != null)
                  Text(l.common_xp_gain(ending.xp[e.key]!), style: Noir.label(12, color: Noir.brassLight, spacing: 0.2)),
              ],
            ),
          ),
      ],
    );
  }
}

class _XpSection extends StatelessWidget {
  const _XpSection({required this.result, required this.l});

  final GameResult result;
  final L l;

  @override
  Widget build(BuildContext context) {
    final r = result;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xCC0E101C),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Noir.brass.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: r.xpBefore.toDouble(), end: r.xpAfter.toDouble()),
            duration: const Duration(milliseconds: 2200),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) {
              final xp = v.round();
              final rank = rankForXp(xp);
              final next = nextRankXp(xp);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      RankBadge(rank: rank, size: 44),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.rankName(rank), style: Noir.title(19)),
                            Text(next == null ? l.hub_rank_max : l.hub_rank_progress(xp, next),
                                style: Noir.text(11.5, color: Noir.smoke)),
                          ],
                        ),
                      ),
                      Text(l.common_xp_gain(xp - r.xpBefore), style: Noir.title(24, color: Noir.brassLight)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: rankProgress(xp),
                      minHeight: 9,
                      backgroundColor: const Color(0x33E8E0D0),
                      color: Noir.brass,
                    ),
                  ),
                ],
              );
            },
          ),
          if (r.dailyBonus > 0) ...[
            const SizedBox(height: 10),
            _Line(icon: Icons.today_rounded, text: '${l.ending_daily_bonus}: ${l.common_xp_gain(r.dailyBonus)}'),
          ],
          const SizedBox(height: 8),
          _Line(icon: Icons.local_fire_department_rounded, text: '${l.ending_streak}: ${l.hub_streak(r.streak)}'),
          const SizedBox(height: 8),
          _Line(
            icon: r.newEnding ? Icons.auto_stories_rounded : Icons.bookmark_rounded,
            text: '${r.newEnding ? l.ending_new_ending : l.ending_known_ending} ${l.ending_collection_count(r.endingsInScenario)}',
            color: r.newEnding ? Noir.brassLight : Noir.smoke,
          ),
          if (r.rankUp) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFE6C766), Noir.brass]),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(children: [
                const Icon(Icons.military_tech_rounded, color: Noir.night),
                const SizedBox(width: 8),
                Text(l.ending_rank_up(l.rankName(r.rankAfter)), style: Noir.title(17, color: Noir.night)),
              ]),
            ).animate().fadeIn(delay: 2200.ms).shake(delay: 2200.ms, hz: 3, rotation: 0.02),
          ],
          if (r.unlocks.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(l.ending_unlocked.toUpperCase(), style: Noir.label(10.5, color: Noir.brass, spacing: 1.8)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final u in r.unlocks)
                  TagChip(
                    switch (u.kind) {
                      'class' => l.className(u.id),
                      'hat' => l.hatName(u.id),
                      _ => l.coat_name((int.tryParse(u.id) ?? 0) + 1),
                    },
                    color: Noir.brassLight,
                    icon: switch (u.kind) {
                      'class' => GameIcons.cls(u.id),
                      'hat' => Icons.face_retouching_natural_rounded,
                      _ => Icons.checkroom_rounded,
                    },
                  ),
              ],
            ),
          ],
          if (r.newAchievements.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(l.ending_achievement.toUpperCase(), style: Noir.label(10.5, color: Noir.brass, spacing: 1.8)),
            const SizedBox(height: 6),
            for (final a in r.newAchievements)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Noir.brass),
                    child: Icon(GameIcons.achievement(a), size: 17, color: Noir.night),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.achievementName(a), style: Noir.text(13.5, weight: FontWeight.w600)),
                        Text(l.achievementDesc(a), style: Noir.text(11.5, color: Noir.smoke, height: 1.25)),
                      ],
                    ),
                  ),
                ]),
              ).animate().fadeIn(delay: 2400.ms).slideX(begin: 0.1),
          ],
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text, this.color = Noir.smoke});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: Noir.text(13, color: color))),
      ]);
}

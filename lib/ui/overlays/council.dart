import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../app/theme.dart';
import '../widgets/portrait.dart';
import 'game_context.dart';

/// Beratung: Spur-Karten mit Stimmen (Avataren), Timer, Abstimmen per Tipp.
class CouncilPanel extends StatelessWidget {
  const CouncilPanel({super.key, required this.g});

  final GameCtx g;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final h = MediaQuery.sizeOf(context).height;
    final pad = MediaQuery.paddingOf(context);
    final options = g.cv.leadOptions;
    final myVote = g.cv.leadVotes[g.me];
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 640, maxHeight: h * 0.64),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xF2131626), Color(0xFA0A0B14)],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            border: Border(top: BorderSide(color: g.accent.withValues(alpha: 0.7), width: 2)),
            boxShadow: const [BoxShadow(color: Color(0xCC000000), blurRadius: 30)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Row(
                  children: [
                    Icon(Icons.forum_rounded, color: g.accent, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.council_title, style: Noir.title(23)),
                          Text(l.council_subtitle, style: Noir.text(12.5, color: Noir.smoke, height: 1.3)),
                        ],
                      ),
                    ),
                    ValueListenableBuilder<WorldSnapshot?>(
                      valueListenable: g.session.world,
                      builder: (context, w, _) {
                        final rem = w?.phaseRemainingMs ?? 0;
                        final urgent = rem < 15000;
                        return Text(formatClock(rem),
                            style: Noir.title(24, color: urgent ? Noir.bloodBright : Noir.brassLight));
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                child: options.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(28),
                        child: Text(l.council_no_leads,
                            textAlign: TextAlign.center, style: Noir.typed(14.5, color: Noir.paper)),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 16 + pad.bottom),
                        itemCount: options.length + (g.cv.chosenLeads.isEmpty ? 0 : 1),
                        itemBuilder: (context, i) {
                          if (i == options.length) return _Chosen(g: g);
                          final id = options[i];
                          final voters = [
                            for (final e in g.cv.leadVotes.entries)
                              if (e.value == id) e.key,
                          ];
                          return _LeadCard(
                            g: g,
                            leadId: id,
                            voters: voters,
                            mine: myVote == id,
                            onVote: () {
                              HapticFeedback.mediumImpact();
                              g.send(VoteLead(id));
                            },
                          ).animate().fadeIn(delay: (90 * i).ms, duration: 300.ms).slideY(begin: 0.12);
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

class _LeadCard extends StatelessWidget {
  const _LeadCard({
    required this.g,
    required this.leadId,
    required this.voters,
    required this.mine,
    required this.onVote,
  });

  final GameCtx g;
  final String leadId;
  final List<String> voters;
  final bool mine;
  final VoidCallback onVote;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final def = g.scenario?.leadById[leadId];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onVote,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Noir.paper,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: mine ? g.accent : Colors.transparent, width: 3),
            boxShadow: [
              const BoxShadow(color: Color(0x99000000), blurRadius: 10, offset: Offset(0, 4)),
              if (mine) BoxShadow(color: g.accent.withValues(alpha: 0.35), blurRadius: 16),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 6, color: mine ? g.accent : Noir.blood),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (def?.hidden ?? false)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(children: [
                              const Icon(Icons.hub_rounded, size: 13, color: Noir.blood),
                              const SizedBox(width: 4),
                              Text(l.council_from_combo.toUpperCase(),
                                  style: Noir.label(9.5, color: Noir.blood, spacing: 1.4)),
                            ]),
                          ),
                        Text(def?.name.resolve() ?? leadId, style: Noir.title(18, color: Noir.ink, spacing: 0.3)),
                        const SizedBox(height: 4),
                        Text(def?.text.resolve() ?? '', style: Noir.typed(13.5, color: Noir.inkSoft)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            for (final v in voters)
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Tooltip(
                                  message: g.nameOf(v),
                                  child: DetectiveAvatar(
                                    coat: g.coatOf(v),
                                    hat: g.hatOf(v),
                                    size: 28,
                                    ring: v == g.me ? g.accent : null,
                                  ),
                                ),
                              ).animate().scale(begin: const Offset(0.4, 0.4), duration: 220.ms, curve: Curves.easeOutBack),
                            if (voters.isEmpty) Text('—', style: Noir.text(13, color: Noir.inkSoft)),
                            const Spacer(),
                            if (mine)
                              Row(children: [
                                Icon(Icons.how_to_vote_rounded, size: 16, color: Color.lerp(g.accent, Noir.ink, 0.35)),
                                const SizedBox(width: 4),
                                Text(l.council_your_vote,
                                    style: Noir.label(12, color: Color.lerp(g.accent, Noir.ink, 0.35)!, spacing: 0.3)),
                              ])
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Noir.ink,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(l.council_vote, style: Noir.label(12, color: Noir.paper, spacing: 0.4)),
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
        ),
      ),
    );
  }
}

class _Chosen extends StatelessWidget {
  const _Chosen({required this.g});

  final GameCtx g;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('${g.l.council_chosen}:', style: Noir.text(12, color: Noir.smoke)),
          for (final id in g.cv.chosenLeads)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: const Color(0x44E8E0D0)),
              ),
              child: Text(g.leadName(id), style: Noir.text(11.5, color: Noir.smoke)),
            ),
        ],
      ),
    );
  }
}

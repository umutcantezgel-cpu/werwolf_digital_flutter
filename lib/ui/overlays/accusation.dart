import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../app/theme.dart';
import '../haptics.dart';
import '../widgets/buttons.dart';
import '../widgets/noir_backdrop.dart';
import '../widgets/paper.dart';
import '../widgets/portrait.dart';
import 'game_context.dart';

/// Anklage: Täter, Motiv und Waffe wählen; Stimmen der anderen sichtbar.
class AccusationOverlay extends StatefulWidget {
  const AccusationOverlay({super.key, required this.g, required this.onNotebook});

  final GameCtx g;
  final VoidCallback onNotebook;

  /// Höhe von Titel, Untertitel und „Beweise ansehen“ (unter der Statusleiste) – Toasts beginnen darunter.
  static const double headerExtent = 118;

  @override
  State<AccusationOverlay> createState() => _AccusationOverlayState();
}

class _AccusationOverlayState extends State<AccusationOverlay> {
  String? _culprit;
  String? _motive;
  String? _weapon;

  /// Der Spieler hat selbst etwas gewählt – dann gilt nur noch die lokale Auswahl.
  bool _touched = false;

  /// Solange der Spieler nichts angetippt hat, die eigene Anklage vom Server übernehmen –
  /// auch wenn sie erst später eintrifft (z. B. vom Autopiloten nach einem Verbindungsabbruch).
  void _syncFromVote() {
    if (_touched) return;
    final mine = widget.g.cv.accusations[widget.g.me];
    if (mine == null) return;
    _culprit = mine.culprit;
    _motive = mine.motive;
    _weapon = mine.weapon;
  }

  @override
  Widget build(BuildContext context) {
    _syncFromVote();
    final g = widget.g;
    final l = g.l;
    final s = g.scenario;
    final mine = g.cv.accusations[g.me];
    final changed = mine == null || mine.culprit != _culprit || mine.motive != _motive || mine.weapon != _weapon;
    final suspects = s?.candidates ?? const <SuspectDef>[];

    List<String> votersFor(bool Function(AccuseVote v) test) => [
      for (final e in g.cv.accusations.entries)
        if (test(e.value)) e.key,
    ];

    return NoirBackdrop(
      accent: Noir.blood,
      rain: false,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 12, 4),
              child: Row(
                children: [
                  const Icon(Icons.gavel_rounded, color: Noir.bloodBright, size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.accuse_title, style: Noir.title(26)),
                        Text(l.accuse_subtitle, style: Noir.text(12.5, color: Noir.smoke)),
                      ],
                    ),
                  ),
                  ValueListenableBuilder<WorldSnapshot?>(
                    valueListenable: g.session.world,
                    builder: (context, w, _) {
                      final rem = w?.phaseRemainingMs ?? 0;
                      return Text(
                        formatClock(rem),
                        style: Noir.title(26, color: rem < 20000 ? Noir.bloodBright : Noir.brassLight),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: widget.onNotebook,
                              icon: const Icon(Icons.menu_book_rounded, size: 18, color: Noir.brass),
                              label: Text(
                                l.accuse_open_notebook,
                                style: Noir.label(12.5, color: Noir.brass, spacing: 0.4),
                              ),
                            ),
                          ),
                          SectionLabel(l.accuse_who, color: Noir.bloodBright),
                          LayoutBuilder(
                            builder: (context, box) {
                              final cols = box.maxWidth > 520 ? 3 : 2;
                              final w = (box.maxWidth - (cols - 1) * 10) / cols;
                              Widget card(int i) => _SuspectCard(
                                g: g,
                                s: suspects[i],
                                selected: _culprit == suspects[i].id,
                                voters: votersFor((v) => v.culprit == suspects[i].id),
                                onTap: () {
                                  Haptics.selection();
                                  setState(() {
                                    _touched = true;
                                    _culprit = suspects[i].id;
                                  });
                                },
                              ).animate().fadeIn(delay: (70 * i).ms).slideY(begin: 0.08);
                              // Zeilenweise gleich hohe Karten, damit umbrechende Namen das Raster nicht zerreißen.
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (var r = 0; r < suspects.length; r += cols) ...[
                                    if (r > 0) const SizedBox(height: 12),
                                    IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          for (var c = 0; c < cols; c++) ...[
                                            if (c > 0) const SizedBox(width: 10),
                                            SizedBox(width: w, child: r + c < suspects.length ? card(r + c) : null),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 22),
                          SectionLabel(
                            l.accuse_why,
                            color: Noir.bloodBright,
                            trailing: _Optional(text: l.accuse_optional),
                          ),
                          _ChoiceWrap(
                            g: g,
                            options: [for (final m in s?.motives ?? const <MotiveDef>[]) (m.id, m.name.resolve())],
                            selected: _motive,
                            votes: (id) => votersFor((v) => v.motive == id),
                            onPick: (id) => setState(() {
                              _touched = true;
                              _motive = _motive == id ? null : id;
                            }),
                          ),
                          const SizedBox(height: 22),
                          SectionLabel(
                            l.accuse_how,
                            color: Noir.bloodBright,
                            trailing: _Optional(text: l.accuse_optional),
                          ),
                          _ChoiceWrap(
                            g: g,
                            options: [for (final w in s?.weapons ?? const <WeaponDef>[]) (w.id, w.name.resolve())],
                            selected: _weapon,
                            votes: (id) => votersFor((v) => v.weapon == id),
                            onPick: (id) => setState(() {
                              _touched = true;
                              _weapon = _weapon == id ? null : id;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
              decoration: const BoxDecoration(
                color: Noir.bar,
                border: Border(top: BorderSide(color: Noir.lineSoft)),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (mine != null && !changed)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Noir.buff, size: 17),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(l.accuse_submitted, style: Noir.text(12.5, color: Noir.smoke)),
                              ),
                            ],
                          ),
                        ),
                      NoirButton(
                        label: _culprit == null
                            ? l.accuse_pick_culprit
                            : (mine == null ? l.accuse_submit : l.accuse_update),
                        icon: Icons.gavel_rounded,
                        style: NoirButtonStyle.danger,
                        onPressed: _culprit == null || !changed
                            ? null
                            : () {
                                Haptics.heavy();
                                g.send(Accuse(culprit: _culprit!, motive: _motive, weapon: _weapon));
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Optional extends StatelessWidget {
  const _Optional({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: Noir.text(10.5, color: Noir.smokeDim));
}

class _SuspectCard extends StatelessWidget {
  const _SuspectCard({
    required this.g,
    required this.s,
    required this.selected,
    required this.voters,
    required this.onTap,
  });

  final GameCtx g;
  final SuspectDef s;
  final bool selected;
  final List<String> voters;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final dead = g.cv.deadNpcs.contains(s.id);
    final traits = g.traitsOf(s.id);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            // Auswahlrahmen als Vordergrund: kostet keine Textbreite (sonst fehlen dem Namen 6 px).
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: selected ? Noir.bloodBright : Colors.transparent, width: 3),
            ),
            decoration: BoxDecoration(
              color: Noir.paper,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                const BoxShadow(color: Noir.shadowStrong, blurRadius: 10, offset: Offset(0, 4)),
                if (selected) BoxShadow(color: Noir.bloodBright.withValues(alpha: 0.4), blurRadius: 18),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 1.25,
                  child: ClipRect(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Portrait(look: s.look, size: 140, accent: g.accent, dead: dead),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(9, 8, 9, 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.name.resolve(),
                        style: Noir.title(14.5, color: Noir.ink, spacing: 0.2),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(s.role.resolve(), style: Noir.text(11, color: Noir.inkSoft, height: 1.2)),
                      if (g.cv.contradicted.contains(s.id))
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.gpp_maybe, size: 13, color: Noir.bloodBright),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  l.accuse_contradicted,
                                  style: Noir.text(10.5, color: Noir.bloodBright, weight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 6),
                      if (traits == null)
                        Text(
                          l.dialogue_not_questioned,
                          style: Noir.text(10.5, color: Noir.inkSoft.withValues(alpha: 0.8)),
                        )
                      else
                        for (final (label, value) in traits)
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '$label: ',
                                  style: Noir.text(10.5, color: Noir.inkSoft, height: 1.3),
                                ),
                                TextSpan(
                                  text: value,
                                  style: Noir.text(10.5, color: Noir.ink, weight: FontWeight.w600, height: 1.3),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 22,
                        child: Row(
                          children: [
                            for (final v in voters.take(5))
                              Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: DetectiveAvatar(
                                  coat: g.coatOf(v),
                                  hat: g.hatOf(v),
                                  size: 22,
                                  ring: v == g.me ? Noir.bloodBright : null,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (dead)
            Positioned(
              top: 8,
              left: 6,
              child: Stamp(text: l.accuse_dead, fontSize: 12, angle: -0.2, color: Noir.ink),
            ),
          if (selected)
            Positioned(
              top: 6,
              right: 4,
              child: Stamp(
                text: l.ending_culprit,
                fontSize: 13,
                angle: 0.18,
              ).animate().scale(begin: const Offset(1.8, 1.8), duration: 220.ms, curve: Curves.easeIn),
            ),
        ],
      ),
    );
  }
}

class _ChoiceWrap extends StatelessWidget {
  const _ChoiceWrap({
    required this.g,
    required this.options,
    required this.selected,
    required this.votes,
    required this.onPick,
  });

  final GameCtx g;
  final List<(String, String)> options;
  final String? selected;
  final List<String> Function(String id) votes;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final (id, name) in options)
          GestureDetector(
            onTap: () {
              Haptics.selection();
              onPick(id);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.fromLTRB(12, 9, 10, 9),
              decoration: BoxDecoration(
                color: selected == id ? Noir.blood : Noir.panelStrong,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: selected == id ? Noir.bloodBright : Noir.line),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name, style: Noir.text(14, weight: FontWeight.w600)),
                  if (votes(id).isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(color: Noir.line, borderRadius: BorderRadius.circular(8)),
                      child: Text('${votes(id).length}', style: Noir.label(11, color: Noir.cream, spacing: 0)),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

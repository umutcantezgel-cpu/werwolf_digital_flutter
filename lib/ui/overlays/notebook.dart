import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../app/theme.dart';
import '../../l10n/lookup.dart';
import '../clue_text.dart';
import '../icons.dart';
import '../widgets/buttons.dart';
import '../widgets/meters.dart';
import '../widgets/noir_backdrop.dart';
import 'game_context.dart';

/// Notizbuch (eigene Hinweise) und Beweiswand (Team) als Vollbild-Blatt.
class NotebookSheet extends StatefulWidget {
  const NotebookSheet({super.key, required this.g, required this.onClose, this.initialTab = 0});

  final GameCtx g;
  final VoidCallback onClose;
  final int initialTab;

  @override
  State<NotebookSheet> createState() => _NotebookSheetState();
}

class _NotebookSheetState extends State<NotebookSheet> {
  late int _tab = widget.initialTab;
  bool _combine = false;
  String? _first;

  void _tapBoard(ClueView c) {
    if (!_combine) return;
    HapticFeedback.selectionClick();
    if (_first == null) {
      setState(() => _first = c.id);
    } else if (_first == c.id) {
      setState(() => _first = null);
    } else {
      widget.g.send(Combine(_first!, c.id));
      setState(() {
        _first = null;
        _combine = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final g = widget.g;
    final l = g.l;
    final pad = MediaQuery.paddingOf(context);
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            child: const ColoredBox(color: Noir.shadowStrong),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: pad.top + 28,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Container(
                decoration: const BoxDecoration(
                  color: Noir.leather,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                  boxShadow: [BoxShadow(color: Noir.scrim, blurRadius: 30)],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: Column(
                    children: [
                      _Header(
                        tab: _tab,
                        mine: g.cv.notebook.length,
                        board: g.cv.board.length,
                        onTab: (t) => setState(() {
                          _tab = t;
                          _combine = false;
                          _first = null;
                        }),
                        onClose: widget.onClose,
                        accent: g.accent,
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: _tab == 0
                              ? _MineTab(key: const ValueKey('mine'), g: g)
                              : _BoardTab(
                                  key: const ValueKey('board'),
                                  g: g,
                                  combine: _combine,
                                  first: _first,
                                  onTap: _tapBoard,
                                  onToggleCombine: () => setState(() {
                                    _combine = !_combine;
                                    _first = null;
                                  }),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ).animate().slideY(begin: 0.25, duration: 280.ms, curve: Curves.easeOutCubic).fadeIn(duration: 200.ms),
        if (_combine)
          Positioned(
            left: 16,
            right: 16,
            bottom: pad.bottom + 18,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Noir.blood,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [BoxShadow(color: Noir.shadowStrong, blurRadius: 12)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.hub_rounded, color: Noir.cream, size: 18),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _first == null ? l.notebook_combine_hint : l.notebook_combine_hint_second,
                        textAlign: TextAlign.center,
                        style: Noir.text(13.5, weight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn().slideY(begin: 0.4),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.tab,
    required this.mine,
    required this.board,
    required this.onTab,
    required this.onClose,
    required this.accent,
  });

  final int tab;
  final int mine;
  final int board;
  final ValueChanged<int> onTab;
  final VoidCallback onClose;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    Widget tabBtn(int i, String label, int count, IconData icon) {
      final sel = tab == i;
      return Expanded(
        child: GestureDetector(
          onTap: () => onTab(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: sel ? accent : Colors.transparent, width: 3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 17, color: sel ? Noir.cream : Noir.smokeDim),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: Noir.label(13.5, color: sel ? Noir.cream : Noir.smokeDim, spacing: 0.4),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(color: sel ? accent : Noir.line, borderRadius: BorderRadius.circular(8)),
                  child: Text('$count', style: Noir.label(11, color: sel ? Noir.night : Noir.smoke, spacing: 0)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Noir.leatherLight, Noir.leatherMid]),
        border: Border(bottom: BorderSide(color: Noir.shade)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(color: Noir.lineStrong, borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 6, 6, 0),
            child: Row(
              children: [
                const Icon(Icons.menu_book_rounded, color: Noir.brass, size: 22),
                const SizedBox(width: 10),
                Expanded(child: Text(l.notebook_title, style: Noir.title(22))),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded, color: Noir.smoke),
                ),
              ],
            ),
          ),
          Row(
            children: [
              tabBtn(0, l.notebook_mine, mine, Icons.edit_note_rounded),
              tabBtn(1, l.notebook_board, board, Icons.push_pin_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _MineTab extends StatelessWidget {
  const _MineTab({super.key, required this.g});

  final GameCtx g;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final list = g.cv.notebook;
    if (list.isEmpty) return _Empty(text: l.notebook_empty_mine, icon: Icons.search_rounded);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded, size: 16, color: Noir.warning),
            const SizedBox(width: 6),
            Expanded(
              child: Text(l.notebook_share_hint, style: Noir.text(12.5, color: Noir.warning)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < list.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _NoteCard(
              g: g,
              clue: list[i],
              onShare: () {
                HapticFeedback.mediumImpact();
                g.send(ShareClue(list[i].id));
              },
            ),
          ).animate().fadeIn(delay: (50 * i).ms).slideX(begin: 0.04),
      ],
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.g, required this.clue, required this.onShare});

  final GameCtx g;
  final ClueView clue;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final t = clueTexts(g.scenario, clue, l);
    return Container(
      decoration: BoxDecoration(
        color: Noir.paper,
        borderRadius: BorderRadius.circular(3),
        boxShadow: const [BoxShadow(color: Noir.shadowStrong, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: CustomPaint(
        painter: _RuledPainter(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(36, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _KindChip(kind: clue.kind, label: t.kindLabel),
                  const SizedBox(width: 8),
                  Expanded(
                    child: t.pending == null
                        ? const SizedBox.shrink()
                        : Align(
                            alignment: Alignment.centerRight,
                            child: _PendingChip(text: t.pending!, lab: clue.pending == 'lab'),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(t.title, style: Noir.title(18, color: Noir.ink, spacing: 0.3)),
              const SizedBox(height: 4),
              Text(t.text, style: Noir.typed(14.5, color: Noir.ink)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(l.clue_found_by(g.nameOf(clue.foundBy)), style: Noir.text(11.5, color: Noir.inkSoft)),
                  ),
                  SizedBox(
                    width: 120,
                    child: NoirButton(
                      label: l.notebook_share,
                      icon: Icons.push_pin_rounded,
                      height: 38,
                      style: NoirButtonStyle.danger,
                      onPressed: onShare,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RuledPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = Noir.ruleBlue
      ..strokeWidth = 1;
    for (var y = 34.0; y < size.height - 4; y += 21) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    canvas.drawLine(
      const Offset(24, 0),
      Offset(24, size.height),
      Paint()
        ..color = Noir.ruleRed
        ..strokeWidth = 1.2,
    );
    // Lochung
    for (var y = 22.0; y < size.height; y += 40) {
      canvas.drawCircle(Offset(11, y), 4, Paint()..color = Noir.leather);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _KindChip extends StatelessWidget {
  const _KindChip({required this.kind, required this.label});

  final String kind;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(GameIcons.clueKind(kind), size: 14, color: Noir.blood),
      const SizedBox(width: 4),
      Text(
        label.toUpperCase(),
        style: Noir.label(10, color: Noir.blood, spacing: 1.6, weight: FontWeight.w700),
      ),
    ],
  );
}

class _PendingChip extends StatelessWidget {
  const _PendingChip({required this.text, required this.lab});

  final String text;
  final bool lab;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: Noir.inkBlueWash,
      borderRadius: BorderRadius.circular(3),
      border: Border.all(color: Noir.inkBlueLine),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(lab ? Icons.science_rounded : Icons.hourglass_bottom_rounded, size: 12, color: Noir.inkBlue),
        const SizedBox(width: 4),
        Flexible(
          child: Text(text, style: Noir.label(10.5, color: Noir.inkBlue, spacing: 0.2)),
        ),
      ],
    ),
  );
}

class _BoardTab extends StatelessWidget {
  const _BoardTab({
    super.key,
    required this.g,
    required this.combine,
    required this.first,
    required this.onTap,
    required this.onToggleCombine,
  });

  final GameCtx g;
  final bool combine;
  final String? first;
  final ValueChanged<ClueView> onTap;
  final VoidCallback onToggleCombine;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final board = g.cv.board;
    final strength = g.strength;
    return Stack(
      children: [
        const Positioned.fill(child: _Cork()),
        ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 80),
          children: [
            // Beweisstärke
            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              decoration: BoxDecoration(
                color: Noir.glassStrong,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Noir.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.balance_rounded, color: Noir.brass, size: 18),
                      const SizedBox(width: 8),
                      Text(l.notebook_strength.toUpperCase(), style: Noir.label(11, color: Noir.brass, spacing: 1.8)),
                      const Spacer(),
                      Text('$strength', style: Noir.title(22, color: Noir.cream)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  StrengthMeter(
                    value: strength,
                    max: math.max(Tuning.strengthPerfect + 2, strength),
                    solid: Tuning.strengthSolid,
                    perfect: Tuning.strengthPerfect,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.notebook_strength_hint(Tuning.strengthSolid, Tuning.strengthPerfect),
                          style: Noir.text(11.5, color: Noir.smoke),
                        ),
                      ),
                      Text(l.notebook_contradictions(g.cv.contradictions), style: Noir.text(11.5, color: Noir.smoke)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (board.length >= 2)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 170,
                  child: NoirButton(
                    label: combine ? l.common_cancel : l.notebook_combine,
                    icon: combine ? Icons.close_rounded : Icons.hub_rounded,
                    height: 40,
                    style: combine ? NoirButtonStyle.secondary : NoirButtonStyle.primary,
                    accent: g.accent,
                    onPressed: onToggleCombine,
                  ),
                ),
              ),
            const SizedBox(height: 14),
            if (board.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: _Empty(text: l.notebook_empty_board, icon: Icons.push_pin_outlined, light: true),
              )
            else
              _Masonry(
                children: [
                  for (var i = 0; i < board.length; i++)
                    _PinnedCard(
                      g: g,
                      clue: board[i],
                      index: i,
                      selected: first == board[i].id,
                      selectable: combine,
                      onTap: () => onTap(board[i]),
                    ),
                ],
              ),
            if (g.cv.deductions.isNotEmpty) ...[
              const SizedBox(height: 18),
              SectionLabel(l.notebook_deductions, color: Noir.paper),
              for (final d in g.cv.deductions) _DeductionCard(g: g, comboId: d),
            ],
          ],
        ),
      ],
    );
  }
}

class _Masonry extends StatelessWidget {
  const _Masonry({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final left = <Widget>[];
    final right = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      (i.isEven ? left : right).add(Padding(padding: const EdgeInsets.only(bottom: 16), child: children[i]));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(children: left)),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 22),
            child: Column(children: right),
          ),
        ),
      ],
    );
  }
}

class _PinnedCard extends StatelessWidget {
  const _PinnedCard({
    required this.g,
    required this.clue,
    required this.index,
    required this.selected,
    required this.selectable,
    required this.onTap,
  });

  final GameCtx g;
  final ClueView clue;
  final int index;
  final bool selected;
  final bool selectable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final t = clueTexts(g.scenario, clue, l);
    final tilt = ((index * 37) % 7 - 3) * 0.008;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.04 : 1,
        duration: const Duration(milliseconds: 150),
        child: Transform.rotate(
          angle: tilt,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(11, 16, 11, 10),
                decoration: BoxDecoration(
                  color: clue.kind == 'sighting' ? Noir.paperYellow : Noir.paper,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: selected ? Noir.bloodBright : (selectable ? Noir.brassLine : Colors.transparent),
                    width: selected ? 3 : 1.5,
                  ),
                  boxShadow: const [BoxShadow(color: Noir.shadowStrong, blurRadius: 8, offset: Offset(2, 5))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _KindChip(kind: clue.kind, label: t.kindLabel),
                    const SizedBox(height: 5),
                    Text(t.title, style: Noir.title(14.5, color: Noir.ink, spacing: 0.2)),
                    const SizedBox(height: 4),
                    Text(t.text, style: Noir.typed(12.5, color: Noir.ink, height: 1.35)),
                    if (t.pending != null) ...[
                      const SizedBox(height: 6),
                      _PendingChip(text: t.pending!, lab: clue.pending == 'lab'),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      l.clue_shared_by(g.nameOf(clue.sharedBy ?? clue.foundBy)),
                      style: Noir.text(10, color: Noir.inkSoft),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -7,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        center: const Alignment(-0.4, -0.4),
                        colors: [selected ? Noir.pinLight : Noir.pin, Noir.blood],
                      ),
                      boxShadow: const [BoxShadow(color: Noir.shadowStrong, blurRadius: 3, offset: Offset(1, 2))],
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

class _DeductionCard extends StatelessWidget {
  const _DeductionCard({required this.g, required this.comboId});

  final GameCtx g;
  final String comboId;

  @override
  Widget build(BuildContext context) {
    final def = g.scenario?.comboById[comboId];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Noir.paperLight,
        borderRadius: BorderRadius.circular(2),
        border: const Border(left: BorderSide(color: Noir.blood, width: 4)),
        boxShadow: const [BoxShadow(color: Noir.shadowStrong, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.hub_rounded, size: 16, color: Noir.blood),
              const SizedBox(width: 6),
              Expanded(
                child: Text(def?.name.resolve() ?? comboId, style: Noir.title(16, color: Noir.ink, spacing: 0.3)),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(def?.text.resolve() ?? '', style: Noir.typed(13.5, color: Noir.ink)),
        ],
      ),
    );
  }
}

class _Cork extends StatelessWidget {
  const _Cork();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      gradient: RadialGradient(
        radius: 1.2,
        colors: [Noir.corkLight, Noir.corkDark, Noir.corkDeep],
        stops: [0, 0.65, 1],
      ),
    ),
    child: CustomPaint(painter: GrainPainter(opacity: 0.12, density: 0.012)),
  );
}

class _Empty extends StatelessWidget {
  const _Empty({required this.text, required this.icon, this.light = false});

  final String text;
  final IconData icon;
  final bool light;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: light ? Noir.paperFaded : Noir.smokeDim),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Noir.typed(14, color: light ? Noir.paper : Noir.smoke),
          ),
        ],
      ),
    ),
  );
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../../app/theme.dart';
import '../../l10n/lookup.dart';
import '../clue_text.dart';
import '../haptics.dart';
import '../icons.dart';
import '../widgets/buttons.dart';
import '../widgets/noir_backdrop.dart';
import '../widgets/paper.dart';
import '../widgets/portrait.dart';
import '../widgets/typewriter.dart';
import 'game_context.dart';

/// Ein Eintrag im Verhörprotokoll.
class DialogueEntry {
  DialogueEntry({this.question, this.answer, this.lie = false, this.clue, this.reaction, this.presented});

  /// Frage (Topic-ID) des Spielers.
  final String? question;

  /// Antwort-Text des Verdächtigen.
  final String? answer;
  final bool lie;

  /// Neu erhaltener Hinweis.
  final String? clue;

  /// `nervous`, `annoyed`, `neutral` bei vorgelegten Beweisen.
  final String? reaction;

  /// Name des vorgelegten Beweises.
  final String? presented;
}

/// Zustand des offenen Verhörs (wird von den Session-Ereignissen gefüttert).
class DialogueState extends ChangeNotifier {
  String? npc;
  final List<DialogueEntry> entries = [];
  String? _pendingTopic;
  String? _pendingPresent;

  /// Themen, die dieser Spieler selbst gefragt hat (pro NPC, über Verhöre hinweg).
  final Map<String, Set<String>> _askedByMe = {};

  /// Hat dieser Spieler [topic] bei [npcId] selbst gehört?
  bool askedByMe(String npcId, String topic) => _askedByMe[npcId]?.contains(topic) ?? false;

  bool get open => npc != null;

  /// Unterkante des Verhör-Kopfs (globale y-Koordinate) – Toasts beginnen darunter.
  final headerBottom = ValueNotifier<double>(0);

  @override
  void dispose() {
    headerBottom.dispose();
    super.dispose();
  }

  void openFor(String npcId, ScenarioDef? s) {
    if (npc == npcId) return;
    npc = npcId;
    entries.clear();
    final greet = s?.suspectById[npcId]?.line('greet').resolve() ?? '';
    if (greet.isNotEmpty) entries.add(DialogueEntry(answer: greet));
    notifyListeners();
  }

  /// Neuer Fall in derselben Session: eigene Befragungen vergessen.
  void resetCase() {
    _askedByMe.clear();
    close();
  }

  void close() {
    npc = null;
    entries.clear();
    notifyListeners();
  }

  void asked(String topic) {
    _pendingTopic = topic;
  }

  void presenting(String clueName) {
    _pendingPresent = clueName;
  }

  void onDialogue(GameEvent e, ScenarioDef? s) {
    final id = e.str('npc');
    if (id == null || id != npc) return;
    final topic = e.str('topic') ?? _pendingTopic;
    final line = e.str('line') ?? topic ?? 'greet';
    final text = s?.suspectById[id]?.line(line).resolve() ?? '';
    entries.add(DialogueEntry(question: topic, answer: text, lie: e.flag('lie'), clue: e.str('clue')));
    if (topic != null) (_askedByMe[id] ??= {}).add(topic);
    _pendingTopic = null;
    notifyListeners();
  }

  void onPresent(GameEvent e, ScenarioDef? s, String clueName) {
    final id = e.str('npc');
    if (id == null || id != npc) return;
    final reaction = e.str('reaction') ?? 'neutral';
    final text = reaction == 'neutral' ? null : s?.suspectById[id]?.line(reaction).resolve();
    entries.add(DialogueEntry(presented: _pendingPresent ?? clueName, answer: text, reaction: reaction));
    _pendingPresent = null;
    notifyListeners();
  }
}

/// Vollbild-Verhör: Porträt, Steckbrief, Protokoll, Themen, Beweis vorlegen.
class InterrogationOverlay extends StatefulWidget {
  const InterrogationOverlay({super.key, required this.g, required this.state, required this.onClose});

  /// Querformat/geringe Höhe: Protokoll links, Themen rechts, kompakter Kopf.
  static bool wideLayout(Size size) => size.width > size.height && size.height < 560;

  /// Breite der Themen-Spalte im Querformat.
  static const double sidePanelWidth = 340;

  /// Querformat: linker Rand der Themen-Spalte (dort, unter „Beweis vorlegen“, ist Platz für Toasts).
  static double sidePanelLeft(Size size, EdgeInsets pad) {
    final avail = size.width - pad.left - pad.right;
    final body = math.min(avail, 980.0);
    return pad.left + (avail - body) / 2 + body - sidePanelWidth;
  }

  final GameCtx g;
  final DialogueState state;
  final VoidCallback onClose;

  @override
  State<InterrogationOverlay> createState() => _InterrogationOverlayState();
}

class _InterrogationOverlayState extends State<InterrogationOverlay> {
  final _scroll = ScrollController();
  final _headerKey = GlobalKey();
  bool _picking = false;

  @override
  void initState() {
    super.initState();
    widget.state.addListener(_onEntries);
  }

  @override
  void dispose() {
    widget.state.removeListener(_onEntries);
    _scroll.dispose();
    super.dispose();
  }

  void _onEntries() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _ask(String topic) {
    final npc = widget.state.npc;
    if (npc == null) return;
    Haptics.selection();
    widget.state.asked(topic);
    widget.g.send(AskTopic(npc: npc, topic: topic));
  }

  void _present(ClueView c) {
    final npc = widget.state.npc;
    if (npc == null) return;
    Haptics.medium();
    widget.state.presenting(clueTexts(widget.g.scenario, c, widget.g.l).title);
    widget.g.send(PresentClue(npc: npc, clue: c.id));
    setState(() => _picking = false);
  }

  /// Kopfhöhe melden (Name und Bio sind unterschiedlich lang), damit Toasts ihn nicht verdecken.
  void _reportHeader() {
    if (!mounted) return;
    final box = _headerKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final bottom = box.localToGlobal(Offset(0, box.size.height)).dy;
    if ((widget.state.headerBottom.value - bottom).abs() > 0.5) widget.state.headerBottom.value = bottom;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _reportHeader());
    final g = widget.g;
    final l = g.l;
    final npcId = widget.state.npc!;
    final def = g.scenario?.suspectById[npcId];
    final heard = g.cv.heard[npcId] ?? const [];
    final topics = [
      Topic.alibi,
      Topic.victim,
      Topic.observation,
      if (detectiveClasses[g.myClass]?.rumors ?? false) Topic.rumor,
    ];
    final traits = g.traitsOf(npcId);
    final pad = MediaQuery.paddingOf(context);
    final dead = g.cv.deadNpcs.contains(npcId);
    final wide = InterrogationOverlay.wideLayout(MediaQuery.sizeOf(context));
    final name = def?.name.resolve() ?? npcId;
    // Vom Team schon gefragt, von mir aber nicht: erklären statt nur abzuhaken.
    final teamOnly = [
      for (final t in topics)
        if (heard.contains(t) && !widget.state.askedByMe(npcId, t)) t,
    ];

    final header = Padding(
      key: _headerKey,
      padding: EdgeInsets.fromLTRB(16, wide ? 6 : 8, 6, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.rotate(
            angle: -0.04,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 5, 5, wide ? 10 : 16),
              decoration: const BoxDecoration(
                color: Noir.paper,
                boxShadow: [BoxShadow(color: Noir.shadowStrong, blurRadius: 12, offset: Offset(0, 5))],
              ),
              child: def == null
                  ? SizedBox(width: wide ? 60 : 104, height: wide ? 60 : 104)
                  : Portrait(look: def.look, size: wide ? 60 : 104, accent: g.accent, dead: dead),
            ),
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
          SizedBox(width: wide ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  (def?.role.resolve() ?? '').toUpperCase(),
                  style: Noir.label(11, color: g.accent, spacing: 2, weight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(name, style: Noir.title(wide ? 20 : 24)),
                const SizedBox(height: 6),
                Text(
                  def?.bio.resolve() ?? '',
                  maxLines: wide ? 1 : null,
                  overflow: wide ? TextOverflow.ellipsis : null,
                  style: Noir.text(13, color: Noir.smoke, height: 1.35),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.close_rounded, color: Noir.smoke, size: 26),
          ),
        ],
      ),
    );

    final transcript = ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final entries = widget.state.entries;
        final note = teamOnly.isEmpty ? 0 : 1;
        return ListView.builder(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
          itemCount: entries.length + note,
          itemBuilder: (context, i) {
            if (i < note) {
              return _TeamNote(text: l.dialogue_team_note(name, teamOnly.map(l.topicShort).join(', ')));
            }
            final k = i - note;
            return _EntryView(entry: entries[k], g: g, latest: k == entries.length - 1, npcName: name);
          },
        );
      },
    );

    final topicsPanel = Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Noir.bar,
        border: wide
            ? const Border(left: BorderSide(color: Noir.lineSoft))
            : const Border(top: BorderSide(color: Noir.lineSoft)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.dialogue_topics.toUpperCase(), style: Noir.label(10.5, color: Noir.smoke, spacing: 2)),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, box) {
              final w = (box.maxWidth - 8) / 2;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final t in topics)
                    SizedBox(
                      width: w,
                      child: _TopicButton(
                        topic: t,
                        heard: heard.contains(t) && !teamOnly.contains(t),
                        teamHeard: teamOnly.contains(t),
                        accent: g.accent,
                        enabled: !dead,
                        onTap: () => _ask(t),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          NoirButton(
            label: l.dialogue_present,
            icon: Icons.content_paste_search_rounded,
            height: 46,
            style: NoirButtonStyle.danger,
            onPressed: dead ? null : () => setState(() => _picking = true),
          ),
        ],
      ),
    );

    final traitStrip = Padding(
      padding: EdgeInsets.fromLTRB(16, wide ? 8 : 14, 16, 4),
      child: _TraitStrip(traits: traits, l: l),
    );
    const divider = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Divider(height: 1, color: Noir.lineSoft),
    );

    final Widget body;
    if (wide) {
      body = ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  header,
                  traitStrip,
                  divider,
                  Expanded(child: transcript),
                ],
              ),
            ),
            SizedBox(
              width: InterrogationOverlay.sidePanelWidth,
              child: LayoutBuilder(
                builder: (context, box) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: box.maxHeight),
                    child: topicsPanel,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      body = ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: LayoutBuilder(
          builder: (context, box) {
            // Sehr niedrige Bildschirme: Kopf, Steckbrief und Themen scrollen mit,
            // statt das Protokoll auf null Höhe zu drücken.
            if (box.maxHeight < 520) {
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  header,
                  traitStrip,
                  divider,
                  SizedBox(height: 200, child: transcript),
                  topicsPanel,
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header,
                traitStrip,
                divider,
                Expanded(child: transcript),
                topicsPanel,
              ],
            );
          },
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.5, -0.85),
                  radius: 1.3,
                  colors: [Color.lerp(g.accent, Noir.night, 0.82)!, Noir.deep, Noir.deepest],
                  stops: const [0, 0.5, 1],
                ),
              ),
              child: const CustomPaint(painter: GrainPainter(opacity: 0.05)),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(top: pad.top, bottom: pad.bottom, left: pad.left, right: pad.right),
              child: Center(child: body),
            ),
          ),
          if (_picking)
            Positioned.fill(
              child: _EvidencePicker(g: g, onPick: _present, onClose: () => setState(() => _picking = false)),
            ),
        ],
      ),
    );
  }
}

/// Hinweis im Protokoll: Das Team hat schon gefragt – die Antworten hört man durch eigenes Nachfragen.
class _TeamNote extends StatelessWidget {
  const _TeamNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
        decoration: BoxDecoration(
          color: Noir.lineFaint,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Noir.lineSoft),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.groups_rounded, size: 17, color: Noir.smoke),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text, style: Noir.text(12.5, color: Noir.smoke, height: 1.35)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TraitStrip extends StatelessWidget {
  const _TraitStrip({required this.traits, required this.l});

  final List<(String, String)>? traits;
  final L l;

  @override
  Widget build(BuildContext context) {
    final t = traits;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(l.dialogue_profile.toUpperCase(), style: Noir.label(10, color: Noir.smoke, spacing: 1.8)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: t == null
              ? Text(l.dialogue_not_questioned, style: Noir.text(12.5, color: Noir.smokeDim))
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final (label, value) in t)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Noir.lineFaint,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Noir.line),
                        ),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '$label: ',
                                style: Noir.text(11.5, color: Noir.smoke),
                              ),
                              TextSpan(
                                text: value,
                                style: Noir.text(11.5, weight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _EntryView extends StatelessWidget {
  const _EntryView({required this.entry, required this.g, required this.latest, required this.npcName});

  final DialogueEntry entry;
  final GameCtx g;
  final bool latest;
  final String npcName;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final children = <Widget>[];
    final question = entry.question;
    final presented = entry.presented;
    if (question != null || presented != null) {
      children.add(
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(left: 60, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color.lerp(Noir.night3, g.accent, 0.12),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(3),
              ),
              border: Border.all(color: g.accent.withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  presented != null ? Icons.content_paste_search_rounded : GameIcons.topic(question!),
                  size: 15,
                  color: g.accent,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    presented != null ? l.dialogue_presented(presented) : l.topicQuestion(question!),
                    style: Noir.text(13.5, weight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final answer = entry.answer;
    if (answer != null && answer.isNotEmpty) {
      final style = Noir.typed(15, color: Noir.ink);
      children.add(
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: EdgeInsets.only(right: 40, bottom: entry.lie ? 22 : 6),
              child: PaperCard(
                padding: EdgeInsets.fromLTRB(14, 12, 14, entry.lie ? 22 : 12),
                child: latest ? TypewriterText('„$answer“', style: style, charMs: 18) : Text('„$answer“', style: style),
              ),
            ),
            if (entry.lie)
              Positioned(
                right: 12,
                bottom: 2,
                child: Stamp(
                  text: l.dialogue_lie,
                  fontSize: 15,
                  angle: -0.08,
                ).animate().scale(begin: const Offset(1.8, 1.8), duration: 260.ms, curve: Curves.easeIn).fadeIn(),
              ),
          ],
        ),
      );
    }
    final reaction = entry.reaction;
    if (reaction != null) {
      final (color, text) = switch (reaction) {
        'nervous' => (Noir.warning, l.dialogue_reaction_nervous),
        'annoyed' => (Noir.debuff, l.dialogue_reaction_annoyed),
        _ => (Noir.smoke, l.dialogue_reaction_neutral),
      };
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4, top: 2),
          child: Row(
            children: [
              Icon(
                reaction == 'nervous'
                    ? Icons.sentiment_dissatisfied_rounded
                    : (reaction == 'annoyed' ? Icons.mood_bad_rounded : Icons.sentiment_neutral_rounded),
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                '$npcName $text',
                style: Noir.text(12.5, color: color, weight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }
    final clue = entry.clue;
    if (clue != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              const Icon(Icons.note_add_rounded, size: 16, color: Noir.buff),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  l.dialogue_new_clue(g.clueName(clue)),
                  style: Noir.text(12.5, color: Noir.buff, weight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.1);
  }
}

class _TopicButton extends StatelessWidget {
  const _TopicButton({
    required this.topic,
    required this.heard,
    this.teamHeard = false,
    required this.accent,
    required this.enabled,
    required this.onTap,
  });

  final String topic;

  /// Selbst gehört.
  final bool heard;

  /// Nur das Team hat gefragt – die Antwort fehlt diesem Spieler noch.
  final bool teamHeard;
  final Color accent;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Material(
        color: heard ? Noir.lineFaint : Noir.night3,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: enabled ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: heard ? Noir.lineSoft : accent.withValues(alpha: 0.6)),
            ),
            child: Row(
              children: [
                Icon(GameIcons.topic(topic), size: 18, color: heard ? Noir.smokeDim : accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ein Wort pro Thema: lieber minimal verkleinern als mitten im Wort umbrechen.
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l.topicShort(topic),
                          maxLines: 1,
                          style: Noir.text(13.5, weight: FontWeight.w600, color: heard ? Noir.smoke : Noir.cream),
                        ),
                      ),
                      if (heard) Text(l.dialogue_heard, style: Noir.text(10.5, color: Noir.smokeDim, height: 1.2)),
                      if (teamHeard)
                        Text(l.dialogue_heard_team, style: Noir.text(10.5, color: Noir.smoke, height: 1.2)),
                    ],
                  ),
                ),
                if (heard) const Icon(Icons.check_rounded, size: 16, color: Noir.buff),
                if (teamHeard) const Icon(Icons.groups_rounded, size: 16, color: Noir.smoke),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EvidencePicker extends StatelessWidget {
  const _EvidencePicker({required this.g, required this.onPick, required this.onClose});

  final GameCtx g;
  final ValueChanged<ClueView> onPick;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l = g.l;
    final clues = [...g.cv.notebook, ...g.cv.board];
    return GestureDetector(
      onTap: onClose,
      child: ColoredBox(
        color: Noir.scrim,
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600, maxHeight: MediaQuery.sizeOf(context).height * 0.7),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                  decoration: BoxDecoration(
                    color: Noir.leather,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Noir.line),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(l.dialogue_present_title, style: Noir.title(18))),
                          IconButton(
                            onPressed: onClose,
                            icon: const Icon(Icons.close_rounded, color: Noir.smoke),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (clues.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            l.dialogue_present_empty,
                            textAlign: TextAlign.center,
                            style: Noir.typed(14, color: Noir.paper),
                          ),
                        )
                      else
                        Flexible(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: clues.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 8),
                            itemBuilder: (context, i) {
                              final c = clues[i];
                              final t = clueTexts(g.scenario, c, l);
                              return PaperCard(
                                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                                onTap: () => onPick(c),
                                child: Row(
                                  children: [
                                    Icon(GameIcons.clueKind(c.kind), color: Noir.blood, size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(t.title, style: Noir.title(14.5, color: Noir.ink, spacing: 0.2)),
                                          const SizedBox(height: 2),
                                          Text(
                                            t.text,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Noir.typed(12.5, color: Noir.inkSoft, height: 1.3),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (c.sharedBy != null)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: Icon(Icons.push_pin_rounded, size: 15, color: Noir.inkSoft),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 180.ms);
  }
}

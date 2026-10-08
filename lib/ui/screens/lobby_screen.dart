import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../session/game_session.dart';
import '../icons.dart';
import '../widgets/buttons.dart';
import '../widgets/noir_backdrop.dart';
import '../widgets/panels.dart';
import '../widgets/portrait.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  GameSession? _session;
  bool _left = false;

  @override
  void initState() {
    super.initState();
    final app = context.read<AppState>();
    _session = app.session;
    final s = _session;
    if (s == null) return;
    // Bevorzugte Ausrüstung setzen (nur freigeschaltete Teile).
    final meta = app.meta;
    final lo = meta.loadout;
    app.send(
      SetLoadout(
        cls: meta.classUnlocked(lo.cls) ? lo.cls : 'forensic',
        coat: meta.coatUnlocked(lo.coat) ? lo.coat : 0,
        hat: meta.hatUnlocked(lo.hat) ? lo.hat : 'fedora',
      ),
    );
    final cfg = app.pendingConfig;
    if (cfg != null) {
      app.pendingConfig = null;
      app.send(cfg);
    }
    if (!s.isOnline) app.send(const SetReady(true));
    s.caseView.addListener(_onCase);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onCase());
  }

  @override
  void dispose() {
    _session?.caseView.removeListener(_onCase);
    super.dispose();
  }

  void _onCase() {
    final cv = _session?.caseView.value;
    if (!mounted || _left || cv == null) return;
    if (cv.phase != Phase.lobby) {
      _left = true;
      context.go(Routes.game);
    }
  }

  Future<void> _leave() async {
    _left = true;
    final app = context.read<AppState>();
    final router = GoRouter.of(context);
    await app.leaveSession();
    router.go(Routes.hub);
  }

  void _setLoadout({String? cls, int? coat, String? hat}) {
    final app = context.read<AppState>();
    final me = _me(app.session?.caseView.value);
    final cur = Loadout(cls: me?.cls ?? 'forensic', coat: me?.coat ?? 0, hat: me?.hat ?? 'fedora');
    final next = Loadout(cls: cls ?? cur.cls, coat: coat ?? cur.coat, hat: hat ?? cur.hat);
    app.meta.loadout = next;
    app.send(SetLoadout(cls: next.cls, coat: next.coat, hat: next.hat));
  }

  LobbyPlayer? _me(CaseView? cv) {
    final id = _session?.playerId;
    return cv?.lobby.where((p) => p.id == id).firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    final s = _session;
    if (s == null) return const Scaffold(backgroundColor: Noir.night);
    final l = L.of(context);
    final app = context.read<AppState>();
    return ValueListenableBuilder<CaseView?>(
      valueListenable: s.caseView,
      builder: (context, cv, _) {
        final scenario = cv?.scenarioId == null ? null : s.scenarios[cv!.scenarioId];
        final accent = accentOf(scenario);
        final me = _me(cv);
        final isHost = cv != null && cv.hostId == s.playerId;
        final meta = context.watch<MetaStore>();
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _leave();
          },
          child: Scaffold(
            body: NoirBackdrop(
              accent: accent,
              rain: false,
              child: SafeArea(
                child: Column(
                  children: [
                    ContentWidth(
                      child: NoirTopBar(title: l.lobby_title, subtitle: scenario?.title.resolve(), onBack: _leave),
                    ),
                    Expanded(
                      child: cv == null
                          ? const Center(child: CircularProgressIndicator(color: Noir.brass))
                          : ListView(
                              padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
                              children: [
                                ContentWidth(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      if (s.isOnline) _RoomCode(code: cv.roomCode),
                                      if (scenario != null)
                                        _CaseBanner(scenario: scenario, mode: cv.mode, accent: accent),
                                      const SizedBox(height: 18),
                                      SectionLabel(
                                        l.lobby_players(
                                          cv.lobby.length + (cv.bots - cv.lobby.where((p) => p.bot).length).clamp(0, 6),
                                        ),
                                      ),
                                      for (final p in cv.lobby)
                                        _PlayerRow(
                                          player: p,
                                          me: p.id == s.playerId,
                                          host: p.id == cv.hostId,
                                        ).animate().fadeIn(duration: 300.ms),
                                      for (var i = cv.lobby.where((p) => p.bot).length; i < cv.bots; i++)
                                        _BotSlot(index: i + 1),
                                      const SizedBox(height: 18),
                                      SectionLabel(l.lobby_loadout),
                                      _ClassPicker(
                                        selected: me?.cls ?? 'forensic',
                                        rank: meta.rank,
                                        accent: accent,
                                        onPick: (c) => _setLoadout(cls: c),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        l.lobby_coat.toUpperCase(),
                                        style: Noir.label(11, color: Noir.smoke, spacing: 1.8),
                                      ),
                                      const SizedBox(height: 8),
                                      _CoatPicker(
                                        selected: me?.coat ?? 0,
                                        rank: meta.rank,
                                        onPick: (c) => _setLoadout(coat: c),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        l.lobby_hat.toUpperCase(),
                                        style: Noir.label(11, color: Noir.smoke, spacing: 1.8),
                                      ),
                                      const SizedBox(height: 8),
                                      _HatPicker(
                                        selected: me?.hat ?? 'fedora',
                                        coat: me?.coat ?? 0,
                                        rank: meta.rank,
                                        accent: accent,
                                        onPick: (h) => _setLoadout(hat: h),
                                      ),
                                      if (isHost) ...[
                                        const SizedBox(height: 20),
                                        SectionLabel(l.lobby_case),
                                        _HostConfig(
                                          cv: cv,
                                          scenarios: s.scenarios,
                                          online: s.isOnline,
                                          accent: accent,
                                          onConfigure: app.send,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                    if (cv != null)
                      _BottomBar(
                        isHost: isHost,
                        online: s.isOnline,
                        ready: me?.ready ?? false,
                        accent: accent,
                        canStart: cv.scenarioId != null,
                        onReady: (v) => app.send(SetReady(v)),
                        onStart: () => app.send(const StartGame()),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoomCode extends StatelessWidget {
  const _RoomCode({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlassPanel(
        onTap: () {
          Clipboard.setData(ClipboardData(text: code));
          showNoirSnack(context, l.lobby_copied, icon: Icons.copy_rounded);
        },
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.lobby_room_code.toUpperCase(), style: Noir.label(11, color: Noir.smoke, spacing: 2)),
                const SizedBox(height: 4),
                Text(code, style: Noir.title(40, color: Noir.brassLight, spacing: 12)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.copy_rounded, color: Noir.smoke),
          ],
        ),
      ),
    );
  }
}

class _CaseBanner extends StatelessWidget {
  const _CaseBanner({required this.scenario, required this.mode, required this.accent});

  final ScenarioDef scenario;
  final String mode;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final bg = Color(scenario.theme.color('background'));
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(colors: [Color.lerp(bg, accent, 0.22)!, bg]),
        border: Border.all(color: accent.withValues(alpha: 0.6)),
        boxShadow: const [BoxShadow(color: Color(0x88000000), blurRadius: 14, offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(scenario.title.resolve(), style: Noir.title(22)),
                const SizedBox(height: 3),
                Text(scenario.tagline.resolve(), style: Noir.text(13, color: Noir.smoke, height: 1.3)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          TagChip(l.modeName(mode), color: accent, filled: true),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({required this.player, required this.me, required this.host});

  final LobbyPlayer player;
  final bool me;
  final bool host;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: me ? const Color(0x22C9A227) : const Color(0x99151829),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: me ? Noir.brass.withValues(alpha: 0.5) : const Color(0x22E8E0D0)),
      ),
      child: Row(
        children: [
          DetectiveAvatar(coat: player.coat, hat: player.hat, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        player.name,
                        style: Noir.text(15.5, weight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (me) ...[
                      const SizedBox(width: 6),
                      Text('(${l.common_you})', style: Noir.text(13, color: Noir.smoke)),
                    ],
                    if (host) ...[
                      const SizedBox(width: 6),
                      Tooltip(
                        message: l.lobby_host,
                        child: const Icon(Icons.star_rounded, size: 16, color: Noir.brass),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(GameIcons.cls(player.cls), size: 14, color: Noir.smoke),
                    const SizedBox(width: 4),
                    Text(l.className(player.cls), style: Noir.text(12.5, color: Noir.smoke)),
                    if (player.bot) ...[const SizedBox(width: 8), TagChip(l.lobby_bot, color: const Color(0xFF6FA8DC))],
                  ],
                ),
              ],
            ),
          ),
          if (!player.connected)
            TagChip(l.lobby_offline, color: Noir.debuff)
          else
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: player.ready || player.bot
                  ? Row(
                      key: const ValueKey(1),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Noir.buff, size: 18),
                        const SizedBox(width: 4),
                        Text(l.lobby_ready, style: Noir.label(12, color: Noir.buff, spacing: 0.3)),
                      ],
                    )
                  : Text(
                      l.lobby_waiting,
                      key: const ValueKey(0),
                      style: Noir.label(12, color: Noir.smokeDim, spacing: 0.3),
                    ),
            ),
        ],
      ),
    );
  }
}

/// Platzhalter für einen KI-Partner, der beim Start dazukommt.
class _BotSlot extends StatelessWidget {
  const _BotSlot({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0x22E8E0D0)),
        color: const Color(0x44151829),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x446FA8DC), width: 1.5),
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Color(0xAA6FA8DC), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(l.lobby_bot_slot(index), style: Noir.text(14.5, color: Noir.smoke)),
          ),
          TagChip(l.lobby_bot, color: const Color(0xFF6FA8DC)),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms).slideX(begin: 0.05);
  }
}

class _ClassPicker extends StatelessWidget {
  const _ClassPicker({required this.selected, required this.rank, required this.accent, required this.onPick});

  final String selected;
  final int rank;
  final Color accent;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final classes = detectiveClasses.values.toList();
    return SizedBox(
      height: 196,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: classes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final c = classes[i];
          final locked = rank < c.unlockRank;
          final sel = c.id == selected;
          return GestureDetector(
            onTap: locked ? null : () => onPick(c.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 178,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sel ? Color.lerp(Noir.night3, accent, 0.16) : const Color(0xCC151829),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: sel ? accent : const Color(0x26E8E0D0), width: sel ? 2 : 1),
                boxShadow: sel ? [BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 14)] : null,
              ),
              child: Opacity(
                opacity: locked ? 0.42 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: sel ? accent : const Color(0x22E8E0D0),
                          ),
                          child: Icon(GameIcons.cls(c.id), size: 19, color: sel ? Noir.night : Noir.cream),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(l.className(c.id), style: Noir.title(15.5), maxLines: 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(l.lobby_ability.toUpperCase(), style: Noir.label(9.5, color: accent, spacing: 1.5)),
                    const SizedBox(height: 2),
                    Text(
                      l.classAbility(c.id),
                      style: Noir.text(11.5, height: 1.3),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(l.lobby_passive.toUpperCase(), style: Noir.label(9.5, color: Noir.smoke, spacing: 1.5)),
                    const SizedBox(height: 2),
                    if (locked)
                      Row(
                        children: [
                          const Icon(Icons.lock_rounded, size: 13, color: Noir.brass),
                          const SizedBox(width: 4),
                          Text(
                            l.common_unlock_at(l.rankName(c.unlockRank)),
                            style: Noir.label(11.5, color: Noir.brass, spacing: 0.2),
                          ),
                        ],
                      )
                    else
                      Text(
                        l.classPassive(c.id),
                        style: Noir.text(11.5, color: Noir.smoke, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CoatPicker extends StatelessWidget {
  const _CoatPicker({required this.selected, required this.rank, required this.onPick});

  final int selected;
  final int rank;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (var i = 0; i < detectiveCoats.length; i++)
          Tooltip(
            message: rank < coatRank(i) ? l.common_unlock_at(l.rankName(coatRank(i))) : l.coat_name(i + 1),
            child: GestureDetector(
              onTap: rank < coatRank(i) ? null : () => onPick(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: coatColor(i),
                  border: Border.all(
                    color: i == selected ? Noir.cream : const Color(0x44000000),
                    width: i == selected ? 3 : 1,
                  ),
                  boxShadow: i == selected
                      ? [BoxShadow(color: coatColor(i).withValues(alpha: 0.6), blurRadius: 10)]
                      : null,
                ),
                child: rank < coatRank(i)
                    ? const Icon(Icons.lock_rounded, size: 16, color: Color(0xCCFFFFFF))
                    : (i == selected ? const Icon(Icons.check_rounded, size: 18, color: Colors.white) : null),
              ),
            ),
          ),
      ],
    );
  }
}

class _HatPicker extends StatelessWidget {
  const _HatPicker({
    required this.selected,
    required this.coat,
    required this.rank,
    required this.accent,
    required this.onPick,
  });

  final String selected;
  final int coat;
  final int rank;
  final Color accent;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: detectiveHats.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final h = detectiveHats[i];
          final locked = rank < hatRank(h);
          final sel = h == selected;
          return GestureDetector(
            onTap: locked ? null : () => onPick(h),
            child: Column(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Noir.night3,
                    border: Border.all(color: sel ? accent : const Color(0x26E8E0D0), width: sel ? 2 : 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Opacity(
                          opacity: locked ? 0.35 : 1,
                          child: Portrait(
                            look: LookDef(coat: detectiveCoats[coat], hat: h),
                            size: 62,
                            accent: accent,
                          ),
                        ),
                        if (locked) const Center(child: Icon(Icons.lock_rounded, color: Noir.brass, size: 20)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  locked ? l.common_unlock_at(l.rankName(hatRank(h))) : l.hatName(h),
                  style: Noir.label(10, color: sel ? Noir.cream : Noir.smoke, spacing: 0.1, weight: FontWeight.w500),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HostConfig extends StatelessWidget {
  const _HostConfig({
    required this.cv,
    required this.scenarios,
    required this.online,
    required this.accent,
    required this.onConfigure,
  });

  final CaseView cv;
  final Map<String, ScenarioDef> scenarios;
  final bool online;
  final Color accent;
  final void Function(Command) onConfigure;

  void _send({String? scenarioId, String? mode, int? bots}) {
    final sid = scenarioId ?? cv.scenarioId ?? (scenarios.keys.toList()..sort()).first;
    onConfigure(
      ConfigureGame(
        scenarioId: sid,
        mode: mode ?? cv.mode,
        seed: mode == null || mode == cv.mode ? cv.seed : null,
        bots: bots ?? cv.bots,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final ids = scenarios.keys.toList()..sort();
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (online) ...[
            Text(l.lobby_scenario.toUpperCase(), style: Noir.label(10.5, color: Noir.smoke, spacing: 1.6)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: cv.scenarioId,
              isExpanded: true,
              dropdownColor: Noir.night3,
              style: Noir.text(14.5),
              items: [for (final id in ids) DropdownMenuItem(value: id, child: Text(scenarios[id]!.title.resolve()))],
              onChanged: (v) => v == null ? null : _send(scenarioId: v),
            ),
            const SizedBox(height: 14),
            Text(l.lobby_mode.toUpperCase(), style: Noir.label(10.5, color: Noir.smoke, spacing: 1.6)),
            const SizedBox(height: 6),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'story', label: Text(l.mode_story)),
                ButtonSegment(value: 'random', label: Text(l.mode_random)),
              ],
              selected: {cv.mode == 'story' ? 'story' : 'random'},
              showSelectedIcon: false,
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: accent,
                selectedForegroundColor: Noir.night,
                foregroundColor: Noir.cream,
                side: const BorderSide(color: Noir.line),
              ),
              onSelectionChanged: (s) => _send(mode: s.first),
            ),
            const SizedBox(height: 14),
          ],
          Row(
            children: [
              const Icon(Icons.smart_toy_rounded, color: Noir.smoke, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(l.lobby_bots, style: Noir.text(15, weight: FontWeight.w600)),
              ),
              _StepButton(
                icon: Icons.remove_rounded,
                onTap: cv.bots > 0 ? () => _send(bots: cv.bots - 1) : null,
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${cv.bots}',
                  textAlign: TextAlign.center,
                  style: Noir.title(22, color: Noir.brassLight),
                ),
              ),
              _StepButton(
                icon: Icons.add_rounded,
                onTap: cv.bots < 5 ? () => _send(bots: cv.bots + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => RoundIconButton(icon: icon, onPressed: onTap, size: 36);
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.isHost,
    required this.online,
    required this.ready,
    required this.accent,
    required this.canStart,
    required this.onReady,
    required this.onStart,
  });

  final bool isHost;
  final bool online;
  final bool ready;
  final Color accent;
  final bool canStart;
  final ValueChanged<bool> onReady;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      decoration: const BoxDecoration(
        color: Color(0xF00B0D18),
        border: Border(top: BorderSide(color: Color(0x22E8E0D0))),
      ),
      child: ContentWidth(
        child: Row(
          children: [
            if (online) ...[
              Expanded(
                child: NoirButton(
                  label: ready ? l.lobby_unready : l.lobby_set_ready,
                  icon: ready ? Icons.close_rounded : Icons.check_rounded,
                  style: NoirButtonStyle.secondary,
                  onPressed: () => onReady(!ready),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: isHost
                  ? NoirButton(
                      label: l.lobby_start,
                      icon: Icons.play_arrow_rounded,
                      accent: accent,
                      onPressed: canStart ? onStart : null,
                    )
                  : Center(
                      child: Text(l.lobby_wait_host, style: Noir.text(13.5, color: Noir.smoke)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

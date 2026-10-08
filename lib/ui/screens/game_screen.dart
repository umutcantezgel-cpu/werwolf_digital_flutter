import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mordakte_core/mordakte_core.dart';
import 'package:provider/provider.dart';

import '../../app/app_state.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../game/game_view.dart';
import '../../l10n/lookup.dart';
import '../../session/game_session.dart';
import '../haptics.dart';
import '../overlays/accusation.dart';
import '../overlays/council.dart';
import '../overlays/ending.dart';
import '../overlays/event_feed.dart';
import '../overlays/game_context.dart';
import '../overlays/hud.dart';
import '../overlays/interrogation.dart';
import '../overlays/intro.dart';
import '../overlays/minimap.dart';
import '../overlays/notebook.dart';
import '../overlays/signal_wheel.dart';
import '../overlays/status_overlays.dart';
import '../overlays/toasts.dart';
import '../widgets/buttons.dart';
import '../widgets/paper.dart';

/// Spiel: Szene (GameView) + phasenabhängige Overlays.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameSession? _session;
  late final AppState _app;
  final _sceneKey = GlobalKey();
  final _toasts = ToastController();
  final _dialogue = DialogueState();
  final _heart = ValueNotifier<int>(0);
  final _flash = ValueNotifier<int>(0);
  final _life = ValueNotifier<LifeState>(LifeState.alive);
  StreamSubscription<GameEvent>? _sub;

  bool _notebook = false;
  int _notebookTab = 0;
  bool _signals = false;
  bool _mapSmall = false;
  bool _mapBig = false;
  final Set<String> _seen = {};
  String? _nightText;
  Timer? _nightTimer;
  Timer? _autoClose;
  Phase? _lastPhase;
  int _lastHeartHaptic = 0;
  bool _left = false;

  @override
  void initState() {
    super.initState();
    _app = context.read<AppState>();
    final s = _session = _app.session;
    if (s == null) return;
    _sub = s.events.listen(_onEvent);
    s.caseView.addListener(_onCase);
    s.world.addListener(_onWorld);
    _lastPhase = s.caseView.value?.phase;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onWorld();
      if (_lastPhase == Phase.night) _showNight();
      _applyDev();
    });
  }

  void _applyDev() {
    final s = _session;
    final open = _app.dev.open;
    if (s == null || open == null || !mounted) return;
    switch (open.split(':').first) {
      case 'notebook':
        _openNotebook(0);
      case 'board':
        _openNotebook(1);
      case 'signals':
        setState(() => _signals = true);
      case 'map':
        setState(() => _mapBig = true);
      case 'dialog':
        final parts = open.split(':');
        final npc = parts.length > 1 ? parts[1] : s.scenario?.suspects.first.id;
        if (npc == null) return;
        _dialogue.openFor(npc, s.scenario);
        setState(() {});
        Future.delayed(const Duration(milliseconds: 300), () => _ask(npc, Topic.alibi));
        Future.delayed(const Duration(milliseconds: 900), () => _ask(npc, Topic.observation));
    }
  }

  void _ask(String npc, String topic) {
    _dialogue.asked(topic);
    _app.send(AskTopic(npc: npc, topic: topic));
  }

  @override
  void dispose() {
    _sub?.cancel();
    _session?.caseView.removeListener(_onCase);
    _session?.world.removeListener(_onWorld);
    _nightTimer?.cancel();
    _autoClose?.cancel();
    _toasts.dispose();
    _dialogue.dispose();
    _heart.dispose();
    _flash.dispose();
    _life.dispose();
    super.dispose();
  }

  GameCtx? _ctx() {
    final s = _session;
    final cv = s?.caseView.value;
    if (s == null || cv == null || !mounted) return null;
    return GameCtx(app: _app, session: s, cv: cv, l: L.of(context));
  }

  void _onWorld() {
    final s = _session;
    if (s == null) return;
    final dev = _app.dev.life;
    final life = switch (dev) {
      'downed' => LifeState.downed,
      'ghost' => LifeState.ghost,
      _ => s.world.value?.detective(s.playerId)?.life ?? LifeState.alive,
    };
    if (_life.value != life) {
      _life.value = life;
      // Niedergeschlagen/Geist: Verhör schließen, sonst verdeckt es Hilfe-Knopf und Countdown.
      if (life != LifeState.alive && _dialogue.open && mounted) {
        setState(() {
          _dialogue.close();
          _signals = false;
        });
      }
    }
  }

  void _onCase() {
    final s = _session;
    final cv = s?.caseView.value;
    if (cv == null || !mounted) return;
    if (cv.phase != _lastPhase) {
      final prev = _lastPhase;
      _lastPhase = cv.phase;
      if (cv.phase == Phase.night) _showNight();
      if (cv.phase != Phase.investigation && cv.phase != Phase.night) {
        if (_dialogue.open) _dialogue.close();
      }
      if (cv.phase == Phase.lobby && prev != null && !_left) {
        _left = true;
        context.go(Routes.lobby);
        return;
      }
      if (prev == Phase.ending) {
        // Neuer Fall im selben Raum: Merker des alten Falls verwerfen.
        _seen.clear();
        _flash.value = 0;
        _dialogue.resetCase();
      }
      final world = cv.phase == Phase.investigation || cv.phase == Phase.night || cv.phase == Phase.council;
      // Vollbild-Abschnitte (Intro, Anklage, Ende) starten ohne Meldungen der vorigen Phase.
      if (!world) _toasts.clear();
      if (prev != null && cv.phase != Phase.ending) {
        Haptics.medium();
        final g = _ctx();
        // Anklage/Intro zeigen ihren Titel selbst – der Phasen-Toast würde ihn nur verdecken.
        if (g != null && world) {
          _toasts.show(g.l.toast_phase(g.l.phaseName(cv.phase), cv.chapter), icon: Icons.flag_rounded, color: g.accent);
        }
      }
      setState(() {
        _signals = false;
        _mapBig = false;
        if (cv.phase == Phase.ending || cv.phase == Phase.intro) _notebook = false;
      });
    }
  }

  void _showNight() {
    final g = _ctx();
    if (g == null) return;
    final s = g.scenario;
    final ch = s == null ? null : s.chapters[(g.cv.chapter - 1).clamp(0, s.chapters.length - 1)];
    _nightTimer?.cancel();
    setState(() => _nightText = ch?.night.resolve() ?? '');
    _nightTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) setState(() => _nightText = null);
    });
  }

  /// Autoplay (Vorführung): Verhör nach kurzer Ruhe wieder schließen, damit die Szene sichtbar bleibt.
  void _armAutoClose() {
    if (!_app.autoplay) return;
    _autoClose?.cancel();
    _autoClose = Timer(const Duration(seconds: 6), () {
      if (mounted && _dialogue.open) setState(_dialogue.close);
    });
  }

  void _onEvent(GameEvent e) {
    final g = _ctx();
    if (g == null) return;
    if (e.type == Ev.dialogueOpen || e.type == Ev.dialogue || e.type == Ev.present) _armAutoClose();
    switch (e.type) {
      case Ev.dialogueOpen:
        final npc = e.str('npc');
        if (npc == null) return;
        Haptics.selection();
        _dialogue.openFor(npc, g.scenario);
        setState(() {
          _notebook = false;
          _signals = false;
          _mapBig = false;
        });
      case Ev.dialogue:
        _dialogue.onDialogue(e, g.scenario);
      case Ev.present:
        _dialogue.onPresent(e, g.scenario, g.clueName(e.str('clue')));
        if (e.str('reaction') == 'nervous') Haptics.medium();
      case Ev.shadowNear:
        final now = DateTime.now().millisecondsSinceEpoch;
        _heart.value = now;
        if (now - _lastHeartHaptic > 1400) {
          _lastHeartHaptic = now;
          Haptics.heavy();
        }
      case Ev.phase:
      case Ev.ending:
        break;
      default:
        if (e.type == Ev.attacked && e.str('player') == g.me) {
          _flash.value = DateTime.now().millisecondsSinceEpoch;
        }
        showEventToast(e, g, _toasts);
    }
  }

  void _openNotebook(int tab) {
    final cv = _session?.caseView.value;
    setState(() {
      _notebook = true;
      _notebookTab = tab;
      _signals = false;
      _mapBig = false;
      if (cv != null) {
        _seen.addAll(cv.notebook.map((c) => c.id));
        _seen.addAll(cv.board.map((c) => c.id));
      }
    });
  }

  int _badge(CaseView cv) =>
      cv.notebook.where((c) => !_seen.contains(c.id)).length + cv.board.where((c) => !_seen.contains(c.id)).length;

  Future<void> _leave({String to = Routes.hub}) async {
    _left = true;
    final router = GoRouter.of(context);
    await _app.leaveSession();
    router.go(to);
  }

  /// Online-Gastgeber: neuen Fall im selben Raum starten (alle Mitspieler bleiben dabei).
  Future<void> _rematch(GameCtx g) async {
    final l = g.l;
    final list = g.session.scenarios.values.toList()..sort((a, b) => a.id.compareTo(b.id));
    final id = await showDialog<String>(
      context: context,
      barrierColor: Noir.scrim,
      builder: (c) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: PaperCard(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.ending_rematch_title, style: Noir.title(21, color: Noir.ink)),
                const SizedBox(height: 6),
                Text(l.ending_rematch_text, style: Noir.typed(13.5, color: Noir.inkSoft)),
                const SizedBox(height: 14),
                for (final sc in list) ...[
                  NoirButton(
                    label: sc.title.resolve(),
                    icon: Icons.folder_open_rounded,
                    height: 48,
                    style: sc.id == g.cv.scenarioId ? NoirButtonStyle.secondary : NoirButtonStyle.primary,
                    onPressed: () => Navigator.of(c).pop(sc.id),
                  ),
                  const SizedBox(height: 8),
                ],
                NoirButton(
                  label: l.common_cancel,
                  style: NoirButtonStyle.ghost,
                  height: 44,
                  onPressed: () => Navigator.of(c).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (id == null || !mounted) return;
    final cv = g.session.caseView.value ?? g.cv;
    if (cv.phase != Phase.ending) return;
    // Tagesfall nicht wiederholen: ein neuer Fall im Raum ist ein Zufallsfall bzw. die Story.
    final mode = cv.mode == 'daily' ? 'random' : cv.mode;
    _app.send(ConfigureGame(scenarioId: id, mode: mode, bots: cv.bots));
    _app.send(const StartGame());
  }

  Future<void> _menu() async {
    final l = L.of(context);
    final ok = await showDialog<bool>(
      context: context,
      barrierColor: Noir.scrim,
      builder: (c) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: PaperCard(
            clip: true,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.hud_leave_title, style: Noir.title(22, color: Noir.ink)),
                const SizedBox(height: 8),
                Text(l.hud_leave_text, style: Noir.typed(14, color: Noir.inkSoft)),
                const SizedBox(height: 20),
                NoirButton(
                  label: l.hud_leave_confirm,
                  icon: Icons.logout_rounded,
                  style: NoirButtonStyle.danger,
                  onPressed: () => Navigator.of(c).pop(true),
                ),
                const SizedBox(height: 8),
                NoirButton(
                  label: l.common_cancel,
                  style: NoirButtonStyle.ghost,
                  height: 44,
                  onPressed: () => Navigator.of(c).pop(false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (ok == true && mounted) await _leave();
  }

  @override
  Widget build(BuildContext context) {
    final s = _session;
    if (s == null) return const Scaffold(backgroundColor: Noir.night);
    final scene = GameView(key: _sceneKey, session: s);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _menu();
      },
      child: Scaffold(
        backgroundColor: Noir.night,
        resizeToAvoidBottomInset: false,
        body: ValueListenableBuilder<CaseView?>(
          valueListenable: s.caseView,
          builder: (context, cv, _) {
            if (cv == null) {
              return const Center(child: CircularProgressIndicator(color: Noir.brass));
            }
            final g = GameCtx(app: _app, session: s, cv: cv, l: L.of(context));
            final phase = cv.phase;
            final inWorld = phase == Phase.investigation || phase == Phase.night || phase == Phase.council;
            return Stack(
              fit: StackFit.expand,
              children: [
                // Szene (Geister sehen entsättigt)
                ValueListenableBuilder<LifeState>(
                  valueListenable: _life,
                  builder: (context, life, _) => life == LifeState.ghost
                      ? ColorFiltered(colorFilter: const ColorFilter.matrix(ghostMatrix), child: scene)
                      : scene,
                ),
                if (phase == Phase.night) const NightVignette(key: ValueKey('night')),
                HeartbeatVignette(key: const ValueKey('heartbeat'), trigger: _heart),
                FlashOverlay(key: const ValueKey('flash'), trigger: _flash),
                if (inWorld) ..._worldOverlays(g),
                if (phase == Phase.intro) IntroOverlay(g: g),
                if (phase == Phase.accusation) AccusationOverlay(g: g, onNotebook: () => _openNotebook(1)),
                if (phase == Phase.ending && cv.ending != null)
                  Consumer<AppState>(
                    builder: (context, app, _) => EndingOverlay(
                      g: g,
                      ending: cv.ending!,
                      result: app.lastResult,
                      // Online führt „Neuer Fall“ nicht in die Solo-Akten, sondern bleibt im Raum.
                      onNewCase: s.isOnline ? null : () => _leave(to: Routes.cases),
                      onRematch: s.isOnline && cv.hostId == s.playerId ? () => _rematch(g) : null,
                      onHub: () => _leave(),
                    ),
                  ),
                if (_dialogue.open && inWorld)
                  InterrogationOverlay(g: g, state: _dialogue, onClose: () => setState(_dialogue.close)),
                if (_notebook)
                  NotebookSheet(
                    key: ValueKey('nb$_notebookTab'),
                    g: g,
                    initialTab: _notebookTab,
                    onClose: () => setState(() => _notebook = false),
                  ),
                if (_signals && inWorld)
                  SignalWheel(
                    accent: g.accent,
                    onClose: () => setState(() => _signals = false),
                    onSignal: (kind, value) {
                      g.send(Signal(kind: kind, value: value));
                      setState(() => _signals = false);
                    },
                  ),
                if (_mapBig && inWorld) _bigMap(g),
                _toastLayer(phase, inWorld),
                ValueListenableBuilder<bool>(
                  valueListenable: s.connected,
                  builder: (context, ok, _) => ok
                      ? const SizedBox.shrink()
                      : Positioned(
                          top: MediaQuery.paddingOf(context).top,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Noir.blood,
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Noir.cream),
                                ),
                                const SizedBox(width: 10),
                                Text(g.l.hud_disconnected, style: Noir.text(12.5)),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Toasts nie über die Kopfzeilen der Vollbild-Overlays legen und auf engen Bildschirmen
  /// (Querformat) weniger gleichzeitig zeigen, damit Nachtbanner und Beratung lesbar bleiben.
  Widget _toastLayer(Phase phase, bool inWorld) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 560;
    final overlayMax = compact ? 1 : 2;
    if (phase == Phase.ending) return ToastLayer(controller: _toasts, bottom: 16, right: 12);
    if (_notebook) {
      return ToastLayer(controller: _toasts, top: NotebookSheet.headerExtent, right: 12, maxVisible: overlayMax);
    }
    if (phase == Phase.accusation) {
      return ToastLayer(controller: _toasts, top: AccusationOverlay.headerExtent, right: 12, maxVisible: overlayMax);
    }
    if (!inWorld) return ToastLayer(controller: _toasts, top: 4, right: 12);
    if (_dialogue.open) {
      if (InterrogationOverlay.wideLayout(size)) {
        // Querformat: unten in der Themen-Spalte, fern von Kopf und Protokoll.
        return ToastLayer(
          controller: _toasts,
          bottom: 12,
          left: InterrogationOverlay.sidePanelLeft(size, MediaQuery.paddingOf(context)) + 8,
          right: 8,
          maxVisible: 1,
        );
      }
      final padTop = MediaQuery.paddingOf(context).top;
      return ValueListenableBuilder<double>(
        valueListenable: _dialogue.headerBottom,
        builder: (context, bottom, _) => ToastLayer(
          controller: _toasts,
          // Bis der Kopf gemessen ist: unter Porträt (104) samt Rahmen.
          top: bottom > padTop ? bottom - padTop + 6 : 146,
          right: 12,
          maxVisible: overlayMax,
        ),
      );
    }
    final banner = phase == Phase.night && _nightText != null;
    return ToastLayer(
      controller: _toasts,
      top: compact ? 88 : 112,
      right: compact ? 12 : 64,
      maxVisible: compact ? 1 : (banner || phase == Phase.council ? 2 : 3),
    );
  }

  List<Widget> _worldOverlays(GameCtx g) {
    final phase = g.cv.phase;
    return [
      ValueListenableBuilder<LifeState>(
        key: const ValueKey('hud'),
        valueListenable: _life,
        builder: (context, life, _) => GameHud(
          g: g,
          notebookBadge: _badge(g.cv),
          onNotebook: () => _openNotebook(0),
          onSignals: () => setState(() {
            _signals = true;
            _mapBig = false;
          }),
          onMenu: _menu,
          onEffect: (id) {
            final buff = effectCatalog[id]?.buff ?? true;
            _toasts.show(
              g.l.toast_effect_on(g.l.effectName(id), g.l.effectDesc(id)),
              icon: Icons.info_outline_rounded,
              color: buff ? Noir.buff : Noir.debuff,
              ms: 4200,
            );
          },
          mapOpen: _mapSmall,
          onMap: () => setState(() => _mapSmall = !_mapSmall),
          onMapExpand: () => setState(() => _mapBig = true),
          showBottom: phase != Phase.council && life == LifeState.alive,
        ),
      ),
      if (phase == Phase.council) CouncilPanel(key: const ValueKey('council'), g: g),
      if (phase == Phase.night && _nightText != null)
        ValueListenableBuilder<LifeState>(
          key: const ValueKey('nightBanner'),
          valueListenable: _life,
          builder: (context, life, _) => life == LifeState.alive
              ? NightBanner(title: g.l.night_title, text: _nightText!, hint: g.l.night_hint)
              : const SizedBox.shrink(),
        ),
      ValueListenableBuilder<LifeState>(
        key: const ValueKey('lifeState'),
        valueListenable: _life,
        builder: (context, life, _) {
          if (life == LifeState.ghost) {
            // In der Beratung würde das Banner die Spurkarten samt Abstimmknopf verdecken.
            if (phase == Phase.council) return const SizedBox.shrink();
            return Stack(children: [GhostBanner(g: g)]);
          }
          if (life != LifeState.downed) return const SizedBox.shrink();
          return ValueListenableBuilder<WorldSnapshot?>(
            valueListenable: g.session.world,
            builder: (context, w, _) {
              final left = w?.detective(g.me)?.downedLeftMs ?? 0;
              return DownedOverlay(g: g, leftMs: left > 0 ? left : (_app.dev.life == 'downed' ? 9400 : 0));
            },
          );
        },
      ),
    ];
  }

  Widget _bigMap(GameCtx g) {
    final l = g.l;
    final size = MediaQuery.sizeOf(context);
    final width = (size.width - 48).clamp(200.0, 560.0);
    return GestureDetector(
      onTap: () => setState(() => _mapBig = false),
      child: ColoredBox(
        color: Noir.scrim,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.hud_map, style: Noir.title(22)),
              const SizedBox(height: 6),
              Text(
                g.cv.pingsLeft > 0 ? l.hud_map_ping(g.cv.pingsLeft) : l.hud_map_no_ping,
                style: Noir.text(12.5, color: Noir.smoke),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {},
                child: MiniMap(g: g, width: width, interactive: true, onPinged: () => setState(() => _mapBig = false)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

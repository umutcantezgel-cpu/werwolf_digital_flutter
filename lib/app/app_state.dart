import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:mordakte_core/mordakte_core.dart';

import '../meta/meta_store.dart';
import '../meta/progression.dart';
import '../session/fake_session.dart';
import '../session/game_session.dart';
import '../session/session_factory.dart';

/// Einstellungen aus dem Entwickler-Einstieg (`?fake=…&open=…`).
class DevOptions {
  /// `notebook`, `board`, `dialog`, `signals`, `map`
  final String? open;

  /// `downed`, `ghost`
  final String? life;

  const DevOptions({this.open, this.life});
}

/// App-weiter Zustand: geladene Szenarien, aktuelle Session, Meta-Fortschritt.
class AppState extends ChangeNotifier {
  AppState({required this.meta, required this.scenarios});

  final MetaStore meta;
  final Map<String, ScenarioDef> scenarios;

  GameSession? _session;
  GameSession? get session => _session;

  /// Wird beim Betreten der Lobby gesendet (Solo: sofort konfigurieren).
  ConfigureGame? pendingConfig;

  DevOptions dev = const DevOptions();

  /// Ergebnis des zuletzt verbuchten Spiels (End-Bildschirm).
  GameResult? lastResult;

  GameTally _tally = GameTally();
  bool _recorded = false;
  StreamSubscription<GameEvent>? _eventSub;

  List<ScenarioDef> get sortedScenarios => scenarios.values.toList()..sort((a, b) => a.id.compareTo(b.id));

  DailyCase get daily => DailyCase.forDate(DateTime.now(), scenarios.keys);

  String get playerName => meta.hasName ? meta.name! : 'Detektiv';

  /// Szenarien der aktuellen Session (fällt auf die geladenen zurück).
  Map<String, ScenarioDef> get sessionScenarios => _session?.scenarios ?? scenarios;

  // --- Sessions ------------------------------------------------------------------

  /// Solo-Fall starten → Lobby.
  Future<void> startSolo(ScenarioDef scenario, String mode, {int bots = 3}) async {
    await leaveSession();
    final seed = switch (mode) {
      'random' => math.Random().nextInt(0x7FFFFFFF),
      'daily' => daily.seed,
      _ => null,
    };
    final s = await SessionFactory.solo(scenarios: scenarios, playerName: playerName);
    pendingConfig = ConfigureGame(scenarioId: scenario.id, mode: mode, seed: seed, bots: bots);
    _attach(s);
    if (s is FakeSession) s.debugSetPhase(Phase.lobby);
    notifyListeners();
  }

  /// Entwickler-Einstieg `?autoplay=<id>`: echtes Solo-Spiel, KI steuert den eigenen
  /// Detektiv, 2 KI-Partner, Story-Modus – startet sofort.
  Future<bool> startAutoplay(String scenarioId) async {
    final scenario = scenarios[scenarioId] ?? sortedScenarios.firstOrNull;
    if (scenario == null) return false;
    await leaveSession();
    final s = await SessionFactory.solo(scenarios: scenarios, playerName: playerName, autoplay: true);
    pendingConfig = null;
    _attach(s);
    final lo = meta.loadout;
    s.send(SetLoadout(cls: lo.cls, coat: lo.coat, hat: lo.hat));
    s.send(ConfigureGame(scenarioId: scenario.id, mode: 'story', bots: 2));
    s.send(const StartGame());
    notifyListeners();
    return true;
  }

  /// Online: [roomCode] == null → neuen Raum erstellen. Wirft bei Fehlern.
  Future<void> startOnline({String? roomCode}) async {
    await leaveSession();
    final s = await SessionFactory.online(
      scenarios: scenarios,
      playerName: playerName,
      roomCode: roomCode,
      serverUrl: meta.serverUrl ?? defaultServerUrl,
    );
    pendingConfig = null;
    _attach(s);
    notifyListeners();
  }

  /// Entwickler-Einstieg: Fake-Session in einer bestimmten Phase.
  void openFake(Phase phase, {DevOptions dev = const DevOptions()}) {
    final s = SessionFactory.fake();
    this.dev = dev;
    _attach(s);
    if (s is FakeSession) s.debugSetPhase(phase, chapter: phase == Phase.accusation || phase == Phase.ending ? 3 : 1);
    notifyListeners();
  }

  void _attach(GameSession s) {
    _session = s;
    lastResult = null;
    _recorded = false;
    _tally = GameTally();
    _eventSub = s.events.listen(_onEvent);
    s.caseView.addListener(_onCase);
    _onCase();
  }

  /// Befehl an die Session (zentraler Weg für die UI).
  void send(Command c) {
    final s = _session;
    if (s == null) return;
    s.send(c);
    // Platzhalter-Session ohne Engine: Phasen weiterschalten, damit der Ablauf klickbar ist.
    if (s is FakeSession) {
      final phase = s.caseView.value?.phase;
      if (c is StartGame && phase == Phase.lobby) {
        s.debugSetPhase(Phase.intro, chapter: 1);
      } else if (c is SetReady && c.ready && phase == Phase.intro) {
        s.debugSetPhase(Phase.investigation);
      }
    }
  }

  Future<void> leaveSession() async {
    final s = _session;
    if (s == null) return;
    _session = null;
    pendingConfig = null;
    dev = const DevOptions();
    s.caseView.removeListener(_onCase);
    await _eventSub?.cancel();
    _eventSub = null;
    notifyListeners();
    await s.dispose();
  }

  // --- Ergebnis verbuchen ----------------------------------------------------------

  void _onEvent(GameEvent e) {
    final me = _session?.playerId;
    switch (e.type) {
      case Ev.combo when e.str('by') == me:
        _tally.combos++;
      case Ev.revived when e.str('by') == me:
        _tally.revives++;
      case Ev.clueFound:
        final world = _session?.world.value;
        if (me != null && world?.detective(me)?.life == LifeState.ghost) _tally.ghostHelped = true;
    }
  }

  void _onCase() {
    final s = _session;
    final cv = s?.caseView.value;
    if (s == null || cv == null || _recorded) return;
    final ending = cv.ending;
    if (ending == null) return;
    _recorded = true;
    lastResult = meta.record(
      ending: ending,
      scenarioId: cv.scenarioId ?? 'unknown',
      mode: cv.mode,
      playerId: s.playerId,
      online: s.isOnline,
      scenarioCount: scenarios.length,
      tally: _tally,
    );
    notifyListeners();
  }
}

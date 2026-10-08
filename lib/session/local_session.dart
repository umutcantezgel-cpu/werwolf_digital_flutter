import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mordakte_core/mordakte_core.dart';

import 'game_session.dart';

/// Offline-Session: Die komplette RoomRuntime läuft im App-Prozess.
/// Solo (optional mit KI-Partnern) ohne Netz, gleiche Regeln wie online.
class LocalSession implements GameSession {
  LocalSession({
    required this.scenarios,
    required String playerName,
    bool autoplay = false,
    this.timeScale = 1,
  }) {
    _rt = RoomRuntime(roomCode: roomCode, scenarios: scenarios);
    _rt.join(playerId, playerName);
    if (autoplay) _rt.setAutopilot(playerId, true);
    _clock.start();
    _timer = Timer.periodic(const Duration(milliseconds: Tuning.tickMs), (_) => _tick());
    _publish(force: true);
  }

  @override
  final Map<String, ScenarioDef> scenarios;

  /// Zeitraffer für Demo/Screenshots (`?speed=`), 1 = Echtzeit.
  final double timeScale;

  late final RoomRuntime _rt;
  late final Timer _timer;
  final _clock = Stopwatch();
  int _last = 0;
  int _seq = 0;
  bool _disposed = false;

  final _world = ValueNotifier<WorldSnapshot?>(null);
  final _case = ValueNotifier<CaseView?>(null);
  final _events = StreamController<GameEvent>.broadcast();
  final _connected = ValueNotifier<bool>(true);

  @override
  String get playerId => 'me';

  @override
  String get roomCode => 'SOLO';

  @override
  bool get isOnline => false;

  @override
  ValueListenable<WorldSnapshot?> get world => _world;

  @override
  ValueListenable<CaseView?> get caseView => _case;

  @override
  Stream<GameEvent> get events => _events.stream;

  @override
  ValueListenable<bool> get connected => _connected;

  @override
  ScenarioDef? get scenario {
    final id = _case.value?.scenarioId;
    return id == null ? null : scenarios[id];
  }

  /// KI übernimmt den eigenen Detektiv (Demo/Screenshots).
  void setAutoplay(bool on) => _rt.setAutopilot(playerId, on);

  void _tick() {
    if (_disposed) return;
    final now = _clock.elapsedMilliseconds;
    var dt = ((now - _last) * timeScale).round();
    _last = now;
    while (dt > 0) {
      final step = dt > 100 ? 100 : dt;
      _rt.tick(step);
      dt -= step;
    }
    _publish();
  }

  void _publish({bool force = false}) {
    _world.value = _rt.worldFor(playerId);
    final c = _rt.caseFor(playerId, force: force);
    if (c != null) _case.value = c;
    for (final e in _rt.drainEvents(playerId)) {
      _events.add(e);
    }
  }

  @override
  void move(double x, double y, double facing) {
    if (_disposed) return;
    _rt.applyMove(playerId, MoveInput(x: x, y: y, facing: facing, seq: ++_seq));
  }

  @override
  void send(Command command) {
    if (_disposed) return;
    _rt.applyCommand(playerId, command);
    _publish();
  }

  @override
  Future<void> dispose() async {
    _disposed = true;
    _timer.cancel();
    await _events.close();
  }
}

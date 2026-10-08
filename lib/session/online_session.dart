import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:mordakte_core/mordakte_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'game_session.dart';

/// Fehler beim Aufbau einer [OnlineSession]. Die App übersetzt `error_<key>`.
///
/// Schlüssel: die des Servers ([NetError] sowie `server_error`, `server_full`)
/// und lokal [timeout] bzw. [unreachable].
class OnlineSessionException implements Exception {
  const OnlineSessionException(this.key);

  final String key;

  /// Kein `room` innerhalb von [OnlineSession.connectTimeout].
  static const timeout = 'timeout';

  /// Server nicht erreichbar oder Verbindung beim Aufbau abgerissen.
  static const unreachable = 'unreachable';

  @override
  String toString() => 'OnlineSessionException($key)';
}

/// Online-Raum über WebSocket (Mobile und Web). Protokoll: `protocol/messages.dart`.
///
/// - Reconnect automatisch mit Backoff (0,5 s → 5 s, unbegrenzt) und gespeichertem
///   Token; der Server bringt den Spieler selbst in den Raum zurück.
/// - Ist der Raum endgültig weg (z. B. Server neu gestartet), kommt ein
///   [GameEvent] vom Typ [Ev.error] mit `key` (z. B. `room_not_found`) und
///   [lostReason] wird gesetzt; danach wird nicht mehr neu verbunden.
class OnlineSession implements GameSession {
  OnlineSession._(this._url, this._playerName, this.scenarios, this._token);

  /// shared_preferences-Schlüssel für das Wiederverbindungs-Token.
  static const tokenKey = 'mordakte_token';

  static const connectTimeout = Duration(seconds: 8);
  static const _pingEvery = Duration(seconds: 10);
  static const _staleAfter = Duration(seconds: 25);
  static const _rejoinAfter = Duration(seconds: 3);
  static const _moveInterval = Duration(milliseconds: 67); // ≤ 15 Nachrichten/s
  static const _backoffMinMs = 500;
  static const _backoffMaxMs = 5000;
  static const _maxQueuedCommands = 32;

  /// Im `w`-Umschlag steht `WorldSnapshot.t` unter diesem Schlüssel,
  /// weil `t` der Nachrichtentyp ist (siehe `server/lib/wire.dart`).
  static const _worldTimeKey = 'wt';

  /// Close-Code des Servers: Eine andere Verbindung mit demselben Token hat übernommen.
  static const _closeReplaced = 4000;

  /// Verbindet, meldet sich an (`hello`) und erstellt ([roomCode] == null) bzw.
  /// betritt einen Raum. Wirft [OnlineSessionException].
  static Future<OnlineSession> connect({
    required String url,
    required String playerName,
    required Map<String, ScenarioDef> scenarios,
    String? roomCode,
  }) async {
    final Uri uri;
    try {
      uri = Uri.parse(url);
    } on FormatException {
      throw const OnlineSessionException(OnlineSessionException.unreachable);
    }
    final session = OnlineSession._(uri, playerName, scenarios, await _loadToken());
    try {
      await session._start(roomCode).timeout(
            connectTimeout,
            onTimeout: () => throw const OnlineSessionException(OnlineSessionException.timeout),
          );
    } catch (e) {
      await session._shutdown(sendLeave: false);
      if (e is OnlineSessionException) rethrow;
      throw const OnlineSessionException(OnlineSessionException.unreachable);
    }
    return session;
  }

  final Uri _url;
  final String _playerName;
  String? _token;

  @override
  final Map<String, ScenarioDef> scenarios;

  String _playerId = '';
  String _roomCode = '';

  final _world = ValueNotifier<WorldSnapshot?>(null);
  final _case = ValueNotifier<CaseView?>(null);
  final _connected = ValueNotifier<bool>(false);
  final _events = StreamController<GameEvent>.broadcast();

  final Stopwatch _clock = Stopwatch()..start();

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;

  /// Zählt Sockets hoch; Rückmeldungen alter Sockets werden ignoriert.
  int _generation = 0;
  Duration _lastInbound = Duration.zero;

  /// Gesetzt, solange der erste Aufbau (bis `room`) läuft.
  Completer<void>? _pending;
  String? _joinCode;

  bool _disposed = false;
  String? _lostReason;
  bool _rejoining = false;

  Timer? _reconnectTimer;
  int _attempt = 0;
  Timer? _rejoinTimer;
  Timer? _pingTimer;
  int _pingN = 0;

  // Bewegung (gedrosselt)
  Timer? _moveTimer;
  Duration _lastMoveSent = -_moveInterval;
  bool _moveWanted = false;
  double _wantX = 0, _wantY = 0, _wantF = 0;
  double? _sentX, _sentY, _sentF;
  int _seq = 0;

  final List<Command> _queued = [];

  // ---------------------------------------------------------------------------
  // GameSession

  @override
  String get playerId => _playerId;

  @override
  String get roomCode => _roomCode;

  @override
  bool get isOnline => true;

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

  /// Gesetzt, wenn der Raum endgültig verloren ist (Fehler-Schlüssel).
  String? get lostReason => _lostReason;

  @override
  void move(double x, double y, double facing) {
    if (_disposed) return;
    _wantX = x;
    _wantY = y;
    _wantF = facing;
    _moveWanted = true;
    _scheduleMove();
  }

  @override
  void send(Command command) {
    if (_disposed || _lostReason != null) return;
    if (_connected.value && _channel != null) {
      _sendNow({'t': Msg.cmd, 'c': command.toJson()});
    } else if (_queued.length < _maxQueuedCommands) {
      // Kurz offline: nach dem Reconnect nachsenden.
      _queued.add(command);
    }
  }

  @override
  Future<void> dispose() => _shutdown(sendLeave: true);

  // ---------------------------------------------------------------------------
  // Verbindung

  Future<void> _start(String? roomCode) async {
    final code = roomCode?.replaceAll(RegExp(r'\s'), '').toUpperCase();
    _joinCode = (code == null || code.isEmpty) ? null : code;
    final pending = _pending = Completer<void>();
    // Fehler können eintreffen, bevor unten `await` läuft.
    unawaited(pending.future.then((_) {}, onError: (Object _) {}));
    await _open();
    await pending.future;
    _pending = null;
    _pingTimer = Timer.periodic(_pingEvery, (_) => _onPingTimer());
  }

  Future<void> _open() async {
    final gen = ++_generation;
    _dropChannel();
    final ch = WebSocketChannel.connect(_url);
    _channel = ch;
    try {
      await ch.ready;
    } catch (_) {
      if (gen == _generation) _channel = null;
      rethrow;
    }
    if (gen != _generation || _disposed) {
      unawaited(ch.sink.close().catchError((Object _) {}));
      return;
    }
    _lastInbound = _clock.elapsed;
    _sub = ch.stream.listen(
      (data) => _onMessage(gen, data),
      onDone: () => _onClosed(gen, ch.closeCode),
      onError: (Object _) {},
    );
    _sendNow({
      't': Msg.hello,
      'name': _playerName,
      if (_token != null) 'token': _token,
      'proto': protocolVersion,
    });
  }

  void _dropChannel() {
    final sub = _sub;
    final ch = _channel;
    _sub = null;
    _channel = null;
    if (sub != null) unawaited(sub.cancel());
    if (ch != null) unawaited(ch.sink.close().catchError((Object _) {}));
  }

  void _onClosed(int gen, int? closeCode) {
    if (gen != _generation || _disposed) return;
    _sub = null;
    _channel = null;
    _connected.value = false;
    final pending = _pending;
    if (pending != null) {
      if (!pending.isCompleted) {
        pending.completeError(const OnlineSessionException(OnlineSessionException.unreachable));
      }
      return;
    }
    if (closeCode == _closeReplaced) {
      _lose('replaced');
      return;
    }
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed || _lostReason != null || _reconnectTimer != null) return;
    final delay = math.min(_backoffMaxMs, _backoffMinMs << math.min(_attempt, 8));
    _attempt++;
    _reconnectTimer = Timer(Duration(milliseconds: delay), () async {
      _reconnectTimer = null;
      if (_disposed || _lostReason != null) return;
      try {
        await _open();
      } catch (_) {
        _scheduleReconnect();
      }
    });
  }

  void _forceReconnect() {
    _generation++;
    _dropChannel();
    _connected.value = false;
    _scheduleReconnect();
  }

  void _onPingTimer() {
    if (_disposed || _lostReason != null || _channel == null) return;
    if (_clock.elapsed - _lastInbound > _staleAfter) {
      // Halb-offene Verbindung (Mobilfunk): neu aufbauen.
      _forceReconnect();
      return;
    }
    _sendNow({'t': Msg.ping, 'n': ++_pingN});
  }

  void _sendNow(Map<String, Object?> msg) {
    final ch = _channel;
    if (ch == null) return;
    try {
      ch.sink.add(jsonEncode(msg));
    } catch (_) {
      // Socket schon zu – onDone kümmert sich.
    }
  }

  Future<void> _shutdown({required bool sendLeave}) async {
    if (_disposed) return;
    if (sendLeave && _lostReason == null) _sendNow({'t': Msg.leave});
    _disposed = true;
    _generation++;
    for (final t in [_reconnectTimer, _rejoinTimer, _pingTimer, _moveTimer]) {
      t?.cancel();
    }
    final ch = _channel;
    final sub = _sub;
    _channel = null;
    _sub = null;
    if (ch != null) {
      try {
        await ch.sink.close(1000).timeout(const Duration(seconds: 2));
      } catch (_) {}
    }
    await sub?.cancel();
    _connected.value = false;
    await _events.close();
  }

  // ---------------------------------------------------------------------------
  // Nachrichten

  void _onMessage(int gen, dynamic data) {
    if (gen != _generation || _disposed) return;
    _lastInbound = _clock.elapsed;
    Map<String, dynamic>? msg;
    try {
      msg = (jsonDecode(data as String) as Map).cast<String, dynamic>();
      _handle(msg);
    } catch (e, st) {
      debugPrint('OnlineSession: Nachricht "${msg?['t']}" nicht lesbar: $e\n$st');
    }
  }

  void _handle(Map<String, dynamic> msg) {
    switch (msg['t']) {
      case Msg.world:
        _world.value = WorldSnapshot.fromJson({...msg, 't': msg[_worldTimeKey] ?? 0});
        _completeIfReady();
      case Msg.caseView:
        _case.value = CaseView.fromJson(msg);
        _completeIfReady();
      case Msg.events:
        for (final raw in msg['list'] as List) {
          final e = GameEvent.fromJson((raw as Map).cast<String, dynamic>());
          if ((e.to == null || e.to == _playerId) && !_events.isClosed) _events.add(e);
        }
      case Msg.welcome:
        _onWelcome(msg['player'] as String, msg['token'] as String);
      case Msg.room:
        _onRoom(msg['code'] as String);
      case Msg.error:
        _onError(msg['key'] as String? ?? 'unknown');
      case Msg.pong:
        break;
    }
  }

  void _onWelcome(String id, String token) {
    final previous = _playerId;
    _playerId = id;
    if (token != _token) {
      _token = token;
      unawaited(_saveToken(token));
    }
    if (_pending != null) {
      final code = _joinCode;
      _sendNow(code == null ? {'t': Msg.create} : {'t': Msg.join, 'code': code});
      return;
    }
    if (previous == id) {
      // Normalfall: Der Server schickt gleich `room`. Kommt nichts (Gnadenfrist
      // abgelaufen), selbst wieder beitreten.
      _rejoinTimer?.cancel();
      _rejoinTimer = Timer(_rejoinAfter, _rejoin);
    } else {
      // Server kennt das Token nicht mehr (z. B. Neustart): als neuer Spieler beitreten.
      _rejoin();
    }
  }

  void _rejoin() {
    _rejoinTimer?.cancel();
    _rejoinTimer = null;
    if (_disposed || _lostReason != null || _roomCode.isEmpty) return;
    _rejoining = true;
    _sendNow({'t': Msg.join, 'code': _roomCode});
  }

  void _onRoom(String code) {
    _rejoinTimer?.cancel();
    _rejoinTimer = null;
    _rejoining = false;
    _roomCode = code;
    _attempt = 0;
    _connected.value = true;
    _completeIfReady();
    if (_queued.isNotEmpty) {
      final queued = List.of(_queued);
      _queued.clear();
      queued.forEach(send);
    }
    _scheduleMove();
  }

  /// Erster Aufbau fertig, sobald `room` und die erste Ansicht (`c`/`w`) da
  /// sind – die Lobby hat dann sofort Daten. Der Server schickt `c` direkt nach `room`.
  void _completeIfReady() {
    final pending = _pending;
    if (pending == null || pending.isCompleted || _roomCode.isEmpty) return;
    if (_case.value != null || _world.value != null) pending.complete();
  }

  void _onError(String key) {
    final pending = _pending;
    if (pending != null) {
      if (!pending.isCompleted) pending.completeError(OnlineSessionException(key));
      return;
    }
    const roomGone = {NetError.roomNotFound, NetError.roomFull, NetError.gameRunning, NetError.notInRoom};
    if (_rejoining && roomGone.contains(key)) {
      _lose(key);
    } else if (key == NetError.notInRoom) {
      // Server hat uns aus dem Raum genommen: einmal versuchen, wieder beizutreten.
      _connected.value = false;
      _rejoin();
    } else {
      debugPrint('OnlineSession: Server-Fehler $key');
    }
  }

  void _lose(String key) {
    if (_lostReason != null) return;
    _lostReason = key;
    _connected.value = false;
    _rejoinTimer?.cancel();
    _reconnectTimer?.cancel();
    _queued.clear();
    _generation++;
    _dropChannel();
    if (!_events.isClosed) _events.add(GameEvent(Ev.error, to: _playerId, args: {'key': key}));
  }

  // ---------------------------------------------------------------------------
  // Bewegung

  void _scheduleMove() {
    if (_moveTimer != null || !_moveWanted || _disposed) return;
    final wait = _moveInterval - (_clock.elapsed - _lastMoveSent);
    if (wait <= Duration.zero) {
      _flushMove();
    } else {
      _moveTimer = Timer(wait, _flushMove);
    }
  }

  void _flushMove() {
    _moveTimer = null;
    // Offline: Wunschposition behalten und nach dem Reconnect senden.
    if (!_moveWanted || !_connected.value || _channel == null) return;
    _moveWanted = false;
    if (_wantX == _sentX && _wantY == _sentY && _wantF == _sentF) return;
    _sentX = _wantX;
    _sentY = _wantY;
    _sentF = _wantF;
    _lastMoveSent = _clock.elapsed;
    _sendNow({'t': Msg.move, ...MoveInput(x: _wantX, y: _wantY, facing: _wantF, seq: ++_seq).toJson()});
  }

  // ---------------------------------------------------------------------------
  // Token

  static Future<String?> _loadToken() async {
    try {
      return (await SharedPreferences.getInstance()).getString(tokenKey);
    } catch (_) {
      return null;
    }
  }

  static Future<void> _saveToken(String token) async {
    try {
      await (await SharedPreferences.getInstance()).setString(tokenKey, token);
    } catch (_) {}
  }
}

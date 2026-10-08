/// Räume, Spieler und die Raum-Schleife (Tick + Snapshots).
library;

import 'dart:async';
import 'dart:math';

import 'package:mordakte_core/mordakte_core.dart';

import 'codes.dart';
import 'runtime.dart';
import 'wire.dart';

typedef Logger = void Function(String message);

void defaultLog(String message) => print('${DateTime.now().toUtc().toIso8601String()} $message');

/// Eine Client-Verbindung aus Sicht der Räume (siehe `Connection`).
abstract interface class ClientLink {
  /// Kurzbeschreibung für Logs (z. B. `#3 1.2.3.4`).
  String get label;

  void send(String text);

  void close(int code, String reason);
}

/// Ein Spieler über Verbindungen hinweg (Token → gleiche ID).
class Player {
  Player._(this.id, this.token, this.name);

  final String id;
  final String token;
  String name;

  /// Aktive Verbindung, `null` = getrennt.
  ClientLink? link;

  /// Raum, in dem der Spieler gerade ist.
  Room? room;

  /// Seit wann getrennt (Manager-Uhr, ms).
  int? offlineSinceMs;
  Timer? _graceTimer;

  bool get online => link != null;
}

/// Ein Raum mit eigener Runtime und eigenem Takt.
class Room {
  Room._(this._manager, this.code, this.runtime);

  final RoomManager _manager;
  final String code;
  final GameRuntime runtime;
  final Set<Player> members = {};

  final Stopwatch _clock = Stopwatch();
  Timer? _loop;
  int _lastMs = 0;
  int _sinceSnapshot = 0;

  int? _emptySinceMs;
  int? _finishedAtMs;

  int? _lastErrorLogMs;
  int _suppressedErrors = 0;

  /// Größter Zeitschritt pro Tick (z. B. nach einem Hänger des Prozesses).
  static const maxStepMs = 1000;

  bool get running => _loop != null;

  void _start() {
    _clock.start();
    _loop = Timer.periodic(Duration(milliseconds: _manager.tickMs), (_) => _step());
  }

  void _stop() {
    _loop?.cancel();
    _loop = null;
    _clock.stop();
  }

  void _step() {
    final now = _clock.elapsedMilliseconds;
    var dt = now - _lastMs;
    if (dt <= 0) return;
    _lastMs = now;
    if (dt > maxStepMs) dt = maxStepMs;
    guard('tick', () => runtime.tick(dt));
    _sinceSnapshot += dt;
    if (_sinceSnapshot >= _manager.snapshotMs) {
      _sinceSnapshot -= _manager.snapshotMs;
      if (_sinceSnapshot >= _manager.snapshotMs) _sinceSnapshot = 0;
      _broadcast();
    }
  }

  /// Pro Spieler: `w`, `c` (falls geändert), `ev` (falls vorhanden).
  void _broadcast() {
    for (final p in members.toList()) {
      final link = p.link;
      if (link == null) {
        // Getrennte Spieler bekommen beim Reconnect den vollen Fall-Zustand;
        // alte Toasts/Ereignisse werden verworfen.
        guard('drainEvents', () => runtime.drainEvents(p.id));
        continue;
      }
      try {
        link.send(encodeWorld(runtime.worldFor(p.id)));
        final view = runtime.caseFor(p.id);
        if (view != null) link.send(encodeCase(view));
        final events = [
          for (final e in runtime.drainEvents(p.id))
            if (e.to == null || e.to == p.id) e,
        ];
        if (events.isNotEmpty) link.send(encodeEvents(events));
      } catch (e, st) {
        _logError('snapshot ${p.id}', e, st);
      }
    }
  }

  void _sendRoomAndCase(Player p) {
    final link = p.link;
    if (link == null) return;
    link.send(encodeMsg({'t': Msg.room, 'code': code}));
    final view = guard('caseFor', () => runtime.caseFor(p.id, force: true));
    if (view != null) link.send(encodeCase(view));
  }

  /// Führt [body] aus; Ausnahmen der Runtime werden geloggt (gedrosselt), nie weitergereicht.
  T? guard<T>(String what, T Function() body) {
    try {
      return body();
    } catch (e, st) {
      _logError(what, e, st);
      return null;
    }
  }

  void _logError(String what, Object error, StackTrace st) {
    final now = _manager._clock.elapsedMilliseconds;
    final last = _lastErrorLogMs;
    if (last != null && now - last < 10000) {
      _suppressedErrors++;
      return;
    }
    final extra = _suppressedErrors > 0 ? ' (+$_suppressedErrors weitere seit der letzten Meldung)' : '';
    _suppressedErrors = 0;
    _lastErrorLogMs = now;
    final trace = st.toString().split('\n').take(6).join('\n    ');
    _manager.log('[$code] Fehler in $what: $error$extra\n    $trace');
  }
}

/// Verwaltet alle Räume und Spieler eines Server-Prozesses.
class RoomManager {
  RoomManager({
    required this.runtimeFactory,
    Random? random,
    this.tickMs = Tuning.tickMs,
    this.snapshotMs = Tuning.snapshotMs,
    this.reconnectGrace = const Duration(seconds: 120),
    this.emptyRoomTtl = const Duration(minutes: 5),
    this.finishedRoomTtl = const Duration(minutes: 10),
    this.forgetPlayerAfter = const Duration(minutes: 30),
    Duration janitorInterval = const Duration(seconds: 5),
    this.maxRooms = 2000,
    Logger? log,
  })  : _rng = random ?? Random.secure(),
        log = log ?? defaultLog {
    _clock.start();
    _janitor = Timer.periodic(janitorInterval, (_) => _sweep());
  }

  final RuntimeFactory runtimeFactory;
  final int tickMs;
  final int snapshotMs;

  /// So lange darf ein getrennter Spieler zurückkommen, bevor er den Raum verlässt.
  final Duration reconnectGrace;

  /// Raum ohne verbundene Spieler wird nach dieser Zeit geschlossen.
  final Duration emptyRoomTtl;

  /// Beendete Partie: Raum wird nach dieser Zeit geschlossen.
  final Duration finishedRoomTtl;

  /// Getrennte Spieler ohne Raum: Token verfällt nach dieser Zeit.
  final Duration forgetPlayerAfter;

  final int maxRooms;
  final Logger log;

  final Random _rng;
  final Stopwatch _clock = Stopwatch();
  late final Timer _janitor;

  final Map<String, Room> _rooms = {};
  final Map<String, Player> _byToken = {};
  final Map<String, Player> _byId = {};

  int get roomCount => _rooms.length;

  int get onlineCount => _byId.values.where((p) => p.online).length;

  Room? room(String code) => _rooms[code];

  Player? player(String id) => _byId[id];

  // ---------------------------------------------------------------------------
  // API für Verbindungen

  /// `hello`: neuer Spieler oder Reconnect per Token. Antwortet mit `welcome`
  /// und bringt einen zurückkehrenden Spieler sofort wieder in seinen Raum.
  Player hello(ClientLink link, {String? token, required String name}) {
    var p = token == null ? null : _byToken[token];
    if (p == null) {
      p = Player._(_newPlayerId(), newToken(_rng), name);
      _byToken[p.token] = p;
      _byId[p.id] = p;
      log('${link.label}: hello → ${p.id} "$name" (neu)');
    } else {
      p.name = name;
      p._graceTimer?.cancel();
      p._graceTimer = null;
      final old = p.link;
      if (old != null && !identical(old, link)) {
        p.link = null;
        old.close(closeReplaced, 'replaced');
        log('${old.label}: ersetzt durch ${link.label} (${p.id})');
      }
      log('${link.label}: hello → ${p.id} "$name" (Reconnect${p.room != null ? ', Raum ${p.room!.code}' : ''})');
    }
    p.link = link;
    p.offlineSinceMs = null;
    link.send(encodeMsg({'t': Msg.welcome, 'player': p.id, 'token': p.token}));

    final room = p.room;
    if (room != null) {
      final r = p;
      room.guard('setConnected', () => room.runtime.setConnected(r.id, true));
      room._emptySinceMs = null;
      room._sendRoomAndCase(p);
    }
    return p;
  }

  /// `create`: neuer Raum, Spieler tritt bei, Antwort `room`.
  void create(Player p) {
    if (_rooms.length >= maxRooms) {
      _reply(p, encodeError(ServerError.full));
      return;
    }
    final code = _newRoomCode();
    if (code == null) {
      _reply(p, encodeError(ServerError.full));
      return;
    }
    final GameRuntime runtime;
    try {
      runtime = runtimeFactory(code);
    } catch (e, st) {
      log('Runtime für $code konnte nicht erzeugt werden: $e\n$st');
      _reply(p, encodeError(ServerError.internal));
      return;
    }
    _leaveRoom(p, reason: 'create');
    final room = Room._(this, code, runtime);
    _rooms[code] = room;
    room._start();
    final ok = room.guard('join', () => runtime.join(p.id, p.name));
    if (ok != true) {
      _closeRoom(room, 'Beitritt des Erstellers fehlgeschlagen');
      _reply(p, encodeError(ok == null ? ServerError.internal : NetError.gameRunning));
      return;
    }
    log('Raum $code erstellt von ${p.id} (${_rooms.length} Räume)');
    _enter(room, p);
  }

  /// `join`: Antwort `room` oder `err`.
  void join(Player p, Object? rawCode) {
    final code = normalizeRoomCode(rawCode);
    final room = code == null ? null : _rooms[code];
    if (room == null) {
      _reply(p, encodeError(NetError.roomNotFound));
      return;
    }
    if (identical(p.room, room)) {
      // Schon drin (z. B. doppelter Beitritt nach Reconnect): nur bestätigen.
      room.guard('setConnected', () => room.runtime.setConnected(p.id, true));
      room._sendRoomAndCase(p);
      return;
    }
    final known = room.guard('humanPlayers', () => room.runtime.humanPlayers) ?? const <String>[];
    final occupied = {...known, for (final m in room.members) m.id};
    if (!occupied.contains(p.id) && occupied.length >= maxPlayersPerRoom) {
      _reply(p, encodeError(NetError.roomFull));
      return;
    }
    _leaveRoom(p, reason: 'join ${room.code}');
    final ok = room.guard('join', () => room.runtime.join(p.id, p.name));
    if (ok == null) {
      _reply(p, encodeError(ServerError.internal));
    } else if (!ok) {
      _reply(p, encodeError(NetError.gameRunning));
    } else {
      log('${p.id} tritt ${room.code} bei (${room.members.length + 1} Spieler)');
      _enter(room, p);
    }
  }

  /// `leave`: Raum verlassen (Runtime entscheidet: Lobby → weg, im Spiel → getrennt).
  void leave(Player p) => _leaveRoom(p, reason: 'leave');

  void command(Player p, Command command) {
    final room = p.room;
    if (room == null) {
      _reply(p, encodeError(NetError.notInRoom));
      return;
    }
    room.guard('applyCommand(${command.type})', () => room.runtime.applyCommand(p.id, command));
  }

  void move(Player p, MoveInput move) {
    final room = p.room;
    if (room == null) return;
    room.guard('applyMove', () => room.runtime.applyMove(p.id, move));
  }

  /// Verbindung [link] von [p] ist weg. Ignoriert veraltete Verbindungen.
  void disconnected(Player p, ClientLink link) {
    if (!identical(p.link, link)) return;
    p.link = null;
    p.offlineSinceMs = _clock.elapsedMilliseconds;
    final room = p.room;
    if (room != null) {
      room.guard('setConnected', () => room.runtime.setConnected(p.id, false));
      log('${link.label}: ${p.id} getrennt (Raum ${room.code}, ${_seconds(reconnectGrace)} s Gnadenfrist)');
    }
    p._graceTimer?.cancel();
    p._graceTimer = Timer(reconnectGrace, () {
      p._graceTimer = null;
      if (p.link == null) _leaveRoom(p, reason: 'kein Reconnect');
    });
  }

  /// Fährt alles herunter (Timer, Räume, Verbindungen).
  Future<void> close() async {
    _janitor.cancel();
    for (final room in _rooms.values.toList()) {
      _closeRoom(room, 'Server stoppt', notify: false);
    }
    for (final p in _byId.values) {
      p._graceTimer?.cancel();
      p.link?.close(1000, 'server shutdown');
    }
  }

  // ---------------------------------------------------------------------------

  void _reply(Player p, String text) => p.link?.send(text);

  void _enter(Room room, Player p) {
    room.members.add(p);
    p.room = room;
    room._emptySinceMs = null;
    room._sendRoomAndCase(p);
  }

  void _leaveRoom(Player p, {required String reason}) {
    final room = p.room;
    if (room == null) return;
    p.room = null;
    room.members.remove(p);
    room.guard('leave', () => room.runtime.leave(p.id));
    log('${p.id} verlässt ${room.code} ($reason)');
  }

  void _closeRoom(Room room, String reason, {bool notify = true}) {
    room._stop();
    _rooms.remove(room.code);
    for (final p in room.members.toList()) {
      p.room = null;
      if (notify) _reply(p, encodeError(NetError.notInRoom));
    }
    room.members.clear();
    log('Raum ${room.code} geschlossen ($reason, ${_rooms.length} Räume)');
  }

  /// Aufräumen: leere/beendete Räume, vergessene Spieler.
  void _sweep() {
    final now = _clock.elapsedMilliseconds;
    for (final room in _rooms.values.toList()) {
      if (room.members.any((m) => m.online)) {
        room._emptySinceMs = null;
      } else {
        room._emptySinceMs ??= now;
      }
      if (room._finishedAtMs == null && room.guard('finished', () => room.runtime.finished) == true) {
        room._finishedAtMs = now;
      }
      final emptySince = room._emptySinceMs;
      final finishedAt = room._finishedAtMs;
      if (emptySince != null && now - emptySince >= emptyRoomTtl.inMilliseconds) {
        _closeRoom(room, 'leer');
      } else if (finishedAt != null && now - finishedAt >= finishedRoomTtl.inMilliseconds) {
        _closeRoom(room, 'Partie beendet');
      }
    }
    for (final p in _byId.values.toList()) {
      final since = p.offlineSinceMs;
      if (p.link == null && p.room == null && since != null && now - since >= forgetPlayerAfter.inMilliseconds) {
        p._graceTimer?.cancel();
        _byId.remove(p.id);
        _byToken.remove(p.token);
      }
    }
  }

  static String _seconds(Duration d) =>
      d.inMilliseconds % 1000 == 0 ? '${d.inSeconds}' : (d.inMilliseconds / 1000).toStringAsFixed(1);

  String _newPlayerId() {
    while (true) {
      final id = newPlayerId(_rng);
      if (!_byId.containsKey(id)) return id;
    }
  }

  String? _newRoomCode() {
    for (var i = 0; i < 64; i++) {
      final code = randomRoomCode(_rng);
      if (!_rooms.containsKey(code)) return code;
    }
    return null;
  }
}

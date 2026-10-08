/// Smoke-Test des Server-Kerns ohne echte Engine.
///
/// Startet [RoomManager] + HTTP/WebSocket auf einem freien Port mit einer
/// Mini-Fake-Runtime und spielt das Protokoll mit echten WebSocket-Clients durch.
///
///   cd server && dart run tool/smoke.dart [-v]
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/mordakte_core.dart';
import 'package:mordakte_server/codes.dart';
import 'package:mordakte_server/rooms.dart';
import 'package:mordakte_server/runtime.dart';
import 'package:mordakte_server/scenarios.dart';
import 'package:mordakte_server/server.dart';
import 'package:mordakte_server/wire.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// ---------------------------------------------------------------------------
// Fake-Runtime: Lobby-Join, Bewegung, Ereignisse.

class FakePlayer {
  FakePlayer(this.name);
  final String name;
  bool connected = true;
  bool ready = false;
  double x = 1.5, y = 1.5, f = 0;
  int ack = 0;
}

class FakeRuntime implements GameRuntime {
  FakeRuntime(this.code);

  final String code;
  final Map<String, FakePlayer> players = {};
  final Map<String, List<GameEvent>> _queues = {};
  final Map<String, int> _sentVersion = {};
  final List<String> calls = [];
  int _t = 0;
  int _version = 1;
  bool started = false;

  @override
  List<String> get humanPlayers => players.keys.toList();

  @override
  bool get finished => false;

  @override
  bool join(String playerId, String name) {
    calls.add('join $playerId');
    final known = players[playerId];
    if (known != null) {
      known.connected = true;
      _version++;
      return true;
    }
    if (started) return false;
    players[playerId] = FakePlayer(name);
    _queues[playerId] = [];
    _version++;
    return true;
  }

  @override
  void leave(String playerId) {
    calls.add('leave $playerId');
    players.remove(playerId);
    _queues.remove(playerId);
    _version++;
  }

  @override
  void setConnected(String playerId, bool connected) {
    calls.add('setConnected $playerId $connected');
    players[playerId]?.connected = connected;
    _version++;
  }

  @override
  void applyMove(String playerId, MoveInput move) {
    final p = players[playerId];
    if (p == null) return;
    p
      ..x = move.x
      ..y = move.y
      ..f = move.facing
      ..ack = move.seq;
  }

  @override
  void applyCommand(String playerId, Command command) {
    calls.add('cmd $playerId ${command.type}');
    switch (command) {
      case SetReady(:final ready):
        players[playerId]?.ready = ready;
        _version++;
      case StartGame():
        started = true;
        _version++;
        _emit(GameEvent(Ev.phase, args: {'phase': 'intro', 'chapter': 1}));
      case Signal(:final kind, :final value):
        _emit(GameEvent(Ev.signal, args: {'by': playerId, 'kind': kind, 'value': value}));
      case Interact(:final target):
        // Absichtlich in alle Warteschlangen: Der Server muss nach `to` filtern.
        _emit(GameEvent(Ev.nothingFound, to: playerId, args: {'hotspot': target}));
      default:
        break;
    }
  }

  void _emit(GameEvent e) {
    for (final q in _queues.values) {
      q.add(e);
    }
  }

  @override
  void tick(int dtMs) => _t += dtMs;

  @override
  WorldSnapshot worldFor(String playerId) => WorldSnapshot(
        t: _t,
        phase: started ? Phase.intro : Phase.lobby,
        chapter: started ? 1 : 0,
        phaseRemainingMs: 0,
        phaseTotalMs: 0,
        detectives: [
          for (final e in players.entries)
            DetectiveView(
              id: e.key, name: e.value.name, cls: 'forensic', coat: 0, hat: 'fedora', bot: false,
              connected: e.value.connected, x: e.value.x, y: e.value.y, facing: e.value.f,
              life: LifeState.alive, hp: 3, maxHp: 3, nerves: 100, hidden: false, moving: false,
              channel: null, effects: const [], downedLeftMs: 0,
            ),
        ],
        npcs: const [],
        shadow: null,
        signals: const [],
        ackSeq: players[playerId]?.ack ?? 0,
      );

  @override
  CaseView? caseFor(String playerId, {bool force = false}) {
    if (!force && _sentVersion[playerId] == _version) return null;
    _sentVersion[playerId] = _version;
    return CaseView(
      version: _version,
      roomCode: code,
      hostId: players.keys.isEmpty ? '' : players.keys.first,
      scenarioId: 'sample',
      mode: 'story',
      seed: 1,
      bots: 0,
      lobby: [
        for (final e in players.entries)
          LobbyPlayer(
            id: e.key, name: e.value.name, cls: 'forensic', coat: 0, hat: 'fedora',
            ready: e.value.ready, bot: false, connected: e.value.connected,
          ),
      ],
      phase: started ? Phase.intro : Phase.lobby,
      chapter: started ? 1 : 0,
      notebook: const [],
      board: const [],
      deductions: const [],
      contradictions: 0,
      hotspots: const {},
      openDoors: const [],
      items: const [],
      inventory: const [],
      leadOptions: const [],
      leadVotes: const {},
      chosenLeads: const [],
      accusations: const {},
      heard: const {},
      deadNpcs: const [],
      abilityCooldownMs: 0,
      abilityCharges: 0,
      pingsLeft: 1,
      ending: null,
    );
  }

  @override
  List<GameEvent> drainEvents(String playerId) {
    final q = _queues[playerId];
    if (q == null || q.isEmpty) return const [];
    final out = List.of(q);
    q.clear();
    return out;
  }
}

// ---------------------------------------------------------------------------
// Test-Client

class Client {
  Client._(this.name, this._ch) {
    _ch.stream.listen(
      (data) {
        final msg = (jsonDecode(data as String) as Map).cast<String, dynamic>();
        inbox.add(msg);
        _arrived.add(null);
      },
      onDone: () {
        closeCode = _ch.closeCode;
        if (!closed.isCompleted) closed.complete();
      },
      onError: (_) {},
    );
  }

  static Future<Client> connect(String url, String name) async {
    final ch = WebSocketChannel.connect(Uri.parse(url));
    await ch.ready;
    return Client._(name, ch);
  }

  final String name;
  final WebSocketChannel _ch;
  final List<Map<String, dynamic>> inbox = [];
  final Set<int> _consumed = {};
  final _arrived = StreamController<void>.broadcast();
  final Completer<void> closed = Completer();
  int? closeCode;
  String? playerId;
  String? token;

  void send(Object msg) => _ch.sink.add(msg is String ? msg : jsonEncode(msg));

  Future<void> close() => _ch.sink.close(1000);

  /// Nächste noch nicht verbrauchte Nachricht vom Typ [type] (optional mit Bedingung).
  Future<Map<String, dynamic>> expect(
    String type, {
    bool Function(Map<String, dynamic>)? where,
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (true) {
      for (var i = 0; i < inbox.length; i++) {
        final m = inbox[i];
        if (_consumed.contains(i) || m['t'] != type) continue;
        if (where != null && !where(m)) continue;
        _consumed.add(i);
        return m;
      }
      final left = deadline.difference(DateTime.now());
      if (left <= Duration.zero) throw TimeoutException('$name: keine "$type"-Nachricht');
      await _arrived.stream.first.timeout(left, onTimeout: () {});
    }
  }

  bool has(String type, {bool Function(Map<String, dynamic>)? where}) =>
      inbox.any((m) => m['t'] == type && (where == null || where(m)));

  int count(String type) => inbox.where((m) => m['t'] == type).length;

  /// Zuletzt empfangene Nachricht vom Typ [type].
  Map<String, dynamic> latest(String type) => inbox.lastWhere((m) => m['t'] == type);

  Future<Map<String, dynamic>> hello({String? token}) async {
    send({'t': Msg.hello, 'name': name, 'token': ?token, 'proto': protocolVersion});
    final w = await expect(Msg.welcome);
    playerId = w['player'] as String;
    this.token = w['token'] as String;
    return w;
  }
}

// ---------------------------------------------------------------------------

var _passed = 0;
var _failed = 0;

void check(String what, bool ok, [Object? detail]) {
  if (ok) {
    _passed++;
    print('  OK    $what');
  } else {
    _failed++;
    print('  FAIL  $what${detail == null ? '' : ' – $detail'}');
  }
}

Future<void> step(String title, Future<void> Function() body) async {
  print('\n$title');
  try {
    await body();
  } catch (e, st) {
    _failed++;
    print('  FAIL  Ausnahme: $e\n$st');
  }
}

Future<String> health(int port) async {
  final client = HttpClient();
  try {
    final req = await client.get('127.0.0.1', port, '/health');
    final res = await req.close();
    return (await res.transform(utf8.decoder).join()).trim();
  } finally {
    client.close(force: true);
  }
}

Future<void> pause(int ms) => Future<void>.delayed(Duration(milliseconds: ms));

Future<void> main(List<String> args) async {
  final verbose = args.contains('-v');
  if (!args.contains('--real-only')) await fakeSuite(verbose);
  if (!args.contains('--fake-only')) await realSuite(verbose);
  print('\n$_passed OK, $_failed FAIL');
  exit(_failed == 0 ? 0 : 1);
}

/// Teil A: Protokoll, Schutz, Reconnect und Aufräumen mit der Fake-Runtime.
Future<void> fakeSuite(bool verbose) async {
  print('=== Teil A: Fake-Runtime ===');
  final fakes = <String, FakeRuntime>{};
  final rooms = RoomManager(
    runtimeFactory: (code) => fakes[code] = FakeRuntime(code),
    reconnectGrace: const Duration(milliseconds: 600),
    emptyRoomTtl: const Duration(milliseconds: 800),
    janitorInterval: const Duration(milliseconds: 100),
    log: (m) {
      if (verbose) print('        [server] $m');
    },
  );
  final server = await serveMordakte(rooms, port: 0);
  final port = server.port;
  final url = 'ws://127.0.0.1:$port/ws';
  print('Smoke-Test gegen $url (tick ${Tuning.tickMs} ms, snapshot ${Tuning.snapshotMs} ms)');

  late Client a, b;
  late String code;
  late FakeRuntime fake;

  await step('1. Health', () async {
    final h = await health(port);
    check('GET /health → "$h"', h.startsWith('ok') && h.contains('rooms=0'));
  });

  await step('2. hello → welcome', () async {
    a = await Client.connect(url, 'Anna');
    final w = await a.hello();
    check('welcome mit Spieler-ID ${w['player']}', a.playerId!.startsWith('p_'));
    check('Token ist 128 Bit hex', isWellFormedToken(a.token));
  });

  await step('3. create → room, c, w', () async {
    a.send({'t': Msg.create});
    final r = await a.expect(Msg.room);
    code = r['code'] as String;
    fake = fakes[code]!;
    check('room code=$code', normalizeRoomCode(code) == code);
    final c = CaseView.fromJson(await a.expect(Msg.caseView));
    check('c sofort: Lobby ${c.lobby.map((p) => p.name).toList()}, Host = Anna', c.hostId == a.playerId);
    final w = decodeWorld(await a.expect(Msg.world));
    check('w kommt (phase=${w.phase.name}, t=${w.t} ms)', w.phase == Phase.lobby && w.detectives.length == 1);
  });

  await step('4. join (falscher Code, dann richtiger in Kleinschreibung)', () async {
    b = await Client.connect(url, 'Ben');
    await b.hello();
    check('zweiter Spieler ${b.playerId} ≠ ${a.playerId}', b.playerId != a.playerId);
    b.send({'t': Msg.join, 'code': 'ZZZZ'});
    final e = await b.expect(Msg.error);
    check('falscher Code → err ${e['key']}', e['key'] == NetError.roomNotFound);
    b.send({'t': Msg.join, 'code': code.toLowerCase()});
    final r = await b.expect(Msg.room);
    check('join → room ${r['code']}', r['code'] == code);
    final c = CaseView.fromJson(await b.expect(Msg.caseView));
    check('Lobby hat 2 Spieler', c.lobby.length == 2);
    final ca = await a.expect(Msg.caseView, where: (m) => (m['lobby'] as List).length == 2);
    check('Anna bekommt aktualisierte Lobby (version ${ca['version']})', true);
  });

  await step('5. Kaputte Nachrichten', () async {
    b.send('{kaputt');
    check('kaputtes JSON → err bad_message', (await b.expect(Msg.error))['key'] == NetError.badMessage);
    b.send({'t': Msg.cmd, 'c': {'type': 'gibt_es_nicht'}});
    check('unbekannter Befehl → err bad_message', (await b.expect(Msg.error))['key'] == NetError.badMessage);
    b.send({'t': Msg.ping, 'n': 7});
    check('Verbindung lebt: ping → pong n=7', (await b.expect(Msg.pong))['n'] == 7);
    a.send(jsonEncode({'t': Msg.ping, 'pad': 'x' * 9000}));
    check('> 8 KB → err bad_message', (await a.expect(Msg.error))['key'] == NetError.badMessage);
  });

  await step('6. mv → Position in w (eigene + fremde Sicht)', () async {
    a.send({'t': Msg.move, ...const MoveInput(x: 3.5, y: 4.25, facing: 1.0, seq: 1).toJson()});
    final wa = decodeWorld(await a.expect(Msg.world, where: (m) => m['ack'] == 1));
    final me = wa.detective(a.playerId!)!;
    check('Anna: ack=1, Position (${me.x}, ${me.y})', me.x == 3.5 && me.y == 4.25);
    final wb = decodeWorld(await b.expect(Msg.world, where: (m) {
      final d = decodeWorld(m).detective(a.playerId!);
      return d != null && d.x == 3.5;
    }));
    check('Ben sieht Anna bei x=${wb.detective(a.playerId!)!.x}', true);
  });

  await step('7. cmd → ev / c', () async {
    a.send({'t': Msg.cmd, 'c': const Signal(kind: 'emote', value: 'wave').toJson()});
    bool isSignal(Map<String, dynamic> m) => (m['list'] as List).any((e) => (e as Map)['type'] == Ev.signal);
    await a.expect(Msg.events, where: isSignal);
    final evB = await b.expect(Msg.events, where: isSignal);
    final ev = GameEvent.fromJson(((evB['list'] as List).first as Map).cast());
    check('Signal-Ereignis an beide (${ev.type} ${ev.args})', ev.str('by') == a.playerId);

    a.send({'t': Msg.cmd, 'c': const Interact('h_desk').toJson()});
    bool isPrivate(Map<String, dynamic> m) => (m['list'] as List).any((e) => (e as Map)['type'] == Ev.nothingFound);
    await a.expect(Msg.events, where: isPrivate);
    await pause(300);
    check('privates Ereignis nur an Anna (Server filtert "to")', !b.has(Msg.events, where: isPrivate));

    b.send({'t': Msg.cmd, 'c': const SetReady(true).toJson()});
    final c = CaseView.fromJson(await a.expect(Msg.caseView, where: (m) {
      return (m['lobby'] as List).any((p) => (p as Map)['id'] == b.playerId && p['ready'] == true);
    }));
    check('SetReady → neue Fall-Ansicht (version ${c.version})', fake.calls.contains('cmd ${b.playerId} ready'));
  });

  await step('8. Schutz: Rate-Limit und Reihenfolge', () async {
    final c = await Client.connect(url, 'Cleo');
    c.send({'t': Msg.create});
    check('create vor hello → err protocol', (await c.expect(Msg.error))['key'] == NetError.protocol);
    for (var i = 0; i < 100; i++) {
      c.send({'t': Msg.ping, 'n': i});
    }
    await pause(500);
    final pongs = c.count(Msg.pong);
    check('100 pings im Burst → $pongs pongs (max. 40/s)', pongs > 0 && pongs <= 40);
    await c.close();
  });

  await step('9. Laufendes Spiel / voller Raum', () async {
    a.send({'t': Msg.cmd, 'c': const StartGame().toJson()});
    await a.expect(Msg.events, where: (m) => (m['list'] as List).any((e) => (e as Map)['type'] == Ev.phase));
    final c = await Client.connect(url, 'Cleo');
    await c.hello();
    c.send({'t': Msg.join, 'code': code});
    check('join in laufendes Spiel → err game_running', (await c.expect(Msg.error))['key'] == NetError.gameRunning);

    final host = await Client.connect(url, 'Host2');
    await host.hello();
    host.send({'t': Msg.create});
    final code2 = (await host.expect(Msg.room))['code'] as String;
    final others = <Client>[];
    for (var i = 0; i < maxPlayersPerRoom - 1; i++) {
      final o = await Client.connect(url, 'Gast$i');
      await o.hello();
      o.send({'t': Msg.join, 'code': code2});
      await o.expect(Msg.room);
      others.add(o);
    }
    c.send({'t': Msg.join, 'code': code2});
    check('7. Spieler → err room_full', (await c.expect(Msg.error))['key'] == NetError.roomFull);
    for (final o in [c, host, ...others]) {
      await o.close();
    }
  });

  await step('10. Reconnect mit Token', () async {
    final bId = b.playerId!;
    final bToken = b.token!;
    await b.close();
    await pause(200);
    check('Trennung → setConnected(false)', fake.calls.contains('setConnected $bId false'));

    final b2 = await Client.connect(url, 'Ben');
    final w = await b2.hello(token: bToken);
    check('gleiche Spieler-ID nach Reconnect (${w['player']})', w['player'] == bId);
    final r = await b2.expect(Msg.room);
    check('automatisch wieder im Raum ${r['code']} (ohne join)', r['code'] == code);
    final c = CaseView.fromJson(await b2.expect(Msg.caseView));
    check('sofort c (force) mit Phase ${c.phase.name}', c.roomCode == code);
    check('setConnected(true)', fake.calls.contains('setConnected $bId true'));
    await b2.expect(Msg.world);
    check('w läuft weiter', true);

    // Übernahme: zweite Verbindung mit demselben Token, bevor die alte zu ist.
    final b3 = await Client.connect(url, 'Ben');
    await b3.hello(token: bToken);
    await b3.expect(Msg.room);
    await b2.closed.future.timeout(const Duration(seconds: 2));
    check('alte Verbindung wird mit Code ${b2.closeCode} geschlossen', b2.closeCode == closeReplaced);
    b3.send({'t': Msg.ping, 'n': 1});
    check('neue Verbindung aktiv', (await b3.expect(Msg.pong))['n'] == 1);

    final stranger = await Client.connect(url, 'Fremd');
    final ws = await stranger.hello(token: 'ab' * 16);
    check('unbekanntes Token → neue ID ${ws['player']}', ws['player'] != bId && ws['token'] != 'ab' * 16);
    await stranger.close();

    // Gnadenfrist (im Test 600 ms) → leave
    await b3.close();
    await pause(900);
    check('ohne Reconnect nach Gnadenfrist → leave($bId)', fake.calls.contains('leave $bId'));
    check('Raum hat noch 1 Mitglied', rooms.room(code)?.members.length == 1);
  });

  await step('11. Aufräumen leerer Räume', () async {
    await a.close();
    await pause(1300);
    final h = await health(port);
    check('alle getrennt → Räume geschlossen ("$h")', h.contains('rooms=0'));
  });

  await rooms.close();
  await server.close(force: true);
}

/// Teil B: echte `RoomRuntime` mit dem Beispiel-Szenario – Lobby → Intro → Ermittlung.
Future<void> realSuite(bool verbose) async {
  print('\n=== Teil B: echte RoomRuntime ===');
  final serverErrors = <String>[];
  void log(String m) {
    if (m.contains('Fehler')) serverErrors.add(m);
    if (verbose) print('        [server] $m');
  }

  final scenarios = loadScenarios(resolveScenarioDir(null), log: log, includeSample: true);
  final runtimes = <String, RoomRuntime>{};
  final rooms = RoomManager(
    runtimeFactory: (code) => CoreRuntime(runtimes[code] = RoomRuntime(roomCode: code, scenarios: scenarios)),
    log: log,
  );
  final server = await serveMordakte(rooms, port: 0);
  final url = 'ws://127.0.0.1:${server.port}/ws';
  print('Szenarien: ${scenarios.keys.toList()}');

  late Client a, b;
  late String code;
  bool hasEvent(Map<String, dynamic> m, bool Function(GameEvent) test) =>
      (m['list'] as List).any((e) => test(GameEvent.fromJson((e as Map).cast())));

  await step('B1. Lobby: create + join', () async {
    a = await Client.connect(url, 'Anna');
    await a.hello();
    a.send({'t': Msg.create});
    code = (await a.expect(Msg.room))['code'] as String;
    final c = CaseView.fromJson(await a.expect(Msg.caseView));
    check('Raum $code, Phase ${c.phase.name}, Host Anna', c.phase == Phase.lobby && c.hostId == a.playerId);
    b = await Client.connect(url, 'Ben');
    await b.hello();
    b.send({'t': Msg.join, 'code': code});
    await b.expect(Msg.room);
    final cb = CaseView.fromJson(await b.expect(Msg.caseView, where: (m) => (m['lobby'] as List).length == 2));
    check('Ben in der Lobby (${cb.lobby.map((p) => p.name).join(', ')})', true);
  });

  await step('B2. ConfigureGame + StartGame', () async {
    a.send({
      't': Msg.cmd,
      'c': const ConfigureGame(scenarioId: 'sample', mode: 'story', bots: 2).toJson(),
    });
    final c = CaseView.fromJson(await a.expect(Msg.caseView, where: (m) => m['scenario'] == 'sample'));
    check('Konfiguration: scenario=${c.scenarioId}, mode=${c.mode}, bots=${c.bots}', c.bots == 2);
    a.send({'t': Msg.cmd, 'c': const StartGame().toJson()});
    await b.expect(Msg.events, where: (m) => hasEvent(m, (e) => e.type == Ev.phase && e.str('phase') == 'intro'));
    check('ev phase=intro an Ben', true);
    final w = decodeWorld(await a.expect(Msg.world, where: (m) => m['phase'] == 'intro'));
    check('w phase=intro, ${w.detectives.length} Detektive (2 Menschen + 2 Bots)', w.detectives.length == 4);
    final cb = CaseView.fromJson(await b.expect(Msg.caseView, where: (m) => m['phase'] == 'intro'));
    check('c phase=intro, Kapitel ${cb.chapter}', cb.chapter >= 1);
  });

  await step('B3. Intro überspringen → Ermittlung', () async {
    for (final cl in [a, b]) {
      cl.send({'t': Msg.cmd, 'c': const SetReady(true).toJson()});
    }
    final w = decodeWorld(await a.expect(
      Msg.world,
      where: (m) => m['phase'] == 'investigation',
      timeout: const Duration(seconds: 8),
    ));
    check('w phase=investigation (${w.phaseRemainingMs} ms übrig)', w.phase == Phase.investigation);
    final c = CaseView.fromJson(await b.expect(Msg.caseView, where: (m) => m['phase'] == 'investigation'));
    check('c phase=investigation, ${c.hotspots.length} Hotspots sichtbar', c.hotspots.isNotEmpty);
  });

  await step('B4. Bewegung und Autopilot', () async {
    final me = decodeWorld(b.latest(Msg.world)).detective(b.playerId!)!;
    b.send({'t': Msg.move, ...MoveInput(x: me.x + 0.1, y: me.y, facing: 0, seq: 1).toJson()});
    final w1 = decodeWorld(await b.expect(Msg.world, where: (m) => m['ack'] == 1));
    final moved = w1.detective(b.playerId!)!;
    check('mv angenommen: ack=1, x ${me.x} → ${moved.x}', (moved.x - (me.x + 0.1)).abs() < 0.05);

    final start = decodeWorld(a.latest(Msg.world)).detective(a.playerId!)!;
    runtimes[code]!.setAutopilot(a.playerId!, true);
    await pause(3000);
    final now = decodeWorld(a.latest(Msg.world)).detective(a.playerId!)!;
    final dist = (now.x - start.x).abs() + (now.y - start.y).abs();
    check('Autopilot bewegt Anna (${start.x},${start.y}) → (${now.x},${now.y})', dist > 0.5);
    final evCount = a.count(Msg.events) + b.count(Msg.events);
    check('Ereignisse fließen ($evCount ev-Nachrichten bisher)', evCount > 0);
  });

  await step('B5. Reconnect im laufenden Spiel', () async {
    final id = b.playerId!;
    final token = b.token!;
    await b.close();
    await pause(300);
    final b2 = await Client.connect(url, 'Ben');
    final w = await b2.hello(token: token);
    check('gleiche ID $id', w['player'] == id);
    await b2.expect(Msg.room);
    final c = CaseView.fromJson(await b2.expect(Msg.caseView));
    check('sofort c (force) in Phase ${c.phase.name}', c.phase == Phase.investigation);
    await b2.expect(Msg.world);
    await pause(200);
    final wd = decodeWorld(b2.latest(Msg.world)).detective(id);
    check('wieder verbunden in w (connected=${wd?.connected})', wd != null && wd.connected);
    await b2.close();
  });

  check('keine Runtime-Fehler im Server-Log', serverErrors.isEmpty, serverErrors.join('\n'));
  await a.close();
  await rooms.close();
  await server.close(force: true);
}

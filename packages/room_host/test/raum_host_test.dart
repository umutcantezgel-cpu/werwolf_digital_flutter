import 'dart:async';
import 'dart:io';

import 'package:room_host/room_host.dart';
import 'package:test/test.dart';

/// Einfaches Echo-Spiel: zählt Nachrichten, schickt jedem seine eigene zurück.
class _Echo implements RaumSpiel {
  final Map<String, List<Map<String, Object?>>> post = {};
  final Set<String> online = {};
  int ticks = 0;
  @override
  bool beitreten(String id, String name) {
    if (post.length >= 3) return false;
    post[id] = [];
    return true;
  }

  @override
  void verlassen(String id) => post.remove(id);
  @override
  void verbunden(String id, bool ja) => ja ? online.add(id) : online.remove(id);
  @override
  void nachricht(String id, Map<String, Object?> n) {
    if (n['art'] == 'kaputt') throw StateError('absichtlich');
    post[id]!.add({'art': 'echo', 'text': n['text']});
  }

  @override
  void tick(double dt) => ticks++;
  @override
  Map<String, Object?> zustandFuer(String id) => {'ich': id, 'ticks': ticks};
  @override
  List<Map<String, Object?>> ereignisseFuer(String id) {
    final p = post[id]!;
    final out = List.of(p);
    p.clear();
    return out;
  }

  @override
  bool get beendet => false;
}

Future<void> warte(bool Function() bed) async {
  for (var i = 0; i < 100 && !bed(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

void main() {
  late RaumHost host;
  late _Echo spiel;
  late String code;
  setUp(() async {
    host = RaumHost((_) => spiel = _Echo(), seed: 1);
    await host.starte(adresse: InternetAddress.loopbackIPv4);
    code = host.erstelleRaum();
  });
  tearDown(() => host.stoppe());

  test('Raumcode: 4 Zeichen ohne verwechselbare Zeichen (0/O, 1/I)', () {
    expect(code, matches(RegExp(r'^[A-HJ-NP-Z2-9]{4}$')));
  });

  test('Beitritt, Ereignis im nächsten Takt, Zustand regelmäßig', () async {
    final c = await RaumClient.verbinde('127.0.0.1', host.port, raum: code, name: 'Ada');
    expect(c.spieler, 'S1');
    c.sende({'art': 'x', 'text': 'hallo'});
    await warte(() => c.ereignisse.isNotEmpty);
    expect(c.ereignisse.single['text'], 'hallo');
    await warte(() => (c.zustand['ticks'] as int? ?? 0) > 5);
    expect(c.zustand['ich'], 'S1');
    await c.trenne();
  });

  test('Unbekannter Raum und voller Raum werden abgelehnt', () async {
    expect(RaumClient.verbinde('127.0.0.1', host.port, raum: 'ZZZZ'), throwsA(isA<StateError>()));
    for (var i = 0; i < 3; i++) {
      await RaumClient.verbinde('127.0.0.1', host.port, raum: code);
    }
    expect(RaumClient.verbinde('127.0.0.1', host.port, raum: code), throwsA(isA<StateError>()));
  });

  test('Wiederverbinden per Token: gleiche Spieler-ID, Ereignisse warten', () async {
    final a = await RaumClient.verbinde('127.0.0.1', host.port, raum: code, name: 'Ada');
    final token = a.token!;
    await a.trenne();
    await warte(() => !spiel.online.contains('S1'));
    spiel.post['S1']!.add({'art': 'echo', 'text': 'während weg'});
    final b = await RaumClient.verbinde('127.0.0.1', host.port, token: token);
    expect(b.spieler, 'S1');
    await warte(() => b.ereignisse.isNotEmpty);
    expect(b.ereignisse.single['text'], 'während weg');
    await b.trenne();
  });

  test('Fehler im Spiel bricht die Verbindung nicht ab', () async {
    final c = await RaumClient.verbinde('127.0.0.1', host.port, raum: code);
    c.sende({'art': 'kaputt'});
    await warte(() => c.fehler.isNotEmpty);
    expect(c.fehler, ['spiel']);
    expect(host.spielFehler, hasLength(1));
    c.sende({'art': 'x', 'text': 'weiter'});
    await warte(() => c.ereignisse.isNotEmpty);
    expect(c.ereignisse.single['text'], 'weiter');
    await c.trenne();
  });
}

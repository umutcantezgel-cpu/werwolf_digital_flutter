import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'raum_host.dart';

/// Einfacher Client (dart:io) für Werkzeuge, Tests und die Mehrspieler-Simulation.
/// Die App nutzt dasselbe Protokoll über `web_socket_channel`.
class RaumClient {
  final WebSocket _ws;
  String? spieler, token, raum;
  Map<String, Object?> zustand = const {};
  final List<Map<String, Object?>> ereignisse = [];
  final List<String> fehler = [];
  final _willkommen = Completer<void>();

  /// Wird bei jedem Ereignis aufgerufen (mit Empfangszeit in µs seit [uhr]).
  void Function(Map<String, Object?> e)? beiEreignis;

  RaumClient._(this._ws) {
    _ws.listen((d) {
      final n = jsonDecode(d as String) as Map<String, Object?>;
      switch (n['t']) {
        case RaumNachricht.willkommen:
          spieler = n['spieler'] as String;
          token = n['token'] as String;
          raum = n['raum'] as String;
          if (!_willkommen.isCompleted) _willkommen.complete();
        case RaumNachricht.zustand:
          zustand = n;
        case RaumNachricht.ereignisse:
          for (final e in n['liste'] as List) {
            final m = e as Map<String, Object?>;
            ereignisse.add(m);
            beiEreignis?.call(m);
          }
        case RaumNachricht.fehler:
          fehler.add(n['schluessel'] as String);
          if (!_willkommen.isCompleted) _willkommen.completeError(StateError(n['schluessel'] as String));
      }
    }, onError: (_) {});
  }

  /// Verbindet mit `ws://<adresse>:<port>/raum` und tritt [raum] bei (oder verbindet per [token] neu).
  static Future<RaumClient> verbinde(String adresse, int port, {String? raum, String name = '', String? token}) async {
    final c = RaumClient._(await WebSocket.connect('ws://$adresse:$port/raum'));
    c._ws.add(jsonEncode({'t': RaumNachricht.hallo, 'name': name, 'raum': ?raum, 'token': ?token}));
    await c._willkommen.future.timeout(const Duration(seconds: 5));
    return c;
  }

  void sende(Map<String, Object?> inhalt) => _ws.add(jsonEncode({'t': RaumNachricht.spiel, ...inhalt}));

  Future<void> trenne() => _ws.close();
}

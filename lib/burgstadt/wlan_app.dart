import 'dart:async';
import 'dart:convert';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'wlan_host_stub.dart' if (dart.library.io) 'wlan_host_io.dart' as host;

/// WLAN-Spiel der App: Gastgeber über den eingebetteten Raum-Host (nur App), Gast über
/// WebSocket (App und Browser). Nur lokales Netz – keine fremden Server.
class AppWlan implements WlanAnbindung {
  WebSocketChannel? _kanal;
  StreamSubscription<Object?>? _abo;
  host.Gastgeber? _host;
  bool _schliesst = false;

  @override
  bool get kannGastgeben => host.kannGastgeben;

  @override
  Future<(String, List<String>, String)> eroeffne(BurgstadtRaum raum, String name) async {
    await schliessen();
    final h = host.Gastgeber();
    final r = await h.starte(raum, name);
    _host = h;
    return r;
  }

  @override
  Future<void> beitreten(String adresse, String code, String name,
      {required void Function(Map<String, Object?> nachricht) empfang, required void Function(String grund) getrennt}) async {
    await schliessen();
    _schliesst = false;
    final kanal = WebSocketChannel.connect(Uri.parse('ws://$adresse/raum'));
    await kanal.ready.timeout(const Duration(seconds: 6));
    _kanal = kanal;
    _abo = kanal.stream.listen((d) {
      if (d is! String) return;
      final n = jsonDecode(d);
      if (n is Map<String, Object?>) empfang(n);
    }, onDone: () {
      if (!_schliesst) getrennt('Verbindung zum Gastgeber getrennt');
    }, onError: (Object e) {
      if (!_schliesst) getrennt('$e');
    });
    kanal.sink.add(jsonEncode({'t': 'hallo', 'name': name.isEmpty ? 'Gast' : name, 'raum': code}));
  }

  @override
  void senden(Map<String, Object?> nachricht) => _kanal?.sink.add(jsonEncode(nachricht));

  @override
  Future<void> schliessen() async {
    _schliesst = true;
    await _abo?.cancel();
    _abo = null;
    await _kanal?.sink.close();
    _kanal = null;
    await _host?.stoppe();
    _host = null;
  }
}

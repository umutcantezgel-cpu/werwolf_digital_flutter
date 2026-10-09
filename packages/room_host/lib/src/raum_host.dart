import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import '../raum_spiel.dart';

/// Protokoll (JSON-Textnachrichten über WebSocket, Pfad `/raum`):
///
/// Client → Host
/// - `{"t":"hallo","name":"…","raum":"ABCD"}` – Beitritt; mit `"token":"…"` Wiederverbinden.
/// - `{"t":"spiel", …}` – alles Weitere geht an das Spiel ([RaumSpiel.nachricht]).
///
/// Host → Client
/// - `{"t":"willkommen","spieler":"S1","token":"…","raum":"ABCD"}`
/// - `{"t":"zustand", …}` – Zustand aus Sicht des Spielers (alle [RaumHost.zustandAlle] Takte)
/// - `{"t":"ereignisse","liste":[…]}` – sofort im nächsten Takt
/// - `{"t":"fehler","schluessel":"…"}` – `raum_unbekannt`, `abgelehnt`, `token_unbekannt`, `format`
abstract final class RaumNachricht {
  static const hallo = 'hallo', spiel = 'spiel';
  static const willkommen = 'willkommen', zustand = 'zustand', ereignisse = 'ereignisse', fehler = 'fehler';
}

/// Ein Teilnehmer über Verbindungen hinweg (Token → dieselbe Spieler-ID).
class RaumSpieler {
  final String id, token, name;
  WebSocket? verbindung;
  RaumSpieler(this.id, this.token, this.name);
  bool get online => verbindung != null;
}

/// Ein Raum mit Code, Spiel und Teilnehmern.
class Raum {
  final String code;
  final RaumSpiel spiel;
  final Map<String, RaumSpieler> spieler = {};
  int _naechste = 1;
  Raum(this.code, this.spiel);
}

/// Host für Räume im lokalen Netz. Läuft auf dem Gerät des Gastgebers (App) oder als
/// Werkzeug/Test. Ein Takt [takt] Hz führt alle Spiele weiter, verschickt Ereignisse sofort
/// und den Zustand alle [zustandAlle] Takte.
class RaumHost {
  final RaumSpiel Function(String code) fabrik;
  final int takt, zustandAlle;
  final Map<String, Raum> raeume = {};
  final Map<String, (Raum, RaumSpieler)> _tokens = {};
  final math.Random _zufall;
  HttpServer? _server;
  Timer? _uhr;
  int _takte = 0;
  final Stopwatch _zeit = Stopwatch();

  /// Gesendete Nachrichten (für Messungen).
  int gesendet = 0;

  /// Fehler, die das Spiel beim Verarbeiten einer Nachricht warf (für Tests/Protokoll).
  final List<String> spielFehler = [];

  RaumHost(this.fabrik, {this.takt = 30, this.zustandAlle = 3, int? seed}) : _zufall = math.Random(seed);

  int get port => _server?.port ?? 0;

  /// Startet den Server; liefert den Port (0 = frei wählen lassen).
  Future<int> starte({InternetAddress? adresse, int port = 0}) async {
    final s = await HttpServer.bind(adresse ?? InternetAddress.anyIPv4, port);
    _server = s;
    s.listen(_anfrage);
    _zeit.start();
    var letzte = 0;
    _uhr = Timer.periodic(Duration(microseconds: 1000000 ~/ takt), (_) {
      final jetzt = _zeit.elapsedMicroseconds;
      _schritt((jetzt - letzte) / 1e6);
      letzte = jetzt;
    });
    return s.port;
  }

  Future<void> stoppe() async {
    _uhr?.cancel();
    for (final r in raeume.values) {
      for (final p in r.spieler.values) {
        await p.verbindung?.close();
      }
    }
    await _server?.close(force: true);
  }

  static const _zeichen = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  /// Neuer Raum; liefert seinen Code (4 Zeichen, ohne verwechselbare Zeichen).
  String erstelleRaum() {
    String code;
    do {
      code = String.fromCharCodes([for (var i = 0; i < 4; i++) _zeichen.codeUnitAt(_zufall.nextInt(_zeichen.length))]);
    } while (raeume.containsKey(code));
    raeume[code] = Raum(code, fabrik(code));
    return code;
  }

  String _neuesToken() => List.generate(24, (_) => _zeichen[_zufall.nextInt(_zeichen.length)]).join();

  Future<void> _anfrage(HttpRequest q) async {
    if (q.uri.path != '/raum' || !WebSocketTransformer.isUpgradeRequest(q)) {
      q.response
        ..statusCode = HttpStatus.notFound
        ..write('Burgstadt-Raum: WebSocket unter /raum');
      await q.response.close();
      return;
    }
    final ws = await WebSocketTransformer.upgrade(q);
    RaumSpieler? ich;
    Raum? raum;
    ws.listen((daten) {
      Map<String, Object?> n;
      try {
        n = jsonDecode(daten as String) as Map<String, Object?>;
      } catch (_) {
        _sende(ws, {'t': RaumNachricht.fehler, 'schluessel': 'format'});
        return;
      }
      if (n['t'] == RaumNachricht.hallo) {
        final token = n['token'] as String?;
        if (token != null) {
          final t = _tokens[token];
          if (t == null) {
            _sende(ws, {'t': RaumNachricht.fehler, 'schluessel': 'token_unbekannt'});
            return;
          }
          (raum, ich) = t;
          final alt = ich!.verbindung;
          ich!.verbindung = ws;
          if (alt != null && alt != ws) alt.close(4000, 'ersetzt');
          raum!.spiel.verbunden(ich!.id, true);
        } else {
          final r = raeume[(n['raum'] as String? ?? '').toUpperCase()];
          if (r == null) {
            _sende(ws, {'t': RaumNachricht.fehler, 'schluessel': 'raum_unbekannt'});
            return;
          }
          final id = 'S${r._naechste++}';
          final name = (n['name'] as String? ?? id).trim();
          if (!r.spiel.beitreten(id, name.isEmpty ? id : name)) {
            _sende(ws, {'t': RaumNachricht.fehler, 'schluessel': 'abgelehnt'});
            return;
          }
          final p = RaumSpieler(id, _neuesToken(), name)..verbindung = ws;
          r.spieler[id] = p;
          _tokens[p.token] = (r, p);
          (raum, ich) = (r, p);
          r.spiel.verbunden(id, true);
        }
        _sende(ws, {'t': RaumNachricht.willkommen, 'spieler': ich!.id, 'token': ich!.token, 'raum': raum!.code});
        _sende(ws, {'t': RaumNachricht.zustand, ...raum!.spiel.zustandFuer(ich!.id)});
        return;
      }
      if (ich == null || raum == null) {
        _sende(ws, {'t': RaumNachricht.fehler, 'schluessel': 'erst_hallo'});
        return;
      }
      if (n['t'] == RaumNachricht.spiel) {
        try {
          raum!.spiel.nachricht(ich!.id, n);
        } catch (e) {
          spielFehler.add('$e');
          _sende(ws, {'t': RaumNachricht.fehler, 'schluessel': 'spiel'});
        }
      }
    }, onDone: () {
      final p = ich;
      if (p != null && p.verbindung == ws) {
        p.verbindung = null;
        raum?.spiel.verbunden(p.id, false);
      }
    }, onError: (_) {});
  }

  void _sende(WebSocket ws, Map<String, Object?> n) {
    ws.add(jsonEncode(n));
    gesendet++;
  }

  void _schritt(double dt) {
    _takte++;
    for (final r in raeume.values) {
      r.spiel.tick(dt);
      for (final p in r.spieler.values) {
        final ws = p.verbindung;
        if (ws == null) continue; // Ereignisse warten im Spiel bis zum Wiederverbinden
        final e = r.spiel.ereignisseFuer(p.id);
        if (e.isNotEmpty) _sende(ws, {'t': RaumNachricht.ereignisse, 'liste': e});
        if (_takte % zustandAlle == 0) _sende(ws, {'t': RaumNachricht.zustand, ...r.spiel.zustandFuer(p.id)});
      }
    }
  }

  /// Adressen dieses Geräts im lokalen Netz (für die Anzeige „Beitreten mit …“).
  static Future<List<String>> lanAdressen() async => [
        for (final i in await NetworkInterface.list(type: InternetAddressType.IPv4))
          for (final a in i.addresses)
            if (!a.isLoopback) a.address,
      ];
}

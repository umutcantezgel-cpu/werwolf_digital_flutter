/// JSON-Umschläge (siehe `protocol/messages.dart` in `mordakte_core`).
///
/// Abweichung im `w`-Umschlag: `WorldSnapshot.toJson()` enthält selbst ein Feld
/// `t` (Laufzeit in ms), das mit dem Typ-Feld `"t":"w"` kollidiert. Die Laufzeit
/// wird deshalb unter [worldTimeKey] übertragen:
/// `{"t":"w","wt":12345,"phase":…}`. Die App (`OnlineSession`) liest es genauso.
library;

import 'dart:convert';

import 'package:mordakte_core/mordakte_core.dart';

/// Feld für `WorldSnapshot.t` im `w`-Umschlag.
const worldTimeKey = 'wt';

/// WebSocket-Close-Code: Eine neuere Verbindung mit demselben Token hat übernommen.
const closeReplaced = 4000;

/// Server-eigene Fehler-Schlüssel (zusätzlich zu [NetError]).
abstract final class ServerError {
  /// Unerwarteter Fehler beim Erstellen/Beitreten.
  static const internal = 'server_error';

  /// Zu viele Räume auf diesem Server.
  static const full = 'server_full';
}

String encodeMsg(Map<String, Object?> msg) => jsonEncode(msg);

String encodeError(String key) => jsonEncode({'t': Msg.error, 'key': key});

String encodeWorld(WorldSnapshot world) {
  final j = world.toJson();
  final time = j.remove('t');
  return jsonEncode({'t': Msg.world, worldTimeKey: time, ...j});
}

String encodeCase(CaseView view) => jsonEncode({'t': Msg.caseView, ...view.toJson()});

String encodeEvents(List<GameEvent> events) =>
    jsonEncode({'t': Msg.events, 'list': [for (final e in events) e.toJson()]});

/// Gegenstück zu [encodeWorld].
WorldSnapshot decodeWorld(Map<String, dynamic> msg) => WorldSnapshot.fromJson({...msg, 't': msg[worldTimeKey] ?? 0});

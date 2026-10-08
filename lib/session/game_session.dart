import 'package:flutter/foundation.dart';
import 'package:mordakte_core/mordakte_core.dart';

/// Verbindung der App zu einem Spielraum – offline ([LocalSession]) oder
/// online ([OnlineSession]). UI und Flame-Szene sprechen nur mit diesem Interface.
abstract class GameSession {
  /// Eigene Spieler-ID.
  String get playerId;

  /// Raumcode (online) bzw. `SOLO`.
  String get roomCode;

  bool get isOnline;

  /// Positionen & Lebenswerte (~10 Hz). Die Flame-Szene liest `.value` direkt.
  ValueListenable<WorldSnapshot?> get world;

  /// Fall-Zustand, ändert sich nur bei Spiel-Logik.
  ValueListenable<CaseView?> get caseView;

  /// Ereignisse für Toasts, Dialoge, Haptik.
  Stream<GameEvent> get events;

  /// Verbindungsstatus (online); offline immer `true`.
  ValueListenable<bool> get connected;

  /// Alle bekannten Szenarien (für Lobby-Auswahl und Texte).
  Map<String, ScenarioDef> get scenarios;

  /// Das aktuell gespielte Szenario (aus `caseView.scenarioId`).
  ScenarioDef? get scenario {
    final id = caseView.value?.scenarioId;
    return id == null ? null : scenarios[id];
  }

  /// Eigene Position melden (Client besitzt seine Position). Höchstens ~15× pro Sekunde.
  void move(double x, double y, double facing);

  void send(Command command);

  Future<void> dispose();
}

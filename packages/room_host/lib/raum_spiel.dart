/// Schnittstelle eines Spiels, das ein [RaumHost] hostet – ohne `dart:io`, damit auch
/// Spiele im Web sie umsetzen können.
library;

/// Ein Spiel in einem Raum. Alle Nachrichten sind JSON-Objekte.
abstract interface class RaumSpiel {
  /// Neuer Teilnehmer; `false` = abgelehnt (z. B. Raum voll, Partie läuft).
  bool beitreten(String spielerId, String name);

  void verlassen(String spielerId);

  /// Verbindung des Spielers steht wieder ([ja]) oder ist weg.
  void verbunden(String spielerId, bool ja);

  /// Nachricht des Spielers (Inhalt bestimmt das Spiel).
  void nachricht(String spielerId, Map<String, Object?> inhalt);

  /// Zeitschritt in Sekunden.
  void tick(double dt);

  /// Aktueller Zustand aus Sicht des Spielers (regelmäßig gesendet).
  Map<String, Object?> zustandFuer(String spielerId);

  /// Neue Ereignisse für den Spieler seit dem letzten Abholen (sofort gesendet).
  List<Map<String, Object?>> ereignisseFuer(String spielerId);

  /// Partie beendet (Raum darf geschlossen werden).
  bool get beendet;
}

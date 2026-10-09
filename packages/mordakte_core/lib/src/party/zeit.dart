/// Spielwelt-Uhrzeit für den Partymodus.
///
/// Der Abend läuft über Mitternacht. Damit Vergleiche einfach bleiben, rechnet
/// [Uhrzeit] in Sekunden seit 12:00 Uhr mittags: 12:00 = 0, 23:58:40 = 43120,
/// 0:00:00 = 43200, 7:00 = 68400.
class Uhrzeit implements Comparable<Uhrzeit> {
  /// Sekunden seit 12:00 Uhr mittags.
  final int sekunden;

  const Uhrzeit(this.sekunden);

  /// Liest `HH:MM` oder `HH:MM:SS`. Stunden 12–23 gehören zum Abend, 0–11 zur Nacht danach.
  factory Uhrzeit.parse(String s) {
    final m = _muster.firstMatch(s.trim());
    if (m == null) throw FormatException('Ungültige Uhrzeit: "$s"');
    final h = int.parse(m.group(1)!);
    final min = int.parse(m.group(2)!);
    final sek = m.group(3) == null ? 0 : int.parse(m.group(3)!);
    if (h > 23 || min > 59 || sek > 59) throw FormatException('Ungültige Uhrzeit: "$s"');
    final tag = h * 3600 + min * 60 + sek;
    return Uhrzeit(h >= 12 ? tag - 12 * 3600 : tag + 12 * 3600);
  }

  static final _muster = RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$');

  static bool istGueltig(String s) {
    try {
      Uhrzeit.parse(s);
      return true;
    } on FormatException {
      return false;
    }
  }

  Uhrzeit plus(int s) => Uhrzeit(sekunden + s);

  int minus(Uhrzeit o) => sekunden - o.sekunden;

  bool operator <(Uhrzeit o) => sekunden < o.sekunden;
  bool operator <=(Uhrzeit o) => sekunden <= o.sekunden;
  bool operator >(Uhrzeit o) => sekunden > o.sekunden;
  bool operator >=(Uhrzeit o) => sekunden >= o.sekunden;

  @override
  int compareTo(Uhrzeit other) => sekunden.compareTo(other.sekunden);

  @override
  bool operator ==(Object other) => other is Uhrzeit && other.sekunden == sekunden;

  @override
  int get hashCode => sekunden.hashCode;

  /// Immer `HH:MM:SS`, auch bei vollen Minuten (laufende Uhr der Rückblende).
  String get mitSekunden {
    final tag = (sekunden + 12 * 3600) % (24 * 3600);
    String zz(int v) => v.toString().padLeft(2, '0');
    return '${zz(tag ~/ 3600)}:${zz((tag % 3600) ~/ 60)}:${zz(tag % 60)}';
  }

  /// `HH:MM:SS` (ohne Sekunden, wenn sie 0 sind).
  @override
  String toString() {
    final tag = (sekunden + 12 * 3600) % (24 * 3600);
    final h = tag ~/ 3600, m = (tag % 3600) ~/ 60, s = tag % 60;
    String zz(int v) => v.toString().padLeft(2, '0');
    return s == 0 ? '${zz(h)}:${zz(m)}' : '${zz(h)}:${zz(m)}:${zz(s)}';
  }
}

/// Halboffenes Zeitfenster [von, bis).
class Zeitfenster {
  final Uhrzeit von;
  final Uhrzeit bis;

  const Zeitfenster(this.von, this.bis);

  factory Zeitfenster.parse(List<Object?> paar) =>
      Zeitfenster(Uhrzeit.parse(paar[0] as String), Uhrzeit.parse(paar[1] as String));

  bool enthaelt(Uhrzeit t) => t >= von && t < bis;

  @override
  String toString() => '$von–$bis';
}

import '../util/rng.dart';

/// Fall-Code: kurzer Startwert, aus dem der Täter-Pfad und alle
/// Zufallsentscheidungen folgen (Master §6). Gleicher Code, gleicher Fall.
class FallCode {
  /// Ohne leicht verwechselbare Zeichen (0/O, 1/I, 2/Z, 5/S, 8/B, 6/G).
  static const alphabet = 'ACDEFHJKLMNPRTUVWXY3479';
  static const laenge = 5;

  final String code;
  FallCode._(this.code);

  /// Liest einen eingegebenen Code; Klein- und Leerzeichen sind erlaubt.
  static FallCode? lesen(String eingabe) {
    final c = eingabe.toUpperCase().replaceAll(RegExp(r'[\s-]'), '');
    if (c.length != laenge) return null;
    for (final z in c.split('')) {
      if (!alphabet.contains(z)) return null;
    }
    return FallCode._(c);
  }

  /// Ein neuer Code aus [rng].
  factory FallCode.zufall(Rng rng) => FallCode._([for (var i = 0; i < laenge; i++) alphabet[rng.nextInt(alphabet.length)]].join());

  /// Startwert des Falls.
  int get seed => Rng.hashString('schlosskeller:$code');

  /// Zufallsgenerator für alle Entscheidungen dieses Falls.
  Rng rng() => Rng(seed);

  /// Täter-Pfad: der erste Zug des Generators.
  String pfad(List<String> pfade) => pfade[rng().nextInt(pfade.length)];

  /// Der erste Code in fester Reihenfolge, der [ziel] ergibt (für Testläufe
  /// der Spielleitung und die E2E-Läufe).
  static FallCode fuerPfad(String ziel, List<String> pfade) {
    final rng = Rng(Rng.hashString('fuerPfad:$ziel'));
    for (var i = 0; i < 10000; i++) {
      final c = FallCode.zufall(rng);
      if (c.pfad(pfade) == ziel) return c;
    }
    throw StateError('kein Code für $ziel');
  }

  @override
  String toString() => code;

  @override
  bool operator ==(Object other) => other is FallCode && other.code == code;

  @override
  int get hashCode => code.hashCode;
}

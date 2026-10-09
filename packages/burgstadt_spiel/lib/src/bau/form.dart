import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

/// Ort einer Möbel- oder Objektform im Bereich (Burgstadt HD, P1-OPUS-01): Grundfläche in Metern
/// (schon um 0,04 m eingerückt), Höhe, Textur, Licht und eine stabile Kennung für Varianten.
class FormOrt {
  const FormOrt({
    required this.ding,
    required this.bereichId,
    required this.x0,
    required this.z0,
    required this.x1,
    required this.z1,
    required this.hoehe,
    required this.textur,
    required this.warm,
    required this.kalt,
  });

  final Ding ding;
  final String bereichId;
  final double x0, z0, x1, z1, hoehe;
  final int textur;
  final double warm, kalt;

  double get breite => x1 - x0;
  double get tiefe => z1 - z0;

  /// Kennung für [hashTeil]: Bereich und Kachel des Dings.
  String get kennung => '$bereichId|${ding.x0}|${ding.z0}';

  /// Deterministische Variante für Teil [teil] dieser Form (nie der Zufall des Stadtgenerators).
  int hash(int teil) => hashTeil(kennung, teil);
}

/// Eine Möbel- oder Objektform ([Moebelform]): Geometrie innerhalb der Grundfläche des Dings. Karte, Kollision,
/// Marken und Stationen bleiben die des Dings – die Form ist reine Darstellung (P5 des Kerns).
abstract interface class Moebelform {
  /// Name wie `legende.form` in den Daten (z. B. `tisch`).
  String get name;

  void baue(MeshBuilder m, FormOrt o);
}

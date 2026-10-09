import '../form.dart';
import 'bank.dart';
import 'bett.dart';
import 'stuhl.dart';
import 'tisch.dart';

/// Register der Möbel- und Objektformen nach Name (E-010). Jede Form liegt in einer eigenen Datei
/// unter `bau/formen/`; Formen ohne Eintrag zeichnet der Bestand (Quader).
final Map<String, Moebelform> kFormen = {
  for (final f in const <Moebelform>[BankForm(), BettForm(), StuhlForm(), TischForm()]) f.name: f,
};

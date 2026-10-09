import 'package:burgstadt_spiel/burgstadt_spiel.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Spielstand der Burgstadt in `shared_preferences` (bereits Abhängigkeit des Bestands).
class PrefsSpielstand implements Spielstand {
  static const _schluessel = 'burgstadt_spielstand_v1';

  @override
  Future<String?> lade() async => (await SharedPreferences.getInstance()).getString(_schluessel);

  @override
  Future<void> speichere(String json) async => (await SharedPreferences.getInstance()).setString(_schluessel, json);

  @override
  Future<void> loesche() async => (await SharedPreferences.getInstance()).remove(_schluessel);
}

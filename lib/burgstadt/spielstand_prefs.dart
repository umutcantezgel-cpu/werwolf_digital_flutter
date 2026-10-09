import 'dart:convert';

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

/// Optionen der Burgstadt in `shared_preferences`.
abstract final class PrefsOptionen {
  static const _schluessel = 'burgstadt_optionen_v1';

  static Future<void> lade(Optionen o) async {
    final t = (await SharedPreferences.getInstance()).getString(_schluessel);
    if (t == null) return;
    try {
      o.ausJson(jsonDecode(t) as Map<String, dynamic>);
    } catch (_) {
      // beschädigter Eintrag: Standardwerte behalten
    }
  }

  static Future<void> speichere(Optionen o) async =>
      (await SharedPreferences.getInstance()).setString(_schluessel, jsonEncode(o.zuJson()));
}

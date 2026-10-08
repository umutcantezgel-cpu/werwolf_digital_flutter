import 'package:shared_preferences/shared_preferences.dart';

/// Speicher-Schlüssel des Tokens.
const tokenKey = 'mordakte_token';

/// Speicher-Schlüssel des zuletzt betretenen Online-Raums (Rückkehr nach Neustart).
const roomKey = 'mordakte_room';

Future<String?> loadToken() async => (await SharedPreferences.getInstance()).getString(tokenKey);

Future<void> saveToken(String token) async {
  await (await SharedPreferences.getInstance()).setString(tokenKey, token);
}

Future<String?> loadRoom() async => (await SharedPreferences.getInstance()).getString(roomKey);

Future<void> saveRoom(String code) async {
  await (await SharedPreferences.getInstance()).setString(roomKey, code);
}

Future<void> clearRoom() async {
  await (await SharedPreferences.getInstance()).remove(roomKey);
}

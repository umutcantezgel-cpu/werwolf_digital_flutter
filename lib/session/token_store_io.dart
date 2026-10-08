import 'package:shared_preferences/shared_preferences.dart';

/// Speicher-Schlüssel des Tokens.
const tokenKey = 'mordakte_token';

Future<String?> loadToken() async => (await SharedPreferences.getInstance()).getString(tokenKey);

Future<void> saveToken(String token) async {
  await (await SharedPreferences.getInstance()).setString(tokenKey, token);
}

import 'dart:js_interop';

/// Speicher-Schlüssel des Tokens.
const tokenKey = 'mordakte_token';

@JS('sessionStorage')
external _Storage get _sessionStorage;

extension type _Storage._(JSObject _) implements JSObject {
  external String? getItem(String key);
  external void setItem(String key, String value);
}

/// Pro Tab (überlebt Neuladen; „Tab duplizieren“ kopiert es allerdings mit).
Future<String?> loadToken() async {
  try {
    return _sessionStorage.getItem(tokenKey);
  } catch (_) {
    return null;
  }
}

Future<void> saveToken(String token) async {
  try {
    _sessionStorage.setItem(tokenKey, token);
  } catch (_) {}
}

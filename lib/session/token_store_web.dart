import 'dart:js_interop';

/// Speicher-Schlüssel des Tokens.
const tokenKey = 'mordakte_token';

/// Speicher-Schlüssel des zuletzt betretenen Online-Raums (Rückkehr nach Neuladen).
const roomKey = 'mordakte_room';

@JS('window.sessionStorage.getItem')
external String? _getItem(String key);

@JS('window.sessionStorage.setItem')
external void _setItem(String key, String value);

@JS('window.sessionStorage.removeItem')
external void _removeItem(String key);

String? _get(String key) {
  try {
    return _getItem(key);
  } catch (_) {
    return null;
  }
}

void _set(String key, String value) {
  try {
    _setItem(key, value);
  } catch (_) {}
}

/// Pro Tab (überlebt Neuladen; „Tab duplizieren“ kopiert es allerdings mit).
Future<String?> loadToken() async => _get(tokenKey);

Future<void> saveToken(String token) async => _set(tokenKey, token);

/// Raumcode pro Tab, gehört zum Token desselben Tabs.
Future<String?> loadRoom() async => _get(roomKey);

Future<void> saveRoom(String code) async => _set(roomKey, code);

Future<void> clearRoom() async {
  try {
    _removeItem(roomKey);
  } catch (_) {}
}

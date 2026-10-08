/// Raumcodes, Spieler-IDs und Tokens.
library;

import 'dart:math';

/// Eindeutig lesbares Alphabet: ohne 0/O und 1/I.
const roomCodeAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
const roomCodeLength = 4;

const _idAlphabet = 'abcdefghijkmnpqrstuvwxyz23456789';
const _hex = '0123456789abcdef';

String _pick(Random rng, String alphabet, int length) {
  final buf = StringBuffer();
  for (var i = 0; i < length; i++) {
    buf.write(alphabet[rng.nextInt(alphabet.length)]);
  }
  return buf.toString();
}

/// Zufälliger Raumcode, z. B. `KX4T`.
String randomRoomCode(Random rng) => _pick(rng, roomCodeAlphabet, roomCodeLength);

/// Normalisiert eine Benutzereingabe (Großbuchstaben, ohne Leerzeichen).
/// Gibt `null` zurück, wenn es kein gültiger Raumcode sein kann.
String? normalizeRoomCode(Object? raw) {
  if (raw is! String) return null;
  final code = raw.replaceAll(RegExp(r'\s'), '').toUpperCase();
  if (code.length != roomCodeLength) return null;
  for (final ch in code.split('')) {
    if (!roomCodeAlphabet.contains(ch)) return null;
  }
  return code;
}

/// Neue Spieler-ID, z. B. `p_k3mz8q2xha`.
String newPlayerId(Random rng) => 'p_${_pick(rng, _idAlphabet, 10)}';

/// Geheimes Wiederverbindungs-Token (128 Bit, hex).
String newToken(Random rng) {
  final buf = StringBuffer();
  for (var i = 0; i < 16; i++) {
    final b = rng.nextInt(256);
    buf
      ..write(_hex[b >> 4])
      ..write(_hex[b & 0xf]);
  }
  return buf.toString();
}

/// Plausibilitätsprüfung für Tokens aus `hello`.
bool isWellFormedToken(Object? token) => token is String && RegExp(r'^[0-9a-f]{32}$').hasMatch(token);

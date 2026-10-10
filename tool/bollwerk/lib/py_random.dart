// Nachbau von Pythons `random.Random` (MT19937, CPython 3.x) und SHA-256 für den
// Simulator-Port (Master-Prompt §8 V: „gleiche Zahlen am gleichen Seed-Satz“ wie
// planung/bollwerk/proben/wuerfel_sim.py). Nur Werkzeug, nie Spiellogik (WÜ-1).
import 'dart:convert';
import 'dart:typed_data';

class PyRandom {
  final Uint32List _mt = Uint32List(624);
  int _i = 625;

  PyRandom(int seed) {
    var s = seed < 0 ? -seed : seed;
    final key = <int>[];
    if (s == 0) key.add(0);
    while (s > 0) {
      key.add(s & 0xFFFFFFFF);
      s >>= 32;
    }
    _initByArray(key);
  }

  void _initGenrand(int s) {
    _mt[0] = s;
    for (var i = 1; i < 624; i++) {
      final prev = _mt[i - 1] ^ (_mt[i - 1] >> 30);
      _mt[i] = (_mul32(1812433253, prev) + i) & 0xFFFFFFFF;
    }
    _i = 624;
  }

  void _initByArray(List<int> key) {
    _initGenrand(19650218);
    var i = 1, j = 0;
    for (var k = 624 > key.length ? 624 : key.length; k > 0; k--) {
      final prev = _mt[i - 1] ^ (_mt[i - 1] >> 30);
      _mt[i] = ((_mt[i] ^ _mul32(prev, 1664525)) + key[j] + j) & 0xFFFFFFFF;
      i++;
      j++;
      if (i >= 624) {
        _mt[0] = _mt[623];
        i = 1;
      }
      if (j >= key.length) j = 0;
    }
    for (var k = 623; k > 0; k--) {
      final prev = _mt[i - 1] ^ (_mt[i - 1] >> 30);
      _mt[i] = ((_mt[i] ^ _mul32(prev, 1566083941)) - i) & 0xFFFFFFFF;
      i++;
      if (i >= 624) {
        _mt[0] = _mt[623];
        i = 1;
      }
    }
    _mt[0] = 0x80000000;
  }

  static int _mul32(int a, int b) {
    final aHi = (a >> 16) & 0xFFFF, aLo = a & 0xFFFF;
    return ((aLo * b) + (((aHi * b) & 0xFFFF) << 16)) & 0xFFFFFFFF;
  }

  int genrand() {
    if (_i >= 624) {
      for (var k = 0; k < 624; k++) {
        final y = (_mt[k] & 0x80000000) | (_mt[(k + 1) % 624] & 0x7fffffff);
        _mt[k] = _mt[(k + 397) % 624] ^ (y >> 1) ^ ((y & 1) != 0 ? 0x9908b0df : 0);
      }
      _i = 0;
    }
    var y = _mt[_i++];
    y ^= y >> 11;
    y ^= (y << 7) & 0x9d2c5680;
    y ^= (y << 15) & 0xefc60000;
    y ^= y >> 18;
    return y & 0xFFFFFFFF;
  }

  /// `random()`: 53-Bit-Gleitkommazahl in [0, 1).
  double random() {
    final a = genrand() >> 5, b = genrand() >> 6;
    return (a * 67108864.0 + b) * (1.0 / 9007199254740992.0);
  }

  int getrandbits(int k) => genrand() >> (32 - k); // k ≤ 32

  int randbelow(int n) {
    final k = n.bitLength;
    var r = getrandbits(k);
    while (r >= n) {
      r = getrandbits(k);
    }
    return r;
  }

  int randint(int a, int b) => a + randbelow(b - a + 1);

  T choice<T>(List<T> l) => l[randbelow(l.length)];

  void shuffle<T>(List<T> l) {
    for (var i = l.length - 1; i > 0; i--) {
      final j = randbelow(i + 1);
      final t = l[i];
      l[i] = l[j];
      l[j] = t;
    }
  }

  /// `sample(population, k)` (CPython 3.11+), gleiche Auswahlreihenfolge.
  List<T> sample<T>(List<T> pop, int k) {
    final n = pop.length;
    var setsize = 21;
    if (k > 5) {
      var p = 1, e = 0;
      while (p < 3 * k) {
        p *= 4;
        e++;
      }
      setsize += 1 << (2 * e);
    }
    final aus = <T>[];
    if (n <= setsize) {
      final pool = List.of(pop);
      for (var i = 0; i < k; i++) {
        final j = randbelow(n - i);
        aus.add(pool[j]);
        pool[j] = pool[n - i - 1];
      }
    } else {
      final gew = <int>{};
      for (var i = 0; i < k; i++) {
        var j = randbelow(n);
        while (gew.contains(j)) {
          j = randbelow(n);
        }
        gew.add(j);
        aus.add(pop[j]);
      }
    }
    return aus;
  }
}

/// SHA-256 (FIPS 180-4) über UTF-8, als Hex.
String sha256Hex(String text) => sha256Bytes(utf8.encode(text)).map((b) => b.toRadixString(16).padLeft(2, '0')).join();

List<int> sha256Bytes(List<int> daten) {
  const k = [
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
  ];
  final h = [0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19];
  final m = List<int>.of(daten)..add(0x80);
  while (m.length % 64 != 56) {
    m.add(0);
  }
  final bits = daten.length * 8;
  for (var i = 7; i >= 0; i--) {
    m.add((bits >> (8 * i)) & 0xFF);
  }
  int rotr(int x, int n) => ((x >> n) | (x << (32 - n))) & 0xFFFFFFFF;
  final w = List<int>.filled(64, 0);
  for (var c = 0; c < m.length; c += 64) {
    for (var i = 0; i < 16; i++) {
      w[i] = (m[c + 4 * i] << 24) | (m[c + 4 * i + 1] << 16) | (m[c + 4 * i + 2] << 8) | m[c + 4 * i + 3];
    }
    for (var i = 16; i < 64; i++) {
      final s0 = rotr(w[i - 15], 7) ^ rotr(w[i - 15], 18) ^ (w[i - 15] >> 3);
      final s1 = rotr(w[i - 2], 17) ^ rotr(w[i - 2], 19) ^ (w[i - 2] >> 10);
      w[i] = (w[i - 16] + s0 + w[i - 7] + s1) & 0xFFFFFFFF;
    }
    var a = h[0], b = h[1], cc = h[2], d = h[3], e = h[4], f = h[5], g = h[6], hh = h[7];
    for (var i = 0; i < 64; i++) {
      final s1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25);
      final ch = (e & f) ^ ((~e & 0xFFFFFFFF) & g);
      final t1 = (hh + s1 + ch + k[i] + w[i]) & 0xFFFFFFFF;
      final s0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22);
      final maj = (a & b) ^ (a & cc) ^ (b & cc);
      final t2 = (s0 + maj) & 0xFFFFFFFF;
      hh = g;
      g = f;
      f = e;
      e = (d + t1) & 0xFFFFFFFF;
      d = cc;
      cc = b;
      b = a;
      a = (t1 + t2) & 0xFFFFFFFF;
    }
    h[0] = (h[0] + a) & 0xFFFFFFFF;
    h[1] = (h[1] + b) & 0xFFFFFFFF;
    h[2] = (h[2] + cc) & 0xFFFFFFFF;
    h[3] = (h[3] + d) & 0xFFFFFFFF;
    h[4] = (h[4] + e) & 0xFFFFFFFF;
    h[5] = (h[5] + f) & 0xFFFFFFFF;
    h[6] = (h[6] + g) & 0xFFFFFFFF;
    h[7] = (h[7] + hh) & 0xFFFFFFFF;
  }
  return [for (final x in h) for (var i = 3; i >= 0; i--) (x >> (8 * i)) & 0xFF];
}

/// Partie-Seed wie `seed(*teile)` im Python-Simulator: erste 8 Hex von sha256("a|b|…").
int pySeed(List<Object> teile) => int.parse(sha256Hex(teile.join('|')).substring(0, 8), radix: 16);

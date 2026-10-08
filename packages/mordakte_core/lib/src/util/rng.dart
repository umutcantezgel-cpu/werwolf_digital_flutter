/// Deterministischer 32-Bit-Zufallsgenerator (mulberry32).
///
/// `dart:math` `Random(seed)` liefert nicht auf allen Plattformen (VM, Web)
/// dieselbe Folge. Der Fall des Tages muss aber auf jedem Gerät identisch sein.
class Rng {
  int _state;

  Rng(int seed) : _state = seed & 0xFFFFFFFF;

  int get state => _state;

  /// Nächste vorzeichenlose 32-Bit-Zahl.
  int nextUint32() {
    _state = (_state + 0x6D2B79F5) & 0xFFFFFFFF;
    var t = _state;
    t = _imul(t ^ (t >> 15), t | 1);
    t ^= (t + _imul(t ^ (t >> 7), t | 61)) & 0xFFFFFFFF;
    return (t ^ (t >> 14)) & 0xFFFFFFFF;
  }

  /// Gleichverteilt in [0, max).
  int nextInt(int max) {
    if (max <= 0) return 0;
    return nextUint32() % max;
  }

  /// Gleichverteilt in [0, 1).
  double nextDouble() => nextUint32() / 4294967296.0;

  bool chance(double p) => nextDouble() < p;

  T pick<T>(List<T> list) => list[nextInt(list.length)];

  void shuffle<T>(List<T> list) {
    for (var i = list.length - 1; i > 0; i--) {
      final j = nextInt(i + 1);
      final tmp = list[i];
      list[i] = list[j];
      list[j] = tmp;
    }
  }

  /// 32-Bit-Multiplikation ohne Überlauf in den 53-Bit-Bereich (Web-sicher).
  static int _imul(int a, int b) {
    final aHi = (a >> 16) & 0xFFFF;
    final aLo = a & 0xFFFF;
    final bHi = (b >> 16) & 0xFFFF;
    final bLo = b & 0xFFFF;
    return ((aLo * bLo) + ((((aHi * bLo) + (aLo * bHi)) & 0xFFFF) << 16)) &
        0xFFFFFFFF;
  }

  /// Stabiler Hash eines Strings (FNV-1a), z. B. für Seeds aus Datum + Szenario.
  static int hashString(String s) {
    var h = 0x811C9DC5;
    for (final c in s.codeUnits) {
      h ^= c;
      h = _imul(h, 0x01000193);
    }
    return h & 0xFFFFFFFF;
  }
}

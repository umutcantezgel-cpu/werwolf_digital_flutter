/// Deterministischer 32-Bit-Zufall (xorshift32) – gleiche Folge auf VM und im Web.
class Zufall {
  int _x;
  Zufall(int seed) : _x = (seed & 0xffffffff) == 0 ? 0x9E3779B9 : seed & 0xffffffff;

  int naechste() {
    var x = _x;
    x ^= (x << 13) & 0xffffffff;
    x ^= x >> 17;
    x ^= (x << 5) & 0xffffffff;
    _x = x & 0xffffffff;
    return _x;
  }

  /// 0 ≤ Ergebnis < [n].
  int ganz(int n) => naechste() % n;

  /// 0 ≤ Ergebnis < 1.
  double kommazahl() => naechste() / 4294967296.0;

  bool chance(double p) => kommazahl() < p;

  T waehle<T>(List<T> l) => l[ganz(l.length)];
}

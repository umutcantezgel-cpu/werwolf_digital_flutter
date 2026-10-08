import 'dart:math' as math;

/// Kachel-Koordinaten (x = Spalte nach Osten, y = Zeile nach Süden).
class Pt {
  final int x;
  final int y;
  const Pt(this.x, this.y);

  @override
  bool operator ==(Object other) => other is Pt && other.x == x && other.y == y;

  @override
  int get hashCode => x * 73856093 ^ y * 19349663;

  @override
  String toString() => '($x,$y)';

  List<int> toJson() => [x, y];

  static Pt fromJson(Object? j) {
    final l = j as List;
    return Pt((l[0] as num).toInt(), (l[1] as num).toInt());
  }
}

double dist(double ax, double ay, double bx, double by) {
  final dx = ax - bx;
  final dy = ay - by;
  return math.sqrt(dx * dx + dy * dy);
}

double clampD(double v, double lo, double hi) => v < lo ? lo : (v > hi ? hi : v);

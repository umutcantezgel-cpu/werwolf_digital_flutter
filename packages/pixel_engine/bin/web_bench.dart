import 'package:pixel_engine/pixel_engine.dart';

/// Browser-Variante des Benchmarks (dart2js / wasm), Ausgabe über die Konsole.
void main() {
  for (final s in const [
    [240, 135],
    [320, 180],
    [384, 216],
  ]) {
    print('BENCH ${runBenchmark(s[0], s[1], 240).report}');
  }
  print('BENCH FERTIG');
}

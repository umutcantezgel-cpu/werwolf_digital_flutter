import 'dart:math' as math;
import 'dart:typed_data';

import '../lighting.dart';
import '../pixel_buffer.dart';
import '../raster/renderer.dart';
import 'demo_scene.dart';

class BenchmarkResult {
  final int width, height, frames;
  final double avgMs, p95Ms, maxMs;
  final String stats;
  final Uint8List lastFrame;
  BenchmarkResult(this.width, this.height, this.frames, this.avgMs, this.p95Ms, this.maxMs, this.stats, this.lastFrame);

  String get report =>
      'Rasterer ${width}x$height · $frames Bilder · Mittel ${avgMs.toStringAsFixed(2)} ms · '
      'p95 ${p95Ms.toStringAsFixed(2)} ms · max ${maxMs.toStringAsFixed(2)} ms · '
      '${(1000 / avgMs).toStringAsFixed(0)} fps · $stats';
}

/// Rendert [frames] Bilder eines Rundgangs durch die Prüfszene (inkl. RGBA-Wandlung).
BenchmarkResult runBenchmark(int w, int h, int frames, {double Function()? nowMs}) {
  final sw = Stopwatch()..start();
  final now = nowMs ?? () => sw.elapsedMicroseconds / 1000.0;
  final scene = DemoScene.build();
  final fb = PixelBuffer(w, h);
  final rgba = Uint8List(w * h * 4);
  final r = Renderer(fb, LightTable.nacht, scene.textures);
  r.flashStrength = 0.9;
  final times = <double>[];
  for (var f = 0; f < frames; f++) {
    final t0 = now();
    final a = f / frames * math.pi * 2;
    r.camera
      ..x = math.cos(a) * 6
      ..z = math.sin(a) * 6
      ..y = 1.6
      ..yaw = a + math.pi / 2 + 0.6 * math.sin(a * 3)
      ..pitch = -0.08 + 0.1 * math.sin(a * 2);
    r.begin();
    r.drawSky();
    for (final m in scene.meshes) {
      r.drawMesh(m);
    }
    fb.toRgba(rgba);
    times.add(now() - t0);
  }
  final sorted = [...times]..sort();
  // Erste 10 Bilder (Aufwärmen/JIT) nicht mitzählen
  final warm = times.length > 20 ? times.sublist(10) : times;
  final avg = warm.reduce((a, b) => a + b) / warm.length;
  return BenchmarkResult(w, h, frames, avg, sorted[(sorted.length * 0.95).floor().clamp(0, sorted.length - 1)],
      sorted.last, r.stats.toString(), rgba);
}

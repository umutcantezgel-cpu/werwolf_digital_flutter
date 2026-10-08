import 'dart:io';

import 'package:pixel_engine/pixel_engine.dart';

/// Go/No-Go-Messung des Software-Rasterers.
/// `dart run bin/benchmark.dart [breite höhe bilder png]`
void main(List<String> args) {
  final w = args.isNotEmpty ? int.parse(args[0]) : 320;
  final h = args.length > 1 ? int.parse(args[1]) : 180;
  final frames = args.length > 2 ? int.parse(args[2]) : 300;
  final png = args.length > 3 ? args[3] : null;
  final r = runBenchmark(w, h, frames);
  stdout.writeln(r.report);
  if (png != null) {
    File(png).writeAsBytesSync(encodePngRgba(w, h, r.lastFrame));
    stdout.writeln('Bild: $png');
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:pixel_engine/pixel_engine.dart';

/// Pixelprüfung (Ebene 5) für Bildschirmfotos aus dem Browser:
/// `dart run bin/pixel_pruef.dart <bild.png> <k> [x y w h]`
/// Prüft Palette (nur Palettenfarben) und Blocktest im Raster k.
void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln('Aufruf: pixel_pruef.dart <bild.png> <k> [x y w h]');
    exit(2);
  }
  final (w, h, rgba) = dekodierePng(File(args[0]).readAsBytesSync());
  final k = int.parse(args[1]);
  final ox = args.length > 5 ? int.parse(args[2]) : 0, oy = args.length > 5 ? int.parse(args[3]) : 0;
  final aw = args.length > 5 ? int.parse(args[4]) : (w - ox) ~/ k * k;
  final ah = args.length > 5 ? int.parse(args[5]) : (h - oy) ~/ k * k;
  final off = countOffPalette(rgba);
  final b = blockTest(rgba, w, h, k, ox: ox, oy: oy, areaW: aw, areaH: ah);
  stdout.writeln('${args[0]} · ${w}x$h · Palette: ${off == 0 ? 'OK' : '$off Pixel außerhalb'} · Block ×$k: $b');
  exit(off == 0 && b.ratio == 1 ? 0 : 1);
}

/// Minimaler PNG-Dekoder (8 Bit RGB/RGBA, ohne Interlace) über dart:io-zlib.
(int, int, Uint8List) dekodierePng(Uint8List d) {
  var p = 8;
  int u32(int i) => (d[i] << 24) | (d[i + 1] << 16) | (d[i + 2] << 8) | d[i + 3];
  var w = 0, h = 0, typ = 0;
  final idat = BytesBuilder();
  while (p < d.length) {
    final len = u32(p);
    final t = String.fromCharCodes(d.sublist(p + 4, p + 8));
    final daten = d.sublist(p + 8, p + 8 + len);
    if (t == 'IHDR') {
      w = u32(p + 8);
      h = u32(p + 12);
      if (daten[8] != 8 || daten[12] != 0) throw const FormatException('nur 8 Bit ohne Interlace');
      typ = daten[9];
    } else if (t == 'IDAT') {
      idat.add(daten);
    }
    p += 12 + len;
  }
  final bpp = typ == 6 ? 4 : (typ == 2 ? 3 : throw const FormatException('nur RGB/RGBA'));
  final roh = Uint8List.fromList(zlib.decode(idat.toBytes()));
  final stride = w * bpp;
  final out = Uint8List(w * h * 4);
  var vor = Uint8List(stride);
  for (var y = 0; y < h; y++) {
    final f = roh[y * (stride + 1)];
    final z = Uint8List.sublistView(roh, y * (stride + 1) + 1, y * (stride + 1) + 1 + stride);
    final cur = Uint8List(stride);
    for (var i = 0; i < stride; i++) {
      final a = i >= bpp ? cur[i - bpp] : 0, b = vor[i], c = i >= bpp ? vor[i - bpp] : 0;
      final pr = switch (f) {
        0 => 0,
        1 => a,
        2 => b,
        3 => (a + b) >> 1,
        4 => _paeth(a, b, c),
        _ => throw FormatException('Filter $f'),
      };
      cur[i] = (z[i] + pr) & 0xFF;
    }
    for (var x = 0; x < w; x++) {
      out[(y * w + x) * 4] = cur[x * bpp];
      out[(y * w + x) * 4 + 1] = cur[x * bpp + 1];
      out[(y * w + x) * 4 + 2] = cur[x * bpp + 2];
      out[(y * w + x) * 4 + 3] = bpp == 4 ? cur[x * bpp + 3] : 255;
    }
    vor = cur;
  }
  return (w, h, out);
}

int _paeth(int a, int b, int c) {
  final p = a + b - c;
  final pa = (p - a).abs(), pb = (p - b).abs(), pc = (p - c).abs();
  if (pa <= pb && pa <= pc) return a;
  if (pb <= pc) return b;
  return c;
}

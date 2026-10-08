import 'dart:typed_data';

/// Minimaler PNG-Encoder (RGBA8, unkomprimierte Deflate-Blöcke) in reinem Dart –
/// web-tauglich, ohne Abhängigkeiten. Für Belegbilder und Tests.
Uint8List encodePngRgba(int width, int height, Uint8List rgba) {
  // Rohdaten mit Filterbyte 0 pro Zeile.
  final stride = width * 4;
  final raw = Uint8List((stride + 1) * height);
  for (var y = 0; y < height; y++) {
    raw[y * (stride + 1)] = 0;
    raw.setRange(y * (stride + 1) + 1, (y + 1) * (stride + 1), rgba, y * stride);
  }
  final zlib = _zlibStored(raw);
  final out = BytesBuilder();
  out.add(const [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
  final ihdr = ByteData(13)
    ..setUint32(0, width)
    ..setUint32(4, height)
    ..setUint8(8, 8)
    ..setUint8(9, 6)
    ..setUint8(10, 0)
    ..setUint8(11, 0)
    ..setUint8(12, 0);
  _chunk(out, 'IHDR', ihdr.buffer.asUint8List());
  _chunk(out, 'IDAT', zlib);
  _chunk(out, 'IEND', Uint8List(0));
  return out.toBytes();
}

/// Liest ein PNG, das [encodePngRgba] geschrieben hat (oder beliebige 8-Bit-RGBA/RGB-PNGs
/// ohne Kompression nicht – nur für eigene Dateien gedacht).
Uint8List _zlibStored(Uint8List data) {
  final b = BytesBuilder();
  b.add(const [0x78, 0x01]);
  var pos = 0;
  while (pos < data.length) {
    final len = (data.length - pos) > 65535 ? 65535 : data.length - pos;
    final last = pos + len >= data.length;
    b.addByte(last ? 1 : 0);
    b.addByte(len & 0xFF);
    b.addByte((len >> 8) & 0xFF);
    b.addByte((~len) & 0xFF);
    b.addByte(((~len) >> 8) & 0xFF);
    b.add(Uint8List.sublistView(data, pos, pos + len));
    pos += len;
  }
  if (data.isEmpty) b.add(const [1, 0, 0, 0xFF, 0xFF]);
  var a = 1, s = 0;
  for (final v in data) {
    a = (a + v) % 65521;
    s = (s + a) % 65521;
  }
  final ad = (s << 16) | a;
  b.add([(ad >> 24) & 0xFF, (ad >> 16) & 0xFF, (ad >> 8) & 0xFF, ad & 0xFF]);
  return b.toBytes();
}

void _chunk(BytesBuilder out, String type, Uint8List data) {
  final len = ByteData(4)..setUint32(0, data.length);
  out.add(len.buffer.asUint8List());
  final td = Uint8List.fromList(type.codeUnits);
  out.add(td);
  out.add(data);
  var crc = 0xFFFFFFFF;
  for (final v in td) {
    crc = _crcTable[(crc ^ v) & 0xFF] ^ (crc >> 8);
  }
  for (final v in data) {
    crc = _crcTable[(crc ^ v) & 0xFF] ^ (crc >> 8);
  }
  crc = crc ^ 0xFFFFFFFF;
  final c = ByteData(4)..setUint32(0, crc & 0xFFFFFFFF);
  out.add(c.buffer.asUint8List());
}

final List<int> _crcTable = List<int>.generate(256, (n) {
  var c = n;
  for (var k = 0; k < 8; k++) {
    c = (c & 1) != 0 ? 0xEDB88320 ^ (c >> 1) : c >> 1;
  }
  return c;
});

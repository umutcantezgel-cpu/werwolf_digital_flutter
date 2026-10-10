import 'dart:typed_data';

import 'blockkoerper.dart';

/// Kompaktes, verlustfreies Speicherformat für Blockkörper (7.2, K-02): „FKB1“.
///
/// Aufbau (little endian): `F K B 1` · Version (u8) · Blockgröße (f64) · Breite, Tiefe, Höhe (u32) ·
/// Tafelgröße n (u8) · n × (Material u8, Farbe u24) · je Abschnitt in Indexreihenfolge ein Typbyte:
/// 0 = einheitlich + Wert (u8), 1 = voll als Lauflängen (Wert u8, Länge als Varint) bis 32³ Blöcke.
const _kennung = [0x46, 0x4B, 0x42, 0x31];
const _version = 1;

Uint8List schreibeBlockkoerper(Blockkoerper k) {
  final b = BytesBuilder(copy: false);
  final kopf = ByteData(1 + 8 + 12 + 1);
  kopf.setUint8(0, _version);
  kopf.setFloat64(1, k.blockgroesse, Endian.little);
  kopf.setUint32(9, k.breite, Endian.little);
  kopf.setUint32(13, k.tiefe, Endian.little);
  kopf.setUint32(17, k.hoehe, Endian.little);
  kopf.setUint8(21, k.tafel.length - 1);
  b.add(_kennung);
  b.add(kopf.buffer.asUint8List());
  for (var i = 1; i < k.tafel.length; i++) {
    final e = k.tafel[i]!;
    b.add([e.material, e.farbe & 0xFF, (e.farbe >> 8) & 0xFF, (e.farbe >> 16) & 0xFF]);
  }
  final (ax, ay, az) = k.abschnitte;
  final lauf = <int>[];
  for (var a = 0; a < ax * ay * az; a++) {
    final (voll, wert) = k.abschnittRoh(a);
    if (voll == null) {
      b.add([0, wert]);
      continue;
    }
    lauf
      ..clear()
      ..add(1);
    var i = 0;
    while (i < voll.length) {
      final w = voll[i];
      var n = 1;
      while (i + n < voll.length && voll[i + n] == w) {
        n++;
      }
      lauf.add(w);
      var v = n;
      while (v >= 0x80) {
        lauf.add((v & 0x7F) | 0x80);
        v >>= 7;
      }
      lauf.add(v);
      i += n;
    }
    b.add(lauf);
  }
  return b.takeBytes();
}

Blockkoerper liesBlockkoerper(Uint8List daten) {
  for (var i = 0; i < 4; i++) {
    if (daten[i] != _kennung[i]) throw const FormatException('keine FKB1-Daten');
  }
  final d = ByteData.sublistView(daten);
  if (d.getUint8(4) != _version) throw FormatException('unbekannte Version ${d.getUint8(4)}');
  final k = Blockkoerper(
      blockgroesse: d.getFloat64(5, Endian.little),
      breite: d.getUint32(13, Endian.little),
      tiefe: d.getUint32(17, Endian.little),
      hoehe: d.getUint32(21, Endian.little));
  final n = d.getUint8(25);
  var o = 26;
  for (var i = 0; i < n; i++) {
    k.tafel.add(Farbeintrag(daten[o], daten[o + 1] | (daten[o + 2] << 8) | (daten[o + 3] << 16)));
    o += 4;
  }
  final (ax, ay, az) = k.abschnitte;
  const groesse = kAbschnitt * kAbschnitt * kAbschnitt;
  for (var a = 0; a < ax * ay * az; a++) {
    final typ = daten[o++];
    if (typ == 0) {
      k.setzeAbschnittRoh(a, null, daten[o++]);
      continue;
    }
    if (typ != 1) throw FormatException('unbekannter Abschnittstyp $typ');
    final voll = Uint8List(groesse);
    var i = 0;
    while (i < groesse) {
      final w = daten[o++];
      var n = 0, schieb = 0;
      while (true) {
        final c = daten[o++];
        n |= (c & 0x7F) << schieb;
        if (c < 0x80) break;
        schieb += 7;
      }
      if (i + n > groesse) throw const FormatException('Lauflänge über Abschnittsgrenze');
      voll.fillRange(i, i + n, w);
      i += n;
    }
    k.setzeAbschnittRoh(a, voll, 0);
  }
  if (o != daten.length) throw const FormatException('überzählige Bytes');
  return k;
}

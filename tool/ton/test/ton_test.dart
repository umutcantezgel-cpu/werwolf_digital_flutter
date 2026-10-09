/// Abnahmetests für die Klangdateien (Auftrag A-603a, Punkt 9).
///
/// Vorausgesetzt wird der vorherige Lauf `dart run erzeuge.dart` (Testbefehl im Auftrag).
library;

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:test/test.dart';

import '../erzeuge.dart';

const String _ordner = '../../assets/burgstadt/ton';

/// Dekodiertes WAV: Kopfdaten und Abtastwerte mit Vollausschlag 1,0.
class Wav {
  Wav(this.rate, this.bits, this.kanaele, this.werte);

  final int rate;
  final int bits;
  final int kanaele;
  final Float64List werte;
}

/// Liest Kopf und Abtastwerte. Prüft RIFF/WAVE/fmt/data und die Längenangaben.
Wav lese(Uint8List b) {
  final bd = ByteData.sublistView(b);
  String text(int off) => String.fromCharCodes(b.sublist(off, off + 4));
  expect(text(0), 'RIFF');
  expect(text(8), 'WAVE');
  expect(text(12), 'fmt ');
  expect(text(36), 'data');
  expect(bd.getUint32(4, Endian.little), b.length - 8, reason: 'RIFF-Länge');
  expect(bd.getUint32(16, Endian.little), 16, reason: 'fmt-Länge');
  expect(bd.getUint16(20, Endian.little), 1, reason: 'PCM');
  final kanaele = bd.getUint16(22, Endian.little);
  final rate = bd.getUint32(24, Endian.little);
  final bits = bd.getUint16(34, Endian.little);
  final datenBytes = bd.getUint32(40, Endian.little);
  expect(datenBytes, b.length - 44, reason: 'data-Länge');
  final n = datenBytes ~/ 2;
  final werte = Float64List(n);
  for (var i = 0; i < n; i++) {
    werte[i] = bd.getInt16(44 + 2 * i, Endian.little) / 32768.0;
  }
  return Wav(rate, bits, kanaele, werte);
}

double _spitzeDbfs(Float64List w) {
  var spitze = 0.0;
  for (final v in w) {
    spitze = math.max(spitze, v.abs());
  }
  return 20 * math.log(spitze) / math.ln10;
}

double _mittelwert(Float64List w) {
  var summe = 0.0;
  for (final v in w) {
    summe += v;
  }
  return summe / w.length;
}

bool _gleich(Uint8List a, Uint8List b) {
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

void main() {
  late Map<String, Uint8List> erstesMal;

  setUpAll(() {
    erstesMal = erzeugeWavs();
  });

  test('alle Dateien der Liste existieren nach dem Erzeugen', () {
    for (final e in eintraege) {
      expect(File('$_ordner/${e.name}.wav').existsSync(), isTrue, reason: e.name);
    }
    expect(File('$_ordner/LISTE.md').existsSync(), isTrue);
    expect(eintraege.length, 44);
  });

  for (final e in eintraege) {
    group(e.name, () {
      late Wav wav;
      setUp(() {
        wav = lese(File('$_ordner/${e.name}.wav').readAsBytesSync());
      });

      test('Kopf: 22 050 Hz, 16 Bit, mono', () {
        expect(wav.rate, 22050);
        expect(wav.bits, 16);
        expect(wav.kanaele, 1);
        expect(wav.werte, isNotEmpty);
      });

      test('Spitze zwischen −3 und −0,9 dBFS', () {
        final db = _spitzeDbfs(wav.werte);
        expect(db, lessThanOrEqualTo(-0.9));
        expect(db, greaterThanOrEqualTo(-3.0));
      });

      test('kein Gleichanteil: |Mittelwert| < 0,01', () {
        expect(_mittelwert(wav.werte).abs(), lessThan(0.01));
      });

      if (e.schleife) {
        test('Schleife schließt: |erstes − letztes Sample| < 0,05', () {
          final w = wav.werte;
          expect((w[0] - w[w.length - 1]).abs(), lessThan(0.05));
        });
      }
    });
  }

  test('Determinismus: zweimal erzeugen ergibt gleiche Bytes', () {
    final zweites = erzeugeWavs();
    expect(zweites.keys.toList(), erstesMal.keys.toList());
    for (final name in erstesMal.keys) {
      expect(_gleich(erstesMal[name]!, zweites[name]!), isTrue, reason: name);
    }
  }, timeout: const Timeout(Duration(minutes: 3)));

  test('Dateien auf der Platte entsprechen dem Erzeuger', () {
    for (final entry in erstesMal.entries) {
      final platte = File('$_ordner/${entry.key}.wav').readAsBytesSync();
      expect(_gleich(platte, entry.value), isTrue, reason: entry.key);
    }
  });

  test('Gesamtgröße aller Dateien ≤ 12 MB', () {
    var gesamt = 0;
    for (final e in eintraege) {
      gesamt += File('$_ordner/${e.name}.wav').lengthSync();
    }
    expect(gesamt, lessThanOrEqualTo(12 * 1000 * 1000));
  });
}

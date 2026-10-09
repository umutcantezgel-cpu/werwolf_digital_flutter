import 'dart:convert';
import 'dart:io';

import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

Map<String, dynamic> _lies(String pfad) => jsonDecode(File(pfad).readAsStringSync()) as Map<String, dynamic>;

/// Alle Bildpixel mit Zeile und Spalte, die einen bestimmten Index tragen.
Iterable<(int, int)> _wo(SpriteImage s, bool Function(int c) passt) sync* {
  for (var i = 0; i < s.pixels.length; i++) {
    if (passt(s.pixels[i])) yield (i ~/ s.width, i % s.width);
  }
}

/// Anzahl Pixel, in denen sich zwei Bilder unterscheiden, und die Zeilen dieser Unterschiede.
(int, Set<int>) _unterschied(SpriteImage a, SpriteImage b) {
  var n = 0;
  final zeilen = <int>{};
  for (var i = 0; i < a.pixels.length; i++) {
    if (a.pixels[i] != b.pixels[i]) {
      n++;
      zeilen.add(i ~/ a.width);
    }
  }
  return (n, zeilen);
}

void main() {
  final bibliothek = {
    ...kTeileBasis,
    ...teileAusJson(_lies('data/figuren/teile_koepfe.json')),
    ...teileAusJson(_lies('data/figuren/teile_kleidung.json')),
  };
  final karten = [
    for (final k in _lies('data/figuren/karten.json')['karten'] as List) Figurenkarte.ausJson(k as Map<String, dynamic>),
  ];
  // Je Karte vier Bilder in Ausdruck-Reihenfolge.
  final bilder = {
    for (final k in karten) k.id: [for (final a in Ausdruck.values) portraet(k, a, bibliothek: bibliothek)],
  };

  test('66 Karten × 4 Ausdrücke: 64×64, nur Palettenindizes oder 255, je Bild mindestens 1500 sichtbare Pixel', () {
    expect(karten, hasLength(66));
    final befunde = <String>[];
    for (final k in karten) {
      for (final s in bilder[k.id]!) {
        if (s.width != 64 || s.height != 64 || s.footX != 32 || s.footY != 63) befunde.add('${k.id}: Format');
        var sichtbar = 0;
        for (final c in s.pixels) {
          if (c != 255) {
            sichtbar++;
            if (c >= paletteRgb.length) {
              befunde.add('${k.id}: Index $c');
              break;
            }
          }
        }
        if (sichtbar < 1500) befunde.add('${k.id}: nur $sichtbar sichtbare Pixel');
      }
    }
    expect(befunde, isEmpty, reason: befunde.take(10).join('\n'));
  });

  test('Augen: Augenfarbe Ramp.at(neutral, 1) kommt in jedem Bild vor, nur innerhalb der oberen 70 % und nur als Augen', () {
    final befunde = <String>[];
    for (final k in karten) {
      for (final s in bilder[k.id]!) {
        final augen = _wo(s, (c) => c == Ramp.at(Ramp.neutral, 1)).toList();
        if (augen.isEmpty) befunde.add('${k.id}: keine Augen');
        for (final (y, _) in augen) {
          if (y >= 0.7 * 64) befunde.add('${k.id}: Index 1 in Zeile $y');
          if (y < 10 || y > 50) befunde.add('${k.id}: Augen außerhalb der Gesichtsfläche (Zeile $y)');
        }
        // Zwei Augen mit höchstens 3 Zeilen × 2 Spalten; alles andere bleibt frei von Index 1.
        if (augen.length > 12) befunde.add('${k.id}: ${augen.length} Index-1-Pixel');
      }
    }
    expect(befunde, isEmpty, reason: befunde.take(10).join('\n'));
  });

  test('Rampe 5 (Grün) nur bei Karten mit einem Material auf Rampe 5', () {
    final befunde = <String>[];
    for (final k in karten) {
      final hatGruen = k.materialien.values.any((m) => m.rampe == 5);
      for (final s in bilder[k.id]!) {
        final gruen = _wo(s, (c) => c != kTransparent && rampeVon(c) == Ramp.green).isNotEmpty;
        if (gruen && !hatGruen) befunde.add('${k.id}: Grün ohne Rampe-5-Material');
      }
    }
    expect(befunde, isEmpty, reason: befunde.take(10).join('\n'));
  });

  test('Ausdrücke einer Figur: paarweise mindestens 12 Pixel Unterschied, alle in den Zeilen 10–50', () {
    final befunde = <String>[];
    for (final k in karten) {
      final b = bilder[k.id]!;
      for (var i = 0; i < b.length; i++) {
        for (var j = i + 1; j < b.length; j++) {
          final (n, zeilen) = _unterschied(b[i], b[j]);
          final paar = '${k.id} ${Ausdruck.values[i].name}/${Ausdruck.values[j].name}';
          if (n < 12) befunde.add('$paar: nur $n Pixel');
          for (final y in zeilen) {
            if (y < 10 || y > 50) befunde.add('$paar: Unterschied in Zeile $y');
          }
        }
      }
    }
    expect(befunde, isEmpty, reason: befunde.take(10).join('\n'));
  });

  test('je Ausdruck: zwei verschiedene Figuren unterscheiden sich in mindestens 150 Pixeln', () {
    final befunde = <String>[];
    for (var a = 0; a < Ausdruck.values.length; a++) {
      for (var i = 0; i < karten.length; i++) {
        for (var j = i + 1; j < karten.length; j++) {
          final (n, _) = _unterschied(bilder[karten[i].id]![a], bilder[karten[j].id]![a]);
          if (n < 150) befunde.add('${Ausdruck.values[a].name}: ${karten[i].id}/${karten[j].id} nur $n Pixel');
        }
      }
    }
    expect(befunde, isEmpty, reason: befunde.take(10).join('\n'));
  });

  test('deterministisch: zweimal erzeugt = gleiche Bytes', () {
    for (final k in karten) {
      for (final a in Ausdruck.values) {
        final ein = portraet(k, a, bibliothek: bibliothek).pixels;
        final zwei = portraet(k, a, bibliothek: bibliothek).pixels;
        expect(zwei, equals(ein), reason: '${k.id} ${a.name}');
      }
    }
  });

  test('fehlendes Teil wirft ArgumentError (kein stilles Weglassen)', () {
    const karte = Figurenkarte(id: 'X', name: 'X', materialien: {'haut': Material(7, 4)}, teile: ['frisur-gibt-es-nicht']);
    expect(() => portraet(karte, Ausdruck.neutral), throwsArgumentError);
  });
}

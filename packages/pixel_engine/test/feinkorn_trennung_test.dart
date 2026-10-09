import 'dart:io';

import 'package:test/test.dart';

/// Trennungsprüfung der Pixel-Bausteine (FEINKORN, Master-Prompt §3): keine Spielinhalte, nur erlaubte Importe.
/// Geprüft werden alle .dart-Dateien unter lib/src/feinkorn/ und lib/feinkorn.dart.
/// Der Test läuft aus der Paketwurzel (packages/pixel_engine), wie `dart test` es tut.

/// Der einzige erlaubte Import aus dem Paket selbst (öffentlicher Einstieg der Bausteine).
const _erlaubtesPaket = 'package:pixel_engine/feinkorn.dart';

/// Verbotene Wörter, Groß/Klein egal, jeweils als ganzes Wort (sonst wäre „Kollision“ ein Treffer für „olli“).
const _verboten = [
  'schlosskeller', 'mordakte', 'detektiv', 'schneider', 'ahmet', 'fatma', 'olli', 'can',
  'thekensaal', 'kerzenständer', 'kerzenstaender', 'buffetsaal', 'kaminsaal', 'turmgang',
  'vorratsraum', 'windfang', 'burgstadt', 'schartenfels',
];

final _ganzeWoerter = {
  for (final w in _verboten) w: RegExp('(?<![\\p{L}\\p{N}_])$w(?![\\p{L}\\p{N}_])', caseSensitive: false, unicode: true),
};

final _direktive = RegExp(r'''^\s*(?:import|export|part)\s+['"]([^'"]+)['"]''');

/// Wurzel des Bausteine-Bereichs als absolute Uri mit abschließendem Schrägstrich.
final _bereich = Uri.directory(Directory('lib/src/feinkorn').absolute.path);

/// Ziel einer Import-, Export- oder Part-Direktive in dieser Zeile, sonst null.
String? _direktivZiel(String zeile) => _direktive.firstMatch(zeile)?.group(1);

/// Grund, warum ein Ziel nicht erlaubt ist; null, wenn erlaubt.
/// Erlaubt: dart:-Bibliotheken, package:pixel_engine/feinkorn.dart und relative Pfade innerhalb von src/feinkorn.
String? _verstossImport(String ziel, Uri datei, Uri bereich) {
  if (ziel.startsWith('dart:') || ziel == _erlaubtesPaket) return null;
  if (ziel.contains(':')) return 'fremdes Paket oder Schema „$ziel“';
  final aufgeloest = datei.resolve(ziel);
  return aufgeloest.path.startsWith(bereich.path) ? null : 'relativer Pfad verlässt src/feinkorn: „$ziel“';
}

/// Verbotene Wörter in einer Zeile (Groß/Klein egal, als ganze Wörter).
List<String> _wortTreffer(String zeile) => [for (final wort in _verboten) if (_ganzeWoerter[wort]!.hasMatch(zeile)) wort];

List<File> _dateien() {
  final liste = Directory('lib/src/feinkorn')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList()
    ..add(File('lib/feinkorn.dart'));
  liste.sort((a, b) => a.path.compareTo(b.path));
  return liste;
}

void main() {
  final dateien = _dateien();

  test('Prüfung erfasst die Bausteine (lib/feinkorn.dart und Dateien unter src/feinkorn)', () {
    final pfade = dateien.map((f) => f.path).toList();
    expect(pfade, contains('lib/feinkorn.dart'));
    expect(pfade.where((p) => p.startsWith('lib/src/feinkorn/')), isNotEmpty);
  });

  test('Schritt 2a: Importe nur aus dart:, package:pixel_engine/feinkorn.dart oder src/feinkorn', () {
    final verstoesse = <String>[];
    for (final datei in dateien) {
      final zeilen = datei.readAsLinesSync();
      for (var i = 0; i < zeilen.length; i++) {
        final ziel = _direktivZiel(zeilen[i]);
        if (ziel == null) continue;
        final grund = _verstossImport(ziel, datei.absolute.uri, _bereich);
        if (grund != null) verstoesse.add('${datei.path}:${i + 1}: $grund');
      }
    }
    expect(verstoesse, isEmpty, reason: 'Verstöße (Datei:Zeile):\n${verstoesse.join('\n')}');
  });

  test('Schritt 2b: keine verbotenen Wörter (Groß/Klein egal, „can“ nur als ganzes Wort)', () {
    final treffer = <String>[];
    for (final datei in dateien) {
      final zeilen = datei.readAsLinesSync();
      for (var i = 0; i < zeilen.length; i++) {
        for (final wort in _wortTreffer(zeilen[i])) {
          treffer.add('${datei.path}:${i + 1}: „$wort“');
        }
      }
    }
    expect(treffer, isEmpty, reason: 'Treffer (Datei:Zeile):\n${treffer.join('\n')}');
  });

  group('Selbsttest der Prüfregeln (ohne Selbsttest könnte die Prüfung stumm bleiben)', () {
    final innen = _bereich.resolve('darstellung/beispiel.dart');

    test('Importe: Fremdpakete und Ausbrüche aus src/feinkorn werden erkannt, erlaubte nicht', () {
      expect(_verstossImport('package:flutter/material.dart', innen, _bereich), isNotNull);
      expect(_verstossImport('package:mordakte_core/mordakte.dart', innen, _bereich), isNotNull);
      expect(_verstossImport('package:burgstadt_app/karte.dart', innen, _bereich), isNotNull);
      expect(_verstossImport('package:pixel_engine/src/pixel_buffer.dart', innen, _bereich), isNotNull);
      expect(_verstossImport('../../dither.dart', innen, _bereich), isNotNull);

      expect(_verstossImport('dart:typed_data', innen, _bereich), isNull);
      expect(_verstossImport(_erlaubtesPaket, innen, _bereich), isNull);
      expect(_verstossImport('../daten/material.dart', innen, _bereich), isNull);
      expect(_verstossImport('material.dart', innen, _bereich), isNull);
    });

    test('Direktiven: Ziel wird aus import, export und part gelesen, Kommentarzeilen nicht', () {
      expect(_direktivZiel("import 'dart:math' as math;"), 'dart:math');
      expect(_direktivZiel("export 'src/feinkorn/daten/material.dart';"), 'src/feinkorn/daten/material.dart');
      expect(_direktivZiel('import "../daten/material.dart";'), '../daten/material.dart');
      expect(_direktivZiel("part 'teil.dart';"), 'teil.dart');
      expect(_direktivZiel("/// import 'package:flutter/material.dart';"), isNull);
    });

    test('Wörter: Treffer unabhängig von Groß/Klein, nur als ganze Wörter', () {
      expect(_wortTreffer('final Olli = 1;'), ['olli']);
      expect(_wortTreffer('// SCHLOSSKELLER und Kerzenständer'), containsAll(['schlosskeller', 'kerzenständer']));
      expect(_wortTreffer('can do this'), ['can']);
      expect(_wortTreffer('scan canvas can_x Kanne'), isEmpty);
      expect(_wortTreffer('Kollision Zuschneiden'), isEmpty);
      expect(_wortTreffer('Bruch Erde Eiche Glas'), isEmpty);
    });
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:mordakte_core/src/party/farbe.dart';
import 'package:test/test.dart';

import 'kanon_hilfe.dart';

/// Toleranz für 4 Nachkommastellen.
const double _toleranz = 0.00005;

/// Mindestabstand zwischen Figuren im selben Startraum (ABNAHME F-13).
const double _mindestImRaum = 10;

/// Mindestabstand der Beweisfarbe zu jeder anderen Figur (ABNAHME F-13).
const double _mindestBeweis = 20;

/// Referenzpaare aus der Testtabelle von Sharma et al. 2005 (Lab-Werte, ΔE00).
const _referenzPaare = <({String nr, List<double> a, List<double> b, double erwartet})>[
  (nr: '1', a: [50.0000, 2.6772, -79.7751], b: [50.0000, 0.0000, -82.7485], erwartet: 2.0425),
  (nr: '2', a: [50.0000, 3.1571, -77.2803], b: [50.0000, 0.0000, -82.7485], erwartet: 2.8615),
  (nr: '3', a: [50.0000, 2.8361, -74.0200], b: [50.0000, 0.0000, -82.7485], erwartet: 3.4412),
  (nr: '4', a: [50.0000, -1.3802, -84.2814], b: [50.0000, 0.0000, -82.7485], erwartet: 1.0000),
  (nr: '5', a: [50.0000, -1.1848, -84.8006], b: [50.0000, 0.0000, -82.7485], erwartet: 1.0000),
  (nr: '6', a: [50.0000, -0.9009, -85.5211], b: [50.0000, 0.0000, -82.7485], erwartet: 1.0000),
  (nr: '7', a: [50.0000, 0.0000, 0.0000], b: [50.0000, -1.0000, 2.0000], erwartet: 2.3669),
  (nr: '9', a: [50.0000, 2.4900, -0.0010], b: [50.0000, -2.4900, 0.0009], erwartet: 7.1792),
  (nr: '13', a: [50.0000, -0.0010, 2.4900], b: [50.0000, 0.0009, -2.4900], erwartet: 4.8045),
  (nr: '15', a: [50.0000, 2.5000, 0.0000], b: [50.0000, 0.0000, -2.5000], erwartet: 4.3065),
  (nr: '16', a: [50.0000, 2.5000, 0.0000], b: [73.0000, 25.0000, -18.0000], erwartet: 27.1492),
  (nr: '17', a: [50.0000, 2.5000, 0.0000], b: [61.0000, -5.0000, 29.0000], erwartet: 22.8977),
  (nr: '18', a: [50.0000, 2.5000, 0.0000], b: [56.0000, -27.0000, -3.0000], erwartet: 31.9030),
  (nr: '19', a: [50.0000, 2.5000, 0.0000], b: [58.0000, 24.0000, 15.0000], erwartet: 19.4535),
];

/// Eine Person des Kanons: Kennung, Startraum, Farbe und ob sie die Beweisfarbe trägt.
typedef _Person = ({String id, String raum, String farbe, bool beweis});

/// figuren.json des Falls (Repo-Wurzel aus der Testhilfe).
String _figurenPfad() => '$repoWurzel/content/party/schlosskeller/figuren.json';

/// Liest alle 22 Personen (Detektiv, Opfer, 20 Figuren) aus figuren.json.
List<_Person> _ladePersonen() {
  final json = jsonDecode(File(_figurenPfad()).readAsStringSync()) as Map<String, dynamic>;
  final roh = <Map<String, dynamic>>[
    json['detektiv'] as Map<String, dynamic>,
    json['opfer'] as Map<String, dynamic>,
    ...(json['figuren'] as List).cast<Map<String, dynamic>>(),
  ];
  return [
    for (final p in roh)
      (
        id: p['id'] as String,
        raum: p['startRoom'] as String,
        farbe: p['colorCode'] as String,
        beweis: p.containsKey('beweisFarbe'),
      ),
  ];
}

/// Prüft die Abstandsregeln und liefert je Verstoß eine Meldung mit beiden Personen und dem Wert.
List<String> _farbVerstoesse(List<_Person> personen) {
  final fehler = <String>[];

  for (var i = 0; i < personen.length; i++) {
    for (var j = i + 1; j < personen.length; j++) {
      final a = personen[i];
      final b = personen[j];
      if (a.raum != b.raum) continue;
      final d = deltaE2000(a.farbe, b.farbe);
      if (d < _mindestImRaum) {
        fehler.add(
          '${a.id} / ${b.id} (Startraum ${a.raum}): ΔE2000 = ${d.toStringAsFixed(4)}, '
          'Mindestwert $_mindestImRaum',
        );
      }
    }
  }

  final beweise = personen.where((p) => p.beweis).toList();
  if (beweise.length != 1) {
    fehler.add('Erwartet genau eine Beweisfigur, gefunden: ${beweise.length}');
    return fehler;
  }
  final beweis = beweise.single;
  for (final andere in personen) {
    if (andere.id == beweis.id) continue;
    final d = deltaE2000(beweis.farbe, andere.farbe);
    if (d < _mindestBeweis) {
      fehler.add(
        'Beweisfarbe ${beweis.id} / ${andere.id}: ΔE2000 = ${d.toStringAsFixed(4)}, '
        'Mindestwert $_mindestBeweis',
      );
    }
  }
  return fehler;
}

void main() {
  group('Referenzwerte', () {
    test('Sharma-Paare stimmen auf 4 Nachkommastellen', () {
      for (final p in _referenzPaare) {
        expect(
          deltaE2000Lab(p.a, p.b),
          closeTo(p.erwartet, _toleranz),
          reason: 'Paar ${p.nr} aus Sharma et al. 2005',
        );
      }
    });

    test('Referenzpaare sind symmetrisch (Reihenfolge egal)', () {
      for (final p in _referenzPaare) {
        expect(
          deltaE2000Lab(p.b, p.a),
          closeTo(p.erwartet, _toleranz),
          reason: 'Paar ${p.nr} in umgekehrter Reihenfolge',
        );
      }
    });

    test('Weiß hat Lab-Werte L=100, a=0, b=0', () {
      final lab = labAusHex('#FFFFFF');
      expect(lab[0], closeTo(100, 0.001));
      expect(lab[1], closeTo(0, 0.001));
      expect(lab[2], closeTo(0, 0.001));
    });

    test('Rot wird nach CIELAB D65 umgerechnet', () {
      final lab = labAusHex('#FF0000');
      expect(lab[0], closeTo(53.2408, 0.001));
      expect(lab[1], closeTo(80.0925, 0.001));
      expect(lab[2], closeTo(67.2032, 0.001));
    });

    test('ungültige Hex-Farbe wird abgelehnt', () {
      expect(() => labAusHex('#GGGGGG'), throwsFormatException);
      expect(() => labAusHex('#12345'), throwsFormatException);
    });
  });

  group('Eigenschaften des Abstands', () {
    test('gleiche Farbe hat Abstand 0', () {
      expect(deltaE2000('#3A6EA5', '#3A6EA5'), closeTo(0, 1e-9));
      expect(deltaE2000('#000000', '#000000'), closeTo(0, 1e-9));
    });

    test('Abstand ist symmetrisch', () {
      const paare = [
        ['#1F3A52', '#3A6EA5'],
        ['#F5C400', '#800020'],
        ['#E5E5E5', '#D8A7B1'],
      ];
      for (final p in paare) {
        expect(
          deltaE2000(p[1], p[0]),
          closeTo(deltaE2000(p[0], p[1]), 1e-9),
          reason: '${p[0]} gegen ${p[1]}',
        );
      }
    });
  });

  group('Kanon Schlosskeller', () {
    test('im selben Startraum mindestens 10', () {
      final personen = _ladePersonen();
      expect(personen, hasLength(22), reason: 'Detektiv, Opfer und 20 Figuren');

      final verstoesse = _farbVerstoesse(personen)
          .where((meldung) => !meldung.startsWith('Beweisfarbe'))
          .toList();
      expect(verstoesse, isEmpty, reason: verstoesse.join('\n'));
    });

    test('Beweisfarbe mindestens 20 zu allen', () {
      final personen = _ladePersonen();
      final verstoesse = _farbVerstoesse(personen)
          .where((meldung) => meldung.startsWith('Beweisfarbe') || meldung.startsWith('Erwartet'))
          .toList();
      expect(verstoesse, isEmpty, reason: verstoesse.join('\n'));
    });

    test('erkennt zu nahe Farben', () {
      final personen = _ladePersonen();
      final can = personen.singleWhere((p) => p.beweis);
      final aylin = personen.singleWhere((p) => p.id == 'aylin');

      // Kopie der Liste: Aylin trägt Cans Farbe. Die Datei bleibt unverändert.
      final manipuliert = [
        for (final p in personen)
          if (p.id == aylin.id) (id: p.id, raum: p.raum, farbe: can.farbe, beweis: p.beweis) else p,
      ];

      final verstoesse = _farbVerstoesse(manipuliert);
      expect(verstoesse, isNotEmpty, reason: 'Gleiche Farbe muss gemeldet werden');
      expect(
        verstoesse.any((m) => m.contains('Beweisfarbe ${can.id} / aylin') && m.contains('0.0000')),
        isTrue,
        reason: 'Meldung nennt Can und Aylin mit ΔE2000 0.0000, gefunden: ${verstoesse.join(' | ')}',
      );
    });
  });
}

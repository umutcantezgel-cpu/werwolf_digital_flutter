import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// Abnahme der Kleidungs- und Zubehörteile (Auftrag A-108b).
const _arten = {'frisur', 'gesicht', 'oberteil', 'unterteil', 'schuhe', 'kopf', 'zubehoer'};
const _formen = {'ellipsoid', 'quader', 'zylinder'};

/// Materialnamen aus FORMAT-FIGUREN.md (bekannte und feste Namen).
const _materialien = {
  'haut', 'haar', 'bart', 'oberteil', 'darunter', 'weste', 'aermel', 'unterarm', 'hose', 'unterbein',
  'strumpf', 'schuhe', 'akzent', 'kopfbedeckung', 'schal', 'tasche', 'brille', 'papier', 'laterne', 'handy',
  'metall',
};

/// Neutrale Probe-Figur (wie in bin/teile_kleidung_probe.dart).
const _probe = <String, Material>{
  'haut': Material(7, 5),
  'haar': Material(1, 1),
  'oberteil': Material(1, 6),
  'darunter': Material(0, 7),
  'weste': Material(2, 3),
  'hose': Material(1, 2),
  'schuhe': Material(1, 0),
  'akzent': Material(4, 4),
  'tasche': Material(2, 2),
  'schal': Material(3, 5),
  'strumpf': Material(0, 5),
  'metall': Material(0, 2),
};

/// Augenpixel im Kopfbereich (wie in figur_test.dart).
int _augen(SpriteImage s) {
  var oben = 0;
  while (s.pixels.sublist(oben * s.width, (oben + 1) * s.width).every((c) => c == kTransparent)) {
    oben++;
  }
  return s.pixels
      .sublist(oben * s.width, (oben + 14) * s.width)
      .where((c) => c == Ramp.at(Ramp.neutral, 1))
      .length;
}

void main() {
  final json = jsonDecode(File('data/figuren/teile_kleidung.json').readAsStringSync()) as Map<String, dynamic>;
  final liste = [for (final t in json['teile'] as List) t as Map<String, dynamic>];
  final neue = teileAusJson(json);
  final bibliothek = {...kTeileBasis, ...neue};
  final baker = FigurBaker(bibliothek);
  final stehen = kAnimationen['stehen']!.first;

  Figurenkarte probe(String teil) =>
      Figurenkarte(id: 'probe-$teil', name: teil, materialien: _probe, teile: ['frisur-kurz', teil]);

  test('Datei: Version 1, mindestens 26 Teile, Ids eindeutig und frei von kTeileBasis', () {
    expect(json['version'], 1);
    expect(liste.length, greaterThanOrEqualTo(26));
    final ids = [for (final t in liste) t['id'] as String];
    expect(ids.toSet(), hasLength(ids.length), reason: 'doppelte Ids in der Datei');
    expect(ids.where((id) => kTeileBasis.containsKey(id)), isEmpty, reason: 'Id schon in kTeileBasis vergeben');
  });

  test('Arten, Formen, Knochen, Materialnamen und Umleitungen sind gültig', () {
    final knochen = {for (final k in kSkelett) k.name};
    bool dreier(Object? v) => v is List && v.length == 3 && v.every((x) => x is num);
    final befunde = <String>[];
    for (final t in liste) {
      final id = t['id'];
      if (!_arten.contains(t['art'])) befunde.add('$id: Art „${t['art']}“');
      final koerper = (t['koerper'] as List?) ?? const [];
      final umleitung = (t['umleitung'] as Map?) ?? const {};
      if (koerper.isEmpty && umleitung.isEmpty) befunde.add('$id: weder Körper noch Umleitung');
      for (final g in koerper) {
        final m = g as Map<String, dynamic>;
        if (!_formen.contains(m['form'])) befunde.add('$id: Form „${m['form']}“');
        if (!knochen.contains(m['knochen'])) befunde.add('$id: Knochen „${m['knochen']}“');
        if (!_materialien.contains(m['material'])) befunde.add('$id: Material „${m['material']}“');
        if (!dreier(m['mitte'])) befunde.add('$id: mitte ist kein Vektor');
        if (!dreier(m['groesse'])) {
          befunde.add('$id: groesse ist kein Vektor');
        } else if ((m['groesse'] as List).any((x) => (x as num) <= 0)) {
          befunde.add('$id: groesse nicht positiv');
        }
        if (m['dreh'] != null && !dreier(m['dreh'])) befunde.add('$id: dreh ist kein Vektor');
      }
      for (final e in umleitung.entries) {
        if (!_materialien.contains(e.key)) befunde.add('$id: Umleitung von „${e.key}“');
        if (!_materialien.contains(e.value)) befunde.add('$id: Umleitung nach „${e.value}“');
      }
    }
    expect(befunde, isEmpty, reason: befunde.join('\n'));
  });

  test('Jedes Teil brennt auf der Probe-Karte in allen Animationen ohne Prüfbefund', () {
    for (final t in neue.values) {
      final karte = probe(t.id);
      expect(pruefeKarte(karte, bibliothek), isEmpty, reason: t.id);
      expect(pruefeFigur(baker.backe(karte)), isEmpty, reason: t.id);
    }
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('Jedes Teil ist sichtbar: mindestens 4 Pixel Unterschied in einer der 8 Richtungen', () {
    final ohne = Figurenkarte(id: 'ohne', name: 'ohne', materialien: _probe, teile: const ['frisur-kurz']);
    for (final t in neue.values) {
      final mit = probe(t.id);
      var groesste = 0;
      for (var r = 0; r < 8; r++) {
        final a = baker.backeEinzel(ohne, stehen, r).pixels;
        final b = baker.backeEinzel(mit, stehen, r).pixels;
        var n = 0;
        for (var i = 0; i < a.length; i++) {
          if (a[i] != b[i]) n++;
        }
        if (n > groesste) groesste = n;
      }
      expect(groesste, greaterThanOrEqualTo(4), reason: t.id);
    }
  });

  test('Gesicht bleibt frei: beide Augen sind von vorne sichtbar', () {
    for (final t in neue.values) {
      expect(_augen(baker.backeEinzel(probe(t.id), stehen, 0)), 2, reason: t.id);
    }
  });

  test('Teile sind paarweise unterscheidbar: Bilder unterscheiden sich vorne oder seitlich um mindestens 6 Pixel', () {
    // Verglichen werden die ganzen Sprites (Umriss und Farbe): ein Teil am Körper ändert oft nur die
    // Fläche, nicht den Umriss, und ist trotzdem als Teil unterscheidbar.
    final ids = neue.keys.toList();
    final bilder = <Uint8List>[
      for (final id in ids)
        Uint8List.fromList([
          ...baker.backeEinzel(probe(id), stehen, 0).pixels,
          ...baker.backeEinzel(probe(id), stehen, 2).pixels,
        ]),
    ];
    final befunde = <String>[];
    for (var i = 0; i < ids.length; i++) {
      for (var j = i + 1; j < ids.length; j++) {
        var n = 0;
        for (var k = 0; k < bilder[i].length; k++) {
          if (bilder[i][k] != bilder[j][k]) n++;
        }
        if (n < 6) befunde.add('${ids[i]} ≈ ${ids[j]} ($n Pixel)');
      }
    }
    expect(befunde, isEmpty, reason: befunde.join('\n'));
  }, timeout: const Timeout(Duration(minutes: 2)));
}

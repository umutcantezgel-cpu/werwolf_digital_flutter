import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// Materialien der neutralen Probe-Figur. Keine Rampe 0: dort liegt die Augenfarbe.
const _materialien = {
  'haut': Material(7, 5),
  'haar': Material(2, 3),
  'bart': Material(4, 5),
  'kopfbedeckung': Material(6, 4),
  'akzent': Material(3, 4),
  'metall': Material(1, 6),
  'oberteil': Material(1, 3),
  'hose': Material(1, 2),
  'schuhe': Material(1, 1),
};

const _formen = {'ellipsoid', 'quader', 'zylinder'};
const _formatArten = {'frisur', 'gesicht', 'oberteil', 'unterteil', 'schuhe', 'kopf', 'zubehoer'};
const _artPraefix = {'frisur': 'frisur-', 'gesicht': 'bart-', 'kopf': 'kopf-'};
const _materialNamen = {
  'haut', 'haar', 'bart', 'oberteil', 'darunter', 'weste', 'aermel', 'unterarm', 'hose', 'unterbein', 'strumpf',
  'schuhe', 'akzent', 'kopfbedeckung', 'schal', 'tasche', 'brille', 'papier', 'laterne', 'handy', 'metall',
};

/// Mindestabstand (Pixel, über 8 Richtungen) zweier Teile derselben Art.
const _mindestAbstand = 8;

int _augen(SpriteImage s) => s.pixels.where((c) => c == Ramp.at(Ramp.neutral, 1)).length;

/// Pixelabstand über alle Richtungen: zählt Umriss, Innenkanten und Farbstufen.
int _abstand(List<Uint8List> a, List<Uint8List> b) {
  var n = 0;
  for (var r = 0; r < a.length; r++) {
    for (var i = 0; i < a[r].length; i++) {
      if (a[r][i] != b[r][i]) n++;
    }
  }
  return n;
}

void main() {
  final json = jsonDecode(File('data/figuren/teile_koepfe.json').readAsStringSync()) as Map<String, dynamic>;
  final liste = [for (final t in json['teile'] as List) t as Map<String, dynamic>];
  final teile = teileAusJson(json);
  final bibliothek = {...kTeileBasis, ...teile};
  final baker = FigurBaker(bibliothek);
  final posen = kAnimationen['stehen']!.first;

  Figurenkarte karte(String id, List<String> teileIds) =>
      Figurenkarte(id: id, name: id, materialien: _materialien, teile: teileIds);

  test('Datei: Version 1, 38 Teile mit eindeutigen IDs (22 Frisuren, 6 Bärte, 10 Kopfbedeckungen)', () {
    expect(json['version'], 1);
    final ids = [for (final t in liste) t['id'] as String];
    expect(ids.toSet().length, ids.length, reason: 'doppelte IDs');
    expect(teile.length, liste.length);
    expect(teile.values.where((t) => t.art == 'frisur').length, 22);
    expect(teile.values.where((t) => t.art == 'gesicht').length, 6);
    expect(teile.values.where((t) => t.art == 'kopf').length, 10);
  });

  test('IDs doppeln keine Grundbibliothek kTeileBasis', () {
    expect(teile.keys.where(kTeileBasis.containsKey), isEmpty);
  });

  test('Arten, Präfixe, Formen, Knochen und Materialnamen gültig (nur FORMAT-Namen)', () {
    final knochen = {for (final k in kSkelett) k.name};
    final befunde = <String>[];
    for (final t in liste) {
      final id = t['id'] as String, art = t['art'] as String;
      if (!_formatArten.contains(art)) befunde.add('$id: Art „$art“ nicht im FORMAT');
      if (!id.startsWith(_artPraefix[art] ?? '#')) befunde.add('$id: Präfix passt nicht zur Art $art');
      for (final g in (t['koerper'] as List? ?? const []).cast<Map<String, dynamic>>()) {
        if (!_formen.contains(g['form'])) befunde.add('$id: Form „${g['form']}“');
        if (!knochen.contains(g['knochen'])) befunde.add('$id: Knochen „${g['knochen']}“');
        if (!_materialNamen.contains(g['material'])) befunde.add('$id: Material „${g['material']}“');
        for (final feld in ['mitte', 'groesse', 'dreh']) {
          final wert = g[feld];
          if (wert == null) continue;
          if (feld == 'dreh' && wert is! List) befunde.add('$id: dreh kein Vektor');
          if (wert is! List || wert.length != 3 || wert.any((v) => v is! num)) befunde.add('$id: $feld kein Dreiervektor');
        }
        if ((g['groesse'] as List).any((v) => (v as num) <= 0)) befunde.add('$id: Halbachse <= 0');
      }
      for (final e in ((t['umleitung'] as Map?) ?? const {}).entries) {
        if (!_materialNamen.contains(e.key) || !_materialNamen.contains(e.value)) befunde.add('$id: Umleitung ${e.key}→${e.value}');
      }
    }
    expect(befunde, isEmpty, reason: befunde.join('\n'));
  });

  test('Jedes Teil: Karte gültig, brennt in allen Animationen, pruefeFigur ohne Befund', () {
    for (final t in teile.values) {
      final k = karte(t.id, [t.id]);
      expect(pruefeKarte(k, bibliothek), isEmpty, reason: t.id);
      final befunde = pruefeFigur(baker.backe(k));
      expect(befunde, isEmpty, reason: '${t.id}\n${befunde.take(8).join('\n')}');
    }
  });

  test('Gesicht bleibt frei: Front-Ansicht zeigt beide Augen', () {
    expect(_augen(baker.backeEinzel(karte('basis', const []), posen, 0)), 2, reason: 'Methode: Basisfigur');
    for (final t in teile.values) {
      final s = baker.backeEinzel(karte(t.id, [t.id]), posen, 0);
      expect(_augen(s), 2, reason: '${t.id} verdeckt die Augen');
    }
  });

  test('Jedes Teil ist sichtbar und Teile derselben Art haben unterscheidbare Bilder', () {
    final basis = [for (var r = 0; r < 8; r++) baker.backeEinzel(karte('basis', const []), posen, r).pixels];
    final bilder = <String, List<Uint8List>>{
      for (final t in teile.values)
        t.id: [for (var r = 0; r < 8; r++) baker.backeEinzel(karte(t.id, [t.id]), posen, r).pixels],
    };
    final befunde = <String>[];
    for (final t in teile.values) {
      if (_abstand(bilder[t.id]!, basis) < 4) befunde.add('${t.id}: unsichtbar');
    }
    final ids = teile.values.toList();
    for (var i = 0; i < ids.length; i++) {
      for (var j = i + 1; j < ids.length; j++) {
        if (ids[i].art != ids[j].art) continue;
        final d = _abstand(bilder[ids[i].id]!, bilder[ids[j].id]!);
        if (d < _mindestAbstand) befunde.add('${ids[i].id} ≈ ${ids[j].id} (Abstand $d)');
      }
    }
    expect(befunde, isEmpty, reason: befunde.join('\n'));
  });
}

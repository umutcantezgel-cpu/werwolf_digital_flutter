import 'dart:convert';
import 'dart:io';

import 'package:pixel_engine/pixel_engine.dart';
import 'package:test/test.dart';

/// Abnahme der Figurenkarten (Auftrag A-601b): 65 Karten aus rollen.json (BW, R01–R20) und
/// bewohner.json (B01–B44), Teile nur aus kTeileBasis, teile_koepfe.json, teile_kleidung.json.
Map<String, dynamic> _lies(String pfad) => jsonDecode(File(pfad).readAsStringSync()) as Map<String, dynamic>;

/// Die Figur „Wanderstiefel“ ist Stiefel mit Arbeitsschuh-Sohle; nur R03 und R04 tragen sie.
bool _wanderstiefel(Figurenkarte k) => k.teile.contains('schuhe-stiefel') && k.teile.contains('schuhe-arbeitsschuhe');

void main() {
  final daten = _lies('data/figuren/karten.json');
  final karten = [for (final k in daten['karten'] as List) Figurenkarte.ausJson(k as Map<String, dynamic>)];
  final bibliothek = {
    ...kTeileBasis,
    ...teileAusJson(_lies('data/figuren/teile_koepfe.json')),
    ...teileAusJson(_lies('data/figuren/teile_kleidung.json')),
  };
  final baker = FigurBaker(bibliothek);
  final stehen = kAnimationen['stehen']!.first;

  test('Datei: Version 1, 65 Karten in Reihenfolge BW, R01 … R20, B01 … B44', () {
    expect(daten['version'], 1);
    final erwartet = [
      'BW',
      for (var i = 1; i <= 20; i++) 'R${i.toString().padLeft(2, '0')}',
      for (var i = 1; i <= 44; i++) 'B${i.toString().padLeft(2, '0')}',
    ];
    expect([for (final k in karten) k.id], erwartet);
  });

  test('Teile: jede Karte nutzt nur vorhandene Teile und bekannte Knochen (pruefeKarte ohne Befund)', () {
    final befunde = [for (final k in karten) ...pruefeKarte(k, bibliothek)];
    expect(befunde, isEmpty, reason: befunde.join('\n'));
  });

  test('Jede Karte brennt in Stehen und Gehen ohne Prüfbefund (pruefeFigur)', () {
    final befunde = <String>[];
    for (final k in karten) {
      befunde.addAll(pruefeFigur(baker.backe(k, animationen: ['stehen', 'gehen'])));
    }
    expect(befunde, isEmpty, reason: befunde.take(20).join('\n'));
  }, timeout: const Timeout(Duration(minutes: 3)));

  test('Grün (Rampe 5) nur bei R03 und R04, in keinem Material einer anderen Figur', () {
    for (final k in karten) {
      final gruen = k.materialien.entries.where((e) => e.value.rampe == Ramp.green).map((e) => e.key);
      if (k.id == 'R03' || k.id == 'R04') {
        expect(gruen, contains('oberteil'), reason: '${k.id} trägt Grün im Oberteil');
      } else {
        expect(gruen, isEmpty, reason: '${k.id} darf kein Grün (Rampe 5): $gruen');
      }
    }
  });

  test('Wanderstiefel nur bei R03 und R04, mit gleichen Teilen und gleichen Farben', () {
    expect([for (final k in karten) if (_wanderstiefel(k)) k.id], ['R03', 'R04']);
    final r03 = karten.firstWhere((k) => k.id == 'R03');
    final r04 = karten.firstWhere((k) => k.id == 'R04');
    expect(
      [for (final t in r03.teile) if (t.startsWith('schuhe')) t],
      [for (final t in r04.teile) if (t.startsWith('schuhe')) t],
    );
    for (final name in ['schuhe', 'akzent']) {
      final a = r03.materialien[name]!, b = r04.materialien[name]!;
      expect([a.rampe, a.stufe], [b.rampe, b.stufe], reason: 'Wanderstiefel: $name');
    }
  });

  test('Braune Schaftstiefel (Wanderstiefel-Anmutung) nur bei R03 und R04 (Sichtprüfung A-605)', () {
    final braun = [
      for (final k in karten)
        if (k.teile.contains('schuhe-stiefel') && k.materialien['schuhe']?.rampe == 2) k.id,
    ];
    expect(braun, ['R03', 'R04']);
    for (final k in karten.where((k) => RegExp(r'^B\d').hasMatch(k.id))) {
      expect(k.teile, isNot(contains('schuhe-stiefel')), reason: k.id);
      expect(k.materialien['schuhe']!.rampe, isNot(2), reason: '${k.id}: braune Schuhe');
    }
  });

  test('Bewohner: jedes Kleidungsstück aus bewohner.json trägt genau seine Farbe', () {
    final bewohner = (_lies('../burgstadt_core/data/stadt/bewohner.json')['bewohner'] as List).cast<Map<String, dynamic>>();
    final nach = {for (final k in karten) k.id: k};
    for (final b in bewohner) {
      final k = nach[b['id']]!;
      final kleidung = ((b['aussehen'] as Map)['kleidung'] as List).cast<Map<String, dynamic>>();
      final alle = {for (final x in kleidung) x['teil'] as String};
      for (final x in kleidung) {
        final m = k.materialien[kleidungsMaterial(x['teil'] as String, alle)];
        expect([m?.rampe, m?.stufe], [kRampeNamen[x['rampe']], x['stufe']], reason: '${k.id}: ${x['teil']}');
      }
      final haar = kHaarfarben[(b['aussehen'] as Map)['haar']];
      if (haar != null) expect([k.materialien['haar']!.rampe, k.materialien['haar']!.stufe], [haar.rampe, haar.stufe], reason: '${k.id}: Haar');
    }
  });

  test('Keine Laken-/Gespenst-Anmutung bei Bewohnern: kein Nachthemd, Morgenmantel, keine Kapuze', () {
    for (final k in karten.where((k) => RegExp(r'^B\d').hasMatch(k.id))) {
      for (final t in ['oberteil-nachthemd', 'oberteil-morgenmantel', 'kopf-kapuze', 'oberteil-poncho']) {
        expect(k.teile, isNot(contains(t)), reason: k.id);
      }
    }
  });

  test('Unterscheidbarkeit nach dem Maß der Sichtprüfer: kein Paar verwechselbar (Silhouette + Farbe, Körperfarben)', () {
    final bilder = [for (final k in karten) Figurenbild.backe(baker, k)];
    final befunde = <String>[];
    for (var i = 0; i < karten.length; i++) {
      for (var j = i + 1; j < karten.length; j++) {
        final a = vergleiche(bilder[i], bilder[j]);
        if (a.verwechselbar) {
          befunde.add('${karten[i].id} ≈ ${karten[j].id}: $a');
        }
      }
    }
    expect(befunde, isEmpty, reason: befunde.join('\n'));
  });

  test('Keine Materialien auf [0,1] (Augenfarbe liegt auf Rampe 0 Stufe 1)', () {
    for (final k in karten) {
      for (final e in k.materialien.entries) {
        expect(e.value.rampe == 0 && e.value.stufe == 1, isFalse, reason: '${k.id}: ${e.key} auf [0,1]');
      }
    }
  });

  test('Werte: Material 0–7, Größe 1,50–1,95 m (keine Kinder), Breite 0,85–1,25', () {
    for (final k in karten) {
      for (final e in k.materialien.entries) {
        expect(e.value.rampe, inInclusiveRange(0, 7), reason: '${k.id}: ${e.key}');
        expect(e.value.stufe, inInclusiveRange(0, 7), reason: '${k.id}: ${e.key}');
      }
      expect(k.groesse, inInclusiveRange(1.50, 1.95), reason: '${k.id}: groesse');
      expect(k.breite, inInclusiveRange(0.85, 1.25), reason: '${k.id}: breite');
    }
  });

  test('Name und Größe stimmen mit den Quellen überein (rollen.json, bewohner.json)', () {
    final rollen = (_lies('data/figuren/rollen.json')['figuren'] as List).cast<Map<String, dynamic>>();
    final bewohner = (_lies('../burgstadt_core/data/stadt/bewohner.json')['bewohner'] as List).cast<Map<String, dynamic>>();
    final quelle = {for (final f in [...rollen, ...bewohner]) f['id'] as String: f};
    for (final k in karten) {
      final q = quelle[k.id];
      expect(q, isNotNull, reason: '${k.id}: keine Quelle');
      expect(k.name, q!['name'], reason: '${k.id}: name');
      if (q['groesse'] != null) expect(k.groesse, (q['groesse'] as num).toDouble(), reason: '${k.id}: groesse');
    }
  });

  test('Unterscheidbarkeit: je Paar mindestens 40 Pixel vorne UND (Silhouette ≥ 12 Pixel ODER Oberteil-Farbe verschieden)', () {
    final vorne = [for (final k in karten) baker.backeEinzel(k, stehen, 0)];
    final befunde = <String>[];
    for (var i = 0; i < karten.length; i++) {
      for (var j = i + 1; j < karten.length; j++) {
        final a = vorne[i].pixels, b = vorne[j].pixels;
        var px = 0, maske = 0;
        for (var p = 0; p < a.length; p++) {
          if (a[p] != b[p]) px++;
          if ((a[p] == kTransparent) != (b[p] == kTransparent)) maske++;
        }
        final oa = karten[i].materialien['oberteil']!, ob = karten[j].materialien['oberteil']!;
        final farbeVerschieden = oa.rampe != ob.rampe || oa.stufe != ob.stufe;
        if (px < 40 || (maske < 12 && !farbeVerschieden)) {
          befunde.add('${karten[i].id} ≈ ${karten[j].id} (Pixel $px, Silhouette $maske)');
        }
      }
    }
    expect(befunde, isEmpty, reason: '${befunde.length} Paare:\n${befunde.join('\n')}');
  });
}

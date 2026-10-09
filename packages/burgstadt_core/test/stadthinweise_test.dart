import 'dart:convert';
import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:test/test.dart';

import 'fall_daten_test.dart' show ladeFall;

/// Stadt-Hinweise an den 12 Fall-Orten (Auftrag A-401a, in ANPASSUNG.md übernommen):
/// Format, Einstufung, Verortung in der Welt und Wirkung im Fallsystem.
void main() {
  final wurzel = findeRepoWurzel()!;
  final anpassung = File('$wurzel/nachtlauf/kanon/ANPASSUNG.md').readAsStringSync();
  final vorschlagText = anpassung.substring(anpassung.indexOf('## Stadt-Hinweise an den Fall-Orten'));
  final k = kanonLesen('$wurzel/krimidinner/spuk-im-gewoelbe/10_kanon').mitOverlay(anpassung, datei: 'ANPASSUNG.md');
  final hinweise = k.mitPraefix('H-S').toList()
    ..sort((a, b) => a.id.compareTo(b.id));
  final wahrheiten = k.mitPraefix('HW-S').toList()
    ..sort((a, b) => a.id.compareTo(b.id));

  test('24 Hinweise H-S01…H-S24 mit Wahrheiten HW-S01…HW-S24', () {
    final nummern = [
      for (var i = 1; i <= 24; i++) 'S${i.toString().padLeft(2, '0')}',
    ];
    expect(
      hinweise.map((h) => h.id).toList(),
      equals([for (final n in nummern) 'H-$n']),
    );
    expect(
      wahrheiten.map((h) => h.id).toList(),
      equals([for (final n in nummern) 'HW-$n']),
    );
    expect(hinweise.every((h) => h.sicht == Sicht.o), isTrue);
    expect(wahrheiten.every((h) => h.sicht == Sicht.l), isTrue);
  });

  test('Proben bleiben bei 0 Befunden', () {
    for (final eintrag in alleProben(k).entries) {
      expect(eintrag.value, isEmpty, reason: eintrag.key);
    }
    expect(k.lesefehler, isEmpty);
  });

  test('Einstufung nur Farbe, entlastend oder bestätigend', () {
    for (final h in wahrheiten) {
      final einstufung = h.feld('Einstufung') ?? '';
      final erlaubt = ['Farbe', 'entlastend', 'bestätigend'].any(
        (e) => einstufung == e || einstufung.startsWith('$e ('),
      );
      expect(erlaubt, isTrue, reason: '${h.id}: „$einstufung“');
    }
  });

  test('Stützt nie S-1…S-7', () {
    final notwendig = RegExp(r'(?<![\p{L}\p{N}_])S-[1-7](?!\d)', unicode: true);
    for (final h in wahrheiten) {
      expect(notwendig.hasMatch(h.feld('Stützt') ?? ''), isFalse, reason: h.id);
    }
  });

  test('Quelle: Station ORT-nn mit existierender Kennung; je Fall-Ort zwei Hinweise', () {
    final muster = RegExp(r'^Station (ORT-\d\d)$');
    final proOrt = <String, int>{};
    for (final h in hinweise) {
      final quelle = h.feld('Quelle') ?? '';
      final treffer = muster.firstMatch(quelle);
      expect(treffer, isNotNull, reason: '${h.id}: „$quelle“');
      final ort = treffer!.group(1)!;
      expect(k.datensaetze.containsKey(ort), isTrue, reason: '${h.id} → $ort');
      proOrt[ort] = (proOrt[ort] ?? 0) + 1;
    }
    expect(
      proOrt.values.every((n) => n == 2),
      isTrue,
      reason: 'Hinweise je Ort: $proOrt',
    );
  });

  test('Die Orte entsprechen den Fall-Orten in haeuser.json', () {
    final hinweiseOrte = hinweise
        .map((h) => RegExp(r'ORT-\d\d').firstMatch(h.feld('Quelle') ?? '')!.group(0)!)
        .toSet()
        .toList()
      ..sort();
    final haeuser = jsonDecode(
      File(
        '$wurzel/packages/burgstadt_core/data/stadt/haeuser.json',
      ).readAsStringSync(),
    ) as Map<String, dynamic>;
    final fallOrte = [
      for (final haus in (haeuser['haeuser'] as List).cast<Map<String, dynamic>>())
        if (haus['ort'] != null) haus['ort'] as String,
    ]..sort();
    expect(fallOrte.length, 12);
    expect(hinweiseOrte, equals(fallOrte));
  });

  test('Phase 2 oder 3 (Oberstadt ab Phase 2)', () {
    for (final h in hinweise) {
      expect(['2', '3'], contains(h.feld('Phase')), reason: h.id);
    }
  });

  test('Form nur Karte, Beweisstück, mündlich oder Erzähler', () {
    for (final h in hinweise) {
      expect(
        ['Karte', 'Beweisstück', 'mündlich', 'Erzähler'],
        contains(h.feld('Form')),
        reason: h.id,
      );
    }
  });

  test('Leitplanken-Scan: keine Fehler und keine Warnungen', () {
    final treffer = scanneText(vorschlagText, datei: 'vorschlag_stadthinweise.md');
    expect(
      treffer.where((t) => t.fehler).map((t) => '$t').toList(),
      isEmpty,
    );
    expect(
      treffer.where((t) => !t.fehler).map((t) => '$t').toList(),
      isEmpty,
    );
  });

  test('Kein Text nennt Merle zusammen mit Taler, Laken, Bund, Kerzenständer oder Stiefel', () {
    const verboten = ['taler', 'laken', 'bund', 'kerzenst', 'stiefel'];
    for (final zeile in const LineSplitter().convert(vorschlagText)) {
      final klein = zeile.toLowerCase();
      if (!klein.contains('merle')) continue;
      for (final v in verboten) {
        expect(klein.contains(v), isFalse, reason: zeile);
      }
    }
  });

  test('Jeder Fall-Ort hat eine Station in seinem Innenraum (fallorte.json)', () {
    final j = jsonDecode(File('$wurzel/packages/burgstadt_core/data/innenraeume/fallorte.json').readAsStringSync()) as Map;
    final stationen = <String>{
      for (final b in j['bereiche'] as List)
        for (final l in ((b as Map)['legende'] as Map).values)
          if ((l as Map)['art'] == 'station' && l['station'] != null) l['station'] as String,
    };
    expect(stationen, containsAll([for (var i = 1; i <= 12; i++) 'ORT-${i.toString().padLeft(2, '0')}']));
  });

  test('Fallsystem: 24 Stadt-Hinweise mit Station; Untersuchen ab ihrer Phase', () {
    final d = ladeFall();
    final stadt = d.hinweise.values.where((h) => h.id.startsWith('H-S')).toList();
    expect(stadt, hasLength(24));
    expect(stadt.every((h) => h.station != null && h.station!.startsWith('ORT-')), isTrue);
    final z = FallZustand(d, 4)..starte();
    expect(z.untersuche('DET', 'ORT-02'), isEmpty, reason: 'Oberstadt-Hinweise erst ab Phase 2');
    z.phase = 2;
    final e = z.untersuche('DET', 'ORT-02');
    expect(e.map((x) => x.hinweis), contains('H-S03'));
    expect(z.wissen['DET'], contains('H-S03'));
    expect(Hinweis.reihenfolge('H-S01') > Hinweis.reihenfolge('H-257'), isTrue);
  });
}

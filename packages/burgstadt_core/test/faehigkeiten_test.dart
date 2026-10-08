import 'dart:convert';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:test/test.dart';

import 'fall_daten_test.dart' show ladeFall;

/// Z-05: Jede Rolle hat eine exklusive Fähigkeit/Sichtschicht; die Sichtregeln je Rolle.
void main() {
  final d = ladeFall();
  final welt = baueBurg();
  final rollen = [for (var i = 1; i <= 20; i++) 'R${i.toString().padLeft(2, '0')}'];

  FallZustand neu() => FallZustand(d, 20)..starte();

  /// Löst den Auslöser von [f] für [wer] aus.
  List<Ereignis> ausloesen(FallZustand z, Faehigkeit f, String wer) {
    if (f.station != null) return z.untersuche(wer, f.station!);
    if (f.werkzeug != null) return z.untersuche(wer, f.werkzeug!);
    if (f.bereich != null) return z.betritt(wer, f.bereich!);
    return z.begegnung(wer, f.gespraechMit ?? (wer == 'R01' ? 'R02' : 'R01'));
  }

  test('20 Rollen, je eine Fähigkeit mit gültigem Auslöser (Station/Bereich/Gegenüber existiert)', () {
    expect(d.faehigkeiten.keys.toList()..sort(), rollen);
    final stationen = {for (final b in welt.values) for (final x in b.dinge) if (x.legende.station != null) x.legende.station!};
    for (final f in d.faehigkeiten.values) {
      final n = [f.station, f.werkzeug, f.bereich].whereType<String>().length + (f.gespraech ? 1 : 0);
      expect(n, 1, reason: '${f.rolle}: genau ein Auslöser');
      if (f.station != null) expect(stationen, contains(f.station), reason: f.rolle);
      if (f.werkzeug != null) expect(stationen, contains(f.werkzeug), reason: f.rolle);
      if (f.bereich != null) expect(welt.keys, contains(f.bereich), reason: f.rolle);
      if (f.gespraechMit != null) expect([...rollen, 'BW'], contains(f.gespraechMit), reason: f.rolle);
      expect(scanneText(f.text).where((t) => t.fehler), isEmpty, reason: f.rolle);
    }
  });

  test('Exklusiv: der Text einer Fähigkeit erreicht nur ihre Rolle, einmal', () {
    for (final r in rollen) {
      final f = d.faehigkeiten[r]!;
      final z = neu();
      final e = ausloesen(z, f, r).where((e) => e.art == 'sicht').toList();
      expect(e, hasLength(1), reason: '$r: Fähigkeit wirkt beim eigenen Auslöser');
      expect(e.single.an, r);
      expect(e.single.text, f.text);
      expect(ausloesen(z, f, r).where((e) => e.art == 'sicht'), isEmpty, reason: '$r: nur einmal');
      // Andere Rollen am selben Auslöser bekommen nie diesen Text
      for (final o in rollen.where((o) => o != r)) {
        final andere = ausloesen(neu(), f, o).where((e) => e.art == 'sicht');
        expect(andere.where((e) => e.text == f.text), isEmpty, reason: '$o sieht nicht, was $r sieht');
        expect(andere.every((e) => e.an == o), isTrue);
      }
    }
  });

  test('Sichtschicht wirkt nur für Rollen im Spiel (bei N = 4 nicht für R20)', () {
    final z = FallZustand(d, 4)..starte();
    expect(z.rollen, isNot(contains('R20')));
    expect(z.betritt('R20', 'gewoelbe'), isEmpty);
  });

  test('Spuren: Spurenarten der Sichtschichten (Fußspur R11/R20, Wachs R17, Verwischt R03), sonst nur Detektiv', () {
    final spuren = spurenMitSichtschichten(burgSpuren(welt), d.faehigkeiten);
    for (final s in spuren) {
      expect(s.sicht, contains('detektiv'));
      final erwartet = {
        SpurArt.fussspur: {'R11', 'R20'},
        SpurArt.wachs: {'R17'},
        SpurArt.verwischt: {'R03'},
      }[s.art] ?? <String>{};
      expect(s.sicht.difference({'detektiv'}), erwartet, reason: '${s.art} ${s.beschreibung}');
    }
    expect(spuren.map((s) => s.art).toSet().length, greaterThanOrEqualTo(6));
  });

  test('Gegenspiel: nur R03 verwischt den Abdruck bei BS-01; er bleibt als „verwischt“ erkennbar; Speichern hält es', () {
    final z = neu();
    expect(z.verwische('R01', 'BS-01'), isEmpty);
    expect(z.verwische('R03', 'BS-04'), isEmpty);
    final e = z.verwische('R03', 'BS-01');
    expect(e.single.art, 'verwischt');
    expect(e.single.an, 'R03');
    expect(z.verwische('R03', 'BS-01'), isEmpty);
    final abdruck = burgSpuren(welt).firstWhere((s) => s.station == 'BS-01' && s.art == SpurArt.fussspur);
    expect(abdruck.alsVerwischt().art, SpurArt.verwischt);
    final z2 = FallZustand.ausJson(d, jsonDecode(jsonEncode(z.zuJson())) as Map<String, dynamic>);
    expect(z2.verwischt, {'BS-01'});
    expect(z2.faehigkeitGenutzt, z.faehigkeitGenutzt);
  });

  test('Mit Bots (N = 20): die meisten Rollen nutzen ihre Fähigkeit im Lauf von Phase 1', () {
    final sim = Simulation(Welt(baueBurg()), neu(), seed: 3, tempo: 0.6);
    for (var i = 0; i < 30 * 240 && sim.fall.phase == 1; i++) {
      sim.tick(1 / 30);
    }
    expect(sim.fall.faehigkeitGenutzt.length, greaterThanOrEqualTo(12), reason: '${sim.fall.faehigkeitGenutzt}');
  });
}

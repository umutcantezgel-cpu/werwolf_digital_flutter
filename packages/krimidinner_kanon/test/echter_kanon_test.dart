// Parser gegen den echten Kanon v1.x (krimidinner/spuk-im-gewoelbe/10_kanon).
// Zählungen nur mit Spielraum: Der Kanon darf ergänzt werden (v1.1, v1.2 …).
import 'package:krimidinner_kanon/krimidinner_kanon.dart';
import 'package:test/test.dart';

import 'hilfe.dart';

String nr2(int n) => n.toString().padLeft(2, '0');

void main() {
  late KrimiKanon k;
  setUpAll(() => k = echterKanon);

  test('mindestens 1200 Datensätze, keine Lesebefunde', () {
    expect(k.datensaetze.length, greaterThanOrEqualTo(1200));
    expect(k.lesefehler, isEmpty);
  });

  test('nur K*.md werden gelesen (GESAMT-KANON doppelt sonst alles)', () {
    final dateien = kanonDateien();
    expect(dateien.keys, contains('GESAMT-KANON.md'));
    expect(
      k.datensaetze.values.map((d) => d.datei).toSet().every(istKanonDatei),
      isTrue,
    );
  });

  test('Pflichtkennungen des Begleiters sind alle da', () {
    expect(Gewoelbe.pflichtBefunde(k), isEmpty);
  });

  test('Sichtklassen der Rollendatensätze', () {
    for (var r = 1; r <= 20; r++) {
      final rr = 'R${nr2(r)}';
      expect(k.datensaetze['$rr-STAMM']!.sicht, Sicht.o, reason: rr);
      expect(k.datensaetze['$rr-ÖFFENTLICH']!.sicht, Sicht.o, reason: rr);
      for (final t in ['GEHEIM', 'WISSEN', 'VERBINDUNGEN', 'LÜGE']) {
        expect(k.datensaetze['$rr-$t']!.sicht, Sicht.g, reason: '$rr-$t');
        expect(k.datensaetze['$rr-$t']!.feld('Rolle'), rr, reason: '$rr-$t');
      }
      expect(k.datensaetze['$rr-PLOT']!.sicht, Sicht.l, reason: rr);
    }
  });

  test('Detektiv-Entscheidungen: D öffentlich mit A/B/C, DW Lösung', () {
    for (var p = 1; p <= 3; p++) {
      for (var i = 1; i <= 3; i++) {
        final d = k.datensaetze['D$p-$i']!;
        expect(d.sicht, Sicht.o);
        for (final o in ['A', 'B', 'C']) {
          expect(d.feld('Option $o'), isNotEmpty, reason: 'D$p-$i Option $o');
        }
        expect(k.datensaetze['DW$p-$i']!.sicht, Sicht.l);
      }
    }
  });

  test('Detektiv: STAMM und ALIBI öffentlich, Beobachtungen B1–B6 geheim', () {
    expect(k.datensaetze['DET-STAMM']!.sicht, Sicht.o);
    expect(k.datensaetze['DET-ALIBI']!.sicht, Sicht.o);
    for (var i = 1; i <= 6; i++) {
      final b = k.datensaetze['DET-B$i']!;
      expect(b.sicht, Sicht.g);
      expect(b.feld('Rolle'), 'DET');
    }
  });

  test('Lösungsdatensätze sind L', () {
    for (final id in [
      'K-012',
      'K-090',
      'K-091',
      'K-092',
      'BW-WAHRHEIT',
      'LR-7',
    ]) {
      expect(k.datensaetze[id]!.sicht, Sicht.l, reason: id);
    }
    for (final p in ['AB-', 'EM-', 'GS-', 'Z-', 'BS-', 'HW-', 'S-', 'PF-']) {
      final ds = k.mitPraefix(p).toList();
      expect(ds, isNotEmpty, reason: p);
      expect(ds.every((d) => d.sicht == Sicht.l), isTrue, reason: p);
    }
  });

  test('alle Proben wie kanon.py: keine Befunde', () {
    final befunde = alleProben(k);
    for (final e in befunde.entries) {
      expect(e.value, isEmpty, reason: e.key);
    }
  });

  test(
    'tatsaechliche: nie FEHLT, je besetzter Rolle genau 3 Aufträge je Phase',
    () {
      for (var p = 1; p <= 3; p++) {
        for (var n = 4; n <= 20; n++) {
          final t = tatsaechliche(k, p, n);
          expect(t.where((x) => x.$4 == 'FEHLT'), isEmpty, reason: 'P$p N=$n');
          for (var r = 1; r <= n; r++) {
            expect(t.where((x) => x.$1 == r).length, 3, reason: 'P$p N=$n R$r');
          }
          for (final (von, an, _, _) in t) {
            expect(von, lessThanOrEqualTo(n));
            expect(an, lessThanOrEqualTo(n));
            expect(an, isNot(von));
          }
        }
      }
    },
  );
}


import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:test/test.dart';

FallDaten ladeFall() => ladeFallDaten(findeRepoWurzel()!);

void main() {
  final f = ladeFall();

  test('Zahlen wie im Kanon', () {
    expect(f.hinweise.keys.where((h) => !h.startsWith('H-S')).length, 257);
    expect(f.hinweise.keys.where((h) => h.startsWith('H-S')).length, 24); // Stadt-Hinweise (Anpassung)
    expect(f.gespraeche.length, 180);
    expect(f.rollenEntscheidungen.length, 60);
    expect(f.detektivEntscheidungen.length, 9);
    expect(f.rollen.length, 20);
    expect(f.meldekarten.length, 12);
    expect(f.notwendig, {'S-1', 'S-2', 'S-3', 'S-4', 'S-5', 'S-6', 'S-7'});
    expect(f.burgwartAussagen.keys, containsAll([1, 2, 3]));
    expect(f.rollen['R03']!.name, 'Merle Hartwig');
  });

  test('Jeder Hinweis hat eine Herkunft im Spiel', () {
    for (final h in f.hinweise.values) {
      final herkunft = h.gespraech != null || h.station != null || h.meldekarte || h.erzaehler || h.detektivMappe;
      expect(herkunft, isTrue, reason: '${h.id}: ${h.quelle}');
      if (h.gespraech != null) expect(f.gespraeche.containsKey(h.gespraech), isTrue, reason: h.id);
    }
  });

  test('Gespräche verweisen auf existierende Hinweise; Detektiv-Entscheidungen haben Punkte', () {
    for (final g in f.gespraeche.values) {
      for (final h in [...g.gibt, ...g.ersatzGibt]) {
        expect(f.hinweise.containsKey(h), isTrue, reason: '${g.id} → $h');
      }
    }
    for (final d in f.detektivEntscheidungen.values) {
      expect(d.punkte[d.echte], 1, reason: d.id);
      expect(d.optionen.values.every((o) => o.isNotEmpty), isTrue);
    }
  });

  test('Jede notwendige Schlussfolgerung ist bei jeder Besetzung 4–20 erreichbar', () {
    for (var n = 4; n <= 20; n++) {
      for (final s in f.notwendig) {
        final da = f.schluesse[s]!.where((h) => f.hinweise[h] != null && f.imSpiel(f.hinweise[h]!, n));
        expect(da, isNotEmpty, reason: '$s bei N=$n');
      }
    }
  });
}

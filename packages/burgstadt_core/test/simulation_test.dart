import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:test/test.dart';

import 'fall_daten_test.dart' show ladeFall;

void main() {
  final d = ladeFall();

  test('Navigation: vom Gewölbe zur Rüstung Kunibert über Turm und Treppe', () {
    final w = Welt(baueBurg());
    final nav = Navigation(w);
    final (mx, mz) = w.bereiche['gewoelbe']!.marken['m']!;
    final abs = w.bereiche['absatz']!;
    final kunibert = abs.dinge.firstWhere((x) => x.legende.station == 'Kunibert');
    final weg = nav.weg(('gewoelbe', mx, mz), (o) => Navigation.nebenDing(abs, kunibert, o));
    expect(weg, isNotNull);
    expect(weg!.first.$1, 'gewoelbe');
    expect(weg.last.$1, 'absatz');
  });

  test('Echtzeit: Phase 1 mit 4 Bots – Gespräche geführt, Stationen besucht, niemand in Wänden', () {
    final z = FallZustand(d, 4)..starte();
    final sim = Simulation(Welt(baueBurg()), z);
    var ticks = 0;
    while (z.abschnitt == Abschnitt.ermittlung && ticks < 20000) {
      sim.tick(0.1);
      ticks++;
      for (final f in sim.figuren.values) {
        final b = sim.welt.bereiche[f.bereich]!;
        final (kx, kz) = f.kachel;
        expect(b.begehbar(kx, kz), isTrue, reason: '${f.id} steckt in ${b.id} $kx/$kz');
      }
    }
    expect(z.abschnitt, Abschnitt.lagerunde);
    final geplant = d.gespraecheFuer(1, 4).length;
    expect(z.erledigt.where((g) => g.startsWith('G1-')).length, greaterThanOrEqualTo(geplant * 0.8));
    expect(z.untersucht.where((u) => u.startsWith('R')).length, greaterThan(0));
    expect(z.akte.length, greaterThan(5));
  });

  test('Detektiv in Hörweite erfährt Gesprächs-Hinweise; Ansprechen liefert Alibi + Geteiltes', () {
    final z = FallZustand(d, 4)..starte();
    final sim = Simulation(Welt(baueBurg()), z);
    final e = sim.detektivFragt('R02');
    expect(e.first.art, 'aussage');
    expect(e.first.text, contains('Rojda'));
  });
}

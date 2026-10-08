import 'dart:convert';
import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:test/test.dart';

void main() {
  final w = findeRepoWurzel()!;
  final innen = [
    for (final f in Directory('$w/packages/burgstadt_core/data/innenraeume').listSync().whereType<File>())
      if (f.path.endsWith('.json')) jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
  ];
  final haeuser = [
    for (final h in (jsonDecode(File('$w/packages/burgstadt_core/data/stadt/haeuser.json').readAsStringSync()) as Map)['haeuser'] as List)
      h as Map<String, dynamic>,
  ];
  final bereiche = baueWelt(innen, haeuser: haeuser);

  test('A-307a: alle offenen Türen erreicht (0 nicht erreicht), 0 Steckenbleiber, Bots frei', () {
    final bericht = erkunde(bereiche, phase: 3, bots: 4, seed: 1752);
    final offen = [
      for (final b in bereiche.values)
        for (final d in b.dinge)
          if (d.legende.art == KachelArt.tuer && Bereich.offen(d.legende, 3)) d,
    ];
    expect(bericht.tuerenGesamt, offen.length, reason: 'Türenzahl stimmt nicht mit den offenen Türen überein');
    expect(bericht.nichtErreicht, isEmpty, reason: 'nicht erreicht: ${bericht.nichtErreicht}');
    expect(bericht.erreicht, bericht.tuerenGesamt);
    expect(bericht.steckenbleiber, isEmpty, reason: 'Steckenbleiber: ${bericht.steckenbleiber}');
    expect(bericht.bots.every((b) => b.frei), isTrue, reason: 'ein Bot endet nicht frei');
    expect(bericht.rechenzeit.inSeconds, lessThan(60));
  });

  test('A-307a: deterministisch bei gleichem Seed', () {
    final a = erkunde(bereiche, phase: 3, bots: 4, seed: 1752);
    final b = erkunde(bereiche, phase: 3, bots: 4, seed: 1752);
    expect(a.erreicht, b.erreicht);
    expect(a.spielzeit, b.spielzeit);
    expect(
      [for (final x in a.bots) (x.bereich.id, x.x, x.z)],
      [for (final x in b.bots) (x.bereich.id, x.x, x.z)],
    );
  });

  test('A-307a: andere Seeds und Bot-Zahlen erreichen ebenfalls alle Türen', () {
    for (final (seed, n) in [(1, 1), (7, 2), (99, 8)]) {
      final b = erkunde(bereiche, phase: 3, bots: n, seed: seed);
      expect(b.nichtErreicht, isEmpty, reason: 'Seed $seed, $n Bots: ${b.nichtErreicht}');
      expect(b.steckenbleiber, isEmpty, reason: 'Seed $seed, $n Bots: ${b.steckenbleiber}');
      expect(b.bots.every((x) => x.frei), isTrue, reason: 'Seed $seed, $n Bots: ein Bot endet nicht frei');
    }
  });

  test('A-307a: Steckenbleiber-Erkennung meldet Ziel hinter einer Wand, nicht das erreichbare', () {
    // Zwei Gänge, getrennt durch eine Wandzeile: Ziel im unteren Gang ist nur über die Wand "erreichbar".
    final raum = Bereich(
      id: 'pruef',
      name: 'Prüfraum',
      innen: true,
      karte: ['#########', '#.......#', '#########', '#.......#', '#########'],
      legende: const {},
    );
    final tuer = ErkundungsTuer(
      von: raum,
      ding: Ding('x', const Legende(KachelArt.tuer, 'Probe'), 0, 0, 0, 0),
      nach: null,
      nachKachel: null,
    );

    final bot = Erkunder(name: 'Probe', bereich: raum, x: 0.75, z: 0.75);
    bot.zielSetzen(tuer, [GehSchritt(raum, 0.75, 1.75)]);
    ErkundungsEreignis? ereignis;
    var zeit = 0.0;
    while (ereignis == null && zeit < 10) {
      ereignis = bot.schritt(kErkundungDt);
      zeit += kErkundungDt;
    }
    expect(ereignis, isA<Steckenbleiber>());
    expect(zeit, inInclusiveRange(3.0, 3.5), reason: 'Steckenbleiben nach 3 s Stillstand');
    expect(bot.untaetig, isTrue);
    expect(bot.frei, isTrue);

    final gegen = Erkunder(name: 'Gegenprobe', bereich: raum, x: 0.75, z: 0.75);
    gegen.zielSetzen(tuer, [GehSchritt(raum, 3.25, 0.75)]);
    ErkundungsEreignis? zweites;
    var schritte = 0;
    while (!gegen.untaetig && schritte < 600) {
      zweites = gegen.schritt(kErkundungDt) ?? zweites;
      schritte++;
    }
    expect(gegen.untaetig, isTrue, reason: 'erreichbares Ziel nicht erreicht');
    expect(zweites, isNull, reason: 'erreichbares Ziel darf kein Ereignis auslösen');
    expect(gegen.x, closeTo(3.25, 0.06));
  });
}

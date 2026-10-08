import 'dart:convert';
import 'dart:io';

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:burgstadt_core/burgstadt_core_io.dart';
import 'package:test/test.dart';

void main() {
  final burg = Welt(baueBurg());

  test('Burg-Karten sind gültig (Legende, Türziele, Marken)', () {
    expect(burg.pruefe(), isEmpty);
    for (final b in burg.bereiche.values) {
      for (final z in b.karte) {
        expect(z.length, b.breite, reason: '${b.id}: ungleiche Zeilenbreite');
      }
    }
  });

  test('Kanon-Topologie: Gewölbe 3 Türen, Speisekammer 2 Türen, Turm verbindet alle Ebenen', () {
    Iterable<String> ziele(String id) =>
        burg.bereiche[id]!.dinge.where((d) => d.legende.art == KachelArt.tuer).map((d) => d.legende.ziel!).toSet();
    expect(ziele('gewoelbe'), {'turmfuss', 'speisekammer', 'hof'});
    expect(ziele('speisekammer'), {'gewoelbe', 'turmfuss'});
    expect(ziele('turmfuss'), containsAll(['gewoelbe', 'speisekammer', 'absatz']));
    expect(ziele('absatz'), {'turmfuss', 'hofebene'});
    expect(ziele('hofebene'), containsAll(['absatz', 'hof', 'wehrgang']));
  });

  test('Erreichbarkeit: von der Gewölbe-Mitte jede offene Tür und jede Station', () {
    // Flutfüllung je Bereich, Übergang über offene Türen
    final besucht = <String, Set<int>>{};
    final offen = <(String, int, int)>[];
    final (sx, sz) = burg.bereiche['gewoelbe']!.marken['m']!;
    offen.add(('gewoelbe', sx, sz));
    while (offen.isNotEmpty) {
      final (id, x, z) = offen.removeLast();
      final b = burg.bereiche[id]!;
      final set = besucht.putIfAbsent(id, () => {});
      if (!set.add(z * b.breite + x)) continue;
      for (final (dx, dz) in const [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
        final nx = x + dx, nz = z + dz;
        if (b.begehbar(nx, nz)) {
          offen.add((id, nx, nz));
        } else {
          final d = b.dingAn(nx, nz);
          if (d != null && Bereich.offen(d.legende, 2)) {
            final ziel = burg.bereiche[d.legende.ziel]!;
            final (mx, mz) = ziel.marken[d.legende.zielMarke]!;
            offen.add((ziel.id, mx, mz));
          }
        }
      }
    }
    expect(besucht.keys.toSet(), burg.bereiche.keys.toSet());
    // jede Station grenzt an begehbare, besuchte Kacheln oder ist selbst begehbar
    for (final b in burg.bereiche.values) {
      for (final d in b.dinge.where((d) => d.legende.station != null)) {
        var ok = false;
        for (var z = d.z0 - 1; z <= d.z1 + 1; z++) {
          for (var x = d.x0 - 1; x <= d.x1 + 1; x++) {
            if (besucht[b.id]!.contains(z * b.breite + x)) ok = true;
          }
        }
        expect(ok, isTrue, reason: '${b.id}: Station ${d.legende.station} unerreichbar');
      }
    }
  });

  test('Kollision: Wände und Möbel blockieren, Boden ist frei', () {
    final g = burg.bereiche['gewoelbe']!;
    final (mx, mz) = g.markePos('m');
    expect(g.frei(mx, mz), isTrue);
    expect(g.frei(0.2, 0.2), isFalse); // Ecke Wand
    expect(g.frei(1.0, 0.9), isFalse); // Kamin
  });

  test('Jede Türziel-Marke liegt direkt vor einer Tür des Zielbereichs', () {
    for (final b in burg.bereiche.values) {
      for (final d in b.dinge.where((d) => d.legende.art == KachelArt.tuer)) {
        final ziel = burg.bereiche[d.legende.ziel]!;
        final (mx, mz) = ziel.marken[d.legende.zielMarke]!;
        var neben = false;
        for (final (dx, dz) in const [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
          if (ziel.art(mx + dx, mz + dz) == KachelArt.tuer) neben = true;
        }
        expect(neben, isTrue, reason: '${b.id} → ${ziel.id}: Marke ${d.legende.zielMarke} liegt nicht an einer Tür');
      }
    }
  });

  test('Ganze Welt mit Innenräumen: gültig, Marktplatz-Türen führen in die Räume und zurück', () {
    final w = findeRepoWurzel()!;
    final dateien = [
      for (final f in Directory('$w/packages/burgstadt_core/data/innenraeume').listSync().whereType<File>())
        if (f.path.endsWith('.json')) jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
    ];
    final welt = Welt(baueWelt(dateien));
    expect(welt.pruefe(), isEmpty);
    final stadt = welt.bereiche['stadt']!;
    final tueren = stadt.dinge.where((d) => d.legende.art == KachelArt.tuer && !d.legende.verschlossen).toList();
    expect(tueren.length, greaterThanOrEqualTo(5)); // Burgtor + 4 Fall-Orte am Markt
    final nav = Navigation(welt, phase: 2);
    final (bx, bz) = welt.bereiche['hof']!.marken['b']!;
    final weg = nav.weg(('hof', bx, bz), (o) => o.$1 == 'innen-teestube');
    expect(weg, isNotNull, reason: 'Vom Burghof durch das Burgtor in die Teestube');
    expect(Navigation(welt, phase: 1).weg(('hof', bx, bz), (o) => o.$1 == 'stadt'), isNull, reason: 'Phase 1: Burgtor zu');
  });
}

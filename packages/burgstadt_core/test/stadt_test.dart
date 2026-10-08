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
  final welt = Welt(bereiche);
  final stadt = bereiche['stadt']!;

  test('Z-04: Welt gültig, ≥150 Gebäude, ≥40 Innenräume, Fall-Orte, Gangnetz', () {
    expect(welt.pruefe(), isEmpty);
    final gebaeude = stadt.dinge.where((d) => d.legende.form == 'haus' || d.legende.form == 'turm').length;
    expect(gebaeude, greaterThanOrEqualTo(150));
    final innenraeume = bereiche.values.where((b) => b.innen && (b.id.startsWith('innen-') || b.id.startsWith('haus-'))).length;
    expect(innenraeume, greaterThanOrEqualTo(40));
    for (final ort in ['museum', 'pension', 'schreinerei', 'fundus', 'stromhaus', 'teestube', 'baeckerei', 'rathaus', 'bibliothek', 'apotheke', 'kirche', 'uhrturm']) {
      expect(bereiche.containsKey('innen-$ort'), isTrue, reason: 'Fall-Ort innen-$ort fehlt');
    }
    expect(bereiche.containsKey('gaenge'), isTrue);
    expect(stadt.dinge.where((d) => d.legende.form == 'laube'), isNotEmpty, reason: 'überdachte Holztreppe');
  });

  test('Ebene 6: Erkundungsbot erreicht jede offene Tür und jeden Innenraum (ab Phase 2), niemand steckt fest', () {
    final nav = Navigation(welt, phase: 2);
    // Flutfüllung über alle Bereiche ab der Gewölbe-Mitte
    final (mx, mz) = bereiche['gewoelbe']!.marken['m']!;
    final besucht = <String, Set<int>>{};
    final offen = <Ort>[('gewoelbe', mx, mz)];
    while (offen.isNotEmpty) {
      final (id, x, z) = offen.removeLast();
      final b = bereiche[id]!;
      if (!besucht.putIfAbsent(id, () => {}).add(z * b.breite + x)) continue;
      for (final (dx, dz) in const [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
        final nx = x + dx, nz = z + dz;
        if (b.begehbar(nx, nz)) {
          offen.add((id, nx, nz));
        } else {
          final d = b.dingAn(nx, nz);
          if (d != null && Bereich.offen(d.legende, 2)) {
            final zb = bereiche[d.legende.ziel]!;
            final m = zb.marken[d.legende.zielMarke]!;
            offen.add((zb.id, m.$1, m.$2));
          }
        }
      }
    }
    final nichtErreicht = bereiche.keys.where((k) => !besucht.containsKey(k)).toList();
    expect(nichtErreicht, isEmpty, reason: 'unerreichbar: $nichtErreicht');
    // Jede offene Tür der Stadt grenzt an erreichte Kacheln
    for (final d in stadt.dinge.where((d) => d.legende.art == KachelArt.tuer && Bereich.offen(d.legende, 2))) {
      var ok = false;
      for (var z = d.z0 - 1; z <= d.z1 + 1; z++) {
        for (var x = d.x0 - 1; x <= d.x1 + 1; x++) {
          if (besucht['stadt']!.contains(z * stadt.breite + x)) ok = true;
        }
      }
      expect(ok, isTrue, reason: 'Tür ${d.legende.name} bei ${d.x0}/${d.z0} unerreichbar');
    }
    expect(nav.phase, 2);
  });

  test('Determinismus: gleicher Seed → gleiche Stadt', () {
    final a = baueWelt(innen, haeuser: haeuser)['stadt']!;
    expect(a.karte.join('\n'), stadt.karte.join('\n'));
    final c = baueWelt(innen, haeuser: haeuser, seed: 99)['stadt']!;
    expect(c.karte.join('\n'), isNot(stadt.karte.join('\n')));
  });
}

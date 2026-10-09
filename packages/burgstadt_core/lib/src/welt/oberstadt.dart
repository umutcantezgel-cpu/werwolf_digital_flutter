import 'bereich.dart';

/// Haus am Marktplatz: Rechteck in Kacheln, Name, Putz, optional Innenraum.
class _Haus {
  final int x0, z0, x1, z1;
  final String name, putz;
  final String? innen; // Bereichs-ID des Innenraums
  final String tuerSeite; // n, s, w, o (Seite zum Platz)
  final double hoehe;
  const _Haus(this.x0, this.z0, this.x1, this.z1, this.name, this.putz, this.tuerSeite, {this.innen, this.hoehe = 7});
}

/// Marktplatz der Oberstadt (Durchstich): Häuserkranz, Uhrturm, Brunnen, Burgtor.
/// Türen führen in vorhandene Innenräume [innen] (IDs `innen-…`); fehlt ein Raum,
/// bleibt die Tür verschlossen. Ab Phase 2 erreichbar (Burgtor, STADT-03).
Bereich baueMarktplatz(Set<String> innen) {
  const b = 64, t = 52;
  final raster = List.generate(t, (_) => List.filled(b, '.'));
  final legende = <String, Legende>{};
  final marken = <String, (int, int)>{};
  // Rand: Stadtmauer
  for (var x = 0; x < b; x++) {
    raster[0][x] = '#';
    raster[t - 1][x] = '#';
  }
  for (var z = 0; z < t; z++) {
    raster[z][0] = '#';
    raster[z][b - 1] = '#';
  }
  const haeuser = [
    _Haus(1, 1, 12, 9, 'Stadtmuseum am Marktplatz', 'putzSandstein', 's', innen: 'innen-museum', hoehe: 9),
    _Haus(13, 1, 22, 9, 'Haus zum Glockenseil', 'putzAltrosa', 's', innen: 'innen-wohnstube-1'),
    _Haus(37, 1, 48, 9, 'Rathaus', 'putzCreme', 's', innen: 'innen-rathaus', hoehe: 10),
    _Haus(49, 1, 62, 9, 'Krämerhaus Kesslergasse 1', 'putzTaubenblau', 's', innen: 'innen-laden-1'),
    _Haus(1, 12, 9, 24, 'Pension „Zum Uhrturm“', 'putzOcker', 'o', innen: 'innen-pension', hoehe: 8),
    _Haus(1, 27, 9, 38, 'Tuchhaus zur Waage', 'putzKalkweiss', 'o', innen: 'innen-laden-4'),
    _Haus(1, 41, 14, 50, 'Teestube „Zur Laterne“', 'putzAltrosa', 'n', innen: 'innen-teestube'),
    _Haus(15, 41, 27, 50, 'Haus zum Kachelofen', 'putzCreme', 'n', innen: 'innen-wohnstube-2'),
    _Haus(36, 41, 48, 50, 'Haus am Brunnen', 'putzTaubenblau', 'n', innen: 'innen-wohnstube-5'),
    _Haus(49, 41, 62, 50, 'Zunfthaus der Weber', 'putzSandstein', 'n', innen: 'innen-zunftstube-1'),
    _Haus(54, 12, 62, 24, 'Papierhandlung', 'putzOcker', 'w', innen: 'innen-laden-3'),
    _Haus(54, 27, 62, 38, 'Uhrmacherhaus', 'putzAltrosa', 'w', innen: 'innen-werkstatt-4'),
  ];
  const zeichen = 'ACDEFIJLMNPRVWXYZ123456789';
  var zi = 0;
  for (final h in haeuser) {
    final c = zeichen[zi++];
    for (var z = h.z0; z <= h.z1; z++) {
      for (var x = h.x0; x <= h.x1; x++) {
        raster[z][x] = c;
      }
    }
    legende[c] = Legende(KachelArt.objekt, h.name, form: 'haus', hoehe: h.hoehe, textur: h.putz);
    // Tür mittig auf der Platzseite
    final (tx, tz, mx, mz) = switch (h.tuerSeite) {
      's' => ((h.x0 + h.x1) ~/ 2, h.z1, (h.x0 + h.x1) ~/ 2, h.z1 + 1),
      'n' => ((h.x0 + h.x1) ~/ 2, h.z0, (h.x0 + h.x1) ~/ 2, h.z0 - 1),
      'o' => (h.x1, (h.z0 + h.z1) ~/ 2, h.x1 + 1, (h.z0 + h.z1) ~/ 2),
      _ => (h.x0, (h.z0 + h.z1) ~/ 2, h.x0 - 1, (h.z0 + h.z1) ~/ 2),
    };
    final tc = zeichen[zi++];
    raster[tz][tx] = tc;
    final hatInnen = h.innen != null && innen.contains(h.innen);
    legende[tc] = Legende(KachelArt.tuer, hatInnen ? h.name : '${h.name} (dunkel, verschlossen)',
        ziel: hatInnen ? h.innen : 'stadt', zielMarke: hatInnen ? 't' : 'b', verschlossen: !hatInnen, textur: 'eichenTuer', hoehe: 2.2);
    if (h.innen != null) marken['tuer-${h.innen}'] = (mx, mz);
  }
  // Uhrturm (ORT-01) und Brunnen
  for (var z = 14; z <= 19; z++) {
    for (var x = 29; x <= 34; x++) {
      raster[z][x] = 'U';
    }
  }
  legende['U'] = const Legende(KachelArt.objekt, 'Uhrturm (schlägt mechanisch weiter)', form: 'turm', hoehe: 18, textur: 'quaderMauer', station: 'ORT-01');
  // Tür des Uhrturms (Südseite)
  raster[19][31] = 'K';
  final uhrInnen = innen.contains('innen-uhrturm');
  legende['K'] = Legende(KachelArt.tuer, uhrInnen ? 'Tür zum Uhrwerk' : 'Tür zum Uhrwerk (verschlossen)',
      ziel: uhrInnen ? 'innen-uhrturm' : 'stadt', zielMarke: uhrInnen ? 't' : 'b', verschlossen: !uhrInnen, textur: 'eichenTuerEisen', hoehe: 2.2);
  marken['tuer-innen-uhrturm'] = (31, 20);
  for (var z = 30; z <= 33; z++) {
    for (var x = 30; x <= 33; x++) {
      raster[z][x] = 'Q';
    }
  }
  legende['Q'] = const Legende(KachelArt.objekt, 'Marktbrunnen', form: 'brunnen', hoehe: 0.9, textur: 'quaderMauer');
  // Burgweg: Durchgang im Norden zwischen den Häusern zum Burgtor
  for (var x = 23; x <= 36; x++) {
    raster[0][x] = '#';
  }
  for (var x = 28; x <= 35; x++) {
    raster[0][x] = 'G';
  }
  legende['G'] = const Legende(KachelArt.tuer, 'Burgtor (zurück in den Burghof)', ziel: 'hof', zielMarke: 'b', textur: 'eichenTuerEisen', hoehe: 3.5);
  raster[1][31] = 'b';
  return Bereich(
    id: 'stadt',
    name: 'Marktplatz der Oberstadt',
    innen: false,
    raumHoehe: 8,
    wandTextur: 'bruchsteinMauer',
    bodenTextur: 'pflaster',
    grundKalt: 0.26,
    karte: [for (final z in raster) z.join()],
    legende: legende,
    namensMarken: marken,
  );
}

import 'dart:math' as math;

import '../zufall.dart';
import 'bereich.dart';

/// Ergebnis des Stadtgenerators.
class StadtPlan {
  final Bereich stadt;
  final Bereich gaenge;
  final List<Bereich> innenraeume;
  final Map<String, String> hausInnen; // Haus-ID → Bereichs-ID des Innenraums
  final Map<String, String> viertelVonHaus;
  final int gebaeude;
  StadtPlan(this.stadt, this.gaenge, this.innenraeume, this.hausInnen, this.viertelVonHaus, this.gebaeude);
}

class _Rechteck {
  final int x0, z0, x1, z1;
  const _Rechteck(this.x0, this.z0, this.x1, this.z1);
  int get w => x1 - x0 + 1;
  int get t => z1 - z0 + 1;
  double get cx => (x0 + x1) / 2;
  double get cz => (z0 + z1) / 2;
}

/// Erzeugt die Oberstadt Schartenfels: ovale Mauer mit Toren, Gassen, Marktplatz,
/// Kirchenburg, Häuserzeilen (aus `haeuser.json`), Innenräume (Kopien der Vorlagen)
/// und das Gangnetz unter der Stadt. Deterministisch über [seed].
StadtPlan generiereStadt({
  required List<Map<String, dynamic>> haeuser,
  required Map<String, Map<String, dynamic>> innenVorlagen,
  int seed = 1752,
}) {
  final r = Zufall(seed);
  const b = 320, t = 260;
  const cx = 160.0, cz = 136.0, rx = 150.0, rz = 116.0;
  double ell(num x, num z) => math.pow((x - cx) / rx, 2) + math.pow((z - cz) / rz, 2).toDouble();
  final art = List.generate(t, (_) => List.filled(b, ' ')); // ' ' außen, '.' Gasse, '#' Mauer, 'B' Baufläche
  for (var z = 0; z < t; z++) {
    for (var x = 0; x < b; x++) {
      final e = ell(x, z);
      if (e < 1) art[z][x] = e > 0.975 ? '#' : 'B';
    }
  }
  void gasse(int x0, int z0, int x1, int z1) {
    for (var z = math.max(0, z0); z <= math.min(t - 1, z1); z++) {
      for (var x = math.max(0, x0); x <= math.min(b - 1, x1); x++) {
        if (art[z][x] == 'B') art[z][x] = '.';
      }
    }
  }

  const ix = 160, iz = 136;
  // Mauergasse (innen an der Mauer)
  for (var z = 0; z < t; z++) {
    for (var x = 0; x < b; x++) {
      final e = ell(x, z);
      if (e < 0.975 && e > 0.89 && art[z][x] == 'B') art[z][x] = '.';
    }
  }
  // Hauptgasse Nord–Süd, Querstraße West–Ost
  gasse(ix - 4, 0, ix + 3, t - 1);
  gasse(0, iz - 4, b - 1, iz + 3);
  // Ringgasse
  for (var z = 0; z < t; z++) {
    for (var x = 0; x < b; x++) {
      final e = ell(x, z);
      if (e > 0.36 && e < 0.42 && art[z][x] == 'B') art[z][x] = '.';
    }
  }
  // Nebengassen: Gitter mit Versatz
  // Nebengassen schwingen sanft (keine Schachbrett-Stadt)
  for (var x = 30; x < b - 16; x += 22 + r.ganz(8)) {
    if ((x - ix).abs() < 18) continue;
    final dz = r.ganz(20);
    final ph = r.kommazahl() * 6.28, amp = 3 + r.ganz(4);
    for (var z = 10 + dz; z <= t - 10 - dz; z++) {
      final xx = x + (amp * math.sin(z / 19 + ph)).round();
      gasse(xx, z, xx + 3, z);
    }
  }
  for (var z = 26; z < t - 16; z += 22 + r.ganz(8)) {
    if ((z - iz).abs() < 18) continue;
    final dx = r.ganz(20);
    final ph = r.kommazahl() * 6.28, amp = 3 + r.ganz(4);
    for (var x = 10 + dx; x <= b - 10 - dx; x++) {
      final zz = z + (amp * math.sin(x / 23 + ph)).round();
      gasse(x, zz, x, zz + 3);
    }
  }
  // Marktplatz (30 × 24 m) und Kirchplatz (Kirchhügel, Westen)
  const markt = _Rechteck(ix - 30, iz - 24, ix + 29, iz + 23);
  gasse(markt.x0, markt.z0, markt.x1, markt.z1);
  const kirche = _Rechteck(28, iz - 26, 78, iz + 22);
  gasse(kirche.x0, kirche.z0, kirche.x1, kirche.z1);

  final dinge = <Ding>[];
  final marken = <String, (int, int)>{};
  final karte = List.generate(t, (z) => List.of(art[z]));
  void setze(_Rechteck q, String c) {
    for (var z = q.z0; z <= q.z1; z++) {
      for (var x = q.x0; x <= q.x1; x++) {
        karte[z][x] = c;
      }
    }
  }

  final innen = <Bereich>[];
  // ------------------------------------------------------------ Wahrzeichen
  // Uhrturm mitten auf dem Marktplatz (ORT-01)
  const uhr = _Rechteck(ix - 6, iz - 6, ix + 5, iz + 5);
  setze(uhr, 'U');
  dinge.add(Ding('U', const Legende(KachelArt.objekt, 'Uhrturm (schlägt mechanisch weiter)', form: 'turm', hoehe: 20, textur: 'quaderMauer', station: 'ORT-01'),
      uhr.x0, uhr.z0, uhr.x1, uhr.z1));
  if (innenVorlagen.containsKey('innen-uhrturm')) {
    karte[uhr.z1][ix] = 'D';
    final json = innenVorlagen['innen-uhrturm']!;
    innen.add(Bereich.ausJson(json));
    marken['tuer-innen-uhrturm'] = (ix, uhr.z1 + 1);
    dinge.add(Ding('D', const Legende(KachelArt.tuer, 'Tür zum Uhrwerk', ziel: 'innen-uhrturm', zielMarke: 't', textur: 'eichenTuerEisen', hoehe: 2.2),
        ix, uhr.z1, ix, uhr.z1));
  }
  // Marktbrunnen
  const brunnen = _Rechteck(ix - 18, iz + 10, ix - 14, iz + 14);
  setze(brunnen, 'O');
  dinge.add(Ding('O', const Legende(KachelArt.objekt, 'Marktbrunnen', form: 'brunnen', hoehe: 0.9, textur: 'quaderMauer'),
      brunnen.x0, brunnen.z0, brunnen.x1, brunnen.z1));
  // Kirchenburg (ORT-12): Kirche, Ringmauer mit Tor, Friedhof
  final kq = _Rechteck(kirche.x0 + 12, kirche.z0 + 10, kirche.x0 + 34, kirche.z0 + 26);
  setze(kq, 'K');
  dinge.add(Ding('K', const Legende(KachelArt.objekt, 'Kirchenburg', form: 'haus', hoehe: 12, textur: 'quaderMauer', station: 'ORT-12'),
      kq.x0, kq.z0, kq.x1, kq.z1));
  if (innenVorlagen.containsKey('innen-kirche')) {
    final tx = kq.x1, tz = (kq.z0 + kq.z1) ~/ 2;
    karte[tz][tx] = 'D';
    innen.add(Bereich.ausJson(innenVorlagen['innen-kirche']!));
    marken['tuer-innen-kirche'] = (tx + 1, tz);
    dinge.add(Ding('D', const Legende(KachelArt.tuer, 'Kirchentür', ziel: 'innen-kirche', zielMarke: 't', textur: 'eichenTuerEisen', hoehe: 3),
        tx, tz, tx, tz));
  }
  // Friedhof: Grabsteine
  for (var k = 0; k < 14; k++) {
    final gx = kirche.x0 + 4 + (k % 7) * 6, gz = kirche.z1 - 12 + (k ~/ 7) * 6;
    if (karte[gz][gx] != '.' || karte[gz][gx + 1] != '.') continue;
    setze(_Rechteck(gx, gz, gx + 1, gz), 'O');
    dinge.add(Ding('O', const Legende(KachelArt.objekt, 'Grabstein', form: 'kiste', hoehe: 0.8, textur: 'quaderMauer'), gx, gz, gx + 1, gz));
  }
  // Überdachte Holztreppe (Laubengang, begehbar) vom Kirchplatz zur Querstraße
  final laube = _Rechteck(kirche.x1 + 1, iz - 2, kirche.x1 + 24, iz + 1);
  for (var z = laube.z0; z <= laube.z1; z++) {
    for (var x = laube.x0; x <= laube.x1; x++) {
      if (karte[z][x] == '.') karte[z][x] = 'L';
    }
  }
  dinge.add(Ding('L', const Legende(KachelArt.station, 'Überdachte Holztreppe', form: 'laube', hoehe: 2.6, textur: 'holzBohlen'),
      laube.x0, laube.z0, laube.x1, laube.z1));

  // ------------------------------------------------------------ Häuser an den Gassen
  bool frei(_Rechteck q) {
    if (q.x0 < 1 || q.z0 < 1 || q.x1 >= b - 1 || q.z1 >= t - 1) return false;
    for (var z = q.z0; z <= q.z1; z++) {
      for (var x = q.x0; x <= q.x1; x++) {
        if (karte[z][x] != 'B') return false;
      }
    }
    return true;
  }

  final fussabdruecke = <(_Rechteck, String, int, int)>[]; // Rechteck, Türseite, Türkachel x/z
  for (var z = 1; z < t - 1; z++) {
    for (var x = 1; x < b - 1; x++) {
      if (karte[z][x] != 'B') continue;
      // Gasse im Norden/Süden/Westen/Osten?
      final seiten = <String>[
        if (karte[z - 1][x] == '.') 'n',
        if (karte[z + 1][x] == '.') 's',
        if (karte[z][x - 1] == '.') 'w',
        if (karte[z][x + 1] == '.') 'o',
      ];
      if (seiten.isEmpty) continue;
      final seite = seiten.first;
      final front = 8 + r.ganz(5), tiefe = 10 + r.ganz(7);
      final q = switch (seite) {
        'n' => _Rechteck(x, z, x + front - 1, z + tiefe - 1),
        's' => _Rechteck(x, z - tiefe + 1, x + front - 1, z),
        'w' => _Rechteck(x, z, x + tiefe - 1, z + front - 1),
        _ => _Rechteck(x - tiefe + 1, z, x, z + front - 1),
      };
      // ggf. kleiner versuchen
      var hq = q;
      if (!frei(hq)) {
        final klein = switch (seite) {
          'n' => _Rechteck(x, z, x + 7, z + 8),
          's' => _Rechteck(x, z - 8, x + 7, z),
          'w' => _Rechteck(x, z, x + 8, z + 7),
          _ => _Rechteck(x - 8, z, x, z + 7),
        };
        if (!frei(klein)) continue;
        hq = klein;
      }
      // Tür so mittig wie möglich, aber nur mit Gasse davor
      final kandidaten = <(int, int, int)>[]; // (Abstand zur Mitte, x, z)
      if (seite == 'n' || seite == 's') {
        final zz = seite == 'n' ? hq.z0 : hq.z1, vor = seite == 'n' ? zz - 1 : zz + 1;
        for (var xx = hq.x0 + 1; xx < hq.x1; xx++) {
          if (karte[vor][xx] == '.') kandidaten.add(((xx - (hq.x0 + hq.x1) ~/ 2).abs(), xx, zz));
        }
      } else {
        final xx = seite == 'w' ? hq.x0 : hq.x1, vor = seite == 'w' ? xx - 1 : xx + 1;
        for (var zz = hq.z0 + 1; zz < hq.z1; zz++) {
          if (karte[zz][vor] == '.') kandidaten.add(((zz - (hq.z0 + hq.z1) ~/ 2).abs(), xx, zz));
        }
      }
      if (kandidaten.isEmpty) continue;
      kandidaten.sort((a, c) => a.$1.compareTo(c.$1));
      final (_, tx, tz) = kandidaten.first;
      setze(hq, 'H');
      fussabdruecke.add((hq, seite, tx, tz));
    }
  }
  // Restflächen: Gärten und Höfe hinter Mauern (blockierend, niedrig)
  for (var z = 1; z < t - 1; z++) {
    for (var x = 1; x < b - 1; x++) {
      if (karte[z][x] != 'B') continue;
      var x1 = x;
      while (x1 + 1 < b && karte[z][x1 + 1] == 'B' && x1 - x < 24) {
        x1++;
      }
      var z1 = z;
      while (z1 + 1 < t && z1 - z < 24) {
        var ok = true;
        for (var xx = x; xx <= x1; xx++) {
          if (karte[z1 + 1][xx] != 'B') ok = false;
        }
        if (!ok) break;
        z1++;
      }
      final q = _Rechteck(x, z, x1, z1);
      setze(q, 'G');
      dinge.add(Ding('G', Legende(KachelArt.objekt, 'Gartenmauer', form: 'garten', hoehe: 1.2, textur: 'bruchsteinMauer'), x, z, x1, z1));
    }
  }

  // ------------------------------------------------------------ Viertel und Zuordnung der Häuser
  String viertel(double x, double z) {
    final e = ell(x, z);
    if (z < cz - rz * 0.5) return 'Burgberg';
    if (e > 0.62) return 'Mauerviertel';
    if (x < cx - rx * 0.35) return 'Kirchhügel';
    if (x > cx + rx * 0.35) return 'Handwerkergasse';
    if (z > cz + rz * 0.35) return 'Untere Stadt';
    return 'Marktviertel';
  }

  final nachViertel = <String, List<int>>{};
  for (var i = 0; i < fussabdruecke.length; i++) {
    final q = fussabdruecke[i].$1;
    nachViertel.putIfAbsent(viertel(q.cx, q.cz), () => []).add(i);
  }
  // Häuser nahe am Marktplatz zuerst (für die Markt-Fall-Orte)
  for (final l in nachViertel.values) {
    l.sort((a, c) {
      final qa = fussabdruecke[a].$1, qc = fussabdruecke[c].$1;
      final da = (qa.cx - ix).abs() + (qa.cz - iz).abs(), dc = (qc.cx - ix).abs() + (qc.cz - iz).abs();
      return da.compareTo(dc);
    });
  }
  final belegt = <int>{};
  final hausInnen = <String, String>{};
  final viertelVonHaus = <String, String>{};
  const ortVorlage = {
    'ORT-02': 'innen-museum',
    'ORT-03': 'innen-pension',
    'ORT-04': 'innen-schreinerei',
    'ORT-05': 'innen-fundus',
    'ORT-06': 'innen-stromhaus',
    'ORT-07': 'innen-teestube',
    'ORT-08': 'innen-baeckerei',
    'ORT-09': 'innen-rathaus',
    'ORT-10': 'innen-bibliothek',
    'ORT-11': 'innen-apotheke',
    'ORT-12': 'innen-kirche',
  };
  final vorlagenNachTyp = <String, List<String>>{};
  for (final id in innenVorlagen.keys) {
    final typ = RegExp(r'^innen-([a-z]+)').firstMatch(id)?.group(1) ?? 'wohnstube';
    vorlagenNachTyp.putIfAbsent(typ, () => []).add(id);
  }
  final typZaehler = <String, int>{};
  String? vorlageFuer(Map<String, dynamic> h) {
    final ort = h['ort'] as String?;
    if (ort != null && ortVorlage.containsKey(ort) && innenVorlagen.containsKey(ortVorlage[ort])) return ortVorlage[ort];
    final ir = (h['innenraum'] as String? ?? '').toLowerCase();
    final typ = switch (ir) {
      'werkstatt' || 'schreinerei' => 'werkstatt',
      'laden' || 'bäckerei' || 'apotheke' || 'teestube' => 'laden',
      'speicher' || 'archiv' || 'schaltraum' || 'uhrwerk' => 'speicher',
      'amtsstube' || 'bibliothek' || 'museum' || 'kirche' || 'fundus' || 'pension' => 'zunftstube',
      _ => 'wohnstube',
    };
    final l = vorlagenNachTyp[typ] ?? vorlagenNachTyp['wohnstube'];
    if (l == null || l.isEmpty) return null;
    final n = typZaehler[typ] = (typZaehler[typ] ?? -1) + 1;
    return l[n % l.length];
  }

  var gebaeude = 0;
  final genutzteFallVorlagen = <String>{};
  void baueHaus(int fi, Map<String, dynamic>? h) {
    final (q, seite, tx, tz) = fussabdruecke[fi];
    belegt.add(fi);
    gebaeude++;
    final id = h?['id'] as String? ?? 'X-$fi';
    final name = h?['name'] as String? ?? 'Wohnhaus';
    final putz = const ['putzOcker', 'putzAltrosa', 'putzTaubenblau', 'putzCreme', 'putzKalkweiss', 'putzSandstein'][(fi * 7 + q.x0) % 6];
    final hoehe = 6.5 + (fi % 4) * 0.8;
    dinge.add(Ding('H', Legende(KachelArt.objekt, name, form: 'haus', hoehe: hoehe, textur: putz), q.x0, q.z0, q.x1, q.z1));
    // Tür: mittig zur Gasse; Marke davor
    final (mx, mz) = switch (seite) { 'n' => (tx, tz - 1), 's' => (tx, tz + 1), 'w' => (tx - 1, tz), _ => (tx + 1, tz) };
    karte[tz][tx] = 'D';
    String? zielId;
    if (h != null && h['betretbar'] == true) {
      final v = vorlageFuer(h);
      if (v != null) {
        final istFall = v.startsWith('innen-') && ortVorlage.values.contains(v) && !genutzteFallVorlagen.contains(v);
        zielId = istFall ? v : 'haus-$id';
        if (istFall) genutzteFallVorlagen.add(v);
        final json = Map<String, dynamic>.from(innenVorlagen[v]!);
        json['id'] = zielId;
        json['name'] = istFall ? json['name'] : name;
        // Türen des Innenraums auf die eigene Marke umleiten
        final leg = <String, dynamic>{};
        for (final e in (json['legende'] as Map).entries) {
          final l = Map<String, dynamic>.from(e.value as Map);
          if (l['ziel'] == 'stadt') l['zielMarke'] = 'tuer-$zielId';
          leg[e.key as String] = l;
        }
        json['legende'] = leg;
        innen.add(Bereich.ausJson(json));
        hausInnen[id] = zielId;
        marken['tuer-$zielId'] = (mx, mz);
      }
    }
    viertelVonHaus[id] = viertel(q.cx, q.cz);
    dinge.add(Ding(
        'D',
        Legende(KachelArt.tuer, zielId == null ? '$name (dunkel, verschlossen)' : name,
            ziel: zielId ?? 'stadt', zielMarke: zielId == null ? 'b' : 't', verschlossen: zielId == null, textur: 'eichenTuer', hoehe: 2.2),
        tx,
        tz,
        tx,
        tz));
  }

  final hausListe = [...haeuser];
  // Fall-Orte und benannte Häuser je Viertel zuordnen
  for (final h in hausListe) {
    if ((h['ort'] as String?) == 'ORT-01') continue; // Uhrturm ist Wahrzeichen
    if ((h['ort'] as String?) == 'ORT-12') continue; // Kirchenburg ist Wahrzeichen
    final v = h['viertel'] as String;
    final kandidaten = (nachViertel[v] ?? const <int>[]).where((i) => !belegt.contains(i)).toList();
    final i = kandidaten.isNotEmpty
        ? kandidaten.first
        : List.generate(fussabdruecke.length, (i) => i).firstWhere((i) => !belegt.contains(i), orElse: () => -1);
    if (i < 0) break;
    baueHaus(i, h);
  }
  for (var i = 0; i < fussabdruecke.length; i++) {
    if (!belegt.contains(i)) baueHaus(i, null);
  }

  // ------------------------------------------------------------ Tore in der Mauer
  int mauerZ(int x, int richtung) {
    var z = iz;
    while (z > 0 && z < t - 1 && karte[z][x] != '#') {
      z += richtung;
    }
    return z;
  }

  int mauerX(int z, int richtung) {
    var x = ix;
    while (x > 0 && x < b - 1 && karte[z][x] != '#') {
      x += richtung;
    }
    return x;
  }

  void tor(int x0, int z0, int x1, int z1, Legende l, String? marke, (int, int) markePos) {
    for (var z = z0; z <= z1; z++) {
      for (var x = x0; x <= x1; x++) {
        karte[z][x] = 'D';
      }
    }
    dinge.add(Ding('D', l, x0, z0, x1, z1));
    if (marke != null) marken[marke] = markePos;
  }

  final nz = mauerZ(ix, -1);
  tor(ix - 4, nz - 1, ix + 3, nz, const Legende(KachelArt.tuer, 'Burgtor (hinauf in den Burghof)', ziel: 'hof', zielMarke: 'b', textur: 'eichenTuerEisen', hoehe: 3.5),
      'b', (ix, nz + 1));
  final sz = mauerZ(ix, 1);
  tor(ix - 4, sz, ix + 3, sz + 1,
      const Legende(KachelArt.tuer, 'Untertor (verschlossen bis zum Morgengrauen)', ziel: 'stadt', zielMarke: 'b', verschlossen: true, textur: 'eichenTuerEisen', hoehe: 3.5),
      'untertor', (ix, sz - 1));
  final ox = mauerX(iz, 1);
  tor(ox, iz - 4, ox + 1, iz + 3,
      const Legende(KachelArt.tuer, 'Obertor (verschlossen bis zum Morgengrauen)', ziel: 'stadt', zielMarke: 'b', verschlossen: true, textur: 'eichenTuerEisen', hoehe: 3.5),
      'obertor', (ox - 1, iz));
  // Turmpforte zum Wehrgang der Burg (nachts verschlossen) – im Westen
  final wx = mauerX(iz, -1);
  tor(wx - 1, iz - 2, wx, iz + 1,
      const Legende(KachelArt.tuer, 'Turmpforte zum Mauerweg (nachts verschlossen)', ziel: 'stadt', zielMarke: 'b', verschlossen: true, textur: 'eichenTuerEisen', hoehe: 2.4),
      null, (0, 0));

  // ------------------------------------------------------------ Gangnetz unter der Stadt
  final abgaenge = <(int, int)>[
    (ix + 12, iz + 12), // Marktplatz
    (kirche.x0 + 6, kirche.z0 + 4), // Kirchplatz
    (ix + 100, iz - 3), // Querstraße Ost
    (ix + 2, iz + 80), // Hauptgasse Süd
    (ix + 2, iz - 70), // Hauptgasse Nord
  ];
  const gb = 120, gt = 80;
  final g = List.generate(gt, (_) => List.filled(gb, '#'));
  void gang(int x0, int z0, int x1, int z1) {
    for (var z = math.min(z0, z1); z <= math.max(z0, z1); z++) {
      for (var x = math.min(x0, x1); x <= math.max(x0, x1); x++) {
        if (x > 0 && z > 0 && x < gb - 1 && z < gt - 1) g[z][x] = '.';
      }
    }
  }

  // Abgänge im Gangnetz verteilt, alle über einen Hauptgang verbunden
  final gpos = <(int, int)>[(10, 10), (30, 60), (60, 20), (90, 60), (108, 12)];
  gang(10, 38, 108, 41);
  for (final (x, z) in gpos) {
    gang(x - 1, math.min(z, 39), x + 2, math.max(z, 40));
    gang(x - 3, z - 3, x + 4, z + 4); // Kammer
  }
  final gdinge = <Ding>[];
  final gmarken = <String, (int, int)>{};
  for (var k = 0; k < abgaenge.length; k++) {
    final (ax, az) = abgaenge[k];
    final (gx, gz) = gpos[k];
    if (karte[az][ax] != '.' || karte[az][ax + 1] != '.') continue;
    // Abgang in der Stadt (Falltür im Pflaster als Tür-Objekt)
    karte[az][ax] = 'D';
    dinge.add(Ding('D', Legende(KachelArt.tuer, 'Kellerabgang zu den Gewölbegängen', ziel: 'gaenge', zielMarke: 'abgang-$k', textur: 'holzBohlen', hoehe: 1.0),
        ax, az, ax, az));
    marken['gang-$k'] = (ax + 1, az);
    // Treppe hinauf im Gangnetz
    g[gz - 4][gx] = 'D';
    gdinge.add(Ding('D', Legende(KachelArt.tuer, 'Treppe hinauf', ziel: 'stadt', zielMarke: 'gang-$k', textur: 'stufenStein', hoehe: 2.2), gx, gz - 4, gx, gz - 4));
    gmarken['abgang-$k'] = (gx, gz - 3);
  }
  final gaenge = Bereich(
    id: 'gaenge',
    name: 'Gewölbegänge unter der Stadt',
    innen: true,
    raumHoehe: 2.4,
    wandTextur: 'bruchsteinMauer',
    bodenTextur: 'erde',
    deckenTextur: 'gewoelbeDecke',
    grundKalt: 0.02,
    karte: [
      for (final z in g) z.map((c) => c == 'D' ? 'D' : c).join(),
    ],
    legende: const {'D': Legende(KachelArt.tuer, 'Treppe')},
    namensMarken: gmarken,
    vorgegebeneDinge: gdinge,
  );

  // Karte: Baufläche-Reste → Gasse
  final zeilen = [for (final z in karte) z.map((c) => c == 'B' ? '.' : c).join()];
  final stadt = Bereich(
    id: 'stadt',
    name: 'Oberstadt Schartenfels',
    innen: false,
    raumHoehe: 7,
    wandTextur: 'bruchsteinMauer',
    bodenTextur: 'pflaster',
    grundKalt: 0.42,
    karte: zeilen,
    legende: const {
      'H': Legende(KachelArt.objekt, 'Haus'),
      'G': Legende(KachelArt.objekt, 'Garten'),
      'U': Legende(KachelArt.objekt, 'Uhrturm'),
      'K': Legende(KachelArt.objekt, 'Kirche'),
      'O': Legende(KachelArt.objekt, 'Objekt'),
      'D': Legende(KachelArt.tuer, 'Tür'),
      'L': Legende(KachelArt.station, 'Laube'),
    },
    namensMarken: marken,
    vorgegebeneDinge: dinge,
  );
  return StadtPlan(stadt, gaenge, innen, hausInnen, viertelVonHaus, gebaeude + 2);
}

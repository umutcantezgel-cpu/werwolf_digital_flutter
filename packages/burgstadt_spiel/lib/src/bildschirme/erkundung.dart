import 'dart:convert';
import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

import '../blasen_layout.dart';
import '../fallsitzung.dart';
import '../spiel.dart';
import '../kompass.dart';
import '../steuerung.dart';
import 'fallakte.dart';
import 'hauptmenue.dart';
import 'lagerunde.dart';
import 'optionen_bildschirm.dart';
import 'stadtkarte.dart';

/// Ich-Perspektive in der Burg: laufen, umsehen, Türen benutzen, untersuchen.
class Erkundung extends Bildschirm {
  String ort;
  double x = 0, z = 0, yaw = -math.pi / 2, pitch = 0;
  double _wippen = 0;
  bool licht = true;

  /// Detektivblick (Sichtschicht mit Spuren).
  bool blick = false;
  Spur? zielSpur;
  final Steuerung steuerung = Steuerung();
  String meldung = '';
  double _meldungZeit = 0;
  double _blende = 1; // 1 = schwarz, blendet auf
  Ding? ziel; // Ding im Blick (Tür, Möbel, Station)
  Figur? zielFigur; // Figur im Blick

  /// Laufender Fall (null = freie Erkundung ohne Fall).
  final Fallsitzung? sitzung;
  int _lagerundePhase = 0;
  final List<(Ereignis, double)> _karten = []; // angezeigte Hinweiskarten mit Restzeit

  /// Gerade angezeigte Hinweiskarten (für Tests und Barrierefreiheit).
  List<Ereignis> get karten => [for (final k in _karten) k.$1];

  static const gehen = 1.6, rennen = 3.2, reichweite = 1.5;

  Erkundung({this.ort = 'gewoelbe', String marke = 'm', this.sitzung}) {
    _setzeAn(ort, marke);
  }

  late Bereich _bereich;

  void _setzeAn(String id, String marke) {
    ort = id;
    _bereich = _welt!.bereiche[id]!;
    final (mx, mz) = _bereich.markePos(marke);
    x = mx;
    z = mz;
    // Blick in den Raum: zur Mitte des Bereichs
    final cx = _bereich.breite * kKachel / 2, cz = _bereich.tiefe * kKachel / 2;
    yaw = math.atan2(cz - z, cx - x);
    pitch = 0;
  }

  // Die Welt wird beim ersten Tick gesetzt (Bildschirme kennen das Spiel erst dann).
  static Welt? _welt = Welt(baueBurg());

  @override
  bool get menueNavigation => false;

  @override
  bool get zeigtTutorial => true;

  double _schrittWeg = 0;
  double _gelaufen = 0;

  double _seitSpeichern = 0;

  /// Spielstand sichern (Fall, eigene Lage, besuchte Orte, gezeigte Tutorial-Schritte).
  void speichern(Spiel spiel) {
    final sz = sitzung;
    if (sz == null || sz.fall.abschnitt == Abschnitt.ende) return;
    _seitSpeichern = 0;
    final j = jsonEncode({
      'sitzung': sz.zuJson(),
      'ort': ort,
      'x': x,
      'z': z,
      'yaw': yaw,
      'besucht': [...spiel.besucht],
      'tutorial': [...spiel.tutorial.gezeigt],
    });
    spiel.letzterStand = j;
    spiel.spielstand?.speichere(j);
  }

  /// Gespeicherten Stand fortsetzen; `null`, wenn keiner da ist oder er nicht passt.
  static Erkundung? fortsetzen(Spiel spiel) {
    final roh = spiel.letzterStand, daten = spiel.fallDaten;
    if (roh == null || daten == null) return null;
    final j = jsonDecode(roh) as Map<String, dynamic>;
    final s = Fallsitzung.ausJson(daten, spiel.stadt, spiel.teile, spiel.karten, j['sitzung'] as Map<String, dynamic>,
        bewohner: spiel.bewohnerDaten, haeuser: spiel.haeuserDaten);
    final ort = j['ort'] as String;
    if (s == null || !spiel.stadt.bereiche.containsKey(ort)) return null;
    spiel.besucht
      ..clear()
      ..addAll([for (final b in j['besucht'] as List) b as String]);
    spiel.tutorial.gezeigt
      ..clear()
      ..addAll([for (final t in j['tutorial'] as List) t as String]);
    return Erkundung(sitzung: s)
      ..ort = ort
      ..x = (j['x'] as num).toDouble()
      ..z = (j['z'] as num).toDouble()
      ..yaw = (j['yaw'] as num).toDouble();
  }

  void _tutorial(Spiel spiel, String ausloeser) {
    if (sitzung != null) spiel.tutorial.ausloesen(ausloeser, an: spiel.optionen.tutorial);
  }

  /// Schlüssel der Ortsansage: Fall-Ort (Station ORT-nn) oder Bereichs-ID.
  String _ortSchluessel() {
    for (final d in _bereich.dinge) {
      final st = d.legende.station;
      if (st != null && st.startsWith('ORT-')) return st;
    }
    return _bereich.id;
  }
  int _schrittNr = 0;

  @override
  void betreten(Spiel spiel) {
    _welt = spiel.stadt;
    _bereich = spiel.stadt.bereiche[ort]!;
    spiel.ton.schleife('musik', _bereich.innen ? 'musik_gewoelbe_schleife' : null, lautstaerke: 0.3);
    spiel.ton.schleife('umgebung', _bereich.innen ? 'kaminglut_schleife' : 'wind_schleife', lautstaerke: _bereich.innen ? 0.2 : 0.45);
    if (_meldungZeit <= 0) _meldung(_bereich.name);
    // Ortsansage des Erzählers beim ersten Betreten
    final sz = sitzung;
    if (sz != null && spiel.besucht.add(ort)) {
      final t = spiel.erzaehler?.ort(_ortSchluessel(), spiel.besucht.length);
      if (t != null) _karten.add((Ereignis('erzaehler', t, uhr: sz.fall.uhr), 5.0));
      if (ort == 'stadt') _tutorial(spiel, 'stadt');
    }
  }

  @override
  void tick(Spiel spiel, double dt, Eingabe e) {
    final s = spiel.skala!;
    _blende = math.max(0, _blende - dt * 3);
    steuerung.verarbeite(e, spiel.pixelUi, s.uiW, dt, empfindlichkeit: spiel.optionen.blickEmpfindlichkeit);
    yaw += steuerung.drehen;
    pitch = (pitch + steuerung.nicken).clamp(-1.1, 1.1);
    final v = e.haelt(Taste.rennen) ? rennen : gehen;
    final fx = math.cos(yaw), fz = math.sin(yaw);
    final rx = -fz, rz = fx;
    final gx = steuerung.gehenX, gy = steuerung.gehenY;
    final nx = x + (fx * gy + rx * gx) * v * dt, nz = z + (fz * gy + rz * gx) * v * dt;
    final x0 = x, z0 = z;
    if (_bereich.frei(nx, z)) x = nx;
    if (_bereich.frei(x, nz)) z = nz;
    final weg = math.sqrt((x - x0) * (x - x0) + (z - z0) * (z - z0));
    if (weg > 0.0005) _wippen += weg * 5.5;
    _schrittWeg += weg;
    _gelaufen += weg;
    if (_gelaufen > 2) _tutorial(spiel, 'erste_bewegung');
    if (_schrittWeg > 0.72) {
      _schrittWeg = 0;
      final boden = _bereich.innen ? 'stein' : (_bereich.id == 'wehrgang' ? 'holz' : 'pflaster');
      spiel.ton.spiele('schritt_${boden}_${_schrittNr++ % 4 + 1}', lautstaerke: 0.45);
    }
    ziel = _blickziel();
    zielFigur = _blickFigur();
    final sz = sitzung;
    if (sz != null) {
      if (spiel.besucht.add('#einfuehrung')) {
        _tutorial(spiel, 'start');
        final t = spiel.erzaehler?.uhr('einfuehrung', 0);
        if (t != null) _karten.add((Ereignis('erzaehler', t, uhr: sz.fall.uhr), 6.0));
      }
      if (zielFigur != null) _tutorial(spiel, 'erste_figur');
      if (ziel?.legende.station != null) _tutorial(spiel, 'erste_station');
      sz.tick(dt);
      sz.figuren.backe(3); // Budget je Bild: Spitze bleibt mit Abstand unter 50 ms × 1/4 (Z-09)
      sz.position(ort, x, z, yaw, 'stehen', dt);
      for (final ev in sz.anzeige) {
        _karten.add((ev, ev.text.length > 90 ? 6.0 : 4.0));
        if (ev.art == 'belauscht' || ev.art == 'teilen' || ev.art == 'fund') spiel.ton.spiele('hinweis_gefunden', lautstaerke: 0.5);
        if (ev.art == 'fund') _tutorial(spiel, 'erster_fund');
        if (ev.art == 'teilen') _tutorial(spiel, 'teilen');
        if (ev.art == 'phase') {
          _seitSpeichern = 1e9; // nach dem Phasenwechsel sichern
          spiel.ton.spiele('uhrturm_schlag', lautstaerke: 0.8);
          final p = sz.fall.phase;
          final t = spiel.erzaehler?.uhr('phase$p', p);
          if (t != null) _karten.add((Ereignis('erzaehler', t, uhr: sz.fall.uhr), 6.0));
          if (p == 2) _tutorial(spiel, 'phase2');
        }
      }
      sz.anzeige.clear();
      _seitSpeichern += dt;
      if (_seitSpeichern > 60) speichern(spiel);
      while (_karten.length > 3) {
        _karten.removeAt(0);
      }
      if (sz.fall.abschnitt == Abschnitt.lagerunde && _lagerundePhase != sz.fall.phase) {
        _lagerundePhase = sz.fall.phase;
        spiel.ton.spiele('uhrturm_schlag');
        _tutorial(spiel, 'lagerunde');
        spiel.oeffne(LagerundeBildschirm(sz));
      }
      if (e.gedrueckt(Taste.akte)) {
        _tutorial(spiel, 'akte');
        spiel.oeffne(FallakteBildschirm(sz));
      }
    }
    for (var i = _karten.length - 1; i >= 0; i--) {
      final (ev, t) = _karten[i];
      if (t - dt <= 0) {
        _karten.removeAt(i);
      } else {
        _karten[i] = (ev, t - dt);
      }
    }
    if (e.gedrueckt(Taste.licht)) {
      licht = !licht;
      spiel.ton.spiele('handylicht_klick');
      _tutorial(spiel, 'licht');
    }
    if (e.gedrueckt(Taste.blick)) _blickUmschalten(spiel);
    if (blick) _tutorial(spiel, 'blick');
    zielSpur = blick ? _naechsteSpur(spiel) : null;
    if (e.gedrueckt(Taste.menue) || e.gedrueckt(Taste.zurueck)) spiel.oeffne(_Pause(this));
    if (e.gedrueckt(Taste.karte)) karteOeffnen(spiel);
    if (steuerung.tippAktion || e.gedrueckt(Taste.aktion)) _handle(spiel);
    _meldungZeit -= dt;
  }

  /// Stadtkarte mit Schnellreise zu besuchten Fall-Orten (erst wenn das Burgtor offen ist).
  void karteOeffnen(Spiel spiel) {
    spiel.oeffne(StadtkarteBildschirm(this, reise: (marke) {
      if (_phase < 2) {
        _meldung('Das Burgtor ist noch verschlossen – die Oberstadt erst ab Phase 2.');
        return;
      }
      _setzeAn('stadt', marke);
      _blende = 1;
      betreten(spiel);
      spiel.ton.spiele('schritt_pflaster_1', lautstaerke: 0.6);
    }));
  }

  /// Erstes Ding in Blickrichtung bis [reichweite] (Tür, Möbel, Station).
  Ding? _blickziel() {
    final fx = math.cos(yaw), fz = math.sin(yaw);
    for (var t = 0.2; t <= reichweite; t += 0.1) {
      final px = x + fx * t, pz = z + fz * t;
      final kx = (px / kKachel).floor(), kz = (pz / kKachel).floor();
      final a = _bereich.art(kx, kz);
      final d = _bereich.dingAn(kx, kz);
      if (d != null && (a == KachelArt.tuer || a == KachelArt.objekt || a == KachelArt.station)) {
        if (a == KachelArt.objekt && d.legende.station == null && d.legende.form != 'tuerdeko') {
          return d; // Möbel: benennbar
        }
        return d;
      }
      if (a == KachelArt.wand || a == KachelArt.leer) return null;
    }
    return null;
  }

  /// Figur der Sitzung im Blick (bis 2,4 m, enger Winkel).
  Figur? _blickFigur() {
    final sz = sitzung;
    if (sz == null) return null;
    Figur? best;
    var bestD = 2.4;
    for (final f in sz.sim.figuren.values) {
      if (f.id == sz.ich || f.bereich != ort) continue;
      final dx = f.x - x, dz = f.z - z;
      final d = math.sqrt(dx * dx + dz * dz);
      if (d > bestD) continue;
      var a = math.atan2(dz, dx) - yaw;
      a = math.atan2(math.sin(a), math.cos(a));
      if (a.abs() > 0.4) continue;
      best = f;
      bestD = d;
    }
    return best;
  }

  int get _phase => sitzung?.fall.phase ?? 1;

  void _blickUmschalten(Spiel spiel) {
    blick = !blick;
    spiel.ton.spiele(blick ? 'detektivblick_an' : 'detektivblick_aus', lautstaerke: 0.6);
  }

  /// Nächste Spur im Blickfeld (bis 2,5 m), deren Beschreibung angezeigt wird.
  Spur? _naechsteSpur(Spiel spiel) {
    Spur? best;
    var bestD = 2.5;
    for (final s in spiel.spurenFuer(sitzung)) {
      if (s.bereich != ort || s.abPhase > _phase || !s.sicht.contains('detektiv')) continue;
      final dx = s.x - x, dz = s.z - z;
      final d = math.sqrt(dx * dx + dz * dz);
      if (d > bestD) continue;
      var a = math.atan2(dz, dx) - yaw;
      a = math.atan2(math.sin(a), math.cos(a));
      if (a.abs() > 0.5) continue;
      best = s;
      bestD = d;
    }
    return best;
  }

  String _name(Figur f) {
    if (f.id == 'BW') return 'Burgwart Eckehard';
    if (f.id == FallZustand.detektiv) return 'Detektiv';
    final b = sitzung?.sim.bewohner[f.id];
    if (b != null) return '${b.name} (${b.beruf})';
    return sitzung?.fall.daten.rollen[f.id]?.name ?? f.id;
  }

  void _handle(Spiel spiel) {
    final fig = zielFigur;
    final sz = sitzung;
    if (fig != null && sz != null) {
      if (fig.id == 'BW') {
        final a = sz.fall.daten.burgwartAussagen[sz.fall.phase] ?? '';
        sz.melde([Ereignis('aussage', 'Burgwart: $a', von: 'BW', uhr: sz.fall.uhr)]);
        if (sz.fall.phase >= 2) sz.untersuche('BW');
      } else {
        sz.frage(fig.id);
        _tutorial(spiel, 'gespraech');
      }
      spiel.ton.spiele('papier_rascheln', lautstaerke: 0.4);
      return;
    }
    final d = ziel;
    if (d == null) {
      _meldung('Hier ist nichts Besonderes.');
      return;
    }
    final l = d.legende;
    switch (l.art) {
      case KachelArt.tuer:
        if (!Bereich.offen(l, _phase)) {
          spiel.ton.spiele('schluessel_klimpern', lautstaerke: 0.4);
          _meldung(l.offenAbPhase != null
              ? '${l.name}: Der Burgwart schließt erst in Phase ${l.offenAbPhase} auf.'
              : '${l.name}: verschlossen.');
          return;
        }
        spiel.ton.spiele(l.textur == 'eisenGitter' ? 'tuer_eisen' : (l.textur == 'stufenStein' ? 'schritt_stein_1' : 'tuer_eiche_auf'), lautstaerke: 0.7);
        _setzeAn(l.ziel!, l.zielMarke!);
        _blende = 1;
        betreten(spiel);
      case KachelArt.station:
      case KachelArt.objekt:
        if (l.station != null && sz != null) {
          final funde = sz.untersuche(l.station!);
          // Im WLAN-Spiel kommen die Funde als Ereignis vom Gastgeber
          if (funde.isEmpty && !sz.imNetz) {
            final ort = sz.fall.daten.kanon.datensaetze[l.station!];
            final rolle = ort?.feld('Rolle im Fall');
            if (rolle != null) {
              sz.melde([Ereignis('aussage', '${ort!.feld('Ort') ?? l.name}: ${rolle.replaceFirst(RegExp(r'^(Farbe|bestätigend|entlastend[^(]*)\s*'), '')}', uhr: sz.fall.uhr)]);
            } else {
              _meldung('${l.name}: nichts Neues.');
            }
          }
          spiel.ton.spiele('papier_rascheln', lautstaerke: 0.5);
        } else {
          _meldung(l.station != null ? '${l.name}: Hier lohnt ein genauer Blick.' : l.name);
        }
      default:
        _meldung(l.name);
    }
  }

  /// Höchstens [max] Zeilen; die letzte endet dann sichtbar mit „…“.
  static List<String> _gekuerzt(PixelUi ui, List<String> zeilen, int max) {
    if (zeilen.length <= max) return zeilen;
    return [...zeilen.take(max - 1), '${zeilen[max - 1]} …'];
  }

  void _meldung(String m) {
    meldung = m;
    _meldungZeit = 3;
  }

  @override
  void zeichneWelt(Spiel spiel) {
    final r = spiel.renderer;
    final wipp = spiel.optionen.kopfwippen ? math.sin(_wippen) * 0.03 : 0.0;
    r.camera
      ..x = x
      ..z = z
      ..y = 1.62 + wipp
      ..yaw = yaw
      ..pitch = pitch;
    var flash = licht ? 0.9 : 0.0;
    if (licht && !spiel.optionen.flackernAus) flash *= 0.97 + 0.03 * math.sin(spiel.zeit * 23);
    r.flashStrength = flash;
    spiel.zeichneBereich(ort, s: sitzung, blick: blick);
  }

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    if (_blende > 0) {
      // Überblendung beim Raumwechsel: Dither-Vorhang
      final stufe = (_blende * 16).round();
      for (var y = 0; y < h; y++) {
        for (var xx = 0; xx < w; xx++) {
          if (bayer4[((y & 3) << 2) | (xx & 3)] < stufe) ui.fb.color[y * w + xx] = Pal.black;
        }
      }
    }
    final cx = w ~/ 2, cy = h ~/ 2;
    final farbe = ziel != null ? UiFarbe.akzent : UiFarbe.text;
    ui.fb.fillRect(cx - 3, cy, 2, 1, farbe);
    ui.fb.fillRect(cx + 2, cy, 2, 1, farbe);
    ui.fb.fillRect(cx, cy - 3, 1, 2, farbe);
    ui.fb.fillRect(cx, cy + 2, 1, 2, farbe);
    final sz = sitzung;
    final ortName = _bereich.name;
    final zeitText = sz == null ? 'Freie Erkundung' : '${sz.uhrText} · Phase ${sz.fall.phase}';
    // HUD-Flächen zuerst: Sprechblasen weichen ihnen aus (die Knöpfe werden erst unten gezeichnet)
    final knoepfe = knopfSpalte(w, h);
    final sperren = hudSperren(ui.font, w, h, draussen: !_bereich.innen, ort: ortName, zeit: zeitText);
    ui.text(zeitText, 4, 3);
    // Kompass draußen: quer oben in der Mitte, hochkant unten in der Mitte
    if (!_bereich.innen) zeichneKompass(ui, yaw, kompassRechteck(w, h));
    // Sprechblasen über Figuren: Platz und Zipfel nach blasen_layout.dart
    if (sz != null) {
      final cam = spiel.renderer.camera;
      final kf = spiel.skala!.kWelt / spiel.skala!.kUi;
      final tmp = List<double>.filled(3, 0);
      // nächste Figuren zuerst: ihre Blase bekommt den Platz direkt über dem Kopf
      final sprecher = [
        for (final f in sz.sim.figuren.values)
          if (f.bereich == ort && f.blasenZeit > 0 && f.sprechblase != null) f,
      ]..sort((a, b) => ((a.x - x) * (a.x - x) + (a.z - z) * (a.z - z)).compareTo((b.x - x) * (b.x - x) + (b.z - z) * (b.z - z)));
      final wuensche = <BlasenWunsch>[];
      final zeilenListe = <List<String>>[];
      for (final f in sprecher) {
        cam.toView(f.x, 2.05, f.z, tmp, 0);
        if (tmp[2] < 0.4 || tmp[2] > 9) continue;
        final sx = (cam.cx + tmp[0] * cam.focal / tmp[2]) * kf, sy = (cam.cy - tmp[1] * cam.focal / tmp[2]) * kf;
        // bis 5 Zeilen (A-703a)
        final zeilen = _gekuerzt(ui, ui.font.wrap(f.sprechblase!, math.min(170, w - 20)), 5);
        final blaseH = zeilen.length * ui.zeilenHoehe + 4;
        final blaseB = zeilen.map(ui.font.measure).fold(0, math.max) + 8;
        wuensche.add(BlasenWunsch(sx, sy, blaseB, blaseH));
        zeilenListe.add(zeilen);
      }
      final plaetze = ordneBlasen(wuensche, w, h, sperren);
      for (var i = 0; i < plaetze.length; i++) {
        final r = plaetze[i];
        if (r == null) continue; // kein Platz: Blase entfällt, wie bisher
        ui.panel(r, grund: UiFarbe.grundDunkel, fangen: false);
        final kopfX = math.min(math.max(wuensche[i].sx.round(), r.x + 2), r.rechts - 3);
        _zeichneZipfel(ui, r, zipfelVon(wuensche[i], r), kopfX);
        for (var k = 0; k < zeilenListe[i].length; k++) {
          ui.text(zeilenListe[i][k], r.x + 4, r.y + 2 + k * ui.zeilenHoehe, schatten: null);
        }
      }
    }
    // auf dunkler Plakette: auf Mauern und Licht war die Schrift schwer lesbar (A-703a)
    final ow = ui.font.measure(ortName);
    ui.flaeche(ortsPlakette(w, ow, ui.font.height), UiFarbe.grundDunkel);
    ui.text(ortName, w - ow - 4, 3, farbe: UiFarbe.text, schatten: null);
    // Blickziel benennen
    final d = ziel;
    final fz = zielFigur;
    final sp = zielSpur;
    if (blick) ui.textMittig('Detektivblick', cx, 3, farbe: UiFarbe.spuk);
    if (sp != null && fz == null && d == null) {
      ui.textMittig(sp.beschreibung, cx, cy + 10, farbe: UiFarbe.spuk);
    } else if (fz != null) {
      ui.textMittig('${_name(fz)} – ansprechen', cx, cy + 10, farbe: UiFarbe.akzent);
    } else if (d != null) {
      final l = d.legende;
      final was = switch (l.art) {
        KachelArt.tuer => Bereich.offen(l, _phase) ? l.name : '${l.name} (verschlossen)',
        _ => l.name,
      };
      ui.textMittig(was, cx, cy + 10, farbe: UiFarbe.akzent);
    }
    // Knöpfe rechts (im Hochformat größer: auf dem Handy waren sie zu klein, A-703a)
    final bw = knoepfe[0].w;
    if (ui.knopf(
        knoepfe[0],
        fz != null ? 'Reden' : (d == null ? 'Aktion' : (d.legende.art == KachelArt.tuer ? 'Öffnen' : 'Ansehen')),
        hervorgehoben: d != null || fz != null)) {
      _handle(spiel);
    }
    if (ui.knopf(knoepfe[1], 'Licht', hervorgehoben: licht)) {
      licht = !licht;
      spiel.ton.spiele('handylicht_klick');
    }
    if (ui.knopf(knoepfe[2], 'Blick', hervorgehoben: blick)) _blickUmschalten(spiel);
    final neu = sz?.neueAkte ?? 0;
    if (ui.knopf(knoepfe[3], neu > 0 ? 'Akte $neu' : 'Akte', hervorgehoben: neu > 0)) {
      if (sz != null) {
        _tutorial(spiel, 'akte');
        spiel.oeffne(FallakteBildschirm(sz));
      } else {
        _meldung('Ohne Fall gibt es keine Akte.');
      }
    }
    if (ui.knopf(knoepfe[4], 'Menü')) spiel.oeffne(_Pause(this));
    final j = steuerung.joystick;
    if (j != null) {
      ui.kreis(j.$1, j.$2, Steuerung.joyRadius.round(), UiFarbe.rand);
      ui.kreis(j.$3, j.$4, 6, UiFarbe.text, gefuellt: true);
    }
    // Hinweiskarten (neueste unten)
    var ky = 16;
    for (final (ev, _) in _karten) {
      final titel = switch (ev.art) {
        'belauscht' => 'Mitgehört',
        'teilen' => 'Dir erzählt',
        'fund' => 'Gefunden',
        'akte' => 'Fallakte',
        'aussage' => 'Aussage',
        'erzaehler' => 'Erzähler',
        'phase' => 'Uhrturm',
        _ => 'Notiz',
      };
      final kw = math.min(w - bw - 20, 300);
      // bis 6 Zeilen; längere Texte enden sichtbar mit „…“ (ganz in der Akte, A-703a)
      final zeilen = _gekuerzt(ui, ui.font.wrap(ev.text, kw - 10), 6);
      final kh = (zeilen.length + 1) * ui.zeilenHoehe + 4;
      final r = Rechteck(4, ky, kw, kh);
      ui.panel(r, grund: UiFarbe.grundDunkel, fangen: false);
      ui.text(titel, r.x + 5, r.y + 2, farbe: ev.art == 'akte' ? UiFarbe.spuk : UiFarbe.akzent, schatten: null);
      for (var i = 0; i < zeilen.length; i++) {
        ui.text(zeilen[i], r.x + 5, r.y + 2 + (i + 1) * ui.zeilenHoehe, schatten: null);
      }
      ky += kh + 3;
      if (ky > h - 60) break;
    }
    if (_meldungZeit > 0 && meldung.isNotEmpty) {
      final tw = ui.font.measure(meldung);
      final r = Rechteck((w - tw) ~/ 2 - 6, h - 40, tw + 12, ui.font.height + 6);
      ui.panel(r, fangen: false);
      ui.text(meldung, r.x + 6, r.y + 3);
    }
  }
}

class _Pause extends Bildschirm {
  final Erkundung erkundung;
  _Pause(this.erkundung);
  String _meldung = '';

  @override
  bool get zeigtWelt => false;

  @override
  void tick(Spiel spiel, double dt, Eingabe e) {
    if (e.gedrueckt(Taste.menue) || e.gedrueckt(Taste.zurueck)) spiel.schliesse();
  }

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    final p = Rechteck(w ~/ 2 - 90, h ~/ 2 - 78, 180, 164);
    ui.panel(p);
    ui.textMittig('Pause', w ~/ 2, p.y + 6, farbe: UiFarbe.akzent);
    final mitFall = erkundung.sitzung != null;
    final eintraege = ['Weiter', 'Stadtkarte', if (mitFall) 'Speichern', 'Optionen', 'Hauptmenü'];
    final wahl = ui.menue(eintraege, w ~/ 2, p.y + 24, breite: 150);
    switch (wahl < 0 ? '' : eintraege[wahl]) {
      case 'Weiter':
        spiel.schliesse();
      case 'Stadtkarte':
        spiel.schliesse();
        erkundung.karteOeffnen(spiel);
      case 'Speichern':
        erkundung.speichern(spiel);
        _meldung = 'Gespeichert.';
      case 'Optionen':
        spiel.oeffne(OptionenBildschirm());
      case 'Hauptmenü':
        erkundung.speichern(spiel);
        spiel.wechsle(Hauptmenue());
    }
    if (_meldung.isNotEmpty) ui.textMittig(_meldung, w ~/ 2, p.unten - ui.zeilenHoehe - 4, farbe: UiFarbe.spuk);
  }
}

/// Zipfel zum Kopf: Dreieck aus 5, 3 und 1 Pixeln (dem Körper zugewandt), Grundfarbe der Blase,
/// 1 px Rand; Licht von oben links, also linke Kante hell und rechte Kante dunkel.
void _zeichneZipfel(PixelUi ui, Rechteck r, Zipfel z, int zx) {
  if (z == Zipfel.keiner) return;
  for (var k = 0; k < kZipfelHoehe; k++) {
    final y = z == Zipfel.unten ? r.unten + k : r.y - 1 - k;
    final halb = kZipfelHoehe - 1 - k;
    for (var dx = -halb; dx <= halb; dx++) {
      final farbe = halb == 0
          ? UiFarbe.rand
          : (dx == -halb ? UiFarbe.randHell : (dx == halb ? UiFarbe.randDunkel : UiFarbe.grundDunkel));
      ui.fb.fillRect(zx + dx, y, 1, 1, farbe);
    }
  }
}

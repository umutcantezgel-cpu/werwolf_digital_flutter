import 'dart:async';
import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

import '../fallsitzung.dart';
import '../spiel.dart';
import 'erkundung.dart';

/// Netz-Anbindung, die die App stellt: Gastgeben braucht einen Server im Gerät (`dart:io`,
/// nicht im Browser), Beitreten eine WebSocket-Verbindung (überall).
abstract class WlanAnbindung {
  /// Kann dieses Gerät einen Raum eröffnen? (Im Browser nicht.)
  bool get kannGastgeben;

  /// Startet den Raum-Host für [raum] und tritt selbst als erster Teilnehmer bei.
  /// Liefert den Raum-Code, die Adressen „IP:Port“ dieses Geräts und die eigene Spieler-ID.
  Future<(String code, List<String> adressen, String ich)> eroeffne(BurgstadtRaum raum, String name);

  /// Verbindet sich mit einem Raum. [empfang] bekommt jede Nachricht des Gastgebers
  /// (`willkommen`, `zustand`, `ereignisse`, `fehler`); [getrennt] meldet das Ende.
  Future<void> beitreten(String adresse, String code, String name,
      {required void Function(Map<String, Object?> nachricht) empfang, required void Function(String grund) getrennt});

  /// Gast: Spiel-Nachricht an den Gastgeber.
  void senden(Map<String, Object?> nachricht);

  /// Raum schließen bzw. Verbindung trennen.
  Future<void> schliessen();
}

enum _Schritt { wahl, gastgeber, eingabe, verbinde, gastLobby }

/// Mehrspieler im lokalen Netz: Raum eröffnen (Lobby mit Code und Rollenzahl) oder beitreten
/// (Adresse und Code über die Bildschirmtastatur oder die Tastatur).
class WlanBildschirm extends Bildschirm {
  WlanBildschirm();

  _Schritt _schritt = _Schritt.wahl;
  String meldung = '';

  // Gastgeber
  BurgstadtRaum? _raum;
  String _code = '';
  List<String> _adressen = const [];
  String _ich = '';
  int _n = 4;

  // Gast
  final Map<String, String> _feld = {'Adresse': '', 'Code': '', 'Name': ''};
  String _aktiv = 'Adresse';
  Map<String, Object?>? _lobby;
  Fallsitzung? _gastSitzung;
  final List<Map<String, Object?>> _vorStart = [];

  static const standardPort = 47100;

  @override
  bool get zeigtWelt => false;

  @override
  bool get menueNavigation => false;

  @override
  void betreten(Spiel spiel) {
    if (_feld['Name']!.isEmpty) _feld['Name'] = 'Gast ${math.Random().nextInt(90) + 10}';
  }

  @override
  void tick(Spiel spiel, double dt, Eingabe e) {
    if (e.gedrueckt(Taste.zurueck) || e.gedrueckt(Taste.menue)) {
      _zurueck(spiel);
      return;
    }
    if (_schritt == _Schritt.eingabe) {
      // Tastatur (Computer): Zeichen ins aktive Feld
      for (final c in e.text.toUpperCase().split('')) {
        _tippe(c);
      }
      if (e.textLoeschen) _tippe('⌫');
    }
  }

  void _zurueck(Spiel spiel) {
    final w = spiel.wlan;
    if (_schritt == _Schritt.wahl) {
      spiel.schliesse();
      return;
    }
    if (_schritt == _Schritt.gastgeber || _schritt == _Schritt.gastLobby || _schritt == _Schritt.verbinde) {
      unawaited(w?.schliessen());
      _raum = null;
      _gastSitzung = null;
    }
    _schritt = _Schritt.wahl;
    meldung = '';
  }

  void _tippe(String c) {
    final alt = _feld[_aktiv]!;
    if (c == '⌫') {
      if (alt.isNotEmpty) _feld[_aktiv] = alt.substring(0, alt.length - 1);
      return;
    }
    final max = _aktiv == 'Code' ? 4 : (_aktiv == 'Name' ? 14 : 21);
    if (alt.length >= max) return;
    final erlaubt = switch (_aktiv) {
      'Adresse' => RegExp(r'[0-9.:]'),
      'Code' => RegExp(r'[A-Z0-9]'),
      _ => RegExp(r'[A-ZÄÖÜ0-9 \-]'),
    };
    if (erlaubt.hasMatch(c)) _feld[_aktiv] = alt + (_aktiv == 'Name' && alt.isNotEmpty ? c.toLowerCase() : c);
  }

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    final p = Rechteck(6, 6, w - 12, h - 12);
    ui.panel(p, grund: UiFarbe.grundDunkel);
    ui.text('Im WLAN spielen', p.x + 6, p.y + 4, farbe: UiFarbe.akzent);
    if (ui.knopf(Rechteck(p.rechts - 66, p.y + 4, 60, 15), 'Zurück')) _zurueck(spiel);
    final innen = Rechteck(p.x + 8, p.y + 24, p.w - 16, p.h - 30);
    switch (_schritt) {
      case _Schritt.wahl:
        _zeichneWahl(spiel, ui, innen);
      case _Schritt.gastgeber:
        _zeichneGastgeber(spiel, ui, innen);
      case _Schritt.eingabe:
        _zeichneEingabe(spiel, ui, innen);
      case _Schritt.verbinde:
        ui.absatz('Verbinde mit ${_feld['Adresse']} …', innen, farbe: UiFarbe.textGedimmt);
      case _Schritt.gastLobby:
        _zeichneGastLobby(spiel, ui, innen);
    }
    if (meldung.isNotEmpty) ui.absatz(meldung, Rechteck(p.x + 8, p.unten - 30, p.w - 16, 26), farbe: UiFarbe.spuk);
  }

  // ------------------------------------------------------------------ Wahl

  void _zeichneWahl(Spiel spiel, PixelUi ui, Rechteck r) {
    final anb = spiel.wlan;
    var y = r.y;
    y += ui.absatz(
            'Alle Geräte müssen im selben WLAN sein. Eine Person eröffnet die Partie und spielt den Detektiv; '
            'die anderen treten mit Adresse und Code bei und übernehmen Rollen. Fehlende Rollen spielen Bots.',
            Rechteck(r.x, y, r.w, 60),
            farbe: UiFarbe.textGedimmt) +
        10;
    final bw = math.min(220, r.w);
    final kannHost = anb != null && anb.kannGastgeben && spiel.fallDaten != null;
    if (ui.knopf(Rechteck(r.x + (r.w - bw) ~/ 2, y, bw, 18), 'Partie eröffnen', aktiv: kannHost)) {
      unawaited(_eroeffne(spiel));
    }
    y += 24;
    if (ui.knopf(Rechteck(r.x + (r.w - bw) ~/ 2, y, bw, 18), 'Einer Partie beitreten', aktiv: anb != null)) {
      _schritt = _Schritt.eingabe;
      meldung = '';
    }
    y += 28;
    if (anb == null) {
      ui.absatz('In dieser Fassung gibt es kein WLAN-Spiel.', Rechteck(r.x, y, r.w, 30), farbe: UiFarbe.textGedimmt);
    } else if (!anb.kannGastgeben) {
      ui.absatz('Im Browser kannst du beitreten, aber keine Partie eröffnen (dafür braucht es die App).',
          Rechteck(r.x, y, r.w, 30),
          farbe: UiFarbe.textGedimmt);
    }
  }

  // ------------------------------------------------------------------ Gastgeber

  Future<void> _eroeffne(Spiel spiel) async {
    final d = spiel.fallDaten!;
    final raum = BurgstadtRaum(d, spiel.stadt, bewohner: spiel.bewohnerDaten, haeuser: spiel.haeuserDaten);
    meldung = 'Raum wird eröffnet …';
    try {
      final (code, adressen, ich) = await spiel.wlan!.eroeffne(raum, 'Detektiv');
      _raum = raum;
      _code = code;
      _adressen = adressen;
      _ich = ich;
      _schritt = _Schritt.gastgeber;
      meldung = '';
    } catch (e) {
      meldung = 'Raum konnte nicht eröffnet werden: $e';
    }
  }

  void _zeichneGastgeber(Spiel spiel, PixelUi ui, Rechteck r) {
    final raum = _raum!;
    var y = r.y;
    ui.text('Beitreten mit', r.x, y, farbe: UiFarbe.akzent);
    y += ui.zeilenHoehe + 2;
    for (final a in _adressen.take(3)) {
      ui.text('Adresse  $a', r.x + 4, y, skala: 2);
      y += ui.zeilenHoehe * 2 + 2;
    }
    if (_adressen.isEmpty) {
      ui.text('Keine WLAN-Adresse gefunden – ist das Gerät im WLAN?', r.x + 4, y, farbe: UiFarbe.spuk);
      y += ui.zeilenHoehe + 2;
    }
    ui.text('Code     $_code', r.x + 4, y, skala: 2, farbe: UiFarbe.akzent);
    y += ui.zeilenHoehe * 2 + 8;
    final teilnehmer = raum.reihenfolge.length;
    final minN = math.max(4, teilnehmer - 1).clamp(4, 20);
    if (_n < minN) _n = minN;
    ui.text('Mitspielende ($teilnehmer von ${BurgstadtRaum.maxTeilnehmer})', r.x, y, farbe: UiFarbe.akzent);
    y += ui.zeilenHoehe + 2;
    for (final id in raum.reihenfolge) {
      if (y > r.unten - 70) break;
      final online = id == _ich || raum.online.contains(id);
      ui.text('${raum.namen[id]}${id == _ich ? ' (du, Detektiv)' : ''}${online ? '' : ' – getrennt'}', r.x + 4, y,
          farbe: online ? UiFarbe.text : UiFarbe.textGedimmt);
      y += ui.zeilenHoehe;
    }
    y = math.max(y + 6, r.unten - 60);
    ui.text('Rollen in der Partie: $_n (Bots: ${_n - (teilnehmer - 1)})', r.x, y + 3);
    if (ui.knopf(Rechteck(r.x + 200, y, 20, 15), '−', aktiv: _n > minN)) _n--;
    if (ui.knopf(Rechteck(r.x + 224, y, 20, 15), '+', aktiv: _n < 20)) _n++;
    y += 22;
    if (ui.knopf(Rechteck(r.x + (r.w - 160) ~/ 2, y, 160, 18), 'Partie starten')) {
      raum.nachricht(_ich, {'art': 'start', 'n': _n});
      final s = Fallsitzung.imRaum(raum, _ich, spiel.teile, spiel.karten)..beenden = () => unawaited(spiel.wlan?.schliessen());
      spiel.besucht.clear();
      spiel.wechsle(Erkundung(sitzung: s));
    }
  }

  // ------------------------------------------------------------------ Gast

  void _zeichneEingabe(Spiel spiel, PixelUi ui, Rechteck r) {
    var y = r.y;
    for (final f in const ['Adresse', 'Code', 'Name']) {
      final k = Rechteck(r.x, y, math.min(260, r.w), 16);
      final aktiv = _aktiv == f;
      ui.flaeche(k, aktiv ? UiFarbe.grund : UiFarbe.grundDunkel);
      ui.rahmen(k, aktiv ? UiFarbe.akzent : UiFarbe.rand);
      final wert = _feld[f]!;
      ui.text('$f: ${wert.isEmpty && f == 'Adresse' ? '192.168.…' : wert}${aktiv ? '_' : ''}', k.x + 4, k.y + 3,
          farbe: wert.isEmpty ? UiFarbe.textGedimmt : UiFarbe.text);
      if (ui.tippflaeche(k)) _aktiv = f;
      y += 20;
    }
    y += 4;
    // Bildschirmtastatur
    const reihen = ['1234567890', 'QWERTZUIOP', 'ASDFGHJKL.', 'YXCVBNM:⌫'];
    final tb = math.min(26, (r.w - 4) ~/ 10 - 2);
    for (final reihe in reihen) {
      for (var i = 0; i < reihe.length; i++) {
        final c = reihe[i];
        if (ui.knopf(Rechteck(r.x + i * (tb + 2), y, tb, 18), c)) _tippe(c);
      }
      y += 21;
    }
    y += 6;
    final bereit = _feld['Adresse']!.length >= 7 && _feld['Code']!.length == 4;
    if (ui.knopf(Rechteck(r.x, y, 160, 18), 'Verbinden', aktiv: bereit)) unawaited(_verbinde(spiel));
  }

  Future<void> _verbinde(Spiel spiel) async {
    var adresse = _feld['Adresse']!;
    if (!adresse.contains(':')) adresse = '$adresse:$standardPort';
    _schritt = _Schritt.verbinde;
    meldung = '';
    _lobby = null;
    _vorStart.clear();
    try {
      await spiel.wlan!.beitreten(adresse, _feld['Code']!, _feld['Name']!.trim(),
          empfang: (n) => _empfange(spiel, n),
          getrennt: (grund) {
            if (_schritt != _Schritt.wahl) meldung = 'Verbindung beendet: $grund';
            if (_schritt == _Schritt.verbinde || _schritt == _Schritt.gastLobby) _schritt = _Schritt.eingabe;
          });
    } catch (e) {
      _schritt = _Schritt.eingabe;
      meldung = 'Keine Verbindung zu $adresse ($e).';
    }
  }

  static const _fehlertexte = {
    'raum_unbekannt': 'Diesen Code gibt es dort nicht.',
    'abgelehnt': 'Die Partie läuft schon oder ist voll.',
    'token_unbekannt': 'Die alte Verbindung ist abgelaufen.',
  };

  void _empfange(Spiel spiel, Map<String, Object?> n) {
    final s = _gastSitzung;
    if (s != null) {
      s.empfange(n);
      return;
    }
    switch (n['t']) {
      case 'willkommen':
        _schritt = _Schritt.gastLobby;
      case 'fehler':
        meldung = _fehlertexte[n['schluessel']] ?? 'Fehler: ${n['schluessel']}';
      case 'ereignisse':
        _vorStart.add(n);
      case 'zustand':
        if (n['lobby'] == true) {
          _lobby = n;
        } else {
          _starteAlsGast(spiel, n);
        }
    }
  }

  void _starteAlsGast(Spiel spiel, Map<String, Object?> z) {
    final d = spiel.fallDaten;
    if (d == null || z['rolle'] == null) return;
    final s = Fallsitzung.alsGast(d, spiel.stadt, z, spiel.teile, spiel.karten,
        bewohner: spiel.bewohnerDaten, haeuser: spiel.haeuserDaten)
      ..senden = (m) {
        spiel.wlan?.senden({'t': 'spiel', ...m});
      }
      ..beenden = () => unawaited(spiel.wlan?.schliessen());
    for (final n in _vorStart) {
      s.empfange(n);
    }
    _vorStart.clear();
    _gastSitzung = s;
    spiel.besucht.clear();
    spiel.wechsle(Erkundung(sitzung: s));
  }

  void _zeichneGastLobby(Spiel spiel, PixelUi ui, Rechteck r) {
    var y = r.y;
    y += ui.absatz('Verbunden. Warte, bis der Detektiv die Partie startet …', Rechteck(r.x, y, r.w, 30)) + 6;
    final l = _lobby;
    if (l == null) return;
    ui.text('Mitspielende', r.x, y, farbe: UiFarbe.akzent);
    y += ui.zeilenHoehe + 2;
    for (final m in (l['mitspieler'] as List? ?? const [])) {
      if (y > r.unten - 34) break;
      final mm = (m as Map).cast<String, Object?>();
      ui.text('${mm['name']}${mm['id'] == l['ich'] ? ' (du)' : ''}${mm['id'] == l['gastgeber'] ? ' – Detektiv' : ''}', r.x + 4, y);
      y += ui.zeilenHoehe;
    }
  }
}

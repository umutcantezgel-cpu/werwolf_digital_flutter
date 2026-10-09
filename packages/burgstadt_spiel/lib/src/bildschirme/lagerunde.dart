import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

import '../fallsitzung.dart';
import '../spiel.dart';
import 'anklage.dart';

/// Lagerunde am Phasenende: Meldekarten, Rollen-Entscheidungen, dann die drei
/// Entscheidungen des Detektivs mit Ergebnis, dann die nächste Phase.
///
/// Allein entscheiden die Bots sofort. Im WLAN-Spiel entscheidet jede Person ihre eigene
/// Rollen-Entscheidung (Bots und Säumige übernimmt der Gastgeber nach einer Frist); der
/// Detektiv wartet darauf und trifft dann seine drei Entscheidungen.
class LagerundeBildschirm extends Bildschirm {
  final Fallsitzung s;
  final List<String> zeilen = [];
  DetektivEntscheidung? aktuell;
  String? ergebnis;
  final int _phase;
  bool _weiterGesendet = false;

  @override
  bool get zeigtTutorial => true;

  LagerundeBildschirm(this.s) : _phase = s.fall.phase {
    final f = s.fall;
    if (!s.imNetz) {
      // Rollen-Bots entscheiden
      for (final e in f.rollenEntscheidungen()) {
        s.waehleRolle(e.id, s.sim.bots.rollenWahl(e));
      }
      s.sim.bots.teileNeues('R01'); // Nachzügler
      s.weiter(); // → Entscheidungen des Detektivs
    }
    _meldekarten();
    aktuell = _ichBinDetektiv ? f.detektivEntscheidungen().firstOrNull : null;
  }

  bool get _ichBinDetektiv => s.ich == FallZustand.detektiv;

  void _meldekarten() {
    final f = s.fall;
    zeilen
      ..clear()
      ..addAll([
        for (final e in f.protokoll)
          if (e.art == 'meldekarte' && (e.uhr - f.uhr).abs() < 1) e.text,
      ]);
  }

  @override
  bool get zeigtWelt => false;

  @override
  void betreten(Spiel spiel) => spiel.ton.schleife('musik', 'musik_gewoelbe_schleife', lautstaerke: 0.4);

  @override
  void tick(Spiel spiel, double dt, Eingabe e) {
    if (!s.imNetz) return;
    s.tick(dt); // Ereignisse abholen (Gastgeber) – der Raum läuft weiter
    final f = s.fall;
    if (zeilen.isEmpty) _meldekarten();
    // Im Netz bestimmt der Gastgeber den Fortgang
    if (f.abschnitt == Abschnitt.eingrenzung || f.abschnitt == Abschnitt.ende) {
      spiel.wechsle(AnklageBildschirm(s));
    } else if (f.phase != _phase) {
      spiel.ton.spiele('uhrturm_schlag', lautstaerke: 0.9);
      spiel.schliesse();
    } else if (_ichBinDetektiv && ergebnis == null) {
      aktuell = f.abschnitt == Abschnitt.detektivWahl ? f.detektivEntscheidungen().firstOrNull : null;
    }
  }

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    final f = s.fall;
    final p = Rechteck(6, 6, w - 12, h - 12);
    ui.panel(p, grund: UiFarbe.grundDunkel);
    ui.text('Lagerunde im Gewölbe · Phase ${f.phase} · ${s.uhrText}', p.x + 6, p.y + 4, farbe: UiFarbe.akzent);
    var y = p.y + 20;
    if (!_ichBinDetektiv) {
      _zeichneRolle(spiel, ui, p, y);
      return;
    }
    if (f.abschnitt == Abschnitt.lagerunde) {
      // Nur im WLAN-Spiel: die Rollen entscheiden noch
      for (final z in zeilen) {
        y += ui.absatz(z, Rechteck(p.x + 8, y, p.w - 16, 40), farbe: UiFarbe.text) + 2;
      }
      final offen = f.rollenEntscheidungen().length;
      y += ui.absatz(offen == 0 ? 'Alle Rollen haben entschieden.' : 'Die Rollen entscheiden noch ($offen offen) …',
              Rechteck(p.x + 8, y + 4, p.w - 16, 30), farbe: UiFarbe.textGedimmt) +
          8;
      if (ui.knopf(Rechteck(w ~/ 2 - 80, y, 160, 18), 'Zu meinen Entscheidungen', aktiv: offen == 0 && !_weiterGesendet)) {
        s.weiter();
        _weiterGesendet = true;
      }
      return;
    }
    _weiterGesendet = false;
    if (ergebnis == null && aktuell == null) {
      // alle drei entschieden → weiter
      y += ui.absatz('Du hast deine drei Entscheidungen getroffen. Punkte bisher: ${f.punkte}.', Rechteck(p.x + 8, y, p.w - 16, 40));
      final label = f.phase < 3 ? 'Weiter: Phase ${f.phase + 1}' : 'Zur Eingrenzung';
      if (ui.knopf(Rechteck(w ~/ 2 - 80, y + 10, 160, 18), label, aktiv: !_weiterGesendet)) {
        s.weiter();
        if (s.imNetz) {
          _weiterGesendet = true; // der Gastgeber schaltet weiter, tick() folgt
          return;
        }
        spiel.ton.spiele('uhrturm_schlag', lautstaerke: 0.9);
        if (f.abschnitt == Abschnitt.eingrenzung) {
          spiel.tutorial.ausloesen('anklage', an: spiel.optionen.tutorial);
          spiel.wechsle(AnklageBildschirm(s));
        } else {
          spiel.schliesse();
        }
      }
      return;
    }
    // Meldekarten
    for (final z in zeilen) {
      y += ui.absatz(z, Rechteck(p.x + 8, y, p.w - 16, 40), farbe: UiFarbe.text) + 2;
    }
    y += 4;
    final d = aktuell;
    if (ergebnis != null) {
      ui.text('Ergebnis', p.x + 8, y, farbe: UiFarbe.akzent);
      y += ui.zeilenHoehe + 2;
      y += ui.absatz(ergebnis!, Rechteck(p.x + 8, y, p.w - 16, p.unten - y - 30));
      if (ui.knopf(Rechteck(w ~/ 2 - 50, p.unten - 24, 100, 18), 'Weiter')) {
        ergebnis = null;
        aktuell = f.detektivEntscheidungen().firstOrNull;
      }
      return;
    }
    if (d == null) return;
    ui.text('Deine Entscheidung (${d.id})', p.x + 8, y, farbe: UiFarbe.akzent);
    y += ui.zeilenHoehe + 2;
    y += ui.absatz(d.frage, Rechteck(p.x + 8, y, p.w - 16, 60)) + 6;
    final zeilenJeKnopf = h > w ? 3 : 2; // Hochformat: größere Knöpfe (A-703a)
    for (final o in ['A', 'B', 'C']) {
      final r = Rechteck(p.x + 8, y, p.w - 16, ui.zeilenHoehe * zeilenJeKnopf + 6);
      if (ui.knopf(r, '$o: ${_kurz(ui, d.optionen[o]!, r.w - 16)}')) {
        ergebnis = s.waehleDetektiv(d.id, o);
        if (s.imNetz) f.detektivWahl[d.id] = o; // sofort weiter; der Spiegel bestätigt es
        aktuell = null;
        spiel.ton.spiele('hinweis_gefunden');
      }
      y += r.h + 4;
    }
  }

  /// Rolle im WLAN-Spiel: eigene Rollen-Entscheidung treffen, dann auf den Detektiv warten.
  void _zeichneRolle(Spiel spiel, PixelUi ui, Rechteck p, int y0) {
    final f = s.fall;
    var y = y0;
    for (final z in zeilen) {
      y += ui.absatz(z, Rechteck(p.x + 8, y, p.w - 16, 40), farbe: UiFarbe.text) + 2;
    }
    final meine = [for (final e in f.rollenEntscheidungen()) if (e.rolle == s.ich) e];
    if (meine.isEmpty) {
      ui.absatz(
          f.abschnitt == Abschnitt.lagerunde
              ? 'Deine Entscheidung ist gefallen. Die anderen entscheiden noch …'
              : 'Der Detektiv trifft seine Entscheidungen …',
          Rechteck(p.x + 8, y + 6, p.w - 16, 30),
          farbe: UiFarbe.textGedimmt);
      return;
    }
    final e = meine.first;
    ui.text('Deine Entscheidung (${e.id})', p.x + 8, y + 4, farbe: UiFarbe.akzent);
    y += ui.zeilenHoehe + 6;
    y += ui.absatz(e.lage, Rechteck(p.x + 8, y, p.w - 16, 60)) + 6;
    final zeilenJeKnopf = p.h > p.w ? 3 : 2;
    for (var i = 0; i < e.optionen.length; i++) {
      final r = Rechteck(p.x + 8, y, p.w - 16, ui.zeilenHoehe * zeilenJeKnopf + 6);
      if (ui.knopf(r, '${String.fromCharCode(65 + i)}: ${_kurz(ui, e.optionen[i].text, r.w - 16)}')) {
        s.waehleRolle(e.id, i);
        f.rollenWahl[e.id] = i; // bis der Spiegel es bestätigt
        spiel.ton.spiele('papier_rascheln');
      }
      y += r.h + 4;
    }
  }

  static String _kurz(PixelUi ui, String t, int max) {
    var s = t;
    while (ui.font.measure(s) > max && s.length > 4) {
      s = '${s.substring(0, s.length - 2)}…';
    }
    return s;
  }
}

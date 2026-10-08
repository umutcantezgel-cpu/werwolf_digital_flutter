import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

import '../fallsitzung.dart';
import '../spiel.dart';
import 'anklage.dart';

/// Lagerunde am Phasenende: Meldekarten, Rollen-Entscheidungen (Bots), dann die
/// drei Entscheidungen des Detektivs mit Ergebnis, dann die nächste Phase.
class LagerundeBildschirm extends Bildschirm {
  final Fallsitzung s;
  final List<String> zeilen = [];
  DetektivEntscheidung? aktuell;
  String? ergebnis;
  bool fertig = false;

  @override
  bool get zeigtTutorial => true;

  LagerundeBildschirm(this.s) {
    final f = s.fall;
    for (final e in f.protokoll.where((e) => e.art == 'meldekarte' && e.uhr == f.uhr)) {
      zeilen.add(e.text);
    }
    // Rollen-Bots entscheiden
    for (final e in f.rollenEntscheidungen()) {
      s.melde(f.waehleRolle(e.id, s.sim.bots.rollenWahl(e)));
    }
    s.sim.bots.teileNeues('R01'); // Nachzügler
    f.zurDetektivWahl();
    aktuell = f.detektivEntscheidungen().firstOrNull;
  }

  @override
  bool get zeigtWelt => false;

  @override
  void betreten(Spiel spiel) => spiel.ton.schleife('musik', 'musik_gewoelbe_schleife', lautstaerke: 0.4);

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    final f = s.fall;
    final p = Rechteck(6, 6, w - 12, h - 12);
    ui.panel(p, grund: UiFarbe.grundDunkel);
    ui.text('Lagerunde im Gewölbe · Phase ${f.phase} · ${s.uhrText}', p.x + 6, p.y + 4, farbe: UiFarbe.akzent);
    var y = p.y + 20;
    if (ergebnis == null && aktuell == null) {
      // alle drei entschieden → weiter
      y += ui.absatz('Du hast deine drei Entscheidungen getroffen. Punkte bisher: ${f.punkte}.', Rechteck(p.x + 8, y, p.w - 16, 40));
      final label = f.phase < 3 ? 'Weiter: Phase ${f.phase + 1}' : 'Zur Eingrenzung';
      if (ui.knopf(Rechteck(w ~/ 2 - 80, y + 10, 160, 18), label)) {
        s.melde(f.weiter());
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
    for (final o in ['A', 'B', 'C']) {
      final r = Rechteck(p.x + 8, y, p.w - 16, ui.zeilenHoehe * 2 + 6);
      if (ui.knopf(r, '$o: ${_kurz(ui, d.optionen[o]!, r.w - 16)}')) {
        final e = f.waehleDetektiv(d.id, o);
        s.melde(e);
        ergebnis = e.isEmpty ? '' : e.first.text;
        spiel.ton.spiele('hinweis_gefunden');
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

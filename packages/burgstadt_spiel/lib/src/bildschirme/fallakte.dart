import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart' show Hinweis;
import 'package:pixel_engine/pixel_engine.dart';

import '../fallsitzung.dart';
import '../spiel.dart';

/// Fallakte: eigene Notizen und die gemeinsame Akte, Heften und Fäden.
class FallakteBildschirm extends Bildschirm {
  final Fallsitzung s;
  bool akteZeigen = true;
  int auswahl = 0;
  int scroll = 0;
  String? fadenStart;
  String meldung = '';

  FallakteBildschirm(this.s) {
    s.neueAkte = 0;
  }

  @override
  bool get zeigtWelt => false;

  List<String> get _liste {
    final f = s.fall;
    final l = akteZeigen ? f.akte.toList() : f.wissen['DET']!.where((h) => !f.akte.contains(h)).toList();
    l.sort((a, b) => Hinweis.reihenfolge(a).compareTo(Hinweis.reihenfolge(b)));
    return l;
  }

  @override
  void tick(Spiel spiel, double dt, Eingabe e) {
    final l = _liste;
    if (e.gedrueckt(Taste.zurueck) || e.gedrueckt(Taste.akte) || e.gedrueckt(Taste.menue)) spiel.schliesse();
    if (l.isEmpty) return;
    if (e.gedrueckt(Taste.runter)) auswahl = math.min(l.length - 1, auswahl + 1);
    if (e.gedrueckt(Taste.hoch)) auswahl = math.max(0, auswahl - 1);
    if (e.rad != 0) auswahl = (auswahl + e.rad.sign.toInt()).clamp(0, l.length - 1);
  }

  @override
  bool get menueNavigation => false;

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    final f = s.fall;
    final p = Rechteck(6, 6, w - 12, h - 12);
    ui.panel(p, grund: UiFarbe.grundDunkel);
    ui.text('Fallakte', p.x + 6, p.y + 4, farbe: UiFarbe.akzent);
    final kopfR = '${s.uhrText} · Phase ${f.phase} · ${f.akte.length} in der Akte · ${f.wissen['DET']!.length} Notizen';
    ui.text(kopfR, p.rechts - ui.font.measure(kopfR) - 6, p.y + 4, farbe: UiFarbe.textGedimmt);
    // Reiter
    if (ui.knopf(Rechteck(p.x + 6, p.y + 18, 90, 15), 'Fallakte', hervorgehoben: akteZeigen)) {
      akteZeigen = true;
      auswahl = 0;
    }
    if (ui.knopf(Rechteck(p.x + 100, p.y + 18, 110, 15), 'Meine Notizen', hervorgehoben: !akteZeigen)) {
      akteZeigen = false;
      auswahl = 0;
    }
    if (ui.knopf(Rechteck(p.rechts - 66, p.y + 18, 60, 15), 'Zurück')) spiel.schliesse();
    final l = _liste;
    final hoch = h > w;
    final listeH = hoch ? (p.h - 60) ~/ 2 : p.h - 60;
    final listeW = hoch ? p.w - 12 : (p.w - 18) * 2 ~/ 5;
    final lr = Rechteck(p.x + 6, p.y + 38, listeW, listeH);
    ui.flaeche(lr, UiFarbe.grund);
    final zeilen = listeH ~/ ui.zeilenHoehe;
    if (auswahl >= l.length) auswahl = math.max(0, l.length - 1);
    if (auswahl < scroll) scroll = auswahl;
    if (auswahl >= scroll + zeilen) scroll = auswahl - zeilen + 1;
    for (var i = scroll; i < l.length && i < scroll + zeilen; i++) {
      final y = lr.y + (i - scroll) * ui.zeilenHoehe + 1;
      final r = Rechteck(lr.x, y, lr.w, ui.zeilenHoehe);
      if (ui.tippflaeche(r)) auswahl = i;
      final hw = f.daten.hinweise[l[i]]!;
      final gewaehlt = i == auswahl;
      if (gewaehlt) ui.flaeche(r, 51);
      final faden = f.faeden.any((x) => x.$1 == l[i] || x.$2 == l[i]) ? '~ ' : '';
      var t = '$faden${hw.inhalt}';
      while (ui.font.measure(t) > lr.w - 6 && t.length > 4) {
        t = '${t.substring(0, t.length - 2)}…';
      }
      ui.text(t, lr.x + 3, y + 1, farbe: gewaehlt ? UiFarbe.akzent : UiFarbe.text, schatten: null);
    }
    if (l.isEmpty) {
      ui.text(akteZeigen ? 'Noch nichts in der Akte.' : 'Keine eigenen Notizen außerhalb der Akte.', lr.x + 4, lr.y + 4,
          farbe: UiFarbe.textGedimmt);
      return;
    }
    // Detail
    final dr = hoch
        ? Rechteck(p.x + 6, lr.unten + 6, p.w - 12, p.h - listeH - 66)
        : Rechteck(lr.rechts + 6, lr.y, p.w - listeW - 18, listeH);
    final hid = l[auswahl];
    final hw = f.daten.hinweise[hid]!;
    ui.flaeche(dr, UiFarbe.grund);
    final herkunft = hw.gespraech != null ? 'Gespräch' : (hw.station != null ? 'Fundstück' : (hw.erzaehler ? 'Burgwart' : 'Bericht'));
    ui.text('$hid · $herkunft · Phase ${hw.phase}', dr.x + 4, dr.y + 3, farbe: UiFarbe.textGedimmt);
    final hText = ui.absatz(hw.inhalt, Rechteck(dr.x + 4, dr.y + 17, dr.w - 8, dr.h - 40));
    final int by = dr.y + 17 + math.min<int>(hText, dr.h - 40) + 4;
    if (!f.akte.contains(hid)) {
      if (ui.knopf(Rechteck(dr.x + 4, by, 130, 15), 'An die Akte heften')) {
        s.melde(f.teile('DET', 'akte', hid));
        spiel.ton.spiele('fallakte_heften');
        meldung = 'Angeheftet.';
      }
    } else {
      final label = fadenStart == null ? 'Faden ziehen' : (fadenStart == hid ? 'Faden abbrechen' : 'Faden hierher');
      if (ui.knopf(Rechteck(dr.x + 4, by, 120, 15), label)) {
        if (fadenStart == null) {
          fadenStart = hid;
          meldung = 'Wähle den zweiten Eintrag.';
        } else if (fadenStart == hid) {
          fadenStart = null;
          meldung = '';
        } else {
          s.melde(f.verbinde('DET', fadenStart!, hid));
          meldung = 'Faden: $fadenStart ↔ $hid';
          fadenStart = null;
          spiel.ton.spiele('papier_rascheln');
        }
      }
    }
    if (meldung.isNotEmpty) ui.text(meldung, dr.x + 4, by + 18, farbe: UiFarbe.spuk);
  }
}

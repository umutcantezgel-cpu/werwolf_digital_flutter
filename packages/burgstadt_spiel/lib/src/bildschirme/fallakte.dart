import 'dart:math' as math;

import 'package:burgstadt_core/burgstadt_core.dart' show FallZustand, Hinweis;
import 'package:pixel_engine/pixel_engine.dart';

import '../fallsitzung.dart';
import '../spiel.dart';

/// Fallakte: eigene Notizen und die gemeinsame Akte, Heften, Teilen an Einzelne und Fäden.
class FallakteBildschirm extends Bildschirm {
  final Fallsitzung s;
  bool akteZeigen = true;
  int auswahl = 0;
  int scroll = 0;
  String? fadenStart;
  String meldung = '';

  /// Auswahl der Empfängerin/des Empfängers beim Teilen an Einzelne ist offen.
  bool teilenOffen = false;

  /// Tastatur/Gamepad: Bestätigen löst die Hauptaktion des gewählten Eintrags aus.
  bool _bestaetigt = false;

  FallakteBildschirm(this.s) {
    s.neueAkte = 0;
  }

  @override
  bool get zeigtWelt => false;

  List<String> get _liste {
    final f = s.fall;
    final l = akteZeigen ? f.akte.toList() : (f.wissen[s.ich] ?? const <String>{}).where((h) => !f.akte.contains(h)).toList();
    l.sort((a, b) => Hinweis.reihenfolge(a).compareTo(Hinweis.reihenfolge(b)));
    return l;
  }

  @override
  void tick(Spiel spiel, double dt, Eingabe e) {
    _bestaetigt = false;
    if (teilenOffen) {
      // Empfänger wählen: Fokus-Navigation der Knöpfe (hoch/runter, bestätigen)
      if (e.gedrueckt(Taste.zurueck) || e.gedrueckt(Taste.blick) || e.gedrueckt(Taste.menue)) teilenOffen = false;
      return;
    }
    final l = _liste;
    if (e.gedrueckt(Taste.zurueck) || e.gedrueckt(Taste.akte) || e.gedrueckt(Taste.menue)) spiel.schliesse();
    // Tastatur/Gamepad: links/rechts wechselt den Reiter, Bestätigen heftet bzw. zieht den Faden,
    // Blick (Q / Y) öffnet „Teilen mit …“
    if (e.gedrueckt(Taste.links) || e.gedrueckt(Taste.rechts) || e.gedrueckt(Taste.drehLinks) || e.gedrueckt(Taste.drehRechts)) {
      akteZeigen = !akteZeigen;
      auswahl = 0;
      return;
    }
    if (l.isEmpty) return;
    if (e.gedrueckt(Taste.bestaetigen)) _bestaetigt = true;
    if (e.gedrueckt(Taste.blick) && !akteZeigen) {
      teilenOffen = true;
      spiel.pixelUi
        ..fokus = 4 // erster Empfänger (nach Reitern, Zurück und „Teilen mit …“)
        ..fokusSichtbar = true;
    }
    if (e.gedrueckt(Taste.runter)) auswahl = math.min(l.length - 1, auswahl + 1);
    if (e.gedrueckt(Taste.hoch)) auswahl = math.max(0, auswahl - 1);
    if (e.rad != 0) auswahl = (auswahl + e.rad.sign.toInt()).clamp(0, l.length - 1);
  }

  @override
  bool get menueNavigation => teilenOffen;

  @override
  bool get zeigtTutorial => true;

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    final f = s.fall;
    final p = Rechteck(6, 6, w - 12, h - 12);
    ui.panel(p, grund: UiFarbe.grundDunkel);
    ui.text('Fallakte', p.x + 6, p.y + 4, farbe: UiFarbe.akzent);
    final kopfR = '${s.uhrText} · Phase ${f.phase} · ${f.akte.length} in der Akte · ${f.wissen[s.ich]?.length ?? 0} Notizen';
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
      if (ui.font.measure(t) > lr.w - 6) {
        // am Wortende kürzen statt mitten im Wort (A-703a)
        final woerter = t.split(' ');
        var k = '';
        for (final wort in woerter) {
          final n = k.isEmpty ? wort : '$k $wort';
          if (ui.font.measure('$n …') > lr.w - 6) break;
          k = n;
        }
        t = k.isEmpty ? t.substring(0, math.min(t.length, 8)) : '$k …';
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
      if (ui.knopf(Rechteck(dr.x + 138, by, 110, 15), 'Teilen mit …', hervorgehoben: teilenOffen)) teilenOffen = !teilenOffen;
      if (teilenOffen) {
        _empfaenger(spiel, ui, Rechteck(dr.x + 4, by + 18, dr.w - 8, dr.unten - by - 20), hid);
        return;
      }
      if (ui.knopf(Rechteck(dr.x + 4, by, 130, 15), 'An die Akte heften') || _bestaetigt) {
        s.teile('akte', hid);
        spiel.ton.spiele('fallakte_heften');
        spiel.tutorial.ausloesen('heften', an: spiel.optionen.tutorial);
        meldung = 'Angeheftet.';
      }
    } else {
      final label = fadenStart == null ? 'Faden ziehen' : (fadenStart == hid ? 'Faden abbrechen' : 'Faden hierher');
      if (ui.knopf(Rechteck(dr.x + 4, by, 120, 15), label) || _bestaetigt) {
        if (fadenStart == null) {
          fadenStart = hid;
          meldung = 'Wähle den zweiten Eintrag.';
        } else if (fadenStart == hid) {
          fadenStart = null;
          meldung = '';
        } else {
          s.verbinde(fadenStart!, hid);
        spiel.tutorial.ausloesen('faden', an: spiel.optionen.tutorial);
          meldung = 'Faden: $fadenStart ↔ $hid';
          fadenStart = null;
          spiel.ton.spiele('papier_rascheln');
        }
      }
    }
    if (meldung.isNotEmpty) ui.text(meldung, dr.x + 4, by + 18, farbe: UiFarbe.spuk);
  }

  /// Knöpfe für alle anderen Rollen der Partie (im WLAN-Spiel mit dem Namen der Person).
  void _empfaenger(Spiel spiel, PixelUi ui, Rechteck r, String hid) {
    final f = s.fall;
    final menschen = {for (final m in s.mitspieler) m['rolle']: m['name']};
    final ziele = [FallZustand.detektiv, ...f.rollen].where((x) => x != s.ich).toList();
    const bw = 118, bh = 15;
    final spalten = math.max(1, r.w ~/ (bw + 4));
    for (var i = 0; i < ziele.length; i++) {
      final id = ziele[i];
      final name = id == FallZustand.detektiv ? 'Detektiv' : (f.daten.rollen[id]?.name.split(' ').first ?? id);
      final mensch = menschen[id];
      final label = mensch != null ? '$name ($mensch)' : name;
      final k = Rechteck(r.x + (i % spalten) * (bw + 4), r.y + (i ~/ spalten) * (bh + 3), bw, bh);
      if (k.unten > r.unten) break;
      if (ui.knopf(k, label)) {
        s.teile(id, hid);
        spiel.ton.spiele('papier_rascheln');
        teilenOffen = false;
        meldung = 'Geteilt mit $name.';
      }
    }
  }
}

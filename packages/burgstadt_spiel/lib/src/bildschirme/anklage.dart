import 'package:burgstadt_core/burgstadt_core.dart';
import 'package:pixel_engine/pixel_engine.dart';

import '../fallsitzung.dart';
import '../spiel.dart';
import 'hauptmenue.dart';

/// Eingrenzung, Anklage und Ende (Endmatrix EM-1…EM-4, Auflösung).
class AnklageBildschirm extends Bildschirm {
  final Fallsitzung s;
  AnklageBildschirm(this.s);

  @override
  bool get zeigtWelt => false;

  @override
  void betreten(Spiel spiel) => spiel.ton.schleife('musik', 'musik_morgengrauen', lautstaerke: 0.5);

  @override
  void zeichneUi(Spiel spiel, PixelUi ui) {
    final w = ui.fb.width, h = ui.fb.height;
    final f = s.fall;
    final p = Rechteck(6, 6, w - 12, h - 12);
    ui.panel(p, grund: UiFarbe.grundDunkel);
    var y = p.y + 4;
    if (f.abschnitt == Abschnitt.ende) {
      final titel = f.daten.kanon.datensaetze[f.ende]?.feld('Ende') ?? f.ende!;
      ui.text('Morgengrauen · Ende: $titel', p.x + 6, y, farbe: UiFarbe.akzent);
      y += ui.zeilenHoehe + 4;
      final teile = <String>[
        'Angeklagt: ${f.daten.rollen[f.angeklagt]?.name ?? f.angeklagt}. Punkte: ${f.punkte} von 9.',
        for (final sId in ['S-2', 'S-3', 'S-4', 'S-5', 'S-7']) f.daten.schlussText[sId] ?? '',
        f.daten.kanon.datensaetze['GS-1']?.feld('Kern') ?? '',
        f.daten.kanon.datensaetze['GS-2']?.feld('Kern') ?? '',
      ];
      for (final t in teile) {
        if (y > p.unten - 40) break;
        y += ui.absatz(t, Rechteck(p.x + 8, y, p.w - 16, p.unten - y - 30)) + 3;
      }
      if (ui.knopf(Rechteck(w ~/ 2 - 60, p.unten - 24, 120, 18), 'Zum Hauptmenü')) spiel.wechsle(Hauptmenue());
      return;
    }
    ui.text('Eingrenzung', p.x + 6, y, farbe: UiFarbe.akzent);
    y += ui.zeilenHoehe + 2;
    y += ui.absatz(f.eingrenzungsText, Rechteck(p.x + 8, y, p.w - 16, 100)) + 8;
    ui.text('Wen klagst du an?', p.x + 8, y, farbe: UiFarbe.akzent);
    y += ui.zeilenHoehe + 4;
    for (final r in f.verdaechtigenkreis) {
      if (ui.knopf(Rechteck(p.x + 8, y, 220, 18), f.daten.rollen[r]?.name ?? r)) {
        s.melde(f.klageAn(r));
        spiel.ton.spiele('schreck', lautstaerke: 0.6);
      }
      y += 22;
    }
  }
}

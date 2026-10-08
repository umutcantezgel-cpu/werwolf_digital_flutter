import '../palette.dart';
import '../raster/renderer.dart' show SpriteImage;
import 'baker.dart';
import 'figur.dart';

/// Sprite-Prüfung (Ebene 5): liefert Befunde für einen Figurensatz.
List<String> pruefeFigur(FigurSatz satz) {
  final out = <String>[];
  final id = satz.karte.id;
  for (final e in satz.bilder.entries) {
    for (var b = 0; b < e.value.length; b++) {
      final richtungen = e.value[b];
      if (richtungen.length != 8) out.add('$id ${e.key}/$b: ${richtungen.length} statt 8 Richtungen');
      final signaturen = <String>{};
      for (var r = 0; r < richtungen.length; r++) {
        final s = richtungen[r];
        final ort = '$id ${e.key}/$b/r$r';
        if (s.width != FigurBaker.breite || s.height != FigurBaker.hoehe) out.add('$ort: Größe ${s.width}×${s.height}');
        if (s.footX != FigurBaker.fussX || s.footY != FigurBaker.fussY) out.add('$ort: Fußpunkt verschoben');
        var unterste = -1, deckend = 0;
        for (var y = 0; y < s.height; y++) {
          for (var x = 0; x < s.width; x++) {
            final c = s.pixels[y * s.width + x];
            if (c == kTransparent) continue;
            deckend++;
            if (c >= 64) out.add('$ort: Index $c außerhalb der Palette');
            unterste = y;
            // Kontur: Randpixel müssen dunkle Stufe (≤ 4) haben
            final rand = x == 0 || y == 0 || x == s.width - 1 || y == s.height - 1 ||
                s.pixels[y * s.width + x - 1] == kTransparent ||
                s.pixels[y * s.width + x + 1] == kTransparent ||
                s.pixels[(y - 1) * s.width + x] == kTransparent ||
                s.pixels[(y + 1) * s.width + x] == kTransparent;
            if (rand && (c & 7) > 4) out.add('$ort: helle Kontur bei $x/$y');
          }
        }
        if (deckend < 200) out.add('$ort: zu wenig sichtbar ($deckend px)');
        if (unterste < s.footY - 3 || unterste > s.footY + 1) out.add('$ort: Füße enden in Zeile $unterste statt ~${s.footY}');
        signaturen.add(String.fromCharCodes(s.pixels));
      }
      if (signaturen.length < richtungen.length) out.add('$id ${e.key}/$b: Richtungen nicht alle verschieden');
    }
  }
  return out;
}

/// Prüft, ob alle Teile einer Karte existieren und nur bekannte Knochen nutzen.
List<String> pruefeKarte(Figurenkarte k, Map<String, Teil> bibliothek) {
  final out = <String>[];
  final knochen = {for (final kn in kSkelett) kn.name};
  for (final t in k.teile) {
    final teil = bibliothek[t];
    if (teil == null) {
      out.add('${k.id}: Teil „$t“ fehlt');
      continue;
    }
    for (final g in teil.koerper) {
      if (!knochen.contains(g.knochen)) out.add('${k.id}: Teil „$t“ nutzt unbekannten Knochen ${g.knochen}');
    }
  }
  for (final e in k.materialien.entries) {
    final m = e.value;
    if (m.rampe < 0 || m.rampe > 7 || m.stufe < 0 || m.stufe > 7) out.add('${k.id}: Material ${e.key} außerhalb');
  }
  return out;
}

/// Unbenutzt außerhalb von Tests: hält [SpriteImage] im Import sichtbar.
typedef FigurBild = SpriteImage;

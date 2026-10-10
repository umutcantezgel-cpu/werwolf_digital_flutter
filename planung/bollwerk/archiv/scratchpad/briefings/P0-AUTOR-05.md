Du bist Autor im Projekt „Burgstadt HD“. Paket **P0-AUTOR-05 · Eichbilder für die Sichtprüfer** (HZ-04).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md und /home/user/werwolf_digital_flutter/hd/STILBLATT.md und halte dich an die Regeln.

## Ziel
Später bewerten Haiku-Sichtprüfer Bilder (Texturen, Räume, Fassaden). Bevor wir ihnen trauen, eichen wir sie: Sie bekommen 18 Bilder, von denen 12 einen bekannten Fehler haben und 6 fehlerfrei sind, und wir messen ihre Trefferquote. Du baust diese Bilder – reproduzierbar per Werkzeug.

## Auftrag
**Neu** `/home/user/werwolf_digital_flutter/packages/burgstadt_spiel/bin/eichbilder.dart` (reines Dart). Aufruf aus `packages/burgstadt_spiel`:
`dart run bin/eichbilder.dart <bildordner> <loesungsdatei>`
- Schreibt 18 PNGs `eich_01.png` … `eich_18.png` nach `<bildordner>` in einer festen, aber **gemischten** Reihenfolge (Fehlerart darf nicht aus der Nummer folgen; Mischung mit festem Seed über einen eigenen kleinen LCG, kein `dart:math Random`).
- Schreibt die Lösung als Markdown-Tabelle `| Bild | fehlerfrei/Fehlerart | Ort im Bild | Beschreibung |` nach `<loesungsdatei>`.
- Bildgröße je 640×360 (quer), ganzzahlig vergrößerte Pixelgrafik wie im Spiel (Welt 320×180 ×2 oder Texturen gekachelt ×4). PNG schreiben wie `bin/bildschirmfoto.dart` / `bin/kontaktbogen.dart` (Funktion `encodePngRgba`).
- Die Bildinhalte nehmen echtes Spielmaterial: Texturen aus `baueAlleTexturen()`, Szenen über `ladeAusRepo(spiel)` und `Erkundung(ort: …, marke: …)` wie in `bin/bereichsfotos.dart`, die Bildkomposition über `komponiere(spiel.welt, spiel.ui, spiel.skala!)`. Hilfsfunktion zum Kacheln einer Textur siehe `bin/kontaktbogen.dart`.

Die 18 Bilder (je genau EIN Fehler oder keiner):
- **6 fehlerfrei:** 3 Spielszenen (Oberstadt `stadt` Marke `b`; ein Fall-Ort aus `fallorte.json`; Burg `gewoelbe`) und 3 Texturkacheln (`quaderMauer`, `holzDielen`, `fachwerkPutz`, je 4×4 gekachelt, ×2).
- **3 × Rauschen:** eine fehlerfreie Texturkachel bzw. Szene, in der 25–35 % der Pixel einer Fläche durch zufällige Palettenfarben derselben Rampe ersetzt sind (eine Textur: `putzOcker`; eine Szene: Boden der Oberstadt; eine Textur: `holzBohlen`).
- **2 × Moiré:** (a) eine Textur mit 1-Texel-Streifen im Wechsel (2 Farben), gekachelt und im Spiel-Raster auf einem schräg nach hinten laufenden Boden gezeichnet, so dass in der Ferne Interferenzmuster entstehen (zeichne den Boden selbst: Zeile y → Tiefe z, Texel = nearest, KEINE Mip-Stufe); (b) dasselbe mit einem feinen Schachbrett.
- **3 × Stilbruch:** (a) ein Putz mit weichem Verlauf über ≥ 12 Stufen von links nach rechts (Airbrush-Look), (b) eine Mauer mit Licht von UNTEN RECHTS (Lichtkante unten/rechts, Schatten oben/links – gegen Stilblatt §3), (c) eine Textur, deren Fugen die dunkelste Stufe der Rampe nutzen und 1 Texel breit sind, so dass sie in Mip 1 verschwinden (zeige Mip 0 links und Mip 1 rechts).
- **2 × Fremdfarbe:** eine fehlerfreie Szene, in der eine Fläche von 6×6 Bildpixeln in Magenta (RGB FF00FF) bzw. Neongrün (RGB 00FF66) steht – Ort zufällig, aber nicht am Rand. Dies sind die einzigen Pixel außerhalb der Palette.
- **2 × abgeschnitten:** (a) eine Szene mit einem UI-Panel (`PixelUi.panel` + Text), das rechts über den Bildrand hinausläuft, so dass der Text mitten im Wort abgeschnitten ist; (b) eine Texturkachel-Tafel, bei der die letzte Spalte Kacheln nur zur Hälfte im Bild ist.

Prüfe selbst: Lies jedes Bild mit dem Read-Werkzeug an und vergewissere dich, dass der Fehler sichtbar ist (und die fehlerfreien sauber sind). Schreibe in der Rückgabe je Bild einen Satz.

Pflichtläufe:
- `cd /home/user/werwolf_digital_flutter/packages/burgstadt_spiel && /opt/flutter/bin/dart analyze --fatal-infos` grün.
- `dart run bin/eichbilder.dart /home/user/werwolf_digital_flutter/hd/eichung/bilder /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/eichung_loesung.md`
- Ein zweiter Lauf in einen Scratch-Ordner liefert byte-gleiche Bilder (Determinismus; mit `cmp` prüfen).

WICHTIG: Die Lösungsdatei liegt NUR im Scratch-Ordner, NIE im Repo. In der Rückgabe die Lösung nicht wiederholen, nur ihren Pfad nennen.

## Rückgabe
Rückgabeformular laut AUTOR.md (STILBLATT-CHECK: welche Fehler gegen welche Stilblatt-Regel verstoßen), letzte Zeile `ENDE PAKET P0-AUTOR-05`.

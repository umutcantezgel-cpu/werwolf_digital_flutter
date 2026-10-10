Du bist Autor im Projekt „Burgstadt HD“. Paket **P0-AUTOR-02 · Kontaktbogen-Werkzeug** (HZ-04, HZ-05, HZ-07).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md und /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md und halte dich an die Regeln.

## Ziel
Ein Werkzeug, das jede Textur und jedes Mesh als beschriftetes Probebild („Kontaktbogen“) ausgibt, damit Prüfer und Sichtprüfer Stil, Kachelbarkeit und Mip-Lesbarkeit beurteilen können.

## Auftrag
**Neu** `/home/user/werwolf_digital_flutter/packages/burgstadt_spiel/bin/kontaktbogen.dart` (reines Dart). Aufruf aus `packages/burgstadt_spiel`:
- `dart run bin/kontaktbogen.dart texturen <ausgabe.png> [name1,name2,…]` – alle (oder die genannten) Welttexturen aus `baueAlleTexturen()` (Namen aus dem Enum `TexturId` in `packages/pixel_engine/lib/src/kit/texturen.dart`). Je Textur eine Zelle: oben 2×2 gekachelt in Mip 0 (in Originalgröße, ganzzahlig vergrößert mit Faktor `--zoom`, Standard 2), darunter 2×2 gekachelt in Mip 1 (gleicher Zoom, also halb so groß), darunter der Name in der Bitmap-Schrift (`BitmapFont.parse(kSchriftNormal)` aus pixel_engine; siehe wie `PixelUi` Text zeichnet). Zellen im Raster, Hintergrund `Pal.black`, Rahmen `Pal.darkGrey`.
- `dart run bin/kontaktbogen.dart texturen-licht <ausgabe.png> [namen]` – wie oben, aber jede Textur zusätzlich in 3 Lichtlagen (kalt 0,3 / warm 0,6 / Nebel 2) über `LightTable.night().lookup` umgefärbt, damit sichtbar wird, wie sie im Spiel wirkt.
- `dart run bin/kontaktbogen.dart bereich <bereich-id> <ausgabe.png>` – baut die Welt wie `bin/bereichsfotos.dart` (über `ladeAusRepo`), nimmt die `BereichGeometrie` des Bereichs und rendert sie aus 3 Blickwinkeln (von Süden, Südosten, Osten; Kamera außerhalb des Bounding-Rechtecks der Meshes auf 1,62 m Höhe, Blick zur Mitte, Bildgröße je 320×180) nebeneinander mit Beschriftung. Für einzelne Meshes später (Bauteile, Formen) reicht die Funktion `rendereMeshBlicke(List<Mesh> meshes, …)` als öffentliche Funktion in derselben Datei, die du für `bereich` benutzt.
- Am Ende jedes Laufs: Palettenprüfung des Bildes (jedes Pixel ein Palettenindex < `paletteRgb.length`; zähle Verstöße) und Ausgabe `KONTAKTBOGEN <modus> · <n> Zellen · Palette OK` bzw. `… · PALETTE FEHLER <n>` (Exit 1).
- PNG schreiben über die vorhandene PNG-Funktion in `packages/pixel_engine/lib/src/png.dart` (sieh nach, wie `bin/bildschirmfoto.dart` PNGs schreibt).

Probe (Pflicht): erzeuge
- `/home/user/werwolf_digital_flutter/hd/bilder/proben/P0-AUTOR-02_texturen.png` (alle Texturen),
- `/home/user/werwolf_digital_flutter/hd/bilder/proben/P0-AUTOR-02_licht.png` (Texturen `pflaster,putzOcker,dachBiberschwanz,fensterDunkel` – falls die Namen anders heißen, nimm die nächstliegenden aus `TexturId`),
- `/home/user/werwolf_digital_flutter/hd/bilder/proben/P0-AUTOR-02_bereich.png` (ein beliebiger Innenraum aus fallorte.json, id in der Rückgabe nennen).
Sieh dir jedes Bild mit dem Read-Werkzeug an und beschreibe in einem Satz, was zu sehen ist.

Prüfung: `cd packages/burgstadt_spiel && /opt/flutter/bin/dart analyze --fatal-infos` grün.

## Rückgabe
Rückgabeformular laut AUTOR.md, letzte Zeile `ENDE PAKET P0-AUTOR-02`.

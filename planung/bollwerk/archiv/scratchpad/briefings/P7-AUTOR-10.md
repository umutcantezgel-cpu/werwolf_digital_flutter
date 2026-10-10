Du bist Autor im Projekt „Burgstadt HD“. Paket **P7-AUTOR-10 · Anklage-Bildschirm v2** (HZ-11).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md, /home/user/werwolf_digital_flutter/hd/STILBLATT.md (§10) und /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/briefings/P7-KOPF.md.

## Gegenstand
`packages/burgstadt_spiel/lib/src/bildschirme/anklage.dart` (nur diese Datei; Texte und Knopf-Rechtecke bleiben wortgleich bzw. gleich).

## Gestaltung (verbindlich)
- Hintergrund statt leerem Schwarz: ein ruhiges Pixelmuster über das ganze UI-Raster unter dem Panel – Morgengrauen-Himmel: waagerechte Bänder von unten `Ramp.at16(Ramp.amber, 5)` über `Ramp.at16(Ramp.red, 4)` und `Ramp.at16(Ramp.blue, 4)` nach oben `Ramp.at16(Ramp.blue, 1)`, Bandgrenzen mit 2-Zeilen-Bayer-Übergang (`bayer4` aus pixel_engine), nur im Abschnitt **Ende** (Morgengrauen); bei Eingrenzung/Anklage ein dunkles Nachtblau-Muster (`Ramp.at16(Ramp.blue, 1)` mit jedem 4. Pixel jeder 4. Zeile in `Ramp.at16(Ramp.blue, 2)` – ruhiges Raster, kein Rauschen).
- Panel: wie bisher `ui.panel(p, grund: UiFarbe.grundDunkel)` (Panel v2 ist schon gestaltet).
- Überschriften („Eingrenzung“, „Wen klagst du an?“, „Morgengrauen · Ende: …“): darunter eine 1-px-Trennlinie über die Panelbreite − 12 in `UiFarbe.randDunkel` mit 1 px `UiFarbe.randHell` darunter (Fase).
- Verdächtigen-Knöpfe: links im Knopf ein 10×10-Feld mit einem einfachen Pixel-Siegel (Kreis 8 px in `Ramp.at16(Ramp.red, 6)` mit 1 px `Ramp.at16(Ramp.red, 9)` oben links) – reine Zier, Beschriftung bleibt zentriert wie bisher, Trefferfläche gleich.
- Bestätigungsfrage: Rahmen um den Fragetext (`ui.rahmen` o. ä.) in `UiFarbe.akzent`.
- Keine neuen Texte, keine Animation, keine neuen Farben außerhalb der Palette.

## Belege
Vorher/Nachher (1280×720 und 1080×2400) für (a) Auswahl der Verdächtigen, (b) Bestätigungsfrage, (c) Ende. Erzeuge sie mit einem Skript, das eine Fallsitzung startet und den Bildschirm direkt setzt (Vorbild: `packages/burgstadt_spiel/bin/spieltest.dart` – dort wird der Anklage-Bildschirm erreicht); Skript NUR vorübergehend unter `packages/burgstadt_spiel/bin/_tmp_anklage.dart`, danach löschen. Bilder nach `hd/bilder/proben/P7-AUTOR-10_<vorher|nachher>_<a|b|c>_<quer|hoch>.png`.

## Pflicht
`dart analyze --fatal-infos` und `dart test` in `packages/burgstadt_spiel` grün; `bin/spieltest.dart` (wie in `tool/alle_tests.sh`: `dart run bin/spieltest.dart <ordner> 4` und `... 12 1080 2400`) endet mit `SPIELTEST OK`.

## Rückgabe
Rückgabeformular laut AUTOR.md, letzte Zeile `ENDE PAKET P7-AUTOR-10`.

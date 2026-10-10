Du bist Autor im Projekt „Burgstadt HD“. Paket **P7-AUTOR-01+02 · Knöpfe v2 und Panels v2** (HZ-11).

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md, /home/user/werwolf_digital_flutter/hd/STILBLATT.md (§1, §2, §10) und /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/briefings/P7-KOPF.md.

## Gegenstand
`packages/pixel_engine/lib/src/ui/pixel_ui.dart`: die Funktionen `panel(...)`, `knopf(...)` und – falls vorhanden – `rahmen(...)` sowie die Farbkonstanten `UiFarbe`. Nur diese Datei ändern.

## Gestaltung (verbindlich)
**Panel v2** (gleiche Außenmaße r):
- Schlagschatten 1 px unten und rechts außerhalb (wie bisher, `UiFarbe.schatten`).
- Außenrand 1 px in `UiFarbe.rand`; die vier Eckpixel des Außenrands bleiben frei (Grund durchscheinen lassen = abgerundeter Eindruck): Ecken nicht zeichnen.
- Innen-Fase: oberste Innenzeile und linke Innenspalte 1 px hell (`UiFarbe.randHell`), unterste Innenzeile und rechte Innenspalte 1 px dunkel (neue Konstante `UiFarbe.randDunkel = Ramp.at16(Ramp.stone, 4)`).
- Grundfläche `grund`, dazu eine 1-px-Glanzlinie direkt unter der Innenfase oben in `Ramp.at16(Ramp.blue, 6)`, wenn `grund == UiFarbe.grund` (sonst keine).
**Knopf v2** (gleiche Maße, gleiche Trefferlogik, gleiche Zustände):
- normal: wie Panel v2 (Rand `UiFarbe.rand`, Fase hell/dunkel, Grund `UiFarbe.grund`).
- hervorgehoben: Rand `UiFarbe.akzent`, Grund `Ramp.at16(Ramp.blue, 7)`.
- gedrückt: Fase umgekehrt (oben/links dunkel, unten/rechts hell), Grund `UiFarbe.akzentDunkel`, Inhalt 1 px nach unten rechts, kein Schlagschatten (wie bisher).
- gesperrt: Grund `UiFarbe.grundDunkel`, Rand `Ramp.at16(Ramp.stone, 7)`, keine Fase, Text `UiFarbe.textGedimmt`.
- Fokus: Rand `UiFarbe.akzent`, Fase oben in Akzent (wie bisher) und der Pfeil links (unverändert).
- Die Beschriftung bleibt an derselben Stelle.
- ACHTUNG Test: `packages/burgstadt_spiel/test/spiel_test.dart` sucht den Knopf „Allein spielen“ über die Farbe `UiFarbe.rand` in der Bildmitte (Zeilen ~75–82). Der Außenrand muss daher weiterhin `UiFarbe.rand` sein (bis auf die freien Ecken) – prüfe, dass der Test grün bleibt.

## Belege
Vorher/Nachher wie in P7-KOPF.md für die Bildschirme `hauptmenue` und `optionen` (Dateinamen von bildschirmfoto.dart), jeweils 1280×720.

## Rückgabe
Rückgabeformular laut AUTOR.md (STILBLATT-CHECK mit §10), letzte Zeile `ENDE PAKET P7-AUTOR-0102`.

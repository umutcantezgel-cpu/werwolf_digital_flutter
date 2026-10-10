Du bist Autor im Projekt „Burgstadt HD“. Paket **P4-AUTOR-03 · Form bank** (HZ-07). Lies zuerst /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/briefings/FORM-KOPF.md und halte dich daran.

## Gegenstand
Datei `packages/burgstadt_spiel/lib/src/bau/formen/bank.dart`, Klasse `BankForm`, `name` = `'bank'`.
Bestand (Legende): „Bank“ 0,45 m holzBohlen (7×), „Eckbank“, „Gaubenbank“, „Fensterbank“, „Kinderbank“ 0,45; „Sackbank“ 0,45 holzDielen; „Sägebock“ 0,7 holzDielen; „Wartebank“ 0,5; „Wandbank“ 0,5; „Bankreihe“ 0,9 holzBohlen. Bänke sind lang (2–8 Kacheln) und 1 Kachel tief.

## Gestaltung
- Die **Längsrichtung** ist die längere Seite der Grundfläche.
- **hoehe ≤ 0,55 (Sitzbank ohne Lehne):** Sitzbrett 0,05 m dick über die ganze Länge; **Wangen** statt Beinen: alle ≤ 1,2 m eine Brettwange (0,04 m dick, volle Tiefe minus 0,04), unten mit einem Ausschnitt (zwei Füße: die Wange besteht aus zwei Stollen 0,08 m breit und einem Querholz darüber); dazu eine Längszarge 0,08 m hoch direkt unter dem Sitz auf der Rückseite (`rueckseite`).
- **0,55 < hoehe < 0,85 (Sägebock):** zwei gespreizte Beinpaare (schräge Quads, je 2 Beine, die nach außen 0,06 m auseinanderlaufen), ein Balken 0,1 × 0,1 oben.
- **hoehe ≥ 0,85 (Bankreihe, Kirchenbank):** Sitz auf 0,45 m, Rückenlehne an `rueckseite` bis `hoehe` (Brett 0,03 m, leicht nach hinten versetzt um 0,04 m oben), Wangen an den Enden bis zur vollen Höhe mit abgerundetem Abschluss (2 Stufen).
- Variante `o.hash(0) % 2`: Sitzbrett aus zwei Brettern mit 0,01 m Fuge (zwei Boxen) oder ein Brett.
- **Budget:** ≤ 24 Dreiecke je laufendem Meter + 40.

## Testgrundflächen
2,42 × 0,42 × 0,45; 0,42 × 3,92 × 0,45 (längs in z); 1,42 × 0,42 × 0,7 (Sägebock); 3,92 × 0,92 × 0,9 (Bankreihe). Erlaubte Texturen: nur o.textur.

Probe: `hd/bilder/proben/P4-AUTOR-03.png`. Letzte Zeile der Rückgabe `ENDE PAKET P4-AUTOR-03`.

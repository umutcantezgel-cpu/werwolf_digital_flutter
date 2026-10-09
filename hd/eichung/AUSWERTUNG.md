# Eichlauf der Sichtprüfer (P0-SICHT-01…03) – Auswertung

Bilder: `hd/eichung/bilder/eich_01…18.png` (P0-AUTOR-05), Lösung: `LOESUNG.md` (erst nach dem Lauf ins Repo gelegt).

| Stimme | richtig | Quote | falsch | fehlerhafte erkannt | Fehlalarme |
|---|---|---|---|---|---|
| P0-SICHT-01 | 14/18 | 77,8 % | 01, 08, 09, 18 | 11/12 | 2/6 |
| P0-SICHT-02 | 14/18 | 77,8 % | 01, 06, 09, 18 | 10/12 | 1/6 |
| P0-SICHT-03 | 16/18 | 88,9 % | 01, 08 | 11/12 | 1/6 |
| Mehrheit 2 von 3 | 14/18 | 77,8 % | 01, 08, 09, 18 | – | – |

## Befund je Fehlbild
- **eich_01 (Stilbruch: Licht von unten rechts, 2-Texel-Kante):** von allen drei übersehen. Die Lichtrichtung ist in Bildgröße kaum sichtbar → wird **strukturell gemessen** (Lichtkantentest in `texturen_test` v2, P1-AUTOR-01), nicht per Sichtprüfung.
- **eich_08 (fehlerfrei, Kamin-Gewölbe im Bestand):** 2 von 3 sehen „Rauschen“ in der Gewölbedecke. Der Bestand wirkt verrauscht – das ist genau der Ausgangsbefund, den Burgstadt HD beheben soll (gestaltete Texturen statt Rauschen); kein Prüferfehler im engeren Sinn.
- **eich_09 (Fremdfarbe Neongrün 6×6):** 2 von 3 nennen stattdessen „Rauschen“ in der Kalkputz-Fassade. Fremdfarben prüft ohnehin der **Palettentest** (`countOffPalette`, jede Abnahme) – strukturell.
- **eich_18 (fehlerfrei, Uhrwerk-Kammer):** 2 von 3 halten die helle, kalte Säule für Fremdfarbe. Sie ist Bestand (Uhrwerk mit kaltem Licht) und fällt auch im Kontaktbogen auf → Befund für P4 (Form/Licht der Uhrwerk-Kammer), kein Palettenfehler.

## Entscheidung (E-047, Annahme A2)
Die Mehrheitsquote liegt mit 77,8 % unter 80 %. Gemäß A2 gilt daher:
1. **Strukturmessung statt Sichturteil** für Fremdfarbe (Palettentest), Lichtrichtung (Lichtkantentest) und Streupixel (Streupixel-Quote ≤ 8 % in `texturen_test` v2).
2. **Sichtprüfer urteilen** über Moiré, Rauschen in Texturkacheln, Abgeschnittenes, Verlauf/Airbrush, Gesamteindruck und Kanon-Blick – dort lagen alle drei Stimmen richtig (02, 03, 05, 07, 11, 13, 14, 17: 24 von 24 Einzelurteilen).
3. **Opus-Stichprobe** an jedem Tor: Ich sehe mir jedes Torbild selbst an, bevor ein Sichturteil zählt.
4. Briefing-Verbesserung (L5): Sichtprüfer bekommen künftig Referenzbilder „so sieht der gewollte Stil aus“ (Musterdateien ab P1-OPUS-12) und das Vorher-Bild zum Vergleich.

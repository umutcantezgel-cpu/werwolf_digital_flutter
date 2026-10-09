Du bist Autor im Projekt „Burgstadt HD“. Paket **P4-AUTOR-02 · Form stuhl** (HZ-07). Lies zuerst /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/briefings/FORM-KOPF.md und halte dich daran.

## Gegenstand
Datei `packages/burgstadt_spiel/lib/src/bau/formen/stuhl.dart`, Klasse `StuhlForm`, `name` = `'stuhl'`.
Bestand (Legende): „Stuhl“ 0,5 m holzBohlen (9×), „Hocker“ 0,45–0,5 m, „Schemel“ 0,4–0,45 m, „Vorsteherstuhl“ 1,0 m eichenTuerEisen, „Lesesessel“ 0,9 m teppichRot, „Stuhl“ 0,9 m holzDielen, „Ratsstuhl“ 0,95 m holzDielen. Grundfläche meist 1 Kachel (0,42 × 0,42 m nach dem Einrücken).

## Gestaltung
- `hoehe` ist die Gesamthöhe. **Sitzhöhe** = min(0,45, hoehe) m.
- **hoehe ≤ 0,55 (Hocker, Schemel, niedriger Stuhl):** Sitzplatte 0,05 m dick, 0,02 m Überstand nach innen eingerückt; vier Beine 0,05 × 0,05 m, leicht nach innen versetzt (0,03 m); bei `o.hash(0) % 2 == 0` drei Beine (Melkschemel, Dreieck) statt vier; eine Querstrebe zwischen zwei Beinen auf 0,15 m Höhe. Keine Lehne.
- **hoehe > 0,55 (Stuhl mit Lehne):** Sitz wie oben auf 0,45 m; Lehne an der Seite `rueckseite`: zwei Lehnenpfosten (Verlängerung der hinteren Beine) bis `hoehe`, dazwischen ein Brett (Höhe 0,25 m, Dicke 0,03 m) oben und bei `o.hash(1) % 2 == 0` eine zweite schmale Sprosse darunter.
- **Lesesessel / Ratsstuhl / Vorsteherstuhl (hoehe ≥ 0,9 und Grundfläche ≥ 0,9 m in einer Richtung oder Textur ≠ holzBohlen):** breiter Sitz, Armlehnen (0,06 m breit, auf 0,65 m Höhe) an den beiden Seiten quer zur `rueckseite`, hohe geschlossene Lehne.
- Die Rückseite (Lehne) zeigt zur Wand (`rueckseite`), die Sitzvorderkante in den Raum.
- **Budget:** ≤ 70 Dreiecke (Sessel ≤ 90).

## Testgrundflächen
0,42 × 0,42 × 0,5; 0,42 × 0,42 × 0,9; 0,92 × 0,92 × 0,9 (Sessel). Erlaubte Texturen: nur o.textur.

Probe: `hd/bilder/proben/P4-AUTOR-02.png`. Letzte Zeile der Rückgabe `ENDE PAKET P4-AUTOR-02`.

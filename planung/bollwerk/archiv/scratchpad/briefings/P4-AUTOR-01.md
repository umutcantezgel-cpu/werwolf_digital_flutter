Du bist Autor im Projekt „Burgstadt HD“. Paket **P4-AUTOR-01 · Form bett** (HZ-07). Lies zuerst /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/briefings/FORM-KOPF.md und halte dich daran.

## Gegenstand
Datei `packages/burgstadt_spiel/lib/src/bau/formen/bett.dart`, Klasse `BettForm`, `name` = `'bett'`.
Bestand in der Stadt (Legende): „Bett“ 0,6 m hoch, holzBohlen (3×); „Wiege“ 0,7 m, holzVertaefelung; „Schrankbett“ 1,9 m, holzVertaefelung. Grundflächen sind Kachelvielfache (0,5 m) minus 2 × 0,04 m – lies die echten Maße aus dem Probebild-Titel (Modus `formen`).

## Gestaltung
- **Bettgestell** aus `o.textur`: vier Eckpfosten (0,08 × 0,08 m), Seitenzargen 0,12 m hoch auf 0,20–0,32 m Höhe, Kopfteil an der `rueckseite` bis zur vollen `hoehe` (oben 0,04 m Abschlussleiste etwas heller), Fußteil auf der Gegenseite niedriger (≈ 60 % der Höhe).
- **Liegefläche:** Strohsack/Matratze 0,12 m dick auf den Zargen, Textur `TexturId.holzDielen` mit gedämpftem Licht; darauf eine **Wolldecke** aus `TexturId.teppichRot`, die das Fußende und die Seiten 0,04 m überlappt und die obere ⅓ (zum Kopfteil hin) frei lässt. **Keine weiße Bettwäsche, kein Kissen in Weiß, kein Laken** (Kanon).
- Das Kopfteil steht an der Seite `rueckseite`; liegt das Ding quer (breiter als tief), richtet sich die Liegerichtung trotzdem nach `rueckseite`.
- **Schrankbett** (hoehe > 1,5 m): Kasten mit Rückwand an `rueckseite`, zwei Seitenwänden und Dach (Kranzleiste 0,06 m), offene Front mit dem Bett darin auf 0,3 m Höhe.
- **Wiege** (Grundfläche ≤ 1,0 m in beiden Richtungen): niedriger Kasten mit zwei gebogenen Kufen (je 3–4 Segmente) unten statt Pfosten.
- Variante `o.hash(0) % 3`: Kopfteil gerade / mit zwei Zierknäufen (0,06 m Würfel) / mit Mittelbrett.
- **Budget:** ≤ 90 Dreiecke (Schrankbett ≤ 110).

## Testgrundflächen
2,0 × 1,0 × 0,6 m; 1,0 × 2,0 × 0,6 m; 1,0 × 0,5 × 0,7 m (Wiege); 2,0 × 1,0 × 1,9 m (Schrankbett). Erlaubte Texturen: o.textur, holzDielen, teppichRot.

Probe: `hd/bilder/proben/P4-AUTOR-01.png`. Letzte Zeile der Rückgabe `ENDE PAKET P4-AUTOR-01`.

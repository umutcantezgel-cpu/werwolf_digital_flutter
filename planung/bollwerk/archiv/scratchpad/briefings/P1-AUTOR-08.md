Du bist Autor im Projekt „Burgstadt HD“. Paket **P1-AUTOR-08 · Bauteil fenster v1** (HZ-05) – das erste Fassaden-Bauteil.
Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md und /home/user/werwolf_digital_flutter/hd/STILBLATT.md (§6 Bauteilmaße, §1).

## Schnittstelle (lies sie zuerst)
- `packages/burgstadt_spiel/lib/src/bau/bauteil.dart`: `Wandflaeche` (Grundlinie x0,z0 → x1,z1, Unterkante y0, Oberkante y1, Außennormale nx,nz, Licht warm/kalt; `punkt(u, aussen)`), `BauteilOrt` (Fläche, Mittelpunkt `u` entlang der Fläche, Unterkante `y`, `breite`, `hoehe`, `kennung`, `texturen`-Map Rolle → Texturindex, `hash(teil)`), Interface `Bauteil { String get name; void baue(MeshBuilder m, BauteilOrt o); }`.
- `packages/pixel_engine/lib/src/raster/mesh.dart`: `MeshBuilder.wall(...)` (senkrechte Fläche, sichtbar von rechts in Laufrichtung), `box(...)`, `vertex(...)`, `quad(...)`. UV in Texeln mit `kDichteWelt` = 64 Texel/m.
- Heute zeichnet `_haus` in `packages/burgstadt_spiel/lib/src/welt_geometrie.dart` Fenster als flache Quads 3 cm vor der Wand (Zeilen mit `reihe(`). Lies das, um Maße und Lichtwerte zu verstehen. NICHT ändern – den Einbau macht der Orchestrator.

## Auftrag
NEU `packages/burgstadt_spiel/lib/src/bau/teile/fenster.dart` mit `class FensterV1 implements Bauteil` (`name` = `'fenster'`). Die Fassade ist (noch) eine geschlossene Fläche ohne Loch; das Fenster ist deshalb ein **aufgesetztes Relief**:
1. **Glas:** Fläche breite × hoehe, 0,01 m vor der Wand, Textur `o.texturen['glas']` (Fallback: Index von `TexturId.fensterDunkel`), UV in Metern × 64 ab der linken oberen Glasecke (so kachelt die Sprossentextur maßstabsgetreu).
2. **Rahmen (Faschen):** umlaufender Putzrahmen 0,12 m breit, 0,04 m vor der Wand (vier flache Kästen), Textur `o.texturen['rahmen']`; Seiten der Kästen sichtbar (Tiefe 0,04).
3. **Sims (Fensterbank):** unter dem Fenster, Breite = breite + 2 × 0,12 + 2 × 0,04, Höhe 0,06, Vorsprung 0,08 m, Textur `o.texturen['sims']`.
4. **Sturz:** über dem Rahmen ein Gesims 0,06 hoch, 0,05 vorstehend, Breite wie Sims, Textur `o.texturen['sims']`.
5. **Licht:** Vertex-Licht aus `o.flaeche.warm/kalt`; Unterseiten (Sims, Sturz) mit 0,6 × kalt (Schatten), Oberseiten mit +0,05 kalt.
6. Vorsprungsregel (Stilblatt §6): unter 2,3 m Höhe höchstens 0,10 m – der Sims steht 0,08 m vor (erfüllt).
7. Variante über `o.hash(0)`: Bei `hash % 5 == 0` hat das Fenster keinen Sturz (schlichtere Häuser).
Registriere es in `packages/burgstadt_spiel/lib/src/bau/teile/register.dart` (Import + Eintrag in der Liste `const <Bauteil>[FensterV1()]`).

## Test und Probe
- NEU `packages/burgstadt_spiel/test/bauteil_fenster_test.dart`: (a) baut ein Fenster auf einer Wand nach Süden (Normale (0,1)) und nach Osten, zählt Dreiecke (> 20), prüft, dass alle Vertices innerhalb [Wand − 0,01, Wand + 0,13] in Normalenrichtung liegen und innerhalb der Fensterbreite + 0,4 m; (b) Vorsprung unter 2,3 m ≤ 0,10 m; (c) zwei Bauvorgänge mit gleicher Kennung ergeben identische Meshes (Determinismus).
- Probe: rendere das Fenster mit `rendereMeshBlicke` aus `bin/kontaktbogen.dart` (öffentliche Funktion; lies, wie sie aufgerufen wird) vor einer Putzwand (eigene Wand-Box 3 × 3 m mit Textur `putzOcker`) – über ein Skript NUR vorübergehend unter `packages/burgstadt_spiel/bin/_tmp_fenster.dart`, danach löschen. Bild nach `/home/user/werwolf_digital_flutter/hd/bilder/proben/P1-AUTOR-08.png`, mit Read ansehen und beschreiben.
- `cd packages/burgstadt_spiel && /opt/flutter/bin/dart analyze --fatal-infos && /opt/flutter/bin/dart test` grün.

## Rückgabe
Rückgabeformular laut AUTOR.md (STILBLATT-CHECK §6 mit Maßen), letzte Zeile `ENDE PAKET P1-AUTOR-08`.

Du bist Autor im Projekt „Burgstadt HD“. Paket **P1-AUTOR-07 · Textur fensterDunkel v2 (Sprossenglas bei Nacht)** (HZ-04).
Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md und /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/briefings/TEXTUR-KOPF.md.

**Gegenstand:** Dunkles Fensterglas mit Sprossen (ersetzt Bestand `fensterDunkel`). Datei `kit/texturen/fenster_dunkel_a.dart`, Funktion `fensterDunkelV2A()`, Kandidat `fensterDunkel_a`.
**Hintergrund:** Rahmen, Laibung und Sims baut künftig das Bauteil „fenster“ als Geometrie; diese Textur ist NUR die Glasfläche mit Sprossen und wird in Metern auf die Glasfläche gelegt (64 Texel = 1 m, kachelnd). Ein Fenster ist ca. 0,9 × 1,1 m.
**Gestaltung:** 64×64 (1 m × 1 m), kachelbar. Sprossenkreuz-Raster: senkrechte und waagrechte Sprossen alle 21–22 Texel (3 Felder je Meter), Sprosse 2 Texel breit aus `wood` (Stufe 6, linke/obere Sprossenkante 1 Texel Stufe 8, rechte/untere Stufe 4). Glas: `blue` Stufen 2–4 (Grund Stufe 3; je Scheibe über Lcg leicht anders: Stufe 2, 3 oder 4 als ganze Fläche), in jeder Scheibe oben links eine kurze diagonale Spiegelung (3–5 Texel lange Linie unter 45°, Stufe 6) – nicht in allen Scheiben gleich lang (Lcg). Im Glas unten rechts je Scheibe 1 Texel dunklerer Rand (Stufe 1) als Tiefe. Kein Rauschen.
Hinweis: Glas ist ein flaches Material ohne Lichtkanten-Pflicht; die Sprossen sind erhaben (Licht oben links).
Beleg-Paketname für den Kontaktbogen: `P1-AUTOR-07`.
**Rückgabe:** Rückgabeformular laut AUTOR.md, letzte Zeile `ENDE PAKET P1-AUTOR-07`.

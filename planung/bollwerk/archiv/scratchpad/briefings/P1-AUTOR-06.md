Du bist Autor im Projekt „Burgstadt HD“. Paket **P1-AUTOR-06 · Textur dachBiberschwanz v2** (HZ-04).
Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md und /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/briefings/TEXTUR-KOPF.md.

**Gegenstand:** Biberschwanz-Ziegeldach (ersetzt Bestand `dachBiberschwanz`). Datei `kit/texturen/dach_biberschwanz_a.dart`, Funktion `dachBiberschwanzV2A()`, Kandidat `dachBiberschwanz_a`.
**Wichtig zur Ausrichtung:** Auf dem Dach liegt die Oberkante der Textur am First, die Unterkante an der Traufe (v wächst zur Traufe). Die gerundeten Ziegelenden zeigen also NACH UNTEN.
**Gestaltung:** 128×128 (2 m × 2 m). Doppeldeckung: Reihen 12 Texel hoch (sichtbarer Teil), Ziegel 11 Texel breit (≈ 17 cm), jede Reihe um einen halben Ziegel versetzt. Jeder Ziegel: Körper `red` Stufen 7–9 (je Ziegel über Lcg eine von drei; jeder ~8. Ziegel `wood` Stufe 7 als gealterter brauner Ziegel), unten gerundet (die zwei unteren Eckpixel jeder Seite in Schattenfarbe), linke Kante 1 Texel +2 Stufen, obere 1 Texel +1, rechte Kante 1 Texel −2, unter jedem Ziegelende 2 Texel Schlagschatten (`red` Stufe 3) auf der darunterliegenden Reihe. Zwischen den Ziegeln 1 Texel Fuge `red` Stufe 4. Kein Grün (Moos ist die eigene Textur `dachBiberschwanzMoos`).
Beleg-Paketname für den Kontaktbogen: `P1-AUTOR-06`.
**Rückgabe:** Rückgabeformular laut AUTOR.md, letzte Zeile `ENDE PAKET P1-AUTOR-06`.

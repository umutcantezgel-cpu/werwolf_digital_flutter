# FORM-KOPF · gemeinsame Regeln für alle Möbelformen (P4-AUTOR-01 … 20)

Lies zuerst: /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md,
/home/user/werwolf_digital_flutter/hd/STILBLATT.md (§1, §2, §8) und /home/user/werwolf_digital_flutter/hd/kundschaft/P0-KUND-04.md (Abschnitt 4a/4b, Verbotsliste).

## Schnittstelle
- `packages/burgstadt_spiel/lib/src/bau/form.dart`: `FormOrt` (Grundfläche `x0,z0,x1,z1` in Metern, schon 0,04 m eingerückt; `hoehe`; `textur` = Texturindex aus der Legende; `warm`, `kalt` = Licht; `rueckseite` 0 = −z, 1 = +x, 2 = +z, 3 = −x – die Seite an der Wand, Lehnen und Rückwände gehören dorthin; `ding` mit `ding.legende` (u. a. `lichtWarm`); `hash(teil)` für Varianten). Interface `Moebelform { String get name; void baue(MeshBuilder m, FormOrt o); }`.
- Muster: `packages/burgstadt_spiel/lib/src/bau/formen/tisch.dart` (heutiger Tisch, Platte + 4 Beine).
- `packages/pixel_engine/lib/src/raster/mesh.dart`: `MeshBuilder.box(x0,y0,z0,x1,y1,z1, tex, warm:, cold:, texTop:)`, `vertex`, `quad`, `triangle`, `wall`, `floor`. UV in Texeln, `kDichteWelt` = 64 Texel/m (box/wall/floor rechnen das selbst).
- Register: `packages/burgstadt_spiel/lib/src/bau/formen/register.dart` – deine Form ist dort schon eingetragen; deine Datei `bau/formen/<name>.dart` existiert als Platzhalter (Quader). Du ERSETZT nur den Inhalt deiner Datei (Klassenname und `name` bleiben). register.dart und alle anderen Formdateien änderst du NICHT.

## Regeln
1. **Grundfläche ist Gesetz:** Alle Eckpunkte liegen in [x0, x1] × [z0, z1] und in der Höhe in [0, hoehe] (Kollision und Karte bleiben die des Dings). Kleinere Teile dürfen innen liegen.
2. **Mindestens 3 Teilkörper**, Silhouette durch Geometrie (Stilblatt §8, P2 des Kerns). Kanten durch Licht: Oberseiten etwas heller (`cold: k + 0.05`), Unterseiten und Innenflächen dunkler (`warm: w * 0.8` o. ä.). Werte auf 0..1 begrenzen.
3. **Texturen:** Hauptkörper `o.textur`. Zusätzliche Texturen nur aus `TexturId` und nur die im Auftrag genannten. Keine Farbe außerhalb der Palette, kein Grün.
4. **Dreiecksbudget:** höchstens so viele Dreiecke wie im Auftrag genannt (gezählt mit `MeshBuilder.triangleCount`). Unsichtbare Flächen (Unterseiten am Boden, Rückseiten an der Wand) weglassen, wo `box` es erlaubt – sonst eigene Quads.
5. **Varianten** nur über `o.hash(teil)` (z. B. Lehne gerade oder geschwungen); nie `dart:math Random`.
6. **Kanon (P0-KUND-04 §4):** keine weiße Bettwäsche, kein Laken oder Leinen, keine Becher, Krüge, Gläser, Flaschen, kein Geschirr, keine Kerzenständer oder -leuchter, keine Schlüssel, Taler, Zettel. Eine Kerze nur dort, wo der Auftrag es sagt.
7. **Ein Paket, eine Datei** `packages/burgstadt_spiel/lib/src/bau/formen/<name>.dart` (snake_case), plus ein Test `packages/burgstadt_spiel/test/form_<name>_test.dart`.

## Test (Pflicht)
`test/form_<name>_test.dart` baut die Form für drei Grundflächen aus dem Auftrag und für alle vier `rueckseite`-Werte und prüft: (a) alle Eckpunkte innerhalb Grundfläche und Höhe (Toleranz 1e-9), (b) Dreiecke ≥ 12 und ≤ Budget, (c) gleiche Kennung → identisches Mesh (pos, uv, tri, tex), (d) Texturindizes nur aus der erlaubten Menge. Ein `Ding` für den Test: lies, wie `Ding` und `Legende` in `packages/burgstadt_core/lib/src/welt/bereich.dart` gebaut werden.

## Probe (Pflicht)
`cd packages/burgstadt_spiel && /opt/flutter/bin/dart run bin/kontaktbogen.dart formen /home/user/werwolf_digital_flutter/hd/bilder/proben/<PAKET-ID>.png <name>`
(dafür muss die Form im Register stehen – vorübergehend, siehe oben). Das Bild mit Read ansehen und in der Rückgabe beschreiben: Silhouette, Lehne an der richtigen Seite, Lesbarkeit.

## Prüfen
`cd packages/burgstadt_spiel && /opt/flutter/bin/dart analyze --fatal-infos && /opt/flutter/bin/dart test test/form_<name>_test.dart` grün.
Nichts committen, nichts pushen. Andere Dateien als die eigenen nicht verändern (andere Agenten arbeiten parallel im selben Baum).

## Rückgabe
Formular aus AUTOR.md (ÄNDERUNGEN, TEST, PROBE, STILBLATT-CHECK §8, KANON-CHECK, OFFENE FRAGEN, SELBSTPRÜFUNG), Dreieckszahl je Probe-Ding, letzte Zeile `ENDE PAKET <ID>`.

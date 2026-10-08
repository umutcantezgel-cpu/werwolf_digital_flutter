# Bereichs-Format (eingefroren 09.10.)

Ein **Bereich** ist ein Innenraum oder Außenbereich als Kachelraster (1 Zeichen = 0,5 m × 0,5 m).
Datei: `data/innenraeume/<gruppe>.json` = `{"version":1,"bereiche":[ <Bereich>, … ]}`. Leser: `Bereich.ausJson`
(`lib/src/welt/bereich.dart`), Beispiel von Hand: `lib/src/welt/burg.dart`.

```json
{"id":"innen-baeckerei","name":"Bäckerei am Untertor","innen":true,"raumHoehe":2.8,
 "wandTextur":"putzCreme","bodenTextur":"holzDielen","deckenTextur":"holzBohlen","grundWarm":0.05,"grundKalt":0.04,
 "karte":[
  "##########",
  "#OO....TT#",
  "#........#",
  "#..t.....#",
  "####DD####"],
 "legende":{
  "O":{"art":"objekt","name":"Backofen","form":"kasten","hoehe":1.6,"textur":"ziegelKamin","lichtWarm":0.6,"lichtWeite":4},
  "T":{"art":"objekt","name":"Ladentheke","form":"tisch","hoehe":1.0,"textur":"holzDielen"},
  "D":{"art":"tuer","name":"Ladentür","ziel":"stadt","zielMarke":"tuer-H-123","textur":"eichenTuer"}}}
```

## Zeichen
- `#` Wand (Raumhöhe, Textur `wandTextur`), `.` Boden, ` ` (Leerzeichen) außerhalb.
- `a`–`z` Marken (begehbarer Boden mit Namen: Ankunft hinter Türen, Plätze für Figuren). Jede Tür braucht im **eigenen** Bereich eine Marke direkt davor (Ankunft von außen); der Name ist frei, üblich `t`.
- Großbuchstaben/Ziffern laut Legende: `objekt` (blockiert, wird als Möbel gebaut), `tuer` (in der Wandlinie; führt zu `ziel`/`zielMarke`), `station` (begehbarer Boden mit Fundstelle, Kennung `station`).
- Gleiche benachbarte Zeichen bilden **ein** Ding (Rechteck). Alle Zeilen gleich lang.

## Legende-Felder
`art` (objekt|tuer|station), `name` (wird im Spiel angezeigt – Deutsch, duzen, Leitplanken!), `form`
(tisch|stuhl|bank|regal|truhe|kasten|kiste|fass|bett|ofen|kamin|theke|vitrine|kessel|wand|saeule|tuerdeko|brunnen),
`hoehe` (m), `textur` (Name aus `TexturId` in `packages/pixel_engine/lib/src/kit/texturen.dart`),
`lichtWarm`/`lichtKalt` (0–1) und `lichtWeite` (m) für Lichtquellen (Kerze 0,3/2,5 m; Ofen 0,6/4 m; Kamin 0,9/7 m),
`ziel`/`zielMarke`/`verschlossen` für Türen, `station` für Stationen.

## Regeln
- Strom ist aus (Kanon STADT-02): Licht nur von Kerzen, Glut, Öfen, Notleuchten, Mond (`grundKalt` 0,03–0,08 drinnen).
- Raumhöhe 2,4–3,4 m; Räume 4–14 m Kantenlänge; mindestens 1 Tür; alles Begehbare von der Tür aus erreichbar.
- Keine Alkoholika, kein Blut, keine Hexen/Teufel. Gaststätten sind Teestube, Café, Bäckerei.
- Prüfung: `Welt(...).pruefe()` leer, Erreichbarkeit per Flutfüllung (siehe `test/welt_test.dart`).

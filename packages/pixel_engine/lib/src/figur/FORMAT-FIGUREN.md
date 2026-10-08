# Figuren-Format (eingefroren 09.10.)

Figuren entstehen aus einer **Gliederpuppe** (Skelett `kSkelett`, Standardkörper `kKoerper`) plus **Teilen**.
Der Brenner (`FigurBaker`) wirft Strahlen auf die Grundkörper und brennt 8 Richtungen × alle Animationen
als indizierte Sprites (48×80 px, Fußpunkt 24/77, 32 Texel/m). Schattierung, Kontur, Innenlinien und Augen
entstehen automatisch.

## Koordinaten
- Meter, für eine 1,75 m große Figur; der Brenner skaliert mit `groesse`.
- Figur-Raum: x = rechte Körperseite der Figur, y = oben, z = vorne (Blickrichtung). Winkel in Grad.
- Knochen und Ursprünge (Elternknochen → Versatz): becken (Boden +0,95) → rumpf (+0,06) → kopf (+0,56);
  rumpf → schulterL/R (∓0,19 | +0,46) → ellbogenL/R (−0,28) → handL/R (−0,25);
  becken → huefteL/R (∓0,095 | −0,02) → knieL/R (−0,45) → fussL/R (−0,44). L = linke Körperseite (x negativ).
- Kopf-Ellipsoid: Mitte (0 | 0,11 | 0,005), Halbachsen (0,098 | 0,118 | 0,105) – Haare liegen knapp darüber
  (Halbachsen 3–15 mm größer, Mitte leicht nach hinten/oben), Gesicht (z > 0,08, y 0,05–0,16) bleibt frei.

## Teil (JSON, Datei `data/figuren/teile_<gruppe>.json` = `{"version":1,"teile":[…]}`)
```json
{"id":"frisur-bob","art":"frisur","koerper":[
  {"form":"ellipsoid","knochen":"kopf","mitte":[0,0.13,-0.01],"groesse":[0.11,0.11,0.115],"material":"haar"},
  {"form":"quader","knochen":"kopf","mitte":[0,0.03,-0.03],"groesse":[0.11,0.06,0.08],"dreh":[0,0,0],"material":"haar"}
 ],
 "umleitung":{"unterarm":"haut"}}
```
- `form`: `ellipsoid` | `quader` | `zylinder` (Achse y). `groesse` = Halbachsen. `dreh` optional (Grad x, y, z).
- `art`: `frisur` | `gesicht` | `oberteil` | `unterteil` | `schuhe` | `kopf` | `zubehoer`.
- `material`: Name; die Figurenkarte ordnet Namen Rampe/Stufe zu. Bekannte Namen: haut, haar, bart, oberteil,
  darunter, weste, aermel, unterarm, hose, unterbein, strumpf, schuhe, akzent, kopfbedeckung, schal, tasche,
  sowie feste: brille, papier, laterne, handy, metall. Fehlende Namen fallen zurück (`kMaterialErsatz`).
- `umleitung`: ersetzt Materialnamen des Körpers (z. B. kurze Ärmel `unterarm → haut`, Rock `unterbein → strumpf`).

## Figurenkarte (JSON)
```json
{"id":"R03","name":"Merle Hartwig","groesse":1.67,"breite":0.95,"kopf":1.0,
 "materialien":{"haut":[7,5],"haar":[2,5],"oberteil":[5,2],"darunter":[0,7],"hose":[6,3],"schuhe":[2,3]},
 "teile":["frisur-schulterlang","oberteil-strickjacke","schuhe-stiefel","notizbuch"]}
```
- Materialien als `[rampe, stufe]` (Rampen 0 neutral, 1 stein, 2 holz, 3 rot, 4 bernstein, 5 grün, 6 blau, 7 haut).
- Grün (Rampe 5) nur für R03 und R04.

## Prüfung
`dart run bin/figurenprobe.dart <png>` (Aufstellung) und `test/figur_test.dart` (Sprite-Prüfung:
Größe, Palette, Fußpunkt, Kontur, 8 verschiedene Richtungen, Teile gültig).

# Sichtprüfung A-605i/j · Prüfer sichtpruefer_10

- **Blatt:** `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px), 66 Figuren, je Front, Seite, Rücken = 198 Ansichten.
- **Stand:** Schritt 0 ausgeführt (`git merge --ff-only nachtlauf/burgstadt`, fb0ec24 → 505a473).
- **Datenquellen (nur gelesen):** `packages/pixel_engine/data/figuren/rollen.json` (BW, R01–R20), `packages/burgstadt_core/data/stadt/bewohner.json` (B01–B44), `packages/pixel_engine/lib/src/palette.dart`.
- **Karten-Hash (Punkt 12):** `git hash-object packages/pixel_engine/data/figuren/karten.json` = `21297795db6f3766b720740bdf53309b32745621`, Kürzel `21297795db`.
- **Hilfsbilder und Auswertung:** `scratchpad/s10/`. Keine anderen Prüfberichte gelesen.

## 1. Vorgehen

- **Palette:** Alle 61 Farben des Blatts sind exakt Palettenfarben (Index = Rampe·8 + Stufe). Der Blatthintergrund #4B4D55 ist Index 4 (neutral.4).
- **Pixeldichte:** Jede der 198 Ansichten ist ein exakter 2×2-Raster (0 uneinheitliche Blöcke). Alle Figuren haben damit dieselbe Pixeldichte.
- **Sichtung:** 22 Ausschnitte mit je drei Figuren, ×2 vergrößert. Zusätzlich Füße (×8), Köpfe (×6) und Hände/Hüften (×6) für alle 66 Figuren, plus Palettencodes einzelner Bereiche.
- **Spielmaßstab:** Blatt auf 1/3 verkleinert (984 × 501 px, die Figuren sind 36–45 px hoch). Paare im ×3-Zoom betrachtet.
- **Kriterium „verwechselbar“.** Ein Paar wird gezählt, wenn alle drei Punkte zutreffen:
  1. Höhe: |Δ| ≤ 3 Sprite-Pixel (Front, nativ; 1 Sprite-Pixel = 2 Blattpixel).
  2. Aufbau gleich: bei beiden Hose/Jeans sichtbar, oder bei beiden Rock/Kleid mit nackten Beinen.
  3. Farbe in der Körpermitte (mittlere 40 % der Breite): Oberkörper (25–50 % der Höhe) und Unterkörper (58–92 %) jeweils gleiche Rampe, Stufenabstand ≤ 1.

  Kopf, Haar, Hut/Mütze, Bart und Zubehör dürfen sich unterscheiden; sie stehen im Vorschlag. Alles andere ist Grenzfall (Abschnitt 4).

## 2. Regelprüfung (Punkte 5 und 9)

| Regel | Befund | Verstoß |
|---|---|---|
| Grün nur R03 und R04 | Grün (Rampe 5) nur bei R03 (Strickjacke, 204/89/224 Px in Front/Seite/Rücken) und R04 (Fleece, 268/110/268 Px). Bei den übrigen 64 Figuren 0 Px Grün in allen drei Ansichten. | nein |
| Wanderstiefel nur R03 und R04 | R03 und R04 tragen braune Schaftstiefel mit dunkler Sohle (holz.3, Schaft ca. 6 Sprite-Reihen). Keine andere Figur hat braune Schäfte. B02, B09, B18, B21, B24 und B30 tragen blaue Stiefel. Braune Halbschuhe ohne Schaft: R05, R09, R16 (Abschnitt 6). | nein |
| Kleiderfarben Bewohner wie Datensatz | Alle benannten Kleidungsteile der 44 Bewohner sind exakt in der Datensatzfarbe vorhanden. Kleinste Fläche: B33 Schal blau.6 mit 8 Px. Hemden und Umhänge 11–32 Px, Hauptteile 52–261 Px. | nein |
| Kleiderfarben R und BW | Alle nicht als „erfunden“ markierten Teile sind in der Datensatzfarbe vorhanden (exakte Palettenzählung). Haarfarben: Farbfamilie passt überall. Bei R03, R05, R09, R14 und R15 liegt die Datensatzstufe nur auf 2–13 Px (Schattierung). Bei R01, R17 und R20 ist das Haar verdeckt (Mütze, Hut, Kapuze). | nein |
| Keine Gegenstände aus K9 §8 | Hände und Hüften aller 66 Figuren gesichtet: kein Taler, Schlüsselbund, Laken, Stablampe, Kerzenständer oder Zettel. Sichtbar ist nur Datensatz-Zubehör, z. B. B16 Regenschirm, B26 Umhängetasche, B31 Gießkanne, B33 Häkelbeutel, B35 Eimer. B18 hält ein helles Objekt (3 × 4 Px, laut Datensatz Nähkorb), kein flaches Blatt. | nein |
| Gleiche Pixeldichte | 198 von 198 Ansichten im 2×2-Raster. | nein |
| Film-/Spiel-Kopien, Klischees | Keine eindeutige Kopie erkennbar. Grenzfälle in Abschnitt 6 (R17, B21, B29). | nein |
| Grenzen (Punkt 9) | Keine Flaschen, Gläser, Blut, Hörner oder Vampir-/Hexenmerkmale erkennbar. | nein |

## 3. Verwechselbare Paare (9)

Mitte oben / unten = sichtbare Farbe der Körpermitte (Palettenname).

| ID | ID | Warum (Höhe · Mitte oben / unten · Unterschied) | Vorschlag zur Unterscheidung |
|---|---|---|---|
| B07 | B16 | Hoch. H 57/58. Mitte bernstein.4 / bernstein.4 oben, holz.2 / holz.1 unten (Rock). Beide mit nackten Beinen. Unterschied nur am Kopf: B16 grauer Hut und Regenschirm, B07 rote Locken. | B16 Mantel (bernstein.4, im Datensatz) auf neutral.4 (grau) ändern, oder B07 Bluse (bernstein.4, im Datensatz) auf rot.4. |
| B20 | B22 | Hoch. H 61/62. Mitte bernstein.4 / bernstein.3 oben, blau.3 / blau.3 unten (Hosen). Unterschied: B20 blaue Mütze, B22 brauner Hut, grauer Bart, langer Mantel. | B20 Hose (im Datensatz nicht benannt, frei) auf stein.2 (grau) ändern. |
| R06 | R14 | Hoch. H 62/63. Mitte blau.1 / blau.2 oben, holz.4 / holz.3 unten (Hosen). Bei beiden Bart und dunkle Stiefel. Unterschied: R06 rotes Halstuch und Stoppelbart, R14 breitere Statur und Vollbart. | R14 Cordweste (blau.2, rollen.json) auf stein.3 (grau) oder holz.4 ändern. |
| B08 | B27 | Mittel bis hoch. H 58/56. Mitte blau.6 / blau.5 oben, rot.2 / rot.2 unten (identische Hose). Unterschied: B08 Hut und Gehstock, B27 langes schwarzes Haar. | B27 Pullover (blau.5, im Datensatz) auf neutral.5 ändern, oder B08 Hose (rot.2, im Datensatz) auf holz.4. |
| R14 | R20 | Mittel. H 63/60. Mitte blau.2 / blau.3 oben (Westen), holz.3 / holz.2 unten. Unterschied: R14 Vollbart, R20 Zopf, graue Kapuze, oranges Halstuch. | R20 Daunenweste (blau.3, rollen.json) auf neutral.4 (grau) oder rot.3 ändern. |
| B32 | B41 | Mittel. H 59/62. Mitte blau.5 / blau.6 oben und unten, jeweils blaue Schürze. Unterschied: B32 orange Ärmel und schwarzes Haar, B41 braune Bluse und brauner Zopf. | B41 Schürze (blau.6, im Datensatz) auf rot.3 ändern. |
| B03 | B32 | Mittel. H 60/59. Mitte blau.4 / blau.5 oben und unten, jeweils blaue Schürze. Unterschied: B03 heller Kittel und weiße Haube, B32 orange Ärmel und schwarzes Haar. | B32 Schürze (blau.5, im Datensatz) auf neutral.3 (dunkelgrau) ändern. |
| B03 | B40 | Gering bis mittel. H 60/62. Mitte blau.4 / blau.4 oben, blau.4 / blau.3 unten (Schürze bzw. langer blauer Mantel). Unterschied: B03 heller Kittel und weiße Haube, B40 brauner Hut und langer Mantel. | B40 Mantel (blau.4, im Datensatz) auf stein.4 (grau) ändern. |
| R05 | R09 | Gering. H 59/62. Mitte blau.2 / blau.2 oben, blau.3 / blau.2 unten (Jeans bzw. Schürze). Unterschied: R09 weißes Hemd im Oberkörper und rote Haare, R05 blonder Bob und Brille. | R05 Sakko (blau.2, rollen.json) auf neutral.3 (anthrazit) ändern. |

## 4. Grenzfälle (nicht als Paar gezählt)

**Gruppe A: Stufenabstand 2 in der Körpermitte (14 Kandidaten, Regel knapp verfehlt).**

- R01 / R16 (68/65): oben neutral.2 / neutral.4 (R16 Sakko hat Hintergrundfarbe), unten holz.2 / holz.4.
- R05 / R13 (59/58): oben blau.2 / blau.1, unten blau.3 / blau.1.
- R05 / B03 (59/60): oben blau.2 / blau.4, unten blau.3 / blau.4.
- R05 / B40 (59/62): oben blau.2 / blau.4, unten blau.3 / blau.3.
- R06 / R08 (62/59): oben blau.1 / blau.3, unten holz.4 / holz.4.
- R06 / R20 (62/60): oben blau.1 / blau.3, unten holz.4 / holz.2.
- R07 / B10 (64/65): oben holz.3 / holz.4, unten holz.2 / holz.4.
- R08 / R20 (59/60): oben blau.3 / blau.3, unten holz.4 / holz.2.
- R09 / B03 (62/60): oben blau.2 / blau.4, unten blau.2 / blau.4.
- R09 / B40 (62/62): oben blau.2 / blau.4, unten blau.2 / blau.3.
- R16 / B12 (65/65): oben neutral.4 / neutral.6, unten holz.4 / holz.4.
- B03 / B41 (60/62): oben blau.4 / blau.6, unten blau.4 / blau.6.
- B26 / B44 (63/62): oben rot.5 / rot.4, unten holz.4 / holz.2. B26 hat navy Hut.
- B32 / B40 (59/62): oben blau.5 / blau.4, unten blau.5 / blau.3.

**Gruppe B: Farbe oder Aufbau weichen deutlicher ab.**

- B06 / B08: identische Kleidung (Jacke blau.6, Hose rot.2), aber H 68/58 (Δ 10). Größe unterscheidet. Bei einer Umfärbung beachten.
- B28 / B36: Hose rot.2 gleich, H 64/64. Jacke hell (neutral.6) gegen mittelgrau (stein.4). B28 hat gelbe Mütze.
- B01 / B31: Oberteil holz.3 gleich, beide graues Haar. Unterteil hellgrau (Schürze neutral.6) gegen mittelgrau (Rock neutral.4). B31 hat schwarzen Hut.
- B16 / B31: Farben vertauscht (B16 bernstein.4 / holz.2, B31 holz.3 / neutral.4), beide graues Haar mit Hut, H 58/57.
- B13 / B33: gleicher Aufbau (Kleid, Haube, weißer Dutt, nackte Beine), H 57/60. Kleid rot.4 gegen bernstein.4.
- B33 / B38 / B43: weißhaarige Frauen in Kleidern. Farben bernstein.4, blau.3 mit holz.4-Schürze und neutral.3 sind verschieden.
- DET / B36: Mantel stein.4 gleich, H 63/64. DET hat rote Bommelmütze, roten Schal und schwarze Hose, B36 weinrote Hose.
- DET / B35 sowie B15 / B35: steinfarbene Mäntel bzw. Kittel (stein.4 bzw. stein.6). H B15 54 gegen B35 62 (Δ 8).
- B02 / B10 / B14: bernsteinfarbene Hemden und graue Hosen, aber Körpermitte verschieden (blaue Weste, braune Schürze, orange Weste).
- B04 / B42: bernstein-Oberteile (B04 Mantel bernstein.5 bis zum Knie, B42 Jacke bernstein.3), H 67/65.
- R05 / R18, R13 / R18, R08 / B38: blaue oder navy Oberteile, aber Aufbau verschieden (Hose gegen Kleid oder Schürze mit nackten Beinen).
- R02 / R11: beide langes schwarzes Haar, H 57/58. Schwarzer Hoodie gegen navy Jacke, blaue gegen graue Jeans.
- R03 / R04: beide grüne Oberteile und Wanderstiefel (zulässig), H 59/64 (Δ 5). Graue gegen blaue Hose, Haar lang braun gegen kurz blond.
- R12 / R14: Westen-Silhouette, H 66/63. Schwarze gegen braune Hose.

## 5. Abweichungen zum Datensatz (kein Regelverstoß)

- Rote Zubehörteile fehlen im Blatt (0 Px Rot in allen drei Ansichten): R19 (roter Kameragurt quer über der Brust, rollen.json), R13 (rote Granatapfel-Brosche), R11 (rote Rotlicht-Stirnlampe), R08 (rote Marienkäfer-Ohrringe). Bei R19 ist das im Spielmaßstab am ehesten sichtbar.

## 6. Formhinweise (kein Paar, Empfehlung)

- Westen als runde Scheibe auf der Brust: R12, R14, B02, B11, B39. Im Spielmaßstab wirken sie wie Rucksack oder Schild.
- Krone-Anmutung durch gespitzte blonde Haarkanten: B21, B29.
- Helm-Anmutung durch Haarkuppel: R04 (kurz blond), B04 (kurz grau, Blockform).
- R16: Sakko hat exakt Hintergrundfarbe (Index 4). Der Umriss ist auf dem Blatt schwach.
- R05: braune Halbschuhe ohne Schaft (holz.2, 36 Px). Im Spielmaßstab braun wie die Wanderstiefel von R03/R04. Empfehlung: dunkel setzen, Halbschuhfarbe ist frei. R09 (holz.1, 43 Px) und R16 (holz.1, 92 Px) sind so dunkel, dass sie als schwarz gelten.
- Grenzfälle Film-/Klischee: R17 (brauner Lederhut mit Feder, rostbraune Jacke) hat eine Abenteurer-Anmutung. Der Datensatz verlangt den Hut, bitte gegenlesen. B21 und B29 siehe Krone-Anmutung.

## 7. Gesamturteil

- **Regelverstöße: 0** (Abschnitt 2).
- **Verwechselbare Paare: 9** (Abschnitt 3). Grenzfälle sind getrennt in Abschnitt 4 aufgeführt.
- **Abnahme: nein.** Nacharbeit an den 9 Paaren. Benannte Farben sind in bewohner.json bzw. rollen.json zu ändern, nicht im Blatt. Ungenannte Teile (z. B. die Hose von B20) können direkt im Blatt geändert werden. Danach die Sichtprüfung wiederholen.
- Die Zählung hängt an der Schwelle „Stufenabstand ≤ 1“. Bei Stufenabstand 2 kämen 14 Kandidaten hinzu (Abschnitt 4, Gruppe A).

ERGEBNIS · Paare: 9 · Verstöße: 0 · Karten 21297795db

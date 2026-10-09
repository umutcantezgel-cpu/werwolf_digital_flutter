# Sichtprüfung A-605q · sichtpruefer_19

**Auftrag:** A-605q (Sichtprüfung der Figuren-Aufstellung, 66 Figuren, BW, DET, R01–R20, B01–B44)
**Bild:** `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px, je Figur Front, Seite, Rücken)
**Schritt 0:** `git merge --ff-only nachtlauf/burgstadt` im Worktree, Fast-Forward fb0ec24..6f0d724.
**Kartenstand:** `git hash-object packages/pixel_engine/data/figuren/karten.json` = `fc94af9295464e10208481e8343829b095889742` (Kennung: `fc94af9295`).
**Gelesen:** Auftrag, Bild, `packages/pixel_engine/data/figuren/rollen.json`, `packages/burgstadt_core/data/stadt/bewohner.json`, `packages/pixel_engine/lib/src/palette.dart`. Keine anderen Prüfberichte, nichts in `nachtlauf/auftraege/A-605/` durchsucht. Kein Commit, kein Push, kein Build.

## 1. Vorgehen und Maßstab

- **Anordnung:** 8 Zeilen à 9 Dreiergruppen, die letzte Zeile hat 3. Die Beschriftungen (BW, DET, R01 ...) wurden vergrößert bestätigt; die Zuordnung stimmt mit den Datensätzen überein (Haarfarbe, Kopfbedeckung, Kleiderfarben jeder Figur).
- **Vermessung (Bildpixel):** Höhe Kopf bis Fuß in der Front 104–136 px, Breite 18–50 px. Alle 198 Ansichten (66 × 3) haben dasselbe Pixelraster von 2 px, also dieselbe Pixeldichte.
- **Farben:** Alle Bildpixel sind exakte Palettenfarben (Anteil 1,0). Oberteil = Brust-/Armbereich, Unterteil = Bein-, Rock- oder Schürzenbereich, Haut ausgenommen. Die Farben wurden gegen die Datensätze abgeglichen.
- **Maßstab (meine Auslegung, offen gelegt):** "Gleiche Größe" = |Δ Höhe| ≤ 7 px (die Regel nennt 8 px als Unterschied). "Gleiche Statur" = Breitendifferenz < 8 px. "Gleiche Hauptfarbe" = gleiche Palettenrampe mit Stufenabstand ≤ 2. Kopf (Frisur, Kopfbedeckung) und Kleidungsform (Hose gegen Rock, lang gegen kurz, nackte Beine) müssen gleich wirken.
- **Geprüft:** 15 Paare mit gleicher Oberteil- und Unterteilfarbe und |Δ Höhe| ≤ 7 px, dazu 28 Paare mit gleicher Farbfamilie (Stufe egal) und |Δ Höhe| ≤ 7 px. Dazu weitere Nahpaare nach Augenschein.

## 2. Verwechslungspaare

| ID | ID | Warum | Vorschlag zur Unterscheidung |
|---|---|---|---|
| – | – | keine | – |

Keines der geprüften Paare erfüllt alle Kriterien. Die nächsten Fälle stehen in Abschnitt 3 (Grenzfälle, nicht als Paar gezählt) und Abschnitt 4 (geprüft, unterscheidbar).

## 3. Grenzfälle (nicht als Paar gezählt)

| Nr. | Paar | Höhe (px) | Gleich | Abweichung (klein) | Vorschlag |
|---|---|---|---|---|---|
| G1 | B38 / B41 | 116 / 108 (Δ 8) | blaues Oberteil, goldene Schürze, Frauen | Größe genau an der Schwelle von 8 px. Zusätzlich nackte Beine (B38) gegen Hose (B41). | B41 um 1–2 Sprite-Pixel kleiner (Größe ist für Bewohner nicht vorgegeben), damit der Abstand sicher über 8 px liegt. |
| G2 | B06 / B36 | 126 / 120 (Δ 6) | Jacke bernstein/4, Hose rot/2, gleiche Silhouette | Einziger Kopfunterschied: blaue Mütze (B06) gegen keine Kopfbedeckung (B36). Breite 44 gegen 36 px (Δ 8). | Mütze von B06 deutlicher gestalten. Schuhe und Bart von B36 (nicht im Datensatz) anders halten. |
| G3 | B06 / B17 | 126 / 126 (Δ 0) | Jacke bernstein/4, blaue Mütze, Beine im Braun-Rot-Bereich | Hose dunkelrot rot/2 (B06) gegen Overall braun holz/3 (B17): nahe Töne, andere Familie. Schuhe blau (B06) gegen grau (B17). Bart braun gegen grau. | B17 um mindestens 8 px kleiner oder schmaler (Statur frei). Schuhe bei B17 dunkel. |
| G4 | B05 / B25 | 126 / 122 (Δ 4) | Oberteil ocker/gold, Rock, nackte Beine, Frauen | Rock dunkelrot rot/2 (B05) gegen braun holz/4 (B25). Kopf: weißer Dutt (B05) gegen braunes Haar (B25, Zopf von vorn nicht sichtbar). | Größe (frei) um mindestens 8 px ändern. Samtbeutel von B25 am Hüftbereich deutlich zeichnen. |
| G5 | R06 / B27 | 122 / 122 (Δ 0) | Hose braun holz/4, gleiche Silhouette | Oberteil sehr dunkles Marineblau blau/1 (R06) gegen Mittelblau blau/4 (B27), Stufe 3. Kopf: kurzes Haar mit Stoppelbart (R06) gegen langes schwarzes Haar (B27). | Größe von R06 (erfunden, frei) um mindestens 8 px ändern. |
| G6 | R06 / R14 | 122 / 120 (Δ 2) | Oberteil navy, Haar kurz mit Bart | Hose braun holz/4 (R06) gegen dunkelrot rot/2 (R14). Ärmel navy (R06) gegen grau (T-Shirt darunter, R14). | Größe von R14 (erfunden, frei) um mindestens 8 px ändern. |
| G7 | R01 / R16 | 134 / 132 (Δ 2) | Hose braun holz/3 bzw. holz/4 | Jacke sehr dunkel neutral/1 (R01) gegen mittelgraues Sakko neutral/4 (R16), Stufe 3. Kopf: graue Strickmütze (R01) gegen keine Kopfbedeckung (R16). | Mütze von R01 in heller Farbe oder mit Kontrast (Kopfbedeckungsfarbe frei). Größe von R16 (erfunden) um mindestens 8 px ändern. |

## 4. Geprüfte Nahpaare, unterscheidbar

| Paar | Δ Höhe (px) | Entscheidender Unterschied |
|---|---|---|
| BW / B16 | 0 | BW Weste und Hose, B16 langer Mantel und Rock. B16 mit Hut, BW mit weißem Haar und Brille. |
| R10 / B22 | 6 | R10 Latzhose und Pixie-Haar, B22 langer goldener Mantel und blauer Hut. |
| R20 / B27 | 2 | Ärmel grau (R20, Kapuzenpulli) gegen blau (B27). Kapuze gegen langes Haar. Breite 32 gegen 40 px. |
| B01 / B29 | 6 | Ärmel braun (B01 Kleid) gegen gelb (B29 Jacke). B01 nackte Beine, B29 blaue Hose und blaue Stiefel. |
| B01 / B23 | 2 | Farben vertauscht: B01 Oberteil braun, Unterteil grau. B23 Oberteil grau, Unterteil braun. |
| B02 / B42 | 2 | Ärmel gelb (B02) gegen hellblau (B42). B02 blaue Mütze, B42 ohne Kopfbedeckung. |
| B03 / B32 | 0 | Ärmel grau (B03 Kittel) gegen gelb (B32 Hemd). B03 Haube mit Zöpfen, B32 schwarzes Kurzhaar. |
| B05 / B06 | 0 | B05 Rock mit nackten Beinen gegen B06 Hose mit blauen Stiefeln. B05 weißer Dutt gegen B06 blaue Mütze. |
| B05 / B36 | 6 | B05 Rock mit nackten Beinen gegen B36 Hose. Dutt gegen kurzes Haar mit Bart. |
| B12 / B36 | 4 | Hose grau (B12) gegen dunkelrot (B36). B36 mit Bart. |
| B19 / B38 | 4 | Ärmel golden (B19 Kleid) gegen blau (B38 Kleid). B38 mit Haube und weißem Dutt. |
| B19 / B40 | 4 | Breite 40 gegen 28 px. B19 Kleid, B40 Hose mit Stiefeln und Hut. |
| B21 / B27 | 2 | B21 Rock mit nackten Beinen und blauen Stiefeln, B27 Hose. Locken gegen langes Haar. |
| B24 / B34 | 0 | B24 langer Mantel gegen B34 kurze Jacke. B24 schwarze Hose gegen B34 braune Hose. |
| B24 / B37 | 4 | Blaue Mütze (B24) gegen graues Langhaar (B37). Hellblau (B24) gegen Mittelblau (B37). |
| B33 / B43 | 6 | Oberteil grau (B33 Kleid) gegen dunkelrot (B43 Kleid mit goldenem Umhang). |
| B33 / B38 | 2 | Ärmel grau (B33) gegen blau (B38). B33 blauer Schal, B38 goldene Schürze. |
| B38 / B40 | 0 | B38 Kleid mit Schürze und nackten Beinen, B40 Mantel, Hose und Stiefel. Haube gegen Hut. Breite 36 gegen 28 px. |
| R13 / R18 | 2 | R13 Hosenanzug, R18 Kleid mit nackten Beinen. Pferdeschwanz gegen schulterlanges Lockenhaar. |
| R15 / B07 | 4 | R15 Hose, B07 Rock mit nackten Beinen. |
| R15 / B39 | 6 | R15 langes Haar, B39 blaue Mütze und Bart. B39 gelbe Ärmel. |
| R02 / B26 | 6 | Oberteil schwarz (R02) gegen hellgrau (B26). R02 Langhaar mit Kopfhörern, B26 Hut und Bart. |
| R06 / R20 | 2 | R20 Kapuze, R06 kurzes Haar mit Bart. Ärmel navy (R06) gegen grau (R20). |
| R06 / B21 | 2 | R06 Hose, B21 Rock mit nackten Beinen. |
| R09 / B03, R09 / B32 | 2 | Schürze dunkel (R09, Stufe 2) gegen hell (B03, B32, Stufe 6). Kopf verschieden. |
| B17 / B25 | 4 | B17 Overall gegen B25 Rock. Blaue Mütze (B17) gegen Zopf (B25). |

## 5. Regelprüfung

**Verstöße: keine.**

- **Grün** (Palettenrampe 5, Indizes 40–47): kommt nur bei R03 (Strickjacke) und R04 (Fleece) vor. Kein anderes Figurpixel in Front, Seite oder Rücken.
- **Wanderstiefel** (braune Schaftstiefel mit dicker Sohle): nur R03 und R04, Schaft und Farbe holz/3 sichtbar. Braune Füße bei R05, R09 und R16 sind Halbschuhe ohne Schaft (Datensatz). Blaue Schaftstiefel (B06, B21, B29, B40) sind nicht braun. Siehe H1.
- **Kleiderfarben der Bewohner wie im Datensatz:** Alle benannten Kleidungsfarben von B01–B44 und BW, R01–R20 erscheinen im Bild in der Datensatzfarbe (Palettenrampe und Stufe). Nicht sichtbar oder nur am Kragen sichtbar: R01, R02, R06, R07, R08, R17 (T-Shirt unter Jacke verdeckt), R16, R19 (Hemd verdeckt), R05 und R13 (Bluse nur am Kragen), B33 (Schal klein). Das ist kein Verstoß.
- **Gegenstände aus K9 §8** (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): nicht erkennbar. Hand- und Hüftbereich aller 66 Figuren vergrößert geprüft. Sichtbar, aber nicht verboten: Arzttasche (B09), Zollstock (B10), Glasschneider (B12), Gehstock (B08), Regenschirm (B16), Nähkorb (B18), Notenmappe (B19), Samtbeutel (B25), Umhängetasche (B26), Gießkanne (B31), Häkelbeutel (B33), Eimer (B35), Maßband (B38), Strickzeug (B13), Kamera-Gurt (R19), Notizbuch (R03).
- **Film- und Spielkopien, Klischees:** keine erkennbar. Keine Vampir-, Hexen-, Teufels- oder Walpurgis-Motive. Keine Gruppenklischees (Hautton und Haartracht sind nicht als Motiv gesetzt).
- **Blut, Alkohol, Drogen:** nichts sichtbar. Keine Flaschen, Gläser oder Zigaretten. Keine roten Stellen am Kopf von BW.
- **DET:** steinfarbener Mantel (stein/4), rote Bommelmütze, roter Schal. Entspricht der Vorgabe.
- **Pixeldichte:** alle 198 Ansichten im gleichen 2-px-Raster.

## 6. Hinweise (kein Verstoß)

- **H1:** R05, R09, R16 tragen braune Halbschuhe (holz/1–2) mit dunkler Sohle. Im Maßstab 1/3 können sie wie Wanderstiefel wirken. Der Schaft fehlt, der Datensatz nennt Halbschuhe.
- **H2:** R03 hält in der linken Hand einen hellen Gegenstand. Laut Datensatz ist es ein Notizbuch. Nicht als Zettel gewertet.
- **H3:** R12 hat auf Brust und Rücken eine große runde dunkle Fläche (Steppweste). Von hinten wirkt sie wie ein Rucksack. Im Datensatz ist kein Rucksack genannt.
- **H4:** R17 hat zwei blaue Flächen am Bauch vorn, die nicht im Datensatz stehen. Hinten sind sie nicht vorhanden.
- **H5:** R20 hat das Haar unter der grauen Kapuze verborgen. Der Datensatz nennt hellbraunes Haar, das nur an der Stirn sichtbar ist. Wegen der Kapuze kein Verstoß.
- **H6:** Im Datensatz genannt, aber nicht gezeichnet: B15 (Laterne), B17 (Kehrbesen), B40 (Schaufel), R11 (Rotlicht-Stirnlampe, nur als Merkmal). Kein Verstoß.
- **H7:** B19 hat am Hüftbereich eine blaue Notenmappe. Eine Mappe ist kein Zettel.

## 7. Gesamturteil

- Verwechslungspaare: 0. Regelverstöße: 0.
- Grenzfälle G1–G7 zählen nicht als Paar. Eine Nachbesserung ist optional: Größe der frei gesetzten Figuren um mindestens 8 px ändern, Mütze deutlicher zeichnen.
- **Abnahme: ja.**

ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten fc94af9295

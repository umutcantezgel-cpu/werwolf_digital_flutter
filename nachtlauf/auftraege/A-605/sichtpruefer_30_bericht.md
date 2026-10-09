# Sichtprüfung A-605ab · sichtpruefer_30

Auftrag: A-605ab, Sichtprüfung der Figuren-Aufstellung nach festem Maßstab.
Gegenstand: `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px, 66 Figuren mit Front, Seite und Rücken).
Stand: `git merge --ff-only nachtlauf/burgstadt` ausgeführt, Worktree auf a56f8c8. Kein Commit, kein Push, kein Build. Datenquellen nur gelesen. Keine anderen Prüfberichte gelesen.

## 1. Vorgehen

- Bild in 66 Figuren mal 3 Ansichten zerlegt (198 Ausschnitte). Zuordnung über die Beschriftungen unter den Seitenansichten. Reihenfolge: BW, DET, R01 bis R20, B01 bis B44.
- Maße: alle Höhen (106 bis 136 px) und Breiten gerade. Farbläufe: 0 ungerade von 56 028. Einheitliches 2-px-Raster, gleiche Pixeldichte.
- Sichtung in 2-facher Vergrößerung (22 Ausschnitte) und in 2,5-facher Vergrößerung für Kopf, Bart, Schuhe, Schürzen und Kleinzubehör (36 Figuren, ergänzt durch Farbprofile).
- Paarprüfung nach Maßstab 5a: alle Figuren gegen alle über Höhe, Kopf, Kleidungsform und Farbfamilie gesiebt. Verbliebene Kandidaten einzeln im Ausschnitt geprüft.
- Farbabgleich: alle gelisteten Kleidungsstücke aus `rollen.json` (ohne „erfunden“) und `bewohner.json` gegen Palette v2 (`palette.dart`). Rampe exakt, Stufe bis ±2.

## 2. Verwechselbare Paare

Keine. Kein Paar erfüllt alle Kriterien des Maßstabs 5a. Die engsten Kandidaten stehen in Abschnitt 3. Sie unterscheiden sich in mindestens einem Punkt, der nach 5a sicher trennt (deutlicher Kopfunterschied, Größe ab 8 px, große Farbfläche in anderer Familie im Oberteil oder in der Hose/im Rock).

| ID | ID | warum | Vorschlag |
|---|---|---|---|
| – | – | keine Paare nach Maßstab 5a | – |

Falls Schürzen- und Mantelflächen nicht als Hauptfläche gewertet werden, zählen G1, G2, G3 und G7 als Paare. Diese Entscheidung liegt beim Kanon.

## 3. Grenzfälle (zählen nicht als Paar)

| Nr | Paar | Größe (px) | Gleich | Entscheidender Unterschied | Vorschlag |
|---|---|---|---|---|---|
| G1 | B10 / B15 | 122 / 124 | braunes Kurzhaar, keine Kopfbedeckung, blaues Oberteil, dunkle Hose | B10 vorne helle graue Schürze (gelistet, neutral 6). B15 blauer Kittel bis zum Oberschenkel | Schürzenfarbe von B10 in andere Familie (z. B. holz). Datensatzentscheidung |
| G2 | B36 / B41 | 128 / 126 | braunes Kurzhaar, keine Kopfbedeckung, blaue Jeans, warme Rottöne im Oberkörper | B41 graues Hemd an den Armen und lange orangefarbene Schürze (rot 5). B36 rostrote Jacke (rot 4) | Schürze von B41 in holz oder blau. Datensatzentscheidung |
| G3 | B22 / B40 | 128 / 130 | Hut, langer gegürteter Mantel, graue Hose | Mantel bernstein (B22) gegen holz (B40). Zylinder (B22) gegen niedrigen Hut (B40) | Mantelfarbe einer der beiden in andere Familie. Datensatzentscheidung |
| G4 | B14 / B20 | 128 / 128 | blaue Mütze, bernsteinfarbenes Hemd, roter Oberkörper, graues Haar | Nur die Hose: navy (B14) gegen mittelgrau (B20). Beide Hosen sind nicht gelistet | Hose von B20 auf holz oder neutral setzen (frei) |
| G5 | R06 / R20 | 120 / 116 | blaues Oberteil, braune Hose (beide frei), schlank | R06 schwarzes Kurzhaar. R20 hellbraunes Zopf und oranger Schal (R06 dunkelroter Schal) | Hose von R20 auf neutral setzen (frei) |
| G6 | R08 / R20 | 110 / 116 | gleiche Oberteilfarbe (blau 3), braune Hose (frei), schlank | R08 dunkler Dutt. R20 hellbraunes Zopf und oranger Schal. Größe 6 px | Hose von R08 auf neutral oder blau setzen (frei) |
| G7 | B09 / B25 | 110 / 114 | gleiches Oberteil (bernstein 5), braunes Haar | B09 braunes Overall (Hose). B25 brauner Rock mit nackten Beinen. Dutt gegen Zopf | Rockfarbe von B25 ändern oder Beine verdecken. Datensatzentscheidung |
| G8 | B04 / B44 | 126 / 122 | graues Kurzhaar, keine Kopfbedeckung, braune Hose | B04 langer bernsteinfarbener Mantel. B44 rote Weste mit bernsteinfarbenen Ärmeln (ungelistetes Hemd) | Mantel von B04 kürzen oder Weste von B44 ändern. Datensatzentscheidung |

Nahe, aber eindeutig unterscheidbar:
- B02 / B14: Mütze gleich, Weste blau gegen rot.
- B17 / B20: Mütze, Oberteil gelb gegen rot.
- B06 / B35: Größe 134 gleich. Mütze und Glatze gegen kurzes Haar, Jacke gegen Kittel.
- B12 / B32: Oberteil bernstein gegen rot, Haar braun gegen schwarz.
- B05 / B23: Größe 114 gleich. Oberteil braun gegen grau, Locken gegen kurz.
- B21 / B23: Rock dunkelgrau gegen blau.
- B13 / B43: Kleid grau gegen rot.
- R17 / B44: Größe 128 gegen 122. Hut gegen keinen.
- B26 / B41: Hut gegen keinen.
- B36 / B14: Größe 128 gleich. Mütze gegen keine.
- R15 / B07: Hose gegen Rock, Haarfarbe verschieden.
- R12 / B24: Weste gegen Mantel, Kopf verschieden.
- R11 / R13: Größe 106 gegen 112. Hose hellgrau gegen navy.

## 4. Regelverstöße

1. **R19** (Punkt 16, Bartabgleich). Das Bild zeigt einen hellbraunen Kinnbart (Goatee). Das Farbprofil im Kinnbereich liegt im Holzbereich (holz 07 bis 13), also in der Haarfarbe. `rollen.json` nennt `bart: "kurz"`. Das Merkmal dagegen „Kinnbart (Goatee)“. Die Bartart stimmt damit nicht mit dem Datenfeld überein. Vorschlag: `bart` auf „kinnbart“ setzen oder das Bild auf „kurz“ umstellen (Datensatzentscheidung).

Anzahl Verstöße: 1.

Geprüft ohne Befund:
- **Grün nur R03 und R04:** Grün kommt nur im Oberteil von R03 (Strickjacke) und R04 (Pullover) vor. Keine weitere grüne Kleidung oder grünes Zubehör.
- **Wanderstiefel nur R03 und R04:** Braune Schaftstiefel mit dicker grauer Sohle nur bei R03 und R04 (Schuhprofil: brauner Schaft etwa 12 px über 4 px grauer Sohle). Braune Halbschuhe ohne Schaft (R05, R09, R16) haben keine dicke Sohle und sind im Datensatz als Halbschuh geführt. Alle anderen Schuhe sind schwarz, dunkelrot oder blau (z. B. B02, B04 blau; B22, B30, B38, B42 dunkelrot).
- **K9 §8:** Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer und Zettel nicht erkennbar. Sichtbare Gegenstände sind nicht verboten: Gießkanne (B31), Nähkorb (B18), Eimer (B35), Gehstock (B08), Regenschirm (B16), Arzttasche (B09), Samtbeutel (B25), Häkelbeutel (B33), Kameragurt (R19).
- **Kleiderfarben (gelistete Teile):** Automatischer Abgleich für alle 66 Figuren bestanden. Zwei Randfälle mit weniger als 1,5 % Fläche und passendem Farbton: R02 (weiße Turnschuhe, Bild hellgrau bis weiß) und B33 (grauer Schal). Kein Verstoß.
- **Ungelistete Unterhemden und Blusen** (z. B. B11, B31, B39, B44) sind im Datensatz frei (Regel 5), kein Verstoß.
- **Film- und Spiel-Kopien, Klischees:** keine erkennbar (kein Vampir, keine Hexe, kein Teufel, kein Walpurgis, keine ethnischen Klischees).
- **Pixeldichte:** einheitliches 2-px-Raster (Abschnitt 1).
- **Geschlechtertausch** (B12, B15, B32, B35, B39, B41): im Bild nicht prüfbar, kein Befund.

## 5. Punkt 16 im Einzelnen

Haar, Frisur und Bart der Rollen gegen `rollen.json`:
- **BW:** weißes Kurzhaar, kurzer weißer Bart, Brille auf der Stirn. Passt.
- **R01:** graue Strickmütze, braunes Haar darunter, kurzer brauner Bart. Passt.
- **R02:** schwarzes lockiges Langhaar, kein Bart. Passt.
- **R03:** braunes schulterlanges Haar mit Spange, kein Bart. Passt.
- **R04:** blondes Kurzhaar, kein Bart. Passt.
- **R05:** blonder Bob, Brille, kein Bart. Passt.
- **R06:** schwarzes Kurzhaar. Der Dreitagebart erscheint nur als dunkler Hautschatten an Kinn und Wange (hau 01 bis 03), kein schwarzer Vollbart. Passt (E57).
- **R07:** braune Locken, Farbton heller (E54). Passt.
- **R08:** dunkler Dutt. Passt.
- **R09:** rotbraunes Kurzhaar. Passt.
- **R10:** blonder Pixie. Passt.
- **R11:** langes schwarzes Haar. Passt.
- **R12:** blond-bernsteinfarbenes Kurzhaar (heller, E54), kein Bart. Passt.
- **R13:** schwarzer Pferdeschwanz. Passt.
- **R14:** braunes Kurzhaar (dunkler, E54) und voller brauner Bart. Passt.
- **R15:** braunes welliges Langhaar. Passt.
- **R16:** dunkles Haar nach hinten gekämmt, grauer kurzer Bart. Passt.
- **R17:** brauner Lederhut mit blauem Band, dunkler kurzer Bart, Haar unter dem Hut (dunkler, E54). Passt.
- **R18:** dunkles schulterlanges Haar. Passt.
- **R19:** hellbraunes Kurzhaar (heller, E54). Bart: Kinnbart, siehe Verstoß 1.
- **R20:** hellbraunes Zopf, keine Kapuze. Passt.

Dutt, Haube und Glatze nicht nur bei Älteren: Dutt sichtbar bei R08 (27 Jahre), B27 (31), B09 (44) und B38 (73). Haube bei B03 (51) und B13 (88). Glatze sichtbar bei B18 (66). B06 (46) trägt darüber eine Mütze. Passt.

Hut und langer Mantel: B22 und B40 (G3) sind die einzige Hut-Mantel-Kombination, die nah beieinander liegt. Unterscheidbar an Mantelfarbe und Hutform. B16 (blauer Hut, grauer Mantel, brauner Rock) und DET (rote Bommelmütze, grauer Mantel, dunkle Hose) sind eindeutig unterscheidbar. Ebenso B24 (dunkelblaue Mütze, Bart, hellblauer Mantel) und B37 (langes graues Haar, orangeroter Mantel).

## 6. Hinweise (kein Verstoß)

- R09 wirkt am unteren Bein wie ein Stiefel, weil Hose und Halbschuh beide braun sind. Der Schuh hat keinen Schaft und keine abgesetzte dicke Sohle. Kein Wanderstiefel, aber ein mögliches Verwechslungsrisiko mit R03 und R04.
- R05 und R16: braune Halbschuhe, datenkonform.

## 7. Gesamturteil

Abnahme: **nein**.

Begründung: 1 Verstoß (R19, Bartart). Keine Paare, 8 Grenzfälle (Abschnitt 3). Nach Korrektur des Bartfelds oder des Bildes bei R19 wäre das Urteil ja, sofern die Grenzfälle nicht als Paare gewertet werden.

Figurenstand 2f77614620
ERGEBNIS · Paare: 0 · Verstöße: 1 · Karten 850245deb6

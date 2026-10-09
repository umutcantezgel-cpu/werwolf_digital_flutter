# Sichtprüfung Figuren-Aufstellung A-605k/l · sichtpruefer_12

- Auftrag: nachtlauf/auftraege/A-605k.md
- Prüfer-ID: sichtpruefer_12
- Stand: Worktree nach Schritt 0 (`git merge --ff-only nachtlauf/burgstadt`, HEAD e8519a5)
- Prüfgegenstand: nachtlauf/bilder/phase3/figuren_aufstellung.png (2952 × 1504 px), 66 Figuren (BW, DET, R01–R20, B01–B44)
- Karten-Hash: `git hash-object packages/pixel_engine/data/figuren/karten.json` = c44e0c18987c7030f24a891c70ef2b398729315e
- Keine Commits, kein Push, kein Build, kein Testbefehl (Sichtprüfung).

## 1. Verfahren

- **Zerlegung:** Die Aufstellung hat 8 Zeilen (7 × 9 Gruppen, 1 × 3 Gruppen). Jede Gruppe zeigt Front, Seite und Rücken; die Beschriftung steht unter der Seitenansicht. Die Zuordnung der IDs ist über die Kleiderfarben geprüft: Für alle 44 Bewohner stehen die Datensatzfarben exakt im Bild, auch in der Schlussreihe B42 bis B44. R10 ist im Pixelfont schwer lesbar und über die Reihenfolge und die Kleidung bestätigt.
- **Spielmaßstab:** Die Aufstellung wurde auf 1/3 verkleinert (Box-Filter, 984 × 501 px) und zum Lesen mit ×4 dargestellt. Die Entscheidungen fallen in dieser Ansicht. Details wurden in 2×- und 4×-Ausschnitten am Original geprüft.
- **Maße** in Pixeln der Aufstellung (Originalauflösung): Höhe = Vorderansicht von Oberkante bis Sohle. Breite = Vorderansicht inklusive Arme und Handgegenstände. Nach 5a gilt ein Höhenunterschied von mindestens 8 px als unterscheidbar; dieselbe Schwelle setze ich für die Breite (Statur).
- **Farben:** Die Aufstellung nutzt 61 verschiedene Farben, alle in der 64er-Palette (palette.dart). Die Zuordnung erfolgt über Rampe·8+Stufe. Gleiche Hauptfarbe für Oberteil bzw. Hose/Rock heißt: gleiche Farbfamilie und Stufen-Unterschied höchstens 1. Stufen-Unterschied 2, oder sehr dunkle Nachbarfamilien, ergibt einen Grenzfall. Alles andere ist unterscheidbar.
- **Kopf:** Zählt sind der Kopfbedeckungstyp (keine, Mütze, Hut, Haube) und der Frisurtyp (kurz, lang, Zopf, Dutt, Locken, Glatze). Haarfarbe und Bart zählen nicht.
- **Vorfilter:** Alle 2145 Figurenpaare wurden nach Höhe, Breite und Farbsignatur von Oberteil und Unterteil gefiltert. Die verbliebenen Kandidaten wurden einzeln nach Kopf, Kleidungsform und Stufen im Spielmaßstab verglichen.

## 2. Verwechselbare Paare

| ID | ID | warum | Vorschlag zur Unterscheidung |
|---|---|---|---|
| keine | | | |

Kein Paar erfüllt alle Bedingungen aus 5a zugleich (gleiche Silhouette und gleiche Hauptfarben, ohne deutlichen Kopf-, Größen- oder Farbunterschied).

## 3. Grenzfälle (nicht als Paar gezählt)

| ID | ID | Abweichung | warum knapp | Vorschlag (optional) |
|---|---|---|---|---|
| R06 | R08 | Höhe 122/116 (Δ6), Breite 36/32 (Δ4). Oberteil dunkles Blau (R06 Jacke, Stufe 1) gegen mittleres Blau (R08 Pullover, Stufe 3). Unterteil beide braun (Stufe 4 bzw. 3). R06 hat kurzes schwarzes Haar mit Bartstoppel und ein rotes Halstuch, R08 einen Dutt. | Der Stufen-Unterschied im Oberteil beträgt nur 2. Dutt und Halstuch sind die einzigen kleinen Unterscheidungsmerkmale. | Oberteil-Stufe von R08 auf 2 oder 4 setzen, oder den Dutt deutlicher ausformen. |
| BW | B12 | Höhe 120/118 (Δ2), Breite 40/36 (Δ4). BW trägt eine Weste (Stufe 4) über dem Hemd, B12 nur das Hemd (Stufe 6). Unterteil beide braune Hose (Stufe 4). Beide haben kurzes Haar ohne Kopfbedeckung; BW hat weißes Haar und eine Brille auf der Stirn. | Die Weste ist der einzige Silhouetten-Unterschied, dazu ein Stufen-Unterschied von 2 im Oberteil. | Weste von BW um mindestens 3 Stufen abdunkeln oder heller machen. |
| B13 | B43 | Höhe 108/112 (Δ4), Breite 34/36 (Δ2). Kleid B13 dunkles Braun (Stufe 2), Kleid B43 dunkles Rot (Stufe 2). Umhang B13 Bernstein 5, Umhang B43 Bernstein 3. Beide haben einen Dutt und nackte Beine. | Beide Kleider sind sehr dunkel, Braun und Rot liegen nah beieinander, und der Umhang unterscheidet sich nur in der Helligkeit. | Kleid von B43 deutlicher bordeauxrot setzen oder den Umhang von B13 nachschärfen. |
| B13 | B33 | Höhe 108/106 (Δ2), Breite 34/34 (Δ0). Kleid B13 dunkles Braun (Stufe 2), Kleid B33 dunkles Grau (Stufe 3). Umhang B13 Bernstein 5 gegen Schal B33 Blau 4 (klein). Beide haben Dutt, Haube und nackte Beine. | Die Kleider sind sehr dunkel, Braun gegen Grau. Der Umhang trennt beide nur über die Helligkeit. | Umhang von B13 in eine andere Form oder Farbe bringen. |
| R02 | R14 | Höhe 128/120 (Δ8, Grenzwert), Breite 40/40. Oberteil schwarz (R02 Hoodie, Stufe 0) gegen dunkles Marineblau (R14 Weste, Stufe 2). Unterteil beide blau (R02 Jeans Stufe 4, R14 Hose Stufe 3). R02 hat lockiges Haar und helle Sneaker, R14 kurzes Haar mit Vollbart und dunkle Stiefel. | Die Höhe liegt genau am Grenzwert und beide Oberteile sind sehr dunkel. | Größe von R02 oder R14 um mehr als 8 px spreizen. |

## 4. Geprüft und unterscheidbar (Auswahl)

| ID | ID | Δ Höhe/Breite | unterscheidend |
|---|---|---|---|
| R06 | B34 | 4/4 | Oberteil dunkles Blau (Stufe 1) gegen helles Blau (B34 Jacke, Stufe 6, Unterschied 5). B34 hat keine erkennbare Mütze. |
| R14 | B42 | 4/0 | Oberteil dunkle Weste (Stufe 2) gegen helle Jacke (Stufe 6). Hose blau gegen schwarze Hose mit dunkelblauen Stiefeln. |
| R15 | B36 | 2/4 | Hose dunkelblaue Jeans (R15, Stufe 1) gegen graue Hose (B36, Stufe 4) mit dunkelblauen Stiefeln. R15 hat langes Haar, B36 kurzes. |
| R17 | B40 | 2/4 | Oberkörper gleiche Farbe (Rost, Stufe 4) und gleicher Hut-Typ. Unterschied: Jacke bis zur Hüfte (R17) gegen Mantel bis zum Knie (B40). Bart gegen Glatze. |
| R20 | B27 | 6/0 | R20 hat ein orangefarbenes Halstuch, grauen Kapuzenpulli über blauer Weste und einen Zopf. B27 trägt einen einfarbig hellblauen Pullover und langes schwarzes Haar. |
| B09 | B25 | 6/4 | Gleicher Zopf, ähnliches Amber. B25 hat nackte Beine (Rock), B09 einen Overall bis zum Fuß. |
| B16 | B26 | 4/0 | Rock (B16) gegen Hose mit dunkelblauen Stiefeln (B26). Hut orange gegen dunkelblau. B16 trägt einen Regenschirm. |
| B23 | B42 | 2/0 | B23 hat einen grauen Rock und nackte Beine, B42 eine schwarze Hose mit Stiefeln und einen Bart. |
| B06 | B34 | 8/4 | Gleiche Jacke (Blau, Stufe 6), aber Hose rot (B06) gegen braun (B34). Höhe genau 8 px. |
| DET | B24 | 6/0 | DET hat eine rote Bommelmütze und einen roten Schal. Mantel bei DET steinfarben, bei B24 hell (Stufe 6). |
| B02 | B32 | 2/4 | B02 hat eine blaue Mütze und eine blaue Weste, B32 keinen Hut und eine blaue Schürze. |
| R18 | B15 | 2/8 | Breite 8 px, Grenzwert. R18 hat nackte Beine, B15 dunkle. R18 hat Locken, B15 einen Zopf. |
| B15 | B42 | 8/4 | Höhe 8 px, Grenzwert. B15 trägt einen Kittel bis zum Knie, B42 eine Jacke mit Hose. B15 hat einen Zopf, B42 Bart. |

Weitere Nachbarn mit Δ unter 8 px sind über Kopf, Schürze, Hosenfarbe oder Kleidungsform unterscheidbar: BW/R09 (blaue Schürze), R01/R16 (Mütze), R01/B10 (Mütze, braune gegen schwarze Hose), R06/B38 (Haube, Kleid), R09/R16 (Schürze), R09/B31 (Hut), R13/R18 (Hosenanzug gegen Kleid mit nackten Beinen), B03/B38 (Zopf gegen Dutt, blaue gegen braune Schürze), B04/B29 (graue gegen blaue Hose), B09/B16 (Zopf gegen Hut), B16/B25 (Hut gegen Zopf), B25/B26 (Hut), B11/B41 (roter Rock mit nackten Beinen gegen blaue Jeans), B17/B39 (rote gegen blaue Hose), B18/B30 (Glatze und langer Mantel gegen Haar und kurze Jacke), B26/B30 (Hut, Hose braun gegen schwarz), B29/B41 (graue gegen orange Schürze), B35/B43 (grauer Kittel gegen rotes Kleid), R10/B32 (blaues Shirt gegen amberfarbenes Hemd mit blauer Schürze), B02/B38 (Mütze, Kleid gegen Hose).

Alle übrigen Nachbarn haben in Höhe oder Breite mindestens 8 px Unterschied und sind nach 5a unterscheidbar.

## 5. Regelverstöße

**keine**

Geprüfte Regeln:

- **Grün nur R03 und R04:** erfüllt. Grünpixel (Rampe 5) kommen nur bei R03 (1968 Pixel) und R04 (2768 Pixel) vor.
- **Wanderstiefel nur R03 und R04:** erfüllt. Braune Schaftstiefel mit dicker Sohle sind nur bei R03 und R04 zu sehen. Braune Hosen mit dunklen Schuhen tragen B12, B34, B40, R07, R16 und R17; das sind keine Schaftstiefel. Hohe dunkelblaue Stiefel tragen B05, B24, B26, B29, B36, B41 und B42; sie sind nicht braun.
- **Kleiderfarben der Bewohner wie im Datensatz:** erfüllt. Für alle 44 Bewohner ist jede Kleidungsfarbe aus bewohner.json (aussehen.kleidung) als exakte Palettenfarbe mit mindestens 10 Pixeln in der Figur vertreten. Oberteil- und Unterteilfamilien sind zusätzlich am Bild geprüft. Von 168 Prüfpunkten sind 7 auffällig, alle bei Rollen und alle verdeckte Unterhemden (R01, R06, R07, R08, R17 mit 0 Pixeln; R13 Bluse mit 8 Pixeln; R19 Hemd mit 4 Pixeln). Das ist kein Verstoß.
- **Keine Gegenstände aus K9 §8 sichtbar:** erfüllt. Keine Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer oder Zettel erkennbar. Sichtbare Handgegenstände sind Nähkorb (B18), Gießkanne (B31), Häkelbeutel (B33), Eimer (B35), Strickzeug (B13), Arzttasche (B09), Gehstock (B08) und Regenschirm (B16).
- **Keine Film- oder Spielkopien, keine Klischees:** bei der Sichtung nicht erkennbar.
- **Alle Figuren in derselben Pixeldichte:** erfüllt. Bei allen 66 Figuren ist die häufigste Lauflänge 2 px in beide Richtungen.

## 6. Hinweise ohne Regelbezug (keine Verstöße)

- B13: Der Datensatz nennt weißes Haar und eine Haube. Die Darstellung zeigt rotes Haar und keine erkennbare Haube.
- B34: Der Datensatz nennt eine Mütze. Eine Mütze ist nicht erkennbar (brauner Kopf, gelber Streifen am Hals).
- B15 (Laterne) und B40 (Schaufel): Das Zubehör steht im Datensatz, ist aber in der Aufstellung nicht sichtbar.
- R19: Der rote Kameragurt aus dem Datensatz ist nicht sichtbar. R13: Die rote Brosche ist nicht sichtbar.

## 7. Gesamturteil

**Abnahme ja.**

- Paare: 0. Verstöße: 0.
- Die Grenzfälle R06/R08, BW/B12, B13/B43, B13/B33 und R02/R14 sind knapp, im Spielmaßstab aber unterscheidbar. Sie zählen nicht als Paar. Wenn der Maßstab enger gelesen werden soll, sind die Stufen-Unterschiede bei R06/R08 und BW/B12 die ersten Stellen zum Nachschärfen.

## 8. Hilfsmaterial

Hilfsbilder und Analysedateien liegen in /tmp/claude-0/-home-user-werwolf-digital-flutter/ff661d51-da74-5d9a-bcdc-83630a0036a3/scratchpad/s12/. Sie sind kein Teil der Abnahme. Außer dieser Berichtsdatei wurden keine Dateien geändert.

ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten c44e0c1898

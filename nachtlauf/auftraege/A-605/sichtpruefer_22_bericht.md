# Sichtprüfung A-605t · Figuren-Aufstellung (66 Figuren)

Prüfer: sichtpruefer_22 · Auftrag A-605t (Maßstab A-605s, Z-03) · Worktree nach ff-only-Merge von nachtlauf/burgstadt (229c199)

## 1. Grundlage und Vorgehen

- Bild: nachtlauf/bilder/phase3/figuren_aufstellung.png (2952 × 1504 px), 66 Figuren mit Front, Seite und Rücken, Beschriftung je Gruppe.
- Datenquellen (nur gelesen): packages/pixel_engine/data/figuren/rollen.json (BW, R01–R20), packages/burgstadt_core/data/stadt/bewohner.json (B01–B44), packages/pixel_engine/lib/src/palette.dart.
- Verfahren: Figurengrenzen und Höhen per PIL gemessen (Höhe der Frontansicht in Pixeln der Aufstellung), Silhouettenbreite auf 45 % der Höhe, Farbzonen per exaktem Palettenabgleich (alle Bildpixel liegen exakt auf den 64 Palettenfarben). Alle Figuren in Ausschnitten 2×, Übersichten 4×, Köpfe und Beine 6× bzw. 10×, Seiten- und Rückansichten 3× geprüft.
- Pixeldichte: bei allen 66 Figuren ist die häufigste Lauflänge gleicher Farbe 2 px.
- Farbfamilie = Palettenrampe (neutral, stein, holz, rot, bernstein, grün, blau, haut).

## 2. Verwechselbare Paare

Ergebnis: keine (0 Paare).

Anwendung des Maßstabs 5a: Ein Paar liegt nur vor, wenn Größe (Abweichung unter 8 px), Statur, Kopf (Frisur und Kopfbedeckung), Kleidungsform und die Hauptfarben von Oberteil und Hose/Rock übereinstimmen. Keines der geprüften Kandidatenpaare (Abschnitt 3) erfüllt alle Kriterien; jeweils mindestens ein deutliches Merkmal trennt die Figuren.

| ID | ID | Warum | Vorschlag zur Unterscheidung |
|---|---|---|---|
| – | – | keine Paare nach Maßstab 5a | – |

## 3. Grenzfälle (nicht als Paar gezählt)

Maße: Höhe in px (Front), Statur = Silhouettenbreite bei 45 % der Höhe.

| ID / ID | Gleich | Abweichung, die trennt | Vorschlag |
|---|---|---|---|
| R06 / B27 | Höhe 122/122, Statur 36/40, Hose holz 4, Oberteil blau | R06 kurzes Haar mit Stoppelbart und rotem Halstuch, B27 langes schwarzes Haar | Haarlänge oder Halstuchfarbe deutlicher machen |
| R13 / R18 | Höhe 112/110, Statur 28/32, Oberteil und Rock blau | R13 Hosenanzug mit Pferdeschwanz, R18 Kleid mit nackten Beinen und schulterlangem Haar | Kleidungsform bleibt getrennt; Haar prüfen |
| R13 / B41 | Höhe 112/108, Statur 28/32, Hose blau | B41 hat bernsteinfarbene Schürze auf 35 % der Oberkörperfläche | Schürze trennt; keine Änderung nötig |
| B05 / B25 | Höhe 126/122, Statur 36/36, Oberteil bernstein | Rock dunkelrot (rot 2) gegen braun (holz 4); Haar weißer Dutt gegen braunen Knoten | Rockfarbe einer der beiden deutlicher abstufen |
| B06 / B36 | Höhe 126/120, Jacke bernstein 4, Hose rot 2 identisch | B06 breiter (Gurte, Statur 44 gegen 36) und blaue Mütze gegen Haar | Schultergurte in B06 prüfen |
| B14 / B20 | Höhe 132/128, Statur 36/40, beide blaue Mütze, dunkle Hose | B14 bernsteinfarbene Ärmel mit orangeroter Weste, B20 dunkelrote Jacke mit gelber Krawatte | keine Änderung nötig |
| B02 / B14 | Höhe 128/132, Statur 32/36, beide blaue Mütze, bernsteinfarbene Ärmel | Westenfarbe blau (B02) gegen orangerot (B14), große Farbfläche | keine Änderung nötig |
| B01 / B23 | Höhe 112/114, Statur 32/36 | B01 braunes Kleid mit grauer Schürze, B23 graue Jacke mit Rock; Dutt gegen kurzes Haar | Kleidungsform und Oberteilfarbe trennen |
| B29 / B12 | Höhe 118/116, Statur 36/40, Oberteil gelb, Hose grau | B29 graue Schürze (41 % der Front), blonder Zopf; B12 kurzes braunes Haar | keine Änderung nötig |
| R05 / R10 | Höhe 128/130, Oberteil blau, Hose bernstein | Statur 36 gegen 28 (Δ8); R05 Sakko mit Hose, R10 Latzhose mit Latz | Statur und Latzhose trennen |
| B36 / B44 | Höhe 120/118, Statur 36/36, Oberteil bernstein | B44 orangerote Weste; Hose dunkelrot (B36) gegen dunkelbraun (B44) | keine Änderung nötig |

Grenzwert-Fälle (Höhenunterschied genau 8 px, nach Maßstab unterscheidbar): B04/B18 (134/126), B23/B25 (114/122), B11/B31 (104/112), B22/R17 (136/128), B38/B43 (116/108), B17/B44 (126/118), B09/B44 (110/118).

Gleiche Silhouette, aber deutlicher Kopf- oder Farbunterschied (unterscheidbar): R01/R16 (graue Mütze gegen keine), R02/B26 (Hut), B16/B23 (Hut), B24/B37 (Mütze), B03/B35 (Haube), B24/B34 (Hose schwarz gegen braun bei gleicher Jacke), B42/B37 (Mantel gegen Jacke, Haar), B38/R18 (Haube und Schürze).

## 4. Regelverstöße

Keine (0). Geprüft:

- Grün (Rampe 5): Pixelzählung über Front, Seite und Rücken. Grüne Palettenfarben kommen nur bei R03 und R04 vor. Ockerfarbene Teile (B12, B25, B40, Bernstein 3–4, Farbton ca. 37°) sind kein Grün.
- Wanderstiefel (braune Schaftstiefel mit dicker Sohle): nur R03 und R04 haben solche Stiefel. Blaue Stiefel (B02, B06, B21, B29) sind nicht braun. Braune Halbschuhe bei R05, R09 und R16 sind niedrig und keine Schaftstiefel.
- Kleiderfarben wie im Datensatz: Oberteil- und Hosenfarben aller Figuren stimmen mit Rampe und Stufe des Datensatzes überein, etwa B13 Kleid rot 5, B43 Kleid rot 2, B19 Kleid bernstein 5, B38 Schürze bernstein 4. Nicht benannte Hemden, Blusen und Hosen sind frei (z. B. B11, B36, B37, B39, B44).
- K9 §8 (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): nicht sichtbar. Sichtbare Zubehörteile stehen im Datensatz (z. B. Regenschirm B16, Gehstock B08, Gießkanne B31, Eimer B35, Nähkorb B18, Umhängetasche B26, Kamera R19).
- Leitplanken: kein Alkohol (keine Flasche, kein Krug, kein Glas), keine Verletzung oder Blut, keine Hexe, kein Vampir, kein Teufel, keine erkennbare Film- oder Spielkopie, kein erkennbares Gruppenklischee.
- Pixeldichte: alle 66 Figuren haben 2-px-Blockstruktur.

## 5. Hinweise (kein Verstoß, zur Abwägung)

- Runde Flächen auf dem Oberkörper: Weste oder Mantel als Scheibe bei BW, R12, R14, B02, B24 und B39. Das wirkt wie Bauch oder Rucksack und verändert die Silhouette. Schulter- und Armkontur empfohlen.
- B30 und B41: braune Haarpartie mit Krempenlinie. Der Datensatz nennt kopf: keine. Gelesen als Haar, vergleichbar mit B42. Klärung empfohlen.
- R17: zwei blaue Patten an den Hüften, im Datensatz nicht genannt. Farbe ist frei.
- R11: Rotlicht-Stirnlampe laut Merkmal, im Bild nicht erkennbar.
- R20: Kapuze aufgesetzt, entspricht dem Merkmal.

## 6. Gesamturteil

Abnahme ja (0 Paare, 0 Regelverstöße). Die Hinweise in Abschnitt 5 und die Grenzfälle in Abschnitt 3 sind nicht abnahmerelevant.

## 7. Arbeitsstand

Worktree per ff-only auf nachtlauf/burgstadt (229c199). Geschrieben: nur diese Berichtsdatei (untracked) und Hilfsdateien im Scratchpad. Kein Commit, kein Push, kein Build.

ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten db8e0a6155

# Sichtprüfbericht A-605k/l · sichtpruefer_14

- Auftrag: nachtlauf/auftraege/A-605k.md
- Stand: Worktree nach Schritt 0 (`git merge --ff-only nachtlauf/burgstadt`, HEAD bf22e49)
- Prüfgegenstand: nachtlauf/bilder/phase3/figuren_aufstellung.png (2952 × 1504 px), 66 Figuren, 198 Sprites
- Karten-Hash: `git hash-object packages/pixel_engine/data/figuren/karten.json` = 0e9ec58e3320c3f085bca084fca953c658b619f0
- Nur gelesen zum Abgleich: packages/pixel_engine/data/figuren/rollen.json, packages/burgstadt_core/data/stadt/bewohner.json, packages/pixel_engine/lib/src/palette.dart, nachtlauf/KANON.md (Kanon K9 §8, Grünregel)
- Keine anderen Prüfberichte gelesen. Kein Commit, kein Push, kein Build.

## 1. Vorgehen

- Zuordnung: Die Beschriftungen ergeben acht Reihen zu je neun IDs (letzte Reihe drei): BW, DET, R01–R20, B01–B44. Je ID drei Sprites von links nach rechts: Front, Seite, Rücken.
- Maße in Pixeln der Aufstellung: Höhe = Oberkante bis Sohle des Frontsprites, Breite = Frontsprite. Alle 198 Sprites haben dieselbe Pixelgröße (Modus der Lauflängen = 2 px), also einheitliche Pixeldichte.
- Farben: Jeder Pixel liegt exakt auf der Palette. Ausgewertet als Index = Rampe·8 + Stufe und gegen den Datensatz abgeglichen.
- Sichtprüfung: Dreiergruppen zweifach vergrößert, Vorderansichten dreifach, Beine und Füße, Gegenstände in Händen und an Hüften. Hilfsbilder liegen in scratchpad/s14/.
- Maßstab 5a, operationalisiert: gleiche Silhouette = Höhe Δ ≤ 7 px, gleicher Kopf (Kopfbedeckung ja/nein und Frisurtyp), gleiche Kleidungsform, Breite Δ ≤ 4 px. Gleiche Hauptfarben = gleiche Farbfamilie (Rampe) bei Oberteil und Hose/Rock. Unterscheidbar sind Kopfunterschied, Größe ≥ 8 px oder große Farbfläche in anderer Familie.

## 2. Verwechselbare Paare

| ID | ID | warum | Vorschlag zur Unterscheidung |
|---|---|---|---|
| – | – | keine | – |

Kein Paar erfüllt alle Bedingungen ohne ein unterscheidendes Merkmal. Die engsten Fälle stehen getrennt unter 3.

## 3. Grenzfälle (nicht als Paar gezählt)

| Nr | ID | ID | Höhe (Δ px) | Gleich | Unterschied nach Maßstab | Vorschlag |
|---|---|---|---|---|---|---|
| 1 | B06 | B34 | 134 / 126 (8) | Mützenkopf, Jacke blau/6, Breite 44/40 | Δ genau 8 px (Schwelle, zählt als unterscheidbar); Hose rot/2 gegen holz/3; Mütze blau gegen braun | B34 um 2 px kleiner ansetzen (Größe ist für B-Figuren frei) |
| 2 | R06 | R16 | 122 / 128 (6) | Kurzhaar mit Bart, Hose holz/4, Breite 36/40 | Oberteil marineschwarz (blau/1) gegen dunkelgrau (neutral/4), beide sehr dunkel; roter Halstuch-Akzent bei R06, grauer Bart bei R16 | Hose von R16 (Datensatz: frei) auf eine andere Familie setzen, z. B. blau/3 |
| 3 | B06 | B28 | 134 / 130 (4) | Mützenkopf, Hose rot/2 (beide Datensatz), Breite 44/40 | Jacke hellblau (blau/6) gegen hellgrau (neutral/6), Helligkeit ähnlich; Mütze blau gegen grau | B28 um 4 px kleiner (126); Mützenfarbe ist frei |
| 4 | BW | B12 | 120 / 118 (2) | Kurzhaar ohne Kopfbedeckung, Hose holz/4 (beide Datensatz) | BW trägt Weste warmgrau (stein/4) über hellgrauem Hemd (neutral/6), B12 nur Hemd; BW mit weißem Haar und Bart, B12 mit braunem Haar | B12 auf 112 oder 128 px (Δ ≥ 8) |
| 5 | R17 | B40 | 130 / 128 (2) | Hut, Oberteil rot/4 (beide Datensatz), Hose braun (holz/2 gegen holz/3) | Hutfarbe braun gegen orange; goldener Bart (R17); blauer Gürtel (R17); Mantel (B40) gegen Jacke (R17) | Hutfarbe von B40 (frei) auf eine andere Familie setzen |
| 6 | B13 | B43 | 108 / 112 (4) | Kleid, Umhang, Haube, Dutt, Breite 34/36 | Kleid holz/2 (dunkelbraun) gegen rot/2 (dunkelrot); Umhang bernst/5 (hell) gegen bernst/3 (dunkel) | B43 auf 120 px (Δ ≥ 8) |

Priorität: Grenzfälle 1 bis 3 vor einem Release nachschärfen. Die Größenangaben für B-Figuren sind im Datensatz frei, die Hutfarbe und die Hose von R16 ebenfalls.

## 4. Regelverstöße

Keine.

Geprüfte Regeln:
- Grün (Rampe 5, Index 40–47): nur R03 und R04 enthalten Grün (R03 1968 Pixel, R04 2768 Pixel über alle Ansichten). Alle übrigen 64 Figuren: 0 Pixel.
- Wanderstiefel (braun, Schaft, dicke Sohle): nur R03 und R04 haben braune Stiefel (holz/3, deckungsgleich mit rollen.json). Braune Fußbekleidung bei R05 und R09 sind niedrige Halbschuhe ohne Schaft (Datensatz: halbschuhe). Kurze, sehr dunkle rote Schuhe ohne Schaft bei B01, B16, B21, B22, B23, B25, B28. Blaue Stiefel bei B02, B24, B26, B36, B42, B41. Dunkle Stiefel bei R06, R11, R14, R15. Keine braunen Schaftstiefel außer R03 und R04.
- Kleiderfarben: Alle datensatzgebundenen Farben sind im Bild vorhanden. BW: Weste stein/4, Hemd neutral/6, Cordhose holz/4. R01–R20: festgelegtes Oberteil, Unterteil, Shirt und Schuhe, ohne die im Datensatz als erfunden markierten Teile. B01–B44: jeder Eintrag aus aussehen.kleidung. Keine Abweichung.
- Gegenstände K9 §8 (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): nicht erkennbar. Sichtbar sind unter anderem Gießkanne (B31), Häkelbeutel (B33), Eimer (B35), Gehstock (B08), Regenschirm (B16), Arzttasche (B09), Umhängetasche (B26), Strickzeug (B13), Kameragurt (R19) und Kopfhörer (R02). Zu B18, B10 und B39 siehe 5.
- Pixeldichte: einheitlich, alle 198 Sprites mit 2-px-Pixelblöcken.
- Film-/Spielkopien, Klischees, Alkohol und Drogen, Blut: keine erkennbar.

## 5. Hinweise (keine Verstöße, nicht gezählt)

- B18: flache, silbergraue Schale in einer Hand. Datensatz: Nähkorb. Ein eiserner Kerzenständer ist nicht erkennbar (kein Dorn, keine Kerze, keine dunkle Eisenfarbe), auch kein Taler oder Schlüsselbund. Bitte am Original gegenprüfen.
- B10: langer grauer Stab am Rücken (Datensatz: Zollstock). Kein Leuchtkopf erkennbar, also keine Stablampe.
- B39: kleines rostbraunes Rechteck an der rechten Hüfte (Rückansicht). Kein weißes Papier, daher kein Zettel.
- B13: Haar und Haube im Bild überwiegend orange-braun (Palette bernst/rot/holz, 184 px gegen 12 helle Pixel im Kopfbereich). Datensatz: haar weiß. Abgleichhinweis, kein Kleidungsverstoß.
- DET ist in der Aufstellung als Referenz enthalten. Der Kanon sagt, der Detektiv ist im Spiel nie sichtbar. Für eine Aufstellung zulässig.
- R01: Grundbild ohne Ruß. Ruß steht im Datensatz erst ab 23:52, die Aufstellung zeigt also den Grundzustand.
- Haubenfiguren B03, B13, B33, B38, B43: nur Kopfbedeckung und Kleidung, keine Trachtenmerkmale, kein Gruppenklischee erkennbar.
- R17 (Lederhut mit Federband) wirkt allgemein als Abenteurer. Keine konkrete Film-, Spiel- oder Figurenvorlage erkennbar.

## 6. Gesamturteil

Abnahme ja. Paare: 0. Verstöße: 0. Grenzfälle 1 bis 6 sind dokumentiert und sollten nach Abschnitt 3 nachgeschärft werden, sie sind aber keine Verwechslungspaare im Sinne des Maßstabs.

ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten 0e9ec58e33

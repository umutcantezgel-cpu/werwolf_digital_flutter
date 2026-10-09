# Sichtprüfung A-605s · Figuren-Aufstellung (sichtpruefer_21)

- Auftrag: A-605s/t, Sichtprüfer sichtpruefer_21
- Bild: `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px), 66 Figuren, je Front, Seite, Rücken
- Kartenstand: db8e0a6155 (`git hash-object packages/pixel_engine/data/figuren/karten.json`, nach Schritt 0)
- Schritt 0: `git merge --ff-only nachtlauf/burgstadt` im Worktree (d92a675 → 229c199, Fast-Forward)

## Vorgehen

1. Zerlegung des Bildes in 66 Dreiergruppen (8 Zeilen, Beschriftung in Lesereihenfolge: BW, DET, R01–R20, B01–B44), 198 Ansichten.
2. Sichtprüfung im Maßstab 1/3 (Kontaktbogen, Füße auf gemeinsamer Grundlinie) und 2× mit allen drei Ansichten.
3. Datenabgleich: `rollen.json` (BW, R01–R20), `bewohner.json` (B01–B44, Feld `aussehen`), `palette.dart` (Index = Rampe·8 + Stufe).
4. Bewertung getrennt nach Silhouette (Größe in Pixeln der Aufstellung, Breite als Statur, Kopfbedeckung und Frisur, Kleidungsform, großes Zubehör) und Farbe (Oberteil, Hose/Rock). Gleiche Hauptfarbe: gleiche Rampe, Stufen-Differenz höchstens 2. Gleiche Größe: Höhendifferenz unter 8 px. Gleiche Statur: Breitendifferenz höchstens 4 px. Haarfarbe ist kein Kriterium des Maßstabs.
5. Vorauswahl über Datenmerkmale (Kopfbedeckung, Rampe von Oberteil und Hose/Rock, Größe, Breite), danach visuelle Prüfung der übrigen Kandidaten.

## Verwechselbare Paare

Keine. Nach Maßstab 5a ist kein Paar verwechselbar.

Geprüfte Nahpaare, nicht als Paar gewertet (Größe in px, erstgenannte ID zuerst):

| Paar | Größe (px) | Entscheidender Unterschied |
|---|---|---|
| R13 – R18 | 112 / 110 | R13 Hosenanzug in Blau, R18 Kleid in Blau (blu3) mit nackten Unterschenkeln (Hautton hau3); R13 Pferdeschwanz, R18 Schulterhaar |
| B21 – B27 | 120 / 122 | B21 blaue Stiefel unter braunem Rock (hlz2), B27 braune Hose (hlz4); B21 Locken, B27 lange Haare |
| B01 – B29 | 112 / 118 | B01 braunes Kleid (hlz3) unter grauer Schürze, nackte Beine; B29 gelbe Jacke (bst5) unter grauer Schürze, blaue Hose; Dutt gegen Zopf |
| B05 – B36 | 126 / 120 | B05 Rock mit nackten Beinen, B36 dunkelrote Hose (rot2) |
| B03 – B32 | 122 / 122 | B03 graue Kittel (stn5) und weiße Haube, B32 gelbes Oberteil (bst4) mit kurzem Haar ohne Kopfbedeckung |
| B19 – B38 | 120 / 116 | B38 blaues Kleid (blu5) unter Schürze (bst4), graue Haube; B19 gelbes Kleid (bst5), lange rote Haare |
| B39 – B14 | 126 / 132 | B39 dunkelblaue Hose (blu3), B14 schwarze Hose; Locken gegen Glatze unter Mütze |
| B12 – B44 | 116 / 118 | B44 orangefarbene Weste (rot5) gegen olivgelbes Hemd (bst3); B12 dunkelgraue Hose (stn2), B44 braune Hose (hlz2) |
| B08 – B24 | 132 / 132 | B08 dunkelrote Hose (rot2) gegen B24 schwarze Hose (neu2); B08 Hut, B24 Mütze |
| B09 – B41 | 110 / 108 | B09 braunes Overall (hlz4) mit gelber Jacke, B41 blaue Hose und hellblaue Bluse unter gelber Schürze |
| BW – B23 | 120 / 114 | B23 nackte Beine unter braunem Rock, BW braune Cordhose; BW graue Weste, B23 helle Jacke |
| B26 – R17 | 134 / 128 | Hut und kurzes Haar gleich; B26 graues Oberteil (neu6) gegen R17 rostrote Jacke (rot4), B26 blaue Hose gegen R17 braune Cargohose |

## Grenzfälle (nicht als Paar gezählt)

- **R06 – R20** (122 / 120 px, Breite 36 / 32): gleiche Gesamtsilhouette, gleiche Hauptfarben (Oberteil blu1 / blu3, Hose hlz4 / hlz2). Die Unterschiede liegen nur im Detail: Zopf bei R20 (von vorn kaum sichtbar, im Profil deutlich), Halstuch orange (R20) gegen dunkelrot (R06), helles Hemd am Hals bei R20. Vorschlag: R20 das Zopf-Profil von vorn sichtbar machen oder das Oberteil heller oder anders gefärbt setzen, dann sind beide aus 5–8 m sicher zu trennen.

## Regelverstöße

Keine. Geprüft wurde:

- **Grün (Rampe 5):** Grünpixel nur bei R03 (Strickjacke, grn2, 1968 Pixel) und R04 (Pullover, grn4, 2708 Pixel). Alle übrigen 64 Figuren ohne Grünpixel.
- **Wanderstiefel (braune Schaftstiefel, dicke Sohle):** Braune Schaftstiefel nur bei R03 und R04. Die übrigen Figuren mit braunem Fußbereich haben niedrige Schuhe: R05 (braune Halbschuhe, hlz2), R09 (dunkelbraune Halbschuhe, hlz1, unter brauner Hose), R16 (hlz1), R17 (dunkle Schuhe unter brauner Cargohose), B09, B22, B34, B44 (dunkle Schuhe unter braunen Hosen oder Overall). Geprüft im 4×-Ausschnitt: R09 wirkt auf den ersten Blick wie Stiefel, die Pixelfolge zeigt aber niedrige Schuhe. Kein Verstoß.
- **Kleiderfarben nach Datensatz:** Abgleich aller Figuren mit Kleidungsangaben, keine Abweichung der Rampe erkennbar. Stichproben: B11 braune Weste (hlz2) über heller Bluse, B39 rote Weste (rot4), B44 orangefarbene Weste (rot5), B35 blaue Hose (blu4), R09 blaue Schürze über weißem Shirt. Freie Angaben (Schuhe und Hosen bei B-Figuren, Kopfbedeckungsfarben) nicht bewertet.
- **Gegenstände aus K9 §8** (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): nicht erkennbar. Sichtbare Zubehörteile sind nicht verboten: Gehstock (B08), Regenschirm (B16), Kameragurt (R19), Gießkanne (B31), Eimer (B35), Arzttasche (B09).
- **Leitplanken:** keine Flaschen oder Gläser (kein Alkohol), keine Blutspuren (BW ohne rote Stellen), keine Spitzhüte (Hüte sind breitkrempig: B08, B16, B22, B26, R17), keine Teufels- oder Vampirmerkmale, keine erkennbaren Klischee-Kostüme.
- **Pixeldichte:** alle 66 Figuren im gleichen Pixelraster (je Pixelstufe 2 px, Pixelanalyse aller 198 Ansichten).

## Gesamturteil

**Abnahme ja.** Keine verwechselbaren Paare und keine Regelverstöße nach Maßstab 5a. Der Grenzfall R06 – R20 ist als Hinweis dokumentiert und zählt nicht als Paar.

## Hinweis zum Git-Stand (nicht Teil der Sichtprüfung)

- Im Worktree gibt es nur den ff-only-Merge (d92a675 → 229c199). Keine eigenen Commits, kein Push, kein Build. Dieser Bericht ist eine unversionierte Datei im Worktree.
- Lokal bekannter `origin/main` (ohne neuen Fetch): d92a675. `nachtlauf/burgstadt` (= `origin/nachtlauf/burgstadt`, 229c199) liegt 3 Commits darüber (b1dfbaf, fe4a085, 229c199). Der Stand ist also noch nicht auf main.
- Lokaler `main` (fb0ec24) liegt 13 Commits hinter `origin/main`.

ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten db8e0a6155

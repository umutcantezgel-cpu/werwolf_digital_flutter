# Sichtprüfung A-605m · Figuren-Aufstellung

Prüfer: sichtpruefer_15 · Auftrag A-605m
Bild: `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px, 66 Figuren, je Front, Seite, Rücken)
Stand: Worktree nach `git merge --ff-only nachtlauf/burgstadt` auf HEAD 2e459d4. Kartenstand: `git hash-object packages/pixel_engine/data/figuren/karten.json` = `e4624201afb4d8c38e4f0d4f0b0a49e47dcfbe3f`.

## Vorgehen

- Gesichtet: Gesamtbild auf 1/3 verkleinert (Spielabstand 5 bis 8 m), Ausschnitte mit je 3 Figuren in 2-facher Vergrößerung, Vergleichsmontagen in 4-facher Vergrößerung.
- Messung: Höhe der Frontansicht in Pixeln (Bounding-Box ohne Hintergrund). Alle 493.768 Vordergrundpixel stimmen exakt mit den 64 Palettenfarben aus `packages/pixel_engine/lib/src/palette.dart` überein. Rampe und Stufe jeder Farbfläche sind dadurch eindeutig.
- Paarprüfung nach Abschnitt 5a: Paar = gleiche Gesamtsilhouette und gleiche Hauptfarben (Oberteil, Hose/Rock). Unterscheider: deutlicher Kopfunterschied, Größe mindestens 8 px, große Farbfläche in anderer Farbfamilie. Farbfamilie = Palettenrampe (neutral, stein, holz, rot, bernstein, grün, blau). Helligkeitsstufen innerhalb einer Rampe zählen nicht als Unterschied (siehe Abschnitt 6).
- Alle 66 Figuren wurden nach Höhe, Kopfform, Kleidungsform und Ober-/Unterteil-Familie tabelliert. 75 Kandidatenpaare mit Höhendifferenz unter 8 px und überlappenden Familien wurden einzeln geprüft.

## 1. Verwechselbare Paare

| ID | ID | Warum | Vorschlag zur Unterscheidung |
|---|---|---|---|
| R06 | R08 | Höhe 122 / 116 px (Δ 6). Oberteil dunkelblau (R06 Jacke blau1, R08 Pullover blau3, gleiche Familie). Unterteil braun (R06 holz4, R08 holz3). Statur ähnlich (Breite 36 / 32 px). Kopf ohne Kopfbedeckung: kurzes Haar mit Stoppelbart (R06) gegen Dutt (R08) ist kein deutlicher Kopfunterschied. Das dunkelrote Halstuch von R06 ist nur ein kleiner Akzent. | Oberteil von R08 in eine andere Farbfamilie setzen (z. B. Rampe 4 Bernstein oder Rampe 3 Rot). Alternativ die Höhe um mindestens 8 px trennen (R08 auf 130 px oder R06 auf 114 px). |

## 2. Grenzfälle (nicht als Paar gezählt)

| ID | ID | Abweichung | Hinweis |
|---|---|---|---|
| DET | B24 | Höhe 126 / 120 (Δ 6). Beide tragen einen langen grauen Mantel und eine Mütze. DET: Mantel stein (Rampe 1, Stufe 3 bis 4). B24: Mantel neutral (Rampe 0, Stufe 6). Die beiden Grautöne liegen nahe beieinander. Unterschied sonst nur durch die rote Bommelmütze und den roten Schal von DET. | Mantelfamilie einer der beiden Figuren ändern (z. B. B24 auf eine Buntfarbe). |
| B13 | B33 | Höhe 108 / 106 (Δ 2). Beide tragen ein Kleid, weißes Dutt und eine Haube. B13: Kleid holz2 (braun), bernsteinfarbener Umhang. B33: Kleid stein3 (dunkelgrau), blaue Haube und Schal. Die Kleider sind beide dunkel, die Familien unterscheiden sich nur knapp. | Kleiderfamilie von B33 oder B13 ändern, oder die Haubenfarbe deutlich trennen. |
| BW | B12 | Höhe 120 / 118 (Δ 2). Hose bei beiden holz4 (gleich). BW: weißes Haar und weißer Bart. B12: braunes Haar, kein Bart. BW: Weste stein4 gegen B12 helles Hemd neutral6. | Bart von BW als Unterscheider nutzen, oder die Weste von BW in eine andere Familie setzen. |

## 3. Regelverstöße

Keine gefunden.

- Grün (Rampe 5, Palettenindex 40 bis 47): Nur R03 und R04 enthalten grüne Pixel (Front, Seite, Rücken). Bei allen übrigen 64 Figuren sind es 0 Pixel.
- Wanderstiefel (braune Schaftstiefel mit dicker Sohle): Nur R03 und R04 tragen sie. Die braunen Fußtöne bei R05, R09 und R16 gehören zu niedrigen Halbschuhen ohne Schaft (Datensatz: halbschuhe). Bei B09, B12, B16, B21, B22, B34 und B40 sind die unteren Partien Hosen-, Rock- oder Mantelsäume mit dunklen, kleinen Schuhen.
- Kleiderfarben laut Datensatz: 118 Pflichtfarben aus `rollen.json` (nicht erfunden) und `bewohner.json` geprüft, alle im Bild vorhanden. Drei davon haben nur kleine Anteile (unter 1 %) und sind verdeckt oder klein: R02 Turnschuh (0,6 %), R16 Hemd (0,5 %, unter der Jacke), R19 Hemd (0,2 %, unter der Lederjacke). Kein Verstoß.
- Gegenstände K9 §8 (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): nicht sichtbar, und keines der Zubehörteile im Datensatz nennt diese Gegenstände. Im Bild gesichtet: Gehstock (B08), Regenschirm (B16), Kochschürze (R09), Hutschachtel (B22) u. a. Notizbücher und Mappen (R03, B01, B04, B06, B19, B24, B42) sind geschlossene Bücher bzw. Mappen ohne losen Zettel. Klemmbrett (B20) ohne sichtbares Blatt.
- Pixeldichte: Alle 66 Figuren liegen im gleichen 2-px-Raster (häufigste Lauflänge 2 px, alle Lauflängen gerade).
- Film- oder Spielkopien, Klischees, Alkohol, Blut, Vampir, Hexe, Teufel, Walpurgis: nicht erkennbar. Kannen (B02 Ölkanne, B07 Thermoskanne, B31 Gießkanne) sind keine Alkoholgefäße. Der Lederhut von R17 mit Feder ist ein allgemeiner Abenteuerhut, keine erkennbare Kopie.
- DET entspricht der Vorgabe: steinfarbener Mantel, rote Bommelmütze, roter Schal.

## 4. Nahbereiche, die unterscheidbar sind (kein Paar, kein Grenzfall)

- B04 / B18: B18 hat einen Nähkorb, die Silhouette ist dadurch 46 px breit (B04: 32 px). B04 Mantel bernstein5 gegen B18 bernstein3 (deutlich heller). B18 ist kahl.
- B29 / B41: Gleiche Höhe (110 px), Zopf, gelbes Oberteil, blaue Hose. Die Schürze ist grau (B29) gegen orange (B41), eine große Farbfläche in anderer Familie.
- B08 / B27: Höhe genau 8 px (120 / 112). Nach Maßstab unterscheidbar. Zusätzlich Hut gegen langes Haar.
- R01 / R16 und R06 / B34: Mütze gegen kein Kopfschmuck, deutlicher Kopfunterschied.
- B02 / B14: Gleiche Höhe (128 px), gleiche Form Weste plus Hemd. Weste blau gegen rot (große Farbfläche in anderer Familie), Hose grau gegen blau.
- B16 / B26: Beide Hut. B16 hat Rock und Regenschirm, B26 Hose. Unterschied in der Kleidungsform.
- B21 / B42: Rock mit bloßen Beinen gegen Hose, Locken gegen kurzes Haar mit Bart.
- R09 / R06: Weißes Shirt mit dunkelblauer Schürze gegen dunkelblaue Jacke (große Farbfläche in anderer Familie).

## 5. Gesamturteil

Abnahme nein. Ein verwechselbares Paar (R06 / R08). Die drei Grenzfälle (DET / B24, B13 / B33, BW / B12) sind nicht als Paar gezählt, sollten aber geprüft werden. Regelverstöße: keine.

## 6. Grenzen der Prüfung

- Kopfklasse und Kleidungsform sind Sichtzuordnungen aus den 2x- und 4x-Ausschnitten. Die Farbfamilien sind pixelgenau.
- Bei strenger Auslegung, in der Helligkeitsstufen innerhalb einer Rampe ab 2 Stufen als anderer Farbton zählen, würde R06 / R08 als Grenzfall gelten und die Paarzahl wäre 0. Bei der Auslegung dieses Berichts (Rampe = Farbfamilie, Abschnitt 5a) bleibt es bei einem Paar.

ERGEBNIS · Paare: 1 · Verstöße: 0 · Karten e4624201af

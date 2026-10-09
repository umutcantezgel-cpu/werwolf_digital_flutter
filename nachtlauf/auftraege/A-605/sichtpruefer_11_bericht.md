# Sichtprüfung A-605k/l · sichtpruefer_11

- **Stand:** Worktree auf e8519a5 (Schritt 0: `git merge --ff-only nachtlauf/burgstadt`, vorher fb0ec24).
- **Bild:** `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px), 66 Figuren mit Front, Seite und Rücken. Reihenfolge: BW, DET, R01–R20, B01–B44.
- **Karten-Hash:** `git hash-object packages/pixel_engine/data/figuren/karten.json` = `c44e0c18987c7030f24a891c70ef2b398729315e`.

## Vorgehen

- Alle 66 Figuren aus dem Bild segmentiert und vermessen. Höhe = Scheitel bis Sohle, Front-Ansicht, in Bildpixeln der Aufstellung. Spanne: 106 px (R11, B33) bis 136 px (B22).
- Alle Bildpixel liegen in der 64er-Palette (`packages/pixel_engine/lib/src/palette.dart`). Farbfamilie = Rampe. Gleiche Hauptfarbe = gleiche Rampe in Oberteil und Unterteil. Eine Schürze zählt zum Oberteil.
- Vorprüfung aller 2145 Paare nach Höhe (Abweichung höchstens 7 px), Kopfklasse, Kleidungsform und Rampe von Oberteil und Unterteil. Ergebnis: 5 Kandidaten (R09/R16, R09/B12, R17/B40, B04/B30, B29/B41), dazu BW/B12 manuell. Kopfklasse und Kleidungsform sind am Bild bestimmt.
- Alle Kandidaten und Nahpaare in vierfacher Vergrößerung (Front, Seite, Rücken) sichtgeprüft.
- Datenabgleich mit `packages/burgstadt_core/data/stadt/bewohner.json` und `packages/pixel_engine/data/figuren/rollen.json`.
- Hilfsbilder und Auswertungen liegen im Scratchpad s11, nicht im Repository. Keine fremden Prüfberichte gelesen.

## 1. Verwechselbare Paare

Keine. Kein Paar stimmt nach Maßstab 5a zugleich in Silhouette und Hauptfarben überein.

| ID | ID | warum | Vorschlag zur Unterscheidung |
|---|---|---|---|
| – | – | keines | – |

## 2. Grenzfälle (nicht als Paar gezählt)

| ID | ID | gleich | einziger bzw. kleiner Unterschied | Vorschlag |
|---|---|---|---|---|
| BW | B12 | Höhe 120/118 px; kurzes Haar mit Bart; Hose Holz 4 | Oberteil: Weste Stein 4 (mittelwarmgrau) gegen Hemd Neutral 6 (hellgrau). Haar weiß mit Brille auf der Stirn gegen braun | Weste von BW in Blau oder Rot, dann klar getrennt |
| B29 | B41 | Höhe 110/110 px; Zopf bzw. Pferdeschwanz; Oberteil Bernstein 5; blaue Hose | Schürze grau (B29, Neutral 5) gegen orange (B41, Rot 5). Haar blond gegen braun | Größe um mindestens 8 px absetzen (B41 auf 118 px) oder eine Schürze ändern |
| R09 | B12 | Höhe 124/118 px (Abweichung 6); kurzes Haar; Hose Holz 3/4; Oberteil weiß bzw. hellgrau | dunkelblaue Schürze bei R09 (große Fläche); Haar rotbraun gegen braun; Schuhe braun gegen dunkel | Größe von B12 auf 116 px (Abweichung 8), dann unterscheidbar |

## 3. Geprüfte Nahpaare, unterscheidbar

- **R17 ↔ B40** (130/128 px): Mantel bis 76 % der Figurenhöhe (B40) gegen Jacke bis 45 % (R17). Kopf: kahl mit orangem Hut (B40) gegen brauner Hut mit Feder und Bart (R17).
- **B04 ↔ B30** (114/120 px): Mantel bis 75 % der Höhe (B04) gegen Jacke bis 44 % (B30). Hose dunkelgrau (B04, Neutral 4) gegen schwarz (B30, Neutral 2). Haar grau gegen braun.
- **B14 ↔ B20** (128/122 px): Weste orange (B14, Rot 5) gegen ockergelbe Jacke (B20, Bernstein 4). Mütze rostrot gegen graublau.
- **R09 ↔ R16** (124/128 px): dunkelblaue Schürze (R09) gegen anthrazitfarbenes Sakko (R16). R16 mit grauem Bart.
- **B01 ↔ B13** (112/108 px): hellgraue Schürze (B01) gegen gelbe Schulterpartie (B13). B13 mit orangefarbener Haube.
- **B21 ↔ B42** (118/116 px): Rock mit nackten Beinen (B21) gegen Hose mit dunkelblauen Stiefeln (B42). Blonde Locken gegen kurzes braunes Haar mit Bart.
- **B05 ↔ B43** (110/112 px): blaue Beine (B05) gegen nackte Beine (B43). Brauner Rock (B05, Holz 2) gegen dunkelrotes Kleid (B43, Rot 2).
- **B21 ↔ B23** (118/114 px): schwarzer Rock (B21, Neutral 2) gegen warmgrauen Rock (B23, Stein 4). Blonde Locken gegen graues Kurzhaar (B23).

## 4. Regelverstöße

Keine.

- **Grün (Oliv/Dunkelgrün), nur R03 und R04:** Nur R03 (1968 Pixel) und R04 (2768 Pixel) enthalten Palettenfarben der Rampe 5 (grün). Die übrigen 64 Figuren haben 0 Pixel dieser Rampe. Kein Verstoß.
- **Wanderstiefel (braun, Schaft, dicke Sohle), nur R03 und R04:** Gesättigt braune Schaftstiefel gibt es nur bei R03 und R04. R05, R09 und R16 tragen braune Halbschuhe (Datensatz „halbschuhe“, niedrig). B14 hat warmgraue Stiefel (Stein 1.2 bis 1.5, nicht braun). B02, B24, B26, B36, B41 und B42 haben dunkelblaue Stiefel. Alle übrigen Füße sind schwarz, dunkelrot oder dunkel. Kein Verstoß.
- **Kleiderfarben laut Datensatz:** Alle sichtbaren Kleidungsteile der Bewohner (88 Einträge in `bewohner.json`) und der Rollen (`rollen.json`) sind im Bild in Rampe und Stufe ±1 vorhanden. Ausnahmen ohne Verstoß: Teile unter Jacken oder Pullovern sind verdeckt (R01, R02, R06, R07, R08, R13, R16, R17, R19). Kleine Teile: B33 „Schal blau 4“ ist als kleiner blauer Halsschal sichtbar (1,7 % der Pixel). Die Schuhe von R02 (weiß), R12 und R17 (dunkel) sind klein, aber datengemäß. Kein Verstoß.
- **Pixeldichte:** Alle 66 Figuren haben 2 × 2 Bildpixel je Sprite-Pixel (größter gemeinsamer Teiler aller Lauflängen = 2, keine Lauflänge 1). Kein Verstoß.
- **Gegenstände aus K9 §8** (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): nicht erkennbar. Geprüft wurden unter anderem Taschenuhr (B02), Uhr (R04), gelbes Tuch am Hals (B34), dunkelroter Gegenstand am Gürtel (B39), Klemmbrett (B20), Stöcke und Werkzeuge (B08, B10, B16, B17, B32, B40). Keiner davon ist eine Münze, ein Schlüssel, ein Blatt Papier, eine Taschenlampe, ein Kerzenständer oder ein Zettel. Die im Datensatz genannte Laterne (B15) ist im Bild nicht zu sehen.
- **Film-/Spiel-Kopien und Klischees:** kein eindeutiger Befund. Hüte und Mäntel (R17, B08, B16, B22, B26, B31, B40) sind alltägliche Kopfbedeckungen und Kleidung. Keine Vampir-, Hexen-, Teufel- oder Walpurgis-Motive. Keine gruppenbezogenen Klischees erkennbar.
- **Beobachtung ohne Regelbezug:** R19 nennt im Datensatz einen roten Kameragurt quer über der Brust. Im Bild ist nur ein dunkles Kameraobjekt zu erkennen.

## 5. Gesamturteil

**Abnahme ja.** Keine verwechselbaren Paare nach Maßstab 5a, keine Regelverstöße. Die drei Grenzfälle BW/B12, B29/B41 und R09/B12 zählen nicht als Paar. Würde der Auftraggeber einen davon als Paar werten, wäre das Gesamturteil Abnahme nein.

ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten c44e0c1898

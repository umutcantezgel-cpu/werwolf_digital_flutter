# Sichtprüfung Figuren-Aufstellung (A-605u/v), Bericht sichtpruefer_24

- **Auftrag:** A-605v (gilt für A-605u und A-605v)
- **Prüfgegenstand:** `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px, 66 Figuren mit Front, Seite und Rücken)
- **Stand:** Worktree per `git merge --ff-only nachtlauf/burgstadt` auf 614da74 gebracht (Schritt 0). Hash von `packages/pixel_engine/data/figuren/karten.json`: `b60891cc2b` (erste 10 Zeichen).
- **Datenquellen (nur gelesen):** `packages/pixel_engine/data/figuren/rollen.json` (BW, R01–R20), `packages/burgstadt_core/data/stadt/bewohner.json` (B01–B44, Feld `aussehen`), `packages/pixel_engine/lib/src/palette.dart`.
- **Nicht geändert:** keine Datei außer diesem Bericht, kein Commit, kein Push, kein Build. Hilfsdateien nur im Scratchpad-Unterordner `sichtpruefer_24`.

## Vorgehen

1. Layout gemessen: 8 Reihen mit je 9 Gruppen (Reihe 8: 3 Gruppen). Reihenfolge BW, DET, R01–R20, B01–B44, Beschriftung im Bild gelesen.
2. Ausschnitte: 22 Ausschnitte mit je 3 Gruppen, 2-fach vergrößert, visuell geprüft. Zusätzlich vergrößerte Fußzonen aller 66 Vorderansichten. Seiten- und Rückansichten zur Kontrolle.
3. Messung je Figur (PIL): Höhe und Breite der Vorderansicht in Sheet-Pixeln (Höhen 104 bis 136 px), Pixelraster, exakte Palettenindizes. Alle 485 080 sichtbaren Pixel sind Palettenfarben.
4. Alle 2145 Paare auf Farbe geprüft. Die 46 Paare mit nahezu gleichen Oberteil- und Hosenfarben wurden weiter auf Silhouette und Zubehör geprüft.

Festlegungen zum Maßstab 5a (meine Operationalisierung):
- **Gleiche Gesamtsilhouette:** Höhendifferenz unter 8 px; gleiche Kopfform (Kategorien: kein Kopfschmuck oder kurz, Glatze, Mütze, Hut, Haube, Dutt, Zopf, lange Haare, Locken, Bob, Pferdeschwanz); gleiche Kleidungsform (H = Jacke, Weste oder Pullover mit Hose; R = Rock oder Kleid mit sichtbaren Beinen; L = langer Mantel oder Kittel; S = Schürze prägt das Bild; O = Latzhose oder Overall); kein großes Zubehör nur bei einer der beiden. Die Breite wurde nur als Zusatzmaß ausgewiesen und nicht als Ausschlussgrund gewertet.
- **Gleiche Hauptfarben:** Oberteil und Hose oder Rock gleiche Palettenrampe, Stufendifferenz höchstens 2. Warmes Grau (stein) und kühles Grau (neutral) gelten als verschiedene Rampen; solche Paare sind im Anhang mit „warm/kalt“ gekennzeichnet.

## 1. Verwechselbare Paare

**Keine (0).** Kein Paar erfüllt beide Bedingungen gleichzeitig. 46 Paare haben nahezu gleiche Hauptfarben, scheitern aber an Kopfform, Kleidungsform, Höhe oder Zubehör (Anhang A). Die engsten davon sind unten als Grenzfälle getrennt genannt.

| ID | ID | warum | Vorschlag zur Unterscheidung |
|---|---|---|---|
| – | – | keine | – |

## 2. Grenzfälle (zählen nicht als Paar)

| ID | ID | gleich | einziger kleiner Unterschied | Vorschlag |
|---|---|---|---|---|
| B02 | B42 | Höhe 128/130 px, Hose grau, Oberteil blau (5/6), Form Jacke-Hose | blaue Mütze (B02) gegen unbedeckten Kopf (B42), Haarfarbe weiß gegen braun | Mütze in Form und Schirm klarer machen oder die Kopfform von B42 abweichend gestalten |
| B06 | B36 | Oberteil bernstein 4, Hose rot 2, Form Jacke-Hose | blaue Mütze (B06) gegen unbedeckten Kopf (B36), Breite 44 gegen 36 px | Schulterbreite von B06 angleichen oder die Locken von B36 prägnanter setzen |
| R20 | B27 | Oberteil blau (3/4), Hose braun (2/4), Höhe 120/122 px | Zopf (R20, Breite 32 px) gegen offenes langes Haar (B27, Breite 40 px) | Zopf von R20 nach vorn über die Schulter legen; Haar von B27 auf Schulterhöhe kürzen |
| R06 | R09 | Kopf kurz ohne Bedeckung, Hose braun (4/3), Oberteil dunkelblau, Höhe 122/124 px | Schürze mit weißem Hemd (R09) gegen Jacke mit rotem Halstuch (R06) | Schürze als Formunterschied belassen; im Spiel bei Dämmerung prüfen |
| B03 | B35 | Kittel lang, Höhe 122/120 px, untere Hälfte blau | weiße Haube (B03) gegen Dutt (B35), Eimer an der Hüfte (B35), warmes Grau (stein 5) gegen kühles Grau (neutral 6) | Haube als helle Kopfform betonen; Grautöne trennen (B03 warm, B35 kühl) |

## 3. Regelverstöße

**Keine (0).** Geprüft wurde:

- **Grün (Oliv/Dunkelgrün):** nur R03 (Strickjacke) und R04 (Pullover). Grüne Pixel in allen Ansichten: R03 1968, R04 3084, alle übrigen Figuren 0.
- **Wanderstiefel (braune Schaftstiefel):** nur R03 und R04. Deren Stiefel haben exakt die Palettenfarbe holz 3 (R03 je Ansicht 104, 76, 112 Pixel; R04 136, 96, 136 Pixel). Braune Halbschuhe tragen R05, R09 und R16. Laut rollen.json sind das Halbschuhe, keine Schaftstiefel (siehe Hinweis 2).
- **Bewohner-Kleiderfarben (bewohner.json):** alle 88 Kleidungseinträge von B01 bis B44 sind im Bild in der angegebenen Rampe vorhanden (±1 Stufe). Fünf sekundäre Teile wurden einzeln exakt belegt: B13 Umhang stein 5 (476 Pixel, Rückansicht), B43 Umhang bernstein 3 (320 Pixel, Rückansicht), B19 Schal stein 4 (60 Pixel), B33 Schal blau 4 (32 Pixel), B37 Hemd bernstein 3 (64 Pixel).
- **Rollen-Festfarben (rollen.json):** Oberteil und Hose von BW und R01–R20 sind im Bild vorhanden (±1 Stufe). Freie Teile laut Feld „erfunden“ wurden nicht als Verstoß gewertet. R02 trägt weiße Turnschuhe (neutral 7, je Ansicht 20/24/16 Pixel).
- **K9 §8 (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel):** nicht erkennbar. Die Rotlicht-Stirnlampe von R11 um den Hals ist keine Stablampe.
- **Gleiche Pixeldichte:** alle 66 Figuren in allen drei Ansichten haben ein 2-Pixel-Raster (Modus und größter gemeinsamer Teiler je 2).
- **Film-/Spiel-Kopien, Klischees, Blut, Verletzungen über Beule und Kühlpack hinaus, Alkohol:** nichts erkennbar. Thermoskanne (B07), Ölkanne (B02) und Gießkanne (B31) sind unverdächtig.

## 4. Hinweise (kein Verstoß)

1. Die Beschriftung der letzten Reihe (B42, B43, B44) ist am unteren Bildrand knapp beschnitten: Das Beschriftungsband endet in Zeile 1503, also 14 statt 16 Zeilen. Die IDs sind lesbar.
2. R16: braune Halbschuhe auf brauner Hose wirken aus der Ferne wie braune Stiefel und können mit den Wanderstiefeln von R03 und R04 verwechselt werden.
3. B25: Bluse bernstein 3 (Palettenfarbe #94661A) wirkt im Kleinen dunkel ockergelb bis olivfarben. Es ist kein Grün; kein Verstoß.
4. R12, Rückansicht: großer dunkler runder Fleck auf dem oberen Rücken. In rollen.json stehen nur Steppweste und Zollstock. Bitte prüfen, ob das so gewollt ist.
5. R16 und R19: das Hemd ist nur als Kragen sichtbar (je 4 Pixel). Kein Verstoß, aber im Bild praktisch nicht erkennbar.

## 5. Gesamturteil

**Abnahme ja.** Null verwechselbare Paare, null Regelverstöße. Die fünf Grenzfälle sind nicht als Paar gezählt; die Vorschläge sind optional. Die Hinweise betreffen Lesbarkeit und Einzelheiten und sind keine Abnahmehürde.

## Anhang A: Nah-Paare und Ausschlussgrund

Format: ID–ID · Δ Höhe, Δ Breite (px) · Ausschlussgrund. Grenzfälle sind mit „(Grenzfall)“ markiert. „warm/kalt“ = nur warmes gegen kühles Grau.

- B02–B42 · 2, 4 · Kopf Mütze/kurz (Grenzfall)
- B06–B36 · 6, 8 · Kopf Mütze/kurz (Grenzfall)
- B24–B37 · 4, 4 · Kopf Mütze/lang
- R06–R09 · 2, 4 · Form Jacke-Hose/Schürze (Grenzfall)
- R15–B39 · 6, 4 · Kopf lang/Mütze
- R18–B38 · 6, 4 · Kopf lang/Haube; Schürze bernstein bei B38
- R20–B27 · 2, 8 · Kopf Zopf/lang (Grenzfall)
- B02–B24 · 4, 12 · Form Jacke-Hose/langer Mantel
- B03–B15 · 14, 4 · Höhe; Kopf Haube/Zopf
- B05–B06 · 0, 4 · Kopf Dutt/Mütze; Form Rock/Hose
- B05–B36 · 6, 4 · Kopf Dutt/kurz; Form Rock/Hose
- B17–B25 · 4, 0 · Kopf Mütze/Zopf; Form Overall/Rock
- B21–B27 · 2, 0 · Kopf Locken/lang; Form Rock/Hose
- B27–B34 · 10, 4 · Höhe; Kopf lang/Mütze
- B32–B40 · 6, 12 · Kopf kurz/Hut; Form Schürze/langer Mantel
- BW–R16 · 12, 0 · Höhe; Oberteil warm/kalt
- R03–R04 · 16, 8 · Höhe; Kopf lang/kurz
- R08–B27 · 12, 12 · Höhe; Kopf Dutt/lang
- R08–R20 · 10, 4 · Höhe; Kopf Dutt/Zopf
- R09–B27 · 2, 0 · Kopf kurz/lang; Form Schürze/Jacke-Hose
- R09–R20 · 4, 8 · Kopf kurz/Zopf; Form Schürze/Jacke-Hose
- R13–R18 · 2, 4 · Kopf Pferdeschwanz/lang; Form Hose/Kleid
- R16–B23 · 18, 0 · Höhe; Form Hose/Rock
- R17–B44 · 10, 0 · Höhe; Kopf Hut/kurz
- B03–B35 · 2, 6 · Kopf Haube/Dutt; Zubehör Eimer; Oberteil warm/kalt (Grenzfall)
- B04–B20 · 6, 4 · Kopf kurz/Mütze; Form langer Mantel/Jacke-Hose; Hose nah
- B07–B39 · 10, 4 · Höhe; Kopf Locken/Mütze; Form Rock/Hose
- B09–B17 · 16, 6 · Höhe; Kopf Zopf/Mütze
- B09–B25 · 12, 6 · Höhe; Form Overall/Rock; Zubehör Arzttasche
- B11–B30 · 30, 8 · Höhe; Kopf Zopf/kurz; Form Rock/Hose
- B17–B22 · 10, 0 · Höhe; Kopf Mütze/Hut; Form Overall/langer Mantel
- B21–B34 · 12, 4 · Höhe; Kopf Locken/Mütze; Form Rock/Hose
- B22–B25 · 14, 0 · Höhe; Kopf Hut/Zopf; Form langer Mantel/Rock
- B24–B42 · 2, 8 · Kopf Mütze/kurz; Form langer Mantel/Jacke-Hose; Hose nah
- BW–B16 · 0, 2 · Kopf kurz/Hut; Form Jacke-Hose/langer Mantel; Zubehör Regenschirm
- DET–R12 · 6, 8 · Kopf Mütze/kurz; Form langer Mantel/Jacke-Hose; Oberteil warm/kalt
- R08–R09 · 14, 12 · Höhe; Kopf Dutt/kurz; Form Jacke-Hose/Schürze
- B09–B22 · 26, 6 · Höhe; Kopf Zopf/Hut; Form Overall/langer Mantel
- B12–B31 · 4, 4 · Kopf kurz/Hut; Form Jacke-Hose/Rock; Zubehör Gießkanne; Hose nah
- B15–B35 · 12, 10 · Höhe; Kopf Zopf/Dutt; Zubehör Eimer; Oberteil warm/kalt
- B16–B23 · 6, 2 · Kopf Hut/kurz; Form langer Mantel/Rock; Zubehör Regenschirm; Oberteil warm/kalt
- B26–B35 · 14, 2 · Höhe; Kopf Hut/Dutt; Form Jacke-Hose/langer Mantel
- B03–B26 · 12, 8 · Höhe; Kopf Haube/Hut; Form langer Mantel/Jacke-Hose; Oberteil warm/kalt
- B15–B26 · 26, 12 · Höhe; Kopf Zopf/Hut; Form langer Mantel/Jacke-Hose
- R16–B16 · 12, 2 · Höhe; Kopf kurz/Hut; Form Jacke-Hose/langer Mantel; Zubehör Regenschirm
- R12–B33 · 18, 6 · Höhe; Kopf kurz/Haube; Form Jacke-Hose/Rock; Zubehör Häkelbeutel

ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten b60891cc2b

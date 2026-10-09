# Sichtprüfung Figuren-Aufstellung · Auftrag A-605o · sichtpruefer_17

## Stand und Vorgehen

- **Worktree:** `git merge --ff-only nachtlauf/burgstadt` ausgeführt, Fast-Forward auf `3092813`, Arbeitsbaum sauber.
- **Kartenstand:** `git hash-object packages/pixel_engine/data/figuren/karten.json` = `901192c46385d39d2719c27ce01bcdf344f3f7af`, Kürzel `901192c463`.
- **Prüfobjekt:** `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 Pixel). 66 Figuren mit je Front, Seite, Rücken, also 198 Ansichten. Die IDs stammen aus der Beschriftung und sind über die Anzahl (BW, DET, R01–R20, B01–B44) gegengeprüft. Reihenfolge: Zeile 1 BW, DET, R01–R07; Zeile 2 R08–R16; Zeile 3 R17–R20, B01–B05; Zeilen 4–7 B06–B41; Zeile 8 B42–B44.
- **Methode:**
  - Pixelanalyse aller 198 Ansichten: alle Farben sind exakte Palettenfarben, und überall gilt ein Raster von 2 Bildpixeln je Sprite-Pixel.
  - Sichtprüfung aller 66 Figuren in vergrößerten Bögen, zusätzlich Hüft-, Hand- und Fußzonen.
  - Abgleich mit `bewohner.json` (B01–B44), `rollen.json` (BW, R01–R20) und `palette.dart` (Index = Rampe·8 + Stufe).
- **Auslegung (eigene, im Auftrag nicht festgelegt):**
  - Farbfamilien nach Palettenrampen. Schwarz und Grau bilden eine Familie, Navy zählt zu Blau.
  - Größe nach Frontansicht. Ein Breitenunterschied von 8 Pixeln oder mehr zählt als Statur-Unterschied.
  - Kopf nach Kopfbedeckung und Frisurtyp. Haarfarbe, Bart und kleine Accessoires zählen als Details.

## 1. Verwechselbare Paare

| Nr | ID | ID | Warum (Maßstab 5a) | Vorschlag zur Unterscheidung |
|---|---|---|---|---|
| 1 | BW | B12 | Größe 120/118 Pixel (Δ 2), Breite 40/36 (Δ 4). Beide haben kurzes Haar ohne Kopfbedeckung. Oberteil grau (BW Weste stein4 mit Hemd, B12 Hemd neutral6), Hose braun (beide holz4, identisch). Einziger Unterschied: weißer Bart und Weste bei BW, also kleine Details. | BW-Cordhose in eine andere Farbfamilie setzen, z. B. Blau oder Rot. Die Farbe ist in `rollen.json` als erfunden markiert. Dann unterscheidet sich eine große Hosenfläche. |
| 2 | DET | B24 | Größe 126/120 Pixel (Δ 6), Breite 36/36. Beide tragen einen langen grauen Mantel bis zum Knie und eine Mütze. Oberteil grau (DET steinfarben, B24 neutral6). Einziger Unterschied: DETs rote Bommel und roter Schal, also kleine Akzente, sowie B24s blaue Stiefel. B24s Hose ist vom Mantel verdeckt. | DET-Hose (frei erfunden) in Braun oder Blau setzen, dann unterscheidet sich eine große Hosenfläche. Alternativ den roten Schal als großes Zubehör über die Brust führen. Mantel und Bommelmütze unverändert lassen. |

Anzahl verwechselbarer Paare: **2**. DET ist die Figur der Spielerrolle und deshalb besonders betroffen.

## 2. Grenzfälle (nicht als Paar gezählt)

Die Paare unterscheiden sich nur in einem knappen Merkmal. Nach dem Maßstab sind sie knapp unterscheidbar.

| ID | ID | Einziger Unterschied nach Maßstab | Übrige Merkmale |
|---|---|---|---|
| BW | R16 | Größe genau 8 Pixel (Schwelle): BW 120, R16 128. | Breite 40/40. Beide kurzes Haar mit Bart. Oberteil grau, Hose braun. BW hat helle Hemdsärmel, R16 ein dunkles Sakko. |
| R18 | B21 | Größe genau 8 Pixel (Schwelle): R18 110, B21 118. | Breite 28/32. Beide lockiges Haar und nackte Unterschenkel. R18 trägt ein einteiliges navy Kleid, B21 eine hellblaue Bluse mit schwarzem Rock. |
| R17 | B40 | Mantel bis zum Oberschenkel (B40) gegen kurze Jacke bis zur Hüfte (R17). Bart bei R17 gegen Glatze bei B40. Hutfarbe braun gegen rostrot. | Größe 130/128, Breite 36/40. Hut bei beiden, Oberteil rostrot, Hose braun. |
| R06 | R16 | Oberteil bei R06 fast schwarzes Navy (blau1), bei R16 Anthrazit (neutral4). Nur Farbton. Stoppelbart gegen grauer Bart. Dunkelroter Halstuch klein. | Größe 122/128 (Δ 6), Breite 36/40. Haar kurz und schwarz, Hose braun. |
| R14 | B42 | Hose bei R14 dunkelnavy (blau3), bei B42 schwarz. Nur Farbton. Oberteil navy gegen hellblau ist dieselbe Familie. | Größe 120/116 (Δ 4), Breite 40/40. Beide kurzes braunes Haar mit Bart. |

## 3. Regelverstöße

**Keine.** Geprüft wurde Folgendes:

- **Grün** (Palettenrampe 5, Index 40–47): Grüne Pixel stehen nur bei R03 (Strickjacke, Index 42) und R04 (Fleece, Index 44), in allen drei Ansichten. Keine andere Figur hat grüne Pixel. Kein Verstoß.
- **Wanderstiefel** (braune Schaftstiefel mit dicker Sohle): nur bei R03 und R04. Die braunen Schuhe von R05, R09 und R16 sind Halbschuhe ohne Schaft. Kein Verstoß.
- **Kleiderfarben der Bewohner** (`bewohner.json`): alle 44 Bewohner (B01–B44). Jede dort benannte Kleidungsfarbe ist exakt im Sprite vorhanden. Die Zuordnung ist in den Bögen sichtbar bestätigt. Kein Verstoß.
- **Kleiderfarben der R-Figuren** (`rollen.json`): die sichtbaren Teile stimmen überein. Fehlende Unterziehshirts sind verdeckt (R01, R06, R07, R08, R09, R10, R13, R17, R19). Kein Verstoß.
- **Gegenstände aus K9 §8** (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): keine erkennbar. Sichtbar sind nur Gegenstände, die im Datensatz stehen: Gehstock (B08), Regenschirm (B16), Arzttasche (B09), Gießkanne (B31), Eimer (B35), Häkelbeutel (B33), Nähkorb (B18), Aktenordner (B42), Umhängetasche (B26), Kameragurt (R19). Kein Verstoß.
- **Film-/Spiel-Kopien und Klischees:** keine erkennbar. Kein Spitzhut einer Hexe, kein Vampir-Umhang, keine Hörner. Kein Verstoß.
- **Pixeldichte:** einheitlich. Alle 198 Ansichten haben 2 Bildpixel je Sprite-Pixel und nur Palettenfarben. Kein Verstoß.
- **Leitplanken** (Alkohol, Drogen, Blut): keine sichtbar. Keine Flaschen, Gläser oder Krüge, keine Blutspuren, keine Verletzungsdarstellung. Kein Verstoß.

## 4. Hinweise (kein Verstoß)

- R18 hat laut `rollen.json` einen Anstecker „Einspruch!“ am Kragen. Im Bild ist er nicht erkennbar. Das Wort ist als Ausruf vor allem aus einer bekannten Spielereihe geläufig. Der Autor sollte das prüfen.
- R11 trägt laut `rollen.json` eine Rotlicht-Stirnlampe um den Hals. Das ist keine Stablampe im Sinne der K9-Liste und im Bild kaum erkennbar.
- Die Hintergrundfarbe der Aufstellung (`D4CEC3`) entspricht Palettenindex 15. Kein Figurenpixel nutzt diese Farbe. Würde ein Sprite sie nutzen, verschwände der Teil im Hintergrund.
- Verdeckte Teile (Unterziehshirts, Hosen unter langen Mänteln) sind nur über die Datensätze belegt. Im Bild sind sie nicht zu prüfen.

## 5. Gesamturteil

**Abnahme: nein.** Es gibt zwei verwechselbare Paare, darunter DET/B24 mit der Spielerfigur. Regelverstöße gibt es keine. Die Nachbesserung betrifft nur Farbe und Größe von DET, BW und, falls gewünscht, der Grenzfälle.

ERGEBNIS · Paare: 2 · Verstöße: 0 · Karten 901192c463

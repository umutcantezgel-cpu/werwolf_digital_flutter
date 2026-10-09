# Sichtprüfung A-605aa/ab · Figuren-Aufstellung · sichtpruefer_29

Stand: Worktree nach `git merge --ff-only nachtlauf/burgstadt` (HEAD a56f8c8). Bild: `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px, 66 Figuren, je Front, Seite, Rücken). Nur lesend: `rollen.json`, `bewohner.json`, `palette.dart`, `karten.json` (nur Hash), `tool/hd_abnahme.dart` (nur `--figurenstand`). Keine anderen Prüfberichte gelesen. Keine Datenänderung, kein Commit, kein Push, kein Build.

## Vorgehen

- Raster 9 × 8 aus dem Bild (je 328 × 188 px), 2× vergrößert, alle 66 Figuren in drei Ansichten gesichtet.
- Messung je Frontansicht: Höhe von Kopfoberkante bis Sohle (Pixel). Alle Figurenfarben sind exakte Palettenfarben (0 Pixel außerhalb der Palette).
- Datenabgleich: Kleiderfarbe = Palettenindex Rampe × 16 + 2 × Stufe + 1; Haar, Bart und Kopfbedeckung gegen `rollen.json` bzw. `bewohner.json`.
- Paarprüfung: alle 2145 Paare, mit Höhe (Schwelle 8 Pixel), Kopfbedeckung, Frisurtyp, Farbfamilie von Oberteil und Unterteil sowie Kleidungsform.
- Farbfamilien: Rot (auch Bordeaux und Rostrot), Ocker/Gelb (bernstein), Braun (holz), Grau (neutral, stein), Schwarz/Dunkelgrau, Blau/Navy, Hellblau, Grün, Weiß.

## 1. Verwechselbare Paare

| ID | ID | warum | Vorschlag zur Unterscheidung |
|---|---|---|---|
| – | – | keine. Kein Paar erfüllt zugleich Silhouette (Höhe, Kleidungsform), Kopf (Kopfbedeckung, Frisur) und Hauptfarben in Oberteil und Hose/Rock. Die engsten Nachbarn stehen in Abschnitt 3. | – |

Paare gesamt: 0.

## 2. Grenzfälle (zählen nicht als Paar)

| ID | ID | Gemeinsamkeit | kleiner Unterschied | Vorschlag |
|---|---|---|---|---|
| B14 | B20 | 128 Pixel, navy Mütze, graues Kurzhaar, rotes Oberteil, dunkle Hose | Hose: B14 marineblau, B20 anthrazit (Farbfamilie Blau gegen Grau). Oberteil: B14 orangerote Weste, B20 dunkelweinrote Jacke | Hose von B20 (frei erfunden) auf Braun ändern |
| B22 | B40 | 128 / 130 Pixel, Hut und langer Mantel, graues Kurzhaar, graue Hose | Hutform: B22 Zylinder, B40 breite Krempe. Mantelton: B22 ockergelb (bernstein 3), B40 dunkelbraun (holz 3) | Mantel von B40 in eine andere Farbfamilie (nicht Grün). Alternativ Hut von B22 mit breiter Krempe |

## 3. Regelverstöße

Verstöße: 1

- **V1 · R19 (Punkt 16, Bart).** `rollen.json`: `bart: kurz`. Merkmal: „Kinnbart (Goatee)“. Das Bild zeigt nur eine dunkle Kinn- und Kieferschattierung in Hauttönen (Palette Haut 1 bis 3), keine Bartfarbe. Damit entspricht das Bild weder „kurz“ (vergleiche R01, R16, R17 und BW mit Bart in Haarfarbe) noch „Kinnbart“. Die Datenangaben widersprechen sich außerdem. Vorschlag: Bartart im Datensatz eindeutig festlegen und den Bart in Haarfarbe zeichnen.

Keine weiteren Verstöße:

- Grün (nur R03 und R04): Grünpixel (Rampe 5) nur bei R03 (768 Pixel) und R04 (1328 Pixel). Keine andere Figur hat grünliche Palettenfarben.
- Wanderstiefel (braune Schaftstiefel, nur R03 und R04): R03 und R04 zeigen braune Schaftstiefel mit dicker Sohle. R05, R09 und R16 haben braune Halbschuhe ohne Schaft, passend zu `halbschuhe`. Sonst keine braunen Schäfte.
- Kleiderfarben Bewohner: B01 bis B44 zeigen alle Datenfarben von Oberteil und Unterteil exakt im Bild (jeweils mindestens 15 Pixel). Kein Abweichler.
- Kleiderfarben Rollen (ohne als frei erfunden markierte Teile): R01 bis R20 stimmen überein.
- Gegenstände aus K9 §8 (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): keine sichtbar. Geprüft wurde das Hüft- und Handband aller 66 Figuren. Sichtbar sind nur erlaubte Beigaben, zum Beispiel B09 Arzttasche, B31 Gießkanne, B33 Häkelbeutel, B35 Eimer, B44 Garnrolle, B16 Regenschirm.
- Pixeldichte: alle Figuren 2 Pixel je Sprite-Pixel, kein Abweichler.
- Film- oder Spielkopien und Klischees: keine erkennbar. Ein Referenzbestand stand nicht zur Verfügung, geprüft wurde nur die Sichtprüfung.
- Alkohol, Drogen, Blut, Hexen, Vampire, Teufel: nicht erkennbar.

Punkt 16 im Einzelnen:

- R06: Dreitagebart als Bartschatten (Hauttöne auf Kinn und Kiefer), kein schwarzer Vollbart.
- R14: voller Bart, Bartfarbe dunkel-holz über Kiefer und Kinn.
- R16: Kurzbart grau meliert, Haar nach hinten gekämmt, passend zu `kurz` und `grau meliert`.
- R17: dunkler Kurzbart. Brauner Lederhut mit blauem Band. Das Haar liegt unter der Krempe.
- R01: Kurzbart braun, graue Strickmütze.
- R07, R12 und R19 heller, R14 dunkler: passt zu den Haarstufen in `rollen.json`.
- R20: keine Kapuze auf dem Kopf, Zopf an Seite und Rücken sichtbar.
- Dutt, Haube und Glatze bei jüngeren Bewohnern: B27 (31 Jahre) Dutt, B09 (44) Dutt, B03 (51) Haube, B06 (46) Glatze mit Mütze. Alle vorhanden.
- Geschlechtswechsel: B15, B35 und B41 sind als Männer lesbar. B12, B32 und B39 siehe Hinweis H1 und H2.
- Hut und langer Mantel: B16 (118 Pixel), B22 (128) und B40 (130) sind unterscheidbar. Die Ausnahme ist das Grenzfallpaar B22/B40 in Abschnitt 2.

## 4. Anhang: Höhen der Frontansichten (Pixel)

BW 120, DET 126, R01 134, R02 128, R03 118, R04 130, R05 128, R06 120, R07 124, R08 110, R09 126, R10 130, R11 106, R12 134, R13 112, R14 120, R15 120, R16 132, R17 128, R18 110, R19 118, R20 116, B01 114, B02 122, B03 114, B04 126, B05 114, B06 134, B07 114, B08 122, B09 110, B10 122, B11 114, B12 112, B13 106, B14 128, B15 124, B16 118, B17 134, B18 120, B19 118, B20 128, B21 112, B22 128, B23 114, B24 134, B25 114, B26 132, B27 118, B28 136, B29 118, B30 134, B31 126, B32 112, B33 110, B34 120, B35 134, B36 128, B37 132, B38 124, B39 118, B40 130, B41 126, B42 136, B43 108, B44 122.

## 5. Nahfälle, geprüft und unterscheidbar

| ID | ID | Höhe | entscheidender Unterschied |
|---|---|---|---|
| B03 | B13 | 114 / 106 | Haube in beiden. B03 hat Zopf und hellblaue Schürze (große Fläche), B13 Dutt und roten Umhang |
| DET | B16 | 126 / 118 | beide langer steingrauer Mantel. DET rote Bommelmütze und roter Schal, dunkle Hose. B16 navy Hut, graue Locken, brauner Rock |
| B08 | B40 | 122 / 130 | beide blaue Hüte. B08 kahl, hellblaue Jacke, dunkelrote Hose. B40 graues Kurzhaar, brauner Langmantel |
| B09 | R08 | 110 / 110 | beide Dutt, braune Hose. B09 amberfarbene Jacke, R08 navy Pullover |
| B06 | B35 | 134 / 134 | braune Hosen. B06 Mütze auf Glatze, hellblaue Jacke. B35 Kurzhaar ohne Kopfbedeckung, blauer Kittel bis Knie |
| B24 | B35 | 134 / 134 | B24 Bart und navy Mütze, schwarze Hose. B35 ohne Bart und Mütze, braune Hose |
| B15 | B35 | 124 / 134 | gleicher blauer Kittel und Kurzhaar. Höhe (10 Pixel) und Hose (dunkel gegen braun) |
| B10 | B15 | 122 / 124 | braunes Kurzhaar, blaues Oberteil. B10 hellgraue Schürze (größte Fläche), B15 blauer Kittel |
| R01 | B24 | 134 / 134 | Bart und Mütze in beiden. R01 schwarze Jacke, braune Hose. B24 hellblauer Mantel, schwarze Hose |
| R12 | B24 | 134 / 134 | schwarze Hose in beiden. R12 dunkle Weste mit Brille, B24 hellblauer Mantel mit Bart |
| BW | R06 | 120 / 120 | braune Hose in beiden. BW graue Weste, weiße Haare und Brille. R06 navy Jacke und Dreitagebart-Schatten |
| R05 | R10 | 128 / 130 | blondes Kurzhaar. R05 navy Blazer und Brille, R10 hellblaues Shirt und ockerfarbene Latzhose |
| R14 | R15 | 120 / 120 | Oberteil und Hose vertauscht (R14 navy Weste und dunkelrote Hose, R15 dunkelroter Blazer und navy Jeans). R14 voller Bart, R15 welliges Langhaar |
| R14 | R20 | 120 / 116 | ähnliches navy Oberteil mit grauem Hemd. R14 voller Bart, R20 Zopf und orangefarbenes Halstuch |
| R18 | R13 | 110 / 112 | beide navy. R18 Kleid mit nackten Beinen, R13 Hosenanzug. Lockiges offenes Haar gegen Pferdeschwanz |
| R11 | R13 | 106 / 112 | lang offenes Haar gegen Pferdeschwanz. R11 graue Jeans, R13 navy Hose |
| B27 | R13 | 118 / 112 | dunkler Dutt gegen Pferdeschwanz. B27 ockerfarbener Pullover, R13 navy Blazer |

## 6. Hinweise (kein Verstoß, nicht gezählt)

- H1 · B12 (als Frau geführt): trägt einen braunen Bart. Bart ist frei erfindbar, wirkt aber männlich. Vorschlag: Bart entfernen.
- H2 · B32 (Frisur `kurz`): im Bild ein kleiner Haarknoten auf dem Kopf. Vorschlag: Frisur angleichen.
- H3 · B34 (Kopfbedeckung `mütze`): im Bild ein dunkles Band über blondem Haar, keine Mützenkrone. Vorschlag: Mütze zeichnen oder Datensatz angleichen.
- H4 · R02: Haar im Bild nahe Schwarz, Datensatz dunkelgrau. Kein Regelverstoß.
- H5 · Im Datensatz genannte Merkmale, die im Bild nicht zu erkennen sind: R05 Kugelschreiber, R10 Bleistift, R11 Stirnlampe, R13 Brosche, B15 Laterne, B17 Kehrbesen, B40 Schaufel. Kein Regelverstoß.

## 7. Gesamturteil

Abnahme: **nein**. Der einzige Grund ist V1 (R19, Bart). Keine verwechselbaren Paare. Die Grenzfälle B14/B20 und B22/B40 stehen zur Entscheidung, blockieren die Abnahme aber nicht. Nach Klärung von V1 ist das Bild abnahmefähig.

Figurenstand 2f77614620
ERGEBNIS · Paare: 0 · Verstöße: 1 · Karten 850245deb6

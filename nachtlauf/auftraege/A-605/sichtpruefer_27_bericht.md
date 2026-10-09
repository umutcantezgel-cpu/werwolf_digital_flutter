# Sichtprüfung A-605y · sichtpruefer_27

**Auftrag:** A-605y (gilt auch für A-605z) · **Prüfer:** sichtpruefer_27 · **Bild:** `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px, 66 Figuren, je Vorder-, Seiten- und Rückansicht)

**Schritt 0:** `git merge --ff-only nachtlauf/burgstadt` im Worktree, Fast-Forward von e7e4219 auf e13255f. Andere Prüfberichte nicht gelesen, Ordner A-605 nicht durchsucht.

**Datenquellen (nur gelesen):** `packages/pixel_engine/data/figuren/rollen.json` (21 Figuren BW, R01–R20), `packages/burgstadt_core/data/stadt/bewohner.json` (B01–B44), `packages/pixel_engine/lib/src/palette.dart` (160 Farben).

**Figurenstand:** add31ccee3 (`dart run tool/hd_abnahme.dart --figurenstand`; das Werkzeug gab zusätzlich Meldungen „Running build hooks“ aus, getrackte Dateien blieben unverändert).
**Karten-Stand:** 88600ae6c9 (`git hash-object packages/pixel_engine/data/figuren/karten.json`).

## Ergebnis

- Verwechselbare Paare: **0**
- Regelverstöße: **0**
- Grenzfälle (nicht als Paar gezählt): **3** (G1 bis G3)
- Abnahme: **ja**, mit den Hinweisen unter Grenzfälle und Beobachtungen

## 1. Verwechselbare Paare

| ID | ID | Warum | Vorschlag zur Unterscheidung |
|---|---|---|---|
| – | – | Kein geprüftes Paar erfüllt alle Bedingungen aus 5a | – |

Maßstab 5a, angewendet: verwechselbar nur bei gleicher Gesamtsilhouette (Größe Δ < 8 px, gleiche Kleidungsform, gleiche Kopfform mit Frisur oder Kopfbedeckung, gleiches großes Zubehör) UND gleichen Hauptfarben (Oberteil und Hose/Rock). Unterscheidbar sind Paare mit deutlich anderer Kopfbedeckung oder Frisur, einem Größenunterschied ≥ 8 px oder einer großen Farbfläche in anderer Farbfamilie.

## 2. Grenzfälle (nicht als Paar gezählt)

| Nr | Paar | Gleich | Unterschied | Vorschlag |
|---|---|---|---|---|
| G1 | R13 – R18 | Größe 112 / 110 px; beide schlank, dunkles Haar, dunkle Navy-Töne | R13 Hosenanzug bis zum Schuh, Pferdeschwanz. R18 Kleid mit nackten Beinen, schulterlanges Haar | R18 Kleid in hellerem Blau oder mit Gürtel; bei R13 die Revers-Brosche auffälliger machen |
| G2 | B01 – B43 | Größe 114 / 108 px; beide ältere Frauen, helles Kurzhaar, langes Kleid, nackte Beine | B01 braunes Kleid mit großer grauer Schürze. B43 dunkelrotes Kleid mit ockerfarbenem Umhang, Brille, Haarband | B43 Kleid in eine helle Farbfamilie (bernstein) setzen, oder B01 ohne Schürze |
| G3 | B12 – B32 | Größe 112 / 112 px; beide schlanke Frauen, dunkles Kurzhaar ohne Kopfbedeckung, dunkle Hose | B32 ockerfarbene Schürze bis zum Knie und orangefarbene Ärmel, Haar schwarz (B12 braun) | B12 Haar heller, oder B32 Schürze in holz- oder blauem Ton |

## 3. Regelverstöße

Keine. Geprüft:

- **Grün (Regel 5):** Grüne Pixel (Palettenrampe 5) kommen im gesamten Bild nur bei R03 (Strickjacke) und R04 (Pullover) vor.
- **Braune Schaftstiefel mit dicker Sohle:** nur R03 und R04 (Wanderstiefel, laut Datensatz). R05, R09 und R16 haben braune Halbschuhe ohne Schaft, das ist kein Verstoß. Alle übrigen Schuhe und Stiefel sind schwarz, dunkelgrau, navy oder dunkelrot. Geprüft in vergrößerten Unterschenkel-Ausschnitten aller 66 Figuren.
- **Kleiderfarben wie im Datensatz:** Alle 151 Angaben ohne Schuhe (rollen.json: Haar, Oberteil, Unterteil; bewohner.json: Kleidung) erscheinen exakt im Sprite, jeweils mit mindestens 12 Pixeln. Die Darunter-Kleidung der Rollen ist meist verdeckt und nicht gezählt. Einzige Abweichung ist R12-Halbschuh (8 Pixel). Schuhe sind laut Auftrag frei erfunden, kein Verstoß.
- **Gegenstände aus K9 §8:** Kein Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer oder Zettel erkennbar. B15 hält eine Laterne (im Datensatz benannt, keine Stablampe). Papierobjekte aus dem Datensatz (u. a. Zeitung bei B28, Ladeliste bei B39, Notizbücher und Mappen) sind im Bild nicht als lose Zettel lesbar. Bitte gegen K9 §8 abgleichen.
- **Klischees, Film- und Spielkopien, Alkohol, Blut:** nichts erkennbar. DET hat steinfarbenen Mantel, rote Bommelmütze und roten Schal.
- **Pixeldichte:** Bei allen 66 Figuren dieselbe Pixelblockgröße (häufigste Lauflänge 2 Pixel).

## 4. Punkt 16: Rollen (Haar, Frisur, Bart) und Hut mit langem Mantel

Rollen gegen rollen.json. Haarfarbe exakt im Sprite, Frisur und Bart in der Vergrößerung:

- BW: kurzes weißes Haar, weißer Bart, Brille. Stimmt.
- R01: kurz, Bart kurz, graue Mütze. Stimmt.
- R02: lang-offen, kein Bart. Stimmt.
- R03: schulterlang, kein Bart. Spange kaum erkennbar. Stimmt.
- R04: kurz, kein Bart. Stimmt.
- R05: Bob, Brille, kein Bart. Stimmt.
- R06: kurz, Bartstoppel. Stimmt.
- R07: kurz-locken, heller Ton. Stimmt.
- R08: Dutt, kein Bart. Stimmt.
- R09: kurz, kein Bart. Stimmt.
- R10: kurz (Pixie), kein Bart. Stimmt.
- R11: lang-offen, kein Bart. Stimmt.
- R12: kurz, Brille, heller Ton. Stimmt.
- R13: Pferdeschwanz, kein Bart. Stimmt.
- R14: kurz, voller Bart, dunkler Ton. Stimmt.
- R15: lang-offen, wellig. Stimmt.
- R16: kurz, zurückgekämmt, grau melierter Bart. Stimmt.
- R17: kurz, dunkler Bart, brauner Lederhut, dunkler Ton. Stimmt.
- R18: schulterlang, kein Bart. Stimmt.
- R19: kurz, heller Ton, Kinnbart nur schwach erkennbar (dunkler Kinnfleck). Weitgehend stimmt.
- R20: Zopf, keine Kapuze auf dem Kopf (E55). Stimmt.
- DET: rote Bommelmütze, roter Schal, steinfarbener Mantel. Stimmt.

Hut mit langem Mantel, alle unterscheidbar:

- B22 gegen B40: beide navyblauer Hut, langer Mantel, graues Haar. B22 ockerfarbener Mantel mit Bart. B40 dunkelbrauner Mantel ohne Bart.
- B16 gegen DET: B16 navyblauer Hut, grauer Mantel, brauner Rock, nackte Beine. DET rote Mütze, Hose. Kopf und Beine unterscheiden.
- B24 gegen B06: beide hellblaues Oberteil. B24 langer Mantel, schwarze Hose, navyblaue Mütze. B06 kurze Jacke, braune Hose, graue Mütze.
- B37 gegen B18: beide langer rötlicher Mantel. B37 langes graues Haar, B18 Glatze. Größe 132 gegen 120 px.
- B03 gegen B16: beide grauer langer Überwurf. B03 weiße Haube mit Zöpfen, blaue Schürze. B16 navyblauer Hut.
- R17 gegen B40: beide Hut. R17 brauner Lederhut, rostrote Jacke. B40 navyblau, langer Mantel.

## 5. Geprüfte Nahpaare (Vorprüfung)

Vorprüfung: Größe Δ < 8 px und Oberteil wie Unterteil mit ΔE76 < 16 (Sprite-Farben). Ergebnis: 22 Paare. Alle 22 sind durch Kopf, Kleidungsform oder Farbe unterscheidbar.

| Paar | Δ Größe (px) | Unterscheidendes Merkmal |
|---|---|---|
| B14 – B37 | 4 | Mütze gegen langes graues Haar; Weste mit Hemd gegen langen Mantel |
| B08 – B34 | 2 | Hut mit weißem Bart gegen gelbes Haar mit Bart; Hose dunkelrot gegen dunkelbraun |
| R07 – B40 | 6 | lockiges Haar gegen Hut; Jacke gegen langen Mantel |
| B02 – B15 | 2 | Mütze gegen kein Kopfschmuck; bernsteinfarbene Ärmel |
| B12 – B25 | 2 | Hose gegen Rock mit nackten Beinen; Kurzhaar gegen Zopf |
| B17 – B20 | 6 | bernsteinfarbene Jacke gegen dunkelrote Jacke; Bart bei B17 |
| BW – B39 | 2 | weißes Haar mit Bart und Brille gegen dunkles Lockenhaar mit Mütze; Hose braun gegen dunkelrot |
| B14 – B44 | 6 | Mütze gegen graues Haar mit Bart; Hose navy gegen dunkelbraun |
| R07 – B19 | 6 | Hose gegen Kleid mit nackten Beinen; kurzes gegen langes rotes Haar |
| R14 – R20 | 4 | Vollbart gegen Zopf; Hose dunkelrot gegen dunkelbraun |
| B30 – B40 | 4 | kein Hut gegen Hut; Jacke gegen langen Mantel |
| R13 – B43 | 4 | Hose gegen Kleid mit nackten Beinen; Navy gegen Dunkelrot |
| B32 – B33 | 2 | schwarzes gegen weißes Haar; Hose gegen nackte Beine unter bernsteinfarbenem Kleid |
| R10 – B04 | 4 | Latzhose gegen langen Mantel; senfgelbe Beine gegen dunkle Stiefel |
| B21 – B39 | 6 | Rock mit nackten Beinen gegen Hose; blonde Locken gegen dunkles Haar mit Mütze |
| R20 – B21 | 4 | Hose gegen Rock mit nackten Beinen; brauner Zopf gegen blonde Locken |
| R18 – B21 | 2 | dunkles gegen blondes Haar; Navy gegen Grau |
| B20 – B40 | 2 | Mütze gegen Hut; Jacke gegen langen Mantel |
| R07 – B20 | 4 | Locken gegen Mütze; braune gegen dunkelrote Jacke |
| B17 – B40 | 4 | Mütze gegen Hut; bernsteinfarben gegen braun |
| B29 – B32 | 6 | blonde Zöpfe gegen schwarzes Kurzhaar; graue Jacke gegen orangefarbenes Hemd mit Schürze |
| R15 – B18 | 0 | lange Locken gegen Glatze |

Weitere Paare, die auffielen und geprüft wurden: B06 – B35 (Mütze gegen Haar, Größe 134 px, hellblaue Jacke gegen mittelblauen Kittel), B22 – B40 (siehe Punkt 4), R17 – B36 (gleiche rostrote Jacke, Größe 128 px, Hut gegen keinen, braune gegen navyblaue Hose), B41 – R09 (grauer gegen weißer Oberkörper, orangefarbene gegen navyblaue Schürze).

## 6. Beobachtungen (kein Regelverstoß)

- Bewohner mit „kurz“ im Datensatz zeigen am Hinterkopf einen Knoten oder längeres Haar: B12, B15, B30, B35. Bitte gegen die Frisur prüfen.
- B01 und B44: graues Kurzhaar wirkt wie eine Kopfbedeckung oder ein Helm (Datensatz: keine Kopfbedeckung). B43 trägt ein sichtbares Haarband.
- B34: Mütze nur am dunklen Band lesbar.
- Haar- und Bartfarbe der Bewohner stehen im Datensatz nur als Wort, deshalb nicht exakt prüfbar.

## 7. Methode

- Zerlegung mit PIL: 8 Zeilen zu je 9 Figuren (letzte Zeile 3), je drei Ansichten. Vergrößerung ×3 für Paare und Köpfe, ×4 für die Beine. Fernsicht-Test über die Übersicht im halben Maßstab und über Silhouette und Farbflächen.
- Alle 55 721 geprüften Vordergrundpixel sind exakt Palettenfarben (100 %). Zuordnung Datenstufe s zu Palettenindex Rampe·16 + 2s + 1.
- Größe: Bounding-Box-Höhe der Vorderansicht inkl. Kopfbedeckung.
- Farbe: Abstand ΔE76 im Lab-Raum. Die Vorprüfung nutzt Sprite-Farben als Auswahl, die Einzelbewertung stützt sich auf Datensatz und Bild.
- Keine Daten geändert, kein Commit, kein Push, kein Build, kein Testlauf.

## 8. Abnahme

Abnahme: **ja**. Keine verwechselbaren Paare nach 5a, keine Regelverstöße, Punkt 16 erfüllt. G1 bis G3 und die Beobachtungen in Punkt 6 sind Hinweise für den Autor, keine Pflichtänderungen.

Figurenstand add31ccee3
ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten 88600ae6c9

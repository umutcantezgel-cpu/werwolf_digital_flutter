# Sichtprüfung A-605n · sichtpruefer_16

**Auftrag:** A-605m/n, Sichtprüfung der Figuren-Aufstellung (66 Figuren)
**Prüfer:** sichtpruefer_16
**Datum:** 2026-10-09
**Worktree:** /home/user/werwolf_digital_flutter/.claude/worktrees/agent-a1b5156323ab8756e

**Schritt 0:** `git merge --ff-only nachtlauf/burgstadt` im Worktree. Fast-forward fb0ec24..2e459d4, HEAD gleich nachtlauf/burgstadt (2e459d4).

## Ergebnis

| Punkt | Befund |
|---|---|
| Verwechselbare Paare (Maßstab 5a) | 0 |
| Regelverstöße (Katalog 5) | keine (0) |
| Grenzfälle, nicht als Paar gezählt | 4 (Abschnitt 3) |
| Abgleich mit dem Datensatz, ohne Regelbezug | 3 Abweichungen: B14, B34, B39 (Abschnitt 5) |
| Gesamturteil | Abnahme ja, mit Vorbehalt zu den Grenzfällen und zu B14, B34, B39 |

## 1. Grundlage und Vorgehen

- Bild: /home/user/werwolf_digital_flutter/.claude/worktrees/agent-a1b5156323ab8756e/nachtlauf/bilder/phase3/figuren_aufstellung.png (2952 × 1504 px). Zerlegt in 198 Sprites, je Figur Front, Seite und Rücken. Zuordnung über die Beschriftung unter jeder Figur (BW, DET, R01–R20, B01–B44), in den Ausschnitten einzeln gelesen.
- Nur gelesen: `packages/pixel_engine/data/figuren/rollen.json`, `packages/burgstadt_core/data/stadt/bewohner.json`, `packages/pixel_engine/lib/src/palette.dart`. Andere Prüfberichte nicht gelesen, `nachtlauf/auftraege/A-605/` nicht durchsucht.
- Pixelprüfung: Alle 471.288 Figurpixel liegen exakt auf der 64-Farben-Palette. Alle Figuren sind auf einem 2-px-Raster gezeichnet (alle Sprite-Maße gerade, häufigste Lauflänge 2 px).
- Sichtprüfung: Ausschnitte mit Nearest-Neighbour-Vergrößerung (×2 bis ×9), Kontaktbögen aller Front-Ansichten, Füße, Taille und Hände, Köpfe, dazu Vergleichsbögen für die Grenzfälle.
- Maßstab 5a, operationalisiert (Einschätzung für 5–8 m bei 1/3-Skalierung):
  - **Größe:** Höhe der Frontansicht in Pixeln der Aufstellung. Differenz ≥ 8 px = unterscheidbar.
  - **Statur:** Breite der Frontansicht. Differenz ≥ 8 px = unterscheidbar.
  - **Kopf:** Kopfbedeckung (keine, Mütze, Hut, Haube, Kapuze) und Frisurform. Unterschied in einem der beiden = unterscheidbar. Haarfarbe liegt nicht im Maßstab.
  - **Kleidungsform:** Oberteil (Mantel, Jacke, Weste, Bluse, Kleid, Kittel, Overall), Unterteil (Hose, Rock, Kleid, Overall), Schürze, großes Zubehör (Umhang, Regenschirm, Gehstock). Abweichung = unterscheidbar.
  - **Hauptfarben:** dominante Farbe im Oberteil- und im Unterteilbereich. Gleiche Farbfamilie heißt gleiche Palettenrampe mit Stufen-Differenz ≤ 2. Andere Rampe oder Stufen-Differenz ≥ 3 = unterscheidbar.
  - **Grenzfall:** alle Kriterien gleich bis auf eine knappe Abweichung (Größe genau 8 px, Farbfamilie nur über sehr dunkle oder sehr helle Töne, oder ein kleines Detail).
- Prüfung: alle 2145 Paare maschinell gegen diese Kriterien geprüft, die nächstliegenden Paare zusätzlich in Vergleichsbögen gesichtet. Empfindlichkeit: Auch mit Farbtoleranz ±3 Stufen, mit zusammengefassten Oberteilformen oder mit ignorierter Frisur entsteht kein Paar.

## 2. Verwechselbare Paare

Keine. Kein Paar erfüllt alle Kriterien (Größe, Statur, Kopf, Kleidungsform, Zubehör und Hauptfarben).

| ID | ID | warum | Vorschlag zur Unterscheidung |
|---|---|---|---|
| – | – | keine | – |

## 3. Grenzfälle (nicht als Paar gezählt)

| ID | ID | Gleich | Entscheidender Unterschied | Vorschlag (Datensatz abstimmen) |
|---|---|---|---|---|
| R06 | R16 | Größe 122/128 (Δ 6), Statur 36/40 (Δ 4), kein Kopfschmuck, kurzes Haar, Unterteil identisch (braune Hose, Stufe 4) | Oberteil sehr dunkel: Marineblau (blau 0–1) gegen Anthrazit (neutral 2–4). R16 mit grauem Bart. | R16-Sakko hellgrau (neutral 6) oder R06-Jacke auf Stufe 3 |
| B06 | B28 | Größe 134/130 (Δ 4), Statur 44/40 (Δ 4), beide Mütze, Unterteil identisch (dunkelrot) | Oberteil hellblau (blau 6) gegen hellgrau (neutral 6). Mütze blau gegen braun. | B28-Jacke in Bernstein oder Holz, oder B06 mit Hut statt Mütze |
| R17 | B40 | Größe 130/128 (Δ 2), Statur 36/40 (Δ 4), beide braune Hüte, Oberteil rostrot (rot 4), Hose braun | Jacke bis zur Hüfte (R17) gegen Mantel bis zum Knie (B40). R17 mit Bart und Hutfeder. | B40-Mantel auf Hüftlänge oder R17-Jacke in Steinton |
| BW | R16 | Statur 40/40, Kopf kurz, Hose braun (Stufe 4) | Größe 120/128 (Δ 8, genau am Schwellenwert). Weste mit hellen Ärmeln (BW) gegen Sakko mit dunklen Ärmeln (R16). Haar weiß gegen dunkel (nicht im Maßstab). | Größe von R16 auf mindestens 130 px oder BW auf höchstens 118 px (Größe ist frei) |

Nahe, aber unterscheidbar (kein Paar, zur Kenntnis):
- B06 / B08: gleiche Kleidung im Datensatz (Jacke blau/6, Hose rot/2). Größe Δ 14, Mütze gegen Hut.
- R01 / R16: fast gleiche Garnitur (dunkle Jacke, braune Hose), Größe Δ 6. R01 trägt eine Mütze, R16 nicht.
- B34 / B42: gleiche hellblaue Jacke. Hose braun gegen schwarz.

## 4. Regelprüfung (Katalog 5 und Leitplanken 9)

| Regel | Befund | Verstoß |
|---|---|---|
| 5: Grün nur R03 und R04 | Grüne Palettenfarben nur bei R03 (Front 768, Seite 344, Rücken 856 Pixel) und R04 (Front 1152, Seite 464, Rücken 1152). Keine andere Figur. | nein |
| 5: Wanderstiefel (braune Schaftstiefel, dicke Sohle) nur R03 und R04 | Braune Schaftstiefel nur bei R03 und R04 (Füße aller 66 Figuren bei ×5 geprüft, Kandidaten bei ×8). Ohne Verstoß: R05 trägt braune Halbschuhe ohne Schaft (Datensatz: Halbschuhe). Kurze dunkelbraune bis dunkelrote Schuhe ohne Schaft bei R16, R17, B16, B22, B25, B28. Blaue und schwarze Stiefel sind keine Wanderstiefel. | nein |
| 5: Kleiderfarben wie im Datensatz | Alle Kleidungsstücke mit Datenwert stimmen mit dem Bild überein (Abweichung ≤ 2 Stufen, Schattierung). Geprüft: B01–B44 alle Kleidungsangaben, BW und R01–R20 Oberteil und Unterteil. Schal und Umhang (B13, B19, B33, B43) liegen am Rand der Mittelbahn und wurden visuell bestätigt. | nein |
| 5: Keine K9-§8-Gegenstände | Keine Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer oder Zettel erkennbar. Hände, Taille und Hüfte geprüft (×5 alle Figuren, ×8 Kandidaten). Sichtbar sind nur Alltagsgegenstände: Gehstock (B08), Regenschirm (B16), Nähkorb (B18), Häkelbeutel (B33), Eimer (B35), Gießkanne (B31), Taschen (B09, B26), Kamera am Gurt (R19). | nein |
| 5: Keine Film-/Spiel-Kopien, keine Klischees | Keine erkennbare Kopie bekannter Figuren. Keine Vampir-, Hexen-, Teufels- oder Walpurgis-Motive. Keine Herkunfts-Requisiten oder Klischee-Kleidung. Hautton ist nicht als Merkmal eingesetzt. Einschätzung. | nein |
| 5: Alle Figuren in derselben Pixeldichte | 198 von 198 Sprites auf dem 2-px-Raster, Palette exakt. | nein |
| 9: Leitplanken | Keine Flaschen, Gläser, Krüge oder Ähnliches. Kein Blut. Keine sichtbare Verletzung (BW ohne Beule und ohne Kühlpack im Bild). | nein |

Regelverstöße gesamt: keine (0).

DET entspricht der Beschreibung: steinfarbener Mantel, rote Bommelmütze, roter Schal.

## 5. Abgleich mit dem Datensatz (ohne Regelbezug, nicht als Verstoß gezählt)

- **B14:** Datensatz Kopf „mütze“, Haar grau. Bild: keine Mütze, Haar rotorange.
- **B34:** Datensatz Kopf „mütze“, Haar blond. Bild: keine Mütze, Haar braun, gelblicher Streifen am Kinn.
- **B39:** Datensatz Kopf „mütze“, Haar braun, kraus. Bild: keine Mütze, Haar rotorange, kraus.

Nicht gewertet: Zubehör aus dem Datensatz, das im Bild nicht erkennbar ist (z. B. B15 Laterne). R20 hat eine graue Kapuze am Kopf. Der Datensatz nennt „Kapuze des grauen Pullis“, das passt.

## 6. Nebenbefund (keine Regel)

- Westen werden bei B02, B11, B39, B44 und R12 als runde Fläche gezeichnet. Bei 5–8 m liest sich das eher als Fleck denn als Weste. Umrisse prüfen.

## 7. Gesamturteil

Abnahme ja. Keine verwechselbaren Paare und keine Regelverstöße. Zur Entscheidung des Auftraggebers bleiben offen: die vier Grenzfälle aus Abschnitt 3 und die drei Datenabweichungen B14, B34, B39. Falls der Datensatz für Kopfbedeckung und Haarfarbe bindend ist, sind B14, B34 und B39 bis zur Anpassung nicht abnahmefähig.

## 8. Dateihoheit

Geschrieben wurde nur diese Berichtsdatei. Ausschnitte und Hilfsskripte liegen im Scratchpad, nicht im Repository. Kein git commit, kein git push, kein Build.

ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten e4624201af

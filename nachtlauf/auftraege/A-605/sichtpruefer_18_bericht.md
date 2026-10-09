# Sichtprüfung A-605p · sichtpruefer_18

**Basis.** Worktree `/home/user/werwolf_digital_flutter/.claude/worktrees/agent-aa0bcd570c363b414`. Schritt 0 `git merge --ff-only nachtlauf/burgstadt` ausgeführt: Fast-Forward fb0ec24..3092813, HEAD = nachtlauf/burgstadt = 3092813. Geprüft wurde `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px, 66 Figuren mit Front, Seite und Rücken). Datenquellen nur gelesen: `packages/pixel_engine/data/figuren/rollen.json`, `packages/burgstadt_core/data/stadt/bewohner.json`, `packages/pixel_engine/lib/src/palette.dart`. Kartenstand per `git hash-object packages/pixel_engine/data/figuren/karten.json` = 901192c46385…, Kürzel 901192c463. Keine anderen Prüfberichte gelesen, `nachtlauf/auftraege/A-605/` nicht durchsucht. Kein Commit, kein Push, kein Build.

**Vorgehen.** Figuren über Pixel-Zusammenhangskomponenten je Ansicht abgegrenzt. Höhe = Kopf bis Sohle in Bildpixeln der Front-Ansicht. Alle 493 152 Vordergrundpixel sind exakte Palettenfarben. Montagen aller 66 Figuren (×3), Ausschnitte für Hände, Hüften, Füße und Köpfe (×5 bis ×6). Paarprüfung über alle 2 145 Paare: Größe, Kopf, Kleidungsform, große Zusatzflächen und Hauptfarben von Oberteil und Hose/Rock.

**Angewandter Maßstab (Arbeitsdefinitionen).**
- Größe: |Δ Höhe| ≥ 8 px macht unterscheidbar.
- Kopf: andere Kategorie (Hut, Mütze, Haube, Glatze, Dutt, Zopf, Locken, lang, kurz, Pferdeschwanz) ist deutlich.
- Kleidungsform: Oberteil-Typ (Jacke, Mantel, Weste, Kittel, Bluse, Kleid) und Unterteil (Hose, Rock, Kleid). Schürze und Umhang zählen als große Zusatzfläche.
- Hauptfarben: gleiche Palettenrampe und CIE76-ΔE ≤ 12 gelten als gleich. Größere Abweichung ist eine große Fläche in anderer Farbfamilie.
- Grenzfall: ein Paar, das nur in einem kleinen Detail abweicht, oder dessen Größendifferenz genau an der Schwelle von 8 px liegt.

## 1. Verwechselbare Paare

Keine (0). Kein Paar erfüllt Größe, Kopf, Kleidungsform, große Zusatzflächen und Hauptfarben zugleich.

## 2. Grenzfälle (zählen nicht als Paar)

| Paar | Δ Höhe | Gemeinsam | Trennendes Merkmal | Vorschlag |
|---|---|---|---|---|
| R17 – B40 | 2 px (130 / 128) | Hut; Oberteil identisch (Rostton, ΔE 0); Hose braun (ΔE 10) | B40 trägt einen langen Mantel bis zum Oberschenkel, R17 eine kurze Jacke mit blauen Hüfttaschen. R17 hat einen bernsteinfarbenen Bart, B40 keinen. Hutfarbe braun (R17) gegen orangerot (B40). | Mantellänge von B40 und Bart von R17 als Merkmale behalten. Hutfarbe nicht angleichen. |
| R05 – R12 | 8 px, genau an der Schwelle (126 / 134) | Brille bei beiden; dunkles Oberteil (Sakko navy / Weste anthrazit, ΔE 10); dunkle Hose (ΔE 11) | Höhe genau 8 px. R05 blonder Bob, R12 dunkles Kurzhaar. R12 zeigt hellblaue Hemdärmel unter der Weste. | Höhenabstand auf mindestens 10 px erhöhen oder die blauen Ärmel von R12 als Erkennungszeichen nutzen. |
| R20 – B11 | 8 px, genau an der Schwelle (118 / 110) | Zopf bei beiden; Oberteil navy Weste (ΔE 0); Beinkleidung dunkelrot (ΔE 0) | B11 trägt einen Rock mit nackten Beinen, R20 eine Hose. B11 hat gelbe Blusenärmel, R20 graue Kapuzenärmel und einen orangen Schal. | Höhenabstand auf mindestens 10 px erhöhen. Rock mit nackten Beinen bei B11 beibehalten. |

## 3. Nahfälle (unterscheidbar, nur Kurzbegründung)

| Paar | Δ Höhe | Entscheidender Unterschied |
|---|---|---|
| B29 – B41 | 0 | Schürze grau (B29) gegen orange (B41), große Fläche (ΔE 65). Haar blond gegen braun. |
| B13 – B33 | 2 | Kleid braun (B13) gegen grau-braun (B33), ΔE 21. B13 bernsteinfarbener Umhang, B33 blauer Schal. |
| B04 – B30 | 6 | B04 langer Mantel gegen B30 Jacke. Hose dunkelgrau (B04) gegen schwarz (B30), ΔE 22. |
| B14 – B20 | 6 | Oberteil orange (B14, Weste rot5) gegen Senfgelb (B20, Jacke bernstein4), ΔE 25. Mützen orange gegen blaugrau. |
| R20 – B27 | 6 | R20 Oberteil zweifarbig (navy Weste, graue Kapuze), B27 einfarbig Blau (ΔE 24). Zopf gegen langes Haar. |
| BW – B12 | 2 | Oberteil warmgraue Weste (BW) gegen hellgraues Hemd (B12), ΔE 26. BW hat weißes Haar und Bart. |
| DET – B24 | 6 | Mantel warmgrau (DET) gegen hellgrau (B24), ΔE 26. DET trägt rote Bommelmütze und roten Schal. |
| B28 – B06 | 4 | Jacke hellgrau (B28) gegen hellblau (B06), ΔE 17. Hosen gleich (rot2). |
| B16 – B26 | 4 | B16 Rock mit nackten Schienbeinen gegen B26 Hose mit Stiefeln. Hut orange gegen navy. |
| B09 – B25 | 6 | B09 Hose gegen B25 Rock mit nackten Beinen. Oberteil bernstein5 gegen bernstein3, ΔE 29. |
| B01 – B13 | 4 | Dutt (B01) gegen Haube (B13). B01 graue Schürze gegen B13 bernsteinfarbenen Umhang. |
| B04 – B18 | 6 | B04 graues Kurzhaar gegen B18 kahler Kopf. Mantel bernstein5 gegen bernstein3, ΔE 29. |
| R01 – DET | 8, Schwelle | Jacke schwarz (R01) gegen Mantel warmgrau (DET), ΔE 37. Graue Mütze gegen rote Bommelmütze. |
| B08 – B40 | 8, Schwelle | Jacke hellblau (B08) gegen Mantel rostrot (B40), ΔE 72. |
| B32 – R10 | 0 | Farben vertauscht: B32 Oberteil senf und blaue Schürze, R10 blaues Oberteil und senfgelbe Latzhose. |

## 4. Regelverstöße

Keine (0). Geprüft:
- **Grün (Rampe 5):** nur R03 (768 Pixel) und R04 (1 152 Pixel). Alle anderen Figuren haben 0 Pixel dieser Rampe. Ocker-Bernstein-Töne wie der Mantel von B18 (94661A, Farbton ca. 37°) sind keine Oliv-Töne.
- **Wanderstiefel (braune Schaftstiefel mit dicker Sohle):** nur R03 und R04 (Wanderstiefel laut rollen.json, im Bild braune Stiefel). Braune Schuhe bei R05, R09 und R16 sind laut rollen.json Halbschuhe und im Ausschnitt ohne Schaft. Dunkelrote bis schwarze Schuhe (u. a. B01, B16, B21 bis B23, B25, B28) sind keine braunen Stiefel.
- **Kleiderfarben der Bewohner (bewohner.json, B01 bis B44):** jede Datensatzfarbe der Kleidung kommt in der Figur exakt vor (Stufe exakt, alle Anzahlen > 0). Keine Abweichung.
- **Kleiderfarben BW und R01 bis R20 (rollen.json), DET (Auftragsbeschreibung):** alle sichtbaren Datensatzfarben stimmen. Unterhemden unter Jacken sind nicht sichtbar (R01, R06, R07, R08, R17). Das ist kein Verstoß.
- **Gegenstände aus K9 §8 (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel):** nicht erkennbar. Geprüft in den Montagen aller 66 Figuren und in Vergrößerungen (×5) der Hände, Hüften und Köpfe von B02, B11, B13, B15, B16, B17, B19, B20, B22, B24, B25, B26, B27, B28, B30, B31, B32, B33, B37, B39, B40, B42 sowie R11 und R19. Hinweis: das rotbraune Rechteck an der Hüfte von B39 (Ladeliste) wirkt wie ein Lederetui, Papier ist nicht erkennbar. Bitte bestätigen, falls ein Zettel gemeint ist.
- **Film- und Spielkopien, Klischees:** keine erkennbar.
- **Pixeldichte:** alle 66 Figuren liegen auf demselben 2-px-Raster (alle Farblängen geradzahlig, Modus 2 px).
- **Weitere Leitplanken:** keine Flaschen, Gläser, Blut oder Hexen-, Teufels- oder Walpurgismotive erkennbar.

Hinweise ohne Regelbezug:
- B02: die blaue Weste erscheint auf der Brust als runde Fläche. Die Form ist unklar.
- R11: das Merkmal "Rotlicht-Stirnlampe um den Hals" ist nicht gezeichnet. Das Merkmal "Saturn-Aufnäher" nennt eine reale Handelsmarke und ist im Bild nicht lesbar.

## 5. Gesamturteil

Paare: 0. Verstöße: 0. Grenzfälle: 3 (R17 – B40, R05 – R12, R20 – B11). Nahfälle: 14. **Abnahme ja** (keine Paare, keine Verstöße; Grenzfälle zur Kenntnis).

ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten 901192c463

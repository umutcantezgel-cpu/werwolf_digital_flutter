# Bericht A-605a/b · Sichtprüfung der Figuren-Aufstellung

- **Prüfer-ID:** sichtpruefer_1 (unabhängig erstellt; keine anderen Prüfberichte gelesen)
- **Geprüfte Datei:** `nachtlauf/bilder/phase2/figuren_aufstellung.png` (2952 × 1504 px, 65 Figuren, je Front, Seite, Rücken; IDs darunter)
- **Worktree:** `/home/user/werwolf_digital_flutter/.claude/worktrees/agent-a2c40fd63c74b38a9` (Stand `1cdfc49` nach `git merge --ff-only nachtlauf/burgstadt`)
- **Gegenprüfung (nur lesend):** `nachtlauf/KANON.md`, `packages/pixel_engine/data/figuren/rollen.json` (BW, R01–R20), `packages/burgstadt_core/data/stadt/bewohner.json` (B01–B44), `packages/pixel_engine/lib/src/palette.dart` (64 Farben, Rampe = Index div 8)

## Vorgehen

1. Sichtprüfung der Figuren in Dreier-Gruppen, 2× vergrößert (Nächste-Nachbar-Skalierung). Köpfe und Stiefel zusätzlich 6× bzw. 12× vergrößert.
2. Silhouetten: Überlappung (IoU) der Front-Ansichten für alle 2080 Figurenpaare, zusätzlich Farbabstand der Körperfarbe.
3. Farben: Abgleich der Kleiderfarben mit der Palette und den Datensätzen.

Grenze: Die Beurteilung erfolgt im Maßstab der Aufstellung (Sprites ca. 108 bis 134 px hoch), nicht im Spielmaßstab. Bei stark geschatteten Stellen ist die Farbzuordnung unsicher. Solche Fälle stehen gesondert unter 2.4.

## 1. Verwechselbare Paare (17)

Paare 1 bis 9 sind durch Silhouetten-Überlappung (IoU) und Farbabstand belegt. Paare 10 bis 17 sind Sichtbefunde.

| Nr. | ID | ID | Warum | Vorschlag zur Unterscheidung |
|---|---|---|---|---|
| 1 | B17 | B26 | Gleicher Schnitt (IoU 0,92): Tunika, Gürtel, Stiefel. Beide grauhaarig mit Kopfbedeckung (B17 Mütze, B26 Hut). Farbe rotbraun gegen braun (Abstand 24). | B26 laut Datensatz blaue Jacke (Rampe 6). B17 braune Jacke mit dunklem Overall. |
| 2 | B11 | B21 | Lange helle Gewänder (IoU 0,91). Beide blond. B11 zeigt zusätzlich eine kronenartige goldene Kopfform, im Datensatz ist keine Kopfbedeckung vorgesehen. | B11 Zopf deutlich zeigen, Farbe nach Datensatz (Bernstein-Weste, Holz-Rock). Kronenartige Form entfernen. |
| 3 | B07 | B19 | Lange Robe bzw. langes Kleid mit roten Haaren (IoU 0,91, Abstand 30). Im Bild gegenüber dem Datensatz vertauscht: B07 zeigt Rot, B19 zeigt Ocker. | Datensatz umsetzen: B07 Bernstein-Bluse und Holz-Rock, B19 rotes Kleid. Haarform (B07 Locken, B19 lang) als Unterschied behalten. |
| 4 | B23 | B33 | Lange Mäntel mit hellem Kopf (IoU 0,89, Abstand 44). | B33 laut Datensatz blaues Kleid. Weiße Haube als Kennzeichen behalten. |
| 5 | B17 | B42 | Fast gleiche Farbe (Abstand 12), gleicher Schnitt (IoU 0,87). | Gürtel und Schuhe (B17 gold, B42 schwarz bzw. weiß) und Kopf (grau gegen braun) behalten. B42 laut Datensatz graue Jacke, blaues Hemd. |
| 6 | B26 | B42 | Kittel mit weißen Knöpfen, ähnlicher Braunton (IoU 0,88, Abstand 32). | Gürtel (B26 gold, B42 schwarz) und Kopfbedeckung (B26 Hut) behalten. Farben nach Datensatz. |
| 7 | B09 | B40 | Braune Tunika mit schwarzem Gürtel (IoU 0,85, Abstand 29). | B40 roter Hut, warmgrauer Mantel (Datensatz: Stein 4). B09 Zopf als Kennzeichen. |
| 8 | B16 | B19 | Lange Robe, ähnliche Körperform (IoU 0,86, Abstand 40). | B19 lange rote Haare, B16 Hut. B16 Farbe nach Datensatz (roter Mantel, Rot 4). |
| 9 | B07 | B16 | Lange Robe in ähnlichen Brauntönen (IoU 0,84, Abstand 28). | B16 roter Mantel laut Datensatz. B07 Locken und Goldsaum als Kennzeichen. |
| 10 | B08 | B28 | Sichtbefund: gleicher Körper (grauer Kittel, schwarzer Gürtel, dunkle Hose, weiße Schuhe). | Im Datensatz vertauscht: B08 grauer Kittel mit brauner Hose, B28 brauner Kittel mit grauer Hose. Kopf (B08 Hut, B28 blaue Mütze) behalten. |
| 11 | B22 | B29 | Sichtbefund: gelbe Tunika mit schwarzem Gürtel und dunklen Beinen. | B22 laut Datensatz blauer Mantel. B29 mit roter Schürze und grauer Jacke. |
| 12 | B06 | B36 | Sichtbefund: dunkelblaue Jacke, schwarze Hose, schwarze Stiefel. | B06 Mütze kontrastfarben setzen. Schuhe für B06 und B36 im Datensatz festlegen (fehlen). |
| 13 | BW | B02 | Sichtbefund: stämmige Gestalt, Weste mit silbernen Schulterplatten, braune Hose und Stiefel. | BW durch weißes Haar und Brille kenntlich. B02 Stiefel ohne Datengrundlage streichen oder festlegen. |
| 14 | R01 | B37 | Sichtbefund: dunkle, bauschige Jacke mit grauem Kopfaufsatz. | R01 Mütze in Kontrastfarbe, oder B37 langes Haar betonen. |
| 15 | R18 | B01 | Sichtbefund: lange blaue Kleider, gleiche Farbfamilie. | R18 dunkles Haar und sichtbare Beine. B01 graues Dutt und bodenlange Robe. |
| 16 | R03 | R04 | Sichtbefund: beide grün, Jeans, braune Stiefel. Grün ist bei beiden zulässig, kein Verstoß. | Haare (R03 braun schulterlang mit Spange, R04 blond kurz) und Oberteil (dunkle Strickjacke gegen Fleece) betonen. |
| 17 | R11 | B27 | Sichtbefund: lange schwarze Haare, dunkle Oberteile. | R11 braune Stiefel gegen B27 dunkle Sneaker mit weißer Sohle. R11 Oberteil schwarz, B27 blau. |

## 2. Regelverstöße (27 Figuren)

### 2.1 Wanderstiefel-Anmutung (8 Figuren)

Regel: „Wanderstiefel nur R03 und R04“.

- R11, R12, R17, R20: Datensatz Typ `stiefel` (Rampe 2), also nicht `wanderstiefel`. Im Bild sind die braunen Schäfte mit dunkler Sohle von R03 und R04 nicht zu unterscheiden.
- B02, B04, B12, B44: Im Datensatz ist keine Schuhangabe vorhanden. Im Bild tragen sie braune Stiefel in derselben Form.

Kein Verstoß: R05, R09, R16 tragen braune Halbschuhe (`halbschuhe`, kürzer und flacher).

### 2.2 Laken-Anmutung (1 Figur)

- **B38:** Lange weiße Stoffbahn bis zum Boden, wirkt wie ein Laken (K9 §8 verbietet das Laken auf Figuren). Datensatz: Kleid Bernstein (Ocker) und helle Schürze. Das ockerfarbene Kleid ist im Bild nicht sichtbar.

### 2.3 Kleiderfarbe weicht vom O-Datensatz ab (18 Figuren)

Regel laut KANON: „Kleidung kommt nur aus O-Datensätzen.“ Datensatz in Klammern.

| ID | Datensatz (bewohner.json) | Bild |
|---|---|---|
| B07 | Bluse Bernstein, Rock Holz | dunkelrote Robe mit Goldsaum |
| B09 | Overall Neutral, Jacke Blau | braune Tunika |
| B10 | Schürze Holz, Hemd Neutral | blaue Tunika |
| B11 | Weste Bernstein, Rock Holz | helle graue Robe |
| B14 | Weste Holz, Hemd Neutral | hellblaue Tunika |
| B19 | Kleid Rot (Stufe 5), Schal Bernstein | ockerfarbenes Kleid |
| B22 | Mantel Blau, Hose Holz | gelbe Tunika, keine blaue Oberbekleidung |
| B24 | Mantel Neutral, Hose Holz | dunkelblaue Jacke und dunkelblaue Hose |
| B25 | Bluse Bernstein | dunkelblaue Robe, kein Bernstein sichtbar |
| B26 | Jacke Blau | braune Tunika |
| B29 | Jacke Neutral (grau) | goldgelbe Tunika, rote Schürze |
| B32 | Schürze Holz, Hemd Blau | helle graue Tunika |
| B33 | Kleid Blau, Schal Rot | goldgelbe Robe |
| B34 | Jacke Neutral, Hose Holz | blassgelbe Tunika, dunkle Hose |
| B40 | Mantel Stein (warmgrau) | tanfarbene Tunika |
| B41 | Schürze Blau | ockerfarbene Tunika, kein Blau |
| B42 | Jacke Neutral, Hemd Blau | rostorange Tunika |
| B43 | Kleid Blau (Stufe 2) | dunkelgraue Robe |

### 2.4 Zu prüfen, nicht gezählt

Die Abweichung ist sichtbar, aber die Farbe lässt sich nicht sicher bestimmen oder die Zuordnung ist uneindeutig.

- B08: Hose Holz laut Datensatz, im Bild dunkelgrau.
- B16: Mantel Rot laut Datensatz, im Bild dunkelbraun.
- B17: Jacke Holz laut Datensatz, im Bild rot. Gold-Gürtel und -Schuhe stehen nicht im Datensatz.
- B18: Mantel Stein laut Datensatz, im Bild schwarz. Gold-Gürtel und -Schuhe stehen nicht im Datensatz.
- B21: Bluse Rot laut Datensatz, nicht sichtbar.
- B28: Jacke Holz laut Datensatz, im Bild grau.
- B30: Jacke Holz laut Datensatz, im Bild ockerbraun.
- B31: Jacke Holz laut Datensatz, nicht sichtbar. Im Bild schwarze Robe.
- B35: Kittel Blau laut Datensatz, im Bild grau.
- B37: Hemd Blau laut Datensatz, nicht sichtbar.
- B39: Hose Holz laut Datensatz, im Bild schwarz.

### 2.5 Geprüft ohne Befund

- **Grün (nur R03, R04):** Einzige grüne Kleidung sind R03 (dunkelgrüne Strickjacke) und R04 (olivgrüner Fleece). Im Datensatz hat nur R03 und R04 die Rampe 5. Die grauen Töne von B04, B43, R01 und R16 sind entsättigt (grau bis warmgrau), nicht grün.
- **K9 §8 (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel):** Nicht erkennbar. Hinweise ohne Verstoß: R03 hat ein weißes Rechteck am Körper (Notizbuch laut Datensatz, kann auf Distanz wie ein Zettel wirken). B15 hat eine gelbe Laterne am Hüftgürtel (Datensatz: Laterne, nicht mit Stablampe verwechseln).
- **Alkohol und Drogen:** Keine Flaschen, Gläser oder ähnliche Gegenstände erkennbar.
- **Blut und Verletzungen:** Keine. Die hellen Stirnbänder von BW, R05 und R12 entsprechen Brillen laut Datensatz.
- **Hexen, Teufel, Walpurgis, Vampir:** Keine Hexenhüte, Hörner oder Vampir-Umhänge erkennbar.
- **Film-/Spiel-Kopien und Klischees:** Keine eindeutigen Befunde. B19 (lange rote Haare, lange Robe) wurde nicht als Klischee gewertet, die Farbe ist aber nach Datensatz zu prüfen (Punkt 2.3).
- **Pixeldichte:** Einheitlich. Alle Sprites liegen im selben Pixelraster. Die Höhenunterschiede (108 bis 134 px) entstehen durch Kopfbedeckung und Schuhe.
- **R01 bis R20 und BW:** Die Kleiderfarben stimmen mit `rollen.json` überein.

## 3. Gesamturteil

**Abnahme: nein.**

Begründung:
- 27 Verstöße: 8 Wanderstiefel-Anmutungen (2.1), 1 Laken-Anmutung (2.2), 18 Kleiderfarben gegen den Datensatz (2.3).
- 17 verwechselbare Paare. Davon 9 mit sehr hoher Verwechslungsgefahr (IoU ≥ 0,84 bei Farbabstand ≤ 46): Paare 1 bis 9.

Empfehlung in dieser Reihenfolge:
1. Die Aufstellung aus `bewohner.json` neu erzeugen und den Datenstand prüfen. Die Abweichungen in 2.3 betreffen fast nur B-Figuren, die R-Figuren stimmen.
2. Stiefel: Die Wanderstiefel-Form bleibt R03 und R04 vorbehalten. Andere braune Stiefel brauchen eine eigene Form oder Farbe. Für B02, B04, B12 und B44 die Schuhe im Datensatz festlegen oder ohne Stiefel darstellen.
3. B38: Kleid Bernstein statt weißer Robe.
4. Paare 1 bis 9 über die Datensatz-Farben trennen. Paare 10 bis 17 über Kopfbedeckung, Haar und Gürtel differenzieren und danach im Spielmaßstab nachprüfen.

Ich habe keine Dateien außer dieser Berichtsdatei geschrieben. Kein Commit, kein Push, kein Build.

AUFTRAG A-605 FERTIG · nachtlauf/auftraege/A-605/sichtpruefer_1_bericht.md · Paare: 17 · Verstöße: 27 · Abnahme nein

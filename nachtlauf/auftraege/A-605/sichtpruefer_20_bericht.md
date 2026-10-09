# Sichtprüfung Figuren-Aufstellung · Auftrag A-605r (sichtpruefer_20)

**Stand:** Worktree `/home/user/werwolf_digital_flutter/.claude/worktrees/agent-a708bb2c57cecbc86`, nach `git merge --ff-only nachtlauf/burgstadt` (fb0ec24 → 6f0d724).
**Geprüftes Bild:** `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px). 66 Figuren zu je Front, Seite, Rücken (198 Sprites), Kennungen darunter: BW, DET, R01–R20, B01–B44 (alle 66 gelesen).
**Datenquellen (nur gelesen):** `packages/pixel_engine/data/figuren/rollen.json`, `packages/burgstadt_core/data/stadt/bewohner.json`, `packages/pixel_engine/lib/src/palette.dart`, Auftrag `nachtlauf/auftraege/A-605q.md`. Andere Prüfberichte nicht gelesen, `nachtlauf/auftraege/A-605/` nicht durchsucht.
**Karten-Stand:** `git hash-object packages/pixel_engine/data/figuren/karten.json` = fc94af9295464e10208481e8343829b095889742.
**Hilfsdateien:** nur unter `scratchpad/s20/`. Kein Commit, kein Push, kein Build.

## Ergebnis in Kürze

- Verwechselbare Paare: **0**
- Grenzfälle (nicht als Paar gezählt): **2** (R01/R16, B06/B36)
- Regelverstöße: **0**
- Gesamturteil: **Abnahme ja**

## 1. Verwechselbare Paare

Keine. Keines der 2145 möglichen Paare erfüllt den Maßstab (Silhouette gleich und Hauptfarben gleich, ohne deutlichen Unterschied). Die beiden nächsten Fälle stehen unter 2.

| ID | ID | warum | Vorschlag zur Unterscheidung |
|---|---|---|---|
| – | – | keine verwechselbaren Paare | – |

## 2. Grenzfälle (nicht als Paar gezählt)

| ID | ID | Gemeinsam | Unterschied | Begründung |
|---|---|---|---|---|
| R01 | R16 | Höhe 134/132 px (Δ 2), Breite 40/40 px, Jacke + Hose, Oberteil Familie neutral, Unterteil holz (Stufe 3/4) | R01: graue Strickmütze, Kopf hell; R16: kurzes dunkles Haar mit grauem Bart, Kopf dunkel. Jacke fast schwarz (neu 1) gegen mittelgrauen Sakko (neu 4). Schuhe R01 dunkelgrau, R16 braun | Kein deutlicher Kopfunterschied (Mütze gegen kurzes Haar). Die Helligkeit unterscheidet sich innerhalb derselben Farbfamilie. Mehrere kleine Merkmale helfen beim Unterscheiden. Vorschlag: Mütze in Akzentfarbe oder Sakko heller bzw. dunkler anlegen. |
| B06 | B36 | Jacke bernstein 4, Hose rot 2, braunes kurzes Haar mit braunem Bart. Höhe 126/120 px (Δ 6) | B06: blaue Mütze, dunkelgraue Schulterriemen, weißer Gürtel, blaue Stiefel. B36: keine Mütze, graue Schuhe. Breite 44/36 px (Δ 8) | Höhe (Δ 6) und Breite (Δ 8) liegen unter den deutlichen Schwellen (siehe Methode). Mütze gegen Haar ist knapp. Vorschlag: Schulterriemen entfernen, damit die Breite zu B36 passt, oder Mützen- bzw. Schuhfarbe stärker absetzen. |

Hinweis: Würde der Auftraggeber beide Grenzfälle als Paar werten, ergäbe sich Paare: 2 und die Abnahme wäre nein.

## 3. Nahe, aber nach dem Maßstab unterscheidbar (Auswahl, nicht gezählt)

| Paar | Entscheidender Unterschied |
|---|---|
| R13 / R18 | R18 trägt ein Kleid mit nackten Beinen, R13 eine Hose. Haar: Pferdeschwanz gegen Locken |
| R15 / B07 | B07 trägt einen Rock mit nackten Beinen, R15 Jeans. Haar: lang gegen locken |
| R06 / B27 | Haar kurz (R06) gegen lang (B27). Jacke gegen Bluse |
| R06 / B34 | Höhe 122 gegen 132 px (Δ 10). B34 trägt eine Mütze |
| R16 / B28 | Unterteil braun (holz 4) gegen dunkelrot (rot 2). B28 trägt eine Mütze |
| B14 / B39 | Unterteil schwarz (neu 0) gegen dunkelblau (blau 3). Farbfamilien verschieden, beide Beine dunkel (Grenzbereich, Hinweis). Höhe Δ 6 |
| B17 / B25 | B17 Overall gegen B25 Rock. Mütze gegen Haar. Zopf gegen kurzes Haar |
| R05 / R10 | R10 Latzhose mit senfgelbem Latz über dem Oberkörper gegen blauen Blazer bei R05 |
| B02 / B42 | B02 bernsteinfarbene Ärmel und Hemd gegen blaue Ärmel bei B42. Mütze gegen Haar |
| B12 / B32 | B32 blaue Schürze (großes Zubehör). Höhe Δ 6 |
| DET / B03 | B03 blaue Schürze. DET Bommelmütze gegen B03 Haube mit Zopf |
| B05 / B25 | B05 Rock dunkelrot gegen B25 Rock braun. Dutt gegen Zopf |

## 4. Regelverstöße

Keine. Geprüft wurde:

- **Grün** (Palettenrampe 5, Indizes 40–47): Grünpixel nur bei R03 (Front 768 px, Seite 344, Rücken 856) und R04 (1136 / 472 / 1136). Bei den übrigen 64 Figuren kein Grün.
- **Wanderstiefel** (braun, Schaft, dicke Sohle): braune Schaftstiefel nur bei R03 und R04. Braune Halbschuhe ohne Schaft bei R05, R09, R16 (Datensatz: Halbschuhe), kein Verstoß. Dunkelrote Schuhe bei B08 und B30, nicht braun und ohne Schaft. Blaue, schwarze und graue Stiefel bei den übrigen Figuren, z. B. BW, R06, R14, R15, B06, B21, B29, kein Verstoß.
- **Kleiderfarben wie im Datensatz**: Bei allen 66 Figuren ist die Datensatzfarbe (Rampe·8 + Stufe) der sichtbaren Kleidungsstücke im erwarteten Körperbereich vorhanden. Anteil 2 % (Schal, Kragen) bis 46 % (große Schürze, B10). Verdeckte Unterhemden bei R01, R02, R06, R07, R08, R13, R16, R19 liegen unter 0,5 % Pixelanteil, kein Verstoß.
- **K9 §8** (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): Gegenstände in Händen und am Körper geprüft: Gehstock (B08), Regenschirm (B16), Gießkanne (B31), Eimer (B35), Häkelbeutel (B33), Umhängetasche (B26), zwei blaue Gürteltaschen (R17), Kameragurt (R19), Schürzen (B01, B03, B10, B29, B32, B38, B41, R09). Kein Taler, kein Schlüsselbund, kein Laken, keine Stablampe (Stäbe ohne Lampenkopf), kein Kerzenständer, kein Zettel.
- **Alkohol und Drogen**: keine Flaschen, Gläser oder Krüge mit alkoholischem Bezug.
- **Blut und Verletzung**: keine roten Flecken auf Haut oder Kopf. BW ohne Beule und ohne Kühlpack.
- **Film- und Spiel-Kopien, Klischees**: keine erkennbar. Kopfbedeckungen und Kleidung folgen dem Datensatz. DET trägt die beschriebene Bommelmütze, keine Ermittler-Mütze. Keine Hexe, kein Vampir, kein Teufel, kein Walpurgis.
- **Pixeldichte**: alle 198 Sprites liegen auf demselben 2-px-Raster (Lauflängen-ggT 2, gerade Ursprünge).
- **Palette**: alle Bildfarben sind exakte Palettenfarben (64 Farben, keine Fremdfarbe).

## 5. Hinweise (kein Verstoß)

- **R01**: Gesicht braun (Hautton 3 wie im Datensatz). Der Zustand „rußschwarz ab 23:52“ ist im Grundbild nicht dargestellt. So sollte es bleiben.
- **R05, R09, R16**: braune Halbschuhe, die an braune oder bernsteinfarbene Hosen anschließen. Ohne Schaft, kein Verstoß. Bei R09 und R16 kann die Unterschenkelwirkung bei kleiner Ansicht stiefelähnlich wirken. R03 und R04 bleiben die einzigen eindeutigen Schaftstiefel.
- **Datensatz-Zubehör im Bild nicht zu erkennen**: u. a. Laterne (B15), Klemmbrett (B20), Aktenmappe (B24), Stirnlampe (R11), Anstecker „Einspruch!“ (R18). Der Datensatz nennt außerdem einen Markennamen (R11, „Saturn-Aufnäher“).
- **R19**: dunkler Hautton (Stufe 2), schwarze Lederjacke, Kamera. Keine Überzeichnung oder Typisierung erkennbar.

## 6. Methode (kurz)

- **Maße**: Bounding-Box der Frontansicht im PNG. Frontansicht: Höhen 104 (B11) bis 136 px (B22, B28, B37), Breiten 28 (R08, R11, R13, B11, B40) bis 50 px (B18).
- **Paarprüfung**: alle 2145 Paare nach diesen Kriterien.
  - Höhe: Δ ≥ 8 px deutlich, Δ 6–7 px knapp.
  - Breite (Statur): Δ ≥ 10 px deutlich, Δ 8–9 px knapp.
  - Kopf: Hut, Haube oder Kapuze gegen kein Kopf deutlich. Glatze gegen Haar deutlich. Lang gegen kurz deutlich. Mütze gegen kein Kopf knapp. Dutt, Zopf, kurz, Schulter und Locken untereinander knapp.
  - Kleidungsform: Hose, Rock, Kleid und Latzhose deutlich verschieden. Jacke, Weste und Bluse untereinander knapp.
  - Farbfamilien (Oberteil, Unterteil, Ärmel): verschiedene Familie deutlich. Gleiche Familie mit Stufen-Δ ≥ 3 knapp.
  - Großes Zubehör (Stock, Schirm, Eimer, Kanne, Korb, Kamera, Schürze, Umhang) deutlich. Kleine Taschen knapp.
  - Paar: keine deutlichen und keine knappen Unterschiede. Grenzfall: nur knappe Unterschiede.
- **Gegenkontrolle**: Überlappung der Frontumrisse (fußausgerichtet) kombiniert mit der Farbfamilien-Übereinstimmung. Die höchsten Werte wurden einzeln optisch geprüft. Sie sind unterscheidbar, außer R01/R16.
- **Sichtprüfung**: alle 66 Figuren in Ausschnitten (×3), Füße (×4 und ×7), Gesichter und Zubehör (×4–9) geprüft.
- **Grenze der Messung**: Der Hintergrund D4CEC3 ist Palettenindex 15 (Stein 7). Figurenpixel dieser Farbe wären bei der Umrissmessung verloren gegangen. Bei der Sichtprüfung fiel keine solche Fläche auf.

## Gesamturteil

**Abnahme ja.** Keine verwechselbaren Paare, keine Regelverstöße. Die beiden Grenzfälle R01/R16 und B06/B36 sind dokumentiert und zählen nicht als Paar.

ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten fc94af9295

# Sichtprüfung Figuren-Aufstellung · Auftrag A-605u

**Prüfer:** sichtpruefer_23 · **Bild:** `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px) · **Umfang:** 66 Figuren (BW, DET, R01–R20, B01–B44), je Front, Seite, Rücken

## 0. Vorbereitung
- Schritt 0: `git merge --ff-only nachtlauf/burgstadt` im Worktree, Fast-Forward d92a675 → 614da74 (106 Commits).
- Karten-Stempel: `git hash-object packages/pixel_engine/data/figuren/karten.json` = `b60891cc2be540e37cd54380c039ddf801f55790`, also Stand `b60891cc2b`.
- Nur gelesen: das Bild, `packages/pixel_engine/data/figuren/rollen.json`, `packages/burgstadt_core/data/stadt/bewohner.json`, `packages/pixel_engine/lib/src/palette.dart`. Keine anderen Prüfberichte gelesen.

## 1. Maßstab und Messung
- **Gleiche Silhouette:** Höhe der Vorderansicht Δ < 8 px (gemessen 104 bis 136 px); gleiche Kopfform (Kopfbedeckung oder Frisurklasse); gleiche Kleidungsform (Hose, Rock/Kleid, langer Mantel/Kittel, Latzhose, Schürze).
- **Gleiche Hauptfarben:** Oberteil und Hose/Rock liegen in derselben Palettenrampe (Farbfamilie). Helligkeitsunterschiede innerhalb einer Rampe habe ich nicht als Unterscheidung gewertet (Auftrag 5a).
- Alle Pixel der Vorderansichten liegen exakt in der Palette (Index = Rampe·8 + Stufe). Die Farbanteile je Kleidungsstück sind mit den Datensätzen abgeglichen.
- Vergrößerte Ausschnitte (×3 bis ×5) je Figur, dazu paarweiser Vergleich aller Figuren mit ähnlicher Höhe, Kopf und Farbe.

## 2. Verwechselbare Paare
**Keine (0).** Kein Paar erfüllt alle Kriterien gleichzeitig.

## 3. Grenzfälle (nicht als Paar gezählt)

| ID | ID | Δ Höhe | Was sie unterscheidet | Vorschlag |
|---|---|---|---|---|
| B14 | B39 | 6 | Beide mit blauer Mütze, gelbes Hemd mit roter Weste. Hose B14 fast schwarz (Neutral-Rampe), Hose B39 Nachtblau (blau/3). Bart grau gegen braun. | Hose von B14 ist im Datensatz nicht festgelegt: in der Stein- oder Holzfamilie wählen. |
| B06 | B36 | 6 | Jacke (bernstein/4) und Hose (rot/2) identisch. Einziger Kopfunterschied: blaue Mütze bei B06. | Höhe um mindestens 8 px abstufen (Größe ist frei erfunden). |
| R06 | B27 | 0 | Hose identisch (holz/4). Oberteil blau in zwei Stufen (R06 dunkel, B27 mittelblau). Kopf: kurzes Haar mit Stoppelbart gegen schulterlanges, schwarzes Haar. | Höhe um mindestens 8 px abstufen. Haarlänge ist im Datensatz festgelegt. |
| R01 | B28 | 2 | Mützen unterschiedlich (R01 grau, B28 blau). Jacken in derselben Rampe (R01 sehr dunkel, B28 hell). Hose R01 holz/3 gegen B28 rot/2, beide dunkel. | Höhe um mindestens 8 px abstufen; Mützenfarbe ist frei. |
| R06 | R14 | 2 | Oberteil blau. Hose holz/4 gegen rot/2, beide mittel bis dunkel. Bart Stoppel gegen voller Bart. | Höhe um mindestens 8 px abstufen. |

Weitere knappe Nahfälle, eindeutig unterscheidbar: R01/R16 (Mütze gegen Haar und Bart), R02/B26 (Hut gegen lockiges Haar, Jacke schwarz gegen hellgrau), B02/B14 (Weste blau gegen rot, Hose grau gegen schwarz), B05/B36 (Rock mit nackten Beinen gegen Hose, Farben identisch), BW/B16 (Hut gegen weißes Haar, Mantel und Rock gegen Weste und Hose), B21/B27 (Rock mit blauen Stiefeln gegen Hose), R05/R10 (Sakko gegen Latzhose, Bob gegen Pixie).

## 4. Regelverstöße
**Keine (0).** Geprüft:
1. **Grün (nur R03, R04):** Grün-Pixel nur bei R03 und R04, in allen Ansichten. Keine weitere Figur.
2. **Wanderstiefel (braun, Schaft, dicke Sohle; nur R03, R04):** braune Schaftstiefel nur bei R03 und R04. R05, R09 und R16 haben braune, aber niedrige Halbschuhe (Datensatz: Halbschuhe). B02, B06 und B21 haben blaue Schaftstiefel, nicht braun.
3. **Kleiderfarben (bewohner.json, rollen.json):** Alle B01–B44 stimmen in Farbfamilie und Stufe überein. BW und R01–R20 stimmen mit rollen.json überein. Kleinste Teile sind kaum sichtbar, aber vorhanden: Schal B33 (blau/4) etwa 1,4 % der Figurfläche, Hemd B37 (bernstein/3) etwa 1,9 %, Umhang B43 (bernstein/3) etwa 2,1 %.
4. **Gegenstände aus K9 §8** (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): nichts erkennbar. Die grauen Gegenstände an Hand und Hüfte von B18, B31 und B35 wirken wie Korb, Kanne und Eimer (Datensatz: Nähkorb, Gießkanne, Eimer). Gehstock (B08) und Regenschirm (B16) sind lange Stäbe ohne Lampe.
5. **Pixeldichte:** Alle 66 Figuren liegen im gleichen 2-px-Raster.
6. **Klischees, Film- oder Spielkopien, Herkunft:** keine erkennbar; kein Vampir-, Hexen- oder Teufelsmotiv.
7. **Blut, Verletzung, Alkohol:** nichts erkennbar. BW zeigt keine Wunde, im Bild gibt es keine Flaschen oder Gläser.

## 5. Gesamturteil
**Abnahme: ja.** Keine verwechselbaren Paare, keine Regelverstöße.

Vorbehalt: B14/B39 ist die knappste Entscheidung. Hier stehen dunkles Nachtblau (blau/3) gegen Eisenschwarz (neutral) als Hosen gegenüber. Gelten beide als gleiche Hauptfarbe, wird B14/B39 ein Paar: dann Paare: 1 und Abnahme nein. Die Festlegung liegt beim Auftraggeber.

ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten b60891cc2b

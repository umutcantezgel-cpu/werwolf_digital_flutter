# Sichtprüfung A-605c/d · sichtpruefer_3

**Stand:** HEAD `a4f534a` (Fast-Forward von `nachtlauf/burgstadt` ab `6e11a58`).
**Auftrag:** `nachtlauf/auftraege/A-605c.md` (im Worktree ab `a4f534a` vorhanden; vorher nur unverfolgt im Hauptcheckout gelesen, Inhalt identisch).
**Prüfgegenstand:** `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 x 1504 px), 65 Figuren: BW, R01–R20, B01–B44, je Front, Seite, Rücken.
**Unabhängigkeit:** Keine anderen Prüfberichte im Ordner A-605 gelesen.

## Methode

- Tafel in 8 Zeilen zerlegt (Zeilen 1–7: je 9 Figuren, Zeile 8: B43, B44). Jede Figur ist als Front, Seite, Rücken eindeutig getrennt (27 Läufe je Zeile). Ausschnitte 2x vergrößert und angesehen.
- Übersicht aller 65 Frontansichten im Maßstab 1:3 (ca. Spielentfernung), zum Vergleich der Verwechselbarkeit.
- Farbabgleich: Die Tafel besteht zu 100 % aus Palettenfarben (`palette.dart`). Abgeglichen mit `bewohner.json` (`aussehen`) und `rollen.json`.
- Pixeldichte: Bei allen 65 Figuren ist der Pixelblock 2 px (gleiche Dichte).
- Hinweis zur Farbprüfung: `baker.dart` (Z. 213–221) verschiebt die Stufe je Pixel (Rand -3, Innenkante -2, Oberfläche -2 bis +1). Ein Stufen-Versatz gegenüber dem Datensatz ist daher Schattierung und kein Verstoß. Geprüft wird die Farbfamilie (Rampe) jedes sichtbaren Kleidungsstücks.

## Regelprüfung

| Regel | Befund |
|---|---|
| Grün nur R03 und R04 | Eingehalten. Grüne Pixel (Rampe 5) nur bei R03 (488 Px) und R04 (964 Px). |
| Wanderstiefel (braune Schaftstiefel) nur R03, R04 | Eingehalten. Nur R03 und R04 tragen braune Schaftstiefel. Braune niedrige Halbschuhe bei R05, R09, R16, B22 und B39 sind keine Schaftstiefel. |
| Kleiderfarben wie Datensatz | Keine Abweichung der Farbfamilie bei sichtbaren Kleidungsstücken. Nicht sichtbar, daher kein Verstoß: B18 Hemd, B37 Hemd (unter Mantel), R16 darunter, R19 darunter. |
| K9 §8 (Taler, Schlüsselbund, Laken, Stablampe, Kerzenständer, Zettel) | Kein eindeutiger Verstoß. Zwei Verdachtsfälle, siehe unten. |
| Film- oder Spielkopien, Klischees | Keine erkennbar. |
| Gleiche Pixeldichte | Eingehalten (2 px Block bei allen 65 Figuren). |

**Verdachtsfälle K9 §8 (Zettel):**
- **B39** (Datensatz-Zubehör: Ladeliste): In der linken Hand eine cremefarbene Fläche (Palettenindex 63, Pergament), die sich nicht eindeutig von der Hand unterscheiden lässt. Bei Papier wäre es ein Zettel.
- **B42** (Zubehör: Aktenordner): Gleiche Erscheinung, cremefarbener Bereich in der linken Hand.

Entscheidung über Papier oder Hand liegt bei der Leitung. Vorschlag: Gegenstand in der Hand weglassen oder eindeutig als Nicht-Papier zeichnen.

**Unbedenklich erkannte Gegenstände:** B13 gelbes Knäuel (Strickzeug), B18 Korb (Nähkorb), B15 Laterne, B08 Gehstock, B16 Schirm, B31 Gießkanne, B33 Beutel, B35 Eimer, B44 rote Garnrolle.

## Abgleich mit dem Datensatz (Hinweis, kein Kleiderfarbfehler)

Haar und Kopfbedeckung weichen bei folgenden Bewohnern vom Datensatz ab. Haarfarbe ist nicht in der Liste der Kleiderfarben, daher kein Regelverstoß, aber zur Klärung:
- **B14:** Datensatz grau, glatze, Mütze. Bild: orangerotes Haar, keine Mütze.
- **B17:** Datensatz grau, Mütze. Bild: braunes Haar, keine Mütze.
- **B24:** Datensatz braun, Mütze. Bild: gelb-oranges Haar, keine Mütze.
- **B33:** Datensatz weiß, Dutt, Haube. Bild: blondes Haar, keine Haube.
- **B38:** Datensatz weiß, Dutt, Haube. Bild: blondes Haar, keine Haube.

## Verwechselbare Paare

Stärke: **stark** = gleiche Datenfarben am Kleidungsstück und ähnliche Silhouette im 1:3-Maßstab. **mittel** = gleiche Farbfamilie oder ähnliche Form, aber mit einem sichtbaren Unterschied.

| # | ID | ID | Stärke | Warum verwechselbar | Vorschlag zur Unterscheidung |
|---|---|---|---|---|---|
| 1 | B12 | B36 | stark | Datenfarben identisch: Hemd bzw. Jacke blau 3, Hose neutral 2. Beide braunes kurzes Haar, kein Kopfschmuck, Oberkörper dunkelblau, Hose schwarz. | B36 Jacke auf Rot (Rampe 3) oder Holz; B12 Hemd heller. |
| 2 | B08 | B24 | stark | Dunkelgraue Jacke (B08 neutral 3 = B24 Mantel neutral 3) und braune Hose holz 2, identisch. Orangefarbener Kopf (Hut bei B08, Haar bei B24). | B24 Mantel auf Blau 3 oder Bernstein; B08 Hut in anderer Farbe. |
| 3 | B11 | B23 | stark | Weste bzw. Jacke bernstein 3 und Rock holz 2 identisch. Gleiche Figurform und Haltung. | Haar unterscheidet (B11 blond lang, B23 grau kurz). B23 Jacke auf Blau 2 oder Grau. |
| 4 | B01 | B43 | stark | Kleid blau 2 identisch. Beide älter, Dutt, kein Kopfschmuck, dunkler Oberkörper. | B43 Kleid auf Rot 2; B01 Schürze behält. |
| 5 | B18 | B40 | stark | Mantel stein 4 identisch. Beide kahlköpfig, grauer Mantel bis zur Hüfte. | B40 trägt orangen Hut (vorhanden); B18 Mantel auf Holz 2 oder Blau. |
| 6 | B07 | B25 | stark | Bluse bernstein 4 identisch, gleiche Figurform. Rock braun (B07) und schwarz (B25). | B25 Bluse auf Rot 3 oder Blau; B07 behält Bernstein. |
| 7 | R05 | R11 | stark | Sakko bzw. Jacke blau 2 identisch, Jeans blau 4 identisch, Größe 1.68 bei beiden. | Haar unterscheidet (R05 blonder Bob, R11 dunkel lang). R11 Daunenjacke auf Rot 3 oder Holz. |
| 8 | R07 | B17 | mittel | Jacke holz 3 identisch, dunkle Hose. Braunes Haar bei beiden (Datensatz B17 grau). | B17 Jacke auf Blau 3 oder Bernstein. R07 Halstuch sichtbar lassen. |
| 9 | R06 | R13 | mittel | Jacke bzw. Sakko blau 1 identisch, dunkles Haar, dunkle Beine. Größe unterscheidet (1.82 gegen 1.68). | R13 Hose auf Holz oder Stein 2 heller; R06 Halstuch rot behält. |
| 10 | R01 | B20 | mittel | Dunkle Jacke, graue Hose, Kopfbedeckung dunkel bis grau. Gleiche Kopfform im 1:3-Maßstab. | R01 Strickmütze auf Rot 3 oder Bernstein; B20 Krawatte blau sichtbar. |
| 11 | R01 | R19 | mittel | Dunkle Oberteile, graue Hose, schmale Figur. | R19 Kamera-Gurt rot ist bereits vorhanden, im Bild nach vorne ziehen; R01 Mütze farbig. |
| 12 | R02 | R11 | mittel | Jeans blau 4 identisch, langes dunkles Haar, dunkle Oberteile, Größe 1.66 gegen 1.68. | R11 Daunenjacke auf Holz oder Stein; R02 Haar hochstecken. |
| 13 | R03 | R04 | mittel | Grünes Oberteil (erlaubt), blaue Jeans und Wanderstiefel identisch, fast gleiche Silhouette. | Haar unterscheidet (braun gegen blond). R03 weiße Streifen der Strickjacke klar zeigen; R04 Uhr sichtbar machen. |
| 14 | B05 | R15 | mittel | Pullover bzw. Sakko rot 3 identisch, dunkle Hose bzw. brauner Rock. | Haar unterscheidet (B05 weißer Dutt, R15 braunes Wellenhaar). B05 Pullover auf Bernstein oder Blau 4. |
| 15 | B10 | B14 | mittel | Hemd neutral 5 identisch, braune Schürze bzw. Weste, dunkle Hose, dunkle Stiefel. | B14 Weste auf Blau 2 oder Rot 3. |
| 16 | B16 | B19 | mittel | Orange-rote lange Kleider (rot 4 gegen rot 5), gleiche Länge und Form. | B16 Mantel auf Blau 2 oder Grau; B19 Schal bernstein bleibt. |
| 17 | B33 | B35 | mittel | Kleid bzw. Kittel blau 3 identisch, Dutt bei beiden. | B33 Kleid auf Rot 2 oder Grau; B33 Haube sichtbar machen. |
| 18 | B26 | B36 | mittel | Jacke blau 3 und Hose neutral 2 identisch. | B26 Hut sichtbar lassen und Jacke auf Holz 3 wechseln, oder B36 Jacke umfärben. |
| 19 | R12 | R16 | mittel | Männer mit kurzem dunklem Haar, graue bzw. khakifarbene Hosen, dunkle Oberteile. | R16 Sakko auf Blau 2; R12 Weste auf Rot 3. |
| 20 | R16 | B42 | mittel | Jacke neutral 4 identisch, graue Hose, kurzes Haar. | B42 Jacke auf Holz 3; R16 grau meliertes Bart sichtbar lassen. |
| 21 | BW | B34 | mittel | Oberteil grau, braune Hose (holz 2 bzw. 3), helles Haar. | B34 Hose auf Blau 2 oder Neutral; BW Weste auf Rot 3. |
| 22 | B13 | B31 | mittel | Braun-graue Oberbekleidung, graue bzw. weiße Haare, Haube bzw. Hut. | B31 Rock auf Blau 3 oder Bordeaux; B13 Haube behält. |

Weitere Hinweise (nicht als Paar gelistet): B04, B18 und B37 tragen graue lange Mäntel. Bei nebeneinander stehenden Figuren ist das ähnlich. Bei B04 Brille, bei B37 Stimmgabel sichtbar machen.

## Regelverstöße

- Grün: keine.
- Wanderstiefel: keine.
- Kleiderfarben (Farbfamilie): keine.
- K9 §8: keine eindeutigen Verstöße. Verdacht: B39 (Ladeliste) und B42 (Aktenordner), jeweils cremefarbene Fläche in der Hand.
- Film, Spiel oder Klischee: keine erkennbar.
- Pixeldichte: keine.

## Gesamturteil

**Abnahme: nein.** Gründe:
1. 7 starke Paare mit identischen Datenfarben und ähnlicher Silhouette im Spielmaßstab (B12/B36, B08/B24, B11/B23, B01/B43, B18/B40, B07/B25, R05/R11).
2. Verdacht auf Zettel in B39 und B42 (K9 §8).
3. Haar- und Kopfbedeckungs-Abweichungen gegenüber bewohner.json bei B14, B17, B24, B33, B38.

Die Regeln Grün, Wanderstiefel, Farbfamilie und Pixeldichte sind eingehalten.

---
Endmeldung: `AUFTRAG A-605c/d FERTIG · /home/user/werwolf_digital_flutter/.claude/worktrees/agent-a1cb846926b3ae19e/nachtlauf/auftraege/A-605/sichtpruefer_3_bericht.md · Paare: 22 · Verstöße: 0 (2 Verdacht: B39, B42) · Abnahme nein`

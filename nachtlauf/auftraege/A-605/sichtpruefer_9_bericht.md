# Sichtprüfung A-605i/j – Figuren-Aufstellung (Prüfer sichtpruefer_9)

**Grundlage:** `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px), 66 Figuren (BW, DET, R01–R20, B01–B44), je Front, Seite und Rücken. Abgleich mit `packages/pixel_engine/data/figuren/rollen.json`, `packages/burgstadt_core/data/stadt/bewohner.json` und `packages/pixel_engine/lib/src/palette.dart`. Worktree nach Schritt 0 auf `nachtlauf/burgstadt` (505a4730).

**Vorgehen:** Jede Figur einzeln ausgeschnitten und dreifach vergrößert (Näherung für 5–8 m, etwa ein Drittel der Bildhöhe); alle 66 Figuren paarweise verglichen. Farben pixelgenau gegen die Palette geprüft: Alle Bildpixel der Figuren entsprechen exakt einer der 64 Palettenfarben. Der Bildhintergrund (75,77,85) ist Palettenindex 4 (neutral, Stufe 4).

**Maßstab:**
- *Verwechselbar (Paar):* Silhouette in allen fünf Merkmalen gleich – Größe (Höhe Vorderansicht ±6 px), Frisur-Typ (kurz/glatze, lang inkl. Zopf und Pferdeschwanz, Dutt, Locken), Kopfbedeckung (keine, Mütze, Hut, Haube, Kapuze), Oberteil-Form, Unterteil-Form – und ein Farbblock (Oberkörper oder Unterkörper) mit gleicher Palettenrampe und Stufe ±2. Dunkle Töne (Stufe ≤ 3 in neutral/stein/blau bzw. holz/rot) gelten bei Nacht als ähnlich.
- *Grenzfall:* Form identisch, Farbe klar trennend, oder nur vier Merkmale gleich. Nicht als Paar gezählt, unter Punkt 3 getrennt aufgeführt.
- *Statur:* Bei den Bewohnern nicht im Datensatz; visuell beurteilt, nicht separat gezählt.

## 1. Regelprüfung

| Regel | Befund |
|---|---|
| Grün (Oliv/Dunkelgrün) nur R03 und R04 | Erfüllt. Grünpixel (Palettenrampe 5) nur bei R03 (2068 px) und R04 (2584 px), in allen drei Ansichten. Keine andere Figur. |
| Wanderstiefel (braune Schaftstiefel, dicke Sohle) nur R03 und R04 | Erfüllt. Braune Schaftstiefel nur bei R03 und R04. Grenzfall: braune Halbschuhe mit dicker Sohle ohne Schaft bei R05, R09 und R16 sowie dunkelbraune Schuhe bei B12 (siehe 3) – kein Verstoß. |
| Kleiderfarben der Bewohner wie im Datensatz | Erfüllt. Die Hauptfarben der Kleidungsstücke B01–B44 stimmen mit `bewohner.json` überein. Abweichung nur bei der Hose von B04 (Datensatz neutral 4), die mit dem Bildhintergrund identisch ist (siehe 4). |
| Keine Gegenstände aus K9 §8 sichtbar | Erfüllt. Kein Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer oder Zettel erkennbar. Grenzfall: B39 hält eine dunkelrote Ladeliste (Block an der rechten Hüfte, kein Papier erkennbar). |
| Keine Film-/Spiel-Kopien, keine Klischees | Erfüllt. Grenzfall R17 (brauner Lederhut mit Eichelhäherfeder): Abenteuer-/Robin-Hood-Anmutung, generische Form, kein konkretes Zitat. Keine ethnisierenden Merkmale erkannt. |
| Kein Blut, keine Alkohol-/Drogensymbole, keine Hexen, Teufel, Vampire, Walpurgis | Erfüllt. Keine entsprechenden Motive erkannt (Thermoskanne B07 und Gießkanne B31 sind unverdächtig). |
| Gleiche Pixeldichte | Erfüllt. Alle 66 Figuren im gleichen Raster (Lauflängen durchgehend Vielfache von 2 px). |

**Regelverstöße: keine (0).**

## 2. Verwechselbare Paare (23)

Höhen in px (Vorderansicht), Reihenfolge wie die IDs. Größe ist bei allen Figuren frei erfunden (Datensatz), daher sind Größenänderungen ohne Datenänderung möglich.

| # | ID | ID | Warum (Silhouette gleich / Farbblock gleich) | Vorschlag zur Unterscheidung |
|---|---|---|---|---|
| 1 | B02 | B14 | Höhe 128/124; Mütze; Weste + Hemd; graue Hose (stein 3/2) | B14 Größe −8 px (frei); B02 Hose (frei) in Holzton |
| 2 | B06 | B34 | Höhe 136/134; Mütze; kurzes Haar; gleiche helle Jacke (blau 6) | B34 Größe −8 px (frei); Mützenfarbe (frei) bei einem von beiden ändern |
| 3 | B06 | R01 | Höhe 136/136; Mütze; Jacke; dunkelwarme Hose (rot 2 / holz 2) | R01 Größe ±8 px (frei); B06 Mützenfarbe (frei) ändern |
| 4 | B10 | B12 | Höhe 130/130; kurzes Haar; kein Kopfschmuck; Hemd + Hose; brauner Unterkörper (holz 4) | B10 Größe −8 px (frei); B12 Größe +8 px (frei) |
| 5 | B28 | B34 | Höhe 128/134; gelbe Mütze; helle Jacke; dunkelwarme Hose (rot 2 / holz 3) | B28 Größe +8 px (frei); B34 Mützenfarbe (frei) ändern |
| 6 | B29 | R03 | Höhe 114/118; langes Haar; Jacke; grauer Unterkörper (Schürze neutral 5 / Jeans neutral 5) | B29 Größe −6 px (frei); R03 bleibt durch die grüne Strickjacke unterscheidbar |
| 7 | B29 | R11 | Höhe 114/116; langes Haar; Jacke; grauer Unterkörper (neutral 5) | B29 Größe −6 px (frei); R11 Jeans (frei) in Blau |
| 8 | B30 | B42 | Höhe 128/130; kurzes Haar; Jacke; warme Oberteile (rot 5 / bernst 3); dunkle Hose (blau 3 / neutral 2) | B42 Größe +8 px (frei); B42 Hose (frei) in Holzton |
| 9 | B30 | R04 | Höhe 128/128; kurzes Haar; kein Kopfschmuck; Jacke; blaue Hose (blau 3/4) | B30 Größe −8 px (frei); R04 Hosenfarbe (frei) in Stein; R04 bleibt grün (Grün ist R03/R04 vorbehalten) |
| 10 | B30 | R19 | Höhe 128/124; kurzes Haar; Jacke; dunkle Hose (blau 3 / neutral 3) | R19 Größe +6 px (frei); B30 Größe −6 px (frei) |
| 11 | B34 | R01 | Höhe 134/136; Mütze; Jacke; braune Hose (holz 3/2) | B34 Größe −8 px (frei); R01 Mützenfarbe (Datensatz-Änderung nötig) |
| 12 | B42 | R19 | Höhe 130/124; kurzes Haar; Jacke; dunkler Unterkörper (neutral 2/3) | B42 Hose (frei) in Holzton; R19 Größe −6 px (frei) |
| 13 | B44 | R14 | Höhe 124/126; kurzes Haar; Weste + Hose; dunkelbraune Hose (holz 0/3) | B44 Größe −8 px (frei); R14 Größe −6 px (frei) |
| 14 | R03 | R11 | Höhe 118/116; langes Haar; Jacke; graue Jeans gleich (neutral 5) | R11 Jeans (frei) in Blau; R11 Größe −4 px (frei) |
| 15 | R05 | R11 | Höhe 118/116; langes Haar; Jacke; Oberteil gleich dunkelblau (blau 2) | R05 Größe +8 px (frei); R11 Jeans (frei) in Blau |
| 16 | R05 | R13 | Höhe 118/116; langes Haar; Jacke; dunkle Farben (Oberteil blau 2/0, Hose blau 3/1) | R13 Größe −8 px (frei); R05 Hose (frei) in Stein |
| 17 | R05 | R15 | Höhe 118/116; langes Haar; Blazer; dunkle Hose (blau 3/0) | R15 Größe +8 px (frei); R15 Haar als Zopf (Datensatz-Änderung nötig) |
| 18 | R06 | R16 | Höhe 124/130; kurzes Haar; Jacke/Sakko; gleiche braune Hose (holz 4) | R06 Größe −6 px (frei); R06 Hose (frei) in Stein |
| 19 | R06 | R19 | Höhe 124/124; kurzes Haar; kein Kopfschmuck; dunkle Oberteile (blau 1 / neutral 0) | R19 Größe +8 px (frei); R06 Hose (frei) in Stein; rotes Kameragurt von R19 sichtbar machen (siehe 4) |
| 20 | R11 | R13 | Höhe 116/116; langes Haar; Jacke/Blazer; dunkle Oberteile (blau 2 / blau 0) | R13 Größe −8 px (frei); R13 Dutt statt Pferdeschwanz (Datensatz-Änderung nötig) |
| 21 | R12 | R14 | Höhe 132/126; kurzes Haar; Weste + Hose; dunkle Westen (neutral 3 / blau 2) | R14 Größe −6 px (frei); R14 Weste in Bernstein (Datensatz-Änderung nötig) |
| 22 | R13 | R15 | Höhe 116/116; langes Haar; Jacke; dunkle Hosen (blau 1/0) | R15 Größe +8 px (frei); R13 Größe −8 px (frei) |
| 23 | R16 | R19 | Höhe 130/124; kurzes Haar; Jacke; dunkle Oberteile (neutral 3/0) | R19 Größe −6 px (frei); R16 Hose (frei) in Blau; rotes Kameragurt von R19 sichtbar machen |

Schwerpunkte: Damen mit langem Haar und dunkler Jacke oder Hose (R03, R05, R11, R13, R15); Männer mit Mütze (B02, B06, B14, B28, B34, R01); kurzhaarige Männer mit Jacke und Hose (B30, B42, R04, R06, R16, R19).

## 3. Grenzfälle (nicht als Paar gezählt)

**3a. Silhouette identisch, Farbe trennt (33 Kombinationen):** B01/B43, B07/B21, B10/R09, B12/R09, B13/B33, B13/B38, B19/R18, B20/B28, B22/B40, B29/R05, B29/R13, B29/R15, B30/B36, B30/R06, B30/R16, B32/R09, B33/B38, B36/B42, B36/R04, B36/R06, B36/R16, B36/R19, B42/R04, B42/R06, B42/R16, B44/BW, R03/R05, R03/R13, R03/R15, R04/R06, R04/R16, R04/R19, R11/R15.

Besonders beachten: Die weißen Dutt-Damen B13, B33, B38 und B43 sind in Haar und Kleidform identisch; nur die Kleiderfarbe trennt. Ebenso die Hut-Männer R17, B22 und B40 (Hut, Bart oder Glatze, langer Mantel oder Jacke). Im Nachtlicht wären diese Gruppen eher verwechselbar als die Einzelpaare.

**3b. Vier Merkmale gleich, Farbblock gleich (Beispiele):** B12/R16 und B10/R16 (Höhe 130/130, kurzes Haar, Unterkörper braun; Oberteil Hemd gegen Sakko). Weitere Kombinationen mit vier gleichen Merkmalen wurden automatisch erfasst und nach Sichtprüfung nicht als Paar gewertet, weil Größe (≥ 8 px), Kopfbedeckung, Frisur oder Kleidungsform klar abweichen.

**3c. Braune Halbschuhe mit dicker Sohle (kein Verstoß):** R05, R09, R16, B12. Kein Schaft, daher nicht die Wanderstiefel-Regel.

## 4. Abgleich-Hinweise (kein Regelverstoß)

- **R19:** Der im Datensatz genannte breite rote Kameragurt ist im Bild nicht erkennbar (nur ein dunkles Rechteck an der Brust).
- **R02:** Der große Kopfhörer um den Hals (Datensatz) ist im Bild nicht erkennbar.
- **R20:** Das Haar (Zopf) ist von der grauen Kapuze verdeckt; das orange Halstuch ist sichtbar.
- **B04:** Die Hose (Datensatz neutral 4) hat dieselbe Farbe wie der Aufstellungshintergrund (Palettenindex 4). Die Beine sind nur als Schattenkontur sichtbar. Empfehlung: Hintergrundfarbe der Aufstellung ändern oder die Hosenstufe anheben.
- **B39:** Die Ladeliste ist als dunkelroter Block an der rechten Hüfte dargestellt. Sie ist kein Zettel im Sinne von K9 §8, liegt aber nahe; im Spiel prüfen.
- **R17:** Der Lederhut mit Eichelhäherfeder ist generisch, aber die Kopfform erinnert an Abenteuerfiguren. Bewusst belassen oder anpassen.

## 5. Gesamturteil

**Abnahme: nein.**

Regelverstöße: keine (0). Verwechselbare Paare: 23. Alle 23 Paare liegen bei höchstens 6 px Größenunterschied; eine Größenänderung um mindestens 8 px trennt sie, weil die Größe im Datensatz nicht festgelegt ist. Frisur, Kopfbedeckungsform und im Datensatz genannte Kleidungsfarben sind dagegen vorgegeben und brauchen eine Datensatz-Änderung. Freie Kleidungsteile (Hosen, die im Datensatz nicht genannt sind, Schuhe, Kopfbedeckungsfarbe) können ohne Datenänderung angepasst werden.

Nach der Nachbesserung der 23 Paare und der Entscheidung zu den Grenzfällen (3a, 3b) ist eine erneute Sichtprüfung nötig.

ERGEBNIS · Paare: 23 · Verstöße: 0 · Karten 21297795db

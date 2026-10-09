# Sichtprüfung A-605w · sichtpruefer_25

Auftrag A-605w (gilt auch für A-605x). Im Worktree `git merge --ff-only nachtlauf/burgstadt` ausgeführt, HEAD jetzt 2777e28.
Geprüft: `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px, 66 Figuren, je Front, Seite, Rücken; acht Zeilen mit Beschriftung).
Datenquellen (nur gelesen): `packages/pixel_engine/data/figuren/rollen.json` (BW, R01–R20), `packages/burgstadt_core/data/stadt/bewohner.json` (B01–B44), `packages/pixel_engine/lib/src/palette.dart`.
Keine Daten geändert, kein Commit, kein Push, kein Build. Der Figurenstand wurde nur mit `dart run tool/hd_abnahme.dart --figurenstand` gelesen.

## Methode
- Jede Figur vermessen: Höhe von Scheitel bis Sohle und Breite der Vorderansicht in Pixeln der Aufstellung. Alle Figuren einer Zeile stehen auf derselben Standlinie.
- Alle 66 Figuren haben dieselbe Rasterbreite von 2 px (gleiche Pixeldichte). Alle Bildpixel sind exakte Palettenfarben.
- Palette Version 2 (Index = Rampe · 16 + Stufe). Die Datenstufe s liegt auf Index 2s+1 (`Ramp.at`). Der Auftrag nennt noch „Rampe · 8 + Stufe“ (Palette v1); umgerechnet wurde nach v2.
- Verwechslung: Vorfilter über alle 2145 Paare mit Höhe ≤ 7 px, Breite ≤ 4 px, gleicher Kopfbedeckung, gleicher Frisur und gleicher Kleidungsform. Ergebnis: 25 Kandidaten, jeder mit Farbprüfung. Dazu geprüft: Paare mit anderer Frisur oder Kleidungsform, die im Maßstab 1/3 ähnlich wirkten.
- Bewertung nach Punkt 5a: Paar = gleiche Silhouette und gleiche Hauptfarben (Oberteil, Hose/Rock). Abweichungen in Kleinteilen (Hutfarbe, Gürtel, Schuhe, Bart) entscheiden nicht. Grenzfall = Abweichung nur in einem kleinen Detail, das knapp zur Unterscheidung genügt (Nachbarton, Frisurvariante, Kopfbedeckungsfarbe).

## Verwechselbare Paare: 1

| ID | ID | Warum | Vorschlag zur Unterscheidung |
|---|---|---|---|
| B22 | B40 | Beide 122 px hoch, Breite 36 gegen 40 px. Beide tragen einen Hut (B22 dunkelblau, B40 mittelblau), grauen Bart und einen langen ockerfarbenen Mantel (B22 bernstein/3, B40 bernstein/4). Die Beine wirken in beiden Bildern blau: B22 blaue Hose (blau/4), B40 nur ein schmaler brauner Hosenstreifen unter dem Mantel und darunter blaue Stiefel. Im Maßstab 1/3 nicht sicher zu trennen. Abweichend nur Hutton und Gürtelfarbe (B22 blau, B40 braun). | B40: Hut in Rot statt Mittelblau. B22: Hose in Grau statt Blau. Grüne Kleidung und braune Schaftstiefel bleiben R03 und R04 vorbehalten. |

## Grenzfälle (zählen nicht als Paar)
1. **B06 / B28**: 134 gegen 128 px, Breite 40 / 36. Beide Glatze unter blauer Mütze, dunkelrote Hose (rot/2). Oberteil B06 hellblau (blau/6), B28 hellgrau (neutral/6): gleiche Helligkeit, nur der Farbton unterscheidet. B28 zusätzlich grauer Bart.
2. **B06 / B34**: 134 / 134 px, Breite 40 / 36. Oberteil beide hellblau (blau/6). Hose B06 dunkelrot (rot/2), B34 braun (holz/3). Kopfbedeckung B06 blau, B34 gelb-ocker.
3. **B28 / B34**: 128 / 134 px, Breite 36 / 36. Oberteil hellgrau gegen hellblau, Hose dunkelrot gegen braun, Mütze blau gegen gelb-ocker. Jeweils nur Nachbartöne.
4. **B38 / B43**: 110 / 108 px, Breite 32 / 36. Beide weißes Haar: B38 Dutt, B43 kurzes Haar. B38 braune Schürze (holz/4) über ockerfarbenem Kleid (bernstein/3). B43 rostrotes Kleid (rot/4) mit ockerfarbenem Umhang (bernstein/3). Braun gegen Rostrot im Maßstab 1/3 knapp.
5. **R07 / B09**: 124 / 118 px, Breite 36 / 40. Beide braune Oberteile (R07 Lederjacke holz/3, B09 Overall holz/4) und braune Beine. Frisur R07 Locken, B09 Dutt. B09 hat ockerfarbene Ärmel und eine schwarze Arzttasche.
6. **B15 / B42**: 118 / 124 px, Breite 40 / 40. Beide kurzes braunes Haar und blaues Oberteil. B15 Kittel (blau/5) bis über die Oberschenkel, B42 Jacke (blau/5) bis zur Hüfte. B15 Hose dunkelgrau, B42 Hose dunkelblau.

## Regelprüfung: Verstöße 0
- **Grün** (Oliv/Dunkelgrün): nur R03 (Strickjacke) und R04 (Pullover). Keine andere Figur trägt Grün.
- **Braune Schaftstiefel** (Wanderstiefel): nur R03 und R04. Die übrige braune Fußbekleidung ist niedrig (R05 und R09 laut Daten Halbschuhe). B29 und B40 haben blaue Stiefel; Schuhe sind im Datensatz frei.
- **Kleiderfarben laut Datensatz**: Alle genannten Hauptteile der Bewohner B01–B44 und der Rollen sind im Bild in Rampe und Stufe vorhanden. Kleinteile geprüft: B37 Krawatte rot/3 (28 px), B19 Schal neutral/4 (38 px), R02 Sneaker weiß (20 px). Verdeckte Teile (z. B. Unterhemd R01, R04) sind nicht sichtbar und zählen nicht.
- **Gegenstände aus K9 §8** (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): nicht erkennbar. Sichtbare Requisiten entsprechen dem Datensatz: Arzttasche (B09), Gehstock (B08), Strickzeug (B13), Regenschirm (B16), Nähkorb (B18), Gießkanne (B31), Häkelbeutel (B33), Eimer (B35), Zange (B36), Aktenordner (B42), Kameragurt (R19). Laterne (B15) und Kehrbesen (B17) sind nicht erkennbar.
- **Film-/Spiel-Kopien und Klischees**: keine erkennbar. R01 hat ein mittelbraunes Gesicht mit dunklem Bart; der Ruß-Zustand ist im Bild nicht als eigene Farbe zu erkennen. Kein Verstoß.
- **Pixeldichte**: alle 66 Figuren mit Rasterbreite 2 px. Kein Verstoß.
- Frei und nicht bewertet: Größe, Statur, Hautton, Schuhe, Bart, Kopfbedeckungsfarbe, Hose und Hemd, soweit der Datensatz nichts nennt.

## Schritt 16: Haar, Bart, Geschlecht
- **Haar und Bart der Rollen** stimmen mit `rollen.json` überein. Die Haarfarbe ist im Bild bei 19 von 20 Rollen nachweisbar; bei R20 ist der Zopf nur seitlich sichtbar, die Kapuze verdeckt ihn von vorn. Heller: R07 (locken, holz/5), R12 (golden, bernstein/4), R19 (hellbraun, holz/6). Dunkler: R14 (dunkelbraun, holz/2) und R17 (dunkel).
- **Bärte**: R01 dunkler kurzer Bart, R06 Stoppel, R14 voller brauner Bart, R16 grau meliert, R17 Schnurrbart, R19 dunkler Kinnbart. R12 ohne Bart, dafür Brille.
- **Hinweis**: Der Auftrag nennt sechs Rollen mit neuer Haarfarbe, nennt aber nur fünf IDs (R07, R12, R19, R14, R17). Geprüft wurden alle 20 Rollen.
- **Getauschte Geschlechter**: B15, B35 und B41 (Männer) sind über Breite (40–42 px) und kurzes Haar als Männer lesbar. B12 (28 px) und B32 (32 px) (Frauen) haben kurzes Haar und keinen Rock; die Frauenlesart kommt nur über die schmale Silhouette. Vorschlag: B12 Zopf oder Rock, B32 Dutt. B39 (Frau) ist über Locken und 36 px Breite lesbar.
- Eine Verwechslung zwischen Mann und Frau mit ähnlicher Kleidung gibt es nicht. Der nächste Mann mit ähnlicher Kleidung, B10 (122 px, 40 px), unterscheidet sich von B12 um 12 px in der Höhe und 12 px in der Breite. B41 (124 px, 40 px) unterscheidet sich von B32 um 8 px in der Höhe und 8 px in der Breite.

## Geprüft und unterscheidbar (Auswahl)
- B41 / B25: Breite 40 / 32 px, Zopf gegen kurzes Haar, Hose gegen Rock.
- B21 / B29: Locken gegen Zopf, Beine Haut gegen blaue Stiefel.
- B01 / B38: hellgraue gegen braune Schürze.
- B33 / B38: 118 / 110 px (Differenz 8 px), helles Bernstein gegen braun.
- B06 / B24: Hose dunkelrot gegen schwarz.
- R13 / R18: Hosenanzug gegen Kleid, Haut an den Beinen sichtbar.
- B02 / B14: blaue gegen orange Weste.
- R01 / B34: schwarze gegen hellblaue Jacke.

## Gesamturteil
**Abnahme nein.** Ein verwechselbares Paar (B22 / B40), keine Regelverstöße. Nach einer der beiden Änderungen aus der Tabelle ist die Sichtprüfung dieser beiden Figuren zu wiederholen.

Figurenstand fc6f32f494
ERGEBNIS · Paare: 1 · Verstöße: 0 · Karten 6e6584163c

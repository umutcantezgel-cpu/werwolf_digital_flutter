# Sichtprüfung Figuren-Aufstellung (A-605x) · sichtpruefer_26

**Gesamturteil: Abnahme nein.** 0 verwechselbare Paare, 1 Regelverstoß (R20, Zopf nicht sichtbar), 11 Grenzfälle (nicht als Paar gezählt).

## 0. Stand und Methode

- **Worktree:** `/home/user/werwolf_digital_flutter/.claude/worktrees/wf_63dbc7fc-a2c-2`. Schritt 0: `git merge --ff-only nachtlauf/burgstadt`, Fast-Forward von 3d0722f auf 2777e28 (34 Commits).
- **Bild:** `nachtlauf/bilder/phase3/figuren_aufstellung.png`, 2952 × 1504 px, 66 Figuren in 8 Reihen (7 × 9 und 1 × 3), je Figur Front, Seite, Rücken, Beschriftung darunter.
- **Datenquellen (nur gelesen):** `packages/pixel_engine/data/figuren/rollen.json` (BW, R01–R20), `packages/burgstadt_core/data/stadt/bewohner.json` (B01–B44, Feld `aussehen`), `packages/pixel_engine/lib/src/palette.dart`.
- **Palette:** Der Auftrag nennt „Index = Rampe·8 + Stufe“. `palette.dart` ist Palette v2 mit `Ramp.at(rampe, stufe) = rampe·16 + 2·stufe + 1`. Die Soll-Farben habe ich damit berechnet.
- **Maße:** Höhe = Kopfoberkante bis Fußunterkante in der Frontansicht, Messtoleranz ±2 px. Seiten- und Rückansicht weichen höchstens 2 px ab. Pixelgröße (Modus der Lauflängen) bei allen 66 Figuren 2 px.
- **Sichtung:** Vergrößerungen ×2 (Figuren, Mittelkörper), ×4 (Füße), ×10 (Köpfe), Pixelklassenkarten für Köpfe, Füße und Objekte, Farbabgleich gegen die Datensätze, Paarvergleich nach Maßstab 5a.
- **Außerdem gelesen, nicht Grundlage der Bewertung:** `tool/hd_abnahme.dart` und `tool/lib/figurenstand.dart` (Prüfung, dass `--figurenstand` nur den Hash ausgibt; der Befehl wurde zweimal ausgeführt und schreibt nichts), einzelne Zeilen aus `packages/pixel_engine/lib/src/figur/bewohner_karten.dart` und `baker.dart` zur Kontrolle der Farbzuordnung.
- Keine anderen Prüfberichte gelesen, Ordner `nachtlauf/auftraege/A-605/` nicht durchsucht. Keine Daten geändert, kein Commit, kein Push, kein Build. Hilfsdateien nur im Scratch-Unterordner `sichtpruefer_26/`.

## 1. Verwechselbare Paare (Maßstab 5a)

**Anzahl: 0.**

Kein Figurenpaar erfüllt zugleich alle Bedingungen: Höhendifferenz unter 8 px, gleicher Kopf, gleiche Kleidungsform und Statur, gleiche Hauptfarben in Oberteil und Hose/Rock. Die nächsten Kandidaten stehen unter Abschnitt 2.

| ID | ID | warum | Vorschlag |
|---|---|---|---|
| – | – | keine | – |

## 2. Grenzfälle (nicht als Paar gezählt)

**Anzahl: 11.** Jeweils unterscheidbar über ein Kopf-, Kleidungs- oder Farbdetail. Die Vorschläge sind optional.

| Nr | ID, ID | Höhe (px) | gleich | unterscheidet | Vorschlag |
|---|---|---|---|---|---|
| G1 | R13, R19 | 112, 118 (Δ 6) | Oberteil fast schwarz (Sakko #121A28, Jacke #0B0C10), Hose dunkel | R13 dunkler Pferdeschwanz; R19 hellbraunes Kurzhaar mit Kinnbart, roter Kameragurt | R13: rote Brosche (Merkmal „Granatapfel-Brosche“) am Revers sichtbar machen |
| G2 | R01, R16 | 134, 132 (Δ 2) | Hosen braun (#5E3A24, #7A4E31), gleiche Statur | R01 graue Mütze, schwarze Jacke; R16 dunkelgraues Sakko, grau melierter Bart | R16: Manschettenknöpfe (Merkmal) sichtbar machen |
| G3 | R01, B30 | 134, 134 (Δ 0) | Oberteil dunkel (schwarz #16171D, dunkelbraun #45291A), Hose braun bzw. dunkelrot | R01 graue Mütze und Bart; B30 kein Kopfschmuck, braunes Haar | B30: Jacke heller, oder Mütze von R01 als Blickfang behalten |
| G4 | B15, B42 | 118, 124 (Δ 6) | Oberteil gleiches Blau (#56739B), braunes Kurzhaar, kein Kopfschmuck | B15 Kittel bis über das Knie, Hose dunkelgrau (#34353B); B42 Jacke bis zur Hüfte, rote Krawatte, Hose marineblau (frei) | B42: Hose heller setzen (Hose ist nicht im Datensatz); Krawatte betonen |
| G5 | BW, B16 | 120, 118 (Δ 2) | Oberteil grau (#6B6660 bzw. #8A847C), Hose/Rock braun (#7A4E31) | BW weißes Haar und Bart, Brille, Hose; B16 dunkelblauer Hut, Rock, Regenschirm | B16: Hutfarbe (frei) kontrastierend |
| G6 | B05, B08 | 118, 120 (Δ 2) | Oberteil gleich (blau #7F9DBF), Rock/Hose gleich (dunkelrot #5A1E16) | B05 weiße Locken, Rock, nackte Beine; B08 Hut, Hose, Gehstock | B08: Hutfarbe (frei) kontrastierend |
| G7 | B06, B34 | 134, 134 (Δ 0) | Oberteil gleich (blau #7F9DBF) | B06 kahl, dunkelblaue Mütze, Hose dunkelrot; B34 blonde Haare über grauer Mütze, Hose braun (#5E3A24) | B34: Mützenfarbe (frei) klar anders |
| G8 | B06, B24 | 134, 136 (Δ 2) | Oberteil gleich (blau #7F9DBF), Mütze | B24 Mantel bis zum Knie (B06 Jacke), Hose schwarz (B06 dunkelrot), braunes Haar an den Schläfen (B06 kahl) | B24: Mützenfarbe (frei) oder Mantellänge |
| G9 | B06, B28 | 134, 128 (Δ 6) | Hose gleich (dunkelrot #5A1E16), blaue Mütze, gleicher Jackenschnitt | B06 hellblaue, B28 hellgraue Jacke (andere Farbfamilie); B28 Haarkranz | B28: Mützenfarbe (frei) kontrastierend |
| G10 | B41, B32 (Geschlecht getauscht) | 124, 116 (Δ 8, Grenzmaß) | Orange-Töne in Schürze/Hemd (#C8642B, #BC8424), kurzes Haar | B41 Oberteil grau (#6B6660), Schürze orange; B32 Oberteil orange (#C8642B), Schürze ocker, schwarzes Haar | B32: Größe (nicht im Datensatz) um 2 px verringern oder B41 vergrößern |
| G11 | B39, R14 (Geschlecht getauscht) | 114, 120 (Δ 6) | Hose gleich (dunkelrot #5A1E16), Weste über Hemd, Breite 36 bzw. 40 px | B39 Mütze, krauses Haar, gelbes Hemd, graue Weste; R14 Vollbart, navy Weste, schwarze Stiefel | B39: Mützenfarbe (frei) betonen |

## 3. Regelverstöße

**Anzahl: 1.**

| Nr | ID | Regel | Befund | Vorschlag |
|---|---|---|---|---|
| V1 | R20 | Punkt 16: Haar nach rollen.json | rollen.json: haar holz/6, frisur zopf. Im Bild verdeckt die graue Kapuze (Merkmal „Kapuze des grauen Pullis“) den Kopf. Hellbraun ist nur am Pony sichtbar (Seitenansicht Zeilen 8–11 ab Kopfoberkante) und in zwei Pixelzeilen am Nacken (Rückansicht Zeilen 20–21). Der Zopf ist nicht erkennbar. | Kapuze zurückgeschlagen darstellen oder den Zopf über die Schulter führen |

Geprüft ohne Befund:
- **Grün nur R03 und R04:** Grünpixel gemessen: R03 520, R04 1288, alle übrigen 0.
- **Wanderstiefel nur R03 und R04:** Füße aller 66 Figuren vergrößert geprüft. R03 und R04 haben braune Schaftstiefel mit grauer Sohle. Sonst keine braunen Schaftstiefel: blaue hohe Stiefel bei B02, B29, B39, B40; schwarze bei BW, R06, R11, R14, R15. Braune Halbschuhe bei R05, R09, R16 sind keine Schaftstiefel. B34 und B35 haben braune Hosen bis zum Schuh, darunter graue bzw. schwarze Schuhe.
- **Kleiderfarben wie im Datensatz:** Oberteil und Hose/Rock aller 44 Bewohner und aller 21 Einträge in rollen.json (BW, R01–R20) gegen die Datensätze abgeglichen. DET nach Vorgabe (steinfarbener Mantel, rote Bommelmütze, roter Schal) geprüft. Keine Abweichung. Hemd und Hose ohne Datenangabe sind frei.
- **Gegenstände aus K9 §8** (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): Hand- und Gürtelbereich der Figuren mit Objekten vergrößert geprüft (R17, B09, B11, B20, B06, B02, B18, B33, B35, B31, B38, B19, B03, B16, B08, B10, B36, B41). Zu sehen: Gießkanne (B31), Eimer (B35), Häkelbeutel (B33), Nähkorb (B18), Gehstock (B08), Regenschirm (B16), Arzttasche (B09), Kameragurt (R19). Keines der verbotenen Stücke.
- **Pixeldichte:** alle 66 Figuren 2 px Blockgröße.
- **Film-/Spiel-Kopien, Klischees, Alkohol-Andeutungen:** am Bild kein Befund.

Hinweise (kein Verstoß):
- **R17:** zwei blaue Taschen an der Hüfte. rollen.json nennt bei R17 kein Zubehör. Klären, ob gewollt.
- **B01, B33, B38:** weißes oder graues Haar als Volumen wirkt aus der Ferne wie eine Kappe. Pixelkarte: Haar ohne Krempe, Daten `kopf: keine`.
- **B32:** hochgesteckt wirkendes schwarzes Haar wirkt aus der Ferne wie ein Hut. Pixelkarte: kein Hutrand, `kopf: keine`.
- **B12 (weiblich):** im Bild kaum weibliche Merkmale (kurzes Haar, Hose). Verwechslung mit gleich gekleideten Männern (B10, B02, B14, B20) ist durch Größe (Δ 12–24 px) und Oberteilfarbe ausgeschlossen.

## 4. Punkt 16: Haar und Bart der Rollen, Geschlechter

Haar und Bart der Rollen gegen rollen.json geprüft (Köpfe ×10, Pixelkarten):
- **Übereinstimmend:** BW (weiß kurz, weißer Kurzbart, Brille), R01 (graue Mütze, brauner Kurzbart), R02 (schwarz, lockig, lang), R04 (blond kurz), R05 (Bob, bernsteinbraun, Brille), R06 (schwarz kurz, Bart als Stoppel), R07 (braun, Locken), R08 (dunkler Dutt), R09 (rotbraun kurz), R10 (hellblond, kurz), R11 (schwarz, lang), R12 (ocker kurz, Brille), R13 (dunkler Pferdeschwanz), R14 (braun kurz, voller Bart), R15 (braun lang, lose, kein Zopf), R16 (dunkel kurz, grau melierter Kurzbart), R17 (dunkel, Kurzbart, Lederhut), R18 (dunkel, schulterlang), R19 (hellbraun kurz, Kinnbart, Kameragurt).
- **Nach E54 geänderte Haarfarben:** R07, R12, R19 heller und R14, R17 dunkler. Im Bild entsprechend umgesetzt.
- **R03** (schulterlang, braun, kein Bart): Die Vorderansicht zeigt im Kinnbereich eine Haarfläche (Zeilen 18–21 ab Kopfoberkante). Die Seitenansicht zeigt dort Haut, das Haar liegt am Nacken. Kein Bart, kein Verstoß.
- **Abweichung:** R20, siehe V1.

**Geschlechter (E54 getauscht):** B15, B35, B41 männlich in Pflege, Reinigung, Bedienung; B12, B32, B39 weiblich im Handwerk. Gegen gleich gekleidete Figuren des anderen Geschlechts geprüft: keine nicht unterscheidbar. Die nächsten Fälle stehen als G10 (B41/B32) und G11 (B39/R14).

## 5. Maße (Frontansicht, Höhe in px)

Reihe 1: BW 120 · DET 126 · R01 134 · R02 128 · R03 116 · R04 132 · R05 128 · R06 120 · R07 124
Reihe 2: R08 110 · R09 126 · R10 130 · R11 106 · R12 134 · R13 112 · R14 120 · R15 120 · R16 132
Reihe 3: R17 128 · R18 110 · R19 118 · R20 120 · B01 114 · B02 134 · B03 122 · B04 132 · B05 118
Reihe 4: B06 134 · B07 118 · B08 120 · B09 118 · B10 122 · B11 114 · B12 110 · B13 124 · B14 128
Reihe 5: B15 118 · B16 118 · B17 134 · B18 126 · B19 118 · B20 128 · B21 112 · B22 122 · B23 114
Reihe 6: B24 136 · B25 118 · B26 134 · B27 120 · B28 128 · B29 108 · B30 134 · B31 112 · B32 116
Reihe 7: B33 118 · B34 134 · B35 128 · B36 130 · B37 130 · B38 110 · B39 114 · B40 122 · B41 124
Reihe 8: B42 124 · B43 108 · B44 118

## 6. Gesamturteil

- **Abnahme: nein.** Grund: V1 (R20, Zopf nicht sichtbar).
- Paare: 0. Verstöße: 1. Grenzfälle: 11 (nicht als Paar gezählt).

Figurenstand fc6f32f494
ERGEBNIS · Paare: 0 · Verstöße: 1 · Karten 6e6584163c

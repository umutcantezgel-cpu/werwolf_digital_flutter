# A-605z · Sichtprüfung der Figuren-Aufstellung (sichtpruefer_28)

Prüfer: sichtpruefer_28 (Auftrag A-605z, identischer Prüfauftrag A-605y/z)
Worktree-Stand: HEAD e13255f (Schritt 0: `git merge --ff-only nachtlauf/burgstadt`, Fast-Forward ausgeführt)
Prüfobjekt: `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px, 66 Figuren, je Front, Seite, Rücken)
Datenquellen (nur gelesen): `packages/pixel_engine/data/figuren/rollen.json`, `packages/burgstadt_core/data/stadt/bewohner.json`, `packages/pixel_engine/lib/src/palette.dart`
Hash `karten.json` (`git hash-object`, ohne -w): 88600ae6c9288c405685258e7a1bc8973049a99c

## Ergebnis auf einen Blick

- Verwechselbare Paare nach Maßstab 5a: 0
- Regelverstöße: 1 (R06, Haar und Bart passen nicht zu rollen.json)
- Grenzfälle, nicht als Paar gezählt: 8 (Abschnitt 2)
- Abnahme: nein, bis R06 korrigiert ist

## 1. Verwechselbare Paare

Keine. Keines der 16 geprüften Nahpaare (Abschnitte 2 und 3) erfüllt zugleich gleiche Gesamtsilhouette und gleiche Hauptfarben. Jedes Paar hat mindestens einen großen Unterschied: eine andere Farbfamilie oder Stufe bei Oberteil oder Hose, eine andere Kleidungsform, einen deutlichen Kopfunterschied oder einen Höhenunterschied von mindestens 8 px.

| ID | ID | warum | Vorschlag zur Unterscheidung |
|---|---|---|---|
| – | – | keine | – |

## 2. Grenzfälle (nicht als Paar gezählt)

Höhe = Pixelhöhe des Front-Sprites in der Aufstellung. Der Maßstab 1/3 entspricht dem Blick aus 5 bis 8 m.

| IDs | Höhe (px) | Gleich | Entscheidender Unterschied | Urteil | Vorschlag |
|---|---|---|---|---|---|
| B22 / B40 | 128 / 130 | Hut, langer Mantel, graue Hose, Höhe | Mantel ockergelb (bernstein 3) gegen dunkelbraun (holz 3); Hut dunkelblau gegen blau | unterscheidbar | B40 Mantel auf blau-grau (blau 2) oder Hutfarbe ändern |
| B06 / B35 | 134 / 134 | Hose holz 4, blaues Oberteil (blau 6 gegen blau 5), Höhe | Mütze auf glattem Kopf gegen kurzes braunes Haar; Jacke hüftlang gegen Kittel knielang | unterscheidbar | B35 Kittel auf Hüftlänge kürzen |
| B14 / B44 | 128 / 122 | Weste rot 5 und Hemd gelb identisch | Hose navy gegen dunkelbraun; blaue Mütze gegen graues Haar; Höhe 6 px | unterscheidbar | B44 Hose auf grau oder schwarz (neutral) |
| B05 / B07 | 114 / 114 | Lockenhaar, Rock blau, Höhe | Oberteil dunkelbraun (holz 2) gegen dunkelrot (rot 3); lange gegen kurze Ärmel; zusätzlich Haar weiß gegen rot | unterscheidbar, knapp | B05 Pullover auf blau-grau |
| R13 / R18 | 112 / 110 | Navy in allen Kleidungsteilen, dunkles Haar | Kleid mit sichtbaren Waden (R18) gegen Hosenanzug (R13); Pferdeschwanz gegen Schulterhaar | unterscheidbar | R13 Hose ein Blau-Stufe heller oder R18 Rock kürzen |
| R06 / R14 | 120 / 120 | Kopf kurz mit Bart, Oberteil navy, Höhe | Hose braun (holz 4) gegen dunkelrot (rot 2); Jacke gegen Weste mit grauen Ärmeln | unterscheidbar | R14 Hose auf grau |
| B06 / B24 | 134 / 134 | Oberteil hellblau (blau 6), Mütze, Höhe | Hose braun gegen schwarz; Jacke hüftlang gegen Mantel bis zu den Waden, bei B24 mit Bart | unterscheidbar | B24 Hose braun oder Mantel kürzen |
| DET / B16 | 126 / 118 | Grauer Mantel (Stein-Rampe) | Bommelmütze rot gegen blauer Hut; roter Schal; Mantel bis übers Knie gegen Mantel bis zur Hüfte mit braunem Rock; Höhendifferenz 8 px (Schwelle erreicht) | unterscheidbar | keiner nötig |

## 3. Weitere geprüfte Nahpaare (klar unterscheidbar)

- B02 / B34 (122 / 120 px): beide mit Mütze und blauem Oberteil. B02 hat gelbes Hemd, dunkle Hose und blaue Schaftstiefel, B34 braune Hose.
- B42 / B17 (136 / 134 px): gleiche gelbe Jacke. B42 hat schwarze Hose und Bart, B17 eine dunkelrote Latzhose und eine blaue Mütze.
- B27 / B38 (118 / 124 px): gleiches gelbes Oberteil (gelb 3). B27 hat navy Hose, B38 ein Kleid mit Schürze.
- B12 / B32 (112 / 112 px): B12 gelbes Hemd und graue Hose, B32 orangefarbenes Hemd, gelbe lange Schürze und schwarze Hose.
- BW / R06 (120 / 120 px): gleiche braune Hose (holz 4). BW trägt graue Weste mit weißem Haar und Bart, R06 eine navy Jacke.
- R12 / R16 (134 / 132 px): gleiches anthrazitfarbenes Oberteil. R12 hat schwarze Hose, R16 braune Hose.
- B15 / B35 (124 / 134 px): gleicher blauer Kittel. B35 ist 10 px größer und hat braune Hose, B15 dunkle Hose.
- B28 / B06 (136 / 134 px): B28 graue Jacke und dunkelrote Hose, B06 hellblaue Jacke und braune Hose.
- R11 / R18 (106 / 110 px): navy Oberteile. R11 trägt graue Jeans, R18 ein Kleid.
- B09 / R08 (110 / 110 px): gleicher Dutt und gleiche braune Hose (Overall bzw. Hose). B09 hat gelbe Jacke, R08 navy Pullover.

## 4. Regelverstöße

1. **R06 (Diyar Kaya):** Das Haar reicht seitlich bis zum Unterkiefer, der Bart wirkt dichter als Stoppel. rollen.json: `frisur: kurz`, `bart: stoppel`. Im 6-fachen Ausschnitt liegt die Länge bei der Bob-Länge von R05, bei R14, R16, R17 und R19 endet das Haar an den Ohren. Vorschlag: Haar auf kurz zurücksetzen und Bart auf Stoppel.

Sonst keine. Im Einzelnen geprüft:

- **Grün (nur R03 und R04):** Pixelzählung über alle drei Ansichten. Rampe 5 kommt nur bei R03 (1968 px) und R04 (3196 px) vor. Kein Verstoß.
- **Wanderstiefel (braune Schaftstiefel mit dicker Sohle, nur R03 und R04):** Im 4-fachen Fußausschnitt tragen nur R03 und R04 braune Schaftstiefel. Braune Schuhe bei R05, R08, R09, R16, R17 und B34 sind niedrige Halbschuhe. Blaue Schaftstiefel bei B02 und B04 sind nicht braun. Kein Verstoß.
- **Kleiderfarben der Bewohner (bewohner.json):** Bei allen 44 Bewohnern erscheint jede genannte Rampe und Stufe als Hauptfarbe mit mindestens 28 Pixeln. Index = Rampe · 16 + 2 · Stufe + 1. Kein Verstoß.
- **Kleiderfarben der Rollen (rollen.json):** Oberteil, Unterteil und Schuhe erscheinen in der genannten Farbe. Innenkleidung (Hemd, T-Shirt, Bluse) ist bei R01, R04, R06, R13, R16, R17 und R19 verdeckt und nicht prüfbar. Kein Verstoß.
- **K9 §8 (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel):** Nichts davon ist sichtbar. Die übrigen Zubehörteile (Notizbuch, Klemmbrett, Aktenmappe, Gehstock, Stimmgabel, Gießkanne, Stirnlampe bei R11) stehen nicht auf der Liste und sind nicht beanstandet.
- **Leitplanken (Alkohol, Drogen, Blut, Hexe, Vampir, Walpurgis, Teufel):** Nichts sichtbar. Keine Hexenhüte. Die Kopfbedeckung von B27 ist ein Zylinder (Abschnitt 7), kein Hexenhut.
- **Film- und Spielkopien, Klischees:** Keine erkennbar.
- **Pixeldichte:** Alle 66 Front-Sprites haben denselben Raster (häufigste horizontale Lauflänge 2 px, größter gemeinsamer Teiler 2 px). Das Bild enthält nur die 61 exakten Palettenfarben. Kein Verstoß.

## 5. Rollen: Haar, Frisur und Bart (rollen.json, Punkt 16)

| Rolle | rollen.json (Haar, Frisur, Bart) | Bild | Urteil |
|---|---|---|---|
| BW | kurz, Bart kurz, weiß | weißes kurzes Haar, weißer Bart, Brille auf der Stirn | passt |
| DET | frei erfunden: rote Bommelmütze, roter Schal, steinfarbener Mantel | wie beschrieben | passt |
| R01 | kurz, Bart kurz, graue Strickmütze | Mütze grau, dunkler Bart | passt |
| R02 | lang-offen, lockig | lange lockige schwarze Haare | passt |
| R03 | schulterlang (Spange) | schulterlanges braunes Haar; Spange nicht erkennbar | passt |
| R04 | kurz, hellblond (bernstein 6) | kurzes hellblondes Haar | passt |
| R05 | bob | Bob-Länge | passt |
| R06 | kurz, Bart stoppel | Haar bis zum Unterkiefer, Bart dicht | Abweichung (Abschnitt 4) |
| R07 | kurz-locken, heller (holz 5) | kurze braune Locken | passt |
| R08 | Dutt | Dutt im Rückenbild | passt |
| R09 | kurz, rot (rot 4) | kurzes rotbraunes Haar | passt |
| R10 | kurz (Pixie), hellblond (bernstein 7) | Pixie-Schnitt, sehr hell | passt |
| R11 | lang-offen, schwarz | langes glattes schwarzes Haar | passt |
| R12 | kurz, heller (bernstein 4), Brille | goldener Ton, Brille, kein Bart | passt |
| R13 | Pferdeschwanz | Pferdeschwanz in der Seitenansicht | passt |
| R14 | kurz, Bart voll, dunkler (holz 2) | dunkelbraunes Haar, voller Bart | passt |
| R15 | lang-offen, wellig | langes welliges braunes Haar | passt |
| R16 | kurz, Bart kurz (grau meliert) | Haar zurückgekämmt, grauer Bart | passt |
| R17 | Hut, kurz, Bart kurz, dunkler (neutral 2) | brauner Lederhut mit Feder, dunkler Bart | passt |
| R18 | schulterlang | schulterlanges dunkles Haar | passt |
| R19 | kurz, Bart kurz, heller (holz 6) | kurzes helles Haar, Kinnbart | passt |
| R20 | Zopf, keine Kapuze | Zopf in der Seitenansicht, keine Kapuze am Kopf | passt |

## 6. Hut und langer Mantel (Punkt 16)

- B22 (Hut dunkelblau, Mantel ockergelb) und B40 (Hut blau, Mantel dunkelbraun) sind im Maßstab 1/3 unterscheidbar. Der Trennwert ist die Mantelfarbe. Kein Paar, siehe Abschnitt 2.
- DET (rote Bommelmütze, steinfarbener Mantel bis übers Knie, roter Schal) und B16 (blauer Hut, grauer Mantel bis zur Hüfte, brauner Rock) sind durch Kopfbedeckung, Schal und Mantellänge getrennt. Der Höhenunterschied beträgt 8 px.
- Weitere lange Mäntel: B04 (bernstein), B18 (rostrot, Glatze), B24 (blau, Mütze mit Bart), B37 (orangerot, lange graue Haare). Sie sind untereinander durch Kopf und Farbe getrennt.

## 7. Auffälligkeiten (kein Verstoß gezählt, zur Nachprüfung)

- **B01:** Im Bild ist ein grauer Hut mit Krempe zu sehen. Im Datensatz stehen `kopf: keine` und `frisur: kurz`. Generator oder Datensatz prüfen.
- **B27:** Im Bild ist ein schwarzer Zylinder mit Krempe zu sehen. Im Datensatz stehen `frisur: dutt` und `kopf: keine`. Prüfen.
- **B32 und B44:** Der Kopfaufsatz ist nicht eindeutig (Haarknoten oder Kopfbedeckung). Bitte in höherer Auflösung prüfen.

## 8. Maßstab und Methode

- Das Bild wurde in 198 Sprites zerlegt. Die 66 Figuren wurden nach der Reihenfolge der Labels zugeordnet. Die Höhen (Front) reichen von 106 px (R11, B13) bis 136 px (B28, B42).
- Eine Höhendifferenz von mindestens 8 px gilt als Unterscheidung. Die Paarprüfung erfolgte im Maßstab 1/3, dargestellt mit 5-facher Vergrößerung. Die Detailprüfung erfolgte in 2-, 4- und 6-fachen Ausschnitten.
- Die Bildfarben wurden pro Pixel auf den Palettenindex abgebildet. Das Bild enthält nur exakte Palettenfarben.
- Hilfsdateien liegen im Scratchpad unter `sichtpruefer_28/`. Es wurden keine Daten geändert, kein Commit, kein Push und kein Build ausgeführt. `dart run tool/hd_abnahme.dart --figurenstand` wurde nur lesend verwendet.

## 9. Gesamturteil

Paare: 0 · Verstöße: 1 (R06). Abnahme: nein. Alle übrigen Prüfpunkte sind bestanden.

Figurenstand add31ccee3
ERGEBNIS · Paare: 0 · Verstöße: 1 · Karten 88600ae6c9

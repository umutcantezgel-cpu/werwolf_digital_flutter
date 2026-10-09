# A-605ac · Sichtprüfung der Figuren-Aufstellung

Prüfer: sichtpruefer_31 · Auftrag A-605ac (gilt auch für A-605ad) · Worktree nach `git merge --ff-only nachtlauf/burgstadt` auf 314e8dd (Fast-Forward von e937ae2).
Bild: nachtlauf/bilder/phase3/figuren_aufstellung.png (2952 × 1504 px, 66 Figuren mit Front, Seite und Rücken).
Gelesen (nur lesen): packages/pixel_engine/data/figuren/rollen.json, packages/burgstadt_core/data/stadt/bewohner.json, packages/pixel_engine/lib/src/palette.dart.
Nicht gelesen: andere Prüfberichte. Der Ordner nachtlauf/auftraege/A-605/ wurde nicht durchsucht. Keine Daten geändert, kein Commit, kein Push, kein Build.

## 1. Ergebnis

- Verwechselbare Paare: 0
- Grenzfälle (zählen nicht als Paar): 1, B05 / B07 (Abschnitt 4)
- Regelverstöße: keine
- Gesamturteil: Abnahme ja (Hinweise in Abschnitt 6)

## 2. Vorgehen

1. Zerlegung in 198 Ansichten (66 Figuren × 3). Kennungen aus der Beschriftung: Zeile 1 BW, DET, R01 bis R07; Zeile 2 R08 bis R16; Zeile 3 R17 bis R20 und B01 bis B05; Zeilen 4 bis 7 B06 bis B41; Zeile 8 B42 bis B44.
2. Farben: Alle Pixel der Vordersichten liegen exakt auf den 160 Palettenfarben (0 Abweichungen). Oberteil, Hose/Rock, Haar und Schuhe lassen sich damit Rampe und Stufe zuordnen. Datenstufe s liegt auf Index Rampe·16 + 2s + 1.
3. Maß: Höhe und Breite der Vordersicht in Bildpixeln.
4. Verwechselbarkeit nach 5a. Gleich sein müssen: Kopfkategorie (Hut, Mütze, Haube, Glatze, kurz, Locken, Dutt, Zopf oder Pferdeschwanz, lang), Kleidungsform (Oberteil + Hose, Weste + Hose, Oberteil + Rock, Kleid, Mantel oder Kittel, Overall), großes Zubehör (Schürze, Umhang, Stock, Schirm, Schaufel, Besen) sowie die Hauptfarben von Oberteil und Hose/Rock (gleiche Farbfamilie, höchstens eine Stufe Abstand). Höhe und Breite (Statur) dürfen sich um höchstens 7 px unterscheiden.
5. Grenzfall: genau ein Merkmal knapp an der Schwelle (Höhe 8 bis 9 px, Breite 8 px, Farbstufe 2) oder eine benachbarte Farbfamilie bei sonst gleichem Bild.

## 3. Verwechselbare Paare

Keine. Kein Paar erfüllt alle Kriterien.

Nicht gezählt, weil unterscheidbar: die 19 Paare mit gleichen Hauptfarben (gleiche Familie, Stufe ±1). Jedes unterscheidet sich durch Kopf, Kleidungsform, großes Zubehör, Höhe ab 8 px oder Statur:

| Paar | Entscheidender Unterschied |
|---|---|
| BW / R16 | Höhe 12 px (120 gegen 132); Weste + Hose gegen Sakko + Hose |
| BW / B16 | B16 mit Hut und Regenschirm (groß) |
| R07 / B19 | Locken gegen langes Haar; Jacke + Hose gegen Kleid |
| R07 / B40 | B40 mit Hut und Schaufel (groß) |
| R09 / R20 | R09 mit Schürze (groß); Zopf gegen kurzes Haar; Höhe 10 px |
| R12 / B21 | Höhe 22 px; Breite 44 gegen 32 px |
| R16 / B16 | B16 mit Hut und Regenschirm (groß); Höhe 14 px |
| R17 / B44 | R17 mit Hut; Jacke + Hose gegen Weste + Hose |
| B04 / B33 | Höhe 16 px; Mantel gegen Kleid |
| B06 / B34 | Höhe 14 px |
| B06 / B35 | B06 mit Mütze; B35 mit Kittel (lang) statt Jacke |
| B07 / B36 | Höhe 14 px; Locken gegen kurzes Haar; Breite 32 gegen 44 |
| B12 / B31 | B31 mit Hut; Höhe 14 px |
| B15 / B24 | B24 mit Mütze; Höhe 10 px |
| B19 / B40 | B40 mit Hut und Schaufel (groß); Höhe 12 px |
| B23 / B26 | B26 mit Hut; Höhe 18 px |
| B32 / B37 | B32 mit Schürze (groß); Höhe 20 px |
| B34 / B35 | B34 mit Mütze, B35 mit kurzem Haar; Höhe 14 px |
| B36 / B41 | Breite 44 gegen 32 px; B41 mit Schürze (groß) |

## 4. Grenzfälle (nicht als Paar gezählt)

- B05 / B07: beide mit Locken, Oberteil + Rock, gleiche Höhe (114 px), Rock navy in beiden (blau-3 bei B05, blau-4 bei B07). Breite 36 gegen 32 px. Der einzige Farbunterschied liegt im Oberteil: B05 dunkelbraun (Pullover holz-2), B07 dunkelrot (Bluse rot-3). Beides dunkle Warmtöne, aber verschiedene Familien. Die Haarfarbe (weiß-grau gegen rot) ist kein Maßstab-Merkmal. Vorschlag zur Unterscheidung: Oberteil von B07 deutlicher rot setzen oder das von B05 heller und grauer, damit die Familien klar auseinanderliegen.

Weitere Nachbarn mit anderer Farbfamilie, unterscheidbar und deshalb keine Grenzfälle: BW / R14 (Weste grau gegen navy, Hose braun gegen dunkelrot); B06 / B28 (hellblau gegen hellgrau, braun gegen dunkelrot); R01 / B28 (schwarz gegen hellgrau, braun gegen dunkelrot); DET / B24 (grauer gegen hellblauer Mantel, Höhe 8 px); R01 / B06 (schwarz gegen hellblau); B11 / B25 (braun gegen gelb Oberteil, rost gegen dunkelbraun Rock); B36 / B42 (rot gegen gelb Oberteil, Höhe 8 px).

## 5. Regelprüfung

- Grün (Oliv und Dunkelgrün): nur R03 (Strickjacke) und R04 (Pullover). Gezählt in allen drei Ansichten (Palettenstufen 80 bis 95). Keine andere Figur hat Grün.
- Wanderstiefel (braune Schaftstiefel mit dicker Sohle): nur R03 und R04. Braune Hosen, die bis zum Schuh reichen, sind keine Stiefel (R01, R05, R07, R09, R16, R17, R20, B06, B09, B34, B35, B44). Dunkle Stiefel bei B02, B04, B14 und B24 sind nicht braun.
- K9 §8 (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): nicht erkennbar. Sichtbar sind nur Gegenstände, die nicht auf der Liste stehen: Gehstock B08, Regenschirm B16, Kehrbesen B17, Schaufel B40, Eimer B35, Gießkanne B31, Häkelbeutel B33, Nähkorb B18, Umhängetasche B26, Arzttasche B09, Kamera am roten Gurt R19. Kleinstobjekte wie ein Notizbuch (B01, B04, B06) lassen sich bei dieser Auflösung nicht sicher ausschließen.
- Haar, Frisur und Bart der Rollen gegen rollen.json:
  - Haarfarbe passt bei allen Rollen innerhalb der Schattierung. BW weiß (neutral-7). R02, R06, R11, R13, R18 schwarz. R16, R17 dunkel (neutral-2). R03, R07 mittelbraun (holz-5). R08 sehr dunkelbraun (holz-1). R14, R15 dunkelbraun (holz-2). R19, R20 hellbraun (holz-6). R04 blond (bernstein-6). R05 ockerbraun (bernstein-3). R09 rostrot (rot-4). R10 hellblond (bernstein-7). R12 ockerblond (bernstein-4). R01 unter der Mütze nicht sichtbar.
  - Frisur: R03 schulterlang, R05 Bob, R07 kurze Locken, R08 Dutt, R10 Pixie, R02 und R11 lang offen, R13 Pferdeschwanz, R15 lang gewellt, R18 schulterlang, R20 Zopf ohne Kapuze. Die übrigen Rollen tragen kurzes Haar.
  - Bart: BW kurz (grauweiß), R01 kurz (dunkel), R06 Dreitagebart als dunkle Kieferschattierung (kein schwarzer Vollbart), R12 kein Bart, R14 voll (braun), R16 kurz grau meliert, R17 kurz (dunkel), R19 Kinnbart als kleiner Fleck in Haarfarbe am Kinn (4 bis 8 px breit). Alle übrigen Rollen ohne Bart.
  - Kopfbedeckung: R17 brauner Lederhut mit blauem Band, R01 graue Strickmütze, DET rote Bommelmütze.
- Kleiderfarben: Oberteil und Hose/Rock stimmen mit den Datensatzfarben überein, Abweichungen höchstens eine Schattenstufe. Stichproben: B01 Kleid holz-3; B04 Mantel bernstein-5; B06 Jacke blau-6, Hose holz-4; B14 Weste rot-5, Hemd bernstein-5; B24 Mantel blau-6; B31 Jacke bernstein-5, Rock neutral-4; R03 Strickjacke grün-2, Jeans blau-4; R04 Pullover grün-4, Jeans stein-4; R10 T-Shirt blau-6, Latzhose bernstein-4; R13 Hosenanzug blau-1.
- Pixeldichte: alle 66 Figuren im selben 2-px-Raster (häufigste Lauflänge je Figur, alle drei Ansichten).
- Film- und Spielkopien, Klischees: keine erkennbar. Die Hut-Figuren (R17, B08, B16, B22, B26, B31, B40) haben eigene Kleidungskombinationen.
- Alkohol und Drogen: keine Flasche, kein Glas und kein Krug erkennbar.
- Blut und Verletzungen: keine erkennbar.

## 6. Hinweise (kein Verstoß)

- Hut und langer Mantel: B22 (Zylinder, ockerfarbener Mantel bis Knie) und B40 (blauer Krempenhut, brauner Mantel, Schaufel) sind unterscheidbar durch Hutform, Farbfamilie (Ocker gegen Braun) und Schaufel. Die Höhe unterscheidet sich nur um 2 px. Würde der Mantel von B22 Richtung Braun wandern, entstünde ein verwechselbares Paar. DET (grauer Mantel, rote Bommelmütze) hat keinen Gegenpart.
- R19 Kinnbart und R06 Dreitagebart sind nur schwach lesbar. Bei Bedarf in der Aufstellung deutlicher setzen.
- B32: Die Aufstellung zeigt einen schwarzen Haarknoten, der Datensatz nennt „kurz“. Zur Klärung. Kein Verstoß gegen Punkt 5.
- Zu Punkt 16 (Dutt, Haube, Glatze nicht mehr nur bei Älteren): Dutt sichtbar bei R08 (27 Jahre), B27 (31), B09 (44), B38 (73). Haube nur bei B03 (51) und B13 (88). Glatze sichtbar bei B18 (66); bei B06 (46) und B28 (84) verdeckt eine Mütze die Glatze. Der Geschlechtertausch (B15, B35, B41, B12, B32, B39) ist im Lineup nicht sicher prüfbar.
- Technische Notiz: `dart run tool/hd_abnahme.dart --figurenstand` lief im Worktree und gab den Figurenstand aus. Dabei erschienen Flutter-Hinweise zu Root-Nutzung und „Running build hooks“. Der Arbeitsbaum blieb unverändert (git status danach leer). Der Standardlauf des Abnahme-Skripts wurde nicht gestartet. Gegenprüfung des Hashs mit git hash-object über die elf erfassten Dateien: gleicher Wert.

## 7. Abnahme

Keine verwechselbaren Paare und kein Regelverstoß. Gesamturteil: Abnahme ja.

Figurenstand 2bed32ba96
ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten 850245deb6

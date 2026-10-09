# A-605ad · Sichtprüfung der Figuren-Aufstellung · sichtpruefer_32

Auftrag A-605ac/ad, Teil ad. Prüfer: sichtpruefer_32. Worktree-Stand 314e8dd (nach `git merge --ff-only nachtlauf/burgstadt`, vorher e937ae2).

Prüfgegenstand: `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px). 66 Figuren-IDs (BW, DET, R01–R20, B01–B44), je Front, Seite und Rücken, also 198 Ansichten.

Datenquellen (nur gelesen): `packages/pixel_engine/data/figuren/rollen.json`, `packages/burgstadt_core/data/stadt/bewohner.json`, `packages/pixel_engine/lib/src/palette.dart` (Palette v2). Andere Prüfberichte nicht gelesen, den Ordner A-605 nicht durchsucht.

## Methode

- Pixelmessung je Ansicht (Höhe und Breite). Die Frontansichten sind 106 bis 136 px hoch.
- Farbabgleich: Alle 479.384 Figurenpixel sind exakte Palettenfarben. Rampe und Stufe folgen aus dem Palettenindex (Rampe · 16 + 2 · Stufe + 1).
- Sichtprüfung vergrößerter Ausschnitte (2×, 4×, 8×) für Köpfe, Füße, Hüftzone und Gesichter.
- Abstandsprüfung nach 5a: Figurenpaare auf 1/3 verkleinert nebeneinander.
- Paartest nach 5a, operational: Kopfklasse gleich (Frisur oder Kopfbedeckung), Silhouettenklasse gleich (Oberteil kurz oder lang, Unterteil Hose oder Rock), Höhendifferenz unter 8 px, Oberfarbe und Unterfarbe jeweils gleiche Farbfamilie (Rampe). Helligkeitsunterschiede innerhalb einer Familie und kleine Details zeigen Grenzfälle.
- Filterstufen über alle 2145 Figurenpaare: Kopfklasse gleich 394, Silhouette zusätzlich gleich 198, Höhe unter 8 px zusätzlich 94, Farbfamilien in Oberteil und Unterteil zusätzlich gleich 1 (R06/R09, siehe G2).
- Befehl `/opt/flutter/bin/dart run tool/hd_abnahme.dart --figurenstand` nur mit Lesezugriff ausgeführt; der Worktree blieb danach sauber.
- Keine Datenänderung, kein Commit, kein Push, kein Build.

## Ergebnis

- Verwechselbare Paare: 0
- Regelverstöße: 0
- Grenzfälle (nicht als Paar gezählt): 7 (G1–G7)
- Abnahme: ja

## Verwechselbare Paare

Keine (0).

## Grenzfälle (nicht als Paar gezählt)

| Nr | Figur | Figur | Höhe px (Δ) | Warum knapp, kleines Detail | Vorschlag zur Unterscheidung |
|---|---|---|---|---|---|
| G1 | R06 | R20 | 120 / 116 (Δ4) | Kopf kurz gegen Zopf; der Zopf ist nur in Seiten- und Rückansicht sichtbar. Oberteil dunkelblau bei beiden, R20 mit grauen Ärmeln. Hose braun (holz 4 gegen holz 2). Statur normal (R06) gegen schmal (R20). | Zopf im Frontbild sichtbar machen oder R20 dunklere Ärmel geben. Hosenfarbe um zwei Stufen absetzen. |
| G2 | R06 | R09 | 120 / 126 (Δ6) | Kopf beide kurz. R09 trägt dunkelblaue Schürze über weißem Shirt (weiße Ärmel, Familie neutral), R06 durchgehend dunkelblau. Hose braun (holz 4 gegen holz 2). R09 kräftig, R06 normal. | Weißen Shirtanteil von R09 verringern, zum Beispiel Schürze über die Ärmel ziehen. |
| G3 | R08 | R20 | 110 / 116 (Δ6) | Dutt gegen Zopf. Oberteil beidesmal dunkelblau (blau 3), R20 mit grauen Ärmeln, R08 mit dunklen Ärmeln. Hose braun (holz 4 gegen holz 2). | Dutt von vorn klarer zeichnen, grauen Ärmel von R20 dunkler setzen. |
| G4 | B22 | B40 | 128 / 130 (Δ2) | Hut und langer Mantel bei beiden, Hose grau (stein 3 gegen stein 2). Mantel ocker (bernstein 3) gegen dunkelbraun (holz 3), also andere Farbfamilie, deshalb nicht als Paar gezählt. Hut: B22 Zylinder, B40 Hut mit breiter Krempe. | Mantelfarbe einer der beiden Figuren auf eine andere Familie setzen (grau oder blau), Hutform deutlicher trennen. |
| G5 | B03 | B13 | 114 / 106 (Δ8) | Δ8 ist genau der Grenzwert, also nach 5a unterscheidbar. Haube bei beiden, lange graue Oberteile (Kittel stein 5 gegen Kleid stein 4). Unterschied an den Beinen (dunkle Hose gegen bloße Beine), an blauer Schürze und rotem Umhang. | Blaue Schürze und roten Umhang als Blickfang erhalten, Höhendifferenz nicht unter 8 px senken. |
| G6 | DET | B16 | 126 / 118 (Δ8) | Δ8 ist genau der Grenzwert. Lange Mäntel in Steinfarbe bei beiden. Kopf verschieden: DET rote Bommelmütze, B16 Hut mit Locken. DET dunkle Hose, B16 brauner Rock. | Kopfbedeckung und Rock/Hose als Unterscheider erhalten. |
| G7 | R01 | R16 | 134 / 132 (Δ2) | Kopf Mütze gegen kurzes dunkles Haar mit grauem Bart. Oberteil schwarz (neutral 1) gegen anthrazit (neutral 4). Hose braun (holz 3 gegen holz 4). | Mütze von R01 als Unterscheider erhalten, Helligkeit des Sakkos von R16 weiter absetzen. |

Im 1/3-Bild bleiben G1 bis G4 knapp, G5 bis G7 sind durch Blickfänge (blaue Schürze, roter Umhang, rote Mütze, schwarzes Oberteil) klar zu trennen.

## Regelverstöße

Keine (0). Geprüft:

1. Grün (Rampe 5) nur bei R03 (Strickjacke) und R04 (Pullover). Über alle 198 Ansichten kommt Grün bei keiner anderen Figur vor.
2. Wanderstiefel (braune Schaftstiefel mit dicker Sohle) nur bei R03 und R04. Braune Schuhe bei R05, R09, R16, B09, B22, B23, B29, B30, B38 und B42 sind kurze Halbschuhe ohne Schaft. Stiefel bei B02 und B04 (dunkelblau), B06, B10, B14, B24, B25, B28, B31 und B36 (grau oder schwarz) sind nicht braun.
3. Kleiderfarben wie im Datensatz: Alle sichtbaren Kleidungsstücke aus `rollen.json` und `bewohner.json` stimmen pixelgenau in Rampe und Stufe. Teilweise verdeckt sind R01, R04, R06, R07 und R19 (Unterhemd), B04 (Hose holz 2, nur 64 px sichtbar, vom Mantel verdeckt) und B37 (Hemd). Kein Verstoß.
4. Keine Gegenstände aus K9 §8 sichtbar (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel). Geprüft: Hüftzone und Hände aller 66 Figuren (Front) und die Langgegenstände in allen drei Ansichten für B06, B08, B15, B16, B17, B36, B40 und B44. Gesehen: Gehstock (B08) und Regenschirm (B16) als dunkle Stöcke ohne Lampenkopf. Die zwei grauen Streifen auf der Brust von B06 sind Hosenträger, die vom Schultergürtel bis zum Gürtel verlaufen. Taschen und Behälter (B09, B13, B18, B25, B26, B31, B33, B35, B44) sind nicht verboten.
5. Pixeldichte: Alle 198 Ansichten haben dasselbe 2-Pixel-Raster. Kein Verstoß.
6. Film- oder Spielkopien und Klischees: In der Sichtprüfung nichts erkennbar. Ein Abgleich mit Vorlagen war nicht möglich.

## Punkt 16 (neu in dieser Runde)

- Geschlechtertausch: B15, B35 und B41 (m) sowie B12, B32 und B39 (w) sind in Silhouette und Farbe nicht verwechselbar. Nächste Gegenstücke: B12 (112 px) gegen B42 (136 px, Δ24); B15 (124 px) gegen B35 (134 px, Δ10, Hose grau gegen braun); B32 (112 px) gegen B41 (126 px, Δ14); B39 (118 px) gegen B28 (136 px, Δ18).
- Dutt, Haube und Glatze auch bei Jüngeren: Dutt bei R08 (27 Jahre), B09 (44), B27 (31), B38 (73). Haube bei B03 (51) und B13 (88). Glatze bei B06 (46), B18 (66), B08 (81), B28 (84). Im Bild erkennbar. Hinweis: B27 wirkt von vorn wie ein dunkler Zylinder, im Profil ist der Dutt sichtbar.
- Haarfarben laut Auftrag: R07 mittelbraun (Rampe 2, Stufe 5), R12 ockergelb (4/4), R19 hellbraun (2/6), R14 dunkelbraun (2/2), R17 sehr dunkel (0/2). Die gezeichneten Farben stimmen mit `rollen.json` überein.
- R20: Keine Kapuze auf dem Kopf. Der Zopf ist in Seiten- und Rückansicht sichtbar, von vorn liegt das Haar eng am Kopf (siehe G1 und G3).
- R06: Dreitagebart als Bartschatten. Gesicht und Kinn zeigen eine dunkle Hautstufe (Stufen 0 bis 2). Keine schwarze Vollbartfläche, schwarze Pixel nur bei Augen und Haar.
- R19: Kinnbart (`kinnbart`) als kleiner Streifen unter dem Mund. Bei 1/3 schwach lesbar.
- Bartarten: R14 voll (braun), R01 kurz (braun), BW kurz (weiß), R16 kurz (grau, wie Merkmal „grau meliert“; `rollen.json` nennt keine Bartfarbe), R17 kurz (dunkel), R06 Stoppel, R19 Kinnbart. Alle übrigen Rollen ohne Bart. Stimmt mit `rollen.json` überein.
- Frisuren: R02 lang-offen (lockig), R03 schulterlang, R05 Bob, R07 kurz-locken, R08 Dutt, R10 Pixie, R11 lang-offen, R13 Pferdeschwanz (Profil), R15 lang-offen, R18 schulterlang, R20 Zopf. Stimmt mit `rollen.json` überein.
- Hut und langer Mantel: B22 (Zylinder, Mantel ocker) und B40 (Hut, Mantel dunkelbraun) sind über Mantelfarbe und Hutform unterscheidbar, siehe G4. DET (Mütze, Mantel steinfarben) und B16 (Hut, Mantel steinfarben, Rock) trennen Kopfbedeckung und Rock, siehe G6. R17 trägt einen Hut, aber keinen langen Mantel.

## Punkt 17 (Zusatzzeile HD-Strang)

Figurenstand 2bed32ba96 (`dart run tool/hd_abnahme.dart --figurenstand` im Worktree nach Schritt 0). Karten-Stand 850245deb6 (`git hash-object packages/pixel_engine/data/figuren/karten.json`).

## Gesamturteil

Abnahme ja. Keine verwechselbaren Paare und keine Regelverstöße. G1 bis G4 liegen nahe beieinander und sollten in der nächsten Figurenrunde nachgeschärft werden. Sie blockieren die Abnahme nicht.

Figurenstand 2bed32ba96
ERGEBNIS · Paare: 0 · Verstöße: 0 · Karten 850245deb6

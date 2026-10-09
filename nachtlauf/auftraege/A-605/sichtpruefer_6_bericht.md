# Sichtprüfung A-605c/d · Sichtprüfer 6 (dritte Runde)

**Geprüfte Datei:** `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504 px, 65 Figuren, je Front/Seite/Rücken)
**Stand:** f5002ef (Fast-Forward von `nachtlauf/burgstadt` ausgeführt, HEAD geprüft)
**Datenabgleich:** `packages/pixel_engine/data/figuren/rollen.json` (BW, R01–R20), `packages/burgstadt_core/data/stadt/bewohner.json` (B01–B44), `packages/pixel_engine/lib/src/palette.dart`
**Unabhängigkeit:** Keine anderen Prüfberichte im Ordner A-605 gelesen.

## Ergebnis

| Kennzahl | Wert |
|---|---|
| Verwechselbare Paare (5–8 m, Spielmaßstab) | **6** (1 hoch, 4 mittel, 1 gering bis mittel) |
| Regelverstöße | **0** |
| Hinweise (Datensatz-Merkmale fehlen oder Lesbarkeit) | 9 |
| Gesamturteil | **Abnahme nein** (bis die Paare aufgelöst sind) |

## Vorgehen

- Zerlegung der 65 × 3 Ansichten mit python3/PIL, Prüfung in umgekehrter Reihenfolge (B44 zuerst bis BW).
- Sichtprüfung in 2x-Blättern (je 8 Figuren), zusätzlich 4x-Zooms, Fuß- und Handzonen sowie Spielmaßstab (Ausschnitte auf 1/3 verkleinert, für die Anzeige 3x vergrößert).
- Farben: Alle Bildfarben sind exakte Palettenfarben (486 740 Pixel, 0 Abweichungen). Die Farbzuordnung erfolgt daher ohne Rundung.
- Paare: Vorauswahl über Silhouetten-IoU und Farbhistogramm im Spielmaßstab, danach visuelle Einzelprüfung jedes Kandidaten.

## Verwechselbare Paare

Silhouette und Farbe sind getrennt angegeben.

| ID | ID | Silhouette | Farbe | Einstufung und Grund | Vorschlag zur Unterscheidung |
|---|---|---|---|---|---|
| B03 | B38 | Frau, weiße Haube, Kittel/Kleid bis Knie, Schürze vorn, Höhe 108/120 | Hauptfarben vertauscht: B03 hellgrauer Kittel (stein 6) mit senfgelber Schürze (bernstein 5); B38 senfgelbes Kleid (bernstein 3) mit hellgrauer Schürze (neutral 6) | **hoch**: gleiche Kopfform und gleicher Schnitt, nur die zwei Farben sind vertauscht | B38: Haube entfernen oder Schürze in Blau/Rot; B03 Schürze umfärben |
| B15 | B35 | Frau, Kittel bis Knie, Hose sichtbar, braunes Haar (Zopf bzw. Dutt), Höhe 118/110 | Kittel praktisch gleich hellgrau (stein 6 / neutral 6); Hose braun in ähnlichem Ton (holz 2 / holz 4) | **mittel bis hoch**: gleiche Grundform, Haarform als einziger Silhouetten-Unterschied | B35 Kittel in Blau, Rot oder Bernstein; alternativ B15 Hose umfärben |
| B38 | B43 | alte Frau, weißes Haar, Kleid bis Wade, Schürze bzw. Umhang | Kleid identisch (bernstein 3), Haarfarbe weiß; vorn grauer Schürze (B38) bzw. blauer Umhang (B43) | **mittel**: Kleid und Haar gleich, Unterschied nur an Schulter und Vorderseite | B43 Umhang in anderer Farbe; B38 Haube streichen |
| B22 | B24 | Mann, langer Mantel, blaue Kopfbedeckung (Hut bzw. Mütze), Höhe 136/128 | Mantel identisch (bernstein 5), Kopfbedeckung blau; Beine: B22 braun, B24 blau | **mittel**: obere Hälfte identisch, nur Hutform und Beinfarbe unterscheiden | B24: Hose holz 3 sichtbar machen (Mantel kürzen); B22 Hut in anderer Farbe |
| B01 | B13 | alte Frau, Dutt (grau bzw. weiß), Kleid bis Wade, Höhe 110/120 | Kleider fast gleich dunkelbraun (holz 3 / holz 2); B01 mit heller Schürze, B13 mit grauem Umhang und blauen Stiefeln | **mittel**: gleiche Figur und ähnliche Kleiderfarbe, Unterschied nur über helle Schürze | B13 Kleid umfärben (z. B. Rot); Haarfarben angleichen vermeiden |
| R02 | R19 | dunkles Oberteil (Hoodie bzw. Lederjacke), graue Hose, Höhe 116/122; R02 langes Haar, R19 kurzes Haar | Oberteil schwarz bei beiden (R02 r0/s0, R19 r0/s0); Hose grau (R02 heller, R19 dunkler); Schuhe weiß (R02) bzw. schwarz (R19) | **gering bis mittel**: Unterschied nur Haarlänge und Schuhfarbe | R19 Hose blau (jeans, Rampe 6); alternativ R02 Sneaker umfärben |

### Grenzfälle (benannt, nicht als verwechselbar gewertet)

- **R02 / R05:** dunkler Oberkörper (schwarz bzw. navy) und graue Hose. Unterscheidung über Haarfarbe (schwarz lang bzw. blond) und Schuhe (weiß bzw. braun). Bei 8 m knapp.
- **B21 / B25:** gleiche hellblaue Bluse. Rock schwarz (B21) bzw. braun (B25), Haar blond bzw. braun.
- **B03 / B35:** Kittel gleich; B03 unterscheidet sich durch Haube und senfgelbe Schürze.
- **B07 / B19:** ähnliches gelbliches Oberteil; Unterkörper braun (B07) bzw. gelbes Kleid (B19).
- **R12 / B20:** dunkle Oberkörper; R12 mit hellblauen Ärmeln und breiterem Körper, B20 mit grauer Mütze und blauem Hemd.

## Regelprüfung

| Regel | Ergebnis | Belege |
|---|---|---|
| Grün nur R03 und R04 | eingehalten | Grünrampe (Rampe 5) als Pixel: R03 1988 (Strickjacke), R04 2584 (Fleece), alle anderen Figuren 0. |
| Wanderstiefel nur R03 und R04 | eingehalten | Fußzonen aller 65 Figuren geprüft: braune Schaftstiefel mit dicker Sohle nur bei R03 und R04. Braune Schuhe bei R05, R09, R16 sind kurze Halbschuhe. |
| Kleiderfarben wie im Datensatz | eingehalten, ein Grenzfall (B24) | Alle im Datensatz genannten Kleiderrampen sind bei jeder Figur im Bild vorhanden (Pixelzählung). Sichtprüfung: Ausnahme B24, siehe Hinweise. |
| Keine K9-§8-Gegenstände | eingehalten | Kein Zettel, Taler, Schlüsselbund, Laken, Stablampe oder eiserner Kerzenständer erkennbar. Helle Gegenstände in Händen bei B18 (Lesart Nähkorb), B13 (Strickzeug), B33 (Häkelbeutel), jeweils im Datensatz als Zubehör genannt. |
| Gleiche Pixeldichte | eingehalten | Alle 65 Figuren mit 2-px-Blöcken (Lauflängen-Modus 2). Höhen 108 bis 136 px, Fußlinien je Zeile gleich. |
| Keine verbotenen Motive (Alkohol, Blut, Film-Kopien) | keine Auffälligkeit | Keine Flaschen, Gläser oder Blutspuren erkennbar. Film- und Spielkopien aus dem Bild nicht erkennbar. |

## Hinweise (keine Regelverstöße)

1. **B24:** Hose holz 3 laut Datensatz. Sichtbar sind nur ein schmaler brauner Streifen unter dem Mantel und 22 Zeilen blauer Unterschenkel bis zum Boden. Entweder sind es blaue Stiefel (Schuhe sind frei), dann ist die Hose praktisch unsichtbar, oder die Hosenfarbe weicht ab. Klären, Grenzfall zu einem Verstoß.
2. **B16:** Rock neutral 3 laut Datensatz nicht sichtbar. Der Mantel endet an den Knien, darunter ist nur Haut zu sehen.
3. **B39:** Mütze laut Datensatz kaum erkennbar. Auf dem Scheitel ist nur ein grauer Pixelblock, das braune Lockenhaar dominiert.
4. **R19:** Roter Kameragurt (Merkmal) fehlt. Im Bild kommt kein Rot vor (Rampe 3 = 0 Pixel), nur ein grauer Kamerakörper ist sichtbar.
5. **R13:** Rote Granatapfel-Brosche (Merkmal) fehlt, im Bild kein Rot.
6. **R17:** Blau gebänderte Eichelhäherfeder (Merkmal) am Hut fehlt.
7. **R02:** Kopfhörer um den Hals (Merkmal) nicht eindeutig erkennbar.
8. **B18:** Heller Gegenstand in der linken Hand. Lesart Nähkorb, aber nicht eindeutig. Bei Verwechslungsgefahr mit einem Zettel als braunen Korb zeichnen.
9. **B01:** Runder brauner Fleck mittig auf der Schürze, kein Datensatz-Merkmal (vermutlich Knopf). Kein Verstoß.

**Technische Notizen:**
- Der Auftrag beschreibt einen hellen Hintergrund. Das Bild hat einen dunkelgrauen Hintergrund (#4B4D55).
- Diese Hintergrundfarbe entspricht der Palettenfarbe Rampe 0, Stufe 4. Eine Prüfung, ob Figurenpixel dieser Farbe im Bild mit dem Hintergrund verschmelzen, ist nicht erfolgt.

## Gesamturteil

**Abnahme nein.** Das Paar B03/B38 hat hohe Verwechslungsgefahr, B15/B35, B38/B43, B22/B24 und B01/B13 mittlere, R02/R19 gering bis mittlere. Die Paare sind vor einer Neuprüfung aufzulösen. Die Hinweise 1 bis 8 sollten zusätzlich geklärt werden, weil fehlende Merkmale die Figuren im Spiel nicht unterscheidbarer machen.

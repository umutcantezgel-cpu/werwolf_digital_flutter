# Sichtprüfung Figuren-Aufstellung, Runde 3 · Prüfer sichtpruefer_5

**Datei:** `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 × 1504, 65 Figuren, je Front, Seite, Rücken)
**Stand:** f5002ef (Schritt 0 ausgeführt, Fast-Forward ok)
**Methode:** Zuschnitt je Figur mit PIL, Ansicht ×3 Vergrößerung. Verwechslungsprüfung auf etwa 1/3 der Originalhöhe (ca. 47 px Figurhöhe, zum Ansehen ×2), Vorderansicht. Abgleich mit `packages/pixel_engine/data/figuren/rollen.json`, `packages/burgstadt_core/data/stadt/bewohner.json` und der Palette aus `palette.dart`. Grün-Prüfung zusätzlich per Pixelfarbe über alle Figuren. Keine anderen Prüfberichte gelesen.

## Verwechselbare Paare

| Paar | Silhouette | Farbe | Urteil | Vorschlag zur Unterscheidung |
|---|---|---|---|---|
| B38 – B43 | Beide weiblich, Kleid bis zur Wade, weißer Kopf (Haube bzw. weißer Dutt), gleiche Höhe: gleich. | Kleid bei beiden Bernstein-Ocker (bernstein/3). Unterschied nur Schürze grau gegen Umhang blau: kaum sichtbar. | hoch | Kleidfarbe einer Figur auf eine andere Rampe setzen (z. B. holz oder rot) oder die Kopfbedeckung bei B38 in Kontrastfarbe ändern. |
| B15 – B35 | Beide weiblich, heller Kittel bis Oberschenkel, braune Hose, Haarknoten am Hinterkopf: gleich. | Kittel stein/6 und neutral/6 sind beide hellgrau und im Fernbild nicht zu trennen. | hoch | Kittelfarbe einer der beiden auf einen kontrastierenden Ton setzen (z. B. blau oder rot). Zopf gegen Dutt ist im Fernbild nicht erkennbar. |
| B07 – B11 | Beide weiblich, kurzes Oberteil, brauner Rock bis Knie, nackte Beine, lange Haare: gleich. | Oberteil beide Ocker/Senf (B07 bernstein/4 vollflächig, B11 bernstein/3 als Weste über heller Bluse): ähnlich. Haarfarbe rot gegen blond nur aus der Nähe. | mittel | Oberteil von B07 auf Blau oder Rot setzen, oder die Weste von B11 deutlich dunkler oder heller als B07 halten. |
| B22 – B24 | Beide männlich, langer Mantel bis Knie, blaue Kopfbedeckung: gleich. Krempenhut gegen Mütze nur aus der Nähe unterscheidbar. | Mantel bei beiden identisch bernstein/5. Beine unterscheiden sich (B22 braune Hose, B24 blaue Stiefel). | mittel | Mantel von B24 auf Stein- oder Rotton setzen, oder Hut von B22 in Kontrastfarbe. |
| B33 – R18 | Beide weiblich, dunkelblaues Kleid bis Knie, nackte Waden: gleich. | Beide dunkelblau (B33 blau/3, R18 Kleid blau/3). Unterschied nur der Kopf: weiße Haube gegen dunkles Haar. | mittel | Kleidfarbe von B33 auf Rot oder Holz setzen. Die Haube bleibt als Merkmal erhalten. |

## Bedingt (geprüft, nicht als verwechselbar gewertet)

- **B02 – B06:** Silhouette gleich (stämmig, blaue Mütze). Die Farbblöcke sind vertauscht (B02 rotes Hemd mit hellblauer Weste und grauer Hose, B06 hellblaue Jacke mit roter Hose). Knapp, aber trennbar.
- **B08 – B26:** Älterer Mann mit Hut, Jacke blau. Hut orange-rot gegen dunkelrot, Jacke hell gegen dunkel, Hose grau gegen schwarz. Der Gehstock von B08 hilft.
- **B04 – B08:** Beide hellblaue Jacke bzw. Mantel. B08 hat Hut und Gehstock, B04 hat Brille und keinen Hut.
- **B13 – B38:** Gleiche Form (Kleid, weiße Haube, blaue Schuhe). B13 ist braun (holz/2), B38 ocker: die Farbe trennt.
- **B18 – B40:** Grauer Mantel bei beiden. B40 trägt einen braunen Hut, B18 ist kahl.
- **R06 – R16:** Männlich, Bart, mittlere Größe. R06 navy Jacke, R16 grauer Sakko, Haar schwarz gegen grau.
- **R05 – R13:** Beide Frauen in Navy. R05 hat graue Hose und blonden Bob, R13 ist durchgehend navy mit schwarzem Pferdeschwanz.

## Regelverstöße

Keine.

- **Grün (Moosgrün, Rampe 5):** Nur R03 (Strickjacke) und R04 (Fleece) zeigen Grün. Der Pixeltest über alle 65 Figuren bestätigt, dass nur R03 und R04 grüne Pixel haben.
- **Wanderstiefel (braune Schaftstiefel, dicke Sohle):** Nur R03 und R04. Die braunen Halbschuhe von R05 und R16 sind niedrige Schuhe und keine Schaftstiefel, daher kein Verstoß.
- **Kleiderfarben der Bewohner:** Alle 44 Bewohner gegen `bewohner.json` geprüft, Übereinstimmung. B24 trägt Hose holz/3, die vom Mantel fast verdeckt ist; die sichtbare Partie am Knie ist braun. Kein Verstoß.
- **K9 §8 (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel):** Im Fernbild nicht erkennbar. Geprüft gegen die Liste im Auftrag, die Datei K9 selbst wurde nicht gelesen.
- **Film-/Spiel-Kopien, Klischees:** Keine auffällig erkannt.
- **Pixeldichte:** Alle Figuren erscheinen in gleicher Pixelgröße.

## Hinweise (kein Regelverstoß)

- **R19:** `rollen.json` nennt einen "breiten roten Kameragurt quer über der Brust". Im Sprite ist der Gurt dunkel und auf der Brust nur ein graues Rechteck erkennbar. Abgleich prüfen.
- **Hintergrund:** Die Datei hat den Hintergrund RGB (75, 77, 85), also mittelgrau-blau und nicht hell wie in der Auftragsbeschreibung.
- **Papierobjekte im Zubehör:** Klemmbrett (B20), Ladeliste (B39), Kassenbuch (B29) und Notizbuch (B01, B04, B06, R03) stehen nicht auf der K9-§8-Liste. Bei der K9-Prüfung "Zettel" nachsehen.
- **Abweichung zur Commit-Nachricht f5002ef:** Dort steht "0 verwechselbare Paare". Diese Prüfung findet 5 Paare, davon 2 hoch.

## Gesamturteil

**Abnahme: nein.** Zwei Paare mit hoher Verwechslungsgefahr (B38/B43, B15/B35) und drei mit mittlerer (B07/B11, B22/B24, B33/R18). Keine Regelverstöße.

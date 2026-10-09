# Sichtprüfung A-605c/d · Figuren-Aufstellung, vierte Runde

- Prüfer: sichtpruefer_8 (unabhängig, ohne Berichte aus A-605)
- Datei: `nachtlauf/bilder/phase3/figuren_aufstellung.png` (2952 x 1504, Hintergrund #4B4D55)
- Stand: 1d9b78c (Schritt 0 ausgeführt, Fast-Forward-Merge bestätigt)
- Umfang: 65 Figuren (BW, R01–R20, B01–B44), je Front, Seite, Rücken; 8 Zeilen

## Vorgehen

- Zerlegung per Hintergrundfarbe in Figurentripel, Zuordnung zu den IDs über die Beschriftung der Zeilen.
- Detailprüfung: 22 Blätter zu je drei Tripeln, zweifach vergrößert, Reihenfolge B44 zuerst, dann rückwärts.
- Spielmaßstab: Ausschnitte auf 1/3 verkleinert (Box-Filter), zeilenweise und halbzeilenweise dreifach dargestellt. Zusätzlich 42 Nahpaare einzeln im Spielmaßstab (Front und Rücken) verglichen.
- Farbprüfung: Alle Vordergrundpixel sind exakte Palettenfarben (59 verschiedene, keine Fremdfarben). Dominante Farben je Körperregion und die exakten Datensatzfarben je Kleidungsteil wurden gegen `rollen.json` und `bewohner.json` geprüft.
- Vergrößerte Einzelprüfungen für alle strittigen Stellen (B08, B16, B30, B33, B36, R12, R16, R17, R19, B31, B33, B36, B43, B13, B20, B24, B14, B32).
- Gelesen: Auftrag A-605c, `nachtlauf/KANON.md` (Abschnitt „Figuren-Kanon für Sprites“), `rollen.json`, `bewohner.json`, `palette.dart`, das Bild. Keine Berichte im Ordner A-605 geöffnet.
- Offenlegung: Bei der Suche nach der K9-§8-Quelle sind per grep Zeilen aus `ENTSCHEIDUNGSLOG.md` (Z. 80, 125) und aus den Aufträgen A-601a, A-601c und A-605a im Suchergebnis aufgetaucht. Die Befundzeile zu früheren Paaren (ENTSCHEIDUNGSLOG Z. 125) wurde nicht als Grundlage verwendet.

## Verwechselbare Paare

Keine. Kein Paar erfüllt beide Kriterien zugleich: Silhouette ähnlich UND Kopf, Oberkörper und Beine im Spielmaßstab kaum unterscheidbar. Die stärksten Grenzfälle stehen darunter, mit getrennter Bewertung von Silhouette und Farbe.

Grenzfälle (nicht als verwechselbar gewertet):

| Paar | Silhouette | Kopf | Oberkörper | Beine | Bewertung und Vorschlag |
|---|---|---|---|---|---|
| B17 / B39 | beide Männer, je 134 px hoch, Oberkörper gelb mit Trägern bzw. Weste | orange (B17 Mütze, B39 Haar) | gleich: Bernstein 5 | B17 dunkles Rotbraun (Overall rot 2), B39 mittleres Braun (Hose holz 4) | knapp. B39 zeigt Haar ingwer, Datensatz sagt „braun“. Angleichen; B17-Mütze in anderer Farbe (Kopfbedeckung frei). |
| B08 / B06 | beide Männer, 122 / 128 px, Jacke und Hose ähnlich | B08 schwarzer Hut mit Krempe, B06 ockerfarbene Mütze | gleich: Jacke Blau 6 | gleich: Hose Rot 2 | Kopfbedeckung trennt. B06-Mütze dunkler oder B08-Hut in anderer Farbe (frei). |
| B01 / B38 | Frauen, langes Kleid, Dutt bzw. Haube, Hautbeine; 112 / 122 px | hellgrau bis weiß | vertauscht: B01 braunes Kleid mit grauer Schürze, B38 graues Kleid mit brauner Schürze | vertauscht (gleiche Schürzenlage, gespiegelt) | nicht gewertet, Verwechslungsrisiko vor allem bei Gegenlicht. Farben sind fest vorgegeben; Trennung nur über Haube und Schürzenlänge möglich. |
| B12 / B25 | B12 Mann mit Hose, B25 Frau mit Rock und Hautbeinen; 126 / 118 px | braun (beide) | hellgrau (beide Neutral 6) | B12 braune Hose, B25 brauner Rock mit Hautbeinen | Beine unterscheiden sich durch die Hautbeine. Beobachten. |
| R06 / R14 | Männer mit Bart, 124 / 126 px | R06 schwarz (Haar), R14 braun | dunkles Navy beide; R14 mit grauen Armen | braun beide (R06 holz 4, R14 holz 3) | knapp. Die Haarfarbe trennt. |
| R08 / R14 | R08 schlank mit Dutt, 118 px; R14 kräftig, 126 px | R08 dunkelbraun, R14 braun | Navy beide; R14 mit grauen Armen | braun beide | knapp. Statur und graue Arme trennen. |

## Regelverstöße

1. **B16 (sicher):** Rock. Datensatz: „Rock [neutral 3]“ (dunkles Grau). Im Sprite ist der gesamte Rock von der Taille bis zum Knie bernsteinfarben, wie der Mantel (bernstein 3). Anteil der Datensatzfarbe am Rock: 4 %. Korrektur: Rock dunkelgrau gemäß Datensatz, Mantel bleibt.
2. **B08 (Verdacht, zu klären):** Weißes Tuch über dem Hinterkopf, Rückansicht, unter dem Hut bis zum Nacken. Im Datensatz nicht vorgesehen (Hut, Gehstock). Wirkt wie Verband oder Laken. Laken ist nach K9 §8 verboten, Verletzungsdarstellung über „Beule“ hinaus ebenso. Die Vorderansicht zeigt nur ein Halstuch, das ist unkritisch. Klärung: Tuch am Hinterkopf entfernen oder begründen.

Geprüft ohne Befund:
- Grün (Rampe 5): nur bei R03 und R04 vorhanden (Pixelzählung, alle anderen Figuren 0 Pixel).
- Wanderstiefel (braun, Schaft, dicke Sohle): keine braunen Schaftstiefel außer R03 und R04. Braune Schuhe bei R05, R09, R16 sind Halbschuhe laut Datensatz.
- K9 §8 (Taler, Schlüsselbund, Laken, Stablampe, eiserner Kerzenständer, Zettel): nicht sichtbar, außer dem Verdacht bei B08. Regenschirm (B16) und Gehstock (B08) sind als solche erkennbar.
- Pixeldichte: alle 65 Figuren im selben 2-px-Raster.

## Hinweise (kein Verstoß, nicht gewertet)

- B30, B36, R16: Hose bzw. Sakko um eine Farbstufe dunkler als im Datensatz (B30 und B36 Hose neutral 4 erscheint als neutral 3, R16 Sakko neutral 4 gemischt mit 3 und 5). B33: Kleid stein 3 erscheint um ein bis zwei Stufen dunkler. Im Spiel nicht sicher unterscheidbar.
- B24: Hose stein 3 ist vom Mantel verdeckt, kein Befund.
- B39: Haar im Sprite ingwer, Datensatz „braun“ (kein Kleidungsbefund, siehe Grenzfall).
- B32: Haar als hoher Dutt statt „kurz“ (Frisur, keine Farbe).
- R19: Der im Merkmal genannte rote Kameragurt fehlt im Sprite. Die Kamera ist nur als dunkles Viereck erkennbar.
- R17: blaue Teile an der Hüfte, im Datensatz nicht genannt; als Taschen lesbar.
- B33 und B13 (je Seite): kleines weißes Detail vor dem Gesicht, nicht eindeutig identifizierbar.

## Gesamturteil

**Abnahme: NEIN.**

Begründung: B16 entspricht bei Rock und Farbe nicht dem Datensatz. Das Tuch am Hinterkopf von B08 ist zu klären. Nach Korrektur von B16 und Klärung von B08 ist die Aufstellung nach den Kriterien dieses Auftrags abnahmefähig. Die Grenzfälle sind Empfehlungen und keine Abnahmebedingung, außer das Team entscheidet anders.

Endmeldung: `AUFTRAG A-605c/d FERTIG · nachtlauf/bilder/phase3/figuren_aufstellung.png · Paare: 0 · Verstöße: 2 · Abnahme nein`

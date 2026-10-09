# Abschlussbericht · Nachtlauf „Spuk im Gewölbe – Burgstadt Schartenfels“

*Stand: siehe letzte Zeile. Maßgeblich für die Abnahme ist allein `belege/abnahme.txt`, erzeugt von `dart run tool/abnahme.dart`.*

## 1. Ergebnis in Kürze

Aus „Mordakte“ ist ein Ich-Perspektive-Krimi mit 2,5D-Pixelfiguren geworden. Er spielt in einer verschlossenen, nächtlichen Burgstadt im Stil siebenbürgischer Oberstädte. Der Fall „Spuk im Gewölbe“ folgt dem verbindlichen Kanon und ist an die Stadt angepasst; jede Anpassung steht in `kanon/ANPASSUNG.md`. Gespielt wird allein mit Bots oder im WLAN mit 4 bis 20 Rollen. Der Bestand („Klassische Fälle“) bleibt erreichbar.

- **Bedienung:** Touch, Tastatur mit Maus und Gamepad; Bildschirme quer und hoch.
- **Stadt:**
  - 160 Gebäude in 6 Vierteln, 59 betretbare Innenräume, davon 12 Fall-Orte.
  - Gangnetz, Wehrgang, Fledermäuse.
  - 44 Stadtbewohner mit eigenem Nachtplan.
- **Fall:**
  - 257 Kanon-Hinweise und 24 Stadt-Hinweise, 180 Gespräche, Entscheidungen, Punkte, Eingrenzung, vier Enden.
  - Detektivblick mit 7 Spurenarten; jede der 20 Rollen hat eine eigene Sichtschicht oder Fähigkeit; die Täterin kann Spuren verwischen.
  - Teilen an Einzelne oder an die Fallakte, mit Fäden zwischen Hinweisen.
- **Mehrspieler im lokalen Netz:** Lobby mit Code und Adresse. Fehlende Rollen spielen Bots, Spoiler sind geschützt.
- **Darstellung:**
  - Eigener Software-Rasterer mit fester 64-Farben-Palette.
  - 66 Figuren in 8 Richtungen mit Animationen, Porträts mit 4 Ausdrücken.
- **Rund ums Spiel:** Erzähler, Tutorial, prozedurale Klänge und Musik, Stadtkarte mit Schnellreise, Kompass, Speichern und Fortsetzen, Optionen.

## 2. Abnahme Z-01 … Z-14

Die Tabelle mit Messwerten und Belegen steht in `ABNAHME.md`, das Protokoll des vollständigen Testlaufs aller elf Ebenen in `belege/alle_tests_voll.txt`.

## 3. Bilder

**Hauptmenü und Erkundung mit Tutorial**

![Hauptmenü](bilder/z02/quer/01_hauptmenue.png)
![Erkundung im Gewölbe](bilder/z02/quer/03_erkundung_tutorial.png)

**Oberstadt: Marktviertel, Kirchhügel, Untere Stadt**

![Marktviertel](bilder/z02/quer/viertel_marktviertel.png)
![Kirchhügel](bilder/z02/quer/viertel_kirchhuegel.png)
![Untere Stadt](bilder/z02/quer/viertel_untere_stadt.png)

**Innenräume: Stadtmuseum, Kirchenburg**

![Stadtmuseum](bilder/z02/quer/innen_innen_museum.png)
![Kirchenburg](bilder/z02/quer/innen_innen_kirche.png)

**Fallakte, Lagerunde, Ende**

![Fallakte](bilder/z02/quer/fallakte.png)
![Lagerunde](bilder/z02/quer/lagerunde_phase1.png)
![Ende](bilder/z02/quer/ende.png)

**Stadtkarte und WLAN-Spiel**

![Stadtkarte](bilder/phase6/stadtkarte_quer.png)
![WLAN](bilder/phase6/wlan_wahl_quer.png)

**Hochformat (Handy)**

![Erkundung hochkant](bilder/z02/hoch/03_erkundung_tutorial.png)

**Figuren-Aufstellung: 66 Figuren, je vorne, seitlich und hinten**

![Figuren-Aufstellung](bilder/phase3/figuren_aufstellung.png)

**Porträts mit 4 Ausdrücken**

![Porträts](bilder/phase3/portraets.png)

## 4. Prüfungen durch unabhängige Prüfer

- **Figuren (Z-03):**
  - Bis zur Endrunde gab es zwölf Sichtprüfungen. Die Prüfer maßen anfangs sehr verschieden (E30).
  - Die Endrunde (Prüfer 11 und 12) lief mit dem festen Maßstab aus Z-03: 0 verwechselbare Paare, 0 Regelverstöße.
  - Knappe Grenzfälle (nicht gezählt): BW/B12, B29/B41, R09/B12, R06/R08, B13/B43, B13/B33, R02/R14.
- **Inhalt (Z-12):** fünf Runden Gegenprüfung (A-702b bis f). Die Befunde sind umgesetzt oder begründet abgewogen (E23, E27, E29, E31).
- **Leitplanken-Scanner:** 0 Treffer in allen Spieltexten.
- **Fairness:** Der Löser bestätigt für N = 4…20, dass jeder notwendige Schluss abgesichert ist. Das Durchspiel mit Bots endet bei jeder Rollenzahl als Meisterdetektiv. Teilen spart 72 % der Schritte.

## 5. Was in der Nacht schiefging (ehrlich)

- **Testskript (E28):** Der Gesamttest verschluckte rote Pakettests (`… || echo "keine Tests"`). Drei Commits trugen deshalb einen roten Datentest: 02ab9b5, d511fac und 7574641. Gefunden, behoben und für alle Commits nachgeprüft (`belege/historie_pakettests.txt`). Die Geschichte ist nicht umgeschrieben.
- **abnahme.dart (E31):** Der erste Lauf endete still ohne Ergebnis, weil ein Future an einem schon beendeten Strom hing. Das ist behoben.
- **Zeitangaben:** Zwei Einträge im Entscheidungslog trugen geschätzte statt gemessene Uhrzeiten. Sie sind korrigiert. Ein Stundeneintrag im Nachtprotokoll (gegen 03:00) fehlt und wurde zusammengefasst nachgetragen.
- **Leistungsspitze (E36):**
  - Messungen unter Parallellast (Agenten kompilierten gleichzeitig) zeigten beim Figurenbacken einzelne Spitzen von 27 und 54 ms Wanduhrzeit. Ein Lauf war deshalb rot.
  - Das Speicherbereinigungs-Protokoll schließt die Speicherbereinigung als Ursache aus. Die Ursache war Verdrängung durch andere Prozesse.
  - Seitdem misst `bin/leistung.dart` die Prozessorzeit des Spielthreads (`CLOCK_THREAD_CPUTIME_ID`); die Wanduhrzeit steht weiter als Information im Protokoll. Beleg in `belege/leistung_z09.txt`.
- **Figurenkarten von Hand (E38):** Nach Sichtprüfer 13 habe ich vier Bewohnerkarten von Hand nachgeschärft. Die ersten Werte erzeugten drei neue enge Paare. Gefunden hat sie `karten_test` vor dem Commit; eingecheckt wurde erst die Fassung ohne Paare.

## 6. Nicht gebaut oder nur genähert

Siehe `FUER-DEN-NUTZER.md`. Kurz:

- Nicht gebaut: Neigen (Sensor-Abhängigkeit), Bildschirm wach halten beim Gastgeber, Suche im WLAN ohne Adresse und QR-Code, Wiederverbinden in der App, Desktop-Plattformordner.
- **Balancing:**
  - Spielzeit je Phase rund 8, 11 und 11 Minuten (Tempo 65/480).
  - Bots lösen bei jeder Rollenzahl.
  - Feinabstimmung mit echten Gruppen steht aus.

## 7. Starten

Siehe `ANLEITUNG.md` (Start, Steuerung je Gerät, WLAN, Speichern, Optionen).

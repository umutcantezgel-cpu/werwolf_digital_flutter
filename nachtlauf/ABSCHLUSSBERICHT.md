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

**Ergebnis:** `tool/abnahme.dart` bestätigt am Stand a28178c **14 von 14** Kriterien (`belege/abnahme.txt`). Grundlage ist der grüne Gesamtlauf aller elf Ebenen am Code-Stand 6f0d724; danach hat sich nur `nachtlauf/` geändert.

Messwerte aus diesem Lauf:
- Spiellogik 0,14 ms je Bild (Grenze 4), Nachladespitze 18,6 ms (Grenze 50), Speicherwachstum 6,3 % (Grenze 10).
- Teilen kommt nach höchstens 43 ms an (Grenze 1000); Teilen spart 72 % der Schritte (Grenze 30).
- Erkundungsbots erreichen 134 von 134 Türen; 0 Konsolenfehler in 3 Geräteprofilen.

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
  - Es gab 20 Sichtprüfungen. Die Prüfer maßen anfangs sehr verschieden (E30). Danach galt ein fester Maßstab (Z-03, Punkt 5a).
  - Auch mit festem Maßstab werteten Prüfer Fälle knapp an der Schwelle unterschiedlich (z. B. BW/B12, DET/B24). Seit E40 steckt der Maßstab deshalb im Figurenvergleich selbst: gleiche Farbfamilie an Rumpf und Beinen, Größe bis 5 Sprite-Pixel und gleicher Kopf gilt als verwechselbar. Der Generator verteilt die Bewohner danach, und `karten_test` prüft es.
  - Endrunde am Kartenstand fc94af9295: Sichtprüfer 19 und 20 unabhängig voneinander mit 0 verwechselbaren Paaren und 0 Regelverstößen.
  - Gefundene Fehler, die nur Menschenaugen sehen: Kopfbedeckungen in Haarfarben lasen sich als Haar (B13, B14, B34, B39). Die Regel dagegen steht jetzt im Generator und im Test.
- **Inhalt (Z-12):**
  - Zwölf Runden Gegenprüfung (A-702b bis m). Jede Runde fand feinere Punkte. Umgesetzt oder begründet abgewogen ist alles in E23 bis E40.
  - Darunter: das Herkunftsmuster in den Familienfeldern des Kanons (E38/E39, per Overlay, Kanon-Dateien unverändert), Altersbilder, Gruppenwörter („Putzfrau“, „Hausfrau“), Spuren-Echos in Stadttexten und eine geschlechtsbezogene Anrede der spielenden Person.
  - Letzte Runde (A-702m, Stand a7f1985): Leitplanken ja, Kanontreu ja, Plagiatsfrei ja. Ihre 5 geringen Befunde stehen nach der Abbruchregel (E40) in `FUER-DEN-NUTZER.md`.
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
- **Viele Sichtprüf-Runden (E38–E40):** Nach den neuen Signaturteilen (Kameragurt, Kopfhörer) brauchte Z-03 vier weitere Prüferpaare (13 bis 20). Gefunden wurden: B13 mit einer Haube, die wie rotes Haar aussah; R06/R08; BW/B12; DET/B24. Meine Korrekturen von Hand haben das Problem dabei teils nur zum nächsten Nachbarn verschoben. Beendet hat das erst der Maßstab im Figurenvergleich selbst (E40).
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

*Stand: 09.10. 09:17 (Europe/Berlin), Branch `nachtlauf/burgstadt`.*

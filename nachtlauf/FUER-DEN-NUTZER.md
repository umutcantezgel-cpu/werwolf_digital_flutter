# FÜR DEN NUTZER – was nur Menschen prüfen oder entscheiden können

## Auf echten Geräten prüfen
- **WLAN-Spiel mit mehreren Handys.** Getestet ist das Protokoll mit 4, 8 und 20 simulierten Teilnehmern über echte WebSockets (room_host/test/mp_sim.dart), dazu die Spielsitzungen von Gastgeber und Gast (burgstadt_spiel/test/wlan_test.dart). Nicht getestet ist ein echtes WLAN mit mehreren Geräten.
- **iOS:** Die Berechtigung „Lokales Netzwerk“ ist eingetragen (`NSLocalNetworkUsageDescription`). Ob die Abfrage auf einem iPhone erscheint und ob Gäste das Gerät erreichen, lässt sich nur auf echter Hardware prüfen. iOS-Builds gehen nur auf macOS.
- **Spielgefühl der Ich-Perspektive:** Bewegungsübelkeit, Touch-Steuerung, Blick-Empfindlichkeit, Lesbarkeit der Pixeltexte auf kleinen Bildschirmen.
- **Leistung auf echter Mittelklasse-Hardware.** Im Container gibt es nur Desktop-CPUs. Gemessen wurde mit Faktor 4 (AOT) und mit Chrome-CPU-Drosselung (siehe `belege/leistung_z09.txt`); beides ist eine Näherung, keine Handy-Messung.
- **Web-Fassung im Browser:** Im Container (Headless-Chrome, Software-Darstellung, ohne Drosselung) lief sie mit 33 Bildern pro Sekunde am Desktop-Profil und mit 15–17 am Handy-Profil, das mit dreifacher Pixeldichte größere Puffer braucht (`bilder/geraete/bericht.txt`). Die native App (AOT) braucht für ein Bild im Mittel 2,8 ms auf der Desktop-CPU. Gedacht ist das Spiel für die App. Probehalber gebaut (nicht im Repo): Ein WebAssembly-Build (`flutter build web --wasm`) halbiert die Rechenzeit je Bild (10 statt 20 ms) und bringt 47 bzw. 25 Bilder pro Sekunde. Er gibt aber eine Konsolenwarnung zum Multithreading aus (die Seite ist nicht cross-origin-isolated); deshalb bleibt der geprüfte Web-Build vorerst dart2js.
- **Klang:** Alle Geräusche und die Musik sind prozedural erzeugt. Ob sie angenehm sind, kann nur ein Ohr beurteilen.

## Nicht umgesetzt (bewusst, mit Grund)
- **Neigen zum Umsehen:** Dafür bräuchte es eine neue Abhängigkeit (`sensors_plus`). Die Option ist deshalb nicht im Menü; stattdessen gibt es die Blick-Empfindlichkeit.
- **Bildschirm wach halten beim Gastgeber:** `wakelock_plus` wäre eine neue Abhängigkeit. Bis dahin muss die Bildschirmsperre des Gastgeber-Handys länger eingestellt werden.
- **Partie im WLAN ohne Adresse finden** (mDNS über `bonsoir`) und **QR-Code zum Beitreten:** nicht gebaut. Beitreten geht über Adresse und Code.
- **Wiederverbinden mit derselben Rolle:** Das Protokoll kann es (Token), die App bietet es noch nicht an. Nach einem Verbindungsabbruch läuft die Rolle beim Gastgeber weiter.
- **Desktop-Fassungen** (Windows, macOS, Linux): Die Plattformordner fehlen (`flutter create --platforms=…`).
- **Sprachausgabe:** Das Projekt hat keine. Erzählertexte werden angezeigt, nicht vorgelesen.

## Bitte entscheiden
- **Kanon-Anpassung „bewusstlos“ → „benommen“ (E29):** Die Leitplanken erlauben als Verletzungsbeschreibung nur „Beule“, „benommen“ und „Kühlpack“. Deshalb ersetzt das Overlay das Kanonwort „bewusstlos“ im ganzen Spiel durch „benommen“. Die Dateien in `krimidinner/` sind unverändert. Wenn der Kanon des Krimidinners selbst angepasst werden soll, sollte das dort geschehen.
- **Familienfelder der Rollen (E38):**
  - Im Kanon hatten fast alle Rollen mit nichtdeutschen Wurzeln ein Fest, eine Speise oder ein Instrument als Familienmerkmal (z. B. Pierogi, Newroz, Revani), die Rollen mit deutschen Wurzeln kaum.
  - Die Inhaltsprüfung wertete dieses Muster als Klischee-Risiko. Deshalb fasst das Overlay (`kanon/ANPASSUNG.md`, Abschnitt „Familienfelder“) bei 12 Rollen nur diesen einen Satzteil herkunftsneutral; alles andere bleibt.
  - Das Spiel zeigt das Feld Familie ohnehin nicht an. Die Kanon-Dateien des Krimidinners sind unverändert.
  - Wenn dir die ursprünglichen Details lieber sind, genügt es, diesen Abschnitt im Overlay zu löschen.
- **Abwägungen der Inhaltsprüfung:** Einige Punkte bleiben bewusst so, mit Begründung in E23, E27, E29 und E38. Dazu gehören die Spuren des Falls, die auf die Täterin zeigen (das ist das Rätsel), „Einspruch!“ bei R18 (Kanon) und die erfundene Figur des Detektivs.
- **Frisuren älterer Bewohnerinnen (E40):** Mehrere ältere Bewohnerinnen tragen laut `bewohner.json` einen Dutt. Die Inhaltsprüfung (Runde 11) nannte das ein mögliches Altersbild. Eine Änderung ist leicht (Feld `frisur`), braucht aber neue Sichtprüfungen der Figuren. Sie ist deshalb nicht in dieser Nacht gemacht.
- **Kanon v1.0 (E41, E42):** `main` brachte den fertigen Kanon v1.0. Er ist eingearbeitet; die Kanon-Dateien selbst sind unverändert. Für die Kanon-Autoren:
  - **FM-1** (Funktionsmatrix, [L], im Spiel nicht sichtbar) ordnete die Tatfunktionen nach Herkunftsgruppen, und ihre Begründung widerspricht dem Kanon selbst (R02 legt den Hebel um). Im wirksamen Kanon steht sie jetzt nach Rollen-IDs ohne Herkunft (Overlay, E43). Vorschlag für die Kanon-Datei: dieselbe Fassung übernehmen.
  - **Wetter:** K-002 sagt „klarer Himmel“, Nebel nur im Tal. Die Stadttexte sind angeglichen (E43). Wer Nebel in der Oberstadt will, müsste K-002 ändern.
  - **LISTE-ZEITEN** nennt „00:01 der Burgwart wird … gefunden und kommt zu sich“; BS-01 und PF-3 nennen 00:00:25 bzw. 00:00:50. Vorschlag: „kurz nach Mitternacht“.
  - **Phase 1 beginnt** im Spiel jetzt wie in Z-0030 um 00:30. Vorher war es 00:25, der Zeitpunkt des Auftrags des Burgwarts.
  - **Das Gespensterlaken** ist jetzt wie im Kanon (Z-2140) Burgwäsche „Schartenfels 7“. Die Pension der Stadt hat einen eigenen blauen Stempel.
- **„Spur verwischen“ (R03):** Nur die Täterin kann eine Spur verwischen, und „verwischt“ sehen alle mit Detektivblick. Wer die Fähigkeit hat, bleibt geheim. Ein Prüfer schlug vor, sie zusätzlich einer unschuldigen Rolle zu geben. Das wäre eine neue falsche Fährte und damit eine Kanon-Entscheidung (E42).
- **Kleine Textpunkte aus Inhaltsrunde 12 (A-702m, Urteil ja · ja · ja):** Nach der Abbruchregel in E40 sind sie gesammelt statt umgesetzt; jeder ist eine Ein-Satz-Änderung in `bewohner.json` bzw. `haeuser.json`.
  - B24 nennt „den Brunnen“ der Oberstadt, der nicht in LISTE-ORTE steht. Vorschlag: „Pferdebrunnen“ (H-002) oder „Marktplatz“.
  - B15 spricht von „den Alten“ und „Schützlingen“. Vorschlag: „Leute im Haus“, „Bewohner“.
  - B18 nennt die Eule über der Tür „aus Holz“, H-004 eine steinerne Eule über dem Dachfenster. Angleichen.
  - B44 (Gerücht): „der Riese sei damit ins Tal gerutscht“ streichen, wie schon bei H-034.
  - Inschriften H-053 und H-132 („wer nicht gesehen werden will“, „was sie verbirgt“): neutraler fassen, damit nichts nach Verstecken klingt.
- **Figuren:** Die ersten Sichtprüfer bewerteten sehr unterschiedlich (E30). Seitdem gilt ein fester Maßstab, und `karten_test` prüft die Unterscheidbarkeit zusätzlich automatisch. Ein menschlicher Blick auf `bilder/phase3/figuren_aufstellung.png` ist trotzdem sinnvoll.
- **Rote Pakettests in drei Commits (E28):** Ein Fehler im Testskript hat bei 02ab9b5, d511fac und 7574641 einen roten Datentest verschluckt. Behoben und belegt; die Geschichte ist nicht umgeschrieben.

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
- **Figuren:** Die ersten Sichtprüfer bewerteten sehr unterschiedlich (E30). Seitdem gilt ein fester Maßstab, und `karten_test` prüft die Unterscheidbarkeit zusätzlich automatisch. Ein menschlicher Blick auf `bilder/phase3/figuren_aufstellung.png` ist trotzdem sinnvoll.
- **Rote Pakettests in drei Commits (E28):** Ein Fehler im Testskript hat bei 02ab9b5, d511fac und 7574641 einen roten Datentest verschluckt. Behoben und belegt; die Geschichte ist nicht umgeschrieben.

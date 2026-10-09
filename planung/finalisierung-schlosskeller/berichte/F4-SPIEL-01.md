ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 1 · Grenzen 2 · Summe 9/10 (nur 54 Fotos gelesen; Befunde 2–5, 7–9 behoben, 1 und 6 kein Befund bzw. Fotozeitpunkt, E-037)

# Bericht F4-SPIEL-01

## Bericht F4-SPIEL-01

**GEPRÜFT**
- **Läufe** (bericht.md, bericht.json): ahmet und fatma je 20 Läufe (n = 4, 7, 12, 16, 20 pro Ende) plus je ein Semantik-Lauf (n = 7, ende_meister), zusammen 42. Alle bestanden, Endname wie erwartet, Punkte konsistent, Fehler und fremde Einträge leer. Die Sammelzahl 84/84 gilt auch für olli und can, die ich nicht gesichtet habe.
  - Ergebnis je Ende (gleich für ahmet und fatma): ende_meister (richtig) 9 Punkte, ende_teilerfolg (richtig) 0, ende_justizirrtum (falsch) 9, ende_eskalation (falsch) 0.
- **Fotos:** 54 Bilder aus 8 Läufen mit n = 7.
  - ahmet_ende_meister_n7: alle 21 Pflichtfotos plus 11 weitere (010, 011, 012, 016, 017, 022, 036, 037, 048, 049, 054).
  - fatma_ende_meister_n7: 050, 052, 056, 057.
  - Übrige sechs Läufe: nur 052 (finale), 056 (aufloesung_r3) und 057 (ende).
  - Nicht gesichtet: rund 125 weitere Pflichtfotos (Kontextgrenze). B8 im fatma-Pfad vor dem Finale ist deshalb nicht fotografisch geprüft.
- **Kanon und Code** nur gelesen: fall.json, texte/*.json, figuren.json, packages/mordakte_core/lib/src/party/erzaehler.dart, lib/party/bildschirme/aufloesung.dart.

**ERGEBNIS JE PRÜFPUNKT**

| Prüfpunkt | Status | Fundstellen |
|---|---|---|
| Endname im Finale und auf dem Ende-Bildschirm | erfüllt (8/8) | 052, 057 in allen 8 Läufen |
| Punkte passen zur Spielweise | erfüllt (8/8) | 057; bericht.json |
| Rundenuhr gleich in Zentrale, Karte, Erzähler | erfüllt | ahmet_meister 006/007 (00:30), 021/022 (01:15), 036/037 (02:00) |
| Kein Täterhinweis vor dem Finale außer verdeckt | erfüllt für ahmet_meister; fatma nur 050 | verdeckt: 004, 017; geteilt ohne Täternennung: 006–021, 035, 036, 048–050 |
| Sackgassen | keine gefunden | 017 und 051: Bestätigungsknopf vor der Wahl inaktiv; Ende ohne Knopf laut Code (F7) |
| Verständlichkeit | verletzt | F3, F8 |
| Texte widerspruchsfrei | verletzt | F1, F2, F4, F9 |
| B1 Raum folgt Kanon | nicht prüfbar (teils) | 010, 022 zeigen Theke und Tafeln; Rüstung, Vitrine, Wendeltreppe nicht im Ausschnitt |
| B2 Nebel des Krieges | erfüllt | 007, 010, 022, 037 |
| B3 Licht der Ermittlung | erfüllt | 007 (grünes Notausgangsschild), 010, 022 (Lichtkegel) |
| B4 Figuren erkennbar | erfüllt (Stichprobe) | 007, 010 |
| B5 Ziele und Handlung | erfüllt | 007 Befragen/Damir; 010 Befragen/Emine; 022 Untersuchen; 037 Absuchen |
| B6 Inhaltsregeln im Bild | erfüllt (Stichprobe) | keine Flaschen, Gläser oder Schrift in der Szene |
| B7 Bildschirme lesbar | verletzt | 002 (F5); Uhrzeiten konsistent; Scrolltexte nicht abgeschnitten |
| B8 Spoilerschutz | erfüllt für ahmet_meister | Täterrolle nur in 004 und 017 |
| B9 Rückblende | teils erfüllt | 052–055: Uhr läuft (23:54 bis 00:15); zwei hervorgehobene Figuren in 053–055; kein Joystick, kein Aktionsknopf. Stromausfall-Look nicht sicher prüfbar. Der Erzähltext der Rückblende steht laut Code unter dem Finaltext und ist auf den Fotos nicht zu sehen. |

**BEFUNDE**

1. **mittel** · /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/ahmet_ende_meister_n7/050_resuemee_r3.png (gleich: .../fatma_ende_meister_n7/050_resuemee_r3.png) · Resümee Runde 3, Fach „Stand der Verdächtigen“ · sichtbar: „Die Spuren haben sich gelichtet – jetzt liegt es an dir.“, also genau eine Restperson ohne Namen · erwartet: bei gutem Spiel zwei Restverdächtige mit Namen. Kanon fall.json, Runde 3: „Bei gutem Spiel stehen zwei Restverdächtige dem Schlüsselbeweis gegenüber.“ Die Anklage (.../ahmet_ende_meister_n7/051_anklage.png) zeigt weiterhin „vier Verdächtigen“. Ursache: erzaehler.dart, Zeilen 101–102, wählt bei genau einer Restperson den Baustein „eins“. Das kann bei gutem Spiel als indirekter Hinweis gelesen werden. · kleinste Änderung: Restmenge nach Runde 3 bei gutem Spiel auf zwei Personen bringen, sonst fall.json und Anklagetext angleichen.
2. **mittel** · /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/ahmet_ende_meister_n7/036_gespraeche_r3.png · Rundenkopf Runde 3 · sichtbar: „Bei gutem Spiel stehen zwei Restverdächtige dem Schlüsselbeweis gegenüber.“ (das Kern-Feld aus fall.json wird als Untertitel gezeigt) · erwartet: kein Spielmechanik-Hinweis vor dem Finale; widerspricht dem Resümee derselben Partie (050) · kleinste Änderung: Kern-Feld der Runde 3 nicht anzeigen oder neutral formulieren.
3. **mittel** · .../ahmet_ende_meister_n7/009_fund_e1_1.png und .../012_fund_e1_2.png · Entscheidungskarte im Hintergrund · sichtbar: Fund zu Entscheidung 1 (Damir) unter „ENTSCHEIDUNG 2 VON 9“; Fund zu Entscheidung 2 (Emine) unter „ENTSCHEIDUNG 3 VON 9“ · erwartet: Fund und Überschrift gehören zur selben Entscheidung · kleinste Änderung: Zähler und Frage im Hintergrund erst nach „Verstanden“ umschalten.
4. **mittel** · .../ahmet_ende_meister_n7/056_aufloesung_r3.png (Absatz Ahmet) gegenüber .../052_finale.png · Auflösung: „Herrn Schneider geht es gut.“ · Finaltext (nur per Scrollen sichtbar, Kanon erzaehler-finale-ahmet.json): „Er hat eine Beule und eine Gedächtnislücke.“ · erwartet: ein einheitlicher Zustand für Herrn Schneider · kleinste Änderung: Satz „geht es gut“ in den Auflösungen der Täter (Kanon erzaehler-aufloesung.json) streichen oder an die Beule anpassen.
5. **schwer (Regelwortlaut „Text abgeschnitten“)** · /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/ahmet_ende_meister_n7/002_einrichtung.png · sieben Namensfelder · sichtbar: „Name am Tisc…“; Kanon ui-einrichtung.json: „Name am Tisch (optional)“ · erwartet: vollständiger Platzhalter · kleinste Änderung: Feld breiter machen oder „Name (optional)“. Inhaltlich nur Eingabehilfe, die Funktion bleibt klar; Schwere ggf. auf mittel setzen.
6. **leicht** · .../ahmet_ende_meister_n7/008_endgueltig_e1_1.png, identisch mit 009 · unbesetzter Gast Damir: keine Bestätigung „Das ist endgültig“ (sie erscheint bei Emine in .../011_endgueltig_e1_2.png) · erwartet: klären, ob die Bestätigung auch für Gäste ohne Rolle gilt, sonst Fotostelle anpassen.
7. **leicht** · .../ahmet_ende_meister_n7/057_ende.png (alle Enden) · kein Knopf; „Mit diesem Code startet derselbe Fall noch einmal genauso.“ nennt keinen Weg · erwartet: Weg zum Neustart oder Hinweis, wo der Code eingegeben wird · kleinste Änderung: Knopf „Neuer Abend“. Der Kommentar in lib/party/bildschirme/aufloesung.dart, Zeile 10, nennt den fehlenden Weiter-Knopf als Absicht.
8. **leicht** · .../ahmet_ende_meister_n7/007_ziel_e1_1.png (auch 010, 022, 037) · Schaltfläche „Ohne Karte wählen“ · für Gäste nicht erkennbar, was sie tut · kleinste Änderung: klarere Beschriftung nach Prüfung der Funktion.
9. **leicht** · .../ahmet_ende_meister_n7/005_intro.png („Schauvitrine“) gegenüber .../056_aufloesung_r3.png („Turmvitrine“) · prüfen, ob dasselbe Objekt gemeint ist; sonst vereinheitlichen.

**GESAMTURTEIL:** Nein. Endlogik und Punkte stimmen in den acht gesichteten Läufen, aber der Stand nach Runde 3 widerspricht Kanon und Anklage, die Fundkarten stehen unter der falschen Entscheidung, und ein Platzhalter ist abgeschnitten.

## OFFENE FRAGEN
- Bleiben bei gutem Spiel nach Runde 3 zwei oder eine Restperson übrig? Kanon (fall.json) und Code (erzaehler.dart) widersprechen sich.
- Soll die Bestätigung „Das ist endgültig“ auch bei unbesetzten Gästen gelten?
- Ist der Stromausfall-Look der Rückblende vor 23:58 gewollt? Auf den Fotos nicht sicher unterscheidbar (B9).
- Soll die Prüfung der übrigen rund 125 Pflichtfotos nachgeholt werden, besonders B8 im fatma-Pfad?

SELBSTPRÜFUNG: Alle Prüfpunkte bewertet, nicht sicher Prüfbares als „nicht prüfbar“ markiert. Jeder Befund hat Foto und Stelle. Beurteilt wurde nur Sichtbares; Kanon- und Codebezüge (F1, F2, F4, F7) sind als solche gekennzeichnet.

=== ENDE F4-SPIEL-01 · BEREIT ZUR RÜCKGABE ===

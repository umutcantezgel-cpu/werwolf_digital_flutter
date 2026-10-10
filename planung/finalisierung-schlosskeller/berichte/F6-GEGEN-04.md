## Bericht F6-GEGEN-04

Gegenprüfer · Bauphase F6 · Kanon v1.0.0 · Auftragsstand f26f2de. `git status` zeigte keine Änderungen an getrackten Dateien. Kein `git log`. Geschrieben nur im Scratch-Ordner `/tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-GEGEN-04/`.

### GEPRÜFT
- **Log:** E-039 vollständig; E-024 (Regeln, Bonus, Nachtrag zur Ausschlussregel, Verworfen-Liste), E-025 (GEGEN #6a, FALL #2, FALL #3), E-014 (W-1), E-029 (Finale). E-035 und E-036 nur im Bezug auf GEGEN-01 Nr. 4 und 5. GEGEN-01 vollständig, GEGEN-02 als Bezug gelesen.
- **Werkzeuge:** `party_simulate` OK (bestes Spiel Restmenge 4/2/1; beste feste Folge 8/7/8/7; drei feste Folgen mit mindestens 7 Punkten in allen Pfaden). `party_pruefen` OK (22 Personen). `party_texte` OK (1601 Texte). Ausgaben in `simulate.txt`, `pruefen.txt`, `texte.txt`.
- **Eigene Nachrechnung** (`nachrechnung.py`, nur Kanon-JSON, keine Dart-Logik): alle 768 Optionsfolgen je Pfad, Restmenge nach R1, R2 und R3 mit R-ENTLASTET und R-UEBERFUEHRT. Das Modell stimmt mit dem Simulator überein: Restmenge nach R3 128/40/240/360 (Ahmet, Can) und 128/60/280/300 (Fatma, Olli); Enden 55/713/1635/669; 640 Anklagen des Täters bei Restmenge über 1; 704 bzw. 784 Anklagen außerhalb der Restmenge.
- **Pfad Can:** tatmatrix/can.json, beobachtungen (b_damir_ahmet_weg, b_damir_ahmet_blieb, b_ahmet_haelt, b_ahmet_jacke), texte/dossiers-b1.json, texte/taeter-can.json, texte/erzaehler-aufloesung.json (aufloesung.ahmet.unschuldig.can), bonus.json (h_can_3_wahr), entscheidungen.json (Begründungen e2_1, e3_3), tatmatrix/basis.json (Umfeld 23:55 bis 00:02), raeume.json.
- **Rollenhefte:** `packages/mordakte_core/lib/src/party/texte.dart`, Z. 156: Im eigenen Pfad ist das Dossier einer Kernrolle die Täterfassung. Das Rollenheft „noch bevor es scheppert“ erscheint im Pfad Can nicht, also kein Widerspruch.
- **Bonus:** Namen je Runde über alle vier Pfade mit Wortgrenzen geprüft, Flexionsformen (Fatmas, Cans) manuell ergänzt. Alle zwölf falschen Hinweise sind durch eine richtige Entscheidung des eigenen Pfads widerlegbar.
- **Nicht geprüft:** Druck, Fotos, Gruppenwahl-Ausgänge. Sie liegen außerhalb der Logikprüfung.

### ERGEBNIS JE PRÜFPUNKT

| Prüfpunkt | Ergebnis | Beleg |
|---|---|---|
| GEGEN-01 Nr. 1: Can, Restmenge 1 nach R2 | behoben | Nach R2 nie Restmenge 1; Minimum 2 (48 Folgen je Pfad) |
| GEGEN-01 Nr. 2: Can, allein nach R3 über Beleg | behoben | 0 Folgen allein ohne Überführung nach R3 |
| GEGEN-01 Nr. 3: Spätankunft nur bei Täterrolle | behoben nach Vorschlag, Restheuristik bleibt | Pfad Can: Ahmet spät und unschuldig; bestes Spiel nach R1 je Pfad 1 Spätankunft und 2 Alibis; Spätperson = Täter in 3 von 4 Pfaden (Offene Frage 1) |
| GEGEN-01 Nr. 6: Namen nur bei einer Qualität | behoben | Je Runde über alle Pfade mindestens zwei Qualitäten pro Name; R1 neutral ohne Name |
| GEGEN-01 Nr. 7: Kerzenständer | behoben | 4 Funde je Pfad; harmlos/belastend je Spur 0,69 bis 0,84 (Kriterium E-039 „mindestens halb“ erfüllt) |
| GEGEN-01 Nr. 8: Prüfwerkzeug | nur teilweise | Ausschlussprüfung nur im Kontext des besten Spiels (simulator.dart Z. 123 bis 140), siehe Befund 1 |
| GEGEN-01 Nr. 9: Sabotage bei vier Rollen | nicht geprüft | Vermerk übernommen |
| E-039: nie nur eine Person vor R3 | bestätigt | Alle 768 Folgen je Pfad |
| E-039: allein übrig nur mit Schlüsselbeweis und Fundort derselben Person | bestätigt | 0 Gegenbeispiele je Pfad |
| E-039: nach R1 genau eine Spätankunft und zwei Alibis | bestätigt | Bestes Spiel je Pfad |
| E-039: keine falsche Option schließt mehr aus, ohne Ausnahme | widerlegt | 80 Vorgeschichten je Pfad Fatma und Olli, Befund 1 |
| Pfad Can: Uhrzeiten | konsistent | Ahmet am Ostende 23:58:22; Jackenständer bis 23:59:02; Umschlag in Jacke 23:58:32; Scheppern 23:58:40; Rückkehr 23:59:10; Umschlag heraus 00:09:12; Ascheneimer 00:12:00 (Hana 00:11:30 bis 00:12:10) |
| Pfad Can: Orte und Sätze | überwiegend konsistent | Befund 3 (Ortsbezug Anrichte) |
| Pfad Can: wer nimmt den Gang wahr | nur Damir | Gang im Dunkeln am Ostende; Sicherungskasten liegt im Westsaal; Leyla geht 23:57:40 zur Ost-Tafel West, dort ohne Sehen und ohne Hörbeleg; kein Befund |
| Pfad Can: Auflösung, Täterfassung, Dossier | konsistent | Keine Abweichung |
| Bonus: falsch widerlegbar, Qualität nicht ablesbar | ja | Satzform je Runde gleich, Neutrale pfadgleich |
| Kerzenständer: Zahl der Funde | 4 in allen Pfaden | Keine Deduplizierung mehr nötig |

### BEFUNDE

**Befund 1 · mittel · Entscheidung e3_3 (Option e3_3_aylin mit Fakt f_nd_ahmet_quittung gegen e3_3_zeynep); Prüfung in simulator.dart Z. 123 bis 140**

Die Aussage „keine falsche Option schließt mehr aus als die richtige, ohne Ausnahme“ (E-039) stimmt nicht. In den Pfaden Fatma und Olli gibt es je 80 Vorgeschichten, in denen die falsche Option e3_3_aylin einen Ausschluss bewirkt und die richtige e3_3_zeynep keinen. Ahmet und Can sind nie betroffen (0 Fälle), weil dort kein Alibi für Ahmet oder Can entsteht.

Beispiel Pfad Fatma: e1_1 Damir, e1_2 Emine, e1_3 Azra (richtig); e2_1 Bauchtasche (falsch); e2_2 Tasche und e2_3 Olli (richtig); e3_1 Turmgang (falsch); e3_2 Fatma (richtig). Vor e3_3 ist die Restmenge {Ahmet, Fatma, Can}. Aylin deckt Ahmets Quittung auf; Ahmet hat Alibi aus Damir und jetzt auch ein Nebendelikt, also scheidet er aus. Ergebnis: Restmenge {Fatma, Can}, 6 Punkte. Mit Zeynep bleibt {Ahmet, Fatma, Can}, 7 Punkte. Pfad Olli: Aylin ergibt 5 Punkte und {Can, Olli}, Zeynep 6 Punkte und {Ahmet, Can, Olli}.

Die Simulator-Prüfung vergleicht nur mit dem Stand des besten Spiels und erkennt den Fall nicht. Sie verletzt die Regel aus dem E-024-Nachtrag (Regel Zeile 489): Eine falsche Option darf nur mehr ausschließen, wenn die richtige ein belastendes Indiz gegen die Täterperson zeigt. Zeynep zeigt in Fatma und Olli nur das Nebendelikt Cans.

- **Erwartet:** Keine falsche Option schließt mehr aus als die richtige, auch nicht nach einer falschen Vorentscheidung (E-024-Nachtrag; E-039).
- **Änderung:** Entweder f_nd_ahmet_quittung in den Pfaden Fatma und Olli nicht als Nebendelikt führen (dort als Umgebung oder Lüge, ohne Ausschluss), oder e3_3_zeynep in diesen Pfaden ein belastendes Indiz gegen die Täterperson geben. Den Simulator auf alle Vorgeschichten erweitern und die Aussage in E-039 korrigieren.

**Befund 2 · mittel · Bonus-Hinweise h_ahmet_3_wahr, h_fatma_3_wahr, h_olli_3_wahr, h_can_3_wahr (R3, wirkung „entlastet“ für die zweite Restperson)**

Bei zwei Restverdächtigen nach R3 ohne Überführung ersetzt der wahre R3-Hinweis den Schlüsselbeweis. Er entlastet die zweite Person, und der Täter ist dann ohne Überführung bestimmt. Das betrifft 14 Folgen je Pfad (Restmenge 2, Anklage des Täters, mindestens 7 Punkte).

Beispiel Pfad Ahmet: R1 und R2 richtig; e3_1 Ostsaal (richtig, Fundort Ahmet); e3_2 Fatma (falsch); e3_3 Zeynep (richtig). Ergebnis: 8 Punkte, Restmenge {Ahmet, Can}, kein Schlüsselbeweis. Der wahre Hinweis „Das leuchtende Gesicht rannte schon vor dem Scheppern durch den Durchgang“ entlastet Can, und die Anklage Ahmet ergibt Meister. Pfad Fatma analog mit e3_1 Buffetsaal, e3_2 Kerzenständer (falsch), e3_3 Zeynep: 8 Punkte, {Fatma, Can}.

Der Log begründet die Entlastung als formal ausschlussfrei: „Die Entlastung schließt nie allein aus, weil R-ENTLASTET zusätzlich das belegte Nebendelikt verlangt“ (E-024, Bonus-Hinweise). Das gilt für die Restmenge. Der Tisch sieht aber nur die Aussage. Die Bestätigung durch eine Entscheidung (E-025, FALL #2) fehlt in diesen Folgen. Das Meister-Ende verlangt sie nach E-029 nicht, weil das Finale nur Pfad, Ende und Punkte kennt.

- **Erwartet:** Nach R3 bestimmt der Schlüsselbeweis den Täter (Master 7.6, R-UEBERFUEHRT). Ein Hinweis ersetzt ihn nicht.
- **Änderung:** Die R3-Wahrhinweise in allen vier Pfaden auf eine pfadgleiche Aussage ohne Entlastungswirkung umstellen (z. B. die Beobachtung b_serkan_tor, Pfade alle). Alternativ entscheiden, ob das Meister-Ende Überführung voraussetzen soll; E-029 hat das Finale bewusst nur auf Pfad, Ende und Punkte gestützt. E-024 und E-025 entsprechend nachtragen. Entscheidung beim Orchestrator.

**Befund 3 · leicht · Bonus-Hinweis h_can_3_wahr (Pfad Can, R3)**

„Beim Scheppern war Ahmet nicht an der Anrichte, sondern drüben im Ost-Saal an seiner Jacke“ nennt einen anderen Ort als der Trenner-Satz und die Auflösung. Laut aufloesung.ahmet.unschuldig.can kauert Ahmet „hinter der Theke am Ostende, neben Damir“. Die Anrichte mit dem Kerzenständer ist im Pfad Ahmet der Tatort (taeter-ahmet: „Dann gehst du zum Kerzenlicht an der Anrichte“). Der Satz ist wahr, verweist den Pfad Can aber auf den Ort eines anderen Pfads.

- **Erwartet:** Der Bonus nennt denselben Ort wie der Trenner-Satz.
- **Änderung:** „Beim Scheppern war Ahmet nicht am Ostende der Theke bei Damir, sondern drüben im Ost-Saal an seiner Jacke.“

### BEKANNT (vom Log entschieden, kein Befund)
- **Meister ohne Überführung:** 26 Folgen je Pfad (14 mit Restmenge 2, 12 mit 3). Bewusst, E-029 und E-039 SPIEL-02 Nr. 6. Unterschied zu Befund 2: dort fehlt die Entlastung als Hinweis, hier nur der Beweis.
- **Negativbefund am Kerzenständer im Pfad Fatma:** Ohne Schlüsselbeweis von Ahmet, Can oder Olli kann der Tisch Fatma erkennen, und Meister mit 7 bis 8 Punkten ist ohne Ring möglich. E-024: „Wer aus dem Fehlen einer Spur selbst schließt, spielt gut; die Restmenge bleibt eine sichere Untergrenze.“
- **Zusatzindiz nach bestem R2:** Nur der Täter trägt Wachs (f_z_ahmet, f_z_fatma, f_z_olli, f_z_can). E-024: „im Täterpfad zusätzlich das Zusatzindiz“.
- **Gästewissen lenkt die Optionen:** npc.leyla.2 und npc.meryem.2 lenken R2 auf e2_1 Ascheneimer (richtig in drei Pfaden). npc.kaan.3 und npc.selin.3 lenken R3 auf e3_1 Turmgang (richtig nur im Pfad Can). E-039 Nr. 5 (V).

### GESAMTURTEIL
Nicht freigabefähig ohne Nachbesserung. E-039 behebt die Logikbefunde GEGEN-01 Nr. 1, 2, 3, 6 und 7 nachweislich: Nach R2 bleibt nie eine Restperson, im Pfad Can kann Ahmet ohne Alibi nicht ausscheiden, und Namen sowie Kerzenständer sind pfadgleich. Zwei Aussagen stimmen nicht: Die Ausschlussregel gilt nicht ohne Ausnahme (Befund 1), und der wahre R3-Hinweis ersetzt bei zwei Restverdächtigen den Schlüsselbeweis (Befund 2). Der Pfad Can ist inhaltlich konsistent bis auf den Ortsbezug in Befund 3.

Selbstprüfung: Alle Prüfpunkte bewertet. Jeder Befund hat eine Fundstelle und ein erwartetes Verhalten. Gegengelesen: E-024, E-025, E-029, E-039 und die Bezüge in E-035 und E-036.

### OFFENE FRAGEN (für den Orchestrator)
1. Nach R1 zeigt die Spätperson in drei von vier Pfaden die Täterperson, im Pfad Can ist es Ahmet (unschuldig). Ist diese Trefferquote von 75 Prozent gewollt? E-039 Nr. 3 hat die Falle für Can gesetzt, nicht für die anderen drei Pfade.
2. Nach bestem R2 identifiziert das Zusatzindiz (Wachs) die Täterperson. Die Designabsicht (Gewalt von Nebendelikt trennen, Master 7.6) macht die R3-Gegenüberstellung zur Beweisfrage. Bestätigen oder ändern.
3. Die Gästewissen-Bausteine vergeben Punkte ohne Ableitung (R2 in drei Pfaden, R3 im Pfad Can). Restpunkt zu E-039 Nr. 5.

=== ENDE F6-GEGEN-04 · BEREIT ZUR RÜCKGABE ===

## Strukturierte Befunde und Gegenproben

Urteil des Prüfers: Nicht freigabefähig ohne Nachbesserung: E-039 behebt GEGEN-01 Nr. 1, 2, 3, 6 und 7 nachweislich, aber die Aussage „keine falsche Option schließt mehr aus“ ist falsch (80 Vorgeschichten je Pfad in Fatma und Olli), und der wahre R3-Hinweis ersetzt bei zwei Restverdächtigen den Schlüsselbeweis (14 Folgen je Pfad).

### Befund 1 · mittel
- **Ort:** /home/user/werwolf_digital_flutter/content/party/schlosskeller/entscheidungen.json, Entscheidung e3_3 (Option e3_3_aylin mit Fakt f_nd_ahmet_quittung gegen e3_3_zeynep); /home/user/werwolf_digital_flutter/packages/mordakte_core/lib/src/party/simulator.dart Z. 123 bis 140
- **Befund:** Im Pfad Fatma (ebenso Olli) gibt es 80 Vorgeschichten, in denen die falsche Option e3_3_aylin einen Ausschluss bewirkt (Ahmet mit Alibi aus Damir und Nebendelikt Quittung) und die richtige e3_3_zeynep keinen. Beispiel Fatma: e1 Damir/Emine/Azra richtig, e2_1 Bauchtasche falsch, e2_2 und e2_3 richtig, e3_1 Turmgang falsch, e3_2 Fatma richtig; Aylin ergibt Restmenge {Fatma, Can} und 6 Punkte, Zeynep {Ahmet, Fatma, Can} und 7 Punkte. Die Simulator-Prüfung vergleicht nur im Kontext des besten Spiels. Ahmet und Can sind nie betroffen (0 Fälle).
- **Erwartet:** Keine falsche Option schließt mehr aus als die richtige, auch nicht nach einer falschen Vorentscheidung (E-024-Nachtrag, Regel Zeile 489; E-039 ohne Ausnahme).
- **Änderung:** Entweder f_nd_ahmet_quittung in den Pfaden Fatma und Olli nicht als Nebendelikt führen (Umgebung oder Lüge, ohne Ausschluss), oder e3_3_zeynep in diesen Pfaden ein belastendes Indiz gegen die Täterperson geben. Simulator-Prüfung auf alle Vorgeschichten erweitern; E-039-Aussage korrigieren.
- **Gegenprobe:** hält (mittel). Der Befund hält: Der Simulator prüft „keine falsche Option schließt mehr aus“ nur im Kontext des besten Spiels (simulator.dart Z. 125 bis 140, Vorgeschichte `vorher` nur aus richtigen Optionen), obwohl E-039 die Regel „ohne Ausnahme“ führt. Meine unabhängige Nachrechnung über alle Vorgeschichten bestätigt 80 Fälle in Fatma und 80 in Olli, in denen Aylins Beleg (Ahmet mit Alibi aus Damir plus Nebendelikt) mehr ausschließt als Zeynep, deren Fakt (Cans Nebendelikt) keine belastende Wirkung gegen die Täterin hat. Das ist auch nach der E-024-Ausnahme eine Verletzung, und das Log entscheidet den Punkt nicht gegenteilig; die Wirkung bleibt mittel, weil das beste Spiel und die Lösbarkeit unberührt sind.
  - Nachgeprüft: Entscheidungslog E-024 (Nachtrag, Zeile 489), E-039 (Zeilen 1106 bis 1181, Zeile 1126 und 1133) gelesen; Simulator-Quelltext simulator.dart Z. 95 bis 160 und entscheidungen.dart (Restmenge, Regeln, faktenVon) gelesen. Werkzeuge ausgeführt: party_simulate (OK, Restmengen 128/40/240/360 und 128/60/280/300 nach R3), party_pruefen (OK), party_texte (1601 Texte OK). Eigenes Python-Skript (scratchpad/f6/gegenprobe/gegen.py, nur Kanon-JSON gelesen, Existenz der Fakten je Pfad aus beobachtungen.json und Tatmatrix nachgebildet) über alle 768 Folgen je Pfad und alle Vorgeschichten jeder Entscheidung: 160 Verstöße, alle bei e3_3_aylin in den Pfaden Fatma und Olli (je 80), 0 in Ahmet und Can, keine weiteren Verstöße in anderen Entscheidungen. Handgeprüft: Beispielverlauf Fatma (e2_1 Bauchtasche, e3_1 Turmgang, e3_2 Fatma), Aylin Rest {Fatma, Can} gegen Zeynep {Ahmet, Fatma, Can}. Keine Dateien im Repo geändert, git status leer.

### Befund 2 · mittel
- **Ort:** /home/user/werwolf_digital_flutter/content/party/schlosskeller/bonus.json, Hinweise h_ahmet_3_wahr, h_fatma_3_wahr, h_olli_3_wahr, h_can_3_wahr; Log: E-024 (Bonus-Hinweise, wahr R3), E-025 (GEGEN #6a, FALL #2, FALL #3), E-029 (Finale nur Pfad, Ende, Punkte)
- **Befund:** Bei zwei Restverdächtigen nach R3 ohne Überführung entlastet der wahre R3-Hinweis die zweite Person und bestimmt den Täter ohne Schlüsselbeweis. Das betrifft 14 Folgen je Pfad (Restmenge 2, Anklage Täter, mindestens 7 Punkte). Beispiel Ahmet: R1 und R2 richtig, e3_1 Ostsaal, e3_2 Fatma falsch, e3_3 Zeynep richtig; 8 Punkte, Restmenge {Ahmet, Can}; der wahre Satz entlastet Can, Anklage Ahmet ergibt Meister. Der Log begründet nur die Restmenge (formal ausschlussfrei), nicht die Ableitung am Tisch; die Bestätigung über eine Entscheidung (E-025 FALL #2) fehlt in diesen Folgen.
- **Erwartet:** Nach R3 bestimmt der Schlüsselbeweis den Täter (Master 7.6, R-UEBERFUEHRT); ein Hinweis ersetzt ihn nicht.
- **Änderung:** Die R3-Wahrhinweise in allen vier Pfaden auf eine pfadgleiche Aussage ohne Entlastungswirkung umstellen (z. B. Beobachtung b_serkan_tor, Pfade alle). Alternativ entscheiden, ob das Meister-Ende Überführung voraussetzen soll (E-029 spricht dagegen). E-024 und E-025 entsprechend nachtragen; Entscheidung beim Orchestrator.
- **Gegenprobe:** hält (schwer). Der Befund hält. Die Fundstelle zeigt die Lücke: h_ahmet_3_wahr entlastet Can (Lauf um 23:58:28 vor dem Scheppern um 23:58:39), und e3_3_zeynep liefert in derselben Runde Cans Nebendelikt, so dass beide Bausteine von R-ENTLASTET zusammenkommen, obwohl das Log hints nur formal ausschließt. Das Log widerlegt den Punkt nicht, denn E-024 und E-025 begründen nur die formale Restmenge ("nie allein"), nicht die Ableitung am Tisch; fall.json W-1 sagt im Wortlaut ebenfalls nur "nie allein". Ich stufe schwer statt mittel ein, weil das Meister-Ende ohne Schlüsselbeweis erreichbar ist, was die Rubrik für schwer (Abkürzung) nennt, und weil der Befund in allen vier Pfaden gilt (je 14 Folgen, davon 11 mit Nebendelikt der Entlasteten).
  - Nachgeprüft: Gelesen: ENTSCHEIDUNGSLOG E-024, E-025 (Tabelle GEGEN #6a, FALL #2, FALL #3), E-029 (Finale und Ausgang), E-039 (Abschnitt Pfad Can und Befundtabelle); MASTER-PROMPT 7.6 bis 7.9; SCHLUESSEL.md Abschnitt Finale; bonus.json (alle vier h_*_3_wahr); entscheidungen.json (Fakten, Optionen, richtig je Pfad, e3_1 bis e3_3); fall.json (Endenmatrix, Regel W-1 im Wortlaut "entlastet aber nie allein"); beobachtungen.json (b_damir_ahmet_weg, b_marek_vor, b_marek_nach, b_zeynep_vorrat, b_azra_olli_frueh, b_emine_fatma_frueh, b_damir_ahmet_blieb); gegenstaende.json (Spur-Bedingungen, Bund-Verstecke je Pfad); tatmatrix ahmet.json und can.json (Zeitpunkte: Can läuft 23:58:28, Scheppern 23:58:39 bis 23:58:40). Eigenes Skript /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/gegenprobe/restmenge.py: alle 768 Optionsfolgen je Pfad, Restmenge nach R-ENTLASTET und R-UEBERFUEHRT, Punkte gegen richtig. Ergebnis: Das Beispiel des Befunds stimmt (Pfad Ahmet, 8 Punkte, Restmenge {Ahmet, Can}). Je Pfad 14 Folgen mit Restmenge {Täter, Entlastete}, Anklage Täter, mindestens 7 Punkte, davon 11 mit Nebendelikt der entlasteten Person (variante.py). Can hat im Kanon kein Alibi-Faktum, so dass R-ENTLASTET ihn nie allein entfernt. Nicht ausgeführt: party_simulate, party_pruefen, party_texte (nicht Teil dieses Befunds). git: nur git status, ohne Befund.

### Befund 3 · leicht
- **Ort:** /home/user/werwolf_digital_flutter/content/party/schlosskeller/bonus.json, Hinweis h_can_3_wahr; Vergleich /home/user/werwolf_digital_flutter/content/party/schlosskeller/beobachtungen.json (b_damir_ahmet_weg) und /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/erzaehler-aufloesung.json (aufloesung.ahmet.unschuldig.can)
- **Befund:** Der wahre R3-Hinweis im Pfad Can nennt „die Anrichte“ als Ort, an dem Ahmet nicht war. Der Trenner-Satz und die Auflösung nennen den Ostende der Theke neben Damir. Die Anrichte mit dem Kerzenständer ist im Pfad Ahmet der Tatort (texte/taeter-ahmet.json). Der Satz ist wahr, verweist aber den Pfad Can auf einen Ort aus einem anderen Pfad.
- **Erwartet:** Der Bonus nennt denselben Ort wie der Trenner-Satz (Ostende der Theke).
- **Änderung:** „Beim Scheppern war Ahmet nicht am Ostende der Theke bei Damir, sondern drüben im Ost-Saal an seiner Jacke.“

## Abnahme (Orchestrator)
- FREIGEGEBEN · 10/10
- Funktion 2 · Kanon-Treue 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2
- Entscheidungen zu jedem Befund: ENTSCHEIDUNGSLOG E-040.

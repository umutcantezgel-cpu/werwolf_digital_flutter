ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (Befunde 3–8 behoben; 1 und 2 kein Befund: Gästewissen pfadgleich, Restmenge ist Schluss des Detektivs, E-037)

# Bericht F4-SPIEL-02

## Bericht F4-SPIEL-02

Basis der Fotos: /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/

**GEPRÜFT**
- Berichte: bericht.md und bericht.json, 84 von 84 bestanden, `fehler` und `fremd` leer, „Fehler je Lauf: keine“.
- Läufe olli und can, alle Personenzahlen: je 20 Läufe (vier Enden × n 4/7/12/16/20) plus Semantik-Lauf 83 (olli) und 84 (can). Alle bestanden. Ende und Punkte wie erwartet: meister 9, teilerfolg 0, justizirrtum 9, eskalation 0. Keine Fehler. Dauer ohne Fotos 67–95 s, mit Fotos 177–185 s.
- Fotos: acht Foto-Läufe (olli und can × vier Enden, n7), je 57 Stellen. Etwa 65 Bilder wurden tatsächlich gelesen. Bilder, die über alle acht Läufe pixelgleich sind, gelten als gelesen, sobald eine Vertreterdatei gelesen ist.
- Pflichtfotos (21 je Lauf) gelesen oder pixelgleich abgedeckt. In Klammern stehen die nicht gelesenen Stellen, die ich nicht bewertet habe:
  - olli_ende_meister_n7: 19 (008, 009)
  - olli_ende_justizirrtum_n7: 19 (008, 009)
  - can_ende_meister_n7: 19 (001, 020)
  - can_ende_justizirrtum_n7: 19 (001, 020)
  - can_ende_teilerfolg_n7: 17 (001, 020, 035, 050)
  - can_ende_eskalation_n7: 15 (001, 008, 020, 035, 050, 056)
  - olli_ende_teilerfolg_n7: 13 (001, 007, 008, 009, 020, 035, 050, 052)
  - olli_ende_eskalation_n7: 13 (001, 007, 008, 009, 020, 035, 050, 056)
  - Titelbilder der Varianten B und C sind nur pixelverglichen; der Unterschied liegt im Leuchten.

| Prüfpunkt | Ergebnis | Fundstellen |
|---|---|---|
| Ende im Finale und auf dem Ende-Bildschirm passt zum Lauf | erfüllt (8/8) | 052/053 und 057 je Lauf |
| Punkte passen zur Spielweise (best 9, schlecht 0) | erfüllt (8/8); Zwischenwerte nicht getestet | 057, bericht.json |
| Täter und Fall-Code am Ende-Bildschirm | erfüllt: Olli 4HTFW, Can KLRVK | 057 |
| Uhrzeit je Runde in Rundenzentrale und Erzählertext | erfüllt für 00:30, 01:15, 02:00 | olli_ende_meister_n7 006, 021, 036 |
| Uhrzeit in der Karte | erfüllt für Runde 1; Runde 2 und 3 nicht gesehen | 007 |
| Rückblende-Uhr läuft weiter (B9) | erfüllt: 053 vor 055 in allen acht Läufen | 053, 055 |
| Kein gemeinsamer Bildschirm nennt die Täterrolle vor dem Finale (B8) | verletzt, Verdacht | 036 (Befund 1), 050 (Befund 2) |
| Verdeckte Ansichten als einzige Ausnahme (B8) | erfüllt für die gelesenen Fälle; wahl_verdeckt nicht gelesen | 004 (Tim, nicht Täter) |
| Anklage ohne Täter-Markierung | erfüllt | 051, in allen acht identisch |
| Kein abgeschnittener Text (B7) | verletzt | 002 (Befund 3), 052 (Befund 4) |
| Knöpfe als Knöpfe erkennbar (B7) | verletzt, mittel | can_ende_eskalation_n7 007 (Befund 5) |
| Nebel, Licht, Ziele, Befragen-Knopf (B2, B3, B5) | erfüllt in den gelesenen Karten | 007 |
| Karte vor dem Finale pfadgleich (K-1) | erfüllt, Stichprobe | olli und can eskalation 007: 16 Pixel am Zielring |
| Anleitungen, Fragen, Fundkarten verständlich | erfüllt | 009, 018, 019 |
| Sackgassen | keine gefunden | bericht.json |
| Doppelte oder unfertige Texte | verletzt, leicht | 006 (Befund 6), 003 (Befund 8) |
| Fehler in bericht.json | keine | bericht.json |

**BEFUNDE**

1. **SCHWER (Verdacht, B8)** · /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/olli_ende_meister_n7/036_gespraeche_r3.png (in allen acht Läufen identisch) · Rundenstart Runde 3, Baustein eines unbesetzten Gastes · sichtbar: „Acht Minuten vor zwölf sagte Olli: ‚Ich hol dir Eis. Und dann red ich mit Schneider.‘“ · erwartet: Laut B8 darf kein gemeinsamer Bildschirm vor dem Finale Täterwissen nennen. Der Satz ist laut /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/taeter-olli.json (tatwissen 1) Täterwissen Ollis, steht hier aber auf dem gemeinsamen Bildschirm (npc.kaan.3 in erzaehler-npc.json). Der Wortlaut ist in allen Pfaden gleich; ob das als pfadneutral gilt, muss der Kanon-Autor entscheiden. · kleinste Änderung: Satz streichen oder den Baustein in die verdeckte Wojtek-Ansicht verlegen.

2. **SCHWER (Verdacht, Spoiler durch Ausschluss)** · /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/olli_ende_meister_n7/050_resuemee_r3.png (identisch mit can_ende_meister_n7/050 und den Justizirrtum-Läufen) · Zwischenresümee nach Runde 3, Fach „Stand der Verdächtigen“ · sichtbar: „Die Spuren haben sich gelichtet – jetzt liegt es an dir.“, also eine Restperson ohne Namen · erwartet: Der Rundenstart 3 verspricht „zwei Restverdächtige“ (kern in /home/user/werwolf_digital_flutter/content/party/schlosskeller/fall.json, runden[2]). Nach Runde 2 zeigt 035 noch „Olli und Can“. Runde 3 reduziert auf eine Person, der Täter ist damit ableitbar. Quelle: /home/user/werwolf_digital_flutter/packages/mordakte_core/lib/src/party/erzaehler.dart, restSchluessel (Zeilen 99–104), gespeist aus der Restmenge der bekannten Fakten. · kleinste Änderung: Restmenge in Runde 3 nicht unter zwei fallen lassen oder den Text „eins“ erst nach der Anklage zeigen. Entscheidung des Kanon-Autors nötig.

3. **SCHWER (B7, abgeschnittener Text)** · /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/olli_ende_meister_n7/002_einrichtung.png (in allen acht identisch) · Namensfelder der sieben Personen · sichtbar: „Name am Tisc…“ · erwartet: vollständiger Platzhalter „Name am Tisch (optional)“ oder ein kürzeres Label · kleinste Änderung: Platzhalter auf „Name (optional)“ kürzen. Diesen Text trägt das Feld des Geburtstagskindes schon (ui-einrichtung.json).

4. **MITTEL (B7, Scroll-Schnitt im Finale)** · /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/can_ende_eskalation_n7/052_finale.png und olli_ende_meister_n7/052_finale.png · Erzählerbox unter der Rückblende · sichtbar: Der Text läuft unter den Weiter-Balken aus, ohne sichtbaren Scroll-Hinweis · erwartet: Erzähltext vollständig sichtbar oder klarer Scroll-Hinweis · Quelle: /home/user/werwolf_digital_flutter/lib/party/bildschirme/finale.dart (Rückblende fest 55 % Höhe, Rest im scrollbaren Rahmen) · kleinste Änderung: Rückblende-Kasten etwas kleiner oder einen Scroll-Hinweis setzen.

5. **MITTEL (B7, Knöpfe)** · /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/can_ende_eskalation_n7/007_ziel_e1_1.png · Entscheidungskopf · sichtbar: „Ohne Karte wählen“ und „Notizbuch“ nur als orangefarbene Textzeilen ohne Fläche oder Rahmen · erwartet: als Knöpfe erkennbar · kleinste Änderung: Rahmen oder Flächenstil geben.

6. **LEICHT (Doppelung)** · /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/olli_ende_meister_n7/006_gespraeche_r1.png · Rundenstart 1 · sichtbar: „Alle vier Kernverdächtigen haben gute Gründe, nahe der Theke gewesen zu sein.“ steht direkt unter dem Rundentitel und fast wortgleich im Erzählertext · erwartet: einmal · kleinste Änderung: den Satz aus runde.1.start (erzaehler-runden.json) streichen.

7. **LEICHT (Uhrzeitformat)** · /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/olli_ende_teilerfolg_n7/055_rueckblende_3.png · Rückblende-Uhr · sichtbar: „Im Keller ist es 00:15 Uhr.“, alle anderen Frames mit Sekunden, etwa „00:12:37 Uhr.“ · Quelle: /home/user/werwolf_digital_flutter/packages/mordakte_core/lib/src/party/zeit.dart, toString lässt Sekunden bei 0 bewusst weg · kleinste Änderung: Sekunden immer anzeigen.

8. **LEICHT (Doppelung)** · /home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/olli_ende_meister_n7/003_rollen.png · Rollenliste · sichtbar: „Ahmet“ und darunter „Ahmet · Der Organisator“ · kleinste Änderung: Untertitel nur mit dem Rollentitel.

**GESAMTURTEIL**
Nicht freigabefähig: Zwei Spoiler-Verdachtspunkte vor dem Finale (036, 050) und ein abgeschnittener Platzhalter im Einrichtungsbildschirm (002) stehen dagegen. Enden, Punkte, Täter, Fall-Code und Uhrzeiten sind in den gelesenen Bildern durchgehend konsistent.

## OFFENE FRAGEN
- Soll nach Runde 3 eine Restperson bleiben (Befund 2) oder sollen zwei übrig bleiben?
- Sind die falschen Bonus-Hinweise der schlechten Gruppen gewollt? Beispiele: olli_ende_eskalation_n7/034_bonus_r2.png („Fatma hat … die Bogentür beschädigt“), can_ende_eskalation_n7/034_bonus_r2.png („Olli hat … die Münzschatulle … genommen“).
- Die Rückblende zeigt bei 00:12:37 (olli_ende_meister_n7/055_rueckblende_3.png) noch dunkle Kulisse, obwohl der Erzähltext sagt, dass das Licht um Mitternacht angeht. Das gehört zu B9 und ist nicht Teil dieser Prüfung.
- Die Läufe prüfen nur 0 und 9 Punkte. Zwischenwerte (zum Beispiel 7 oder 8 bei Meister) sind nicht getestet.
- Nicht gelesen: Entscheidungen 2 und 3 (Fotos 022–045), wahl_verdeckt_r1–3, gruppenwahl_r2 und _r3, bonus_r3 sowie die zweiten Varianten von resuemee_r1–r3 und aufloesung_r3.

**SELBSTPRÜFUNG:** Jeder Prüfpunkt bewertet? Ja, alle Zeilen der Tabelle. Jeder Befund mit Foto und Stelle? Ja. Nur Sichtbares beurteilt? Ja, mit Einschränkung: Einige Bildübertragungen wurden vom Werkzeug abgelehnt. Bewertet habe ich nur gelesene oder pixelgleiche Bilder. Eine frühere Zwischenbeschreibung enthielt Inhalte aus nicht übertragenen Bildern. Sie ist verworfen und fließt nicht in diesen Bericht ein.

=== ENDE F4-SPIEL-02 · BEREIT ZUR RÜCKGABE ===

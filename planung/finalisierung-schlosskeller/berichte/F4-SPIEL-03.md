ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (Befunde 2–5 behoben, E-038; 1 kein Befund: Satz ist im Kanon pfadneutral und Teil der gemeinsamen Zeitleiste; 6 und 7 situativ bzw. Fotozeitpunkt)

# Bericht F4-SPIEL-03

## Bericht F4-SPIEL-03

- **GEPRÜFT:**
  - **Läufe:** bericht.md und bericht.json, 84/84 bestanden, Fehler leer. Die 16 Fotoläufe (je 57 Stellen) stammen laut `/home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/belege/E2E-17173e2.md` aus Commit 17173e2.
  - **Als Bild gelesen** (Basis `/home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/`):
    - `fatma_ende_meister_n7` vollständig (57). `fatma_ende_justizirrtum_n7` vollständig (57; 22 Stellen sind byte-gleich zu fatma_meister und dort gelesen).
    - `olli_ende_meister_n7`: alle Auftragsstellen (016, 017, 031, 032, 033, 046, 047, 049, 010–015, 022–030, 037–045; 048 byte-gleich zu fatma) sowie 034, 035, 052, 055, 057.
    - `ahmet_ende_meister_n7`: 002, 003, 005, 006, 009, 052–055, 057. Dazu `ahmet_ende_teilerfolg_n7/057` und `ahmet_ende_eskalation_n7/057`.
    - `can_ende_meister_n7`: 052–055. Außerdem `raeume/buffetsaal.png`.
  - **Nicht gesichtet:** olli 001, 008, 009, 019, 053, 054, 056; can außer 052–055; ahmet justizirrtum. Byte-gleiche Stellen (002–006, 018, 021, 033, 036, 048, 051) gelten über alle 16 Läufe.
  - Einige Bildaufrufe kamen ohne Bild zurück. Diese Stellen habe ich nicht gewertet und danach neu gelesen.

- **ERGEBNIS JE PRÜFPUNKT:**

| Prüfpunkt | Ergebnis | Fundstellen |
|---|---|---|
| E-037 (1) Rückblende: Ring auf Täter, Schneider mit eigenem Ring, Uhr hh:mm:ss | erfüllt, alle vier Täter | ahmet, fatma (beide), can_meister: 052–055; olli: 052, 055 |
| E-037 (2) Platzhalter „Name (optional)“ | erfüllt | 002 |
| E-037 (3) Scrollleiste, Pfeil, Finale über Fußleiste | verletzt: Pfeil verdeckt Text (Befund 2). Leiste vorhanden, Finaltext beginnt über der Fußleiste | 052 je Pfad |
| E-037 (4) Fund unter eigener Entscheidung | erfüllt | fatma_meister/009, ahmet_meister/009 |
| E-037 (5) Rundenkopf ohne „Bei gutem Spiel“ | erfüllt | 006, 021, 036 |
| E-037 (6) Knöpfe mit Rahmen | erfüllt | fatma_meister/007 |
| E-037 (7) Farbpunkte, Ahmets Punkt sichtbar | erfüllt | 002, 003, 018, 051 |
| E-037 (8) Rollenliste ohne Doppelnamen | erfüllt | 003 |
| E-037 (9) Knopf „Zurück ins Hauptmenü“ | erfüllt in allen sechs gesichteten Enden | 057 |
| E-037 (10) Tugba Rostorange, Fatma-Kopftuch im Dunkel | erfüllt | buffetsaal.png |
| Ende und Punkte | erfüllt | 057, siehe Lauftabelle |
| Uhrzeit je Runde (B7) | erfüllt: 00:30, 01:15, 02:00, Karte gleich | 006, 021, 036; 007, 022, 037 |
| B8 kein Täterhinweis vor dem Finale | verletzt (Befund 1) | 036, in allen 16 Läufen gleich |
| B2, B3 Nebel und Licht | erfüllt (Stichprobe) | 022, 037, 053 |
| B4 Figuren | erfüllt (Stichprobe) | buffetsaal.png |
| B5 Ziele und Aktion | verletzt (Befunde 4–6) | fatma 025, 028/029, 040/041; justizirrtum 022 |
| B6 Inhalte im Bild | erfüllt (Stichprobe) | 007, 022, 037 |
| B7 Bildschirme lesbar | verletzt (Befunde 2, 3) | 036, 052 |
| Sackgassen | keine gefunden | alle gelesenen Läufe |

- **JE LAUF:**

| Lauf | Ende, Punkte | Täterhinweis vor Finale | Sackgasse |
|---|---|---|---|
| fatma_meister | Meister, 9, Fatma | Befund 1; Bonus 019, 034 (Ausnahme) | keine |
| fatma_justizirrtum | Justizirrtum, 9, Fatma | Befund 1; Bonus 019, 034 | keine |
| olli_meister | Meister, 9, Olli | Befund 1; Bonus 034 | keine |
| ahmet_meister | Meister, 9, Ahmet | Befund 1 | keine |
| ahmet_teilerfolg, ahmet_eskalation | Teilerfolg 0; Eskalation 0, Ahmet | Befund 1 | keine |
| can_meister | nur Finale und Rückblenden | nicht gesichtet | keine gefunden |

- **BEFUNDE:**
  1. **schwer (B8, Verdacht; neuer Grund).** `/home/user/werwolf_digital_flutter/tool/e2e/fotos/e2e/olli_ende_meister_n7/036_gespraeche_r3.png` (identisch auch in fatma_meister/036 und in allen 16 Läufen). Rundenstart 3, Erzählertext auf dem gemeinsamen Bildschirm: „Acht Minuten vor zwölf sagte Olli: ‚Ich hol dir Eis. Und dann red ich mit Schneider.‘“ Erwartet: kein Täterwissen auf dem gemeinsamen Bildschirm vor dem Finale. Neuer Grund: Der Kanon führt den Satz als Täterwissen Ollis (`/home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/taeter-olli.json`, tatwissen), die Gästequelle steht in `.../texte/erzaehler-npc.json`, Zeile 20. E-037 hat „pfadgleich“ gewertet. Im fatma-Lauf zeigt der Satz Olli als falsche Fährte. Kleinste Änderung: Namen streichen (z. B. „Acht Minuten vor zwölf hörte ich ein Gespräch mit Schneider“) oder den Satz in eine verdeckte Gastansicht legen.
  2. **mittel (B7).** `.../fatma_ende_meister_n7/052_finale.png` („Verzierungen“), `.../fatma_ende_justizirrtum_n7/052_finale.png` („Um sieben Uhr“), `.../olli_ende_meister_n7/052_finale.png` („Kerzenwachstropfen“). Der Scroll-Pfeil liegt auf der letzten sichtbaren Textzeile und verdeckt Buchstaben. Erwartet: Pfeil außerhalb des Textes. Kleinste Änderung: Pfeil an den Kastenrand setzen oder den Textbereich um eine Zeile kürzen.
  3. **mittel (B7).** `.../fatma_ende_meister_n7/036_gespraeche_r3.png` (identisch in allen Läufen). „ZEIT FÜR DIESE RUNDE“ am unteren Rand: Die Ziffern „02:00“ sind vom Pfeil und von der Fußleiste teilweise verdeckt. Erwartet: lesbar wie 00:30 und 01:15. Kleinste Änderung: Zeitkarte über den Pfeil heben.
  4. **mittel (B5).** `.../fatma_ende_meister_n7/028_ziel_e2_3.png` zeigt am Ziel Olli den Knopf „Befragen“, `.../029_endgueltig_e2_3.png` sagt „Olli und seine Weste untersuchen“. Ebenso `.../040_ziel_e3_2.png` und `.../041_endgueltig_e3_2.png` (Fatma: „Fatmas Hände und ihren Ring untersuchen“). Erwartet: gleiches Verb am Knopf und in der Bestätigung. Kleinste Änderung: Optionstexte in `/home/user/werwolf_digital_flutter/content/party/schlosskeller/entscheidungen.json` (e2_3_olli, e3_2_fatma) auf „befragen“ setzen.
  5. **leicht (B5).** `.../fatma_ende_meister_n7/025_ziel_e2_2.png`. Der Knopf „Untersuchen“ zeigt ein Sprechblasen-Symbol statt der Lupe. Das Ziel ist die Person Fatma, die Bestätigung nennt die Tasche. Kleinste Änderung: Symbol nach dem Verb wählen.
  6. **mittel, situativ (B5).** `.../fatma_ende_justizirrtum_n7/022_ziel_e2_1.png`. Die Kante der Entscheidungskarte schneidet den oberen Teil der Buchstaben von „Umschlag mit dem Mietgeld“ ab. Der Name bleibt weitgehend lesbar. Im Meister-Lauf (`.../fatma_ende_meister_n7/022_ziel_e2_1.png`) ist das Schild frei. Kleinste Änderung: Kamerabild so verschieben, dass das Schild unter der Karte liegt.
  7. **leicht (Fotoskript, kein Spielfehler).** `.../fatma_ende_justizirrtum_n7/013_ziel_e1_3.png` zeigt schon die Bestätigung „Azra befragen“, `.../038_endgueltig_e3_1.png` schon die Fundkarte „Brottasche“. Die Fotoreihe ist in diesem Lauf verschoben. Kleinste Änderung: Fotopause vor dem Ablichten prüfen.

- **GESAMTURTEIL:** Nein, nicht freigabefähig: Befund 1 ist ein schwerer B8-Verdacht, dazu kommen die B7-Überlagerungen (2, 3) und die Verb-Abweichung (4). Ende, Punkte, Rundenuhren und die E-037-Korrekturen 1, 2, 4–10 halten im Foto.

## OFFENE FRAGEN
- Ist der Gästesatz aus Befund 1 nach E-037 „pfadgleich“ vertretbar, obwohl der Kanon ihn als Täterwissen führt? Entscheidung beim Kanon-Autor.
- `/home/user/werwolf_digital_flutter/content/party/schlosskeller/fall.json` (runden[2].kern) nennt „zwei Restverdächtige“. Laut `/home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/ENTSCHEIDUNGSLOG.md` (G1-3) bleibt nach Runde 3 bei gutem Spiel genau eine Person, und das Resümee zeigt eine (050). Der Kern-Text ist nicht sichtbar, widerspricht aber dem Kanon.
- Wahre Bonus-Hinweise gegen die Täterin (fatma_meister 019, 034; olli 034) bleiben nach E-025 und E-037 unverändert. Nicht neu gewertet.
- Ob die Fotoverschiebung (Befund 7) am Werkzeug oder an der App liegt, zeigt das Foto nicht.

SELBSTPRÜFUNG: Alle zehn E-037-Punkte, Ende und Punkte, Rundenuhren und B2–B9 sind bewertet. Jeder Befund hat Foto und Stelle. Beurteilt wurde nur Sichtbares; Kanon-Bezüge stehen nur bei Befund 1, 4 und den offenen Fragen.

=== ENDE F4-SPIEL-03 · BEREIT ZUR RÜCKGABE ===

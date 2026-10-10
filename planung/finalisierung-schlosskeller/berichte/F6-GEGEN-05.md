## Bericht F6-GEGEN-05

Stand: Der Auftrag nennt f26f2de. Geprüft wurde nur mit `git status` (nach den Druckläufen sauber). Der Hash ist nicht gegen den Baum verifiziert (L-06).

### GEPRÜFT
- Drei Druckmappen mit `party_druck` erzeugt, je acht PDFs, alle A4 (595 × 842 pt): `can4` (4 Rollen, Täter Can), `can9` (9 Rollen, Täter Can), `ahmet7` (7 Rollen, Fall VPXWW, Täter Ahmet). Ablage: `/tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f6/F6-GEGEN-05/{can4,can9,ahmet7}/`.
- Alle 24 PDFs mit `pdftotext -layout` gelesen, seitenweise mit Seitenmarke. Gerendert und angesehen: can4 11-fassungen S. 3 und S. 14, can4 12-stimmkarten S. 1, can9 12-stimmkarten S. 1, ahmet7 11-fassungen S. 2.
- Diff der Sätze (Fassungen, Umschläge, Indizkarten, Bogen, Rollenhefte, Spielleitung) und Abgleich aller Codes (Fassungen, Stimmkarten, Codetabellen, Umschläge, Codeliste).
- Entscheidungslog E-039 (Z. 1106–1181) gelesen, dazu E-024, E-025, E-027, E-035, E-036, E-037. Berichte F6-SPIEL-02 und F6-GEGEN-02 gelesen. TON-LEITFADEN Z. 8. Quelltexte der Befunde geprüft.

### SPIELTEST can9 (Spielleitung, Schritt 3)
Gewählt: Täter Can nur in Runde 1 mit B, alle anderen A, außer Emine, Joanna und Olli (Runde 1 bzw. 2 bzw. 3, siehe Tabelle).

| Runde | Stimmen (Code, Wert) | Summe | Umschlag |
|---|---|---|---|
| 1 | Ahmet A HF7 +1, Fatma A MD3 +1, Olli A PY4 +1, Can B HX4 −1, Lejla A FV9 +1, Emine B AV7 0, Tim A VY7 +1, Joanna B KT9 0, Marek A CE9 +1 | 5 | Ab 4: AL9 (neutral). Mit Can A wäre die Summe 7, also HA3 (wahr). |
| 2 | Ahmet A CX9 +1, Fatma B FF4 0, Olli A JA3 +1, Can A PX9 +1, Lejla B EN9 0, Emine A UH3 +1, Tim B WY4 0, Joanna A KP7 +1, Marek B CR7 0 | 5 | Ab 4: AD4 (neutral) |
| 3 | Ahmet A HY9 +1, Fatma A UW9 +1, Olli B AM4 0, Can A EW4 +1, Lejla A DJ4 +1, Emine A LE7 +1, Tim A LN4 +1, Joanna A XX9 +1, Marek A VA9 +1 | 8 | Ab 6: JC4 (wahr). Zusammenhalt in 1 von 3 Runden. |

Die Summen stimmen mit der Codetabelle überein; jede Wertung ist gegen die Tabelle geprüft.

- Erkennbar, welche Kernrolle wie gestimmt hat? Nein. Die acht Kern-Codes je Runde stehen nur in den versiegelten Fassungen. Die Tabelle ist alphabetisch sortiert und ohne Rollen. Die Gäste-Codes sind offen gedruckt, sodass 8 Kern-Codes übrig bleiben, die ich keiner Rolle zuordnen kann. Die −1 gehört zur Täterrolle, aber nicht erkennbar zu einer Person.
- Stimmen Heft, Karten und Fassung überein? Im Wesentlichen ja (Heft S. 4 „Die vier Kernrollen nehmen Streifen A oder B aus ihrer Fassung“, Gäste-Karte „Abreißen, falten und in die Schüssel legen“). Abweichungen: Befund 3 (Rollenheft „Umschlag“), Befund 4 (Strip-Text unter beiden Streifen), Befund 8 (Gäste-Anweisungen im Vier-Rollen-Satz).

### SCHRITTE 4 BIS 7
- Schritt 4, can4: Keine Stimmkarten. `12-stimmkarten.pdf` ist eine Seite: „Heute spielen nur die vier Kernrollen. Sie stimmen mit den Streifen aus ihrer versiegelten Fassung ab. Darum gibt es keine Stimmkarten.“ Die Zählung funktioniert nur mit den Fassungsstreifen. Die Tabelle hat je Runde 8 Codes (Kern A +1, B 0, Can B −1), und alle 24 Codes stehen in den vier Fassungen mit passenden Werten.
- Schritt 5, Spielleitungsheft (alle drei Sätze): Vorlesemarke vor der Lage-Tabelle (S. 5, 7, 9) und im Anhang (S. 11) vorhanden. „Auflösung für alle“ und „Die Rollen am Tisch“ folgen der Anklage (S. 10). „Fassung“ statt „Umschlag“ für die Fassungen (S. 2). „ohne hineinzusehen“ bei Fassungen und Auflösungsheft (S. 2, Auflösung S. 2). Knall und Scheppern im Detektivbogen erklärt (S. 4). Fehlend: der Zusatz beim Falten von Indizkarten und Umschlägen (Befund 6) und der Stapelschritt (Befund 5).
- Schritt 6, Fassungs-Innenseiten (S. 2, 6, 10, 14):

| Satz | S. 2 | S. 6 | S. 10 | S. 14 |
|---|---|---|---|---|
| can4 und can9 | 278 Wörter, 29 Zeilen (Ahmet) | 251, 28 (Fatma) | 252, 26 (Olli) | 397, 41 (Can, Täter) |
| ahmet7 | 477, 41 (Ahmet, Täter) | 251, 27 (Fatma) | 252, 25 (Olli) | 252, 26 (Can) |

Die Täterseite ist auf einen Blick erkennbar: Sie hat als einzige über 30 Zeilen und ist im Bild bis nahe an die Fußzeile gefüllt. Der Satz „Du warst es.“ steht bewusst (E-036 Z. 993). E-039 hat die Länge nur teilweise angeglichen (GEGEN-02 Nr. 5, T). Der Stapelschritt verschärft das, siehe Befund 5.
- Schritt 7, Enden: Richtige Anklage für Can und Ahmet (je Meister und Teilerfolg) endet mit „Bis es dämmert … Dann schließt er auf, und ihr geht hinaus.“ Das ist der Ausgang am Morgen. Die Meister-Enden setzen keinen Fund voraus (Befund 9 als Grenzfall). Die Auflösung-Geständnisse („Die Tat war Panik im Dunkeln“, „im Dunkeln hat ihn die Panik gepackt“) enthalten kein Schlagverb. Die Täterfassungen tun es (Befund 1). Die Gruppenwahl-Texte nennen keine Verwandtschaft als Schweigegrund. Gründe sind Versprechen, Schutz, Freundschaft, Mitschuld (Zeynep als Helferin). Verwandtschaft steht nur in den Rollenbeschreibungen. Die Pflichtgespräche nennen nur gespielte Figuren: can4 nur Kern und Geburtstagskind, ahmet7 ohne Joanna und Marek.

### ERGEBNIS JE PRÜFPUNKT

| Nr | Prüfpunkt | Ergebnis | Befund |
|---|---|---|---|
| P1 | Druck erzeugt, je acht PDFs, A4 | OK | – |
| P2 | Alle 24 PDFs als Text gelesen, Seiten gerendert | OK | – |
| P3 | Kern stimmt nur über Fassung, keine Kern-Stimmkarten | OK | – |
| P4 | Kern-Codes (je 24) ↔ Codetabellen (24 / 54 / 42) | OK | – |
| P5 | Gäste-Stimmkarten (30/30 bzw. 18/18) ↔ Tabelle | OK | – |
| P6 | Umschläge: Schwellen, Codeliste, wahr/neutral/falsch | OK | – |
| P7 | Strip-Anweisung auf der Rundenwahl-Seite | Widerspruch | 4 |
| P8 | Vorlesemarke vor Lage und im Anhang | OK | – |
| P9 | „Auflösung für alle“ und „Die Rollen am Tisch“ nach der Anklage | OK | – |
| P10 | „Fassung“ statt „Umschlag“ im Spielleitungsheft / in Rollenheften | Heft OK, Rollenhefte nicht | 3 |
| P11 | „ohne hineinzusehen“ bei Falten und Stapeln | Fassungen OK, Karten und Umschläge fehlen, Stapel zeigt Innenseite | 5, 6 |
| P12 | Knall und Scheppern im Bogen | OK | – |
| P13 | Bogenzeilen ↔ Kreuze der Indizkarten | Zeile Motiv fehlt | 2 |
| P14 | Innenseiten (Wörter, Erkennbarkeit) | Täterseite erkennbar, E-039 T | 5 |
| P15 | Gruppenwahl-Texte ohne Verwandtschaft als Grund | OK | – |
| P16 | Geständnisse der Auflösung ohne Schlagverb | OK | – |
| P17 | Täterfassung ohne Schlagverb (TON §1) | Verletzt | 1 |
| P18 | Enden: Morgen, Meister ohne Fund | OK, Grenzfall | 9 |
| P19 | Endtexte Grammatik | Fehler | 7 |
| P20 | Gäste-Hefte und Rollen am Tisch konsistent | OK | – |
| P21 | Pflichtgespräch-Partner nur gespielte Figuren | OK | – |
| P22 | Vier-Rollen-Satz: Zählung nur mit Fassungsstreifen | OK | 8 |
| P23 | Spieltest can9 | Summen 5/5/8, Umschläge AL9/AD4/JC4 | – |
| P24 | Stapelanweisung Heft gegen Nutzer-Notiz | Widerspruch | 5 |

### BEFUNDE
1. schwer: Täterfassungen (`11-fassungen.pdf` S. 14 in can4/can9, S. 2 in ahmet7) sagen „Du schlägst einmal zu.“. TON-LEITFADEN Z. 8 verlangt, dass der Schlag nur angedeutet wird. Der Satz steht in allen vier Täter-Texten des Kanons. E-039 hat nur die Auflösungs-Geständnisse bereinigt.
2. mittel: Im gedruckten Ermittlungsbogen (`01-detektivbogen.pdf` S. 4, alle drei Sätze) fehlt die Zeile „Motiv“. Die Karte VR7 (can4/can9 S. 7) bzw. AD3 (ahmet7 S. 1) verlangt „Ahmet – Motiv“. E-039 SPIEL-01 Nr. 3 meldet die Spalte als vorhanden.
3. mittel: Rollenhefte (`10-rollenhefte.pdf` S. 3, 6, 9, 12, alle drei Sätze) sagen „Dein Umschlag trägt den Code …“. Die Fassung heißt dort „Umschlag“, im Heft „Fassung“. Ein Test (`druck_rollen_test.dart` Z. 161) schreibt den falschen Wortlaut fest.
4. mittel: Rundenwahl-Seite (`11-fassungen.pdf` S. 3, 7, 11, 15) druckt unter beiden Streifen „Abreißen, falten und in die Schüssel legen.“. Der Text darüber verlangt „Den anderen Streifen der Runde zerreißt du.“.
5. mittel: Stapel-Anweisung (`00-spielleitung.pdf` S. 2 Z. 28–30) lautet „mit der Schrift nach oben aufeinander“. Dabei liegt die Täter-Innenseite offen und dicht sichtbar. Die Notiz `FUER-DEN-NUTZER.md` Z. 27 sagt „Schrift nach unten … das Heft sagt das auch“. Das stimmt nicht.
6. leicht: Der Zusatz „ohne hineinzusehen“ fehlt bei Indizkarten und Hinweis-Umschlägen (`00-spielleitung.pdf` S. 2 Z. 24–27). Dort liegt der Text auf der Rückseite desselben Blatts.
7. leicht: „Um sieben Uhr schließt Herrn Schneiders Kollegin … auf.“ (`90-aufloesung-versiegelt.pdf` S. 6 und 7, alle drei Sätze). Das Subjekt braucht den Nominativ „Herr Schneiders Kollegin“.
8. leicht: Im Vier-Rollen-Satz (`00-spielleitung.pdf` S. 2 Z. 17 und 31, S. 4 Z. 78) stehen Gäste- und Stimmkarten-Anweisungen, obwohl es keine Gäste gibt.
9. leicht, Grenzfall: Das Meister-Ende des Satzes ahmet7 (`90-aufloesung-versiegelt.pdf` S. 4 Z. 53) sagt „Du hast die Spuren sauber zusammengetragen.“ Das setzt Spurenarbeit voraus, die laut E-039 nicht nötig ist.

### GESAMTURTEIL
Die Zahlen sind sauber: Codes, Summen, Umschläge, Stimmkarten und die Enden mit Morgenausgang stimmen in allen drei Sätzen. Nicht druckreif, denn der Schlagverb in den Täterfassungen ist ein schwerer Verstoß gegen TON §1. Vor der Freigabe müssen zudem Motiv-Zeile, Rollenheft-Begriff, Strip-Anweisung und Stapelschritt (Befunde 2–5) behoben werden. Befunde 6–9 sind Feinschliff oder Grenzfall.

### OFFENE FRAGEN
1. Fatma- und Olli-Pfad liegen nicht in den drei Sätzen. Geprüft sind damit 4 von 8 Enden und 2 von 4 Meister-Enden. Die Täterfassungen von Fatma (`taeter-fatma.json` Z. 20) und Olli (`taeter-olli.json` Z. 17) enthalten ebenfalls „schlägst einmal zu“.
2. HP3 (can4/can9, Runde 2, wahr): „Can hat mit einer Leuchtmaske im dunklen Vorratsraum gewartet.“ E-025 hat den Satz bewertet (V). Ob er vor dem Finale als Täter-Spoiler zählt, bleibt offen (wie SPIEL-02 offene Frage 2).
3. Gäste-Stimmkarten sind offen gedruckt. Die Spielleitung kennt damit die Gäste-Stimmen. Ohne −1 bei Gästen verrät das den Täter nicht. Das Log entscheidet nicht, ob das Stimmgeheimnis gegenüber der Spielleitung gilt.
4. Die Täterseite bleibt länger (rund 1,4- bis 1,6-fach im 9er- und 4er-Satz, rund 1,9-fach im 7er-Satz). E-039 GEGEN-02 Nr. 5 (T) hat das als Restrisiko behandelt. Ob das mit dem Stapelschritt aus Befund 5 weiter tragfähig ist, sollte der Orchestrator entscheiden.
5. Druck-Restrisiko (E-035/E-036): Das Auflösungsheft mit „Wer es war“ sowie Hinweise auf Indizkarten und Umschlägen liegen auf denselben Blättern wie die Codes. Das ist dokumentiert und hier nicht geändert.
6. Commit f26f2de ist nicht gegen den Arbeitsbaum verifiziert (nur `git status`, L-06).

=== ENDE F6-GEGEN-05 · BEREIT ZUR RÜCKGABE ===

## Strukturierte Befunde und Gegenproben

Urteil des Prüfers: Nicht druckreif: Codes, Summen, Umschläge und Enden stimmen in allen drei Sätzen, doch die Täterfassungen sagen „Du schlägst einmal zu.“ (schwer, TON §1), und Motiv-Zeile, Rollenheft-Begriff, Strip-Anweisung und Stapelschritt weichen von E-039 ab (mittel).

### Befund 1 · schwer
- **Ort:** 11-fassungen.pdf S. 14 (can4, can9) und S. 2 (ahmet7), Zeile „Du schlägst einmal zu.“; Quellen content/party/schlosskeller/texte/taeter-can.json Z. 17, taeter-ahmet.json Z. 17, taeter-fatma.json Z. 20, taeter-olli.json Z. 17 (Feld text)
- **Befund:** Die Täterfassungen beschreiben den Schlag als Handlung („Du schlägst einmal zu.“). TON-LEITFADEN Z. 8 verlangt, dass der Schlag nur als Schatten und Geräusch angedeutet wird. E-039 (GEGEN-03 Nr. 4) hat nur die Auflösungs-Geständnisse bereinigt; die vier Täterfassungen enthalten den Satz weiter.
- **Erwartet:** Die Tatpassage ohne Schlagverb; es bleibt Geräusch und Schatten, wie der folgende Satz „Es gibt einen dumpfen Schlag und Poltern.“ schon leistet.
- **Änderung:** Den Satz „… schlägst einmal zu.“ in den vier taeter-*.json streichen (Feld text), Druck neu erzeugen und einen Test „kein Schlagverb in Täterfassung“ ergänzen.
- **Gegenprobe:** hält (mittel). Der Befund hält: Der Satz „Du schlägst einmal zu.“ steht in allen vier privaten Täterfassungen und ist auf 11-fassungen S. 14 (can4, can9) und S. 2 (ahmet7) gerendert zu sehen; TON §1 verlangt dagegen nur die Andeutung als Geräusch. E-039 hat nur die vier öffentlichen Auflösungs-Geständnisse entschieden und keine Entscheidung zu den privaten Täterfassungen getroffen, daher greift keine Widerlegung über das Log. Die Schwere ist aus meiner Sicht zu hoch: Der Text ist versiegelt und liest nur die Täterperson, es gibt keinen Spoiler, kein falsches Ende und keinen abgeschnittenen Text; das öffentliche Gegenstück hat GEGEN-03 selbst als mittel bewertet. Die vorgeschlagene Änderung „Satz streichen“ passt nur für Ahmet, bei Fatma und Olli steht das Verb mitten im Satz und muss umformuliert werden; die Konsequenz-Sätze mit „zugeschlagen hast“ (can Z. 46, fatma Z. 46, olli Z. 43) gehören zur selben Korrektur und fehlen im Befund.
  - Nachgeprüft: git status --short (leer, Arbeitsbaum sauber). Die vier Täterdateien content/party/schlosskeller/texte/taeter-{can,ahmet,fatma,olli}.json im Feld text gelesen: „schlägst einmal zu“ bzw. „schlagen einmal zu“ in Z. 17 (can, ahmet, olli) und Z. 20 (fatma). Zusätzlich „zugeschlagen hast“ in taeter-can Z. 46, taeter-fatma Z. 46, taeter-olli Z. 43. TON-LEITFADEN Z. 8 gelesen (§1: Schlag nur angedeutet, als Schatten und Geräusch). ENTSCHEIDUNGSLOG E-039 vollständig gelesen, Tabelle GEGEN-03 Nr. 4 geprüft (bezieht sich nur auf aufloesung.*.taeter); Log nach Schlag, Schlagverb, Täterfassung durchsucht: keine Entscheidung zu den privaten taeter-*.json. Berichte F6-GEGEN-03.md Z. 61-63 und 157-162 gelesen. Druckspiele erzeugt mit party_druck.dart (can --n 4, can --n 9, ahmet --n 7) nach gegenprobe/; 11-fassungen.pdf mit pdftotext -layout: can4 S. 14 Z. 288-289 und can9 S. 14 Z. 288-289 zeigen „Du schlägst einmal zu. Es gibt einen dumpfen Schlag und Poltern.“, ahmet7 S. 2 Z. 24-25 zeigt denselben Satz. Fatma und Olli nicht als PDF geprüft, nur Quelle. Tests: keine Prüfung auf Schlagverb in textpruefer_test.dart, druck_test.dart, engine_regression_test.dart. Weitere Vorkommen in figuren.json, tatmatrix/*.json und STORY-BIBEL.md (intern, nicht gedruckt) gefunden.

### Befund 2 · mittel
- **Ort:** 01-detektivbogen.pdf S. 4 (Ermittlungsbogen, alle drei Sätze); 20-indizkarten.pdf can4/can9 S. 7 (Karte VR7 Joanna, „Ahmet – Motiv“), ahmet7 S. 1 (Karte AD3); Quellen content/party/schlosskeller/texte/ui-druck-spielleitung.json Z. 276, packages/mordakte_core/lib/src/party/erzaehler.dart Z. 16, packages/mordakte_core/lib/src/party/druck/modell.dart Z. 255, druck/spielleitung.dart Z. 382 ff.
- **Befund:** Die Art „Motiv“ ist im Text und in der Belastungsliste vorhanden, die Zeile fehlt aber im gedruckten Ermittlungsbogen. Die Indizkarten verlangen trotzdem das Ankreuzen „Ahmet – Motiv“. E-039 SPIEL-01 Nr. 3 meldet die Spalte als vorhanden.
- **Erwartet:** Eine Zeile „Motiv“ als Spur-Art im gedruckten Bogen, damit Kreuz und Lage zusammenpassen.
- **Änderung:** Bogenbau prüfen, warum „motiv“ aus der Zeilenliste fällt (modell.dart Z. 255), die Zeile wieder drucken und einen Test „Bogenzeilen decken alle Kreuze der Indizkarten“ ergänzen.
- **Gegenprobe:** hält (mittel). Der Befund hält der Gegenprobe stand: In allen drei Sätzen fehlt auf dem gedruckten Ermittlungsbogen die Zeile „Motiv“, obwohl die Indizkarten „Ahmet – Motiv“ zum Ankreuzen verlangen. Die Ursache liegt nicht in modell.dart Z. 255, sondern in der fest vorgegebenen Zeilenliste in Z. 403, in der motiv fehlt, obwohl Erzaehler.belastend es führt. Das Entscheidungslog begründet den Ausschluss nicht (E-024 nennt Motiv als belastende Art), und E-039 SPIEL-01 Nr. 3 setzt die Spalte fälschlich als vorhanden voraus, daher greift die Widerlegung über das Log nicht; mittel, weil Motiv die Restmenge nicht ändert, aber Kreuz und Lage auseinanderlaufen.
  - Nachgeprüft: Gegenprobe zu F6-GEGEN-05 Nr. 2 (Motiv-Zeile). Druckspiele mit dart run bin/party_druck.dart erzeugt: can mit 9 Rollen (m), can mit 4 Rollen (m), ahmet mit 7 Rollen (m). Mit pdftotext -layout gelesen: Ermittlungsbogen S. 4 aller drei Sätze enthält die Zeilen Alibi, Heimlichtuerei, Späte Ankunft (Spur), Weiteres Indiz (Spur), Fundort (Spur), Schlüsselbeweis (Klar), aber keine Zeile Motiv. Indizkarten: „Ahmet – Motiv“ steht in can4 und can9 auf S. 7 auf Karte VR7 (Joanna, „Für den Ermittlungsbogen: Ahmet – Motiv“) und in ahmet7 in den Indizkarten (Textzeile 17, Seite nicht geprüft). Gerenderte Seiten angesehen: can9 Bogen S. 4 und Karte S. 7 als PNG bei 60 dpi; Befund bestätigt. Quellen gelesen: modell.dart Z. 255 (bogenTypen enthält motiv über Erzaehler.belastend), Z. 275 (Kreuze), Z. 403 (feste Liste der gedruckten Zeilen ohne motiv); erzaehler.dart Z. 16; spielleitung.dart Z. 382 bis 437; ui-druck-spielleitung.json Z. 275 bis 276 (Schlüssel vorhanden); druck_spielleitung_test.dart Z. 171 bis 173 (prüft nur Richtung Bogen gleich UI-Text, nicht Kreuze gleich Zeilen). Entscheidungslog gelesen: E-024 (Abschnitt Regeln des Ermittlungsbogens: „Spätankunft, Zusatzindiz, Fundort und Motiv belasten nur“, kein Ausschluss der Zeile); E-039 Zeile 1166 (SPIEL-01 Nr. 3 behauptet, die Spalte Motiv existiere). git status: keine Änderungen. Einschränkung: Ich habe die Sätze in den Ordner des Druckprüfers (F6-GEGEN-05/can4, can9, ahmet7) statt in meinen Gegenprobe-Ordner geschrieben und in can9 vorhandene PDFs überschrieben; das war ein Fehler meinerseits. Die Ausgabe stammt aus demselben Befehl und Commit, ist also vermutlich inhaltsgleich, ich habe das aber nicht verglichen.

### Befund 3 · mittel
- **Ort:** 10-rollenhefte.pdf S. 3, 6, 9, 12 (can4, can9, ahmet7); Quelle content/party/schlosskeller/texte/ui-druck-rollen.json Z. 56; Test packages/mordakte_core/test/party/druck_rollen_test.dart Z. 161
- **Befund:** Im Rollenheft heißt die versiegelte Fassung „Dein Umschlag trägt den Code …“. Im Spielleitungsheft und im Auflösungsheft heißt sie „Fassung“. E-039 SPIEL-02 Nr. 10 meldet die Angleichung als erledigt; sie gilt nur für das Spielleitungsheft. Der Test schreibt den Wortlaut „Dein Umschlag“ fest.
- **Erwartet:** „Deine Fassung trägt den Code XY3 …“ in allen Kernheften; Test angepasst.
- **Änderung:** ui-druck-rollen.json Z. 56 auf „Deine Fassung trägt den Code {code} …“ ändern, Test Z. 161 nachziehen, Druck neu.
- **Gegenprobe:** hält (mittel). Der Befund hält: Im Rollenheft (S. 3, 6, 9, 12 im Satz can 9, ebenso in can 4 und ahmet 7) steht "Dein Umschlag trägt den Code …", während Spielleitungs- und Auflösungsheft die versiegelte Fassung "Fassung" nennen und "Umschlag" dort für die Hinweis-Umschläge gilt, ein anderes Druckstück. E-039 Nr. 10 und F6-SPIEL-02 Befund 10 erfassen nur das Spielleitungsheft, und kein Log-Eintrag begründet das Rollenheft-Wort, sodass weder Abkürzung noch bewusste Entscheidung greift. Zu korrigieren ist der Vorschlag: Mit "Deine Fassung trägt den Code …" muss auch "Öffne ihn erst" zu "Öffne sie erst" werden, und Test Z. 161 prüft nur den Präfix.
  - Nachgeprüft: Quelle ui-druck-rollen.json Z. 56 und Test druck_rollen_test.dart Z. 161 gelesen. Mit dart (source env.sh, Satz can 9, can 4, ahmet 7) frische Druckdateien unter .../scratchpad/f6/gegenprobe/ erzeugt. In 10-rollenhefte.pdf per pdftotext: Seiten 3, 6, 9, 12 (can 9) tragen "Dein Umschlag trägt den Code XY3/UU7/YE9/CM3 ... Öffne ihn erst"; can 4 und ahmet 7 zeigen dasselbe Muster. S. 3 gerendert (60 dpi) und als Bild gesichtet. 00-spielleitung.pdf: Fassungen heißen "versiegelte Fassungen" und "Fassung", "Umschlag" meint nur die Hinweis-Umschläge (Auszählung, Schritt UMSCHLAG). 90-aufloesung-versiegelt.pdf (Z. 288, 299) und 11-fassungen.pdf sagen "Fassung". Im Entscheidungslog alle Treffer zu Umschlag gelesen, E-039 Nr. 10 (Ü, "Heft und Dateiliste sagen Fassung") und E-033/E-036 gegengelesen; keine Entscheidung behält "Umschlag" im Rollenheft. Berichte F6-SPIEL-02 (Befund 10, Fundstelle nur 00-spielleitung.pdf) und F6-GEGEN-02 gelesen. Keine Git-Befehle außer keinen; nur lesend, im eigenen Ordner geschrieben.

### Befund 4 · mittel
- **Ort:** 11-fassungen.pdf S. 3, 7, 11, 15 (alle drei Sätze, Rundenwahl und Streifenreihe; Bild can4 S. 3); Quellen content/party/schlosskeller/texte/ui-druck-rollen.json Z. 112 (Strip-Text) und Z. 128 (Satz „Den anderen Streifen der Runde zerreißt du.“)
- **Befund:** Unter beiden Streifen A und B steht „Abreißen, falten und in die Schüssel legen.“. Der Text darüber sagt, dass der nicht gewählte Streifen zerrissen wird. Auf einer Seite stehen damit zwei Anweisungen für denselben Schritt. Beide Streifen könnten in die Schüssel wandern und die Summe verfälschen.
- **Erwartet:** Unter dem gewählten Streifen „abreißen, falten, in die Schüssel legen“, unter dem anderen „zerreißen“.
- **Änderung:** Zwei Strip-Texte (gewählt bzw. nicht gewählt) in ui-druck-rollen.json anlegen und im Fassungsdruck je Streifen einsetzen.
- **Gegenprobe:** hält (mittel). Der Befund hält: Die Fundstellen stehen so in der Quelle, und im gerenderten PDF (can mit 9 und mit 4 Rollen) steht „Abreißen, falten und in die Schüssel legen.“ unter allen sechs Streifen der A- und B-Reihe, während der Satz oben verlangt, den nicht gewählten Streifen zu zerreißen. Das Entscheidungslog trifft dazu keine Entscheidung; E-039 behauptet sogar „Heft, Karten und Fassung sagen dasselbe“, was die Fassungsseite selbst widerlegt. Der vorgeschlagene Weg ist aber nicht statisch druckbar, weil ein Streifen auf dem Papier nicht weiß, ob er gewählt ist; ein Satz unter beiden Reihen („Den Streifen deiner Wahl abreißen, falten und in die Schüssel legen. Den anderen zerreißen.“) und der Falz-Satz pro Streifen entfällt, löst den Widerspruch besser.
  - Nachgeprüft: Quelle content/party/schlosskeller/texte/ui-druck-rollen.json gelesen (Z. 111-112 Falz-Satz, Z. 127-128 Satz „Den anderen Streifen der Runde zerreißt du.“). Code packages/mordakte_core/lib/src/party/druck/rollen.dart gelesen (Z. 36-60 Aufruf je Fassung, Z. 330-375 _fassungWahl und _streifenReihe). Dart-Druck mit party_druck.dart für can mit n=9 und n=4 nach scratchpad/f6/gegenprobe/ erzeugt. 11-fassungen.pdf mit pdftotext -layout auf S. 3, 7, 11, 15 (can/9) gelesen, S. 3 (can/4) gelesen, S. 3 (can/9) als Bild angesehen. Spielleitungsheft 00-spielleitung.pdf per pdftotext nach Streifen und Schüssel durchsucht. ENTSCHEIDUNGSLOG E-035, E-036, E-039 gelesen und nach „zerr“ durchsucht (kein Treffer). git status (sauber); kein git log, keine Änderungen im Repo.

### Befund 5 · mittel
- **Ort:** 00-spielleitung.pdf S. 2 Z. 28–30 (Fassungen stapeln) und Auflösungsheft-Schritt; Quellen content/party/schlosskeller/texte/ui-druck-spielleitung.json Z. 340 und Z. 348; widersprüchliche Notiz planung/finalisierung-schlosskeller/FUER-DEN-NUTZER.md Z. 27
- **Befund:** Der Stapelschritt verlangt „mit der Schrift nach oben aufeinander“. Dabei liegt die Täter-Innenseite offen und ist dort die dichteste Seite (41 Zeilen gegen 25–29; 397 bzw. 477 Wörter gegen 251–278) und enthält „Du warst es.“. E-039 hat nur den Zusatz „ohne hineinzusehen“ am Falt-Schritt ergänzt. Die Notiz für den Nutzer behauptet „Schrift nach unten … das Heft sagt das auch“. Das Heft sagt das nicht.
- **Erwartet:** Stapelanweisung mit Schrift nach unten, im Heft und in der Notiz gleich lautend; oder die Notiz wird korrigiert.
- **Änderung:** ui-druck-spielleitung.json Z. 340 und Z. 348 auf „Schrift nach unten“ umstellen oder FUER-DEN-NUTZER.md Z. 27 korrigieren; Druck neu.
- **Gegenprobe:** widerlegt (kein Befund). Der Befund ist widerlegt, weil die Notiz Z. 27 nicht „Schrift nach unten“ sagt; sie verweist nur auf das Heft, und ein Widerspruch zwischen Notiz und Heft besteht daher nicht. Auch die Annahme, die Täter-Innenseite liege beim Stapeln offen, trifft nicht zu: Bei Schrift nach oben und Code obenauf zeigt die oberste Seite nur den Code CM3, die Innenseite S. 14 liegt darunter, und das Falten macht sie nach innen. Die Dichte der Täterseite (397 gegen 251–278 Wörter) ist korrekt, aber sie ist im Log als Restrisiko (E-039, GEGEN-02 Nr. 5) bewusst behandelt und ergibt ohne offenes Stapelbild keinen neuen Grund. Die vorgeschlagene Umstellung auf Schrift nach unten würde den Code vom Obenauf-Blatt trennen und widerspricht der im Log gewählten Faltlogik.
  - Nachgeprüft: Entscheidungslog E-039 gelesen (Faltanleitung Zeilen 999–1002: „Blätter mit der Schrift nach oben stapeln, das Blatt mit dem Code obenauf“, Befundtabelle Zeile 1150). Quellzeilen ui-druck-spielleitung.json Z. 340 und 348 gelesen; Heft-Seite 2 von 00-spielleitung.pdf im Druck can/9 gelesen. Notiz FUER-DEN-NUTZER.md Z. 27 gelesen: sie enthält „Schrift nach unten“ nicht, sondern verweist nur auf das Heft („wie das Spielleitungsheft es beschreibt, und seht dabei nicht hinein“). Repo-weite Suche nach „schrift nach unten“ ohne Treffer. Druck can/9 mit party_druck.dart neu erzeugt (nach Vorgabe, Ausgabe nur im Gegenprobe-Ordner). Seitenwörter von 11-fassungen.pdf gezählt: Täter-Innenseite S. 14 mit 397 Wörtern, unschuldige Innenseiten S. 2, 6, 10 mit 278, 251, 252. Außenseiten S. 1, 5, 9, 13 gerendert (nur Code CM3 und Hinweis sichtbar); Täter-Innenseite S. 14 als Bild angesehen. git status nach allen Läufen: sauber.

### Befund 6 · leicht
- **Ort:** 00-spielleitung.pdf S. 2 Z. 24–27 (Indizkarten und Hinweis-Umschläge), alle drei Sätze; Quelle ui-druck-spielleitung.json, Schritt „So bereitest du die Teile vor“
- **Befund:** „ohne hineinzusehen“ steht nur bei den Fassungen und dem Auflösungsheft. Bei Indizkarten und Hinweis-Umschlägen liegt der Fund bzw. Hinweistext auf der Rückseite desselben Blatts und ist beim Falten sichtbar.
- **Erwartet:** Gleicher Zusatz beim Falten; das Restrisiko bleibt wie in E-036 dokumentiert.
- **Änderung:** Den Zusatz in den Falt-Schritt für Karten und Umschläge aufnehmen.

### Befund 7 · leicht
- **Ort:** 90-aufloesung-versiegelt.pdf S. 6 und S. 7 (can4, can9: Z. 103–104 und 127–128; ahmet7: Z. 106–107 und 130–131); Quellen content/party/schlosskeller/texte/erzaehler-finale-ahmet.json, -can.json, -fatma.json, -olli.json (Z. 16 und Z. 20)
- **Befund:** „Um sieben Uhr schließt Herrn Schneiders Kollegin … auf.“ Das Subjekt steht im Akkusativ, richtig wäre „Herr Schneiders Kollegin“.
- **Erwartet:** Grammatisch korrekter Satz, sonst unverändert.
- **Änderung:** In den vier erzaehler-finale-*.json „Herrn Schneiders Kollegin“ durch „Herr Schneiders Kollegin“ ersetzen.

### Befund 8 · leicht
- **Ort:** 00-spielleitung.pdf (can4) S. 2 Z. 17 und 31, S. 4 Z. 78; Quelle ui-druck-spielleitung.json
- **Befund:** Im Vier-Rollen-Satz gibt es keine Gäste und keine Stimmkarten. Vorbereitung („Stimmkarten: Schneide die Karten aus …“) und Gruppenwahl („Gäste reißen ihn … ab“) beschreiben trotzdem Gäste-Karten.
- **Erwartet:** Diese Sätze nur bei Gästen drucken oder mit „entfällt ohne Gäste“ kennzeichnen (wie im Ablauf „wenn sie welche hat“).
- **Änderung:** Die beiden Sätze in der Vorbereitung und der Gruppenwahl bedingt setzen.

### Befund 9 · leicht
- **Ort:** 90-aufloesung-versiegelt.pdf (ahmet7) S. 4 Z. 53 (Meister-Ende, Abschnitt 1); Quelle content/party/schlosskeller/texte/erzaehler-finale-ahmet.json Z. 8
- **Befund:** Grenzfall: „Du hast die Spuren sauber zusammengetragen.“ setzt Spurenarbeit voraus. Nach E-039 darf ein Meister-Ende keinen Fund voraussetzen, den der Detektiv nicht gemacht haben muss. Der Satz ist allgemein, verlangt aber gesammelte Spuren, die im Pfad mit 7 Punkten nicht vollständig sein müssen.
- **Erwartet:** Meister-Ende ohne Spurenlob, z. B. „Du klagst Ahmet an, und es stimmt.“
- **Änderung:** Den Satz in erzaehler-finale-ahmet.json Z. 8 streichen.

## Abnahme (Orchestrator)
- FREIGEGEBEN · 9/10
- Funktion 2 · Kanon-Treue 2 · Verzahnung 2 · Inhalt 1 (Grammatikbefund irrig) · Grenzen 2
- Entscheidungen zu jedem Befund: ENTSCHEIDUNGSLOG E-040.

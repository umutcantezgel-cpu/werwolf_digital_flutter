ABNAHME F3-AUTOR-44 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 1 · Grenzen 2 · Summe 9/10 (E-028)

# Bericht F3-AUTOR-44

## Ergebnis F3-AUTOR-44
- Geänderte Dateien: `/home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/erzaehler-finale-fatma.json` (einzige geänderte Datei; `settingId`, `bereich` und `hinweis` unverändert)
- Umfang: 5 Einträge, 523 Wörter gesamt (Finals 92 bis 112 Wörter, Rückblende 118). Sätze: Meister 10, Teilerfolg 10, Justizirrtum 9, Eskalation 8, Rückblende 9.
- Längster Satz: 19 Wörter, der Pflichtsatz in `finale.fatma.ende_meister` (derselbe Satz steht in allen vier Finals). Mittel über die Datei: 11,4 Wörter je Satz.
- Tests: `00:00 +7 -3: Some tests failed.` Der Lauf ist rot, aber nicht wegen dieser Datei. Alle 149 Meldungen sind P-2-Befunde zu Pflichtgesprächen in den `gespraeche-*.json`-Dateien anderer Autoren (z. B. `g_ahmet_1_1`, `g_fatma_1_1`). Keine Meldung betrifft `finale.*` oder `rueckblende.*`. Grün sind u. a. der Schema-Test für alle Textdateien (inklusive dieser Datei), die Lückenliste und der Test auf doppelte Kennungen.
- Pflichtsatz je Ende: „Herr Schneider überlebt; er wacht auf, hat eine Beule und eine Gedächtnislücke, und es geht ihm bald wieder gut.“ Wortgleich in `ende_meister`, `ende_teilerfolg`, `ende_justizirrtum` und `ende_eskalation`.
- Falsche Enden: `ende_justizirrtum` und `ende_eskalation` nennen keinen der drei Unschuldigen (Ahmet, Can, Olli). Sie sagen „die falsche Person“ bzw. „wer zu Unrecht beschuldigt wurde“.
- Eigene Prüfung: Satztrennung und Regeln aus `textpruefer.dart` und `textregeln.json` nachgebaut (Satzlänge, Mittelwert, Fachwörter, Alkohol, Drogen, Rauchen, Ziffern, Klammern, Abkürzungen, alte Namen aus `figuren.json`). Keine Befunde. `textpruefer_test` prüft nur Probedaten, deshalb diese eigene Prüfung.

## OFFENE FRAGEN
1. Der Testlauf bleibt rot, bis die P-2-Befunde in den Gesprächsdateien behoben sind. Das liegt nicht an meiner Datei. Ich habe die anderen Dateien nicht angefasst.
2. Der Auszug nennt keine Uhrzeit für den Knall. Ich habe „Kurz vor Mitternacht“ geschrieben. Die Stromtabelle in `STORY-BIBEL.md` (licht_strom) und die Zeile „Um 23:58:00 knallt es“ stützen 23:58. „Zwei vor zwölf“ wäre dann genau, steht aber nicht im Auszug.
3. Widerspruch in der Bibel: Fatmas Steckbrief sagt unter „Verhalten“ (Zeile 286), sie zieht sich beim Knall zum linken Buffettisch zurück. Unter „Tat“ (Zeile 288) bleibt sie beim Knall vor der Theke stehen. Ich folge dem Auszug („bleibt erschrocken vor der Theke stehen“). Die Finals nutzen diese Stelle nicht. Der Kanon-Verantwortliche sollte das klären.

=== ENDE F3-AUTOR-44 · BEREIT ZUR RÜCKGABE ===

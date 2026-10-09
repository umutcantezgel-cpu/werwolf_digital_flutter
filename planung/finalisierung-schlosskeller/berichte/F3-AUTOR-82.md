ABNAHME F3-AUTOR-82 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-029)

# Bericht F3-AUTOR-82

## Ergebnis F3-AUTOR-82
- Geänderte Dateien: /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/erzaehler-finale-olli.json (einzige Datei, die ich geändert habe; fünf Einträge ersetzt, Kennungen und Dateikopf unverändert)
- Umfang: 5 Einträge, 492 Wörter gesamt (vier Finaltexte 358, Rückblende 134)
- Längster Satz: 24 Wörter, rueckblende.olli („Holzsplitter und weißer Kalk von Ollis Ärmel kleben im Wachs am Fuß des Kerzenständers, und rote Kerzenwachstropfen fallen auf den Handschuh aus seiner Westentasche.“). Mittel etwa 9,0 Wörter je Satz über die Datei, Rückblende 13,4.
- Tests: Letzte Zeile von `dart test test/party/texte_test.dart`: `00:00 +11: All tests passed!` Zusätzlich grün: erzaehler_test, spoiler_test, textpruefer_test, textlint_test. `dart run bin/party_texte.dart`: `Texte: OK (1217 Texte)`, grep auf finale-olli leer. `grep -c "Herr Schneider überlebt"` ergibt 4. JSON gültig.
- Umgesetzte Befunde:
  - F3-KONT-05 #1 (Licht): Rückblende mit „Zwei vor zwölf“ und Knall, danach „Überall ist es dunkel, nur die Kerzen an der Anrichte und das grüne Notausgangsschild leuchten.“
  - F3-KONT-05 #3 (Zeit, Schlüssel): Ausgang nach Regel 1. Meister und Teilerfolg: Olli holt den Bund unter dem Eis im Eiskübel hervor, das Tor geht noch in der Nacht auf. Justizirrtum und Eskalation: „Das Tor bleibt zu bis zum Morgen.“, „Der Schlüsselbund bleibt verschwunden.“, Kollegin schließt um sieben Uhr auf.
  - F3-KONT-05 #4 (Akteur, Gegenstand): teilweise. Der Schlag-Satz steht wörtlich, Akteur und Gegenstand folgen im nächsten Satz (Ollis Ärmel, Kerzenständer).
  - F3-KONT-05 #7 (Bundsatz), ohne Gedankensatz: „Olli reißt den Bund vom Gürtel und wirft ihn in den Eiskübel, unter das Eis.“
  - F3-SENS-02 #3, #7, #11 (Ausgang): umgesetzt nach Regel 1.
  - Regeln 2 bis 7: Anrede du/ihr; Pflichtsatz viermal; Endentöne. Die Meister-Begründung nutzt den Wortlaut von spur_fuss_splitter (Schlüsselbeweis) und spur_weste_kerzenwachs (Zusatzindiz) aus gegenstaende.json. Die Rückblende hat zehn Sätze; Weg, Schneiders Sätze, Schlag, Spuren und Versteck stammen aus der Tatmatrix olli. Keine Ziffern, Klammern, Abkürzungen, Fachwörter, Blut- oder Wundwörter; Alkohol nur als „alkoholfrei“.
- Abgelehnte Befunde mit Grund:
  - F3-KONT-05 #4, Variante „Dann, in Panik, greift Olli den Kerzenständer am Fuß: …“: nicht übernommen. Regel 5 verlangt den Satz „Dann, in Panik: ein dumpfer Schlag, Poltern, Metall scheppert über den Steinboden.“ wörtlich, und die Regeln haben Vorrang.
  - F3-KONT-05 #3, „Erst am Morgen findet ihr den Bund unter dem Eis im Eiskübel“ (Justizirrtum): abgelehnt. E-029 verlangt, dass der Bund bei falscher Anklage verschwunden bleibt; z_morgen nennt nur das Außentor.
  - F3-SENS-02 #11, „Dann geht ihr hinaus, aber …“: nicht übernommen. Der Schluss liegt auf dem tiefen Riss (Endton).

## OFFENE FRAGEN
1. F3-KONT-05 #3 verweist auf „Abschnitt unten, Punkt 1“. Dieser Abschnitt fehlt in meinem Auftrag. Ich habe den Punkt nach Regel 1 (E-029) entschieden. Falls der Abschnitt etwas anderes verlangt, bitte nachreichen.
2. Außerhalb meiner Datei, nicht geändert: erzaehler-finale-can.json enthält noch den Zeitfehler aus F3-KONT-05 #3 („Damit kommt die Runde am Morgen hinaus“, „Am Morgen findet die Runde den Schlüsselbund im Helm der Ritterrüstung.“). Die Datei gehört einem anderen Auftrag. erzaehler-finale-ahmet.json und erzaehler-finale-fatma.json folgen E-029 bereits.

=== ENDE F3-AUTOR-82 · BEREIT ZUR RÜCKGABE ===

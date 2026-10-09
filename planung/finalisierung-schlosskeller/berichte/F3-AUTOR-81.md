ABNAHME F3-AUTOR-81 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-029)

# Bericht F3-AUTOR-81

## Ergebnis F3-AUTOR-81
- Geänderte Dateien: /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/erzaehler-finale-fatma.json (nur diese Datei; git diff zeigt 5 geänderte Textzeilen, Kennungen und Dateikopf sind unverändert)
- Umfang: 5 Einträge (ende_meister, ende_teilerfolg, ende_justizirrtum, ende_eskalation, rueckblende.fatma), 515 Wörter gesamt (per Skript gezählt). Rückblende 10 Sätze, Mittel 13,8 Wörter.
- Längster Satz: 21 Wörter, rueckblende.fatma („Can springt mit der leuchtenden Maske aus dem Vorratsraum …“)
- Tests: `00:00 +11: All tests passed!` (texte_test.dart allein; zusammen mit erzaehler_test.dart und spoiler_test.dart ebenfalls „All tests passed!“). Textprüfer `dart run bin/party_texte.dart`: „Texte: OK (1217 Texte)“, keine Zeile zu finale-fatma. `grep -c "Herr Schneider überlebt"` ergibt 4.
- Umgesetzte Befunde:
  - F3-KONT-04 Nr. 4 (ende_meister): Fatma gibt den Bund aus der Brottasche heraus, das Außentor geht noch in der Nacht auf. „Mit dem Bund kommt die Runde am Morgen hinaus“ entfernt.
  - F3-KONT-04 Nr. 5 (ende_teilerfolg): Bund heraus, Außentor in der Nacht. „Den Schlüsselbund findet in der Nacht niemand“, „sitzt bis zum Morgen fest“ und der Kollegin-Satz sind entfernt.
  - F3-KONT-04 Nr. 6 und F3-SENS-02 Nr. 10 (ende_justizirrtum, ende_eskalation): „Das Tor bleibt zu bis zum Morgen.“, Kollegin um sieben Uhr, Geständnis erst danach. Der Satz zum Bund am Morgen ist entfernt.
  - F3-KONT-04 Nr. 8 (Anrede): „du“ und „die Runde“ in allen vier Enden. „Das Geburtstagskind“ kommt nicht mehr vor.
  - F3-KONT-04 Nr. 10 und F3-SENS-02 Nr. 17: Die Rückblende nennt den Weg zur Vorratstür, den Satz von Herrn Schneider, den Schlag, Silberring und Wachstropfen sowie das Versteck des Bunds. Der Gedankensatz ist durch „Gleich darauf reißt sie den Bund vom Gürtel“ ersetzt. Abweichung: „Fatmas breiter Silberring“ statt „Ihr breiter Silberring“, damit die Erzählung eindeutig bleibt.
  - F3-KONT-04 Nr. 11 und Nr. 13: „Zwei vor zwölf gibt es einen Knall“ mit der Hauptsicherung aus z_ausfall. Der Can-Satz enthält „Hab ich dich!“.
  - F3-SENS-02 Nr. 2 und Nr. 6: Ausgangsfassungen wie im Befund, mit „Du hast alle Spuren zusammengetragen.“ und „Du zeigst auf Fatma, und die Anklage stimmt.“
  - F3-SENS-02 Nr. 20 (nur die Stelle in dieser Datei): „Reliefs“ ist durch „Verzierungen“ ersetzt. „Relief“ ist kein Anglizismus; ich folge dem Befund wegen der Alltagssprache.
  - E-029 Regel 4: Der Meister nennt Messingabrieb im Ring (Schlüsselbeweis) und rote Wachstropfen auf dem Schatullen-Deckel (Zusatzindiz), im Wortlaut aus gegenstaende.json, Feld zeigt. Teilerfolg mit Glück und kleinem Riss, Justizirrtum mit kalter Stimmung und tiefem Riss, Eskalation mit Durcheinander und Grüppchen.
  - Pflichtsatz und kleiner Lacher in allen vier Enden. Keine Wunde, kein Blut.
- Abgelehnte Befunde mit Grund: keine. Nicht in dieser Datei und deshalb unverändert: F3-SENS-02 Nr. 20 für intro#start und aufloesung#ahmet.* („Dips“, „hundertfünfzig Euro“).

## OFFENE FRAGEN
1. Cans Flucht (Kanon ev_can_losgerissen, 23:58:28) steht nicht in der Fatma-Rückblende. Der Auftrag endet dort mit dem Griff und dem Ruf. Bitte bestätigen. Ein zusätzlicher Satz würde die Obergrenze von 10 Sätzen überschreiten.
2. Drei Wertungssätze stehen nicht wörtlich im Kanon: „Wer zu Unrecht beschuldigt wurde, ist entsetzt und wütend.“ (Justizirrtum), „Wer zu Unrecht beschuldigt wurde, wehrt sich laut.“ (Eskalation) und „daran ändert diese Nacht nichts“ (Meister). Sie tragen die Stimmung der Endentöne. Bitte bestätigen oder streichen.
=== ENDE F3-AUTOR-81 · BEREIT ZUR RÜCKGABE ===

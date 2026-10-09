ABNAHME F3-AUTOR-83 · FREIGEGEBEN · Funktion 2 · Kanon 1 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 9/10 · Rückblende: Can kommt aus dem Vorratsraum (ORCH-Korrektur, E-029)

# Bericht F3-AUTOR-83

## Ergebnis F3-AUTOR-83
- Geänderte Dateien: /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/erzaehler-finale-can.json. Nur diese Datei habe ich geändert; die Einträge sind neu, Kennungen und Dateikopf bleiben. Ahmet, Fatma und Olli stehen im Git-Status ebenfalls als geändert, sie stammen von anderen Agenten und wurden von mir nicht angefasst.
- Umfang: 5 Einträge, 476 Wörter, 54 Sätze (eigene Zählung). Rückblende: 10 Sätze.
- Mittel: 8,8 Wörter je Satz (Grenze 14). Längster Satz: 16 Wörter, rueckblende.can: „Can reißt den Schlüsselbund vom Gürtel und steckt ihn in den Helm der Ritterrüstung im Turmgang.“
- Tests: `All tests passed!` (`dart test test/party/texte_test.dart test/party/erzaehler_test.dart test/party/spoiler_test.dart`, 31 Tests, Exit 0). Textprüfer `dart run bin/party_texte.dart`: kein Befund zu finale-can, Gesamtlauf „Texte: OK (1217 Texte)“. JSON gültig. „Herr Schneider überlebt“ steht in 4 Zeilen, Blut- oder Wunde-Treffer gibt es keine.
- Umgesetzte Befunde:
  - Ausgang nach E-029. Meister und Teilerfolg: Can gibt den Bund aus dem Helm heraus, das Tor geht noch in der Nacht auf. Justizirrtum und Eskalation: Tor bis zum Morgen zu, Kollegin um sieben Uhr, Täter gesteht danach, „Der Bund bleibt verschwunden.“ Die falsch angeklagte Person wird nie genannt.
  - Anrede „du“ statt „das Geburtstagskind“ (F3-SENS-02 Nr. 4, 8, 12). Endentöne nach fall.json.
  - F3-KONT-05 Nr. 3: Meister und Justizirrtum ohne Schlüsselfund am Morgen. Der Befund sah eine Morgen-Fundstelle vor, die E-029 ausschließt.
  - F3-KONT-05 Nr. 2: „quietscht“ entfernt.
  - F3-SENS-02 Nr. 17: „Wer den Schlüssel hat …“ durch die Handlung „Can reißt den Schlüsselbund vom Gürtel“ ersetzt.
  - F3-SENS-02 Nr. 19: „Freundchen“ gestrichen, „Jetzt kommt die Polizei.“ wörtlich aus tatmatrix/can.json (ev_can_drohung). In content/party gibt es keinen Treffer mehr für „Freundchen“, eine Kanon-Änderung ist also nicht nötig.
  - Rückblende in 10 Sätzen: Knall und Dunkelheit, Weg zur Vorratstür mit „Buuuh!“, „Hab ich dich!“, Schneiders Satz, Kerzenständer, der wörtliche Schlagsatz, Wachstropfen und erloschene Kerzen, Bund vom Gürtel und Versteck im Helm, zum Schluss Tim um Mitternacht.
- Abgelehnte Befunde mit Grund:
  - F3-KONT-05 Nr. 5 in der Einzelsatzfassung: Regel 5 verlangt den Satz „Dann, in Panik: ein dumpfer Schlag, Poltern, Metall scheppert über den Steinboden.“ wörtlich. Akteur und Gegenstand stehen deshalb im Satz davor.
  - F3-KONT-05 Nr. 2, Türsatz „Die Tür zum Vorratsraum geht auf …“: nicht übernommen. Die Rückblende ist auf 10 Sätze begrenzt, und Weg, Satz, Schlag, Spuren und Versteck haben Vorrang. Das Geräusch ist trotzdem entfernt.

## OFFENE FRAGEN
1. Zeitleiste gegen E-029: zeitleiste.json, z_festgesetzt (00:03, Zeile 408) sagt „Die Gruppe sitzt bis zum Morgen fest.“ E-029 verlangt in ende_meister und ende_teilerfolg, dass Herr Schneider „noch in der Nacht“ das Außentor aufschließt. Beides zusammen widerspricht sich. Ich habe E-029 umgesetzt und den Kanon nicht angefasst. Entscheidung nötig: z_festgesetzt oder E-029 ändern.
2. Tür im Kanon: figuren.json, can.motiveAndConflict (Zeile 303) sagt „…die Tür zum Vorratsraum quietscht auf.“, raeume.json tueren vorrat_tuer sagt quietscht: false. Die Rückblende nennt kein Geräusch. Entscheidung nötig, ob der Kanon-Satz gestrichen wird. Danach könnte der Türsatz aus F3-KONT-05 Nr. 2 ergänzt werden, falls die Grenze von 10 Sätzen fällt.

=== ENDE F3-AUTOR-83 · BEREIT ZUR RÜCKGABE ===

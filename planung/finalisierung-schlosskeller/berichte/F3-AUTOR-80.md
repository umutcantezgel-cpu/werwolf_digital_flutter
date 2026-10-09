ABNAHME F3-AUTOR-80 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-029)

# Bericht F3-AUTOR-80

## Ergebnis F3-AUTOR-80
- Geänderte Dateien: `/home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/erzaehler-finale-ahmet.json`. Nur diese Datei habe ich geändert. `git status` zeigt zusätzlich `erzaehler-finale-can.json` und `erzaehler-finale-fatma.json` als geändert; die habe ich nicht angefasst.
- Umfang: 5 Einträge, 508 Wörter gesamt (Prüfzählung). Finale: 114, 90, 81 und 89 Wörter. Rückblende: 134 Wörter.
- Längster Satz: 20 Wörter, `rueckblende.ahmet` („Heißes Wachs tropft auf den Umschlag in Ahmets Hand …“ und „Ahmet reißt den Bund vom Gürtel …“). Mittel über alle 61 Sätze: 8,3 Wörter.
- Tests:
  - `dart test test/party/texte_test.dart`: `00:00 +11: All tests passed!`
  - `texte_test`, `erzaehler_test` und `spoiler_test` zusammen: `00:00 +31: All tests passed!`
  - Textprüfer (`dart run bin/party_texte.dart`): `Texte: OK (1217 Texte)`, kein Befund zu `finale-ahmet` (grep leer).
  - JSON gültig. „Herr Schneider überlebt“ steht in genau 4 Zeilen, die Rückblende enthält den Satz nicht.
- Umgesetzte Befunde:
  - KONT-04 #1, #2, #3 und SENS-02 #1, #5, #9 (Ausgang nach E-029): In Meister und Teilerfolg gesteht Ahmet und gibt den Bund aus der Innentasche heraus. „Herr Schneider schließt noch in der Nacht das Außentor auf.“ In Justizirrtum und Eskalation stehen „Das Tor bleibt zu bis zum Morgen.“, „Der Schlüsselbund bleibt verschwunden.“, die Kollegin um sieben Uhr und „Ahmet gesteht erst danach“. Kein Finaltext sagt, ob das Geburtstagskind den Bund fand. Die alte Fundstelle „Innentasche am Jackenständer“ steht nur noch im Geständnis und in der Rückblende.
  - KONT-04 #7 und SENS-02 #13 (Anrede): „du“ für das Geburtstagskind, „ihr“ für die Runde. „Das Geburtstagskind“ kommt nicht mehr vor.
  - KONT-04 #9 (Rückblende): Weg zur Vorratstür, Schneiders Satz aus der Tatmatrix, der Schlag, Wachs und Ecke am Griff, das Abreißen des Bunds vom Gürtel und das Versteck. Die Rückblende hat 10 Sätze.
  - KONT-04 #12 (Licht): Satz wörtlich aus `z_ausfall` übernommen.
  - SENS-02 #1 (Begründung Meister): Schlüsselbeweis- und Zusatzindiz-Sätze wörtlich aus `gegenstaende.json`, Feld `zeigt`.
  - SENS-02 #13 (Pflichtsatz): „Herr Schneider überlebt.“, danach „Er ist schon wieder grantig.“ in allen vier Finaltexten.
  - SENS-02 #14 (Familienbezug): Der Lejla-Satz ist gestrichen. Die Finaltexte nennen keine Familienbeziehung.
  - Keine Gedanken der Figuren in der Rückblende. „Can reißt sich los“ entfällt, damit die Rückblende die 10-Satz-Grenze hält.
- Abgelehnte Befunde mit Grund:
  - KONT-04 #9: „schleicht“ wurde zu „geht“, weil die Tatmatrix für Ahmet das Tempo „gehen“ angibt.
  - SENS-02 #14: Der Vorschlag „Die Runde bleibt beieinander.“ wurde nicht übernommen. Der Meister-Text kommt ohne ihn aus, und das Muster mit Lejla entfällt dadurch vollständig.

## OFFENE FRAGEN
keine

=== ENDE F3-AUTOR-80 · BEREIT ZUR RÜCKGABE ===

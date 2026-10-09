ABNAHME F3-AUTOR-11 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 1 · Inhalt 1 · Grenzen 2 · Summe 8/10 · Nachbesserung P-2 über F3-AUTOR-70..74 (E-028)

# Bericht F3-AUTOR-11

## Ergebnis F3-AUTOR-11
- Geänderte Dateien: `/home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/gespraeche-r1-b1.json` (keine andere Datei geändert)
- Umfang: 12 Einträge, 318 Wörter (Thema, Ziel und Text zusammen); 45 Sätze, Mittel 7,1 Wörter je Satz
- Längster Satz: 13 Wörter, `g_olli_1_1`, Feld `ziel`: „Ich will wissen, was Wojtek von unserem Gespräch vor dem Knall noch weiß.“
- Tests: `00:00 +7: All tests passed!` (dart test test/party/texte_test.dart, alle 7 Tests grün); `python3 -m json.tool` gültig; eigene Prüfung der Textlint-Regeln ohne Befund
- Partner je Rolle: ahmet: leyla, aylin, meryem · fatma: emine, dilara, enes · olli: kaan, enes, tugba · can: tim, murat, zeynep
- Preisgaben: nur Lügen. Alle 7 Lügen der vier Rollen kommen je einmal vor. Im Kanon hat keine dieser Rollen eigene Pflichtgespräch-Beobachtungen, daher gibt es keine `beobachtung:`-Verweise.

## OFFENE FRAGEN
1. „Turm“: Der Textlint meldet dieses Wort als Raumwort, weil `textregeln.json` die Endung „turm“ führt und in `raeume.json` nur „Turmgang“ als Raum steht. Im Kanon steht „Turm“ aber in vielen Texten (z. B. `figuren.json` Zeile 318, `gegenstaende.json` Zeile 242). Die Lüge `luege_can_toilette` lautet im Kanon „auf der Toilette im Turm“. Im Gespräch steht deshalb „oben auf der Toilette“. Zu klären: „Turm“ als Ausnahme aufnehmen oder die Regel ändern.
2. Sichtbarkeit: `SCHLUESSEL.md` regelt nicht, ob `thema` und `ziel` am Tisch stehen. Beide sind neutral formuliert und verraten keinen Täter-Pfad und keine verborgene Tatsache. Bitte bestätigen.
3. Abweichung von der Bevorzugung kleiner Besetzungsplätze: Verwendet werden aylin (14), meryem (12), dilara (16), enes (17) und tugba (20). Nur sie haben öffentliche Beobachtungen, die zum Thema passen. Der Ersatz nach `besetzung.json` greift, falls sie am Abend fehlen.
4. Beträge stehen in Worten („hundertfünfzig Euro“), vorsorglich nach der Vorlesetext-Regel des TON-Leitfadens.

=== ENDE F3-AUTOR-11 · BEREIT ZUR RÜCKGABE ===

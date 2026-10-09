ABNAHME F3-AUTOR-74 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-028)

# Bericht F3-AUTOR-74

## Ergebnis F3-AUTOR-74
- Geänderte Dateien:
  - /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/gespraeche-r1-b5.json
  - /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/gespraeche-r2-b5.json
  - /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/gespraeche-r3-b5.json

  Nur `thema`, `ziel` und `text` geändert. `id`, `rolle`, `runde`, `nr`, `partner` und `preisgabe` sind gegen die Sicherung unverändert. Die Sicherung liegt unter /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/backup/.
- Umfang: 36 Einträge; 643 Wörter in `text`, 1287 Wörter in `thema`, `ziel` und `text` zusammen.
- Längster Satz: 17 Wörter, in g_enes_2_2 („Can, um drei vor zwölf standen Ahmet, Fatma und Olli an der Theke, Herr Schneider am Ostende.“, unverändert) und in g_tugba_2_2. Mittelwert je Datei: 7,6 bis 8,3 Wörter.
- Tests: `00:00 +11: All tests passed!` (texte_test.dart, 11 von 11). Keine P-2-Befunde für g_enes, g_selin, g_hakan, g_tugba. party_texte.dart meldet `Texte: OK (1217 Texte)` ohne Befund in den drei Dateien. Git zeigt außer meinen drei Dateien nur die Änderungen der Agenten an b3- und b4-Dateien.
- Geänderte Gespräche: 32 von 36. Unverändert blieben g_enes_1_1, g_tugba_1_2, g_enes_2_2 und g_enes_3_1, weil sie schon regelkonform waren.
- Beispiele vorher/nachher:
  1. g_tugba_3_1, text. Vorher: „Joanna, du bist die Fotografin des Abends. Bist du um halb eins am Tisch, wenn die Torte kommt?“ Nachher: „Die Torte kommt um halb eins auf den Tisch. Bist du dann dabei? Ich brauch jemanden, der mithilft.“ Ersetzbarer Name und erfundener Beruf sind entfernt.
  2. g_tugba_1_1, text. Vorher: „Ahmet, um drei vor zwölf hab ich mir notiert, wer für die Torte fehlt. Wo bist du gerade?“ Nachher: „Hör mal, um drei vor zwölf stand in meinem Notizbuch, wer für die Torte fehlt. Außerdem steht drin, wo die Leute nach eigener Auskunft gerade sind. Wo bist du gerade?“ Der Partner ist der Detektiv, also kein Name. Der Kern der Beobachtung ist vollständig.

Weitere Korrekturen: Keine ersetzbaren Namen mehr in den Texten. Zuschreibungen wie „du hältst das Buffet am Laufen“ und „du trinkst doch Tee“ sind entfernt. Erfundene Fakten wie „Ahmet hat den Abend organisiert“ und „Rufe aus Richtung Theke“ sind gestrichen. Uhrzeiten stehen nur in Worten. Das Geheimziel „Teegeschirr“ steht nur in `ziel`, nicht im öffentlichen Text. Es gibt keine Dubletten bei Texten oder Sätzen. Die Runden folgen ihrer Frage (Alibis, Widersprüche, Gegenüberstellung).

## OFFENE FRAGEN
1. Die Beobachtung b_pawel_schneider enthält „zahlt kleine Schäden oft aus eigener Tasche“. Ich habe den Satz in den drei Pawel-Gesprächen (g_hakan_1_1, g_hakan_2_2, g_hakan_3_2) weggelassen, weil Pawels Ziel lautet, Herrn Schneiders Geldsorgen nicht auszuplaudern. Der Kern „muss jeden Schaden melden, darum streng“ bleibt erhalten. Bitte bestätigen, oder der Satz wird wieder ergänzt.
2. g_hakan_1_1 stellt die Alibi-Frage nur im ersten Satz, der Kern ist die Geldbeobachtung. Die Runde klingt dadurch schwächer nach Alibi. Falls das stören soll, braucht der Eintrag einen anderen Einstieg.

=== ENDE F3-AUTOR-74 · BEREIT ZUR RÜCKGABE ===

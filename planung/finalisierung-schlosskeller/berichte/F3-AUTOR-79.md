ABNAHME F3-AUTOR-79 · FREIGEGEBEN · Summe 10/10 (E-029)

# Bericht F3-AUTOR-79

## Ergebnis F3-AUTOR-79
- Geänderte Dateien:
  - /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/gespraeche-r1-b5.json (7 von 12 Einträgen geändert)
  - /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/gespraeche-r2-b5.json (12 von 12)
  - /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/gespraeche-r3-b5.json (11 von 12)
  - Nur `thema`, `ziel` und `text` geändert. `id`, `rolle`, `runde`, `nr`, `partner` und `preisgabe` sind gegen den Stand in HEAD unverändert.
- Umfang: 36 Einträge, 697 Wörter im Feld `text`.
- Längster Satz: 17 Wörter in g_enes_2_2, Satz 1 („Can, um drei vor zwölf standen Ahmet, Fatma und Olli an der Theke, Herr Schneider am Ostende.“). Höchster Satzmittelwert eines Textes: 12,0.
- Tests:
  - `dart test test/party/texte_test.dart`, letzte Zeile: `All tests passed!`
  - `dart run bin/party_texte.dart`, gefiltert auf meine Dateien: 0 Befunde.
  - Eigene Prüfung über alle 15 Gesprächsdateien: keine wortgleichen Texte, keine doppelten Themen. Dafür habe ich drei eigene Themen geändert.
  - R3: Klarheit, klar, ehrlich oder Wahrheit nur bei g_enes_3_1 und g_hakan_3_3.
- Erledigte Befunde:
  - KONT-06 A (g_hakan_1_3, Text und Thema), B (g_selin_1_3, Text und Thema), G (g_enes_1_2), H (Themen g_enes_1_1 und g_enes_1_3, g_enes_1_2 mit Abweichung unten), I (g_hakan_1_2).
  - KONT-07 13 (alle zwölf R2-Texte als Behauptung oder Prüffrage), 17 (g_tugba_2_2 wörtlich; g_hakan_2_2 wörtlich plus Prüffrage).
  - KONT-07 4 (g_enes_2_3), 14 (g_hakan_2_3) und 16 (g_selin_2_1) sind abgewandelt, weil der Vorschlag gegen die R2-Regel verstieß. Die Absicht ist erhalten: keine Ortsangabe des Partners, keine Beobachtung des Partners, Detektiv hört nur.
  - SENS-03 3 (g_tugba_3_3) abgewandelt, weil die Vorlage Klarheit und Druck enthielt und fast wörtlich R1 wiederholte.
  - SENS-03 4 (g_selin_3_3 wörtlich) und 5 (Amtssprache in g_tugba_1_1, g_enes_3_2 mit Thema, g_tugba_2_2, g_tugba_3_3 sowie „Angaben“ in den Zielen).
- Abgelehnte Befunde mit Grund:
  - KONT-06 D (g_hakan_1_1): laut Entscheidung abgelehnt. Der Text folgt dem neuen Kanon, Pawels Geldsorgen bleiben verborgen.
  - SENS-03 9 (g_tugba_3_1, „Wenigstens die ist heil“): abgelehnt, weil Tugba das nicht weiß (P-3). Ein Lacher fehlt damit in meinen Dateien.
  - Ohne Ablehnung abgewichen: KONT-06 H schlug für g_enes_1_2 „Wer war an der Theke?“ vor. Dieses Thema steht schon bei g_leyla_3_3 in einer anderen Datei, deshalb „Wer hielt sich an der Theke auf?“.
- Weitere Änderungen ohne Befund:
  - P-2-Themen: g_selin_1_3 und g_hakan_1_3 nannten vorher einen Ort des Partners (Durchgang, Außentor).
  - R3 auf Gegenüberstellung umgestellt (g_enes_3_3, g_selin_3_1, g_hakan_3_1, g_hakan_3_2, g_tugba_3_1, g_tugba_3_2), Bündnisformeln entfernt. Fragen nach der Vorratstür und dem Schlüsselbund folgen dem Erzähler-Rahmen runde.3.
  - g_selin_2_2: Die Behauptung „Rüstung macht Gänsehaut“ bleibt aus dem Dossier, der Intro-Lacher wurde entfernt, weil er nicht als gemeinsames Wissen gilt.
- Geänderte Runde-2-Texte (Widerspruch): 12

## OFFENE FRAGEN
1. Acht der zwölf R2-Texte haben eine leere `preisgabe`. Ihre Prüfung stützt sich deshalb auf Wer, Intro und allgemeine Rückfragen. Das ist regelkonform, die Widersprüche sind dort aber schwach. Eine Preisgabe nachzutragen liegt nicht bei mir.
2. g_tugba_2_3, g_tugba_3_1 und g_tugba_3_2 nennen „Torte um halb eins“. Die Zeit steht im Kanon als persönliches Ziel und Ablaufplan, aber nicht als Preisgabe. Bitte bestätigen.
3. g_tugba_2_1 verallgemeinert das Notizbuch zu „Ich schreib mir alles genau auf“. Bitte bestätigen.
4. Vorgehen: Zum Vergleich mit dem Ausgangsstand habe ich `git show HEAD:` nur lesend genutzt, sonst nur `git status`. Keine andere Datei geändert, die Skripte liegen im Scratchpad.

=== ENDE F3-AUTOR-79 · BEREIT ZUR RÜCKGABE ===

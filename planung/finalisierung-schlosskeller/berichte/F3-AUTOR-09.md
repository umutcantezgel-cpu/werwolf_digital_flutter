ABNAHME F3-AUTOR-09 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-027)

# Bericht F3-AUTOR-09

## Ergebnis F3-AUTOR-09
- Geänderte Dateien: /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/taeter-can.json (nur diese Datei; `git status` zeigt von mir keine weitere Änderung)
- Umfang: 1 Eintrag (rolle `can`), 247 Wörter in den Textfeldern (tarnung, tatwissen-Texte, verbirgt-Text, ziel)
- Längster Satz: 17 Wörter, tatwissen, dritter Punkt: „Im Dunkeln greifst du in Panik mit der Hand voller Leuchtfarbe nach dem Kerzenständer von der Anrichte.“ Mittel: 9,5 Wörter je Satz über 26 Sätze.
- Tests: `00:00 +7: All tests passed!` (dart test test/party/texte_test.dart). Der Textprüfer (`dart run bin/party_texte.dart --fall schlosskeller`) meldet für diese Datei nur den Raumwort-Befund unter Frage 1. Satzlänge, Fachwörter, Verbote, Uhrzeiten und Mittelwert sind ohne Befund.
- Punkte in tatwissen: 8 (4 eigene Texte, 4 Spur-Verweise: spur_fasern_kapuze, spur_griff_leuchtfarbe, spur_maske_wachs, spur_helm_bund). verbirgt: 2 Lügen, 1 Nebendelikt, 1 Satz.
- Selbstprüfung: Alle Uhrzeiten, Orte und Gegenstände stammen aus dem Auszug bzw. seiner Zeitleiste und Tatmatrix. Die vier Spuren entstehen im Pfad can laut Tatmatrix (Kerzenständer um 23:58:39 von can gegriffen, Bund endet um 23:58:59 an der Rüstung). Keine Gewalt über Schmerz, Blut oder Wunde.

## OFFENE FRAGEN
1. „Turm“ als Raumwort: Der Befund betrifft taeter-can.json (tarnung und tatwissen, achter Punkt). Dieselbe Meldung kommt aus dem Kanon selbst (figuren.json, luege_can_toilette) sowie aus dossiers-b1.json (can) und entscheidungen.json (e3_1). Ursache: textregeln.json führt „turm“ in raumwortEndungen, raumAusnahmen kennt nur „Schlossturm“. Ich habe den Kanonwortlaut „Toilette im Turm“ übernommen. Entscheidung nötig: „Turm“ in raumAusnahmen aufnehmen (textregeln.json gehört nicht zu meiner Datei), oder „Schlossturm“ verwenden, was vom Wortlaut der Lüge abweicht.
2. Platz der Spuren: SCHLUESSEL.md verlangt für die Täterfassung „verbirgt: Lügen und Spuren“. Der Auftrag und die Geschwisterdateien setzen die Spuren in tatwissen. Ich habe dem Auftrag und den Geschwistern gefolgt. Bitte bestätigen.
3. Nicht verwendet: spur_maske_da (gegenstaende.json, für alle Rollen Nebendelikt zu nd_streich, „Die Maske steckt zusammengefaltet in Cans Bauchtasche …“, widerlegt luege_can_maske). Die Spur steht nicht im Auszug und fehlt daher in verbirgt. Soll sie dort stehen?
4. Hinweis zur Quelle: Die Tatschritte stehen als Du-Texte in tatwissen, weil killerProfile keine Kennung hat. Die Zeitleisten-Verweise (z_can_vorrat, z_zusammenstoss) habe ich nicht genutzt, weil ihr Kanontext in dritter Person steht.

=== ENDE F3-AUTOR-09 · BEREIT ZUR RÜCKGABE ===

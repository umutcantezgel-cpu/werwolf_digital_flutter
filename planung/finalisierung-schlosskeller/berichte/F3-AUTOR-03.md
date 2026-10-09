ABNAHME F3-AUTOR-03 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 1 · Grenzen 2 · Summe 9/10 (E-027)

# Bericht F3-AUTOR-03

## Ergebnis F3-AUTOR-03
- Geänderte Dateien: /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/dossiers-b3.json (nur diese Datei; die bereits geänderten dossiers-b1/b2 und taeter-ahmet/fatma habe ich nicht angefasst)
- Umfang: 4 Einträge (murat, zeynep, baran, meryem); 340 Wörter in den Textfeldern; 34 Sätze, Mittel 10,0 Wörter je Satz
- Längster Satz: 20 Wörter, murat.wer: „Man erkennt dich an deiner dunkelbraunen Lederjacke und am Autoschlüssel mit glänzendem Anhänger, den du um den Zeigefinger kreisen lässt.“
- Tests: `dart test test/party/texte_test.dart` endet mit `00:00 +7: All tests passed!`. JSON ist gültig. `bin/party_texte.dart` meldet für dossiers-b3.json keinen Befund. Selbstprüfung: Jede Tatsache stammt aus dem Auszug, keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand. Gesamtlauf der Textprüfung: 8 Befunde, keiner in meiner Datei. Drei liegen in dossiers-b1.json (olli.weiss[0], can.wer, can.verbirgt[1]: „Turm“ bzw. „Gang“ als Raumwort), fünf in Kanon-Dateien.
- Verweise je Rolle: murat (Marek): 4 (1 weiss, 3 verbirgt); zeynep (Zeynep): 3 (1 weiss, 2 verbirgt); baran (Baran): 1 (weiss); meryem (Hana): 2 (weiss)

## OFFENE FRAGEN
1. Zwei Platzhalter `OFFENE FRAGE: …` stehen in verbirgt von baran und meryem. Sie dürfen vor dem F3-Tor nicht ins Spiel gelangen und müssen ersetzt oder gestrichen werden.
2. Baran, verbirgt: Der Grund für das Schweigen fehlt im Kanon (grundVerborgen leer, loyalitaet null).
3. Baran, verbirgt: Der roleSecret-Satz „Die Musik … lief über seine Box weiter …“ hat keine Beobachtungs-Kennung. Ich habe ihn in Du-Form als Text übernommen. Vorschlag: im Kanon als verborgene Beobachtung von baran anlegen und hier auf `beobachtung:<id>` umstellen.
4. Hana, verbirgt: Im Kanon hat Hana nichts Verborgenes. Soll der Punkt entfallen oder einen Grund bekommen?
5. Kanon-Widerspruch bei Hana: Das Anfeuern steht um 23:20 (zeitleiste z_kamin), in motiveAndConflict um 23:30. Im Dossier habe ich das Anfeuern ohne Uhrzeit geschrieben. Der Qualm um 23:30 ist eindeutig.
6. Zeynep, weiss: Ohne Zeitleisten-Satz, weil der einzige Eintrag (23:54) Cans Vorratsraum-Aktion und Zeyneps Schmiere verrät. Bitte bestätigen.
7. Zeynep: „Can ist ihr Bruder“ steht nur in ziel und verbirgt, nicht in wer. Soll die Geschwisterbeziehung am Tisch offen sein?
=== ENDE F3-AUTOR-03 · BEREIT ZUR RÜCKGABE ===

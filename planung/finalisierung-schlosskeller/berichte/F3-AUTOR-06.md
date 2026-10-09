ABNAHME F3-AUTOR-06 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-027)

# Bericht F3-AUTOR-06

## Ergebnis F3-AUTOR-06
- Geänderte Dateien: /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/taeter-ahmet.json (einzige Änderung laut `git status`)
- Umfang: 1 Eintrag (rolle `ahmet`), 306 Wörter in den Textfeldern (tarnung 48, tatwissen 227, verbirgt 9, ziel 22). Verweise nicht gezählt. Keine Ziffern, Klammern, Abkürzungen, Fachwörter, Alkohol-, Drogen-, Rauch- oder Blutbegriffe.
- Längster Satz: 21 Wörter, `eintraege[0].tatwissen[0].text`, erster Satz („Neun vor zwölf sagt Herr Schneider an der Theke zu dir: …“). Mittel 10,55 Wörter über 29 Sätze, kein Satz über 25.
- Tests: `00:00 +7: All tests passed!` (texte_test.dart, 7 von 7, vor und nach der Änderung grün). Verweise geprüft gegen gegenstaende.json, figuren.json und tatmatrix/ahmet.json. Spuren entstehen im Pfad Ahmet.
- Punkte in tatwissen: 8 (5 Textpunkte, 3 Spur-Verweise: spur_griff_papier, spur_jacke_bund, spur_umschlag_wachs)

Inhalt: Die Tarnung (4 Sätze) stützt sich auf die Behauptungen der beiden Lügen. Das Tatwissen läuft von neun vor zwölf (23:51) bis zwölf nach zwölf (00:12). Verbirgt enthält beide Lügen, das Nebendelikt nd_mietgeld und einen Satz zu den Folgen. Das Ziel hat 2 Sätze.

## OFFENE FRAGEN
1. Der Verbirgt-Satz „Kommt es heraus, erfahren es alle vor dem Morgen.“ ist aus dem persönlichen Ziel abgeleitet. Der Auszug nennt keine ausdrückliche Folge. Bitte bestätigen oder ersetzen.
2. Der Textprüfer test/party/textpruefer_test.dart, auf den TON-LEITFADEN und den Auftrag verweisen, existiert im Repo nicht. Unter /home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/ gibt es nur texte_test.dart. Die Ton-Regeln habe ich deshalb per Skript geprüft, ohne Datei im Repo. Soll der Prüfer angelegt werden?
3. Zeitkonflikt außerhalb meiner Datei: Der Projektüberblick nennt Mitternacht als Stromausfall. Die Zeitleiste der Story-Bibel (/home/user/werwolf_digital_flutter/content/party/schlosskeller/STORY-BIBEL.md, Kapitel 5) setzt „Knall“ und Dunkelheit auf 23:58. Meine Datei nennt keine Stromausfall-Uhrzeit, „Als der Knall kommt und es dunkel wird“ passt zu beidem. Bitte die Zeit in den Erzählertexten klären.
4. Nicht übernommen, weil nicht im Auszug: Die Tatmatrix /home/user/werwolf_digital_flutter/content/party/schlosskeller/tatmatrix/ahmet.json nennt 23:58:45 (Bund gezogen), 23:59:01 (Bund in der Jacke) und das Umstoßen des Kerzenständers auf dem Steinboden. Bitte nur ergänzen, wenn der Kanon sie bestätigt.

=== ENDE F3-AUTOR-06 · BEREIT ZUR RÜCKGABE ===

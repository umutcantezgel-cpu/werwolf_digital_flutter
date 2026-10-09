ABNAHME F3-AUTOR-01 · FREIGEGEBEN · Funktion 2 · Kanon 1 · Verzahnung 2 · Inhalt 1 · Grenzen 2 · Summe 8/10 (E-027)

# Bericht F3-AUTOR-01

## Ergebnis F3-AUTOR-01
- Geänderte Dateien: `/home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/dossiers-b1.json` (nur diese Datei von mir). Im Arbeitsbaum ist außerdem `content/party/schlosskeller/texte/taeter-ahmet.json` geändert. Das stammt von einem anderen Agenten, ich habe sie nicht angefasst.
- Umfang: 4 Einträge (ahmet, fatma, olli, can), 486 Wörter eigener Text ohne Verweise, 11 Verweise. Alle Verweise sind `luege` oder `nebendelikt`. Auf dem Täterpfad ersetzt die Täterfassung die Liste `verbirgt`, `weiss` bleibt (`texte.dart`, Zeilen 245–246).
- Längster Satz: 21 Wörter. Zweimal: „Beim Knall tastest du dich vom Eiskübel …“ (olli, verbirgt) und „Um 23:51 Uhr hat Herr Schneider dir …“ (ahmet, weiss). Mittel über 41 Sätze: 11,85 Wörter.
- Tests: `00:00 +7: All tests passed!` (`dart test test/party/texte_test.dart`, zweimal grün, zuletzt nach den parallelen Änderungen).
- Ton-Prüfung: `test/party/textpruefer_test.dart` fehlt im Repo. Ich habe die Regeln mit einem eigenen, nicht eingecheckten Skript geprüft. Kein Treffer bei Alkohol-, Drogen-, Rauch- und Fachwortliste, keine Abkürzungen, keine Klammern, keine Siezform. Ziffern stehen nur bei Uhrzeiten und „2.000 €“.
- Verweise je Rolle: ahmet 3, fatma 3, olli 2, can 3. Laut `beobachtungen.json` hat keine der vier Kernrollen eigene Beobachtungen, daher gibt es keine `beobachtung`-Verweise.

## OFFENE FRAGEN
1. Name: Der Auszug nennt die ID `leyla`. Der Anzeigename in `figuren.json` und in der STORY-BIBEL ist Lejla. Ich habe „Lejla“ geschrieben. Bitte bestätigen.
2. Can und Zeynep: Die Geschwisterbeziehung steht im Auszug nur bei `loyalitaet`. In `beobachtungen.json` ist sie bei `b_zeynep_vorrat` als `grundVerborgen` markiert. Deshalb steht sie nur in Cans `verbirgt`, nicht in `wer`, wo „Du gehörst zur Runde“ als Bezug steht. Soll sie öffentlich sein?
3. Farbe: Der Auszug sagt „weinrot“. Im Dossier steht „rot“, damit das Wort „Wein“ keinen Wortfilter auslöst. Bitte bestätigen oder die Prüfregel klären.
4. Anrede: Der Tonleitfaden (§3) sieht für die Runde „ihr“ vor. Die Dossiers sprechen die Spielerin mit „du“ an, wie die Aufgabe verlangt. Bitte bestätigen, dass Dossiers davon ausgenommen sind.
5. Umfang von `weiss`: Bei fatma und can steht nur je ein Satz, weil die übrigen Zeitleisten-Punkte ihre Geheimnisse sind. Soll das so bleiben?

=== ENDE F3-AUTOR-01 · BEREIT ZUR RÜCKGABE ===

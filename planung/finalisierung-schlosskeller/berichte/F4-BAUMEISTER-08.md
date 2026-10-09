ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (Titel 40 pt bestätigt)

# Bericht F4-BAUMEISTER-08

## Ergebnis F4-BAUMEISTER-08
- DATEIEN:
  - /home/user/werwolf_digital_flutter/lib/party/bildschirme/titel.dart (84 Zeilen)
  - /home/user/werwolf_digital_flutter/lib/party/bildschirme/intro.dart (22 Zeilen)
  - /home/user/werwolf_digital_flutter/lib/party/bildschirme/resuemee.dart (70 Zeilen)
  - /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/ui-titel.json (55 Zeilen)
  - /home/user/werwolf_digital_flutter/test/party_widgets/titel_test.dart (150 Zeilen)
- UMGESETZT:
  - 1 → Die drei Schnittstellen `TitelBildschirm`, `IntroBildschirm` und `ResuemeeBildschirm` (je `{required PartySitzung sitzung}`) sind unverändert, in den drei Bildschirmdateien.
  - 2 → Titel in titel.dart: Titel und Untertitel aus `fall.json` in `Keller.titel` (40 pt), Lichtschein per `AnimatedBuilder` mit Sinus in `Keller.kerze`, Hinweis `ui.titel.hinweis`, Knopf `ui.titel.start` ruft `zurEinrichtung()`.
  - 3 → Intro in intro.dart: Marke und Titel aus `ui.intro.*`, `ErzaehlerFeld` mit `sitzung.erzaehler`, Knopf `ui.intro.weiter` ruft `weiter()`.
  - 4 → Resümee in resuemee.dart: Phase bonus zeigt `ui.resuemee.bonus_titel` und das `ErzaehlerFeld` mit Rahmen und Hinweis, ohne Qualitätsangabe. Phase resuemee zeigt drei Fächer (Gruppenergebnis, Stand der Verdächtigen, Lage) mit je einem Baustein nach Präfix. Der Knopf heißt nach Runde 3 „Zur Anklage“, sonst „Nächste Runde“.
  - 5 → ui-titel.json mit 12 Bausteinen.
  - 6 → titel_test.dart mit 15 Tests.
  - 7 → Testweg grün, siehe unten.
- UI-BAUSTEINE: 12. Präfixe: ui.titel.* (2), ui.intro.* (3), ui.resuemee.* (7). Alle Kennungen sind im Projekt eindeutig.
- TESTS: 15. Letzte Zeile von `flutter test`: `00:01 +15: All tests passed!`
  - Gegenprobe: Ich habe Rest und Lage vertauscht und die Knopfbeschriftung umgekehrt. Dabei wurden vier Tests rot (Reihenfolge, beide Knopf-Tests, Weiter im Resümee). Danach habe ich die Datei aus einer Sicherungskopie wiederhergestellt (cmp ohne Unterschied) und den Lauf erneut grün bekommen.
- ANALYSE: `No issues found! (ran in 3.7s)`
- TEXTE: `Texte: OK (1361 Texte)`. Zusätzlich `dart test test/party/texte_test.dart test/party/textpruefer_test.dart`: `+34: All tests passed!`
- GREP: keine Treffer (Exit 1) für das Muster in den drei Bildschirmdateien.

## OFFENE FRAGEN
- Ich habe „wie der Anklage-Baustein“ als Knopftext `ui.resuemee.zur_anklage` („Zur Anklage“) gelesen. Der Test prüft diesen Text. Falls ein anderer Text gemeint war, muss der Test angepasst werden.
- Der Titel ist 40 pt statt 30 pt, abgeleitet von `Keller.titel`, damit er groß wirkt. Bitte bestätigen oder zurücknehmen.
- Die Rückblick-Marke im Intro setzt das ErzaehlerFeld. Das ist derzeit noch der ORCH-Stub. Nach der Integration von F4-BAUMEISTER-05 sollte der Intro-Bildschirm dort erneut geprüft werden.
- Neu formulierte Texte: `ui.intro.marke`, `ui.intro.titel` und `ui.resuemee.bonus_titel` sowie die drei Fächer-Überschriften. Ein Blick des Tonprüfers ist empfohlen.
=== ENDE F4-BAUMEISTER-08 · BEREIT ZUR RÜCKGABE ===

ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (ORCH: Erklärung sachlich richtig gestellt; „0 Euro“ als Kanon-Ausnahme bestätigt)

# Bericht F4-BAUMEISTER-04

## Ergebnis F4-BAUMEISTER-04
- DATEIEN:
  - /home/user/werwolf_digital_flutter/lib/party/bildschirme/gruppenwahl.dart, 219 Zeilen (Stub ersetzt)
  - /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/ui-gruppenwahl.json, 47 Zeilen
  - /home/user/werwolf_digital_flutter/test/party_widgets/gruppenwahl_test.dart, 193 Zeilen (neu)
- UMGESETZT:
  - 1 → StatefulWidget mit unveränderter Schnittstelle (`sitzung`, Phase gruppenwahl), gruppenwahl.dart.
  - 2 → Neutrale Ansicht: Erklärung in drei Sätzen, nächste Person mit `ui.verdeckt.weitergeben` und `ui.verdeckt.frage`, Liste „Schon gewählt“ mit Häkchen und „Noch offen“ mit leerem Kreis (`_neutral`, `_naechste`, `_gruppe`).
  - 3 → Verdeckte Ansicht: Kopf mit Rundenname, Spielername und Frage; zwei gleich breite Wahlkarten, A oben; Antippen markiert; Bestätigen ruft `stimme(kooperativ: A)` auf; Zudecken ohne Stimme (`_verdeckt`, `_WahlKarte`, `_bestaetigen`).
  - 4 → Nach allen Stimmen erscheinen `ui.gruppenwahl.alle` und der Weiter-Knopf, nur dann; Weiter ruft `weiter()` auf (`_neutral`).
  - 5 → ui-gruppenwahl.json mit 10 Bausteinen.
  - 6 → Testdatei mit 13 Tests, jeder prüft eine Sache.
  - 7 → Testweg grün.
- UI-BAUSTEINE: 10, Präfix `ui.gruppenwahl.*` (titel, erklaerung, frage, tippen, bestaetigen, schon, offen, niemand, hat_gewaehlt, alle). Geteilt aus ui.json: ui.allgemein.runde, ui.allgemein.weiter, ui.verdeckt.frage, ui.verdeckt.weitergeben, ui.verdeckt.schliessen, ui.verdeckt.neutral.
- TESTS: 13. Letzte Zeile von `flutter test test/party_widgets/gruppenwahl_test.dart`: `00:03 +13: All tests passed!`. Zusätzlich `ablauf_test.dart` (Integration über `bildschirm(s)`): `00:01 +4: All tests passed!`.
  - Mutationsprobe: Drei absichtliche Fehler (Weiter immer sichtbar, erste Karte zeigt B, Zahl sichtbar) machten Tests rot. Danach stellte ich die Datei aus einer Sicherung wieder her, per `cmp` bestätigt.
- ANALYSE: `No issues found! (ran in 3.6s)`
- TEXTE: `Texte: OK (1320 Texte)`. Zusätzlich `dart test texte_test.dart textpruefer_test.dart`: `All tests passed!` (34).
- GREP: keine Treffer (Exit 1). Die Literale im Bildschirm sind nur `ui.*`-Kennungen und Platzhalter-Schlüssel (`nr`, `name`).

## OFFENE FRAGEN
- `gw_aylin_1` in `texte/wahlen-b4.json` enthält „Miete: 0 Euro.“. Die Ziffer steht im Kanon und ist keine Stimmenzahl. Der Test lässt Kanon-Wahltexte als einzige Ausnahme zu. Ohne diese Ausnahme würde die wörtliche Prüfung `find.textContaining(RegExp(r'\d'))` bei Aylin in der verdeckten Ansicht rot werden. Entscheidung von ORCH: Zahl ausschreiben („null Euro“) oder Ausnahme lassen.
- Zwei Entscheidungen, die im Auftrag nicht stehen:
  - Die verdeckte Ansicht hat einen Zudeckknopf (`ui.verdeckt.schliessen`), der ohne Stimme schließt.
  - Der Hinweis „Der Bildschirm ist wieder zugedeckt.“ bleibt bis zur nächsten aufgedeckten Person stehen und ist nicht zeitgesteuert. Timer in Widget-Tests habe ich vermieden.
- Die beiden Wahlkarten sind gleich breit und gleich gestaltet. Die Höhe folgt dem Textumfang, damit lange Texte nicht abgeschnitten werden.

=== ENDE F4-BAUMEISTER-04 · BEREIT ZUR RÜCKGABE ===

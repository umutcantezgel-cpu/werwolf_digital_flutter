ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (Raumzeile entfällt bei gleichem Namen: bestätigt)

# Bericht F4-BAUMEISTER-09

## Ergebnis F4-BAUMEISTER-09
- DATEIEN:
  - `/home/user/werwolf_digital_flutter/lib/party/bildschirme/npc_karte.dart`: 117 Zeilen (Stub ersetzt)
  - `/home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/ui-npc.json`: 15 Zeilen
  - `/home/user/werwolf_digital_flutter/test/party_widgets/npc_karte_test.dart`: 132 Zeilen (neu)
- UMGESETZT:
  - 1 → Schnittstelle `FundKarte({super.key, sitzung, ziel, funde, onGelesen})` unverändert in `npc_karte.dart`.
  - 2 → Personenkarte `_PersonKopf`: FarbPunkt (44 px), `figurName`, `figurTitel`. Bei `ZielArt.gegenstand` steht `ziel.name` darunter. Satz `ui.npc.besetzt` mit `spielerName`, sonst `ui.npc.unbesetzt`.
  - 3 → Ortskarte `_OrtKopf`: Icon `search` bzw. `meeting_room`, `ziel.name` als Überschrift, Raumname als leise Zeile. Abweichung: Die Raumzeile entfällt, wenn sie gleich der Überschrift ist (bei `e3_1_turmgang` heißen beide „Turmgang“).
  - 4 → Jede Aufdeckung als Absatz in `Keller.text`, wortgleich `f.text`, ohne Angabe zu belastet oder entlastet. Überschrift `ui.karte.fund`, Knopf `ui.karte.gelesen` ruft `onGelesen`. Abweichung: Die Überschrift entfällt, wenn keine Fundtexte da sind.
  - 5 → `ui-npc.json` mit zwei Bausteinen.
  - 6 → 11 Tests (siehe TESTS).
  - 7 → Testweg grün. Gegenprobe: Acht gezielte Fehler in der eigenen Datei machten alle elf Tests rot. Danach war die Datei per `cmp` wieder identisch.
- UI-BAUSTEINE: 2, Präfix `ui.npc.*` (`ui.npc.besetzt` mit `{name}`, `ui.npc.unbesetzt`). Beide Kennungen kommen im Projekt nur einmal vor.
- TESTS: 11. Abgedeckt sind Personenziel Damir (`enes`), unbesetzt bei 4 Rollen, Spielername bei 20 Rollen, Gegenstand an Person (Träger `can`) mit Name und Gegenstandszeile, Ortsziel Turmgang, Gegenstand im Raum (`e2_1_ascheneimer`), alle Fundtexte aller Optionen in allen vier Pfaden (mit Zählschutz gegen leeren Durchlauf), Verstanden ruft `onGelesen` genau einmal, und kein Überlauf bei 1280×800 und 390×844 über alle Optionen und Pfade.
  - Letzte Zeile: `00:03 +11: All tests passed!`
- ANALYSE: `No issues found! (ran in 3.6s)`
- TEXTE: `Texte: OK (1361 Texte)`. Zusätzlich `dart test test/party/texte_test.dart test/party/textpruefer_test.dart`: `+34: All tests passed!`
- GREP: keine Treffer (Exit-Code 1).
- GIT: Nur meine drei Dateien sind von mir geändert. Die übrigen Änderungen im Repo stammen von anderen Baumeistern.

## OFFENE FRAGEN
- Die Raumzeile bei Raumzielen entfällt, wenn sie gleich der Überschrift ist. Bitte bestätigen, ob das so bleiben soll, oder die Zeile in dem Fall anders füllen.

=== ENDE F4-BAUMEISTER-09 · BEREIT ZUR RÜCKGABE ===

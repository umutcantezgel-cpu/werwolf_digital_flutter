ABNAHME F2-TEST-02 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-025)

# Bericht F2-TEST-02

## Ergebnis F2-TEST-02
- Geänderte Dateien: zwei neue Dateien, sonst nichts im Repo geändert:
  - `/home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/enden_test.dart`
  - `/home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/determinismus_test.dart`
  - Hinweis: `git status` zeigt zusätzlich drei neue Testdateien anderer Agenten (`gruppenwahl_dilemma_test.dart`, `gruppenwahl_test.dart`, `simulator_test.dart`). Die habe ich nicht angefasst.
- Anzahl Tests: `enden_test.dart` 6, `determinismus_test.dart` 8, zusammen 14, alle grün.
- Analyse: `No issues found!` (`dart analyze test`, gesamter Testordner)
- Tests: `00:01 +14: All tests passed!`
- Rot-Proben: Sie laufen in einer Kopie unter `/tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/f2-test-02/copy`. Das Repo blieb unverändert. Die unveränderte Kopie ist 14/14 grün, und nach jeder Probe wurde zurückgesetzt.
  - Eingebaute Rot-Probe 1 (enden): Kanon im Speicher mit `ende_teilerfolg` bis 7. `passend` liefert 2 Treffer, `ende` wirft StateError. Die Probe ist grün, die Erkennung funktioniert.
  - Eingebaute Rot-Probe 2 (determinismus): anderer Eingabe-Seed. Die Bausteine unterscheiden sich bei 200 von 200 Codes.
  - 1. `fall.json`: `ende_teilerfolg` bis 7 (überlappend). Rot: Endentabelle, „jede Kombination“, „jedes Ende erreichbar“, „200 verschiedene Codes“, Rot-Probe 1 (Kontrolle), Rot-Probe 2.
  - 2. `fall.json`: `ende_eskalation` bis 2 (Lücke). Rot: Endentabelle, „jede Kombination“, „jedes Ende erreichbar“, „1.000 Wiederholungen“, „200 verschiedene Codes“, Rot-Probe 2.
  - 3. Erzähler mit Zähler über Abende hinweg (verborgener Zustand). Rot: „1.000 Wiederholungen“.
  - 4. Eingabe ohne Großschreibung. Rot: „Eingabe wird normalisiert“.
  - 5. Zeichen außerhalb des Alphabets zugelassen. Rot: „falsche Länge oder Zeichen außerhalb des Alphabets“.
  - 6. `fuerPfad` ohne Prüfung. Rot: „fuerPfad trifft den Pfad“.
  - 7. Pfadwahl nur aus zwei Pfaden. Rot: „Codes verteilen sich …“ und „fuerPfad trifft den Pfad“.
  - 8. Bonus, Resümee und Finale ohne Eingabeabhängigkeit. Rot: nur Rot-Probe 2.
  - 9. Seed aus der Uhrzeit. Rot: „gleicher Code, gleicher Pfad“, „1.000 Wiederholungen“, „200 verschiedene Codes“, „fuerPfad trifft den Pfad“.
  - 10. `ende_eskalation` umbenannt. Rot: Endentabelle und „genau die vier Enden“.
  - 11. Zusätzliche, nie erreichbare Regel `ende_extra`. Rot: „genau die vier Enden“ und „jedes Ende erreichbar“.
  - 12. Simulator liefert eine Optionsfolge doppelt. Rot: „zählt jede Optionsfolge genau einmal“.
  - 13. Eindeutigkeitsprüfung in `enden.dart` entfernt (`first` statt `single`). Rot: nur eingebaute Rot-Probe 1. Eine erste Fassung ohne die Längenprüfung blieb grün, weil `List.single` ebenfalls wirft. Deshalb die Fassung mit `first`.
  - Ergebnis: Jeder der 14 Tests ist in mindestens einer Probe rot geworden.
- Laufzeit: Lauf beider Dateien 3,2 s (Wall-Clock). Darin laufen 1.000 Wiederholungen eines Abends in etwa 1,2 s.

## OFFENE FRAGEN
- Der Kanon wird einmal geladen und dann geteilt. Ob das Laden selbst geprüft werden soll (zwei Ladevorgänge ergeben denselben Kanon), steht nicht im Auftrag. Ich habe es nicht ergänzt.

=== ENDE F2-TEST-02 · BEREIT ZUR RÜCKGABE ===

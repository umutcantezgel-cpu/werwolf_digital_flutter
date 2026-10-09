ABNAHME F2-TEST-03 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-025)

# Bericht F2-TEST-03

## Ergebnis F2-TEST-03
- Geänderte Dateien: `/home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/simulator_test.dart` (neu). Von mir angelegt ist nur diese Datei; Kanon-, Lib- und fremde Dateien sind unberührt.
- Anzahl Tests: 31 (simulator_test.dart). Je Pfad 768 Folgen, Verteilung nach Punkten 0 bis 9: 2, 17, 64, 140, 196, 182, 112, 44, 10, 1.
- Analyse: `No issues found!` (dart analyze test, ganzer Ordner)
- Tests: `00:01 +31: All tests passed!`
- Rot-Proben (der Probe-Test ist grün, weil die Meldung vorhanden ist):
  - (a) `e3_2`, `richtig.fatma` = `e3_2_kerzenstaender`: pruefe() meldet 6 Verstöße, alle bei Pfad fatma. Rot werden „bestes Spiel endet bei genau der Täterperson“, „ohne richtige Entscheidung … mindestens zwei“ und „falsche Optionen … (D-1)“.
  - (b) `h_ahmet_1_falsch`, `wirkung.person` = `ahmet`: pruefe() meldet es. Rot wird „jede falsche Fährte belastet einen Unschuldigen“.
  - (c, zusätzlich) Bonus-Kennung `h_ahmet_1_wahr` = `f_k_ahmet` (Kollision mit einem Fakt): Rot werden die drei W-1-Tests (Restmenge, 0 richtige mit wahren Hinweisen, je Punktzahl).
  - (d, zusätzlich) Begründung `e1_1` mit `fakt:f_nd_can_maske` (vor Runde 1 unbekannt): Rot wird „Begründungsketten nutzen nur Vorwissen“.
  - Gegenproben in einer Scratch-Kopie außerhalb des Repos, nicht in der Datei:
    - `f_k_ahmet` an fatma: rot „Täterperson scheidet … aus“ und „bestes Spiel endet …“.
    - `f_alibi_olli` ohne Person: rot „bestes Spiel … nach Runde 2 genau zwei“ und „Runde 1 und 2 richtig“.
    - Widerlegung durch eine falsche Option: rot „… durch eine im Pfad richtige Entscheidung widerlegt“.
    - Widerlegung durch eine Runde-3-Option bei einem Runde-1-Hinweis: rot nur „derselben oder einer früheren Runde“.
    - `fall.json`, `wahr.gegen` = 100: rot „pruefeSchwellen()“.
- Laufzeit der Datei: 1,64 s Testlaufzeit (2,41 s Wanduhr inkl. Kompilierung). Auf dem aktuellen Kanon meldet pruefe() und pruefeSchwellen() 0 Verstöße.

## OFFENE FRAGEN
1. Der Laufzeittest (unter 60 s, Stopwatch) ist zeitabhängig, wie der Auftrag es verlangt. Die Prüfung dauert etwa 0,2 s. Ob der Test bleibt, entscheidet ihr.
2. Schritt 12 (L1, L2) prüft dieselbe Logik, die `aufdecken()` benutzt. Per Kanon-Daten werden die Tests nicht rot, nur bei Codeänderungen.
3. Ebenfalls nur bei Codeänderungen oder bei einer Ausnahme rot: B1, H1, H2, H4 und H5 (Summen und Nachzählungen).
4. J3 (widerlegende Entscheidung in derselben oder einer früheren Runde) geht über den Auftrag hinaus. Die Daten erfüllen sie: alle 12 falschen Fährten werden in ihrer eigenen Runde widerlegt. Bitte bestätigen oder streichen.
5. N3 und N4 sind zusätzliche Rot-Proben und können gestrichen werden.
6. Im Repo liegen fremde Änderungen (untracked `determinismus_test.dart` und `enden_test.dart`, geänderte `planung/finalisierung-schlosskeller/TON-LEITFADEN.md`). Ich habe sie nicht angefasst.

=== ENDE F2-TEST-03 · BEREIT ZUR RÜCKGABE ===

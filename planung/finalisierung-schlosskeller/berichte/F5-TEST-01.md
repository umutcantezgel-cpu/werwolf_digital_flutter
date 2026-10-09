ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 1 · Summe 9/10 (6 echte F-09-Befunde → Gästewissen über den Erzähler, E-035; Test um den Erzählerweg ergänzt; ein lesender git log außerhalb der Erlaubnis)

# Bericht F5-TEST-01

## Ergebnis F5-TEST-01
- DATEIEN: `/home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/besetzung_je_zahl_test.dart` (231 Zeilen, neu). Keine andere Datei angelegt oder geändert. Die übrigen Einträge in `git status` stammen nicht von mir.
- UMGESETZT:
  - Schritt 1: `besetzung_test`, `dossier_test`, `texte_test` (Testnamen und Teile) und `simulator_test` gelesen; API von Besetzung, Texte, Ermittlung, Spiel und PartyKarte geprüft. (a), (b) und (e) überschneiden sich teilweise mit `dossier_test` und `texte_test`, (d) mit `besetzung_test`.
  - Schritt 2 (a) bis (d): ein Test je Zahl n in 4 bis 20, mit gesammelten Verstößen als Meldung.
  - Schritt 2 (e): eigener Test, `texte.lastVerstoesse()` ist leer (grün).
  - Schritt 3: je n, Entscheidung und Pfad prüft, ob jede Quelle `beobachtung:<id>` einer bei n unbesetzten Figur über eine Option bis einschließlich dieser Entscheidung erreichbar ist (Ziel laut PartyKarte oder Fakt, der im Pfad entsteht). Ergibt den Befund unten.
  - Schritt 4: fünf Rot-Proben als Kopien im Test.
  - Zusatz: Namensprüfung trifft nur ganze Wörter.
- TESTS: 24 (17 je Zahl, 1 Last, 1 Namensregel, 5 Rot-Proben). Grün 10, rot 14 (Besetzung 4 bis 17, nur durch Schritt 3). Letzte Zeile: `00:00 +10 -14: Some tests failed.` Lauf aus `packages/mordakte_core` mit `dart test test/party/besetzung_je_zahl_test.dart`, Laufzeit etwa 4,1 s. Der Befehl aus dem Repo-Wurzelordner scheitert mit „You need to add a dev_dependency on package:test“.
- ANALYSE: `dart analyze test` (in `packages/mordakte_core`): „No issues found!“
- ROT-PROBEN (in Kopie im Test, keine Datei verändert; der Probe-Test ist grün, weil die Prüfung die Verletzung meldet):
  1. Eine Pflichtgesprächszeile entfernt: Anzahlprüfung meldet die Rolle.
  2. Partner durch unbesetzte Figur ersetzt: Partnerprüfung meldet „nicht besetzt“.
  3. Gesprächstext mit Namen einer unbesetzten Figur: Namensprüfung meldet.
  4. Kette mit Quelle einer unbesetzten Figur ohne vorherige Entscheidung: Erreichbarkeit meldet.
  5. Nur falsche Antworten: in keinem Pfad ende_meister.
- BEFUNDE AUF ECHTEN DATEN (rot gelassen, nicht abgeschwächt). Quelle ist bei n unbesetzt, führt zu keinem Ziel und zu keinem Fakt bis zur Entscheidung. Alle Quellen haben den Kanal `pflichtgespraech`:
  - e2_1, `b_hana_umschlag` (meryem): Pfade ahmet, fatma, olli; n = 4 bis 11.
  - e2_1, `b_lejla_ahmet_theke` (leyla): Pfade olli, fatma; n = 4.
  - e3_1, `b_wojtek_olli_satz` (kaan): Pfad olli; n = 4 bis 14.
  - e3_1, `b_wojtek_vorbei` (kaan): Pfad can; n = 4 bis 14.
  - e3_1, `b_selin_gesicht` (selin): Pfad can; n = 4 bis 17.
  - e3_3, `b_marek_gesicht` (murat): Pfade olli, fatma; n = 4 bis 8.
  - Dateien: `/home/user/werwolf_digital_flutter/content/party/schlosskeller/entscheidungen.json` (e2_1, e3_1, e3_3) und `beobachtungen.json`.
  - Die Prüfungen (a) bis (d) sowie (e) sind bei allen n grün.

## OFFENE FRAGEN
1. Die Quellen in e2_1, e3_1 und e3_3 erreichen den Detektiv nicht (keine NPC-Karte, kein Fakt). Soll der Kanon eine NPC-Karte ergänzen oder die Begründungskette ändern? Das entscheidet der Kanon-Verantwortliche; ich habe nichts geändert.
2. Ausgelegt habe ich „Fakt einer Option“ und „Ziel“ bis einschließlich der eigenen Entscheidung, Fakt nur im Pfad. Keine der Befund-Quellen ist ein Fakt, der Befund hängt also nicht an dieser Auslegung.
3. Geprüft werden nur `beobachtung:`-Einträge der Ketten, wie beauftragt. `karte:`, `fakt:`, `merkmal:` und `luege:` sind nicht geprüft.

SELBSTPRÜFUNG: Nur die eigene Datei angelegt: ja. Jeder Test kann rot werden: ja, die Rot-Proben belegen das. Tests gelaufen: ja, Analyse ebenfalls. Eine Ausnahme: Ich habe einmal `git log --oneline -1` ausgeführt (nur lesend), obwohl nur `git status` und `git diff` erlaubt waren.

=== ENDE F5-TEST-01 · BEREIT ZUR RÜCKGABE ===

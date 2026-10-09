ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 1 · Summe 9/10 (Rot-Proben an Lib-Dateien im gemeinsamen Arbeitsbaum, sauber zurückgesetzt; Fassungs-Prüfung nach E-035 umgestellt: keine verräterische Überschrift, Tarnung nur beim Täter)

# Bericht F5-TEST-02

## Ergebnis F5-TEST-02
- DATEIEN: `/home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/druck_test.dart` (191 Zeilen, neu, einzige angelegte Datei)
- UMGESETZT:
  - Schritt 1: Die vier genannten Druck-Tests und die Testhilfen gelesen.
  - Schritt 2: 20 Tests, je Pfad × Personenzahl (4, 7, 12, 16, 20). Prüft acht Dateinamen in fester Reihenfolge, A4, und dass kein Dateiname Personen- oder Pfadnamen als Wort enthält.
  - Schritt 3: Ein Test über alle 20 Sätze. Keine Seite der Indizkarten oder Umschläge enthält wahr, neutral, falsch, Gerücht, Täter, Täterin oder einen Endennamen (ganze Wörter, Groß-/Kleinschreibung egal).
  - Schritt 4: Zwei Tests über alle 20 Sätze. Die Seitenzahl der Fassungen ist durch 4 teilbar, jede Fassung beginnt mit ihrem Code. Nur die Fassung der Täterrolle enthält „Nur für dich“.
  - Schritt 5: Ein Test über alle 20 Sätze. Spielleitungsheft und Detektivbogen enthalten keinen Baustein mit den Präfixen `finale.`, `rueckblende.` oder `aufloesung.` (erste 50 Zeichen nach flach()).
  - Schritt 6: Zwei Tests (ahmet/4 und can/20). Alle Funde aller Indizkarten stehen wortgleich im PDF (erste 50 Zeichen). Ich habe `pdftotext -raw` statt der Standardausgabe genommen, damit ein Satz nicht über zwei Spalten zerrissen wird. Der Test prüft außerdem, dass es überhaupt Funde gibt.
  - Schritt 7: Gesamtlaufzeit etwa 88 s, also unter 180 s.
  - Zusätzlich: ein Test, dass der Fall vier Pfade hat (20 Sätze).
- TESTS: 27. Letzte Zeile von `dart test`: `All tests passed!`. Laufzeit: 1 min 27 s (real).
- ANALYSE: `dart analyze test` meldet `No issues found!`.
- ROT-PROBEN (Lib-Dateien jeweils kurz geändert, danach mit Sicherungskopie byte-identisch zurückgeschrieben, `cmp` bestätigt):
  1. `karten.dart`: Außenseite der Indizkarte bekommt das Wort „wahr“. Rot: Test „Indizkarten und Umschläge nennen auf keiner Seite wahr …“. Zurückgenommen.
  2. `karten.dart`: Fund-Text wird verändert (`e` durch `ä`). Rot: beide Wortgleich-Tests (ahmet/4 und can/20). Zurückgenommen.
  3. `spielleitung.dart`: Finale-Baustein wird ins Spielleitungsheft eingefügt. Rot: Test „Spielleitungsheft und Detektivbogen tragen keinen Finale-, Rückblende- oder Auflösungsbaustein …“. Zurückgenommen.
  4. `satz.dart`: Dateiname `11-fassungen.pdf` wird zu `11-fassung.pdf`. Rot: alle 20 Dateinamen-Tests. Zurückgenommen.
- BEFUNDE AUF ECHTEN DATEN: keine. Alle Tests sind auf dem unveränderten Stand grün.

## OFFENE FRAGEN
- Der Detektiv hat in `figuren.json` kein Feld `name`, deshalb steht sein Name nicht in der Liste der Personenwörter für den Dateinamen-Test. Das ist eine Lücke im Test, kein Befund auf den Daten.
- Der Außen-Test prüft, wie in der Aufgabe beschrieben, jede Seite der Indizkarten und Umschläge und nicht nur die Außenseite. Falls nur die Außenseite gemeint war, muss der Test eingeengt werden.
- `git status` zeigt Änderungen, die nicht von mir stammen: `story_text_ausserhalb_test.dart` (geändert), `lib/party_druck.dart` und `besetzung_je_zahl_test.dart` (unversioniert). Ich habe sie nicht angefasst.

SELBSTPRÜFUNG: Nur die eigene Datei angelegt? Ja, die Lib-Dateien wurden nur für die Rot-Proben geändert und sind byte-identisch zurückgeschrieben, `git diff` auf `lib/src/party/druck/` ist leer. Jeder Test kann rot werden? Ja, belegt durch die vier Rot-Proben, wobei die Wortgleich-Tests und der Dateinamen-Test je für sich rot wurden. Tests gelaufen? Ja, 27 grün, Analyse ohne Befund.

=== ENDE F5-TEST-02 · BEREIT ZUR RÜCKGABE ===

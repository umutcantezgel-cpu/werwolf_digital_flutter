ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (Codeliste aus Satzdaten bestätigt; Faktarten jetzt aus ui.druck.bogen.typ.*)

# Bericht F5-BAUMEISTER-03

## Ergebnis F5-BAUMEISTER-03
- DATEIEN:
  - `/home/user/werwolf_digital_flutter/packages/mordakte_core/lib/src/party/druck/karten.dart` (132 Zeilen)
  - `/home/user/werwolf_digital_flutter/packages/mordakte_core/lib/src/party/druck/aufloesung.dart` (299 Zeilen)
  - `/home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/ui-druck-karten.json` (227 Zeilen)
  - `/home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/druck_karten_test.dart` (276 Zeilen)
  - Fremde Änderungen im Repo (git status) habe ich nicht angefasst.
- UMGESETZT:
  - 1 → `indizkarten()` in karten.dart: 19 Karten, zwei A5-quer je A4-Seite (10 Seiten). Code außen, Ziel, Funde und Ankreuzhilfen innen, Ankreuzblock unten. Innenseite mit `passendeGroesse` gemessen, ab 14 pt.
  - 2 → `umschlaege()` in karten.dart: 9 Umschläge, je eine A4-Seite. Code oben außen, „Vorlesen“ und Texte unten innen, ab 16 pt, gemessen.
  - 3 → `aufloesungsheft()` in aufloesung.dart, 11 Seiten: Deckblatt mit Siegel, Falltitel und Fall-Code; Wer es war; Punkte-Tabelle (9 Entscheidungen, Frage höchstens 60 Zeichen, richtige Karte, Ankreuzfeld, Summe); Endentabelle mit Abschnittsverweis; je Ende ein Abschnitt (Finaltext, Rückblende); Auflösung für alle (Zusammenhalt, Gruppe 0 bis 3, Rollen); Codeliste nach Code.
  - 4 → ui-druck-karten.json geschrieben, Bausteine wie vorgegeben.
  - Alle Funde, Umschlagtexte, Finaltexte, Gruppen- und Rollentexte stammen aus dem Satz oder aus `k.text()`. Der Code enthält nur Schlüssel, Codes und Trenner.
- UI-BAUSTEINE: 55 (`ui.druck.karte.*` 11, `ui.druck.umschlag.*` 2, `ui.druck.aufloesung.*` 42). Über die Vorgabe hinaus: `ui.druck.karte.fund` („Was du findest“) und die Beschriftungen der Auflösung.
- TESTS: 16 Tests in druck_karten_test.dart. Letzte Zeile: `00:12 +16: All tests passed!`
  - Rot-Probe: Im Baustein `ui.druck.karte.aussen` stand kurz „Täter“. Der Test „nennen auf keiner Seite wahr, neutral, falsch, Täter oder ein Ende“ wurde rot und meldete „ahmet: „Täter“ auf Karte oder Umschlag“. Danach habe ich den Originaltext zurückgesetzt und geprüft.
  - Testhilfe druck_hilfe.dart unverändert genutzt (`pdfPruefen` für Seiten und A4). Für Wortgleichheit habe ich eine eigene Rohtext-Hilfe in meiner Testdatei, weil `pdftotext -layout` die beiden Kartenspalten vermischt.
- ANALYSE: `No issues found!` (für lib/src/party/druck und test)
- TEXTE: `Texte: OK (1545 Texte)`. texte_test und textpruefer_test: `All tests passed!` (34 Tests).
- CLI: `--pfad can --n 4` und `--pfad fatma --n 20` beide mit Exit 0, alle acht Dateien erzeugt. Ausgabe lag im Scratchpad, nicht im Repo.
- SICHTPROBE (PNG, 50 dpi):
  - Indizkarten: Seiten 1, 4 und 5 (dichte Karten HP4, HU7, KK7; unbesetzte Person KM3).
  - Umschlag: Seite 1 (DR4).
  - Auflösung: Deckblatt, Seite 2 (Wer es war, Punkte), Seite 3 (Endentabelle), Seite 4 (Abschnitt 1 mit Rückblende), Seite 8 (Auflösung für alle), Seite 10 (Codeliste).
  - Gesehen: Außenseiten zeigen nur Code und kleinen Hinweis. Ankreuzhilfen stehen unten. Titel in Special Elite brechen sauber um. Umschlag-Innenseite ist gut lesbar.
  - Nach der Sichtprobe korrigiert: Karten-Schrift ab 14 pt statt 12, Kopf- und Fußzeile des Auflösungsheftes auf 9 pt.

## OFFENE FRAGEN
1. `satz_stil.dart` (gemeinsame Datei, unverändert): `kopf()` setzt die Marke auf 8,5 pt, `fuss()` auf 8 pt. Die Regel verlangt mindestens 9 pt. Das Auflösungsheft nutzt eigene Kopf- und Fußzeilen mit 9 pt. Ob die Stildatei geändert wird, entscheidet der Orchestrator.
2. Codeliste: Ich zeige die Bedeutung aus den Satzdaten, z. B. „Indizkarte, Runde 1, Entscheidung 1: Joanna befragen“, statt des Rohwerts aus `codes` („Indizkarte e1_1 · e1_1_joanna“). Der Rohwert enthält interne IDs. Codes und Sortierung entsprechen dem Auftrag. Bitte bestätigen.
3. Faktart „nebendelikt“ heißt „Heimlichtuerei“, wie in der Regel R-ENTLASTET. Die übrigen Faktarten: Alibi, Späte Ankunft, Zusatzindiz, Fundort, Schlüsselbeweis. Abgleich mit dem Detektivbogen (BAUMEISTER-01) nötig.
4. Ein früher Lauf von `dart analyze` meldete einmal 1 Befund. Die Quelle habe ich nicht festgestellt. Zur selben Zeit wurde rollen.dart von BAUMEISTER-02 geändert. Alle späteren Läufe, auch der Abschluss, sind sauber.
5. Die Kürzung der Frage auf 60 Zeichen ist umgesetzt, greift aber im Ist-Stand nicht, weil alle Fragen höchstens 50 Zeichen haben.

=== ENDE F5-BAUMEISTER-03 · BEREIT ZUR RÜCKGABE ===

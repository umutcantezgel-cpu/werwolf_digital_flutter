ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (ORCH: Zählhinweis Wertseite ergänzt; Faktarten aus einer Quelle; Kopf und Fuß auf 9 pt)

# Bericht F5-BAUMEISTER-01

## Ergebnis F5-BAUMEISTER-01
- DATEIEN:
  - /home/user/werwolf_digital_flutter/packages/mordakte_core/lib/src/party/druck/spielleitung.dart: 512 Zeilen (vorher Stub mit 16)
  - /home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/ui-druck-spielleitung.json: 84 Zeilen
  - /home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/druck_spielleitung_test.dart: 206 Zeilen (neu)
- UMGESETZT:
  1. Deckblatt mit Falltitel, Titel „Spielleitungsheft – ohne Lösung“, Fall-Code, Personenzahl und Hinweis zum Auflösungsheft → `spielleitungsheft()`, `_deckblatt()`.
  2. Vorbereitung als Tabelle 00, 01, 10, 11, 12, 20, 21, 90 → `_vorbereitung()`.
  3. Ablauf → `_ablauf()`, `_runde()`, `_anklage()`. Intro mit Marke „Vorlesen“. Je Runde eine Seite mit Rundenstart, Uhr (Minuten aus `fall.json`, also 30), drei Entscheidungen, Gruppenwahl mit Auszähltabelle („Ab Summe X | Umschlag CODE“) und dem Hinweis „unter 0 zählen als 0“, Umschlag, Zwischenresümee (Gruppe, Restmenge, Lage in drei Stufen). Die Anklage hat eine eigene Seite mit Auflösungsschritt und Punktezählung.
  4. Anhang mit allen Restmengen aus `resuemeeRest`, Namen und Vorlesetext → `_anhang()`.
  5. Detektivbogen → `detektivbogen()`, `_entscheidung()`. Kopf, Regeln aus `detektiv.regeln.*`, je Runde drei Entscheidungen mit Kästchen, Optionstext, „Karte CODE“ rechts und „Gewählt: Karte“-Zeile. Runden 2 und 3 beginnen auf neuer Seite.
  6. Ermittlungsbogen → `_ermittlungsbogen()`. Tabelle Faktarten × Kernpersonen mit Kästchen. Spalte „Lage“ (Schlüsselbeweis klar, belastende Art Spur). Regeltexte wortgleich aus `regelText`, dazu die Lage-Regel.
  7. Angeklagt-Zeile und Punktefeld „Punkte ___ von 9“ → `_anklageBogen()`.
  - Kein Text im Code, nur Bausteine, `k.text` und Satzdaten. Keine Karten oder Umschläge in meinen Teilen, daher kein `passendeGroesse`. Nicht geändert: satz.dart, modell.dart, satz_stil.dart, druck_hilfe.dart.
- UI-BAUSTEINE: 77 Einträge, davon 53 mit Präfix `ui.druck.spielleitung.*` und 24 mit `ui.druck.bogen.*`.
- TESTS: 10 Tests. Letzte Zeile: `00:01 +10: All tests passed!`
  - Rot-Probe: Den letzten Intro-Absatz habe ich vorübergehend weggelassen. Der Test „Heft nennt jeden Intro-Baustein …“ wurde rot (`+9 -1`). Danach habe ich die Datei aus der Sicherung wiederhergestellt (cmp identisch), der Lauf ist wieder grün.
- ANALYSE: `dart analyze lib/src/party/druck/spielleitung.dart test/party/druck_spielleitung_test.dart` ergibt `No issues found!`. Die Analyse von `lib/src/party/druck` allein ist ebenfalls sauber. Die Analyse von `lib/src/party/druck test` meldet einen Befund in einer fremden Datei (siehe Offene Fragen).
- TEXTE: `Texte: OK (1545 Texte)`. `dart test test/party/texte_test.dart test/party/textpruefer_test.dart`: `All tests passed!` (34).
  - CLI `--pfad can --n 4` und `--pfad fatma --n 20` laufen ohne Fehler. Beide Teile sind A4, Heft 7 Seiten, Bogen 4 Seiten.
- SICHTPROBE (PNG bei 60 dpi, im Sitzungs-Scratchpad statt /tmp):
  - /tmp/claude-0/-home-user-werwolf-digital-flutter/7caf0337-a711-594a-ac19-e1cc0ae35826/scratchpad/probe12/sl-2.png: Vorbereitung und Ablaufbeginn. Gut lesbar, Vorlesen-Marken am Rand.
  - .../scratchpad/probe12/sl-4.png: Runde 2. Auszähl- und Lage-Tabelle lesbar.
  - .../scratchpad/probe12/bo-1.png: Detektivbogen Seite 1. Kästchen, Codes rechts, Gewählt-Zeile klar.
  - .../scratchpad/probe12/bo-4.png: Ermittlungsbogen mit Lage-Spalte, Anklage und Punktefeld.
  - .../scratchpad/can4/anhang-7.png: Anhang für 4 Personen. Alle 15 Zeilen auf einer Seite.
  - Behoben: Überschriften standen am Seitenende ohne Text (RUNDENSTART, ENTSCHEIDUNGEN), und Entscheidung 3 war über zwei Seiten geteilt. Deshalb jetzt je Runde eine Seite.

## OFFENE FRAGEN
- Schrift unter 9 pt in satz_stil.dart (nicht meine Datei, nicht geändert): `stil.kopf` setzt die Marke auf 8,5 pt, `stil.fuss` auf 8 pt. Meine Teile haben eigene Kopf- und Fußzeilen mit 9 pt. ORCH sollte satz_stil.dart anpassen.
- `dart analyze lib/src/party/druck test` meldet einen Befund außerhalb meiner Dateien: test/party/druck_rollen_test.dart:7:8 (ungenutzter Import, Baumeister 02). Ich habe ihn nicht angefasst.
- story_text_ausserhalb_test.dart (F-11) ist rot wegen Fundstellen in druck/probe.dart (10), satz.dart (8), modell.dart (3), karten.dart (2), rollen.dart (2), satz_stil.dart (1) und lib/party/daten.dart (1). Meine spielleitung.dart hat keine Treffer.
- Die Rundendauer im Druck ist fest 30 Minuten aus fall.json, die App lässt andere Dauern zu. Soll der Satz die Dauer als Parameter bekommen? Entscheidung bei ORCH.

=== ENDE F5-BAUMEISTER-01 · BEREIT ZUR RÜCKGABE ===

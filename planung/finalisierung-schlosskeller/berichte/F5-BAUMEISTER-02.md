ABNAHME · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 1 · Grenzen 2 · Summe 9/10 (Inhalt: Täterziel im Kernheft – von ORCH in die Fassung verlegt, Test ergänzt; Stimmkarten mit Namen bestätigt, Zählung über die Wertseite)

# Bericht F5-BAUMEISTER-02

## Ergebnis F5-BAUMEISTER-02
- DATEIEN:
  - `/home/user/werwolf_digital_flutter/packages/mordakte_core/lib/src/party/druck/rollen.dart`: 399 Zeilen
  - `/home/user/werwolf_digital_flutter/content/party/schlosskeller/texte/ui-druck-rollen.json`: 123 Zeilen
  - `/home/user/werwolf_digital_flutter/packages/mordakte_core/test/party/druck_rollen_test.dart`: 197 Zeilen
- UMGESETZT:
  - 1 Rollenhefte, `rollen.dart` (`rollenhefte`, `_deckblatt`, `_heft`): Deckblatt mit Farbbalken, dann Heft mit Wer ich bin, Ziel, Pflichtgesprächen und Besetzung. Nicht-Kernrollen zusätzlich Was ich weiß, Was ich verberge und Rundenwahl. Kernrollen nur der Umschlag-Hinweis mit Code.
  - 2 Fassungen (`fassungen`, `_fassung`, `_innen`, `_tafel`): Außenseite mit Code, Innenseiten, Täterfassung mit Tafel zuerst, Sabotage statt B. Kürzere Fassungen bekommen Notizseiten; die Länge wird je Probe-Dokument gezählt.
  - 3 Stimmkarten (`stimmkarten`, `_karte`, `_vorderseite`, `_kartenSchrift`): 90 × 60 mm, acht je Blatt mit Schnitt, gefaltete Rückseite mit Wert, Reihenfolge Runde, Besetzung, A vor B. Eine Schriftgröße für alle, gemessen über die ganze Vorderseite.
  - 4 Bausteine: `ui-druck-rollen.json`, 29 Einträge.
  - 5 Tests: `druck_rollen_test.dart`, 11 Tests.
  - 6 Testweg und Sichtprobe, siehe unten. Abweichungen: Kartentext mit Zeilenabstand 0,5 statt 2, weil sonst 184 Zeichen bei 9 pt nicht passen. Blöcke werden über `pw.NewPage` zusammengehalten.
- UI-BAUSTEINE: 29. Präfixe `ui.druck.rollen.*` (18), `ui.druck.fassung.*` (7), `ui.druck.stimme.*` (4). Schlüssel im Code und in der Datei sind deckungsgleich.
- TESTS: 11. Letzte Zeile: `00:12 +11: All tests passed!`
  - Rot-Probe: Die Auffüllung der Notizseiten in `fassungen` wurde kurz entfernt. Der Test „Fassungen: vier Kernrollen …“ wurde rot (`Expected: <0>`, `Actual: <1>`). Die Zeile ist zurückgenommen, die Datei ist identisch.
- ANALYSE: `No issues found!`
- TEXTE: `Texte: OK (1545 Texte)`. `texte_test` und `textpruefer_test` zusammen: `All tests passed!`
- CLI: `--pfad can --n 4` und `--pfad fatma --n 20` beide mit Exit 0. Ausgaben liegen im Scratchpad, nichts im Repo. Der erste Lauf brach in `karten.dart` (F5-BAUMEISTER-03) ab. Beim zweiten Lauf lief er durch.
- SICHTPROBE (PNG):
  - Deckblatt (Ahmet): ruhig, Name groß, Farbbalken und Hinweis klar.
  - Rollenseiten (Ahmet, Lejla): Labels klein und grau, Werte 11 pt, Gesprächsblöcke bleiben zusammen, das Geburtstagskind erscheint als Partner.
  - Fassung der Täterin (Fatma, zwei Innenseiten): Fund: Die Tafel hatte keinen Abstand zur nächsten Überschrift, und „Runde 1“ stand allein am Seitenende. Behoben.
  - Stimmkarten (Blatt 1): Schnitt und Faltlinie klar, das Minus-Zeichen wird richtig gesetzt. Fund: Der 184-Zeichen-Text passte nicht. Kopfzeile kompakter, Zeilenabstand angepasst. Danach passt alles.

## OFFENE FRAGEN
1. Spoiler im Heft der Täterin: Unter „Mein Ziel heute Nacht“ steht das Täterziel („… Du willst unentdeckt bleiben …“). Grund: `k.satz.rollenhefte` liefert im Täterpfad das Täter-Dossier. So gedruckt, wie die Vorgabe es verlangt. Entscheidung nötig: so lassen (ENTSCHEIDUNGSLOG: Täterfassung „im eigenen Rollenheft“), oder im Heft das unschuldige Ziel zeigen und das Täterziel nur im Umschlag.
2. Stimmkarten (E-031): Die Vorderseite nennt die Figur, wie vorgegeben. Beim verdeckten Zählen bleibt der Name verborgen. Wer die −1-Karte umdreht, sieht den Absender der Sabotage. Bitte bestätigen oder ändern.

=== ENDE F5-BAUMEISTER-02 · BEREIT ZUR RÜCKGABE ===

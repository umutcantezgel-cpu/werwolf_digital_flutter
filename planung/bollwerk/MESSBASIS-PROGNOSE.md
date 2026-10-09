# MESSBASIS-PROGNOSE · Meta-Lauf BOLLWERK (M1)

**Dies ist nie die Basis.** Die verbindliche Basis zählt der Nachtlauf in BW0 an K (B-02-Commit) mit `tool/bollwerk/umfang.dart` und friert sie in `planung/bollwerk/messbasis/UMFANG-BASIS.md` ein.

## 1. Messskript und Wiederholbarkeit

- Skript: `planung/bollwerk/proben/umfang_probe.sh` (sha256 `81502cafd32526c5fefe9923171b20390e5390b4d9b9d6287779ecd85bf30237`).
- Aufruf: `bash planung/bollwerk/proben/umfang_probe.sh <baum> <env.sh>`.
- Zwei Durchläufe am Baum 5c8324298bd774f2c07e91ff2fb98bd1f909e3c7: `diff umfang1.txt umfang2.txt` → leer („ZWEIMAL-GLEICH“).
- Gegenzählung durch einen Haiku-Messer (M1-MESS-01, `bestand/faktenpruefung/M1-MESS-01.md`): 20 Einheiten (9 Entscheidungen, 8 Orte, 3 Lacher) mit Datei:Zeile; Zählung „Entscheidungen 9, Orte 43, Lacher 3“ = Skript. **Übereinstimmung 20/20.**

## 2. Werte heute und Hochrechnung bis K

| Achse | Zählbefehl (Kurzform) | heute (fin 5c83242) | Hochrechnung K (Spanne) | Grund der Spanne |
|---|---|---|---|---|
| X1 Entscheidungen inkl. Folge/Abstecher | `jq '.entscheidungen\|length' entscheidungen.json` (+ Schicht) | 9 | 9 | kanonfest bis B-02 |
| X2 Spieltexte | `dart run bin/party_texte.dart` → „Geprüfte Texte: N“ | 1.581 | 1.581–1.900 | F5–F7 schreiben noch Druck-/Anleitungstexte |
| X3 Orte in den 7 Räumen | `jq '.orte\|length' raeume.json` | 43 | 43–45 | Kanon steht seit F1 |
| X4 Gags und Nebenhandlungen | `jq '.lacher\|length' setting.json` | 3 | 3–5 | Code-Gags (Rüstung, Kamin) zählen erst als Schicht-Einheit |
| X5 Weißlisten-Zusatzfunde | kein Mechanismus am Stand fin | 0 | 0 | entsteht erst mit dem Würfel |
| X6 sichtbare Aktionsarten mit Animation | `grep -c "math.sin(walk) \* moveAmt" figure_painter.dart` | 1 (gehen) | 1–2 | F4-Restarbeiten |

## 3. Achsenprüfung (Basis-Hochrechnung und natürlicher Deckel)

| Achse | Basis K | natürlicher Deckel | Deckel ÷ Basis | Regel | Entscheidung (ENTSCHEIDUNGSLOG E-M1-01) |
|---|---|---|---|---|---|
| X1 | 9 | 150–400 (Folgeentscheidungen und Abstecher je Raum × Runde, begrenzt durch Abend-Invariante je Partie, nicht je Pool) | 17–44 | ok | Indexachse, g = 3 |
| X2 | 1.581–1.900 | 8.000–20.000 (Texte, die F2/F3 bestehen und an genau einer Stelle verdrahtet sind) | 4–12 | ok | Indexachse, g = 2 |
| X3 | 43–45 | 150–200 (Teilorte innerhalb der 7 Räume, keine neuen Bereiche) | 3,3–4,7 | knapp ≥ 3 | Indexachse, g = 1; Ziel 4× ist realistisch, 3× ist Pflicht |
| X4 | 3–5 (< 5) | 300–600 | – | Basis < 5 | **Mindestbasis 10** (f = Wert ÷ 10), g = 1 |
| X5 | 0 | 14–30 (Weißliste C4 ist kanongebunden und endlich) | < 3 bei Mindestbasis 10 | Deckel < 3× | **aus dem Index genommen → Pflichtziel** „Weißliste ausgeschöpft: ≥ 14 pfadgleiche Zusatzfunde verdrahtet“ |
| X6 | 1–2 (< 5) | 40–60 (je Aktionsart Pose + Animation + Klang) | – | Basis < 5 | **Mindestbasis 5** (f = Wert ÷ 5), g = 2 |

Gewichte: A-09 (3, 2, 1, 1, 1, 2) geprüft und bestätigt; mit X5 als Pflichtziel gelten g = (X1 3, X2 2, X3 1, X4 1, X6 2), Σ g = 9. Begründung: sichtbare Entscheidungen und Aktionen tragen den Nutzerwunsch („rundenbasierte Folgen von Entscheidungen … Aktionen“), Texte folgen, Orte und Gags ergänzen.

## 4. Was U ≥ 10 bedeutet (Rechnung, U = exp(Σ g·ln f ÷ Σ g))

| Szenario | f (X1, X2, X3, X4, X6) | U | größter Anteil an ln U |
|---|---|---|---|
| Planziel F (M4) | 15, 6, 4, 30, 9 | **10,19** | X1 38,9 % (< 40 %) |
| konservativ | 12, 5, 3,5, 25, 8 | 8,54 | X1 38,6 % |
| je Achse nur 3× | 3, 3, 3, 3, 3 | 3,0 | – |
| Streckziel | 40, 10, 5, 60, 12 | 18,7 | X1 42 % (> 40 %, gekappt) |

In absoluten Einheiten (Planziel): X1 = 135 Entscheidungen (9 → 135), X2 ≈ 9.500–11.400 Texte, X3 ≈ 172–180 Orte, X4 = 300 Gags, X6 = 45 Aktionsarten. Volumenfaktor ≈ 6 (von Texten dominiert).

**Folge:** U ≥ 10 ist nur mit allen fünf Achsen nahe am Deckel erreichbar; X3 (Orte) und X6 (Aktionsarten, Code mit Posen) sind die Engpässe. Das geht als Risiko in die Prognose und als Zwischenziel je Nacht in den Plan (M4).

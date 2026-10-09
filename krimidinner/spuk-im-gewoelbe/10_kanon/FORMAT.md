# Kanon-Format · verbindlich für K1–K7

Der Kanon besteht aus Datensätzen, je Datensatz genau eine Zeile:

    @KENNUNG [S] | Feld: Wert | Feld: Wert | …

- `@` steht am Zeilenanfang. Zeilen ohne `@` sind Überschriften oder Erläuterungen und gelten nicht als Kanon-Tatsache.
- `KENNUNG` ist im gesamten Kanon eindeutig.
- `S` ist die Sichtklasse des ganzen Datensatzes:
  - `O` öffentlich: dürfen alle Spieler, der Detektiv und der Erzähler kennen.
  - `G` Rollengeheimnis: nur die im Datensatz genannte(n) Rolle(n) und Lösungspakete.
  - `L` Lösung: nur Lösungspakete (Täterrolle, Auflösung, Enden, Spielleitung, Zeit- und Absicherungsprüfungen, Probeläufe).
- Felder werden mit ` | ` getrennt. Innerhalb eines Werts sind `|` und Zeilenumbrüche verboten.
- Feldnamen sind fest (siehe unten). Reihenfolge der Felder wie unten.
- Uhrzeiten im Kanon als `HH:MM` (24 h). In Spieltexten werden sie später in Worten geschrieben.
- Rollen heißen im Kanon immer `R01` … `R20`, der Detektiv `DET`, der Burgwart `BW`, die Spielleitung `SL`.
- Wörtliche Rede steht in „…“ und wird in Paketen wortgleich übernommen (Kernsatz).

## K1 Grundwahrheit (`10_kanon/K1-GRUNDWAHRHEIT.md`)
- `@K-001 [L] | Tatsache: …` – Einzeltatsache. Öffentliche Rahmentatsachen (was alle wissen) mit `[O]`.
- `@Z-2347a [L] | Zeit: 23:47 | Wer: R03 | Ort: <Ort aus LISTE-ORTE> | Was: …` – Zeitleiste. Mehrere Einträge zur selben Minute erhalten Suffix a, b, c. Vor 23:30 dürfen Zeiten grob sein (`Zeit: ca. 21:15`).
- `@PF-1 [L] | Frage: … | Antwort: …` – Pflichtfragen 1–7.
- `@BS-01 [L] | Beweisstück: … | Wahrheit: … | Scheinbare Deutung: … | Wirkt belastend für: …` und `@BSO-01 [O] | Beweisstück: … | Fundort: … | Phase: … | Aussehen: …` (öffentliche Beschreibung).
- `@LISTE-ORTE [O] | Orte: …` · `@LISTE-GEGENSTÄNDE [O] | Gegenstände: …` · `@LISTE-ZEITEN [O] | Öffentlich bekannte Zeitpunkte: …` – geschlossene Listen. Was nicht in einer Liste steht, darf in Spieltexten nicht als Ort, lösungsrelevanter Gegenstand oder Zeitpunkt auftauchen.

## K2 Rollenregister (`10_kanon/K2-ROLLEN.md`)
Je Rolle sieben Datensätze (hier R07):
- `@R07-STAMM [O] | Name: … | Aussprache: … | Geschlecht: w/m | Alter: … | Wurzeln: … | Familie: … | Beruf: … | Beziehung zum Geburtstagskind: … | Kleidung: … | Sprechweise: 1) … 2) … 3) …`
- `@R07-ÖFFENTLICH [O] | Beziehung zum Burgwart (bekannt): … | Behauptetes Alibi: … | Comedy-Beteiligung (sichtbar): …`
- `@R07-GEHEIM [G] | Geheimnis: … | Motiv: … | Wahres Alibi: … | Beziehung zum Burgwart (wahr): …`
- `@R07-WISSEN [G] | Wissen: HH:MM … ; HH:MM … ; …` – nur was die Rolle selbst gesehen, gehört oder getan hat, mit Uhrzeit.
- `@R07-VERBINDUNGEN [G] | Verbindungen: R03 (…) ; R11 (…) ; …`
- `@R07-PLOT [L] | Funktion: … | Motiv-Einstufung: echt/scheinbar | Block: … | Anker je Phase: P1 R0x, P2 R0x, P3 R0x`
- `@R07-LÜGE [G] | Darf lügen über: … | Muss wahr sagen über: …` (nach K7)
Zusätzlich `@DET-… ` (Detektiv, alles [O] oder [G] für das Geburtstagskind) und `@BW-…` (Burgwart: STAMM [O], ZUSTAND [O], AUSSAGEN [O] mit Phase, WAHRHEIT [L]).

## K3 Hinweisnetz (`10_kanon/K3-HINWEISE.md`)
- `@H-14 [O] | Inhalt: … | Form: Karte/Beweisstück/mündlich/Erzähler | Quelle: Station …/Beweisstück BS-0x/Gespräch G2-07/Erzähler | Phase: 1 | Min: 4`
  - `Inhalt` ist genau das, was der Finder erfährt. Sichtklasse `O`, weil es in Spieltexten stehen darf, sobald gefunden. Ein Hinweis, der nur einer Rolle bekannt ist, bekommt `[G]` und `Rolle: R0x`.
- `@HW-14 [L] | Wahrheit: … | Stützt: S3 | Einstufung: echt/falsche Fährte/entlastend | Blockierbar durch: E1-02 Option 2 / nein | Unabhängig von: …`
  - Einstufung nach Wirkung auf den Detektiv: „echt“ führt zur Lösung; „falsche Fährte“ lässt eine unschuldige Person schuldig wirken (z. B. Jonas’ Geldnot, Strang a); „entlastend“ gibt einer unschuldigen Person Zeit, Ort oder Erklärung (z. B. Jonas’ Telefonat an der Zinne); „Farbe“ trägt nur Nebenhandlung. Ein Zusatz in Klammern ist erlaubt.
- `@S-1 [L] | Schlussfolgerung: … | Notwendig: ja/nein | Hinweise: H-03, H-14, …`

## K4 Gesprächsgraph (`10_kanon/K4-GESPRAECHE.md`)
- `@G2-07 [G] | Von: R07 | Ziel: R11 | Ersatz: R03 | Min: 11 | Bedingung: … | Frage: „…“ | Antwort: „…“ | Antwortart: wahr/gelogen/ausweichend | Gibt heraus: H-22 / nichts | Ersatz-Bedingung: … / – | Ersatz-Frage: „…“ / – | Ersatz-Antwort: „…“ / – | Ersatz-Antwortart: wahr/gelogen/ausweichend / – | Ersatz gibt heraus: H-31 / nichts / – | Zusammenfall: G2-03 / nein`
  - `Min` = Mindestbesetzung, ab der das reguläre Ziel anwesend ist (= höhere der beiden Rollennummern).
  - `Ersatz` nur, wenn das Ziel außerhalb 1–4 liegt und eine höhere Nummer hat als `Von`; sonst `Ersatz: –`. Bei Ersatz gilt der Kern mit Ersatzziel, solange N < Min.
  - `Bedingung` ist am Tisch überprüfbar (Karte zeigen, bestimmte Frage stellen, Codewort nennen).
  - `Ersatz-Bedingung`, `Ersatz-Frage`, `Ersatz-Antwort`, `Ersatz-Antwortart` und `Ersatz gibt heraus` beschreiben den Ersatzfall: was der Auftraggeber das Ersatzziel fragt und was dieses antwortet (Besetzungsbedingung: nur wenn das reguläre Ziel nicht besetzt ist). Das Ersatzziel gibt nur heraus, was es selbst wissen kann.
  - `Antwortart` sieht nur das Ziel (und Lösungspakete); der Auftraggeber bekommt Frage, Bedingung und was er erfährt.
- `@LAST-P2 [L] | …` – Lastprobe (wird vom Werkzeug geprüft).

## K5 Entscheidungsbaum (`10_kanon/K5-ENTSCHEIDUNGEN.md`)
- `@D1-1 [O] | Phase: 1 | Frage: … | Option A: … | Option B: … | Option C: … | Begründbar durch: H-…`
- `@DW1-1 [L] | Echte Spur: B | Falsche Fährte: A | Ablenkung: C | Punkte: B=1, A=0, C=0 | Ergebnis A: … | Ergebnis B: … | Ergebnis C: …` (Ergebnis = Inhaltskern des Ergebnistexts, 1–2 Sätze)
- `@E1-07 [G] | Rolle: R07 | Lage: … | Option 1: … → Folge: … | Option 2: … → Folge: … | Option 3: … → Folge: … | Umsetzung: Kartenaktion/Ansage`
  - Folge ist eindeutig und ausführbar. Eine Folge verschiebt Hinweise oder verändert Wege, löscht aber nie den letzten Weg zu einer notwendigen Schlussfolgerung.
  - Ansagen zu Rollen 1–4 sind anonym („Jemand am Tisch …“).

## K6 Auflösungslogik (`10_kanon/K6-AUFLOESUNG.md`)
- `@AB-0-3 [L] | Punkte: 0–3 | Verdächtigenkreis: … | Entlastet: … | Erzähler nennt: …` (ebenso 4–6, 7–8, 9)
- `@AK-… [L]` Anklageablauf, `@EM-… [L]` Endmatrix.

## K7 Lügenregel (`10_kanon/K7-LUEGENREGEL.md`)
- `@LR-1 [O] | Regel: …` – für alle Rollen gleich formuliert.

## K8 Stilblatt und K9 Look-Bibel
Fließtext mit festen Abschnitten (`10_kanon/K8-STILBLATT.md`, `10_kanon/K9-LOOKBIBEL.md`). Glossar-Einträge als `@GL-xx [O] | Begriff: … | Schreibweise: … | Aussprache: …`.

## Kennungsbereiche für Hinweise aus Gesprächen
- Phase 1: Kernrollen-Gespräche H-101 bis H-119, Erweiterungsrollen H-121 bis H-199
- Phase 2: H-201 bis H-219 und H-221 bis H-299
- Phase 3: H-301 bis H-319 und H-321 bis H-399
Jeder Hinweis hat einen Wahrheitsdatensatz HW mit derselben Nummer.

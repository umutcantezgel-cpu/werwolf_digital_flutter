# A-8 · Umfang, Füllstoff, Design und Bildverfahren

Teil 1 sind die Festlegungen des Meta-Laufs (gehen vor). Teil 2 ist der Pflichtinhalt MP-7 und MP-8 aus Anhang A.

## Teil 1 · Festlegungen des Meta-Laufs

### 1.1 Indexachsen, Gewichte, Mindestbasen (E-M1-01)
| Achse | Gewicht g | Basis | f |
|---|---|---|---|
| X1 Entscheidungen inkl. nichtwertender Folgeentscheidungen und Abstecher | 3 | Zählung an K | Wert ÷ Basis |
| X2 Spieltexte und Bausteine (≥ 8 Wörter) | 2 | Zählung an K (`party_texte.dart`, Prognose 1.581–1.900) | Wert ÷ Basis |
| X3 begehbare Ziele und Orte innerhalb der 7 Räume | 1 | Zählung an K (Prognose 43) | Wert ÷ Basis |
| X4 Gags und Nebenhandlungen | 1 | **Mindestbasis 10** (Kanon hat 3 Lacher) | Wert ÷ max(10, Basis) |
| X6 sichtbare Aktionsarten mit Animation | 2 | **Mindestbasis 5** (Bestand 1: gehen) | Wert ÷ max(5, Basis) |
| X5 Weißlisten-Zusatzfunde | – | **kein Index, Pflichtziel ≥ 14** pfadgleiche Zusatzfunde verdrahtet | – |

U = exp(Σ g·ln f ÷ Σ g), Σ g = 9, f gedeckelt bei 100; jede Indexachse ≥ 3×; keine Achse > 40 % von ln U. Planziel F = 10 mit f = (15, 6, 4, 40, 9) → U = 10,52 (Marge 5 %, X1-Anteil 38,4 %); X4 = 400 Gags (Mindestbasis 10). Zwischenziele rechnet BW0 als f_Ziel × eingefrorene Basis an K − Basis, plus 5 % Reserve; N0 zählt bei allen Achsen mit.

### 1.2 Füllstoff und Gremium (aus der Fabrikprobe)
- Ringe 1–6 als Skript (Vorlage `planung/bollwerk/proben/fabrik_ringe.py`): Form, Regeln (`content/party/textregeln.json`, Sperrliste, Gewalt, Bildregeln, Satzlänge, Siezen, Pfeife nur mit Seifenblasen), Kanon (Kennungen, Ort↔Raum, Weißliste, keine Tatzeit-Uhrzeiten, **keine neuen Spuren/Kratzer/Abdrücke an Kanon-Orten**), Erreichbarkeit, Neuheit (Wort-3-Gramm-Jaccard < 0,5, Tupel eindeutig).
- Ring 7: drei Haiku-Richter blind mit den Linsen Kanon, Ton, Spaß und der Pflichtfrage Wirkung (ja/nein mit Nennung des geänderten Folgefelds aus A-3; nein = Ablehnung), Skala 0–10; angenommen bei ≥ 2 Stimmen ≥ 7; Spreizung > 2 → zwei weitere Richter (Gesamt), Median aus 5 zählt. Aktionsarten (X6) bekommen eine eigene Rubrik: Lesbarkeit der Pose in 2–4 Schlüsselbildern, Stiltreue, Wiederverwendbarkeit.
- F5-Eichung: In jeden Richter-Stapel kommen 20 Füllstücke (Vorlage im Meta-Lauf: 20/20 abgelehnt); lehnt das Gremium weniger als 18 ab, ist die Welle ungültig.
- Briefing-Pflichten, die die Annahme von 18 % auf 58 % hoben: jede Variante mit spürbarer Folge (auch ohne Wurf), je Option eine andere Folge, ein Bild-, Witz- oder Gruselmoment, konkrete Stufentexte, Abschnitt „Zugschicht“ im Kern-Auszug.

### 1.3 Bildverfahren (erprobt in M1)
- Web-Build eines festen SHA im Wegwerf-Worktree: `rm -rf .dart_tool/flutter_build && flutter build web --release --no-web-resources-cdn -o build/web` (92 s).
- Fotos: `node $BW/tool/bollwerk/foto.mjs <worktree> <aus> [räume] [zusatz]` (Vorlage `planung/bollwerk/proben/foto_probe.mjs`): Partymodus `?party=schlosskeller&pfad=…&n=…&bis=entscheidungen&at=<x,y>&zoom=1.05`, feste Uhr über `page.clock.install` und `runFor`, Ansichten 393×852, 852×393, 1180×820 bei Pixeldichte 2; Bewegungsstreifen mit `STREIFEN=8` (8 Bilder je 0,25 s). ≈ 68 s je Bild.
- Gleichheit: dieselbe SHA zweimal fotografiert ergibt ΔE-Mittel ≤ 1,0 je Bild (`bildgleich.py`; gemessen 0,005–0,10). Bytegleich nur über den Golden-Weg L6.
- Kontaktbögen: `kontaktbogen.py` (JPEG ≤ 2.400 px, ≤ 1,5 MB), Zeile in `planung/bollwerk/bilder/INDEX.md`.
- **Befund Queransicht:** Im Querformat verdeckt die Entscheidungskarte etwa die halbe Szene samt Detektiv; Aufwertungen am Detektiv sind dort unsichtbar. Die Karte im Querformat ist eine eigene Design-Aufgabe (Lichtungsaufgabe L-D1).

### 1.4 Eichungen (Stand Meta-Lauf)
- D3a (Paar-Eichung): 18 Kontrollpaare (Original gegen unscharf, flau, blass, Rauschen, Blöcke, dunkel) + 6 Gleichpaare; 3 Haiku-Richter, Mehrheit 18/18 richtig, 0/6 Fehlalarm. Die Kontrollpaare waren grob; der Nachtlauf ergänzt in BW0 feine Kontrollpaare (halbe Stärke) und muss weiterhin ≥ 15/18 und ≤ 1/6 erreichen.
- D3b: 12 Stilbruch-Bilder (pixel3d, fremdfarbe, lichtrichtung, isowinkel, abgeschnitten, textueberlauf je 2) + 6 einwandfreie + 6 überladene; Mehrheit 18/18 erkannt (Typ 16/18), 0/6 Fehlalarm.
- Erzeuger: `planung/bollwerk/proben/eichsatz.py <lauf1> <lauf2> <aus> <seed>`; die Lösung bleibt bis nach dem Gremium außerhalb des Stapels.

### 1.5 Designmaße, Basiswerte der Probe (ohne Masken)
Buffetsaal/Kaminsaal/Ostsaal am Stand fin@5c83242: Luminanz L* 6,4–10,2; Vignette (Rand − Mitte) −1,8 bis −9,3; Palettenanteil (ΔE76 ≤ 10) 95,2–97,6 %; Iso-Kantenanteil 30–37 % (ohne Masken; S3 misst nur neue Kanten); Dunkelanteil (L* < 5) 40–63 %. Werkzeug `designmass.py`. Die verbindliche Basis entsteht in BW0 an K mit Masken.

## Teil 2 · Pflichtinhalt aus Anhang A
### MP-7 · UMFANG 10–100×
**Kanonfeste Achsen** (Faktor 1, nicht im Index): Täterpfade 4, wertende Entscheidungen 9, Runden 3, Fakten 30, Enden 4, Räume 7 mit 8 Türen.

**Indexachsen** (Zählbefehl je Achse in `UMFANG-BASIS.md`):
- X1 Entscheidungen samt nichtwertender Folgeentscheidungen und Abstecher (Basis 9)
- X2 Spieltexte und Bausteine (1.217)
- X3 begehbare Ziele und Orte innerhalb der 7 Räume (43)
- X4 Gags und Nebenhandlungen (3)
- X5 Weißlisten-Zusatzfunde (Zahl am B-02-Commit)
- X6 sichtbare Aktionsarten mit Animation (Zahl am B-02-Commit; F4 bringt schon einige)

**Formel**
- f_i = Wert nach Füllstoffprüfung ÷ Basis am B-02-Commit, gedeckelt bei 100.
- U = exp(Σ g_i · ln f_i / Σ g_i).
- Die Gewichte legt der Meta-Lauf in M1 fest, mit Begründung (festgelegt g = 3, 2, 1, 1, 2 für X1, X2, X3, X4, X6, X5 Pflichtziel: sichtbare Aktionen hoch, Weißlisten-Funde kanongebunden niedrig). Danach ändert sie niemand.
- (Ersetzt durch Teil 1 §1.1: Planziel f = 15, 6, 4, 40, 9 → U = 10,52; X4 = 400 Gags, X6 = 45 Aktionsarten, X5 nur Pflichtziel ≥ 14.)
- **Umfangsplan** (aus M4): welche Kombination f_1 … f_6 U ≥ 10 erfüllt und wie viele Aufträge und Stunden (Vorlauf und Hauptlauf) sie braucht. Vorlauf-Ware in `content/runden/` zählt, sobald sie nach B-02 F1–F5 besteht. Reicht eine Hauptlauf-Nacht nicht, setzt der Master-Prompt je Nacht ein Zwischenziel aus diesem Plan (Annahme A-11). Das BK-Kriterium bleibt U ≥ 10; nichts wird still gesenkt.

**Schwellen**
- U ≥ 10, Streckziel 100.
- Jede Indexachse ≥ 3×.
- Keine Achse trägt mehr als 40 % von ln U.

**Pflichtziele (statt Index)**
- Spielformen 3/3
- Ruhe-Animationen 22/22
- Posen ≥ 24
- Mimik ≥ 4 Ausdrücke je Figur
- Würfeltabelle je Entscheidung mit Wurf
- Leben-Effektarten ≥ 6
- Requisitenarten ≥ 30/34
- je Pflichtentscheidung ≥ 1 Kette

**Nur berichtet:** Partieverläufe (nur inhaltlich unterscheidbare Szenenfolgen) und Tests.

**Werkzeug:** `dart run tool/bollwerk/umfang.dart` → Exit 1 bei U < 10 oder einer Achse < 3×.

**Kanon-Erweiterungsregel**
- Kanon 1.0 bleibt Byte für Byte unverändert (L0.3 gegen K, MP-14).
- Die Schicht liegt in `content/runden/schlosskeller/` mit `schichtVersion` und `basisKanon: "1.0.0"`.
- Ein neues Stück ist nicht lösungsrelevant:
  - in allen 4 Pfaden wortgleich
  - keine Faktquelle, kein Kettenglied
  - kein neues Wissen über 23:50–00:15
  - Restmenge nie geändert
- Gespräche erfüllen P-1 und `party_pruefen`.
- Nebenhandlungen nur für Stufe II–V und nur außerhalb 23:50–00:15.
- Neue Orte nur innerhalb der 7 Räume (C5).
- Ob auch neue Fälle oder Täterpfade dazukommen, ist Annahme A-04 (Standard: nur Schichten).

**Füllstoffprüfung** (`dart run tool/bollwerk/fuellstoff.dart`; ein Stück zählt nur bei F1–F6 grün). Füllstoff = Einheit ohne Wirkung (F3), ohne Erreichbarkeit (F2), Schablonen-Dublette (F4) oder mit Zeitzuwachs (F6).
- F1 Schema und Inhaltsprüfer: 0 Treffer.
- F2 Erreichbarkeit: in ≥ 1 % der Partien ihres Modus aus dem eingefrorenen Seed-Satz (bestes Spiel, zufällig, erste Option); 100 % der Einheiten.
- F3 Wirkung:
  - Optionen unterscheiden sich paarweise in ≥ 1 Protokollfeld.
  - Ein Text ist an genau einer Stelle verdrahtet.
- F4 keine Dublette:
  - Texte: Jaccard der Wort-3-Gramme < 0,5.
  - Entscheidungen und Aktionen: Tupel eindeutig.
  - Posen und Bilder: Silhouetten-IoU < 0,9 nach `bewohner_karten.dart` `vergleiche`.
- F5 Gremium:
  - Eine Einheit zählt nur, wenn Ring 7 sie annimmt (3 Linsen Kanon, Ton, Spaß; ≥ 2 Stimmen ≥ 7/10, bei Spreizung > 2 Median aus 5) und ihr Stapel die Füllstück-Eichung besteht: 20 Füllstücke je Stapel, 10 offensichtliche und 10 subtile (F1–F4 grün, ohne Wirkung oder mit Kanon-Nahbruch), per Seed aus ≥ 60 Vorlagen, von Haiku-Bauern der Welle erzeugt; bestanden bei ≥ 18/20 und ≥ 8/10 subtilen abgelehnt.
- F6 Zeit: Schemafeld `zeit_s` (Gerätezeit, die die Einheit hinzufügt) ≤ 30 s; erhöht eine Einheit im L4-Paarvergleich (mit/ohne, gleicher Seed) die Gerätezeit je Runde, zählt sie nicht.
- Die Ausschussquote steht stündlich im NACHTPROTOKOLL.

**Spieldauer:** C7. Was die Dauer sprengt, zählt nicht für den Umfang.

### MP-8 · DESIGN-AUFWERTUNG
**Look-Vertrag**
- *Stil-Konstanten* (nie ändern):
  - Iso 64/32/40, Kamera und Zoombereich, Zeichenreihenfolge
  - gezeichnete Figuren mit heutigen Proportionen und Strich
  - keine Pixel-3D-Blöcke, Farbfamilie der Palette
- *Qualitätsstufe* (soll aufgewertet werden):
  - Licht und Schatten, Nebel (BE-13)
  - Mimik und Gesten, Detaildichte
  - Bedien-Optik: Karten, Würfelbühne, Übergänge
  - Leben-Schicht
- Erweiterungen nur additiv: eine neue Sitzungsklasse; Abfragen `if (session is …)`, ohne die alles gleich läuft; neue Maler in neuen Dateien; Flutter-Overlays im Noir-Stil; Posen als optionale Parameter.

**D1 Strukturmaße** (`tool/bollwerk/design_mass.dart`, jedes mit Golden)
- Ruhe-Animationen 22/22
- Posen ≥ 24, je Aktionsart ≥ 1
- Mimik ≥ 4 je Figur
- Requisitenarten ≥ 30/34, 0 Umwidmungen, 0 Flaschen
- Leben-Effektarten ≥ 6
- Übergänge ≥ 5
- Würfelbühne und Entscheidungskarten

**D2 Blinder Paarvergleich**
- 42 Paare: 7 Räume × 2 Kanon-Lichtzustände × 3 Ansichten (hoch, quer, Tablet), gleiche Kamera, fester Zeitpunkt (ersetzt die frühere Zahl 28); dazu 7 Bewegungsstreifenpaare. Gegen Nebenkanäle (Befund Meta-Probe D2): jedes Paar bekommt eigene, zufällig benannte Kopien, beide Bilder gleich kodiert und auf gleiche Dateigröße gebracht, Metadaten entfernt; ein Urteil mit Sicherheit 1 von 5 zählt nicht als Treffer.
- Jedes Paar zweimal (A/B, B/A, Reihenfolge per Seed). Die Dateinamen sind Hashes.
- 5 Haiku-Stimmen plus eine Opus-Stichprobe von 7 Paaren.
- Bestanden bei ≥ 85 % „nachher besser“ und Mehrheit in jedem Raum.
- Alle Paare gehen als Kontaktbogen an den Nutzer. Ein Nutzer-Veto macht D2 rot.

**D3 Eichung** (vor jedem Gremium)
- 18 Eichbilder, 12 davon mit bekanntem Fehler. Typen: Pixel-3D-Block, Fremdfarbe, Lichtrichtung, Iso-Winkel, abgeschnittene Figur, Textüberlauf.
- Die Lösung wird erst nach dem Lauf eingecheckt.
- Das Gremium gilt, wenn die Mehrheit 2/3 ≥ 15/18 richtig liegt und ≤ 1 von 6 einwandfreien Bildern fälschlich meldet.
- Sonst urteilen 3 Opus-Ersatzrichter; D1 ersetzt D2 nie.

**Stilprüfung** (`python3 tool/bollwerk/stil.py`; Pillow und numpy sind vorhanden). Sie misst Stiltreue, nicht Gleichheit. Verglichen wird dieselbe Szene mit derselben Kamera im selben Lichtzustand am B-02-Commit. Der Renderer gibt Masken für Nebel, Licht und Effekte, neue oder ersetzte Requisiten, Figuren und Overlays mit aus; diese Flächen sind ausgeschlossen.
- S1: Kanten der Stil-Konstanten-Schicht (Böden, Wände, Türen) ≥ 92 % innerhalb ±1 px.
- S2: ≥ 97 % der Pixel außerhalb der Nebelmaske liegen mit ΔE2000 ≤ 10 an einer Palettenfarbe.
- S3: neue Kanten ≥ 85 % innerhalb ±3° von 0°, 90° oder ±26,57°.
- S4: Luminanz ±15 % und Vignette ±0,05, nur im Sichtkegel.
- S5: Importregel BE-01, Teilchen ≤ 3 px.
- (überholt: die geeichten Zahlen stehen in Master-Prompt Abschnitt 6 und Teil 1.)
- Gremium ≥ 2/3 „selber Stil“, geeicht mit 6 zusätzlichen Stilbruch-Bildern.

**Leistung und Akku**
- Beim Warten auf eine Entscheidung ≤ 10 Bilder/s und keine Physik. Physik läuft nur beim Würfeln und bei Splittern.
- Qualitätsstufen einfach, mittel, hoch. Liegt die Bildzeit 5 s lang über 50 ms, geht es automatisch eine Stufe tiefer. „Einfach“ hat keine Teilchen.
- Gemessen wird nach L8.


### Nachtrag M6 (Prüfrunde 2, gilt vor Teil 2)
- **F3 Wirkung:** je Option eine Folge aus A-3 „Spürbare Folgen“; bei Nachtminuten ≥ 2 min Unterschied.
- **F4 Dublette:** Orts-, Gegenstands- und Figurennamen aus den Kanonlisten vor dem Vergleich durch Platzhalter ersetzen; dann Wort-3-Gramm-Jaccard < 0,25 je Paar; höchstens ein Text je Satzskelett.
- **F2** einheitlich mit A-5 Ring 5: je Einheit in ≥ 1 % der Partien eines L4-Laufs (≥ 2.000 Partien, drei Strategien).
- **Bildverfahren:** Z-01, D2 und Vorher-Galerie nutzen nur `tool/bollwerk/foto.mjs` (aus `proben/foto_probe.mjs`), Qualitätsstufe „hoch“ fest; Gleichheit zweier Fotoläufe derselben SHA mit `bildgleich.py`, ΔE-Mittel ≤ 1,0 je Bild, Beleg in `belege/L12.txt`. Bewegungsstreifen als 8 Einzelbilder, animiertes WebP nur, wenn `kontaktbogen.py` es in BW0 lernt. Die automatische Qualitätsabstufung gilt nur im Spiel; ob sie Teilchen streicht, ist Frage an FUER-DEN-NUTZER.
- **Look-Anker:** Vorher-Galerie an K in der Sitzung `party` (7 Räume × 2 Lichtzustände × hoch/quer), bytegleich in `schnell`. Erneuert nur nach Z-17 (eigener Commit `LOOK-ANKER neu · <Grund>`, L12 grün, Bogen im Chat, ENTSCHEIDUNGSLOG); das Verbot des Neuschreibens in Abschnitt 7 gilt für Tore, nicht für diesen Weg. BW0 misst das Ankerbild `origin/kern-feinkorn:planung/feinkorn/bilder/k0/vorher_buffetsaal.png` mit `designmass.py` gegen die Vorher-Galerie (Ergebnis in `belege/L6.txt`).
- **S2/S4/S6/Licht:** S2 misst ΔE2000 (die Meta-Probe `designmass.py` nutzte ΔE76; BW0 eicht Metrik und Schwelle an der K-Basis). S3 gilt nur für Böden, Wände, Türen. S6: Anteil der Pixel in Quadraten ≥ 4 × 4 px mit einer Füllfarbe und 0°/90°-Kanten in den Masken neuer Figuren und Requisiten ≤ K-Basis + 5 Prozentpunkte (an `eichsatz.py` geeicht: `pixel3d` darüber, die sechs einwandfreien darunter). Masken nur für Nebel, Effekte und die 10 Kanon-Lichtquellen, jede Maskenfläche als Zahl in `belege/S.txt`. `stil.py --eich` spielt die 12 Fehler- und 6 Überladen-Bilder; jeder Fehlertyp macht ≥ 1 Test rot, sonst ist `stil.py` rot.
- **Abend-Basis (Z-12):** `messbasis/abend.json` entsteht am grünen BW2-Tor; Umfangseinheiten dürfen Abend und Gerätezeit nicht verlängern.
- **Einheit und Achse (Befunde ROT-1b, L07):** Eine gültige Einheit ist jede angenommene Variante mit F1–F6 grün, gezählt als Zeile der Merge-Datei unter `content/runden/schlosskeller/` (nie als Bauer-Ausgabe). Jede Einheit zählt in genau einer der Datensatz-Achsen X1, X3, X4, X6 nach ihrem Feld `art`: Abstecher und Folgeentscheidung → X1, Gag → X4 (einmal, auch wenn mehrere Einheiten `folge: gag` auslösen), Aktion → X6, Ort → X3; Lacher nur X4, nie zusätzlich X5. X2 ist eine eigene Größe (Lesebreite, ANNAHMEN A-26): Texte mit ≥ 8 Wörtern nach Platzhalter-Entfernung überall in der Schicht, auch Stufentexte von X1-Einheiten, mit demselben Filter wie die Basis; ein mehrfach gleicher Text zählt einmal. Der Morgenbericht zeigt U zusätzlich ohne Stufentexte in X2 (U_streng); fällt U_streng unter 8, steht das in FUER-DEN-NUTZER.
- **Wirkung je Achse (statt F3 allein):** X1 Optionen unterscheiden sich in ≥ 1 Feld des Spielstands (Punkte bleiben unberührt; Nachtminuten, Marken, Kettenstand, Freischaltungen), nicht im Textschlüssel. X3 zählt nur als Feld `ort` ≥ 1 Entscheidung oder ≥ 1 Abstechers, Dublette bei < 1 Kachel Abstand im selben Raum. X4 nur mit genau einer Auslösestelle und Spaß-Urteil ≥ 7. X6 nur, wenn sie `aktion.art` ≥ 1 Entscheidung ist.
- **Annahme mit fünf Richtern:** Spreizung = höchstes − niedrigstes Urteil. Bei Spreizung > 2 kommen zwei Richter (Linsen Kanon, Ton) hinzu; dann gilt allein der Median der fünf ≥ 7. X6: Lesbarkeit, Stiltreue, Wiederverwendbarkeit je im Median ≥ 7. F5-Eichstücke werden vor dem Merge entfernt und nie gezählt.
- **Basen:** Ein Skript zählt sie in BW0 an K und schreibt Zahl und Filter nach `UMFANG-BASIS.md`; von Hand wird nichts eingetragen. X6-Basis = Aktionsarten mit Animation ohne Ruhe-Animationen, Nenner max(5, Zahl). (Teil 2 MP-7 nennt X2 = 1.217 und ein überholtes Beispiel; es gilt Teil 1 und dieser Nachtrag.)

### 1.6 Design-Zwischenziele (D2-Probe, Zählregel Z-14)
Meta-Probe: 11/36 = 31 % „nachher besser“ (DESIGN-PROBE §2). Zwischenziele: nach BW3 ≥ 50 %, nach der ersten BW5-Design-Welle ≥ 65 %, vor BW7 ≥ 85 %. Unter dem Zwischenziel gehen zwei von drei Wellen an Design; unter 85 % beginnt BW7 nicht.

### 1.7 Zählregel Z-14 (D2, wörtlich verbindlich)
49 Paare = 7 Räume × 2 Kanon-Lichtzustände × 3 Ansichten (393×852, 852×393, 1180×820, Pixeldichte 2) + 7 Bewegungsstreifenpaare; jedes Paar in beiden Reihenfolgen (per Seed) als eigene, zufällig benannte Kopien gleicher Größe ohne Metadaten; je Darbietung 5 Haiku-Stimmen (`model: "haiku"`, `effort: "max"`, Antwort `{paar, besser: A, B oder gleich, sicherheit: 1–5}`), Stimmen mit Sicherheit 1 zählen nicht; ein Paar ist „nachher besser“, wenn in beiden Reihenfolgen die Mehrheit der gültigen Stimmen „nachher“ wählt; ≥ 85 % der 49 Paare und in jedem Raum ≥ 4 seiner 7 Paare; kein `VETO D2` offen; Meta-Blindprobe zum Vergleich: 25/36 erkannt, 11/36 „nachher besser“ (DESIGN-PROBE §2)

### 1.8 Schwellen Z-16 (Stilprüfung, wörtlich verbindlich)
Bezug: gleiche Szene, Kamera und Lichtzustand an K; Masken des Renderers ≤ 35 % der Bildfläche. S1 ≥ 92 % der Kanten der Stil-Konstanten-Schicht innerhalb ±1 px; S2 ≥ 97 % der Pixel außerhalb der Masken mit ΔE2000 ≤ 10 an einer Palettenfarbe; S3 ≥ 85 % der neuen Kanten innerhalb ±3° von 0°, 90°, ±26,57°; S4 Luminanz ±15 % und Vignette (Rand − Mitte in L*) ±5 % relativ zur K-Basis im Sichtkegel; S5 Teilchen ≤ 3 px nur für Splitter und Staub, 0 Treffer der Sperrliste (A-2 Definitionen); S6 Blockfreiheit in Figuren- und Requisitenmasken ≤ K-Basis + 5 Prozentpunkte; Lichtquellen = die 10 aus `raeume.json`; Nebelmaske je Raum nicht leer; Rot-Probe über den Eichsatz (jeder Fehlertyp macht ≥ 1 Test rot)

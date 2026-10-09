# P0-GEGEN-01 · Angriff auf die Messwerkzeuge (HZ-02, HZ-03, HZ-12)

Gegenprüfer · Projekt „Burgstadt HD“ · Geprüft: `packages/burgstadt_spiel/bin/flimmer.dart`, `bin/banding.dart`, `bin/szenen_mess.dart`.
Stand: Repo HEAD `920a863`. Die drei Dateien sind dort identisch zum Arbeitsstand bei allen Läufen (`flimmer.dart`, `banding.dart` seit `69dcb7a`; `szenen_mess.dart` seit `02d4735`). Bei allen Läufen war der Arbeitsbaum sauber. Erst danach wurde im Arbeitsbaum Palette v2 gestaged (`pixel_engine/lib/src/palette.dart`, `banding.dart` mit neuem `stufeVon`, nicht committet). B-04 ist deshalb auf beide Stände bezogen. Versuchsskripte und Ausgaben liegen nur im Scratch-Ordner `gegen01/` (unten „Lauf-Protokoll“). Im Repo wurde nichts geändert.

## Kurzfassung

- **Flimmern (HZ-03):** Das Werkzeug misst die Texelbewegung unter einer 0,1-m-Fahrt, kein Moiré. Mit flachen Texturen fällt der Wert von 0,542 auf 0,031. Die Auflösung ändert ihn nicht. Die Schwelle „≤ 50 %“ ist damit ohne jede Verbesserung am Flimmern erreichbar. Zusätzlich sind Szenenwahl (Szene C ist die Hofebene, nicht der Burghof) und das FERNE-Mittel (leere Szene wird als 0 mitgemittelt) fehlerhaft.
- **Banding (HZ-02):** Das Profil liegt zu 76 % auf der dunkelsten Stufe, die gewählte Wand hat Textur-Flecken im Lichtkegel, die Stufenzahl schwankt je Zeile zwischen 5 und 6, und ein Luma-Sprung von 40,8 (1,3 bis 1,8 Stufen) wird als „1 Stufe“ gemeldet. `stufeVon` passt nur zu einer Palettenversion: HEAD mit `& 7` ist für Palette v2 falsch (B-04).
- **Szenenmessung (HZ-12):** Die Wanduhr streut unbelastet um 39 % und unter Last um Faktor 3,4. Der Ausgangswert 61,3 ns/Px liegt unter allen drei eigenen Läufen (66 bis 92 ns/Px). Die Basis für „35 % unter Ausgang“ ist nicht festgelegt (320×180 ergibt 39,8 ns/Px als Ziel, 640×360 ergibt 34,3). Figuren werden kaum gemessen.
- **Befundzahl:** schwer 8 · mittel 7 · leicht 2 (gesamt 17).

## Antworten auf die Auftragspunkte

1. **Misst das Flimmer-Werkzeug das Richtige?** Nein, es misst Texelbewegung (F-03). Bei verdoppelter Weltauflösung bleibt der Wert gleich (F-04). „≤ 50 %“ ist nur durch weniger Texturdetail erreichbar und damit trivial und uninformativ (F-03). Eine HD-Dichte von 64 Texel/m würde den Wert voraussichtlich anheben (F-04).
2. **Banding:** Die Stufenzählung „verschiedene Indizes der Mittelzeile“ ist nicht robust (B-02). Die Wand ist nicht repräsentativ (B-01, B-05). Die Stufenfunktion passt nur zu einer Palettenversion: HEAD mit `& 7` liefert bei v2 falsche Sprünge von 7, der Arbeitsbaum mit `& 15` bei v1 falsche Sprünge von 15 (B-04).
3. **Szenenmessung:** Die Wanduhr streut zu stark (S-01). Prozessorzeit des Threads ist stabil (S-01). Figuren sind unterrepräsentiert (S-04). Die Regression stimmt nicht (S-03).
4. **Reproduzierbarkeit:** `flimmer` zweimal identisch (0,542 / 0,393). `banding` zweimal identisch (Text und CSV). `szenen_mess` über drei Läufe mit identischen Zählwerten, aber unterschiedlichen Zeiten.
5. **Szenenwahl Flimmer:** `hofebene` ist der Innenraum „Hofebene des Turms“, nicht der Burghof `hof`. Folge: Ausgang MITTEL 0,542 statt 0,642 mit `hof`, also 18 % Unterschied (F-01). Zusätzlich verfälscht die leere Szene das FERNE-Mittel (F-02).

## Befunde

### F-01 · schwer · Szene C misst nicht den Burghof

- **Beleg:** `flimmer.dart:151` lädt `spiel.stadt.bereiche['hofebene']`. Das ist laut `packages/burgstadt_core/lib/src/welt/burg.dart:131–134` der Innenraum „Hofebene des Turms“ mit `innen: true`. Der Burghof ist `hof` (`burg.dart:175–177`, `innen: false`). Die Ausgabe nennt die Szene trotzdem `C-Burghof` (`flimmer.dart:153`).
- **Lauf:** Scratch-Variante `gegen01/flimmer_var2_out.txt`, Zeilen „echt · 320x180 · 0,10“. Mit `hof` (Marke b, längste freie Sicht 7,8 m) ergibt sich für C 0,668 statt 0,370. MITTEL steigt von 0,542 auf 0,642, FERNE von 0,393 auf 0,640.
- **Folge:** Die HZ-03-Schwelle „≤ 50 %“ liegt je nach Szene bei 0,271 oder 0,321. Der Ausgangswert misst die Szenenwahl und nicht das Flimmern.
- **Vorschlag:** Szene C auf `hof` (Marke b, längste Sicht, wie Szene A) setzen. Die Innenraum-Hofebene als eigene, benannte Zusatzszene führen. Die Szenenliste mit jedem eingefrorenen Ausgang protokollieren.

### F-02 · schwer · FERNE-Mittel ist durch eine leere Szene um ein Drittel zu niedrig

- **Beleg:** Szene C hat keinen Bodenpunkt jenseits 6 m: Ausgabe „Boden bis 4,2 m“ (`flimmer.dart:226–229`, `gegen01/flimmer_std_1.txt`). `fernAnteil` liefert bei `fern == 0` den Wert 0 (`flimmer.dart:162`). `fernMittel` mittelt trotzdem über alle drei Szenen (`flimmer.dart:241`). Ausgang: „FLIMMERN MITTEL 0,542 · FERNE 0,393“.
- **Zahl:** Ohne die leere Szene ist FERNE (0,716 + 0,462) / 2 = 0,589 (`gegen01/flimmer_var2_out.txt`, Spalte „FERNE ohne Szene ohne Ferne“).
- **Folge:** Ein FERNE-Wert hängt daran, wie viele Szenen zufällig keine Fernpixel haben. Ein Szenenwechsel verschiebt die Basis, ohne dass am Flimmern etwas geändert wurde.
- **Vorschlag:** Szenen mit weniger als 1000 Fernpixeln aus dem Fern-Mittel ausschließen und dann „n/a“ ausgeben. Die Zahl der Fernpixel je Szene in die Ausgabe aufnehmen.

### F-03 · schwer · Das Werkzeug misst Texelbewegung, nicht Flimmern

- **Beleg (Code):** Das zweite Bild liegt 0,1 m vor dem ersten, ohne jeden Bewegungsausgleich (`flimmer.dart:234`). Gezählt wird jede Änderung des Palettenindex (`flimmer.dart:171`). Auch ein perfekt gefilterter Renderer ändert bei einer Verschiebung Indizes. Das Werkzeug kann Moiré also nicht von richtiger Bewegung trennen.
- **Beleg (Flachtextur-Referenz):** Alle Texturen auf ihren häufigsten Index gesetzt, Geometrie, Licht und Nebel unverändert (Scratch `flimmer_var.dart`, Funktion `flach`). MITTEL bei 0,10 m: 0,031 statt 0,542 (320×180), 0,032 bei 640×360. Rund 94 % des Werts stammen aus Texturdetail.
- **Beleg (Schritt-Sweep, echte Texturen, MITTEL):** 0,01 m → 0,101 · 0,02 m → 0,194 · 0,05 m → 0,408 · 0,10 m → 0,542 · 0,20 m → 0,605. Szene A allein: 0,152 / 0,284 / 0,608 / 0,756 / 0,698. Linear bis etwa 0,05 m, danach flacher (`gegen01/flimmer_var2_out.txt`).
- **Folge:** HZ-03 misst, wie viele Pixel sich bei 10 cm Fahrt ändern. Weniger Texturdetail, ein höherer Mip-Cap oder flachere Texturen senken den Wert, ohne dass Moiré besser wird. Das Ziel 0,271 liegt weit über dem Flachtextur-Wert 0,031. Die Schwelle ist damit trivial erreichbar und sagt nichts über Flimmern aus. Die Stilblatt-Regel „höchstens 8 von 16 Stufen je Textur“ (`hd/KERN.md:81`) wirkt in dieselbe Richtung.
- **Vorschlag (auflösungsunabhängige Messung):** Referenzvergleich statt Paarvergleich. Für N = 10 Schritte à 0,01 m (insgesamt 0,1 m) und jeden Bodenpixel p:
  - Referenz R_t(p) = Mittel der 4×4 Unterpixel-Luma aus einer vierfach feineren Welt (gleiche Kamera, Texturen, Mip-Formel).
  - Fehler e_t(p) = |Luma_t(p) − R_t(p)| mit Luma nach Rec. 709 aus der Palette.
  - Flimmerwert = Anteil der Paare (t, t+1), für die |e_{t+1}(p) − e_t(p)| > 2 Luma gilt. Die Schwelle 2 wird an Flachtextur und Ausgang geeicht.
  - Eichung: Flachtextur muss nahe 0 liegen. Der Ausgang muss einen festen, reproduzierbaren Wert liefern.
  - Szenenliste fest: A, B, `hof`, plus eine Figurenszene (siehe S-04).
  - Der Wert hängt dann am Abstand zum Ideal und nicht an der Pixelzahl. Die Alternative „Richtungswechsel der Luma über N Schritte“ ist nur mit Eichung brauchbar, weil Texturrauschen auch ohne Flimmern Wechsel erzeugt.

### F-04 · mittel · Die Auflösung ändert den Wert nicht, die HD-Dichte schon

- **Beleg (Lauf):** 320×180 → 640×360 mit gleichen Texturen und 0,10 m: MITTEL 0,542 → 0,542. A 0,756 → 0,761, B 0,501 → 0,499, C 0,370 → 0,365 (`gegen01/flimmer_var2_out.txt`).
- **Beleg (Code):** Texeldichte `kTexelsPerMeter = 32` (`packages/pixel_engine/lib/src/raster/mesh.dart:5`). Die HD-Planung setzt 64 Texel/m bei doppelter Brennweite, sodass tpp gleich bleibt (`hd/ENTSCHEIDUNGSLOG.md:11`, E-005). Mip-Auswahl in `packages/pixel_engine/lib/src/raster/renderer.dart:483–492`.
- **Folge:** Die Prämisse des Auftrags („doppelt so viele Pixel je Texel-Wechsel“) trifft für die reine Auflösung nicht zu. Die Dichte ist dagegen wirksam: 64 Texel/m bedeuten 6,4 statt 3,2 Texel je 0,1 m. Nach dem Schritt-Sweep entspricht das dem Ausgang bei 0,2 m, also MITTEL ≈ 0,605, +12 % gegenüber 0,542. Um ≤ 50 % des Ausgangs zu erreichen, müsste der HD-Wert dann um 55 % sinken. Das ist eine Ableitung aus dem Sweep und keine direkte Messung.
- **Vorschlag:** Vor P1 einen Dichte-Lauf in einer Scratch-Kopie messen (Mesh-UV ×2 bei doppelter Brennweite). Bis dahin HZ-03 nicht als erfüllbar oder unerfüllbar bewerten.

### F-05 · mittel · Das Ergebnis hängt an der Schrittweite

- **Beleg (Lauf, 320×180, hofebene):** MITTEL 0,523 (0,08 m), 0,533 (0,09), 0,542 (0,10), 0,548 (0,11), 0,554 (0,12). Szene A: 0,786 (0,08) → 0,756 (0,10) → 0,698 (0,20), also nicht monoton. Szene hof: 0,628 (0,08), 0,642 (0,10), 0,651 (0,12), 0,667 (0,20) (`gegen01/flimmer_var2_out.txt`).
- **Folge:** „0,1 m“ ist eine willkürliche Wahl. Die Schwelle verschiebt sich je nach Schrittwahl um einige Prozent. Der Szenenwechsel (F-01) wirkt stärker als jede Schrittänderung.
- **Vorschlag:** Mittel über 0,05 bis 0,15 m mit sieben Schritten bilden und die Spannweite ausgeben.

### F-06 · mittel · Zielgröße und Gewichtung sind nicht festgelegt

- **Beleg:** HZ-03 (`hd/ZIELFORMEL.md:20`) verlangt „Flimmerwert ≤ 50 % des Ausgangs“, das Werkzeug gibt aber MITTEL und FERNE aus. MITTEL ist ungewichtet über die Szenen gebildet (`flimmer.dart:240`). Pixelgewichtet mit den Bodenpixeln 10754 / 5785 / 3845 (`gegen01/flimmer_std_1.txt`) ergäbe sich 0,611 statt 0,542, also +13 %.
- **Folge:** Je nach Lesart liegt die Schwelle bei 0,271 (MITTEL), 0,305 (MITTEL pixelgewichtet), 0,295 (FERNE korrigiert) oder 0,197 (FERNE wie ausgegeben, falsch).
- **Vorschlag:** Die Zielgröße in HZ-03 wörtlich festlegen: eine Zahl, feste Szenenliste, Gewichtung, Schrittbereich. Das Werkzeug gibt genau diese Zahl als ZIEL aus.

### F-07 · leicht · `--qualitaet hoch` verdoppelt die Auflösung nicht

- **Beleg:** `packages/burgstadt_spiel/lib/src/skalierung.dart:5–7` (sparsam 135, mittel 180, hoch 216). Lauf: `--qualitaet hoch` ergibt `SKALA Welt 320x180 ×4`, wie mittel. `sparsam` ergibt 214×120. Der Usage-Text `flimmer.dart:17` führt `hoch` als Stufe.
- **Folge:** Mit der Option ist die Verdopplung nicht prüfbar. „scharf“ existiert noch nicht (`hd/KERN.md:122–125`, K-011).
- **Vorschlag:** `--welt BxH` wie in `szenen_mess.dart:259–262`.

### B-01 · schwer · Die Wand ist nicht glatt, das Profil ist fast leer

- **Beleg (Wahl):** `banding.dart:79` prüft nur den Namensbeginn „putz“. `banding.dart:56–68` prüft nur die Geometrie (Wandkacheln, freie Sicht), nicht Objekte oder Textur. Gewählt wurde `haus-H-005` („Haus zum Schwarzen Adler“, `putzOcker`, innen; `packages/burgstadt_core/data/stadt/haeuser.json:57`, Probe `gegen01/probe_wand.dart`). An der Mittelachse liegt kein Objekt (Kachel (8,10): Wand, `ding -`).
- **Beleg (Bild):** Im Lichtkegel liegen dunkle Rechteckflecken der Putztextur (`gegen01/banding_1_zoom.png`). Spalte 165 springt von Luma 96,13 auf 136,97 (`gegen01/banding_1.csv`, Spalten 164–165).
- **Beleg (Profil):** 160 Spalten rechts der Mitte (`banding.dart:167–168`). Davon liegen 121 auf Index 32 (dunkelste Stufe), nur 39 tragen einen Gradienten (`banding_1.csv`). Der Lichtkegel (`pixel_engine/lib/src/raster/renderer.dart:91`, flashRadius 0,55 der halben Bildhöhe) deckt etwa 40 Spalten ab.
- **Folge:** HZ-02 „Sprung ≤ 1 Stufe“ wird zu 76 % an einer dunklen Fläche geprüft. Der Luma-Sprung von 40,8 stammt aus der Textur (siehe B-03). Die Messung repräsentiert eine Wand, eine Farbe und einen Abstand (B-05).
- **Vorschlag:** Testwand ohne Dekor wählen (Objektprüfung über `dingAn` im gesamten Kegel, Schwelle für Texturvarianz). Profil über den vollen Kegel (bis etwa 1,2 × Radius) in vier Richtungen erheben. Nur Spalten im Kegel zählen.

### B-02 · schwer · Die Stufenzahl schwankt mit der Zeile

- **Beleg:** Distinkte Farben rechts der Mitte (PNG, `banding_1.png`): Zeile 86 → 5, Zeile 88 → 6, Zeile 90 (Mittelzeile) → 5, Zeile 92 → 6, Zeile 93 → 5. Die Mittelzeile wird in `banding.dart:173` gelesen und in `banding.dart:181` als `index.toSet().length` gezählt. Index 36 erscheint nur in 3 Spalten (`banding_1.csv`).
- **Folge:** Die Stufenzahl ist keine stabile Größe. Einzelne Dither- oder Texturspalten erzeugen eigene „Stufen“, und die Zählung verschiebt sich um eins je Zeile. Die HZ-02-Schwelle „≥ 10 Stufen im Profil“ ist damit nicht auf einer verlässlichen Grundlage bewertbar.
- **Vorschlag:** Stufen aus dem 8-Zeilen-Luma-Band über Palette-Luma-Grenzen bilden. Nur Stufen mit mindestens 3 Spalten zählen. Der Index bleibt nur als Kontrolle.

### B-03 · schwer · Das Sprung-Maß misst den Index, nicht die Helligkeit

- **Beleg:** `banding.dart:184` berechnet den Luma-Sprung aus dem 8-Zeilen-Mittel. `banding.dart:185–187` berechnet den Stufensprung aus dem Index der Mittelzeile. Ausgabe: „größter Sprung 40,8 Luma / 1 Stufen“ (`gegen01/banding_std_1.txt`). Der größte Luma-Sprung liegt zwischen Spalte 164 und 165 (`banding_1.csv`).
- **Palette-Luma** (Rec. 709 aus den RGB-Werten der Mittelzeile im PNG, Formel wie `banding.dart:32`): Index 32 → 30,2 · 33 → 53,2 · 34 → 79,2 · 35 → 106,3 · 36 → 137,0. Die Stufenbreite liegt bei 23,0 bis 30,7. Ein Sprung von 40,8 entspricht also 1,3 bis 1,8 Stufen.
- **Folge:** Das Gate „Sprung ≤ 1 Stufe“ wird mit dem Indexmaß bestanden, obwohl die Helligkeit um mehr als eine Stufe springt. Der Fehler ist eine Folge aus B-01 und dem Indexmaß.
- **Vorschlag:** Sprung in Stufen als Δ-Luma geteilt durch die Stufenbreite der Palette berechnen, über dasselbe Band wie B-02.

### B-04 · mittel · `stufeVon` passt nur zu einer Palettenversion

- **Beleg (HEAD `920a863`):** `banding.dart:29`: `int stufeVon(int index) => index & 7;`. Das stimmt nur für Palette v1 (Index = Rampe·8 + Stufe). Der Kommentar `banding.dart:26–28` nennt `& 15` für Palette v2. KERN K-010 verlangt Index = Rampe·16 + Stufe (`hd/KERN.md:106`).
- **Lauf (Rechnung mit `& 7` auf v2-Indizes 0…31):** Sprünge von 7 bei den Übergängen 7→8, 15→16 und 23→24 (`stufeVon` 7 → 0). Jeder Übergang über die halbe Rampe wird als falscher Sprung gemeldet.
- **Stand Arbeitsbaum (nach den Läufen, gestaged, nicht committet):** `banding.dart` importiert `stufeVon` aus `pixel_engine` (`packages/pixel_engine/lib/src/palette.dart:66`: `index & 15`). Das ist für Palette v2 richtig. Mit der noch gültigen Palette v1 (Index = Rampe·8 + Stufe) würde `& 15` bei den Übergängen 15→16 und 31→32 einen falschen Sprung von 15 melden (Index 15 → 0, Rampe 1 Stufe 7 → Rampe 2 Stufe 0). Das Werkzeug ist damit an den Palettenstand gekoppelt, ohne dass es einen Test dafür gibt.
- **Skalenfolge:** Bei Palette v2 ist eine Stufe halb so groß wie bei v1 (`hd/KERN.md:107`, Altfarbe s liegt auf 2s+1). Die HZ-02-Schwelle „Sprung ≤ 1 Stufe“ wird damit strenger, ohne dass sich der Wortlaut ändert. Der Ausgang „größter Sprung 1 Stufe“ ist nicht auf v2 übertragbar.
- **Folge:** Ein Wechsel der Palette ohne gleichzeitigen Werkzeugwechsel (oder umgekehrt) erzeugt falsche Sprünge oder falsche Gates. Ohne Test bleibt das unbemerkt.
- **Vorschlag:** Die Stufenfunktion zusammen mit der Palettenversion führen (Konstante für Stufen je Rampe, Stufe = Index mod Stufen). Einheitstest mit Palette v1 und v2 (Indizes 0…31 bzw. 0…255 mit jeweils Sprung 1 je Stufenübergang). Die Schwelle in Luma (Δ-Luma je Stufenbreite) angeben, nicht als Stufenzahl.

### B-05 · mittel · Stichprobe mit n = 1

- **Beleg:** `waehleWand` nimmt die Wand mit dem Abstand am nächsten zu 2,0 m (`banding.dart:86–91`). Ergebnis: eine einzige Wand bei 2,00 m (Ausgabe „WAND haus-H-005 … Abstand 2,00 m“). Andere Putzfarben existieren (`packages/burgstadt_core/lib/src/welt/stadtgenerator.dart:321`).
- **Folge:** Das Banding hängt von Farbe, Abstand (Kegelgeometrie) und Wandfläche ab. Ein Wert gilt nur für diesen Fall. HZ-02 nennt keine Fallzahl.
- **Vorschlag:** Drei Abstände (1,0 / 2,0 / 3,0 m) und mindestens drei Putzfarben testen, je Fall das Maximum ausgeben.

### S-01 · schwer · Die Wanduhr streut zu stark für HZ-12

- **Beleg (Code):** `szenen_mess.dart:147` (`final _sw = Stopwatch();`) und `:150–154` (`_zeit` misst die Wanduhr). `leistung.dart:25–26` und `:155–170` verwenden dagegen die Prozessorzeit des Threads (`clock_gettime`, `CLOCK_THREAD_CPUTIME_ID`).
- **Beleg (Lauf, 320×180, Mittel Bild):**
  - Ohne eigene Last, Wanduhr: 3,92 / 3,82 / 5,32 ms (68,1 / 66,3 / 92,4 ns/Px). Spanne 39 % (`gegen01/szenen_std_*.txt`).
  - Gepaart abwechselnd, Wanduhr gegen Prozessorzeit: 4,25 / 4,63 / 4,56 ms gegen 4,65 / 4,62 / 4,06 ms.
  - Unter Fremdlast (vier parallele `flimmer`-Läufe): Wanduhr 11,39 / 17,72 / 5,16 ms (197,8 / 307,6 / 89,6 ns/Px). Prozessorzeit 4,51 / 4,36 / 3,69 ms (78,4 / 75,6 / 64,1 ns/Px). Die Scratch-Kopie `gegen01/szenen_cpu.dart` misst mit Prozessorzeit.
- **Beleg (Host):** Zu Beginn der Läufe belegte ein fremder Prozess `leistung 20` 90,7 % CPU, Load 6,4 (`ps`). Die „unbelasteten“ Läufe waren also nicht sauber.
- **Folge:** Mit der Wanduhr lässt sich HZ-12 (a), „≥ 35 % unter Ausgang“, nicht entscheiden. Eine Einzelmessung ist nicht belastbar.
- **Vorschlag:** Prozessorzeit des Threads wie in `leistung.dart` verwenden. Median und Spanne über mindestens fünf Läufe ausgeben. Die Last (Load-Wert) im Protokoll festhalten.

### S-02 · schwer · Ausgangswert und Basis sind nicht belastbar

- **Beleg:** Ausgang laut Commit `02d4735` und Autorenrückgabe: 320×180 3,53 ms / 61,3 ns/Px; 640×360 12,14 ms / 52,7 ns/Px. Eigene Läufe mit Wanduhr: 320×180 66,3 bis 92,4 ns/Px (drei Läufe, alle über dem Ausgang), 640×360 62,4 / 57,4 ns/Px (zwei Läufe, `gegen01/w640_*.json`).
- **Folge:**
  - HZ-12 (a) verlangt „≥ 35 % unter Ausgang“ je Weltpixel. Das Ziel hängt von der Basis ab: 39,8 ns/Px bei 320×180, 34,3 ns/Px bei 640×360.
  - Die Basis ist eine Einzelmessung. Ihre Streuung (rund ±20 %) ist größer als der Unterschied zwischen beiden Basen.
  - Gleicher Code, gleiche Methode: 320×180 und 640×360 unterscheiden sich um etwa 14 % je Weltpixel. Die Ursache ist nicht geprüft; Fixkosten je Bild (Himmel, `szenen_mess.dart:186`, RGBA-Umwandlung `:189`) sind ein Kandidat.
- **Vorschlag:** Ausgang und Ziel für 640×360 (Zielgröße „scharf“) mit Prozessorzeit neu einfrieren, mit Median und Spanne. Den Zielwert in ZIELFORMEL HZ-12 (a) als absolute ns/Px festlegen.

### S-03 · mittel · Die Regression stimmt nicht

- **Beleg:** `szenen_mess.dart:241–250` (Kleinste Quadrate ohne Achsenabschnitt auf Dreiecke und Pixel). Koeffizienten je Lauf (`gegen01/szenen_std_*.json`): a = 0,58 / 0,45 / 0,82 µs je Dreieck; b = 23,3 / 25,7 / 31,6 ns je Pixel.
- **Residuum** (Modell gegen gemessene Meshes-Zeit je Szene, (Modell − gemessen) / gemessen):
  - Lauf 1: Marktplatz −13 %, Oberstadt +6 %, Innenraum +18 %, Burghof −4 %.
  - Lauf 2: −8 %, +5 %, +17 %, −8 %.
  - Lauf 3: +13 %, −5 %, +3 %, −8 %.
- **Folge:** Bei gleichem Code schwankt a um rund 80 % und b um 36 %. Die Residuen reichen bis ±18 %. Ein fehlender Term für die Zahl der Meshes (6 bis 110 je Bild, Feld `meshesGezeichnet` in der JSON) ist ein naheliegender Grund; mit vier Szenen ist das nicht zu entscheiden. Die Algebra der Formel selbst ist korrekt (Normalgleichung ohne Achsenabschnitt, Einheiten µs und ns stimmen).
- **Vorschlag:** Regression entfernen. Stattdessen Zählwerte je Szene und Mittelzeit berichten. Falls ein Modell bleibt, mit Meshes-Term und mindestens zehn Szenen.

### S-04 · mittel · Die Szenen repräsentieren Figuren kaum

- **Beleg:** Gezeichnete Sprites je Bild: Marktplatz 1,82, Oberstadt zweite Stelle 2,70, Innenraum 0,00, Burghof 0,00 (`gegen01/szenen_std_*.json`, Feld `spritesGezeichnet`; über drei Läufe identisch). Die Sprite-Zeit liegt bei höchstens 0,12 ms von 5,6 ms (2 %, Lauf 3). Figuren werden nur im Bereich der Szene gezeichnet (`szenen_mess.dart:173`).
- **Folge:** Die Figurenlast für HZ-09 (66 Karten in HD, Dichte 64 bei „scharf“) wird praktisch nicht gemessen. Zwei von vier Szenen sind Oberstadt-Szenen. Jede Szene wird als 360°-Rundblick gemessen (`szenen_mess.dart:351`), nicht als Spielblick.
- **Vorschlag:** Eine fünfte Szene mit mindestens sechs Figuren im Blick (Phase 2, Marktplatz) und Figurenzähler in der Ausgabe. Zusätzlich einen Spielblick (Sichtfeld 62°, Fahrt) messen.

### S-05 · leicht · Das Handylicht ist dauerhaft an

- **Beleg:** `szenen_mess.dart:135` setzt `r.flashStrength = 0.9` in jeder Messung. Laut Kommentar in `banding.dart:19` schaltet die Erkundung das Licht nur bei Bedarf ein (`erkundung.dart:404`, `flash = licht ? 0.9 : 0.0`).
- **Folge:** Die Zahlen sind ein Worst Case und kein Spielfall. Vergleiche mit einer Messung ohne Licht sind nicht möglich.
- **Vorschlag:** Im Ausgabeblock „Handylicht an“ ausweisen oder einen zweiten Lauf ohne Licht ergänzen.

## Zusammenfassung nach Schwere

| Schwere | Befunde |
|---|---|
| schwer (8) | F-01, F-02, F-03, B-01, B-02, B-03, S-01, S-02 |
| mittel (7) | F-04, F-05, F-06, B-04, B-05, S-03, S-04 |
| leicht (2) | F-07, S-05 |

## Geprüft ohne Befund

- **Reproduzierbarkeit `flimmer`:** zwei Läufe, identische Ausgabe (0,542 / 0,393).
- **Reproduzierbarkeit `banding`:** zwei Läufe, Text und CSV identisch.
- **Reproduzierbarkeit `szenen_mess`:** Zählwerte (Meshes, Dreiecke, Sprites, Überdeckung) über drei Läufe identisch; nur die Zeiten schwanken (S-01).
- **Kontrollvariante:** Die Scratch-Variante reproduziert die Originalwerte exakt (320×180, 0,10 m, Szene C hofebene: 0,756 / 0,501 / 0,370; MITTEL 0,542; FERNE 0,393). Die Varianten sind daher vergleichbar.
- **CPU-Uhr:** Eichlauf `gegen01/eich_cpu.dart`: Rechenlast ergibt CPU-Zeit unter Wanduhr (Lauf 1: 91,6 gegen 100,8 ms), Schlaf 200 ms ergibt 0,37 ms CPU. Die Uhr funktioniert.
- **Kamerawahl `szenen_mess`:** Szenen A bis D aus `szenen_mess.dart:303–340`, Burghof dort korrekt `hof` (`:337`).

## Offene Fragen

- Trifft die HD-Prognose (F-04, MITTEL ≈ 0,605 bei Dichte 64) zu? Nicht gemessen; ein Mesh-UV-Lauf fehlt.
- Ist der Ausgang (61,3 ns/Px, 52,7 ns/Px) ohne fremde Last reproduzierbar? Nicht geklärt, der Host war nicht frei.
- Zeigen andere Putzfarben dasselbe Banding? Nicht gemessen.
- Verändern Figuren bei „scharf“ den Wert spürbar? Keine Szene mit vielen Figuren gemessen.
- Trennt die Referenzmessung (F-03) den Texturanteil vom Flimmern? Nur vorgeschlagen, nicht umgesetzt.

## Lauf-Protokoll

- **Repo:** Die drei Werkzeuge sind identisch zu HEAD. Während der Prüfung wechselte HEAD von `69dcb7a` auf `920a863` (anderer Agent). Die geprüften Werkzeuge sind davon nicht betroffen.
- **Läufe mit den Originalwerkzeugen** (aus `packages/burgstadt_spiel`, `/opt/flutter/bin/dart run …`): `bin/flimmer.dart` (2×, Standard), `bin/banding.dart --csv --png` (2×), `bin/szenen_mess.dart --json` (3× ohne Fremdlast; 3× Wanduhr und 3× Prozessorzeit unter Fremdlast; 2× `--welt 640x360`), `--qualitaet hoch` und `sparsam` (nur SKALA-Zeile).
- **Scratch-Werkzeuge** (`gegen01/`): `flimmer_var.dart` (Schritt, Auflösung, Flachtextur, Szene C als hofebene oder hof, validiert gegen das Original), `szenen_cpu.dart` (Prozessorzeit statt Wanduhr), `probe_wand.dart` (Belegung der Wand), `eich_cpu.dart` (Eichlauf der CPU-Uhr).
- **Lastmessung:** Ein Shell-Befehl mit einer Lastschleife wurde von einer Sicherheitsprüfung abgelehnt; er enthielt keine Löschung und wurde nicht ausgeführt. Die Last wurde danach mit parallelen `flimmer`-Läufen erzeugt. Im Git-Status ist nach den Läufen keine Änderung durch diese Prüfung zu sehen; die Ausgabe ist die einzige neue Datei.

ENDE PAKET P0-GEGEN-01

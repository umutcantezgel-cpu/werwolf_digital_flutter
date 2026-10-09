# A-4 · Spielkern (Kern-Aussagen K-01…K-26) und bindende Mechanik

Teil 1 ist SPIELKERN.md des Meta-Laufs (Simulator-Belege mit Seed-Satz). Teil 2 sind die bindenden Abschnitte C1–C9 des Startentwurfs; wo Teil 1 abweicht (K-05 Befragen würfelt nie, K-06 keine Helfer-Fachgebiete, K-07 Schwellen 9/7–8/≤6, K-14 Lösbarkeit würfelbezogen, Seed mit Salz statt Fall-Code), gilt Teil 1.

## Teil 1

Grundlage: Anhang C (Startentwurf), vier Gegenentwürfe (3 Haiku auf max, 1 Opus) mit Blindbewertung durch 3 Haiku-Richter, und der Simulator `planung/bollwerk/proben/wuerfel_sim.py` (sha256 `7f568495fa18fe9c81c99cafedbd2b41832fc697b633ad1c7e24191850fdf7d3`).

**Turnier (blind, 3 Richter, 5 Kriterien × 10 Punkte):** Entwurf D (Opus, „Gespenst, Handy, Lupe“) 117 · C (Haiku, „Der ganze Keller“) 104 · A (Haiku, „Karten mit Tempo“) 101 · B (Haiku, „Glückskorb“) 89. Übernommen wird **D als Gerüst**, mit dem Zahlenkern aus dem Simulator (D selbst war nicht reproduzierbar simuliert) und aufgepfropften Ideen aus C (Stimmkreis-Beteiligung) und A (Tempo-Rechnung je Runde).

**Seed-Satz (eingefroren):** Partie-Seed = erste 8 Hex von `sha256("bollwerk-meta|<form>|<n>|<pfad>|<i>")`, i = 0…9.999, Formen party/solo, n ∈ {4, 8, 12, 16, 20}; erschöpfend: 768 Folgen × 4 Pfade × n = 4…20 × Ströme {pech, erfolg, neutral} × Strategien {neutral, gier} = 313.344 Läufe.

### Kern-Aussagen

| Nr | Aussage | Begründung | Beleg (Seed-Satz oben) |
|---|---|---|---|
| K-01 | Eine Runde dauert 45 Nachtminuten; die Gesprächszeit am Tisch (`rundendauerMinuten`) läuft getrennt und ist keine Nachtzeit. | Kanon (Runden 00:30, 01:15, 02:00) | – |
| K-02 | Je Runde: Tischgespräche (würfelfrei, alle `beobachtung:`/`luege:`-Glieder) → 3 Pflichtzüge in Kanon-Reihenfolge, dazwischen Abstecher, solange die Reserve reicht → Feierabend am `geburtstagsplatz` → Gruppenwahl, Bonus, Resümee wie im Kanon. | Entwurf D; P-1 | – |
| K-03 | Entscheidungsarten: Pflichtzug (wertend, 9×, genau ein `Spiel.waehle`), Folgeentscheidung (nichtwertend, öffnet nach einem Pflichtzug, jede Option mit anderer spürbarer Folge, nie mit `fakt:`-Gliedern), Auftakt-Suche (Runde 1, nichtwertend, 0 Nachtminuten, sichert ≥ 1 Wurf je Runde), Abstecher (freiwillig, nichtwertend), Tischruf (offene Gruppenentscheidung nach Pech: Nochmal oder Umweg), Einsatz („gründlich“, Marke), Gruppenwahl (geheim, G-1), Anklage. | A3, Entwurf D, Fabrikprobe R2 | – |
| K-04 | Jede Entscheidung löst eine sichtbare Aktion aus: Weg über A*, Pose, Licht, Klang, Szene 4–12 s, in ≤ 1 s überspringbar. „In den Keller gehen“ ist das Intro 18:00: fünf Sandsteinstufen hinab, Außentor knarrt, Windfang, Buffetsaal blendet auf. | A3, C5 | C8 Nr. 9 im Nachtlauf (L7-Fotos) |
| K-05 | **Nur Suchen würfeln, Befragen nie.** Eine Pflichtentscheidung würfelt, wenn eine ihrer Optionen einen Gegenstand, Raum oder Ort zum Ziel hat (e2_1, e2_2, e2_3, e3_1, e3_2); Befragungen nie, in keiner Form. | Würfelten nur unbesetzte Befragungen, trüge bei e1_1 nur die immer richtige Karte (Damir, NPC ab 8 Personen) einen Wurf: Verstoß gegen C3 „Chance korreliert nicht mit richtig“ (Entwurf D) | Simulator `suche` |
| K-06 | Alle Optionen einer Entscheidung zeigen dieselbe Chance; Modifikatoren hängen nie an Ziel, Option, Besetzung oder Pfad. Helfer-Fachgebiete sind **kein** Modifikator. | Azras „Vitrine“-Bonus läge stets auf der falschen Karte e2_2_vitrine (Entwurf D) | – |
| K-07 | Würfel: 2W6 + Gesamtmodifikator 0..+2; Erfolg ≥ 9, Teilerfolg 7–8, Pech ≤ 6. Modifikatoren: Werkzeug +1 (Tee vom Teekocher, Tims Stirnlampe; Handy-Licht immer +0), „gründlich“ +2 (+2 min), Seifenblasen-Marke +1 (≤ 1 je Wurf, ≤ 2 je Wissensziel, ≤ 3 je Partie). Bei +0: Pech 15/36 = 41,7 %, +1: 27,8 %, +2: 16,7 %. | C2-Band nach Modifikatoren | Pech im ersten Anlauf 31,5–31,8 % |
| K-08 | **Darstellung:** Der Kellerwürfel zeigt Bilder statt Zahlen – Gespenst (Pech), Handy (Teilerfolg), Lupe (Erfolg); vor dem Wurf stehen die drei Chancen in Prozent mit Wort und Symbol (nie nur Farbe). Ein Holzwürfel rollt im Handy-Licht (FEINKORN-Physik nur Darstellung, Seiten auf das Host-Ergebnis umbenannt), danach ein Aktenstempel. | Entwurf D (Richter: „Bilderwürfel macht Pech sichtbar“), WÜ-2 | – |
| K-09 | **Würfelpate:** In der Party tippt reihum eine andere Person den Wurf („Gib das Gerät an Fatma – sie würfelt!“); das Gerät rechnet, der Tipp ist Darstellung. | Entwurf D; C7 Beteiligung | – |
| K-10 | Pech heißt: Missgeschick nur an Sachen, Licht oder Zeit, dann Glück im Unglück (Marke + harmloser wahrer Satz), dann **Tischruf**: Nochmal (+3 min, ohne Bonus) oder Umweg (+3 min, Nachbarort zur selben Kanon-Quelle). Nach zwei Pech in Folge ist der nächste Anlauf mindestens Teilerfolg; der dritte Anlauf je Wissensziel ist immer mindestens Teilerfolg, ohne Deckel. | C2, C6; Pech-Garantie | max. Pech-Folge = 2 in allen 100.000 Zufallspartien |
| K-11 | Kosten: Pflichtzug 6 min (+2 gründlich), 2. und 3. Anlauf bzw. Umweg je 3 min, Erfolg −7 min (Zeitgewinn); Abstecher 7 min (Pech +3). Schlechtester Pflichtzug 6 + 2 + 3 + 3 = 14 min. | Budget-Ungleichung | 3 × 14 = 42 ≤ 45 (C8 Nr. 1a) |
| K-12 | Reserve-Regel: Ein Abstecher oder „gründlich“ nur, wenn danach Restzeit − 3 min (Pech-Zuschlag des Abstechers) ≥ Σ schlechteste Kosten aller offenen Pflichtzüge bleibt. Rundenschranke: Läuft die Uhr ab, gilt jede offene Untersuchung als Teilerfolg. | C2 | 0 Budgetüberschreitungen in 313.344 Läufen (Gier-Bot eingeschlossen) |
| K-13 | Kettensperre auf Entscheidungsebene: Eine Entscheidung öffnet, wenn alle Vorgänger ihrer Liste gespielt und abgeschlossen sind (Liste C2). Alle Abhängigkeiten liegen in früheren Runden. | C2 | 0 Kettenverletzungen |
| K-14 | **Lösbarkeit (würfelbezogen):** Beim Öffnen jeder Entscheidung ist der Faktenstand gleich dem Lauf ohne Würfel, in jedem Würfelstrom und jeder Besetzung; bei bestem Spiel ist jedes `fakt:`-Kettenglied aufgedeckt. Nach einer falschen Vorwahl fehlen Kanon-Fakten absichtlich (§7.7: „eine falsche Entscheidung deckt Wahres auf, das weniger hilft“) – das ist Kanon, nicht Würfel. | Kanon-Befund: alle 30 `fakt:`-Glieder entstehen nur aus der richtigen Option (Analyse `entscheidungen.json`) | Faktenstand ≠ Neutralwurf: 0 von 313.344; fehlende Glieder bei bestem Spiel: 0 |
| K-15 | **Wertung unantastbar (WÜ-4):** Punkte 0–9, Ende, Fakten, Restverdächtige, Gruppenwahl-Wertung, Bonus-Qualität, Rückblende, Schneiders Überleben hängen nur an den Wahlen. | C2 | Wertung ≠ Neutralwurf: 0 von 313.344; Punkte im Mittel 4,31–4,35 (= Zufallsraten 4,33) |
| K-16 | „Manchmal“: Anteil der Züge mit Gelingenswurf 38,5–38,7 % (alle Züge) bzw. 38,5–50,3 % (ohne Befragungen besetzter Rollen); je Runde ≥ 1 Wurf, nie jede Entscheidung. | C8 Nr. 3, 13 | Band 30–60 % in jeder Form und Besetzung |
| K-17 | Spürbarkeit: je Partie Median 2 Pech-Szenen und 3 Erfolge mit Zusatz; das untere Glücksquartil hat 27,5–28,3 % weniger Abstecher und 46–48 % weniger Zusatzfunde als das obere. Ein Abstecher-Erfolg öffnet einen Folge-Abstecher. | C8 Nr. 13 | ≥ 2 / ≥ 2 / ≥ 25 % / ≥ 25 % erfüllt |
| K-18 | Tempo: Gerätezeit je Runde Median 3,37 min (P95 3,88) in der Party, 5,72 min (P95 6,24) in Solo (dort mit NPC-Gesprächen). Abend Party (Schätzung mit Spanne): 10 Einrichtung + 4 Intro + 3 × (25 Gespräch + 3,4 Gerät + 5 Wahl + 2 Resümee) + 10 Finale ≈ 130 min (Spanne 120–145). Solo ≈ 45 min (40–60). | C7 | Gerätezeit gemessen im Modell; Abend als Lichtungsaufgabe mit L4-Zeitmodell |
| K-19 | Party an einem Gerät: hochkant, ≤ 3 Karten, Daumenzone, Tippflächen ≥ 48 dp; Rollenkarten und Gruppenwahl nur über den Weitergabe-Bildschirm (≤ 10 s); Würfel, Chancen und Szenen sind öffentlich und pfadgleich, nur der Fundtext unterscheidet sich. Stimmkreis (aus C): jede besetzte Rolle gibt je Runde eine verdeckte Hilfe-Zusage ab, die nur als Darstellung erscheint (kein Modifikator; die Liste in K-07 ist abschließend). | C7, Entwurf C | – |
| K-20 | Solo mit Bots: Mensch ist Detektiv; Bots spielen Pflichtgespräche als Sprechblasen; jedes Kettenglied ist vor der Anzeige erreichbar; Kooperation 70 % über eigenen Strom `bot:<salz>:<rolle>:<runde>`; der Täter-Bot sabotiert nur in der Gruppenwahl. | C7 | – |
| K-21 | WLAN: Host = Gerät des Detektivs, nur der Host würfelt; das Salz ist eine Zusage: jedes Gerät schickt erst sha256 seiner `Random.secure()`-Zahl, dann die Zahl; der Host mischt per FNV, zeigt vor dem ersten Zug sha256(salz) und deckt das Salz erst in der Auflösung auf; dann rechnet jeder Gast jeden Wurf aus Salz, Entscheidungs-Id und Anlauf nach („Wurf nicht nachvollziehbar“ bei Abweichung). So kann niemand Würfe vorab ausrechnen. | C9, WÜ-1, V-15 | Lichtungsaufgabe L7 (VM-Host + 3 VM-Gäste + 1 Browser-Gast, Probe M0 Frage 5: Schleife geht) |
| K-22 | Geheimnisschutz: `zustandFuer(spieler)` liefert nur die eigene Rolle; Pfad, Täter, Gruppenwahl-Qualität und Stimmenzahl erst in der Auflösung; kein Bot sieht mehr als seine Rolle; der Mitschnitt enthält vor dem Finale 0-mal Pfad, Täterkennung, Fall-Code oder daraus Berechnetes. | C7, WÜ-1 | Mitschnitt-Test im Nachtlauf |
| K-23 | Seed: `Rng(Rng.hashString('wuerfel:<salz>:<entscheidungsId|abstecherId>:<anlauf>'))`; die Id ist die der Entscheidung, also gleiche Zahl für jede Option. Nie laufende Wurfnummer, nie `FallCode.rng()`, nie `dart:math`. | WÜ-1 | – |
| K-24 | Nebenwertung „Seifenblasen-Bilanz“ (eigene Tafel nach der Auflösung, nie in der Endenmatrix): +1 je Lupe, Abstecher, übrige Marke und je 5 Restminuten; Titel wie „Glückspilz“ oder „Gespensterfreund“; auch Pech wird gefeiert. | Entwurf D | – |
| K-25 | Partie-Überschneidung (C9): Jaccard zweier Zufallspartien gleicher Besetzung Median 0,13 (Party) bzw. 0,40 (Solo) bei 8 Abstechern je Runde im Angebot. Schwelle (Annahme): Median ≤ 0,45; sinkt mit wachsendem Abstecher-Pool. | C9 | 1.000 Paare je Form × Besetzung |
| K-26 | Bot-Lösungsquote: zufällig wählender Detektiv-Bot im Mittel 4,33 Punkte (unverändert durch den Würfel). Zielband für einfache Detektiv-Bots (Annahme): richtige Anklage 25–60 %. | C9 | Punkte gemessen; Anklagequote im Nachtlauf mit `party_simulate` |

### Abweichungen von Anhang C (alle im ENTSCHEIDUNGSLOG)
1. Befragungen würfeln nie (C2 sah Würfe bei unbesetzten Rollen vor) – K-05.
2. Helfer-Fachgebiete sind kein Modifikator (C2 listete sie) – K-06.
3. Schwellen 9 / 7–8 / ≤ 6 statt 9 / 6–8 / ≤ 5, damit das Pech-Band nach Modifikatoren hält – K-07.
4. Lösbarkeit würfelbezogen definiert (Kanon-Befund) – K-14.
5. C6-Beispiele „Bogentür quietscht“ und „Rüstung klappert“ entfallen als Pech-Szenen: Die Bogentür trägt `spur_tuer_beschlag`, der Helm ist Bund-Versteck (Entwurf D).
6. Neutrale Bonus-Sätze und der Lacher 20:15 verlassen die Weißliste (Entwurf D: Bonus-Satz verriete die Qualität des Bonus-Hinweises, E-025; der Lacher trägt eine falsche Fährte). Kandidat neu: `spur_stirnlampe` (OFFENE FRAGE, BW0 prüft am Kanon).

## Teil 2 · Bindende Abschnitte C1–C9 (Startentwurf)
### C1 · Grundform „Karten mit Abstechern“ (empfohlener Start)

**Pflichtzüge**
- Jede der 9 Kanon-Entscheidungen (e1_1 … e3_3) wird ein **Pflichtzug** mit 2–3 Karten.
- Die Reihenfolge der Karten bestimmt `Spiel.optionen` (gemischt je Fall-Code).

**Szene und Bestätigung**
- Die gewählte Karte läuft als **sichtbare Szene** ab: Weg über A*, Pose, Handy-Licht, Fundkarte.
- Vor der Szene steht die Bestätigung „Das ist endgültig“ (aus dem F4-Entwurf).

**Abstecher**
- Zwischen den Pflichtzügen gibt es freiwillige **Abstecher** mit echten Wegen.
- Beispiele:
  - „In den Vorratsraum hinter der Theke gehen“
  - „Herrn Schneider einen Tee bringen“
  - „Tims Stirnlampe leihen“
  - „Wendeltreppe hinauf zum WC und wieder hinunter in den Keller“
  - „Seifenblasen pusten und nachdenken“
- Abstecher sind **nichtwertende Folgeentscheidungen**. Das ist die Hauptachse des Wachstums.

**Rundenuhr:** 45 Nachtminuten je Runde, das ist Spielzeit. Davon getrennt bleibt `rundendauerMinuten`, die Gesprächszeit am Tisch. Beide stehen getrennt im Schema.

**Kosten und Start**
- Pflichtkarten kosten pauschal, ohne Wegkosten. Grund: Mit Wegkosten holte ein Geiz-Bot 5–6 statt 4,33 Punkte; das ist eine räumliche Schlagseite.
- Die Runde beginnt am `geburtstagsplatz` (Ostsaal).

---

### C2 · Würfel „stark“ (bindend)

**Was „stark“ heißt (Nutzerwahl):**
> „Der Würfel entscheidet auch, ob eine Untersuchung gelingt. Misslingt sie, gibt es einen zweiten Anlauf oder einen Umweg; lösbar bleibt der Fall.“

**Wahl vor Wurf**
- Die Option steht mit „Das ist endgültig“ fest, **bevor** gewürfelt wird. Pech ändert die Option nie.
- `Spiel.waehle` wird je Kanon-Entscheidung genau **einmal** aufgerufen, mit dieser Option.

**Zwei Zustände**
- Die Würfelschicht führt `aufgedeckt` getrennt von `gewaehlt`.
- Vor dem Finale lesen Fundtexte, Karte, Resümee und Erzähler **nur** `aufgedeckt`. Das hält Kanonregel S-1 (nur Detektivwissen).

**Stufen**

| Stufe | Wirkung |
|---|---|
| Erfolg | Wissen + Zusatz aus der Weißliste + Zeitgewinn |
| Teilerfolg | Wissen |
| Pech | Das Wissen kommt **noch nicht**. Die Szene zeigt ein Missgeschick (C6). Es folgt ein **zweiter Anlauf** (+Bonus, kostet Nachtminuten) oder ein **Umweg**. |

**Umweg:** Er führt zur **selben Kanon-Quelle** (dieselbe Person, derselbe Gegenstand, derselbe Ort) über einen anderen Zugang, z. B. andere Tür, anderes Licht (Stirnlampe) oder späterer Zeitpunkt. Ein Helfer **begleitet oder leuchtet** nur. Nie berichtet eine Figur Wissen, das ihr der Kanon nicht gibt.

**Pech-Garantie (für jedes Spiel, nicht nur bestes Spiel)**
- Je Wissensziel zählen zweiter Anlauf und Umweg gemeinsam. Der **dritte Anlauf ist mindestens Teilerfolg**; das zeigt die Chancenanzeige vorher an.
- **Reserve-Regel:** Abstecher sperren, sobald die Restzeit die schlechtesten Kosten aller offenen Pflichtzüge nicht mehr deckt. Keine Kanon-Entscheidung verfällt je.
- **Budget-Ungleichung je Runde:** Σ der schlechtesten Kosten aller Pflichtzüge ≤ 45 Nachtminuten. M3 belegt sie mit Zahlen.
- **Rundenschranke:** Läuft die Uhr ab, gilt jede offene Untersuchung als Teilerfolg. Erst dann folgen Gruppenwahl und Resümee.
- **Kettensperre (pfadunabhängig, auf Entscheidungsebene):** Eine Kanon- oder Folgeentscheidung öffnet, sobald jede Vorgänger-Entscheidung ihrer Liste gespielt und ihr Anlauf abgeschlossen ist (Wissen aufgedeckt oder per Rundenschranke Teilerfolg). Welche Option gewählt wurde, spielt keine Rolle; nie öffnet eine Entscheidung nach einem pfadabhängigen Fakt. Die Liste ist die Vereinigung aller `fakt:`-Quellen aus `begruendung.*.kette` über alle 4 Pfade:
  - e2_1 ← e1_1, e1_2, e1_3
  - e2_2 ← e1_2
  - e2_3 ← e1_3
  - e3_1 ← alle sechs früheren
  - e3_2 ← e2_*
  - e3_3 ← e1_1, e2_1

**Wertung unantastbar (WÜ-4)**
- Der Würfel ändert nie: Kanon-Punkte (0–9), Ende, Fakten, gewählte Option, Restverdächtige, Qualität der Bonus-Hinweise, Gruppenwahl-Wertung, Rückblende, Schneiders Überleben.
- „Stark“ wirkt auf: Gelingen jedes Anlaufs, Nachtminuten, verfügbare Abstecher, Weißlisten-Zusatzwissen, Atmosphäre, Gags und eine **eigene Nebenwertung** (Seifenblasen-Marken, „Glücksbilanz“ in der Auflösung). Die Nebenwertung erscheint getrennt und geht nie in die Endenmatrix ein.
- Annahme A-03 (ANNAHMEN.md): Die Alternative „Würfel darf Kanon-Punkte kosten“ bricht F-06 und §7.7 und ist deshalb nicht Standard.

**Würfelart (Startwert, M3 stimmt ab)**
- 2W6 + Gesamtmodifikator. Gesamtmodifikator je Wurf = Summe aus Werkzeug, Helfer, „gründlich“ (+2) und Marke, danach begrenzt auf 0 bis +2. −1 nur, wenn M3 eine pfadgleiche Quelle festlegt.
- Startschwellen 9+ Erfolg, 6–8 Teilerfolg, ≤ 5 Pech. Damit liegt Pech bei +0 bei 10/36 ≈ 28 %.
- **Bänder (bindend):**
  - Züge mit Wurf über das Gelingen je Partie: 30–60 % („manchmal“), in jeder Besetzung 4–20, je Runde ≥ 1 Wurf, nie jede Entscheidung
  - Pech im ersten Anlauf: 20–35 %
  - „gründlich“ würfelt ebenfalls, mit +2 und höheren Kosten
- **Modifikatoren nur aus pfadgleichen Quellen:**
  - Weißlisten-Werkzeuge: Handy-Licht, Tims Stirnlampe, Tee vom Teekocher
  - Helfer-Fachgebiet aus der Besetzung, zum Beispiel:
    - Tim: Strom und Licht
    - Wojtek: Bogentür, Rüstung, Holz
    - Azra: Vitrine, Messing
    - Aylin: Geld und Belege
    - Hana: Kamin
    - Marek, Lejla, Damir: Buffet und Tee
    - Pawel, Emine, Can: Befragen
    - Zeynep: Wege
  - Seifenblasen-Marken: je Wurf höchstens 1 (+1), je Partie höchstens 3
- Kernrollen helfen **nur beim Befragen**. Helfer-Boni hängen nie daran, ob der Helfer Täter ist. Der Täter kann keinen Wurf sabotieren; Sabotage gibt es nur in der Gruppenwahl (G-1).
- Befragungen **besetzter** Rollen (ein Mensch am Tisch) würfeln nur über Tempo und Zusatz, nicht über das Gelingen.
- Pech-Ausgleich: nach zwei Pech in Folge (je Wissensziel) ist der nächste Wurf mindestens Teilerfolg; der dritte Anlauf je Wissensziel ist immer mindestens Teilerfolg, ohne Deckel. Je Wissensziel höchstens zwei Seifenblasen-Marken.

**Seed (WÜ-1, eine Formel)**
- `Rng(Rng.hashString('wuerfel:<salz>:<entscheidungsId|abstecherId>:<anlauf>'))`
- Nie eine laufende Wurfnummer (sonst „angeln“), nie `FallCode.rng()` (sonst Pfad-Korrelation).
- Nur der Host würfelt. Ein „Tischwurf“ ist nur Darstellung.

**Transparenz:** Vor dem Wurf zeigt die Karte die drei Chancen in Prozent und was jede Stufe bewirkt. Jeder Wurf wird protokolliert.

**Darstellung**
- Würfelbühne als Overlay mit eigener Skala; ein echter Würfel wäre bei Standardzoom kleiner als ein Pixel.
- Ein Holzwürfel rollt im Handy-Licht (FEINKORN-Physik nur als Darstellung, die Seiten werden auf das Host-Ergebnis umbenannt). Danach erscheint ein Stempel in Aktenoptik.
- Erfolg: ein Schwall Seifenblasen. Pech: Missgeschick-Pose (C6).

---

### C3 · Pfadgleichheit (WÜ-5, bindend)

**Gleich in allen 4 Pfaden** (bei gleichem, eingespeistem Würfelstrom, vor dem Finale):
- Kartenzustand
- angebotene Karten und Abstecher
- angezeigte Chancen und Modifikatoren
- Weg, Pose, Dauer, Licht, Teilchen und Klang jeder Aktion
- jede Pech-Szene

**Ausnahme:** Nur der **Fundtext** darf sich unterscheiden (`zeigt` bzw. `harmlos`).

**Weitere Pflichten**
- Die Chance korreliert nicht mit „Option richtig“ (|ρ| ≤ 0,1).
- Gags, Physik und Pech-Szenen berühren nie Spurenträger, Tatwerkzeug oder die vier Bund-Verstecke (Jacke, Brottasche, Eiskübel, Rüstungshelm).
- Test: `wuerfel_pfadgleich_test`.

---

### C4 · Weißliste der Zusatzinfos (vorläufig; M3 schreibt sie vollständig in den Anhang des Master-Prompts)

**Bedingungen:** pfadgleich (`pfade: alle` bzw. `entstehtWenn: immer`), nicht verborgen, keine Faktquelle, **kein Kettenglied**, kein Nebendelikt einer Kernperson, keine falsche Fährte.

**Kandidaten:**
- `b_baran_rufe`, `b_hana_wachs`, `b_serkan_tor`, `b_pawel_schneider`, `b_schneider_erinnerung`, `b_tim_gesicht`
- `spur_wachs_boden`, `spur_steckdose_verschmort`, `spur_laterne_unberuehrt`, `spur_torte`
- die drei Lacher (20:15, 21:00, 23:30)
- die neutralen Bonus-Sätze

**Herausgenommen**, weil Kettenglied: `b_marek_gesicht` (e2_1, e3_3), `b_selin_gesicht`, `b_wojtek_vorbei` (e3_1).

**Ausgeschlossen:**
- `b_zeynep_vorrat` (Faktquelle)
- `b_damir_*`, `b_emine_fatma_*`, `b_azra_olli_*`
- `b_wojtek_tuer` (verborgen)
- `spur_fasern_kapuze`

---

### C5 · „In den Keller gehen“ wörtlich (bindend)

1. **Intro-Rückblick (18:00, alle Pfade):** Das Geburtstagskind steigt mit den Gästen die **fünf Sandsteinstufen** hinab und betritt durch das **Außentor** den Keller (`zeitleiste.json` z_ankunft). Das ist die erste sichtbare Aktion des Abends. Danach blendet der Raum auf.
2. **Abstecher:** „Wendeltreppe hinauf zum WC und zurück hinunter in den Keller“. Der Abstecher ist pfadgleich, ohne Fund und ohne Hinweis auf Can (Can ist um 23:58–00:01 dort; `luege_can_toilette`).
3. **Raumwechsel im Gewölbe:**
   - Buffetsaal → Vorratsraum
   - → Durchgang → Kaminsaal
   - → Bogentür → Turmgang

**Verboten als neue Bereiche:** Schlosshof, Parkplatz, Stufen draußen als begehbarer Ort während der Ermittlung, Turm oberhalb des WC, Obergeschosse, tiefere Kellerebenen und jede neue Verbindung zwischen bestehenden Räumen.
- Begründung: Außentor und Hoftür sind seit 18:50 verschlossen, es gibt keinen Empfang, und die Alibis hängen an Wegen und Hörregeln.
- Neue Orte entstehen **nur innerhalb der 7 Räume**.
- Ein Blick nach draußen (Lichtschacht, Schlüsselloch) ist als Atmosphäre erlaubt.

---

### C6 · Pech- und Gag-Inhalte (bindend)

**Pech trifft nur Sachen, Licht und Zeit**
- Beispiele: Die Bogentür quietscht, Sibel zuckt zusammen; das Handy-Licht flackert; die Rüstung klappert; Wind treibt die Seifenblasen weg.
- **Verboten:**
  - Verletzungen, ein Sturz mit Aufprall, eine liegende Pose des Detektivs
  - alles an Herrn Schneiders Körper (er sitzt wach mit Kühlpack)
- Jedes Pech endet mit **Glück im Unglück**: einer Marke und einem pfadgleichen Satz aus der Weißliste.

**Auch im Pech verboten**
- hinausgehen, Hilfe von draußen
- die Notlaterne einschalten
- den Kerzenständer nehmen
- Kerzen anzünden, offene Flamme
- Gewalt spielbar zeigen

**Bild**
- keine Flaschen, Stielgläser, Fässer
- kein Rauch aus der Pfeife, nur runde, durchsichtige Seifenblasen
- keine roten Teilchen an Kerzenständer, Opferplatz oder Vorratsraum-Boden

---

### C7 · Spielformen (bindend)

**Party an einem Gerät**
- **Bedienung:** hochkant, Bedienung im Daumenbereich, Tippflächen ≥ 48 dp, höchstens 3 Karten zugleich.
- **Weitergabe:** Verdeckte Einzelansicht über einen Weitergabe-Bildschirm („Gib das Gerät an [Name]“ → Tippen zum Aufdecken → Verdecken). Weiterreichen dauert ≤ 10 s.
- **Beteiligung:**
  - Jede Rolle hat je Runde mindestens eine eigene sichtbare Handlung, z. B. die Gruppenwahl als Geste ihrer Figur oder einen Helfer-Ruf.
  - Wartezeit ohne eigene Handlung ≤ 10 min.
- **Dauer:** Abend im Median ≤ 150 min einschließlich Gespräche; Ermittlung am Gerät je Runde Median ≤ 6 min, P95 ≤ 10 min.
- **Pause:** Eine Pause hält Uhr, Wurf und Animation an.

**Solo mit Bots**
- **Wissen:** Jedes Kettenglied jeder Kanon- und Folgeentscheidung ist vor ihrer Anzeige über NPC-Gespräch, NPC-Karte oder Erzähler erreichbar. Test über alle Ketten × Besetzung 4–20.
- **Bots:** Kooperationsrate fest (Standard 70 %). Der Täter-Bot sabotiert nach G-1. Bot-Strom: `bot:<code>:<rolle>:<runde>`, nie der Würfelstrom.
- **Dauer:** 40–70 min.

**WLAN** über das vorhandene `room_host`, als `RaumSpiel`-Umsetzung
- **Rechnen:** Nur der Host rechnet und würfelt; Host ist das Gerät des Detektivs (Annahme A-07).
- **Verdecktes Wissen:**
  - `zustandFuer(spieler)` liefert nur, was diese Rolle wissen darf: das eigene Dossier, die Täterfassung nur an die Täterrolle.
  - Pfad, Täter, Gruppenwahl-Qualität und Stimmenzahl kommen erst in der Auflösung.
  - Mitschnitt-Test: Vor dem Finale enthält der Verkehr zu Unschuldigen 0-mal Pfad oder Täterkennung.
- **Dauer:** wie Party.
- **Abbrüche:**
  - Gast weg: nach 90 s vertritt ihn ein Bot; mit seinem Token kehrt er in dieselbe Rolle zurück.
  - Gastgeber weg: „Warte auf Gastgeber“. Der Gastgeber setzt aus dem Spielstand fort; die Gäste treten mit dem neuen Code bei.
- **Datenschutz:**
  - Gespeichert und gesendet werden nur selbst gewählte Spielnamen, keine Geräte-IDs; am Ende werden die Namen gelöscht.
  - Der Gastgeber kann Personen entfernen, und der Raum schließt nach der Partie.
  - Hinweis in der App: „Spielt im WLAN nur in einem Netz, dem ihr vertraut.“
- **Abnahme:** `RaumHost` läuft headless in der Dart-VM, dazu 3 Gäste als VM-Clients und 1 Browser-Gast über Playwright: ein voller Abend ohne Fehler. (Echte Handys gibt es im Container nicht; das steht in „Bis zum Store fehlt“.)

**Für alle drei Formen**
- **Fortsetzen:**
  - Spielstand = Fall-Code + Einstellungen + Protokoll der Eingaben und Würfe; das Fortsetzen spielt deterministisch nach.
  - Gespeichert wird nach jedem Zug in `shared_preferences` unter `schlosskeller_partie_v1` (Muster `PrefsSpielstand`).
  - Im Hintergrund pausiert die Szene.
  - Abnahme: 100 Partien je Form, Abbruch nach jedem Zug, das Fortsetzen ergibt dieselbe Prüfsumme.
- **Einstieg:**
  - geführter Probezug ≤ 3 min im Buffetsaal: eine Karte, ein Gang, ein Wurf mit Prozentanzeige, ein Pech mit zweitem Anlauf; überspringbar
  - Hinweiskarten je Mechanik
  - „So spielt ihr“ je Form
  - Ein Neuling-Bot schafft den Probezug in 100 % der Seeds.
- **Inventar:** Der Detektiv trägt nur pfadneutrale Werkzeuge: Handy-Licht, Seifenblasenpfeife, Funde aus der Weißliste. Nie Beweisstücke, nie den Kerzenständer (K-1).
- **Druckspiel:** Es bleibt die Kanon-1.0-Schicht ohne Würfel, wortgleich (F-10, F-14). Würfel, Abstecher und neue Texte gibt es nur in der App.

---

### C8 · Startkriterien für M3 (werden zu BK-Kriterien im Master-Prompt)

1. **Lösbarkeit (Beweis in drei Teilen):**
   - (a) **Monotonie, erschöpfend je Zug einzeln:** jede Ausgangsfolge (E, T, PE, PT, PPE, PPT …), jeweils mit zweitem Anlauf oder Umweg, bei sonst neutralen Würfen. Das Wissen am Rundenende ist gleich dem beim Neutralwurf.
   - (b) **Erschöpfend:** 768 Folgen × 4 Pfade × Besetzung 4–20 mit den Strömen „immer Pech“ und „immer Erfolg“.
   - (c) **Zusätzlich:** 10.000 Seeds je Pfad.

   Ergebnis: 100 % lösbar, 0 Sackgassen, Laufzeit ≤ 10 min. (Eine Gesamtaufzählung aller Würfelfolgen, ≈ 5·10¹¹ Partien, ist ausdrücklich **nicht** verlangt.)
2. **Wertung unantastbar:** `Spiel.punkte` und `Spiel.ende` sind gleich dem Lauf mit Neutralwürfeln, über 768 × 4 × (100 Ströme + „immer Pech“ + „immer Erfolg“): 100 %.
3. **„Manchmal“:**
   - Züge mit Wurf je Partie im Band 30–60 %
   - Pech im ersten Anlauf 20–35 %
   - längste Pech-Folge je Wissensziel ≤ 2
4. **Kostenneutralität:** Der Geiz-Bot holt im Mittel ≤ 4,8 Punkte und in keinem Pfad ≥ 7. |ρ(Kosten, richtig)| ≤ 0,2.
5. **Pfadgleichheit:** WÜ-5 (C3) mit 0 Verstößen.
6. **Entkopplung:** Andere Gruppenwahl-Stimmen ändern das Würfelprotokoll nie (100 %).
7. **Weißliste:** Die Restmenge ist mit allen Zusatzinfos dieselbe wie ohne (0 Verstöße).
8. **Zeitmaß:**
   - Szene je Zug: Median ≤ 12 s, P95 ≤ 20 s, in ≤ 1 s überspringbar
   - Spieldauern nach C7, gemessen mit 1.000 Bot-Partien je Form und Pfad
9. **Sichtbarkeit:** 100 % der Züge zeigen Weg > 0,5 m oder Herbitten plus eine Handlungspose. Im E2E-Foto steht der Detektiv ≤ 1,5 m vom Ziel.
10. **Determinismus:** gleicher Code + gleiches Eingabeskript ergibt 1.000-mal dasselbe Würfel- und Aktionsprotokoll, auf VM und Node.
11. **Inhalt:**
    - Textprüfer der Schicht 0 Treffer, einschließlich der Listen `gewalt` und `sperrliste`
    - Pfeife nur zusammen mit Seifenblasen
    - kein Baustein, in dem Herr Schneider stirbt oder neu verletzt wird
    - Bildregeln aus C6
12. **Bots:** 1.000 Bot-Partien je Pfad laufen ohne Eingriff bis zum Ende. Die Gruppenwahl-Bots erreichen für jede Rollenzahl von 4 bis 20 jede Qualität.
13. **Spürbarkeit (bindend, „stark“ heißt spürbar):** 10.000 Seeds je Form und Besetzung, gemessen bei 4, 12 und 20 und als Band gültig für jede Besetzung 4–20:
    - Würfe über das Gelingen in 30–60 % der Züge, **in jeder Besetzung** (Befragungen besetzter Rollen zählen nicht mit)
    - je Partie im Median ≥ 2 sichtbare Pech-Szenen und ≥ 2 Erfolge mit Zusatzfund
    - das untere Glücksquartil schafft im Mittel ≥ 25 % weniger Abstecher und ≥ 25 % weniger Zusatzfunde als das obere
    - Nr. 2 (Wertung unantastbar) gilt unverändert

### C9 · Nachtrag v4 (aus v3 übernommen)
- **WLAN-Nachrechnung:** Jeder Gast rechnet jeden Wurf aus Seed-Formel (WÜ-1) und Zugdaten nach und zeigt bei Abweichung „Wurf nicht nachvollziehbar“. Kein einzelnes Gerät kann einen Wurf beeinflussen.
- **Partie-Überschneidung:** Maß für Spieltiefe. Zwei Zufallspartien gleicher Personenzahl teilen höchstens einen in M2 festgelegten Anteil ihrer Szenenfolge (Jaccard über Szenen-IDs); gemessen über 1.000 Paare.
- **Bot-Lösungsquote:** Einfache Detektiv-Bots lösen jede Täter-Fassung in einem Zielband aus M2. Das Band ist Annahme; die Lösbarkeit selbst bleibt per Beweis (C8 Nr. 1) bei 100 %.

### Nachtrag M6 (Prüfrunde 2, Simulator `sim11`)
- Auftakt-Suche in Runde 1 und Reserve mit Pech-Zuschlag: 313.344 erschöpfende Läufe ohne Sackgasse, Kettenverletzung, Budgetüberschreitung, Wertungs- oder Faktenabweichung; je Partie hat jede Runde ≥ 1 Wurf (100 % in allen 10 Form × Besetzung).
- Wurfanteil erste Anläufe 42,8–43,4 %, streng 42,8–56,4 %; Pech im ersten Anlauf 32,2–34,0 %; längste Pech-Folge 2; unteres Glücksquartil 29,9–33,0 % weniger Abstecher, 42,5–46,2 % weniger Zusatzfunde. Diese Werte ersetzen die Zahlen in K-16 und K-17.
- Gewürfelt wird genau bei Suchen: Pflicht-, Folge-, Abstecher- und Auftakt-Entscheidungen mit Gegenstands-, Raum- oder Ortsziel; eine solche Entscheidung würfelt für alle ihre Optionen.
- Modifikatoren abschließend (K-07): Werkzeug +1, „gründlich“ +2, Marke +1, Deckel +2. Kein Nochmal-Bonus (K-10), kein Stimmkreis-Bonus (K-19), kein Helfer-Bonus (K-06).

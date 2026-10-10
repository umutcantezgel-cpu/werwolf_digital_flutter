# DESIGN-PROBE · Meta-Lauf BOLLWERK (M3, M6)

Zweck: Vor dem Nachtlauf zeigen, dass das Bildverfahren trägt, die Designmaße messen und ein blinder Paarvergleich (D2) eine Aufwertung erkennt. Die Aufwertungsrichtungen sind nur als Probe gebaut, in Wegwerf-Worktrees auf `finalisierung-schlosskeller@5c83242`. Am Spielcode des Repos wurde nichts geändert.

## 1. Verfahren
- **Bauen:** Web-Build des Partymodus (`/party`).
- **Fotografieren:** Playwright mit fester Uhr (`page.clock`, 00:30 Spielzeit) in drei Ansichten: 393×852, 852×393 und 1180×820, Pixeldichte 2.
  - Werkzeug: `proben/foto_probe.mjs` mit Bewegungsstreifen über 6 Zeitpunkte.
  - Jeder Lauf hatte 0 fremde Netzaufrufe und 0 Konsolenfehler.
- **Gleichheit:** Zwei Läufe derselben SHA sind nicht bytegleich, gelten aber als gleich bei ΔE-Mittel ≤ 1,0 je Bild (`proben/bildgleich.py`, E-M1-02). Gemessen wurden 0,005–0,100.
- **Designmaße:** `proben/designmass.py` liefert Palettenanteil, Luminanz, Vignette und Kanten. Die Basis steht in `bestand/designmass-basis.tsv`.
- **Richtungen:**
  - **R1** „weicher Nebelsaum + warmes Handylicht“: Lichtkegel des Handys mit warmem Rand, Nebelsaum an der Sichtgrenze.
  - **R2** „Staub im Licht“: Staubteilchen ≤ 3 px im Lichtkegel.
- **Bögen:**
  - `bilder/meta/m3-design-vorher-r1-r2-buffetsaal.jpg`
  - `m3-streifen-r2-buffetsaal.jpg`
  - `m3-design-runde2-ostsaal.jpg`
  - `m3-design-runde2-ausschnitt.jpg`

## 2. D2-Blindprobe (M6, 3 Haiku-Richter, 12 Paare)
- **Aufbau:** 2 Räume (Buffetsaal, Ostsaal) × 3 Ansichten × 2 Richtungen ergibt 12 Paare. Die Seiten A/B sind per Seed gemischt, die Dateinamen sind Hashes. Die Lösung lag nur im Scratchpad (`geheim/`).
- **Fragen an die Richter:** Welche Seite ist aufgewertet? Wie sicher (1–5)? Welche Seite ist besser? Stört die Aufwertung?

| Richtung | Treffer „aufgewertet“ | davon bei Sicherheit ≥ 3 | „nachher besser“ | „vorher besser“ | „gleich“ | „stört“ |
|---|---|---|---|---|---|---|
| R1 Nebelsaum + Handylicht | 12/18 | 4/4 | 6 | 0 | 12 | 0 |
| R2 Staub im Licht | 13/18 | 8/8 | 5 | 4 | 9 | 3 |

**Lesart**
- **Beide zu schwach dosiert:** Wenn ein Richter sicher war, lag er immer richtig (12/12). Insgesamt lagen die Treffer aber nur bei 25/36, nahe am Raten. Der Nachtlauf muss die Wirkung deutlich stärker machen, um Z-14 (≥ 85 % „nachher besser“) zu erreichen.
- **R1:** nie schlechter, nie störend, aber kaum sichtbar.
- **R2:** besser sichtbar, aber 4-mal schlechter und 3-mal störend. Die Teilchen lesen sich als Funken; dieses Stilrisiko war schon in M3 sichtbar.
- **Folge für A-01:** Die Reihenfolge R1 vor R2 bleibt. R1 wird in BW3 kräftiger dosiert. R2 nur ohne funkenartige Teilchen.

**Schwäche der Probe (Befund, eingearbeitet)**
- **Nebenkanäle:** Mehrere Paare teilten dasselbe Vorher-Bild. Ein Richter hat bei unsicheren Paaren die größere Datei als „aufgewertet“ gewählt. Dadurch sind die Trefferzahlen etwas zu hoch.
- **Gegenmaßnahme:** A-8 Nachtrag M6 und Z-14 verlangen jetzt:
  - eigene, zufällig benannte Kopien je Paar
  - gleiche Kodierung und gleiche Dateigröße, ohne Metadaten
  - jedes Paar in beiden Reihenfolgen
  - Urteile mit Sicherheit 1 zählen nicht als Treffer

## 3. Eichung D3 (M3)
- **D3a:** Fehlerbilder wurden 18/18 erkannt, Fehlalarme 0/6.
- **D3b:** Stilbrüche wurden 18/18 erkannt, Fehlalarme 0/6.
- **Eichsatz:** `proben/eichsatz.py` mit 12 Fehlerbildern, 6 einwandfreien Bildern und 6 Überladen-Bildern.

## 4. Offene Punkte für den Nachtlauf
- **L-5:** Im Querformat verdeckt die Karte die Szene. Bis das entschieden ist, zählt die Queransicht in Z-14 nur als Bericht.
- **S6 und Lichtquellen:** Beide Maße stehen nur als Startwerte da. BW0 eicht sie am Eichsatz (A-8 Nachtrag M6).
- **Look-Anker:** Er wird nur über den Weg aus Z-17 erneuert.

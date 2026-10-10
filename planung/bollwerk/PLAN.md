# PLAN · Meta-Lauf BOLLWERK (M4)

Alle Zahlen stammen aus Messungen dieses Laufs (LAGEBILD, FABRIKPROBE, SPIELKERN, MESSBASIS-PROGNOSE) oder sind als Schätzung mit Spanne markiert.

## 1. Mengengerüst je Achse (Planziel F, Basis = Prognose an K)

| Achse | Basis (Prognose) | Ziel | Zuwachs | Wer baut | Art der Einheit |
|---|---|---|---|---|---|
| X1 Entscheidungen inkl. Folge/Abstecher | 9 | 135 (15×) | +126 | Haiku (Variantenbauer), Opus integriert | JSON in `content/runden/schlosskeller/` |
| X2 Spieltexte | 1.581 (Spanne bis 1.900) | 6 × Basis (≈ 9.500–11.400) | ≈ +8.000–9.500 | Haiku | Texte ≥ 8 Wörter in der Schicht (≈ 4 je Variante) |
| X3 Orte in den 7 Räumen | 43 | 172 (4×) | +129 | Haiku (Daten), Opus (Raumgraph-Prüfung) | Teilorte mit Koordinate, nur innerhalb der Räume |
| X4 Gags | Mindestbasis 10 (Kanon 3) | 400 (40×) | +397 | Haiku | Gag-Datensatz mit Aktion und Folge |
| X6 Aktionsarten mit Animation | Mindestbasis 5 (Bestand 1) | 45 (9×) | +44 | Opus (Stufe 3, Maler) + Haiku (Posen-Daten, Klang) | Code + Golden + Pose |
| X5 Weißlisten-Zusatzfunde (Pflichtziel) | 0 | ≥ 14 | +14 | Opus | verdrahtet, pfadgleich |
| Pflichtziele D1 | – | Ruhe-Animationen 22/22, Posen ≥ 24, Mimik ≥ 4 je Figur, Requisiten ≥ 30/34, Leben-Effekte ≥ 6, Übergänge ≥ 5, Spielformen 3/3 | – | Opus + Haiku | Code |

**Anteil Opus/Haiku (Schätzung):** Haiku ≈ 90 % der Agentenaufrufe (Inhalt, Urteil, Prüfung), Opus-Agenten ≈ 3 % (Stufe-3-Pakete, Stichprobe großer Wellen, Ersatzrichter), Hauptsitzung Opus: Kernsysteme, Integration, Abnahme.

## 2. Kapazität

| Glied | Messung | Wert je Nacht (9 h Arbeitszeit, Schätzung 8–10 h) |
|---|---|---|
| Parallelität | 12 Hintergrund-Agenten ohne Fehler (M0, M3) | 12 gleichzeitig → ≈ 108 Agentenstunden |
| Maschine | Last ≤ 1,2 bei 12 lesenden Agenten; Bauen und Fotografieren nur im Schwerlast-Slot (1 zugleich) | Code-Aufträge ≤ 2 gleichzeitig (Leichtlast-Plätze) |
| Durchsatz | 22 gültige Einheiten je Agentenstunde (R2, Spanne 15–30) | 108 × 22 ≈ 2.400 (Spanne 1.600–3.200) |
| Kontingent | 61 Tsd. Tokens je gültiger Einheit (Spanne 45–90 Tsd.); Meta-Lauf verbrauchte ≈ 9,2 Mio. Agenten-Tokens in 1,7 h ohne Limit | **Schätzung:** 25–60 Mio. Agenten-Tokens je Limitfenster; × 0,8 = 20–48 Mio. → 330–790 Einheiten je Fenster; bei zwei Fenstern je Nacht **660–1.580 Einheiten** |
| **Kapazität** | min(Parallelität, Maschine, Kontingent × 0,8) | **≈ 1.000 gültige Einheiten je Nacht** (Spanne 660–1.580), davon ≈ 85 % Inhalt, 15 % Prüfung |

Bis B-02 gilt die halbe Wellengröße (STEUERUNG S-1): 6 gleichzeitig.

## 3. Zielfaktor F

**F = 10** (Planziel U = 10,52 aus f = 15, 6, 4, 40, 9, Marge 5 % gegen Basisschwankung; vorher 30 Gags-Faktor mit 1,9 % Marge, Befund M6-L07). Begründung: U ≥ 10 ist mit allen fünf Indexachsen nahe am realistischen Deckel erreichbar; X3 (Orte, Deckel ≈ 4×) und X6 (Aktionsarten mit Code, Deckel ≈ 9–12×) begrenzen nach oben. Ein Streckziel bis U ≈ 18 setzt X1 40× voraus und verletzt die 40-%-Regel; es ist deshalb nicht geplant. **Realistische Prognose: U 8,5–11** nach 5–7 Hauptlauf-Nächten.

## 4. Zwischenziele je Nacht (gültige Einheiten, nach B-02; N0 = Vorlauf)

| Nacht | Phasen | X1 | X2 | X3 | X4 | X6 | sonst |
|---|---|---|---|---|---|---|---|
| N0 (Vorlauf, je Nacht) | V | (Vorrat in `content/runden/`, zählt erst nach B-02) | 600 | 20 | 40 | 0 | Torwerkzeug, Würfelkern, Simulator in Dart, Durchstich-Probe |
| N1 | BW0, BW1 | +10 | +300 | +10 | +20 | +3 | Basis an K, Durchstich im echten Spiel |
| N2 | BW2, BW3 | +30 | +1.700 | +30 | +60 | +12 | Regelkern, Posen, Leben, 2 Aufwertungsrichtungen |
| N3 | BW4 | +25 | +1.800 | +25 | +60 | +10 | Party, Solo, WLAN, App-Start, Fortsetzen |
| N4 | BW5 | +35 | +2.200 | +35 | +80 | +11 | Breite bis U ≥ 10 |
| N5 | BW5/BW6 | +26 | +1.700 | +29 | +77 | +8 | Rest bis Planziel, Design D2 |
| N6 | BW7 | – | – | – | – | – | Härtung, `nacht`-Tor, Leistung |
| N7 | BW8 | – | – | – | – | – | MAIN-REIFE |
| **Summe** | | **+126** | **+7.700 (+ Vorlauf)** | **+129** | **+297 (Ziel +397: +100 in N4/N5)** | **+44** | |

**Zählweise:** X2 zählt Texte (≈ 4 je Einheit); in Einheiten (X1 + X3 + X4 + X6 + X2 ÷ 4) liegen die Nächte bei N1 ≈ 118, N2 ≈ 557, N3 ≈ 570, N4 ≈ 711 (+ 50 Gags), N5 ≈ 565 (+ 50 Gags), also unter der Kapazitätsmitte 1.000. Der Tokenrahmen rechnet in Einheiten (Master-Prompt §10). BW0 rechnet die Zwischenziele an der eingefrorenen Basis an K neu (A-8 §1.1). Liegt die Messung nach Nacht 1 unter dem Bedarf, geht „U ≥ 10 mit N Nächten oder kleineres U“ als Frage nach FUER-DEN-NUTZER.

Verfehlt eine Nacht ihr Ziel um mehr als 20 %, plant der Lauf neu (höchstens zweimal), danach Eintrag in FUER-DEN-NUTZER. Nach Nacht 7 ab B-02 mit U < 10: NACHT-ENDE mit Restbedarf im Morgenbericht.

## 5. Wellenplan und kritischer Pfad

1. **Vorlauf (vor B-02, eigene Pfade):** Torwerkzeug `tool/bollwerk/bollwerk.dart` mit Rot-Probe → Würfelkern und Simulator in `packages/mordakte_core/lib/src/runden/` (Port von `proben/wuerfel_sim.py`) → Vorlauf-Durchstich (Abstecher-Karte → Pose → Würfelbühne, als Bild) → Vorrat für `content/runden/`.
2. **Durchstich (N1):** eine vollständige Runde in allen drei Formen mit wenig Inhalt; volles Tor.
3. **Breite (N2–N5):** Inhaltswellen abwechselnd mit Design-Wellen (A-10).
4. **Kritischer Pfad:** B-02 → BW0 (Basis an K) → Würfelkern → Spielformen (WLAN) → Breite → D2 → MAIN-REIFE. Der WLAN-Strang und die Aktionsarten (X6, Code) sind die längsten Ketten.
5. **Wellengröße:** 12 gleichzeitige Agenten (bis B-02: 6); je Agent 10–25 Varianten; Richter mit Stapeln bis 100 Bausteine; jede Welle passt in ein Limitfenster (≤ 60 min Agentenzeit je Welle).

## 6. Betriebsort und Dauer
Cloud-Kindsitzungen des Leitstands, eine Generation je Nacht (Fenster ≤ 12 h). Prognose: **1–2 Vorlauf-Nächte + 6–7 Hauptlauf-Nächte**; Ende abhängig von B-02 (Finalisierung erwartet 10.10. Vormittag bis 11.10. Abend).

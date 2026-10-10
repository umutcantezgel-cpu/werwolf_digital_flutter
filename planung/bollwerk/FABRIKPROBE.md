# FABRIKPROBE · Meta-Lauf BOLLWERK (M3)

Echte Probe der Variantenfabrik mit Haiku 5.5 hinter der Prüfmauer, 09.10.2026 22:06–23:00 UTC. Rohdaten im Scratchpad; Kennzahlen und Werkzeuge hier und unter `proben/`.

## 1. Slots und Slot-Arten

| Slot | Achse | Art | Denkstufe | Varianten | Runde |
|---|---|---|---|---|---|
| F-AB1 | X1 | Abstecher Vorratsraum R1 | max | 12 | 1 |
| F-AB2 | X1 | Abstecher Kaminsaal/Turmgang R2 | medium | 12 | 1 |
| F-FE1 | X1 | Folgeentscheidung mit sichtbarer Aktion | max | 12 | 1 |
| F-TX1 | X2 | Erzähler-Bausteine je Würfelstufe | medium | 12 | 1 |
| F-GA1 | X4 | Gags Kaminsaal | max | 12 | 1 |
| F-AK1 | X6 | neue Aktionsarten (Pose, Dauer, Licht, Klang) | max | 12 | 1 |
| F-EL1 | X6 | Bildschirmelement: Entscheidungskarte mit Würfelanzeige | medium | 12 | 1 |
| F2-AB | X1 | Abstecher (Briefing geschärft) | max | 12 | 2 |
| F2-FE | X1 | Folgeentscheidung (Briefing geschärft) | max | 12 | 2 |
| F2-GA | X4 | Gags (Briefing geschärft) | medium | 12 | 2 |
| FUELL | – | 20 eingestreute Füllstücke (F5-Eichung, vom Meta-Lauf geschrieben) | – | 20 | 1 und 2 |

## 2. Ringe, Befehle, Ergebnisse

| Ring | Befehl (Probe) | Runde 1 | Runde 2 |
|---|---|---|---|
| 0 Werkzeug-Audit | `bash planung/bollwerk/proben/werkzeug_audit.sh` | 2 Verstöße in 14 Agenten der Lagewelle (lesende MCP-Werkzeuge über ToolSearch) | **0 Verstöße in 32 Agenten** seit „nie ToolSearch“ im Auftrag |
| 1 Form | `python3 -I proben/fabrik_ringe.py <kanon> <textregeln.json> <jsonl…>` | 72/72 | 36/36 |
| 2 Regeln | dto. (Verbotslisten aus `textregeln.json`, Sperrliste A4.6, Gewalt, Bildregeln, Satzlänge, Siezen, Pfeife) | 71/72 (1 × „Notlaterne“) | 36/36 |
| 3 Kanon und Logik | dto. (Kennungen gegen Kanon, Ort↔Raum, Weißliste, Tatzeit-Uhrzeiten, „neue Spur“) | 70/72 (2 × neue Spur, davon 1 erst durch Ring 8 entdeckt und dann als Regel nachgerüstet) | 36/36 |
| 4 Technik | Daten: Ringe 1–3; Bildschirmelement: `python3 -I proben/element_ring4.py` (Tippflächen ≥ 48 dp, unteres Drittel, Palette, Kontrast ≥ 4,5:1, Symbol + Wort) | Element 12/12 | – |
| 5 Spiel | statisch (Raum gesetzt) + Simulator: Abstecher erscheinen bei 8 Angeboten je Runde in jeder Partie, Folge-Abstecher nach Erfolg | 72/72 | 36/36 |
| 6 Neuheit | Wort-3-Gramm-Jaccard ≥ 0,5 = Dublette; Tupel (Art, Raum, Ort, Aktionsart, Zusatz, Wurf) eindeutig je Slot | 0 Dubletten | 0 Dubletten |
| 7 Qualität | 3 Haiku-Richter (Linsen Kanon, Ton, Spaß) blind; angenommen bei ≥ 2 Stimmen ≥ 7; bei Spreizung > 2 zusätzlich 2 Richter (Gesamt), Median zählt | **12/68 = 18 %** | **21/36 = 58 %** (33 nach Mehrheit, 3 nach Median aus 5) |
| 7a F5-Eichung | 20 Füllstücke im Stapel, die Ringe 1–6 bestehen | **20/20 abgelehnt** | **20/20 abgelehnt** |
| 8 Stichprobe | Opus (Meta-Lauf), 20 Varianten per Seed `sha256("M3-F1|4598b06")[:8]` | 1 Kanon-Fehler (F-AB2-03 erfindet einen Kratzer an der Bogentür) → Welle zurück, Ring 3 erweitert | – |
| 9 Mutanten | nur beschrieben (kein neuer Code in der Probe) | – | – |

Bildgremien (D3) siehe DESIGN-PROBE.md: D3a 18/18 bei 0/6 Fehlalarm, D3b 18/18 erkannt bei 0/6 Fehlalarm.

## 3. Was die Annahmequote hob (Nachschärfen, Runde 1 → 2)
1. Pflicht „spürbare Folge“ für jede Variante, auch ohne Wurf; bei Wahlen je Option eine andere Folge.
2. Abschnitt „Zugschicht“ im Kern-Auszug A-3 (Marken, Zeit, Folge-Abstecher sind gültige Folgen) – der Kanon-Richter hatte „Marke nicht in A-3“ abgewertet.
3. Drei Vorbildsätze, die Richter mit 9 bewertet hatten.
4. Verbot neuer Spuren an Kanon-Orten im Briefing und in Ring 3.

Fehlerbilder Runde 1 (Gründe der Richter): „ohne Wirkung/Folge“ (häufigster Grund), „nur Frage ohne Ausgang“, „blass, ohne Bild“, „Hinweisrisiko“; Aktionsarten (F-AK1) 0/12 – die Linse „Spaß“ passt nicht auf Pose-Beschreibungen; **Aktionsarten brauchen eine eigene Rubrik** (Lesbarkeit der Pose in 2–4 Schlüsselbildern, Stiltreue, Wiederverwendbarkeit).

## 4. Kennzahlen

| Größe | Wert | Quelle |
|---|---|---|
| Gleichzeitige Hintergrund-Agenten | 12 ohne Fehler (Welle M0-1); 10 und 6–8 in M2/M3 ohne Fehler; Messung bei 4: Welle M2-1 (4 Entwürfe + 1 Messer) | `bestand/agenten-m0.tsv` |
| Dauer Variantenbauer (12 Varianten) | Median 405 s (R1), 509 s (R2) | dto. |
| Dauer Richter (56–88 Bausteine) | Median 338–420 s | dto. |
| Tokens je Agent (Werkzeugbericht `subagent_tokens`) | Bauer 159–189 Tsd., Richter 153–197 Tsd., Kundschafter max 339 Tsd., Messer medium 81 Tsd., Opus-Entwurf 443 Tsd. | dto. |
| Annahmequote Ring 7 je Denkstufe | R1: max 6/45 = 13 %, medium 6/23 = 26 %; R2: max 15/24 = 63 %, medium 6/12 = 50 % | §2 |
| Gültige Einheiten je Agentenstunde (R2, Bauer + Richter + Ringe) | 21 Einheiten ÷ (20,8 + 36,4) Agentenminuten = **22 je Agentenstunde** (Spanne 15–30) | §2 |
| Tokens je gültiger Einheit (R2) | (494 + 790) Tsd. ÷ 21 = **≈ 61 Tsd.** (Spanne 45–90 Tsd.) | §2 |
| Speicher und Last | Last ≤ 1,2 bei 12 lesenden Agenten; Web-Build 79–358 s (unter Agentenlast länger); Platte 27 GB frei | `uptime`, `df` |
| Nachbesserungsbedarf | 1 Briefing-Runde hob die Quote um 40 Prozentpunkte | §3 |

**Folgerung für den Nachtlauf:** Die Richter sind der Engpass (5 Richter je 36–88 Bausteine). Größere Stapel je Richter (bis 100 Bausteine) und Richter nur auf medium für Ton/Form sind Hebel; Kanon bleibt auf max.

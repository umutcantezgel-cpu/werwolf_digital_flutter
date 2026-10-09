<!-- Burgstadt HD · erzeugt aus dem freigegebenen Gesamtplan v4 (Kern v1.0) · Quelle der Wahrheit ab jetzt diese Datei -->

# Burgstadt HD – ZIELFORMEL

**Zielzustand:**
- Stufe „scharf“ zeigt die Welt in doppelter linearer Auflösung gegenüber „mittel“ (360 Zeilen auf 720p/1080p, je nach Gerät etwa 240 bis 432), mit Palette v2 und 64 Texel/m.
- Jedes der 160 Häuser ist nach `typ` mit Bauteilen modelliert.
- Alle Innen-Bereiche aus `baueWelt()` sind gestaltet (Ausgang laut Z-04: 59, genaue Zählung in P0-PROBE-01), dazu 3 Außenbereiche.
- Figuren und Porträts sind in HD, die Oberfläche ist überarbeitet.
- Die automatische Wahl hält mindestens 30 gelieferte Bilder/s, wo das Gerät es schafft.
- Layout und Spieltexte sind unverändert, die Nachtlauf-Abnahme ist nicht schlechter, und Z-03 ist neu grün.
- Z-12 bleibt eine Lücke des Nachtlaufs, die nicht von HD kommt (E-040).

### Definition of Done (`tool/hd_abnahme.dart` rechnet alles Messbare nach)

| ID | Kriterium | Prüfmethode | Schwelle |
|---|---|---|---|
| HZ-01 | **Auflösung** | `spiel_test` (18 Größen aus K-011 inkl. Schwellen und Obergrenze); Belegfotos `--qualitaet scharf` mit `pixel_pruef` | 18/18 Größen exakt; Obergrenze greift; Puffergrößen von „mittel“ und „sparsam“ identisch zum Ausgang; UI bei „scharf“ = UI bei „mittel“; Block- und Palettentest 100 % in 6 Vierteln, 12 Fall-Orten, Gangnetz, Burg, 8 Bildschirmen und Tutorial, beide Formate |
| HZ-02 | **Palette und Licht v2** | `pixel_test` v2; Wächter Name → RGB; Migrationsbelege (Commits nach P1-OPUS-03 und P1-OPUS-05); `banding.dart` | 160 Farben; Wächter 100 % identisch; beide Migrationsbelege RGB-gleich zum Ausgang; Lichttabelle ≥ 12/12/6; Aufbauzeit nach L-05 festgelegt; Banding-Sprung ≤ 1 Stufe, ≥ 10 Stufen im Profil |
| HZ-03 | **Dichte und Flimmern** | UV-Dichte-Test; `flimmer.dart` (Ausgang mit alter Mip-Formel) | alle Welt-Meshes 64 ± 1 %; Figuren bei „scharf“ 64; Flimmerwert ≤ 50 % des Ausgangs |
| HZ-04 | **95 Texturen** (36 Bestand neu, 7 Spuren in HD, 52 neu; Liste im Feinplan P2) | `texturen_test` v2; Kontaktbögen Mip 0/1; 3 geeichte Sichtprüfer | 95/95 bestehen; 0 offene Befunde zu Rauschen, Moiré oder Stilbruch |
| HZ-05 | **Gebäude** | `bau_test`; Kontaktbögen | 26 Bauteile; 20/20 Profile; 160/160 Häuser mit ≥ 8 Bauteilarten |
| HZ-06 | **9 Sonderbauten** (Uhrturm, Kirchenburg, Mauer und Zinnen, 3 Tore, Wehrgang, Brunnen, Treppe, Burg außen, Gärten) | Checklisten (P3-PRUEF-02); Sichtprüfer | ≥ 6 Elemente je Bau, 9/9 |
| HZ-07 | **Innenräume:** alle 18 Bestandsformen + 4 Burgformen mit eigener Geometrie; je Innen-Bereich Formenvielfalt und Wandaufbau; Kanon-Regeln | `formen_test`; `raum_test` (über `baueWelt()`); formbasierter Kanon-Test; 3 Sichtprüfer | Rückfall 0; alle Innen-Bereiche (Ausgang 59) mit ≥ 4 verschiedenen Deko-Formen und Wandaufbau; 3 Außenbereiche mit ≥ 4 Deko-Formen; 0 Verstöße gegen Positiv- und Verbotsliste; Sichturteil im Median ≥ 4 von 5 |
| HZ-08 | **Licht und Atmosphäre:** Licht perspektivkorrekt, Flackern, Himmel v2, Kulisse, Hochformat, Uhrturm, Fledermäuse | Renderer-Test; Flacker-Metrik; Himmelsmessung; Uhrturm-Test | Flackern an ≥ 90 % der Kerzen- und Ofenquellen; isolierte Einzelpixel im Himmel ≤ 2 % (ohne Sterne); Himmel hochkant ≤ 40 %; Zeiger gleich Spielzeit |
| HZ-09 | **Figuren HD:** 66 Karten in 2 Dichten | `sprite_pruef` v2 und Tests; 3 Sichtprüfer im A-605-Format, mit Zusatzzeile „Figurenstand <hash>“ (Hash über `karten.json`, `rollen.json`, `teile_*.json`, `figuren_hd/`, `figur/*.dart`); `hd_abnahme` prüft den Figurenstand, `tool/abnahme.dart` den Kartenstand | 66/66 fehlerfrei; Augen ≥ 2×2 bei 64; ≥ 2 von 3 Berichten „Paare: 0 · Verstöße: 0“ am aktuellen Karten- und Figurenstand; Z-03 grün |
| HZ-10 | **Porträts HD:** 128×128, 4 Ausdrücke, eingebunden | `portraet_test` v2; Belegfotos | 66/66; Unterschied ≥ 3 % der Gesichtspixel; 0 Verstöße gegen K9 §8; Gespräch und Fallakte belegt |
| HZ-11 | **Oberfläche:** 8 Bildschirme (Erkundung, Fallakte, Hauptmenü, Lagerunde, Optionen, Stadtkarte, WLAN/Lobby, Anklage) und Tutorial überarbeitet; Texte unverändert | `ui_test`; `stadtkarte_test` v2; 3 Sichtprüfer | 0 Überlappungen und 0 abgeschnittene Blasen in 1.000 Lagen; 0 Kollisionen von Beschriftung und Linie; 9/9 belegt |
| HZ-12 | **Leistung:** Ausgangswerte aus P0, Zielwerte im Durchstich bestätigt | `szenen_mess` (VM, Spielszene); `geraete.js` (gelieferte Bilder/s); `qualitaet_test`; `leistung.dart` | (a) Kosten je Weltpixel ≥ 35 % unter Ausgang (Zielwert; nach Messung von Überdeckung und Divisionsanteil im Durchstich bestätigt oder per ÄNDERUNG angepasst); (b) Desktop „scharf“ ≥ 30 Bilder/s; (c) „auto“ wählt nie eine Stufe unter 30, wenn eine ≥ 30 existiert, und Handy-Profile mit „auto“ sind ≥ Ausgang „mittel“; (d) Nachladespitze ×4 ≤ 50 ms; (e) Speicherwachstum ≤ 10 %, RSS ≤ Ausgang + 120 MB; (f) Budget je Ansicht: Meshes ≤ 300, Dreiecke „scharf“ ≤ Wert aus E-014, „mittel“ ≤ 14.000 |
| HZ-13 | **Spiel unverändert** | `layout_pruefsumme`; `git diff` der textPfade; Erkundungsbots; `tool/abnahme.dart` | Prüfsumme gleich Ausgang; textPfade ohne Diff; 134/134 Türen, 0 Steckenbleiber; Nachtlauf ≥ Ausgang (12/14) und Z-03 neu grün (Ziel 13/14); Z-03 zählt für HZ-13 nur, wenn `hd_abnahme` den Figurenstand der A-605-Berichte bestätigt. Z-12 ist im Ausgang offen und bleibt eine Lücke des Nachtlaufs, die nicht von HD kommt (E-040) |
| HZ-14 | **Belege und Übergabe** | Galerie-Artifact; `alle_tests.sh` voll; `hd/ABSCHLUSSBERICHT.md` | ≥ 1 Vorher/Nachher-Paar je HZ, 6 Viertel, 12 Fall-Orte, ≥ 1 Gerätefoto; Gesamtlauf grün; Dokumente aktuell |

**Änderungen an bestehenden Prüfregeln** (mit FREIGABE angenommen, je mit Diff in `hd/belege/format_diff.md`):

| Prüfregel | Änderung |
|---|---|
| `texturen_test` (A-302a v2) | Größen 64/128; ≤ 8 von 16 Stufen statt ≤ 5 von 8; Anzahl aus dem Register; Grünregel mit `>>4` |
| `spiel_test` | Gerade-k-Invariante nur für „sparsam“ und „mittel“ |
| `FORMAT-FIGUREN` v2 | zwei Dichten |
| Figur-Tests (`portraet_test`, `sprite_pruef`, `figur_test`) | Schwellen relativ zur Dichte |
| `teile_*_test` | Augenzählung je Dichte |
| `pixel_test`, `fledermaeuse_test`, `stadtkarte_test` | Palettenbindungen v2 |
| Z-13-Liste | um den Arbeitsbranch erweitert |

`karten_test` behält seine Schwellen, weil der Vergleicher auf dem 32er-Backen arbeitet.

### Mengengerüst

| Bereich | Menge |
|---|---|
| Engine | 12 Kernbausteine; 7 Prüfwerkzeuge (Kontaktbogen, Flimmern, Banding, Szenenmessung, Layout-Prüfsumme, `hd_abnahme`, `hd_commit`) |
| Texturen | 95 |
| Gebäude | 26 Bauteile, 20 Bauprofile, 9 Sonderbauten, LOD in 3 Stufen |
| Innenräume | 22 Formen neu gezeichnet (18 Bestandsformen + 4 Burgformen), 14 Deko-Formen, 4 Wandaufbau-Gruppen, Ausstattung in 51 Dateien (42 Vorlagen, 5 Burgräume, Gangnetz, 3 Außenbereiche), wirksam in allen Innen-Bereichen aus `baueWelt()` |
| Licht und Atmosphäre | 12 Bausteine |
| Figuren und Porträts | 66 Karten × 2 Dichten; 66 × 4 Porträts |
| Oberfläche | 12 Bausteine |
| Galerie | ≥ 1 Paar je HZ, 6 Viertel, 12 Fall-Orte |

### Kapazitätsrechnung
- **Pakete:** 306, davon 29 auf Stufe 3 (das mache ich selbst) und 277 für Haiku.
- **Rechnerisch:** 277 / (4 Plätze × 3 Schichten × 3 Pakete = 36 je Tag) = 7,7 Tage; mit 20 % Puffer ≈ 9,2 Tage.
- **Abhängigkeitsgraph:** Gepackt mit höchstens 12 Haiku- und 2 Opus-Paketen je Schicht ergibt er **33 Schichten = 11 Produktionstage** (T1/S1 bis T11/S3). Der Durchstich ist das Tor vor der Massenproduktion; Opus ist in T1–T4 der Engpass. Kritischer Pfad: 24 Pakete in Folge (P0-OPUS-01 → … → P9-OPUS-03).
- **Puffer:**
  - Im Plan sind 119 Haiku-Plätze frei (43 % von 277, mehr als die geforderten 20 %), vor allem in T1–T2, T4 und T9–T11. Sie gehen an REP-Pakete (Reparaturen) und den Vorrat.
  - T12 kommt als Puffertag für Opus-Übernahmen dazu.
  - **Planfrist: 12 Tage.** Ein Tag ist ein Produktionszyklus.

**Zielabstand** „a von 14“ steht in jeder Statuszeile.

**Abschlussregel:** Fertig erst bei „HD-ZIEL ERREICHT“ aus `hd_abnahme` mit belegten Sichtprüfungen. Absenkungen nur mit deiner Zustimmung.

**Zielsatz:**
> „Burgstadt HD ist fertig, wenn die Stufe ‚scharf‘ die Welt in doppelter linearer Auflösung (360 Zeilen auf 720p/1080p) mit 160 Farben und 64 Texel/m zeigt, 95 Texturen das Stilblatt v2 ohne Rauschen und Moiré erfüllen, alle 160 Häuser nach Typ mit ≥ 8 Bauteilarten und alle Innen-Bereiche der Stadt (Ausgang 59) mit eigenen Möbelformen, ≥ 4 Deko-Formen und Wandaufbau gestaltet sind, Figuren (96×160) und Porträts (128×128) in HD die Sichtprüfung bestehen, die Oberfläche fehlerfrei ist, die automatische Wahl mindestens 30 gelieferte Bilder/s hält, Layout und Spieltexte unverändert sind, die Nachtlauf-Abnahme nicht schlechter ist und `tool/hd_abnahme.dart` HZ-01 bis HZ-14 bestätigt.“

---

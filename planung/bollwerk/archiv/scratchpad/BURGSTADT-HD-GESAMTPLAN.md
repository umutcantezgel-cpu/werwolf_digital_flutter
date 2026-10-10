STAND · Kern v1.0-Entwurf (Plan v4 nach L0-Runde 3, Schleife abgeschlossen) · Phase 0 von 9 · Tag 0 · Schicht – · Zielabstand 0 von 14 Kriterien · Pakete 0 von 306 · Plätze belegt 0 von 4 · nächster Schritt: FREIGABE

# Burgstadt HD – Gesamtplan v4 (zur FREIGABE)

## Kontext
- **Auftrag:** alle bestehenden Designs und die Modellierung schärfen, Gebäude und Räumlichkeiten in hoher Pixelauflösung aufwerten, mit deutlichem Feinschliff und mehr Detailtiefe.
- **Gegenstand:** Laut Sichtung ist das die **Burgstadt Schartenfels** auf `origin/nachtlauf/burgstadt` (`72df36b`): ein Ich-Perspektive-Krimi in 2,5D-Pixelgrafik mit eigenem Dart-Software-Rasterer.
- **Ist-Stand:**
  - Welt 320×180, 32 Texel/m, 64 Farben, 36 Rausch-Texturen
  - Häuser als Quader mit Satteldach; Räume mit etwa 7 Möbeln je Vorlage, die meist Quader sind
  - Figuren 48×80, Porträts 64×64 (im Spiel ungenutzt)
- **Deine Festlegungen:**
  - Pixel-Konzept als 2.5D aufwerten und erweitern; Außenhüllen und Kulisse.
  - Möbel, Licht, Figuren, Porträts und Oberfläche werden mit aufgewertet.
  - Qualitätsstufe „scharf“ mit automatischer Wahl.
  - Palette mit 10 Rampen × 16 Stufen.
  - Gearbeitet wird auf dem Stand der Burgstadt, die Nachtlauf-Abnahme wird **mitgeführt**.
  - Jedes erzeugte Bild zeige ich sofort im Chat.
- **Plan-Schleife L0:**
  - Runde 1: 5 Gegenprüfer (Haiku), 59 Befunde.
  - Runde 2: 3 Gegenprüfer, 13 offene bzw. neue Befunde, davon 6 schwer.
  - Runde 3: 2 Gegenprüfer, nur schwere Befunde gesucht; 5 gefunden.
  - Alle belegten Befunde sind eingearbeitet, siehe „Änderungen aus der Gegenprüfung“ am Ende.

---

## STATION B – KERN v1.0 (wird in P0 als `hd/KERN.md` geschrieben)

**K-001 Nordstern:** Die Burgstadt sieht aus wie ein handgemachtes HD-Pixel-Spiel: doppelt so scharf, bis in jede Fassade und jeden Raum gestaltet, und spielt sich genau wie vorher.

**K-002 Das Projekt in fünf Sätzen** (wortgleich in jedem Paket):
> 1. Burgstadt Schartenfels ist ein nächtlicher Ich-Perspektive-Krimi in 2,5D-Pixelgrafik, gerendert von einem eigenen Dart-Software-Rasterer mit Palettenpuffer.
> 2. Das Projekt „Burgstadt HD“ verdoppelt die Pixelauflösung (Stufe „scharf“ mit doppelter linearer Auflösung, auf 720p/1080p 360 Zeilen, dazu 64 Texel pro Meter) und erweitert die Palette auf 10 Rampen × 16 Stufen, ohne den Pixelstil aufzugeben.
> 3. Gebäude und Räume bekommen echte Modellierung – Laibungen, Simse, Läden, Gauben, Schornsteine, Lauben, eigene Möbelformen und Wandausstattung – und gestaltete Pixeltexturen statt Rauschen.
> 4. Figuren, Porträts, Licht, Himmel und Oberfläche ziehen auf dieselbe Pixeldichte und Farbtiefe nach, und eine automatische Qualitätswahl hält die Bildrate im Budget.
> 5. Kartenlayout, Kollision, Kanon, Spielregeln und alle bestehenden Prüfungen bleiben gültig; jede Änderung ist deterministisch, im Code erzeugt und mit Bildbeleg nachgewiesen.

**K-003 Zielgruppe:**
- Spielgruppen von 4 bis 20 Personen (Handy hoch und quer, Tablet, Web, Desktop). Sie brauchen Lesbarkeit, Stimmung und eine flüssige Bildrate.
- Du als Spielleitung brauchst vorzeigbare Bilder und Stabilität.

**K-004 Leitprinzipien:**
- **P1 Pixel bleibt Pixel:** Abtastung nearest, keine Glättung, jedes Pixel aus der Palette, ganzzahlige Vergrößerung.
- **P2 Silhouette durch Geometrie, Oberfläche durch Textur.**
- **P3 Dichte:**
  - Welt 64 Texel/m.
  - Figuren 64 Texel/m bei „scharf“, sonst 32.
  - Welt- und Figurendichte sind getrennte Größen.
  - Jede Textur muss auch in Mip 1 (≙ 32 Texel/m) gut lesbar sein.
- **P4 Determinismus:** Für Details kommt der Zufall nur aus `hashTeil(objektId, teil)`, nie aus dem Zufallsstrom des Stadtgenerators. Die Layout-Prüfsumme wacht darüber.
- **P5 Spiel unverändert:** Kachelkarten, Kollision, Marken, Türen, Stationen und Texte bleiben. Ausstattung ist reine Darstellung, blockiert nicht und hat keine Texte.
- **P6 Belegpflicht:** Jedes Teil bekommt einen Kontaktbogen, jede Phase Belegfotos. Jedes Bild geht sofort an dich.
- **P7 Budget vor Schönheit:** LOD, automatische Wahl und gemessene Grenzen; kein Detail ohne Messung.

**K-005 Rahmen:**
- Technik: Flutter 3.47.6, Dart 3.13; die Pakete `pixel_engine`, `burgstadt_core` und `burgstadt_spiel` sind reines Dart. Plattformen: Android, iOS, Web.
- **Container:**
  - 4 Kerne, 15 GB.
  - Flutter wird nach `/opt/flutter` geladen; die Werkzeuge erwarten diesen Pfad, `build.sh` nutzt einen anderen. Der Download-Host ist erreichbar.
  - Chromium liegt unter `/opt/pw-browsers`.
- **Branch und Commits:**
  - Arbeitsbranch `claude/pensive-gates-ajtp7x`, vorgespult auf `origin/nachtlauf/burgstadt` (0 eigene Commits; `d92a675` ist Vorfahr).
  - Commits über das neue `tool/hd_commit.sh`:
    - Lauf `alle_tests.sh schnell` (ohne Bindestriche)
    - Pfadliste statt `git add -A`
    - Push `HEAD:claude/pensive-gates-ajtp7x`, der Exit-Code wird geprüft
  - Kein PR ohne deinen Auftrag.
- **Nachtlauf-Abnahme (deine Entscheidung „Mitführen“):**
  - **N-HD-01:** Die Z-13-Liste in `tool/abnahme.dart` bekommt genau eine Zeile dazu, unseren Arbeitsbranch, mit Begründung.
  - **N-HD-02:** HD-Sichtprüferberichte kommen als **neue** Dateien nach `nachtlauf/auftraege/A-605` im dortigen Format (`ERGEBNIS · Paare: N · Verstöße: M · Karten <hash10>`).
  - Sonst ändern wir nichts in `nachtlauf/`.
- **Unantastbare Pfade (`textPfade` aus Z-12):** `packages/burgstadt_core/data`, `packages/burgstadt_spiel/data/texte`, `packages/pixel_engine/data/figuren`, `nachtlauf/kanon` und `krimidinner/…/10_kanon`.
  - Sie bleiben ohne Unterschied zum Stand des zuletzt eingemergten Nachtlaufs (`git merge-base HEAD origin/nachtlauf/burgstadt`).
  - `hd_commit.sh` prüft das vor jedem Commit, `hd_abnahme` zum Schluss.
  - Die Beschriftungen der Qualitätsstufen stehen im Dart-Code (`optionen_bildschirm.dart`), nicht im textPfad.

**K-006 Nicht-Ziele:**
- keine neuen Mechaniken, Fälle oder Spieltexte, keine Kanon-Änderung
- keine Glättung, keine Bilddateien als Spiel-Assets (PNG-Belege sind erlaubt), keine Shader oder GPU-Pfade
- kein Umbau von `lib/game`
- keine neuen Lichtquellen in der Oberstadt (Strom aus)

**K-007 Glossar:**

| Begriff | Bedeutung |
|---|---|
| Welt-Puffer / UI-Puffer | Palettenindex-Bilder der Welt bzw. der Oberfläche |
| kWelt / kUi | ganzzahlige Vergrößerungsfaktoren |
| Rampe / Stufe | Farbton bzw. Helligkeit; v2: 10 × 16 |
| tpp | Texel pro Bildpixel |
| Bauteil, Bauprofil, Form, Deko | Modellierungsbausteine; Haustyp-Regeln; Möbelgeometrie; Ausstattungsgeometrie |
| Ausstattung | darstellende Daten je Bereich in `burgstadt_spiel/data/ausstattung/` |
| Bereich | eine Karte |
| Kachel | 0,5 m |
| Kontaktbogen | Probe-Bild aller Varianten eines Teils (Mip 0 und Mip 1) |
| Belegfoto | Headless-Render der Engine |
| Gerätefoto | Browserlauf über `geraete.js` |
| Durchstich | erste vollständige HD-Kette |
| Sichtprüfer | Prüfer, der Bilder ansieht (Eichlauf zuerst) |
| gelieferte Bilder/s | Welt-Bilder, die tatsächlich ankommen (nicht die requestAnimationFrame-Aufrufe der Seite) |

**K-008 Stilblatt v2 (Muster als lauffähige Dateien aus P1-OPUS-12):**
- **Texturen:**
  - 64×64 (1 m) oder 128×128 (2 m); Spuren 32/64.
  - Je Textur höchstens 8 von 16 Stufen, nur aus den Material-Rampen.
  - Streupixel höchstens 8 %, keine Rauschflächen.
  - Fugen 1–2 Stufen dunkler als der Körper, nie die dunkelste Stufe.
  - Lichtkante oben und links, Schattenkante unten und rechts; kachelbar; Abwechslung über Varianten.
  - In Mip 1 lesbar.
- **Grünregel bleibt** (E-025): Grün nur in `wiese`, `dachBiberschwanzMoos` und `bruchsteinMauer`. Keine neue grüne Textur; Türkis ist blauseitig.
- **Farben der Viertel** (siebenbürgisch):

| Viertel | Farben |
|---|---|
| Markt | Ocker, Altrosa, Taubenblau |
| Handwerk | Sandstein, Fachwerk |
| Kirchhügel | Kalkweiß, Grau |
| Untere Stadt | Türkis, Creme |
| Mauerviertel und Burgberg | Bruch- und Quaderstein |

- **Bauteilmaße:** Laibung 0,15 m; Sims 0,06 × 0,08 m; Laden 0,45 × 1,1 m; Traufe 0,35 m; Ortgang 0,15 m; Fledermausgaube 0,9 × 0,35 m; Schornstein 0,5 × 0,5 m, 1,0 m über First; Sockel 0,6 m.
- **Vorsprünge:** unter 2,3 m höchstens 0,10 m und nie in Tür- oder Wegkacheln; darüber bis 0,6 m.
- **Licht (Kanon: Strom in der Oberstadt aus):**
  - Kein elektrisches Licht; Laternen sind dunkel.
  - Erlaubt: Kerzenfenster, Öfen, Handylicht, Mond, Notleuchten laut Daten, Lichter von Silberhau im Tal.

**K-009 Feste Maße:** Kachel 0,5 m, Tür 2,2 m, Stockwerk 3,0 m, Fenster 0,9 × 1,1 m, Augenhöhe 1,62 m, Sichtfeld 62°, Kollisionsradius 0,22 m, Seed 1752.

**K-010 Palette v2:**
- Index = Rampe·16 + Stufe (Rampe 0–9, Stufe 0–15); 255 = transparent.
- **Alte Farben:** Eine alte Farbe (r, s) liegt exakt auf der neuen Stufe 2s+1. Stufe 2s ist die OKLab-Mitte zwischen der alten Stufe s−1 und s; Stufe 0 ist eine tiefere Variante.
- **Neue Rampen:** 8 Altrosa, 9 Türkis.
- **Code-Konvention:**
  - `Ramp.at(r, s)` behält die 8er-Bedeutung (→ 2s+1); neu ist `Ramp.at16(r, s)`.
  - `Pal.*`-Konstanten werden aus `Ramp.at` erzeugt, nicht als Zahlen gepflegt.
  - `blickFilter` arbeitet mit Schwelle 160.
  - Die Lichttabelle verwendet keine Shifts.
- **`Pal.*`-Konstanten:** generierte Literale; `const` bleibt erhalten, der Wächter prüft Name → RGB.
- **Migrationsbeleg statt Dauer-Kompatibilitätsmodus (E-035):**
  - P1-OPUS-03 stellt auf Palette v2 um und nutzt eine Übergangs-Lichttabelle 8×8×4 mit Suche nur über die 64 Altfarben. Ergebnis: alle Belegfotos RGB-identisch zum Ausgang.
  - P1-OPUS-05 stellt die Dichte um: 64, Bestandstexturen texelverdoppelt, Mip-Cap 4. Ergebnis: weiter RGB-identisch.
  - Beide Commits werden festgehalten. Erst danach ändern Licht v2 und Mip v2 das Bild bewusst.

**K-011 Schnittstellen v2:**
- **Skalierung:**
  - „scharf“ übernimmt das UI-Raster von „mittel“ (`kUi` aus dem heutigen Algorithmus) und setzt `kWelt = kUi`.
  - Die Welt ist damit genau 2× so fein wie bei „mittel“ (linear), die Oberfläche ist identisch zu „mittel“.
  - Sprünge gibt es nur dort, wo auch „mittel“ springt (480/481, 864/865, 1234/1235).
  - **Obergrenze:** „scharf“ gilt nur bei kUi ≥ 2 und höchstens 380.000 Weltpixeln; sonst ist „scharf“ = „mittel“.
  - „sparsam“ und „mittel“ bleiben unverändert (gerades k, kUi = k/2).
  - Nachgerechnete Testgrößen:

| Bildschirm | Welt „scharf“ |
|---|---|
| 1280×720 | 640×360 |
| 1920×1080 | 640×360 |
| 2400×1080 | 800×360 |
| 1080×2400 | 360×800 |
| 2401×1081 | 801×361 |
| 828×1792 | 414×896 |
| 1170×2532 | 390×844 |
| 1440×3200 | 360×800 |
| 1280×500 | 640×250 |
| 1280×481 | 640×241 |
| 1536×864 | 768×432 |
| 1536×865 | 512×289 |
| 2194×1234 | 732×412 |
| 2196×1235 | 549×309 |
| 1179×2556 | 393×852 |
| 1284×2778 | 321×695 |
| 1280×480 | = mittel (Obergrenze) |
| 1280×400 | = mittel (Obergrenze) |

  - Die Kosten sind genau 4× „mittel“; was das Gerät nicht trägt, fängt `auto` ab.
- **Qualitätsstufen:**
  - `Qualitaet {sparsam, mittel, scharf, auto}`.
  - „hoch“ entfällt; ein gespeichertes „hoch“ wird zu `auto`.
  - Bis P1-OPUS-10 gilt `auto` = mittel; dann wird `auto` Standard und wählt zur Laufzeit eine konkrete Stufe.
- **Mip:**
  - tpp = Dichte·z/focal; lv = 0 bei tpp < s, sonst ⌊log2(tpp/s)⌋ + 1.
  - Start mit **s = 2**, das entspricht dem Ausgang. Eine andere Schwelle nur nach Flimmermessung.
  - Für den Boden gilt die Anisotropie je Spanne; alle Stufen werden genutzt.
- **`hashTeil`:** `int hashTeil(String id, int teil)`, dart2js-sicher (16-Bit-Teilprodukte wie `_imul` in `mordakte_core`), mit Golden-Werten für VM und Web.
- **Dichte:** `kDichteWelt = 64` und `kDichteFigur` (32/64) sind getrennte Konstanten; der Baker nutzt `kDichteFigur`.
- **Register nach Name** (nicht nach Position):
  - `kit/texturen/<name>.dart` und `kit/werkzeug.dart` (öffentlich: Lcg, Tex, steine, planken)
  - `bau/teile/`, `bau/profile/`, `bau/formen/`
  - `hashTeil(id, teil)`
  - Die Namen im Enum `TexturId` bleiben die Namensquelle (Regex-Tests); einen Eintrag ergänze ich bei der Integration.
- **Ausstattung (E-036):**
  - Eigene Liste am `Bereich`, nie in `karte`, `dinge` oder `_index`.
  - Neues Feld `vorlage` (der Generator überschreibt heute die Vorlagen-ID), Code in `burgstadt_core/lib`.
  - Dateien `burgstadt_spiel/data/ausstattung/<vorlage|bereich>.json`: 42 Vorlagen, 5 Burgräume, Gangnetz, 3 Außenbereiche.
  - Schema ohne Namen, Texte und Lichtfelder.
  - Anker nur an Wand oder Decke, auf blockierenden Möbeln oder flach (≤ 0,02 m); nie auf Tür-, Stations- oder Markenkacheln.
  - Test: `karte`, `dinge`, `_index`, `begehbar()` und Lichter sind identisch vorher und nachher.
- **Figuren:** HD-Figurendetails liegen in `pixel_engine/data/figuren_hd/`, nur Geometrie, keine Texte.

**K-012 Annahmen:**
- **A1:** Der Nachtlauf bekommt eventuell weitere Commits; Merge vor jedem Tagesabschluss.
- **A2:** Haiku-Sichtprüfer bewerten Bilder verlässlich. Das wird in P0 geeicht; bei einer Trefferquote unter 80 % gibt es Opus-Stichproben und Strukturmessung.
- **A3:** Headless-Zahlen im Web sind eine Näherung für Geräte.
- **A4:** Die Werte aus dem Durchstich tragen die Zielwerte von HZ-12.

**K-013 Kanon-Bildregeln:**
- **Positivliste je Raumart für alle Räume** (P0-KUND-04).
  - Quellen: K9 §8, K1 LISTE-GEGENSTÄNDE und LISTE-ORTE (Ortsbindung, z. B. Punschkessel nur im Kamin-Gewölbe, Holztruhe nur am Turmfuß), M-18/M-23, ANPASSUNG und die bestehenden Testlisten.
  - Für die Oberstadt, das Gangnetz und die Wohnhäuser gilt „nur Farbe“: nie Ort eines Hinweises oder eines lösungsrelevanten Gegenstands.
- **Verboten als neue Ausstattung:**
  - Taler, Schlüssel und Schlüsselbund, Kerzenständer (freistehend), Kerzenleuchter außerhalb des Kamin-Gewölbes, Lampe, Taschen- oder Stablampe, Batterie, Laken und Leinen, Zettel, Wanderstiefel, Ruß
  - neue Rüstungen, neue Lichtquellen
- **Zeit:** Uhren haben überall ein Zifferblatt ohne Zeiger. Der Uhrturm zeigt die Spielzeit (Abgleich mit ANPASSUNG STADT-05).
- **Bestand:**
  - Die Vitrine bleibt ohne Taler-Sockel.
  - Die Rüstung „Kunibert“ bekommt HD nur mit ihren Kanon-Merkmalen: verbogener Panzerhandschuh, Visier, kein sichtbarer Schlüsselbund (E-038).
  - Kerzenleuchter gibt es als neue Ausstattung **nur im Kamin-Gewölbe** (deine Wahl, E-037). Sie sind mehrarmig an Wandhaltern, nicht aufnehmbar und klar anders als der Tatwaffen-Kerzenständer; ihre Flammen flackern, einen eigenen Lichtpunkt haben sie nicht. Der Kanon-Gegenprüfer prüft die Unterscheidbarkeit.
- Die Lichtregel gilt für alle Bereiche; Bestandslichter (Burg-Kamin, Punschkessel, Geleucht) stehen auf einer Ausnahmeliste.

**K-014 Entscheidungslog:** siehe unten (E-001 bis E-034).

---

## STATION C – ZIELFORMEL

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

## STATION D – NEBELKARTE (Wirkung × Unsicherheit, je 1–3)

| ID | Gegenstand | W×U | Lichtung / Gegenmaßnahme |
|---|---|---|---|
| N-01 | Bildrate bei 4-facher Pixelzahl (Rechnung: 4 × 0,65 = 2,6-fache Bildkosten) | 9 | P0-AUTOR-04 und P0-PROBE-02/03 (Ausgang in der Spielszene, gelieferte Bilder/s); P1-OPUS-07/08; Go/No-Go mit drei Stimmen nach dem Durchstich. Rückfall: „scharf“ nur dort, wo „auto“ es trägt, und HZ-12 per ÄNDERUNG |
| N-02 | Flutter-Installation | 4 | P0-OPUS-01 (Pfad `/opt/flutter`, Host erreichbar) |
| N-03 | Nachtlauf läuft weiter | 6 | Fetch vor jeder Schicht, Merge vor jedem Tagesabschluss; textPfade und `nachtlauf/` gelten in deren Fassung |
| N-04 | Palettenlayout verstreut | 6 | P0-KUND-01 als Regex-Audit mit Pflichtliste; Migrationsbelege in P1-OPUS-03 und P1-OPUS-05 |
| N-05 | Aufbau der Lichttabelle im Web (22 Mio. Schritte) | 6 | P1-OPUS-04 misst; einmal statisch bauen; Rückfall: Zeilen bei Bedarf berechnen oder Binärdaten |
| N-06 | Speicher und Backspitze der Figuren (1,6 MB je Figur, ×4 je Backschritt) | 6 | P6-ANALYST-01 **vor** P6-OPUS-01; Backen in Zeilenbändern; LRU; HD nur bei „scharf“ |
| N-07 | Stilbruch zwischen vielen Agenten | 6 | Muster-Dateien (P1-OPUS-12), Varianten, Kontaktbögen, 3 Sichtprüfer |
| N-08 | Varianz der Sichtprüfer | 6 | Eichlauf P0-SICHT; 3 Stimmen; Vergleicher auf 32er-Backen |
| N-09 | Z-13 und Commit-Weg | gelöst | N-HD-01 und `hd_commit.sh` (P0-OPUS-03) |
| N-18 | Bauteil-Mesh-Kosten erst spät sichtbar | 6 | `fenster v1` vorläufig im Durchstich, L-07 im Durchstich gemessen, vor E-014 |
| N-19 | Hash-Abweichung VM/Web (Sterne, Details) | 4 | `hashTeil` dart2js-sicher; Himmel v2 nutzt `hashTeil` |

**Lichtungen:**

| ID | Gegenstand | Pakete |
|---|---|---|
| L-01 | Flutter | P0-OPUS-01 |
| L-02 | Z-13 und Commit-Weg | P0-KUND-03, P0-OPUS-03 |
| L-03 | Leistung Ausgang und Optimierung | P0-AUTOR-04, P0-PROBE-02/03, P1-OPUS-07/08 |
| L-04 | Paletten-Audit | P0-KUND-01 |
| L-05 | Aufbauzeit der Lichttabelle | P1-OPUS-04 |
| L-06 | Figurenbacken | P6-ANALYST-01 |
| L-07 | Mesh- und Dreieckskosten | P1-OPUS-09 und Durchstich |
| N-10 | Layout-Verschiebung | 6 | Prüfsumme über `baueWelt()` und Zahl der Zufallsaufrufe (P0-AUTOR-01), läuft in jedem Schnelllauf |
| N-11 | Moiré trotz 64 Texel/m (das Verhältnis tpp bleibt gleich) | 6 | Mip-Formel mit Anisotropie (P1-OPUS-06), Flimmermessung gegen Ausgang |
| N-12 | 4 Kerne | 4 | voller Testlauf nur an Toren; je Schicht nur `schnell` |
| N-13 | Haiku-Werkzeugkontext | 4 | Werkzeugkasten und Register (P1-OPUS-01), Muster-Dateien (P1-OPUS-12) |
| N-14 | Mesh- und Dreiecksbudget | 6 | Messung L-07 (P1-OPUS-09); LOD und ein Mesh je Haus (P3-OPUS-02) **vor** den Bauteilen |
| N-15 | Kanon-Konflikte durch Ausstattung (falsche Hinweise) | 6 | Positiv- und Verbotsliste (P0-KUND-04), Kanon-Test, Kanon-Blick der Sichtprüfer, Gegenprüfer |
| N-16 | Z-12 oder textPfade versehentlich berührt | 6 | Ausstattung und HD-Figurendaten liegen außerhalb der textPfade; Diff-Prüfung in `hd_abnahme` |
| N-17 | Browserlauf `geraete.js` im Container | 4 | P0-PROBE-03 |

**Vorab-Scheitern (Top 5):**

| Nr. | Ursache | Frühwarnung | Gegenmaßnahme |
|---|---|---|---|
| 1 | „scharf“ zu langsam | Durchstich Desktop < 30 Bilder/s | Optimierungen P1-OPUS-07/08; Go/No-Go; Vorrat V-01 (Isolate-Bänder nativ) |
| 2 | Stilbruch | > 2 Befunde je Schicht | Muster schärfen (L5); Varianten; Opus-Stichprobe |
| 3 | Nachtlauf-Prüfungen rot | `schnell` rot | nur grün committen; Integration je Schicht; Rückbau |
| 4 | Merge-Konflikte | neue Nachtlauf-Commits | täglicher Merge; keine Arbeit in deren Dateien |
| 5 | Reparaturquote > 30 % | Fehlerstatistik | Pakete teilen; Briefing verbessern; Opus übernimmt nach 2 Runden |

---

## STATION E – MEILENSTEIN-LEITER
Die Schichten stammen aus dem Graphen; die Phasen überlappen sich.

| Phase | Ziel | Phasentor (prüfbar) | HZ | Schichten |
|---|---|---|---|---|
| P0 Fundament | Werkzeuge, Ausgangsmessung, Audits, Eichlauf, Kern | Flutter läuft; Ausgang eingefroren und protokolliert (12/14); Ausgangsbilder und -werte; Eichlauf ausgewertet | 13, 14 | T1/S1–T2/S1 |
| P1 Engine-HD und Durchstich | Skalierung, Palette, Licht, Dichte, Mip, Leistung, Register, Auto-Wahl | **Durchstich** in „scharf“ (Marktviertel, Museum, R03) an dich; Migrationsbelege; Durchstich (Pipeline-Probe) an dich; Gegenprüfer; Go/No-Go mit 3 Stimmen (T4/S2) = Tor vor P2, P3 und P4-Ausstattung; E-014 | 01, 02, 03, 12 | T2/S1–T4/S2 |
| P2 Material | 95 Texturen | `texturen_test` v2, 4 Prüfer, 3 Sichtprüfer, Gegenprüfer | 04 | T4/S3–T8/S1 |
| P3 Gebäude | 26 Bauteile, 20 Profile, 9 Sonderbauten, LOD | `bau_test`, Checklisten, Viertel-Belegfotos (nach dem Texturen-Tor); Bauteile nach ihren Texturen | 05, 06 | T4/S3–T8/S3 |
| P4 Innenräume | 22 Formen, 14 Deko-Formen, Wandaufbau, 51 Ausstattungsdateien | `formen_test`, `raum_test`, formbasierter Kanon-Test, Sichtprüfer | 07 | T2/S3–T9/S1 |
| P5 Licht und Atmosphäre | Flackern (mit Option aus), Himmel, Kulisse, Hochformat, Uhrturm, Fledermäuse | Banding-, Himmels- und Flackermessung; 3 Sichtprüfer; Gegenprüfer | 02, 08 | T3/S2–T9/S1 |
| P6 Figuren und Porträts | zwei Dichten, Gesicht, LRU, Porträt 128, Einbindung | Sichtprüfung A-605 (mit Figurenstand), Z-03 grün | 09, 10 | T4/S1–T9/S2 |
| P7 Oberfläche | 8 Bildschirme + Tutorial (Texte unverändert) | `ui_test`, 3 Sichtprüfer, Gegenprüfer, `geraete.js` | 11 | T2/S2–T9/S2 |
| P8 Leistung und Feinschliff | Profiling, Auto-Wahl final, 0 offene Sichtbefunde | `leistung.dart`, Drossellauf, Rundgang mit 3 Stimmen | 12 | T9/S3–T10/S2 |
| P9 Abnahme | Vollauf, Nachtlauf-Abnahme, Galerie, Bericht | HD-ZIEL ERREICHT | alle | T10/S3–T11/S3 |

- **Durchstich zuerst (Pipeline-Probe):** Am Tor von P1 läuft die Engine-Kette vollständig bis zum Bild. Das umfasst Skalierung, Palette, Licht, Dichte, Mip, Leistung, 4 neue Texturen, `fenster v1` an allen Häusern und die Figur R03 in HD. Gebäude-Typologie und Ausstattung verbreitern das danach.
- **Neu verankern:** Zu Beginn jeder Phase schreibe ich drei Sätze zum Zielbeitrag in `hd/STATUS.md`.

---

## STATION F – HAIKU-STAFFEL (`claude-haiku-5-5`; Briefings in `hd/rollen/`)
- **Rollen:**

| Rolle | Aufgabe |
|---|---|
| Kundschafter | Audits und Listen mit Datei:Zeile |
| Autor | genau ein Gegenstand oder eine Gruppe von höchstens 2 gleichartigen, je eine eigene Datei; im Worktree, falls eine geteilte Datei nötig ist |
| Variantenbauer | ★-Stellen |
| Prüfer | Checkliste, `dart analyze`, Tests |
| Sichtprüfer | Bilder; geeicht; 3 Stimmen bei Toren |
| Gegenprüfer | Angriff |
| Probeläufer | Läufe und Belege |
| Analyst | Messungen, Go/No-Go |
| Verdichter | Bericht-Entwurf |
| Monteur | Galerie-Paare |

- Die Registrierung in den Sammellisten übernehme ich bei jeder Integration (L2).
- **Variantenregel:** ★-Stellen gehen an 2 Plätze; ich wähle nach Kontaktbogen und Stilblatt.
- **Mehrstimmenregel:** Go/No-Go, Sichtprüfungen an Toren und Figurenprüfung laufen über je 3 Stimmen. Weichen sie ab, kommt das auf die Nebelkarte.

## STATION G – ARBEITSQUANTEN
- **Paketvertrag:**
  - Ein Gegenstand (oder 2 gleichartige), höchstens 400 Zeilen plus Test plus Probe.
  - Pflichtfeld HZ-ID mit messbarem Zielbeitrag.
  - Rückgabeformular: ÄNDERUNGEN, TEST, PROBE (Bildpfad), STILBLATT-CHECK, KANON-CHECK, OFFENE FRAGEN, SELBSTPRÜFUNG; Endmarke.
- **Verboten:**
  - Dateien außerhalb des Auftrags ändern, textPfade und `nachtlauf/` anfassen
  - `dart:math Random`, Farben außerhalb der Palette, Grün außerhalb der Whitelist
  - neue Lichtquellen
  - „usw.“, „analog“, TODO
- **Bauplan:** wie in §11 des Prompts. Dazu kommen die Muster-Dateien aus P1-OPUS-12 und die Schnittstellen (Werkzeugkasten, BauKontext, Ausstattungsschema).
- **Abhängigkeiten:** „Abhängig von X“ heißt, X liegt in einer früheren Schicht.

### Feinplan – Paketverzeichnis (aus dem Graphen erzeugt; T/S = geplante Schicht)
**P0 Fundament (22 Pakete, davon 3 Opus)**

| ID | Rolle | Gegenstand | Abhängig von | St | HZ | T/S |
|---|---|---|---|---|---|---|
| P0-OPUS-01 | Opus | Branch vorspulen (ff auf origin/nachtlauf/burgstadt), Flutter 3.47.6 nach /opt/flutter (nur Download, kein Web-Build), pub get aller Pakete, Werkzeugcheck | – | 3 | 13,14 | T1/S1 |
| P0-OPUS-02 | Opus | hd/ anlegen: KERN, ZIELFORMEL, NEBELKARTE, PLAN, STATUS, ENTSCHEIDUNGSLOG, PRUEFPUNKT, FEHLER, Rollenbriefings, Stilblatt v2 | – | 3 | 14 | T1/S1 |
| P0-OPUS-03 | Opus | Z-13-Zeile (Arbeitsbranch, N-HD-01) in tool/abnahme.dart; tool/hd_commit.sh (schnell-Lauf, Pfadliste statt add -A, push HEAD:claude/pensive-gates-ajtp7x mit Exit-Code) | P0-OPUS-01 | 3 | 13 | T1/S2 |
| P0-PROBE-01 | Probeläufer | Ausgang: Commit einfrieren (hd/PRUEFPUNKT), alle_tests.sh voll und schnell (Laufzeit je Ebene), dart run tool/abnahme.dart (erwartet 12/14), Zahl der Innen-Bereiche aus baueWelt() | P0-OPUS-01 | 1 | 13 | T1/S2 |
| P0-KUND-01 | Kundschafter | Paletten-Audit per Regex mit \s* bei allen Operatoren (>> 3, & 7, << 6, * 8, ~/ 8, % 8, [/*] 7, fog * 3, Clamps [<>]=? [37] ?, 40/47/63/64/255, Pal., Ramp.at, shades) – Fundliste Datei:Zeile, jede Zeile einem Paket zugeordnet (Pflicht: renderer.dart 453–457/523–527, lighting.dart 24–28/62/72) | – | 1 | 02 | T1/S1 |
| P0-KUND-02 | Kundschafter | Dichte-Audit (kTexelsPerMeter, 32, 48×80, 24/77, 64×64, Mip-Schwellen) in Code und Tests – Fundliste | – | 1 | 03 | T1/S1 |
| P0-KUND-03 | Kundschafter | Test-Bindungen-Audit (spiel_test, texturen_test, pixel_test, portraet_test, teile_*_test, fledermaeuse_test, stadtkarte_test, karten_test, sprite_pruef, figur_test, innenraeume_*_test) – Liste mit Zielpaket | – | 1 | 13 | T1/S1 |
| P0-KUND-04 | Kundschafter | Kanon-Positiv-/Verbotsliste je Raumart (alle Räume): Vereinigung aus K9 §8, K1 LISTE-GEGENSTÄNDE/LISTE-ORTE (Ortsbindung), M-18/M-23, ANPASSUNG („nur Farbe“) und bestehenden Testlisten; Lichtregel (Strom aus) mit Bestands-Ausnahmen | – | 1 | 07,13 | T1/S1 |
| P0-KUND-05 | Kundschafter | Bestandsaufnahme der 42 Raumvorlagen + 5 Burg-Räume + Gangnetz: Raumart, Formen, freie Wandflächen, Fenster | – | 1 | 07 | T1/S1 |
| P0-KUND-06 | Kundschafter | Belegblick-Liste: Kamerapositionen für 6 Viertel, 12 Fall-Orte, Gangnetz, Burg, 8 Bildschirme + Tutorial (beide Formate) | – | 1 | 01,14 | T1/S1 |
| P0-AUTOR-01 | Autor | tool/layout_pruefsumme.dart über baueWelt() (Kachelarten, Marken, Türziele, Kollision, Stationen, Bewohner) + Zahl der Zufallsaufrufe; Fixture-Test; Aufnahme in alle_tests.sh | P0-OPUS-01 | 2 | 13 | T1/S2 |
| P0-AUTOR-02 | Autor | bin/kontaktbogen.dart: Texturen in Mip 0 und Mip 1, Meshes aus 3 Blickwinkeln, beschriftet, mit Palettenprüfung | P0-OPUS-01 | 2 | 04,05,07 | T1/S2 |
| P0-AUTOR-03 | Autor | bin/flimmer.dart (Bodenpixel-Änderungsquote bei 0,1 m Fahrt, 3 Szenen) und bin/banding.dart (radiales Handylicht-Profil) | P0-OPUS-01 | 2 | 02,03 | T1/S2 |
| P0-AUTOR-04 | Autor | bin/szenen_mess.dart: Spielszene je Pass (Meshes, Himmel, Sprites, Blickfilter, RGBA/Übergabe), Überdeckungsquote, Dreiecks-/Mesh-Kosten; mittel und erzwungen 640×360 | P0-OPUS-01 | 2 | 12 | T1/S2 |
| P0-AUTOR-05 | Autor | Eichbilder für den Sichtprüfer-Eichlauf: 12 mit bekannten Fehlern (Rauschen, Moiré, Stilbruch, Fremdfarbe, abgeschnitten), 6 fehlerfrei | P0-AUTOR-02 | 2 | 04 | T1/S3 |
| P0-PROBE-02 | Probeläufer | Ausgangs-Belegfotos (belegfotos, bildschirmfoto, bereichsfotos, stadtfotos; 2 Formate) nach hd/bilder/vorher; Ausgangswerte Flimmern, Banding, Szenenmessung | P0-AUTOR-02..04 | 1 | 12,14 | T1/S3 |
| P0-PROBE-03 | Probeläufer | Browserlauf geraete.js lauffähig machen (PLAYWRIGHT_BROWSERS_PATH), gelieferte Weltbilder/s zählen, Ausgangs-fps in 3 Profilen | P0-OPUS-01 | 1 | 12 | T1/S2 |
| P0-SICHT-01 | Sichtprüfer | Eichlauf A3 (Stimme 1/3): Eichbilder unabhängig bewerten; Trefferquote ≥ 80 % sonst Opus-Stichprobe | P0-AUTOR-05 | 2 | 04 | T2/S1 |
| P0-SICHT-02 | Sichtprüfer | Eichlauf A3 (Stimme 2/3): Eichbilder unabhängig bewerten; Trefferquote ≥ 80 % sonst Opus-Stichprobe | P0-AUTOR-05 | 2 | 04 | T2/S1 |
| P0-SICHT-03 | Sichtprüfer | Eichlauf A3 (Stimme 3/3): Eichbilder unabhängig bewerten; Trefferquote ≥ 80 % sonst Opus-Stichprobe | P0-AUTOR-05 | 2 | 04 | T2/S1 |
| P0-AUTOR-06 | Autor | Gerüst tool/hd_abnahme.dart (HZ-01…HZ-14, liest Protokolle; HD-ZIEL ERREICHT nur bei allem erfüllt; textPfade gegen merge-base) + figurenstand(): Hash über sortierte git-ls-files-Liste (karten.json, rollen.json, teile_*.json, figuren_hd/, figur/*.dart), 10 Zeichen, Golden-Test | P0-AUTOR-01, P0-AUTOR-03..04 | 2 | 14 | T1/S3 |
| P0-GEGEN-01 | Gegenprüfer | Angriff auf Messwerkzeuge: messen Flimmer-, Banding- und Szenenmessung das Richtige? | P0-AUTOR-03..04 | 2 | 02,03,12 | T1/S3 |

**P1 Engine-HD und Durchstich (30 Pakete, davon 12 Opus)**

| ID | Rolle | Gegenstand | Abhängig von | St | HZ | T/S |
|---|---|---|---|---|---|---|
| P1-OPUS-01 | Opus | Werkzeugkasten und Register: kit/werkzeug.dart (Lcg, Tex, steine, planken öffentlich), int hashTeil(String id, int teil) dart2js-sicher (16-Bit-Teilprodukte) mit Golden-Werten VM/Web, Textur-Register nach Name (Enum-Block in texturen.dart unverändert, innenraeume_*_test grün), bau/teile, bau/profile, bau/formen mit Form-Muster (tisch 1:1 portiert); Belegfotos 1:1 | P0-AUTOR-02, P0-PROBE-02 | 3 | 04,05,07 | T2/S1 |
| P1-OPUS-02 | Opus | Skalierung v2: scharf = kUi wie mittel, kWelt = kUi (Welt = 2× mittel linear, UI identisch), nur wenn kUi ≥ 2 und Weltpixel ≤ 380.000, sonst scharf = mittel; Qualitaet {sparsam, mittel, scharf, auto}, „hoch“→auto, auto bis P1-OPUS-10 = mittel; optionen_bildschirm, spiel_test (9 Größen), Blocktest-k aus kUi je Profil in alle_tests.sh | P0-PROBE-01, P0-KUND-03, P0-PROBE-02 | 3 | 01 | T2/S2 |
| P1-OPUS-03 | Opus | Palette v2: 10×16, Ramp.at 8er-Semantik→2s+1, Ramp.at16, Pal-Konstanten als generierte Literale (const bleibt), blickFilter (160), alle Audit-Zeilen; Übergangs-Lichttabelle 8×8×4 mit Suche nur über die 64 Altfarben → Migrationsbeleg: Belegfotos RGB-identisch zum Ausgang (Commit festgehalten) | P0-KUND-01, P0-PROBE-02 | 3 | 02 | T2/S1 |
| P1-OPUS-04 | Opus | LightTable v2 (12 warm × 12 kalt × 6 Nebel × 160, volle Suche, statisch einmal gebaut, Index ohne Shift; renderer.dart 453–457/523–527, lighting.dart 24–28/62/72); Aufbauzeit VM/Web (L-05) | P1-OPUS-03 | 3 | 02 | T2/S3 |
| P1-OPUS-05 | Opus | Dichte: kDichteWelt=64 und kDichteFigur=32 als getrennte Konstanten, Baker-Stellen (baker.dart 168–248) auf kDichteFigur, SpriteImage.texelsPerMeter, UV-Pfade, Mip-Cap 3→4; Bestandstexturen texelverdoppelt; Migrationsbeleg 2: Belegfotos weiter RGB-identisch | P0-KUND-02, P1-OPUS-01, P1-OPUS-03 | 3 | 03 | T2/S2 |
| P1-OPUS-06 | Opus | Mip v2: tpp=dichte·z/focal, lv=0 bei tpp<s sonst ⌊log2(tpp/s)⌋+1, Start s=2 (= Ausgang), Boden-Anisotropie je Spanne, alle Stufen; s nur nach Flimmermessung ändern | P1-OPUS-05 | 3 | 03 | T3/S1 |
| P1-OPUS-07 | Opus | Leistung Raster: affine 16-px-Spannen, Mesh-Sortierung vorne→hinten (falls Überdeckung > 1,3), Bodennebel je Zeile, Float64List-Scratch, Sprite-Spannen, Himmel nur in leeren Tiefen, Blickfilter | P0-AUTOR-04, P1-OPUS-03 | 3 | 12 | T2/S3 |
| P1-OPUS-08 | Opus | Leistung Ausgabe: Welt direkt in RGBA, Puffer wiederverwenden, Web-Übergabe ohne Kopie, UI-RGBA nur bei Änderung, gelieferte Bilder/s zählen | P1-OPUS-03 | 3 | 12 | T3/S1 |
| P1-OPUS-09 | Opus | Licht perspektivkorrekt, Wandlicht 2 Proben je Kante, Boden 1-m-Raster überall; Dreiecks- und Mesh-Kosten (L-07) → vorläufiges Budget „scharf“ (E-014) | P1-OPUS-04, P1-OPUS-07 | 3 | 08,12 | T3/S2 |
| P1-OPUS-10 | Opus | Automatische Qualitätswahl (Grundform): Messfenster gelieferte Bilder, Hysterese, Speichern; Standard wird auto; qualitaet_test | P1-OPUS-02, P1-OPUS-08 | 3 | 12 | T3/S2 |
| P1-OPUS-11 | Opus | Durchstich-Figur: Baker mit Dichteparameter für R03 (Zweidichten-Umbau bleibt P6-OPUS-01) | P1-OPUS-05 | 3 | 09 | T3/S3 |
| P1-AUTOR-01 | Autor | texturen_test v2 (64/128, ≤ 8 Stufen, Streupixel ≤ 8 %, Kachelkante, Lichtkante, Index 0–159, Grünregel mit >>4, Anzahl aus Register) | P1-OPUS-01, P1-OPUS-03 | 2 | 04 | T2/S2 |
| P1-AUTOR-02 | Autor | pixel_test v2, fledermaeuse_test und stadtkarte_test auf Palette v2 | P1-OPUS-03..04 | 2 | 02 | T3/S3 |
| P1-AUTOR-03 | Autor | --qualitaet für belegfotos, stadtfotos, bildschirmfoto, bereichsfotos | P1-OPUS-02 | 1 | 01 | T2/S3 |
| P1-AUTOR-04 | Autor | ★ Textur pflaster v2 (Variante A) | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 04 | T2/S3 |
| P1-VAR-01 | Variantenbauer | ★ Textur pflaster v2 (Variante B: größere Steine, Fächermuster) | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 04 | T2/S3 |
| P1-AUTOR-05 | Autor | ★ Textur putzOcker v2 (Variante A: Flecken, Kanten, Ausbesserungen) | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 04 | T2/S3 |
| P1-VAR-02 | Variantenbauer | ★ Textur putzOcker v2 (Variante B: Kalkputz mit Kellenzügen) | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 04 | T2/S3 |
| P1-AUTOR-06 | Autor | Textur dachBiberschwanz v2 (128) | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 04 | T2/S3 |
| P1-AUTOR-07 | Autor | Textur fensterDunkel v2 (64) | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 04 | T2/S3 |
| P1-AUTOR-08 | Autor | Bauteil fenster v1 (Laibung 0,15, Sims, Sturz) als erstes Teil in bau/teile | P1-OPUS-01, P1-OPUS-05 | 2 | 05 | T2/S3 |
| P1-SICHT-01 | Sichtprüfer | Durchstich-Kontaktbögen und Varianten (Stimme 1/2) | P1-AUTOR-04, P1-VAR-01, P1-AUTOR-05, P1-VAR-02, P1-AUTOR-06..08 | 2 | 04 | T3/S1 |
| P1-SICHT-02 | Sichtprüfer | Durchstich-Kontaktbögen und Varianten (Stimme 2/2) | P1-AUTOR-04, P1-VAR-01, P1-AUTOR-05, P1-VAR-02, P1-AUTOR-06..08 | 2 | 04 | T3/S1 |
| P1-OPUS-12 | Opus | Variantenwahl; Stilblatt-Muster als lauffähige Dateien (Textur, Bauteil, Form, Test); fenster v1 vorläufig in _haus eingebaut (für Durchstich und Bauteilkosten) | P1-SICHT-01..02 | 3 | 04,05,07 | T3/S3 |
| P1-PROBE-01 | Probeläufer | DURCHSTICH (Pipeline-Probe): Marktviertel mit 4 neuen Texturen und fenster v1, Stadtmuseum (Bestand, texelverdoppelt), R03 in „scharf“ hoch/quer; Szenenmessung inkl. Bauteil-Mesh-Kosten (L-07), Flimmern, Banding – sofort an dich | P1-OPUS-04, P1-OPUS-06, P1-OPUS-08..11, P1-AUTOR-03, P1-OPUS-12 | 1 | 01,02,03,12 | T4/S1 |
| P1-GEGEN-01 | Gegenprüfer | Angriff auf Durchstich-Bilder und -Zahlen | P1-PROBE-01 | 2 | 01,02,03,12 | T4/S2 |
| P1-SICHT-03 | Sichtprüfer | Sichtprüfung der Durchstich-Bilder (hoch/quer, vorher/nachher) | P1-PROBE-01 | 2 | 01,03,04 | T4/S2 |
| P1-ANALYST-01 | Analyst | Go/No-Go „scharf“ (Stimme 1/3): Desktop-Web gemessen ≥ 30 gelieferte Bilder/s bei „scharf“ – oder Ausgang mittel ≥ 120·c (c = gemessene Kosten je Weltpixel relativ zum Ausgang); sonst ÄNDERUNG | P1-PROBE-01 | 2 | 12 | T4/S2 |
| P1-ANALYST-02 | Analyst | Go/No-Go „scharf“ (Stimme 2/3): Desktop-Web gemessen ≥ 30 gelieferte Bilder/s bei „scharf“ – oder Ausgang mittel ≥ 120·c (c = gemessene Kosten je Weltpixel relativ zum Ausgang); sonst ÄNDERUNG | P1-PROBE-01 | 2 | 12 | T4/S2 |
| P1-ANALYST-03 | Analyst | Go/No-Go „scharf“ (Stimme 3/3): Desktop-Web gemessen ≥ 30 gelieferte Bilder/s bei „scharf“ – oder Ausgang mittel ≥ 120·c (c = gemessene Kosten je Weltpixel relativ zum Ausgang); sonst ÄNDERUNG | P1-PROBE-01 | 2 | 12 | T4/S2 |

**P2 Material (95 Texturen) (59 Pakete, davon 0 Opus)**

| ID | Rolle | Gegenstand | Abhängig von | St | HZ | T/S |
|---|---|---|---|---|---|---|
| P2-AUTOR-01 | Autor | Textur pflasterGross | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S2 |
| P2-AUTOR-02 | Autor | Textur putzAltrosa | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S2 |
| P2-AUTOR-03 | Autor | Textur putzTaubenblau | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S2 |
| P2-AUTOR-04 | Autor | Textur putzCreme + putzKalkweiss | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S2 |
| P2-AUTOR-05 | Autor | Textur putzSandstein + putzInnenWarm | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S2 |
| P2-AUTOR-06 | Autor | Textur sockelBruchstein + bruchsteinMauer | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T4/S3 |
| P2-AUTOR-07 | Autor | Textur quaderMauer + burgBruchstein | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T4/S3 |
| P2-AUTOR-08 | Autor | Textur dachBiberschwanzMoos | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S2 |
| P2-AUTOR-09 | Autor | Textur gewoelbeDecke + stufenStein | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S1 |
| P2-AUTOR-10 | Autor | Textur holzBohlen + holzDielen | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T4/S3 |
| P2-AUTOR-11 | Autor | Textur eichenTuer + eichenTuerEisen | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S2 |
| P2-AUTOR-12 | Autor | Textur fensterLaden + fensterKerze | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T4/S3 |
| P2-AUTOR-13 | Autor | Textur fachwerkPutz | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T4/S3 |
| P2-AUTOR-14 | Autor | Textur ziegelKamin + kachelOfen | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S3 |
| P2-AUTOR-15 | Autor | Textur kiesWeg + erde | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S3 |
| P2-AUTOR-16 | Autor | Textur wiese + schieferPlatten | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S3 |
| P2-AUTOR-17 | Autor | Textur teppichRot + tapeteStreifen | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S1 |
| P2-AUTOR-18 | Autor | Textur regalBuecher + holzVertaefelung | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S1 |
| P2-AUTOR-19 | Autor | Textur eisenGitter | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T4/S3 |
| P2-AUTOR-20 | Autor | Spur-Texturen A (4 von 7, 32/64 mit Mips) | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S3 |
| P2-AUTOR-21 | Autor | Spur-Texturen B (3 von 7) | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S3 |
| P2-AUTOR-22 | Autor | Textur putzTuerkis + putzOckerB | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S3 |
| P2-AUTOR-23 | Autor | Textur putzOckerC + sockelPutz | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T4/S3 |
| P2-AUTOR-24 | Autor | Textur fensterRahmenAussen + fensterRahmenInnen | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T4/S3 |
| P2-AUTOR-25 | Autor | Textur fensterGlasMond + fensterGlasKerze | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T4/S3 |
| P2-AUTOR-26 | Autor | Textur ladenFluegelRot + ladenFluegelBraun | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T4/S3 |
| P2-AUTOR-27 | Autor | Textur tuerBretter + tuerKassette | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T4/S3 |
| P2-AUTOR-28 | Autor | Textur tuerLadenGlas + torBohlen | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T4/S3 |
| P2-AUTOR-29 | Autor | Textur gesimsStuck + eckQuader | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S1 |
| P2-AUTOR-30 | Autor | Textur fachwerkDunkel + ortgangBrett | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S1 |
| P2-AUTOR-31 | Autor | Textur dachSchiefer + dachSchindel | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S1 |
| P2-AUTOR-32 | Autor | Textur dachrinneBlech + schornsteinZiegel | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S1 |
| P2-AUTOR-33 | Autor | Textur schornsteinKopf + uhrZiffer | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S1 |
| P2-AUTOR-34 | Autor | Textur laterneGlas + laterneEisen (unbeleuchtet, Strom aus) | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S1 |
| P2-AUTOR-35 | Autor | Textur zeichenBaecker + zeichenApotheke | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S1 |
| P2-AUTOR-36 | Autor | Textur zeichenSchmied + zeichenUhr | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S1 |
| P2-AUTOR-37 | Autor | Textur zeichenBuch + zeichenTasse | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S1 |
| P2-AUTOR-38 | Autor | Textur kirchenFenster + gewoelbeRippe | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S1 |
| P2-AUTOR-39 | Autor | Textur zinnenKrone + wehrgangHolz | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S3 |
| P2-AUTOR-40 | Autor | Textur brunnenStein + wasserDunkel | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S3 |
| P2-AUTOR-41 | Autor | Textur grabStein + raureif | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S3 |
| P2-AUTOR-42 | Autor | Textur balkenDecke + stuckDecke | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S1 |
| P2-AUTOR-43 | Autor | Textur kachelBoden + steinPlatten | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S3 |
| P2-AUTOR-44 | Autor | Textur tapeteRanken + tapeteKaro (ohne Grün) | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S3 |
| P2-AUTOR-45 | Autor | Textur teppichBlau + teppichFlicken | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S1 |
| P2-AUTOR-46 | Autor | Textur vorhangStoff + bettDecke | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S2 |
| P2-AUTOR-47 | Autor | Textur tischDecke + regalWerkzeug | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T5/S2 |
| P2-VAR-01 | Variantenbauer | ★ Variante fachwerkPutz B | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T6/S3 |
| P2-VAR-02 | Variantenbauer | ★ Variante holzDielen B | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T7/S1 |
| P2-VAR-03 | Variantenbauer | ★ Variante kirchenFenster B | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T7/S1 |
| P2-VAR-04 | Variantenbauer | ★ Variante putzKalkweiss B | P1-AUTOR-01, P1-OPUS-12, P1-ANALYST-01..03 | 2 | 04 | T7/S1 |
| P2-PRUEF-01 | Prüfer | Stilblatt-Checkliste P2-AUTOR-01..11 (inkl. Mip-1-Lesbarkeit, Grünregel) | P2-AUTOR-01..11 | 2 | 04 | T7/S3 |
| P2-PRUEF-02 | Prüfer | Stilblatt-Checkliste P2-AUTOR-12..22 (inkl. Mip-1-Lesbarkeit, Grünregel) | P2-AUTOR-12..22 | 2 | 04 | T8/S1 |
| P2-PRUEF-03 | Prüfer | Stilblatt-Checkliste P2-AUTOR-23..33 (inkl. Mip-1-Lesbarkeit, Grünregel) | P2-AUTOR-23..33 | 2 | 04 | T8/S1 |
| P2-PRUEF-04 | Prüfer | Stilblatt-Checkliste P2-AUTOR-34..47 (inkl. Mip-1-Lesbarkeit, Grünregel) | P2-AUTOR-34..47 | 2 | 04 | T8/S1 |
| P2-SICHT-01 | Sichtprüfer | Kontaktbogen aller 95 Texturen (Stimme 1/3) | P2-AUTOR-01..47, P2-VAR-01..04 | 2 | 04 | T8/S1 |
| P2-SICHT-02 | Sichtprüfer | Kontaktbogen aller 95 Texturen (Stimme 2/3) | P2-AUTOR-01..47, P2-VAR-01..04 | 2 | 04 | T8/S1 |
| P2-SICHT-03 | Sichtprüfer | Kontaktbogen aller 95 Texturen (Stimme 3/3) | P2-AUTOR-01..47, P2-VAR-01..04 | 2 | 04 | T8/S1 |
| P2-GEGEN-01 | Gegenprüfer | Stilbruch-Angriff über alle Texturen und Viertelfarben | P2-AUTOR-01..47, P2-VAR-01..04 | 2 | 04 | T8/S1 |

**P3 Gebäude (55 Pakete, davon 3 Opus)**

| ID | Rolle | Gegenstand | Abhängig von | St | HZ | T/S |
|---|---|---|---|---|---|---|
| P3-OPUS-01 | Opus | Bauteil-Schnittstelle: BauKontext (Maße, Rampen, hashTeil, LOD), Bauteilzählung für bau_test | P1-OPUS-01, P1-OPUS-05, P1-AUTOR-08, P1-ANALYST-01..03 | 3 | 05 | T4/S3 |
| P3-OPUS-02 | Opus | LOD 3 Stufen, ein Mesh je Haus und LOD (Mesh-Budget ≤ 300), Budget „scharf“ festschreiben (E-014) – vor allen Bauteilen | P1-OPUS-09, P1-ANALYST-01..03, P3-OPUS-01 | 3 | 05,12 | T5/S1 |
| P3-AUTOR-01 | Autor | Bauteil fenster v2 (Sprossen, Glas) | P2-AUTOR-24..25, P3-OPUS-02 | 2 | 05 | T5/S2 |
| P3-AUTOR-02 | Autor | Bauteil fensterladen (offen/halb/zu) | P2-AUTOR-12, P2-AUTOR-26, P3-OPUS-02 | 2 | 05 | T5/S2 |
| P3-AUTOR-03 | Autor | Bauteil fenstergitter | P2-AUTOR-19, P3-OPUS-02 | 2 | 05 | T5/S2 |
| P3-AUTOR-04 | Autor | Bauteil tuer (Rahmen, Stufe, Oberlicht) | P2-AUTOR-27..28, P3-OPUS-02 | 2 | 05 | T5/S2 |
| P3-AUTOR-05 | Autor | Bauteil vordach | P2-AUTOR-31, P3-OPUS-02 | 2 | 05 | T5/S2 |
| P3-AUTOR-06 | Autor | Bauteil traufe (Überstand, Untersicht) | P2-AUTOR-31, P3-OPUS-02 | 2 | 05 | T5/S2 |
| P3-AUTOR-07 | Autor | Bauteil ortgang | P2-AUTOR-30, P3-OPUS-02 | 2 | 05 | T5/S2 |
| P3-AUTOR-08 | Autor | Bauteil first | P2-AUTOR-25, P3-OPUS-02 | 2 | 05 | T5/S2 |
| P3-AUTOR-09 | Autor | Bauteil ★ gaube_fledermaus („Augen“) | P2-AUTOR-25, P3-OPUS-02 | 2 | 05 | T5/S2 |
| P3-AUTOR-10 | Autor | Bauteil gaube_schlepp | P2-AUTOR-31, P3-OPUS-02 | 2 | 05 | T5/S2 |
| P3-AUTOR-11 | Autor | Bauteil schornstein | P2-AUTOR-32..33, P3-OPUS-02 | 2 | 05 | T5/S3 |
| P3-AUTOR-12 | Autor | Bauteil dachrinne | P2-AUTOR-32, P3-OPUS-02 | 2 | 05 | T5/S3 |
| P3-AUTOR-13 | Autor | Bauteil fallrohr | P2-AUTOR-32, P3-OPUS-02 | 2 | 05 | T5/S3 |
| P3-AUTOR-14 | Autor | Bauteil sockel | P2-AUTOR-06, P2-AUTOR-23, P3-OPUS-02 | 2 | 05 | T5/S3 |
| P3-AUTOR-15 | Autor | Bauteil gesims | P2-AUTOR-29, P3-OPUS-02 | 2 | 05 | T5/S3 |
| P3-AUTOR-16 | Autor | Bauteil eckquader | P2-AUTOR-29, P3-OPUS-02 | 2 | 05 | T5/S3 |
| P3-AUTOR-17 | Autor | Bauteil fachwerk (Relief) | P2-AUTOR-13, P2-AUTOR-30, P3-OPUS-02 | 2 | 05 | T5/S3 |
| P3-AUTOR-18 | Autor | Bauteil laube v2 (Arkade) | P2-AUTOR-10, P3-OPUS-02 | 2 | 05 | T5/S3 |
| P3-AUTOR-19 | Autor | Bauteil erker | P2-AUTOR-29, P3-OPUS-02 | 2 | 05 | T5/S3 |
| P3-AUTOR-20 | Autor | Bauteil ladenfront (Auslage, Markise) | P2-AUTOR-28, P3-OPUS-02 | 2 | 05 | T5/S3 |
| P3-AUTOR-21 | Autor | Bauteil ausleger (Zunftschild) | P2-AUTOR-35..37, P3-OPUS-02 | 2 | 05 | T5/S3 |
| P3-AUTOR-22 | Autor | Bauteil wandlaterne (unbeleuchtet) | P2-AUTOR-34, P3-OPUS-02 | 2 | 05 | T5/S3 |
| P3-AUTOR-23 | Autor | Bauteil inschrifttafel (Muster, kein Text) | P2-AUTOR-29, P3-OPUS-02 | 2 | 05 | T6/S1 |
| P3-AUTOR-24 | Autor | Bauteil galerie (Holzbalkon) | P2-AUTOR-10, P3-OPUS-02 | 2 | 05 | T6/S1 |
| P3-AUTOR-25 | Autor | Bauteil torbogen | P2-AUTOR-07, P3-OPUS-02 | 2 | 05 | T6/S1 |
| P3-AUTOR-26 | Autor | Bauteil strebepfeiler | P2-AUTOR-07, P3-OPUS-02 | 2 | 05 | T6/S1 |
| P3-VAR-01 | Variantenbauer | ★ Variante gaube_fledermaus B | P3-OPUS-02 | 2 | 05 | T6/S1 |
| P3-PRUEF-01 | Prüfer | Bauteilvertrag aller 26 Bauteile (Vorsprungsregel, Kachel- und Türfreiheit, Kontaktbogen) | P3-AUTOR-01..26, P3-VAR-01 | 2 | 05 | T6/S2 |
| P3-AUTOR-27 | Autor | Bauprofil Giebelhaus + Eckhaus | P3-PRUEF-01 | 2 | 05 | T7/S1 |
| P3-AUTOR-28 | Autor | Bauprofil Speicher + Werkstatt | P3-PRUEF-01 | 2 | 05 | T7/S1 |
| P3-AUTOR-29 | Autor | Bauprofil Laden + Laubenhaus | P3-PRUEF-01 | 2 | 05 | T7/S1 |
| P3-AUTOR-30 | Autor | Bauprofil Bäckerei + Apotheke | P3-PRUEF-01 | 2 | 05 | T7/S1 |
| P3-AUTOR-31 | Autor | Bauprofil Museum + Bibliothek | P3-PRUEF-01 | 2 | 05 | T7/S1 |
| P3-AUTOR-32 | Autor | Bauprofil Pension + Teestube | P3-PRUEF-01 | 2 | 05 | T7/S1 |
| P3-AUTOR-33 | Autor | Bauprofil Amtshaus + Pfarrhaus | P3-PRUEF-01 | 2 | 05 | T7/S1 |
| P3-AUTOR-34 | Autor | Bauprofil Theater + Stromhaus | P3-PRUEF-01 | 2 | 05 | T7/S1 |
| P3-AUTOR-35 | Autor | Bauprofil Turm + Zunftturm | P3-PRUEF-01 | 2 | 05 | T7/S1 |
| P3-AUTOR-36 | Autor | Sonderbau Uhrturm (Zifferblatt, Galerie, Helm) | P3-PRUEF-01 | 2 | 06 | T7/S2 |
| P3-AUTOR-37 | Autor | Sonderbau Kirchenburg (Strebepfeiler, Maßwerk, Wehrgeschoss) | P3-PRUEF-01 | 2 | 06 | T7/S2 |
| P3-AUTOR-38 | Autor | Sonderbau Stadtmauer + Zinnen v2 (Eigentümer zinnen) | P3-PRUEF-01 | 2 | 06 | T7/S2 |
| P3-AUTOR-39 | Autor | Sonderbau Stadttore (Ober-, Unter-, Burgtor) | P3-PRUEF-01 | 2 | 06 | T7/S2 |
| P3-AUTOR-40 | Autor | Sonderbau Wehrgang (Dach, Bohlen) | P3-PRUEF-01 | 2 | 06 | T7/S2 |
| P3-AUTOR-41 | Autor | Sonderbau Brunnen v2 | P3-PRUEF-01 | 2 | 06 | T7/S2 |
| P3-AUTOR-42 | Autor | Sonderbau Treppe (überdachte Holztreppe, Stufen) | P3-PRUEF-01 | 2 | 06 | T7/S2 |
| P3-AUTOR-43 | Autor | Sonderbau Burg außen (Hof, Turmfuß, Mauerwerk) | P3-PRUEF-01 | 2 | 06 | T7/S2 |
| P3-AUTOR-44 | Autor | Sonderbau Gärten (Form garten, Gartenmauer) | P3-PRUEF-01 | 2 | 06 | T7/S2 |
| P3-OPUS-03 | Opus | Vergabe Profil und Farbe nach typ und Viertel über hashTeil; bau_test (20/20 Profile, 160/160 Häuser ≥ 8 Bauteilarten) | P3-AUTOR-27..37 | 3 | 05 | T7/S3 |
| P3-PRUEF-02 | Prüfer | Checklisten Sonderbauten (≥ 6 Elemente je Bau) und Profile | P3-AUTOR-27..44 | 2 | 05,06 | T8/S1 |
| P3-SICHT-01 | Sichtprüfer | Belegfotos 6 Viertel hoch/quer (Stimme 1/3) | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P3-OPUS-03, P3-PRUEF-02 | 2 | 05,06 | T8/S3 |
| P3-SICHT-02 | Sichtprüfer | Belegfotos 6 Viertel hoch/quer (Stimme 2/3) | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P3-OPUS-03, P3-PRUEF-02 | 2 | 05,06 | T8/S3 |
| P3-SICHT-03 | Sichtprüfer | Belegfotos 6 Viertel hoch/quer (Stimme 3/3) | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P3-OPUS-03, P3-PRUEF-02 | 2 | 05,06 | T8/S3 |
| P3-PROBE-01 | Probeläufer | Erkundungsbots, Belegfoto-Kamera (freie Sicht), Layout-Prüfsumme | P3-OPUS-03, P3-PRUEF-02 | 1 | 13 | T8/S3 |
| P3-GEGEN-01 | Gegenprüfer | Angriff: wirken die Gebäude trotzdem schematisch? | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P3-OPUS-03, P3-PRUEF-02 | 2 | 05 | T8/S3 |

**P4 Innenräume (59 Pakete, davon 2 Opus)**

| ID | Rolle | Gegenstand | Abhängig von | St | HZ | T/S |
|---|---|---|---|---|---|---|
| P4-OPUS-02 | Opus | Ausstattungs-Lader (burgstadt_spiel) mit Übergabe an baueWelt() bzw. Bereich, eigener Renderschritt in BereichGeometrie, Wandaufbau-Schiene, Anker-/Verdeckungsprüfung; Belegfoto einer Vorlage zeigt Deko, Layout-Prüfsumme gleich | P4-OPUS-01 | 3 | 07,13 | T5/S1 |
| P4-OPUS-01 | Opus | Ausstattung: eigene Liste am Bereich (nie in karte/dinge/_index), Feld vorlage im Generator, Dateien data/ausstattung/<vorlage|bereich>.json; Schema ohne Namen, Texte, Lichtfelder; nur Wand-/Deckenanker, auf Möbeln oder flach (≤ 0,02 m); nie auf Tür-, Stations-, Markenkacheln; Tests: karte/dinge/_index/begehbar/Lichter identisch, Positivliste je Raumart (alle Räume), Verbotsliste formbasiert | P0-KUND-04..05, P1-OPUS-01, P1-ANALYST-01..03 | 3 | 07,13 | T4/S3 |
| P4-AUTOR-01 | Autor | Form bett | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T2/S3 |
| P4-AUTOR-02 | Autor | Form stuhl | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T2/S3 |
| P4-AUTOR-03 | Autor | Form bank | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T2/S3 |
| P4-AUTOR-04 | Autor | Form tisch v2 | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T2/S3 |
| P4-AUTOR-05 | Autor | Form regal | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S1 |
| P4-AUTOR-06 | Autor | Form kasten | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S1 |
| P4-AUTOR-07 | Autor | Form kiste | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S1 |
| P4-AUTOR-08 | Autor | Form truhe | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S1 |
| P4-AUTOR-09 | Autor | Form fass | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S1 |
| P4-AUTOR-10 | Autor | Form ofen (Kachelofen) | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S1 |
| P4-AUTOR-11 | Autor | Form kamin v2 | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S1 |
| P4-AUTOR-12 | Autor | Form kessel | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S1 |
| P4-AUTOR-13 | Autor | Form theke | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S1 |
| P4-AUTOR-14 | Autor | Form vitrine (Bestand, ohne Taler-Sockel) | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S1 |
| P4-AUTOR-15 | Autor | Form saeule | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S2 |
| P4-AUTOR-16 | Autor | Form brunnen innen | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S2 |
| P4-AUTOR-17 | Autor | Form Stationsformen wand + boden + tuerdeko (Kanon-Abgleich) | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S2 |
| P4-AUTOR-18 | Autor | Form nische (Burg) | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S2 |
| P4-AUTOR-19 | Autor | Form ruestung (Bestand Kunibert, HD mit Kanon-Merkmalen: verbogener Panzerhandschuh, Visier, kein sichtbarer Schlüsselbund) | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S2 |
| P4-AUTOR-20 | Autor | Form raureif (Burg) | P1-OPUS-01, P1-OPUS-03, P1-OPUS-05 | 2 | 07 | T3/S2 |
| P4-AUTOR-21 | Autor | Deko-Formen wandbild + wanduhr (Zifferblatt ohne Zeiger, überall) | P4-OPUS-02 | 2 | 07 | T6/S1 |
| P4-AUTOR-22 | Autor | Deko-Formen wandregal + spiegel | P4-OPUS-02 | 2 | 07 | T6/S1 |
| P4-AUTOR-23 | Autor | Deko-Formen vorhang + teppich | P2-AUTOR-45..46, P4-OPUS-02 | 2 | 07 | T6/S1 |
| P4-AUTOR-24 | Autor | Deko-Formen geschirr + buecherstapel | P2-AUTOR-18, P4-OPUS-02 | 2 | 07 | T6/S1 |
| P4-AUTOR-25 | Autor | Deko-Formen werkzeugwand + kistenstapel | P2-AUTOR-47, P4-OPUS-02 | 2 | 07 | T6/S2 |
| P4-AUTOR-26 | Autor | Deko-Formen spinnweben (organisch) + deckenbalken | P2-AUTOR-42, P4-OPUS-02 | 2 | 07 | T6/S2 |
| P4-AUTOR-27 | Autor | Deko-Formen korb + krug | P4-OPUS-02 | 2 | 07 | T6/S2 |
| P4-AUTOR-28 | Autor | Wandaufbau Wohnstube + Zunftstube (Fußleiste, Täfelung, Balkendecke, Laibung innen; im Code, nie in innenraeume/*.json) | P0-KUND-05, P2-AUTOR-17..18, P2-AUTOR-42, P4-OPUS-02 | 2 | 07 | T7/S2 |
| P4-AUTOR-29 | Autor | Wandaufbau Werkstatt + Speicher (Fußleiste, Täfelung, Balkendecke, Laibung innen; im Code, nie in innenraeume/*.json) | P0-KUND-05, P2-AUTOR-10, P2-AUTOR-42, P4-OPUS-02 | 2 | 07 | T7/S2 |
| P4-AUTOR-30 | Autor | Wandaufbau Laden + Fall-Orte (Fußleiste, Täfelung, Balkendecke, Laibung innen; im Code, nie in innenraeume/*.json) | P0-KUND-05, P2-AUTOR-18, P2-AUTOR-42, P4-OPUS-02 | 2 | 07 | T7/S2 |
| P4-AUTOR-31 | Autor | Wandaufbau Burg + Gewölbe + Gangnetz (Fußleiste, Täfelung, Balkendecke, Laibung innen; im Code, nie in innenraeume/*.json) | P0-KUND-05, P2-AUTOR-07, P2-AUTOR-09, P2-AUTOR-38, P4-OPUS-02 | 2 | 07 | T7/S3 |
| P4-AUTOR-50 | Autor | Deko-Form wandkandelaber: nur Kamin-Gewölbe (deine Wahl), mehrarmig am Wandhalter, nicht aufnehmbar, klar anders als der Tatwaffen-Kerzenständer; Flammen flackern, kein eigener Lichtpunkt; Kanon-Abgleich LA-02 | P0-KUND-04, P4-OPUS-02 | 2 | 07,13 | T6/S2 |
| P4-PRUEF-01 | Prüfer | formen_test: Quader-Rückfall 0, Formen-Kontaktbögen | P4-AUTOR-01..27, P4-AUTOR-50 | 2 | 07 | T7/S3 |
| P4-AUTOR-32 | Autor | Ausstattung Haus-Vorlagen 1–3 | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S1 |
| P4-AUTOR-33 | Autor | Ausstattung Haus-Vorlagen 4–6 | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S1 |
| P4-AUTOR-34 | Autor | Ausstattung Haus-Vorlagen 7–9 | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S1 |
| P4-AUTOR-35 | Autor | Ausstattung Haus-Vorlagen 10–12 | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S1 |
| P4-AUTOR-36 | Autor | Ausstattung Haus-Vorlagen 13–15 | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S2 |
| P4-AUTOR-37 | Autor | Ausstattung Haus-Vorlagen 16–18 | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S2 |
| P4-AUTOR-38 | Autor | Ausstattung Haus-Vorlagen 19–21 | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S2 |
| P4-AUTOR-39 | Autor | Ausstattung Haus-Vorlagen 22–24 | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S2 |
| P4-AUTOR-40 | Autor | Ausstattung Haus-Vorlagen 25–27 | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S2 |
| P4-AUTOR-41 | Autor | Ausstattung Haus-Vorlagen 28–30 | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S2 |
| P4-AUTOR-42 | Autor | Ausstattung Fall-Orte 1–3 (nur Positivliste) | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S2 |
| P4-AUTOR-43 | Autor | Ausstattung Fall-Orte 4–6 (nur Positivliste) | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S2 |
| P4-AUTOR-44 | Autor | Ausstattung Fall-Orte 7–9 (nur Positivliste) | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S2 |
| P4-AUTOR-45 | Autor | Ausstattung Fall-Orte 10–12 (nur Positivliste) | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S2 |
| P4-AUTOR-46 | Autor | Ausstattung Burg-Räume 1–3 | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S2 |
| P4-AUTOR-47 | Autor | Ausstattung Burg-Räume 4–5 | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S2 |
| P4-AUTOR-48 | Autor | Ausstattung Gangnetz (Keller, Abgänge, Treppe) | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S3 |
| P4-AUTOR-49 | Autor | Ausstattung Außenbereiche stadt, hof, wehrgang | P4-OPUS-02, P4-AUTOR-28..31, P4-PRUEF-01 | 2 | 07 | T8/S3 |
| P4-PRUEF-02 | Prüfer | raum_test über alle Innen-Bereiche aus baueWelt() (Ausgang 59) und 3 Außenbereiche: ≥ 4 Deko-Formen, Wandaufbau; Positiv-/Verbotsliste formbasiert 0 Treffer | P4-AUTOR-32..49 | 2 | 07,13 | T9/S1 |
| P4-SICHT-01 | Sichtprüfer | 12 Räume × 2 Blicke inkl. Kanon-Blick K9 §8 auf Fall-Orte und Burg (Stimme 1/3) | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P4-AUTOR-32..49 | 2 | 07 | T9/S1 |
| P4-SICHT-02 | Sichtprüfer | 12 Räume × 2 Blicke inkl. Kanon-Blick K9 §8 auf Fall-Orte und Burg (Stimme 2/3) | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P4-AUTOR-32..49 | 2 | 07 | T9/S1 |
| P4-SICHT-03 | Sichtprüfer | 12 Räume × 2 Blicke inkl. Kanon-Blick K9 §8 auf Fall-Orte und Burg (Stimme 3/3) | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P4-AUTOR-32..49 | 2 | 07 | T9/S1 |
| P4-PROBE-01 | Probeläufer | Erkundungsbots, Spieltest, Belegfoto-Kamera, Layout-Prüfsumme | P4-AUTOR-32..49 | 1 | 13 | T9/S1 |
| P4-GEGEN-01 | Gegenprüfer | Kanon-Angriff auf Ausstattung von Fall-Orten und Burg (falsche Hinweise?) | P4-AUTOR-32..49 | 2 | 07,13 | T9/S1 |

**P5 Licht und Atmosphäre (17 Pakete, davon 1 Opus)**

| ID | Rolle | Gegenstand | Abhängig von | St | HZ | T/S |
|---|---|---|---|---|---|---|
| P5-OPUS-01 | Opus | Flackerkanal (warmer Anteil je Mesh aus Lichtgruppe, Modulation je Bild), beachtet Option „Flackern aus“; Flacker-Metrik | P1-OPUS-09 | 3 | 08 | T4/S1 |
| P5-AUTOR-01 | Autor | Flackerprofile Kerze, Ofen | P5-OPUS-01 | 2 | 08 | T4/S2 |
| P5-AUTOR-02 | Autor | Kerzenfenster: Lichtschein auf dem Pflaster | P5-OPUS-01 | 2 | 08 | T4/S2 |
| P5-AUTOR-03 | Autor | Himmel v2: Bänder ohne Punktraster, Sterne nach Fläche | P1-OPUS-04, P1-OPUS-07 | 2 | 08 | T3/S2 |
| P5-AUTOR-04 | Autor | Mond als HD-Sprite | P1-OPUS-04, P1-OPUS-07 | 2 | 08 | T3/S2 |
| P5-AUTOR-05 | Autor | Kulisse: Panoramaring Bergland, Lichter von Silberhau im Tal, Burgberg | P1-OPUS-04, P1-OPUS-07 | 2 | 08 | T3/S2 |
| P5-AUTOR-06 | Autor | Wolkenbänder | P1-OPUS-04, P1-OPUS-07 | 2 | 08 | T3/S2 |
| P5-AUTOR-07 | Autor | Bodennebel v2 (Höhenbänder) | P1-OPUS-04, P1-OPUS-07 | 2 | 08 | T3/S2 |
| P5-AUTOR-08 | Autor | Hochformat-Komposition (Horizont, Sichtfeld) | P1-OPUS-02, P1-OPUS-05 | 2 | 08 | T3/S2 |
| P5-AUTOR-09 | Autor | Handylicht-Kante und Banding | P1-OPUS-04 | 2 | 02,08 | T3/S3 |
| P5-AUTOR-10 | Autor | Uhrturm-Zeiger nach Spielzeit (Abgleich ANPASSUNG STADT-05) | P2-AUTOR-33, P3-AUTOR-36 | 2 | 08 | T8/S3 |
| P5-AUTOR-11 | Autor | Fledermäuse in HD | P1-OPUS-02, P1-OPUS-05 | 2 | 08 | T3/S3 |
| P5-SICHT-01 | Sichtprüfer | Atmosphäre Außen und Innen (Stimme 1/3) | P5-AUTOR-01..11 | 2 | 08 | T9/S1 |
| P5-SICHT-02 | Sichtprüfer | Atmosphäre Außen und Innen (Stimme 2/3) | P5-AUTOR-01..11 | 2 | 08 | T9/S1 |
| P5-SICHT-03 | Sichtprüfer | Atmosphäre Außen und Innen (Stimme 3/3) | P5-AUTOR-01..11 | 2 | 08 | T9/S1 |
| P5-GEGEN-01 | Gegenprüfer | Angriff: Lichtregel Strom aus, Flackern, Himmel | P5-AUTOR-01..11 | 2 | 08 | T9/S1 |
| P5-ANALYST-01 | Analyst | Banding, Himmelsanteil hochkant, Flacker-Metrik, Kosten | P5-AUTOR-01..11 | 2 | 02,08,12 | T9/S1 |

**P6 Figuren und Porträts (22 Pakete, davon 3 Opus)**

| ID | Rolle | Gegenstand | Abhängig von | St | HZ | T/S |
|---|---|---|---|---|---|---|
| P6-ANALYST-01 | Analyst | L-06: Backzeit, Spitze je Backschritt und Speicher bei 96×160 (R03) | P1-OPUS-11 | 2 | 09,12 | T4/S1 |
| P6-OPUS-01 | Opus | Baker mit zwei Dichten (32 für Vergleicher und ≤ mittel, 64 für „scharf“), Maße je Dichte, Backen in Zeilenbändern | P6-ANALYST-01 | 3 | 09 | T4/S2 |
| P6-OPUS-02 | Opus | Figurenlager mit LRU (≤ 24 HD-Figuren), Speicherbudget je Stufe, Nachladespitze messen | P6-OPUS-01 | 3 | 09,12 | T5/S2 |
| P6-AUTOR-01 | Autor | Stilisierung neu eichen (Kopf, Glieder, Rumpf) | P6-OPUS-01 | 2 | 09 | T7/S3 |
| P6-AUTOR-02 | Autor | Gesicht HD: Augen 2×2, Brauen, Mund | P6-OPUS-01 | 2 | 09 | T7/S3 |
| P6-AUTOR-03 | Autor | Hände und Finger, Grundkörper Kapsel | P6-OPUS-01 | 2 | 09 | T7/S3 |
| P6-AUTOR-04 | Autor | Kleidungsdetails in data/figuren_hd (nur Geometrie) | P6-OPUS-01 | 2 | 09 | T7/S3 |
| P6-AUTOR-05 | Autor | Kopfbedeckungen ohne Haarfarben-Verwechslung (Regel B13/B14) | P6-OPUS-01 | 2 | 09 | T7/S3 |
| P6-AUTOR-06 | Autor | Kontur und Innenlinien für 16 Stufen | P6-OPUS-01 | 2 | 09 | T7/S3 |
| P6-AUTOR-07 | Autor | sprite_pruef, figur_test, teile_kleidung_test, teile_koepfe_test v2 (je Dichte) | P6-OPUS-01 | 2 | 09 | T7/S3 |
| P6-AUTOR-08 | Autor | karten_test v2: Vergleicher auf 32er-Backen, Farbfamilie >>4 | P6-OPUS-01 | 2 | 09 | T7/S3 |
| P6-VAR-01 | Variantenbauer | ★ Gesicht HD Gegenvariante | P6-OPUS-01 | 2 | 09 | T7/S3 |
| P6-OPUS-03 | Opus | Porträt 128×128, Gesichtsmuster relativ zur Kopfhöhe | P1-OPUS-03 | 3 | 10 | T4/S1 |
| P6-AUTOR-09 | Autor | Ausdrücke v2 neutral + freundlich | P6-OPUS-03 | 2 | 10 | T4/S2 |
| P6-AUTOR-10 | Autor | Ausdrücke v2 nachdenklich + erschrocken | P6-OPUS-03 | 2 | 10 | T4/S2 |
| P6-AUTOR-11 | Autor | portraet_test v2 (Unterschied ≥ 3 %, Ausschlüsse K9 §8, Rampen >>4) | P6-OPUS-03 | 2 | 10 | T4/S2 |
| P6-AUTOR-12 | Autor | Porträt im Gespräch und in der Fallakte | P6-OPUS-03 | 2 | 10 | T4/S2 |
| P6-PROBE-01 | Probeläufer | Figuren-Aufstellung (beide Dichten) und Porträtbogen | P6-OPUS-02, P6-AUTOR-01..08, P6-VAR-01, P6-AUTOR-09..12 | 1 | 09,10 | T8/S3 |
| P6-SICHT-01 | Sichtprüfer | Figuren-Sichtprüfung im A-605-Format mit Zeile „Figurenstand <hash>“ aus figurenstand() (Stimme 1/3) | P0-AUTOR-06, P6-PROBE-01 | 2 | 09,13 | T9/S1 |
| P6-SICHT-02 | Sichtprüfer | Figuren-Sichtprüfung im A-605-Format mit Zeile „Figurenstand <hash>“ aus figurenstand() (Stimme 2/3) | P0-AUTOR-06, P6-PROBE-01 | 2 | 09,13 | T9/S2 |
| P6-SICHT-03 | Sichtprüfer | Figuren-Sichtprüfung im A-605-Format mit Zeile „Figurenstand <hash>“ aus figurenstand() (Stimme 3/3) | P0-AUTOR-06, P6-PROBE-01 | 2 | 09,13 | T9/S2 |
| P6-GEGEN-01 | Gegenprüfer | Angriff: Kanon-Kleidung, Grünregel, Ausschlüsse K9 §8 | P6-PROBE-01 | 2 | 09,10 | T9/S2 |

**P7 Oberfläche (17 Pakete, davon 0 Opus)**

| ID | Rolle | Gegenstand | Abhängig von | St | HZ | T/S |
|---|---|---|---|---|---|---|
| P7-AUTOR-01 | Autor | Knöpfe v2 (Licht-/Schattenkante, Zustände) | P1-OPUS-03 | 2 | 11 | T2/S2 |
| P7-AUTOR-02 | Autor | Panels v2 | P1-OPUS-03 | 2 | 11 | T2/S2 |
| P7-AUTOR-03 | Autor | Hauptmenü-Hintergrund als HD-Szene, Hinweis mit Kontrast | P1-OPUS-03 | 2 | 11 | T2/S2 |
| P7-AUTOR-04 | Autor | Sprechblasen-Layout (Kollision, Rand) + ui_test | P1-OPUS-03 | 2 | 11 | T2/S2 |
| P7-AUTOR-05 | Autor | Stadtkarte mit Gebäudesilhouetten (Cache) | P1-OPUS-03 | 2 | 11 | T2/S2 |
| P7-AUTOR-06 | Autor | Stadtkarte Beschriftungsboxen + stadtkarte_test v2 | P1-OPUS-03 | 2 | 11 | T2/S2 |
| P7-AUTOR-07 | Autor | Kompass v2 | P1-OPUS-03 | 2 | 11 | T2/S2 |
| P7-AUTOR-08 | Autor | Fallakte + Lagerunde: Porträt-Rahmen und Fäden | P6-AUTOR-12 | 2 | 11 | T8/S3 |
| P7-AUTOR-09 | Autor | Optionen: „auto“ und gemessene Bilder/s | P1-OPUS-10 | 2 | 11 | T3/S3 |
| P7-AUTOR-10 | Autor | Anklage-Bildschirm v2 | P1-OPUS-03 | 2 | 11 | T2/S2 |
| P7-AUTOR-11 | Autor | WLAN-Bildschirm und Lobby v2 | P1-OPUS-03 | 2 | 11 | T2/S2 |
| P7-AUTOR-12 | Autor | Tutorial-Overlay v2 (nur Optik, Texte unverändert) | P1-OPUS-03 | 2 | 11 | T2/S2 |
| P7-SICHT-01 | Sichtprüfer | 8 Bildschirme + Tutorial, hoch und quer (Stimme 1/3) | P7-AUTOR-01..12 | 2 | 11 | T9/S2 |
| P7-SICHT-02 | Sichtprüfer | 8 Bildschirme + Tutorial, hoch und quer (Stimme 2/3) | P7-AUTOR-01..12 | 2 | 11 | T9/S2 |
| P7-SICHT-03 | Sichtprüfer | 8 Bildschirme + Tutorial, hoch und quer (Stimme 3/3) | P7-AUTOR-01..12 | 2 | 11 | T9/S2 |
| P7-GEGEN-01 | Gegenprüfer | Angriff: Lesbarkeit, Texte unverändert (Tutorial-Texte sind textPfad) | P7-AUTOR-01..12 | 2 | 11,13 | T9/S2 |
| P7-PROBE-01 | Probeläufer | geraete.js in 3 Profilen (Bedienung, Konsole, pixel_pruef) | P7-AUTOR-01..12 | 1 | 11,12 | T9/S2 |

**P8 Leistung und Feinschliff (16 Pakete, davon 2 Opus)**

| ID | Rolle | Gegenstand | Abhängig von | St | HZ | T/S |
|---|---|---|---|---|---|---|
| P8-OPUS-01 | Opus | Profiling „scharf“ in allen 6 Vierteln, Engstellen beheben | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P3-SICHT-01..03, P3-PROBE-01, P3-GEGEN-01, P4-PRUEF-02, P4-SICHT-01..03, P4-PROBE-01, P4-GEGEN-01, P5-SICHT-01..03, P5-GEGEN-01, P5-ANALYST-01, P6-SICHT-01..03, P6-GEGEN-01 | 3 | 12 | T9/S3 |
| P8-AUTOR-01 | Autor | Feinschliff Marktviertel: alle offenen Sichtbefunde des Viertels schließen (Ziel 0) | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P3-SICHT-01..03, P3-PROBE-01, P3-GEGEN-01, P4-PRUEF-02, P4-SICHT-01..03, P4-PROBE-01, P4-GEGEN-01, P5-SICHT-01..03, P5-GEGEN-01, P5-ANALYST-01, P6-SICHT-01..03, P6-GEGEN-01 | 2 | 05,06,07,08 | T9/S3 |
| P8-AUTOR-02 | Autor | Feinschliff Handwerkergasse: alle offenen Sichtbefunde des Viertels schließen (Ziel 0) | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P3-SICHT-01..03, P3-PROBE-01, P3-GEGEN-01, P4-PRUEF-02, P4-SICHT-01..03, P4-PROBE-01, P4-GEGEN-01, P5-SICHT-01..03, P5-GEGEN-01, P5-ANALYST-01, P6-SICHT-01..03, P6-GEGEN-01 | 2 | 05,06,07,08 | T9/S3 |
| P8-AUTOR-03 | Autor | Feinschliff Kirchhügel: alle offenen Sichtbefunde des Viertels schließen (Ziel 0) | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P3-SICHT-01..03, P3-PROBE-01, P3-GEGEN-01, P4-PRUEF-02, P4-SICHT-01..03, P4-PROBE-01, P4-GEGEN-01, P5-SICHT-01..03, P5-GEGEN-01, P5-ANALYST-01, P6-SICHT-01..03, P6-GEGEN-01 | 2 | 05,06,07,08 | T9/S3 |
| P8-AUTOR-04 | Autor | Feinschliff Untere Stadt: alle offenen Sichtbefunde des Viertels schließen (Ziel 0) | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P3-SICHT-01..03, P3-PROBE-01, P3-GEGEN-01, P4-PRUEF-02, P4-SICHT-01..03, P4-PROBE-01, P4-GEGEN-01, P5-SICHT-01..03, P5-GEGEN-01, P5-ANALYST-01, P6-SICHT-01..03, P6-GEGEN-01 | 2 | 05,06,07,08 | T9/S3 |
| P8-AUTOR-05 | Autor | Feinschliff Mauerviertel: alle offenen Sichtbefunde des Viertels schließen (Ziel 0) | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P3-SICHT-01..03, P3-PROBE-01, P3-GEGEN-01, P4-PRUEF-02, P4-SICHT-01..03, P4-PROBE-01, P4-GEGEN-01, P5-SICHT-01..03, P5-GEGEN-01, P5-ANALYST-01, P6-SICHT-01..03, P6-GEGEN-01 | 2 | 05,06,07,08 | T9/S3 |
| P8-AUTOR-06 | Autor | Feinschliff Burgberg: alle offenen Sichtbefunde des Viertels schließen (Ziel 0) | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P3-SICHT-01..03, P3-PROBE-01, P3-GEGEN-01, P4-PRUEF-02, P4-SICHT-01..03, P4-PROBE-01, P4-GEGEN-01, P5-SICHT-01..03, P5-GEGEN-01, P5-ANALYST-01, P6-SICHT-01..03, P6-GEGEN-01 | 2 | 05,06,07,08 | T9/S3 |
| P8-AUTOR-07 | Autor | Feinschliff Fall-Orte 1–6: offene Sichtbefunde schließen | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P3-SICHT-01..03, P3-PROBE-01, P3-GEGEN-01, P4-PRUEF-02, P4-SICHT-01..03, P4-PROBE-01, P4-GEGEN-01, P5-SICHT-01..03, P5-GEGEN-01, P5-ANALYST-01, P6-SICHT-01..03, P6-GEGEN-01 | 2 | 07 | T9/S3 |
| P8-AUTOR-08 | Autor | Feinschliff Fall-Orte 7–12: offene Sichtbefunde schließen | P2-PRUEF-01..04, P2-SICHT-01..03, P2-GEGEN-01, P3-SICHT-01..03, P3-PROBE-01, P3-GEGEN-01, P4-PRUEF-02, P4-SICHT-01..03, P4-PROBE-01, P4-GEGEN-01, P5-SICHT-01..03, P5-GEGEN-01, P5-ANALYST-01, P6-SICHT-01..03, P6-GEGEN-01 | 2 | 07 | T9/S3 |
| P8-OPUS-02 | Opus | Automatische Wahl final (Startprobe, Hysterese, Web/nativ) | P7-SICHT-01..03, P7-GEGEN-01, P7-PROBE-01, P8-OPUS-01 | 3 | 12 | T10/S1 |
| P8-ANALYST-01 | Analyst | leistung.dart je Stufe, Budget je Ansicht | P8-OPUS-02 | 2 | 12 | T10/S2 |
| P8-PROBE-01 | Probeläufer | geraete.js mit 4-facher Drosselung, gelieferte Bilder/s | P8-OPUS-02 | 1 | 12 | T10/S2 |
| P8-SICHT-01 | Sichtprüfer | Gesamtrundgang alle Viertel und Räume (Stimme 1/3) | P8-AUTOR-01..08, P8-OPUS-02 | 2 | 05,07,08 | T10/S2 |
| P8-SICHT-02 | Sichtprüfer | Gesamtrundgang alle Viertel und Räume (Stimme 2/3) | P8-AUTOR-01..08, P8-OPUS-02 | 2 | 05,07,08 | T10/S2 |
| P8-SICHT-03 | Sichtprüfer | Gesamtrundgang alle Viertel und Räume (Stimme 3/3) | P8-AUTOR-01..08, P8-OPUS-02 | 2 | 05,07,08 | T10/S2 |
| P8-GEGEN-01 | Gegenprüfer | Vorab-Scheitern-Rückblick gegen HZ-01…14 | P8-AUTOR-01..08, P8-OPUS-02 | 2 | 12,13 | T10/S2 |

**P9 Abnahme und Übergabe (9 Pakete, davon 3 Opus)**

| ID | Rolle | Gegenstand | Abhängig von | St | HZ | T/S |
|---|---|---|---|---|---|---|
| P9-PROBE-01 | Probeläufer | alle_tests.sh voll | P8-ANALYST-01, P8-PROBE-01, P8-SICHT-01..03, P8-GEGEN-01 | 1 | 14 | T10/S3 |
| P9-PROBE-02 | Probeläufer | dart run tool/abnahme.dart (Nachtlauf ≥ Ausgang, Z-03 grün) | P8-ANALYST-01, P8-PROBE-01, P8-SICHT-01..03, P8-GEGEN-01 | 1 | 13 | T10/S3 |
| P9-PROBE-03 | Probeläufer | HD-Belegfotos final (2 Formate, alle Stufen) + Gerätefoto | P8-ANALYST-01, P8-PROBE-01, P8-SICHT-01..03, P8-GEGEN-01 | 1 | 01,14 | T10/S3 |
| P9-OPUS-01 | Opus | hd_abnahme final über alle Ebenen | P9-PROBE-01..03 | 3 | 14 | T11/S1 |
| P9-MONT-01 | Monteur | Vorher/Nachher-Paare: ≥ 1 je HZ, 6 Viertel, 12 Fall-Orte, Gerätefoto | P9-PROBE-03 | 1 | 14 | T11/S1 |
| P9-OPUS-02 | Opus | Galerie als Artifact (Kategorien, Umschalter vorher/nachher) | P9-MONT-01 | 3 | 14 | T11/S2 |
| P9-VERD-01 | Verdichter | Abschlussbericht-Entwurf aus den Protokollen | P9-PROBE-01..03 | 2 | 14 | T11/S1 |
| P9-GEGEN-01 | Gegenprüfer | Angriff auf den Bericht: jede Behauptung belegt? | P9-OPUS-01, P9-VERD-01 | 2 | 14 | T11/S2 |
| P9-OPUS-03 | Opus | Abschlussbericht, Prüfpunkt, Push; ZIEL ERREICHT nur, wenn hd_abnahme HD-ZIEL ERREICHT meldet | P9-OPUS-02, P9-GEGEN-01 | 3 | 01-14 | T11/S3 |

### Schichtplan (aus dem Abhängigkeitsgraphen gepackt: je Schicht ≤ 12 Haiku-Pakete + ≤ 2 Opus-Pakete; „abhängig von X“ heißt X liegt in einer früheren Schicht)

| Schicht | Haiku (Anzahl) | Opus | Pakete |
|---|---|---|---|
| T1/S1 | 6 | P0-OPUS-01..02 | P0-KUND-01..06 |
| T1/S2 | 6 | P0-OPUS-03 | P0-PROBE-01, P0-AUTOR-01..04, P0-PROBE-03 |
| T1/S3 | 4 | – | P0-AUTOR-05, P0-PROBE-02, P0-AUTOR-06, P0-GEGEN-01 |
| T2/S1 | 3 | P1-OPUS-01, P1-OPUS-03 | P0-SICHT-01..03 |
| T2/S2 | 11 | P1-OPUS-02, P1-OPUS-05 | P1-AUTOR-01, P7-AUTOR-01..07, P7-AUTOR-10..12 |
| T2/S3 | 12 | P1-OPUS-04, P1-OPUS-07 | P1-AUTOR-03..04, P1-VAR-01, P1-AUTOR-05, P1-VAR-02, P1-AUTOR-06..08, P4-AUTOR-01..04 |
| T3/S1 | 12 | P1-OPUS-06, P1-OPUS-08 | P1-SICHT-01..02, P4-AUTOR-05..14 |
| T3/S2 | 12 | P1-OPUS-09..10 | P4-AUTOR-15..20, P5-AUTOR-03..08 |
| T3/S3 | 4 | P1-OPUS-11..12 | P1-AUTOR-02, P5-AUTOR-09, P5-AUTOR-11, P7-AUTOR-09 |
| T4/S1 | 2 | P5-OPUS-01, P6-OPUS-03 | P1-PROBE-01, P6-ANALYST-01 |
| T4/S2 | 11 | P6-OPUS-01 | P1-GEGEN-01, P1-SICHT-03, P1-ANALYST-01..03, P5-AUTOR-01..02, P6-AUTOR-09..12 |
| T4/S3 | 12 | P3-OPUS-01, P4-OPUS-01 | P2-AUTOR-06..07, P2-AUTOR-10, P2-AUTOR-12..13, P2-AUTOR-19, P2-AUTOR-23..28 |
| T5/S1 | 12 | P3-OPUS-02, P4-OPUS-02 | P2-AUTOR-18, P2-AUTOR-29..37, P2-AUTOR-42, P2-AUTOR-45 |
| T5/S2 | 12 | P6-OPUS-02 | P2-AUTOR-46..47, P3-AUTOR-01..10 |
| T5/S3 | 12 | – | P3-AUTOR-11..22 |
| T6/S1 | 12 | – | P2-AUTOR-09, P2-AUTOR-17, P2-AUTOR-38, P3-AUTOR-23..26, P3-VAR-01, P4-AUTOR-21..24 |
| T6/S2 | 12 | – | P2-AUTOR-01..05, P2-AUTOR-08, P2-AUTOR-11, P3-PRUEF-01, P4-AUTOR-25..27, P4-AUTOR-50 |
| T6/S3 | 12 | – | P2-AUTOR-14..16, P2-AUTOR-20..22, P2-AUTOR-39..41, P2-AUTOR-43..44, P2-VAR-01 |
| T7/S1 | 12 | – | P2-VAR-02..04, P3-AUTOR-27..35 |
| T7/S2 | 12 | – | P3-AUTOR-36..44, P4-AUTOR-28..30 |
| T7/S3 | 12 | P3-OPUS-03 | P2-PRUEF-01, P4-AUTOR-31, P4-PRUEF-01, P6-AUTOR-01..08, P6-VAR-01 |
| T8/S1 | 12 | – | P2-PRUEF-02..04, P2-SICHT-01..03, P2-GEGEN-01, P3-PRUEF-02, P4-AUTOR-32..35 |
| T8/S2 | 12 | – | P4-AUTOR-36..47 |
| T8/S3 | 10 | – | P3-SICHT-01..03, P3-PROBE-01, P3-GEGEN-01, P4-AUTOR-48..49, P5-AUTOR-10, P6-PROBE-01, P7-AUTOR-08 |
| T9/S1 | 12 | – | P4-PRUEF-02, P4-SICHT-01..03, P4-PROBE-01, P4-GEGEN-01, P5-SICHT-01..03, P5-GEGEN-01, P5-ANALYST-01, P6-SICHT-01 |
| T9/S2 | 8 | – | P6-SICHT-02..03, P6-GEGEN-01, P7-SICHT-01..03, P7-GEGEN-01, P7-PROBE-01 |
| T9/S3 | 8 | P8-OPUS-01 | P8-AUTOR-01..08 |
| T10/S1 | 0 | P8-OPUS-02 | – (Puffer/Vorrat) |
| T10/S2 | 6 | – | P8-ANALYST-01, P8-PROBE-01, P8-SICHT-01..03, P8-GEGEN-01 |
| T10/S3 | 3 | – | P9-PROBE-01..03 |
| T11/S1 | 2 | P9-OPUS-01 | P9-MONT-01, P9-VERD-01 |
| T11/S2 | 1 | P9-OPUS-02 | P9-GEGEN-01 |
| T11/S3 | 0 | P9-OPUS-03 | – (Puffer/Vorrat) |

**Vorrat** (für die 119 freien Plätze und Leerlauf; jeweils mit Zielbeitrag):

| ID | Gegenstand | HZ |
|---|---|---|
| V-01 | Isolate-Bänder für den nativen Rasterer | 12 |
| V-02 | Lichtkarten (4 Texel/m) | 08 |
| V-03 | Raureif- und Schnee-Variante der Dächer | 05 |
| V-04 | Mondspiegelung im Fensterglas, Blickwinkel-Variante | 05 |
| V-05 | Zusatzvarianten der Fassaden je Haus | 05 |
| V-06 | Gegenproben auf freigegebenen Paketen älterer Phasen (Probeläufer) | HZ-ID des geprüften Pakets |

---

## STATION H – SCHICHTPLAN
Der Schichtplan steht in der Tabelle unter dem Feinplan; er ist aus demselben Graphen erzeugt.
- **Auslastung:** Freie Haiku-Plätze (vor allem T1–T2, T4 und T9–T11) bekommen REP-Pakete, Vorrat und Gegenproben (V-06), nie Füllstoff.
- **Puffer:** 119 freie Haiku-Plätze im Plan, dazu T12.
- **Frist:** keine. Nennst du eine, rechne ich rückwärts.

## Betrieb und Regelkreise
- **Agentenmodus:** Haiku über Agent/Workflow mit `model: haiku`; Worktree nur bei geteilten Dateien.
- **L1 Paket:** Abnahme nach A–H (≥ 14/16, keine 0), höchstens 2 Reparaturrunden, danach übernehme ich.
- **L2 Schicht:**
  - Integration und Registrierung
  - `alle_tests.sh schnell` und Layout-Prüfsumme
  - `hd_commit.sh`
  - Bilder der Schicht an dich
  - Status aktualisieren
- **L3 Tor:**
  - voller Lauf `alle_tests.sh`
  - Sichtprüfer, Gegenprüfer, Probeläufer
  - Kern und Nebelkarte aktualisieren
  - Torbilder sofort an dich
- **L4 Tag:**
  - Nachtlauf-Merge
  - `hd/STATUS.md` und `hd/PRUEFPUNKT.md`
  - Push
- **L5 Lernen:** `hd/FEHLER.md`; bei Wiederholung wird das Briefing verbessert.
- **L6 Ziel:** `hd_abnahme` nach jedem Tor und Tag; Lücken werden zu Paketen.
- **Meldungen an dich:** Tagesabschluss, Tore, gebündelte Entscheidungen, Eskalationen.
- **Bilder-Regel (E-021):** Jedes erzeugte Bild sofort im Chat, mit einer Zeile Bildunterschrift und bei Vergleichen das Vorher-Bild daneben. Bilder einer Schicht kommen gebündelt am Schichtende, Durchstich und Tore sofort.

## Entscheidungslog (Kurzform)

| ID | Entscheidung |
|---|---|
| E-001 | Gegenstand ist der Burgstadt-Pixelrenderer (Sichtung, deine Antwort) |
| E-002 | Stufe „scharf“ mit doppelter linearer Auflösung (360 Zeilen auf 720p/1080p) und automatischer Wahl; „sparsam“ und „mittel“ unverändert (deine Wahl) |
| E-003 | Palette 10 × 16, Altfarben auf 2s+1, `Ramp.at` mit 8er-Bedeutung (deine Wahl plus Gegenprüfung) |
| E-004 | Arbeitsbranch auf Burgstadt vorgespult; täglicher Merge (deine Wahl) |
| E-005 | 64 Texel/m für die Welt. Weil die Brennweite sich verdoppelt, bleibt tpp gleich; Flimmern wird über Mip v2 gelöst, nicht über die Dichte |
| E-006 | Skalierung „scharf“ = UI-Raster von „mittel“ mit kWelt = kUi (Welt 2× mittel, UI identisch, monoton); andere Stufen unverändert; Blocktest-k aus kUi je Profil |
| E-007 | Silhouette durch Geometrie, Oberfläche durch Textur |
| E-008 | Zufall für Details nur über `hashTeil` |
| E-009 | Ausstattung als darstellende Daten außerhalb der textPfade, ohne Texte, nicht blockierend |
| E-010 | Register nach Name; Enum bleibt die Namensquelle |
| E-011 | Figuren in zwei Dichten; Vergleicher auf 32 |
| E-012 | Porträts werden im Spiel eingebunden |
| E-013 | Leistung: Spannen, Sortierung nach Überdeckungsmessung, Nebel je Zeile, direkte RGBA-Ausgabe, Himmel nur in leeren Tiefen, Sprite-Spannen |
| E-014 | Budget „scharf“ nach L-07, Festlegung in P3-OPUS-02 vor allen Bauteilen |
| E-015 | Lichttabelle 12×12×6×160, einmal statisch gebaut |
| E-016 | In `nachtlauf/` kommen nur neue Dateien nach A-605 (N-HD-02); HD-Dokumente liegen in `hd/`; `tool/abnahme.dart` bekommt nur die Z-13-Zeile |
| E-017 | Formate versioniert ändern (v2 mit Diff) |
| E-018 | Haiku als Arbeitsmodell; Stufe 3 übernimmt Opus (29 Pakete) mit höchstens 2 je Schicht |
| E-019 | Galerie als Artifact |
| E-020 | Flutter nach `/opt/flutter` |
| E-021 | Jedes Bild sofort im Chat (dein Wunsch) |
| E-022 | „hoch“ entfällt und wird zu `auto`; bis P1-OPUS-10 gilt `auto` = mittel, danach ist `auto` Standard |
| E-023 | Mip-Formel mit tpp, Start s = 2 (= Ausgang), Boden-Anisotropie, Cap mit der Dichte verschoben |
| E-024 | HD-Figurendetails in `data/figuren_hd` (textPfade bleiben unberührt) |
| E-025 | Grünregel bleibt |
| E-026 | Strom aus: keine neuen Lichtquellen, Laternen dunkel, Silberhau-Lichter erlaubt |
| E-027 | HZ-07 misst Formenvielfalt (≥ 4 Deko-Formen) statt Elementzahl, über alle Innen-Bereiche aus `baueWelt()` |
| E-028 | Sichtprüfer werden zuerst geeicht; an Toren 3 Stimmen |
| E-029 | Z-13 um eine Zeile erweitert und A-605-Berichte (deine Wahl „Mitführen“) |
| E-030 | Eigener Commit-Weg über `hd_commit.sh` |
| E-031 | Kanon-Bildregeln K-013 |
| E-032 | Gangnetz zählt zu den Innen-Bereichen; die Zahl kommt aus `baueWelt()` (Ausgang laut Z-04: 59) |
| E-033 | Feinplan und Schichtplan werden per Skript aus einer Paketliste erzeugt |
| E-034 | Durchstich-Tor vor der Massenproduktion; Planfrist 12 Tage (11 Produktionstage plus T12 als Puffer) |
| E-035 | Migrationsbelege (RGB-identisch nach Palette v2 und Dichte v2) statt eines dauerhaften Kompatibilitätsmodus |
| E-036 | Ausstattung als eigene Liste am Bereich, Feld `vorlage`, nur Wand-, Decken- oder Möbelanker oder flach |
| E-037 | Kerzenleuchter nur im Kamin-Gewölbe nach LA-02 (deine Wahl): Wandhalter, mehrarmig, nicht aufnehmbar, klar anders als die Tatwaffe; Kanon-Gegenprüfer prüft das (P4-AUTOR-50, P4-GEGEN-01) |
| E-038 | Rüstung „Kunibert“ in HD nur mit Kanon-Merkmalen und Kanon-Blick |
| E-039 | A-605-Berichte mit Zusatzzeile „Figurenstand <hash>“. Der Hash wird über die sortierte `git ls-files`-Liste aus `karten.json`, `rollen.json`, `teile_*.json`, `figuren_hd/` und `figur/*.dart` gebildet (10 Zeichen, P0-AUTOR-06). `hd_abnahme` prüft ihn; Z-03 zählt für HZ-13 nur zusammen mit dieser Prüfung. `abnahme.dart` bleibt bis auf die Z-13-Zeile unverändert |
| E-040 | Z-12 bleibt eine Lücke des Nachtlaufs, die nicht von HD kommt; HD verschlechtert sie nicht (textPfade unberührt) |
| E-041 | Uhren ohne Zeiger überall; Uhrturm zeigt die Spielzeit |
| E-042 | „scharf“ nur bei kUi ≥ 2 und ≤ 380.000 Weltpixeln, sonst = „mittel“ |
| E-043 | Ausstattung wird in `burgstadt_spiel` geladen und an `baueWelt()` übergeben; eigener Renderschritt (P4-OPUS-02) |

## Änderungen aus der Gegenprüfung (L0 Runde 1: 59 · Runde 2: 13 · Runde 3: 5 schwere Befunde; Schleife nach 3 Runden abgeschlossen)

| Thema | Änderung |
|---|---|
| Zählungen | Pakete, Texturen (95) und Innen-Bereiche (aus `baueWelt()`, Ausgang 59) aus der Liste bzw. dem Code abgeleitet; Opus mit 29 Paketen und eigener Kapazität |
| Schichtplan | per Skript erzeugt: höchstens 12 + 2 je Schicht; keine Abhängigkeit innerhalb derselben Schicht; Tore jeweils nach den geprüften Paketen; keine Doppelungen |
| Skalierungsformel und Mip-Formel | festgeschrieben; Größen passen zu den Werkzeugen (2401×1081 ergibt 801×361) |
| Palette | Aufrufkonvention, Regex-Audit, `Pal`-Konstanten, `blickFilter`, Wächter und Golden |
| Leistung | Ausgang in der Spielszene statt in der Demo-Szene; gelieferte Bilder/s; RGBA, Himmel, Sprites und Blickfilter einbezogen; Überdeckung gemessen |
| Abnahme | Z-13 und Z-03 nach deiner Entscheidung („Mitführen“); textPfade gesichert |
| Kanon | keine Kerzenleuchter, kein Taler-Sockel, keine neue Rüstung, keine neuen Lichter (Strom aus) |
| **Runde 3** | Zielformulierung „doppelte lineare Auflösung“ statt fester 360 Zeilen, Obergrenze und Schwellen-Testgrößen; Figurenstand-Hash festgelegt (P0-AUTOR-06) und an HZ-13 gekoppelt; Ausstattungs-Lader und -Renderschritt als P4-OPUS-02; Form-Muster schon in P1-OPUS-01; Deko nach ihren Texturen; Sichtprüfer auf die Durchstich-Bilder (P1-SICHT-03); Kerzenleuchter nach deiner Wahl (P4-AUTOR-50); Lichtungen L-01…L-07 benannt |
| **Runde 2** | Skalierung „scharf“ monoton (= UI-Raster von „mittel“); Migrationsbelege statt Kompatibilitätsmodus; Mip s = 2; `Pal` als generierte Literale; `hashTeil` dart2js-sicher; Ausstattungsanbindung mit Feld `vorlage`; Positiv-/Verbotsliste für alle Räume, formbasiert; K9 §8; Uhren ohne Zeiger; Rüstung mit Kanon-Merkmalen; Bauteile und Wandaufbau nach ihren Texturen; Tor-Gegenprüfer P1, P5, P7; 3 Stimmen an allen Toren; Basis der textPfade festgelegt; Z-12 als Nachtlauf-Lücke ausgewiesen; Go/No-Go mit Formel |
| Vollständigkeit | Gangnetz, Anklage, WLAN, Tutorial, Fledermäuse, Gärten, Hof und Wehrgang ergänzt; `bildschirmfoto` und `bereichsfotos` erhalten `--qualitaet` |
| Werkzeuge | Werkzeugkasten (öffentliche Helfer, `hashTeil`); Register nach Name; Ausstattung je Datei; Muster-Dateien |
| Messgrößen und Begriffe | Messbarkeit von HZ-07/08/12/14 geschärft; Begriffe Belegfoto und Gerätefoto getrennt; `schnell` ohne Bindestriche |
| Reihenfolge | L-06 vor P6-OPUS-01; L-07 und E-014 vor den Bauteilen; Go/No-Go vor P2 und P3 |

## Verifikation (Ende zu Ende)

| Zeitpunkt | Prüfungen |
|---|---|
| Je Schicht | `tool/alle_tests.sh schnell`; `dart run tool/layout_pruefsumme.dart` (gleich dem Ausgang); Kontaktbögen der Schicht (an dich) |
| Je Tor | `tool/alle_tests.sh` voll; Belegfotos `--qualitaet scharf` für beide Formate mit `pixel_pruef`; `szenen_mess`, `flimmer`, `banding`; `geraete.js`; Sichtprüfer |
| Zum Schluss | `dart run tool/abnahme.dart` (Nachtlauf ≥ 12/14, Z-03 grün); `dart run tool/hd_abnahme.dart` → „HD-ZIEL ERREICHT“; Galerie-Artifact; Abschlussbericht |

**Nächster Schritt für dich:** FREIGABE, oder ÄNDERUNG: …

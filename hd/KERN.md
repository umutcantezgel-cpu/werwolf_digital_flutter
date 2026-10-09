<!-- Burgstadt HD · erzeugt aus dem freigegebenen Gesamtplan v4 (Kern v1.0) · Quelle der Wahrheit ab jetzt diese Datei -->

# Burgstadt HD – KERN v1.0

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

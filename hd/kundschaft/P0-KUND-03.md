# P0-KUND-03 · Test-Bindungen

Commit: `c54fe9c` (`git -C /home/user/werwolf_digital_flutter rev-parse --short HEAD`), Branch `claude/pensive-gates-ajtp7x`.
Alle Pfade relativ zu `/home/user/werwolf_digital_flutter/`. Es wurde kein Test ausgeführt, nichts committet und nichts gepusht. Wirkungen sind aus dem Quelltext abgeleitet. Wo nur eine Prognose möglich ist, steht „Prognose“.

Legende Bindung: a = Skalierung/Qualitätsstufe (Enum `Qualitaet`, kUi/kWelt), b = Palette (64 Farben, 8 Stufen je Rampe), c = Texeldichte (32 → 64 Texel/m, TexturId), d = Figurendichte (48×80 → 96×160), e = Porträtgröße (64 → 128).

## Tabelle

| Nr | Datei:Zeile | Erwartung (gekürzt) | Bindung | Wirkung | Zielpaket |
|---|---|---|---|---|---|
| 01 | packages/burgstadt_spiel/test/spiel_test.dart:11-19 | Alle Größen × alle `Qualitaet.values`: kWelt gerade, kUi·2 = kWelt, Welt und UI decken den Schirm | a (Enum) | bleibt grün. `auto` und `scharf` werden automatisch mitgeprüft (Schleife :12). `auto` braucht eine auflösbare Skalierung, das Enum hat dafür kein Feld (packages/burgstadt_spiel/lib/src/skalierung.dart:4-11) | P1-OPUS-02 |
| 02 | packages/burgstadt_spiel/test/spiel_test.dart:22 | `Skalierung.fuer(1280,720,mittel).weltH == 180` | a (Wert mittel) | bleibt grün, solange mittel 180 Zeilen behält | P1-OPUS-02 |
| 03 | packages/burgstadt_spiel/test/spiel_test.dart:23 | `Skalierung.fuer(2401,1081,mittel).weltH == 181` | a (Wert mittel) | bleibt grün (wie 02) | P1-OPUS-02 |
| 04 | packages/burgstadt_spiel/test/spiel_test.dart:28-36 | Hauptmenü, Optionen, Erkundung bei 1280×720, 2401×1081, 1081×2401: Palettentest 0, Blocktest mit k = kUi (:35) ratio 1.0 | a (kUi) | bleibt grün formal. Bei einer Stufe mit 360 Zeilen (Auftrag) ist bei 720p kUi = 1; dann ist der Blocktest immer 100 % und prüft keine Welt-Blöcke (kWelt = 2) | P1-OPUS-02 |
| 05 | packages/burgstadt_spiel/test/spiel_test.dart:34 | `countOffPalette(rgba) == 0` | b (Palette 64) | bleibt grün, solange nur Palettenfarben gezeichnet werden (Zählung gegen `paletteRgb`, packages/pixel_engine/lib/src/pruef.dart:9-18) | P1-OPUS-03 |
| 06 | packages/burgstadt_spiel/test/spiel_test.dart:75-82 | Knopf „Allein spielen“: Suche nach `UiFarbe.rand` in der Bildmitte, Zeile `ky = y + 6` | a (UI-Pixel) | bleibt grün (Suche ist dynamisch). Der Versatz +6 ist ein festes UI-Pixel-Maß | P1-OPUS-02 |
| 07 | packages/burgstadt_spiel/test/spiel_test.dart:90-98 | Joystick: Zeiger bei x = 100 bewegt die Figur um mehr als 0,5 m | a (Joystick-Grenze `z.x < uiW / 2`, packages/burgstadt_spiel/lib/src/steuerung.dart:30) | bleibt grün (100 liegt bei kUi 1 und 2 links der Grenze) | P1-OPUS-02 |
| 08 | packages/burgstadt_spiel/test/spiel_test.dart:99-105 | Blick: Zeiger x = 500 → 560 (rechte Hälfte) ändert `yaw` | a (steuerung.dart:30) | BRICHT bei kUi = 1 (720p, uiW = 1280, Grenze 640): x = 500 wird Joystick statt Blickfinger, yaw bleibt gleich | P1-OPUS-02 |
| 09 | packages/burgstadt_spiel/test/spielstand_test.dart:11, :31; packages/burgstadt_spiel/test/wlan_test.dart:26; packages/burgstadt_spiel/test/spiel_test.dart:133, :156 | Spiel bei 640×360 | a (Größe) | bleibt grün. Bei mittel ergibt 640×360 schon heute kWelt 2 und kUi 1 (skalierung.dart:29-35). Dort wird kein Blocktest geprüft | P1-OPUS-02 |
| 10 | packages/burgstadt_spiel/test/stadtkarte_test.dart:55-63 | 1280×720 und 1080×2400: Palettentest 0 (:61), Blocktest k = kUi (:62-63) | a (kUi) + b | bleibt grün. Bei kUi = 1 wirkungslos (wie 04) | P1-AUTOR-02 |
| 11 | packages/burgstadt_spiel/test/stadtkarte_test.dart:70-81 | Markierungen über Farbe: `Pal.candleLight` (Kommentar „Palette 38“, :70) und `Ramp.at(Ramp.amber, 3)` (:81) | b (Index 38 = Rampe 4, Stufe 6 im 8er-Schema; packages/pixel_engine/lib/src/palette.dart:40, :80) | bleibt grün, wenn die Konstanten neu gesetzt werden. Kommentar „Palette 38“ und Rampenangabe werden falsch | P1-AUTOR-02 (Auslöser P1-OPUS-03) |
| 12 | packages/burgstadt_spiel/test/stadtkarte_test.dart:142 | Kompass: alle Pixel `kTransparent` oder `c < 64` | b (8×8 = 64) | muss erweitert werden: `< 64` ist bei 160 Farben zu schwach. Richtig ist `paletteRgb.length` | P1-AUTOR-02 (Auslöser P1-OPUS-03) |
| 13 | packages/burgstadt_spiel/test/wlan_test.dart:120-132 | WLAN-Bildschirm 1280×720 und 1080×2400: Palette 0 (:131), `blockTest(rgba,w,h,kUi)` ratio 1.0 (:132) | a (kUi) | bleibt grün. Bei kUi = 1 wirkungslos. Kein Flächenausschnitt wie spiel_test.dart:35 | P1-OPUS-02 (Zuordnung, nicht in der Zielliste) |
| 14 | packages/burgstadt_spiel/test/wlan_test.dart:117 | Gast-Erkundung: `countOffPalette(rgba) == 0` | b | bleibt grün | P1-OPUS-03 |
| 15 | packages/burgstadt_spiel/test/fledermaeuse_test.dart:58-63 | 3 Bat-Sprites, 9×5 Pixel, Fußpunkt (4,2) | a (Welt-Pixel) | bleibt grün. Die Sprites bleiben bei kWelt-Wechsel in Welt-Pixeln unverändert (Entscheidung offen) | P1-AUTOR-02 |
| 16 | packages/burgstadt_spiel/test/fledermaeuse_test.dart:70 | Sprite-Index `< paletteRgb.length` | b | bleibt grün (wächst mit der Palette) | P1-AUTOR-02 |
| 17 | packages/burgstadt_spiel/test/fledermaeuse_test.dart:79 | helle Kontur: Randpixel `c & 7 <= 4` | b (8 Stufen, `& 7`) | BRICHT bei 16 Stufen (Stufe steckt in `& 15`, Schwelle neu festlegen) | P1-AUTOR-02 (Auslöser P1-OPUS-03) |
| 18 | packages/burgstadt_spiel/test/fledermaeuse_test.dart:87-107 | Gerendertes Bild 240×135: Sprites ≤ 12 (:102), Palette 0 alle 60 Ticks (:104) | a (Puffer 240×135) + b | bleibt grün. Der Puffer ist kein HD-Maß (Lücke) | P1-AUTOR-02 |
| 19 | packages/pixel_engine/test/pixel_test.dart:10-12 | Palette: 64 Farben, keine Doppelten | b | BRICHT (160 Farben) | P1-AUTOR-02 (Auslöser P1-OPUS-03) |
| 20 | packages/pixel_engine/test/pixel_test.dart:13-14 | 9 K8-Kernfarben sind in `paletteRgb` (palette.dart:3-4) | b | bleibt grün, wenn die K8-Farben im neuen Satz erhalten bleiben (Kanon fest) | P1-AUTOR-02 (Auslöser P1-OPUS-03) |
| 21 | packages/pixel_engine/test/pixel_test.dart:20 | Lichttabelle: `table.every(i < 64)` | b | BRICHT (Indizes bis 159) | P1-AUTOR-02 (Auslöser P1-OPUS-03) |
| 22 | packages/pixel_engine/test/pixel_test.dart:22-23 | `lookup(Pal.candle,3,0,0) >> 3 == Ramp.amber` | b (`>> 3`) | BRICHT bei 16 Stufen (`>> 4`) | P1-AUTOR-02 (Auslöser P1-OPUS-03) |
| 23 | packages/pixel_engine/test/pixel_test.dart:39 | Szene: `fb.color.every(c < 64)` | b | BRICHT (Schranke auf Palettengröße setzen) | P1-AUTOR-02 |
| 24 | packages/pixel_engine/test/pixel_test.dart:42-46 | Szene 320×180, ×3 hochskaliert, Blocktest k = 3 ratio 1.0; verschoben (ox 1) < 0.9 | a (Puffer = mittel) | bleibt grün. k = 3 ist fest und hängt nicht an kUi | P1-AUTOR-02 |
| 25 | packages/pixel_engine/test/texturen_test.dart:26-27 | `TexturId.values.length == 36` | c (Texturkatalog) | BRICHT, sobald Texturen ergänzt oder ersetzt werden (feste Zahl) | P1-AUTOR-01 |
| 26 | packages/pixel_engine/test/texturen_test.dart:37-40 | Größe 32×32 oder 64×64: `[32, 64]` (:39) | c (32 → 64 Texel/m) | muss erweitert werden, falls 128er-Texturen kommen | P1-AUTOR-01 |
| 27 | packages/pixel_engine/test/texturen_test.dart:43-48 | Palettenindizes `< 64` (:46), keine Transparenz (:48) | b | BRICHT (v2 nutzt Indizes bis 159) | P1-AUTOR-01 (Auslöser P1-OPUS-03) |
| 28 | packages/pixel_engine/test/texturen_test.dart:10, :13-23, :51-54 | Kachelbar: ≥ 60 % der Randpaare gleich oder benachbart. `_benachbart` nutzt `a >> 3` und Betrag(a − b) ≤ 1 | b (8er-Rampen) | BRICHT (Rampe bei 16 Stufen nicht `>> 3`) | P1-AUTOR-01 |
| 29 | packages/pixel_engine/test/texturen_test.dart:56-59 | Höchstens 5 Farben je Textur. Kommentar :56 nennt „Abnahme: höchstens 6“ | c (Stilregel bei 64 Texel/m) | bleibt grün. Grenze 5 widerspricht dem Kommentar. Die Quelle „6“ fand sich nicht in nachtlauf/ABNAHME.md | P1-AUTOR-01 |
| 30 | packages/pixel_engine/test/texturen_test.dart:61-65, :7 | Grün (Rampe 5) nur bei Moos, Wiese, Bruchstein: `c >> 3 == Ramp.green` (:63) | b | BRICHT (Grün-Ausdruck `>> 3`) | P1-AUTOR-01 (Auslöser P1-OPUS-03) |
| 31 | packages/pixel_engine/test/texturen_test.dart:7, :62 | Namen `dachBiberschwanzMoos`, `wiese`, `bruchsteinMauer` | TexturId-Namen | bleibt grün, solange die Namen bestehen | P1-AUTOR-01 |
| 32 | packages/burgstadt_core/test/innenraeume_haeuser_test.dart:44-51, :179-186 | Texturnamen aus haeuser.json müssen in `enum TexturId` stehen. Parser `^\s*([a-zA-Z]\w*),` (:50) | c (TexturId-Namen) | bleibt grün, solange bestehende Namen erhalten bleiben (Daten eingefroren). Parser verlangt eine Zeile je Name mit Komma | P1-AUTOR-01 |
| 33 | packages/burgstadt_core/test/innenraeume_fallorte_test.dart:88-96, :151-164 | Texturnamen aus fallorte.json in `enum TexturId`. Zweiter Parser `enum TexturId\s*\{([^}]*)\}` (:90) | c (TexturId-Namen) | bleibt grün. Zwei Parser mit unterschiedlichen Regeln (haeuser :49, fallorte :90) | P1-AUTOR-01 |
| 34 | packages/burgstadt_core/test/innenraeume_fallorte_test.dart:152 | `TexturId` hat mehr als 30 Namen | c | bleibt grün (36 Namen) | P1-AUTOR-01 |
| 35 | packages/pixel_engine/test/portraet_test.dart:43, :48 | 66 Karten × 4 Ausdrücke: 64×64, Fußpunkt x 32, y 63 | e (Porträtgröße) | BRICHT bei 128×128 (Fußpunkt 64/127 nötig; packages/pixel_engine/lib/src/figur/portraet.dart:24-28) | P6-AUTOR-11 |
| 36 | packages/pixel_engine/test/portraet_test.dart:51-53 | Pixel `c >= 64` (außer 255) ergibt Befund | b (+ e) | BRICHT (Palette 160) | P6-AUTOR-11 (Auslöser P1-OPUS-03) |
| 37 | packages/pixel_engine/test/portraet_test.dart:59 | je Bild ≥ 1500 sichtbare Pixel | e | bleibt grün bei 128 (Schwelle zu schwach). Muss auf Fläche (×4) skaliert werden | P6-AUTOR-11 |
| 38 | packages/pixel_engine/test/portraet_test.dart:69, :72-76 | Augen (Index 1): `y >= 0.7 * 64` (:72), Zeilen 10–50 (:73), ≤ 12 Pixel (:76) | e | muss erweitert werden: Zeilenmaße verdoppeln (0,7·128; Zeilen 20–100), Pixelzahl ×4 | P6-AUTOR-11 |
| 39 | packages/pixel_engine/test/portraet_test.dart:85-91 | Rampe 5 = Indizes 40–47 (`c >= 40 && c <= 47`, :87). `hatGruen` über `m.rampe == 5` (:85) | b | BRICHT: Rampe 5 läge in der 16-Stufen-Palette bei 80–95 | P6-AUTOR-11 (Auslöser P1-OPUS-03) |
| 40 | packages/pixel_engine/test/portraet_test.dart:102, :104 | Ausdrucks-Paare ≥ 12 Pixel (:102). Änderungen nur in Zeilen 10–50 (:104) | e | muss erweitert werden (Zeilen 20–100; 12 Pixel zu schwach) | P6-AUTOR-11 |
| 41 | packages/pixel_engine/test/portraet_test.dart:118 | je Ausdruck: zwei Figuren unterscheiden sich in ≥ 150 Pixeln | e | muss auf die 128er-Fläche skaliert werden | P6-AUTOR-11 |
| 42 | packages/pixel_engine/test/figur_test.dart:13-14 | Animationen vorhanden (stehen, gehen, sprechen, untersuchen, erschrecken, zeigen). `gehen` hat 4 Bilder | d | bleibt grün (Anzahl der Bilder ist dichteunabhängig) | P6-AUTOR-07 |
| 43 | packages/pixel_engine/test/figur_test.dart:15-16 | `pruefeFigur(satz)` ohne Befund | d + b (über sprite_pruef.dart) | bleibt grün, wenn `FigurBaker.breite/hoehe/fussX/fussY` (packages/pixel_engine/lib/src/figur/baker.dart:35) mit der Dichte wandern. Palettenregeln brechen (siehe 47, 48, 51) | P6-AUTOR-07 |
| 44 | packages/pixel_engine/test/figur_test.dart:40-41 | Höhe 1,75 m: 54–66 px (:41). Kind 10 px niedriger (:40) | c + d | BRICHT bei 64 Texel/m und 96×160. Höhe in Pixeln = Meter × kTexelsPerMeter (baker.dart:168): 1,75 × 32 = 56 px, bei 64 Texel/m 112 px | P1-OPUS-05 (Maß), P6-AUTOR-07 (Test) |
| 45 | packages/pixel_engine/test/figur_test.dart:48, :52, :55-56 | Augen: Index `Ramp.at(neutral,1)` im Kopffenster von 14 Zeilen (:48). `augen(0) >= 2` (:55). Seitlich weniger (:56) | d + b | muss geprüft werden: 14 Zeilen sind bei 160 Zeilen nur halbe Kopfhöhe. Augenpixel ändern sich (Prognose) | P6-AUTOR-07 |
| 46 | packages/pixel_engine/lib/src/figur/sprite_pruef.dart:18-19 | Größe `FigurBaker.breite × hoehe` und Fußpunkt `fussX/fussY` | d | bleibt grün, wenn die Konstanten (baker.dart:35: 48, 80, 24, 77) mit der Dichte wandern. Sonst Befund für jede Figur | P6-AUTOR-07 (Auslöser P1-OPUS-05) |
| 47 | packages/pixel_engine/lib/src/figur/sprite_pruef.dart:26 | Index `c >= 64` wird als „außerhalb der Palette“ gemeldet | b | BRICHT: gültige Indizes 64–159 würden als Fehler gemeldet | P6-AUTOR-07 (Auslöser P1-OPUS-03) |
| 48 | packages/pixel_engine/lib/src/figur/sprite_pruef.dart:34 | Helle Kontur: Randpixel mit `(c & 7) > 4` | b | BRICHT bei 16 Stufen (`& 15`, neue Schwelle) | P6-AUTOR-07 |
| 49 | packages/pixel_engine/lib/src/figur/sprite_pruef.dart:37 | `deckend < 200` Pixel je Richtung | d | bleibt grün bei 96×160 (mehr Pixel). Muss auf Fläche skaliert werden | P6-AUTOR-07 |
| 50 | packages/pixel_engine/lib/src/figur/sprite_pruef.dart:38 | Füße in Zeilen `footY − 3 … footY + 1` | d | muss skaliert werden (Toleranz bei 2× auf −6 … +2) | P6-AUTOR-07 |
| 51 | packages/pixel_engine/lib/src/figur/sprite_pruef.dart:63 | Material `rampe` und `stufe` je 0–7 | b | BRICHT für v2-Werte (Rampe 0–9, Stufe 0–15) | P6-AUTOR-07 (Auslöser P1-OPUS-03) |
| 52 | packages/pixel_engine/test/teile_kleidung_test.dart:97-103 | Jedes Teil brennt auf der Probe-Karte; `pruefeKarte` und `pruefeFigur` ohne Befund | b + d (sprite_pruef.dart:18-19, :26, :34, :63) | BRICHT, sobald Palette v2 oder neue Maße gelten, bis sprite_pruef angepasst ist | P6-AUTOR-07 |
| 53 | packages/pixel_engine/test/teile_kleidung_test.dart:105-121 | Jedes Teil sichtbar: ≥ 4 Pixel Unterschied in 8 Richtungen (:119) | d | bleibt grün (Schwelle weich). Muss neu kalibriert werden | P6-AUTOR-07 |
| 54 | packages/pixel_engine/test/teile_kleidung_test.dart:123-127, :36-45 | Gesicht frei: genau 2 Augenpixel (:125), Fenster 14 Zeilen (:42) | d + b | BRICHT wahrscheinlich bei 96×160 (Prognose) | P6-AUTOR-07 |
| 55 | packages/pixel_engine/test/teile_kleidung_test.dart:129-151 | Teile paarweise ≥ 6 Pixel Unterschied (:147) | d | bleibt grün (Schwelle weich). Muss neu kalibriert werden | P6-AUTOR-07 |
| 56 | packages/pixel_engine/test/teile_koepfe_test.dart:105-111, :32 | Gesicht frei: `_augen == 2` über das ganze Sprite (:32, :109) | d + b | BRICHT wahrscheinlich (Zählung über alle Pixel; Prognose) | P6-AUTOR-07 |
| 57 | packages/pixel_engine/test/teile_koepfe_test.dart:30, :113-131 | Unsichtbar ab Abstand < 4 (:121). Gleiche Art ≥ `_mindestAbstand` 8 (:30, :128) | d | muss skaliert werden (Pixelabstände wachsen mit der Dichte) | P6-AUTOR-07 |
| 58 | packages/pixel_engine/test/teile_koepfe_test.dart:96-103 | Jedes Teil brennt; `pruefeFigur` ohne Befund | b + d (sprite_pruef) | wie 52 | P6-AUTOR-07 |
| 59 | packages/pixel_engine/test/karten_test.dart:50-59 | Grün (Rampe 5) nur bei R03/R04 (`Ramp.green`, :52; Oberteil :54) | b | bleibt grün, solange Grün = Rampe 5 bleibt. Die eingefrorenen Daten setzen das fest | P6-AUTOR-08 (Auslöser P1-OPUS-03) |
| 60 | packages/pixel_engine/test/karten_test.dart:78, :83 | Braune Schaftstiefel: `rampe == 2` (Holz) | b | bleibt grün, solange Holz Rampe 2 bleibt | P6-AUTOR-08 |
| 61 | packages/pixel_engine/test/karten_test.dart:87-101 | Bewohner-Kleidung und Haar: `kRampeNamen[x['rampe']]` (:96), `kHaarfarben` (:98) | b | muss erweitert werden, wenn Rampennamen und Haarfarben neu gesetzt werden (packages/pixel_engine/lib/src/figur/bewohner_karten.dart:18, :52) | P6-AUTOR-08 |
| 62 | packages/pixel_engine/test/karten_test.dart:111-126, :114 | Kein Paar `verwechselbar` außer R01/R11 (:114). Schwellen in bewohner_karten.dart:558: IoU ≥ 0,84 und `farbe <= 46`; oder ≥ 0,80 und Körper ≥ 0,62 | b + d | muss neu kalibriert werden. Die Größe `farbe` ist hier nicht geprüft; die Schwelle 46 ist an das 8er-Schema gebunden (Prognose) | P6-AUTOR-08 (Auslöser P1-OPUS-03, P1-OPUS-05) |
| 63 | packages/pixel_engine/test/karten_test.dart:128-132 | Kopfbedeckung nie Haarrampe: `kopfbedeckungLesbar` verlangt Rampe ≠ 2, 3, 4 (bewohner_karten.dart:574) | b | bleibt grün, solange Holz/Rot/Bernstein auf den Rampen 2–4 liegen. Sonst Lib anpassen | P6-AUTOR-08 (Auslöser P1-OPUS-03) |
| 64 | packages/pixel_engine/test/karten_test.dart:134-139 | `farbFamilie(0*8+1)=='dunkel'`, `farbFamilie(0*8+5)==farbFamilie(1*8+4)`, `farbFamilie(6*8+3)!=farbFamilie(2*8+3)` | b (8er-Kodierung) | BRICHT: die Lib rechnet `index ~/ 8` und `index % 8` (bewohner_karten.dart:582) | P6-AUTOR-08 (Auslöser P1-OPUS-03) |
| 65 | packages/pixel_engine/test/karten_test.dart:141-147 | Keine Materialien auf Rampe 0 Stufe 1 (Augenfarbe) | b | bleibt grün, solange die Augenfarbe Rampe 0 Stufe 1 bleibt | P6-AUTOR-08 |
| 66 | packages/pixel_engine/test/karten_test.dart:149-158 | Materialwerte `rampe` 0–7 und `stufe` 0–7 (:152-153) | b | muss erweitert werden (v2: Rampe 0–9, Stufe 0–15). Die Daten bleiben gültig | P6-AUTOR-08 |
| 67 | packages/pixel_engine/test/karten_test.dart:173-192, :186 | Je Paar ≥ 40 Pixel vorne (:186). Silhouette ≥ 12 oder andere Oberteil-Farbe (:186) | d | bleibt grün (Schwelle weich bei 96×160). Muss neu kalibriert werden | P6-AUTOR-08 |
| 68 | packages/pixel_engine/test/rollen_daten_test.dart:120-126 | Rampen und Stufen je Teil 0–7 (:125-126) | b | bleibt grün. Datenformat eingefroren; Erweiterung wäre eine verbotene Datenänderung | P1-OPUS-03 |
| 69 | packages/pixel_engine/test/rollen_daten_test.dart:133-143 | Grün (Rampe 5) nur R03/R04 im Oberteil (:137, :139-140) | b | BRICHT, wenn Grün in Palette v2 nicht Rampe 5 ist (Daten fest) | P1-OPUS-03 |
| 70 | packages/pixel_engine/bin/pixel_pruef.dart:15, :17-18, :22 | k ist Kommandozeilen-Argument, kein Abgleich mit der Skala. Exit 1 bei Ratio < 1 | a (k) | keine Bindung an Werte selbst. Falsches k ergibt Exit 1 | P1-OPUS-02 (Gate: P0-OPUS-03) |
| 71 | tool/alle_tests.sh:89-91 | Browser-Fotos: `case "$f" in *desktop*) k=2 ;; *) k=3 ;;` | a (kUi) | BRICHT bei einer Stufe mit 360 Zeilen (desktop 720p: kUi 1; handy 1080er Seite: kUi 2). Prognose. Heute nur zufällig passend | P1-OPUS-02 (Gate: P0-OPUS-03) |
| 72 | tool/alle_tests.sh:58-74 (bildschirmfoto.dart:17, belegfotos.dart:167, bereichsfotos.dart:29, spieltest.dart:32, stadtfotos.dart:46) | k = `spiel.skala!.kUi` | a | bleibt konsistent. Bei kUi = 1 ohne Welt-Block-Prüfung | P1-OPUS-02 |
| 73 | packages/burgstadt_spiel/lib/src/bildschirme/optionen_bildschirm.dart:29 | Exhaustiver `switch` über `Qualitaet` mit `Qualitaet.hoch` (Lib, kein Test) | a (Enum) | BRICHT (Kompilierfehler) beim Entfernen von `hoch`. Betrifft alle Spiel-Tests | P1-OPUS-02 |
| 74 | packages/pixel_engine/lib/src/raster/mesh.dart:5 (= 32); welt_geometrie.dart:90-271; baker.dart:168-170, :247-248; renderer.dart:385 | kTexelsPerMeter steuert Welt-UV, Figurenprojektion und Renderer | c (Kopplung) | Ohne Test: nur figur_test.dart:41 fängt die Figurengröße. Texeldichte 64 ohne Figuranpassung verkleinert die Figuren um den Faktor 2 | P1-OPUS-05 |
| 75 | tool/abnahme.dart:79-92, :83, :88 | Z-03: R = 20, B ≥ 40, zwei Sichtprüfer-Berichte mit Kartenstand = Hash von karten.json | d (indirekt) | bleibt grün. Der Beleg hängt nur an der Datendatei, nicht am Bild. Sichtprüfung bleibt nach einer Figuränderung gültig | P0-OPUS-03 |
| 76 | tool/abnahme.dart:144-148 | Z-09: Regex `× 4 = ([\d.]+) ms` und Grenze „× 4 ≤ 4 ms“ | a (Budget der Stufe mittel) | BRICHT, wenn sich Ausgabeformat oder Faktor ändert. Das Commit-Gate schließt Ebene 7 aus | P0-OPUS-03 |
| 77 | tool/abnahme.dart:169-174 gegen :177-183 | Z-12: datenStand ohne `packages/pixel_engine/data/figuren`; textPfade mit | d/b (Figurendaten) | inkonsistent: Figurendatenänderung macht Berichte ohne HEAD-Stand nicht ungültig | P0-OPUS-03 |
| 78 | tool/abnahme.dart:209-210, :212, :219 | Z-13: erlaubte Ziele `/nachtlauf/burgstadt`, `/main`, `/claude/nifty-gauss-s82y27`, `/claude/pensive-gates-ajtp7x` (seit der Änderung am Skript, Kommentar N-HD-01). Push-Einträge auf alle anderen Remote-Refs seit Beginn machen Z-13 rot | Commit-Weg | bleibt grün für die erlaubten Ziele. Stand dieser Prüfung kein Verstoß (drei Remote-Refs, Reflog ohne „update by push“) | P0-OPUS-03 |
| 79 | tool/abnahme.dart:74-77 | Z-02: zählt `BELEGFOTOS OK (N Bilder)`. Der Text nennt karten_test für „gleiche Pixeldichte“ | e/d (Behauptung) | bleibt grün. Die Pixeldichte wird nicht geprüft (Lücke) | P0-OPUS-03 |

Zielpakete (Zählung nach Haupt-Zielpaket): P1-OPUS-02 13 · P1-OPUS-03 4 · P1-OPUS-05 2 · P1-AUTOR-01 10 · P1-AUTOR-02 13 · P6-AUTOR-07 16 · P6-AUTOR-08 9 · P6-AUTOR-11 7 · P0-OPUS-03 5. Gesamt 79.

Nicht gebunden (gelesen, ohne Bindung an a–e): spiel_test.dart:47-66 (Tastatur), :68-105 ohne :75-105-Teile siehe oben, :108-130 (Ton), :132-153 (Türen), :155-183 (Fall solo, außer der generischen Prüfung spritesDrawn > 0 in :178); spielstand_test.dart (außer 640×360); texte_test.dart (Schrift und Namen); fledermaeuse_test.dart:33-39, :41-55, :109-113, :115-122, :138-169 (Welt-Meter, Kosten, Sprünge); pixel_test.dart:50-68, :70-104, :106-133; texturen_test.dart:67-73 (deterministisch); portraet_test.dart:125-138; figur_test.dart:28-38 (Höhe ohne Maßbezug); font_test.dart (alle Tests, Pal-Konstanten nach Name); rollen_daten_test.dart:92-96, :145-160, :162-195; innenraeume_haeuser_test.dart:108-111, :113-122, :125-135, :137-147, :149-151, :154-177, :191-218 (ohne Textur-Bindung); innenraeume_fallorte_test.dart:109-149, :154-163, :166-174, :176-188, :190-203, :205-240, :253-274.

Regelbindung ohne Zielpaket: innenraeume_fallorte_test.dart:243-250 bricht bei jeder Lichtquelle, deren Name nicht `kerze|ofen|notleuchte|notdienstlampe` enthält. Das gilt für das KOPF-Verbot neuer Lichtquellen.

## abnahme.dart Z-03 / Z-12 / Z-13

**Z-03** (tool/abnahme.dart:79-92). Das Kriterium zählt die Rollen (R-Karten, Muster `^R\d\d$`) und Bewohner (B-Karten) aus packages/pixel_engine/data/figuren/karten.json (:80-82, :90). Es verlangt 20 Rollen, mindestens 40 Bewohner und mindestens zwei Sichtprüfer-Berichte aus nachtlauf/auftraege/A-605 mit „Paare: 0 · Verstöße: 0“ (:85-89). Der Kartenstand ist `git hash-object` von karten.json auf 10 Stellen (:83). Heute lautet er b60891cc2b, und sichtpruefer_23_bericht.md:46 sowie sichtpruefer_24_bericht.md:113 tragen ihn. Die Bindung ist schwach: Der Beleg hängt nur am Datenhash, nicht am gerenderten Figurenbild, und die Prüfung nennt die Sprite-Tests nur im Text (:91). Zusätzlich verlangt Z-03 den Gesamtlauf `gruen` (:90).

**Z-12** (tool/abnahme.dart:163-200). Das Kriterium liest die Gegenprüfer-Berichte aus nachtlauf/auftraege/A-702 (`_bericht.md`) mit dem Urteil „Leitplanken eingehalten: ja“, „Kanontreu: ja“ und „Plagiatsfrei: ja“ (:188). Ein Bericht gilt als gültig, wenn die Spieltexte seit seinem Stand unverändert sind (:190-196). Der Vergleichsstand `datenStand` (:169-174) nimmt vier Pfade: packages/burgstadt_core/data, packages/burgstadt_spiel/data/texte, nachtlauf/kanon und krimidinner/spuk-im-gewoelbe/10_kanon. packages/pixel_engine/data/figuren fehlt dort. Dieser Pfad steht dagegen in `textPfade` (:177-183), das nur bei Berichten mit HEAD-Stand gilt (:192-194). Berichte ohne HEAD-Stand prüfen also Figurendatenänderungen nicht. Das ist eine Inkonsistenz. Praktisch wirkt sie erst, wenn Figurendaten geändert werden, was KOPF verbietet.

**Z-13** (tool/abnahme.dart:202-220). Vollständige Bedingungen, wörtlich aus dem Code:

```
final remotes = _git(['remote']).split('\n').where((r) => r.isNotEmpty).toList();   // :203
final start = int.tryParse(_git(['log', '--format=%ct', '--grep=^Nachtlauf', '--reverse']).split('\n').first) ?? 0;   // :205
const erlaubt = ['/nachtlauf/burgstadt', '/main', '/claude/nifty-gauss-s82y27',
    '/claude/pensive-gates-ajtp7x']; // Burgstadt HD: Arbeitsbranch (N-HD-01, Nutzerentscheidung „Mitführen“)   // :209-210
if (ref.isEmpty || ref.endsWith('/HEAD') || erlaubt.any(ref.endsWith)) continue;   // :212
final m = RegExp(r'@\{(\d+)\}: update by push').firstMatch(z);   // :214
if (m != null && int.parse(m[1]!) >= start) fremdePushes.add(ref);   // :215
final fremdeAbrufe = geraete.fold(0, (n, g) => n + g.$3);   // :218
kriterium('Z-13', remotes.length == 1 && remotes.first == 'origin' && fremdePushes.isEmpty && profile.length == 3 && fremdeAbrufe == 0,   // :219
```

Die vier Bedingungen sind: genau ein Remote `origin`, keine Pushes seit Beginn auf andere Refs als die erlaubten, drei Browser-Profile (desktop, handy-quer, handy-hoch; Muster in :152), und keine fremden Abrufe (:218-219). Die erlaubten Suffixe sind `/nachtlauf/burgstadt`, `/main`, `/claude/nifty-gauss-s82y27` und `/claude/pensive-gates-ajtp7x`. Der Beginn `start` ist 1791494866 (ältester Commit mit Betreff „Nachtlauf…“). Änderung während dieser Prüfung: In der Fassung, die ich zuerst gelesen hatte, fehlte `/claude/pensive-gates-ajtp7x` in der Liste. Die Datei wurde danach geändert (Zeilen 209-210, Kommentar N-HD-01). Der frühere Befund „nicht erlaubt“ gilt deshalb nicht mehr. Heute grün: Die drei Remote-Refs (`origin/claude/pensive-gates-ajtp7x`, `origin/main`, `origin/nachtlauf/burgstadt`) haben in ihren Reflogs keinen Eintrag „update by push“. Ein Push auf einen anderen Branch würde Z-13 rot machen.

## commit_gruen.sh (Schritt für Schritt)

Das Skript `tool/commit_gruen.sh` gilt für ein Commit nach grünem schnellem Gesamttest.

1. `set -uo pipefail` (:3). Kein `-e`, deshalb brechen Fehler nicht ab. `ROOT` ist die Repo-Wurzel, `LOG=$(mktemp)` (:4-6).
2. `bash tool/alle_tests.sh schnell > "$LOG" 2>&1` (:7). Der Lauf im Modus `schnell`.
3. Gate: `grep -aq "ALLE TESTS GRÜN" "$LOG"` (:8). Bei Fehlschlag letzte 15 Zeilen ausgeben und mit `exit 1` beenden (:9-11).
4. `git add -A` (:13). Alle Änderungen werden gestaged, auch ungetrackte. `git status` zeigt heute `?? hd/`. Der Ordner würde also mitcommittet.
5. `git commit -q -F -` mit Heredoc (:14-19). Nachricht ist `$1`, dann die Trailer `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>` und `Claude-Session: https://claude.ai/code/session_015UazG6EuWEYKkbSvg1SfvS` (:17-18). Der Commit landet auf dem ausgecheckten Branch `claude/pensive-gates-ajtp7x`.
6. `git push -q origin nachtlauf/burgstadt 2>&1 | tail -1` (:20). Ziel: Remote `origin` (einziger Remote), Refspec ohne Quelle, also `nachtlauf/burgstadt`. Lokal existiert kein Branch dieses Namens (`git branch --list` zeigt nur `claude/pensive-gates-ajtp7x` und `main`). Es gibt nur die Remote-Tracking-Ref `refs/remotes/origin/nachtlauf/burgstadt`. Nach Git-Semantik schlägt der Push mit „src refspec … does not match any“ fehl. Das ist nicht ausgeführt. Die Fehlermeldung verschwindet durch `| tail -1`, und der Exit-Status des Pushes wird nicht geprüft.
7. `git log --oneline -1` (:21) ist der letzte Befehl. Der Skript-Exit ist 0, unabhängig vom Push.

Ergebnis: Der Commit landet lokal auf dem Branch der Sitzung. Der Push-Erfolg wird nicht gemeldet.

## Blocktest-k

**Wie die Werkzeuge im Spiel k bestimmen.** `bildschirmfoto.dart:17`, `belegfotos.dart:167`, `bereichsfotos.dart:29`, `spieltest.dart:32` und `stadtfotos.dart:46` nehmen `k = spiel.skala!.kUi`. kUi kommt aus `Skalierung.fuer` (packages/burgstadt_spiel/lib/src/skalierung.dart:24-38). Dort wird das gerade k mit der Zeilenzahl der Qualitätsstufe verglichen (`(kurz / k − kurzeSeite)`, :30), kWelt ist gerade, und kUi = kWelt / 2 (:36). Die physische Größe kommt von `Spiel.groesse(w,h)` (spiel.dart:159-160). In der App ist sie `round(logisch × dpr)` (lib/burgstadt/burgstadt_ansicht.dart:16).

**Wie pixel_pruef k bestimmt.** Gar nicht. `k` ist das zweite Kommandozeilenargument (packages/pixel_engine/bin/pixel_pruef.dart:15). Nur die optionalen Parameter `x y w h` gelten, wenn mindestens sechs Argumente kommen (:16-18). Im Gate ruft `tool/alle_tests.sh:89-91` das Werkzeug für die Browser-Fotos auf, und `k` hängt am Dateinamen: `case "$f" in *desktop*) k=2 ;; *) k=3 ;;` (:90).

**Geräte aus tool/browser/geraete.js.** Die Viewports sind desktop 1280×720 @1 (:26), handy-quer 800×360 @3 (:29) und handy-hoch 360×800 @3 (:30). Daraus folgen die physischen Größen und die kUi-Werte:

| Gerät | Physisch | kurze Seite | k im Gate | kUi bei mittel (heute) | kUi bei 360 Zeilen (Prognose) |
|---|---|---|---|---|---|
| desktop | 1280×720 | 720 | 2 | 2 | 1 |
| handy-quer | 2400×1080 | 1080 | 3 | 3 | 2 |
| handy-hoch | 1080×2400 | 1080 | 3 | 3 | 2 |

Heute passen die festen Werte zufällig zur Stufe mittel. Sie sind nicht aus der Skala abgeleitet. Bei einer Stufe mit 360 Zeilen wäre k für den Desktop 2 bei kUi 1, und das Prüfbild wäre nicht blockuniform. Das ist eine Prognose, nicht gelaufen. Bei k = 1 ist jeder Block trivial einfarbig (`blockTest`, packages/pixel_engine/lib/src/pruef.dart:33-55). Der Test misst dann nichts.

**Welche Größen und Werkzeuge im Gate und im Gesamtlauf.** Das Gate `schnell` (ohne Geräte, Leistung, Server-Smoke, Mordakte-Simulation; alle_tests.sh:82) fährt:
- `bildschirmfoto.dart` mit 1280×720 (:61) und 2401×1081 (:64),
- `spieltest.dart` mit 1280×720 (Standard, :67) und 1080×2400 (:68),
- `belegfotos.dart` mit 1280×720 (:70) und 1080×2400 (:71),
- `stadtfotos.dart` mit 1280×720 (Standard, :73).

Ebene 9 (Geräte mit `geraete.js` und `pixel_pruef`, :85-92) und Ebene 7 (`leistung.dart` bei 1280×720, :93-95) laufen nur im Gesamtlauf. `bereichsfotos.dart` wird von `alle_tests.sh` nicht aufgerufen.

## OFFENE FRAGEN

1. `auto`: Das Enum `Qualitaet` hat je Stufe nur `kurzeSeite` (packages/burgstadt_spiel/lib/src/skalierung.dart:4-11). Für `auto` gibt es keinen Wert. spiel_test.dart:12 iteriert über alle Werte. Wie `auto` auflöst (Budget zur Laufzeit oder fester Wert), ist im Quelltext nicht festgelegt. Die Hauptplan-Dateien in hd/ wurden nicht gelesen.
2. `scharf`: Im Quelltext noch nicht vorhanden. Bei 360 Zeilen ist kUi = 1 bei 720p (Rechnung in skalierung.dart:29-36). Soll der Blocktest auf kWelt umgestellt oder kUi ≥ 2 erzwungen werden?
3. Push-Ziel: Der Sitzungs-Branch `claude/pensive-gates-ajtp7x` ist jetzt in abnahme.dart:209-210 erlaubt. commit_gruen.sh:20 pusht trotzdem nach `nachtlauf/burgstadt`, das lokal nicht existiert (siehe commit-Abschnitt). Welcher Branch den Commit tragen soll und ob der Push-Befehl dazu passt, entscheidet der Orchestrator.
4. Z-03: Soll der Kartenstand auch den Renderstand erfassen (Baker, Palette, Maße)? Derzeit bindet er nur an karten.json (abnahme.dart:83).
5. Farbgrenze für Texturen: texturen_test.dart:56-58 erzwingt 5 Farben. Der Kommentar nennt „Abnahme: höchstens 6“. Der Text fand sich nicht in nachtlauf/ABNAHME.md. Welche Quelle gilt?
6. Schwellen: Die Pixelschwellen in teile_*, karten_test, portraet_test und sprite_pruef (40, 150, 12, 6, 200, 1500 Pixel, Zeilen 10–50, footY ±) brauchen eine Regel für die neue Dichte (Fläche ×4 oder Linie ×2). Im Repo fand sich keine Vorgabe.
7. Grün = Rampe 5: Die eingefrorenen Daten (rollen.json, karten.json) enthalten `rampe 5` für Grün. Palette v2 muss Grün auf Rampe 5 lassen, sonst widersprechen die Daten den Tests (rollen_daten_test.dart:137; karten_test.dart:52). Das ist eine Festlegung für P1-OPUS-03.
8. Blocktest-Größen: 1920×1080 kommt nur in den Skalierungs-Invarianten vor (spiel_test.dart:11), nicht im Blocktest. Keine Prüfung bei 2560×1440.
9. Browser-k: Soll k aus dem Gerät gelesen oder von bildschirmfoto als Begleitdatei geschrieben werden (alle_tests.sh:89-91)?
10. `hoch` entfällt: Gespeicherte Werte fallen still auf mittel zurück (packages/burgstadt_spiel/lib/src/optionen.dart:28). Ist diese Migration gewollt?

## Nebenbefunde

- commit_gruen.sh:13 staged `hd/` (ungetrackt). KOPF verbietet Commits durch Pakete.
- commit_gruen.sh:17-18 setzt den Trailer hart auf „Claude Opus 5.5“ und eine fremde Session-URL. Die Attribution dieser Sitzung ist Haiku 5.5. Entscheidung beim Orchestrator.
- abnahme.dart:75-77: Z-02 prüft nur den Zähler der Belegfoto-Zeilen. Die Pixeldichte, die der Text durch karten_test belegt, wird nicht geprüft.
- abnahme.dart:159-161: Z-11 prüft nur, ob spielstand_test.dart existiert, nicht sein Ergebnis.
- abnahme.dart:144-148: Z-09 hängt an der Textform „× 4“ der Leistungsausgabe.
- Kopplung c ↔ d: baker.dart:168, :170, :247-248 rechnet mit kTexelsPerMeter. Figurenhöhe in Pixeln ist Meter × kTexelsPerMeter. figur_test.dart:41 ist der einzige Test, der das fängt.
- Kein Blocktest prüft kWelt-Blöcke. Ob Welt-Pixel bei `scharf` intakt bleiben, ist mit dem bestehenden Blocktest nicht sichtbar.

## SELBSTPRÜFUNG

Gelesen, vollständig, sofern nicht anders vermerkt:
- hd/rollen/KOPF.md
- packages/burgstadt_spiel/test/: spiel_test.dart, stadtkarte_test.dart, fledermaeuse_test.dart, wlan_test.dart, spielstand_test.dart, texte_test.dart (6 von 6)
- packages/pixel_engine/test/: texturen_test.dart, pixel_test.dart, portraet_test.dart, figur_test.dart, teile_kleidung_test.dart, teile_koepfe_test.dart, karten_test.dart, rollen_daten_test.dart, font_test.dart (9 von 9)
- packages/burgstadt_core/test/: innenraeume_haeuser_test.dart, innenraeume_fallorte_test.dart
- packages/pixel_engine/lib/src/figur/sprite_pruef.dart (vollständig)
- packages/pixel_engine/bin/pixel_pruef.dart (vollständig)
- tool/alle_tests.sh, tool/commit_gruen.sh, tool/abnahme.dart (vollständig; die Datei wurde während der Prüfung geändert, Z-13 wurde neu gelesen, Zeilen ab 209 sind nun um eins verschoben. Zeilen 74-200 sind unverändert)

Zur Wirkungsbestimmung ausschnittsweise gelesen: packages/pixel_engine/lib/src/palette.dart, pruef.dart, raster/mesh.dart:5, figur/baker.dart (:35, :168-170, :247-248), figur/portraet.dart (:24-28), figur/bewohner_karten.dart (:18, :52, :558, :571-577, :581-586), kit/texturen.dart (enum :12-49), ui/pixel_ui.dart (:19-30); packages/burgstadt_spiel/lib/src/skalierung.dart (vollständig), komposition.dart (vollständig), spiel.dart (:159-190), steuerung.dart (:23-80), optionen.dart (:5, :28), bildschirme/optionen_bildschirm.dart (:29), bin/belegfotos.dart (:140-180, :343), bin/bildschirmfoto.dart, bin/spieltest.dart (:14-22, :32, :141), bin/stadtfotos.dart (:8-16, :46, :50), bin/bereichsfotos.dart (:29), bin/leistung.dart (:10-16, :27, :74, :149); lib/burgstadt/burgstadt_ansicht.dart (:85-105); tool/browser/geraete.js (:26-30, :63, :118); nachtlauf/ABNAHME.md (Suche nach der Farbgrenze); nachtlauf/auftraege/A-605 (Kartenstand-Treffer); git (Branch, Remote, Reflog, Status, Hash von karten.json).

Nicht geprüft: nachtlauf/belege/*, hd/PLAN.md und die übrigen hd-Dokumente, Lauf der Tests, Ausführung von commit_gruen.sh. Zahlen zu Wirkungen bei 96×160 und 128×128 sind Prognosen.

Keine Dateien außer dieser Ausgabe geändert. Nichts committet, nichts gepusht.

ENDE PAKET P0-KUND-03

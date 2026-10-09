# P0-KUND-01 · Paletten-Audit

Commit: `ef8aac4` (`git -C /home/user/werwolf_digital_flutter rev-parse --short HEAD`). Die Suche lief auf dem Arbeitsbaum; für alle `.dart`-Dateien ist der Stand identisch mit HEAD (siehe OFFENE FRAGEN, Punkt 10).

Auftrag: Palette 8×8 = 64 → 10×16 = 160 (Index = rampe·16 + stufe). Umfang: 216 `.dart`-Dateien (ohne `.dart_tool/`) in `packages/pixel_engine`, `packages/burgstadt_core`, `packages/burgstadt_spiel` (lib, bin, test), `tool/` und `lib/`. Nur gelesen; keine Datei geändert, kein Dart-Lauf.

Legende: **P** = Zeile mit Pflicht-Muster-Treffer. **Z** = Zusatzfund, layout-abhängig ohne Muster-Treffer (z. B. `Material(rampe, stufe)`-Literale, Stufen-Offsets, Obergrenzen ohne Zahl im Muster). Index-Zerlegung = rampe/stufe aus dem Index; Ramp.at = Index-Bildung über `Ramp.at(rampe, stufe)`.

## 1. Layout-abhängige Stellen

| Nr | Datei:Zeile | Code (gekürzt) | Layout-abhängig | Art | Zielpaket |
|---|---|---|---|---|---|
| L01 | `packages/pixel_engine/lib/src/palette.dart`: P 1,10,43,59 | Kommentar: 8 Rampen × 8 Stufen = 64; Index = rampe*8+stufe; K8-Index „= 63“ | ja (P) | Doku der Index-Bildung | P1-OPUS-03 |
| L02 | `packages/pixel_engine/lib/src/palette.dart`: P 37 · Z 36 | static const shades = 8; static const count = 8; | ja (P+Z) | Pal-/Ramp-Konstante (Stufenzahl, Rampenzahl) | P1-OPUS-03 |
| L03 | `packages/pixel_engine/lib/src/palette.dart`: P 40 | Ramp.at: ramp * shades + (shade > 7 ? 7 : shade) | ja (P) | Ramp.at + Stufen-Clamp | P1-OPUS-03 |
| L04 | `packages/pixel_engine/lib/src/palette.dart`: P 44 | const List<int> paletteRgb = [...] (64 Einträge, Kommentare 45-60 mit Alt-Indizes) | ja (P) | Palettentabelle (Pal-Konstante) | P1-OPUS-03 |
| L05 | `packages/pixel_engine/lib/src/palette.dart`: P 89 · Z 65-88,90 | Pal-Konstanten: white=7, stone=12, candle=37, moss=44, parchment=63; 26 Werte | ja (P+Z) | Pal-Konstante (Index = rampe*8+stufe) | P1-OPUS-03 |
| L06 | `packages/pixel_engine/lib/src/palette.dart`: P 114 | (i >> 3) != ramp | ja (P) | Index-Zerlegung (Rampe aus Index) | P1-OPUS-03 |
| L07 | `packages/pixel_engine/lib/src/raster/renderer.dart`: P 45 | (v & 7) < (best & 7)  (dunkelste Stufe je Mip-Pixel) | ja (P) | Index-Zerlegung (Stufe) | P1-OPUS-03 |
| L08 | `packages/pixel_engine/lib/src/raster/renderer.dart`: P 159,160,189,198 · Z 158 | s = level.floor().clamp(0, 3); Ramp.at(Ramp.blue, s…); Ramp.at(Ramp.blue, 4); Ramp.at(Ramp.blue, 1)/Ramp.at(Ramp.neutral, 1) | ja (P+Z) | Ramp.at-Aufruf + Stufen-Clamp (Himmel, Mond, Berge) | P1-OPUS-03 |
| L09 | `packages/pixel_engine/lib/src/raster/renderer.dart`: P 453-457 · Z 451-452 | Raster-Loop: fq = fog*3; Clamps wq>7, cq>7, fq>3; Index col[idx] = table[(((fq*8+wq)*8+cq)<<6)+texel]  (Pflichtstelle 1, Z.457) | ja (P+Z) | Index-Bildung Lichttabelle (inner Raster-Loop) | P1-OPUS-04 |
| L10 | `packages/pixel_engine/lib/src/raster/renderer.dart`: P 523-527 | drawSprite: levelLut, fq = fog*3; Clamps 7/7/3; table[(((fq*8+wq)*8+cq)<<6)+c]  (Pflichtstelle 2, Z.527) | ja (P) | Index-Bildung Lichttabelle (Sprite) | P1-OPUS-04 |
| L11 | `packages/pixel_engine/lib/src/lighting.dart`: P 13 · Z 10-12,42,54 | static const colors = 64; warmLevels = 8; coldLevels = 8; fogLevels = 4; Tabellengröße fogLevels*warmLevels*coldLevels*colors; Schleife p < colors | ja (P+Z) | Lichttabelle-Dimension | P1-OPUS-04 |
| L12 | `packages/pixel_engine/lib/src/lighting.dart`: P 21,25,28 · Z 23-24 | levelLut = sqrt(i/1024)*7; lightOfLevel(k) = (k/7)*(k/7); Doku „Stufe 0..7“ | ja (P+Z) | Lichtstufen-Skala (0..7) | P1-OPUS-04 |
| L13 | `packages/pixel_engine/lib/src/lighting.dart`: P 62 | LightTable.night: nearestPaletteIndexBiased(…, p >> 3, …) | ja (P) | Index-Zerlegung im Lichttabellen-Aufbau | P1-OPUS-04 |
| L14 | `packages/pixel_engine/lib/src/lighting.dart`: P 71,72 | lookup(color, warm, cold, fog) = table[(((fog*warmLevels+warm)*coldLevels+cold) << 6) + color] | ja (P) | Index-Bildung Lichttabelle (lookup) | P1-OPUS-04 |
| F01 | `packages/pixel_engine/lib/src/figur/bewohner_karten.dart`: P 385 | p ~/ 8 == kRampeNamen['haut'] | ja (P) | Index-Zerlegung (Rampe) | P1-OPUS-03 |
| F02 | `packages/pixel_engine/lib/src/figur/bewohner_karten.dart`: P 489-491 · Z 484,583-584 | (p & 7) <= 1; rampe = p >> 3 == 1 ? 0 : p >> 3; h[rampe*3 + ((p&7) >= 6 ? 2 : (p&7) >= 4 ? 1 : 0)]; h = List.filled(24) | ja (P+Z) | Index-Zerlegung + Stufenschwellen + Zonenzahl (8×3) | P1-OPUS-03 |
| F03 | `packages/pixel_engine/lib/src/figur/bewohner_karten.dart`: P 582 | farbFamilie: rampe = index ~/ 8, stufe = index % 8; stufe <= 1 → 'dunkel' | ja (P) | Index-Zerlegung + Stufen-Schwelle | P1-OPUS-03 |
| F04 | `packages/pixel_engine/lib/src/figur/bewohner_karten.dart`: Z 18 | kRampeNamen: 8 Rampennamen (neutral … haut = 0…7) | ja (Z) | Rampen-Anzahl (neue Rampen 8, 9 fehlen) | P1-OPUS-03 |
| F05 | `packages/pixel_engine/lib/src/figur/bewohner_karten.dart`: Z 53-58,83,86-88,90-91,95-100,199,230,239,281,321-322 | Material(rampe, stufe)-Literale der Figurenkarten (z. B. Material(0, 5), Material(7, 3 + z.naechste(4))) | ja (Z) | Stufen-Literal (Material) | P1-OPUS-03 |
| F06 | `packages/pixel_engine/lib/src/figur/sprite_pruef.dart`: P 26,34,63 | c >= 64 (Index außerhalb); (c & 7) > 4 (helle Kontur); m.rampe > 7 oder m.stufe > 7 | ja (P) | Obergrenze + Index-Zerlegung + Stufen-Clamp (Prüfung) | P1-OPUS-03 |
| F07 | `packages/pixel_engine/lib/src/figur/baker.dart`: P 235 · Z 231,233 | stufe = (mm.stufe + schatten).clamp(0, 7); Offsets mm.stufe - 3 / - 2 | ja (P+Z) | Stufen-Clamp + Stufen-Offsets | P1-OPUS-03 |
| F08 | `packages/pixel_engine/lib/src/figur/baker.dart`: P 237,255 | pix[i] = Ramp.at(mm.rampe, stufe); pix[i] = Ramp.at(Ramp.neutral, 1) | ja (P) | Ramp.at-Aufruf | P1-OPUS-03 |
| F09 | `packages/pixel_engine/lib/src/figur/baker.dart`: Z 106 | k.materialien[n] ?? kMaterialStandard[n] ?? const Material(Ramp.neutral, 4) | ja (Z) | Stufen-Literal (Material-Fallback) | P1-OPUS-03 |
| F10 | `packages/pixel_engine/lib/src/figur/figur.dart`: Z 93,203-209 | Material-Standard (brille 0/1, papier 7/7, laterne 4/6, gurt 3/4 …) und JSON-Lesen Material((e.value as List)[0], [1]) | ja (Z) | Stufen-Literal (Standard-Material + Datenimport) | P1-OPUS-03 |
| F11 | `packages/burgstadt_spiel/lib/src/figuren_lager.dart`: Z 9,38-41,43-44,82,85 | Material(x['rampe'], x['stufe']); Material(7, s['haut'] ?? 5); Material(2, 3) … | ja (Z) | Stufen-Literal (Laufzeit-Figuren) | P1-OPUS-03 |
| F12 | `packages/pixel_engine/lib/src/figur/portraet.dart`: P 307,309,311,349 · Z 303,320,334-335 | Ramp.at(mm.rampe, 0 / c-2+schwelle / c+schwelle); Ramp.at(Ramp.neutral, 6) Brille; c = stufe + 3.0*(lam-0.5); Material(Ramp.neutral, 3/4) | ja (P+Z) | Ramp.at + Stufen-Offsets und Spreizung (Porträt) | P6-OPUS-03 |
| T01 | `packages/pixel_engine/lib/src/kit/texturen.dart`: P 9 | Doku: nur Palettenindizes 0–63; mittlere Stufen (2–5) | ja (P) | Test-Erwartung (Texturvertrag) | P1-AUTOR-01 |
| T02 | `packages/pixel_engine/lib/src/kit/texturen.dart`: P 195,247,268,272,277 | _stein/_planken: Ramp.at(rampe, s), (s+1), (s-1); _putz: Ramp.at(rampe, b), (b-1) | ja (P) | Ramp.at-Aufruf + Stufen-Offsets ±1 | P1-OPUS-03 |
| T03 | `packages/pixel_engine/lib/src/kit/texturen.dart`: P 387,419 | c == Ramp.at(Ramp.red, 3); c == Ramp.at(Ramp.stone, 5) (Index-Vergleich) | ja (P) | Ramp.at-Aufruf (Index-Vergleich) | P1-OPUS-03 |
| T04 | `packages/pixel_engine/lib/src/kit/texturen.dart`: P 291,292,313,329,351,360,398,434,453,471,472,492,503,517,526,528,529,541,550,551,574,575,591,592,625,634,637-640,647,648,665,667,671-674,686,705,719,720,745,768,769,789,790,806,815,816 | Ramp.at(Ramp.<rampe>, <Stufe-Literal 0–6>) in Textur-Funktionen (50 Zeilen) | ja (P) | Ramp.at-Aufruf (Stufen-Literal) | P1-OPUS-03 |
| T05 | `packages/pixel_engine/lib/src/kit/texturen.dart`: Z 290,312,328,403,433,452,502,518,540,624,685,704,750,807 | Helfer-Argument koerper: 3–5 (Stufe für _stein/_planken) | ja (Z) | Stufen-Literal (Helfer-Parameter) | P1-OPUS-03 |
| T06 | `packages/pixel_engine/lib/src/kit/texturen.dart`: P 62-67,94 | _putz(Ramp.<rampe>, <Stufe 3–5>, seed: …) — Stufe als Argument b (Ramp.at(rampe, b)) | ja (P) | Stufen-Literal (Helfer _putz) | P1-OPUS-03 |
| S01 | `packages/burgstadt_spiel/lib/src/spuren_geometrie.dart`: P 110,113,119 | blickFilter (256 Einträge): if (i >= 64) t[i] = i; Ramp.at(Ramp.blue, (lum*5).floor().clamp(0, 4)) | ja (P) | blickFilter-Obergrenze + Ramp.at-Stufen | P1-OPUS-03 |
| S02 | `packages/burgstadt_spiel/lib/src/bildschirme/stadtkarte.dart`: P 198,199,200,202,203,204,205,206,207 | Kartenfarben: aussen Ramp.at(blue,1); gasse (stone,6); haus (stone,2); garten (green,2); tuer (wood,6); holz (wood,4); wasser (blue,5); stein (stone,4); besucht (amber,3) | ja (P) | Ramp.at-Aufruf (Stufen-Literal) | P1-OPUS-03 |
| S03 | `packages/burgstadt_spiel/lib/src/fledermaeuse.dart`: P 225 | Ramp.at(Ramp.neutral, rand ? 3 : 5) | ja (P) | Ramp.at-Aufruf (Stufen-Literal) | P1-OPUS-03 |
| D01 | `packages/pixel_engine/lib/src/demo/demo_scene.dart`: P 131,132,145,157,168,183,195 | Demo-Textur: Ramp.at(Ramp.stone, 1/5/3+1), base ± 1, Ramp.at(Ramp.red, 1/2/4/3), Ramp.at(Ramp.wood, …), Ramp.at(Ramp.neutral, 2) | ja (P) | Ramp.at-Aufruf (Stufen-Literal) | P1-OPUS-03 |
| D02 | `packages/pixel_engine/lib/src/demo/demo_scene.dart`: P 20,21 | _plaster(Ramp.amber / Ramp.skin, 3, seed) — Stufe 3 als Argument base | ja (P) | Stufen-Literal (Helfer _plaster) | P1-OPUS-03 |
| W01 | `packages/burgstadt_spiel/bin/stadtplan.dart`: P 20,22,25 | Werkzeug: '.' => Ramp.at(Ramp.stone, 3); 'G' => Ramp.at(Ramp.green, 2); 'H' => Ramp.at(Ramp.red, 2 + …) | ja (P) | Werkzeug (Ramp.at-Stufen) | P1-OPUS-03 |
| W02 | `packages/pixel_engine/bin/aufstellung.dart`: P 26 | Werkzeug: clear(Ramp.at(Ramp.stone, 7)) — Stufe 7 als Obergrenze | ja (P) | Werkzeug (Ramp.at-Stufe) | P1-OPUS-03 |
| W03 | `packages/pixel_engine/bin/figurenprobe.dart`: Z 12,13,16,17,20,21,24,25 | Werkzeug: Material-Literale der Probe-Figuren (z. B. 'haut': Material(7, 5)) | ja (Z) | Werkzeug (Stufen-Literal) | P1-OPUS-03 |
| W04 | `packages/pixel_engine/bin/teile_koepfe_probe.dart`: Z 72-80 | Werkzeug: Material-Literale (haut 7/5, haar 2/3, …) | ja (Z) | Werkzeug (Stufen-Literal) | P1-OPUS-03 |
| W05 | `packages/pixel_engine/bin/teile_kleidung_probe.dart`: Z 13-24 | Werkzeug: Material-Literale (haut 7/5, haar 1/1, …) | ja (Z) | Werkzeug (Stufen-Literal) | P1-OPUS-03 |
| X01 | `packages/pixel_engine/test/teile_kleidung_test.dart`: P 43 · Z 21-32 | Ramp.at(Ramp.neutral, 1) als Zähl-Index; Material-Fixtures (haut 7/5 …) | ja (P+Z) | Test-Erwartung (Figur) | P6-AUTOR-07 |
| X02 | `packages/pixel_engine/test/figur_test.dart`: P 52 · Z 7-8 | Ramp.at(Ramp.neutral, 1) als Zähl-Index; Material-Fixtures | ja (P+Z) | Test-Erwartung (Figur) | P6-AUTOR-07 |
| X03 | `packages/pixel_engine/test/teile_koepfe_test.dart`: P 32 · Z 10-18 | _augen: c == Ramp.at(Ramp.neutral, 1); Material-Fixtures | ja (P+Z) | Test-Erwartung (Figur) | P6-AUTOR-07 |
| X04 | `packages/pixel_engine/test/karten_test.dart`: P 135-138 | farbFamilie(0*8+1), farbFamilie(6*8+0), farbFamilie(0*8+5) ~ (1*8+4), farbFamilie(6*8+3) != (2*8+3) | ja (P) | Index-Bildung in Test-Erwartung | P6-AUTOR-08 |
| X05 | `packages/pixel_engine/test/portraet_test.dart`: P 43,53,82,87 · Z 136 | Test: Pixel < 64 oder 255 (c >= 64); Rampe 5 Indizes 40–47 (c >= 40 && c <= 47); Fixture Material(7, 4) | ja (P+Z) | Test-Erwartung (Porträt-Index) | P6-AUTOR-11 |
| X06 | `packages/pixel_engine/test/pixel_test.dart`: P 10,11,12,20,22,23,39 | Palette: paletteRgb.length == 64; toSet().length == 64; lt.table < 64; lt.lookup(Pal.candle, 3, 0, 0); dim >> 3 == Ramp.amber; c < 64 | ja (P) | Test-Erwartung (Palette, Lichttabelle) | P1-AUTOR-02 |
| X07 | `packages/burgstadt_spiel/test/fledermaeuse_test.dart`: P 79 | expect(c & 7, lessThanOrEqualTo(4)) — helle Kontur | ja (P) | Test-Erwartung (Stufen-Schwelle) | P1-AUTOR-02 |
| X08 | `packages/burgstadt_spiel/test/stadtkarte_test.dart`: P 81,142 | Ramp.at(Ramp.amber, 3) als Farbfinder; c == kTransparent oder c < 64 | ja (P) | Test-Erwartung (Ramp.at, Obergrenze) | P1-AUTOR-02 |
| X09 | `packages/pixel_engine/test/texturen_test.dart`: P 10,43,46,63 | _benachbart: a >> 3 == b >> 3, (a-b).abs() <= 1; Test „nur Palettenindizes 0–63“, c < 64; c >> 3 == Ramp.green | ja (P) | Test-Erwartung (Index-Zerlegung, Obergrenze) | P1-AUTOR-01 |

Alle Ramp.at-Stellen sind als layout-abhängig geführt: 92 Trefferzeilen mit 128 Aufrufen (Abschnitt 4), jeweils mit Stufen-Literal oder Stufen-Ausdruck auf der 8er-Skala. Reine Ramp-IDs (z. B. `Ramp.stone`, ohne `at`) und `Pal.`-Namen sind symbolisch und stehen in Tabelle 2 bzw. Abschnitt 4; die Werte der Pal-Konstanten selbst stehen in L05.

## 2. Verworfene Pflicht-Treffer (nicht layout-abhängig), je Datei

| Datei | Treffer (Zeilen) | Grund |
|---|---|---|
| `lib/game/input/joystick.dart` | 2 | Zeichengeometrie (Pfeilspitze, Pixelabstände) |
| `lib/game/iso_math.dart` | 3 | Isometrie-Maße (Kachel 64×32, Höhe 40) |
| `lib/game/mordakte_game.dart` | 9 | Bewegungs-, Zeit- und Zoomfaktoren; Seed-Formel |
| `lib/game/scene/figure_painter.dart` | 6 | Zeichenkoordinaten; Haarauswahl (h ~/ 7) |
| `lib/game/scene/floor_painter.dart` | 4 | Schleifenzähler und Raummaße |
| `lib/game/scene/markers.dart` | 7 | Alpha- und Zeitfaktoren, Schleifenzähler |
| `lib/game/scene/prop_painter.dart` | 21 | Zeichen-Geometrie, Hex-Farben (Color), Zeitfaktoren |
| `lib/game/scene/static_scene.dart` | 4 | Bildschirm-Offsets (64) |
| `lib/game/scene/weather.dart` | 2 | Alpha-Wert und Schleifenzähler |
| `lib/meta/meta_store.dart` | 1 | Auszeichnungsschwelle (revives >= 3) |
| `lib/session/fake_session.dart` | 1 | Testwert Spielzustand (nerves 64) |
| `lib/ui/overlays/council.dart` | 1 | UI-Maß (Höhe 0.64) |
| `lib/ui/overlays/ending.dart` | 2 | Widget-Größen (Portrait 64, Avatar 40), keine Palette |
| `lib/ui/overlays/hud.dart` | 6 | UI-Größen und Abstände |
| `lib/ui/overlays/interrogation.dart` | 1 | UI-Abstand (40) |
| `lib/ui/overlays/intro.dart` | 1 | Zeitberechnung (clamp bis 2^30) |
| `lib/ui/overlays/notebook.dart` | 3 | UI-Maße und Rasterabstand |
| `lib/ui/overlays/signal_wheel.dart` | 1 | Geometriefaktor 0.47 |
| `lib/ui/overlays/toasts.dart` | 1 | Anzahl Meldungen (> 3) |
| `lib/ui/screens/collection_screen.dart` | 2 | UI-Größen (40) |
| `lib/ui/screens/game_screen.dart` | 1 | UI-Abstand (64) |
| `lib/ui/screens/lobby_screen.dart` | 2 | Schriftgröße (40) und UI-Breite |
| `lib/ui/screens/profile_screen.dart` | 1 | Mantel-Liste detectiveCoats[clamp(0, 7)], keine Palette |
| `lib/ui/widgets/meters.dart` | 1 | Rang-Schwellen (>= 5, >= 3) |
| `lib/ui/widgets/noir_backdrop.dart` | 3 | Geometrie (80, 40); RGB-Werte 255 in Color.fromRGBO |
| `lib/ui/widgets/paper.dart` | 1 | UI-Höhe (40) |
| `lib/ui/widgets/portrait.dart` | 2 | Widget-Größe (40), Geometriefaktor 0.47 |
| `packages/burgstadt_core/lib/src/fall/bots.dart` | 2 | Score-Startwert (-1 << 30), Phasenschleife |
| `packages/burgstadt_core/lib/src/fall/fall_zustand.dart` | 4 | Fall-Phasen und Story-Schwellen |
| `packages/burgstadt_core/lib/src/kanon/proben.dart` | 2 | Anzahl Kanon-Optionen und Schleifen |
| `packages/burgstadt_core/lib/src/pruef/leitplanken.dart` | 2 | Textausschnitt-Rand (40 Zeichen), Teileanzahl |
| `packages/burgstadt_core/lib/src/welt/oberstadt.dart` | 1 | Weltmaße (64, 52) |
| `packages/burgstadt_core/lib/src/welt/stadtgenerator.dart` | 3 | Weltgitter, Gangbreite, Liste der sechs Putz-Namen |
| `packages/burgstadt_core/test/fall_zustand_test.dart` | 1 | Schleife über Phasen |
| `packages/burgstadt_core/test/kanon_test.dart` | 4 | Kanon-Texte (Uhrzeit 23:47), Schleifen |
| `packages/burgstadt_core/test/stadt_test.dart` | 2 | Weltzahlen (>= 150 Gebäude, >= 40 Innenräume) |
| `packages/burgstadt_core/test/stadtleben_test.dart` | 3 | Bewohnerzahl (>= 40), Testtext |
| `packages/burgstadt_spiel/bin/belegfotos.dart` | 2 | Richtungswinkel (k / 8 · π), Zähler |
| `packages/burgstadt_spiel/bin/bildschirmfoto.dart` | 2 | Schleifenzähler, Bildzahl 40 |
| `packages/burgstadt_spiel/bin/leistung.dart` | 2 | Zeit-Eimer (64 ms) |
| `packages/burgstadt_spiel/bin/spieltest.dart` | 1 | Bildschirmauflösung (1280/720) |
| `packages/burgstadt_spiel/bin/stadtplan.dart` | 7 | nur symbolische Pal.-Verwendung |
| `packages/burgstadt_spiel/lib/src/bildschirme/anklage.dart` | 1 | UI-Abstand (40) |
| `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart` | 3 | Schleife (> 3), Dither-Schwelle (blende * 16), symbolisches Pal.black, UI-Höhe 40 |
| `packages/burgstadt_spiel/lib/src/bildschirme/fallakte.dart` | 2 | UI-Maße (17, 40) |
| `packages/burgstadt_spiel/lib/src/bildschirme/hauptmenue.dart` | 1 | Menü-Zeilenhöhe (h ~/ 8, h ~/ 10) |
| `packages/burgstadt_spiel/lib/src/bildschirme/lagerunde.dart` | 5 | UI-Maße (40), Phasen- und Textzähler |
| `packages/burgstadt_spiel/lib/src/bildschirme/optionen_bildschirm.dart` | 1 | Menüindex (< 7) |
| `packages/burgstadt_spiel/lib/src/bildschirme/stadtkarte.dart` | 5 | symbolische Pal.-Verwendung, Richtungsindex (% 8) |
| `packages/burgstadt_spiel/lib/src/bildschirme/wlan.dart` | 1 | Eingabelänge (>= 7 Zeichen) |
| `packages/burgstadt_spiel/lib/src/figuren_lager.dart` | 6 | Zeit-Eimer (64/63 ms), Richtungsindex (& 7, % 8) |
| `packages/burgstadt_spiel/lib/src/kompass.dart` | 1 | Kompass-Abstand (3 Pixel) |
| `packages/burgstadt_spiel/lib/src/spiel.dart` | 4 | LightTable.night() und blickFilter-Lookup (Inhalt erfasst in spuren_geometrie.dart:113), symbolisches Pal.black |
| `packages/burgstadt_spiel/lib/src/spuren_geometrie.dart` | 2 | RGB-Luminanz (/ 255), symbolische Pal.-Verwendung |
| `packages/burgstadt_spiel/lib/src/steuerung.dart` | 1 | Eingabeschwelle (3) |
| `packages/burgstadt_spiel/lib/src/welt_geometrie.dart` | 2 | Welt-Hash (x * 7 + z * 3), Kachelvariante (% 4) |
| `packages/burgstadt_spiel/test/fledermaeuse_test.dart` | 4 | symbolisch paletteRgb.length, LightTable.night(), Anzahl 40/12 |
| `packages/burgstadt_spiel/test/stadtkarte_test.dart` | 2 | symbolische Pal.-Verwendung (Pal.candleLight) |
| `packages/burgstadt_spiel/test/wlan_test.dart` | 1 | Schleifenzähler (3) |
| `packages/pixel_engine/bin/aufstellung.dart` | 1 | symbolische Pal.-Verwendung |
| `packages/pixel_engine/bin/benchmark.dart` | 1 | Argumentanzahl (> 3) |
| `packages/pixel_engine/bin/bewohnerkarten.dart` | 1 | Variantenzahl (_farbVarianten = 64 Durchläufe), keine Palettengröße |
| `packages/pixel_engine/bin/figurenprobe.dart` | 2 | Bildzahl (× 8 Richtungen), symbolisches Pal.nightBlue |
| `packages/pixel_engine/bin/pixel_pruef.dart` | 1 | Alpha-Kanal (255) |
| `packages/pixel_engine/bin/portraetprobe.dart` | 3 | symbolische Pal.-Verwendung |
| `packages/pixel_engine/bin/schriftprobe.dart` | 2 | symbolische Pal.-Verwendung |
| `packages/pixel_engine/bin/teile_kleidung_probe.dart` | 3 | symbolische Pal.-Verwendung, Zellgeometrie (8 × bw) |
| `packages/pixel_engine/bin/teile_koepfe_probe.dart` | 7 | symbolische Pal.-Verwendung, Zellgeometrie (8 × bw, 8 Bilder), Argumentanzahl |
| `packages/pixel_engine/bin/texturprobe.dart` | 3 | symbolische Pal.-Verwendung |
| `packages/pixel_engine/lib/src/demo/benchmark.dart` | 1 | LightTable.night() symbolisch |
| `packages/pixel_engine/lib/src/demo/demo_scene.dart` | 7 | Weltgeometrie (bx * 8.0), Kachelmuster (% 8, ~/ 8), Hash (x * 7 + y * 13) |
| `packages/pixel_engine/lib/src/figur/baker.dart` | 2 | Richtungsindex (& 7), Schleife (3) |
| `packages/pixel_engine/lib/src/figur/figur.dart` | 3 | Posenwinkel (40), Gewicht 0.47 |
| `packages/pixel_engine/lib/src/figur/portraet.dart` | 6 | Porträtmaße (64 × 64, Fuß 32/63), Schleifen |
| `packages/pixel_engine/lib/src/figur/teile_basis.dart` | 1 | Körpergewicht 0.47 (Geometrie) |
| `packages/pixel_engine/lib/src/kit/texturen.dart` | 38 | Texturgröße (_Tex 64), Pixelpositionen und Kachelmuster (% 8), symbolische Ramp.-IDs (rampe: Ramp.x), symbolisches Pal.moss, Schleifen |
| `packages/pixel_engine/lib/src/lighting.dart` | 7 | RGB-Clamp 255 (Z. 56–58), LightTable-Klasse und Signatur, nearestPaletteIndex für Nebelfarbe (Z. 67) |
| `packages/pixel_engine/lib/src/palette.dart` | 7 | Sentinel kTransparent = 255 (Z. 7–8, außerhalb 0–159), paletteArgb/paletteR/G/B und Schleifenlänge (Z. 94–109), symbolisch |
| `packages/pixel_engine/lib/src/pixel_buffer.dart` | 2 | paletteRgb-Länge (symbolisch), 256-Eintrag-Puffer, Sentinel 255 |
| `packages/pixel_engine/lib/src/pruef.dart` | 1 | Palettenmenge aus paletteRgb (symbolisch) |
| `packages/pixel_engine/lib/src/raster/renderer.dart` | 17 | Vertex-Stride 7 und Puffer 4·7·2 (Polygon), symbolische Pal.-/LightTable-Verwendung (Z. 171, 186, 383), Doku LightTable (Z. 79, 83), Nebel-Distanz in Metern (Z. 445) |
| `packages/pixel_engine/lib/src/ui/pixel_ui.dart` | 7 | symbolische Pal.-Verwendung (Stil-Konstanten) |
| `packages/pixel_engine/test/font_test.dart` | 3 | symbolische Pal.-Verwendung |
| `packages/pixel_engine/test/karten_test.dart` | 4 | symbolisch Ramp.green (Z. 52), Prozentangabe 63 % (Z. 113), Pixelschwellen 40/12 (Z. 173, 186) |
| `packages/pixel_engine/test/pixel_test.dart` | 12 | symbolische Pal.-/LightTable-Verwendung, Puffergrößen 64×36 und 8×16, Sprite-Stride 8 (Z. 109), K8-Liste (Z. 14) |
| `packages/pixel_engine/test/portraet_test.dart` | 3 | Formatprüfung 64 × 64 und Fuß 32/63 (Z. 48), Sentinel 255 (Z. 51), Bildhöhe 0.7 × 64 (Z. 72) |
| `packages/pixel_engine/test/texturen_test.dart` | 2 | Texturgrößen 32/64 (Z. 37, 39) |
| `tool/abnahme.dart` | 7 | Zählschwellen der Abnahme (40, 150, 20, 7), Regex-Länge 40, Zeitschwelle |
| `tool/ton/geraeusche.dart` | 3 | Audio: Frequenzen und Schleifen |
| `tool/ton/klangwerk.dart` | 1 | WAV-Header-Offset 40 |
| `tool/ton/musik.dart` | 18 | MIDI-Noten und Tonlängen (Daten) |
| `tool/ton/test/ton_test.dart` | 1 | WAV-Header-Offset 40 |

## 3. Zählung

- Treffer gesamt (eindeutige Zeilen über alle 21 Pflicht-Muster): **513**.
- Davon layout-abhängig: **167** (P: 162 Zeilen; zusätzlich 5 Zeilen, die Pflicht-Treffer sind und über Z laufen).
- Verworfen: **346** (Tabelle 2). Kontrolle: 167 + 346 = 513.
- Zusatzfunde ohne Muster-Treffer (Z): **150** Zeilen.

Je Zielpaket (Zeilen):

| Zielpaket | Layout-abhängig, Pflicht-Treffer | Zusatzfunde (ohne Muster) | Summe |
|---|---|---|---|
| P1-OPUS-03 | 118 | 115 | 233 |
| P1-OPUS-04 | 17 | 9 | 26 |
| P1-AUTOR-01 | 5 | 0 | 5 |
| P1-AUTOR-02 | 10 | 0 | 10 |
| P6-OPUS-03 | 6 | 2 | 8 |
| P6-AUTOR-07 | 3 | 23 | 26 |
| P6-AUTOR-08 | 4 | 0 | 4 |
| P6-AUTOR-11 | 4 | 1 | 5 |
| keins | 0 | 0 | 0 |
| **Summe** | **167** | **150** | **317** |

## 4. Alle Ramp.at-/Pal.-Verwendungen (Anzahl je Datei)

Vorkommen im Quelltext (nicht Zeilen): `Ramp.at(` · `Ramp.<ID>` ohne `at` · `Pal.<Name>`.

| Datei | Ramp.at | Ramp.<ID> (ohne at) | Pal. |
|---|---|---|---|
| `packages/burgstadt_spiel/bin/stadtplan.dart` | 3 | 3 | 8 |
| `packages/burgstadt_spiel/lib/src/bildschirme/erkundung.dart` | 0 | 0 | 1 |
| `packages/burgstadt_spiel/lib/src/bildschirme/stadtkarte.dart` | 9 | 9 | 4 |
| `packages/burgstadt_spiel/lib/src/fledermaeuse.dart` | 1 | 1 | 0 |
| `packages/burgstadt_spiel/lib/src/spiel.dart` | 0 | 0 | 2 |
| `packages/burgstadt_spiel/lib/src/spuren_geometrie.dart` | 1 | 1 | 3 |
| `packages/burgstadt_spiel/test/stadtkarte_test.dart` | 1 | 1 | 2 |
| `packages/pixel_engine/bin/aufstellung.dart` | 1 | 1 | 2 |
| `packages/pixel_engine/bin/figurenprobe.dart` | 0 | 0 | 1 |
| `packages/pixel_engine/bin/portraetprobe.dart` | 0 | 0 | 5 |
| `packages/pixel_engine/bin/schriftprobe.dart` | 0 | 0 | 3 |
| `packages/pixel_engine/bin/teile_kleidung_probe.dart` | 0 | 0 | 3 |
| `packages/pixel_engine/bin/teile_koepfe_probe.dart` | 0 | 0 | 4 |
| `packages/pixel_engine/bin/texturprobe.dart` | 0 | 0 | 3 |
| `packages/pixel_engine/lib/src/demo/demo_scene.dart` | 13 | 14 | 0 |
| `packages/pixel_engine/lib/src/figur/baker.dart` | 2 | 2 | 0 |
| `packages/pixel_engine/lib/src/figur/portraet.dart` | 4 | 3 | 0 |
| `packages/pixel_engine/lib/src/kit/texturen.dart` | 86 | 100 | 2 |
| `packages/pixel_engine/lib/src/raster/renderer.dart` | 4 | 4 | 4 |
| `packages/pixel_engine/lib/src/ui/pixel_ui.dart` | 0 | 0 | 6 |
| `packages/pixel_engine/test/figur_test.dart` | 1 | 1 | 0 |
| `packages/pixel_engine/test/font_test.dart` | 0 | 0 | 4 |
| `packages/pixel_engine/test/karten_test.dart` | 0 | 1 | 0 |
| `packages/pixel_engine/test/pixel_test.dart` | 0 | 1 | 5 |
| `packages/pixel_engine/test/teile_kleidung_test.dart` | 1 | 1 | 0 |
| `packages/pixel_engine/test/teile_koepfe_test.dart` | 1 | 1 | 0 |
| `packages/pixel_engine/test/texturen_test.dart` | 0 | 1 | 0 |
| **Summe** | **128** | **145** | **62** |

## 5. OFFENE FRAGEN

1. **Daten außerhalb des Suchumfangs.** `packages/pixel_engine/data/figuren/rollen.json` enthält 105 Schlüssel `"stufe"`; `karten.json` enthält 577 Material-Einträge als `[rampe, stufe]`-Paare (Zählung per JSON-Lesen, nur gelesen). Laut KOPF darf `data/figuren` nicht geändert werden, der Code liest diese Stufen aber (`figur.dart:93`, `bewohner_karten.dart:239`). Offen: Umrechnung der Stufen auf das 16er-Layout und Zuständigkeit.
2. **Neue Rampen 8 und 9.** Der Code kennt 8 Rampen (`palette.dart:13–34`, `Ramp.count = 8` in `palette.dart:36`); `kRampeNamen` hat 8 Einträge (`bewohner_karten.dart:18–26`). Namen und Verwendung der zwei neuen Rampen stehen nicht im Code.
3. **Lichttabelle warm/kalt.** `lighting.dart:10–11` setzt `warmLevels = 8` und `coldLevels = 8`; die Index-Formel in `renderer.dart:457` und `:527` hängt davon ab. Ob diese Stufenzahlen bei 16 Palettenstufen mitwachsen, ist im Code nicht festgelegt (Entscheidung P1-OPUS-04).
4. **Umrechnung der 8er-Stufen.** 92 Zeilen mit `Ramp.at` (128 Aufrufe), 16 `koerper`-Argumente und 7 `_putz`-Stufen in `texturen.dart` sowie die Offsets `baker.dart:231–233` (−3, −2) und `portraet.dart:303–309` rechnen mit 0–7. Eine Umrechnungsregel (z. B. Verdopplung oder Neuauszeichnung) steht nicht im Code. Zuständigkeit P1-OPUS-03 bzw. P1-AUTOR-01.
5. **Sentinel 255.** `kTransparent = 255` (`palette.dart:8`) liegt bei 160 Farben außerhalb des Indexbereichs. Annahme: 255 bleibt Sentinel. Das setzen `portraet_test.dart:51` und `pixel_buffer.dart:77` voraus; ein Test prüft es nicht direkt.
6. **Index 1 als Augenfarbe.** `portraet.dart:313` („Index 1 ist den Augen vorbehalten“), `portraet_test.dart:65–72` und `karten_test.dart:141` setzen Index 1 = Rampe 0, Stufe 1 voraus. Bei `rampe·16 + stufe` bleibt dieser Wert gleich. Annahme, nicht geprüft.
7. **Zielpaket für Figur-Code und Werkzeuge.** Der Auftrag nennt kein Zielpaket für `bewohner_karten.dart`, `baker.dart`, `sprite_pruef.dart`, `figur.dart`, `figuren_lager.dart` sowie für die Werkzeuge in `bin/`. Ich habe Index- und Stufenstellen P1-OPUS-03 zugeordnet (Index-Zerlegung), das Porträt P6-OPUS-03. Bitte bestätigen.
8. **texturen.dart.** Umfang: 57 `Ramp.at`-Zeilen, 16 `koerper`-Argumente, 7 `_putz`-Stufen (Tabelle 1, Zeilen T02–T06). Offen, ob P1-OPUS-03 (Code) oder P1-AUTOR-01 (Texturinhalt) die Stufen anpasst.
9. **Feste 64 und 255 in Tests.** `pixel_test.dart:11, 12, 20, 39`, `texturen_test.dart:46`, `stadtkarte_test.dart:142` und `portraet_test.dart:53` erwarten 64 als Obergrenze; mit 160 Farben stimmt das nicht. Ersatz (`paletteRgb.length` oder 160) ist im Code nicht festgelegt. Zuständigkeit P1-AUTOR-02, P1-AUTOR-01, P6-AUTOR-11.
10. **Arbeitsbaum und Commit.** Vor der Suche zeigte `git status` `M tool/abnahme.dart` (nicht aus diesem Paket). Während der Arbeit kam der Commit `ef8aac4` hinzu, der diese Änderung und `hd/` übernimmt. Die Trefferlisten der Suche sind vor und nach dem Commit identisch; die Verschiebung der Zeilennummern in `tool/abnahme.dart` ab Zeile 209 betrifft keine gelisteten Treffer (dort nur Zählschwellen, Tabelle 2).
11. **Hinweis außerhalb des Auftrags.** `packages/pixel_engine/lib/src/raster/mesh.dart:5` setzt `kTexelsPerMeter = 32`; der Paketkopf (Satz 2) nennt 64 Texel pro Meter. Nicht palettenrelevant, nur festgehalten.
12. **Veraltete Kommentare.** `palette.dart:45–60` nennt Alt-Indizes (z. B. „= Index 12“), `renderer.dart:158` „Blau 50..53“. Sie werden mit dem Umbau falsch. Gezählt sind davon nur die Doku-Zeilen 1, 10, 43, 59 (L01).
13. **Nicht untersucht.** Dart-Dateien außerhalb der genannten Pfade wurden nicht gesucht. `.dart_tool/` ist ausgeschlossen (Auftrag). `/opt/flutter/bin/dart` wurde nicht ausgeführt; alle Aussagen beruhen auf Lesen und grep.

## 6. SELBSTPRÜFUNG

Pflicht-Muster (je einzeln mit `grep -rnE --include=*.dart --exclude-dir=.dart_tool` über die oben genannten Pfade). Angegeben sind Trefferzeilen, nicht Vorkommen.

| Muster | Trefferzeilen | gesucht |
|---|---|---|
| `>>\s*3` | 6 | ja |
| `&\s*7\b` | 8 | ja |
| `<<\s*3` | 2 | ja |
| `<<\s*6` | 3 | ja |
| `\*\s*8\b` | 14 | ja |
| `\b8\s*\*` | 11 | ja |
| `~/\s*8\b` | 5 | ja |
| `%\s*8\b` | 7 | ja |
| `[/*]\s*7\b` | 29 | ja |
| `fog\s*\*\s*3` | 2 | ja |
| `[<>]=?\s*[37]\b` | 62 | ja |
| `clamp\(\s*0\s*,\s*[37]\s*\)` | 3 | ja |
| `\b(40\|47\|63\|64\|255)\b` | 177 | ja |
| `Pal\.` | 52 | ja |
| `Ramp\.at` | 92 | ja |
| `Ramp\.` | 121 | ja |
| `shades` | 2 | ja |
| `paletteRgb` | 13 | ja |
| `blickFilter` | 2 | ja |
| `LightTable` | 13 | ja |
| `lookup\(` | 2 | ja |

- Alle 21 Pflicht-Muster gesucht: ja. Mit `\s*` bei den Operatoren, so dass `>>3` und `>> 3` gleich gefunden werden.
- Pflichtstellen: `renderer.dart:457` (Index-Formel, inner Raster-Loop) und `renderer.dart:527` (Sprite) sind gefunden und als P1-OPUS-04 eingestuft. `lighting.dart` (Aufbau 42–62, lookup 71–72) ist vollständig erfasst.
- Maschinelle Gegenprobe: 513 eindeutige Pflicht-Zeilen = 167 layout-abhängig + 346 verworfen. Alle P-Zeilen sind Muster-Treffer; keine Zeile ohne Inhalt.
- Materialliterale (Zusatzsuche): 97 Zeilen mit `Material(` in Figur-, Test- und Werkzeugcode, alle als Z erfasst. Ausgeschlossen: Flutter-Widget `Material(` in `lib/ui/` (Fehltreffer), `kleidungsMaterial(` (Fehltreffer), Klassendefinition `figur.dart:61`.
- Kontext: Funktionskopf und Nachbarzeilen wurden gelesen für Index-, Clamp- und Lichttabellenstellen (`palette.dart`, `lighting.dart`, `renderer.dart`, `bewohner_karten.dart`, `sprite_pruef.dart`, `baker.dart`, `portraet.dart`, `spuren_geometrie.dart`, Helfer in `texturen.dart`). Die übrigen Ramp.at- und Material-Literale wurden nach Zeileninhalt und Dateikontext beurteilt. Die verworfenen Treffer (Tabelle 2) nach Zeileninhalt; das Umfeld wurde nicht je ±5 Zeilen geprüft.
- Zählungen in Abschnitt 3 und Tabellen 1–2 stammen aus derselben Datenbasis und sind gegengeprüft (`Summe` = Gesamt).

ENDE PAKET P0-KUND-01

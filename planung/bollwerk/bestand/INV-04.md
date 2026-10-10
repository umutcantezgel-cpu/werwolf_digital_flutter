# M1-INV-04 · Inventar Assets, Druck, Renderer

Baum (nur lesen): /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/wt/fin
Verfahren: find, wc, grep, awk, sed -n, cut (alle lesend). Keine Zahl geschätzt.

## 1. Assets

Befehl: `find assets -type f`, `find <ordner> -maxdepth 1 -type f -printf '%s %f\n' | awk ...`

| Ordner | Dateien | Bytes | Fundstelle / Befehl |
|---|---:|---:|---|
| assets/burgstadt/ton | 45 | 11673458 | `find assets/burgstadt/ton -type f` (44 .wav + 1 LISTE.md) |
| assets/fonts | 4 | 1127860 | `find assets/fonts -type f` |
| **Summe** | **49** | **12801318** | `find assets -type f -printf '%s\n' \| awk '{s+=$1} END{print s}'` |

Gruppen in assets/burgstadt/ton (Summe der Bytes je Gruppe, Befehl `find ... -printf '%s %f\n' | awk`):

| Gruppe | Dateien | Bytes | Fundstelle |
|---|---:|---:|---|
| LISTE.md (Textdatei, kein Ton) | 1 | 5742 | assets/burgstadt/ton/LISTE.md |
| musik_* (musik_gassen_schleife, musik_gewoelbe_schleife, musik_morgengrauen) | 3 | 7938132 | assets/burgstadt/ton/musik_*.wav |
| schritt_* (schritt_holz_1..4 je 19890; schritt_pflaster_1..4 je 15478; schritt_schnee_1..4 je 19890; schritt_stein_1..4 je 13274) | 16 | 274128 | assets/burgstadt/ton/schritt_*.wav |
| Einzeldateien (28 .wav, s. unten) | 25 | 3455456 | assets/burgstadt/ton/*.wav ohne Gruppen oben |
| **Summe** | **45** | **11673458** | Gruppen addieren sich auf die Ordnersumme |

Einzeldateien (ohne Gruppe), alphabetisch: detektivblick_an, detektivblick_aus, eule, fallakte_heften, fledermaus_flattern, handylicht_klick, hinweis_gefunden, hund_fern, kaminglut_schleife, kessel_brodeln_schleife, nebel_brummen_schleife, papier_rascheln, ruestung_klappern, schluessel_klimpern, schreck, teilen_senden, truhe_auf, tuer_eiche_auf, tuer_eiche_zu, tuer_eisen, uhrturm_schlag, uhrturm_viertel, ui_klick, ui_zurueck, wind_schleife. Das sind 25 Dateien. Kontrolle: 25 + 3 (musik_*) + 16 (schritt_*) + 1 (LISTE.md) = 45.

Schriften (assets/fonts, Fundstelle `find assets/fonts -type f`):

| Schrift | Bytes |
|---|---:|
| Inter-Regular.ttf | 324820 |
| Inter-Bold.ttf | 326468 |
| Inter-SemiBold.ttf | 326048 |
| SpecialElite-Regular.ttf | 150524 |
| **Summe** | **1127860** |

Die Schriften Inter-Regular, Inter-Bold und SpecialElite-Regular lädt die Druck-CLI (packages/mordakte_core/bin/party_druck.dart, Zeilen 39-41) per `readAsBytesSync`. Inter-SemiBold wird dort nicht geladen.

## 2. Druckfassung

Suche: `find . -iname '*druck*'` und `grep -rli druck packages lib tool docs content`. `docs` existiert im Baum nicht.

Ausgabeformat: PDF (Paket `pdf`, `pw.Document`, `doc.save()`). Fundstelle packages/mordakte_core/lib/src/party/druck/satz.dart Zeilen 43-48 (DruckDatei) und 50-66 (druckDateien).

Erzeugerbefehl (Fundstelle packages/mordakte_core/bin/party_druck.dart Zeile 3):
`dart run bin/party_druck.dart [--code XXXXX | --pfad <ahmet|fatma|olli|can>] [--n 12] [--detektiv w] [--aus ordner]`, im Paketordner packages/mordakte_core ausführen. Standardziel ist build/druck/<code>-n<n>.

Erzeugte Dateien (Fundstelle packages/mordakte_core/lib/src/party/druck/satz.dart Zeilen 58-65, Funktion druckDateien ab Zeile 50):

| Datei | Zeile in satz.dart |
|---|---:|
| 00-spielleitung.pdf | 58 |
| 01-detektivbogen.pdf | 59 |
| 10-rollenhefte.pdf | 60 |
| 11-fassungen.pdf | 61 |
| 12-stimmkarten.pdf | 62 |
| 20-indizkarten.pdf | 63 |
| 21-umschlaege.pdf | 64 |
| 90-aufloesung-versiegelt.pdf | 65 |
| **Summe** | **8 PDF-Teile** |

Die App lädt denselben Satz: lib/party/druck_tafel.dart Zeile 40 (`druckDateien(...)`). Der Download im Browser läuft über Blob mit `application/pdf`: lib/party/druck_speichern_web.dart Zeilen 5-6 und 10; Stub lib/party/druck_speichern_stub.dart Zeile 4 gibt `false` zurück.

Dateien der Druckfassung (Zeilen per `wc -l`):

| Datei | Zeilen | Rolle |
|---|---:|---|
| packages/mordakte_core/bin/party_druck.dart | 50 | CLI, Zeile 3 Aufruf |
| packages/mordakte_core/lib/party_druck.dart | 7 | Exporte (modell, satz, satz_stil) |
| packages/mordakte_core/lib/src/party/druck/modell.dart | 455 | Modell |
| packages/mordakte_core/lib/src/party/druck/satz.dart | 67 | Satz, druckDateien ab Zeile 50 |
| packages/mordakte_core/lib/src/party/druck/satz_stil.dart | 110 | Stil, Schriften |
| packages/mordakte_core/lib/src/party/druck/karten.dart | 134 | Karten |
| packages/mordakte_core/lib/src/party/druck/rollen.dart | 443 | Rollenhefte |
| packages/mordakte_core/lib/src/party/druck/spielleitung.dart | 589 | Spielleitungsheft |
| packages/mordakte_core/lib/src/party/druck/aufloesung.dart | 310 | Auflösungsheft |
| lib/party/druck_tafel.dart | 107 | App-Ansicht |
| lib/party/druck_speichern.dart | 7 | bedingter Import |
| lib/party/druck_speichern_stub.dart | 4 | Stub |
| lib/party/druck_speichern_web.dart | 50 | Web-Download |
| content/party/schlosskeller/texte/ui-druck-karten.json | 203 | Textbausteine |
| content/party/schlosskeller/texte/ui-druck-rollen.json | 115 | Textbausteine |
| content/party/schlosskeller/texte/ui-druck-spielleitung.json | 359 | Textbausteine |

Summe Bibliothek packages/mordakte_core/lib/src/party/druck/: 2108 Zeilen (7 Dateien; 455+67+110+134+443+589+310 = 2108).

Tests (Zeilen per `wc -l`):

| Datei | Zeilen |
|---|---:|
| packages/mordakte_core/test/party/druck_hilfe.dart | 46 |
| packages/mordakte_core/test/party/druck_karten_test.dart | 276 |
| packages/mordakte_core/test/party/druck_modell_test.dart | 140 |
| packages/mordakte_core/test/party/druck_rollen_test.dart | 233 |
| packages/mordakte_core/test/party/druck_spielleitung_test.dart | 206 |
| packages/mordakte_core/test/party/druck_test.dart | 193 |
| test/party_widgets/druck_tafel_test.dart | 62 |
| **Summe** | **1156** |

Nicht ermittelt: Dateigrößen der erzeugten PDFs. Es gab keinen Lauf (Auftrag: kein Build).

## 3. Renderer-Dateien lib/game/**

Befehl: `find lib/game -type f | xargs wc -l`. Summe 7066 Zeilen in 20 Dateien.

Maler im engen Sinn (Klasse erbt von CustomPainter oder hat eine Methode `paint(`), Befehl `grep -rn "CustomPainter\|paint(" lib/game`:

| Klasse | Datei:Zeile | Methode |
|---|---|---|
| PropPainter | lib/game/scene/prop_painter.dart:24 | paint() Zeile 80 |
| PartyProps | lib/game/scene/party_props.dart:15 | paint() Zeile 37 |
| JoystickPainter (extends CustomPainter) | lib/game/input/joystick.dart:56 | paint() Zeile 64 |
| _ButtonPainter (extends CustomPainter) | lib/game/input/action_button.dart:80 | paint() Zeile 89 |

Hinweis: `tp.paint(` in lib/game/scene/markers.dart Zeilen 493, 525, 547, 589 sind TextPainter-Aufrufe, keine Maler.

Maler im weiteren Sinn (Name endet auf Painter oder Renderer, zeichnen über Methoden wie paintX/render; kein paint(): FloorPainter lib/game/scene/floor_painter.dart:21 (paintGroup 69, paintDecor 520); WallPainter lib/game/scene/wall_painter.dart:58 (paintWall 66, paintDoor 227); FigurePainter lib/game/scene/figure_painter.dart:65; MarkerPainter lib/game/scene/markers.dart:62; LightingRenderer lib/game/scene/lighting.dart:34; WeatherSystem lib/game/scene/weather.dart:12 (render 105).

Dateitabelle:

| Datei | Zeilen | Maler | Effekte (Fundstelle) |
|---|---:|---|---|
| lib/game/mordakte_game.dart | 1676 | Game-Klasse MordakteGame Zeile 154, render 928 (kein Maler) | Teilchen _Teilchen 126; Nebel _Nebel 134, _renderNebel 1139; Rauch _Smoke 141, _drawSmoke 1441; _LocalPing 146; _zeichneKleineEffekte 826; Licht _renderPhasenLicht 1007, _renderSzenenLicht 1040 |
| lib/game/scene/floor_painter.dart | 608 | FloorPainter (weiter Sinn) | Bodenmaterial 111-383; Schimmer _sheen 459; Ambient Occlusion 473 |
| lib/game/scene/figure_painter.dart | 542 | FigurePainter (weiter Sinn) | Schatten shadowFigure 465; Augen shadowEyes 527 |
| lib/game/scene/markers.dart | 612 | MarkerPainter (weiter Sinn) | Spur traceGround 313, traceSmoke 358, traceGlow 377; ping 393; Zielring targetRing 435 |
| lib/game/scene/prop_painter.dart | 959 | PropPainter (eng) | Flamme _flame 946; paintDynamic 814 (Animation) |
| lib/game/scene/party_props.dart | 297 | PartyProps (eng) | keine |
| lib/game/scene/wall_painter.dart | 319 | WallPainter (weiter Sinn) | Fensterwetter paintWindowWeather 191 |
| lib/game/scene/lighting.dart | 165 | LightingRenderer (weiter Sinn) | Glühen _glows 155; Ausschnitt _roomCut 145 |
| lib/game/scene/weather.dart | 202 | WeatherSystem (weiter Sinn) | Regen _rain 121; Spritzer _splashes 140; Schnee _snow 150; Staub _dust 171; Neondunst _neonHaze 188 |
| lib/game/scene/static_scene.dart | 380 | keiner; ruft propPainter.paint auf Zeile 241 | keine |
| lib/game/scene/iso_pen.dart | 192 | Zeichenhelfer IsoPen Zeile 12 | keine |
| lib/game/iso_math.dart | 77 | keiner; applyGround Zeile 61 | keine |
| lib/game/scene/palette.dart | 87 | keiner; ScenePalette Zeile 6 | keine |
| lib/game/scene/szenen_erweiterung.dart | 69 | keiner; SzenenLicht Zeile 55 (lib/game/szenen_erweiterung.dart) | Lichtpunkt Zeile 44 (Daten) |
| lib/game/game_view.dart | 189 | keiner; GameView Zeile 23 | keine |
| lib/game/input/joystick.dart | 108 | JoystickPainter Zeile 56 (eng) | keine |
| lib/game/input/action_button.dart | 185 | _ButtonPainter Zeile 80 (eng) | keine |
| lib/game/dev/preview_main.dart | 101 | keiner | keine |
| lib/game/dev/scenario_preview_session.dart | 150 | keiner | keine |
| lib/game/dev/showcase_session.dart | 148 | keiner | keine |

Summe Maler im engen Sinn: 4 Klassen in 4 Dateien.

Zeilenzahl-Summe kontrolliert: 101+150+148+189+185+108+77+1676+542+608+192+165+612+87+297+959+380+319+202+69 = 7066.

## 4. Requisitenarten (lib/game/scene/prop_painter.dart)

Keine enum für Requisiten. Es gibt nur String-switch-Fälle auf `p.type`.

Haupt-Zeichnung `paint()` (switch ab Zeile 85, Fälle 86-152, default Zeile 154). 34 Fälle:

| Requisit | Zeile |
|---|---:|
| table | 86 |
| chair | 88 |
| armchair | 90 |
| sofa | 92 |
| bed | 94 |
| desk | 96 |
| bookshelf | 98 |
| cabinet | 100 |
| wardrobe | 102 |
| piano | 104 |
| fireplace | 106 |
| plant | 108 |
| lamp | 110 |
| clock | 112 |
| crate | 114 |
| barrel | 116 |
| bathtub | 118 |
| sink | 120 |
| toilet | 122 |
| counter | 124 |
| stove | 126 |
| fridge | 128 |
| seat | 130 |
| luggage | 132 |
| statue | 134 |
| vending | 136 |
| neon_sign | 138 |
| pool_table | 140 |
| bar_stool | 142 |
| tv | 144 |
| bush | 146 |
| tree | 148 |
| car | 150 |
| candles | 152 |
| default (Kiste als Ersatz) | 154 |

Weitere switch-Blöcke in prop_painter.dart:

| Block | Zeilen | Fälle |
|---|---|---|
| topZ (Höhe der Oberkante) | 44-53 | table 45, desk 47, counter 49, bed 51, pool_table 53 |
| light (Licht) | 62-73 | fireplace 63, lamp 65, candles 67, tv 69, vending 71, neon_sign 73 |
| paintDynamic (animiert) | 817-861 | fireplace 818, candles 831, lamp 836, tv 839, vending 853, neon_sign 859, clock 861 |

Party-Requisiten (lib/game/scene/party_props.dart, aufgerufen aus prop_painter.dart Zeile 84 bei `p.type.startsWith('party_')`):

| Requisit | Zeile in party_props.dart |
|---|---:|
| party_tafel | 40 |
| party_buffet | 42 |
| party_theke | 44 |
| party_anrichte | 47 |
| party_teekocher | 53 |
| party_kaffee | 56 |
| party_kamin | 59 |
| party_ascheneimer | 61 |
| party_wendeltreppe | 66 |
| party_ruestung | 68 |
| party_jackenstaender | 70 |
| party_kerzenstaender | 72 |

Summe: 34 Requisitenarten im Haupt-switch, 12 Party-Requisiten in party_props.dart.

## 5. Summen

| Bereich | Kennzahl | Fundstelle |
|---|---|---|
| Assets | 49 Dateien, 12801318 Bytes (45 Ton, 4 Schriften) | assets/ |
| Druck | 8 PDF-Teile, 1 CLI, 2108 Zeilen Bibliothek, 1156 Zeilen Tests | packages/mordakte_core/, lib/party/, test/party_widgets/ |
| Renderer | 20 Dateien, 7066 Zeilen; 4 Maler im engen Sinn | lib/game/ |
| Requisiten | 34 im Haupt-switch, 12 Party-Requisiten | prop_painter.dart Zeilen 86-152, party_props.dart Zeilen 40-72 |

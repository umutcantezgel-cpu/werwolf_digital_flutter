## Bausteine (Klasse · Datei:Zeile · Signatur · Eingaben · unabhängig/abhängig)

Kürzel: `lib/…` = `/home/user/werwolf_digital_flutter/lib/…`, `core/…` = `/home/user/werwolf_digital_flutter/packages/mordakte_core/lib/src/…`.

| Klasse | Datei:Zeile | Signatur (Auszug) | Eingaben | unabhängig / abhängig |
|---|---|---|---|---|
| `StaticScene` | lib/game/scene/static_scene.dart:87 | `factory StaticScene.build(ScenarioDef s, {double resolution = 1.6})` :104; `setOpenDoors(Set<Pt> open)` :354; `dispose()` :370 | ScenarioDef (liest theme, map) | abhängig: ScenarioDef, MapDef, TileChar, propCatalog |
| `StaticDrawable` | static_scene.dart:15 | ctor `{kind, x, y, depth, bounds, height, tall, prop?, east, wall?, door?, picture?}` :45-58; `bool occludes(Rect r)` :61 | Rect; optional PropDef, WallInfo, DoorInfo | überwiegend unabhängig |
| `FloorTile` | static_scene.dart:77 | `FloorTile(Rect dst, Image? image, Picture? picture, RoomDef? room)` :83 | RoomDef | abhängig (Feld `room` wird nicht gelesen) |
| `WallInfo`, `DoorInfo` | lib/game/scene/wall_painter.dart:13, :45 | const ctors (x, y, tall, window, south, east, southFloor, eastFloor, southOutdoor, eastOutdoor) bzw. (x, y, alongX, tall, locked) | Zahlen, Bool | unabhängig |
| `WallPainter` | wall_painter.dart:58 | `WallPainter(ScenePalette pal)`; `paintWall(Canvas, WallInfo)` :66; `paintDoor(Canvas, DoorInfo, {required bool open})` :227; `paintWindowWeather(Canvas, WallInfo, String weather, double t, double flash)` :191 | WallInfo, DoorInfo, ScenePalette | unabhängig (nur palette, iso_math) |
| `FloorPainter`, `FloorGroup` | lib/game/scene/floor_painter.dart:21, :9 | `FloorPainter(ScenePalette)`; `colors(String style)` :29; `paintGroup(Canvas, FloorGroup, {required Map<Pt,PropDef> props, required bool Function(int,int) isWall})` :69; `paintDecor(Canvas, PropDef, Rng)` :520 | FloorGroup(key, style, room, tiles, outdoor) | abhängig (RoomDef, PropDef, Pt, Rng) |
| `PropPainter` | prop_painter.dart:23 | `PropPainter(ScenePalette, {String weather = 'none'})` :27; `static double topZ(PropDef)` :38; `PropLight? light(PropDef)` :55; `paint(Canvas, PropDef, {bool east = false})` :75; `paintDynamic(Canvas, PropDef, double t, {bool east, double night = 0})` :808; `dynamicTypes` :35 | PropDef, ScenePalette, Zeit t | abhängig (PropDef, Rng) |
| `PropLight` | prop_painter.dart:10 | `const PropLight(double z, Color, double radius, {double flicker = 0})` | Zahlen | unabhängig |
| `IsoPen` | lib/game/scene/iso_pen.dart:12 | `IsoPen(Canvas, double ox, double oy, {bool east = false})`; `onFront(v, draw)` :37; `onSide(u, draw)` :40; `part(u, v, draw)` :53; `flush()` :55; `box(...)` :81; `worldBox(...)` :103; `cylinder(...)` :155; `sphere(...)` :177 | Canvas, Kachel-Offset, lokale Koordinaten | unabhängig |
| `Iso` | lib/game/iso_math.dart:12 | `toScreen(x, y, [z])` :28; `toWorld(sx, sy)` :32; `screenDirToWorld(dx, dy)` :40; `worldDirToScreen` :50; `facingToScreen(f)` :53; `applyGround(Canvas)` :61; `tileBounds(x, y, h, [margin])` :71; tileW 64 :13, unitZ 40 :19 | double | unabhängig (dart:ui, dart:math) |
| `ScenePalette` | lib/game/scene/palette.dart:6 | ctor mit 11 Farben :27 (background, floor, floorAlt, wall, wallTop, trim, accent, light, danger, text, fog); `fromTheme(ThemeDef?)` :41; `fallback` :62; Helfer `parseHex` :66, `mix` :76, `shade` :79, `withAlpha` :84, `luminance` :87 | ThemeDef? (nur fromTheme) | Helfer unabhängig; fromTheme abhängig |
| `LightingRenderer` | lib/game/scene/lighting.dart:34 | `LightingRenderer(ScenePalette)`; `render(Canvas, Rect view, {required LightMode mode, required double darkness, required List<SceneLight> lights, required List<RoomDef> litRooms, required List<GlowLight> glows, double flash = 0, double dayTint = 0.1})` :41; privat `_roomPath(RoomDef, double grow)` :130, `_roomCut` :145, `_glows` :155 | LightMode, SceneLight, GlowLight, RoomDef | teilweise abhängig (RoomDef in litRooms und `_roomPath`) |
| `SceneLight`, `GlowLight`, `LightMode` | lighting.dart:12, :24, :9 | `const SceneLight(x, y, radius, {double? cone, double strength = 1})`; `const GlowLight(x, y, z, radius, Color, strength)`; enum day/council/night | Zahlen; cone = Radiant | unabhängig |
| `FigureLook` | lib/game/scene/figure_painter.dart:10 | ctor `{coat, skin, hair, hatColor, hat, build, dress = false}`; `fromLook(LookDef)` :31; `detective(int coatIdx, String hat, String id)` :47 | LookDef; detectiveCoats | abhängig (LookDef, detectiveCoats) |
| `FigurePainter` | figure_painter.dart:65 | `buildScale(String)` :69; `standing(Canvas, Offset feet, FigureLook, {required double facing, double walk = 0, double moveAmt = 0, bool ghost = false, bool shadow = true})` :80; `lying(Canvas, double wx, double wy, FigureLook, {rot, chalk, glow, scale})` :344; `shadowFigure(Canvas, Offset, double t, {required facing, required mode, alpha})` :429; `shadowEyes(...)` :491 | Bildschirm-Offsets, FigureLook, Radiant, mode-String | unabhängig |
| `MarkerPainter`, `TextCache` | lib/game/scene/markers.dart:62, :10 | `MarkerPainter(ScenePalette, TextCache)`; `hotspot(Canvas, Offset, String state, String kind, double t, int seed)` :87; `item(Canvas, Offset, String type, double t, int seed)` :144; `traceGround` :313, `traceSmoke` :358, `traceGlow` :377; `ping(Canvas, double wx, double wy, double age, double life, Color)` :393; `targetRing` :435; `channelRing(Canvas, Offset, double progress, Color)` :463; `nameTag` :487; `targetLabelRect` :497, `targetLabel` :504; `bubble(Canvas, Offset, String kind, String value, double alpha, double scale)` :529; TextCache `get(text, size, color, {weight, shadow})` :13 | Strings (state fresh/searched, kind, type), Palette | unabhängig (Strings statt Core-Enums) |
| `WeatherSystem` | lib/game/scene/weather.dart:12 | `WeatherSystem(String kind, ScenePalette)` :21; `update(double dt, Size, double target, Offset pan)` :51; `render(Canvas, Size, double t)` :105 | kind rain/snow/neon/dust/none (= core/scenario/scenario_def.dart:115) | unabhängig |
| `JoystickState`, `JoystickPainter` | lib/game/input/joystick.dart:6, :56 | `start(int, Offset)` :26; `move(Offset)` :33; `end()` :48; `Offset get vector` :17; radius 56 :7, deadZone 0.14 :8; `JoystickPainter(JoystickState, Offset rest, Color accent)` :61 | Pointer-Events | unabhängig (nur Flutter) |
| `ActionButton` | lib/game/input/action_button.dart:9 | `ActionButton({super.key, required MordakteGame game, double size = 88})` :10; `_ButtonPainter` :80 (Symbol je kind :124-180) | MordakteGame: target, channelProgress, palette, triggerAction() | abhängig (MordakteGame) |
| `ActionTarget` | lib/game/mordakte_game.dart:22 | `const ActionTarget({required id, label, kind, x, y, z = 0, name = ''})` | kind: search, lab, hide, body, blood, npc, item, trace, revive, cancel (Doku :27) | unabhängig, liegt aber in mordakte_game.dart |
| `_Track` (privat) | mordakte_game.dart:53 | `add(double t, double x, double y, double f)` :61; `step(double rt, double dt, {bool useReportedFacing})` :66; Puffer 12 Samples :63 | Zeit, Pose | Logik unabhängig, aber privat: vor Wiederverwendung extrahieren |
| `MordakteGame` | mordakte_game.dart:137 | `MordakteGame({required GameSession session})` :138; `triggerAction()` :214; `screenToWorld(Offset)` :229; `ping(Offset)` :235; `onKeyEvent` :270; `update(double dt)` :298; `render(Canvas)` :831; Felder `stick` :146, `userZoom` :149, `target` :155, `channelProgress` :158, `palette` :161 | GameSession: world, caseView, playerId, scenario, move, send | abhängig (GameSession, WorldSnapshot, CaseView, Phase, LifeState, Tuning, effectCatalog, TileGrid, ScenarioDef, detectiveCoats); Flame-Import :4-5 |
| `GameView` | lib/game/game_view.dart:23 | `GameView({super.key, required GameSession session})` :24; Joystick-Zone :78; Long-Press 520 ms :92; Pinch 0.6-1.8 :117-121; Wheel-Faktor 0.0015 :137; buttonSize 88, margin 24 :44-45 | GameSession | abhängig (GameSession, MordakteGame) |
| `TileGrid` | core/scenario/grid.dart:12 | `TileGrid(MapDef)`; `canStand(x, y, [r = 0.28])` :88; `slide(x, y, dx, dy, [r])` :100; `lineOfSight(ax, ay, bx, by)` :114; `roomAtPos(x, y)` :85; `findPath(Pt, Pt)` :140; `setOpenDoors(Iterable<Pt>)` :67 | MapDef | Core ohne Flutter; abhängig von MapDef |
| Views | core/protocol/views.dart: WorldSnapshot :18, ChannelView :93, DetectiveView :107, NpcView :195, ShadowView :223, SignalView :238, ItemView :371, CaseView :484 (hotspots :515, openDoors :518) | Snapshots ca. 10 Hz, Fall-Zustand | Protokoll | abhängig |
| `Rng` | core/util/rng.dart:5 | `Rng(int seed)`; `nextInt(int)` :22; `nextDouble()`; `chance(p)` :30; `pick`; `shuffle`; `hashString` :54 | int-Seed | unabhängig (reine Dart-Klasse) |
| `ScenarioPreviewSession` (dev) | lib/game/dev/scenario_preview_session.dart:12 | implements GameSession; `_tick()` :33 erzeugt alle 100 ms (Timer :20) synthetische WorldSnapshots | ScenarioDef, Phase | abhängig; Vorlage für Rückblende |
| `ShowcaseSession` (dev) | lib/game/dev/showcase_session.dart:12 | Wrapper um FakeSession, reichert Zustände an | FakeSession | abhängig, nur Vorschau |
| `main` (dev) | lib/game/dev/preview_main.dart:21 | URL-Parameter phase, zoom, at, demo, scenario, local | URL | Entwicklungs-Einstieg |

Je Datei, kurz:
- Unabhängig: iso_math.dart, scene/iso_pen.dart, scene/wall_painter.dart, scene/weather.dart, scene/markers.dart, input/joystick.dart.
- Teilweise: scene/palette.dart (fromTheme nutzt ThemeDef), scene/lighting.dart (RoomDef), scene/figure_painter.dart (LookDef und detectiveCoats nur in Factories).
- Abhängig: scene/static_scene.dart, scene/prop_painter.dart, scene/floor_painter.dart, input/action_button.dart, mordakte_game.dart, game_view.dart (importiert Flame in :4), dev/*.

Umfang: alle Dateien unter lib/game/ (inkl. dev/, input/, scene/) vollständig gelesen, dazu die genutzten Core-Dateien catalog.dart, scenario_def.dart, grid.dart, rng.dart, geom.dart, views.dart, rules.dart (Tuning), validator.dart sowie lib/session/game_session.dart und content/SCHEMA.md.

## Szenenbau aus MapDef

- `ScenarioDef.map` (core/scenario/scenario_def.dart:16) ist ein `MapDef` (:143) mit `rows` (:145), `rooms` (:146), `props` (:147), `spawn` (:148), `councilRoom` (:149). Helfer: `charAt` (:163), `roomAt` (:172, lineare Suche über rooms), `propAt` (:170), `roomById` (:179).
- Aufruf: `MordakteGame._syncScenario` (mordakte_game.dart:322-349) ruft `StaticScene.build(s)` (static_scene.dart:104) auf. Palette via `ScenePalette.fromTheme(s.theme)` (:105), dann `_build(1.6)` (:128).
- Böden `_buildFloors` (static_scene.dart:272-351): Kacheln werden pro Raum gruppiert. Türkacheln gehören zum Nachbarraum (:288-289, `neighbourRoom` :275-283). Stil aus `floorStyles`, sonst `planks` (:295). Rasterisierung per `pic.toImageSync` (:333), Auflösung 1.6, maximal 4096 px (:320), Fallback auf Picture (:337-349).
- Wände (:141-188): `#` und `W` werden zu WallInfo. `tall` wenn Süd- oder Ostnachbar Boden ist (:139, :144). Sichtseiten :151-152. Tiefe `x+y+1` (:162), Bounds `Iso.tileBounds(x, y, h, 2)` (:163). Cutaway-Variante `lowPicture`, wenn die Wand einen Raum nach Süden/Osten begrenzt (:169-187, `_backRooms` :251-263).
- Türen (:189-214): `+` und `L` werden zu DoorInfo (:193, `locked` = `L`). `alongX`-Heuristik (:190), `tall` über Nachbarwand (:191-192). Liste `doors` (:213).
- Props (:217-245): Dekor `rug, bloodstain, papers, puddle` (decorTypes :102) wird übersprungen (:219) und in den Boden gemalt (:325-329). Höhe `max(0.3, spec.height)` (:223). Bounds-Zuschlag je Typ (:224-229: tree 0.4, car 0.2, clock 0.2, sonst 0.15). `east` bei Wand links und nicht oben (:222). `tall = spec.tall` (Höhe ≥ 1.2, catalog.dart:26). `propAt` (:243), `lightProps` (:244).
- `PropDef.spec` = `propCatalog[type] ?? PropSpec(true, 0.5)` (scenario_def.dart:237). Der Validator lehnt unbekannte Typen ab (validator.dart:74), Props nur auf Boden (:75), Boden-Kacheln nur `.` in Räumen (:58).
- Spawn wird im Bau nicht genutzt. Der Kamera-Startpunkt nimmt `spawn.first` (mordakte_game.dart:589-591). `councilRoom` wirkt nur über `litRooms` in Rats-Phasen (:883-889).
- Türzustand: `_syncCase` (mordakte_game.dart:405-418) → `setOpenDoors` (static_scene.dart:354). Dort werden nur `L`-Türen neu aufgenommen (:359). `+`-Türen haben keinen Zustand.
- Statik ist als Picture gecacht (:168, :241). Dynamische Props werden pro Frame gezeichnet (`_drawStatic`, mordakte_game.dart:1113-1116).

## Kamera, Zeichenreihenfolge, Licht, Taschenlampe, Eingabe

Kamera
- Ziel: `Iso.toScreen(px, py, 0.6)` (mordakte_game.dart:587). Folgen mit `k = 1 - exp(-dt·7)` (:597). Start direkt (:593-595).
- Zoom: `base = clamp(short / (10.5·64), 0.42, 2.4)` (:583) × `userZoom` clamp 0.6-1.8 (:584). Vertikaler Anker `_camY = 0.5` (:182).
- Transform in render: translate(size.x/2, size.y·0.5), scale(_zoom), translate(-_cam) (:842-845). Culling-Rect mit inflate 48 (:846-851).

Zeichenreihenfolge in `render()` (:831-919)
1. Böden als Bild-Tiles (:853-863).
2. Bodendekor in `_renderGround` (:922-978): Opfer liegend mit Kreideumriss (:926-932), tote NPCs (:935-947), niedergeschlagene Detektive mit rotem Glow (:949-965), Schattenspuren (:967-971), Zielring (:972-977).
3. Tiefensortierung `_renderSorted` (:980-1093). Einträge `(depth, layer, closure)` (:983). Layer 0 Statik (:1006), Layer 1 Hotspots, Items, Spuren (:1017-1034), Layer 2 NPCs, Detektive, Schatten (:1046, :1063-1066, :1076-1083). Sortierung nach depth, dann layer (:1086-1089). Depth ist x+y, Statik x+y+1.
   - Eigener Spieler verdeckt hohe Statik: Alpha 0.32 (:1003), Cutaway bei Raum hinter der Wand (:995-1000, :1103-1109).
4. Licht `_lighting!.render` (:877-892).
5. Nach Licht (:895, `_renderPostLight` :1244-1316): Schattenaugen (:1246-1255), nächtliches Spurglimmen (:1257-1266), Pings (:1290-1315).
6. Wetter auf dem Bildschirm (:899).
7. Overlays (:902, `_renderOverlays` :1333-1414): Namensschilder, Sprechblasen, Kanalringe, Zielbanner.
8. Vignette (:905-916) und Blitz (:917-919).

Licht
- Tag: nur `dayTint` und Glows mit 0.35 (lighting.dart:52-57).
- Nacht: `darkness = (1 - nightAmbient).clamp(0.3, 0.97)` (mordakte_game.dart:881). Dunkel-Layer per saveLayer (lighting.dart:61-62), lit-Räume ausgeschnitten (:64-66), Lichter als dstOut (:67-97), Glows (:98-107), Mondlicht multiply `#7C8CB8` mit 0.42 (:111-116), warmes Plus in lit-Räumen (:117-122).
- Rat: Dunkel 0.42 (mordakte_game.dart:881), Tönung (lighting.dart:125-127).
- Lichter `_lights` (mordakte_game.dart:1195-1228): Spieler lebend Radius `Tuning.nightLightRadius` 4.5 × Effekt (:1215; rules.dart:39), min 0.8 (:1216), mit Kegel `cone: f` (:1216). Versteckt r 1.6, Stärke 0.8 (:1213). Niedergeschlagen 1.3/0.7 (:1219). Eigener Geist 3.2/0.85 (:1221). Rat r 5.5 (:1207). Lokaler Ping r = 1.0·(1-age/1.6), Stärke 0.6 (:1225).
- `Tuning.dayLightRadius` (rules.dart:38) ist im gesamten Code ungenutzt.

Taschenlampe
- Kreis: radialer Dstout-Gradient mit Stops 0, 0.3, 0.72, 1 (lighting.dart:72-78).
- Kegel: Halbwinkel 0.5 rad (:81), Länge `radius·1.75` (:80), 10 Segmente (:83), Gradient 0.95/0.75/0 bei 0/0.55/1 (:88-93). Richtung ist `_pf` bzw. `tr.facing` (mordakte_game.dart:1204-1205).

Punktlichter (Glows)
- `_glows` (mordakte_game.dart:1230-1242) nimmt `scene.lightProps` und `propPainter.light(p)` (prop_painter.dart:55-73). Flicker `1 - flicker·0.25·(0.5+0.5·sin(9t+seed)·sin(5.3t+2·seed))` (mordakte_game.dart:1238). Radius und Stärke werden damit moduliert (:1239).
- Zeichnung: Nacht als Loch im Dunkel (lighting.dart:98-107), additiv bei Tag (:56) und Nacht (:124), Radius·26 px (:160).

Eingabe
- Joystick: linke 45 % × untere 60 % der Fläche (game_view.dart:78; Doku :20-21). Radius 56 (joystick.dart:7), Totzone 0.14 (:8), Vektor skaliert (:17-24). Wert nach `_game.stick` (game_view.dart:76).
- Priorität: Stick ab Länge 0.05, sonst Tastatur (mordakte_game.dart:470-471). Tastatur WASD/Pfeile (:258-267, `_keyboardDir` :280-292, nur mit Fokus :281-282). Aktion E, Leertaste, Enter (:272-274).
- Bewegung: `Iso.screenDirToWorld` (:499). Geschwindigkeit `Tuning.playerSpeed` 3.2 × Effekt × Betrag (:503; rules.dart:19). Teilschritte ≤ 50 ms (:302-315). Kollision `canStand`/`slide` mit Radius 0.28 (:507-508; rules.dart:21; grid.dart:88, :100-111, Schritte 0.2 bei :103).
- Senden ≤ 15 Hz bei Änderung über 0.004 Kachel oder 0.05 rad (:524-527).
- Antippen: `ActionButton` onPointerDown → `triggerAction()` (action_button.dart:32-35; mordakte_game.dart:214-226, vorher `_flushPose` :222). Ziel = nächstes Objekt in `Tuning.interactRange` 1.5 (:642; rules.dart:22) mit Bias (:658-747).
- Langes Drücken 520 ms → Ping (game_view.dart:92-98; mordakte_game.dart:235-245). Pinch (game_view.dart:117-121), Mausrad (:137).
- Interaktion nur in Ermittlung und Nacht (mordakte_game.dart:423-426). Bewegung zusätzlich in Rat und Anklage (:428-431).

## Prop-Katalog und Eignung für den Schlosskeller

Katalog: `propCatalog` in core/scenario/catalog.dart:34-74. Typen mit Licht: fireplace, lamp, candles, tv, vending, neon_sign (catalog.dart:29, Felder `light`). Hoch (tall, Höhe ≥ 1.2): bookshelf, cabinet, wardrobe, fireplace, lamp, clock, fridge, statue, vending, tree, neon_sign. Diese sollen laut content/SCHEMA.md (Abschnitt `map`) an Nord- oder Westwand stehen.

| Objekt laut Quelle | Typ im Katalog (catalog.dart) | Darstellung | Eignung | Fundstelle Quelle |
|---|---|---|---|---|
| Theke (Schanktheke, Küchentheke) | `counter` :54 (0.6, topZ 0.61 prop_painter.dart:44-45) | `_counter` :551 | gut; lange Theke = mehrere 1×1-Props | Teamchat 232, 336, JSON 478 |
| Buffettisch, lange Tafel | `table` :35 (0.45) | `_table` :162 | bedingt: nur Kachel-Tische, keine Mehrkachel-Tafel | 230, 240, 248 |
| Wandbank, Holzbank | `seat` :57 (Einzelsitz mit Lehne) oder `sofa` :38 | `_seat` :612, `_sofa` :206 | bedingt: kein Bank-Typ | 248, JSON 483 |
| Kamin | `fireplace` :45 (1.2, Licht, hoch) | `_fireplace` :379; Flamme `paintDynamic` :812-824 | gut; hoch, Nord/West-Wand | 26, 393, JSON 483 |
| Kerzen, Kerzenständer | `candles` :68 (0.5, Licht) | `_candlesStatic` :797; Flamme :825-829 | gut als Optik; Kerzenständer als Waffe nur Story | 12, 34 |
| Ritterrüstung | `statue` :59 (1.6, hoch) | `_statue` :642, Marmorfigur | nur Proxy; Rüstung fehlt, neuer Typ nötig | 9, 449, JSON 918 |
| Schauvitrine (Glas) | `cabinet` :42 (1.3, hoch) | Glasfront `pal.glass` prop_painter.dart:303 | nur Proxy; kein Typ `vitrine` | 22, 349, 564, 687 |
| Tür (Holz, Zweiflügel, Bogen, Schloss) | kein Prop; Tile `+` bzw. `L` | `paintDoor` wall_painter.dart:227; DoorInfo :45-54 | nur Grundtypen (alongX, tall, locked); keine Stilvarianten | 228, 234, 242 |
| Regal | `bookshelf` :41 (1.6, hoch) | `_bookshelf` :259 | gut für Optik | Im Teamchat kein "Regal" gefunden (siehe OFFENE FRAGEN) |
| Kiste, Getränkekiste | `crate` :49 (0.6) | `_crate` :486 | gut | 30, JSON 544 |
| Fass, Ascheneimer | `barrel` :50 (0.7) | `_barrel` :503 | Proxy für Ascheneimer | 38 |
| Teppichläufer | `rug` (Dekor) :70 | `paintDecor` floor_painter.dart:524-546 | gut, Boden | 349, 687 |
| Samowar, Teekanne | nicht vorhanden; Proxy: Zylinder im `counter`-Zufallsdekor prop_painter.dart:568-576 | – | Lücke | 232, 336, JSON 478 |
| Sicherungskasten | nicht vorhanden | – | Lücke (cabinet wäre Fehlnutzung) | 26, 344, JSON 483 |
| Jacken-/Kleiderständer | nicht vorhanden | – | Lücke | JSON 488, 541 |
| Außentreppe (5 Stufen), Wendeltreppe | nicht vorhanden; Bodenstil `stone` nur flach (floor_painter.dart:42-43) | – | Lücke | 228, 26, JSON 478 |
| Außentor, Eingangstür | nicht vorhanden; Tile `L` | – | Lücke | 228, 12 |

Ergänzend:
- Bodenstile passen: `stone` für Gewölbe (catalog.dart:15-18; floor_painter.dart:42-43), `tiles` für Küche, `planks`, `carpet`.
- Wetter: `dust` innen mit Intensität 0.55 (mordakte_game.dart:812-816, weather.dart:23-29). Kein Kaminrauch: der einzige Rauch ist der Schattenrauch (`_Smoke`, mordakte_game.dart:124-127, :757-783).
- Validator prüft nur Typ, Boden und Überlappung (validator.dart:58-78), nicht die Höhenregel an den Wänden.

## Ergänzungsstellen (Fog, Punktlichter, Ruhe-Animation, Rückblende)

Fog-of-War je Raum (100 % schwarz, radiale Aufblendung 0,4 s)
- Vorhanden ist nur das Gegenteil: lit-Räume werden nachts freigeschnitten (mordakte_game.dart:883-889, lighting.dart:64-66). Raumform liefert `_roomPath` (lighting.dart:130-143), Raum-Rechteck `RoomDef.x/y/w/h` (scenario_def.dart:190-193).
- Raumzugehörigkeit: `_playerRoom` (mordakte_game.dart:520, :547). `roomAtPos` (grid.dart:85) → `MapDef.roomAt` (scenario_def.dart:172). Türkacheln sind keinem Raum zugeordnet (`_isDoorTile` mordakte_game.dart:553-556). Es gibt kein Sichtfeld, nur den eigenen Raum.
- Sichtlinie: `TileGrid.lineOfSight` (grid.dart:114) wird im Client nicht genutzt (nur core: shadow.dart:74, :236; engine.dart:742, :1372). `_sightBlocked = !floorLike` (grid.dart:82). `+`-Türen zählen als floorLike (:79) und blockieren Sicht nicht. Eine Änderung hier wirkt auch auf die Engine-Schattenlogik.
- Einfügestelle: nach `_renderSorted` und vor dem Licht (mordakte_game.dart:869-871), oder nach `_renderPostLight` (:895). Schwarze Flächen je Raum als Path nach `_roomPath`-Muster (lighting.dart:130). Radiale Aufblendung über `Gradient.radial` mit Zentrum auf der Türkachel (`Iso.toScreen(x+0.5, y+0.5)`, iso_math.dart:28), Vorlage Shader lighting.dart:72-77.
- Zeit: `_time` und `_lastDt` vorhanden (mordakte_game.dart:175-176, :304-305). Kein Tween-Helfer.
- Ohne Raumfilter, also weiterhin sichtbar: Statik (:995-1007), Items und Hotspots (:1009-1035), NPCs (:1038-1047), Detektive (:1049-1068), Schatten (:1070-1085), Bodendekor (:922-978), Post-Light (:1244-1316), Namensschilder (:1349-1382), Lichter (:1195-1228), Glows (:1230-1242).
- Die Statik-Alpha-Mechanik existiert: `d.alpha` mit saveLayer (mordakte_game.dart:1098-1100), Vorlage für Fade.
- Tagmodus: `LightingRenderer` zeichnet im Tag nur dayTint (lighting.dart:52-57). Fog muss separat gezeichnet werden.

Warme Punktlichter mit eigener Farbe und Sinusflackern
- Vorhanden: `PropLight(z, color, radius, flicker)` (prop_painter.dart:10-19), Werte je Typ (:59-69). Glow-Flicker mit Sinus (mordakte_game.dart:1238). Kerzen- und Kaminflammen mit Sinus (prop_painter.dart:821, :828). Additive Glows und Nacht-Ausschnitt (lighting.dart:98-107, :155-164).
- Lücke 1: Lichtquelle nur per Typ (`PropSpec.light`, catalog.dart:29). Theke, Tisch, Tafel, Sofa haben kein Licht. Pro Objekt braucht es ein neues Feld in `PropDef` (scenario_def.dart:228-245: nur type, x, y, color) und Validator/Schema-Anpassung (validator.dart:73-74).
- Lücke 2: `PropDef.color` wirkt nicht auf die Lichtfarbe von candles, fireplace, lamp (prop_painter.dart:59-63). Nur vending und neon_sign nutzen `custom` (:67, :69). Die Quellfarbe `RGB(255,147,41)` (Teamchat 260) ist nirgends hinterlegt.
- Lücke 3: Schatten 45° (Teamchat 262). `_ambientOcclusion` (floor_painter.dart:473-516) nutzt feste Streifen von 0.5 Kachel ohne Richtung (:479-496).

Ruhe-Animation stehender Figuren
- Vorhanden: keine Idle-Animation. `standing()` animiert nur über `walk` und `moveAmt` (figure_painter.dart:95-96, :102, :117-118). Die Signatur hat keinen Zeitparameter (:80-89). NPC-`move` kommt aus Positionsänderung (mordakte_game.dart:103-105), stehende NPCs bleiben statisch. NPC-Blick ändert nur `facing` (:570-575).
- Zeitabhängig sind nur Schatten (`shadowFigure` :429-488) und Props (`paintDynamic`, prop_painter.dart:808).
- Einfügestelle: `standing` um `double t` und Idle-Parameter erweitern. Atmung über `translate` nach figure_painter.dart:102, Kopf bei :222. Phase je Figur aus Hash (figure_painter.dart:49-52). Aufrufstellen mordakte_game.dart:1046, :1172, :1179, :1183.
- Erkennungsmerkmale fehlen: `LookDef` hat nur coat, skin, hair, hat, build, outfit (scenario_def.dart:357-371). Hüte sind auf einen festen Satz beschränkt (`LookDef.hats`, :380). `FigureLook` (figure_painter.dart:10-29) hat keine Requisiten. Teamchat verlangt Pfeife, Smartphone, Schlüsselbund, Brille, Kopftuch, Schal (JSON visualSpecs, z. B. 499, 514, 535, 562).

Rückblende (Figuren entlang einer Zeitleiste)
- Vorhanden: `_Track` mit Puffer 12 (mordakte_game.dart:53-63), Interpolation mit 120 ms Verzögerung (:566), Teleport über 3 Kacheln (:97). Quelle ist nur `_ingestWorld` (:355-403). Figuren fehlen im Snapshot → Track wird entfernt (:382).
- Kein Timeline-Format in content/SCHEMA.md oder core.
- Weg A ohne Renderer-Änderung: eigene GameSession, die synthetische WorldSnapshots liefert. Vorlage `ScenarioPreviewSession._tick()` (scenario_preview_session.dart:33-67, Intervall :20). `t` ist Laufzeit in ms (views.dart:20).
- Weg B im Renderer: `_ingestWorld` durch Timeline-Quelle ersetzen. `_time` (mordakte_game.dart:305) und `_tracks` (:195) steuern Animation und Figuren.
- Stolpersteine: Interaktion ist an `_me` gebunden (mordakte_game.dart:631-636) und sollte in Rückblende aus sein. Eigene Pose setzt `_ingestWorld` (:384-402). Nacht-Licht hängt an `_phase` (:420, :872), also muss die Timeline die Phase setzen.

## OFFENE FRAGEN

1. OFFENE FRAGE: Maßstab. Teamchat nennt `widthMeters: 8` für den Thekensaal (Zeile 477). Die Welt ist in Kacheln gedacht (iso_math.dart:6-8), Laufgeschwindigkeit 3.2 Kacheln/s (rules.dart:19). Ist 1 Kachel = 1 m?
2. OFFENE FRAGE: Raummodell unvollständig. Teamchat und JSON nennen drei Räume ohne Geometrie (JSON Zeilen 473-490, keine x/y/w/h). Nicht als Raum definiert: Vorratsraum (Tatort, Zeilen 12, 26), Gewölbegang mit Vitrine (22), Schlossturm/WC (242, JSON 483), Flur mit Ritterrüstung (9, 449), Vorratskammer (389). Welche Raumaufteilung gilt?
3. OFFENE FRAGE: Widerspruch Opferposition. Zeile 279 sagt "Wanderte zwischen Küchentheke und West-Saal". JSON Zeilen 516-517 sagen startRoom thekensaal bei (4.0, 6.5). Tatort ist laut Zeile 12 der Vorratsraum. Welche Position gilt für `VictimDef.hotspot` (scenario_def.dart:322-330)?
4. OFFENE FRAGE: Figurenkoordinaten (JSON, z. B. Kaan (2.5, 8.0) Zeile 848) lassen sich ohne Geometrie nicht gegen Begehbarkeit prüfen.
5. OFFENE FRAGE: Türstile. Zweiflügel-, Bogen- und Schlosstür (Zeilen 228, 242) sind mit DoorInfo nicht darstellbar (wall_painter.dart:45-54). Soll ein Stilfeld kommen?
6. OFFENE FRAGE: Sichtregel für Fog. Teamchat spricht von Zwischentüren, die Räume öffnen (Zeile 254). `+`-Türen sind immer offen (content/SCHEMA.md, Abschnitt `map`), und `L` öffnet nur über Spur (`_syncCase` mordakte_game.dart:405-418). Soll die Fog-Sichtregel nur clientseitig gelten oder in core, wo sie auch die Schattenlogik betrifft?
7. OFFENE FRAGE: Was ist "Sichtfeld"? Raumweise (eigener Raum plus Nachbarn über offene Tür) oder Sichtlinie (`lineOfSight`, grid.dart:114)? Soll `Tuning.dayLightRadius` (rules.dart:38, ungenutzt) als Sichtradius dienen?
8. OFFENE FRAGE: Soll der Schatten in gefogten Räumen sichtbar sein? Die Engine liefert `shadow` nur, wenn der Betrachter ihn sehen kann (views.dart:28-29).
9. OFFENE FRAGE: Rückblende braucht ein Datenformat für Zeitleisten (Zeit, x, y, facing, Phase). Im Teamchat stehen Uhrzeiten (23:45, 23:50-00:00, 23:55-00:05, 23:58; Zeilen 361, 409, 433, 469, 710), keine Laufzeitwerte.
10. OFFENE FRAGE: Punktlicht pro Objekt. Soll `PropDef` (scenario_def.dart:228) ein Licht-Feld bekommen, oder sollen eigene Typen angelegt werden?
11. OFFENE FRAGE: Lichtfarbe. Teamchat fordert `(255,147,41)` (Zeile 260). Soll das über palette `light` (palette.dart:55) oder über `PropDef.color` laufen? Aktuell ignoriert `light()` die Farbe bei candles, fireplace und lamp (prop_painter.dart:59-63).
12. OFFENE FRAGE: Fehlende Typen: Rüstung, Vitrine, Bank, Samowar, Sicherungskasten, Jackenständer, Treppe. Soll die Liste erweitert werden? Der Validator lehnt Unbekanntes ab (validator.dart:74).
13. OFFENE FRAGE: "Regal" taucht im Teamchat nicht auf, steht aber in der Aufgabenliste. Soll es als bookshelf gelten?
14. OFFENE FRAGE: Mehrkachel-Objekte. Bänke, Tafeln und Theke sind 1×1 (content/SCHEMA.md, Abschnitt `map`; PropDef ohne Größe, scenario_def.dart:228-237). Sollen lange Objekte aus mehreren Props bestehen?
15. OFFENE FRAGE: Figuren-Merkmale wie Kopftuch, Brille, Schal, Pfeife, Smartphone fehlen in LookDef (scenario_def.dart:357-371). Erweitern oder weglassen?
16. OFFENE FRAGE: Höhenregel. Hohe Props sollen an Nord- oder Westwand stehen (content/SCHEMA.md, Abschnitt `map`). Der Validator prüft das nicht (validator.dart:58-78). Teamchat-Positionen wie Kamin-Nische (Zeile 396) passen dazu. Soll der Validator das prüfen?
17. OFFENE FRAGE: Rauch. "Kamin-Rauch" (Zeilen 9, 393) und Zugluft (Zeile 7) sind nicht umgesetzt. Ist das gewünscht?
18. Zur Info, totes Material: `StaticScene.worldBounds` (static_scene.dart:98, :130) wird nicht gelesen, `StaticScene.doors` (:94) ebenfalls, `FloorTile.room` (:81) auch. `Tuning.dayLightRadius` (rules.dart:38) ist ungenutzt.

=== ENDE F0-KUNDSCHAFTER-01 · BEREIT ZUR RÜCKGABE ===
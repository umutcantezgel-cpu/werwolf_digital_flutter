# P0-KUND-02 · Dichte-Audit

Commit (Basis, `git rev-parse --short HEAD`): `c54fe9c` · Stand 2026-10-09 · Haiku-Platz 2 · HZ-03

Geprüft: alle `.dart`-Dateien unter `packages/pixel_engine`, `packages/burgstadt_core`, `packages/burgstadt_spiel` (lib, bin, test) und `tool/` (ohne `.dart_tool/`), 136 Dateien. Ausgangslage: `kTexelsPerMeter = 32` ist heute eine einzige Konstante für Welt und Figuren (`packages/pixel_engine/lib/src/raster/mesh.dart:5`). `kDichteWelt`, `kDichteFigur` existieren noch nicht (Suche nach `kDichte` ohne Treffer). Alle Zeilenangaben sind repo-relativ.

Legende: **ja** = Wert hängt direkt an der Dichte oder an einer Pixelgröße, die aus der Dichte folgt. **indirekt** = Wert wird über eine Zwischengröße wirksam. Nein-Treffer stehen in „Verworfene Treffer“.

## 1. Dichte-abhängige Stellen

| Nr | Datei:Zeile | Code (gekürzt) | Dichte-abhängig | Art | Zielpaket |
|---|---|---|---|---|---|
| 1 | packages/pixel_engine/lib/src/raster/mesh.dart:4-5, 8, 11, 58 | `const double kTexelsPerMeter = 32;` (Doku: „Einheitliche Texel-Dichte für Welt und Figuren“) | ja | Weltdichte + Figurendichte in einer Konstante (Split nötig) | P1-OPUS-05 |
| 2 | packages/pixel_engine/lib/src/raster/mesh.dart:64-66 | `wall()`: `u0 + len * kTexelsPerMeter`, `v0 + (y1 - y0) * kTexelsPerMeter` | ja | UV-Umrechnung Wand (relativ, mit u0/v0) | P1-OPUS-05 |
| 3 | packages/pixel_engine/lib/src/raster/mesh.dart:82-85 | `floor()`: `xx * kTexelsPerMeter`, `zz * kTexelsPerMeter` (absolute Weltkoordinate) | ja | UV-Umrechnung Boden (absolut) | P1-OPUS-05 |
| 4 | packages/pixel_engine/lib/src/raster/renderer.dart:13 | Doku `Texel-Dichte wie die Welt: [kTexelsPerMeter]` (SpriteImage) | ja | Figurendichte (Doku) | P1-OPUS-05 |
| 5 | packages/pixel_engine/lib/src/raster/renderer.dart:22-24, 28-32 | `_buildMips()`: `while (out.length < 4 && w >= 4 && h >= 4)`; Stufengrößen `_mw`, `_mh` | indirekt (Spritegröße) | Mip-Cap Sprite (4 Stufen) | P1-OPUS-05 |
| 6 | packages/pixel_engine/lib/src/raster/renderer.dart:384-385 | `final m1 = focal / kTexelsPerMeter * 2, m2 = m1 * 2, m3 = m2 * 2;` | ja | Mip-Schwelle Dreiecke (Schwellen bei 2, 4, 8 Texel je Bildpixel) | P1-OPUS-06 |
| 7 | packages/pixel_engine/lib/src/raster/renderer.dart:429 | `var lv = z < m1 ? 0 : (z < m2 ? 1 : (z < m3 ? 2 : 3));` | ja | Mip-Auswahl Dreiecke, hart gedeckelt bei Stufe 3 | P1-OPUS-06 |
| 8 | packages/pixel_engine/lib/src/raster/renderer.dart:430 | `if (lv >= nLv) lv = nLv - 1;` | indirekt (Texturstufen) | Mip-Cap pro Textur | P1-OPUS-05 |
| 9 | packages/pixel_engine/lib/src/raster/renderer.dart:431-434 | `tu = ((uz * z).floor() >> lv) & (tw - 1)`, `tv` entsprechend, `levels[lv][tv * tw + tu]` | ja | UV zu Texel mit Mip-Stufe, Kachelung über `&` | P1-OPUS-06 |
| 10 | packages/pixel_engine/lib/src/raster/renderer.dart:483 | `final scale = cam.focal * iz / kTexelsPerMeter; // Bildpixel pro Texel` | ja | Figurendichte: Sprite-Skalierung (muss kDichteFigur sein) | P1-OPUS-05 |
| 11 | packages/pixel_engine/lib/src/raster/renderer.dart:490-494 | Sprite-Mip: `lv = (math.log(1 / scale) / math.ln2).floor()`, Cap `s._mips.length - 1` | ja (über scale) | Mip-Auswahl Sprite (log2) | P1-OPUS-06 |
| 12 | packages/pixel_engine/lib/src/raster/renderer.dart:503, 509 | `((yy + 0.5 - top) / scale).floor() >> lv` und `tx` entsprechend | ja (über lv) | Mip-Lookup Sprite | P1-OPUS-06 |
| 13 | packages/pixel_engine/lib/src/raster/texture.dart:18, 24 | `{int maxLevels = 5}`; `while (levels.length < maxLevels && w > 1 && h > 1)` | indirekt | Mip-Cap Textur (bis 5 gebaut, Renderer nutzt 4) | P1-OPUS-05 |
| 14 | packages/pixel_engine/lib/src/figur/baker.dart:5 | `import '../raster/mesh.dart' show kTexelsPerMeter;` | ja | Baker hängt an der Welt-Konstante | P1-OPUS-11 / P6-OPUS-01 |
| 15 | packages/pixel_engine/lib/src/figur/baker.dart:31 | Doku `(orthografisch, 32 Texel/m)` | ja | Figurendichte (Doku) | P1-OPUS-11 / P6-OPUS-01 |
| 16 | packages/pixel_engine/lib/src/figur/baker.dart:35 | `static const int breite = 48, hoehe = 80, fussX = 24, fussY = 77;` | ja | Figurenmaße (Sprite-Größe, Fußpunkt) | P1-OPUS-11 / P6-OPUS-01 |
| 17 | packages/pixel_engine/lib/src/figur/baker.dart:40 | Doku `Stilisierung … bei ~56 px Figurhöhe` | ja | Figurenmaße (Doku-Zahl: 1,75 m × 32 = 56) | P1-OPUS-11 / P6-OPUS-01 |
| 18 | packages/pixel_engine/lib/src/figur/baker.dart:63 | `final s = k.groesse / 1.75;` | indirekt (Meter; Pixelhöhe = 1,75 × Dichte) | Figurendichte (Referenzgröße 1,75 m) | P1-OPUS-11 / P6-OPUS-01 |
| 19 | packages/pixel_engine/lib/src/figur/baker.dart:147, 150-153, 208, 257, 265-268 | `const n = breite * hoehe;` Arbeitspuffer; `SpriteImage(breite, hoehe, pix, footX: fussX, footY: fussY)` | ja | Figurenmaße (abgeleitet) | P1-OPUS-11 / P6-OPUS-01 |
| 20 | packages/pixel_engine/lib/src/figur/baker.dart:168, 170 | `vy = (fussY - (py + 0.5)) / kTexelsPerMeter`; `vx = (px + 0.5 - fussX) / kTexelsPerMeter` | ja | UV-Umrechnung Pixel zu Meter (Strahlwurf) | P1-OPUS-11 / P6-OPUS-01 |
| 21 | packages/pixel_engine/lib/src/figur/baker.dart:225 | `tiefe[j] < tiefe[i] - 0.07` | indirekt (Schwelle in m; Pixelwirkung bei 64 doppelt so groß) | Innenlinien-Schwelle Figur | P1-OPUS-11 / P6-OPUS-01 |
| 22 | packages/pixel_engine/lib/src/figur/baker.dart:247-248 | `(vx * kTexelsPerMeter + fussX).floor()`, `(fussY - vy * kTexelsPerMeter).floor()` | ja | Augenpixel: Meter zu Pixel | P1-OPUS-11 / P6-OPUS-01 |
| 23 | packages/pixel_engine/lib/src/figur/sprite_pruef.dart:18-19 | `s.width != FigurBaker.breite \|\| s.height != FigurBaker.hoehe`; `footX`/`footY` | ja | Figurenmaße in der Prüfung (Konstanten) | P1-OPUS-11 / P6-OPUS-01 |
| 24 | packages/pixel_engine/lib/src/figur/sprite_pruef.dart:37 | `if (deckend < 200)` | ja (Fläche wächst mit Dichte²) | Pixelschwelle Sichtbarkeit | P6-AUTOR-07 |
| 25 | packages/pixel_engine/lib/src/figur/sprite_pruef.dart:38 | `unterste < s.footY - 3 \|\| unterste > s.footY + 1` | indirekt | Fußzeilen-Toleranz in Pixeln | P6-AUTOR-07 |
| 26 | packages/pixel_engine/lib/src/figur/portraet.dart:1-2, 24-25 | Doku `64×64-Brustbild`; `const int kPortraetBreite = 64; const int kPortraetHoehe = 64;` | ja | Porträtgröße | P6-OPUS-03 |
| 27 | packages/pixel_engine/lib/src/figur/portraet.dart:28, 31-32 | `_fussX = 32, _fussY = 63`; `_kopfHoehePx = 0.6 * kPortraetHoehe`; `_kopfMitteZeile = 23.0` | ja | Porträt-Fußpunkt und Kopfmaße in Pixeln | P6-OPUS-03 |
| 28 | packages/pixel_engine/lib/src/figur/portraet.dart:114, 234 | `SpriteImage(kPortraetBreite, kPortraetHoehe, pix, footX: _fussX, footY: _fussY)`; `const ww = kPortraetBreite, hh = kPortraetHoehe;` | ja | Porträtgröße | P6-OPUS-03 |
| 29 | packages/pixel_engine/lib/src/figur/portraet.dart:117, 124, 139, 144, 248 | Kopfmitte `32`; `ppm` (Pixel je Meter, aus Kopfhöhe in Pixeln, Z. 139); `bild()`: `32 + (vx - vcx) * ppm`; `(px + 0.5 - 32) / a.ppm` | ja | Porträt-Pixeldichte (eigene, nicht an kTexelsPerMeter gekoppelt) und Bildmitte | P6-OPUS-03 |
| 30 | packages/pixel_engine/lib/src/demo/demo_scene.dart:90-111 | `* kTexelsPerMeter` (Satteldach und Giebel, UV) | ja | UV-Umrechnung (Demo-Szene) | P1-OPUS-05 |
| 31 | packages/pixel_engine/lib/src/demo/demo_scene.dart:118-119, 138-139, 174-175 | `const n = 32;` in `_cobble`, `_plaster`, `_stoneWall` | ja | Texturgröße 32 (Demo) | P1-OPUS-05 |
| 32 | packages/pixel_engine/lib/src/demo/demo_scene.dart:150-151, 163-164, 189-190 | `const n = 16;` in `_roof` und `_wood`; `const w = 16, h = 16;` in `_window` | ja | Texturgröße 16 (Demo) | P1-OPUS-05 |
| 33 | packages/pixel_engine/lib/src/kit/texturen.dart:267 (Aufrufe 62-67, 94) | `_putz`: `final t = _Tex(32), r = _Lcg(seed);` | ja | Texturgröße 32 (7 Putz-Texturen) | P1-OPUS-05 |
| 34 | packages/pixel_engine/lib/src/kit/texturen.dart:285, 323, 350 (Aufrufe 342, 344), 491, 497, 516, 525, 535, 549, 573, 619, 633, 646, 664, 680, 699, 718, 744, 767, 788, 805, 814 | `final t = _Tex(32)` je Funktion | ja | Texturgröße 32 (22 Funktionen, 23 Texturen; `_dach` liefert zwei) | P1-OPUS-05 |
| 35 | packages/pixel_engine/lib/src/kit/texturen.dart:307, 397, 428, 447, 469, 590 | `_Tex(64)` in `_pflasterGross`, `_bruchsteinMauer`, `_quaderMauer`, `_burgBruchstein`, `_gewoelbeDecke`, `_fachwerkPutz` | ja | Texturgröße 64 (6 Texturen) | P1-OPUS-05 |
| 36 | packages/pixel_engine/lib/src/kit/texturen.dart:271, 276, 299, 334, 357, 382-383, 519-520, 528-529, 553, 561-564, 577, 578-581, 636, 651, 654, 667, 670, 692, 711, 721-722, 735-736, 771-772, 778, 791-792, 808-809, 819-820, 823-824 | Texel-Literale in 32er-Funktionen: `r.below(27)`, `r.below(32)`, `[4, 11, 17, 24, 30]`, `fugen[0] + 32`, `hline(0, 9, 32, …)`, `rect(4, 4, 24, 22, …)`, `vline(c, 0, 32, …)` | ja | Zeichnung auf dem 32er-Raster; bei Texelverdopplung neu zu skalieren | P1-OPUS-05 |
| 37 | packages/pixel_engine/lib/src/kit/texturen.dart:316, 413, 416-417, 460, 462, 473-475, 595, 599-601, 604-606 | Texel-Literale in 64er-Funktionen: `[4, 19, 32, 48]`, `[13, 26, 48]`, `[8, 24, 39, 55]`, `% 32` (Z. 475, `_gewoelbeDecke`), `2 + r.below(58)`, `vline(x, 0, 64, …)` | ja | Zeichnung auf dem 64er-Raster; `% 32` hat Periode 32 | P1-OPUS-05 |
| 38 | packages/pixel_engine/test/texturen_test.dart:37-40 | `expect([32, 64], contains(t.width));` `expect(t.height, t.width);` | ja | Test-Erwartung Texturgröße | P1-AUTOR-01 |
| 39 | packages/pixel_engine/test/pixel_test.dart:111, 122, 124 | `SpriteImage(8, 16, px, footX: 4, footY: 15)`; `r.drawSprite(s, 5, 0, 0)`; `r.drawSprite(s, 2, 0.5, 0)` | ja (Sprite-Größe in m hängt an kTexelsPerMeter) | Test-Erwartung Sprite-Skalierung | P1-OPUS-05 |
| 40 | packages/pixel_engine/test/portraet_test.dart:43-48 | `64×64`; `s.footX != 32 \|\| s.footY != 63`; `sichtbar < 1500` | ja | Test-Erwartung Porträtformat | P6-OPUS-03 |
| 41 | packages/pixel_engine/test/portraet_test.dart:53, 72-73 | `c >= 64`; `y >= 0.7 * 64`; `y < 10 \|\| y > 50` | ja (Zeilenbezug); `c >= 64` ist Palette | Test-Erwartung Porträt-Zeilen | P6-OPUS-03 |
| 42 | packages/pixel_engine/test/portraet_test.dart:94-104, 112-118 | `n < 12` Pixel mit Zeilen 10 bis 50; `n < 150` Pixel | ja | Test-Erwartung Pixelschwellen Porträt | P6-OPUS-03 |
| 43 | packages/pixel_engine/test/figur_test.dart:34, 40-41 | `return s.footY - y;`; `hoehe(1.75) > hoehe(1.2) + 10`; `inInclusiveRange(54, 66)` | ja (1,75 × 32 = 56 px) | Test-Erwartung Figurenhöhe | P6-AUTOR-07 |
| 44 | packages/pixel_engine/test/figur_test.dart:56 | `s.pixels.sublist(oben * s.width, (oben + 14) * s.width)` | ja | Test-Erwartung Kopfbereich in Zeilen | P6-AUTOR-07 |
| 45 | packages/pixel_engine/test/karten_test.dart:173-186 | `if (px < 40 \|\| (maske < 12 && !farbeVerschieden))` | ja (px-Schwelle); `maske` nein (32er-Normierung) | Test-Erwartung Unterscheidbarkeit in Pixeln | P6-AUTOR-07 |
| 46 | packages/pixel_engine/test/teile_koepfe_test.dart:106-109, 121 | `_augen(...) == 2`; `_abstand(...) < 4` | ja | Test-Erwartung Augen- und Sichtbarkeitspixel | P6-AUTOR-08 |
| 47 | packages/pixel_engine/test/teile_kleidung_test.dart:105, 119, 123-125 | `groesste >= 4`; `_augen(...) == 2` | ja | Test-Erwartung Sichtbarkeitspixel und Augen | P6-AUTOR-08 |
| 48 | packages/pixel_engine/bin/portraetprobe.dart:21 | `const pb = kPortraetBreite, ph = kPortraetHoehe;` | ja | Porträtraster (Probe) | P6-OPUS-03 |
| 49 | packages/pixel_engine/bin/figurenprobe.dart:32; packages/pixel_engine/bin/teile_kleidung_probe.dart:38; packages/pixel_engine/bin/aufstellung.dart:21; packages/pixel_engine/bin/teile_koepfe_probe.dart:10, 16, 37 | `FigurBaker.breite`, `FigurBaker.hoehe`; Doku `Sprite-Zeilen (Standard 0–80)` (teile_koepfe_probe.dart:10) | ja | Figurenmaße (Probe-Werkzeuge) | P1-OPUS-11 / P6-OPUS-01 |
| 50 | tool/abnahme.dart:77 | Text `gleiche Pixeldichte: karten_test` | ja (Begriff) | Abnahme-Text; karten_test prüft die Dichte nur indirekt über `pruefeFigur` | P6-AUTOR-07 |
| 51 | packages/burgstadt_spiel/lib/src/fledermaeuse.dart:20-25 | Doku `Je 9×5 Texel, Fußpunkt Mitte`; drei Bilder 9×5 | ja (Welt-Größe über drawSprite) | Sprite-Größe Fledermaus | P1-OPUS-05 |
| 52 | packages/burgstadt_spiel/lib/src/fledermaeuse.dart:110 | `r.drawSprite(bilder[t.bild], t.x, t.y, t.z, cold: 0.6);` | ja | Skalierung Fledermaus: Dichte-Zuordnung offen | P1-OPUS-05 |
| 53 | packages/burgstadt_spiel/lib/src/fledermaeuse.dart:212-213 | Doku `in den Mip-Stufen der Ferne … dunkelsten Bildpunkt` | indirekt | Mip-Bildung (Palettenannahme, siehe Abschnitt 3) | P1-OPUS-06 |
| 54 | packages/burgstadt_spiel/lib/src/spiel.dart:319 | `r.drawSprite(bild, f.x, 0, f.z, warm: w, cold: k);` | ja | Figuren-Sprites: Skalierung über kTexelsPerMeter | P1-OPUS-05 |
| 55 | packages/burgstadt_spiel/lib/src/spuren_geometrie.dart:8-18, 21-70 | `aus(const [...])`: sieben Spurtexturen, je 16 Zeilen zu 16 Zeichen; `IndexedTexture(n, n, px, maxLevels: 1)` | ja | Texturgröße 16 (außerhalb texturen.dart); keine Mip-Stufen | P1-OPUS-05 |
| 56 | packages/burgstadt_spiel/lib/src/spuren_geometrie.dart:90, 96-97 | `const uMax = 16.0;`; `uv = [(0.0, 0.0), (uMax, 0.0), (uMax, uMax), (0.0, uMax)]` | ja | UV textur-lokal (16 = ganze Textur, nicht Meter) | P1-OPUS-05 |
| 57 | packages/burgstadt_spiel/lib/src/spuren_geometrie.dart:103 | `m.wall(x0, z0, x1, z1, s.hoehe - breit / 2, s.hoehe + breit / 2, tex, …)` | indirekt (über mesh.wall) | UV-Umrechnung Wand-Spuren | P1-OPUS-05 |
| 58 | packages/burgstadt_spiel/lib/src/welt_geometrie.dart:90, 92 | `final hv = math.sqrt(hang) * kTexelsPerMeter;`; `len = (x1 - x0) * kTexelsPerMeter` | ja | UV Satteldach | P1-OPUS-05 |
| 59 | packages/burgstadt_spiel/lib/src/welt_geometrie.dart:104-106 | Giebel-Dreieck: `(first - h) * kTexelsPerMeter`, `(z1 - z0) * kTexelsPerMeter / 2` | ja | UV Giebel | P1-OPUS-05 |
| 60 | packages/burgstadt_spiel/lib/src/welt_geometrie.dart:116, 128-130 | Giebel andere Achse: `len`, `(first - h) * kTexelsPerMeter`, `(x1 - x0) * kTexelsPerMeter / 2` | ja | UV Giebel | P1-OPUS-05 |
| 61 | packages/burgstadt_spiel/lib/src/welt_geometrie.dart:213, 220, 222 | `final u0 = (x * 7 + z * 3) % 4 * 16.0;` übergeben als `u0: u0` an `wall()` | ja | UV-Offset in Texeln: 16 = eine Kachel (0,5 m) bei 32 Texel/m | P1-OPUS-05 |
| 62 | packages/burgstadt_spiel/lib/src/welt_geometrie.dart:218-219 | Türblatt: `final tu = (dz != 0 ? … ) * s * kTexelsPerMeter;` | ja | UV Tür | P1-OPUS-05 |
| 63 | packages/burgstadt_spiel/lib/src/welt_geometrie.dart:269-271 | Spitzhelm: `(top - l.hoehe) * kTexelsPerMeter`, `(x1 - x0) * kTexelsPerMeter / 2` | ja | UV Turm | P1-OPUS-05 |
| 64 | packages/burgstadt_spiel/lib/src/welt_geometrie.dart:159-160, 164, 173, 311 | `boden.floor(…, step: schritt)`; Decke `floor(…, up: false)`; Raureif `floor(…, step: 1)`; Laube `m.floor(…, step: 2)` | indirekt (UV über mesh.floor, absolut, siehe Zeile 3) | UV-Umrechnung Boden | P1-OPUS-05 |

## 2. Verworfene Treffer (kein Dichtebezug), je Datei

- **packages/pixel_engine/lib/src/raster/mesh.dart**: Z. 72-74 (`floor()`-Schrittweite `step = 2` in Metern; Doku „kleine Dreiecke halten Mip stabil“) ist Meterwert ohne Texelbezug. Z. 11 (Doku-Einheit Texel) steht in Nr. 1.
- **packages/pixel_engine/lib/src/raster/renderer.dart**: Z. 19 (Fußpunkt in Texeln, Sprite-Eigenwert); Z. 45 `(v & 7) < (best & 7)` (Palettenannahme 8 Stufen je Rampe, nicht Dichte; in Abschnitt 3 erklärt); Z. 158-159 (Himmelsfarben-Stufe „level“); Z. 269-270 (`out[o + 3] = m.uv[…]`, UV-Kopie ohne Umrechnung); Z. 479 (`cam.near * 2`, `cam.far`).
- **packages/pixel_engine/lib/src/raster/texture.dart**: Z. 19 (`assert` Zweierpotenz); Z. 52-53 (`IndexedTexture.solid(…, size = 8)`, nur Testhelfer); Z. 5-6 Doku (Mip-Bildung per Mehrheitsfarbe, dichte-unabhängig).
- **packages/pixel_engine/lib/src/raster/camera.dart**: Z. 13 `far = 48` (Meter).
- **packages/pixel_engine/lib/src/figur/baker.dart**: Z. 42 (Stilisierungsfaktoren), 47 (Licht), 203 und 231-235 (Schattierungs- und Konturstufen, Palette), 245 (Augenposition in Metern; Nr. 22 rechnet als Pixel um).
- **packages/pixel_engine/lib/src/figur/portraet.dart**: Z. 130 `k.groesse / 1.75` (Meter, dichte-frei; dient als Referenz wie baker.dart:63).
- **packages/pixel_engine/lib/src/figur/sprite_pruef.dart**: Z. 26 `c >= 64` und Z. 28 `(c & 7) > 4` (Palette).
- **packages/pixel_engine/lib/src/figur/bewohner_karten.dart**: Z. 449-471 (`_formMaske`, 32 Zeilen auf Sprite-Höhe normiert, `(gx - 16 + 0.5) * h / 32`), Z. 612 (32 Maskenwörter), Z. 484 (`List.filled(24)`, Histogramm), Z. 558 (Ähnlichkeitsschwellen 0.84, 0.80, 0.62, Farbabstand 46). Normiert, daher dichte-frei.
- **packages/pixel_engine/bin/bewohnerkarten.dart**: Z. 15 (`_varianten = 32`, `_farbVarianten = 64`, `_rollenVarianten = 24`, Anzahl Varianten).
- **packages/pixel_engine/lib/src/palette.dart**: Z. 1, 43 (64 Farben, Palette); **lighting.dart**: Z. 13 `colors = 64` (Palette); **pruef.dart**: Z. 74 (FNV-Hash, 32 Bit); **png.dart**: Z. 55 und **pixel_buffer.dart**: Z. 69 und **bin/pixel_pruef.dart**: Z. 28 (Bitoperationen mit 24 und 32); **ui/pixel_ui.dart**: Z. 197 (`+ 24`, UI); **font/**, **bin/schriftprobe.dart**: Z. 9-10 (Zeichenzahl 48/95); **figur/figur.dart**: Z. 69-89 (`groesse = 1.75` Meter), Z. 140-155 (Posenwinkel 24, 80), Z. 176-179 (Halbachsen in m); **figur/teile_basis.dart**: Z. 45 (Maße in m).
- **packages/pixel_engine/lib/src/demo/benchmark.dart**: nur Renderer-Aufrufe, kein Größenbezug.
- **packages/pixel_engine/test/pixel_test.dart**: Z. 10-20, 39 (Palette `< 64`); Z. 74, 94, 103, 112 (Testpuffer `PixelBuffer(64, 36)`); Z. 86-88, 91-104 (Wandflächen im Testpuffer, Pixelzählung ohne Dichtebezug); Z. 131 (PNG-Signatur 137, 80).
- **packages/pixel_engine/test/karten_test.dart**: Z. 155-156 (`groesse` 1.50 bis 1.95, `breite`); Z. 45, 115 (Aufrufe).
- **packages/pixel_engine/test/teile_koepfe_test.dart**: Z. 61-63 (Zählung der Teile); **teile_kleidung_test.dart**: Z. 60 (`>= 26`).
- **packages/pixel_engine/test/texturen_test.dart**: Z. 45-46 (`c < 64` über alle Mip-Stufen, Palette; siehe Abschnitt 3), Z. 51-53 (Kachelbarkeit, Anteil), Z. 56-58 (höchstens 5 Farben).
- **packages/pixel_engine/test/portraet_test.dart**: Z. 10-27 (Hilfsfunktionen), Z. 82-92 (Rampe 5, Indizes 40 bis 47, Palette), Z. 125-138 (Determinismus, Fehlerfall).
- **packages/burgstadt_spiel/lib/src/spuren_geometrie.dart**: Z. 81-86 (Spurgrößen in m: 0,32; 0,3; 0,2; 0,6; 0,14; 0,7 × 0,35), Z. 91-93 (Bodenabziehbild, Höhe in m), Z. 113 `i >= 64` (Palette, `blickFilter`).
- **packages/burgstadt_spiel/lib/src/welt_geometrie.dart**: Z. 142-144 (Blockgröße 16 m, Schritt 1 bzw. 2, Meter); Z. 179 und 240 (`~/ 32`, Blockschlüssel aus Kachelindex, kein Texelbezug); Z. 58-75 (Fenstermaße in m).
- **packages/burgstadt_spiel/lib/src/spiel.dart**: Z. 79 (Textur-Liste aus `baueAlleTexturen()` und `baueSpurTexturen()`, ohne Größenbezug); Z. 267 (Layout-Kommentar „48 + Rand“, UI); Z. 296 und 300 (`groundFog` 0 innen, 0,25 außen; Nebel, keine Mip-Wirkung).
- **packages/burgstadt_spiel/lib/src/skalierung.dart**: Z. 29 `k <= 32` (ganzzahliger Welt-Pixel-Faktor `kWelt`, Bildschirmskalierung). Hinweis: `kWelt` ist nicht die Texeldichte (Namensverwechslung möglich).
- **packages/burgstadt_spiel/lib/src/komposition.dart**: Z. 7-19 (`kWelt`, `kUi`, Bildschirmskalierung).
- **packages/burgstadt_spiel/lib/src/fledermaeuse.dart**: Z. 18 (`kMaxSprites = 12`), Z. 161-162 (24 Winkel), Z. 228 `footX: 4, footY: 2` (Sprite-Eigenwert).
- **packages/burgstadt_spiel/lib/src/figuren_lager.dart**: Z. 134 `List.filled(64, 0)` (Zeit-Eimer, keine Pixel).
- **packages/burgstadt_spiel/lib/src/kompass.dart**: Z. 24 (24 Segmente).
- **packages/burgstadt_spiel/lib/src/bildschirme/** (hauptmenue, erkundung, lagerunde, anklage, optionen_bildschirm, wlan, stadtkarte): nur UI-Pixelmaße (`- 32`, `- 24`, `80`, `56`, `48`), Stadtkarten-Position (stadtkarte.dart:220 `80.0`, `112.0`).
- **packages/burgstadt_spiel/test/fledermaeuse_test.dart**: Z. 48, 62-63 (Fußpunkt 4 und 2, Sprite-Eigenwert), Z. 93 `..z = 77` (Kameraposition).
- **packages/burgstadt_spiel/test/spiel_test.dart**: Z. 9-23 (Skalierung `kWelt`, Höhen 180 und 181).
- **packages/burgstadt_spiel/test/stadtkarte_test.dart**: Z. 142 `c < 64` (Palette).
- **packages/burgstadt_spiel/bin/stadtfotos.dart**: Z. 21, 24 (Kamerapositionen 80, 110); **bin/leistung.dart**: Z. 84, 142 (64 ms Eimer).
- **packages/burgstadt_core/lib/src/welt/bereich.dart**: Z. 8 `kKachel = 0.5` (Meter). Bezug: welt_geometrie.dart:213 (16 Texel = 1 Kachel bei 32 Texel/m, siehe Nr. 61).
- **packages/burgstadt_core/lib/src/welt/oberstadt.dart**: Z. 17, 33-41 (`b = 64, t = 52` Rasterbreite in Kacheln, `_Haus(…)`-Koordinaten).
- **packages/burgstadt_core/lib/src/welt/stadtgenerator.dart**: Z. 91-92, 155, 232-236, 429-432 (Meter und Kacheln).
- **packages/burgstadt_core/lib/src/zufall.dart**: Z. 1 (32-Bit-Zufall, xorshift).
- **packages/burgstadt_core/lib/src/kanon/kanon.dart**: Z. 196 (`80` Zeichen, Fehlertext); **fall/**, **test/** (u. a. `stadtdaten_test.dart:15` `'Untere Stadt': 32`, `fall_daten_test.dart:13` und `stadthinweise_test.dart:22-151` mit 24 Hinweisen, `kanon_test.dart:303-334` mit 48 und 1276): Zählwerte ohne Pixelbezug.
- **tool/ton/** (klangwerk.dart: Z. 384, 432, 434, 439; geraeusche.dart: Z. 58, 151, 197, 219; musik.dart: MIDI-Noten, Tempo 80 BPM; umgebung.dart: Z. 93 „dichtes Blubbern“, Z. 141; test/ton_test.dart: Z. 38 WAV-Header): Audio, kein Pixelbezug.
- **tool/abnahme.dart**: nur Z. 77 (Treffer Nr. 50).

## 3. Mip-Auswahl heute

**Formel Dreiecke** (Textur-Stufe pro Pixel, `packages/pixel_engine/lib/src/raster/renderer.dart`):

- Z. 384: `// Mip-Schwellen nach Tiefe: Texel pro Bildpixel = Dichte * z / focal`
- Z. 385: `final m1 = focal / kTexelsPerMeter * 2, m2 = m1 * 2, m3 = m2 * 2;`
- Z. 429: `var lv = z < m1 ? 0 : (z < m2 ? 1 : (z < m3 ? 2 : 3));`
- Z. 430: `if (lv >= nLv) lv = nLv - 1;`

Berechnung: Texel je Bildpixel = Dichte · z / focal. Stufe 1 ab 2, Stufe 2 ab 4, Stufe 3 ab 8 Texel je Bildpixel (m1 = 2 · focal / Dichte).

**Formel Sprites** (`renderer.dart`):

- Z. 483: `final scale = cam.focal * iz / kTexelsPerMeter; // Bildpixel pro Texel`
- Z. 491-493: `if (scale < 1) { lv = (math.log(1 / scale) / math.ln2).floor(); if (lv >= s._mips.length) lv = s._mips.length - 1; }`

Berechnung: lv = floor(log2(Texel je Bildpixel)) mit denselben Schwellen 2, 4, 8. Dreiecke und Sprites nutzen damit dieselbe Schwelle. Die Dichte steckt in beiden Formeln: Mit einer gemeinsamen Konstante folgen Sprites (Figuren) und Welt derselben Mip-Schwelle. Die Trennung in kDichteWelt und kDichteFigur muss deshalb festlegen: Dreiecke mit kDichteWelt (renderer.dart:385), Sprites mit kDichteFigur (renderer.dart:483).

**Anzahl Mip-Stufen (Cap):**

- Textur (`packages/pixel_engine/lib/src/raster/texture.dart:18`): `{int maxLevels = 5}`. Gebaut werden bis zu 5 Stufen. Bei 32er Texturen 32, 16, 8, 4, 2; bei 64er Texturen 64 bis 4.
- Renderer (`renderer.dart:429`): wählt nur Stufen 0 bis 3, also 4 Stufen. Stufe 4 wird nie gewählt (Befund: Stufe 4 wird gebaut, aber nie benutzt).
- Sprite (`renderer.dart:32`): `while (out.length < 4 && w >= 4 && h >= 4)`, also höchstens 4 Stufen. Bei 48 × 80: 48 × 80, 24 × 40, 12 × 20, 6 × 10.
- Spur-Texturen (`packages/burgstadt_spiel/lib/src/spuren_geometrie.dart:18`): `maxLevels: 1`, keine Mip-Stufen.

**Mip-Bildung:** Mehrheitsfarbe aus 2 × 2 Texeln (`texture.dart:44-49`), dadurch keine neuen Farben. Für Sprites bevorzugt die Bildung Sichtbares und die dunkelste Stufe (`renderer.dart:39-45`); `(v & 7)` setzt 8 Stufen je Rampe voraus (Palettenannahme, Zielpaket P1-OPUS-06).

**Boden anders als Wände?** Zur Mip-Auswahl: nein. `renderer.dart:429` gilt für jedes Dreieck gleich. Das Feld `m.flags` wird nur für Rückseiten-Culling genutzt (`renderer.dart:328`). Zur UV-Erzeugung: ja.

- Wand: relativ mit Offset `u0`/`v0` (`mesh.dart:64-66`). Die Versätze in `welt_geometrie.dart:213` sind 16-Texel-Schritte.
- Boden: absolute Weltkoordinate × Dichte (`mesh.dart:82-85`). Kachelschritt 2 m als Default (`mesh.dart:74`), Boxen 4 m (`mesh.dart:102-103`), Welt-Böden 1 bis 2 m (`welt_geometrie.dart:144`).
- Boden-Spuren: textur-lokal mit `uMax = 16` (`spuren_geometrie.dart:90, 96`), nicht in Metern.
- Nebel: `groundFog` (`renderer.dart:96, 443-445`), gesetzt in `spiel.dart:296` (innen 0) und `300` (außen 0,25). Nebel, keine Mip-Wirkung.

## 4. Texturgrößen heute

Quelle: `packages/pixel_engine/lib/src/kit/texturen.dart`. Index = `TexturId.index` (enum Z. 12-49). Die Zuordnung Index zu Funktion steht in `_bauer` (Z. 59-96). Die Größe steht im `_Tex(N)`-Aufruf der Funktion.

| Idx | Textur-Name | Größe | Quelle (Funktion, `_Tex`-Zeile) |
|---|---|---|---|
| 0 | pflaster | 32 | `_pflaster`, Z. 285 |
| 1 | pflasterGross | 64 | `_pflasterGross`, Z. 307 |
| 2 | putzOcker | 32 | `_putz`, Z. 267 (Aufruf Z. 62) |
| 3 | putzAltrosa | 32 | `_putz`, Z. 267 (Aufruf Z. 63) |
| 4 | putzTaubenblau | 32 | `_putz`, Z. 267 (Aufruf Z. 64) |
| 5 | putzCreme | 32 | `_putz`, Z. 267 (Aufruf Z. 65) |
| 6 | putzKalkweiss | 32 | `_putz`, Z. 267 (Aufruf Z. 66) |
| 7 | putzSandstein | 32 | `_putz`, Z. 267 (Aufruf Z. 67) |
| 8 | sockelBruchstein | 32 | `_sockelBruchstein`, Z. 323 |
| 9 | dachBiberschwanz | 32 | `_dach`, Z. 350 (Aufruf Z. 342) |
| 10 | dachBiberschwanzMoos | 32 | `_dach`, Z. 350 (Aufruf Z. 344) |
| 11 | bruchsteinMauer | 64 | `_bruchsteinMauer`, Z. 397 |
| 12 | quaderMauer | 64 | `_quaderMauer`, Z. 428 |
| 13 | burgBruchstein | 64 | `_burgBruchstein`, Z. 447 |
| 14 | gewoelbeDecke | 64 | `_gewoelbeDecke`, Z. 469 |
| 15 | holzBohlen | 32 | `_holzBohlen`, Z. 491 |
| 16 | holzDielen | 32 | `_holzDielen`, Z. 497 |
| 17 | eichenTuer | 32 | `_eichenTuer`, Z. 516 |
| 18 | eichenTuerEisen | 32 | `_eichenTuerEisen`, Z. 525 |
| 19 | fensterLaden | 32 | `_fensterLaden`, Z. 535 |
| 20 | fensterDunkel | 32 | `_fensterDunkel`, Z. 549 |
| 21 | fensterKerze | 32 | `_fensterKerze`, Z. 573 |
| 22 | fachwerkPutz | 64 | `_fachwerkPutz`, Z. 590 |
| 23 | ziegelKamin | 32 | `_ziegelKamin`, Z. 619 |
| 24 | kiesWeg | 32 | `_kiesWeg`, Z. 633 |
| 25 | wiese | 32 | `_wiese`, Z. 646 |
| 26 | erde | 32 | `_erde`, Z. 664 |
| 27 | schieferPlatten | 32 | `_schieferPlatten`, Z. 680 |
| 28 | stufenStein | 32 | `_stufenStein`, Z. 699 |
| 29 | teppichRot | 32 | `_teppichRot`, Z. 718 |
| 30 | kachelOfen | 32 | `_kachelOfen`, Z. 744 |
| 31 | regalBuecher | 32 | `_regalBuecher`, Z. 767 |
| 32 | tapeteStreifen | 32 | `_tapeteStreifen`, Z. 788 |
| 33 | holzVertaefelung | 32 | `_holzVertaefelung`, Z. 805 |
| 34 | putzInnenWarm | 32 | `_putz`, Z. 267 (Aufruf Z. 94) |
| 35 | eisenGitter | 32 | `_eisenGitter`, Z. 814 |

Zusammenfassung: 30 Texturen mit 32 Texel, 6 mit 64 Texel (Idx 1, 11, 12, 13, 14, 22). Alle Texturen sind quadratisch; `_Tex`-Aufrufe: 30 Zeilen (inkl. Klassendefinition Z. 116).

Weitere Texturen außerhalb `texturen.dart`:

- Demo (`packages/pixel_engine/lib/src/demo/demo_scene.dart`): `_cobble` 32 (Z. 119), `_plaster` 32 (Z. 139), `_roof` 16 (Z. 151), `_wood` 16 (Z. 164), `_stoneWall` 32 (Z. 175), `_window` 16 (Z. 190).
- Spur (`packages/burgstadt_spiel/lib/src/spuren_geometrie.dart`): 7 Texturen (fussspur, wachs, faser, staub, fingerabdruck, schleifspur, verwischt), je 16 × 16 (Z. 21-70), `maxLevels: 1`.

Befund: Die Welttexturen sind heute genau so groß, dass eine Kachel bei 32 Texel/m 1 m (32er) oder 2 m (64er) entspricht. Bei 64 Texel/m müssten die 32er-Texturen 64 und die 64er 128 Texel haben, sonst erscheint die Textur halb so groß (doppelt so oft gekachelt). Die Spur-Texturen (16 × 16) würden zusätzlich verdoppelt werden müssen.

## 5. Zählung je Zielpaket, offene Fragen, Selbstprüfung

**Zählung je Zielpaket** (Abschnitt 1, 64 Zeilen; Dichte-Spalte: 55 mal „ja“, 9 mal „indirekt“, 0 mal „nein“):

| Zielpaket | Anzahl | Zeilen (Nr.) |
|---|---|---|
| P1-OPUS-05 (Dichte-Konstanten, Baker, UV, Mip-Cap, Texturen texelverdoppelt) | 30 | 1, 2, 3, 4, 5, 8, 10, 13, 30, 31, 32, 33, 34, 35, 36, 37, 39, 51, 52, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64 |
| P1-OPUS-06 (Mip v2: Schwellen, Stufenwahl, Sprite-Mip) | 6 | 6, 7, 9, 11, 12, 53 |
| P1-OPUS-11 / P6-OPUS-01 (Baker zwei Dichten) | 11 | 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 49 |
| P6-OPUS-03 (Porträt 128) | 8 | 26, 27, 28, 29, 40, 41, 42, 48 |
| P6-AUTOR-07 (Figur-Tests) | 6 | 24, 25, 43, 44, 45, 50 |
| P6-AUTOR-08 (Figur-Tests) | 2 | 46, 47 |
| P1-AUTOR-01 (texturen_test) | 1 | 38 |
| keins | 0 | – |
| **Summe** | **64** | |

**Offene Fragen**

1. Porträt-Dichte: `portraet.dart:124, 139` setzt die Porträt-Pixeldichte aus der Kopfhöhe in Pixeln (`_kopfHoehePx = 0.6 * 64`). Es gibt keine Konstante für sie. Offen: Soll sie an `kDichteFigur` gekoppelt werden oder eigene Dichte bleiben? (P6-OPUS-03)
2. Figur-Maße bei 64 Texel/m: Berechnung. 1,75 m × 64 = 112 px, die Sprite-Höhe ist heute 80 (`baker.dart:35`). Die neuen Maße (Breite, Höhe, Fußpunkt) sind im Code nicht festgelegt. (P1-OPUS-11 / P6-OPUS-01)
3. Fledermäuse (`fledermaeuse.dart:110`) und Demo-Szene (`demo_scene.dart`): Welche Dichte gilt? Der Auftrag nennt keine Zuordnung. Die Demo-Szene ist in keinem Zielpaket genannt; ob sie mitgezogen oder eingefroren wird, ist offen.
4. Mip-Stufe 4 (`renderer.dart:429` deckt nur 0 bis 3, Textur baut bis 5 Stufen): Soll der Cap angehoben werden? Offen. (P1-OPUS-06)
5. Wand-Versatz `u0` in `welt_geometrie.dart:213` ist in Texeln (16 = 1 Kachel bei 32 Texel/m). Bei 64 Texel/m wären 32 Texel nötig. Offen: Texel-Schritt oder Meter-Schritt speichern? (P1-OPUS-05)
6. Spur-Boden (`spuren_geometrie.dart:90, 96`) mit `uMax = 16` ist textur-lokal, Wand-Spuren (`:103`) laufen über `kTexelsPerMeter`. Offen: Spuren bei 64 Texel/m doppelt grob, oder texelverdoppeln (32)? (P1-OPUS-05)
7. Innenlinien-Schwelle `baker.dart:225` (0,07 m) bleibt in Metern. Ihre Pixelwirkung verdoppelt sich bei 64 Texel/m. Offen, ob sie zu skalieren ist. (P1-OPUS-11 / P6-OPUS-01)
8. Pixelschwellen in Tests und Prüfung (`sprite_pruef.dart:37` mit 200 px, `karten_test.dart:186` mit 40 px, `teile_koepfe_test.dart:121` und `teile_kleidung_test.dart:119` mit 4 px, `portraet_test.dart:102, 118` mit 12 und 150 px): Die Flächenwirkung wächst mit der Dichte zum Quadrat. Offen: Skalierungsregel für die Schwellen. (P6-AUTOR-07 / P6-AUTOR-08)
9. `tool/abnahme.dart:77` behauptet „gleiche Pixeldichte: karten_test“. Im Test steht kein Dichtebezug (Suche nach „dichte“ in den Tests ohne Treffer). Der Test prüft die Figuren nur indirekt über `pruefeFigur`. Die Abnahme-Zeile ist damit ungedeckt. (P6-AUTOR-07)
10. Palette-Abhängigkeiten, keine Dichte, aber betroffen: `renderer.dart:45` (`& 7`, 8 Stufen), `sprite_pruef.dart:26, 28`, `portraet_test.dart:53`, `texturen_test.dart:46` (alle Mip-Stufen `< 64`), `pixel_test.dart:10-39`, `spuren_geometrie.dart:113`, `stadtkarte_test.dart:142`, `palette.dart:1, 43`, `lighting.dart:13`, `texturen.dart:9` (Doku „Indizes 0–63“). Die Palettenerweiterung (10 × 16) betrifft diese Stellen. Im Auftrag von HZ-03 ist kein Zielpaket dafür genannt. Offen, wer sie übernimmt.
11. Porträt-Mip: `SpriteImage` cap 4 Stufen (`renderer.dart:32`). Bei 128 Porträt-Texeln wären Stufen zu prüfen. Offen. (P6-OPUS-03)
12. `tool/hd_commit.sh` und `hd/` sind untracked im Repo (`git status`). Nicht Teil dieses Audits; nur vermerkt.

**Selbstprüfung** (Trefferzahl je Pflicht-Muster über alle 136 Dateien, `rg`, Zeilen; „Nr.“ = Nummer in Abschnitt 1):

| Muster | Zeilen-Treffer | Verteilung und Befund |
|---|---|---|
| `kTexelsPerMeter\|texelsPerMeter\|TexelsPerMeter` | 38 | welt_geometrie.dart 13 (Nr. 58, 59, 60, 62, 63); mesh.dart 10 (Nr. 1, 2, 3); demo_scene.dart 7 (Nr. 30); baker.dart 5 (Nr. 14, 20, 22); renderer.dart 3 (Nr. 4, 6, 10). Alles in Tabelle. |
| `(?i)dichte` | 7 | mesh.dart 3 (Nr. 1); renderer.dart 2 (Nr. 4, 6); tool/abnahme.dart 1 (Nr. 50); tool/ton/umgebung.dart 1 (verworfen: „dichtes Blubbern“). |
| `\b32\b` | 96 | texturen.dart 63 (Nr. 33 bis 37); portraet.dart 4 (Nr. 27 bis 29); demo_scene.dart 3 (Nr. 31); texturen_test.dart 2 (Nr. 38); portraet_test.dart 1 (Nr. 40); mesh.dart 1 (Nr. 1); baker.dart 1 (Nr. 15). Verworfen: bewohner_karten.dart 7, welt_geometrie.dart 2 (Kachelblöcke), spuren_geometrie.dart 1 (Meterwert 0,32), tool/ton 5, übrige 6 Einzeltreffer (Skalierung, Zufall, UI, Stadtdaten, Bewohnerkarten-Bin, pruef.dart). |
| `48\s*[x×*,]\s*80` | 0 | kein Treffer; das Sprite-Maß steht als `breite = 48, hoehe = 80` (Nr. 16). |
| `\b48\b` | 16 | baker.dart 1 (Nr. 16); texturen.dart 2 (Nr. 37: Z. 413, 460). Verworfen: 13 (tool/ton 4, schriftprobe 2, kanon_test 2, oberstadt 2, camera.dart 1, spiel.dart 1, erkundung.dart 1). |
| `\b80\b` | 25 | baker.dart 1 (Nr. 16); teile_koepfe_probe.dart 1 (Nr. 49). Verworfen: 23 (tool/ton 10, UI, Kamerapositionen, Palette, PNG-Signatur, kanon.dart, stadtgenerator.dart). |
| `\b24\b` | 50 | texturen.dart 6 (Nr. 36, 37: Z. 299, 334, 462, 577, 692, 711); baker.dart 1 (Nr. 16). Verworfen: 43 (u. a. baker.dart:42 `kopfStil = 1.24`, Stadtgenerator, Tests, UI, Audio). |
| `\b77\b` | 7 | baker.dart 1 (Nr. 16). Verworfen: 6 (tool/ton 5, fledermaeuse_test.dart:93 Kameraposition). |
| `\b64\b` | 62 | texturen.dart 18 (Nr. 35, 37); portraet.dart 3 (Nr. 26); portraet_test.dart 4 (Nr. 40, 41); texturen_test.dart 3 (Nr. 38; Z. 46 in Abschnitt 3). Verworfen: 34 (tool/ton 14, pixel_test.dart 9 Testpuffer 64×36, Palette 2, leistung.dart 2, Einzeltreffer 7). |
| `64\s*[x×*,]\s*64` | 3 | portraet.dart:1 (Nr. 26); portraet_test.dart:43 (Nr. 40); texturen_test.dart:37 (Nr. 38). Alles in Tabelle. |
| `(?i)mip` | 12 | renderer.dart 7 (Nr. 5, 6, 11); texture.dart 2 (Doku, Abschnitt 3); fledermaeuse.dart 2 (Nr. 53); mesh.dart 1 (Doku Z. 72, verworfen). |
| `\blevel\b` | 2 | renderer.dart:158-159 (Himmelsstufe), verworfen. |
| `\blv\b` | 14 | renderer.dart 12 (Nr. 7, 8, 9, 11, 12); texturen_test.dart 2 (Z. 45-46, Abschnitt 3). |
| `log2` | 0 | kein Treffer; die Sprite-Stufe nutzt `math.log(...) / math.ln2` (Nr. 11). |
| `mipCap` | 0 | kein Treffer; der Cap heißt `maxLevels` (texture.dart:18) bzw. `< 4` (renderer.dart:32). |
| `u =`, `v =`, `uv`, `* 32`, `/ 32` (Muster aus dem Auftrag) | 42 | dichte-relevant in Tabelle: Nr. 2, 3, 56 (spuren_geometrie.dart:96-97). Übrige: Variablen (`u`, `v`, `uv`), Schleifenzähler, Bit-Operationen, Blockschlüssel (welt_geometrie.dart:179, 240), Silhouette (bewohner_karten.dart:462, 464), UV-Kopie (renderer.dart:269-270). |
| `_Tex(` | 30 | alle in Abschnitt 4 bzw. Tabelle (Nr. 33 bis 35); texturen.dart:116 ist die Klassendefinition. |
| `SpriteImage` | 38 | Typ- und Konstruktoraufrufe. Größenbezug in Tabelle: Nr. 5, 16 bis 19, 26 bis 29, 39, 51, 52. Übrige ohne Dichtebezug. |

Hinweis zur Vollständigkeit: Bei den Mustern mit vielen Treffern (`\b32\b`, `\b64\b`, `\b24\b`) sind die Texel-Literale in `texturen.dart` in Gruppen erfasst (Nr. 36, 37). Jeder Treffer wurde mit Kontext gelesen (Dateien und Zeilen in Abschnitt 1 und 2). Alle `tool/ton`-Treffer sind Audio.

ENDE PAKET P0-KUND-02

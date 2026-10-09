## Gemeinsame Regeln für HD-Texturen (P1/P2)
Lies dazu `/home/user/werwolf_digital_flutter/hd/STILBLATT.md` (§2, §3, §4, §5) vollständig.

**Technik**
- Datei: NEU `packages/pixel_engine/lib/src/kit/texturen/<name_snake_case>_<variante>.dart` (Dateiname IMMER lower_snake_case, z. B. `putz_ocker_b.dart`; Funktions- und Kandidatenname camelCase) mit genau einer öffentlichen Funktion `IndexedTexture <name>V2<Variante>()` (z. B. `pflasterV2A()`), nur Imports `../../palette.dart`, `../../raster/texture.dart`, `../werkzeug.dart`.
- Werkzeugkasten (`packages/pixel_engine/lib/src/kit/werkzeug.dart`): `Tex(n)` (Fläche mit Umbruch: `p`, `g`, `fill`, `rect`, `hline`, `vline`, `build()`), `Lcg(seed)` (`next`, `below`), `steine(...)`, `stein(...)`, `planken(...)`, `putz(...)`. Lies die Datei und nutze sie. Zufall NUR über `Lcg` mit festem Seed.
- Farben NUR über `Ramp.at16(rampe, stufe)` (Stufe 0 … 15, 0 = dunkelste) – keine Zahlenliterale. Rampen: `Ramp.neutral, stone, wood, red, amber, green, blue, skin, altrosa, tuerkis`.
- Dichte: 64 Texel pro Meter. 64×64 = 1 m, 128×128 = 2 m. Die Textur kachelt in beide Richtungen nahtlos (Umbruch in `Tex` hilft).
- Eintragen als Kandidat: in `packages/pixel_engine/lib/src/kit/texturen/kandidaten.dart` EINE Import-Zeile und EINE Map-Zeile `'<name>_<variante>': TexturEintrag(<name>V2<Variante>, dichte: 64),` (andere Agenten tragen dort parallel ein: lies die Datei direkt vor dem Bearbeiten neu und ändere nur deine Zeilen).

**Stil (prüft `pruefeHdTextur` automatisch, siehe `kit/textur_pruefung.dart`)**
- Höchstens 8 Stufen je Rampe, höchstens 3 Rampen, höchstens 14 Indizes. Streupixel ≤ 8 %. Kachelbar.
- Licht von oben links: Oberkanten und linke Kanten der Formen (Steine, Bretter, Ziegel) 1–2 Stufen heller, Unter- und rechte Kanten 1–2 Stufen dunkler; die Prüfung misst das (≥ 2 Luma Unterschied).
- Fugen 1–2 Stufen dunkler als der Körper, nie die dunkelste Stufe der Rampe (Stufe 0/1). Fugen mindestens 2 Texel breit, Formen mindestens 6 Texel groß (Mip-1-Lesbarkeit).
- Kein Rauschen: Abwechslung über ganze Formen (ein Stein eine Stufe heller/dunkler), nicht über Einzelpixel. Einzelne Akzentpixel (Risse, Kanten) nur als zusammenhängende Linien ≥ 3 Pixel.
- Grünregel: Grün (Rampe 5) nur in `wiese`, `dachBiberschwanzMoos`, `bruchsteinMauer`.

**Prüfung (Pflicht)**
- `cd /home/user/werwolf_digital_flutter/packages/pixel_engine && /opt/flutter/bin/dart analyze --fatal-infos && /opt/flutter/bin/dart test test/texturen_test.dart` grün (dein Kandidat wird dort mit `pruefeHdTextur` geprüft).
- Kontaktbogen: `cd /home/user/werwolf_digital_flutter/packages/burgstadt_spiel && /opt/flutter/bin/dart run bin/kontaktbogen.dart kandidaten /home/user/werwolf_digital_flutter/hd/bilder/proben/<PAKET>.png <name>_<variante>` → Zeile „KANDIDAT … Stilblatt OK“. Sieh das Bild mit Read an (Bestand links, dein Kandidat rechts; Mip 0 oben, Mip 1 unten) und beurteile ehrlich: Ist Mip 1 noch lesbar? Sieht es handgezeichnet und ruhig aus, nicht verrauscht? Bessere nach, bis es gut aussieht (höchstens 3 Runden).

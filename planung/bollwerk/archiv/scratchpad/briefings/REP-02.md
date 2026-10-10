Du bist Autor im Projekt „Burgstadt HD“. Paket **REP-02 · Banding-Messung v2** (HZ-02). Reparaturpaket zu P0-AUTOR-03 nach Gegenprüfung P0-GEGEN-01.

Lies zuerst /home/user/werwolf_digital_flutter/hd/rollen/KOPF.md, /home/user/werwolf_digital_flutter/hd/rollen/AUTOR.md und /home/user/werwolf_digital_flutter/hd/gegen/P0-GEGEN-01.md (Befunde B-01…B-05).

## Problem
`packages/burgstadt_spiel/bin/banding.dart` misst an einer einzigen texturierten Wand (Flecken im Lichtkegel, B-01), in einer einzigen Zeile (B-02), in Index-Stufen statt Helligkeit (B-03), mit n = 1 (B-05). Seit Palette v2 (siehe `packages/pixel_engine/lib/src/palette.dart`: 10 Rampen × 16 Stufen, `stufeVon`, `Ramp.at16`) zählt ein Sprung zwischen zwei Farben der alten Palette 2 Stufen.

## Neue Messdefinition (genau so umsetzen)
Banding = wie fein das **Licht** auf einer glatten Fläche abgestuft ist – getrennt von der Textur.
- **Prüfwand statt Spielwand:** baue selbst eine Szene: eine ebene Wand 6 m breit × 3 m hoch, Kamera 2,0 m davor auf 1,62 m Höhe, senkrecht blickend (eigenes `Mesh` über `MeshBuilder.wall`, Vertex-Licht warm 0 / kalt 0,05 an allen Ecken), Textur `IndexedTexture.solid(<Farbe>)`. Gerendert mit einem eigenen `Renderer(PixelBuffer(B, H), LightTable.night(), [textur])`, Nebel wie innen (`fogStart 3`, `fogEnd 20`, `groundFog 0`), Handylicht `flashStrength = 0.9` (Spielwert, erkundung.dart).
- **Drei Grundfarben:** `Ramp.at(Ramp.stone, 4)`, `Ramp.at(Ramp.amber, 4)` (Putz Ocker), `Ramp.at(Ramp.wood, 4)`.
- **Profil:** je Bildspalte von der Bildmitte bis zum rechten Rand der **Modus** (häufigster Index) über 16 Zeilen um die Bildmitte (Dither wird so herausgemittelt) und das **Luma-Mittel** über dieselben 16 Zeilen.
- Kennzahlen je Farbe: **Stufen** = Zahl verschiedener Modus-Indizes im Profil; **größter Sprung** = größte Differenz `stufeVon` (16er-Stufen) zwischen benachbarten Modus-Indizes derselben Rampe; **Luma-Sprung** = größte Differenz benachbarter Luma-Mittel; **Sprünge > 1** = Anzahl benachbarter Modus-Paare mit `stufeVon`-Differenz > 1.
- Ausgabe je Farbe `BANDING <farbe> · Stufen <n> · größter Sprung <s> Stufen · Luma-Sprung <l> · Sprünge>1 <n>` und am Ende `BANDING v2 · Stufen (min) <n> · größter Sprung (max) <s> · Welt BxH`.
- Optionen: `--welt BxH` (Standard 320×180), `--csv <ordner>` (je Farbe `x;modus;stufe;luma`), `--png <ordner>` (je Farbe das Prüfbild).
- Zusätzlich bleibt die bisherige Spielwand-Messung als `--spielwand` erhalten (unverändert in der Wirkung, aber mit `stufeVon` aus pixel_engine).
- Deterministisch, kein `dart:math Random`.

## Dateien
- Ändere NUR `packages/burgstadt_spiel/bin/banding.dart` (bis 400 Zeilen). Gemeinsame Hilfen darfst du in `packages/burgstadt_spiel/bin/mess/hilfen.dart` legen – ACHTUNG: Diese Datei legt parallel auch das Paket REP-01 an. Lege deshalb deine Hilfen in eine EIGENE neue Datei `packages/burgstadt_spiel/bin/mess/banding_hilfen.dart`, nicht in hilfen.dart. `lib/` nicht ändern.

## Pflichtläufe (Ausgaben wörtlich in die Rückgabe)
- `cd /home/user/werwolf_digital_flutter/packages/burgstadt_spiel && /opt/flutter/bin/dart analyze --fatal-infos` grün (Infos aus fremden Dateien nur nennen)
- `dart run bin/banding.dart` und `dart run bin/banding.dart --welt 640x360` und `dart run bin/banding.dart --spielwand`
- zweiter Lauf Standard: gleiche Zahlen
- `--png /tmp/claude-0/-home-user-werwolf-digital-flutter/f7a52164-ab37-599f-81d4-460776fcac08/scratchpad/rep02` und die drei Prüfbilder mit Read ansehen (ein Satz je Bild).

## Rückgabe
Rückgabeformular laut AUTOR.md, letzte Zeile `ENDE PAKET REP-02`.

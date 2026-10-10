## Gemeinsame Regeln für alle Oberflächen-Pakete (P7)
- Die Oberfläche hat in allen Qualitätsstufen dasselbe UI-Raster (bei „scharf“ wie bei „mittel“). „HD“ heißt hier: sorgfältigere Pixelgestaltung mit der Palette v2 (16 Stufen je Rampe, `Ramp.at16(rampe, stufe)`, siehe `packages/pixel_engine/lib/src/palette.dart`), nicht mehr Pixel.
- **Texte bleiben wortgleich** (keine Änderung an Beschriftungen, keine Dateien unter `packages/burgstadt_spiel/data/texte`).
- **Trefferflächen und Positionen bleiben gleich** (gleiche `Rechteck`-Werte für Knöpfe/Panels, gleiche Tastatur-/Gamepad-Navigation), damit Spieltest und Bedienung unverändert funktionieren.
- Licht kommt von oben links: helle Kante oben/links, dunkle Kante unten/rechts. Keine Verläufe über mehr als 3 Stufen, kein Rauschen, keine Fremdfarben (nur Palettenindizes).
- Belege: Vorher-Bild VOR deiner Änderung und Nachher-Bild danach mit `dart run bin/bildschirmfoto.dart <ordner> 1280 720` (und `1080 2400`) aus `packages/burgstadt_spiel`, Bilder nach `/home/user/werwolf_digital_flutter/hd/bilder/proben/<PAKET>_vorher_*.png` und `..._nachher_*.png` (nur die relevanten Bildschirme). Mit Read ansehen und vergleichen.
- Pflicht: `dart analyze --fatal-infos` im Paket grün (Befunde fremder Dateien nur nennen), `dart test` in `packages/burgstadt_spiel` UND `packages/pixel_engine` grün.

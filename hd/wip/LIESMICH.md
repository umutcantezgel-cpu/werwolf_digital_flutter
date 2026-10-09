# Burgstadt HD – unfertige Arbeit (pausiert zugunsten FEINKORN, 2026-10-09)

Diese Patches sind NICHT abgenommen und NICHT angewendet. Wiedereinstieg: `git apply hd/wip/<datei>.patch` auf dem Stand von `claude/pensive-gates-ajtp7x`.

## P1-OPUS-07.patch – Leistung Raster (Stand: Experiment, ändert Bilder)
Datei: packages/pixel_engine/lib/src/raster/renderer.dart (Basis 9575962).
- Spannen zu 32 Pixeln: Tiefe, u, v exakt an den Spannenenden, dazwischen linear; u/v als Festkomma 16.16 auf Stufe 0.
- Lichtstufen (warm, kalt mit Handylicht, Nebel mit Bodennebel) je Spanne an den Enden berechnet und linear geführt; Mip-Stufe je Spanne, wenn beide Enden gleich.
- `Renderer.drawMeshes`: Sortierung vorn → hinten nach Mittelpunkt-Tiefe, dann Verdeckungsprüfung je Mesh gegen ein grobes Tiefenraster (8 × 8-Blöcke, fernste Tiefe, nur geänderte Blöcke neu berechnet); `FrameStats.meshesOccluded`.
- Float64List-Scratch statt List<double>, keine Closures je Dreieck.
Messung (Thread-CPU, 640 × 360, Marktplatz + Oberstadt, nur Meshes): Ausgang 22,2 ms → 16,9 ms. Aufschlüsselung vorher: Aufbau 3,6 · Tiefentest/Schleife 7,4 · Texturzugriff 5,7 · Licht 5,5 ms.
Befunde: Marktplatz Tiefenkomplexität 3,3, davon 52 von 76 Meshes ganz verdeckt; Zeilen im Mittel 18 Pixel; die innere Schleife hat ≈ 40 lebende Werte (Registerdruck, Stack-Spills im JIT).
Offen: spiel.dart/szenen_mess auf drawMeshes umstellen, Himmel nur in leeren Tiefen, Bildvergleich gegen hd_migbeleg (scratchpad mig_957 = Stand 9575962), Szenenmessung, Abnahme.

## P4-AUTOR-01.patch – Form bett (Haiku-Entwurf, ungeprüft)
Datei: packages/burgstadt_spiel/lib/src/bau/formen/bett.dart. Ohne Test und Probe; im Register steht der Platzhalter (Quader).

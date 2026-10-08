# NACHTPROTOKOLL (stündlich ergänzt, Europe/Berlin)
- 23:10 Start. Branch `nachtlauf/burgstadt` von main (fb0ec24) angelegt, Kanon-Branch gemergt (dffb04b).
- 23:25 Ausgangstests: Core 22/22, Server-Smoke 63/0, validate 4× OK, simulate alle Szenarien bis Ende, analyze sauber, kanon.py pruefe 0 Befunde.
- 23:42 Phase 1: `packages/pixel_engine` steht (Palette 64 Farben mit K8-Kern, Licht-Colormaps, Software-Rasterer mit Z-Puffer, Near-Clipping, Mips, Handylicht, Nebel, Himmel mit Mond und Bergen, Billboard-Sprites, PNG, Prüfwerkzeuge Paletten-/Blocktest). 8 Pixeltests grün. Go/No-Go: Go (dart2js 320×180 bei 4× Drosselung 18,7 ms).

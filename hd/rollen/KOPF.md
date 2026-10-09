# Paketkopf (wortgleich in jedem Haiku-Paket)

**Das Projekt in fünf Sätzen**
1. Burgstadt Schartenfels ist ein nächtlicher Ich-Perspektive-Krimi in 2,5D-Pixelgrafik, gerendert von einem eigenen Dart-Software-Rasterer mit Palettenpuffer.
2. Das Projekt „Burgstadt HD“ verdoppelt die Pixelauflösung (Stufe „scharf“ mit doppelter linearer Auflösung, auf 720p/1080p 360 Zeilen, dazu 64 Texel pro Meter) und erweitert die Palette auf 10 Rampen × 16 Stufen, ohne den Pixelstil aufzugeben.
3. Gebäude und Räume bekommen echte Modellierung – Laibungen, Simse, Läden, Gauben, Schornsteine, Lauben, eigene Möbelformen und Wandausstattung – und gestaltete Pixeltexturen statt Rauschen.
4. Figuren, Porträts, Licht, Himmel und Oberfläche ziehen auf dieselbe Pixeldichte und Farbtiefe nach, und eine automatische Qualitätswahl hält die Bildrate im Budget.
5. Kartenlayout, Kollision, Kanon, Spielregeln und alle bestehenden Prüfungen bleiben gültig; jede Änderung ist deterministisch, im Code erzeugt und mit Bildbeleg nachgewiesen.

**Feste Regeln für jedes Paket**
- Repository: `/home/user/werwolf_digital_flutter` (Branch `claude/pensive-gates-ajtp7x`). Nichts committen, nichts pushen – das macht der Orchestrator.
- Nur die im Auftrag genannten Dateien anlegen oder ändern. Niemals ändern: `packages/burgstadt_core/data`, `packages/burgstadt_spiel/data/texte`, `packages/pixel_engine/data/figuren`, `nachtlauf/`, `krimidinner/`.
- Kein `dart:math Random`, keine Farben außerhalb der Palette, keine neuen Lichtquellen, kein „usw.“, kein „analog“, kein TODO.
- Jede Behauptung mit Beleg `Datei:Zeile`. Nichts erfinden: Was du nicht gefunden hast, schreibst du unter „OFFENE FRAGEN“.
- Werkzeuge: `/opt/flutter/bin/dart` (falls vorhanden), sonst nur lesen.
- Rückgabe endet mit der Zeile `ENDE PAKET <ID>`.

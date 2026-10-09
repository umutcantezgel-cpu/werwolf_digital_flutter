# PLAN – Aufträge, Wellen, Zeitschätzung

Legende: Stufe 1–3 (3 = Opus selbst) · Rolle (Haiku) · → Abnahme · Zeit = Schätzung Wandzeit.
Kürzungsleiter, falls die Zeit knapp wird (nie still ein Kriterium absenken): 1. Musik-Varianten 2. Stadtbewohner-Tagesläufe vereinfachen (Routen statt Zeitplan) 3. Innenraum-Vielfalt (Vorlagen wiederverwenden, Mindestzahl bleibt) 4. Animations-Bildzahl (Mindestumfang bleibt).

## Phase 0 – Bestand und Plan (Opus, ~1 h) → Z-01, Z-14
- A-001 Branch + Kanon-Merge ✔ · A-002 Ausgangstests + Bestandsfotos ✔ · A-003 Entscheidungslog/ABNAHME/KANON/Overlay ✔ · A-004 PLAN ✔ · A-005 `tool/alle_tests.sh` · A-006 Auftragsvorlage

## Phase 1 – Pixel-Fundament (~3 h) → Z-02, Z-03, Z-09
- A-101 [3] `pixel_engine`: Palette 8×8-Rampen, Colormaps warm/kalt/Nebel, Bayer 4×4, indizierter Puffer, PNG-Export
- A-102 [3] Rasterer: Kamera, Frustum, Clipping, Z-Puffer, texturierte Dreiecke (perspektivisch korrekt), Schnellpfade Wand/Boden, Billboards, Mipmaps, Licht pro Pixel (Handykegel), Nebel
- A-103 [3] Go/No-Go-Benchmark (VM, AOT, dart2js, wasm, Chrome 4× gedrosselt)
- A-104 [3] Bitmap-Pixelschrift (Glyphen inkl. Umlaute/Sonderzeichen) + Pixel-UI (Panel, Knopf, Liste, Textfluss, Hit-Test), 2. Ebene doppelte Auflösung
- A-105 [3] FrameSink (nativ sync, Web-Canvas, async) + Flutter-Ansicht `lib/burgstadt/` + Eingabe (2 Daumenzonen, Tastatur/Maus, Gamepad, Neigen)
- A-106 [3] Figuren-Rig + Baker (8 Richtungen, Animationen, Kontur, Materialrampen) + Format Teile-Raster + Validator
- A-107 [2] Pixel-Audit der Mordakte-Figuren → Figuren-Stilblatt (Sichtprüfer, Haiku)
- A-108 [2] Teile-Bibliotheken Welle 1: Frisuren, Kopfbedeckungen, Zubehör (Pixelkünstler ×2, Haiku)
- A-109 [3] Prüfwerkzeuge Blocktest, Palettentest, Sprite-Prüfung

## Phase 2 – Durchstich (~3 h) → Z-05, Z-06, Z-07 (Teil), Z-08 (Teil)
- A-201 [3] `burgstadt_core`: Kanon-Parser (typisiert) + Overlay + Abgleich mit `kanon.py`
- A-202 [3] Welt-Modell: Höhenraster, Gebäude-/Raum-Volumen, Kollision, Türen/Portale, Navigation
- A-203 [3] Burg-Komplex von Hand (Gewölbe, Speisekammer, Turm mit Kunibert, Hof, Torhaus, Wehrgang) + Marktplatz + 3 Häuser
- A-204 [3] KanonRuntime (maßgeblich, serialisierbar): Phasen, Gespräche G, Hinweise H, Entscheidungen E/D, Punkte, private/geteilte Infos, Fallakte
- A-205 [3] Detektivblick (Sichtschicht + Pixel-Effekt) + 2 Rollen mit exklusiven Hinweisen
- A-206 [2] Bots (Rollen-Bots teilen/verschweigen, Täterin täuscht nach LR) + Phase 1 allein spielbar
- A-207 [2] Testschreiber: Logik-Tests Ebene 1 (Haiku)

## Phase 3 – Burgstadt (~4 h) → Z-04, Z-02
- A-301 [3] Stadtgenerator-Architektur (Seed, Mauer-Oval, Hügel, 6 Viertel, Gassen, Parzellen, Wahrzeichen-Slots), fortsetzbare Jobs
- A-302 [2] Gebäudemodule (Weltenbauer ×2): Giebelhaus, Dachgauben, Laubengang, Zunftturm, Uhrturm, Kirchenburg, Rathaus, Brunnen
- A-303 [2] Innenraum-Vorlagen + Einrichtung (Weltenbauer ×2): Bäckerei, Teestube, Werkstatt, Wohnstube, Apotheke, Museum, Bibliothek, Pension, Schmiede …
- A-304 [3] Keller- und Gangnetz, Wehrgang, Laden beim Betreten, Licht/Nebel/Mond/Fledermäuse
- A-305 [2] Stadtbewohner: 40 Figurenkarten + Tagesläufe (Autor + Pixelkünstler)
- A-306 [2] Hausgeschichten (Autor) · A-307 [2] Erkundungsbots + Welt-Tests (Testschreiber)

## Phase 4 – Fall und Rollen (~4 h) → Z-05, Z-07, Z-12
- A-401 [3] Hinweis-Verortung aller 257 H in Burg/Stadt + Regelsprache für Bedingungen/Folgen
- A-402 [3] Alle 20 Rollen: Fähigkeiten + exklusive Sichtschichten (Ableitung aus Beruf, Liste im Entscheidungslog)
- A-403 [3] Detektivblick: ≥7 Spurenarten; Gegenspiel der Täterin (verwischen, falsche Fährte, als „verwischt“ erkennbar)
- A-404 [3] Löser Ebene 2 (4…20) + Durchspiel Ebene 3 + Teilen-Nutzen Ebene 4
- A-405 [2] Gespräche/Entscheidungen in der Stadt (Autor prüft Texte gegen Kanon) · A-406 [2] Leitplanken-Scanner (Testschreiber)

## Phase 5 – Teilen und Mehrspieler (~3 h) → Z-06, Z-08
- A-501 [3] `room_host` modusneutral + eingebetteter LAN-Host (dart:io) + Beitritt per Code/QR
- A-502 [3] Lobby, Rollenvergabe 4–20, Bots bis N, Interessenfilter, Deltas, Vorhersage
- A-503 [3] Teilen an Einzelne/Fallakte mit Fäden, Schlussfolgerungen freischalten
- A-504 [2] Mehrspieler-Simulation 4/8/20 (Testschreiber)

## Phase 6 – Präsentation (~3 h) → Z-03, Z-10, Z-11, Z-14
- A-601 [2] Figuren final: 20 Rollen + Burgwart + ≥40 Bewohner, Porträts 4 Ausdrücke (Pixelkünstler ×3, Animator ×1)
- A-602 [3] Erzähler (Steckbriefe, Phasenansagen, Uhrturm), Tutorial, Optionen (UI-Skala, Flackern aus, Sichtfeld, Kopfwippen, Neigen)
- A-603 [2] Ton: prozedurale WAVs (Wind, Schritte je Untergrund, Türen, Treppen, Uhrturm, Hunde, Fledermäuse) + eigene Musik
- A-604 [3] Karte, Kompass, Schnellreise, Speichern/Fortsetzen
- A-605 [2] Sichtprüfer-Wellen: Figuren-Aufstellung (2 unabhängige), Menüs, Viertel

## Phase 7 – Härtung (~3 h+) → alle
- A-701 Testmarathon (alle Ebenen) · A-702 Gegenprüfer (Leitplanken, Kanon, Plagiat) · A-703 Spieltester (Geräteprofile) · A-704 Balancing · A-705 Abschlussbericht, Start-/Steuerungsanleitung, FÜR DEN NUTZER · A-706 `tool/abnahme.dart` grün

Morgenbericht: 07:00 Europe/Berlin (`nachtlauf/MORGENBERICHT.md`).

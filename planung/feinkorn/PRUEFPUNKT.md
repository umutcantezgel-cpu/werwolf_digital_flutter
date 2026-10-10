# FEINKORN · PRÜFPUNKT (zuerst lesen)

**FEINKORN ist beendet und archiviert (E-F021).** Der Nutzer hat am 2026-10-09 entschieden: Der heutige Look der App bleibt, FEINKORN-Technik wird nur noch als „Leben“-Schicht (Physik, Teilchen, Skelett, Klang, Messwerkzeuge) weiterverwendet. Nachfolger: Master-Prompt „Look-alike-Finalisierung“ (rundenbasierte Entscheidungen + Würfelglück), erzeugt über einen Meta-Prompt.

## Was hier liegt und weiterverwendbar ist
- `packages/pixel_engine/lib/feinkorn.dart` – reine Dart-Bibliothek ohne Spielinhalt:
  - `daten/` Material (14), Blockkörper (32³-Abschnitte), Format FKB1 (verlustfrei, Tafel + Lauflänge), Rezeptformat v1, Muster-Gerüst.
  - `physik/` Physikwelt 120 Hz deterministisch, Starrkörper, Partikel mit Ablagerung, Prüfsumme.
  - `bewegung/` Skelett (FK), Figurenaufbau mit Gelenkweg „rück“.
  - `darstellung/` Iso-Backen mit Schattenkarte, Wolke für Teilchen.
  - `werkzeuge/` Testraum, Lückenprüfung.
- Tests: `packages/pixel_engine/test/feinkorn_*` (37 grün), Trennungsprüfung.
- Messwerkzeuge: `tool/feinkorn/bestand.dart` (Bestandsprüfsumme), `tool/feinkorn/messen.mjs` (Chromium-Messung mit CPU-Drosselung).
- Messbasis: `planung/feinkorn/MESSBASIS.md`, `messbasis/`.
- Entscheidungen E-F001…E-F021, Plan, Nebelkarte, Rollenbriefings, Auftragsvorlage (Lernnotiz L-01).

## Offen gelassen (nicht fortsetzen ohne neuen Auftrag)
K0-Plan-Schleife, K1 ab K1-OPUS-02, Materialmuster 01–04 (nur Stubs).

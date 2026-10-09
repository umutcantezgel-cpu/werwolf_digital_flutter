# Burgstadt HD – PRÜFPUNKT (Wiedereinstieg)

- **Arbeitsbranch:** `claude/pensive-gates-ajtp7x`
- **Ausgang (eingefroren in P0-PROBE-01):** `c54fe9c` = `origin/nachtlauf/burgstadt` zum Start
- **merge-base für textPfade:** `git merge-base HEAD origin/nachtlauf/burgstadt`
- **Flutter:** `/opt/flutter` (3.47.6, Dart 3.13.5); `git config --global --add safe.directory /opt/flutter` nötig
- **pub get:** in allen 8 Paketen nötig (`packages/*`, Wurzel, `server`, `tool/ton`) – ohne `tool/ton` meldet `flutter analyze` 46 Fehler (Werkzeugcheck T1/S1)
- **Schnelllauf:** `bash tool/alle_tests.sh schnell` ≈ 280 s
- **Letzte abgeschlossene Schicht:** –
- **Laufende Schicht:** T1/S1
- **Offene Pakete dieser Schicht:** P0-OPUS-02, P0-KUND-01..06
- **Wiedereinstieg:** `hd/STATUS.md` lesen, Schichtplan in `hd/PLAN.md` ab der laufenden Schicht fortsetzen; Ergebnisse unter `hd/kundschaft`, `hd/laeufe`, `hd/sicht`, `hd/pruefung`, `hd/analyse`.

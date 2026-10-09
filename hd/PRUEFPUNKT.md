# Burgstadt HD – PRÜFPUNKT (Wiedereinstieg)

- **Arbeitsbranch:** `claude/pensive-gates-ajtp7x`
- **Ausgang (eingefroren in P0-PROBE-01):** `c54fe9c` = `origin/nachtlauf/burgstadt` zum Start
- **merge-base für textPfade:** `git merge-base HEAD origin/nachtlauf/burgstadt`
- **Flutter:** `/opt/flutter` (3.47.6, Dart 3.13.5); `git config --global --add safe.directory /opt/flutter` nötig
- **pub get:** in allen 8 Paketen nötig (`packages/*`, Wurzel, `server`, `tool/ton`) – ohne `tool/ton` meldet `flutter analyze` 46 Fehler (Werkzeugcheck T1/S1)
- **Schnelllauf:** `bash tool/alle_tests.sh schnell` ≈ 280 s
- **Letzte abgeschlossene Schicht:** T2/S2 (siehe STATUS); laufend T2/S3
- **Laufende Schicht:** T1/S1
- **Offene Pakete:** P1-VAR-02, P1-AUTOR-06/07/08 (Haiku, laufen); Opus: P1-OPUS-07, -06, -08, -09, -10, -11, -12; danach Durchstich P1-PROBE-01
- **Arbeitsweise:** Opus-Pakete im Arbeitsbaum /home/user/wt/palette (detached), Übernahme per Patch; Haiku im Hauptbaum; Commit nur über tool/hd_commit.sh (sauberer Baum)
- **Briefings:** Scratch-Ordner briefings/ (TEXTUR-KOPF.md, P7-KOPF.md); Kandidaten über kit/texturen/kandidaten.dart, Wahl per Kontaktbogen-Modus kandidaten
- **Wiedereinstieg:** `hd/STATUS.md` lesen, Schichtplan in `hd/PLAN.md` ab der laufenden Schicht fortsetzen; Ergebnisse unter `hd/kundschaft`, `hd/laeufe`, `hd/sicht`, `hd/pruefung`, `hd/analyse`.

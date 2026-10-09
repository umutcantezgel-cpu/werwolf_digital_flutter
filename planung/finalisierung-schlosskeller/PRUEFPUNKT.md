# PRÜFPUNKT · Wiederaufnahme

STAND · Bauphase F3 von F7 · Abnahme 6 von 17 (F-01..F-05, F-07; F-06/F-08 vorläufig) · Brüche offen 0 · Aufträge 74 von 175 · Agenten aktiv 4 · nächster Schritt: Welle 2b (Finale Can, Bild, Bildprompts) und Nachbesserung F3-AUTOR-70..74 abnehmen, dann F3-KONT/SENS und F3-TEST-01, dann F3-Tor

## Nach einem Neustart oder in einer neuen Sitzung
1. `cd /home/user/werwolf_digital_flutter && git checkout finalisierung-schlosskeller` (lokal; falls fehlend: `git fetch origin finalisierung-schlosskeller` bzw. Sicherungsbranch `claude/universal-prompt-orchestrator-trt8uu`).
2. Diese Datei, STATUS.md und den Kopf von PLAN.md lesen.
3. Werkzeugkette prüfen: `test -x .werkzeug/flutter/bin/flutter || ` Flutter 3.47.6 nach `.werkzeug/flutter` laden (Befehl in BESTAND.md), dann `source .werkzeug/env.sh`.
4. Quellmaterial prüfen: `quellen/schlosskeller-teamchat.txt` (gitignored). Fehlt es, steht der Inhalt im ersten Nutzer-Beitrag der Ursprungssitzung; ohne beides gilt §2-Ausnahme.
5. Am „nächsten Schritt“ oben weitermachen. Aufträge mit Status „läuft“ im PLAN neu ausgeben (Rückgaben liegen in `berichte/`).

## Stand der Arbeit
- Branch `finalisierung-schlosskeller` (Upstream origin/finalisierung-schlosskeller). F0-, F1- und F2-Tor bestanden.
- F3 läuft (PLAN F3-*; Textsammlung: content/party/schlosskeller/texte/SCHLUESSEL.md). Kanon in `content/party/schlosskeller/`, Schemas in `content/party/schema/`, Kern in `packages/mordakte_core/lib/src/party/`.
- Prüfen: `cd packages/mordakte_core && dart run bin/party_pruefen.dart` (Plausibilität), `dart test test/party`, `dart run bin/party_simulate.dart`; Gesamt: `tool/pruefen.sh alles`.
- Karten-Probelauf: `flutter build web --release --no-web-resources-cdn -t lib/game/dev/preview_main.dart -o build/web_party_preview`, dann `cd tool/e2e && node foto.mjs` (Fotos in `tool/e2e/fotos/`, dem Nutzer zeigen).
- Laufende Aufträge: Welle 2b (`f3-welle2-b.js`: F3-AUTOR-46 Finale Can, F3-AUTOR-65 bild.json, F3-BAUMEISTER-02 Bildprompts) und Nachbesserung F3-AUTOR-70..74 (`f3-nach-gespraeche.js`). Bereit: F3-KONT-01..10, F3-SENS-01..05, F3-TEST-01 (Aufträge in `auftraege/`). Worktrees starten auf main (L-03): Code-Aufträge beginnen mit `git checkout --detach <commit>`.
- Ist ein Lauf beim Neustart verloren: Dateien der laufenden Aufträge mit `git status` prüfen; unfertige Aufträge neu ausgeben (Auftragsdatei in `auftraege/`).
- main wird von einem parallelen Strang (Burgstadt/Nachtlauf) beschrieben. Vor jedem Tor: `git fetch origin main`, mergen, prüfen (E-028).
- Nach Kanon-Änderungen neu erzeugen: `python3 tool/quellabgleich.py`, `dart run bin/party_bibel.dart`.
- **Nutzerwunsch:** Jedes erzeugte Bild sofort im Chat zeigen (SendUserFile).

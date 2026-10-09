# PRÜFPUNKT · Wiederaufnahme

STAND · Bauphase F1 von F7 · Abnahme 0 von 17 · Brüche offen 81 · Aufträge 18 von 169 · Agenten aktiv 2 · nächster Schritt: Baumeister-Rückgaben (Story-Bibel, Farbabstand) abnehmen; Besetzung, Quellabgleich, Brüche entscheiden; F1-Prüfaufträge

## Nach einem Neustart oder in einer neuen Sitzung
1. `cd /home/user/werwolf_digital_flutter && git checkout finalisierung-schlosskeller` (lokal; falls fehlend: `git fetch origin finalisierung-schlosskeller` bzw. Sicherungsbranch `claude/universal-prompt-orchestrator-trt8uu`).
2. Diese Datei, STATUS.md und den Kopf von PLAN.md lesen.
3. Werkzeugkette prüfen: `test -x .werkzeug/flutter/bin/flutter || ` Flutter 3.47.6 nach `.werkzeug/flutter` laden (Befehl in BESTAND.md), dann `source .werkzeug/env.sh`.
4. Quellmaterial prüfen: `quellen/schlosskeller-teamchat.txt` (gitignored). Fehlt es, steht der Inhalt im ersten Nutzer-Beitrag der Ursprungssitzung; ohne beides gilt §2-Ausnahme.
5. Am „nächsten Schritt“ oben weitermachen. Aufträge mit Status „läuft“ im PLAN neu ausgeben (Rückgaben liegen in `berichte/`).

## Stand der Arbeit
- Branch `finalisierung-schlosskeller` (Upstream origin/finalisierung-schlosskeller). F0-Tor bestanden.
- F1 läuft: Kanon in `content/party/schlosskeller/`, Schemas in `content/party/schema/`, Kern in `packages/mordakte_core/lib/src/party/`.
- Prüfen: `cd packages/mordakte_core && dart run bin/party_pruefen.dart` (Plausibilität), `dart test test/party`; Gesamt: `tool/pruefen.sh alles`.
- Karten-Probelauf: `flutter build web --release --no-web-resources-cdn -t lib/game/dev/preview_main.dart -o build/web_party_preview`, dann `cd tool/e2e && node foto.mjs` (Fotos in `tool/e2e/fotos/`, dem Nutzer zeigen).
- Laufende Aufträge: F1-BAUMEISTER-01 (Story-Bibel), F1-TEST-03 (Farbabstand) in Worktrees; Rückgabe im Workflow-Ergebnis mit Pfad des Arbeitsbaums.
- **Nutzerwunsch:** Jedes erzeugte Bild sofort im Chat zeigen (SendUserFile).

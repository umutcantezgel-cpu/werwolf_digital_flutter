# PRÜFPUNKT · Wiederaufnahme

STAND · Bauphase F0 von F7 (F1 begonnen) · Abnahme 0 von 17 · Brüche offen 81 · Aufträge 12 von 168 · Agenten aktiv 1 · nächster Schritt: F0-GEGEN-03 auswerten, F0-Tor; parallel F1-Kanon (figuren, zeitleiste, tatmatrix)

## Nach einem Neustart oder in einer neuen Sitzung
1. `cd /home/user/werwolf_digital_flutter && git checkout finalisierung-schlosskeller` (lokal; falls fehlend: `git fetch origin finalisierung-schlosskeller` bzw. Sicherungsbranch `claude/universal-prompt-orchestrator-trt8uu`).
2. Diese Datei, STATUS.md und den Kopf von PLAN.md lesen.
3. Werkzeugkette prüfen: `test -x .werkzeug/flutter/bin/flutter || ` Flutter 3.47.6 nach `.werkzeug/flutter` laden (Befehl in BESTAND.md), dann `source .werkzeug/env.sh`.
4. Quellmaterial prüfen: `quellen/schlosskeller-teamchat.txt` (gitignored). Fehlt es, steht der Inhalt im ersten Nutzer-Beitrag der Ursprungssitzung; ohne beides gilt §2-Ausnahme.
5. Am „nächsten Schritt“ oben weitermachen. Aufträge mit Status „läuft“ im PLAN neu ausgeben (Rückgaben liegen in `berichte/`).

## Stand der Arbeit
- Branch `finalisierung-schlosskeller` ab origin/main `d92a675`, Upstream abgekoppelt (E-010). F0-Commit `918cb38` liegt auf origin.
- Messbasis grün (siehe BESTAND.md). Prüfbefehl: `tool/pruefen.sh schnell|alles|e2e`; vor jedem Push `tool/secret_scan.sh`.
- Plan-Schleife: Runde 1 entschieden (E-013). Runde 2 = Auftrag F0-GEGEN-03 (Workflow); Rückgabe nach `berichte/F0-GEGEN-03.md`, Entscheidungen als E-014ff.
- F1-Entwürfe (noch nicht committet): `content/party/schlosskeller/{raeume,fall,setting,figuren}.json`, `packages/mordakte_core/lib/src/party/{zeit,raumgraph}.dart`, `kanon/schema.dart`.
- **Nutzerwunsch:** Jedes erzeugte Bild sofort im Chat zeigen (SendUserFile).

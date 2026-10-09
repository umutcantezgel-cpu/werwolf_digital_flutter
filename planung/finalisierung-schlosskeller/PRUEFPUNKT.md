# PRÜFPUNKT · Wiederaufnahme

STAND · Bauphase F0 von F7 · Abnahme 0 von 17 · Brüche offen 49 · Aufträge 1 von 158 · Agenten aktiv 4 · nächster Schritt: Kundschafter-Berichte einarbeiten, Plan-Schleife

## Nach einem Neustart oder in einer neuen Sitzung
1. `cd /home/user/werwolf_digital_flutter && git checkout finalisierung-schlosskeller` (lokal; falls fehlend: `git fetch origin finalisierung-schlosskeller` bzw. Sicherungsbranch `claude/universal-prompt-orchestrator-trt8uu`).
2. Diese Datei, STATUS.md und den Kopf von PLAN.md lesen.
3. Werkzeugkette prüfen: `test -x .werkzeug/flutter/bin/flutter || ` Flutter 3.47.6 nach `.werkzeug/flutter` laden (Befehl in BESTAND.md), dann `source .werkzeug/env.sh`.
4. Quellmaterial prüfen: `quellen/schlosskeller-teamchat.txt` (gitignored). Fehlt es, steht der Inhalt im ersten Nutzer-Beitrag der Ursprungssitzung; ohne beides gilt §2-Ausnahme.
5. Am „nächsten Schritt“ oben weitermachen. Aufträge mit Status „läuft“ im PLAN neu ausgeben (Rückgaben liegen in `berichte/`).

## Stand der Arbeit
- Branch `finalisierung-schlosskeller` ab origin/main `d92a675`, Upstream abgekoppelt (E-010).
- Messbasis grün (siehe BESTAND.md).
- Laufende Aufträge: F0-KUNDSCHAFTER-01/02, F0-KONT-01/02.

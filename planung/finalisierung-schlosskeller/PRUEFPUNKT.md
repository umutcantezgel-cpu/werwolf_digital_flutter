# PRÜFPUNKT · Wiederaufnahme

STAND · Bauphase F4 von F7 · Abnahme 9 von 17 · Brüche offen 0 · Aufträge 130 von 175 · Agenten aktiv 1 · nächster Schritt: E2E-Gerüst (F4-BAUMEISTER-07) abnehmen, dann 84 E2E-Läufe, Spiel- und Sichtprüfung, Hub-Kachel nach origin, F4-Tor

## Nach einem Neustart oder in einer neuen Sitzung
1. `cd /home/user/werwolf_digital_flutter && git checkout finalisierung-schlosskeller` (lokal; falls fehlend: `git fetch origin finalisierung-schlosskeller` bzw. Sicherungsbranch `claude/universal-prompt-orchestrator-trt8uu`).
2. Diese Datei, STATUS.md und den Kopf von PLAN.md lesen.
3. Werkzeugkette prüfen: `test -x .werkzeug/flutter/bin/flutter || ` Flutter 3.47.6 nach `.werkzeug/flutter` laden (Befehl in BESTAND.md), dann `source .werkzeug/env.sh`.
4. Quellmaterial prüfen: `quellen/schlosskeller-teamchat.txt` (gitignored). Fehlt es, steht der Inhalt im ersten Nutzer-Beitrag der Ursprungssitzung; ohne beides gilt §2-Ausnahme.
5. Am „nächsten Schritt“ oben weitermachen. Aufträge mit Status „läuft“ im PLAN neu ausgeben (Rückgaben liegen in `berichte/`).

## Stand der Arbeit
- Branch `finalisierung-schlosskeller` (Upstream origin/finalisierung-schlosskeller). Die Tore F0 bis F3 sind bestanden.
- F4 läuft (E-030 bis E-032):
  - Fertig: Karte, Sitzung, Karten-Session, `SzenenErweiterung` im Renderer, alle Bildschirme, Requisiten, Rückblende, Tests (126 Widget-Tests, `karte_test`, `figuren_konsistenz_test`).
  - Offen: E2E-Gerüst `tool/e2e/e2e.mjs` (F4-BAUMEISTER-07, Workflow f4-e2e), 84 Läufe, Spiel- und Sichtprüfer, Hub-Kachel nach `git fetch origin main`, Tor F-12/F-13.
- Entwickler-Einstieg: `build/web` mit `?party=schlosskeller&pfad=…&n=…&skript=best,a,richtig&takt=…&zeitraffer=…&fotos=0|1&fotopause=…` oder `&bis=<phase>&at=x,y&zoom=…`. Probelauf: `cd tool/e2e && node probe.mjs "<parameter>" <ordner>`, Raumfotos: `node raeume.mjs <ordner>`.
- F5 vorgezogen: Druckmodell `packages/mordakte_core/lib/src/party/druck/modell.dart` mit `druck_modell_test`; Entwurf `F5-ENTWURF-DRUCK.md`.
- Orte im Repo:
  - Kanon: `content/party/schlosskeller/`
  - Textsammlung: `texte/`, Schlüssel in `texte/SCHLUESSEL.md`
  - Schemas: `content/party/schema/`
  - Kern: `packages/mordakte_core/lib/src/party/`
- Prüfen:
  - Plausibilität: `cd packages/mordakte_core && dart run bin/party_pruefen.dart`
  - Party-Tests: `dart test test/party`
  - Simulator: `dart run bin/party_simulate.dart`
  - Texte: `dart run bin/party_texte.dart`
  - Bildprompts: `dart run bin/party_prompts.dart --pruefen`
  - Gesamt: `tool/pruefen.sh alles`
- Karten-Probelauf:
  - Bauen: `flutter build web --release --no-web-resources-cdn -t lib/game/dev/preview_main.dart -o build/web_party_preview`
  - Fotos: `cd tool/e2e && node foto.mjs`; sie landen in `tool/e2e/fotos/` und gehen an den Nutzer.
- Worktrees starten auf main (L-03). Code-Aufträge beginnen deshalb mit `git checkout --detach <commit>`.
- Ging ein Lauf beim Neustart verloren: die Dateien der laufenden Aufträge mit `git status` prüfen und unfertige Aufträge neu ausgeben (Auftragsdatei in `auftraege/`).
- main beschreibt ein paralleler Strang (Burgstadt/Nachtlauf). Vor jedem Tor: `git fetch origin main`, mergen, prüfen (E-028).
- Nach Kanon-Änderungen neu erzeugen: `python3 tool/quellabgleich.py`, `dart run bin/party_bibel.dart`.
- **Nutzerwunsch:** Jedes erzeugte Bild sofort im Chat zeigen (SendUserFile).

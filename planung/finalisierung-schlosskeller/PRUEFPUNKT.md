# PRÜFPUNKT · Wiederaufnahme

STAND · Bauphase F4 von F7 · Abnahme 9 von 17 (F-01..F-08, F-15; F-10/F-11 vorläufig) · Brüche offen 0 · Aufträge 115 von 175 · Agenten aktiv 0 · nächster Schritt: F4-ORCH-01 (Karte aus dem Kanon, Sitzung, Karten-Session) nach F4-ENTWURF-PARTYSITZUNG.md

## Nach einem Neustart oder in einer neuen Sitzung
1. `cd /home/user/werwolf_digital_flutter && git checkout finalisierung-schlosskeller` (lokal; falls fehlend: `git fetch origin finalisierung-schlosskeller` bzw. Sicherungsbranch `claude/universal-prompt-orchestrator-trt8uu`).
2. Diese Datei, STATUS.md und den Kopf von PLAN.md lesen.
3. Werkzeugkette prüfen: `test -x .werkzeug/flutter/bin/flutter || ` Flutter 3.47.6 nach `.werkzeug/flutter` laden (Befehl in BESTAND.md), dann `source .werkzeug/env.sh`.
4. Quellmaterial prüfen: `quellen/schlosskeller-teamchat.txt` (gitignored). Fehlt es, steht der Inhalt im ersten Nutzer-Beitrag der Ursprungssitzung; ohne beides gilt §2-Ausnahme.
5. Am „nächsten Schritt“ oben weitermachen. Aufträge mit Status „läuft“ im PLAN neu ausgeben (Rückgaben liegen in `berichte/`).

## Stand der Arbeit
- Branch `finalisierung-schlosskeller` (Upstream origin/finalisierung-schlosskeller). Die Tore F0 bis F3 sind bestanden.
- F4 beginnt nach `F4-ENTWURF-PARTYSITZUNG.md`:
  - Zuerst baut ORCH `karte.dart` (Kern) samt Test, `lib/party/sitzung.dart`, `lib/party/karte_session.dart`, die optionalen Renderer-Schnittstellen, die Route `/party` und den Entwickler-Einstieg.
  - Danach folgen die Haiku-Baumeister für die Bildschirme.
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

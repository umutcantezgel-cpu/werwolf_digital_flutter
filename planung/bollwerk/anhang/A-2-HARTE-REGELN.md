# A-2 · Harte Regeln (sie werden nie abgewogen)

Quelle: Anhang A4 des Meta-Laufs, mit der Vorrangtabelle V-1…V-24 angewandt. Wo der Master-Prompt etwas enger fasst, gilt der Master-Prompt.

### A4.1 Git und Push
- **Verboten** sind Force-Push, umgeschriebene Geschichte auf geteilten Branches, gelöschte Remote-Branches und überschriebene Tags. Das schließt ein: `--force`, `--force-with-lease`, `+ref`, `--all`, `--mirror`, `--tags`, `--follow-tags`, `--delete` bzw. `:ref`, gelöschte oder verschobene Tags.
- **Push-Ziel (abschließend):** Der Nachtlauf pusht ausschließlich mit `git push origin HEAD:refs/heads/bollwerk`. Alle anderen Refs (main, `archiv/*`, `bollwerk-leitstand`, `bollwerk-plan`, `bollwerk-mc`) gehören anderen; Tags gibt es nicht (der Git-Proxy lehnt sie ab).
- Nie ein Push auf `finalisierung-schlosskeller`, `kern-feinkorn`, `claude/*`, `nachtlauf/*` oder `loop/*`.
- **Abgelehnter Push:** „Lehnt origin einen Push ab, weil jemand anderes gepusht hat: holen, zusammenführen, alles neu testen, erneut pushen. Höchstens drei Anläufe.“ Für `bollwerk` heißt „alles neu testen“: das Tor der laufenden Phase (`bollwerk.dart schnell` bzw. `phase`).
- **Schutzregel:** Lehnt origin den Push auf `bollwerk` wegen einer Schutzregel ab, notierst du das in FUER-DEN-NUTZER.md und setzt `ZUSTAND: NACHT-ENDE`. Pull Requests öffnet der Nachtlauf nie.
- **Staging** nur mit `git add -- <pfade>`. Nie `-A`, `.`, `-u`, `-f`, `commit -a`.
- **Commits:** „Jeder Commit baut und testet grün.“ Commits laufen über `tool/bollwerk/commit.sh` (Muster `tool/hd_commit.sh`): Branch-Prüfung, Pfadliste, Schutzpfade, Schnelltor im sauberen Worktree, Secret-Scan, Push mit ausdrücklichem Ziel. `tool/commit_gruen.sh` (`git add -A`, fest auf `nachtlauf/burgstadt`) wird nie benutzt.
- **Fremde Linien** werden nur in `bollwerk` hereingeholt, nie umgekehrt. Den Merge-Commit MC für main baut der Merge-Bau des Leitstands.
- **Arbeitsorte:** nur `$BW` (der Sitzungs-Checkout auf `bollwerk`) und die Worktrees, die dieser Lauf angelegt hat. Nur lesbar sind jeder andere Checkout und jeder andere Worktree.
- **Lokaler `main`** wird nie benutzt. Maßgeblich ist immer `origin/main` nach `git fetch`.

### A4.2 Werkzeuge
- **Haiku-Agenten** benutzen nur Read, Grep, Glob, Write, Edit und Bash. Write und Edit nur in den Dateien ihres Auftrags.
  - Nie, auch nicht zum Ausprobieren: `mcp__claude-code-remote__*`, `mcp__github__*`, Agent, Workflow, SendMessage, TaskStop, Monitor, EnterWorktree, ExitWorktree, Skill, WebFetch, WebSearch, Artifact, `mcp__Claude_Docs__*`, **ToolSearch**.
  - Warum ToolSearch: Die MCP-Werkzeuge sind verzögert geladen und ohne ToolSearch nicht aufrufbar. Im Meta-Lauf riefen 2 von 14 Agenten trotz Verbot lesende MCP-Werkzeuge über ToolSearch auf; nach dem ToolSearch-Verbot 0 von 32.
  - **Werkzeug-Audit:** Nach jeder Rückgabe läuft `bash $BW/tool/bollwerk/werkzeug_audit.sh` (Vorlage `planung/bollwerk/proben/werkzeug_audit.sh`). Ein Verstoß verwirft das Ergebnis dieses Agenten; ein Verstoß mit schreibendem oder steuerndem Werkzeug ist ABBRUCH-Grund.
  - Nie `git`: Pool-Plätze haben kein Git (A4.9).
  - Kein `flutter build`, kein Commit, kein Push.
- **Opus** nutzt:
  - das Agent-Werkzeug für eigene Aufträge (keine Workflows; sie sind in Kindsitzungen nicht freigegeben)
  - **Herzschlag:**
    - **Nachtlauf (V-5):** keine Routine. Weckruf nur mit `send_later`, Name `BOLLWERK-G<n>-<session_id>`. (Die frühere Routinen-Regel gilt nur noch für den Leitstand.)
    - Die ID kommt sofort aus dem Ergebnis in den PRUEFPUNKT.
    - `update_trigger` und `delete_trigger` nur für IDs aus dem PRUEFPUNKT, und nur, wenn `get_trigger` genau diesen Namen zeigt.
    - Nie anhand von `list_triggers` ändern oder löschen. Im Zweifel stehen lassen und in FUER-DEN-NUTZER eintragen.
  - `list_triggers` und `get_trigger` nur lesend
  - SendUserFile für Kontaktbögen
- **Nie** (auch Opus nicht):
  - `push_files`, `create_or_update_file`, `delete_file`, `create_branch`, `merge_pull_request`, `enable_pr_auto_merge`, `update_pull_request_branch`
  - `create_session`, `create_trigger`, `send_message`, `interrupt_session`, `archive_session`, `fire_trigger`, `update_trigger` für fremde Routinen, `watch_url`, `add_repo`, `create_pull_request`
  - fremde Routinen oder Sitzungen ändern, feuern, unterbrechen, archivieren oder löschen. `delete_trigger` löscht auch Sitzungen, die eine Routine gestartet hat.
- Änderungen am Repo laufen nur über `git` im Worktree, mit Secret-Scan.
- Dieser Absatz steht wortgleich in Teil 7 jeder Auftragsvorlage.

### A4.3 Bestandsschutz
- „Diese Einstellungen fasst du nicht an: Build, Signatur, Store-Einträge, Berechtigungen, App-Kennung und Versionsnummer.“ Die Version `0.1.0+1` bleibt.
- „Du lädst nichts in die Stores hoch.“
- „In die App kommen keine neuen Abhängigkeiten.“ Keine neue Zeile unter `dependencies`, `dev_dependencies` oder `dependency_overrides` in `pubspec.yaml`, `packages/*/pubspec.yaml` und `server/pubspec.yaml`. L0 prüft das mit `git diff -U0 $B HEAD -- <diese Dateien>` (B aus L0.2). Golden-Tests laufen im eigenen Paket `tool/bollwerk/look_anker/` (Abschnitt 7).
- Werkzeug-Pakete gibt es nur in `tool/bollwerk/**`, und nur, wenn Paket und Version schon in einer `pubspec.lock` des Repos stehen (dann kein neuer Download). Sonst weglassen und in FUER-DEN-NUTZER eintragen. Jede Übernahme steht mit Begründung im ENTSCHEIDUNGSLOG und in `planung/bollwerk/LIZENZEN.md`.
- „Die App verbindet sich mit nichts Neuem; bestehende Verbindungen bleiben, wie sie sind.“ „Zur Laufzeit lädt das Spiel nichts von fremden Servern.“ Web-Builds immer mit `--no-web-resources-cdn`.
- „Bestehende Funktionen, Daten und Speicherstände bleiben erhalten. Was du ersetzt, bleibt über einen Schalter erreichbar, bis die Abnahme bestanden ist.“
- „Werkzeuge, Prüfstand und Modellschau erscheinen nie in der veröffentlichten App.“
- Netzwerk nur für Git mit dem bestehenden `origin`, zum Installieren der Abhängigkeiten, die das Projekt schon hat, und für das Flutter-SDK 3.47.6 aus der Quelle von `build.sh` (sha256 geprüft, Master-Prompt Abschnitt 13). Keine neuen Remotes, kein Deployment, kein Hochladen zu fremden Diensten.
- „Du arbeitest nur im Repo-Ordner und installierst nichts systemweit“ (außerhalb nur `/home/user/bw`, `/home/user/bw-varianten`, `/home/user/bw-logs`, `/home/user/bw-archiv`, `/home/user/bw-arbeit`): kein `npm -g`, kein `pip install`, kein `pub global`. `build.sh` wird nie lokal ausgeführt.
- Schriften, Bilder und Klänge liegen im Projekt.

### A4.4 Umgehungsverbot und Kriterien
- „Ginge etwas nur gegen die Grenzen oder wird eine Aktion blockiert, lässt du sie weg, notierst sie unter FÜR-DEN-NUTZER und arbeitest am Rest weiter.“
- **Keine Umgehung:** kein `dangerouslyDisableSandbox`. Keine Änderung an `.claude/**`, `settings*.json`, `CLAUDE.md`, Git-Konfiguration oder Hooks. Keine Skills, die Einstellungen schreiben. Kein Ausweichen auf die GitHub-API.
- „Kein Kriterium wird still abgesenkt.“ Kriterien und Schwellen ändert der Nachtlauf nie. Kürzen nur über die Kürzungsleiter (Abschnitt 8), mit Eintrag.
- **Vergleichsstände** entstehen einmal (in BW0) und werden nie neu geschrieben, um ein Tor grün zu machen. Das gilt für `layout_pruefsumme.dart --schreibe`, `hd/belege/layout_ausgang.txt`, `bestand.dart --schreibe`, `--update-goldens` und die Simulator-Sollwerte.
- **Eingefroren ab dem BW0-Commit** (SHA im PRUEFPUNKT) sind `planung/bollwerk/messbasis/**`, `planung/bollwerk/BESTAND-AUSNAHMEN.txt` und die D3-Lösung. `belege/rotproben.tsv` bekommt nur neue Zeilen. L0.2 prüft `git diff <BW0> HEAD -- <diese Pfade>` (bei `rotproben.tsv` nur entfernte Zeilen).
- Eine neue Bestandsausnahme oder eine „gewollte HD-Änderung“ gilt erst nach der Antwort „A<n>: ja“ des Nutzers; bis dahin ist das Kriterium rot.
- Neue Look-Anker nur in einem eigenen Commit, mit Vorher/Nachher-Bogen im Chat und Eintrag im Log.
- Kein Test wird gelöscht, mit `skip` oder Tag ausgeblendet oder mit `|| true` bzw. `|| echo` entschärft.
- `analysis_options.yaml`, `textregeln.json`, Leitplanken und TON-LEITFADEN werden nur strenger.
- „Eine 0 beim Bestandsschutz heißt: Die Änderung wird sofort zurückgenommen.“

### A4.5 Rohchat und Geheimnisse
- „Vor jedem Push läuft ein Secret-Scan (`bash tool/secret_scan.sh`). Schlüssel, Zugangsdaten, .env-Dateien und der Rohchat kommen nie in den Verlauf.“
- Der Rohchat liegt unter `quellen/schlosskeller-teamchat.txt`. `quellen/` bleibt in `.gitignore`.
- Der Scan zeigt nicht an, dass er die Passagenprüfung überspringt. Vor jedem Push zusätzlich: `if [ ! -f quellen/schlosskeller-teamchat.txt ]; then echo "Passagenprüfung übersprungen"; fi`. Bei „übersprungen“: einmal je Sitzung Vermerk im ENTSCHEIDUNGSLOG und in FUER-DEN-NUTZER; gepusht wird, wenn der Scan mit „Secret-Scan: sauber“ endet. Übernommen wird dann nur, was dieser oder ein früherer Lauf selbst geschrieben hat; nichts mit Chat-Kopfzeilen, „teamchat“ oder „quellen/“.

### A4.6 Inhalt
Wortlaut aus `origin/finalisierung-schlosskeller:planung/finalisierung-schlosskeller/TON-LEITFADEN.md` §1–§10 als Anhang. `VERBOTE-LEITPLANKEN.md` (Krimidinner-Fall) wird **nicht** angehängt. Von dort gilt nur: „Erfinde nichts Lösungsrelevantes; fehlt etwas, schreibe OFFENE FRAGE.“

**Verbote**
- Kein Alkohol, keine Drogen, kein Rauchen, auch nicht als Witz, Andeutung oder Redewendung.
- Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser und Säfte.
- Keine Klischees, keine Fachbegriffe, keine Zungenbrecher.
- Keine echten Personen, keine Marken, nichts aus bestehenden Spielen, kein Minecraft-Look.

**Figuren und Gewalt**
- Herr Schneider überlebt in jedem Ende. Der Schlag ist nur als Schatten und Geräusch angedeutet, kein Blut.
- Die Pfeife des Detektivs bleibt eine Silhouette und bläst Seifenblasen.
- Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe.

**Sprache und Erzähler**
- Sätze im Mittel ≤ 14 Wörter, keiner über 25. Die Runde wird mit „ihr“ angesprochen, Einzelne mit „du“, nie gesiezt.
- Zur Laufzeit nur feste, geprüfte Bausteine; das Spiel erzeugt keinen Text.
- „Das Spiel lügt nie mit eigener Stimme.“
- „Eine falsche Entscheidung deckt Wahres auf, das weniger hilft – nie Falsches.“
- Der Erzähler sagt nie, ob ein Hinweis stimmt (TON §2, E-024).

**Bilder, Requisiten, Klänge**
- Die Inhaltsregeln gelten auch hier. Die Negativliste aus TON §9 gilt für jeden Maler.
- Licht nur aus Kanon-Lichtquellen, Farben nur aus der Palette.
- Keine Flaschen, Stielgläser oder Fässer im Schlosskeller: In BW0 bekommen `prop_painter.dart` (`_table`) und `markers.dart` (`_salts`, Z. 238) einen neuen Parameter `ohneFlaschen` (Standard `false`), den die Partysitzung setzt; ersetzt wird durch Teekannen oder Krüge, bei gleichem Zufallsverbrauch. Klassische Fälle und Burgstadt bleiben bytegleich.
- Keine roten Teilchen an Kerzenständer, Opferplatz oder Vorratsraum-Boden.
- Pech-Szenen nach C6.

**Kanon**
- Nur der Schlosskeller-Kanon (`content/party/schlosskeller/`).
- `krimidinner/` und `nachtlauf/kanon` sind ein anderer Fall und werden nie vermischt.
- Sperrliste (Treffer = rot): Merle, Lüddecke, Rojda, Adnan, Kunibert, Burgwart, Speisekammer, Wehrgang, Torhaus, Hofebene, Turm-Fuß, Eisentür, Bienenwachs, benommen, Apfel-Zimt-Punsch, Ayran.
- Die Textregeln der Schicht bekommen die Liste `gewalt`: blut, blutig, blutet, wunde, verletzt, verletzung, schmerz. Der Textprüfer liest jede Datei der Schicht.

### A4.7 Würfel (WÜ-1 … WÜ-6)
- **WÜ-1 Quelle:** Würfe kommen nur aus `Rng` (`packages/mordakte_core/lib/src/util/rng.dart`):
  - Seed `Rng(Rng.hashString('wuerfel:<salz>:<entscheidungsId|abstecherId>:<anlauf>'))`. Das `salz` hängt nicht vom Fall-Code ab: Im WLAN schickt jedes Gerät in der Lobby eine Zufallszahl (`Random.secure()`), der Host mischt sie per FNV und zeigt allen das Ergebnis vor der ersten Entscheidung; in Party und Solo entsteht es beim Einrichten. `salz` steht im Spielstand. Der Mitschnitt enthält vor dem Finale 0-mal den Fall-Code oder einen daraus berechneten Wert.
  - nie eine laufende Wurfnummer, nie `FallCode.rng()`
  - nie `dart:math`, `Zufall`, `Lcg` oder `FeinZufall` in der Spiellogik
  - nur der Host würfelt; ein Tischwurf ist nur Darstellung
- **WÜ-2 Offen:** Chancen in Prozent stehen vor dem Wurf fest. Jeder Wurf ist sichtbar und protokolliert.
- **WÜ-3 Stark, aber lösbar:** Wahl vor Wurf, zwei Zustände (`aufgedeckt` und `gewaehlt`), Stufen, zweiter Anlauf oder Umweg zur selben Kanon-Quelle, Pech-Garantie mit Reserve-Regel, Budget-Ungleichung, Rundenschranke und Kettensperre (C2). Belegt wird das mit einem erschöpfenden Beweis (C8 Nr. 1).
- **WÜ-4 Wertung unantastbar:**
  - Ein Wurf deckt nie Falsches auf.
  - Er ändert nie: Tatmatrix, Pfad, Fakten, gewählte Option, Kanon-Punkte (0–9), Restverdächtige, Bonus-Qualität, Gruppenwahl-Wertung, Ende, Rückblende, Schneiders Überleben.
  - Die Nebenwertung (Seifenblasen-Marken, Glücksbilanz) erscheint getrennt.
- **WÜ-5 Pfadgleichheit:** wie in C3.
- **WÜ-6 Determinismus:** Gleicher Code + gleiche Eingaben + gleiche Würfe ergeben dasselbe Protokoll, 1.000-mal, auf VM und Node (Abschnitt 7 L3).
  - Im Würfel- und Partycode gibt es 0 Treffer für `.hashCode`, `identityHashCode`, `dart:math`, `DateTime.now` und `Stopwatch`.

### A4.8 Dateihoheit
**Nie ändern (vor und nach B-02):**
- `krimidinner/**`, `nachtlauf/**`, `hd/**`
- `tool/hd_*`, `tool/abnahme.dart` (wird nie **ausgeführt**: es überschreibt `nachtlauf/belege/*`), `tool/commit_gruen.sh`, `tool/layout_pruefsumme.dart`
- Schutzwerkzeuge: `tool/secret_scan.sh`, `tool/lib/**`, `tool/quellabgleich.py`, `tool/mass5a.py`, `tool/browser/**` (außer der einen Zeile in `geraete.js`, Abschnitt 4)
- bestehende Dateien in `tool/ton/**` (neue Dateien sind erlaubt; `erzeuge.dart` läuft nur mit ausdrücklichem Ziel unter `assets/runden/`)
- `assets/burgstadt/**`, `assets/fonts/**`
- die 5 textPfade (B5)
- `packages/burgstadt_core/**`, `packages/burgstadt_spiel/**`, `lib/burgstadt/**`
- `content/scenarios/**`
- gemeinsamer Kern von App und Server: `packages/mordakte_core/lib/src/{engine,model,protocol,runtime,scenario,util}/**` (darunter `util/rng.dart`) und `packages/mordakte_core/bin/{validate,simulate}.dart`; im Barrel `mordakte_core.dart` nur neue `export`-Zeilen
- `server/**`, `netlify.toml`, `vercel.json`, `railway.toml`, `build.sh`
- `android/**`, `ios/**`, `web/index.html`, `web/manifest.json`
- `planung/finalisierung-schlosskeller/**`, `planung/feinkorn/**`
- Tag `schlosskeller-1.0`: BOLLWERK setzt oder pusht ihn nie.

**Nur ergänzen, nichts Bestehendes ändern:**
- `packages/pixel_engine/**` (FEINKORN-Übernahme samt Trennungsprüfung)
- `packages/room_host/**` (`RaumSpiel` nur umsetzen)

`tool/alle_tests.sh` und `tool/pruefen.sh` werden nur aufgerufen. Eigene Läufe liegen unter `tool/bollwerk/**`.

**Zufall:** `Zufall` und `Lcg` werden nie geändert und aus neuem Code nie aufgerufen; ihr Zähler gehört zur Layout-Prüfsumme.

**Vor B-02:** zusätzlich die Liste in B5 sowie `lib/game/**`, `lib/session/**` und `pubspec.yaml`/`.lock`. BOLLWERK schreibt dann nur in:
- `planung/bollwerk/**`, `tool/bollwerk/**`
- `content/runden/**`
- `packages/mordakte_core/lib/src/runden/**`, `packages/mordakte_core/test/runden/**`
- `lib/runden/**`

**Nach B-02** gehen an BOLLWERK über:
- `content/party/**`: Die Kanon-1.0-Wahrheit bleibt Byte für Byte; das prüft L0.3.
- `packages/mordakte_core/lib/src/party/**`, `packages/mordakte_core/bin/party_*`, `packages/mordakte_core/test/party/**`
- `lib/party/**`, `tool/e2e/**`, `docs/partykrimi/**`
- die ORCH-Dateien außer `build.sh`
- `lib/game/**`, `lib/session/**`: Eingriffe nur über optionale Haken `session is …` und neue Parameter mit unverändertem Standard.
- Nachzügler-Commits des anderen Laufs holt BOLLWERK herein und ändert sie nie zurück.

**Merge:** Eine Linie per Merge zusammenzuführen ist kein Ändern; dafür gelten Abschnitt 12 und der Burgstadt-Schutz. L0.2 lässt in Nie-Pfaden nur Inhalte zu, die unverändert aus einer zugelassenen Linie stammen; von „nur ergänzen“ sind diese Merge-Commits ausgenommen; ihr `git diff --stat` kommt ins Log, sichtbare Änderungen gehen nach K6.

**Code im Vorlauf:** Code unter `runden/` darf die Party-Teile von `mordakte_core` und `lib/game/**` importieren, ändert sie aber nicht.

### A4.9 Agenten
- Haiku-Agenten haben nur Werkzeuge nach A4.2. Jeder Auftrag nennt absolute Pfade.
- **Pool-Plätze sind Kopien ohne Git:** höchstens 6 Plätze `/home/user/bw/01…06`, jeder in FLUG.md eingetragen. Das Skript liest `$BW` und `$POOL` aus `env.sh` (`BW` aus dem Pfad von env.sh, `POOL` Standard `/home/user/bw`), damit der Meta-Trockenlauf beides umlenken kann.
  - Anlegen und Zurücksetzen nur mit `bash $BW/tool/bollwerk/pool_reset.sh <NN> <sha>`. Das Skript bricht ab, wenn `<NN>` nicht `01`–`06` ist oder der Platz nicht in FLUG.md steht. Es führt aus: `rm -rf /home/user/bw/<NN> && mkdir -p /home/user/bw/<NN> && git -C $BW archive <sha> | tar -x -C /home/user/bw/<NN>`, danach `pub get --offline` in allen 8 Paketen des Repos (Wurzel, 5 Pakete, `server`, `tool/ton`) und in `tool/bollwerk/look_anker`.
  - Daneben liegt je SHA eine schreibgeschützte Basis `/home/user/bw/basis-<sha7>` (gleich angelegt, dann `chmod -R a-w`).
  - Haiku ruft nie `git` auf. Den Patch erzeugt Opus: `diff -ruN -x .dart_tool -x build -x '.flutter-plugins*' /home/user/bw/basis-<sha7> /home/user/bw/<NN> > /home/user/bw-varianten/<welle>/<kennung>.patch`. Vor `git apply --check` in `$BW` prüft Opus, dass der Patch nur die Dateien des Auftrags berührt.
  - Teil 7 jeder Auftragsvorlage enthält wortgleich: „Du führst nie `git` aus und betrittst nie `$BW` oder einen anderen Checkout.“
  - `git reset --hard`, `git clean` und `git checkout -- <pfad>` laufen nur mit `-C <eigener Wegwerf-Worktree>` (Mutanten, Rot-Proben), nie ohne `-C`.
- Text-, Daten- und Urteilsaufträge bekommen keinen Worktree. Workflow-Option `isolation: 'worktree'` wird nicht benutzt.
- **Ergebnis als Datei, Kurzurteil an Opus:**
  - Varianten schreibt der Agent als JSONL nach `/home/user/bw-varianten/<welle>/<kennung>.jsonl`, Code als Patch nach `…/<kennung>.patch`.
  - Die Rückgabe ist eine Zeile plus Endmarke:
    `KURZ · <Kennung> · <gruen|teil|rot> · Varianten <n> · Selbstprüfung <m>/<n> · Datei <pfad> · Frage <ja|nein>`
    `=== ENDE <Kennung> · BEREIT ZUR RÜCKGABE ===`
  - Berichte mit bis zu 1.800 Wörtern gibt es nur bei Aufträgen der Art „Bericht“.
- „Platzhalter wie ‚usw.‘, ‚analog‘ oder ‚weitere folgen‘ sind verboten und führen zur Ablehnung.“
- „Du simulierst niemals Haiku-Ergebnisse und schreibst vergebene Pakete nicht nebenbei selbst.“ Ausnahme: Ein Paket scheitert zweimal (Abschnitt 5).
- „Die vollständige Lösung bekommen nur Pakete, die sie zwingend brauchen.“
- „Unteragenten unterliegen denselben Grenzen; jeder Auftrag nennt sie.“
- **Keine Backticks in Heredocs (L-01), für Opus und Agenten:** Heredocs nur mit `<<'EOF'` (Anführungszeichen); Texte mit Backticks schreibt man mit Write. Im Meta-Lauf hat ein Heredoc ohne Anführungszeichen einen Push ausgeführt (FUER-DEN-NUTZER §1 auf `bollwerk-plan`).
- Mutanten und Rot-Proben laufen nur in Wegwerf-Worktrees und werden nie committet.
- **Erwartete Refs (V-13):** Vorwärtsbewegungen von `bollwerk-leitstand` (nur `planung/bollwerk/leitstand/**`), neue Refs `archiv/*`, `bollwerk-mc`, `bollwerk-plan`, `bollwerk-probe`, `bollwerk-rueckweg`, neue `claude/*`-Branches anderer Sitzungen, Commits des Nachtlaufs Burgstadt (main, `nachtlauf/*`), der Finalisierung (`finalisierung-schlosskeller`), `kern-feinkorn` und `loop/*`. Sie kommen nur ins NACHTPROTOKOLL.
- **Stolperdraht nach jeder Welle:** `git ls-remote origin` mit dem Bild der letzten Welle vergleichen. Rot ist er nur bei:
  - einem gelöschten Ref
  - einem Ref, dessen alter Stand kein Vorfahr des neuen ist
  - `refs/heads/bollwerk` ≠ letzter eigener Push (außer eine höhere LEASE steht darin: dann gilt v4 2.5)
  - einem neuen Ref außer den in V-13 genannten
  - einem fremden Ref, dessen neue Commits `tool/bollwerk`, `content/runden`, `lib/runden`, `packages/mordakte_core/lib/src/runden` oder `planung/bollwerk` ändern, ausgenommen `planung/bollwerk/{leitstand,v4,archiv}/**` und `planung/bollwerk/META-*`
  Bei Rot: keine neue Welle, Ursache ins NACHTPROTOKOLL, FUER-DEN-NUTZER. Alles andere ist erwartet (V-13) und kommt nur ins NACHTPROTOKOLL.
- Entfernt werden nur Worktrees, die dieser Lauf angelegt hat (Liste in FLUG.md). Vorher wird der Diff als Patch gesichert. Nie `git worktree prune` oder `git clean -x` außerhalb eigener Bäume.

### A4.10 Rechenlast
- **Container:** 4 Kerne, etwa 16 GB RAM, keine GPU.
- **Schwerlast-Slot:** `flock /tmp/bw-schwer.lock <befehl>`, höchstens 1 zugleich. Dazu gehören: voller Testlauf, Web-Build, Chromium, Leistung (L8), Mutanten (L9b), die Nachttiefe.
- **Zwei Leichtlast-Plätze:** `flock /tmp/bw-leicht-1.lock` bzw. `-2.lock`. Jeder Agentenlauf von `dart test`, `dart analyze`, `pub get` und `flutter test` belegt einen davon. Getestet wird nur gezielt (`dart test test/<datei>`).
- **Lastgrenze:** Liegt die Last über 6 oder der freie Speicher unter 3 GB, und das 10 Minuten lang, startet kein neuer Code-Auftrag mehr, bis die Last unter 4 liegt.
- **Plattenwache** (`df -BG --output=avail /home/user`):
  - unter 8 GB: keine neuen Worktrees; `build/` und `.dart_tool/flutter_build` im Pool leeren
  - unter 4 GB: nur noch Übernahme und BW8
- **Messen:** Leistung nur in Thread-CPU-Zeit, nie unter Parallellast. Agenten schreiben nie in einen Baum, in dem gemessen oder getestet wird.
- **PATH:** Jeder Bash-Befehl beginnt mit `source $BW/tool/bollwerk/env.sh &&` ($BW = Sitzungs-Checkout auf `bollwerk`). Die Datei setzt `FLUTTER_ROOT=$BW/.werkzeug/flutter`, `PUB_CACHE=$BW/.werkzeug/pub-cache`, `PATH=$BW/.werkzeug/flutter/bin:/opt/node22/bin:$PATH` und `BW`. `/opt/flutter` gibt es auf den Cloud-Maschinen nicht (Meta-Lauf M0).


### Zusatz Erlaubnisprüfung (L0.2)
Jede Datei aus `git diff --name-status $B HEAD` außerhalb der Schreib-Erlaubnis ist rot: vor B-02 nur `planung/bollwerk/**` (ohne MASTER-PROMPT, anhang, STARTPAKET), `tool/bollwerk/**`, `content/runden/**`, `packages/mordakte_core/lib/src/runden/**`, `packages/mordakte_core/test/runden/**`, `lib/runden/**`, `assets/runden/**`, `test/runden/**`, `docs/bollwerk/**` sowie Dateien aus den Vorlauf-Merges von `1145cb9` und (nur nach A-2 Definitionen) `caf1d61`, deren Blob gleich dem der Linie ist; nach B-02 zusätzlich die übergegangenen Pfade aus A4.8 und Merges zugelassener Linien.

### Definitionen
- **Stolperdraht-Umfang:** verglichen werden nur Branch- und Tag-Refs (nie Pull-Refs); erwartete neue Refs siehe V-13 oben. Eine andere neue Ref ist nicht rot; sie kommt ins NACHTPROTOKOLL und nach FUER-DEN-NUTZER.
- **HD-Linie `caf1d61`:** Merge nur, wenn danach L1 grün ist („LAYOUT GLEICH“, `assets/burgstadt` und textPfade unverändert, `hd_migbeleg` bytegleich); sonst nur archivieren, bis „A12: ja“ in STEUERUNG.md steht.
- **FEINKORN-Importregel (BE-01):** `lib/game/**` und `lib/party/**` importieren aus `pixel_engine` nur `package:pixel_engine/feinkorn_leben.dart`. Diese Datei legt der Lauf beim Übernehmen von `1145cb9` an; sie exportiert nur Physik, Starrkörper, Material, Schattenkarte und das Gelenkgerüst (Leben, kein Aufbau). Sperrliste (Startwert, BW0 prüft sie an `1145cb9` und ergänzt sie in `planung/bollwerk/messbasis/sperrnamen.txt`): `baueFigur`, `Gelenkweg`, `Blockkoerper`, `backeWolke`, `IsoAnsicht`. Jeder Treffer im Importgraph von `lib/main.dart` ist rot (L0.5, Z-30, S5).
- **textPfade (B5 T1–T5):** `packages/burgstadt_core/data`, `packages/burgstadt_spiel/data/texte`, `packages/pixel_engine/data/figuren`, `nachtlauf/kanon`, `krimidinner/spuk-im-gewoelbe/10_kanon`.
- **ORCH-Dateien (B5 R4):** `pubspec.yaml`, `packages/mordakte_core/pubspec.yaml`, `packages/mordakte_core/lib/mordakte_core.dart`, `lib/l10n/app_de.arb`, `analysis_options.yaml`, `build.sh`, `lib/app/router.dart`, `lib/main.dart`, `lib/ui/screens/hub_screen.dart`, `.gitignore`.

### Nachtrag M6 (Skeptiker-Runde)
- `--update-goldens` nur im Commit `LOOK-ANKER neu · <Grund>` (Z-17); BW0 schreibt sha256 aller Dateien unter `tool/bollwerk/look_anker/` und `tool/bollwerk/mutanten/` nach `messbasis/` (eingefroren wie die Messbasis); L0 prüft sie.
- `planung/bollwerk/belege/**` schreibt nur das Torwerkzeug; Ausnahmen, nur als neue Dateien: `belege/gremium/**` über `dart run tool/bollwerk/bollwerk.dart gremium-import <welle>` (Auszüge nach A-5 L11) und `belege/pruefrunde/<n>.json` über `dart run tool/bollwerk/bollwerk.dart pruefrunde --schreibe <n>`. Zwischenziele in PLAN.md ändern sich nur nach oben oder per Neuplanung mit ENTSCHEIDUNGSLOG-Eintrag (höchstens zweimal, Abschnitt 8).
- Nach einer Verdichtung liest du Master-Prompt und Anhänge mit `git show P:<pfad>` (P = Übergabe-SHA), nicht aus dem Arbeitsbaum.
- Schreib-Erlaubnis vor B-02 zusätzlich: `packages/mordakte_core/test/web/kanon_eingebettet.g.dart` (Kanon-Generator, A-5 L3).
- Steuerung: ein B-02- oder FREIGABE-Eintrag gilt nur mit „gilt für: Nacht“ oder „alle“. Annahmen-Schlüssel „A12“ und „A-12“ sind gleichwertig. Einträge außerhalb der Weißliste bekommen `QUITTUNG S-<n> · <UTC> · abgelehnt <grund>`; „WEITER BOLLWERK“ hebt einen STOPP auf.

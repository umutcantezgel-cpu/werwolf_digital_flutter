# KERNKARTE · BOLLWERK (Wiedereinstieg, ≤ 1.500 Wörter)

Angelegt von G1 (2026-10-10). Quelle aller Regeln: `planung/bollwerk/MASTER-PROMPT.md` und `anhang/` am Übergabe-SHA P = `2094a67525cd07526c5e80ab1897e53d3fddac02` (nach Verdichtung mit `git show P:<pfad>` lesen).

## Vorrang
Grenzen (A-2) → Modellregel (MP §0) → Kanon → Nutzerentscheidungen (A-1) → Z-Kriterien (MP §6) → Phasen (MP §8) → Stil. Zielkonflikte: Lösbarkeit/Fairness › Look-Treue › Handyleistung › Design = Umfang › Politur.

## Harte Verbote (Kurzfassung)
- Push nur: `test "$(git rev-parse --abbrev-ref HEAD)" = bollwerk && bash tool/secret_scan.sh | tail -1 | grep -q 'Secret-Scan: sauber' && git push origin HEAD:refs/heads/bollwerk` aus `$BW`. Nie Force, Tags, Löschen, andere Branches, PRs.
- Staging nur `git add -- <pfade>`. Heredocs nur `<<'EOF'`.
- MCP: nur lesend, dazu `send_later`, `get_trigger`/`delete_trigger` für eigene Weckruf-IDs. Nie create_trigger/session, send_message, WebFetch/WebSearch, Artifact, Docs, EnterWorktree.
- Kanon 1.0 (`content/party/**`) Byte für Byte; Wachstum nur in `content/runden/schlosskeller/`.
- Vor B-02 Schreibrecht nur: `planung/bollwerk/**` (ohne MASTER-PROMPT, anhang, STARTPAKET), `tool/bollwerk/**`, `content/runden/**`, `packages/mordakte_core/lib/src/runden/**`, `packages/mordakte_core/test/runden/**`, `lib/runden/**`, `assets/runden/**`, `test/runden/**`, `docs/bollwerk/**`, `packages/pixel_engine/lib/feinkorn_leben.dart`, `packages/mordakte_core/test/web/kanon_eingebettet.g.dart`, Blobs aus Merge `1145cb9`.
- Keine neuen Abhängigkeiten; nichts systemweit installieren; Netz nur origin, Paketquellen, Flutter-SDK.
- Inhalt: kein Alkohol/Drogen/Rauchen; Schneider überlebt; kein Blut; Pfeife bläst Seifenblasen.
- Würfel nur über `Rng` mit Seed `wuerfel:<salz>:<id>:<anlauf>`; nie `dart:math`, `Zufall`, `Lcg`, `FeinZufall`, `FallCode.rng()`, `DateTime.now`, `Stopwatch`, `.hashCode`.
- Haiku-Agenten: nur Read, Grep, Glob, Write, Edit, Bash; nie git, nie ToolSearch; Audit nach jeder Rückgabe.

## Schleifen mit Höchstzahl (MP §9)
Nachbesserung 2 · Briefing-Überarbeitung 1 · Gremium-Zusatzrunde 1 · Welle zurück 2/Slot · Tor rot 3 Reparaturen oder 4 h · neues R 2 · Mutant 2 Aufträge · Eichung 1 · abgelehnter Push 3 · Hereinholen 30 min/5 Dateien · Neuplanung 2 · Prüfrunde 4/Generation · verlorener Agent 1 · lange Welle 1 · D2-Probe 4/Generation.

## Drossel und Ereignisbudget
Ausfälle > 10 %: Wellengröße halbieren, +25 % nach 30 ruhigen Minuten. Wellengröße bis B-02 höchstens 6 (S-1). Rückgaben ≤ 40/h. Last > 6 oder < 3 GB frei für 10 min: keine Code-Aufträge. Platte < 8 GB: keine Worktrees.

## Lange Tore (F-2, Lichtung)
Tore `phase`/`nacht`/`ziel` abgekoppelt: `setsid nohup flock /tmp/bw-schwer.lock dart run tool/bollwerk/bollwerk.dart <modus> > /home/user/bw-logs/tor-<modus>-<sha7>.log 2>&1 < /dev/null &`, PID und Log im PRUEFPUNKT. L-9 prüft Lebensdauer > 2 h; sonst Schichtgruppen `--gruppe <k>` < 100 min. Nicht gemergter `bw-tor` bei Generationsende → `planung/bollwerk/tor-rest/G<n>.patch`, Zeile `TOR-REST` im PRUEFPUNKT.

## Pfade der Zustandsdateien (`planung/bollwerk/`)
LAUF.md · KERNKARTE.md · PRUEFPUNKT.md · FLUG.md · STATUS.md · QUITTUNGEN.md · ENTSCHEIDUNGSLOG.md · REGISTER.md · NACHTPROTOKOLL.md · FUER-DEN-NUTZER.md · ANNAHMEN.md · MORGENBERICHT.md · SCHWELLEN-NACHTRAG.tsv (ab BW0) · belege/ · bilder/ · tor-rest/.

## Wiedereinstieg nach Verdichtung
1. LAUF → KERNKARTE → PRUEFPUNKT → FLUG → STATUS lesen.
2. MP §2.5 und §3 über `git show P:planung/bollwerk/MASTER-PROMPT.md` lesen.
3. LEASE prüfen (`git fetch origin bollwerk && git show origin/bollwerk:planung/bollwerk/LAUF.md | grep '^LEASE'`); `boot_id` vergleichen.
4. Je FLUG-Zeile die Ausgabedatei prüfen; Fehlendes nach „Ende erwartet“ + 30 min einmal neu einreihen.
5. Erst dann Neues beginnen.

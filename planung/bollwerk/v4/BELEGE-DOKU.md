# Dokuprüfung C1–C15 gegen die offizielle Claude-Code-Dokumentation

Stand der Prüfung: 2026-10-09. Quelle: alle 221 Seiten aus https://code.claude.com/docs/llms.txt als Markdown geladen und durchsucht, eine Seite zusätzlich per WebFetch gegengelesen. Zitate sind wörtlich (Englisch).
`/root/.ccr/README.md` beschreibt nur den HTTPS-Egress-Proxy (CA-Bundle, 403/405/407, Umschreiben von SSH auf HTTPS bei GitHub-Remotes, Docker). **Zu Push-Regeln des Git-Proxys steht dort nichts.**

Selbst beobachtet in dieser Sitzung (nicht aus der Doku, nur als Beleg): `claude --version` = 2.1.296, `nproc` = 4, etwa 15 GiB RAM. Gesetzt sind außerdem `CLAUDE_CODE_CHILD_SESSION=1`, `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1`, `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST=1`, `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80` und `CLAUDE_CODE_SESSION_ATTENDED=1`.

---

## C1: Cloud-VM (Ubuntu, ~4 Kerne/16 GB/30 GB; Setup-Cache bei ~5 min)
- **Urteil:** BESTÄTIGT
- **URL:** https://code.claude.com/docs/en/cloud-environments#resource-limits , #environment-caching
- **Zitat:** "Cloud sessions in Anthropic-hosted environments run with approximate resource ceilings that may change over time: 4 vCPUs, 16 GB of RAM, 30 GB of disk" (Liste zusammengezogen). "When setup completes within roughly five minutes, Anthropic snapshots the filesystem and reuses that snapshot as the starting point for later sessions."
- **Korrigierte Aussage:** Jede Sitzung bekommt eine frische VM mit Ubuntu 24.04 auf x86_64. Die Grenzen sind ungefähre Obergrenzen, die sich ändern können. Der Setup-Cache ist ein reiner Dateisystem-Snapshot: Laufende Prozesse wie DB oder `docker compose up` sind nicht enthalten. Der Cache wird neu gebaut, wenn sich das Setup-Skript oder die erlaubten Hosts ändern, und spätestens nach etwa 7 Tagen. Beim Wiederherstellen nach Leerlauf läuft das Setup-Skript nicht erneut.

## C2: Settings in Cloud-Sitzungen
- **Urteil:** BESTÄTIGT (mit Präzisierungen)
- **URL:** https://code.claude.com/docs/en/settings#settings-in-cloud-sessions , settings#when-edits-take-effect , permission-modes (Tab „Web and mobile“), settings-reference (`defaultMode`)
- **Zitat:** "**User and project local settings** (`~/.claude/settings.json` and `.claude/settings.local.json`): not read." Dazu: "`/config`: in your browser at claude.ai/code, opens the Claude Code section of your claude.ai settings instead of changing a value."
- **Weitere Zitate:**
  - "Claude Code watches your settings files and reloads them when they change, so it applies most edits to the running session without a restart, including edits to `permissions`, `hooks`, and credential helpers such as `apiKeyHelper`."
  - "`auto` and `bypassPermissions` don't take effect from project or local settings"
  - Für Cloud-Sitzungen: "Accept edits, Plan, and Auto. … Bypass permissions isn't available."
- **Korrigierte Aussage:**
  - **Welche Datei gilt:** Eine Cloud-Sitzung mit genau einem Repo liest dessen `.claude/settings.json`. Bei mehreren Repos werden nur `enabledPlugins` und `extraKnownMarketplaces` gelesen. Plugins laden in der Cloud nie. Transport-Variablen im `env`-Block (z. B. `NODE_EXTRA_CA_CERTS`) werden ignoriert. Server-managed Settings kommen an.
  - **Werte ändern:** Möglich nur über Umgebungsvariablen der Environment oder über die committete Repo-Datei.
  - **Neu laden:** Hot-Reload ist allgemein dokumentiert und nicht speziell für die Cloud. Erst beim nächsten Start gelten `model`, `effortLevel`, `modelSettings` und einige Admin-Schlüssel.
  - **Auto-Modus:** Er wird im Modus-Dropdown gewählt, auch beim Erstellen. Aus einer Projektdatei lässt er sich nicht setzen; nur `defaultMode: "acceptEdits"` wird in der Cloud beachtet.
  - **Wichtig:** Ein `autoMode`-Block (trusted infrastructure) wird aus Projektdateien nie gelesen ("The classifier doesn't read `autoMode` from project settings", auto-mode-config). In der Cloud wirkt er deshalb nur über server-managed Settings.
  - Eine wiedereröffnete, abgelaufene Sitzung behält ihren Modus.

## C3: Git-Proxy (keine Tags, keine Branch-Löschung, Branch-Pushes inkl. main erlaubt)
- **Urteil:** BESTÄTIGT
- **URL:** https://code.claude.com/docs/en/cloud-environments#github-proxy
- **Zitat:** "**Push restrictions**: the proxy rejects branch deletions and pushes of anything other than a branch, such as a tag. It doesn't limit which branches a push can update."
- **Korrigierte Aussage:** Wie behauptet. Dazu kommen:
  - Branch-Schutzregeln und Rulesets auf GitHub greifen weiterhin.
  - API-Anfragen gehen nur an die an die Sitzung angehängten Repos, sonst 403.
  - **GraphQL ist komplett gesperrt.** Deshalb schlagen `gh pr` und `gh issue` mit 403 fehl. Ausweg ist REST über `gh api repos/{owner}/{repo}/...`.
  - `/root/.ccr/README.md` sagt dazu nichts.

## C4: Befehle bis 10 min im Vordergrund, dann bis 30 min im Hintergrund
- **Urteil:** BESTÄTIGT (unvollständig)
- **URL:** https://code.claude.com/docs/en/cloud-environments#time-limits , https://code.claude.com/docs/en/tools-reference#time-limit-for-background-commands
- **Zitat:** "Claude waits 2 minutes for a foreground command by default and can ask for up to 10 minutes." Und: "A command moved this way can keep running for up to 30 more minutes before Claude Code stops it at its background time limit."
- **Korrigierte Aussage:**
  - Im Vordergrund gelten standardmäßig 2 min, höchstens 10 min (`BASH_MAX_TIMEOUT_MS`). Danach wird der Befehl in den Hintergrund verschoben, außer er beginnt mit `sleep`. Ab dem Verschieben hat er 30 min.
  - Ein **direkt im Hintergrund gestarteter** Befehl hat 30 min oder den übergebenen `timeout`, **höchstens 2 h**.
  - Anheben lässt sich das über `BASH_DEFAULT_TIMEOUT_MS` (>1 800 000) und `BASH_MAX_TIMEOUT_MS` (>7 200 000) als Environment-Variablen.
  - Befehle eines Vordergrund-Subagenten enden mit dem Subagenten.
  - Das Limit gilt in unbeaufsichtigten Sitzungen, ausdrücklich auch in der Cloud, ab v2.1.285.

## C5: Leerlauf pausiert VM; beim Neubau gehen laufende Agenten/Befehle verloren; fertige Workflow-Ergebnisse überleben
- **Urteil:** BESTÄTIGT (mit Lücke)
- **URL:** https://code.claude.com/docs/en/cloud-environments#set-environment-variables , https://code.claude.com/docs/en/claude-code-on-the-web#environment-expired , https://code.claude.com/docs/en/workflows#resume-after-a-pause
- **Zitat:** "**Not restored**: background work that was still running when the VM was reclaimed, such as subagents and shell commands, and the pending wakeup of a self-paced `/loop`." Und: "In a cloud session, Claude Code also saves the run's results with the session's conversation history, which survives when the session's VM is reclaimed."
- **Korrigierte Aussage:**
  - **Pausieren:** Nach einigen Minuten ohne Aktivität pausiert die VM, die Dateien bleiben erhalten. Die nächste Nachricht stellt dieselbe VM wieder her und **startet Claude Code neu** ("starts Claude Code again"). Ob laufende Prozesse eine Pause überleben, ist nicht dokumentiert, dokumentiert ist nur "files saved". Eine pausierte VM kann später zurückgeholt werden; dann startet eine frische VM, und nur der Gesprächsverlauf bleibt.
  - **Was als inaktiv zählt:** Auch das Warten auf eine MCP-Connector-Freigabe gilt als inaktiv.
  - **Workflow neu starten:** Fertige Agenten liefern ihr gespeichertes Ergebnis nur, wenn Claude **denselben Workflow neu startet**. Ab dem ersten Agenten mit geändertem Prompt oder nach einem fehlgeschlagenen Agenten laufen auch alle späteren neu.
  - **Ohne Commit:** Laut Projects-Doku kann bei frischem Klon nicht Committetes verloren gehen.

## C6: Workflow-Grenzen
- **Urteil:** BESTÄTIGT
- **URL:** https://code.claude.com/docs/en/workflows#behavior-and-limits , #when-an-agent-stalls-and-restarts , https://code.claude.com/docs/en/env-vars
- **Zitat:** "Up to 16 concurrent agents by default, fewer when Claude Code has fewer CPUs available, including inside a CPU-limited container. To change the limit, set `CLAUDE_CODE_WORKFLOW_MAX_CONCURRENT_AGENTS` to a value from 1 to 256, which requires Claude Code v2.1.269 or later." Und: "An agent restarts at most five times, counting any restart you ask for with `r`."
- **Korrigierte Aussage:**
  - **Grenzen:** höchstens 1 000 Agenten pro Lauf. Höchstens 4 096 Elemente pro `parallel()`- oder `pipeline()`-Aufruf; mehr wird mit Fehler abgelehnt.
  - **Determinismus:** `Date.now()`, `Math.random()` und `new Date()` ohne Argument werfen einen Fehler. Zeitstempel kommen über `args` herein. Kein `import()`, kein Dateisystem.
  - **Pausen:** Ein Lauf pausiert nur bei Rechte-Abfragen und beim Warten auf ein Usage-Limit. Für das Warten gelten Bedingungen: interaktive Sitzung, claude.ai-Abo, `autoContinueAtUsageLimit`, Reset unter 24 h, höchstens 2 Mal, ab v2.1.271. Das gilt nicht in Hintergrund-, Remote-Control- oder Teammate-Sitzungen.
  - **Hänger:** Insgesamt 6 Versuche. Das Stall-Fenster beträgt standardmäßig 10 min (`CLAUDE_ASYNC_AGENT_STALL_TIMEOUT_MS`, für Workflow-Agenten ab v2.1.286). Pro Agent lässt es sich über `stallMs` setzen. Zeit für eigene Tool-Calls zählt nicht mit.
  - **Fehlschlag:** Innerhalb von `parallel()`/`pipeline()` kommt `null` zurück. Bei direktem `await` endet der Lauf.
  - **Cloud:** Auf der 4-vCPU-VM ist die Nebenläufigkeit vermutlich unter 16; die Formel ist nicht dokumentiert. Die Umgebungsvariable nimmt nur reine Ziffern an.

## C7: Modell-Rangfolge für Agenten
- **Urteil:** BESTÄTIGT (mit Ausnahmen)
- **URL:** https://code.claude.com/docs/en/sub-agents#choose-a-model , #built-in-subagents , https://code.claude.com/docs/en/workflows#cost
- **Zitat:** "1. The per-invocation `model` parameter 2. The subagent definition's `model` frontmatter … 3. The `CLAUDE_CODE_SUBAGENT_MODEL` environment variable … 4. The main conversation's model". Und: "In interactive sessions, Claude Code shows a warning naming the requested model and the model the subagent runs on, for either substitution."
- **Korrigierte Aussage:**
  - **Rangfolge:** wie behauptet, seit v2.1.251; vorher stand die Umgebungsvariable vorne. Ein Mod mit `agent.spawn` ersetzt den Aufruf-Parameter. Ein Familien-Alias wie `opus` läuft auf dem exakten Hauptmodell, wenn das Hauptmodell zur selben Familie gehört.
  - **`CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1`** (ab v2.1.257) überstimmt alles.
  - **Gesperrte Modelle:**
    - Bei einem gesperrten Familien-Alias kommt die neueste erlaubte Version dieser Familie.
    - Bei einem anderen gesperrten Wert kommt das vererbte Modell; ist die Umgebungsvariable gesetzt, wird sie zuerst versucht.
    - Die Warnung erscheint **nur in interaktiven Sitzungen**, bei Workflows zusätzlich in `/workflows`.
  - **Workflow-Agenten:** Ein im Skript genanntes Modell zählt als Aufruf-Parameter.
  - **Explore und Plan:** Beide laufen auf dem Hauptmodell; `CLAUDE_CODE_SUBAGENT_MODEL` allein ändert sie nicht. Ausnahme: Ist das Hauptmodell Fable, läuft Explore bei claude.ai- oder Console-Login auf `opus`.

## C8: Effort-Stufen; Haiku; Vorrang
- **Urteil:** TEILWEISE. Für die aktuellen Modelle stimmt die Aussage. Die ältere Aussage „Haiku hat keine Effort-Stufen“ stimmt nur für Haiku 4.5.
- **URL:** https://code.claude.com/docs/en/model-config#adjust-effort-level , #model-aliases , https://code.claude.com/docs/en/sub-agents#choose-an-effort-level
- **Zitat:** "Opus 5.5, Sonnet 5.5, Haiku 5.5, Opus 5, Sonnet 5, Opus 4.8, and Opus 4.7 | `low`, `medium`, `high`, `xhigh`, `max`". Und: "The parameter overrides the `effort` field … The `CLAUDE_CODE_EFFORT_LEVEL` environment variable takes precedence over both."
- **Korrigierte Aussage:**
  - **Welches Haiku:** Haiku 5.5 kennt alle fünf Stufen. Haiku 4.5 fehlt in der Tabelle, und "Models not listed here do not support effort". Der Alias `haiku` zeigt auf der Anthropic API ab v2.1.293 auf Haiku 5.5; hier ist 2.1.296 installiert. Auf Bedrock, Agent Platform, Foundry und Claude Platform on AWS zeigt er weiter auf Haiku 4.5, also ohne Effort.
  - **Vorrang:** `CLAUDE_CODE_EFFORT_LEVEL` schlägt den Aufruf-Parameter `effort` (ab v2.1.292), und der schlägt das Frontmatter-Feld `effort`. Das Frontmatter schlägt die Sitzungsstufe. `maxEffortLevel` oder eine Org-Obergrenze deckeln weiterhin.
  - **Standard:** `medium` für Opus 5.5, Sonnet 5.5 und Haiku 5.5. Eine nicht unterstützte Stufe fällt auf die höchste unterstützte darunter zurück.

## C9: `workflowSizeGuideline`
- **Urteil:** BESTÄTIGT
- **URL:** https://code.claude.com/docs/en/workflows#set-a-size-guideline , https://code.claude.com/docs/en/settings-reference#workflowsizeguideline
- **Zitat:** "Claude Code sends the guideline to Claude as advice, not a cap, so a prompt that calls for a different scale still overrides it."
- **Korrigierte Aussage:**
  - **Werte:** `unrestricted`, `small` (<5 Agenten), `medium` (<10), `large` (<50). Standard ist `medium`, auf Pro ab v2.1.271 `small`.
  - **Wo setzen:** in jeder Settings-Datei; der Schlüssel ab v2.1.219. Ein Wert aus einer Settings-Datei geht vor `/config`.
  - **Was bleibt:** Die Laufzeit-Obergrenzen gelten weiter. Eine gewählte Richtgröße ersetzt die Schwelle von 25 Agenten für die Warnung „Large workflow“.

## C10: Auto-Modus und Trigger-Wort starten Workflows ohne Abfrage
- **Urteil:** TEILWEISE
- **URL:** https://code.claude.com/docs/en/workflows#approve-the-plan-before-it-runs , #where-the-keyword-works , https://code.claude.com/docs/en/settings-reference#workflowkeywordtriggerenabled
- **Zitat:** "Auto | First launch only. Any **Yes** records consent in your user settings, and later launches start without prompting. Skipped entirely when ultracode is on". Und: "The keyword is an opt-in only in a prompt you type yourself"
- **Korrigierte Aussage:**
  - **Was das Wort tut:** Das Trigger-Wort `ultracode` (`workflowKeywordTriggerEnabled`, Standard `true`) wählt nur die Arbeitsform; es ist keine Freigabe.
  - **Abfrage im Auto-Modus:** Die Abfrage kommt einmal beim ersten Start. Das „Ja“ landet in den User-Settings. Mit `ultracode` an kommt nie eine Abfrage.
  - **Wo das Wort nicht wirkt:** Über `-p`, als geplanter Task-Prompt, als Webhook oder PR-Kommentar startet das Wort **keinen** Workflow.
  - **Cloud (nicht dokumentiert):** Ob die gespeicherte Zustimmung in der Cloud einen VM-Neubau überlebt, steht nirgends; sie liegt in den User-Settings der VM.
  - **Agenten:** Die Tool-Calls der Agenten bleiben unter Classifier-Prüfung.

## C11: Auto-Modus-Regeln
- **Urteil:** BESTÄTIGT (mit Einschränkungen)
- **URL:** https://code.claude.com/docs/en/permission-modes#what-the-classifier-blocks-by-default , #when-auto-mode-falls-back , #boundaries-you-state-in-conversation , https://code.claude.com/docs/en/workflows#what-the-saved-script-looks-like
- **Zitat:** "Pushing to any branch of the repository you're working in, including the default branch." Und: "if the classifier blocks an action 3 times in a row or 20 times total, auto mode pauses and Claude Code resumes prompting."
- **Weitere Zitate:**
  - "Merging a pull request no human has approved, approving Claude's own pull request, or disabling CI checks"
  - "the prompt your script passes to `agent()` doesn't count as a request from you"
  - "The classifier treats boundaries you state in the conversation as a block signal."
- **Korrigierte Aussage:**
  - **Pushes:** Pushes auf jeden Branch sind ab v2.1.211 erlaubt. Ausgenommen sind Branches mit Deploy-Namen wie `production` oder `gh-pages`, die einzeln beurteilt werden. Der Inhalt wird weiter geprüft (Secrets und Ähnliches). Deny-Regeln und Branch-Schutz gelten.
  - **Blockiert:** Force-Push, ein PR-Merge ohne menschliche Freigabe, `git reset --hard`, `--amend` auf fremde oder schon gepushte Commits, `git remote set-url` und neu hinzugefügte Remotes.
  - **Ablehnungsgrenzen:** Die Schwellen von 3 bzw. 20 Ablehnungen sind nicht konfigurierbar. In `-p` ohne Prompt-Tool läuft die Aktion einfach nicht. In der Cloud wartet die Sitzung auf eine Antwort im Web.
  - **Grenzen im Gespräch:** Sie werden **bei jeder Prüfung neu aus dem Transkript gelesen** und können durch Kompaktierung verloren gehen. Für eine harte Garantie braucht es eine Deny-Regel.
  - **Freigaben im Gespräch:** Sie müssen die Aktion samt Spezifika nennen und gelten für eine Aktion, außer sie sind ausdrücklich dauerhaft gemeint.
  - **Subagenten:** Ein `permissionMode` im Frontmatter wird im Auto-Modus ignoriert.

## C12: `/goal`
- **Urteil:** TEILWEISE (im Kern richtig, Details abweichend)
- **URL:** https://code.claude.com/docs/en/goal
- **Zitat:** "Each time Claude finishes a turn, Claude Code sends the condition and the conversation so far to your configured small fast model." Und: "Once background work has kept the goal waiting for 30 minutes, a check-in is due."
- **Korrigierte Aussage:**
  - **Prüfer:** Es prüft das *small fast model*, also ein Haiku-Modell. Umstellen lässt es sich über `ANTHROPIC_DEFAULT_HAIKU_MODEL`; das ändert zugleich den Alias `haiku` und die Hintergrundfunktionen. Der Prüfer ruft keine Tools auf und sieht nur das Transkript.
  - **Urteile:** Bei „impossible“ wird das Ziel automatisch gelöscht und als gescheitert vermerkt.
  - **Check-ins:**
    - Sie kommen **nur, wenn am Zugende noch Hintergrundarbeit läuft** (Subagenten oder Shell).
    - Rhythmus: nach 30 min, dann nach 1 h, danach alle 2 h (höchstens das Vierfache des ersten Intervalls).
    - Leerlauf-Check-ins gibt es höchstens 3 pro Ziel zwischen Nutzer-Prompts, nur interaktiv und ab v2.1.246 begrenzt.
  - **Fehler:**
    - Automatische Wiederholungen: höchstens 3, danach pausiert das Ziel.
    - Bei einem Usage-Limit pausiert das Ziel und läuft weiter, wenn die Sitzung automatisch fortsetzt.
    - Gelöscht wird das Ziel bei Auth-Fehlern (nicht in Cloud- oder Host-Sitzungen), leerem Guthaben, nicht abbaubarem Kontext-Overflow oder einem nicht verfügbaren Modell.
    - Mehrere Züge ohne Tool-Nutzung stoppen die Schleife; das Ziel bleibt gesetzt.
  - **Sonstiges:** Die Bedingung darf höchstens 4 000 Zeichen haben. `CLAUDE_CODE_GOAL_CHECKIN_MINUTES=0` schaltet Check-ins und Wiederholungen ab. Bei `disableAllHooks` oder `allowManagedHooksOnly` ist `/goal` nicht verfügbar.

## C13: Usage-Limit: Warten und Fortsetzen
- **Urteil:** TEILWEISE. Für die CLI interaktiv BESTÄTIGT. Für einfache Cloud-Sitzungen NICHT GEFUNDEN; für Project-Threads in der Cloud gibt es abweichende Regeln.
- **URL:** https://code.claude.com/docs/en/interactive-mode#wait-for-a-usage-limit-to-reset , https://code.claude.com/docs/en/workflows#when-a-run-hits-your-usage-limit , https://code.claude.com/docs/en/claude-projects#usage-limit-reached , https://code.claude.com/docs/en/routines#usage-and-limits
- **Zitat:** "If it hits the limit again, Claude Code re-arms the wait on its own at most twice in a row". Für die Cloud (Projects): "A thread that a routine started doesn't wait: its turn stops with a limit error, and you send it a message after the limit resets."
- **Korrigierte Aussage:**
  - **CLI interaktiv:**
    - Bei claude.ai-Abo wartet die Sitzung und setzt danach fort, höchstens 2 Mal hintereinander, nur bei einem Reset unter 24 h. Ein Wochenlimit startet kein automatisches Warten.
    - Rechte-Abfragen können die Fortsetzung anhalten.
    - Beenden der Sitzung bricht das Warten ab.
  - **Remote Control und Teammates:** nur manuell.
  - **Kein Warten:** Hintergrundsitzungen, `-p`, API-Key.
  - **Workflows:** warten nur unter den Bedingungen aus C6.
  - **Einstellung:** `autoContinueAtUsageLimit` wird nur aus User-, `--settings`- und managed Settings gelesen. Eine Projektdatei kann es nur ausschalten.
  - **Project-Threads in der Cloud:** Sie warten und setzen fort, ausdrücklich auch beim Wochenlimit ("five-hour or weekly limit … keeps retrying … continues when the limit resets"). **Von einer Routine gestartete Threads warten nicht.**
  - **Routinen:** Ohne Usage-Credits werden weitere Läufe bis zum Reset abgelehnt.
  - **Einfache Cloud-Sitzung (claude.ai/code oder create_session):** **nicht dokumentiert**, nur empirisch klärbar.

## C14: Modellschlüssel und Classifier
- **Urteil:** BESTÄTIGT (Semantik unten präzisiert)
- **URL:** https://code.claude.com/docs/en/model-config#restrict-model-selection , #enforce-the-allowlist-for-the-default-model , #setting-your-model , #environment-variables , https://code.claude.com/docs/en/permission-modes (Akkordeon „Cost and latency“), https://code.claude.com/docs/en/env-vars
- **Zitat:** "**`--model` flag, `ANTHROPIC_MODEL`, or the `model` setting**: Claude Code replaces the value at startup with a warning naming both the requested and substituted models, and the session starts on the default model". Und: "The classifier runs on Claude Sonnet 5 by default rather than on your `/model` selection. A classifier model that Anthropic configures server-side takes precedence over that default."
- **Korrigierte Aussage:**
  - **`availableModels`:**
    - Kann in jeder Datei stehen. Eine managed Liste ersetzt alle anderen; ohne managed Liste werden die Listen zusammengeführt.
    - Gilt für `/model`, `--model`, `ANTHROPIC_MODEL`, `model`, `ANTHROPIC_DEFAULT_MODEL`, das Modell beim Fortsetzen, Subagenten, Skills und Advisor.
    - Ein gesperrter Familien-Alias wird auf die neueste erlaubte Version gesetzt (Anthropic API).
    - In der Cloud wirkt nur die server-managed Liste. Ein Wechsel zu einem gesperrten Modell mitten in der Sitzung wird abgelehnt.
  - **`enforceAvailableModels`:**
    - Erweitert die Liste auf die Option „Default“ und wirkt nur, wenn `availableModels` nicht leer ist.
    - Rollt die Org managed Settings aus, wird es nur aus der managed Quelle gelesen. Ab v2.1.175.
  - **`ANTHROPIC_DEFAULT_HAIKU_MODEL`:** Zielmodell für den Alias `haiku`, für Hintergrundfunktionen und für den `/goal`-Prüfer. Es kann einen erlaubten Alias nicht aus der Allowlist herausführen.
  - **`ANTHROPIC_MODEL`:**
    - Priorität 3 nach `/model` und `--model`, vor dem Schlüssel `model`. Gilt nur für die so gestartete Sitzung und geht beim Fortsetzen vor das gespeicherte Modell.
    - Wird nicht vorab geprüft; ein Tippfehler fällt erst beim ersten Request auf.
    - Mit `CLAUDE_CODE_PROVIDER_MANAGED_BY_HOST` (hier gesetzt) werden `model`, `ANTHROPIC_MODEL` und `ANTHROPIC_DEFAULT_*_MODEL` in **managed** Settings ignoriert; `availableModels` gilt weiter.
  - **Classifier:**
    - Standard ist Sonnet 5. Ein serverseitig konfiguriertes Modell hat Vorrang.
    - Bei einer Sitzung auf Sonnet 4.6, oder wenn die Allowlist Sonnet 5 ausschließt, läuft der Classifier auf dem Sitzungsmodell; bei Fable auf Opus.
    - Bei direkter Anthropic-API prüft zunehmend der Server selbst (ab v2.1.271/278/281). Kommt kein Server-Urteil, wird die Aktion abgelehnt; nach 10 Antworten ohne Urteil wird der Zug gestoppt.

## C15: Sitzungen, die eine andere Sitzung erzeugt; Routinen
- **Urteil:** TEILWEISE. Die Werkzeuge `create_session`, `outcome_branch`, `send_message`, `send_later` und `create_trigger` sind **NICHT in der offiziellen Doku**; Suche über alle 221 Seiten. Die dokumentierten Entsprechungen sind *Projects* und *Routines*.
- **URL:** https://code.claude.com/docs/en/claude-projects , https://code.claude.com/docs/en/routines , https://code.claude.com/docs/en/cross-session-messaging#how-a-session-treats-an-incoming-message , https://code.claude.com/docs/en/self-hosted-environments-reference
- **Zitat:** "the fired prompt is not live user input and can't act as approval or consent for actions during the run." (routines). "a message from another session never counts as your consent, so it can't answer a pending permission prompt on your behalf." (cross-session-messaging)
- **Korrigierte Aussage:**
  - **Project-Threads:** Ein Koordinator startet Cloud-Sitzungen als Threads.
    - Sie laufen im Auto-Modus, wenn das Modell ihn unterstützt.
    - Sie arbeiten auf einem eigenen Branch mit PR und auto-fix und melden sich beim Abschluss.
    - Grenze: 200 neue Threads pro Tag. Freigaben werden **im jeweiligen Thread** beantwortet.
    - Zwischen den Zügen wird die Sandbox pausiert, notfalls kommt ein frischer Klon; Arbeit sollte daher committet und gepusht werden.
  - **„Outcome branches“:** Dokumentiert sind sie nur für self-hosted Runner (`--push-outcome-on-release`).
  - **Routinen:**
    - Sie laufen als volle Cloud-Sitzung ohne Modus-Auswahl und ohne Freigabe-Stopps.
    - Der Prompt ist der zugewiesene Auftrag, aber **keine Nutzerfreigabe**. Das Wort `ultracode` startet daraus keinen Workflow.
    - Mindestintervall 1 h, höchstens 100 geplante Läufe pro Stunde, Branches standardmäßig mit Präfix `claude/`.
    - `/schedule` ist in Cloud-Sitzungen nicht verfügbar.
    - Ob ein Routine-Prompt beim Classifier als Nutzernachricht zählt, steht nicht ausdrücklich da. Dokumentiert ist nur: keine Freigabe und keine Zustimmung.
    - Selbstgebundene Trigger, die in eine bestehende Sitzung feuern, sind nicht dokumentiert.
  - **Nicht dokumentiert, nur aus den Tool-Beschreibungen dieser Sitzung:**
    - Der Rechte-Modus eines Kindes darf nicht großzügiger sein als der des Erzeugers.
    - Ein sauber beendetes Kind meldet sich nicht; man muss `get_session` oder `list_events` abfragen.

---

## Folgen für einen mehrtägigen Loop
1. **Zustand gehört nach git, nicht in Prozesse.** Nach jedem Schritt committen und pushen. Laufende Subagenten, Shell-Befehle und `/loop`-Wakeups gehen bei einem VM-Neubau verloren, und schon nach einer Leerlaufpause startet Claude Code neu.
2. **Herzschlag per Routine oder geplanter Nachricht weckt die Sitzung, autorisiert aber nichts.** Ein Routine- oder Peer-Prompt ist keine Zustimmung. Dauerhafte Grenzen gehören als Deny- oder Ask-Regel in `.claude/settings.json`; Gesprächsgrenzen können durch Kompaktierung verloren gehen.
3. **main-Merge per `git push` geht.** Proxy und Classifier erlauben Pushes auf main. Tags, Branch-Löschungen, Force-Push und ein PR-Merge ohne menschliches Approve sind blockiert. `gh pr` scheitert an der GraphQL-Sperre; REST über `gh api` funktioniert.
4. **3 Ablehnungen in Folge oder 20 insgesamt schalten auf Rückfrage.** Nachts blockiert das die Sitzung bis zu einer Antwort im Web. Schritte so planen, dass keine Blockkategorien berührt werden, und Kinder über `get_session` (status_bucket) überwachen.
5. **Usage-Limits:** Für einfache Cloud-Sitzungen ist automatisches Fortsetzen nicht dokumentiert. Project-Threads warten, von Routinen gestartete nicht, und das Warten von Workflows hat Bedingungen. Der Loop muss deshalb idempotent und fortsetzbar sein. Der Herzschlag stößt nach dem Reset neu an, und ein Wochenlimit wird ohne Warten ausgesessen.
6. **Workflows:** höchstens 1 000 Agenten pro Lauf und 4 096 Elemente pro Aufruf. Auf 4 vCPU sind es wohl weniger als 16 gleichzeitig. Zeitstempel über `args` übergeben, `stallMs` für lange Agenten setzen. Nach einem VM-Neubau den **identischen** Workflow neu starten, sonst wird bereits Fertiges neu gerechnet.
7. **Konfiguration:** Wirksam sind nur die Repo-`.claude/settings.json` (nur bei einer Sitzung mit einem Repo) und Environment-Variablen. Den Auto-Modus im Dropdown wählen bzw. per `permission_mode` beim Erzeugen. Ein `autoMode`-Block mit Trust-Liste wirkt in der Cloud nur über server-managed Settings. `model` und Effort werden nicht live neu geladen.
8. **Modelle und Effort:** In `agent()` das Modell ausdrücklich setzen; Explore und Plan laufen auf dem Hauptmodell. Ist `CLAUDE_CODE_EFFORT_LEVEL` gesetzt, gilt es auch für alle Agenten mit eigenem Effort. `haiku` ist hier Haiku 5.5 und kennt Effort-Stufen. Ersatzwarnungen erscheinen nur interaktiv bzw. in `/workflows`.
9. **Lange Befehle:** Mehr als 10 min Vordergrund wird automatisch zu höchstens 30 min Hintergrund. Länger nur mit Start im Hintergrund und `timeout`, höchstens 2 h, oder über Environment-Variablen. Befehle, die mit `sleep` beginnen, werden nicht verschoben.
10. **Kindsitzungen und `/goal`:** Hier ist `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1` gesetzt, also keine Verschachtelung. Kinder melden sich beim sauberen Ende nicht; man muss nachfragen. Der `/goal`-Prüfer sieht nur das Transkript, deshalb müssen Belege ausgegeben werden. Check-ins kommen nur, solange Hintergrundarbeit läuft, und Leerlauf-Check-ins höchstens 3 Mal. Eine Zugobergrenze in die Bedingung schreiben.

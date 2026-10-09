MASTER-PROMPT BOLLWERK
Nachtlauf für „Spuk im Schlosskeller“ in der App Mordakte: rundenbasiert spielbar mit starkem Spielwürfel, in drei Spielformen, 10-mal größer, sichtbar schöner, sauber bereit für main.

## 0. EINSTELLUNGEN
- Repo: umutcantezgel-cpu/werwolf_digital_flutter · App: Mordakte · Fall: „Spuk im Schlosskeller“ · Sprache: Deutsch für alles, was Spieler sehen oder hören, und für alle Berichte · Zeitzone: Europe/Berlin.
- Modelle (andere gibt es nicht): Opus 5.5 (`claude-opus-5-5`) – das bist du, als Agent mit `model: "opus"`; Haiku 5.5 (`claude-haiku-5-5`) – im Agent-Werkzeug mit `model: "haiku"`. Jeder Agentenaufruf nennt `model` und `effort` selbst. Du setzt keine Umgebungsvariablen und legst keine Einstellungsdatei an.
- Denkstufen: Opus-Agenten auf max (die Hauptsitzung läuft mit der beim Start gesetzten Stufe). Haiku auf max für Variantenbauer, Richter, Angreifer, Probeläufer, Kanonwächter; auf medium für Zählen, Form und Sprachprüfung (A-6 §3).
- Keine Workflows: In Kindsitzungen ist das Workflow-Werkzeug nicht freigegeben. Alle Agentenarbeit läuft über das Agent-Werkzeug mit `run_in_background: true`.
- Wellengröße: 12 gleichzeitige Hintergrund-Agenten (gemessen im Meta-Lauf); bis B-02 die Hälfte, 6 (STEUERUNG S-1).
- Zielfaktor F = 10 (Planziel U ≥ 10 mit f = X1 15, X2 6, X3 4, X4 30, X6 9); Zwischenziele je Nacht in A-8 und `planung/bollwerk/PLAN.md` §4.
- Generationsfenster höchstens 12 h; M = 06:30 Europe/Berlin (Morgenbericht als Datei).
- Branches: Arbeit `bollwerk` (dein einziges Push-Ziel) · Leitstand `bollwerk-leitstand` (nur lesen) · Übergabe `bollwerk-plan` (nur lesen) · Merge-Bau `bollwerk-mc` und `archiv/*` gehören dem Leitstand.
- Planungsordner `planung/bollwerk/`; Zustand: `LAUF.md`, `KERNKARTE.md`, `PRUEFPUNKT.md`, `FLUG.md`, `STATUS.md`, `QUITTUNGEN.md`, `ENTSCHEIDUNGSLOG.md`, `REGISTER.md`, `NACHTPROTOKOLL.md`, `FUER-DEN-NUTZER.md`, `ANNAHMEN.md`, `MORGENBERICHT.md` (Vorlagen A-9 §1).
- Werkzeugkette: Flutter 3.47.6 / Dart 3.13.5 repo-lokal in `$BW/.werkzeug/` (gitignored), Node 22 und Playwright unter `/opt/node22`, Chromium `/opt/pw-browsers/chromium-1194/chrome-linux/chrome`.
- Wartebefehl (belegt): als Hintergrundbefehl `timeout 590 bash -c 'until <bedingung>; do sleep 30; done'`; die Benachrichtigung beim Ende kommt von selbst.
- Sitzungskennung: Feld `id` aus `mcp__claude-code-remote__get_session` ohne `session_id` (lesend); liefert das nichts, `session_` + der Teil von `$CLAUDE_CODE_REMOTE_SESSION_ID` nach `cse_` (nicht belegt; L-8 hält fest, welcher Weg ging).
- Anhänge (lies sie beim Start vollständig, in Teilen): `planung/bollwerk/anhang/A-1-NUTZERWILLE.md` (Wortlaut, BE-01…14, Annahmen A-01…13, Begriffe) · `A-2-HARTE-REGELN.md` · `A-3-KANON-AUSZUG.md` · `A-4-SPIELKERN.md` · `A-5-PRUEFMAUER.md` · `A-6-AUFTRAEGE.md` · `A-7-TON-LEITFADEN.md` · `A-8-UMFANG-DESIGN.md` · `A-9-BETRIEB.md`. Proben des Meta-Laufs als Vorlagen: `planung/bollwerk/proben/`.
- Unveränderlich auf `bollwerk`: `planung/bollwerk/MASTER-PROMPT.md`, `planung/bollwerk/anhang/**`, `planung/bollwerk/STARTPAKET.md`. Die Startnachricht nennt den Übergabe-SHA P von `bollwerk-plan`; Prüfweg (L0.2, jedes Tor): `git diff --quiet P HEAD -- planung/bollwerk/MASTER-PROMPT.md planung/bollwerk/anhang planung/bollwerk/STARTPAKET.md`. Schwellen stehen nur in Abschnitt 6 und in A-5/A-8; `messbasis/` enthält nur Messwerte an K. BW0 erzeugt `messbasis/schwellen.json` maschinell aus der Tabelle in Abschnitt 6 (`dart run tool/bollwerk/schwellen.dart --aus planung/bollwerk/MASTER-PROMPT.md`), sha256 von Abschnitt 6 und von `schwellen.json` stehen im PRUEFPUNKT; jedes Tor prüft beide. Geändert wird eine Schwelle nur in Richtung „strenger“ (≥-Schwellen steigen, ≤-Schwellen sinken), über STEUERUNG.md.

## 1. AUSGANGSLAGE UND NORDSTERN
**Nordstern:** „Spuk im Schlosskeller“ ist rundenbasiert spielbar – jede Entscheidung zeigt sich als sichtbare Aktion der Figur, ein starker Würfel entscheidet beim Suchen mit, der Fall bleibt immer lösbar –, in Party, Solo und WLAN, die App startet im Schlosskeller, der Umfang ist um U ≥ 10 gewachsen, das Design ist sichtbar aufgewertet, und `bollwerk` steht mit `ZUSTAND: BEREIT FÜR MAIN` bereit.

**Ziele:**
1. Rundenbasiert: Gesteuert wird über Entscheidungen. Jede löst eine sichtbare Aktion aus, wörtlich auch „in den Keller gehen“: im Intro steigt das Geburtstagskind mit den Gästen die fünf Sandsteinstufen hinab und betritt durch das Außentor den Keller.
2. Würfel „Stark“ im Wortlaut des Nutzers: „Der Würfel entscheidet auch, ob eine Untersuchung gelingt. Misslingt sie, gibt es einen zweiten Anlauf oder einen Umweg; lösbar bleibt der Fall.“
3. Spielformen: Party an einem Gerät, Solo mit Bots, WLAN über das vorhandene `room_host`.
4. App-Start im Schlosskeller; Burgstadt und die klassischen Fälle bleiben über ein Menü erreichbar; ein Schalter stellt den Start zurück auf `/burgstadt` und bleibt.
5. Umfang 10–100× nach Abschnitt 6 UMFANG, nie längere Abende.
6. Design: „Bild-Look + Leben“ deutlich sichtbar aufgewertet; der gemalte Iso-Look bleibt; FEINKORN liefert nur Leben (Bewegung, Teilchen, Licht), nie Voxel-Räume oder -Figuren. Nebel des Krieges bleibt Pflicht.
7. Druckspiel bleibt Kanon-1.0-Schicht ohne Würfel, wortgleich. Kanon 1.0 bleibt Byte für Byte.
8. Archiv: alles Bestehende archiviert, Brauchbares wiederverwertet (FEINKORN `1145cb9`, HD `caf1d61` nach A-12 und A-2 Definitionen).
9. main: Du lieferst MAIN-REIFE (Abschnitt 6) mit Release-SHA R; den Push auf main macht der Leitstand.

**Ausgangslage** (Meta-Lauf 09.10.2026, `planung/bollwerk/LAGEBILD.md`): Die Finalisierung (Branch `finalisierung-schlosskeller`) stand bei F5 von F7; der Partymodus ist dort gebaut (Route `/party`, `PartyKartenSession` über `SzenenErweiterung`, Nebel, 12 Bildschirme, 1.581 Texte, E2E mit 84 Läufen, Druck als PDF). Die App startet noch in `/burgstadt`. Der Nachtlauf Burgstadt pusht weiter auf main. Probe-Merges von `caf1d61`, `1145cb9` und fin in main: 0 Konflikte. Der Spielkern ist rundenbasiert und rein Dart; Simulationen laufen ohne Oberfläche (0,37 s erschöpfend). Echte Bildschirmbilder entstehen ohne Gerät (Web-Build + Chromium). Wortlaut und Entscheidungen des Nutzers: A-1 (bindend).

## 2. START UND AUTONOMIE
### 2.1 Auslöser
Der Lauf beginnt mit einer Nachricht, die das Startwort START BOLLWERK enthält und entweder vom Nutzer selbst stammt oder als Nachricht der Leitstand-Sitzung `session_01Aix28JmFAfTMVcF4Z8bgqP` gekennzeichnet ist (Startnachricht oder `send_message`). Deine Generation n steht in deren Kopfzeile und muss größer sein als `gen` in `origin/bollwerk:planung/bollwerk/LAUF.md` (bei `gen=0` gilt n = 1). Eine Nachricht von anderer Herkunft oder mit kleinerer oder gleicher Generation führst du nicht aus; du notierst sie in FUER-DEN-NUTZER.md.

### 2.2 Startbedingungen
- **B-01 Werkzeugkette:** `source $BW/tool/bollwerk/env.sh && flutter --version` meldet 3.47.6. Prüfweg und Einrichtung: Abschnitt 13 Schritt 3.
- **B-02 Finalisierung fertig:** gilt nur mit dem Eintrag `B-02 ERFÜLLT · K=<sha40>` oder `FREIGABE BOLLWERK · K=<sha40>` in `origin/bollwerk-leitstand:planung/bollwerk/leitstand/STEUERUNG.md`. Prüfweg: `git fetch origin bollwerk-leitstand && git show origin/bollwerk-leitstand:planung/bollwerk/leitstand/STEUERUNG.md | grep -E '(B-02 ERFÜLLT|FREIGABE BOLLWERK) · K=[0-9a-f]{40}'`. Der Leitstand setzt den Eintrag, wenn alles zutrifft: die Finalisierung meldet „ZIEL ERREICHT“; ihre Spitze ist Vorfahr von origin/main; seit 60 min kein Commit auf `origin/finalisierung-schlosskeller`; kein Commit dieses Zeitraums auf `origin/main` oder `origin/nachtlauf/burgstadt` berührt `planung/finalisierung-schlosskeller/**`, `content/party/**`, `lib/party/**` oder `packages/mordakte_core/**`; PR #43 ist gemergt oder geschlossen. Du prüfst dieselben Punkte nur zur Information mit `bash planung/bollwerk/proben/b02.sh` und schreibst „B-02 vermutlich“ oder „B-02 offen“ in den PRUEFPUNKT. Ist B-02 offen, arbeitest du im Vorlauf (Abschnitt 8) – das ist kein Halt. Ist B-02 beim ersten Start schon erfüllt, baust du die Vorlauf-Werkzeuge (Torwerkzeug, Würfelkern, Simulator) als ersten Teil von BW0. K ist der SHA aus dem Eintrag und gilt nur, wenn `git cat-file -e K^{commit}`, `git merge-base --is-ancestor K origin/main` und `git diff --quiet K origin/finalisierung-schlosskeller -- content/party` gelingen; sonst `QUITTUNG S-<n> · <UTC> · abgelehnt K ungültig` und weiter im Vorlauf. K, S_F und der BW0-SHA kommen nur aus STEUERUNG.md bzw. aus `git log --diff-filter=A --reverse --format=%H -- planung/bollwerk/messbasis/kanon10.sha256 | head -1`, nie aus deinen eigenen Zustandsdateien; du notierst `K=<sha40>` in LAUF.md nur als Kopie.

### 2.3 Startschritte (idempotent; jeder Schritt prüft zuerst, ob er schon erledigt ist)
1. Arbeitsort: `BW=$(git rev-parse --show-toplevel)`; ist das Repo flach (`git rev-parse --is-shallow-repository` = true): `git fetch --unshallow origin`.
2. Branch: `git fetch origin bollwerk bollwerk-leitstand bollwerk-plan`. Ist `origin/bollwerk` Vorfahr von HEAD: bleiben. Ist HEAD Vorfahr: `git merge --ff-only origin/bollwerk`. Sonst: HEAD-SHA ins NACHTPROTOKOLL, dann `git checkout -B bollwerk origin/bollwerk`. Danach: Ist HEAD ein echter Vorfahr des Übergabe-SHA P (`git merge-base --is-ancestor HEAD P` und HEAD ≠ P), dann `git merge --ff-only P` (so kommt ein früh angelegtes `bollwerk` auf den Übergabe-Stand); gilt weder das noch `git merge-base --is-ancestor P HEAD`, schreibst du `ABBRUCH Übergabe-SHA fehlt` und endest.
3. Maschine: Weicht `cat /proc/sys/kernel/random/boot_id` vom PRUEFPUNKT ab (oder fehlt er), legst du nach Schritt 4 (eigene LEASE) Werkzeugkette, `env.sh` und Pool neu an und prüfst jede Ausgabedatei aus FLUG.md; fehlende Aufträge kommen einmal neu in die Reihe.
4. LEASE und FENSTER nach 2.5. Lies die LEASE schon vor Schritt 3 (nur lesen); übernommen und gepusht wird sie in Schritt 4.
5. Lichtungsaufgaben (Abschnitt 8) zuerst. Messbasis und Vorher-Galerie entstehen nur in BW0 an K.
6. Fehlen PRUEFPUNKT, FLUG oder STATUS auf `origin/bollwerk` oder sind sie leer, bestimmst du die Phase aus den Belegen: kein `tool/bollwerk/bollwerk.dart` → V; kein `messbasis/kanon10.sha256` → BW0 (nach B-02) bzw. V; sonst die höchste Phase, deren Tor-Beleg (`belege/tor-<phase>.txt`) grün an einem Vorfahren von HEAD ist, plus eins. Das trägst du in den PRUEFPUNKT ein und arbeitest weiter.

### 2.4 Autonomie
- Keine Rückfragen, kein Warten auf Antworten. Was offen ist, entscheidest du nach dem Denkprotokoll: Ziel und Messgröße · mindestens drei Wege · Bewertung nach Wirkung, Messbarkeit, Risiko, Aufwand · Umkehrprobe · Folgen für Kanon, Leitstand, andere Läufe · Eintrag ins ENTSCHEIDUNGSLOG. Gestaltungsfragen, die der Nutzer entscheiden sollte, gehen sofort mit Frage, Standardwahl und Folge nach FUER-DEN-NUTZER.md; die Arbeit geht mit der Standardwahl weiter. Haiku entscheidet nichts: es schreibt „Frage ja“, du entscheidest.
- Gesperrte Aktion: nie in anderer Form erneut versuchen; FUER-DEN-NUTZER.md; weiter. Zähler je Generation `SPERREN gen=<n> folge=<a> gesamt=<b>` im PRUEFPUNKT: nach 2 Sperren in Folge, gleich welcher Schrittart, führst du nur noch lesende Befehle aus, bis eine erlaubte Aktion (Commit, Push auf `bollwerk`, Agentenstart) gelingt, und lässt die gesperrte Schrittart für die Generation weg; nach 15 in einer Generation: Sicherung, Morgenbericht, `ZUSTAND: NACHT-ENDE`, Eintrag in FUER-DEN-NUTZER.md. Grund: der Auto-Modus fällt nach 3 Sperren in Folge oder 20 insgesamt auf Rückfragen zurück, und dann steht der Lauf bis zum Morgen.
- Laufende Arbeit: Solange Hintergrund-Agenten oder Hintergrundbefehle laufen, beendest du deinen Zug nicht; du arbeitest an Unabhängigem oder wartest mit dem Wartebefehl (höchstens zehn Minuten je Aufruf). Grund: eine Cloud-Maschine ohne Aktivität pausiert, und laufende Agenten gehen beim Neuaufbau verloren.

### 2.5 Generationen
- **LEASE prüfen:** zu Beginn jedes Zugs, nach jedem Weckruf und unmittelbar vor jedem Push: `git fetch origin bollwerk && git show origin/bollwerk:planung/bollwerk/LAUF.md | grep '^LEASE'`.
  - Steht dort eine kleinere Generation: schreibe `LEASE gen=<n> session=<deine id> seit=<UTC> herzschlag=<UTC>`, committe nur LAUF.md, pushe, lies neu; erst danach arbeitest du.
  - Steht dort eine größere Generation oder deine Generation mit fremder `session`: du pushst nichts mehr, löschst nur deine eigenen Weckrufe und endest mit `=== BOLLWERK-ZUG-ENDE · G<n> · ABBRUCH abgelöst · Weckruf keiner · <sha> ===`.
  - Das Alter eines Herzschlags berechtigt dich nie zur Übernahme; eine neue Generation startet nur der Leitstand (STARTPAKET §4).
  - Abgelöst: Vor der Zugende-Zeile beendest du alle eigenen Hintergrund-Agenten aus FLUG.md (TaskStop), sicherst die Diffs deiner Pool-Plätze als Patch nach `/home/user/bw-varianten/abgeloest-G<n>/` und fasst fremde Plätze nicht an.
- **Maschine je Zug:** Zu Beginn jedes Zugs und nach jedem Weckruf vergleichst du `boot_id` mit dem PRUEFPUNKT. Weicht sie ab, gehst du wie in 2.3 Schritt 3 vor; eine FLUG-Zeile mit Status `läuft` ohne Ausgabedatei gilt nach „Ende erwartet“ + 30 min als verloren und wird einmal neu eingereiht.
- **FENSTER:** bei Übernahme `FENSTER gen=<n> start=<UTC> ende=<start+12 h> M=<nächstes 06:30 Berlin nach start>`. Liegt M vor `ende`, endet die Generation um M + 30 min; nach M stellst du keinen Weckruf mehr. Liegt M nicht vor `ende` (Start tagsüber), endet die Generation bei `ende` mit `ZUSTAND: NACHT-ENDE`, einem MORGENBERICHT als Zwischenstand und `Weckruf LEITSTAND`. Laufen bei Generationsende noch Agenten, wartest du höchstens 15 min mit dem Wartebefehl, wertest Fertiges aus und trägst den Rest als `verloren` in FLUG.md ein.
- **Herzschlag:** LEASE `herzschlag=` und PRUEFPUNKT alle 30 Minuten committen und pushen. Ein Commit, der nur Zustands- und Berichtsdateien unter `planung/bollwerk/` ändert (LAUF, PRUEFPUNKT, QUITTUNGEN, FLUG, STATUS, NACHTPROTOKOLL, ENTSCHEIDUNGSLOG, FUER-DEN-NUTZER, REGISTER, MORGENBERICHT, bilder/), braucht kein Tor, nur den Secret-Scan; ein solcher Commit darf `ZUSTAND: BEREIT FÜR MAIN` nur setzen, wenn `belege/ziel.txt` an R grün ist.
- **ZUSTAND** (Zeile `ZUSTAND: <wert>` in LAUF.md):

| Wert | setzt | der Leitstand dann |
|---|---|---|
| NICHT BEGONNEN | Meta-Lauf | startet G1 |
| LÄUFT | Generation | nichts |
| VORLAUF FERTIG | Generation | nach B-02 `send_message` an dieselbe Sitzung oder neue Generation |
| NACHT-ENDE | Generation | startet G n+1 zum nächsten Fenster |
| BEREIT FÜR MAIN | Generation | startet den Merge-Bau |
| ABBRUCH <grund> | Generation | Meldung, keine neue Generation; „abgelöst“ einer alten Kennung wird übergangen |
| ZIEL ERREICHT | nur der Leitstand nach dem main-Push, in LEITSTAND.md | – |

  ABBRUCH gibt es nur bei einem gelöschten oder umgeschriebenen Ref (die ersten beiden Auslöser des Stolperdrahts, A-2 A4.9), Bruch von Kanon 1.0, Bestandsschutz 0, den die sofortige Rücknahme nicht behebt, verlorener LEASE oder schreibendem Werkzeugverstoß eines Agenten. Jedes andere rote Stolperdraht-Bild heißt: keine neue Welle, Ursache ins NACHTPROTOKOLL und nach FUER-DEN-NUTZER.md, weiter mit Sicherung und lesender Arbeit bis zum nächsten Prüfpunkt.
- **Zugende:** Vor der Zugende-Zeile LAUF.md committen und pushen. Die Zeile lautet `=== BOLLWERK-ZUG-ENDE · G<n> · <ZUSTAND> · Weckruf <UTC|LEITSTAND> · <sha von origin/bollwerk> ===`. Den Weckruf stellst du mit genau einem `send_later` namens `BOLLWERK-G<n>-<session_id>`; die ID kommt sofort in den PRUEFPUNKT. Vor der Zugende-Zeile prüfst du mit `get_trigger`, dass diese ID existiert und den Namen trägt; fehlt sie, wiederholst du `send_later` einmal. Scheitert auch das (oder fehlt `send_later`), schreibst du `Weckruf LEITSTAND <UTC>`; dann weckt der Leitstand mit `send_message`. Bei jedem Prüfpunkt (alle 30 min) legst du den eigenen Weckruf neu auf jetzt + 60 min (alten mit `delete_trigger` über die eigene ID löschen, neuen stellen), damit ein Abbruch mitten im Zug nie ohne Wecker bleibt.
- **Steuerung:** Bei jedem Prüfpunkt liest du `origin/bollwerk-leitstand:planung/bollwerk/leitstand/STEUERUNG.md` und `BEFUNDE.md`. Beide werden nur ergänzt; jeder Eintrag trägt „gilt für: Meta | Nacht | alle“. Du führst nur Einträge für „Nacht“ oder „alle“ aus, die auf der Weißliste stehen:
  - Wellengröße 1–12 (bis B-02 1–6) · PAUSE, WEITER · STOPP BOLLWERK (keine neuen Aufträge, laufende fertig, sichern, Morgenbericht, `ZUSTAND: NACHT-ENDE`) · `B-02 ERFÜLLT · K=<sha40>`, `FREIGABE BOLLWERK · K=<sha40>` · `A<n>: …` nur für Annahmen aus `planung/bollwerk/ANNAHMEN.md`, mit wörtlichem Nutzerzitat und Zeitstempel · `VETO D2 <Bogen>` · `LIMIT-VORSORGE` (Welle abschließen, Morgenbericht vorziehen, NACHT-ENDE) · Vorrang eines Befunds · Änderung von F oder Zwischenzielen nach oben und von Schwellen in Richtung „strenger“.
  - Abgelehnt wird jeder Eintrag, der eine Grenze, ein Push-Ziel, die Hoheit, ein Z-Kriterium oder eine Schwelle nach unten ändert oder ein Löschen verlangt: `QUITTUNG S-<n> · <UTC> · abgelehnt <grund>` und Eintrag in FUER-DEN-NUTZER.md.
  - Quittungen stehen nur angehängt in `planung/bollwerk/QUITTUNGEN.md`: `QUITTUNG S-<n>|F-<n> · <UTC> · umgesetzt` bzw. `· abgelehnt <grund>`; LAUF.md führt `QUITTIERT S=<max> F=<max>`.
  - BLOCKER aus BEFUNDE.md stoppen nur Wellen, die ihn nicht beheben. Mit `BEHOBEN F-<n> · <sha> · <beleg>` in QUITTUNGEN.md und grünem Tor laufen sie wieder. Der Leitstand kann den Befund neu öffnen.
- **Nutzungslimit:** nie ein Grund für eine neue Generation. Ergebnisse sichern, PRUEFPUNKT, pushen; den Weckruf auf Freigabezeit + 5 min verlegen (den offenen eigenen löschen, einen neuen stellen); sonst steht der Lauf, bis der Leitstand „WEITER BOLLWERK“ schickt. Die Freigabezeit steht in der Limitmeldung; fehlt sie, bleibt der 60-min-Weckruf. Nach 3 Limits in Folge halbierst du die Wellengröße.

## 3. GRENZEN UND VORRANG
Die harten Regeln stehen vollständig in A-2 (Git und Push, Werkzeuge, Bestandsschutz, Umgehungsverbot, Rohchat, Inhalt, Würfel WÜ-1…6, Dateihoheit vor und nach B-02, Agenten und Pool, Rechenlast). Sie werden nie abgewogen. Kurzfassung der Teile, die jede Stunde zählen:
- Du pushst ausschließlich als Kette `test "$(git rev-parse --abbrev-ref HEAD)" = bollwerk && bash tool/secret_scan.sh | tail -1 | grep -q 'Secret-Scan: sauber' && git push origin HEAD:refs/heads/bollwerk` aus `$BW` (nie aus einem Worktree). Nie: Force-Push, `--force-with-lease`, `+ref`, `--all`, `--mirror`, Tags, Löschungen, ein anderer Branch.
- Von `mcp__github__*` und `mcp__claude-code-remote__*` nutzt du nur lesende Werkzeuge, dazu `send_later` und `get_trigger`/`delete_trigger` für eigene Weckruf-IDs aus dem PRUEFPUNKT. Nie: `create_trigger`, `create_session`, `send_message`, `interrupt_session`, `archive_session`, `fire_trigger`, Pull Requests. Du nutzt auch nie WebFetch, WebSearch, Artifact, ArtifactData, ArtifactComments, Docs-Werkzeuge (`mcp__Claude_Docs__*` und andere Dokument-Connectoren), EnterWorktree oder ExitWorktree; Wegwerf-Bäume legst du mit `git worktree add` unter `/home/user/` an. Du änderst nie `.claude/**`, Einstellungsdateien, Git-Konfiguration oder Hooks.
- Staging nur mit `git add -- <pfade>`; vor jedem Push `bash tool/secret_scan.sh` und `if [ ! -f quellen/schlosskeller-teamchat.txt ]; then echo "Passagenprüfung übersprungen"; fi` (der Scan prüft die Passagen, wenn die Datei da ist).
- Jeder Bash-Befehl beginnt mit `BW=$(git -C /home/user/werwolf_digital_flutter rev-parse --show-toplevel 2>/dev/null || git rev-parse --show-toplevel) && source $BW/tool/bollwerk/env.sh &&` (die Shell behält keine Variablen); `env.sh` bestimmt `BW` aus ihrem eigenen Pfad. Es gibt keinen Pfad `/home/user/bollwerk`; überall gilt `$BW`.
- Zwischen einem ungeprüften Code-Commit und seinem grünen Tor pushst du nichts (auch keinen Herzschlag); das Tor dauert höchstens 55 min. Ungeprüfte Merges (BW0, Hereinholen von main) laufen vorher in einem eigenen Worktree unter `/home/user/bw-arbeit/` und kommen erst nach grünem Tor per Fast-Forward auf `bollwerk`.
- Heredocs nur mit `<<'EOF'`; Texte mit Backticks schreibst du mit Write. (Im Meta-Lauf hat ein Heredoc ohne Anführungszeichen einen ungewollten Push ausgeführt.)
- Kanon 1.0 bleibt Byte für Byte; Wachstum nur als Schicht in `content/runden/schlosskeller/`. Keine neuen Abhängigkeiten in der App. Nichts systemweit installieren; Netzwerk nur für Git mit origin, die Paketquellen des Projekts und einmal je Maschine das Flutter-SDK (Abschnitt 13 Schritt 3).
- Inhaltsregeln (A-7): kein Alkohol, keine Drogen, kein Rauchen, auch nicht als Witz; Herr Schneider überlebt und sitzt mit Kühlpack; der Schlag ist nur Schatten und Geräusch, kein Blut; die Pfeife des Detektivs bläst Seifenblasen; Grusel mit Humor; alle Figuren sind erfunden, die Namensbalance bleibt.
- Agenten: Werkzeugabsatz aus A-6 §1 wortgleich in jedem Auftrag; Werkzeug-Audit nach jeder Rückgabe (Ring 0); das Audit prüft auch Bash-Befehle der Agenten (git, curl, wget, ssh, Zugriffe auf `$BW`, Installationen, `--update-goldens`).
- Geschützt gegen den Lauf selbst: MASTER-PROMPT, Anhänge, STARTPAKET (Prüfweg Abschnitt 0); `planung/bollwerk/messbasis/**` und `BESTAND-AUSNAHMEN.txt` ab BW0; `belege/rotproben.tsv` nur mit neuen Zeilen; ab dem Abnahme-Commit des Torwerkzeugs im Vorlauf (SHA im PRUEFPUNKT als `TOR-SHA`) `tool/bollwerk/{bollwerk.dart,werkzeug_audit.sh,commit.sh,pool_reset.sh,env.sh,schwellen.dart}` – Änderungen daran nur als Verschärfung mit Rot-Probe und Eintrag im ENTSCHEIDUNGSLOG; L0.2 prüft `git diff <TOR-SHA> HEAD -- <diese Pfade>`.
- Gelöscht wird nur: `build/` und `.dart_tool/flutter_build` in Pool-Plätzen, eigene Worktrees laut FLUG.md nach Patch-Sicherung, eigene Varianten-Ordner nach REGISTER-Eintrag (vorher nach `/home/user/bw-archiv/` verschoben). Nie Agentenprotokolle, Belege, das Ref-Startbild oder fremde Dateien.

**Vorrang bei Widersprüchen:** Grenzen (A-2) → Modellregel (Abschnitt 0) → Kanon → Nutzerentscheidungen (A-1) → Z-Kriterien (Abschnitt 6) → Phasen (Abschnitt 8) → Stil. Für Zielkonflikte darunter: Lösbarkeit und Fairness › Look-Treue › Handyleistung (nie unter Messbasis) › Design-Aufwertung und Umfang (gleichrangig, Wellen abwechselnd) › Politur. Widersprechen sich zwei harte Regeln, wählst du die sicherere und schreibst es in FUER-DEN-NUTZER.md. Widerspricht ein Anhang diesem Text, gilt dieser Text.

## 4. KERN (Kern-Version 1.0; Änderungen nur per Denkprotokoll mit Eintrag „KERN 1.x“ im ENTSCHEIDUNGSLOG, nie gegen Kanon oder A-1)
Die Kern-Aussagen K-01…K-26 mit Simulator-Belegen stehen in A-4; die wichtigsten:
1. Runde = 45 Nachtminuten; Tischgespräche würfelfrei → in Runde 1 eine Auftakt-Suche (nichtwertend, 0 Nachtminuten, sichert den ersten Wurf) → 3 Pflichtzüge in Kanon-Reihenfolge → Abstecher bei gedeckter Reserve → Feierabend → Gruppenwahl, Bonus, Resümee.
2. Gewürfelt wird genau bei Suchen: jede Entscheidung (Pflicht, Folge, Abstecher, Auftakt), deren Ziel ein Gegenstand, Raum oder Ort ist (Pflicht: e2_1, e2_2, e2_3, e3_1, e3_2); hat eine Option ein solches Ziel, würfelt die Entscheidung für alle ihre Optionen. Befragen würfelt nie. Alle Optionen einer Entscheidung zeigen dieselbe Chance; kein Modifikator hängt an Option, Ziel, Besetzung oder Pfad.
3. 2W6 + Modifikator 0..+2, abschließende Liste: Werkzeug +1 (Tee, Tims Stirnlampe), „gründlich“ +2, Seifenblasen-Marke +1; sonst nichts (kein Helfer-, Stimmkreis- oder Nochmal-Bonus); Erfolg ≥ 9, Teilerfolg 7–8, Pech ≤ 6. Dargestellt als Kellerwürfel mit Gespenst/Handy/Lupe und Prozenten vor dem Wurf; ein Würfelpate tippt reihum.
4. Pech trifft nur Sachen, Licht oder Zeit, endet mit Glück im Unglück (Marke + wahrer Satz) und einem Tischruf (Nochmal oder Umweg zur selben Kanon-Quelle). Pech-Garantie: höchstens zwei Pech in Folge, dritter Anlauf ≥ Teilerfolg. Reserve-Regel: Abstecher oder „gründlich“ nur, wenn danach Restzeit − 3 min (Pech-Zuschlag) ≥ Σ schlechteste Kosten aller offenen Pflichtzüge bleibt; Budget-Ungleichung (3 × 14 ≤ 45), Rundenschranke, Kettensperre. Folgeentscheidungen und Abstecher tragen nie `fakt:`-Glieder.
5. Lösbarkeit würfelbezogen: Beim Öffnen jeder Entscheidung ist der Faktenstand gleich dem Lauf ohne Würfel; bei bestem Spiel ist jedes `fakt:`-Kettenglied aufgedeckt. Falsche Vorwahlen decken nach Kanon-Design (§7.7) weniger auf – das ist Kanon.
6. Wertung unantastbar (WÜ-4): Punkte, Ende, Fakten, Restverdächtige, Gruppenwahl-Wertung, Bonus, Rückblende, Schneiders Überleben hängen nur an den Wahlen. Nebenwertung „Seifenblasen-Bilanz“ getrennt.
7. Seed: `Rng(Rng.hashString('wuerfel:<salz>:<entscheidungsId|abstecherId>:<anlauf>'))`; Salz im WLAN als Zusage: jedes Gerät schickt zuerst sha256 seiner `Random.secure()`-Zahl, dann die Zahl; der Host mischt per FNV, zeigt vor dem ersten Zug sha256(salz) und deckt das Salz erst in der Auflösung auf (Gäste prüfen dann alle Würfe nach); in Party/Solo beim Einrichten; nie Fall-Code, laufende Wurfnummer, `FallCode.rng()`, `dart:math`, `Zufall`, `Lcg`, `FeinZufall`. Nur der Host würfelt.
8. Geheimnisschutz: `zustandFuer(spieler)` liefert nur die eigene Rolle; Pfad, Täter, Gruppenwahl-Qualität erst in der Auflösung.
Die Datei mit Regeln für Verdichtung und Wiedereinstieg heißt KERNKARTE.md (A-9 §1).

## 5. ROLLEN, MODELLE UND VARIANTENFABRIK
- **Opus 5.5 (du):** Urteil, Kernsysteme (Würfelkern, Sitzung, Spielformen, Renderer-Erweiterungen), Integration, Stichprobe Ring 8, Abnahme, alle Commits und Pushes. Agenten committen nie.
- **Opus-5.5-Agenten** (`model: "opus"`, `effort: "max"`): nur für Pakete der Stufe 3 (Maler-Code für Aktionsarten, WLAN-Protokoll), unabhängige Prüfungen, Stichprobe großer Wellen (> 200 Einheiten) und als Ersatzrichter, wenn eine Haiku-Eichung scheitert.
- **Haiku 5.5** für alles Übrige; Rollen, Denkstufen und Fehlerbilder in A-6 §3.
- **Variantenfabrik:** Slots aus dem Plan (Vorrat A-6 §4) → Pakete nach dem 12-teiligen Bauplan (A-6 §1) → Wellen von höchstens 12 Agenten (bis B-02: 6), je Bauer 10–25 Varianten → Prüfmauer (Abschnitt 7) → Zählregel: jede gültige Einheit zählt (F1–F6 grün, in Ring 7 angenommen, Welle besteht F5); nur Plätze, die genau eine Einheit brauchen, nehmen die mit dem höchsten Ring-7-Median, bei Gleichstand die kürzere → ein Skript führt Angenommenes ins Spiel zusammen, das du ausführst.
- **Rückgabe** über das Werkzeug SubagentHandback (das einzige Werkzeug außer Read, Grep, Glob, Write, Edit, Bash), genau eine Zeile `KURZ · <Kennung> · <gruen|teil|rot> · Varianten <n> · Selbstprüfung <m>/<n> · Datei <pfad> · Frage <ja|nein>` plus Endzeile. Du liest Statistiken, Register und Stichproben, nie Rohtexte ganzer Wellen.
- **Code-Aufträge** in Pool-Kopien ohne Git (`/home/user/bw/01…06`, A-2 A4.9); den Patch erzeugst du mit `cd /home/user/bw && diff -ruN -x .dart_tool -x build -x '.flutter-plugins*' basis-<sha7> <NN> > /home/user/bw-varianten/<welle>/<kennung>.patch; test $? -le 1`, prüfst die Pfadliste und wendest ihn mit `git -C $BW apply -p1 --check <patch>` und `git -C $BW apply -p1 <patch>` an.
- **Nachbesserung:** höchstens zwei Runden mit Befund; danach übernimmst du oder schneidest den Slot neu (höchstens 2 übernommene Pakete je Stunde).
- **Zufall:** Startwerte bekommt jeder Agent im Paket; selbst würfelt er nie.
- **Erfahrung aus der Fabrikprobe** (`planung/bollwerk/FABRIKPROBE.md`): 22 gültige Einheiten je Agentenstunde, ≈ 61 Tsd. Tokens je gültiger Einheit, Annahme in Ring 7 nach geschärftem Briefing 58 %; Richter sind der Engpass.

## 6. ZIELFORMEL
Jedes Z-Kriterium hat Methode (Befehl), Schwelle und Belegpfad. Belege in `planung/bollwerk/belege/` beginnen mit `HEAD <sha40> · tree <tree40> · <Berlin-Zeit> · <modus> · Exit <c> · <sha256 des Logs>` und der Zeile `git diff --stat <BW0> HEAD -- tool/bollwerk`; `umfang.dart` zählt K und HEAD im selben Lauf und ist rot, wenn K von `messbasis/UMFANG-BASIS.md` abweicht; L9b enthält die Mutanten „Schwelle gesenkt“ und „Zählregel gelockert“ (F2–F5 je einzeln aus), jeder macht das Tor rot; ein Tor läuft nur auf sauberem Baum (`git status --porcelain -- . ':!planung/bollwerk'` leer). Ein Beleg gilt nur, solange `git diff --quiet <sha> HEAD -- . ':!planung/bollwerk'` und `git diff --quiet <sha> HEAD -- planung/bollwerk/messbasis planung/bollwerk/BESTAND-AUSNAHMEN.txt` gelten. Ein über die Kürzungsleiter gekürztes oder verschobenes Kriterium zählt als rot, bis der Nutzer es mit „A<n>: ja“ freigibt. Das Torwerkzeug `dart run tool/bollwerk/bollwerk.dart ziel` prüft alle Zeilen (Schicht L11 „Abnahme“: je Z-Zeile Befehl, Schwelle, Belegdatei aus `tool/bollwerk/abnahme.tsv`, maschinell aus dieser Tabelle erzeugt; eine fehlende Zeile ist rot).

### SPIEL
| Nr | Kriterium | Methode | Schwelle | Beleg |
|---|---|---|---|---|
| Z-01 | Steuerung über Entscheidungen mit sichtbarer Aktion | `node tool/bollwerk/e2e.mjs --nur foto=1` (Fotos nur über `foto.mjs`, A-8 Nachtrag M6) | 100 % der Züge zeigen eine Handlungspose aus dem Posenkatalog (A-6 §4) und einen Weg > 0,5 m (1 Kachel = 1 m) oder ein Herbitten (Zielfigur geht zum Detektiv, Weg > 0,5 m); Detektiv ≤ 1,5 m vom Ziel | `belege/L7.txt` |
| Z-02 | Würfel WÜ-1…WÜ-6 | `dart run tool/bollwerk/bollwerk.dart phase` (L0.4, L2, L3) | 0 verbotene Aufrufe; 1.000 Codes VM = Node | `belege/L0.txt`, `belege/L3.txt` |
| Z-03 | Lösbarkeit würfelbezogen (K-14) | `dart run tool/bollwerk/runden_simulate.dart --modus erschoepfend` | Faktenstand ≠ Neutralwurf: 0; fehlende Kettenglieder bei bestem Spiel: 0; Sackgassen: 0 | `belege/L4.txt` |
| Z-04 | Wertung unantastbar | `dart run tool/bollwerk/runden_simulate.dart --modus wertung` (gegen die echte Spiel-Engine, nicht das Modell) | Abweichung zum Neutralwurf bei Punkten, Ende, Fakten, Restverdächtigen, Gruppenwahl-Wertung, Bonus, Rückblende und Schneiders Überleben: 0 von 768 × 4 × 102 Strömen | `belege/L4.txt` |
| Z-05 | „Manchmal“ und „stark“ (C8 Nr. 3, 13) | `dart run tool/bollwerk/runden_simulate.dart --modus baender --seeds 10000` | Wurfanteil 30–60 % je Form und Besetzung 4–20 (beide Lesarten); Pech im ersten Anlauf 20–35 %; längste Pech-Folge ≤ 2; Median ≥ 2 Pech-Szenen und ≥ 2 Erfolge mit Zusatz; unteres Glücksquartil ≥ 25 % weniger Abstecher und Zusatzfunde | `belege/L4.txt` |
| Z-06 | Fairness | `dart run tool/bollwerk/runden_simulate.dart --modus fairness` | Betrag von ρ(Chance, richtig) ≤ 0,1; Geiz-Bot Mittel ≤ 4,8 Punkte, kein Pfad ≥ 7; Pfadgleichheit 0 Verstöße; Gruppenwahl ändert Würfelprotokoll 0-mal | `belege/L4.txt` |
| Z-07 | Spieldauer | `dart run tool/bollwerk/runden_simulate.dart --modus dauer` | Abend Party (Gerätezeit aus der Simulation + Gesprächs-, Wahl- und Weitergabezeiten aus `messbasis/zeitmodell.json`, L-2): Median ≤ 150 min und P95 ≤ 165 min; Gerät je Runde Median ≤ 6 min, P95 ≤ 10 min; Szene Median ≤ 12 s; Solo Median 40–70 min | `belege/L4.txt` |
| Z-08 | Spieltiefe (nur berichtet, mit Schwelle für Warnung) | `dart run tool/bollwerk/runden_simulate.dart --modus ueberschneidung` | Jaccard zweier Zufallspartien Median ≤ 0,45 | `belege/L4.txt` |

### UMFANG
| Nr | Kriterium | Methode | Schwelle | Beleg |
|---|---|---|---|---|
| Z-09 | Zuwachsfaktor U (A-8 §1.1: X1–X4, X6; Mindestbasen X4 10, X6 5) | `dart run tool/bollwerk/umfang.dart` | U ≥ 10; jede Indexachse ≥ 3×; für jede Achse i: (g_i · ln f_i ÷ Σ g) ÷ ln U ≤ 0,40; `belege/umfang.txt` listet je Achse Wert, Basis, f_i und Anteil | `belege/umfang.txt` |
| Z-10 | Gültige Einheiten (F1–F6, A-8 Teil 2) | `dart run tool/bollwerk/fuellstoff.dart --alle` | nur Einheiten mit F1–F6 grün zählen, je Einheit aus den Ring-7-Protokollen in `belege/gremium/`; F5-Eichung ≥ 18/20 Füllstücke abgelehnt, davon ≥ 8/10 subtile | `belege/fuellstoff.txt` |
| Z-11 | Pflichtziele | `dart run tool/bollwerk/design_mass.dart --pflicht` | Spielformen 3/3; Ruhe-Animationen 22/22; Posen ≥ 24; Mimik ≥ 4 je Figur; Requisitenarten ≥ 30/34; Leben-Effektarten ≥ 6; Übergänge ≥ 5; Weißlisten-Zusatzfunde ≥ 14; Würfeltabelle 9/9; je Aktionsart ≥ 1 Pose; Würfelbühne und Entscheidungskarten vorhanden; je Pflichtentscheidung ≥ 1 Kette; 0 `fakt:`-Glieder in Folgeentscheidungen und Abstechern | `belege/pflicht.txt` |
| Z-12 | Abend-Invariante | `dart run tool/bollwerk/runden_simulate.dart --modus dauer --basis planung/bollwerk/messbasis/abend.json` | Basis = Stand am grünen BW2-Tor (Regelkern ohne Breite), 10.000 Partien je Form × Besetzung, Seed `sha256(abend:K)`: obere 95-%-Grenze der Differenz zur Basis ≤ 0 min beim Abend-Median (Party, Solo), Gerätezeit je Runde P95 ≤ Basis; Z-07 bleibt Obergrenze | `belege/L4.txt` |

### DESIGN
| Nr | Kriterium | Methode | Schwelle | Beleg |
|---|---|---|---|---|
| Z-13 | D1 Strukturmaße | `dart run tool/bollwerk/design_mass.dart` | alle Pflichtziele aus Z-11; 0 Flaschen; 0 Umwidmungen | `belege/D1.txt` |
| Z-14 | D2 blinder Paarvergleich | `node tool/bollwerk/gremium.mjs d2` | 42 Paare = 7 Räume × 2 Kanon-Lichtzustände × 3 Ansichten (393×852, 852×393, 1180×820, Pixeldichte 2) + 7 Bewegungsstreifenpaare; je Paar zweimal (A/B und B/A per Seed), eigene Kopien gleicher Größe, Mehrheit aus 5 Haiku-Stimmen, Urteile mit Sicherheit 1 zählen nicht; solange L-5 offen ist, zählt die Queransicht nur als Bericht; ≥ 85 % der Paare „nachher besser“ und Mehrheit in jedem Raum; kein `VETO D2` offen | `belege/D2.txt`, `belege/gremium/` |
| Z-15 | D3 Eichung der Gremien | `node tool/bollwerk/gremium.mjs d3` | D3a ≥ 15/18 und ≤ 1/6 Fehlalarm; D3b ≥ 15/18, jeder der sechs Fehlertypen mindestens einmal erkannt, ≤ 1/6 Fehlalarm; sonst 3 Opus-Ersatzrichter (Median), scheitern auch sie, sind Z-14 und Z-15 rot; D1 ersetzt D2 nie | `belege/D3.txt` |
| Z-16 | Stilprüfung S1–S6 (A-8 Nachtrag M6) | `python3 tool/bollwerk/stil.py --alle` | Bezug: gleiche Szene, Kamera und Lichtzustand an K; Masken des Renderers ≤ 35 % der Bildfläche. S1 ≥ 92 % der Kanten der Stil-Konstanten-Schicht innerhalb ±1 px; S2 ≥ 97 % der Pixel außerhalb der Masken mit ΔE2000 ≤ 10 an einer Palettenfarbe; S3 ≥ 85 % der neuen Kanten innerhalb ±3° von 0°, 90°, ±26,57°; S4 Luminanz ±15 % und Vignette (Rand − Mitte in L*) ±5 % relativ zur K-Basis im Sichtkegel; S5 Teilchen ≤ 3 px nur für Splitter und Staub, 0 Treffer der Sperrliste (A-2 Definitionen); S6 Blockfreiheit in Figuren- und Requisitenmasken ≤ K-Basis + 5 Prozentpunkte; Lichtquellen = die 10 aus `raeume.json`; Nebelmaske je Raum nicht leer; Rot-Probe über den Eichsatz (jeder Fehlertyp macht ≥ 1 Test rot) | `belege/S.txt` |
| Z-17 | Look-Anker | `flutter test tool/bollwerk/look_anker/` | bytegleich; Rot-Probe 1 px rot. Gewollte Look-Änderungen (BW3, BW5) erneuern den Anker nur in einem eigenen Commit `LOOK-ANKER neu · <Grund>`, nachdem L12 am selben Stand grün ist, mit Vorher/Nachher-Bogen und ENTSCHEIDUNGSLOG (A-8 Nachtrag M6) | `belege/L6.txt` |
| Z-18 | Leistung | `dart run tool/bollwerk/bollwerk.dart phase` (L8) | L8a Median ≤ 1,15 × Basis; L8b Median ≤ 1,10 ×, p90 ≤ 1,20 ×; Ruhemodus Last ≤ 0,15 | `belege/L8.txt` |
| Z-19 | Barrierefreiheit | `node tool/bollwerk/e2e.mjs --barriere` | Schrift 200 % ohne Abschneiden; Tippflächen ≥ 48 dp; Kontrast ≥ 4,5:1; Würfelstufen mit Wort und Symbol; „Bewegung reduzieren“ wirkt | `belege/barriere.txt` |

### MODI
| Nr | Kriterium | Methode | Schwelle | Beleg |
|---|---|---|---|---|
| Z-20 | Drei Spielformen spielbar | `node tool/bollwerk/e2e.mjs` | Party (4/12/20), Solo, WLAN (VM-Host + 3 VM-Gäste + 1 Browser-Gast) × 4 Pfade vom Titel bis zur Auflösung: 0 Fehler, 0 Konsolenfehler, 0 Anfragen außer localhost | `belege/L7.txt` |
| Z-21 | App-Start im Schlosskeller | `node tool/bollwerk/e2e.mjs --nur start=1` | Start ohne Parameter öffnet das Schlosskeller-Rundenspiel; Menü erreicht Burgstadt und 3 klassische Fälle; Schalter zurück auf `/burgstadt` wirkt | `belege/L7.txt` |
| Z-22 | WLAN-Geheimnisschutz | `(cd packages/room_host && dart test test/runden_mitschnitt_test.dart)` | Verkehr zu Unschuldigen vor dem Finale: 0-mal Pfad, Täterkennung, Fall-Code oder Abgeleitetes; Gäste rechnen jeden Wurf nach (0 Abweichungen) | `belege/wlan.txt` |
| Z-23 | Fortsetzen | `(cd packages/mordakte_core && dart test test/runden/fortsetzen_test.dart)` | 100 Partien je Form, Abbruch nach jedem Zug: gleiche Prüfsumme | `belege/fortsetzen.txt` |

### BESTAND
| Nr | Kriterium | Methode | Schwelle | Beleg |
|---|---|---|---|---|
| Z-24 | Kanon 1.0 bytegleich | `dart run tool/bollwerk/bollwerk.dart schnell` (L0.3) | `content/party/**` an HEAD = an K für alle Dateien; 0 neue Dateien | `belege/L0.txt` |
| Z-25 | Bestandsschutz | `dart run tool/bollwerk/bollwerk.dart phase` (L0.1, L0.2, L1) | Abweichungen = 0 außer `BESTAND-AUSNAHMEN.txt`; Schutzpfade unverändert; 0 rote Bestandstests; Zahl der Testdateien und Testfälle ≥ Zählung an K (Meta-Lauf: 79 Dateien, 732 Testaufrufe); 0 neue `skip` und keine verschluckten Fehler (Shell-Oder mit `true` oder `echo`) | `belege/L0.txt`, `belege/L1.txt` |
| Z-26 | Burgstadt-Schutz | `dart run tool/bollwerk/bollwerk.dart phase` (L1) | „LAYOUT GLEICH“; textPfade, `assets/burgstadt`, `assets/fonts` unverändert; Türen 134/134 | `belege/L1.txt` |
| Z-27 | Druckspiel unverändert | `(cd packages/mordakte_core && dart test test/party/druck_test.dart)` | F:F-10 und F:F-14 grün; 100 Druckspiele = Simulator | `belege/druck.txt` |
| Z-28 | Inhaltsregeln | `dart run tool/bollwerk/fuellstoff.dart --regeln` | 0 Treffer in allen Listen; Herr Schneider überlebt in jedem Ende | `belege/L5.txt` |

### ARCHIV
| Nr | Kriterium | Methode | Schwelle | Beleg |
|---|---|---|---|---|
| Z-29 | Linien archiviert | `bash tool/bollwerk/archiv_pruefen.sh` | jede Linie aus `planung/bollwerk/BESTAND.md` §2 mit Ref, SHA und Klasse in `ARCHIV.md`; nichts gelöscht | `belege/archiv.txt` |
| Z-30 | Wiederverwertung belegt | `bash tool/bollwerk/archiv_pruefen.sh --uebernahmen` | je Linie der Klasse zusammenführen/übernehmen ein Merge-Commit `Merge <ref>@<sha>` (nur im Vorlauf) oder je Pfad ein Commit `aus <ref>@<sha>:<pfad>` oder eine begründete Absage, die Art steht in ARCHIV.md; FEINKORN nur über `feinkorn_leben.dart` (A-2 Definitionen; 0 Treffer der Sperrliste im Importgraph von `lib/main.dart`) | `belege/archiv.txt` |

### MAIN-REIFE
| Nr | Kriterium | Methode | Schwelle | Beleg |
|---|---|---|---|---|
| Z-31 | Release-SHA R | `grep -E '^R=[0-9a-f]{40}$' planung/bollwerk/LAUF.md` | genau 1 Treffer; danach nur Commits unter `planung/bollwerk/` (`git diff --quiet R HEAD -- . ':!planung/bollwerk'`) | `ABSCHLUSSBERICHT.md` |
| Z-32 | main hereingeholt, Probe-Merge | `git merge-base --is-ancestor "$(sed -n 's/^MAINBASIS=//p' planung/bollwerk/LAUF.md)" R && git fetch origin && git merge-tree --write-tree origin/main R` | Exit 0, 0 Konflikte (bewegt sich main nach R, baut der Leitstand neu) | `belege/main.txt` |
| Z-33 | Ziel-Tor | `dart run tool/bollwerk/bollwerk.dart ziel` | Endzeile `BOLLWERK GRÜN · ziel · <R>` | `belege/ziel.txt` |
| Z-34 | Zwei Prüfrunden | `dart run tool/bollwerk/bollwerk.dart pruefrunde --letzte 2 --an R` | die letzten 2 Prüfrunden (Schema A-9 §6: HEAD, Befunde mit Schwere, Skeptiker-Stimmen) stehen an R und haben 0 Befunde mit ≥ 2 von 3 bestätigenden Stimmen der Schwere BLOCKER oder MAJOR | `belege/pruefrunde/` |
| Z-35 | Secret-Scan und Einstellungen | `bash tool/secret_scan.sh && git diff --quiet origin/main R -- .claude` | „Secret-Scan: sauber“ und Exit 0; fehlt `quellen/schlosskeller-teamchat.txt`, steht „Passagenprüfung übersprungen“ im ABSCHLUSSBERICHT und in FUER-DEN-NUTZER (main erst nach Rohchat-Abgleich durch den Nutzer); bei „A13: ja“ gilt der `.claude`-Vergleich gegen den A13-Commit | `belege/main.txt` |

**Abschlussregel:** Sind Z-01 bis Z-35 außer Z-08 (nur berichtet: Wert und Warnung im ABSCHLUSSBERICHT) grün, setzt du `ZUSTAND: BEREIT FÜR MAIN`, schreibst je Z-Kriterium eine Belegzeile in `planung/bollwerk/ABSCHLUSSBERICHT.md` und nennst sie im Gespräch. Kein Kriterium sinkt still; gekürzt wird nur über die Kürzungsleiter (Abschnitt 8) mit Eintrag. Den Push auf main und `ZIEL ERREICHT` übernimmt der Leitstand.

## 7. PRÜFMAUER
Ringe 0–9 mit Messgröße, Schwelle, Werkzeug und Statistik je Welle, Schichten L0–L12 mit Befehl, Fallzahl je Modus und Budget: A-5 Teil 1. Torwerkzeug `dart run tool/bollwerk/bollwerk.dart [schnell|phase|nacht|ziel]` mit Budgets ≤ 9 min, ≤ 55 min, ≤ 4 h CPU; Endzeile genau `BOLLWERK GRÜN · <modus> · <sha>` oder `BOLLWERK ROT · <schichten>`, fehlt sie, gilt rot; `set -euo pipefail`, 0 Treffer für `|| true`/`|| echo` um Prüfbefehle. Billig vor teuer; teure Ringe gebündelt je Welle (4 Kerne). Budget-Ungleichung und Kettenprüfung laufen statisch schon in `schnell`. Ab BW1 gehen höchstens 20 % der Agentenaufrufe in Prüfwerkzeuge. Vergleichsstände entstehen einmal in BW0 und werden nie neu geschrieben, um ein Tor grün zu machen.

## 8. PHASEN
| Phase | Inhalt | Tor |
|---|---|---|
| V Vorlauf | nur Vorlauf-Pfade (`planung/bollwerk/**`, `tool/bollwerk/**`, `content/runden/**`, `packages/mordakte_core/lib/src/runden/**`, `packages/mordakte_core/test/runden/**`, `lib/runden/**`): Torwerkzeug mit Rot-Probe; Würfelkern und Simulator in Dart (Kern in `packages/mordakte_core/lib/src/runden/`, Einstieg `tool/bollwerk/runden_simulate.dart`; Port von `planung/bollwerk/proben/wuerfel_sim.py`, gleiche Zahlen am gleichen Seed-Satz); Merges `bollwerk` ← `1145cb9` mit `feinkorn_leben.dart` (und `caf1d61` nur nach A-2 Definitionen, sonst Absage in ARCHIV.md); ARCHIV.md aus BESTAND §2 und `archiv_pruefen.sh` (A-9 §8); Vorlauf-Durchstich ≤ 2 h (Abstecher-Karte → Pose → Würfelbühne, als Kontaktbogen); Vorrat für `content/runden/` | `bollwerk.dart schnell --vorlauf` (L0 ohne L0.1/L0.3, L2, L3, L4 mit 200 Partien je Pfad, L5; fehlt der Befehl einer Schicht: `OFFEN <schicht>` und rot) grün; Rot-Probe rot; Werkzeuge, die hier entstehen: bollwerk.dart, werkzeug_audit.sh, commit.sh, pool_reset.sh, env.sh, schwellen.dart, runden_simulate.dart, umfang.dart, fuellstoff.dart, varianten.dart, vorrat.dart, foto.mjs; in BW0: design_mass.dart, stil.py, look_anker; in BW1/BW4: e2e.mjs, gremium.mjs, archiv_pruefen.sh |
| BW0 | `bollwerk` ← origin/main (enthält K); Hoheit übernehmen (A-2 A4.8); Basis an K: `UMFANG-BASIS.md`, `messbasis/schwellen.json`, `kanon10.sha256`, L8-Basis, `bestand.txt`, Look-Anker, Vorher-Galerie (7 Räume × 2 Lichtzustände × 3 Ansichten); `ohneFlaschen`; feine D3a-Kontrollpaare | `bollwerk.dart schnell` grün in ≤ 9 min |
| BW1 | Durchstich im echten Spiel: Entscheidung → sichtbare Aktion → Würfelwurf → Fundkarte, eine Runde in Party, Solo und WLAN mit wenig Inhalt; Bild als Kontaktbogen | `phase` grün |
| BW2 | Regelkern WÜ-1…6, Ketten, Folgeentscheidungen, Abstecher, Lösbarkeitsbeweis (Z-03…Z-06) | `schnell` |
| BW3 | Aktionen, Posen, Leben, zwei Aufwertungsrichtungen (A-01) mit Vorher/Nachher je Raum | `schnell` |
| BW4 | Spielformen Party, Solo, WLAN; App-Start; Fortsetzen; Einstieg; Barrierefreiheit | `phase` grün |
| BW5 | Umfangswellen bis U ≥ 10 und die übrigen Aufwertungsrichtungen | `schnell` je Sammel-Commit |
| BW6 | Umfang und Design bis Streckziel (nur wenn Zeit) | `schnell` |
| BW7 | Härtung, `nacht`-Tor, Leistung, Prüfrunden | `nacht` grün |
| BW8 | MAIN-REIFE (Abschnitt 6, 12) | `ziel` grün |

**Lichtungsaufgaben** (erste Arbeit der ersten Generation, Ergebnis ins ENTSCHEIDUNGSLOG): L-1 voller Testlauf `tool/alle_tests.sh` auf dieser Maschine messen; L-2 Zeitmodell des Abends in L4 (Gesprächs-, Wahl-, Weitergabezeiten) und Abend-Invariante belegen; L-3 Gegenstände/Orte-Koordinaten für X3 am Raumgraph prüfen (Teilorte nur innerhalb der Räume); L-4 Weißliste am Kanon prüfen (Kandidat `spur_stirnlampe`, Herausnahme neutraler Bonus-Sätze und des Lachers 20:15; jede herausgenommene Zeile ersetzt ein neuer pfadgleicher Zusatzfund, Z-11 bleibt ≥ 14); L-5 Karte im Querformat verdeckt die Szene (Design-Aufgabe); L-6 Web-Gast im WLAN über den vorhandenen Client; L-7 Fortsetzen nach Nutzungslimit in Kindsitzungen beobachten und ins NACHTPROTOKOLL; L-8 Weg der Sitzungskennung (Abschnitt 0) festhalten.

**Zeitplan je Generation** (einzige Stelle): E = M, wenn M vor `ende` liegt, sonst `ende` − 30 min. Bis E − 2 h Aufträge aller Typen; E − 2 h bis E − 1,5 h nur T- und U-Aufträge, die Laufendes abschließen; ab E − 1,5 h nur Sicherung, Prüfpunkt, Morgenbericht (und BW8, falls dran); nach E nur Abschluss, spätestens E + 30 min Zugende. BW1-Tor spätestens 2 h nach dem grünen BW0-Tor, sonst Kürzungsleiter Stufe 1. BW8 beginnt spätestens E − 6,5 h (phase, Hereinholen, zwei Prüfrunden bis E − 3 h, R, `ziel` spätestens E − 3 h gestartet); sonst NACHT-ENDE mit Restbedarf.

**Zwischenziele:** je Nacht und Achse aus `planung/bollwerk/PLAN.md` §4 (Abweichung > 20 %: neu planen, höchstens zweimal, dann FUER-DEN-NUTZER). Nach Nacht 7 ab B-02 mit U < 10: NACHT-ENDE mit Restbedarf in Nächten.

**Kürzungsleiter** (jede Stufe ins ENTSCHEIDUNGSLOG und als Frage nach FUER-DEN-NUTZER.md; gekürzte Kriterien bleiben rot bis „A<n>: ja“, Abschnitt 6): 1 Streckziel streichen · 2 BW6 kürzen · 3 Umfang 10× nur in den stärksten Achsen (jede Indexachse bleibt ≥ 3×) · 4 nur BW0–BW4 und BW8 (Z-09 bleibt Pflicht; ohne U ≥ 10 NACHT-ENDE mit Restbedarf). Zwei Generationen in Folge ohne Zuwachs bei U und ohne neues grünes Z-Kriterium: NACHT-ENDE „kein Fortschritt“ in FUER-DEN-NUTZER und Morgenbericht.

**Vorlauf fertig:** Ist alles Vorlauf-Mögliche grün gepusht und B-02 weiter offen, setzt du `ZUSTAND: VORLAUF FERTIG`, stellst einen Weckruf auf jetzt + 60 min und endest mit der Zugende-Zeile. Bei jedem Wecken liest du STEUERUNG.md; steht dort ein gültiger B-02-Eintrag, beginnst du BW0, sonst stellst du den nächsten Weckruf (bis zum Fensterende).

## 9. REGELKREISE (jeder mit Höchstzahl)
| Kreis | Ausgang | Höchstzahl |
|---|---|---|
| Nachbesserung einer Variante | grün oder Opus übernimmt / Slot neu | 2 Runden |
| Briefing eines Typs bei Annahme < 30 % in 2 Wellen | Quote ≥ 30 % oder Typ gestrichen | 1 Überarbeitung |
| Gremium mit Spreizung > 2 | Median aus 5 | 1 Zusatzrunde |
| Welle zurück (Ring 8) | neue Welle mit geschärftem Briefing; danach Slot streichen, FUER-DEN-NUTZER | 2 je Slot |
| Tor rot (jede Stufe) | grün; danach nächste Stufe der Kürzungsleiter | 3 Reparaturen oder 2 h je Tor und Phase |
| Neues R in BW8 | Probe-Merge konfliktfrei; sonst NACHT-ENDE mit Konfliktliste | 2 |
| Überlebender Mutant | getötet oder als Lücke ins ENTSCHEIDUNGSLOG | 2 Aufträge je Mutant |
| Eichung D3/F5 gescheitert | 3 Opus-Ersatzrichter, sonst Kriterium rot | 1 |
| Abgelehnter Push (jemand anderes hat gepusht) | holen, zusammenführen, Tor der Phase, erneut; danach LEASE prüfen, bei eigener LEASE NACHT-ENDE mit Ursache | 3 Anläufe |
| Hereinholen von origin/main mit Konflikten | gelöst oder abgebrochen (A-9 §5) | 30 min / 5 Dateien |
| Neu planen bei verfehltem Nachtziel | Plan angepasst | 2, dann FUER-DEN-NUTZER |
| Prüfrunde (A-9 §6) | 2 Runden ohne BLOCKER/MAJOR; danach NACHT-ENDE, offene Befunde in den Morgenbericht | 4 je Generation |
| Verlorener Agent | Ausgabe da oder neu eingereiht | 1 Neueinreihung |
| Welle länger als 3 × geplant | Teilergebnis werten, Fehlendes einreihen | 1 |
| Drossel | Ausfälle ≤ 10 % | halbieren, +25 % nach 30 ruhigen Minuten |

## 10. NEBELKARTE
25 Risiken mit Frühzeichen und Gegenmaßnahme stehen in A-9 §3; dazu für Kontingent, Limits, Sperren und Generationswechsel: Tokenrahmen der Nacht = (Zwischenziel X1 + X3 + X4 + X6 + Zwischenziel X2 ÷ 4) × 61 Tsd. Tokens je Einheit × 1,2 (Haiku und Opus getrennt geführt); ab 70 % nur Aufträge, die ein Z-Kriterium voranbringen; ab 90 % halbierst du die Wellengröße und startest nur noch Aufträge für Z-Kriterien; Leerlauf gibt es nur bei Limit, LIMIT-VORSORGE, Befund-Stopp oder ab 100 % des Rahmens, dann mit Weckruf. Rückgaben je Stunde höchstens 40 (Ereignisbudget); darüber kleinere Wellen mit mehr Varianten je Agent. Generationswechsel ohne Lücke: Zugende-Zeile nur nach gepushtem LAUF.md und PRUEFPUNKT.

## 11. GEDÄCHTNIS, STATUS UND BERICHTE
- Dateien und Vorlagen: A-9 §1. PRUEFPUNKT spätestens alle 30 min und bei jedem Tor (mit `boot_id` und Sperrzähler); FLUG.md vor jedem Agentenstart; NACHTPROTOKOLL stündlich mit `TZ=Europe/Berlin date`; MORGENBERICHT bis M (A-9 §4) mit Kontaktbögen.
- Nach jeder Verdichtung liest du in dieser Reihenfolge: LAUF → KERNKARTE → PRUEFPUNKT → FLUG → STATUS, dann Abschnitt 2.5 und 3 dieses Textes; je FLUG-Zeile prüfst du die Ausgabedatei. Erst danach beginnst du Neues.
- STAND-Zeile am Anfang jeder Antwort: `STAND · G<n> · Phase [V|BW0…BW8] · Abnahme [a] von 35 · U [u]× · Varianten [v] (übernommen [ü]) · Agentenaufrufe [n] · Agenten aktiv [k] · Token [t] · nächster Schritt: […]`.
- Bilder: Kontaktbögen (JPEG ≤ 2.400 px, ≤ 1,5 MB; Vorher/Nachher höchstens 6 Paare; Bewegungsstreifen zusätzlich als animiertes WebP ≤ 3 MB) unter `planung/bollwerk/bilder/<datum>/` mit Zeile in `bilder/INDEX.md` (Zeit, Pfad, sha256, Inhalt, Ansicht). Der Leitstand zeigt sie im Chat; SendUserFile nur zusätzlich. Bilder entstehen nur mit Mitteln ohne fremde Dienste; was ein Bildgenerator liefern müsste, steht als Bildbeschreibung in FUER-DEN-NUTZER.md.
- Dokumente bis MAIN-REIFE: `docs/bollwerk/ANLEITUNG.md` (Start, drei Spielformen, Würfel, Fortsetzen, WLAN, Optionen), `planung/bollwerk/ABSCHLUSSBERICHT.md`, `planung/bollwerk/SPIELTEST.md` (echter Testabend mit Fragebogen), `ARCHIV.md`, `LIZENZEN.md`.

## 12. BEREIT FÜR MAIN
1. Alle Z-Kriterien außer Z-31…Z-35 grün an HEAD.
2. `git fetch origin && git merge --no-ff origin/main -m "Merge origin/main in bollwerk"` nach A-9 §5; Tor `phase`. Vor R und vor jeder Prüfrunde erneut holen; hat sich main bewegt, Schritt 2 wiederholen und die Prüfrunden neu zählen; bricht der Merge ab: NACHT-ENDE, nächste Generation beginnt hier.
3. Zwei Prüfrunden (A-9 §6) ohne bestätigten BLOCKER oder MAJOR.
4. `R=$(git rev-parse HEAD)`; Zeilen `R=<sha40>` und `MAINBASIS=<sha40 von origin/main, in R enthalten>` in LAUF.md; ab jetzt nur Commits unter `planung/bollwerk/`.
5. `dart run tool/bollwerk/bollwerk.dart ziel` → `BOLLWERK GRÜN · ziel · <R>`; Probe-Merge `git merge-tree --write-tree origin/main R` ohne Konflikt; Secret-Scan; `git diff --quiet origin/main R -- .claude`.
6. `ZUSTAND: BEREIT FÜR MAIN`, ABSCHLUSSBERICHT mit einer Belegzeile je Z-Kriterium, Zugende-Zeile mit `Weckruf LEITSTAND`. Hat sich origin/main danach bewegt, baut der Leitstand selbst neu.

## 13. START
Nach START BOLLWERK, in dieser Reihenfolge; jeder Schritt prüft zuerst, ob er schon erledigt ist:
1. STAND-Zeile ausgeben. `BW=$(git rev-parse --show-toplevel)`; ist das Repo flach: `git fetch --unshallow origin`.
2. Branch nach 2.3 Schritt 2. Lies dann LAUF.md, KERNKARTE.md (falls vorhanden), PRUEFPUNKT.md, FLUG.md, STATUS.md und alle Anhänge A-1…A-9.
3. Werkzeugkette, falls `$BW/.werkzeug/flutter/bin/flutter` fehlt (Quelle wie `build.sh`, die einzige erlaubte Download-Quelle außer den Paketquellen): `mkdir -p $BW/.werkzeug/flutter $BW/.werkzeug/pub-cache && curl -sSL -o /home/user/bw-logs/flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.6-stable.tar.xz && echo 'f1631b9c2c8b3529323db412b0d1beacf4a748f8783b0d7cf599a8fd5f461675  /home/user/bw-logs/flutter.tar.xz' | sha256sum -c - && tar -xJf /home/user/bw-logs/flutter.tar.xz -C $BW/.werkzeug/flutter --strip-components=1 && chown -R "$(id -u):$(id -g)" $BW/.werkzeug/flutter && rm /home/user/bw-logs/flutter.tar.xz` (≈ 70–120 s; sha256 aus `releases_linux.json` von Flutter). Dann `tool/bollwerk/env.sh` anlegen (falls fehlend; Inhalt A-2 A4.10), `source $BW/tool/bollwerk/env.sh && flutter --version` (B-01) und `pub get` in allen 8 Paketen (≈ 41 s). `boot_id` in den PRUEFPUNKT. Fehlen die Grundwerkzeuge, legst du sie jetzt an, bevor ein Agent startet: `mkdir -p /home/user/bw-varianten /home/user/bw-logs /home/user/bw-archiv`; `tool/bollwerk/werkzeug_audit.sh` als Kopie von `planung/bollwerk/proben/werkzeug_audit.sh`; `tool/bollwerk/commit.sh` nach dem Muster `tool/hd_commit.sh` (Branch `bollwerk`, Pfadliste, Secret-Scan, Tor der Phase, Zustands-Commits ohne Tor nach 2.5, Push nur `HEAD:refs/heads/bollwerk`); `tool/bollwerk/pool_reset.sh` nach A-2 A4.9.
4. LEASE und FENSTER nach 2.5; KERNKARTE.md nach A-9 §1 anlegen, falls sie fehlt; `ZUSTAND: LÄUFT`; LAUF.md und KERNKARTE.md committen und pushen.
5. STEUERUNG.md und BEFUNDE.md lesen und quittieren; B-02 nach 2.2 prüfen (`bash planung/bollwerk/proben/b02.sh`).
6. Stolperdraht-Startbild: `git ls-remote origin > /home/user/bw-logs/refs-start.txt` (nach dem eigenen LEASE-Push). Erwartete Refs (V-13, A-2 A4.9): main, `bollwerk`, `bollwerk-leitstand`, `bollwerk-plan`, `bollwerk-mc`, `bollwerk-probe`, `bollwerk-rueckweg`, `archiv/*`, `finalisierung-schlosskeller`, `kern-feinkorn`, `nachtlauf/*`, `loop/*`, `claude/*`. Verglichen werden nur Branch- und Tag-Refs (nie Pull-Refs); eine nicht erwartete neue Ref ist nicht rot, sie kommt ins NACHTPROTOKOLL. Zu Beginn von G1 steht `origin/bollwerk` auf P oder einem Vorfahren davon (FUER-DEN-NUTZER §1).
7. Fabrik-Werkzeuge anlegen, falls sie fehlen: `tool/bollwerk/varianten.dart` mit Ringen 1–6 (Port von `proben/fabrik_ringe.py`), `vorrat.dart` (A-6 §4); dann Lichtungsaufgaben anlegen (Abschnitt 8), Vorrat laden, Pool anlegen (A-2 A4.9).
8. Erste Welle starten (bis B-02 höchstens 6 Agenten; FLUG.md vorher schreiben); parallel Torwerkzeug-Bau (Vorlauf) oder BW0 (nach B-02).
9. PRUEFPUNKT und NACHTPROTOKOLL schreiben, committen, pushen.
10. Weiter nach Abschnitt 8 bis zum Fenster-Ende; jeder Zug endet nach 2.5.

# META-PROMPT · BOLLWERK
## Erarbeite den Master-Prompt, mit dem das Schlosskeller-Spiel in einer Nacht um das 10- bis 100-Fache wächst, sichtbar schöner wird und sauber auf main landet

> Diesen Text gibst du Claude (Opus) in Claude Code. Er baut **nicht** am Spiel.
> Claude erarbeitet, misst, prüft und übergibt damit den **Master-Prompt BOLLWERK**, geschätzt in 4–6 Stunden.
> Mit dem Master-Prompt startest du danach den Nachtlauf. Darin orchestriert Opus Tausende Haiku-5.5-Varianten und schützt sie mit einer Prüfmauer.
> Das große Wachstum beginnt erst, wenn der Lauf „Finalisierung Schlosskeller“ fertig ist. Vorher bereitet der Nachtlauf nur vor.
>
> **Dazu gehören drei Anhänge im selben Ordner. Lies sie vollständig, bevor du beginnst:**
> - `META-ANHANG-A-MASTERPROMPT.md`: Was der Master-Prompt enthalten muss. Darin stehen der Wortlaut des Nutzers, seine Entscheidungen, die harten Regeln und der Pflichtinhalt MP-0 bis MP-20.
> - `META-ANHANG-B-FAKTEN.md`: Faktenlage vom 2026-10-09; in M1 nachprüfen.
> - `META-ANHANG-C-MECHANIK.md`: Startentwurf der Spielmechanik für M3.

---

## 0. EINSTELLUNGEN (vor dem Start, durch den Nutzer)

1. Öffne eine **neue** Sitzung in Claude Code (Cloud) mit dem Repo `umutcantezgel-cpu/werwolf_digital_flutter`.
2. Schalte **Ultracode** ein.
3. Stelle in `/config` **„Dynamic workflow size“** auf `unrestricted` (oder `large`).
4. Wähle als Berechtigungsmodus **„Auto“** im Menü neben dem Eingabefeld. Sonst hält jede Rückfrage zu einem Werkzeug den Lauf an, bis du antwortest.
5. Sende diese Nachricht:
   > Hole den Branch `claude/pensive-gates-ajtp7x` (`git fetch origin claude/pensive-gates-ajtp7x`), lies `planung/bollwerk/META-PROMPT.md` und die drei Anhänge daneben vollständig und führe den Meta-Prompt aus.

   Willst du nicht wach bleiben, hänge an: **„Danach direkt START BOLLWERK.“** Dann gelten alle Standardwahlen, und Claude macht nach M8 ohne Pause mit dem Nachtlauf weiter (§4 M8).

Modelle: Orchestrator ist Opus. Arbeiter ist Haiku 5.5: Modellkennung `claude-haiku-5-5`, im Agent-Werkzeug `model: "haiku"`, im Workflow `agent(…, {model: 'claude-haiku-5-5'})`.

---

## 1. AUFTRAG

Du bist der **Prompt-Architekt**. Dein einziges Produkt ist der **Master-Prompt BOLLWERK**. Er liegt in `planung/bollwerk/MASTER-PROMPT.md` auf dem Branch `bollwerk`, mit Anhängen unter `planung/bollwerk/anhang/`.

Mit dem Master-Prompt erreicht ein Nachtlauf (Opus mit Tausenden Haiku-5.5-Varianten) für das Spiel „Spuk im Schlosskeller“ in der App „Mordakte“:
1. **Rundenbasiert spielbar.** Steuerung über Entscheidungen; jede löst eine sichtbare Aktion der Figur aus. Dazu ein starker, offener Würfel. Spielbar als Party an einem Gerät, solo mit Bots und im WLAN. Die App startet im Schlosskeller.
2. **Umfang 10–100×** gegenüber dem Stand nach dem Finalisierungs-Lauf.
3. **Design deutlich schöner** im gewählten Look, belegt mit Bildern und Maßen.
4. **Alles Bestehende archiviert**, Brauchbares wiederverwertet.
5. **Alles sauber auf main.**

Der Master-Prompt muss **für sich allein ausführbar** sein. Ein frischer Opus in einer neuen Sitzung, der nur Master-Prompt, Anhänge und Repo kennt, arbeitet ihn ohne Rückfragen ab, auch nach einer Verdichtung mitten in der Nacht.

Im Meta-Lauf baust du nichts am Spiel. Du erfasst, entwirfst, misst und simulierst, schreibst, lässt gegenprüfen und übergibst. Code ändern, kompilieren und fotografieren darfst du nur in **Wegwerf-Worktrees**, die nie committet werden.

Begriffe stehen in Anhang A3: Variante, Linie, Hoheit, Vorlauf V, Hauptlauf BW0–BW8, T0, M.

---

## 2. WAS DER NUTZER WILL

- **Wortlaut:** Anhang A1. Er kommt unverändert in den Master-Prompt.
- **Feste Entscheidungen BE-01 bis BE-14:** Anhang A2. Kurz:
  - Bild-Look + Leben
  - erst nach dem Finalisierungs-Lauf
  - Umfang 10–100×
  - Design deutlich aufwerten
  - alles sauber auf main
  - Würfel stark (Pech-Garantie, Kanon-Wertung bleibt unberührt)
  - drei Spielformen
  - App-Start im Schlosskeller
  - Bilder in den Chat
  - keine Rückfragen
  - unabhängige Agenten laufen gleichzeitig
  - Druckspiel bleibt
  - Nebel des Krieges ist Pflicht
  - Kanon 1.0 bleibt unantastbar
- **Deutung jedes Wortes:** Anhang A3. Sie ist verbindlich.

Du stellst **keine Fragen**. Was der Nutzer anders sehen könnte, entscheidest du mit Denkprotokoll. In M8 legst du es als **Annahme mit Standardwahl** vor. Der Nutzer kann jede Annahme mit „A<n>: …“ kippen, muss aber nicht.

---

## 3. REGELN DES META-LAUFS

Die harten Regeln für den Nachtlauf stehen in Anhang A4. Für den Meta-Lauf gilt:

1. **Schreiben:**
   - Auf dem Branch `bollwerk` schreibst du nur `planung/bollwerk/**`; Proben und Zählskripte liegen unter `planung/bollwerk/proben/`.
   - Sonst schreibst du nur in eigene Wegwerf-Worktrees (`git -C /home/user/bollwerk worktree add --detach /home/user/bw-meta/<name> <sha>`) und ins Scratchpad.
   - Kein anderer Checkout und kein anderer Worktree wird angefasst.
2. **Git:**
   - Gepusht wird nur `git push origin <sha>:refs/heads/bollwerk`; vorher läuft `bash tool/secret_scan.sh`.
   - Staging nur mit `git add -- <pfade>`.
   - Verboten:
     - Force-Push in jeder Form
     - gelöschte oder verschobene Tags
     - neue Remotes
     - Pushes auf andere Branches, auch nicht auf `claude/pensive-gates-ajtp7x`, das du nur liest
     - `-s ours`, Squash, Rebase
     - Ausführen von `tool/abnahme.dart`
3. **Werkzeuge der Agenten (Haiku und Opus-Unteragenten):** nur Read, Grep, Glob, Write, Edit und Bash; Git nur `status`, `diff`, `log`, `show`. Nie:
   - `mcp__claude-code-remote__*`, `mcp__github__*`
   - Agent, Workflow, SendMessage, TaskStop, Monitor, EnterWorktree, ExitWorktree, Skill
   - WebFetch, WebSearch, Artifact, `mcp__Claude_Docs__*`

   Du selbst nutzt neben den Datei-, Such- und Shell-Werkzeugen nur Agent, Workflow und SendUserFile. Keine Routinen, keine Sitzungen, keine GitHub-API.
4. **Netz:** nur Git mit `origin` und Paketinstallationen für Abhängigkeiten, die das Projekt schon hat. Nichts systemweit installieren. `build.sh` nie ausführen.
5. **Rechenlast:** Web-Build, Chromium, Simulationen und voller Testlauf laufen nur über `flock /tmp/bw-schwer.lock <befehl>`. Jeder Bash-Befehl beginnt mit `source /home/user/bollwerk/planung/bollwerk/proben/env.sh &&`; die Datei setzt PATH auf Flutter und Node.
6. **Umgehungsverbot:** Wird etwas blockiert (Berechtigung, Sandbox, Push), lässt du es weg und trägst es in `FUER-DEN-NUTZER.md` ein. Kein `dangerouslyDisableSandbox`. Keine Änderung an `.claude/**`, `settings*.json`, `CLAUDE.md`, Git-Konfiguration oder Hooks.
7. **Rückfragen:** keine (BE-10). Denkprotokoll ins `ENTSCHEIDUNGSLOG.md`; Gestalterisches mit Standardwahl in `FUER-DEN-NUTZER.md`.
8. **Bilder:** Nur du schickst sie mit SendUserFile in den Chat, als Kontaktbogen mit ≤ 48 Kacheln. Jedes erzeugte Bild ist in einem Bogen.
9. **Rohchat:** `quellen/` kommt nie in den Verlauf. „Passagenprüfung übersprungen“ gilt nicht als bestanden; das kommt ins Log.
10. **Sichern:** Jeder Schritt M0–M7 endet mit Secret-Scan, Commit mit Pfadliste, Push von `bollwerk` und aktualisiertem `PRUEFPUNKT.md`.

---

## 4. ABLAUF (M0–M8)

**Zeitbox:**
- M1–M4 zusammen ≤ 2,5 h.
- M6 standardmäßig 2 Runden, höchstens 4.
- M7 höchstens 3 Durchgänge.

Was offen bleibt, wird zum Nachschub-Auftrag im Vorrat des Master-Prompts, nicht zu einer weiteren Runde.

**Gleichzeitig (BE-11):**
- Unabhängige Agenten startest du in **einer** Nachricht als Hintergrund-Agenten oder in mehreren Workflows nebeneinander.
- Ein einzelner Workflow lässt auf diesem Container nur **2** Agenten gleichzeitig laufen (Anhang B9). Direkte Hintergrund-Agenten liefen zu 8–9 gleichzeitig.
- M2 und M3 laufen gleichzeitig. M4 misst **erst nach** der M3-Synthese, in einem exklusiven Fenster.

**Ablage** in `planung/bollwerk/`:
- `bilder/`
- `proben/` (Skripte mit eigener `pubspec.yaml`)
- `pruefung/` (M6-Befunde, M7-Protokolle)
- `anhang/` (Anhänge des Master-Prompts)
- `belege/`

### M0 · Einrichten
1. `git fetch origin` und Linien mit SHA notieren.
2. `git worktree add -b bollwerk /home/user/bollwerk origin/main`.
3. Darin `git checkout origin/claude/pensive-gates-ajtp7x -- planung/bollwerk`. Damit kommen dieser Meta-Prompt, die Anhänge und das Scratchpad-Archiv auf `bollwerk`.
4. `proben/env.sh`, `ENTSCHEIDUNGSLOG.md`, `STATUS.md`, `PRUEFPUNKT.md` und `FUER-DEN-NUTZER.md` anlegen.
5. Commit und Push.

### M1 · Bestand, Startbedingung, Archiv, Umfangsbasis
1. Starte **gleichzeitig mindestens 9 Leser**, einen je Bereich:
   - Archiv und Linien
   - Look
   - Steuerung und Sitzung
   - Spielkern und Zufall
   - Kanon und Hoheit
   - Prüfwerkzeuge
   - Wiederverwertung
   - Umfangszählung
   - Plattform und Berechtigungen

   Jeder prüft Anhang B für seinen Bereich und meldet Abweichungen mit Beleg.
2. Prüfe selbst 10 % der gemeldeten Fakten nach, mindestens 3 je Bereich. Findest du einen Fehler, wird der Bereich neu erfasst.
3. Prüfe die Startbedingung B-02 mit dem Befehl aus Anhang A6 (MP-2) und notiere den Stand des Finalisierungs-Laufs.
4. Ergebnisse:
   - `ARCHIV.md`: Linie, Ref, SHA, Inhalt, Klasse, Begründung (vier Klassen nach A3)
   - `BESTAND.md`
   - `HOHEIT.md` (vor und nach B-02)
   - `KANON-LUECKEN.md`: je Lücke Beleg, Bestand und Standardwahl
   - `UMFANG-BASIS.md`: Zählskripte in `proben/`, vorläufige Werte, Gewichte g mit Begründung

### M2 · Look-Vertrag, Referenzbilder, Design-Turnier
1. **Referenzbilder:**
   - Wegwerf-Worktree auf `origin/finalisierung-schlosskeller`.
   - Bauen: `flock … flutter build web -t lib/game/dev/preview_main.dart --no-web-resources-cdn -o build/web_party_preview` (≈ 50 s).
   - Fotografieren mit einer Kopie von `foto.mjs` in `proben/` (Import per `createRequire('/opt/node22/lib/node_modules/playwright')`): 7 Räume (`at=` aus der Raummitte in `raeume.json`) × 1280×800 und 390×844 × `phase=investigation|night`.
   - Die Bilder gehen als Kontaktbogen in den Chat.
2. **Look-Anker-Probe** nach MP-14 L6: Paket in `proben/look_anker/`, 1 Raum, 2 Läufe bytegleich. Ebenso eine **Stilprüf-Probe** (`stil.py`, S1–S5) an zwei Referenzbildern.
3. **Design-Turnier:**
   - Mindestens 4 Aufwertungsrichtungen im selben Stil (Anhang A6 MP-8, Qualitätsstufe), je eine Probe als Vorher/Nachher-Ausschnitt im Wegwerf-Worktree, höchstens 60 min je Probe.
   - Alle Proben gehen in den Chat.
   - Ein Gremium mit 5 Linsen bewertet: Look-Treue (Stilprüfung S1–S5), Lesbarkeit am Handy, Atmosphäre, Leistungskosten, Bauaufwand.
4. **Eichsatz** für D3: 18 Bilder, davon 12 mit bekanntem Fehler. Die Lösung bleibt in einer eigenen Datei.
5. **Ergebnis:** `LOOK-VERTRAG.md` und `DESIGN-AUFWERTUNG.md` mit den Zahlen für D1, den Schwellen für S1–S5 (an den Proben geeicht) und der Rangfolge der Richtungen. Die Wahl der Richtung wird **Annahme A-01**, mit Bild.

### M3 · Spielmechanik-Turnier
1. **Entwürfe:**
   - **4 Opus-Agenten** (`model: "opus"`), die einander nicht sehen, schreiben je einen vollständigen Entwurf. Einer davon baut auf Anhang C auf.
   - Dazu mindestens 30 Haiku-Varianten zu Teilfragen: Abstecher-Katalog, Ketten, Würfelschwellen, Pech-Szenen nach C6, Würfelbühne, Rollen-Bots, WLAN-Protokoll, Einstieg.
2. **Richter mit 6 Linsen**, je 0–10:
   - Partyspaß (4–20 Spieler)
   - Solo-Spaß
   - Fairness und Pech-Garantie
   - Kanon-Treue
   - Umsetzbarkeit im Look
   - Wachstum ohne längere Abende
3. **Synthese:** Grundlage ist der Sieger; die besten Ideen der anderen kommen dazu, jeweils mit Begründung. Alle **bindenden** Punkte aus C1–C8 gelten.
4. **Simulationsprobe** in `proben/simulation/` (reines Dart, importiert `mordakte_core` auf `origin/finalisierung-schlosskeller`, ändert nichts):
   - erschöpfender Beweis über Würfelausgänge × 768 Folgen × 4 Pfade × Besetzung 4–20
   - dazu 10.000 Seeds je Pfad
   - Messung aller Schwellen aus C8
   - Verfehlt eine Schwelle, änderst du die Regeln und simulierst neu.
5. **Ergebnis:** `SPIELMECHANIK.md` mit
   - Regeln
   - JSON-Schemas
   - vollständiger Weißliste
   - Aktionskatalog (Aktion → Kanon-Beleg → Animation)
   - drei Beispielrunden, darunter der Abstieg in den Keller
   - Simulationszahlen

### M4 · Durchsatzmessung (Stufenpilot, allein auf dem Rechner)
1. **Bedingung:** Nach der M3-Synthese laufen keine Builds, Simulationen oder anderen Agenten mehr. Im Schwerlast-Slot läuft durchgehend `tool/alle_tests.sh schnell`; das stellt die Nachtlast nach.
2. **Stufen von je 20 min:**
   - (1) 6 direkte Agenten + 2 Workflows à 8 Agenten
   - (2) 12 + 4
   - (3) 18 + 6, nur wenn (2) ohne Einbruch lief

   Einbruch heißt: Ausfälle über 5 %, Dauer-Median 50 % über Stufe 1, Last über 6 oder weniger als 3 GB freier Speicher.
3. **Ein Auftragstyp je Agent:**
   - T: 15 Entscheidungskarten
   - C: ein Code-Paket mit Test und Rot-Probe im Pool-Worktree
   - B: eine Posen-Variante mit Bildlauf
   - U: ein Urteilsbündel über 25 Varianten

   Alle schreiben in Dateien und geben nur eine KURZ-Zeile zurück (A4.9).
4. **Messen je Typ:**
   - Aufträge/h, Varianten/h
   - Dauer (Median, p90)
   - Tokens
   - verwertbar (≥ 8/10 ohne 0; Filterskript `proben/varianten_pruefen.dart` mit `Textpruefer` und `textregeln.json`)
   - Ausfälle (Agenten ohne verwertbare Rückgabe)
5. **Zusätzlich messen:**
   - Opus-Sekunden und Kontextzuwachs je Rückgabe
   - GB je Worktree
   - ob Workflows im Hintergrund laufen, während du arbeitest
   - Berechtigungsnachfragen (Soll 0; jede mit Befehl notieren)
   - Kosten gegen Erwartung
   - Limit-Pausen
6. **Ergebnis:** `DURCHSATZ.md` mit
   - Kapazität je Typ = 0,7 × min(E, F, U, O, S, P, K) (MP-11)
   - Engpass je Typ
   - Nachtziel (Aufträge und Varianten)
   - Tokenrahmen (Haiku und Opus getrennt)
   - je Umfangsachse: ob 10× in einer Nacht rechnerisch erreichbar ist (wenn nicht: Annahme)
   - höchste sichere Stufe

### M5 · Master-Prompt schreiben
- Schreibe `MASTER-PROMPT.md` genau nach Anhang A6 (MP-0 bis MP-20):
  - Hauptteil ≤ 7.000 Wörter, gezählt mit `wc -w`
  - KERN ≤ 400 Wörter oben
  - Anhänge unter `anhang/A-<n>-*.md`, darunter:
    - Wortlaut
    - Schemas, Weißliste
    - Rollenbriefings, Auftragsvorlage
    - Vorrat als Schablonen mit Parameterlisten
    - Kanon-Auszug mit Ketten und Namen
    - TON-LEITFADEN §1–§10
    - Glossar
- Schreibe außerdem:
  - `KERNKARTE.md` (≤ 1.500 Wörter)
  - `VORSCHLAG-FREIGABEN.md`: eine mögliche Freigabeliste für `.claude/settings.json`, falls „Auto“ fehlt. Nur als Vorschlag für den Nutzer, nie angewendet.
  - die Startdateien des Nachtlaufs: `PRUEFPUNKT.md`, `FLUG.md` und `STATUS.md` als Vorlagen
- **Stil:** Deutsch, „du“, kurze Sätze, jede Regel an genau einer Stelle, jedes Kürzel beim ersten Auftreten erklärt, jede Quelle mit Ref und Pfad. Im Master-Prompt heißt MP-n einfach §n. Prüfe jeden §-Verweis mit `grep`.

### M6 · Gegenprüfung bis zur Ruhe
1. **Prüfer:** Je Runde starten **gleichzeitig 10 Prüfer**, jeder mit einer Linse, die den Master-Prompt zu brechen versucht:
   1. Ausführbarkeit (jeder Pfad, Befehl und erste Schritt)
   2. Regeln und Sicherheit (A4 vollständig, Schlupflöcher, Hoheit vor und nach B-02)
   3. Spielentwurf und Fairness (WÜ, Kanon, C1–C8)
   4. Durchhalten (Kapazität, Herzschlag, Verdichtung, Platte, Limits)
   5. Messbarkeit und Bollwerk (Befehl und Schwelle je Kriterium)
   6. Look und Design (Stil-Konstanten, D1–D3)
   7. Umfang und Füllstoff (U, Pflichtziele, keine längeren Abende)
   8. main und Archiv (MP-16, Burgstadt-Schutz)
   9. Spieler und Veröffentlichung (Barrierefreiheit, Fortsetzen, Datenschutz, Einstieg, Store-Liste)
   10. Vollständigkeitskritiker („Was fehlt?“)

   Jeder Befund nennt Schwere (BLOCKER, MAJOR, MINOR), Beleg und Ersatztext.
2. **Bündeln:** Gleiche Befunde legst du zusammen. Befunde, die eine frühere Runde schon bestätigt oder verworfen hat, streichst du.
3. **Skeptiker:** Je Linse prüfen **3 Skeptiker gleichzeitig alle** BLOCKER und MAJOR dieser Linse in einem Auftrag. Ein Befund gilt bei 2 von 3 Stimmen. MINOR arbeitest du ohne Skeptiker ein oder vermerkst sie.
4. **Ruhig** ist eine Runde ohne neuen bestätigten BLOCKER oder MAJOR. Schluss nach 2 ruhigen Runden in Folge, spätestens nach Runde 4. Ist dann ein BLOCKER offen, ist M-12 nicht erfüllt, und er steht in der Übergabe ganz oben.

### M7 · Trockenlauf
Jeder Trockenlauf läuft in einem **frischen Klon** (`git clone --branch bollwerk <origin-url> /tmp/frisch-<n>`), ohne Zugriff auf Scratchpad, `/home/user/wt`, `/home/user/feinkorn` oder lokale Branches.

1. Ein frischer Agent bekommt nur die Startnachricht aus MP-0:
   - Er spielt die ersten 90 Minuten auf dem Papier durch.
   - Er führt die 10 Starthandlungen aus MP-19 in einem Wegwerf-Worktree wirklich aus, ohne Push.
   - Beleg: `belege/meta_trockenlauf.txt`.
2. Ein frischer Agent spielt einen Haiku-Auftrag aus dem Vorrat durch: Vorlage, Werkzeuge, Rückgabe, Paketprüfung.
3. Ein frischer Agent spielt den Vorlauf durch, dazu „B-02 bleibt die ganze Nacht falsch“ und „B-02 wird um 05:00 wahr“.

**Blocker** heißt: ohne Rückfrage nicht ausführbar. Dazu zählen ein fehlender Pfad oder Befehl, ein Exit ≠ 0, zwei Lesarten mit verschiedener Handlung oder ein fehlender Fakt.

Nach jedem Fix prüft ein **neuer** frischer Agent; höchstens 3 Durchgänge. Der Rest kommt als Annahme in die Übergabe.

### M8 · Übergabe
1. **`ANNAHMEN.md`:** die 8 wichtigsten oben, der Rest darunter, je mit Standardwahl und Folge. Mindestens:
   - A-01 Design-Richtung (mit Bild)
   - A-02 Lichtzustand der Runden (Standard: Kanon)
   - A-03 Würfel nie auf Kanon-Punkte
   - A-04 nur Schichten statt neuer Fälle
   - A-05 Spieldauern
   - A-06 Joystick (Standard: im Partymodus aus, sonst unverändert)
   - A-07 WLAN-Host = Detektiv
   - A-08 keine Musik
   - A-09 Gewichte g
   - A-10 Design und Umfang gleichrangig
2. **Sichern:** Commit und Push von `bollwerk`. Eigene Wegwerf-Worktrees entfernen, nur die aus `PRUEFPUNKT.md`.
3. **Chat, in Alltagssprache, ohne Kürzel:**
   1. **Was du bekommst** (5 Zeilen): was das Spiel danach kann, wie stark es wächst, wie es aussieht. Dazu die Kontaktbögen Vorher und Design-Proben.
   2. **Was heute Nacht passiert** (2 Zeilen): Ist die Finalisierung fertig? Wenn nein: „Heute Nacht nur Vorbereitung; das große Wachstum beginnt, sobald schlosskeller-1.0 steht.“
   3. **Was du jetzt tun musst** (≤ 3 Schritte zum Kopieren):
      - neue Sitzung, Ultracode, `/config`, Modus „Auto“
      - Startnachricht: „START BOLLWERK. Führe `git fetch origin` aus, lege den Worktree `/home/user/bollwerk` auf `origin/bollwerk` an, lies `planung/bollwerk/MASTER-PROMPT.md` vollständig und arbeite ihn ab §19 ab.“
   4. **Was du ändern kannst:** die Annahmen als nummerierte Liste. „Antworte z. B. ‚A2: lieber …‘. Ohne Antwort gilt die Standardwahl.“
   5. Dateiliste.
4. **Ist ein BLOCKER offen,** steht er ganz oben.
5. **Autostart:** Hat der Nutzer „Danach direkt START BOLLWERK“ angehängt, schreibst du den PRUEFPUNKT, liest den Master-Prompt vollständig neu und beginnst ohne Pause mit dessen §19 in dieser Sitzung.

---

## 5. ABNAHME DES META-LAUFS

Je Zeile stehen Befehl, Ausgabeauszug und SHA in `planung/bollwerk/ABNAHME-META.md`.

| Nr. | Kriterium | Prüfung |
|---|---|---|
| M-01 | Für sich allein ausführbar | Letzter M7-Durchgang mit 0 Blockern; die 10 Starthandlungen sind wirklich ausgeführt (`belege/meta_trockenlauf.txt`). |
| M-02 | Fakten stimmen | Jede Pfad- und Ref-Angabe im Master-Prompt wird per `git cat-file -e <ref>:<pfad>` bzw. `test -e` geprüft: 0 fehlend (neu markierte ausgenommen). Dazu 20 Zahlenfakten, gezogen per `Rng(Rng.hashString('M-02'))`: 0 Fehler. |
| M-03 | Regeln vollständig | Abgleich gegen namentlich genannte Quellen: `origin/finalisierung-schlosskeller:planung/finalisierung-schlosskeller/MASTER-PROMPT.md` §3, `origin/kern-feinkorn:planung/feinkorn/MASTER-PROMPT.md` §3, `hd/KERN.md` + `hd/rollen/KOPF.md` (auf `origin/claude/pensive-gates-ajtp7x`), `krimidinner/spuk-im-gewoelbe/00_steuerung/MASTER-PROMPT.md`. Ergebnis: 0 fehlende Regeln. |
| M-04 | Nutzerwunsch abgedeckt | Anforderungsmatrix: jeder Satzteil aus A1 und jede BE-Entscheidung → Abschnitt im Master-Prompt; 0 Lücken. |
| M-05 | Spielmechanik belegt | Die Simulation aus M3 erfüllt alle Schwellen aus C8 (Lösbarkeit 100 % mit Würfelbeweis, Wertung unverändert, Bänder, Geiz-Bot, Pfadgleichheit). |
| M-06 | Design-Richtung belegt | ≥ 4 Proben im Chat; Stilprüfung S1–S5 an den Proben gemessen; Gremium geeicht (D3 bestanden) oder Strukturmaße als Ersatz vermerkt. |
| M-07 | Umfang messbar | Zählbefehl je Achse läuft; Gewichte und Pflichtziele festgelegt; Formel MP-7 im Master-Prompt. |
| M-08 | Durchsatz gemessen | `DURCHSATZ.md` mit Werten je Typ, Engpass, Nachtziel, Tokenrahmen und höchster sicherer Stufe. |
| M-09 | Vorrat reicht | Σ Schablonen × Parameter ≥ 1,5 × Nachtkapazität in Aufträgen je Typ; Vorlauf-Vorrat ≥ 8 h; Nachschubwerkzeug beschrieben. |
| M-10 | Bollwerk prüfbar | Jede Schicht L0–L10 hat Befehl, Schwelle, Fallzahl je Modus und Budget. Die Summe je Modus liegt unter dem Modusbudget, gerechnet aus gemessenen Laufzeiten. |
| M-11 | Kriterien messbar | Ein Skript prüft jede BK-Zeile: Befehl in Backticks und Schwelle mit Zahl oder Vergleich. 0 Treffer für „signifikant/deutlich/angemessen/ausreichend/sinnvoll/hochwertig/schön“ ohne Maß im selben Satz. |
| M-12 | Gegenprüfung abgeschlossen | 2 ruhige Runden in Folge, oder nach 4 Runden 0 offene BLOCKER (offene MAJOR mit Folge in ANNAHMEN). |
| M-13 | Hoheit gewahrt | Kein Auftrag im Vorrat berührt vor B-02 einen Pfad außerhalb der Vorlauf-Pfade (Skriptprüfung gegen `HOHEIT.md`). |
| M-14 | Zusammenführung geplant | Je Linie Klasse, Kriterien K1–K7, Reihenfolge, Konfliktregel und Vorfahrtests im Master-Prompt; Probe-Merges aus M1 belegt. |
| M-15 | Form | Hauptteil `wc -w` ≤ 7.000; die Linse „Widerspruch“ in M6 bestätigt 0 Befunde; jede Schwelle steht genau einmal. |
| M-16 | Gesichert | Push auf `bollwerk`; Secret-Scan sauber (übersprungene Passagenprüfung vermerkt); eigene Wegwerf-Worktrees entfernt. |
| M-17 | Übergabe verständlich | Die Chat-Übergabe folgt M8.3, mit kopierbarer Startnachricht und Annahmenliste. |

---

## 6. STAND-ZEILE UND WIEDEREINSTIEG

Jede Antwort im Meta-Lauf beginnt mit:

`STAND · Meta-Lauf [laufende Schritte, z. B. M2+M3] · Prüfrunde [r] · Agenten aktiv [k] · Varianten [v] · nächster Schritt: […]`

**`PRUEFPUNKT.md` enthält:**
- laufende Schritte
- Ergebnisse mit Datei
- laufende Agenten und Workflows mit Kennung, Ausgabedatei und Startzeit
- selbst angelegte Wegwerf-Worktrees
- offene Entscheidungen
- den nächsten Schritt

Du aktualisierst ihn nach jedem Teilschritt und vor jedem großen Agentenstart.

**Nach einer Verdichtung:**
1. `PRUEFPUNKT.md` lesen.
2. In diesem Meta-Prompt §3 und die Abschnitte der laufenden Schritte lesen; bei M5 auch Anhang A6.
3. Laufende Agenten prüfen; nichts doppelt starten.
4. Weitermachen.

---

## 7. START

1. M0 ausführen.
2. M1 starten: alle Leser **gleichzeitig**.
3. Während M1 läuft:
   - den Wegwerf-Worktree für M2 anlegen und bauen
   - die Simulationsprobe für M3 vorbereiten
   - die Pilotaufträge für M4 entwerfen
4. Danach M2 und M3 gleichzeitig, dann M4, M5, M6, M7, M8.

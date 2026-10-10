# BOLLWERK-DAUERLAUF – Plan: alles umsetzen als Loop über die nächsten Tage

## Context
**Ziel:** „Spuk im Schlosskeller“ wird
- rundenbasiert spielbar: Entscheidungen lösen sichtbare Aktionen aus, ein starker Würfel entscheidet über das Gelingen mit, mit zweitem Anlauf oder Umweg, und der Fall bleibt lösbar;
- spielbar als Party an einem Gerät, Solo mit Bots und im WLAN;
- zum Startbildschirm der App;
- 10- bis 100-mal größer und im gewählten Bild-Look deutlich schöner (FEINKORN nur als „Leben“).

Alles Bestehende wird archiviert, Brauchbares wiederverwertet, und am Ende landet alles sauber auf main.

**Ausgangslage:**
- Es gibt unseren Meta-Prompt v2.3 (`planung/bollwerk/`, Commit 3a5765a) und deinen v3 (hochgeladen).
- Du hast entschieden: **v3 ist die Basis, unser Wissen kommt dazu, daraus wird v4.**
- Neu ist dein Wunsch: **Alles läuft als durchgehender Loop über mehrere Tage.**

**Ergebnis:**
- Diese Sitzung wird zum **Leitstand**. Er baut v4, startet in der Cloud zuerst den Meta-Lauf und danach die Nachtläufe als „Generationen“.
- Er überwacht sie, prüft täglich unabhängig gegen, zeigt dir Bilder und Berichte hier im Chat und führt am Ende selbst auf main zusammen.
- Der Loop endet bei ZIEL ERREICHT oder nach den Abbruchregeln.

**Mit der Freigabe dieses Plans erlaubst du dem Leitstand ausdrücklich:**
- Kindsitzungen zu starten, die auf `bollwerk-plan`, `bollwerk` und `bollwerk-mc` pushen
- selbst auf `bollwerk-leitstand` (Steuerung und Zustand), `bollwerk` (einmal anlegen) und `archiv/*` (Archive als Branches) zu pushen
- am Ende per Fast-Forward auf `main` zu pushen, und zwar nur nach allen Toren

Die Plan-Freigabe zitiert der Leitstand wörtlich in LEITSTAND.md. Wird der main-Push trotzdem gesperrt, versucht er ihn nicht in anderer Form, sondern bittet dich um die Nachricht „MAIN BOLLWERK“.

## Architektur
| Rolle | Sitzung | Schreibt | Aufgabe |
|---|---|---|---|
| **Leitstand** | diese | `bollwerk-leitstand` (einziger Schreiber), `archiv/*`, einmalig `bollwerk`, am Ende `main` | v4, Herzschlag, Generationen steuern, Tagesprüfung, Berichte, Bilder, main-Push |
| **Meta** | 1 Kindsitzung | `bollwerk-plan` | v4 ausführen → Master-Prompt und Startpaket |
| **Nachtlauf, Generation n** | genau 1 Kindsitzung zur Zeit | nur `bollwerk` | Master-Prompt abarbeiten: Opus orchestriert Haiku-5.5-Wellen hinter der Prüfmauer |
| **Merge-Bau** | 1 Kindsitzung am Ende | `bollwerk-mc` | MC auf aktuellem main bauen und das volle Tor fahren |

Es gibt keine Werkstatt-Sitzungen und keinen frühen main-Merge. Der Engpass ist das Kontingent, nicht die Rechenleistung.

## L0 – v4 bauen (heute, diese Sitzung, ≈ 2–3 h, Ultracode-Workflows)
1. **Belege** nach `planung/bollwerk/v4/BELEGE.md`:
   - Doku-Prüfung der v3-Betriebsbehauptungen C1–C14: Tags über den Proxy, Auto-Modus-Sperren, /goal, availableModels, Denkstufen von Haiku, Workflow-Gleichzeitigkeit, Nutzungslimit.
   - Lückenanalyse v3 ↔ v2.3.
   - Zwei Erkundungs-Agenten laufen dafür neu, denn die ersten wurden durch deine Unterbrechung abgebrochen.
   - Wo die Doku schweigt, gilt die sichere Annahme. Beispiel: Archive werden Branches statt Tags; es gibt keinen Probe-Tag, denn der ließe sich nicht löschen.
2. **Merge-Karte:**
   - **Gerüst aus v3:** §0–§13, Abläufe statt bedingter Verbote, Fabrikprobe, Kapazität aus Messung, geometrisches Mittel für den Zuwachs, Kaltstart- und Verdichtungsprobe, Umgang mit Sperren.
   - **Inhalt aus v2.3:** Nutzerwortlaut, Entscheidungen BE-01…14, Nie-Liste und Dateihoheit, WÜ-1…6, Burgstadt-Schutz, SR-1…10, Fakten (Anhang B), Mechanik „Würfel stark“ (Anhang C).
3. **Neu für den Loop (Pflicht in v4 und im Master-Prompt):**
   - **Generationen:**
     - Lauf-Sperre `LEASE gen=<n> session=<id> herzschlag=<UTC>` in `planung/bollwerk/LAUF.md` auf `bollwerk`.
     - Zustandszeile `ZUSTAND: LÄUFT | NACHT-ENDE | VORLAUF FERTIG | ZIEL ERREICHT | ABBRUCH <grund>`.
     - Jeder Zug endet mit `=== BOLLWERK-ZUG-ENDE · <ZUSTAND> · Weckruf <UTC> ===`.
   - **Idempotenter Start:**
     - `git fetch origin bollwerk`; ist HEAD ungleich origin/bollwerk: `git checkout -B bollwerk origin/bollwerk`.
     - Jeder Startschritt (Archiv, Messbasis, Vorher-Galerie) prüft zuerst, ob es ihn schon gibt.
   - **Push-Regel:**
     - Der Nachtlauf pusht ausschließlich `bollwerk`. Archive, Tags und main gehören dem Leitstand.
     - Wird ein Push abgelehnt, liest er zuerst LEASE auf origin. Steht dort eine höhere Generation, endet er sofort ohne Merge.
   - **Steuerung:**
     - Der Nachtlauf liest bei jedem Prüfpunkt `origin/bollwerk-leitstand:STEUERUNG.md` (Einträge S-<n>) und `BEFUNDE.md` (F-<n>).
     - Er quittiert mit `QUITTUNG S-<n>/F-<n>` im PRUEFPUNKT.
     - Steuerungen sind nur Schalter, nie Löschaufträge.
   - **B-02 ohne Tag**, denn die Finalisierung ist schon teilweise über Burgstadt in main gemergt (6718650). B-02 gilt, wenn alles zutrifft:
     - `origin/finalisierung-schlosskeller:planung/finalisierung-schlosskeller/ABSCHLUSSBERICHT.md` (oder STATUS) meldet „ZIEL ERREICHT“
     - die Spitze von fin ist Vorfahr von origin/main
     - seit 60 min gibt es keinen Commit in fin-Pfaden
     - PR #43 ist gemergt oder geschlossen

     Sonst gilt nur „FREIGABE BOLLWERK“, nachdem du die Finalisierung angehalten hast.
   - **Nach B-02** holt der Nachtlauf an jedem Phasentor origin/main in `bollwerk`. Die Konfliktzahl aus `git merge-tree` kommt in den Bericht.
   - **Kein main-Push im Master-Prompt.** Der Abschlussschritt des Nachtlaufs heißt „BEREIT FÜR MAIN“.
   - **Sperrdatei** `.claude/settings.json` (availableModels für Opus 5.5 und Haiku 5.5 sowie Erlaubnisregeln für Bauen, Testen und `git push origin HEAD:bollwerk`) nur auf `bollwerk-plan` und `bollwerk`. Ob sie auf main kommt, ist eine Annahme; Standard: nein, sie wird in MC entfernt.
4. **v4 schreiben:**
   - `planung/bollwerk/META-PROMPT.md` (v4) plus überarbeitete Anhänge A, B und C.
   - v2.3 und v1–v3 kommen nach `planung/bollwerk/archiv/` mit Manifest.
5. **Gegenprüfung (Workflow):**
   - 10 Linsen: Ausführbarkeit, Sicherheit, Spiel/Würfel, Durchhalten über Tage, Messbarkeit, Look, Umfang, main/Archiv, Widerspruch, Loop-Schnittstelle.
   - Skeptiker: 3 je BLOCKER, ein Befund gilt bei 2 von 3.
   - Höchstens 2 Runden; Ziel 0 offene BLOCKER.
6. Commit über `tool/hd_commit.sh` auf `claude/pensive-gates-ajtp7x`, dann v4 als Datei an dich.

## L1 – Leitstand einrichten (≈ 30 min)
- **Branch `bollwerk-leitstand`** (von origin/main, nur Planungsdateien unter `planung/bollwerk/leitstand/`):
  - `LEITSTAND.md` ist das Gedächtnis. Es enthält Phase, wörtlich zitierte Freigabe, Routinen-ID, Kind-IDs je Generation, LEASE-Stand, B-02-Zustand, Termine, Tageszähler, offene Befunde und den Ablauf „LEITSTAND ÜBERNEHMEN“ für eine Ersatzsitzung.
  - `STEUERUNG.md` (S-<n>) und `BEFUNDE.md` (F-<n>).
  - Ein eigener Branch, weil Burgstadt `claude/pensive-gates-ajtp7x` periodisch in main merget (0304eb2) und Leitstand-Commits dort sonst auf main landen würden.
- **Herzschlag:**
  - eine `create_trigger`-Routine `BOLLWERK-LEITSTAND-<session_id>`, stündlich, in diese Sitzung
  - nie `create_new_session_on_fire`, denn `delete_trigger` löscht sonst die so gestarteten Sitzungen mit
  - stündlich, damit der 1-h-Prompt-Cache warm bleibt; ein Weckruf mit kaltem Cache würde ≈ 300 k Token neu lesen
  - `send_later` nur für einzelne Termine (Limit-Ende, Phasenwechsel)
  - Änderungen und Löschungen nur über die eigene ID, nie über `list_triggers`
- **Probe:** einmal `fire_trigger`; der Herzschlag-Zug läuft durch.

## L1b – Kinder-Probe (≤ 20 min, Branch `bollwerk-probe`, danach bleibt er als Archiv liegen)
- Eine Kindsitzung (`create_session`, `permission_mode: "auto"`, Modell Opus) mit kleinem Prompt.
- Zu klären:
  - `outcome_branch` auf einem schon bestehenden Branch: setzt sie dort auf und pusht vorwärts?
  - Darf das Kind `send_later` nutzen?
  - Kommt eine `send_message` an?
  - Wie sehen `status_bucket` und `rate_limit_info` im Leerlauf aus, und welcher Modus wurde vererbt?
  - Geht ein Prompt mit 60 KiB durch?
  - Erzeugt die Sitzung von selbst einen PR?
- Ergebnis nach BELEGE.md. **L2 startet erst, wenn alles belegt ist**; Abweichungen passen den Plan an.

## L2 – Meta-Lauf (Kindsitzung, 2–4 h)
- `create_session`: `source_revision: main`, `outcome_branch: bollwerk-plan`, Modell Opus, Auto, Titel „BOLLWERK Meta“. Startnachricht ist der vollständige v4-Text; die Anhänge liest die Sitzung vom Branch.
- Überwachung nach der Tabelle unten.
- Am Ende:
  - Der Leitstand prüft M-01…M-12 und lässt einen frischen Opus-Agenten die Rubrik bewerten (≥ 23/26, keine 0). Dazu kommt eine eigene Kaltstart-Probe.
  - Bilder und Annahmen kommen hierher in den Chat.
  - Es gibt höchstens 1 Nachbesserung; bleibt es unter 23/26, ist **Halt**, und L3 startet nicht.
- Danach legt der Leitstand `bollwerk` einmal auf `origin/bollwerk-plan` an.

## L3 – Nachtlauf-Generationen (Kern des Loops, Tag für Tag)
- **Generation n:** `create_session` mit `source_revision: bollwerk`, `outcome_branch: bollwerk`, Auto und Opus. Startnachricht ist der Master-Prompt-Text plus „START BOLLWERK“.
- **Vor dem Start:**
  - Keine eigene Sitzung arbeitet noch (`get_session`).
  - Die alte Generation ist unterbrochen.
  - LEASE und Kind-ID stehen in LEITSTAND.md.
- **Vorlauf bis B-02:** Der Nachtlauf baut nur in eigenen Pfaden vor. Bei VORLAUF FERTIG startet keine neue Generation, bis B-02 erfüllt ist.
- **Wird B-02 wahr:**
  - S-<n> „B-02 erfüllt“ in STEUERUNG.md.
  - `send_message` an die laufende Generation, sonst eine neue Generation starten.
- **Eine neue Generation gibt es nur bei:** `failed`, einem bestätigten Hänger oder NACHT-ENDE mit offenem Ziel. **Nie wegen eines Limits:** Dann setzt dieselbe Sitzung fort; der Leitstand schickt nach `resetsAt` + 10 min einmal „WEITER BOLLWERK“.
- **Tagesprüfung um 06:00 Berlin** (Leitstand, Workflow):
  - Tagesdiff auf `bollwerk`: Regeln, Kanon, Spielbarkeit, Design anhand der Bilder, Umfang und Füllstoff, main-Reife.
  - Ergebnis F-<n> nach `BEFUNDE.md`.
  - Ein BLOCKER stoppt neue Wellen, bis er quittiert und behoben ist.
- **Morgenbericht um 07:00 Berlin, hier im Chat:** Stand, U je Achse, Vorher/Nachher-Bilder, Kosten des Tages (`usage.cost_usd` aus `get_session`), Risiken, Annahmen zum Kippen.
- **Kontingent:**
  - Bis B-02 läuft der Nachtlauf mit höchstens halber Wellengröße (S-Eintrag), damit die Finalisierung, die Voraussetzung für B-02 ist, nicht ausgebremst wird.
  - Warnt `rate_limit_info` vor einem Wochenlimit, unterbricht der Leitstand die eigene Generation bis `resetsAt`.

## L4 – Zusammenführung auf main
- **Bedingungen:** B-02 erfüllt, alle Z-Kriterien grün, `ZUSTAND: ZIEL ERREICHT` bzw. „BEREIT FÜR MAIN“, und die letzte Tagesprüfung ohne BLOCKER und MAJOR.
- **Ablauf:**
  1. Eine Kindsitzung „BOLLWERK Merge“ (`outcome_branch: bollwerk-mc`) baut MC = `merge --no-ff bollwerk` auf dem aktuellen origin/main.
  2. Sie fährt das volle Tor: alle Tests, Prüfungen, Burgstadt-Schutz, Kanon bytegleich, Secret-Scan, Release-Web-Build, Sperrdatei entfernt.
  3. **Leitstand:** `git fetch`. Hat sich main inzwischen bewegt, merget er neu (MC′) und fährt ein Delta-Tor:
     - Diff MC→MC′ = Diff V→V′
     - schnelles Tor
     - Burgstadt-Schutz
  4. Dann der Fast-Forward-Push `MC′:refs/heads/main` und `archiv/vor-bollwerk` auf V als Branch.
  5. Nach 3 gescheiterten Anläufen gilt BEREIT ZUR INTEGRATION. Der Morgenbericht bittet dich dann um ein Merge-Fenster, also Burgstadt für 1 h anzuhalten.
- Nie Force-Push. Deploy-Hinweis (Netlify, Vercel, Railway) im Bericht. Rückweg nur auf deine Anweisung.

## L5 – Abschluss
- Abschlussbericht mit einer Belegzeile je Z-Kriterium.
- Die eigene Routine wird gelöscht.
- Kindsitzungen bleiben bestehen; das Archivieren machst du.

## Zustandserkennung der Kindsitzungen
| Signal | Bedeutung | Handlung des Leitstands |
|---|---|---|
| LAUF.md `LÄUFT`, Ereignisse jünger als der angekündigte Weckruf + 30 min | arbeitet oder wartet auf eigenen Weckruf | nichts |
| `rate_limit_info.status` ≠ erlaubt | Limit | `send_later` auf `resetsAt` + 10 min → einmal „WEITER BOLLWERK“ an dieselbe Sitzung |
| `blocked` | Rückfrage oder Berechtigung | genauen Wortlaut per PushNotification an dich; Ablauf-Fragen beantwortet er über STEUERUNG.md mit `send_message` |
| Weckruf + 30 min ohne Ereignis und ohne Commit, an 2 Herzschlägen in Folge | Hänger | einmal `send_message`; danach `interrupt_session`, LEASE übernehmen, neue Generation |
| `failed` | Fehler | neue Generation; beim zweiten Fehler in Folge Pause und Meldung |
| `NACHT-ENDE` / `ZIEL ERREICHT` / `VORLAUF FERTIG` | Ende | nächster Schritt nach L3/L4 |

## Herzschlag-Zug (stündlich, knapp gehalten)
1. LEITSTAND.md lesen.
2. `git fetch` und B-02 prüfen.
3. `get_session` je eigener Kind-ID; LAUF.md und PRUEFPUNKT auf `bollwerk` lesen.
4. Handeln nach der Tabelle oben.
5. Neue Bilder vom Branch holen und hier zeigen (vor B-02 nur im Morgenbericht).
6. LEITSTAND.md committen und pushen (nur Planungsdateien: direkter Commit mit Secret-Scan, ohne Schnelltest), bei jedem Wechsel und mindestens alle 3 h.
7. Zug beenden.

**Wiedereinstieg** nach Verdichtung, Pause oder neuem Container: Die Routine weckt den Leitstand. Er liest LEITSTAND.md vom Branch, gleicht jede eigene ID per `get_session` ab und handelt erst danach. Fällt diese Sitzung ganz aus, kann eine neue Sitzung nach dem Ablauf „LEITSTAND ÜBERNEHMEN“ einspringen: alte Routine per ID löschen, eigene anlegen.

## Abbruch- und Pausenregeln
- Meta-Lauf nach 1 Nachbesserung unter 23/26: **Halt** vor L3.
- B-02 bis Tag 5 nicht erfüllt: Der Loop schläft (Herzschlag alle 6 h nur für B-02) und meldet sich mit Bericht.
- Die 7 Tage für BW0–BW8 zählen ab B-02.
- 2 Tage ohne Fortschritt bei U und Abnahme: **Pause** und Meldung.
- Derselbe BLOCKER in 2 Tagesprüfungen: **Pause**.
- Eine Kindsitzung länger als 2 h `blocked`: **Pause** und Meldung.
- main-Merge 3-mal gescheitert: BEREIT ZUR INTEGRATION.
- **Deine Steuerworte hier im Chat:**
  - „STOPP BOLLWERK“: alles unterbrechen, Routine pausieren
  - „WEITER BOLLWERK“
  - „FREIGABE BOLLWERK“: nur nach dem Anhalten der Finalisierung
  - „MAIN BOLLWERK“
  - „A<n>: …“: Annahme kippen

## Sicherheitsregeln
- Fremde Sitzungen (Finalisierung, Nachtlauf Burgstadt, Krimidinner) und fremde Routinen nie anfassen, nur lesen.
- Alle harten Regeln aus v2.3 bleiben: Nie-Liste, Bestandsschutz, Secret-Scan, Rohchat, kein Force-Push, nichts Bestehendes löschen.
- Keine Variablen in der Umgebung „Default“ setzen. Die nutzen auch die anderen Läufe, und `CLAUDE_CODE_SUBAGENT_MODEL` würde deren Unteragenten umstellen. Jeder Agentenaufruf nennt sein Modell selbst.

## Was nur du tun kannst
- Rückfragen zu Berechtigungen in Kindsitzungen beantworten, falls eine Meldung kommt.
- Für einen glatten main-Merge Burgstadt kurz anhalten, falls ich darum bitte.
- Am Ende die Kindsitzungen archivieren.

## Kosten und Zeitrahmen (ehrlich)
- **Kosten:** Diese Sitzung allein steht bei etwa 245 $. Ein mehrtägiger Loop mit Tausenden Haiku-Aufrufen kostet ein Vielfaches und läuft immer wieder ins Fünf-Stunden-Limit. Er wartet dann und macht weiter. Die Tageskosten stehen in jedem Morgenbericht.
- **Finalisierung:** Sie kommt schnell voran (F0–F4 an einem Tag; jetzt F4 von F7, Abnahme 9/17). B-02 ist also in etwa 1–2 Tagen realistisch.
- **Zeitplan:**

| Wann | Was |
|---|---|
| Heute Abend | L0, L1, L1b (≈ 3–4 h), dann L2 (2–4 h) |
| Nacht 1 | erste Generation im Vorlauf |
| Ab B-02 | BW0–BW8 über 2–5 Tage, mit Zwischenziel je Nacht |
| Ende | main |

- **Umfang:** 10× ist in mehreren Nächten realistisch, 100× nicht in einer Woche.

## Verifikation
- **L0:** 0 offene BLOCKER; jede Betriebsbehauptung belegt oder als unsicher markiert.
- **L1/L1b:** `fire_trigger`-Probe läuft durch; alle Fragen der Kinder-Probe beantwortet.
- **L2:**
  - Kindsitzung mit Modell Opus und Modus Auto (`get_session`).
  - `git diff origin/main...origin/bollwerk-plan --stat` zeigt nur `planung/bollwerk/` und die Sperrdatei.
  - Rubrik ≥ 23/26.
- **L3:** Täglich `bollwerk.dart schnell` grün auf `bollwerk`, U steigt, Bilder im Chat, Quittungen für alle S/F.
- **L4:**
  - `git ls-remote origin refs/heads/main` = MC′.
  - Vorfahrprüfung für V, 1145cb9, caf1d61 (falls gemergt) und die Spitze der Finalisierung.
  - Burgstadt-Layout gleich, Kanon bytegleich.

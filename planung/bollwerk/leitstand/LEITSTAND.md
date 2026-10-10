STAND · Leitstand · Phase L3 · Generation 1 (Vorlauf) · B-02 offen · nächster Schritt: G1 überwachen; Tagesprüfung 06:00, Morgenbericht 07:00 Berlin

# LEITSTAND · BOLLWERK-DAUERLAUF

Gedächtnis des Leitstands. Einziger Schreiber: die Leitstand-Sitzung. Branch: `bollwerk-leitstand` (nur `planung/bollwerk/leitstand/**`).
Plan (vollständig): `planung/bollwerk/leitstand/PLAN.md` auf diesem Branch.

## Freigabe (wörtlich)
Der Nutzer hat am 2026-10-09 um etwa 20:30 UTC den Plan „BOLLWERK-DAUERLAUF“ in der Sitzung `session_01Aix28JmFAfTMVcF4Z8bgqP` freigegeben (Plan-Modus, „User has approved your plan“). Der Nutzerauftrag dazu lautete: „erstelle einen plan um alles umzusetzen als loop über die nächsten tage durchgehend“.

Der Freigabeabschnitt im Plan lautet:
> Mit der Freigabe dieses Plans erlaubst du dem Leitstand ausdrücklich: Kindsitzungen zu starten, die auf `bollwerk-plan`, `bollwerk` und `bollwerk-mc` pushen; selbst auf `bollwerk-leitstand` (Steuerung und Zustand), `bollwerk` (einmal anlegen) und `archiv/*` (Archive als Branches) zu pushen; am Ende per Fast-Forward auf `main` zu pushen, und zwar nur nach allen Toren. Wird der main-Push trotzdem gesperrt, versucht er ihn nicht in anderer Form, sondern bittet dich um die Nachricht „MAIN BOLLWERK“.

## Kennungen
| Was | Kennung | Stand |
|---|---|---|
| Leitstand-Sitzung | `session_01Aix28JmFAfTMVcF4Z8bgqP` | aktiv |
| Tagesprüfung/Morgenbericht 10.10. | `trig_01Q5uKrxsfR2D8EBjmy59Z7t` (`send_later`, 04:45 UTC) | geplant |
| Herzschlag-Routine | `trig_01UrDrhXFjttzCW1tkXFPGVr` (Name `BOLLWERK-LEITSTAND-session_01Aix28JmFAfTMVcF4Z8bgqP`, stündlich zur Minute 38) | aktiv |
| Kinder-Probe | `session_01NqNiTSMXk6qK5FVbNAbkrF` (Branch `bollwerk-probe`) | fertig 21:03 UTC |
| Meta-Sitzung | `session_01V8nVEJcaAbNDmTCrmHBoBq` (Branch `bollwerk-plan`, Meta-Prompt v4.1 aus `f2759297c4f5f9a627199b8fe52655f0d3d13e77`) | Übergabe 23:58 UTC: `=== BOLLWERK-META-ENDE · HALT · Runde 3 · 3460ca7e708fd0f74f62a45401f395ae4bedc2fb ===` (M-10: Rubrik 21/26 an der vorletzten Fassung; gelieferte Fassung ungeprüft); Kosten ≈ 116 $ |
| Nachtlauf-Generationen | G1 `session_01J12w9BSCysBqiSdn143rRF` (Titel „BOLLWERK G1“, `source_revision`/`outcome_branch` = `bollwerk`, Master-Prompt aus 2094a67) | gestartet 01:54 UTC, Vorlauf |
| Merge-Bau | – | – |
| Branch `bollwerk` | per Fast-Forward `f84715d..2094a67` auf den Übergabe-SHA gesetzt (01:52 UTC) | Arbeitsbranch der Generationen |
| Übergabe-SHA (Master-Prompt) | `2094a67525cd07526c5e80ab1897e53d3fddac02` (MASTER-PROMPT sha256 6eb7a606…) | unveränderlich auf `bollwerk` |

**Fremd, nie anfassen** (nur lesen): Sitzung „Krimidinner-Produktion“ `session_01Y7GqaaTYTmzoji6hpfHPLj`; die Sitzungen der Finalisierung und des Nachtlaufs Burgstadt (nur über Git sichtbar); jede Routine, deren ID hier nicht steht.

## Phasen
| Phase | Stand |
|---|---|
| L0 v4 bauen | fertig: v4.1 `f275929` (10 Linsen, 6 BLOCKER und ~70 MAJOR eingearbeitet) |
| L1 Leitstand | fertig (Routine aktiv) |
| L1b Kinder-Probe | fertig |
| L2 Meta-Lauf | **abgenommen**: Rubrik Runde 4 an `2094a67` = 23/26 ohne Null (RUBRIK-L2-2094a67.md); F-2 für BW1 offen |
| L3 Generationen | G1 gestartet (Vorlauf) |
| L4 main | offen |
| L5 Abschluss | offen |

## B-02 (Finalisierung fertig, ohne Tag)
Wahr nur, wenn alles zutrifft:
1. `git show origin/finalisierung-schlosskeller:planung/finalisierung-schlosskeller/ABSCHLUSSBERICHT.md` (oder `STATUS.md`) enthält „ZIEL ERREICHT“.
2. `git merge-base --is-ancestor origin/finalisierung-schlosskeller origin/main`.
3. Seit 60 min kein Commit auf `origin/finalisierung-schlosskeller`.
4. PR #43 ist gemergt oder geschlossen (lesend prüfen).
Sonst nur „FREIGABE BOLLWERK“ des Nutzers (nachdem er die Finalisierung angehalten hat).

Letzte Prüfung: 2026-10-10 02:39 UTC · Finalisierung F5 von F7, Abnahme 9/17, letzter Commit ea8d765 (09.10. 23:09 UTC), kein ZIEL ERREICHT · **offen**

## Gezeigte Bilder
- 22:39 UTC · `bilder/meta/m1-bildverfahren-fin-5c83242.jpg` (bollwerk-plan e2b27da)
- 23:39 UTC · `bilder/meta/m3-design-vorher-r1-r2-buffetsaal.jpg`, `m3-streifen-r2-buffetsaal.jpg`, `m3-design-runde2-ostsaal.jpg`, `m3-design-runde2-ausschnitt.jpg`

## Termine (Europe/Berlin)
- Herzschlag stündlich (Routine).
- Tagesprüfung 06:00, Morgenbericht 07:00.

## Herzschlag-Zug
1. Diese Datei lesen (`git fetch origin bollwerk-leitstand && git show origin/bollwerk-leitstand:planung/bollwerk/leitstand/LEITSTAND.md`).
2. `git fetch origin`; B-02 prüfen.
3. `get_session` je eigener Kind-ID; `LAUF.md` und `PRUEFPUNKT.md` auf `origin/bollwerk` lesen.
4. Handeln nach der Tabelle „Zustandserkennung“.
5. Neue Bilder von den Branches holen und im Chat zeigen (vor B-02 nur im Morgenbericht).
6. Diese Datei aktualisieren; bei jedem Wechsel und mindestens alle 3 h committen und pushen (`git add -- planung/bollwerk/leitstand/<datei>`, `bash tool/secret_scan.sh`, `git push origin HEAD:refs/heads/bollwerk-leitstand`).
7. Zug beenden.

## Zustandserkennung
| Signal | Bedeutung | Handlung |
|---|---|---|
| LAUF.md `LÄUFT`, Ereignisse jünger als angekündigter Weckruf + 30 min | arbeitet | nichts |
| `rate_limit_info.status` ≠ erlaubt | Limit | `send_later` auf `resetsAt` + 10 min, dann einmal „WEITER BOLLWERK“ an dieselbe Sitzung |
| `blocked` | Rückfrage/Berechtigung | Wortlaut per PushNotification an den Nutzer; Ablauf-Fragen über STEUERUNG.md + `send_message` |
| Weckruf + 30 min ohne Ereignis und ohne Commit, an 2 Herzschlägen in Folge | Hänger | einmal `send_message`; danach `interrupt_session`, LEASE übernehmen, neue Generation |
| `failed` | Fehler | neue Generation; beim zweiten Fehler in Folge Pause und Meldung |
| `NACHT-ENDE` / `ZIEL ERREICHT` / `VORLAUF FERTIG` | Ende | nächster Schritt nach Plan L3/L4 |

## Ergebnis Kinder-Probe (L1b, 09.10. 21:00–21:03 UTC)
- `outcome_branch` auf bestehendem Branch: Kind startet auf dessen Spitze (flacher Klon, Tiefe 50) und pusht per Fast-Forward (`e937ae2..b8b74fa`). Kein automatischer PR.
- Kennung: `CLAUDE_CODE_REMOTE_SESSION_ID=cse_01NqNi…` ↔ `session_01NqNi…` (gleicher Rest).
- Modus Auto vererbt (`permission_mode: auto`). Vorhanden: Agent, SendUserFile, `send_later`, Workflow (sichtbar).
- Haiku-Hintergrund-Agent läuft ohne Rückfrage (Modell im Protokoll `claude-haiku-5-5`).
- **Workflow startet das Kind nicht:** Das Werkzeug verlangt die Anfrage des Nutzers in eigenen Worten in derselben Sitzung; eine Peer-Nachricht oder Startnachricht genügt nicht. → Meta und Nachtlauf arbeiten mit direkten Hintergrund-Agenten (v4.1 angepasst).
- Die Startnachricht gilt dem Kind als automatischer Auftrag; es führt ihn aus, weil er nur den eigenen Branch beschreibt.
- `send_message` kommt an und wird als Peer-Nachricht behandelt.
- Nicht geprüft: 60-KiB-Prompt (die Startnachricht verweist deshalb auf die Datei), Verhalten am Nutzungslimit.

## Prüfliste für Kindsitzungen (Reihenfolge)
1. `failed` → 2. `rate_limit_info` / letztes Ereignis Limitfehler → 3. `blocked` (nur der Nutzer kann lösen; Wortlaut melden) → 4. Zugende-Zeile mit SHA = origin/bollwerk → 5. Hänger (kein Limit, Weckruf + 30 min überschritten, LEASE-Herzschlag > 90 min).
ZUSTAND → Handlung: NICHT BEGONNEN → G1 starten · LÄUFT → nichts · VORLAUF FERTIG → nach B-02 `send_message` oder neue Generation · NACHT-ENDE → G n+1 zum nächsten Fenster · BEREIT FÜR MAIN → Merge-Bau · ABBRUCH → Meldung, keine neue Generation · ZIEL ERREICHT setzt nur der Leitstand.
Meta-Sitzung: `=== BOLLWERK-META-ZUG · M<n> · <sha> ===` = Zwischenstand; `=== BOLLWERK-META-ENDE · BEREIT|HALT · Runde <k> · <sha40> ===` = Übergabe.

## Abbruch- und Pausenregeln
- Meta-Lauf nach 1 Nachbesserung unter 23/26: Halt vor L3.
- B-02 bis Tag 5 (14.10.) nicht erfüllt: Loop schläft (Herzschlag alle 6 h nur für B-02) und meldet sich.
- 7 Tage für BW0–BW8 ab B-02.
- 2 Tage ohne Fortschritt bei U und Abnahme: Pause und Meldung.
- Derselbe BLOCKER in 2 Tagesprüfungen: Pause.
- Kindsitzung > 2 h `blocked`: Pause und Meldung.
- main-Merge 3-mal gescheitert: BEREIT ZUR INTEGRATION.

## Steuerworte des Nutzers
„STOPP BOLLWERK“ · „WEITER BOLLWERK“ · „FREIGABE BOLLWERK“ · „MAIN BOLLWERK“ · „A<n>: …“

## LEITSTAND ÜBERNEHMEN (Ersatzsitzung)
1. Diese Datei und PLAN.md lesen.
2. Prüfen, dass die alte Leitstand-Sitzung nicht mehr arbeitet (`get_session`).
3. Alte Routine nur über die ID oben löschen (`get_trigger` zeigt den Namen `BOLLWERK-LEITSTAND-<alte session_id>`), eigene anlegen.
4. Kennungen oben ersetzen, committen, pushen; dann Herzschlag-Zug.

## Protokoll
- 2026-10-09 ~20:35 UTC · Plan freigegeben · Branch `bollwerk-leitstand` angelegt.
- 2026-10-09 20:38 UTC · Herzschlag-Routine angelegt.
- 2026-10-09 20:52 UTC · v4 auf `claude/pensive-gates-ajtp7x` (666d569); Gegenprüfung mit 10 Linsen läuft.
- 2026-10-09 20:59 UTC · Sitzung im Modus Auto; Kinder-Probe gestartet.
- 2026-10-09 21:03 UTC · Kinder-Probe fertig (keine Workflows in Kindsitzungen).
- 2026-10-09 21:16 UTC · v4.1 gepusht (f275929).
- 2026-10-09 21:18 UTC · Meta-Lauf gestartet.
- 2026-10-09 21:39 UTC · Herzschlag 1: Meta in M0 (working, kein Limit), `bollwerk-plan` = cf06ca9; B-02 offen (F5 von F7).
- 2026-10-09 22:39 UTC · Herzschlag 2: Meta M0+M1 fertig, M3 läuft; erstes Bild gezeigt; B-02 offen.
- 2026-10-09 23:39 UTC · Herzschlag 3: Meta in M6 (Rubrik 17/26 Zwischenstand); Meta hat `bollwerk` versehentlich angelegt (Heredoc mit Backticks, offengelegt in FUER-DEN-NUTZER §1) – harmlos, Fast-Forward-fähig; 4 Design-Bilder gezeigt; B-02 offen.
- - 2026-10-10 00:39 UTC · Herzschlag 4: Meta fertig mit HALT (21/26 vor letzter Nachbesserung, Kaltstart ohne blockierende Frage, 2 Skeptiker-BLOCKER: einer behoben, einer als A-26); Leitstand startet unabhängige Rubrik an 3460ca7. Master-Prompt 54.843 Byte, sha256 234292126f70a292…
- 2026-10-10 00:57 UTC · Rubrik Leitstand 21/26 (P3, P4, P5, P8, P9 je 1); F-1 und Nachbesserung per send_message an Meta (einzige Runde).
- 2026-10-10 01:39 UTC · Herzschlag 6: Meta-Nachbesserung fertig (2094a67, BEREIT, F-1 quittiert); Rubrik Runde 4 gestartet; B-02 offen.
- 2026-10-10 01:55 UTC · Rubrik Runde 4: 23/26 → L2 abgenommen; `bollwerk` → 2094a67; F-2 (zwei MAJOR für BW1) eingetragen; G1 wird gestartet.
- 2026-10-10 01:54 UTC · G1 gestartet (Vorlauf, Fenster bis M = 06:30 Berlin + 30 min).
- 2026-10-10 02:39 UTC · Herzschlag 7: G1 LÄUFT (LEASE gen=1, Herzschlag 02:34Z, FENSTER M=04:30Z), Tor `schnell --vorlauf` grün, FEINKORN 1145cb9 gemergt mit `feinkorn_leben.dart`, QUITTIERT S=3 F=1; B-02 offen. Tagesprüfung + Morgenbericht per send_later 04:45 UTC (nach Morgenbericht-Datei um 04:30Z).
- Prüfpunkt für L2-Abnahme: Die Meta-Fassung schreibt in FUER-DEN-NUTZER „Merge auf main nur nach menschlicher Freigabe“ – der Plan hat diese Freigabe (Leitstand, nach allen Toren); bei der Abnahme angleichen.

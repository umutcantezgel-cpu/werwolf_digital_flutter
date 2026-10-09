STAND · Leitstand · Phase L0/L1 · Generation 0 · B-02 offen · nächster Schritt: v4 bauen, Herzschlag stellen, Kinder-Probe

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
| Herzschlag-Routine | `trig_01UrDrhXFjttzCW1tkXFPGVr` (Name `BOLLWERK-LEITSTAND-session_01Aix28JmFAfTMVcF4Z8bgqP`, stündlich zur Minute 38) | aktiv |
| Kinder-Probe | `session_01NqNiTSMXk6qK5FVbNAbkrF` (Branch `bollwerk-probe`) | gestartet 20:59 UTC |
| Meta-Sitzung | – | – |
| Nachtlauf-Generationen | – | – |
| Merge-Bau | – | – |

**Fremd, nie anfassen** (nur lesen): Sitzung „Krimidinner-Produktion“ `session_01Y7GqaaTYTmzoji6hpfHPLj`; die Sitzungen der Finalisierung und des Nachtlaufs Burgstadt (nur über Git sichtbar); jede Routine, deren ID hier nicht steht.

## Phasen
| Phase | Stand |
|---|---|
| L0 v4 bauen | läuft |
| L1 Leitstand | fertig (Routine aktiv) |
| L1b Kinder-Probe | läuft |
| L2 Meta-Lauf | offen |
| L3 Generationen | offen |
| L4 main | offen |
| L5 Abschluss | offen |

## B-02 (Finalisierung fertig, ohne Tag)
Wahr nur, wenn alles zutrifft:
1. `git show origin/finalisierung-schlosskeller:planung/finalisierung-schlosskeller/ABSCHLUSSBERICHT.md` (oder `STATUS.md`) enthält „ZIEL ERREICHT“.
2. `git merge-base --is-ancestor origin/finalisierung-schlosskeller origin/main`.
3. Seit 60 min kein Commit auf `origin/finalisierung-schlosskeller`.
4. PR #43 ist gemergt oder geschlossen (lesend prüfen).
Sonst nur „FREIGABE BOLLWERK“ des Nutzers (nachdem er die Finalisierung angehalten hat).

Letzte Prüfung: 2026-10-09 ~20:30 UTC · Finalisierung F4 von F7, Abnahme 9/17, letzter Commit bc9df94 (19:50 UTC) · **offen**

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

# STARTPAKET BOLLWERK · für den Leitstand

## 1. Startnachricht je Generation
Kopfzeile, dann der Verweis auf den Master-Prompt (der Text passt nicht sicher in eine Nachricht; der 60-KiB-Weg ist nicht belegt), dann das Startwort:

> Generation <n> · LEASE nach 2.5 · Leitstand session_01Aix28JmFAfTMVcF4Z8bgqP · Master-Prompt aus <sha40 von bollwerk-plan>
>
> Dein Auftrag ist der Master-Prompt BOLLWERK. Lies ihn vollständig aus dem Checkout von `bollwerk` (`planung/bollwerk/MASTER-PROMPT.md` in Teilen, Anhänge unter `planung/bollwerk/anhang/`), und führe ihn aus. Nach Schritt 2 von Abschnitt 13 (entflacht, auf P) prüfst du mit `git diff --quiet <sha40> HEAD -- planung/bollwerk/MASTER-PROMPT.md planung/bollwerk/anhang`, dass er dem Übergabe-Stand gleicht. Deine Generation ist <n>.
>
> START BOLLWERK

Nach B-02 mit laufender Generation: `send_message` an dieselbe Sitzung mit „B-02 ERFÜLLT · K=<sha40> steht in STEUERUNG.md (S-<n>). WEITER BOLLWERK“.

## 2. Parameter für `create_session` (nur der Leitstand ruft es auf)
| Parameter | Wert |
|---|---|
| Repo-URL | `https://github.com/umutcantezgel-cpu/werwolf_digital_flutter` |
| `source_revision` | `bollwerk` |
| `outcome_branch` | `bollwerk` |
| `model` | `claude-opus-5-5` |
| `permission_mode` | `auto` |
| Titel | `BOLLWERK G<n>` |
| Tag | `bollwerk` |

Vorher: `list_sessions` nach einer laufenden `BOLLWERK G<n>` durchsuchen. Für G1 setzt der Leitstand `bollwerk` per Fast-Forward auf den Übergabe-SHA von `bollwerk-plan`: `git push origin <übergabe-sha40>:refs/heads/bollwerk`. **Hinweis:** `origin/bollwerk` existiert bereits (f84715d, unbeabsichtigt vom Meta-Lauf angelegt, Vorfahr jedes späteren `bollwerk-plan`-Stands, FUER-DEN-NUTZER §1); der Fast-Forward braucht keinen Force-Push. LAUF.md schreibt der Leitstand nie.

## 3. Gebrauchsanleitung für den Nutzer (≤ 10 Zeilen)
1. Der Loop baut jede Nacht in einer eigenen Cloud-Sitzung („BOLLWERK G<n>“) am Schlosskeller weiter: Opus plant und prüft, viele Haiku-Agenten schreiben Varianten, nur Geprüftes kommt ins Spiel.
2. Gearbeitet wird nur auf dem Branch `bollwerk`; main ändert allein der Leitstand nach allen Toren.
3. Morgens liegt `planung/bollwerk/MORGENBERICHT.md` mit Kontaktbögen bereit; der Leitstand zeigt ihn um 07:00.
4. Steuerworte im Leitstand: STOPP BOLLWERK · WEITER BOLLWERK · FREIGABE BOLLWERK (Finalisierung vorher anhalten) · MAIN BOLLWERK · VETO D2 <Bogen> · „A<n>: …“ (Annahme kippen).
5. Nur du kannst: Annahmen kippen, Freigaben für gesperrte Aktionen im Web erteilen, eine Sperrdatei (A-13) beschließen, Store-Schritte (Signatur, Datenschutz, Geräte-Tests) erledigen.
6. Erwartung: 1–2 Vorlauf-Nächte, dann 6–7 Nächte bis U ≈ 10 (Spanne 8,5–11); jede Nacht kostet etwa 25–60 Mio. Agenten-Tokens (Schätzung).
7. Der Hauptlauf beginnt erst, wenn die Finalisierung fertig ist (B-02); vorher baut der Loop Werkzeuge und Vorrat.

## 4. Prüfliste für den Leitstand (Reihenfolge)
1. `get_session`: `failed` → neue Generation; beim zweiten Fehler in Folge Pause und Meldung.
2. `rate_limit_info` (letztes Ereignis Limitfehler, auch bei `failed`) → `send_later` auf `resetsAt` + 10 min, dann einmal „WEITER BOLLWERK“ an dieselbe Sitzung; keine neue Generation.
3. `blocked` → nur der Nutzer im Web kann lösen (`send_message` gilt nicht als Zustimmung); Wortlaut melden.
4. Zugende-Zeile `=== BOLLWERK-ZUG-ENDE · G<n> · <ZUSTAND> · Weckruf <UTC|LEITSTAND> · <sha> ===` mit `<sha>` = `git ls-remote origin refs/heads/bollwerk`.
5. Hänger: kein Limit, Weckruf + 30 min überschritten und LEASE-Herzschlag älter als 90 min → einmal `send_message`, danach neue Generation (die alte erkennt die höhere LEASE und endet).

Handlung je ZUSTAND (aus Abschnitt 2.5): NICHT BEGONNEN → G1 starten · LÄUFT → nichts · VORLAUF FERTIG → nach B-02 `send_message` oder neue Generation · NACHT-ENDE → G n+1 zum nächsten Fenster · BEREIT FÜR MAIN → Merge-Bau (`bollwerk-mc`) · ABBRUCH <grund> → Meldung, keine neue Generation (ein „abgelöst“ einer alten Kennung wird übergangen) · ZIEL ERREICHT setzt nur der Leitstand.

## 5. Keine Sperrdatei, keine Umgebungsvariablen
Die Umgebung „Default“ teilen mehrere Läufe; ob `availableModels` aus der Repo-Datei in der Cloud wirkt, ist nicht belegt (C14); eine Sperrdatei mit `permissions.deny` ist Annahme A-13 (Standard: keine). Die Modellreinheit sichern die Modellangabe je Aufruf und der Protokollbeleg (`grep -o '"model":"[^"]*"' ~/.claude/projects/*/*/subagents/agent-*.jsonl | sort | uniq -c`), das Werkzeugverbot sichern ToolSearch-Verbot und Werkzeug-Audit (Ring 0).

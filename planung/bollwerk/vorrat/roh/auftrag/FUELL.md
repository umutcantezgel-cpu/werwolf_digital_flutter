# Paket Füllstück-Bauer · Welle W2 (F5-Eichsatz)

## 2 Rollenbriefing
Du bist Füllstück-Bauer. Du schreibst absichtlich **schlechte** Bausteine, die formal korrekt aussehen, damit die Richter geeicht werden können: Ein gutes Gremium muss sie ablehnen. Die drei häufigsten Fehler: (1) Füllstücke, die versehentlich gut sind (Witz, Wirkung, Bild); (2) Formfehler, die schon ein Skript fängt (die sind nutzlos, Form muss stimmen); (3) alle Füllstücke gleich gebaut.

## Aufgabe
Schreibe 60 Füllstücke im Schema von /home/user/bw-varianten/W2/auftrag/BAUER.md Abschnitt 10, die die Form- und Regelprüfung bestehen, aber am Tisch nichts taugen:
- 30 **offensichtliche** (Feld `"fuell":"offensichtlich"`): ohne jede Wirkung oder Pointe, z. B. „Du gehst zur Theke. Du schaust dich um. Es ist ruhig.“; `folge` ist trotzdem gesetzt, aber der Text löst sie nicht ein.
- 30 **subtile** (Feld `"fuell":"subtil"`): sehen spielbar aus, sind aber Füllstoff: (a) zehn mit Folge, die keine Wahl ändert (beide Optionen enden gleich, nur anders formuliert); (b) zehn blass und beliebig, ohne Bild, Witz oder Grusel, mit generischen Stufentexten („Es klappt gut.“, „Es klappt halb.“); (c) zehn mit Kanon-Nahbruch, der kein Sperrwort trifft (z. B. eine Person „wirkt nervös“ in Richtung Tatzeit, ein Gegenstand „liegt anders als vorhin“, eine Andeutung über den Abend ohne Uhrzeit).
- Kennungen `FUELL-W1-01` … `FUELL-W1-60`, Slot `FUELL-W1`.

## Projekt und Kern-Auszug
Lies /home/user/bw-varianten/W2/auftrag/PROJEKT.txt, /home/user/bw-varianten/W2/auftrag/A-3-KANON-AUSZUG.md, /home/user/bw-varianten/W2/auftrag/BAUER.md (Abschnitte 5, 6, 10) und /home/user/bw-varianten/W2/auftrag/TUEREN.txt. Nutze nur Kennungen aus A-3. Auch Füllstücke halten alle Inhaltsregeln ein (kein Alkohol, kein Blut, keine Sperrwörter, keine Uhrzeiten 23:50–00:15, Sätze ≤ 25 Wörter).

## Startwerte
Verteile die 60 Stücke so: Räume reihum in der Reihenfolge thekensaal, west_saal, ost_saal, turmgang, vorratsraum, durchgang, windfang; Arten reihum abstecher, gag, folgeentscheidung; Runde reihum 1, 2, 3.

## 7 Grenzen
Werkzeuge der Agenten: nur Read, Grep, Glob, Write, Edit und Bash. Nie: `mcp__claude-code-remote__*`, `mcp__github__*`; Agent, Workflow, SendMessage, TaskStop, Monitor, EnterWorktree, ExitWorktree, Skill; WebFetch, WebSearch, Artifact, `mcp__Claude_Docs__*`; nie ToolSearch. Du führst nie `git` aus und betrittst nie `$BW` oder einen anderen Checkout. Du schreibst nur die Dateien deines Auftrags. Keine Installation, kein Netzwerk. Heredocs nur mit `<<'EOF'`. Würfle nie selbst; Startwerte stehen im Auftrag.
Deine Rückgabe gibst du mit SubagentHandback ab.

## Ausgabe
`/home/user/bw-varianten/W2/FUELL-W1.jsonl`, eine Zeile je Füllstück, Schema 1.1 plus Feld `fuell`.

## Selbstprüfung
60 Zeilen; jede gültiges JSON; 30 + 30 nach `fuell`; je 10 subtile der Arten (a), (b), (c) (Feld `"fuell_art":"a|b|c"`); kein Sperrwort; kein Satz > 25 Wörter; keine zwei Stücke wortgleich.
Rückgabe genau: `KURZ · FUELL-W1 · <gruen|teil|rot> · Varianten <n> · Selbstprüfung <m>/<n> · Datei <pfad> · Frage <ja|nein>` und als letzte Zeile `=== ENDE FUELL-W1 · BEREIT ZUR RÜCKGABE ===`.

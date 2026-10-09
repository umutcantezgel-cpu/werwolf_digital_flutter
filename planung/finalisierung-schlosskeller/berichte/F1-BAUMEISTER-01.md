ABNAHME F1-BAUMEISTER-01 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 1 · Summe 9/10 (E-018)

# Bericht F1-BAUMEISTER-01

## Ergebnis F1-BAUMEISTER-01
- **Blocker:** Der Arbeitsbaum enthält die Basis nicht. `/home/user/werwolf_digital_flutter/.claude/worktrees/wf_cd2b025f-a54-1` (Branch `worktree-wf_cd2b025f-a54-1`, Basis d92a675) hat kein `content/party/`, kein `lib/src/party/` und kein `test/party/kanon_hilfe.dart`. Alles liegt auf `finalisierung-schlosskeller` (Head 4eeb0bd, vier Commits voraus). Ich habe nicht ausgecheckt oder gemergt, weil Git-Schreibbefehle verboten sind. Gearbeitet habe ich in einem `git archive`-Snapshot dieses Branches unter `/tmp/f1-baumeister/repo`. Im Arbeitsbaum ist nichts geändert.
- **Arbeitsbaum:** `/home/user/werwolf_digital_flutter/.claude/worktrees/wf_cd2b025f-a54-1` (unverändert, `git status` leer)
- **Geänderte Dateien (Snapshot, für die Übernahme nach Basis finalisierung-schlosskeller):**
  - `/tmp/f1-baumeister/out/bibel.dart` → `packages/mordakte_core/lib/src/party/bibel.dart`
  - `/tmp/f1-baumeister/out/party_bibel.dart` → `packages/mordakte_core/bin/party_bibel.dart`
  - `/tmp/f1-baumeister/out/story_bibel_test.dart` → `packages/mordakte_core/test/party/story_bibel_test.dart`
  - `/tmp/f1-baumeister/out/STORY-BIBEL.md` → `content/party/schlosskeller/STORY-BIBEL.md` (erzeugt)
- **Analyse:** `No issues found!` (`dart analyze lib bin test` im Snapshot)
- **Tests:** `00:02 +21: All tests passed!` (`dart test test/party`, Snapshot). `--pruefen` gibt Code 0.
- **Rot-Probe:** Zeile 1 von STORY-BIBEL.md auf „# Story-Bibel · Probe“ geändert. Der Test „Story-Bibel ist aktuell“ wurde rot. Danach wiederhergestellt, `cmp` identisch.
- **Umfang STORY-BIBEL.md:** 1355 Zeilen, 150 KB, ohne Zeitstempel (deterministisch).
- **Kapitel und Figuren:** alle 8 Kapitel vorhanden. Detektiv, Opfer und 20 Figuren nach Besetzungsplatz. Kein Story-Text im Code.
- Keine Bilder erzeugt, daher nichts zum Zeigen im Chat.

=== ENDE F1-BAUMEISTER-01 · BEREIT ZUR RÜCKGABE ===

## OFFENE FRAGEN
1. Soll der Worktree auf `finalisierung-schlosskeller` gebracht werden (rebase/merge durch dich), oder sollen die vier Dateien aus `/tmp/f1-baumeister/out/` dort übernommen werden? Im Worktree selbst lege ich nichts ab, weil die Imports ins Leere liefen und die Analyse rot wäre.
2. `plausibilitaet.dart`, `matrixMarkdown`: Koordinaten wie `(24.5|13.5)` in Tabellenzellen brechen die GFM-Tabellen (Spaltenzahl stimmt nicht). Ich habe die Funktion wie vorgegeben unverändert übernommen. Ein Fix (z. B. Semikolon statt Pipe) gehört in den Owner von `plausibilitaet.dart`.
3. Namensmix im Kanon: Die Figurennamen wurden laut E-014 geändert, Texte nutzen teils noch alte Namen. Beispiele: „Merima“ im Lacher `lacher_kamin` (Figur `meryem` heißt „Hana“), „Marek“ (4×, Figur `murat`), „Wojtek“ (11×, Figur `kaan`), „Joanna“ (6×) gegenüber „Johanna“ (1×), „Lejla“ (2×) gegenüber „Leyla“ (1×). Die Bibel gibt beides so aus, wie es im Kanon steht. Angleichen ist Kanon-Sache.
4. Figurenfelder: Über die Vorgabeliste hinaus gebe ich `beweisFarbe` (nur Can) aus. Soll das bleiben?
5. Räume: Einrichtung und Geräusch-Nachbarn stehen nicht in der Kapitelvorgabe und fehlen deshalb in der Bibel.

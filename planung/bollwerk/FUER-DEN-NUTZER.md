# FÜR DEN NUTZER · Meta-Lauf BOLLWERK

## 1. Versehentlich angelegter Branch `bollwerk` (09.10.2026, ≈ 22:57 UTC) – bitte zur Kenntnis
- **Was:** Beim Schreiben eines Anhangs hat ein Shell-Heredoc ohne Anführungszeichen die Backticks im Text als Befehle ausgeführt. Einer davon war `git push origin HEAD:refs/heads/bollwerk`. Dadurch steht `origin/bollwerk` seit ≈ 22:57 UTC auf `f84715dab2780be406ea3f9596617a791e5014e4`.
- **Inhalt:** genau der damalige Stand von `bollwerk-plan` (origin/main 47611d8 plus nur `planung/bollwerk/**`). Kein Spielcode, keine Spieldaten, keine Einstellungsdatei.
- **Folge:** Der Meta-Lauf hat damit seine Grenze „nur `bollwerk-plan` pushen“ einmal verletzt. Er hat nichts gelöscht und nichts erneut versucht. `f84715d` ist Vorfahr jedes späteren `bollwerk-plan`-Stands; der Leitstand kann `bollwerk` beim Start von G1 per Fast-Forward auf den Übergabe-SHA setzen (`git push origin <übergabe-sha>:refs/heads/bollwerk`), ohne Force-Push.
- **Ursache und Gegenmaßnahme:** Genau die Lehre L-01 aus FEINKORN („keine Backticks in Heredocs“). Der Master-Prompt führt sie als harte Regel: Heredocs nur mit `<<'EOF'`; Texte mit Backticks werden mit Write geschrieben.

## 2. Was nur Menschen tun können
(wird in M7 vervollständigt)

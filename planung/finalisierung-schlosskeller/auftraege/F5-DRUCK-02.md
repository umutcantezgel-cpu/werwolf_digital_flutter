F5-DRUCK-02 · Druckprüfer · Bauphase F5 · Kanon v1.0 · Schwierigkeit 2

## Druckprüfer
- **Aufgabe:** prüft die PDFs (A4, Lesbarkeit, abgeschnittener Text, neutrale Codes, Spoiler).
- **Gute Arbeit:** Seite für Seite mit Seitenzahl und Befund; prüft gerenderte Seiten, nicht nur den Quelltext.
- **Häufigste Fehler:** 1) nur die erste Seite prüfen, 2) Spoiler auf Umschlägen oder Deckblättern übersehen, 3) Befund ohne Seitenangabe.

AUFGABE IN EINEM SATZ: Prüfe die gerenderten Seiten des Druckspiels can-n20 Seite für Seite auf A4-Satz, Lesbarkeit, abgeschnittenen Text, neutrale Codes und Spoiler.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

WERKZEUG: Nur lesen. Die Seiten liegen als PNG unter /home/user/werwolf_digital_flutter/tool/e2e/fotos/druck/can-n20/<datei>-<seite>.png (00-spielleitung, 01-detektivbogen, 10-rollenhefte, 11-fassungen, 12-stimmkarten, 20-indizkarten, 21-umschlaege, 90-aufloesung-versiegelt), die PDFs daneben. Ansehen mit dem Read-Werkzeug. Text zum Nachprüfen: pdftotext <pdf> - (nur lesen). Regeln des Drucks: Master 7.14 und /home/user/werwolf_digital_flutter/planung/finalisierung-schlosskeller/F5-ENTWURF-DRUCK.md. Ablauf des Druckspiels: Spielleitung liest vor und zählt; Detektivbogen; Indizkarten verdeckt nach Code; Hinweis-Umschläge nach Auszähltabelle; versiegeltes Auflösungsheft erst nach der Anklage.
GRENZEN: Nichts ändern, keine Git-Befehle außer git status. Höchstens 1.800 Wörter. Geschmack ist kein Befund.
SCHWERE: schwer = Spoiler außen oder in einem offenen Teil, abgeschnittener Text, unlesbar, Druckspiel nicht spielbar (fehlender Code, falscher Verweis); mittel = verwirrende Anleitung, uneinheitliche Bezeichnung; leicht = Feinschliff.

ARBEITSSCHRITTE:
1. Schwerpunkt: großer Satz mit 20 Personen: alle Seiten außer den Rollenheften; aus 10-rollenhefte mindestens die ersten 12 und die letzten 8 Seiten.
2. Prüfe jede Außenseite (Indizkarten links, Umschläge oben, Fassungen erste Seite, Deckblatt des Auflösungshefts): nur Code und neutraler Hinweis? Kein Pfad, keine Qualität, kein Täter?
3. Prüfe Spielleitungsheft und Detektivbogen als offene Teile: Steht dort irgendetwas, das die Lösung oder den Täter verrät?
4. Spiele den Abend auf Papier gedanklich durch: Findet die Spielleitung für jede Stimmen-Summe einen Umschlag, für jede Restmenge einen Vorlesetext, für jeden Kartencode des Bogens eine Indizkarte? Stimmen die Faktarten auf Karten und Bogen überein?
5. Lesbarkeit: abgeschnittene Zeilen, Text über Rändern oder Schnittlinien, zu kleine Schrift (unter etwa 9 pt), Überschrift allein am Seitenende.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht):
## Bericht F5-DRUCK-02
- GEPRÜFT: Dateien und Seiten (Anzahl je Datei)
- BEFUNDE: nummeriert, je Befund: Schwere · Datei und Seite · was zu sehen ist · was erwartet war · kleinste Änderung
- DURCHSPIEL AUF PAPIER: was funktioniert, wo es hakt
- GESAMTURTEIL: freigabefähig ja/nein mit einem Satz
## OFFENE FRAGEN
- (oder „keine“)
SELBSTPRÜFUNG: Jede Datei geprüft? Jede Außenseite angesehen? Jeder Befund mit Seite?
Letzte Zeile exakt: === ENDE F5-DRUCK-02 · BEREIT ZUR RÜCKGABE ===

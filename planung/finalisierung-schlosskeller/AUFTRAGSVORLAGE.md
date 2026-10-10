# Auftragsvorlage (Bauplan §4, feste Reihenfolge)

Jeder Auftrag an einen Unteragenten folgt diesem Aufbau. Aufträge liegen als Datei in `auftraege/<Kennung>.md`, Rückgaben in `berichte/<Kennung>.md` (Berichte) bzw. direkt in den eigenen Dateien (Bau- und Textaufträge).

```
1  Kopfzeile: <Kennung, z. B. F3-AUTOR-07> · <Rolle> · Bauphase F<n> · Kanon v<x.y> · Schwierigkeit <1|2>
2  Rollenbriefing (wortgleich aus ROLLENBRIEFINGS.md)
3  Aufgabe in einem Satz
4  Das Projekt in fünf Sätzen (wortgleich, siehe unten)
5  Kanon-Auszug mit Kennungen (nur was der Auftrag braucht, unveränderlich)
6  Schnittstellen (Typen, Funktionen, Textschlüssel, Dateiformate)
7  Eigene Dateien (nur diese darf der Agent ändern)
8  Grenzen (immer: kein Alkohol, keine Drogen, kein Rauchen, keine Klischees, keine Fachwörter und Zungenbrecher in Spielertexten, alle Figuren erfunden, keine echten Personen/Marken, kein Netz außer Paketverwaltung, nichts außerhalb des Repos, keine Git-Schreibbefehle)
9  Nummerierte Arbeitsschritte mit exakten Mengen
10 Abnahmekriterien und Testweg (Befehle)
11 Ausgabeformular (feste Feldnamen, feste Reihenfolge)
12 Selbstprüfung (Mengen gezählt, Kennungen eingehalten, Grenzen eingehalten, offene Fragen gelistet, Tests gelaufen)
13 Letzte Zeile: === ENDE <Kennung> · BEREIT ZUR RÜCKGABE ===
```

**Eine Rückgabe, eine Nachricht (seit F0, Regelkreis Lernen L-01):** Die gesamte Rückgabe steht vollständig in der letzten Nachricht des Agenten. Zwischenstände in früheren Nachrichten zählen nicht, denn der Workflow übernimmt nur die letzte. Anlass: F0-KONT-01 hatte seinen Bericht auf zwei Nachrichten verteilt.

**Längengrenze (seit F0, L-02):** Jeder Prüf- und Berichtsauftrag nennt eine Obergrenze (Standard 1.800 Wörter). Breite Aufträge werden geteilt; `effort: high` für Prüfungen, `max` nur für eng geschnittene Aufträge.

**Arbeitsbaum (seit F1, L-03):** Code-Aufträge mit eigenem Arbeitsbaum beginnen mit `git checkout --detach <Commit>` (vom Orchestrator genannt). Offene Fragen stehen vor der Endmarke.

**Briefing wortgleich (seit F2, L-04):** Jeder Auftrag stellt das Rollenbriefing wortgleich aus ROLLENBRIEFINGS.md voran, auch bei Prüfaufträgen.

**Prüfaufträge (seit F6, L-06):** Zum Stand reicht `git status`; den Commit nennt der Auftrag. `git log` und andere Git-Befehle sind auch lesend nicht nötig.

**Ohne Arbeitsbaum (seit F2, L-05):** Aufträge, die nur neue Dateien anlegen, laufen direkt im Repo. Der Orchestrator prüft jede Rückgabe selbst nach (Tests, Analyse, `git status`), bevor er committet.

Reicht der Platz nicht: `=== UNTERBROCHEN BEI <Stelle> · WEITER MIT „weiter“ ===`.
Platzhalter wie „usw.“, „analog“ oder „folgt später“ führen zur Ablehnung.

## Das Projekt in fünf Sätzen (wortgleich in jedem Auftrag)
Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

## Paketabnahme (Regelkreis Auftrag)
Fünf Prüfungen zu je 0, 1 oder 2 Punkten:

| Prüfung | 2 Punkte | 0 Punkte |
|---|---|---|
| Funktion | alle Tests und Prüfwerkzeuge grün | ein Test rot oder nicht gelaufen |
| Kanon-Treue | keine offenen Verweise, kein Widerspruch zur Tatmatrix | erfundener lösungsrelevanter Fakt |
| Verzahnung | Regeln aus 7.1 erfüllt (eine Quelle, Ort und Herkunft je Indiz, Spielzustand wählt Baustein) | Story-Text im Code oder Doppelquelle |
| Inhalt | Ton, Inhaltsregeln, Lesbarkeit eingehalten | Verstoß gegen eine Inhaltsregel |
| Grenzen | Dateihoheit eingehalten, keine fremden Abrufe | fremde Datei geändert oder Netzaufruf |

Freigabe ab 8 von 10 Punkten ohne eine 0. Sonst Reparaturauftrag mit Fundstellenliste (Stelle → Problem → Korrektur). Höchstens zwei Nachbesserungen, danach übernimmt der Orchestrator und vermerkt den Grund im ENTSCHEIDUNGSLOG.

Antwortform der Abnahme: `ABNAHME <Kennung> · FREIGEGEBEN | NACHBESSERN | NEU · Funktion x · Kanon x · Verzahnung x · Inhalt x · Grenzen x · Summe x/10` plus Fundstellen.

# Paket Variantenbauer · Fabrikprobe M3 (gemeinsamer Teil)

## 2 Rollenbriefing
Du bist Variantenbauer für das Rundenspiel „Spuk im Schlosskeller“. Du schreibst kleine, spielbare Bausteine einer neuen Schicht über dem festen Kanon. Die drei häufigsten Fehler: (1) Kennungen erfinden, die es im Kanon nicht gibt; (2) etwas Lösungsrelevantes andeuten (wer es war, Fakten zur Tatzeit 23:50–00:15); (3) langweilige Füllsätze ohne Spielwirkung („Du gehst hin. Nichts passiert.“).

## 4 Projekt in fünf Sätzen
Lies /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/auftrag/PROJEKT.txt.

## 5 Kern-Auszug
Lies /tmp/claude-0/-home-user-werwolf-digital-flutter/53b6e71c-ffdd-5b93-8265-4c7d54bac5c4/scratchpad/auftrag/A-3-KANON-AUSZUG.md. Nutze nur Kennungen daraus.
Würfel: 2W6 + Modifikator 0..+2; Erfolg ab 9, Teilerfolg 7–8, Pech bis 6. Pech trifft nur Sachen, Licht und Zeit; jedes Pech endet mit Glück im Unglück (eine Seifenblasen-Marke und ein harmloser, wahrer Satz). Erfolg bringt Zeitgewinn und ggf. einen Zusatzfund aus der Weißliste.

## 6 Qualitätsmaßstab
Jede Variante muss am Tisch Spaß machen (Grusel mit Humor, kindgerecht), eine sichtbare Aktion der Figur haben und sich in mindestens einem spielwirksamen Feld (Ort, Fund, Wissen, Würfelstufe, Aktion, Folgeentscheidung) von allen anderen Varianten unterscheiden. Sätze im Mittel ≤ 14 Wörter, keiner über 25. Die Runde heißt „ihr“, Einzelne „du“, nie „Sie“.
Verboten: Alkohol, Drogen, Rauchen (auch als Witz), Blut, Wunden, Verletzung, Schmerz; Herr Schneider bleibt sitzend mit Kühlpack und wird nie neu verletzt; die Pfeife des Detektivs bläst nur Seifenblasen; keine echten Personen, keine Marken; Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte; keine Flaschen, Stielgläser, Fässer; niemand geht hinaus; Notlaterne, Kerzenständer, Kerzen, offene Flamme sind tabu. Sperrwörter: Merle, Lüddecke, Rojda, Adnan, Kunibert, Burgwart, Speisekammer, Wehrgang, Torhaus, Hofebene, Turm-Fuß, Eisentür, Bienenwachs, benommen, Apfel-Zimt-Punsch, Ayran.

## 6b Lehren aus Runde 1 (Pflicht)
- Jede Variante hat eine **spürbare Folge** aus der Liste „Zugschicht“ in A-3 – auch ohne Wurf. „Nur schauen“ oder „nur gehen“ ohne Folge wird abgelehnt.
- Bei einer Wahl führt **jede Option zu einer anderen Folge** (z. B. Tee bringen → Schneider erzählt einen harmlosen Witz und ihr bekommt eine Marke; Bescheid sagen → Joanna leuchtet beim nächsten Wurf, +1).
- Jede Variante hat **ein Bild, einen Witz oder einen Gruselmoment** in einem Satz (Vorbilder, die Richter mit 9 bewertet haben: „Es sieht eher nach Igel aus.“, „Die Torte schweigt höflich.“, „Das Schild sagt gefühlt: Nein.“).
- Keine Erfindung neuer Spuren, Kratzer, Abdrücke oder Flecken an Kanon-Orten; nie Notlaterne, Kerzen oder Flamme.
- Stufentexte sagen konkret, was passiert (nicht „Ihr gewinnt Zeit.“, sondern „Ihr seid zwei Minuten schneller, weil …“).

## 7 Grenzen
Werkzeuge der Agenten: nur Read, Grep, Glob, Write, Edit und Bash. Nie: `mcp__claude-code-remote__*`, `mcp__github__*`; Agent, Workflow, SendMessage, TaskStop, Monitor, EnterWorktree, ExitWorktree, Skill; WebFetch, WebSearch, Artifact, `mcp__Claude_Docs__*`; nie ToolSearch.
Du führst nie `git` aus und betrittst keinen Checkout. Du schreibst nur deine eine Ausgabedatei. Würfle nie selbst; Startwerte stehen im Auftrag.

## 10 Ausgabeschema (JSONL, eine Variante je Zeile, UTF-8)
{"kennung":"<Slot>-<nn>","slot":"<Slot>","art":"abstecher|folgeentscheidung|text|gag|aktion|element","raum":"<raum-kennung>","ort":"<ort-kennung oder null>","runde":1|2|3|null,"titel":"<≤ 6 Wörter>","text":"<Kartentext 8–40 Wörter>","aktion":{"art":"<aktionsart>","weg":["<ort>"],"pose":"<Pose in ≤ 8 Wörtern>","licht":"<Handy-Licht|Stirnlampe|Raumlicht>","klang":"<Klang in ≤ 4 Wörtern>","dauer_s":<4–12>},"wurf":true|false,"stufen":{"erfolg":"<≤ 25 Wörter>","teil":"<≤ 25 Wörter>","pech":"<≤ 25 Wörter, mit Glück im Unglück>"},"zusatz":"<Weißlisten-Kennung oder null>","kanonbezug":["<kennungen>"]}
Bei wurf=false entfällt "stufen" (null). Felder, die für die Art nicht passen, sind null.

## 11 Selbstprüfung
Zähle: Zeilen = verlangte Zahl; jede Zeile gültiges JSON; jede Kennung aus A-3; kein Sperrwort; kein Satz > 25 Wörter; alle Varianten paarweise verschieden in einem spielwirksamen Feld.

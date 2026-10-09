# META-PROMPT · BOLLWERK
## Schreibe den Master-Prompt für die Nacht, in der das Schlosskeller-Spiel fertig wird

> Diesen Text gibst du Claude (Opus) in Claude Code. Er baut **nicht** am Spiel. Er lässt Claude in 2–4 Stunden
> den **Master-Prompt BOLLWERK** erarbeiten, prüfen und übergeben. Mit diesem Master-Prompt startest du danach
> den Nachtlauf, in dem Opus mit Tausenden Haiku-5.5-Varianten das Spiel finalisiert.

---

## 0. EINSTELLUNGEN (vor dem Start, durch den Nutzer)

- Sitzung: Claude Code (Cloud) mit dem Repo `umutcantezgel-cpu/werwolf_digital_flutter`.
- **Ultracode einschalten.**
- In `/config` den Wert **„Dynamic workflow size“** hochsetzen oder abschalten. Sonst gilt der Richtwert „unter 10 Agenten je Workflow“.
- Orchestrator: Opus. Arbeiter: **Haiku 5.5** (Modellkennung `claude-haiku-5-5`, im Agent-Werkzeug `model: "haiku"`, im Workflow `agent(…, {model: 'claude-haiku-5-5'})`).
- Der Meta-Lauf dauert 2–4 Stunden. Danach legt er dir höchstens 5 offene Entscheidungen vor, jeweils mit Empfehlung.
- Den Nachtlauf startest du mit der Nachricht **„START BOLLWERK“**.

---

## 1. AUFTRAG

Du bist der **Prompt-Architekt**. Dein einziges Produkt ist der **Master-Prompt BOLLWERK**, im Folgenden „der Master-Prompt“. Mit ihm orchestriert ein Opus über eine ganze Nacht Tausende Haiku-5.5-Varianten und finalisiert das Spiel „Spuk im Schlosskeller“ in der App „Mordakte“.

Begriffe:
- **Meta-Lauf:** der Lauf, den dieser Text steuert.
- **Nachtlauf BOLLWERK:** der Lauf, den der Master-Prompt steuert.
- **Variante:** ein von einem Agenten erzeugter Kandidat, der geprüft und bewertet wird. Das kann ein Text, ein Datensatz, Code, ein Test oder ein Bild sein.

Der Master-Prompt muss **für sich allein ausführbar** sein. Ein frischer Opus, der nur den Master-Prompt und das Repo kennt, muss ihn ohne diese Unterhaltung und ohne Rückfragen abarbeiten können, auch nach einer Kontext-Verdichtung mitten in der Nacht.

Du baust im Meta-Lauf nichts am Spiel. Du erfasst, entwirfst, misst, simulierst auf Papier und im Scratchpad, schreibst, lässt gegenprüfen und übergibst.

---

## 2. WAS DER NUTZER WILL

### 2.1 Wörtlich (2026-10-09)
> „kannst du einen Prompt zum generieren eines Promptes entwickeln welcher alles bestehende archiviert und wiederverwertet für das game look alike. Steuerung funktioniert über rundenbasierte folgen von entscheidungen welche den Charakter entsprechende aktionen durchführen lässt wie in den keller gehen sowie ein Luck (Würfel) System für den effekt der entscheidungen manchmal. Der Prompt der dein Prompt entwickeln soll soll dich über Stunden beschäftigt halten so das du die ganze nacht mit tausenden Haikiu 5.5 Varianten in Ulttracode ein Bollwerk schaffen kannst um das game zu finalisieren!“

Übernimm diesen Wortlaut unverändert in den Master-Prompt.

### 2.2 Frühere Entscheidungen des Nutzers (gelten weiter)
- **„Bild-Look + Leben“** (E-F021, Branch `kern-feinkorn`):
  - Der heutige Look der Schlosskeller-Vorschau bleibt die Grundlage.
  - Räume und Figuren werden **nicht** aus Pixel-3D-Blöcken gebaut.
  - FEINKORN-Technik (Physik, Teilchen, Skelett, Material, Klang, Messwerkzeuge) darf nur als „Leben“ im bestehenden Stil dienen.
- **Referenzbild:** `planung/feinkorn/bilder/k0/vorher_buffetsaal.png` auf `origin/kern-feinkorn`. Es ist genau das Bild, das der Nutzer als „sieht gut aus“ geschickt hat: Buffetsaal, Gewölbe, Steinboden, Kerzenleuchter, 20 gezeichnete Figuren, Namensschilder.
- **„zeig mir die bilder immer im chat wenn du welche machst“:** Jedes erzeugte Bild geht in den Chat. Viele Varianten werden zu Kontaktbögen gebündelt.
- **Aus den bisherigen Master-Prompts:**
  - Jede Antwort beginnt mit einer STAND-Zeile.
  - Keine Rückfragen im Nachtlauf.
  - Entscheidungen fallen per Denkprotokoll und kommen ins ENTSCHEIDUNGSLOG.
  - Der Schlussbericht endet mit „ZIEL ERREICHT“ oder „BEREIT ZUR INTEGRATION“.

### 2.3 Deutung der Begriffe (verbindlich; so steht es auch im Master-Prompt)
| Wort des Nutzers | Bedeutung für den Nachtlauf |
|---|---|
| „game look alike“ | Das fertige Spiel sieht aus wie das Referenzbild: dieselben Maler, Farben, dasselbe Licht und dieselbe Iso-Ansicht. Neu dazu kommen nur Aktionen und Einblendungen **im selben Stil**. Gemessen wird gegen Referenzbilder je Raum. |
| „rundenbasierte Folgen von Entscheidungen“ | Spieler steuern **ausschließlich** über Entscheidungen je Runde. Entscheidungen bauen aufeinander auf: Ein Ergebnis öffnet Folgeentscheidungen (Entscheidungsketten). Der Echtzeit-Joystick ist nicht mehr die Steuerung des Spiels. |
| „welche den Charakter entsprechende Aktionen durchführen lässt wie in den Keller gehen“ | Jede Entscheidung löst eine **sichtbare Aktion** der eigenen Figur in der Szene aus, z. B. Weg gehen, Tür öffnen, Treppe hinab, untersuchen, ansprechen, nehmen, verstecken. Es gibt keine Entscheidung ohne Bild. |
| „Luck (Würfel) System … manchmal“ | Bei **einem Teil** der Entscheidungen fällt ein **sichtbarer** Würfelwurf. Er bestimmt die **Wirkung** in Stufen (z. B. Erfolg, Teilerfolg, Pech mit Glück im Unglück), nicht den Zugang zur Lösung. Er ist deterministisch per Seed und protokolliert. |
| „alles bestehende archiviert und wiederverwertet“ | Nichts geht verloren. Jede bestehende Linie steht mit Commit-SHA im ARCHIV. Brauchbares wird gezielt übernommen (mit Quellangabe), der Rest bleibt auf seinem Branch archiviert. |
| „Bollwerk“ | Zweierlei: (1) eine **Prüfmauer** aus Tests, Simulationen, Bildvergleichen und Gegenprüfern, die das Ergebnis absichert; (2) eine **Variantenproduktion** in großer Breite, aus der nur Geprüftes und Bestbewertetes übernommen wird. |
| „tausende Haiku 5.5 Varianten“ | Gezählt werden geprüfte Varianten, nicht Agenten (ein Agent kann viele Varianten liefern). Das Nachtziel leitest du aus **gemessenem** Durchsatz ab (§7). Wunschzahlen gibt es nicht. |
| „die ganze Nacht“ | Mindestens 8 Stunden durchgehend nützliche Arbeit. Ein Auftragsvorrat plus Nachschubregeln sorgt dafür, dass nie Leerlauf entsteht. |

---

## 3. HARTE REGELN

### 3.1 Für den Meta-Lauf
1. Kein Eingriff in App-Code, Pakete, Kanon, Tests, Werkzeuge oder Einstellungen.
2. Schreiben darfst du:
   - `planung/bollwerk/**` (Dokumente),
   - Proben und Messskripte im **Scratchpad** (nicht committet).
3. Git:
   - Lege den Branch **`bollwerk`** aus dem aktuellen `origin/main` an, als eigenen Worktree `/home/user/bollwerk`.
   - Committe dort nur `planung/bollwerk/**` und pushe mit `git push -u origin bollwerk`.
   - Vor jedem Push läuft `bash tool/secret_scan.sh`.
   - Kein Force-Push, keine umgeschriebene Geschichte, keine gelöschten Remote-Branches, keine überschriebenen Tags, keine neuen Remotes.
4. Netzwerk nur für Git mit `origin` und zum Installieren der Abhängigkeiten, die das Projekt schon hat.
5. Keine Rückfragen vor Schritt M8. Unklarheiten entscheidest du per Denkprotokoll und notierst sie in `planung/bollwerk/ENTSCHEIDUNGSLOG.md`.
6. Jedes Bild geht in den Chat.

### 3.2 Für den Master-Prompt (vollständig und möglichst wörtlich übernehmen)
⟨FAKT A: alle harten Regeln aus den drei bisherigen Master-Prompten, wörtlich, mit Quelle – Sicherheit, Git, Stores, Abhängigkeiten, Netz, Release, Secret-Scan, Rohchat, Inhaltsregeln, Dateihoheit, Freigabe main⟩

Neu für BOLLWERK:
- **Glück darf nie die Lösung sperren.** Jedes Schlüsselindiz ist auf jedem Täterpfad ohne Würfelglück erreichbar. Glück verändert Tempo, Kosten und Zusatzwissen.
- **Determinismus:** Derselbe Seed und dieselben Entscheidungen ergeben dasselbe Spielprotokoll, gemessen per Prüfsumme. Es gibt keinen ungeseedeten Zufall in der Spiellogik.
- **Look-Vertrag:** Was §4 als „unverändert“ führt, bleibt Bit für Bit gleich. Das prüfen Golden-Bilder.
- **Rechenlast:** Der Container hat ⟨FAKT: Kerne⟩ Kerne. Schwere Befehle (`flutter test` voll, `flutter build`, Chromium) laufen über eine Sperre (`flock`), höchstens ⟨n⟩ gleichzeitig. Haiku-Agenten erzeugen Text, Daten und Code; schwere Prüfungen startet nur der Orchestrator oder ein ausdrücklich dafür bestimmter Prüfer-Auftrag.

---

## 4. AUSGANGSLAGE (Stand 2026-10-09 abends – in M1 frisch prüfen)

⟨FAKTEN aus der Bestandserfassung: Branches mit SHA und Zweck; Look; Steuerung/Sitzung; vorhandene Runden-/Zufallssysteme; Kanon; Hoheitskarte; Prüfwerkzeuge; Wiederverwertbares; Lehren aus Nachtläufen⟩

---

## 5. ABLAUF DES META-LAUFS (M1–M8)

Arbeite die Schritte in dieser Reihenfolge ab. Parallel läuft, was nicht voneinander abhängt. Starte unabhängige Agenten **gleichzeitig**: als Hintergrund-Agenten in einer Nachricht oder in mehreren Workflows nebeneinander. Ein einzelner Workflow läuft auf diesem Container mit höchstens ⟨FAKT: min(16, Kerne−2)⟩ Agenten gleichzeitig.

### M1 · Bestand und Archivinventar
- Starte mindestens 8 Leser gleichzeitig, je Bereich einer:
  - Archiv, Konventionen und Regeln
  - Look
  - Steuerung und Sitzung
  - Runden-/Zufallssysteme
  - Kanon und Hoheit
  - Prüf-Infrastruktur
  - Wiederverwertung FEINKORN, Burgstadt HD und Nachtlauf
  - Fremd-Branches `loop/*`
- Die Leser arbeiten **nur lesend**. Andere Branches lesen sie nur über `git show`, `git ls-tree` und `git grep`.
- Prüfe selbst eine Stichprobe von 10 % der gemeldeten Fakten nach. Gibt es mehr als 1 Fehler, lässt du den Bereich neu erfassen.
- Ergebnis:
  - `planung/bollwerk/ARCHIV.md` (Tabelle: Linie · Branch · SHA · Inhalt · Klasse *direkt / anpassen / archivieren / verwerfen* · Begründung)
  - `planung/bollwerk/BESTAND.md` (Fakten mit Pfad)
  - `planung/bollwerk/HOHEIT.md` (Pfadmuster → Eigentümer → was BOLLWERK darf)

### M2 · Look-Vertrag und Referenzbilder
- Nimm mit den vorhandenen Werkzeugen Referenzbilder der Schlosskeller-Vorschau auf: je Raum, hochkant und quer (⟨FAKT: Werkzeug und Aufruf⟩).
- Schicke sie als Kontaktbogen in den Chat.
- Schreibe `planung/bollwerk/LOOK-VERTRAG.md` mit drei Teilen:
  - **Unverändert:** Maler, Farben, Licht, Iso-Maß, Zoom, Figurenstil.
  - **Erweiterbar:** neue Aktionen und Posen im selben Stil, Entscheidungskarten, Würfel-Einblendung, Kamerafahrt.
  - **Messung:** Golden-Bilder mit Schwelle sowie Luma- und Farbabgleich gegen die Referenz.

### M3 · Spielmechanik-Turnier
1. **Entwürfe:**
   - Lass mindestens 4 vollständige Entwürfe unabhängig voneinander erstellen (Opus).
   - Lass dazu mindestens 24 Haiku-Varianten zu Teilfragen erzeugen:
     - Rundenstruktur
     - Würfelregeln
     - Pech-Ausgleich
     - Entscheidungskarten zu echten Kanon-Orten
     - Darstellung des Wurfs
2. **Richter:** 5 Linsen bewerten jeden Entwurf von 0 bis 10:
   - Partyspaß (4–20 Spieler)
   - Fairness und Glücksanteil
   - Kanon-Treue
   - Umsetzbarkeit im Look
   - Einzelspiel mit Bots
3. **Synthese:** Nimm den Sieger als Grundlage. Übernimm die besten Ideen der anderen, jeweils mit Begründung.
4. **Simulationsprobe** im Scratchpad, reines Dart ohne App-Code:
   - 10 000 Partien je Täterpfad mit Seeds und Bot-Strategien (zufällig, gierig, vorsichtig).
   - Zu messen:
     - Lösbarkeit (Soll 100 %)
     - Sackgassen (Soll 0)
     - Glücksanteil am Ausgang
     - mittlere Rundenzahl
     - Verteilung der Würfelstufen
     - Anteil der Entscheidungen mit Wurf
   - Reichen die Zahlen nicht, änderst du die Regeln und simulierst neu.
5. Ergebnis: `planung/bollwerk/SPIELMECHANIK.md` mit
   - Regeln
   - Datenmodell (JSON-Schemas) für Entscheidung, Aktion, Wurf und Protokoll
   - Aktionskatalog mit Kanon-Beleg je Aktion
   - drei durchgespielten Beispielrunden, eine davon „in den Keller gehen“
   - Simulationszahlen

### M4 · Durchsatzmessung (Pilot)
- Fahre einen echten Pilot mit typischen Nachtaufgaben:
  - 3 Workflows gleichzeitig mit je 8 Haiku-Agenten
  - dazu 8 direkte Hintergrund-Agenten (`model: "haiku"`)
  - Aufgaben: je Agent 10 Varianten Entscheidungskarten mit strukturierter Ausgabe; 1 Testdatei; 1 Prüfbericht
- Zu messen:
  - Dauer je Agent (Median, 90. Perzentil)
  - tatsächliche Gleichzeitigkeit
  - Varianten je Stunde
  - Ausfälle (null-Ergebnisse)
  - Anteil verwertbarer Varianten (Richterurteil ≥ 7/10)
  - Last auf dem Container (CPU, Platten-Kontingent)
- Leite die **Nachtkapazität** ab: gemessene Rate × geplante Stunden × 0,6 Sicherheitsfaktor.
- Ergebnis: `planung/bollwerk/DURCHSATZ.md`. Die Zahlen gehen als Ziele in den Master-Prompt.

### M5 · Master-Prompt schreiben
- Schreibe `planung/bollwerk/MASTER-PROMPT.md` nach §6. Stil wie die bisherigen Master-Prompts:
  - Deutsch, „du“, nummerierte Abschnitte
  - jede Regel nur einmal
  - feste Vorrangordnung
  - messbare Kriterien
- Hauptteil höchstens 9 000 Wörter; Anhänge sind erlaubt (Aufgabenvorrat, Schemas, Rollenbriefings).

### M6 · Gegenprüfung bis zur Ruhe
- Starte je Runde gleichzeitig **7 Gegenprüfer** mit verschiedenen Linsen. Jeder versucht, den Master-Prompt zu brechen:
  1. Ausführbarkeit: Gibt es jeden Pfad, jeden Befehl, jedes Werkzeug wirklich? Ist jeder erste Schritt eindeutig?
  2. Regeln und Sicherheit: Sind alle harten Regeln da? Gibt es Schlupflöcher? Ist die Dateihoheit gewahrt?
  3. Spielentwurf: Spaß, Fairness, Glücksanteil, Kanon, keine Sackgassen.
  4. Durchhalten über 8 Stunden: Auftragsvorrat, Nachschub, Verdichtung des Kontexts, Wiederaufnahme, Herzschlag, CPU, Platte.
  5. Bollwerk und Messbarkeit: Ist jedes Kriterium mit Befehl und Schwelle prüfbar?
  6. Look-Treue: Kann irgendein Auftrag den Look brechen?
  7. Klarheit: Widersprüche, Mehrdeutigkeit, Vorrang.
- Dazu kommt ein **Vollständigkeitskritiker**: „Was fehlt?“
- Jeder Befund wird von 3 Skeptikern geprüft. Er gilt nur, wenn mindestens 2 ihn bestätigen.
- Bestätigte Befunde arbeitest du ein. Dedupliziere gegen **alle** je gesehenen Befunde.
- Schluss nach 2 Runden ohne neuen bestätigten Befund oder nach 4 Runden. Restbefunde stehen dann begründet im ENTSCHEIDUNGSLOG.

### M7 · Trockenlauf
- Ein frischer Agent bekommt **nur** den Master-Prompt und das Repo. Er spielt die ersten 90 Minuten des Nachtlaufs auf dem Papier durch:
  - jeden Befehl
  - jede Datei
  - jeden Auftrag
  - jede Entscheidung
- Er meldet Blocker, fehlende Fakten, unmögliche oder mehrdeutige Anweisungen.
- Ein zweiter frischer Agent spielt einen Haiku-Auftrag aus dem Vorrat durch, mit Vorlage, Dateihoheit, Rückgabe und 5-Punkte-Prüfung.
- Fixe alles. Danach wiederholst du den Trockenlauf, bis er 0 Blocker hat.

### M8 · Übergabe
- `planung/bollwerk/OFFENE-ENTSCHEIDUNGEN.md` enthält höchstens 5 Fragen, die wirklich der Nutzer entscheiden muss (z. B. Hilfssitzungen in der Cloud, Joystick als Zusatz). Jede Frage hat Optionen, eine Empfehlung und die Folge jeder Option.
- Commit und Push von `planung/bollwerk/**` auf `bollwerk`, mit Secret-Scan davor.
- Chat:
  - Zusammenfassung in 10 Zeilen
  - Dateiliste
  - die offenen Entscheidungen
  - Startanweisung „START BOLLWERK“
- Danach wartest du. Die Antworten des Nutzers arbeitest du in den Master-Prompt ein und pushst erneut. Erst dann ist er fertig.

---

## 6. PFLICHTINHALT DES MASTER-PROMPTS

Der Master-Prompt hat genau diese Abschnitte. Jeder erfüllt die genannten Mindestanforderungen.

**0. EINSTELLUNGEN**
- Ultracode, Workflow-Größe, Modelle (Opus orchestriert, Haiku 5.5 arbeitet)
- Branch `bollwerk`, Worktree, Ordner `planung/bollwerk/`
- erwartete Dauer und Startsatz

**1. NORDSTERN UND ZIELBILD**
- der Wortlaut des Nutzers (§2.1)
- die Deutung (§2.3)
- Referenzbilder je Raum
- ein Absatz „Fertig heißt …“

**2. AUTONOMIE**
- keine Rückfragen
- Denkprotokoll in 5 Schritten: Frage · Optionen · Kriterien nach Vorrang · Entscheidung · Eintrag
- wann der Lauf stoppt und wann er weitermacht

**3. GRENZEN UND VORRANG**
- alle harten Regeln (§3.2)
- Vorrangordnung: Sicherheit und Regeln › Inhaltsregeln und Kanon › Lösbarkeit und Fairness › Look-Treue › Handyleistung › Umfang und Politur

**4. ARCHIV UND WIEDERVERWERTUNG**
- Tabelle aus `ARCHIV.md` mit SHA
- Verfahren: Übernahme nur per Commit mit Quellangabe `aus <branch>@<sha>:<pfad>`; nichts löschen; Archivlinien bleiben auf ihren Branches; `ARCHIV.md` wird fortgeschrieben

**5. SPIELENTWURF** (aus `SPIELMECHANIK.md`)
- Rundenablauf
- Entscheidungsketten
- Aktionskatalog mit Kanon-Beleg und Animation je Aktion
- Würfelsystem: Würfel, Schwellen, Modifikatoren, Stufen, Pech-Ausgleich, Transparenz, Seed und Protokoll
- Fairnessgrenzen
- Einzelspiel mit Bots
- Partymodus/Host gemäß Bestand
- Bedienung im Look: Entscheidungskarten, Würfel-Einblendung, Lesbarkeit hochkant und quer
- JSON-Schemas
- drei Beispielrunden

**6. ARCHITEKTUR UND DATEIPLAN**
- neue Dateien und Ordner
- jeder Eingriff in Bestandsdateien mit Begründung
- Hoheitskarte
- Schalter und Rückfallweg
- was nie in die Veröffentlichung darf (Werkzeuge, Prüfstand)

**7. ROLLEN UND AUFTRÄGE**
- Rollen: Opus-Orchestrator und mindestens 10 Haiku-Rollen, darunter Regelwerker, Kartenschreiber, Aktionsanimator, Würfelmeister, Simulant, Testschreiber, Szenenprüfer, Kanonwächter, Sprachprüfer, Bestandswächter, Leistungsprüfer, Gegenprüfer
- je Rolle ein Briefing
- Auftragsvorlage mit Kopfzeile, Dateihoheit, Eingaben, Ausgaben, Prüfbefehlen und Endzeile `=== ENDE [Kennung] · BEREIT ZUR RÜCKGABE ===`
- 5-Punkte-Prüfung je Rückgabe: Regeln, Kanon, Look, Tests, Qualität, je 0–2; Abnahme bei ≥ 8/10 ohne eine 0

**8. ORCHESTRIERUNG UND SKALIERUNG**
- Muster: Varianten-Turnier (N Haiku-Varianten → automatische Filter → Haiku-Richtergremium mit 3 Linsen → Opus wählt und führt zusammen → Tests), Pipeline, Schleife bis Ruhe, gegnerische Prüfung, Vollständigkeitskritiker
- Kapazitätsplan aus `DURCHSATZ.md`: gleichzeitige Workflows, direkte Agenten, Varianten je Aufruf
- Wellenplan je Stunde
- Zähler für Varianten und Agentenaufrufe
- Wiederaufnahme: `runId`, `journal.jsonl`, PRÜFPUNKT
- Isolation: Worktree je schreibendem Parallelauftrag; nur Opus führt zusammen
- CPU-Sperre und Platten-Kontingent
- Herzschlag (§7.4)
- Fehlerregeln: null-Ergebnis → einmal neu; zweiter Ausfall → Eintrag ins NACHTPROTOKOLL

**9. BAUPHASEN MIT TOREN**
- B0 bis B7 (Vorschlag):
  - B0: Grundlage und Archiv
  - B1: Regelkern und Würfel
  - B2: Entscheidungen und Aktionen im Look
  - B3: Inhalte aus dem Kanon
  - B4: Bots, Mehrspieler, Sitzung
  - B5: Leben und Politur
  - B6: Bollwerk voll und Leistung
  - B7: Integration
- Je Phase: Ziel, Aufträge, Torkriterien, Push von `bollwerk` mit Secret-Scan

**10. AUFTRAGSVORRAT UND NACHSCHUB**
- Mindestens so viele konkrete Aufträge, wie die gemessene Kapazität in 8 Stunden schafft. Sie liegen im Anhang, jeder mit Kennung, Rolle, Hoheit und Prüfung.
- **Nachschubregeln:** Aus Lücken, Befunden, Testfehlern und Kriterien entstehen neue Aufträge, sodass nie Leerlauf entsteht.
- Wird der Vorrat vor dem Morgen leer, läuft der Vollständigkeitskritiker. Seine Befunde sind der nächste Vorrat.

**11. BOLLWERK (Prüfschichten)**
Jede Schicht hat Befehl, Schwelle, Laufzeit und Häufigkeit:
- L1: Einheits- und Eigenschaftstests für Regelkern und Würfel
- L2: Simulation von ≥ 10 000 Partien je Täterpfad mit Seeds; Lösbarkeit 100 %, Sackgassen 0, Glücksanteil in Grenzen
- L3: Determinismus-Prüfsummen der Spielprotokolle
- L4: Golden-Bilder gegen den Look-Vertrag
- L5: Widget- und Ablauftests der Entscheidungsbedienung
- L6: Ende-zu-Ende im Browser (Vorschau, hochkant und quer, Geräteklassen)
- L7: Inhalts- und Kanonprüfung: verbotene Inhalte, keine neuen Fakten, Sprache
- L8: Bestands-, Release- und Secret-Prüfung
- L9: Gegenprüfer-Gremien

**12. ABNAHMEKRITERIEN**
- B-01 … B-nn, jedes messbar mit Methode, Schwelle und Beleg; keine Wörter wie „schön“ oder „gut“ ohne Maß.
- Mindestens abgedeckt:
  - Steuerung nur über Entscheidungen
  - jede Entscheidung mit sichtbarer Aktion
  - Würfel nur bei einem festgelegten Anteil
  - Lösbarkeit
  - Determinismus
  - Look-Treue
  - Leistung ≥ Messbasis
  - alle Tests grün
  - Bestand unverändert, wo verlangt
  - Inhaltsregeln
  - Archiv vollständig

**13. NEBELKARTE**
- mindestens 12 Risiken mit Gegenmaßnahme und Frühzeichen, z. B. Kollision mit dem Finalisierungs-Lauf, Kontextverdichtung, CPU-Engpass, Haiku-Qualität, Glücksfrust, Look-Bruch, Plattenlimit

**14. STATUS UND DISZIPLIN**
- STAND-Zeile: `STAND · Bauphase B[n] von B7 · Abnahme [a] von [N] · Aufträge [fertig] von [gesamt] · Varianten [v] · Agenten aktiv [x] · Bildzeit Geräteklasse mittel [ms] · nächster Schritt: […]`
- STATUS
- PRÜFPUNKT (bei jedem Blockende aktuell)
- NACHTPROTOKOLL (stündlich)
- MORGENBERICHT
- Bilder als Kontaktbögen in den Chat
- Commits nur grün und mit genannten Pfaden

**15. START**
- die ersten 10 Handlungen des Nachtlaufs, Schritt für Schritt

**16. ENDE**
- „ZIEL ERREICHT“, wenn alle Kriterien erfüllt sind und 2 Prüfrunden nichts mehr finden
- sonst „BEREIT ZUR INTEGRATION“ mit Restliste
- Morgenbericht für den Nutzer: was neu ist, Bilder, Zahlen, offene Punkte

---

## 7. SKALIERUNG – „tausende Haiku-Varianten“ ehrlich erreichen

### 7.1 Was gemessen ist
⟨FAKT: Kerne; Workflow-Grenze min(16, Kerne−2) gleichzeitige Agenten je Workflow; höchstens 1000 Agenten je Workflow-Lebensdauer; am 2026-10-09 liefen 8 direkte Hintergrund-Agenten gleichzeitig⟩

### 7.2 Hebel (in dieser Reihenfolge nutzen)
1. **Varianten je Aufruf bündeln.** Ein Haiku-Agent liefert 10–25 Varianten in strukturierter Ausgabe, z. B. Entscheidungskarten, Würfeltabellen, Texte oder Testfälle.
2. **Mehrere Workflows gleichzeitig** im Hintergrund, jeder mit eigener Grenze.
3. **Direkte Hintergrund-Agenten** (`model: "haiku"`) zusätzlich, für Aufträge mit eigener Dateihoheit.
4. **`effort: 'low'`** für mechanische Arbeit. Opus urteilt nur, wo es nötig ist: Synthese, Abnahme, Konflikte.
5. **Hilfssitzungen in der Cloud** nur, wenn der Nutzer in OFFENE-ENTSCHEIDUNGEN zustimmt. Dann gilt:
   - eigener Branch `bollwerk-hilfe-<n>` je Hilfssitzung
   - keine Pushes auf `bollwerk` oder `main`
   - der Orchestrator führt zusammen
   - am Ende werden die Hilfssitzungen archiviert

### 7.3 Zählen und Zielsetzung
- Varianten = geprüfte Kandidaten mit Richterurteil.
- Beide Zähler stehen in der STAND-Zeile und stündlich im NACHTPROTOKOLL: Varianten und Agentenaufrufe.
- Das Nachtziel stammt aus `DURCHSATZ.md`. Weicht die Rate nach 2 Stunden um mehr als 30 % ab, passt du das Ziel an und trägst es ins Log ein.

### 7.4 Durchhalten
- Wartende Hintergrund-Arbeit weckt den Orchestrator von selbst. Polling mit `sleep` gibt es nicht.
- **Sicherheitsnetz:** Solange Arbeit läuft, setzt der Orchestrator eine Selbsterinnerung mit `send_later` alle 45 Minuten. Jede neue Aktivität verschiebt sie. Am Ende werden alle offenen Erinnerungen gelöscht.
- **Kontextverdichtung:** Der Zustand lebt in Dateien (PRÜFPUNKT, STATUS, Vorrat, Journal), nie nur im Kopf. Nach jeder Verdichtung liest der Orchestrator zuerst den PRÜFPUNKT.

---

## 8. ABNAHME DES META-LAUFS

| Nr. | Kriterium | Prüfung |
|---|---|---|
| M-01 | Master-Prompt für sich allein ausführbar | Trockenlauf M7 mit 0 Blockern |
| M-02 | Fakten stimmen | 10 zufällige Fakten mit Pfad bzw. SHA nachgeprüft, 0 Fehler |
| M-03 | Harte Regeln vollständig | Abgleichliste gegen die drei bisherigen Master-Prompts, 0 fehlende |
| M-04 | Wunsch des Nutzers abgedeckt | Anforderungsmatrix: jeder Satzteil aus §2.1 → Abschnitt im Master-Prompt |
| M-05 | Spielmechanik belegt | Simulationszahlen in `SPIELMECHANIK.md` (Lösbarkeit 100 %, Sackgassen 0, Glücksanteil und Rundenzahl genannt) |
| M-06 | Durchsatz gemessen | `DURCHSATZ.md` mit Messwerten und abgeleitetem Nachtziel |
| M-07 | Vorrat reicht | Aufträge ≥ Kapazität für 8 Stunden, dazu Nachschubregeln |
| M-08 | Bollwerk prüfbar | jede Schicht mit Befehl, Schwelle und Laufzeit |
| M-09 | Kriterien messbar | kein Kriterium ohne Methode und Schwelle |
| M-10 | Gegenprüfung abgeschlossen | 2 ruhige Runden oder 4 Runden mit begründetem Rest |
| M-11 | Hoheit gewahrt | kein Auftrag berührt fremde Dateien (Abgleich mit `HOHEIT.md`) |
| M-12 | Form | Hauptteil ≤ 9 000 Wörter, 0 Widersprüche (Klarheitsprüfer) |
| M-13 | Offene Entscheidungen | höchstens 5, jede mit Empfehlung |
| M-14 | Gesichert | Push auf `bollwerk`, Secret-Scan sauber |

---

## 9. STAND-ZEILE DES META-LAUFS

Jede Antwort im Meta-Lauf beginnt mit:

`STAND · Meta-Lauf M[n] von M8 · Prüfrunde [r] · Agenten aktiv [x] · Varianten [v] · nächster Schritt: […]`

---

## 10. START DES META-LAUFS

1. `git fetch origin`; Branch-Stände mit SHA notieren.
2. Worktree `/home/user/bollwerk` auf neuem Branch `bollwerk` aus `origin/main` anlegen.
3. `planung/bollwerk/` mit ENTSCHEIDUNGSLOG und STATUS anlegen.
4. M1 starten: alle Leser **gleichzeitig**.
5. Während M1 läuft: Referenzbilder für M2 vorbereiten und den Pilot für M4 entwerfen.
6. Dann M2 bis M8 wie beschrieben.

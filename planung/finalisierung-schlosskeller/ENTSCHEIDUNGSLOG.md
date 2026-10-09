# ENTSCHEIDUNGSLOG · Finalisierung „Spuk im Schlosskeller“

Format je Eintrag: Ziel und Messgröße · Wege (mindestens drei) · Bewertung (Logik/Lösbarkeit, Spielspaß am Tisch, Treue zum Quellmaterial, Wartbarkeit) · Umkehrprobe · Folgen zweiter Ordnung · Entscheidung.

---

## E-001 · Partymodus in der vorhandenen Mordakte-App (F0)
- **Ziel:** Der Fall ist im Browser spielbar und nutzt die vorhandene Engine (§8: „Eine zweite baust du nicht“). Messgröße: F-12, F-16.
- **Wege:**
  1. Den Mordakte-Spielablauf (Engine, Schatten, Rat) erweitern, sodass er den Partyablauf mitträgt.
  2. Einen Partymodus in derselben App bauen: neue, reine Dart-Logik unter `mordakte_core/lib/src/party/`, neue Bildschirme unter `lib/party/`; der Renderer (Iso-Projektion, Szenenbau, Figuren, Licht, Joystick) wird wiederverwendet.
  3. Eine eigene HTML/JS-Party-App neben Mordakte.
- **Bewertung:**
  - Weg 1 zwingt Partyregeln (4–20 Rollen, 9 gewertete Entscheidungen, Gruppenwahl, feste Enden) in eine Engine mit 6-Spieler-Grenze, Pflicht-Nacht und Echtzeit-Schatten. Viele Änderungen an Bestandscode, hohes Regressionsrisiko für F-16.
  - Weg 2 nutzt genau die passenden Teile (Renderer, Rng, Validator-Muster, Asset-Laden) und lässt Mordakte unberührt.
  - Weg 3 verstößt gegen §8.
- **Umkehrprobe:** Weg 2 wäre falsch, wenn der Renderer so eng an die Mordakte-Session gebunden ist, dass er nicht ohne sie läuft. Prüfung: Kundschafter F0-KUNDSCHAFTER-01. Ergebnis siehe BESTAND.md.
- **Folgen:** Die Story-Daten liegen außerhalb des Codes (F-16 „kein Story-Text außerhalb des Kanons“). Mordakte-Tests bleiben unverändert.
- **Entscheidung:** Weg 2.

## E-002 · Kanon als JSON je Bereich in `content/party/schlosskeller/` (F0)
- **Ziel:** eine maschinenlesbare Quelle mit Schema, getrennte Dateien für parallele Autoren, Story-Bibel erzeugt. Messgröße: F-01.
- **Wege:**
  1. Eine große JSON-Datei.
  2. JSON je Bereich, dazu Textsammlung `texte/*.json` mit Schlüsseln; Schema-Dateien unter `content/party/schema/`.
  3. Das Zeilenformat des früheren Laufs (`@ID [S] | Feld: Wert`).
- **Bewertung:**
  - Weg 1 erzwingt Dateikonflikte bei parallelen Autoren.
  - Weg 3 ist gut prüfbar, aber das Spiel bräuchte dafür einen eigenen Parser, und Behzads JSON müsste konvertiert werden.
  - Weg 2 erhält Behzads Feldnamen (`settingId`, `characters`, `visualSpecs`, `killerProfile` …), wird von App und Werkzeugen direkt gelesen und erlaubt Dateihoheit je Autor.
- **Umkehrprobe:** Wäre JSON für Autoren zu fehleranfällig? Gegenmaßnahme: Der Validator läuft in jedem Test, und Autoren schreiben nur Textdateien mit flachen Schlüssel-Wert-Paaren.
- **Folgen:** Der Asset-Ordner wird in `pubspec.yaml` eingetragen. Ladegröße prüfen.
- **Entscheidung:** Weg 2. Jeder pfadabhängige Datensatz trägt `pfade` (Liste aus `ahmet|fatma|olli|can`, fehlt das Feld, gilt er für alle).

## E-003 · Branch und Übergabe (F0)
- **Ziel:** Arbeit gesichert, am Ende auf main mit Tag, ohne Force-Push.
- **Wege:**
  1. `finalisierung-schlosskeller` wie in den Einstellungen.
  2. Direkt auf dem Sitzungsbranch `claude/universal-prompt-orchestrator-trt8uu`.
  3. Beide parallel.
- **Bewertung:** Die Einstellungen nennen Weg 1. Die Umgebung kann Pushes auf fremde Branchnamen ablehnen.
- **Umkehrprobe:** Lehnt der Proxy ab, ist Weg 1 nicht pushbar. Dann greift Weg 2 als Sicherungsziel mit denselben Commits.
- **Entscheidung:**
  - Lokaler Arbeitsbranch `finalisierung-schlosskeller` ab origin/main `d92a675`, Upstream abgekoppelt (kein versehentlicher Push auf main).
  - Push an jedem Phasentor; bei Ablehnung auf den Sitzungsbranch.
  - F7: Merge nach main, Push, Tag `schlosskeller-1.0`. Ist das blockiert, folgt ein Pull Request und ein Eintrag unter FÜR DEN NUTZER.

## E-004 · Werkzeugkette nur im Repo (F0)
- **Ziel:** bauen und testen ohne systemweite Installation und ohne fremde Server zur Laufzeit.
- **Entscheidung:**
  - Flutter 3.47.6, dieselbe Quelle wie `build.sh`, liegt in `.werkzeug/flutter`; `PUB_CACHE=.werkzeug/pub-cache`; beides gitignored. Aktivierung: `source .werkzeug/env.sh`.
  - E2E: npm-Paket `playwright` in `tool/e2e/` (Apache-2.0) mit dem vorinstallierten Chromium.
  - PDF: Dart-Paket `pdf` (Apache-2.0).
  - Stimme: Web Speech API über `dart:js_interop`, nur lokale Stimmen (`localService`). Keine neue Abhängigkeit.
- **Begründung:** Alle drei Bibliotheken sind verbreitet, gepflegt und frei lizenziert; Lizenzliste in LIZENZEN.md.

## E-005 · Quellmaterial (F0)
- `quellen/` ist seit dem ersten Arbeitsschritt in `.gitignore`.
- Der Teamchat aus Codays erster Nachricht dieser Sitzung liegt wortgleich in `quellen/schlosskeller-teamchat.txt`.
- Der Secret-Scan vor jedem Push prüft, dass nichts aus `quellen/` im Verlauf ist.

## E-006 · Werkstatt und Gemeindesaal (F0)
- Im Repo gibt es dazu weder Daten noch Texte, nur die Titel im Chat. Es gibt also nichts zu übernehmen (§8 „falls vorhanden“).
- Das Kanon-Schema ist fallneutral (`content/party/<fall>/`), damit beide später andocken können.
- Eintrag unter FÜR DEN NUTZER.

## E-007 · Cast und Leitplanken (F0, Feinentscheidung in F1)
- **Ziel:** Kernnamen laut Einstellungen behalten und trotzdem keine Klischees (Grenze, Vorrang 1).
- **Wege:**
  1. Kernnamen ändern, wie die Vorprüfung vorschlägt (Ahmet → Felix, Fatma → Sophie …).
  2. Kernnamen behalten, Herkunft und Motive so verteilen, dass keine Gruppe allein Verfehlungen trägt; Kopftuch auch bei unbelasteten Figuren; Motive aus der Lage statt aus Not oder Herkunft.
  3. Nichts ändern.
- **Bewertung:**
  - Weg 1 verletzt die Einstellungen (Täter aus Ahmet, Fatma, Olli, Can) und Behzads laufende Modellierung.
  - Weg 3 verletzt die Grenze.
  - Weg 2 hält beides ein.
- **Umkehrprobe:** Bleibt trotz Weg 2 ein Klischee-Eindruck, weil drei Kernnamen türkisch klingen? Gegenmaßnahmen:
  - Jede der vier Kernrollen bekommt eine andere Herkunft. Ahmet ist auch ein bosnischer Vorname, Fatma kommt in türkischen und kurdischen Familien vor.
  - Die Tatverteilung ist gleichmäßig: jede Kernrolle in 25 % der Fall-Codes.
  - Jede Verfehlung ist situativ motiviert.
  - Der Sensibilitätsleser prüft die Gesamtverteilung.
  - Der stärkere Vorschlag liegt als Option unter FÜR DEN NUTZER.
- **Entscheidung:** Weg 2. Konkrete Herkunfts- und Namenszuordnung in F1 (E-1xx).

## E-008 · Spoilerschutz als Architekturregel (F0)
- Die 9 Fragen samt Optionen sind in allen Pfaden wortgleich; nur Wertung und Ergebnistext hängen vom Pfad ab.
- Alle vier Schlüsselbeweis-Orte sind in jedem Pfad belegt; in fremden Pfaden mit dokumentierter harmloser Fassung.
- Der Bonus-Hinweis erscheint in allen drei Qualitäten im selben Rahmen. Die App nennt nie die Stimmenzahl.
- Die Täterfassung eines Dossiers erscheint nur in der verdeckten Einzelansicht und im eigenen Rollenheft.
- **Begründung:** Ein gemeinsamer Bildschirm und gedruckte Unterlagen dürfen den Pfad nicht verraten (F-06, F-11, F-12, F-14).

## E-009 · Haiku-Plätze und Denkstufe (F0)
- Die Maschine hat 4 CPUs, ein Workflow lässt höchstens 2 Agenten gleichzeitig laufen. Für 4 gleichzeitige Plätze laufen bis zu 2 Workflows parallel mit getrennter Dateihoheit.
- Modell `haiku`. Qualitätsarbeit (Autor, Prüfer) läuft mit `effort: max`, Kundschaft mit `high`.
- Stufe-3-Teile baut der Orchestrator selbst: Kanon-Kern, Tatmatrix, Plausibilitätsprüfer, Entscheidungs- und Endenmodell, Simulator-Kern, Einbindung, Übergabe.

## E-010 · Upstream abgekoppelt (F0)
- `git checkout -b finalisierung-schlosskeller origin/main` hat origin/main als Upstream gesetzt. Ein `git push` ohne Ziel hätte main getroffen.
- Mit `git branch --unset-upstream` entfernt. Jeder Push nennt sein Ziel ausdrücklich.

## E-011 · Paketabnahme durch den Orchestrator mit Werkzeughilfe (F0)
- **Ziel:** Jede Rückgabe wird nach den fünf Prüfungen bewertet, ohne dass die Abnahme zum Engpass wird.
- **Wege:**
  1. Ich lese jede Rückgabe vollständig.
  2. Ein Opus-Prüfagent bewertet, ich lese nur Stichproben.
  3. Werkzeuge prüfen alles Messbare; ich lese jede Rückgabe mit den Werkzeugberichten und bewerte selbst.
- **Bewertung:** Das Messbare (Schema, Verweise, Satzlängen, Stopplisten, Tests) ist mechanisch prüfbar und vollständig automatisierbar. Urteil bleibt beim Orchestrator (§4).
- **Entscheidung:** Weg 3.
  - Die Abnahme steht als `ABNAHME`-Zeile im Kopf von `berichte/<Kennung>.md`.
  - Bei sehr großen Stapeln (mehr als 20 gleichartige Texte) lese ich jeden fünften vollständig und alle mit Werkzeugbefund.

## E-012 · Lernen L-01: Rückgabe in einer Nachricht (F0)
- **Befund:** Der Rückgabewert von F0-KONT-01 begann mitten in Tabellenzeile 68. Die Zeilen 1–67 standen in einer früheren Nachricht des Agenten; der Workflow übernimmt nur die letzte.
- **Maßnahme:**
  - Bericht aus dem Agentenverlauf wiederhergestellt (`berichte/F0-KONT-01.md`, vollständig mit Endmarke).
  - AUFTRAGSVORLAGE ergänzt: Die gesamte Rückgabe steht in der letzten Nachricht.
  - Workflows prüfen künftig, dass die Rückgabe mit der Überschrift des Ausgabeformulars beginnt und mit der Endmarke endet. Sonst wird der Auftrag einmal mit dem Hinweis wiederholt.

## E-013 · Plan-Schleife Runde 1: Entscheidungen zu F0-GEGEN-01 (17 Befunde) und F0-GEGEN-02 (16 Befunde)
Je Befund: übernommen (Ü), teilweise (T), verworfen (V), mit Begründung. Die Folgen stehen in PLAN, ABNAHME, NEBELKARTE und FÜR-DEN-NUTZER.

| Befund | Entscheidung | Begründung, Folge |
|---|---|---|
| G1-1, G2-3 Abkürzung über drei wahre Hinweise | Ü | Regel W-1: Ein wahrer Bonus-Hinweis liefert einen wahren Baustein (bestätigt eine Beobachtung oder deckt ein Nebendelikt auf), entlastet aber nie allein einen Kernverdächtigen. F-06 wird um den Fall „0 richtige, 3 wahre Hinweise → mindestens 2 Restverdächtige“ ergänzt. |
| G1-2 Anklage durch Raten | T | Die Anklage bleibt gegen alle vier Kernverdächtigen möglich (Master 7.6: „gegen einen der vier“). Die Endmatrix B-12 bleibt. Der Simulator weist Rate-Enden (Anklage außerhalb der Restmenge) getrennt aus. |
| G1-3 Ein oder zwei Restverdächtige | Ü | Bestes Spiel: nach Runde 2 (6 richtige) genau 2 Restverdächtige, nach Runde 3 (9 richtige) genau 1. Das erfüllt F-06 und 7.6 („in Runde 3 stehen zwei Restverdächtige dem Schlüsselbeweis gegenüber“). |
| G1-4, G1-5 Spoiler im Resümee | Ü | Regel S-1: Resümee-Fächer werden nur aus dem Wissen des Detektivs gefüllt (aufgedeckte Fakten, Gruppenqualität), nie aus dem Pfad. Bei Restmenge 1 nennt kein Baustein einen Namen („Die Spuren haben sich gelichtet – jetzt liegt es an dir.“). Kein Baustein sagt „X ist der Täter“. Der Spoiler-Test prüft alle Bausteine vor dem Finale über alle vier Pfade. |
| G1-6 Marker auf der Karte | Ü | E-008 verschärft: Objektliste, Marker und Licht vor dem Finale sind in allen vier Pfaden identisch; nur Fundtexte unterscheiden sich. Test `karte_pfadgleich_test`. |
| G1-7 Kanal der Pflichtgespräche | Ü (Variante a) | Preisgaben in Pflichtgesprächen sind pfadneutral (Nebendelikte, behauptete Alibis, gemeinsame Beobachtungen). Pfadabhängiges Wissen steht im Dossier unter „Was ich verberge“. Es erreicht den Detektiv nur über eine Detektiv-Entscheidung (Befragung, bei unbesetzter Rolle als NPC-Karte) oder anonym über den Bonus-Hinweis. Rollenwissen ist so gebaut, dass es allein niemanden entlastet (anonyme Beobachtung plus Beweis aus einer Entscheidung). |
| G1-8 Falsche Option zeigt Schlüsselbeweis | Ü | Regel D-1: Optionen mit 0 Punkten decken weder Schlüsselbeweis noch Zusatzindiz auf, nur Nebendelikt- oder Umgebungsfakten. Test in `beweise_test` und `simulator_test`. |
| G1-9, G2-14 Simulator unsound und zu langsam | Ü | Zustand = (Pfad, Menge aufgedeckter Fakten, Gruppenqualitäten); Restmenge als Funktion der Faktenmenge mit Memo. Die erschöpfende Auszählung läuft in der CLI `party_simulate` (Budget unter 5 Minuten für alle Pfade und Personenzahlen). Der Testlauf nutzt dieselbe Auszählung mit Memo; Budget unter 60 Sekunden. NEBELKARTE 16 korrigiert. |
| G1-10, G2-13 Gruppenwahl ohne Kosten | Ü | Jede Option trägt maschinenlesbar `kosten` und `nutzen` aus Geheimnis oder Loyalität (A: Geheimnis oder Freund gerät ins Licht; B: schützt das persönliche Ziel). Persönliche Ziele werden in der Auflösung als „erreicht oder nicht“ gezeigt. Test: Jede Rolle hat bei B einen Nutzen und bei A Kosten; jeder der 36 Hinweise ist über eine Stimmenverteilung erreichbar. |
| G1-11 Sabotage | Ü | Regel G-1: Die Option B der Täterrolle heißt im Kanon „Sabotage“. Sie zählt wie jedes B als 0 und hebt zusätzlich eine kooperative Stimme auf (netto −1). Für alle sichtbar ist nur die Qualität, nie die Zahl. Simulator-Dimension: Stimmenverteilungen je Personenzahl → Qualität. |
| G1-12 Lacher im Intro | Ü | Lacher sind Stimmung, nie Erzählerfakt für Alibis. Alle 20 Gäste existieren in der Welt (W1), unbesetzte nennt der Erzähler nur über Bausteine, die die App nach Besetzung wählt (mit Rollenname oder neutral „eine Freundin“). „Verlaufen auf dem Weg zur Toilette“ wird in F1 vergeben. |
| G1-13 Geburtstagskind im Tatraum | Ü | War schon gelöst: Das Geburtstagskind sitzt ab 23:55 mit verbundenen Augen und Musik auf den Ohren im Ostsaal; die Lockung zur Torte um 0:00 fand wegen des Ausfalls um 23:58 nie statt. Der Plausibilitätsprüfer prüft die Wahrnehmung des Geburtstagskinds. |
| G1-14 Druckspiel ohne Restmengen-Anzeige | Ü | Gedruckt wird ein Ermittlungsbogen mit Ausschlussregeln („Hast du Fakt X und Y, ist Z entlastet“), den das Geburtstagskind selbst ausfüllt. F-14 wird ergänzt: Das Resümee ist ohne Auflösungsheft ablesbar. |
| G1-15 Täterfassung in der Druckdatei | Ü | Druck: Jede Kernrolle erhält beide Fassungen als versiegelte Blätter mit neutralen Codes und eine versiegelte Schlüsselkarte, welche sie öffnet. Wer druckt, liest nichts davon; die Spielleitung hält keine Kernrolle. |
| G1-16 Texte veralten bei Kanon-Änderung | Ü | Textlint: Jede Uhrzeit, jeder Ort und jeder Gegenstand in Texten wird gegen Zeitleiste, Raumgraph und Gegenstandsliste geprüft (`textlint_test`). Regel: Jede Kanon-Änderung nach F3 löst den Textlint und die KONT-Prüfung der betroffenen Dateien aus. |
| G1-17, G2-6 F-09 und Besetzung zu spät | Ü | Besetzungsreihenfolge in F1 (`figuren.json` und `besetzung.json`), Ersatzpartner und Begründungsketten-Prüfung je Personenzahl in F2 (Teil des F2-Tors). |
| G2-1 CanvasKit vom CDN | Ü | `--no-web-resources-cdn` in `build.sh` (Bestandsänderung, dokumentiert) und in `tool/pruefen.sh`. Die Netzprüfung läuft schon im Spike (F1) und nicht erst in F6. |
| G2-2 SDK-Download | T | Denkprotokoll: Ohne SDK kann kein Commit „baut und testet grün“ belegt werden. Das Projekt installiert sein gepinntes SDK selbst über `build.sh` aus derselben Quelle. Das zählt als Paketinstallation über das Werkzeug des Projekts. Nichts wird hochgeladen, die Laufzeit des Spiels bleibt ohne fremde Server. Eintrag unter FÜR DEN NUTZER mit Quelle und Prüfweg. |
| G2-4 Analyse-Reihenfolge | Ü | `tool/pruefen.sh` entsteht in F0 und ruft zuerst `pub get` in allen Paketen auf. |
| G2-5 Bestandsänderungen, Spike | Ü | E-001 erhält eine Liste erlaubter Bestandsänderungen: nur zusätzliche, optionale Parameter mit unverändertem Standardverhalten (z. B. `standing(..., idleT)` mit Standard 0, Fog nur bei gesetztem Schalter). Ein Spike folgt in F1 parallel zum Kanon: Karte aus dem Raumgraph, eine Figur, Licht, Playwright-Probelauf mit Netzprüfung. |
| G2-7 Doppelte Quelle Kern-Rundenwahl | Ü | Die Kern-Rundenwahl entsteht nur über die Dilemma-Dateien (Varianten-Regel); F3-AUTOR-26 schreibt nur die Blöcke 2–5. Beide hängen an den Dossiers. |
| G2-8 Textschlüssel, Eigentümer | Ü | Neuer Auftrag F3-ORCH-00 (Schlüsselschema). Eigentümertabelle im PLAN: `pubspec.yaml`, `packages/mordakte_core/pubspec.yaml`, Barrel `mordakte_core.dart`, `lib/l10n/app_de.arb`, `analysis_options.yaml`, `build.sh`, `router.dart`, `main.dart`, `hub_screen.dart` gehören ORCH. Party-UI-Texte stehen in der Kanon-Textsammlung (`texte/ui.json`), nicht in ARB. |
| G2-9 Isolation paralleler Agenten | Ü | Baumeister, die Code ändern oder bauen, laufen mit `isolation: worktree`. Commits nur mit expliziter Pfadliste. Builds mit eigenem `-o`-Verzeichnis je Lauf. |
| G2-10 Übergabe | Ü | Probe-Push am F0-Tor. F7 mit `git merge --ff-only` auf den aktuellen origin/main-Stand. Hub-Kachel und Routen als letzter F4-Schritt nach dem Holen von origin. F-17-Ersatzweg PR (Master §3) wird im Abschlussbericht ausgewiesen, falls er greift. |
| G2-11 Playwright | Ü | `playwright@1.56.1` gepinnt (passt zu `/opt/pw-browsers/chromium-1194`), `PLAYWRIGHT_BROWSERS_PATH` im Skript. Flutter-Semantik wird im Entwicklerbetrieb per `?semantik=1` eingeschaltet, Klicks laufen über Beschriftungen. Die Karte wird über den Dev-Einstieg mit Skript gesteuert. |
| G2-12 Farbabstand | Ü | ΔE2000-Test in F1 (`farbabstand_test`), gemessen an den Hex-Werten des Kanons. Neue Werte: Can `#F5C400` (Signalgelb), Emine `#5E6E3A` (moosgrün), Azra (vorher Dilara) `#7A2E5C` (pflaumenfarben), Aylin `#3A6EA5` (taubenblau). Minimum je Startraum 11,8, Beweisfarbe 29,6 (Probe 10:52). Gerendert prüft der Sichtprüfer in F4. |
| G2-15 Fehlende Aufträge | Ü | Neue Aufträge F4-BAUMEISTER-08 (Titel, Intro- und Resümee-Bildschirm), -09 (NPC-Karte), F4-ORCH-05 (Spielleitung: Täter für Testläufe festlegen, Pfeife mit Seifenblasen, Gags an Rüstung und Kamin). |
| G2-16 Secret-Scan | Ü | `tool/secret_scan.sh` in F0. Es prüft: `git log --all -- quellen/` ist leer; keine Datei im Verlauf enthält Chat-Kopfzeilen (`[09.10.26,`) oder längere wörtliche Chatblöcke; keine Schlüssel- oder Token-Muster; keine `.env`. Berichte zitieren nur Kurzstellen mit Zeilennummer. |
| G2 offen: Kachel = Meter | Ü | 1 Kachel = 1 m in Raumgraph und Tatmatrix. Die Gehgeschwindigkeit des Detektivs im Spiel ist Bedienkomfort und unterliegt nicht den Tatnacht-Werten aus 7.4. |
| G2 offen: Rundenzeit | Ü | Zwei Uhren: Die Weltuhr je Runde (0:30, 1:15, 2:00, Finale 2:45) steht im Bild, im Erzähler und in den Dossiers. Die Tischzeit (Rundendauer 30 Minuten) ist eine Einstellung; E2E verkürzt sie per Dev-Parameter. |
| G2 offen: PDF-Schriften | Ü | Die PDF-Erzeugung liegt in `mordakte_core` (reines Dart) und bekommt die Schrift-Bytes als Parameter. CLI und App laden sie aus `assets/fonts`. |
| G2 offen: Spoiler über Entwicklerwerkzeuge | V | Gäste mit Browser-Entwicklerwerkzeugen auszuschließen ist kein Ziel eines Partyspiels und technisch nicht durchsetzbar. Eintrag unter FÜR DEN NUTZER. |
| G2 Plan-Summe | Ü | PLAN neu gezählt (siehe Kopf). |

## E-014 · Plan-Schleife Runde 2: Entscheidungen zu F0-GEGEN-03a (33 Altbefunde) und F0-GEGEN-03b (13 Befunde Tatnacht, 10 Beweise, 7 offene Fragen)
- **Ablauf:** Der erste Lauf von F0-GEGEN-03 brach technisch ab (Antwort über der Ausgabegrenze, siehe E-017). Neustart aufgeteilt in 03a (Altbefunde) und 03b (Angriff auf die Tatnacht in Dateien). Beide Rückgaben vollständig (Kopf und Endmarke geprüft).
- **03a, Urteil:** 13 gelöst, 19 teilweise, 1 offen. Entscheidungen zu den Rest-Lücken:

| Befund | Entscheidung | Folge |
|---|---|---|
| G1-1, G2-3 „allein“ undefiniert | Ü | W-1 scharf: Bonus-Hinweise haben **keine** Ausschlusswirkung. Sie bestätigen pfadneutrale Fakten oder decken Nebendelikte auf. Ausschlüsse kommen nur aus Detektiv-Entscheidungen. ABNAHME F-06 ergänzt: Für jede Zahl k richtiger Entscheidungen ist die Restmenge mit beliebigen Hinweisen gleich der Restmenge ohne Hinweise. |
| G1-2 Raten mit 0 Punkten → E2 | V | Die Endenmatrix B-12 ist Vorgabe des Master-Prompts. Der Simulator weist Rate-Enden aus; der E2-Text spricht das Glück an (F3). |
| G1-7 Pflichtgespräche | Ü | Der spoiler_test (F-11) prüft auch Pflichtgespräch-Texte und die öffentlichen Dossierteile: Dort dürfen nur Beobachtungen mit `kanal: pflichtgespraech` stehen, und die sind pfadneutral (Prüfer erzwingt das bereits). |
| G1-9 Simulator-Budget | Ü | Budget in ABNAHME F-06: CLI unter 5 Minuten, Test unter 60 Sekunden. |
| G1-10, G2-13 Dominanz | T | F2-TEST-04 prüft zusätzlich: Keine Option ist für eine Rolle in allen drei Runden kostenlos. |
| G1-11 Sabotage | Ü | F2-ORCH-02 erhält das Kanon-Feld `sabotage` je Kernrolle. |
| G1-12 Lacher, unbesetzte Rollen | Ü | „Verlaufen“ ist vergeben (Olli, 20:15, setting.json). Intro-Bausteine nennen unbesetzte Rollen nur neutral (F3, Erzähler wählt nach Besetzung). |
| G1-13 Geburtstagskind | Ü (erledigt) | Tatmatrix: Augenbinde 23:55:10–0:00:35, Ost-Saal; Plausibilitätsprüfer prüft es. |
| G1-15 Täterfassung im Druck | T | Jede Kernrolle bekommt beide Fassungen in versiegelten Umschlägen mit Zufallscode, die Schlüsselkarte nennt nur den Code. Wer das PDF absichtlich durchliest, kann spoilern; das steht unter FÜR DEN NUTZER. |
| G1-16 Neuprüfung nach Kanon-Änderung | Ü | Regel im PLAN: Jede Kanon-Änderung nach F3 löst Textlint und KONT-Prüfung der betroffenen Texte aus. |
| G2-5 Bestandsänderungen | Ü | Liste der tatsächlichen Bestandsänderungen in E-016. |
| G2-6 Ausfallursache bei 4–5 Rollen | Ü (erledigt) | W1: Tim existiert in jeder Besetzung (bei weniger als 6 Rollen als NPC). |
| G2-9 Worktree ohne SDK | Ü (erledigt) | Aufträge laden die Werkzeugkette über den absoluten Pfad `/home/user/werwolf_digital_flutter/.werkzeug/env.sh`. |
| G2-10 F-17 und PR-Ersatzweg | Ü | ABNAHME F-17: erfüllt mit main = origin/main und Tag, oder mit dem Ersatzweg aus Master §3 (PR mit Abschlussbericht), wenn eine Schutzregel greift; der Abschlussbericht weist das aus. |
| G2-16 Wörtliche Passagen | Ü | Secret-Scan Stufe 4: keine Rohchat-Zeile ab 120 Zeichen wörtlich im Arbeitsstand (`tool/lib/chat_passagen.py`). Ein Fund in einem F0-Bericht wurde gekürzt; im Verlauf steht nur dieser einzelne Feldwert, kein Chatauszug. |
| Übrige „teilweise“ | T | Rest-Lücken sind Aufträge späterer Phasen und dort mit Abnahme belegt (F2–F5). |

- **03b, Tatnacht:**

| Befund | Entscheidung | Begründung, Folge |
|---|---|---|
| 1 Jeder Trenner entscheidet den Fall | V (mit Klarstellung) | Logisch schließt ein Trenner genau eine Kernperson aus (Unschuld) oder lässt sie offen (Tatpfad). Die Spätankunft im Tatpfad schließt niemanden aus; die Restmenge entsteht nur aus Ausschlüssen. Gegenkontakt-Paare würden die Trenner zerstören. F2: Die Spätankunft zählt im Entscheidungsmodell nicht als Ausschluss anderer. |
| 2 Weitere Zeugen am Laufweg (Zeynep, Hana, Wojtek) | V | Der Kaminsaal liegt zwei Türen vom Scheppern entfernt; dort hört niemand das Scheppern (Hörregel). Ohne Bezugsereignis gibt es kein VOR/NACH. Der Wissensvergleich des Prüfers bestätigt es. Regeltext in wahrnehmung.json klargestellt. |
| 3 Schneider in der Gedächtnislücke | Ü (erledigt) | Der Prüfer kappt Schneiders Wahrnehmungen ab 23:58:14. |
| 4 Damir im Ahmet-Pfad | V | Das ist der Trenner: Im Ahmet-Pfad fehlt die Berührung genau während des Scheppern. |
| 5 Pfadverräterische Worte beim Griff | Ü | Ereignistexte neutral, ohne Rede. Der einzige Ruf bleibt „Stehen bleiben!“ in allen Pfaden. |
| 6 Wojtek-Zeile | Ü (erledigt) | Der Prüfer vergleicht das Leuchten ohne Raumbezug; kein Unterschied mehr. |
| 7 Quietschende Tür | Ü | Regel: offene Türen quietschen beim Durchgehen nicht; Zustandswechsel einer quietschenden Tür ist laut (im Rechner umgesetzt). |
| 8 Umschlag-Weg | Ü | Ahmet geht um 0:11 zum Ascheneimer (neue Einrichtung), Hana sieht es (b_hana_umschlag). Planfenster bis 0:15. |
| 9 Notlaterne | Ü | Als Lichtquelle mit leerem Zeitfenster geführt (brennt nie). |
| 10 Zeitversatz in Profilen | Ü | Texte an Pläne angeglichen; Tims Stirnlampe rutscht beim Tasten vom Hals. |
| 11 Notizbuch, Foto, Brottasche | Ü (erledigt) | Stehen als Gegenstände im Kanon, pfadgleich. |
| 12 Klischee-Kopplung | T | Kopftuch bei Fatma bleibt (Quellmaterial, E-007). Gegengewichte: Fatmas Motiv ist Ehrgeiz und die Rückgabe am Montag; Aylin (Kopftuch) ist die kompetente Kassenprüferin; Emine (Kopftuch) die Lehrerin. Neues Feld `alltag` für alle 20 entkoppelt Herkunft und Beruf (z. B. Wojtek studiert Architektur, Pawel ist Rechtsreferendar, Marek führt einen Catering-Betrieb, Serkan ist Rettungssanitäter). Serkans Titel wie in Behzads JSON: „Der Fahrdienst-Organisator“. Sensibilitätsleser F1-SENS-01 prüft die Gesamtverteilung; die Kopftuch-Frage steht unter FÜR DEN NUTZER. |
| 13 Pfeife | V | Vorgabe der Einstellungen: Seifenblasenpfeife. |
| Beweisphysik | T | Azras Ringe aus Holz und Stein (kein Metallabrieb möglich). Übrige Beweise robust; die Beweisprüfung leitet die Entstehung jeder Spur aus der Tatmatrix ab (`beweise_test`). |
| Offene Fragen 1, 2, 4, 7 | Ü | Leuchten sieht man im Dunkeln auch von weitem (nur als Leuchten); Möbel dämpfen nicht; Joannas Foto trägt die Uhrzeit 23:51; Herkunft wird im Spiel nie als Etikett gezeigt, sie dient nur der Ausgewogenheitsprüfung. |

- **Plan-Schleife:** Nach zwei Runden sind keine schweren Befunde offen; die dritte Runde entfällt. Die nächste Gegenprüfung ist F1-GEGEN-01 auf dem fertigen Kanon.

## E-015 · Tatnacht-Modell und Wahrnehmungsregeln (F1)
- **Ziel:** Jede Beobachtung ist aus der Tatmatrix ableitbar (7.4), und kein Zeuge löst den Fall allein.
- **Wege:**
  1. Handgeschriebene 15-Sekunden-Tabellen je Pfad.
  2. Pläne je Person (Aufenthalte, Wege über das Raster, Gesagtes, getragenes Licht). Ein Rechner tastet sekundengenau ab und leitet Sehen, Hören, Fühlen und Riechen her. Die 15-Sekunden-Matrix wird daraus erzeugt.
- **Bewertung:** Weg 1 ist bei 22 Personen × 41 Schritten × 4 Pfaden kaum widerspruchsfrei pflegbar. Weg 2 macht die Regeln prüfbar und die Matrix zum Ableitungsprodukt.
- **Entscheidung:** Weg 2 (`tatmatrix.dart`, `wahrnehmung.dart`, `plausibilitaet.dart`). Verfeinerte Regeln in wahrnehmung.json:
  - drei Lautstärken (sehr laut, laut, leise) und Tumult 23:58–0:00 in Buffetsaal, Durchgang und Ost-Saal;
  - schwaches Licht erkennt bis 3 m, volles Licht im ganzen Raum;
  - wer kauert, sieht nichts;
  - der Bund wird in der Faust getragen und klimpert nur beim Abziehen;
  - Zeitabstände im Dunkeln zählen nicht, nur die Reihenfolge.
- **Umbauten nach dem Wissensvergleich:**
  - Lejla trägt um 23:57:40 die Tortenteller in den Ost-Saal.
  - Olli kauert unschuldig bei Azra statt gegen einen Stuhl zu laufen.
  - Can versteckt den Bund im Täterpfad im Helm der Ritterrüstung.
  - Tugba steht ab 23:55 beim Geburtstagskind.
  - Ahmet startet um 23:58:30.
  - Ergebnis: Jeder der vier Trenner hat genau einen Zeugen (Azra/Olli, Emine/Fatma, Damir/Ahmet, Marek/Can), und niemand sonst weiß pfadabhängig etwas. Das prüft der Test.

## E-016 · Spike und Bestandsänderungen (F1-ORCH-11)
- **Ergebnis:** Der Raumgraph lässt sich ohne Umbau im vorhandenen 2.5D-Renderer zeigen. Weg: `partySzenarioJson` baut aus dem Kanon ein Renderer-Szenario mit einer Vorlage für die Pflichtfelder, Einstieg `preview_main.dart?party=schlosskeller`. Playwright-Probelauf: 0 Konsolenfehler, 0 fremde Netzaufrufe. Fotos an den Nutzer geschickt.
- **Bestandsänderungen bisher** (alle zusätzlich, Standardverhalten unverändert; volle Prüfung grün):
  1. `LookDef.headColor` (optional) und Kopfbedeckung `kopftuch` in `LookDef.hats`.
  2. Figurenzeichner: Fall `kopftuch` (kein Haar darunter), Farbe aus `headColor`.
  3. `preview_main.dart`: Parameter `party`.
  4. `pubspec.yaml`: Assets `content/party/schlosskeller/` und `tatmatrix/`.
  5. Barrel: Exporte des Partymodus.
  6. `build.sh`: `--no-web-resources-cdn` (E-013).
- **Befund für F4:** Der Tisch-Zeichner des Bestands setzt zufällig grüne Flaschen und Messingleuchter auf Tische. Für den Partymodus wird eine eigene Tafel-Darstellung nötig (Teekanne, Tassen, Wasserkaraffe, elektrische Teelichter). Auftrag F4-ORCH-06.
- **Kleinere Befunde für F4:** Teekocher und Kaffeemaschine erscheinen als Herd; die Wendeltreppe als Regal; der Detektiv trägt noch den Mordakte-Hut.

## E-017 · Lernen L-02: Ausgabegrenze bei höchster Denkstufe (F0)
- **Befund:** F0-GEGEN-03 lief 36 Minuten und brach mit „Antwort über 128.000 Ausgabe-Token“ ab. Ursache: ein breiter Prüfauftrag (33 Altbefunde plus Angriff auf Regeln und Kanon) mit `effort: max`.
- **Maßnahme:** Breite Prüfaufträge werden geteilt. Jeder Auftrag nennt eine Längengrenze (höchstens 1.800 Wörter Bericht). Prüfaufträge laufen mit `effort: high`; `max` bleibt für eng geschnittene Autoren- und Gegenprüfaufträge. AUFTRAGSVORLAGE ergänzt.

## E-018 · Lernen L-03: Arbeitsbäume entstehen von main (F1)
- **Befund:** Die Worktree-Isolation legte die Arbeitsbäume von F1-BAUMEISTER-01 und F1-TEST-03 auf `d92a675` (origin/HEAD) an, nicht auf den Arbeitsbranch. Kanon und Party-Code fehlten dort. Beide Agenten haben das erkannt, ohne Git-Schreibbefehle gearbeitet (Snapshot in `/tmp` bzw. Kopie der Daten) und vollständig geliefert. Die Rückgabeprüfung des Workflows verlangte die Endmarke als letzte Zeile; F1-BAUMEISTER-01 setzte offene Fragen dahinter und wurde unnötig neu gestartet (Lauf gestoppt).
- **Maßnahme:**
  - Code-Aufträge mit Worktree beginnen mit Schritt 0: `git checkout --detach <Commit des Arbeitsbranchs>` im eigenen Arbeitsbaum. Das ist die einzige erlaubte Git-Schreiboperation; sie betrifft nur den eigenen Arbeitsbaum.
  - Der Workflow prüft die Endmarke als vorhanden, nicht als letzte Zeile.
  - `.claude/worktrees/` steht in `.gitignore`.
- **Abnahmen:**
  - `ABNAHME F1-TEST-03 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10`. 14 Sharma-Referenzpaare, Rot-Proben belegt. Übernommen mit einer Anpassung: Pfad über die Testhilfe.
  - `ABNAHME F1-BAUMEISTER-01 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 1 · Summe 9/10`. Ein Punkt Abzug für die Form (offene Fragen nach der Endmarke). Übernommen mit Ergänzung des Felds `alltag`.
  - Die Befunde des Agenten sind umgesetzt:
    - Pipe-Zeichen in der Matrix-Tabelle;
    - alter Name „Merima“ im Lacher am Kamin;
    - neue Verweisprüfung auf alte Namen.

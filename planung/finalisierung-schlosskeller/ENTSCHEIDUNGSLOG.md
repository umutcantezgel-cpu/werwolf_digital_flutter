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

## E-019 · Alle Brüche entschieden (F1-ORCH-03)
- **Verfahren:** Je Bruch ein Denkprotokoll in Kurzform. Wo nichts Stärkeres dagegen sprach, gilt der Vorschlag aus 7.3. Jede Entscheidung ist im Kanon umgesetzt und durch einen Test oder den Prüfer belegt. Spätere Phasen setzen Regeln um, die hier schon entschieden sind (Spalte „Beleg“ nennt das Abnahmekriterium).
- **Prüfwerkzeuge:** `kanon_schema_test`, `kanonVerweise`, `plausibilitaet_test`, `beweise_test`, `farbabstand_test`, `story_bibel_test`, `bin/party_pruefen.dart`.

### Teil 1 · B-01 bis B-17
| Nr | Entscheidung | Kanon / Beleg |
|---|---|---|
| B-01 | Vorschlag übernommen. Kaminsaal = West-Saal mit Kamin-Nische. Vorratsraum (Tatort) hinter der Theke. Turmgang hinter der Bogentür mit Rüstung, Vitrine und Wendeltreppe zum WC. Durchgang zwischen Kaminsaal und Buffetsaal. Windfang innen, Stufen außen. Genau ein Sicherungskasten (Kaminsaal, Ostwand). | `raeume.json`; Verweisprüfung; F-03 |
| B-02 | Herr Schneider schließt um 18:50 Hoftür und Außentor selbst ab. Es gibt einen Bund (Außentor, Hoftür, Turm). Wer ihn nimmt und wo er landet, legt jeder Pfad fest. | `raeume.json` Türen, `gegenstaende.json` bund_schneider, Tatmatrix; Ausgangslage im Prüfer |
| B-03 | Absperren im Dunkeln entfällt. Stufen außen, Windfang innen. Serkan steht am Außentor im Windfang, Marek im Durchgang. | Tatmatrix basis; b_serkan_tor |
| B-04 | Vorschlag übernommen. Deko-Kerzen elektrisch; echt nur der Messingkerzenständer. Der Kamin ist seit 23:30 aus. Restlicht: Notausgangsschild, Leuchtmaske, ab 23:59:30 Handylampen. | `raeume.json` Lichtquellen, `wahrnehmung.json`; Prüfer |
| B-05 | Mitternachts-Klammer übernommen: Torte im Vorratsraum, Tugbas Tortenplan, Tims Steckdose, Schneider will die Notlaterne holen, Zusammenstoß mit Can, danach der Schlag durch eine von vier Personen. | `zeitleiste.json`, Tatmatrix |
| B-06 | Ein Gegenstand „Leuchtmaske“: weiße Gespenstermaske mit nachleuchtender Farbe, Lichtquelle in der Tatmatrix. | `gegenstaende.json` leuchtmaske, `licht_maske` |
| B-07 | Splitter und Kalk an den Pulli-Ärmeln. Marek parkt im Schlosshof auf Schneiders Platz, darum wird durch Hoftür und Turm getragen. | `figuren.json` olli, `zeitleiste.json` z_lieferung, z_tuerschaden |
| B-08 | Schatulle um 23:40, Tasche ausgebeult um 23:45, Schneider findet die Vitrine um 23:53 und stellt Fatma um 23:56. | `zeitleiste.json` |
| B-09 | Ort angeglichen: vor der Vorratsraumtür. Schlüsselbeweis Can = Leuchtfarbe am Griff, Zusatzindiz = Wachs auf der Maske, beides nur im Can-Pfad. Die Kapuzenfasern sind pfadneutral (Schneider packt die Kapuze in jedem Pfad) und eine falsche Fährte. | `gegenstaende.json`; `beweise_test` |
| B-10 | Palette neu (Can, Emine, Azra, Aylin, Detektiv). ΔE2000 je Startraum ≥ 10 (min. 11,8), Beweisfarbe ≥ 20 (min. 22,9). | `figuren.json`; `farbabstand_test` |
| B-11 | Wer im Dunkeln rennt, ist in jedem Pfad Can mit der Leuchtmaske. Zeugen sehen nur ein leuchtendes Gesicht. | Tatmatrix; b_marek_gesicht, b_selin_gesicht |
| B-12 | Endenmatrix wie vorgeschlagen. | `fall.json` enden; F-07 |
| B-13 | Gezählt werden Rollen ohne Geburtstagskind. | `fall.json` personen, `besetzung.json` |
| B-14 | Alkoholfreier Apfelpunsch, kein Rauchen. Die Pfeife des Detektivs bläst Seifenblasen. Mareks E-Zigarette entfällt, er holt Saft. | `setting.json`, `figuren.json`; F-15 |
| B-15 | Namensbalance je Stufe II–V (E-014, E-020). Kopftuch auch bei Aylin (Kassenprüferin) und Emine (Lehrerin). „Hehler“ entfällt. Feld `alltag` entkoppelt Herkunft und Beruf. | `figuren.json`; F1-SENS-01 |
| B-16 | Wachsarten unterscheidbar: rotes Kerzenwachs am Tatort; braunes Möbelwachs an Ollis Handschuh und an der Bogentür (falsche Fährte, sicher widerlegbar). | `gegenstaende.json` arbeitshandschuh_olli, bogentuer_schaden |
| B-17 | Verlaufen: Olli um 20:15 (Lacher). Der Umschlag ist Ahmets Mietgeld-Umschlag (Ascheneimer). Spüle in der Einrichtung. Lichtschächte mit Klappen im Kaminsaal (Luftzug). Türschaden 18:35/18:50 und Schlichtung 23:00 stehen in der Zeitleiste. | `setting.json`, `zeitleiste.json`, `raeume.json` |

### Teil 2 · V-01 bis V-32
| Nr | Entscheidung | Kanon / Beleg |
|---|---|---|
| V-01 | Schneider geht in allen Pfaden denselben Weg; alle vier Motivszenen kommen in jedem Pfad vor (23:51, 23:56, 23:57). | Tatmatrix basis |
| V-02 | Der Handschuh liegt seit 19:30 in der Kamin-Nische (pfadneutral, falsche Fährte). Ollis Zusatzindiz ist der Bund im Eiskübel, in Reichweite. | `gegenstaende.json` |
| V-03 | Ahmets Jacke hängt ab 23:55 am Ständer; er trägt einen schwarzen Pulli über dem weißen T-Shirt. | `figuren.json`, z_jacke |
| V-04 | Beweis nur Messingabrieb; die Vitrine hat einen Holzrahmen ohne Messing. | `gegenstaende.json` silberring_fatma, vitrine |
| V-05 | Schneider ist kurz bewusstlos, hat eine Beule und eine Gedächtnislücke (ab 23:58:14). | `figuren.json` opfer, z_wach |
| V-06 | Tims alte Mehrfachsteckdose an der Kaffeemaschine; die Hauptsicherung fliegt; Tim schaltet um 0:00 im Kaminsaal wieder ein. | Tatmatrix, mehrfachsteckdose_tim |
| V-07 | Jedes Requisit trägt eine Funktion: Klemmbrett (Forderung, Miete 0 €), Quittungszettel, Hoftür, Lichtschacht-Klappen (Luftzug), Pawels Wissen (Schneiders Strenge), Notlaterne (Ziel Schneiders). | `gegenstaende.json`, `beobachtungen.json` |
| V-08 | Angeklagt werden nur die vier Kernverdächtigen. Erweiterungsrollen lügen nie. | `fall.json` kernverdaechtige; `luegen` leer |
| V-09 | Das Geburtstagskind sitzt ab 23:55 mit Augenbinde und Musik im Ost-Saal und ist nie verdächtig. | Tatmatrix; Prüfer |
| V-10 | Zeynep existiert in jeder Besetzung (W1), bei weniger als 10 Rollen als NPC-Gast. | `besetzung.json` |
| V-11 | Geheimnisse sind pfadneutrale Wahrnehmungen. Pfadwissen haben nur die vier Trenner-Zeugen, je genau einer. | `beobachtungen.json`; `plausibilitaet_test` |
| V-12 | Regel: Jede Kernrolle hat die gleichen Bausteine (Motivszene, Nähe zur Theke um 23:57, Nebendelikt mit Spur, mindestens eine widerlegbare Lüge, genau ein Trenner). Gleich viele erreichbare Belastungsfunde je Pfad legt das Entscheidungsmodell fest. | `figuren.json`, `beobachtungen.json`; F-06 (Simulator je Pfad) |
| V-13 | 1 Kachel = 1 m; Wege und Zeiten geprüft. | `raeume.json`; Prüfer |
| V-14 | Weißer Kalk vom Türbogen statt Lack. | `figuren.json` olli |
| V-15 | Jede Rolle hat `persoenlichesZiel` und `loyalitaet` als Quelle für Kosten und Nutzen der Gruppenwahl (E-013). | `figuren.json`; F-08 |
| V-16 | Alle außer dem Detektiv stimmen geheim; sichtbar ist nur die Qualität; Sabotage G-1. | E-013; F-08 |
| V-17 | Entschieden in E-008. | – |
| V-18 | Die Restmenge ergibt sich aus aufgedeckten Fakten (E-013). | F-06 |
| V-19 | Anker-Raster: Kernrollen höchstens 7 Pflichtgespräche je Runde (F2-ORCH-06). | F-09 |
| V-20 | W1: Jede Ursache existiert unabhängig von der Besetzung. | `besetzung.json` |
| V-21 | Besetzungsreihenfolge ab 5 Rollen mit höchstens einer Person Unterschied. | `besetzung.json`; `kanon_schema_test` |
| V-22 | Motive aus der Lage: Ahmet schämt sich für eine zu große Essensbestellung, Fatma ist ehrgeizig, Olli soll 2.000 € zahlen, Can wollte erschrecken. Die Bestechung wird zur Bitte um Aufschub. | `figuren.json` |
| V-23 | Loyalität individuell begründet (`loyalitaet.grund`). Emine schweigt aus Freundschaft; die Scherben-Vertuschung entfällt. | `figuren.json` |
| V-24 | Alle vier Taten geschehen in Panik im Dunkeln, ein Schlag. | `figuren.json` killerProfile, Tatmatrix |
| V-25 | Neue Etiketten aus der Funktion: „Die Designstudentin“, „Die Schreckhafte“, „Der Organisator“, „Der Spaßvogel“. | `figuren.json`; F1-SENS-01 |
| V-26 | Schneiders Ärger gilt nur Sachen und Geld; Feld `warmeSeite`. | `figuren.json` opfer |
| V-27 | Fachwortliste im TON-LEITFADEN; im Kanon ersetzt (Warmhaltebehälter, Spannungsprüfer-Schraubenzieher, Handyhalter, großer Teekocher, Buffettheke, Schlüsselband, Kapuzenpulli, Bauchtasche, Stoffhose). | `figuren.json`; F-10 (textpruefer_test) |
| V-28 | Namensbalance ohne Klangpaare; Feld `aussprache` für die Stimme. | `figuren.json`; E-020 |
| V-29 | „Buffettheke“, Getränke ausdrücklich genannt; Negativliste für Bildprompts. | `setting.json`; F-15 |
| V-30 | Stil- und Negativanker, keine Herkunftswörter in Prompts. | TON-LEITFADEN §9; F-13 (bildprompt_test) |
| V-31 | Spüle in der Einrichtung. | `raeume.json` spuele |
| V-32 | Renderer-Ergänzungen im Partymodus (Kopftuch erledigt; Fog, Licht, Ruhe-Animation, Tafel in F4). | E-016; F4 |

### Teil 3 · A-01 bis A-33
| Nr | Entscheidung | Kanon / Beleg |
|---|---|---|
| A-01 | Eine Buffettheke mit Anrichte dahinter. | `raeume.json` |
| A-02 | „Außentor“: zweiflügelige, eisenbeschlagene Eichentür mit Kastenschloss. | `raeume.json` aussentor |
| A-03 | Ein Bund. | bund_schneider |
| A-04 | Außen: Stufen zum Parkplatz. Schlosshof mit Schneiders reserviertem Platz hinter der Hoftür. | `setting.json`, `zeitleiste.json` |
| A-05 | „Jackenständer“. | `raeume.json` |
| A-06 | Durchgang, Turmgang, Windfang als einzige Gänge. | `raeume.json` |
| A-07 | Kamin-Nische im West-Saal, Anzeigename „Kaminsaal“. | `raeume.json` |
| A-08 | Sicherungskasten im Kaminsaal (Ostwand). | `raeume.json` |
| A-09 | Detektiv: markante Brille, braun karierter Hut, Lichtkegel vom Handy in der Hand, Seifenblasenpfeife, Kleidung aus dem JSON. | `figuren.json` detektiv |
| A-10 | Schneider startet im Buffetsaal. Die Stabtaschenlampe entfällt; er will die Notlaterne holen. Optik aus dem JSON. | `figuren.json` opfer |
| A-11 | Ahmet: Alibi „hinter der Theke“, Bart übernommen, Motiv ist die Bekanntgabe um zwölf. Umschlag im Kamin-Ascheneimer. Bitte um Aufschub statt Bestechung. Zu große Essensbestellung statt Schulden. | `figuren.json` ahmet |
| A-12 | Fatma: BAföG entfällt, dunkler Rollkragen, nur Messing am Ring, Polizei. Münzschatulle statt einzelner Münze; Vorgeschichte 23:40. | `figuren.json`, `zeitleiste.json` |
| A-13 | Olli: Bogentür; Splitter und Kalk an den Pulli-Ärmeln. Das Maßband trägt Wojtek. Fuß des Ständers. Tore zu bis zur Zahlung. Eis holen. Handschuh in der Kamin-Nische. | `figuren.json`, `gegenstaende.json` |
| A-14 | Can: Leuchtmaske, Versteck Vorratsraum, Schneiders Griff an die Kapuze, Maske bleibt in der Bauchtasche, Signalgelb #F5C400. | `figuren.json`, `gegenstaende.json` |
| A-15 | Zeynep: Schwester, weite hellgraue Hose, wusste von der Maske, steht am Bogen. | `figuren.json` |
| A-16 | Lejla: Ahmets Rechnung fürs Essen; Alibi mit den Tortentellern (E-015). | `figuren.json` |
| A-17 | Tim: Kaffeemaschine an der Mehrfachsteckdose; neue Wahrnehmung (Gesicht am Sicherungskasten); Alibi am Sicherungskasten. | `figuren.json` |
| A-18 | Emine: ohne Scherben-Vertuschung, am linken Buffettisch, schwarze Stiefel. | `figuren.json` |
| A-19 | Joanna: Stoffhose, Aufsteckleuchte am Handyhalter, Foto von 23:51. | `figuren.json`, foto_joanna |
| A-20 | Marek: reservierter Platz, Durchgang, keine E-Zigarette, Autoschlüssel. | `figuren.json` |
| A-21 | Baran: „Der Mann für die Musik“; Rufe statt unmöglicher Schritte. | `figuren.json` |
| A-22 | Hana: Kaminklappe nicht geöffnet. | `figuren.json`, `setting.json` |
| A-23 | Serkan: „Der Fahrdienst-Organisator“, wollte Decken holen, steht im Windfang. | `figuren.json` |
| A-24 | Der Quittungszettel stammt aus Schneiders Block und liegt in Aylins Mappe. | quittung_aylin, klemmbrett_schneider |
| A-25 | Wojtek: Arbeitshose mit verstärkten Knien; Möbelwachs statt Kitten; Satz von 23:52. | `figuren.json` |
| A-26 | Azra: Hehler entfällt; Schneider fand ihr Interesse an der Vitrine seltsam. | `figuren.json` |
| A-27 | Damir: „Der Teemeister“, schwarze Schürze, Theke. | `figuren.json` |
| A-28 | Selin: Kaminsaal; sieht das Leuchten der Maske. | `figuren.json` |
| A-29 | Pawel: Schlossstiftung; trinkt Tee. | `figuren.json` |
| A-30 | Tugba: Ablaufplan an der Wandtafel, Notizbuch, Liste von 23:57. | `figuren.json`, notizbuch_tugba |
| A-31 | Hexwert maßgeblich, dazu `farbname`. | `figuren.json` |
| A-32 | Koordinaten in Metern; Ermittlungsort statt freier Koordinaten. | `figuren.json`; Verweisprüfung |
| A-33 | Detektiv mit Farbcode, Startort und Look. Schneider mit Motiv und warmer Seite. Kernrollen mit Geheimnis. | `figuren.json` |

### Zusatzindizien aus dem Täter-System
Behzads Zusatzindizien werden ersetzt, wo sie nicht nur im eigenen Pfad entstehen können:

| Pfad | Quelle | Kanon | Grund |
|---|---|---|---|
| Ahmet | Schmierzettel in der Spüle | Wachs auf dem Umschlag | Schneiders Notiz gäbe es in jedem Pfad. Der Zettel entfällt; die Mietsache belegen Klemmbrett und Quittung. |
| Fatma | Münze mit Wachs | Schatulle mit Wachs | übernommen (Schatulle statt Münze, B-08) |
| Olli | Handschuh mit Wachs in der Kamin-Nische | Bund im Eiskübel | Den Handschuh gibt es in jedem Pfad; er bleibt als falsche Fährte mit braunem Möbelwachs (B-16, V-02). |
| Can | Delle mit Messingabrieb an der Maske; gelbe Fasern | Leuchtfarbe am Griff; Wachs auf der Maske | Der Griff durch die Maske passt nicht zur Panik. Die Fasern entstehen in jedem Pfad (B-09). |

## E-020 · Namensbalance und Klang (F1)
- **Zuordnung** (IDs bleiben Schlüssel, E-014):
  - Stufe II: Leyla → Lejla (bosnisch, Ahmets Cousine), Johanna → Joanna (polnisch).
  - Stufe III: Murat → Marek (polnisch), Meryem → Hana (bosnisch).
  - Stufe IV: Kaan → Wojtek (polnisch), Dilara → Azra (bosnisch).
  - Stufe V: Hakan → Pawel (polnisch), Enes → Damir (bosnisch).
- **Verworfene Zwischenstände und Grund:**
  - Merima: Klang nah an Marek.
  - Kuba: Reim auf Tugba.
  - Bartek: Anfang wie Baran.
  - Enis: Klang nah an Emine.
- **Herkünfte:** deutsch 2, türkisch 6, kurdisch 3, bosnisch 5, polnisch 4.
- **Sprache:** Das Feld `aussprache` steuert die Stimme (z. B. Can → „Dschan“, Tugba → „Tuuba“, Wojtek → „Woitek“).
- **Nachtrag (E-021):** Selin heißt Sibel (Reim Selin/Aylin, F1-SENS-01). Damit sind 9 Namen geändert; Stufe V bleibt ausgewogen.

## E-021 · F1-Prüfrunde: Entscheidungen zu F1-KONT-01, F1-KONT-02, F1-GEGEN-01, F1-SENS-01
- **Abnahmen:** Alle vier Berichte vollständig, mit Fundstellen und Endmarke.
  - `ABNAHME F1-KONT-01 · FREIGEGEBEN · 10/10`
  - `ABNAHME F1-KONT-02 · FREIGEGEBEN · 10/10`
  - `ABNAHME F1-GEGEN-01 · FREIGEGEBEN · 10/10`
  - `ABNAHME F1-SENS-01 · FREIGEGEBEN · 10/10`

| Befund | Entscheidung | Folge |
|---|---|---|
| KONT-01 #4, KONT-02 #3: Grund für das Mitnehmen des Bunds fehlt | Ü | Ein gemeinsamer Grund in allen vier Täterfassungen: In Panik reißt die Person den Bund ab, weil man mit dem Schlüssel rauskommt; gleich danach merkt sie, dass Flucht alles schlimmer macht, und versteckt ihn. |
| KONT-01 #3, KONT-02 #2: Anlass für Griff und Schlag | Ü | Herr Schneider zischt je Pfad leise einen Satz (Ereignis `ev_<pfad>_drohung`, nur die Täterperson ist näher als 1,5 m; der Wissensvergleich bestätigt das). Griffzeit gleich Ankunftszeit (Fatma, Olli 23:58:38). Fatmas Geheimnis begründet die sofortige Rückgabe. |
| KONT-01 #2: Sturz statt Gehen | Ü | Neues Tempo `faellt` (ohne Schrittgeräusch, Grenze wie Rennen). |
| KONT-01 #5: Verbleib des Mietgelds | Ü | Gegenstand `mietgeld` (2.850 € in Ahmets Hosentasche ab 0:12), widerlegt die Miet-Lüge. |
| KONT-01 #7: Handy-Merkmal nach 23:55 | Ü | Zeitleiste `z_handys` (0:05 Handys zurück); Ahmets Merkmal mit Zeitbezug, neue Ruhe-Animation. |
| KONT-01 #10: Belegfenster Leuchten | Ü | Bis 23:59:30. |
| KONT-01 #1, #11: Matrix-Schritte | V | Die 15-Sekunden-Matrix tastet genau zur Zeile ab; wer zur Zeile losgeht, steht dort noch am Start. Ereignisse zwischen den Zeilen stehen in der Tatmatrix-Datei. |
| KONT-01 #6, #8, #9 | V | Aylin hält die Quittung bewusst zurück (ihr Ziel). Pläne müssen nicht jede Reaktion zeigen. Beweisdichte ist je Pfad gleich: ein Schlüsselbeweis, ein Zusatzindiz. |
| KONT-02 #1: Schneiders Erinnerung | V | Die Gedächtnislücke für die Sekunden vor dem Schlag ist gewollt (V-05). |
| KONT-02 #4: Fatmas Beweis nicht sichtbar | V | Entscheidungen zielen auf Orte, Gegenstände und Personen (F-12). Fatmas Ring wird über eine Personen-Entscheidung untersucht, die es in allen Pfaden gibt (F2). |
| KONT-02 #5, #6 | V | Die Sichtungen sind anonym („leuchtendes Gesicht“) und widerlegen Cans Lüge nicht allein; die Ausbeulung widerlegt „nur Bücher“ nicht. Widerlegt wird über Fasern, Zeynep, Glassplitter und Schatulle. |
| KONT-02 #7–#11 | Ü | Spur der Schatulle (Hand, Tasche); „Herr Schneider am Ostende“; „kurz nach dem Scheppern“; Fasertext; Notizbuch widerlegt auch Fatmas Buffet-Lüge. |
| GEGEN-01 #1: Leuchtfarbe nur im Dunkeln | Ü | Spur ist ein Handabdruck aus grünlich-weißer Farbe, im Licht sichtbar. |
| GEGEN-01 #2: Abkürzung über den Bund | T | Kanon bleibt (vier gleiche Untersuchungsziele, Bund nie Kartenmarker). Regel für F2: Der Bund ist erst in Runde 3 suchbar, in einer Entscheidung mit höchstens drei Bereichen. |
| GEGEN-01 #3: Wortmarker in Trenner-Fassungen | Ü | Beide Fassungen je Trenner im gleichen Satzbau; „außer Atem“ gestrichen. |
| GEGEN-01 #4: Trenner-Zeugen bei kleiner Besetzung | Ü | Regel: Ist ein Zeuge unbesetzt, zeigt die Befragung eine NPC-Karte mit seiner Fassung (App: aus dem Kanon, Druck: versiegelt je Fall-Code). Umsetzung F2-ORCH-06, F5. |
| GEGEN-01 #5: Messing am Ring durch den Bund | Ü | Schlüssel aus dunklem Eisen am Stahlring (`schluesselbundMaterial`). |
| GEGEN-01 #6: Farbe am Griff in fremden Pfaden | Ü | Die Spur ist ein Handabdruck um den Griff; er entsteht nur durch festes Zupacken. |
| GEGEN-01 #7, #8, #11 | V | Damirs Spürzeile steht in der Tatmatrix; Ollis Ärmel sind sein Nebendelikt in allen Pfaden, der Schlüsselbeweis ist das Wachs am Fuß; der Hinweis im Kanon regelt den Bund. |
| GEGEN-01 #9, #10 | Ü | Handschuh-Zeitpunkt (18:45); verbogener Schaft als pfadneutrale Spur; Texte angeglichen. |
| SENS-01 1/2, B1: „bar“ | Ü | „2.000 € Bargeld“. |
| SENS-01 B2, B3: Ziffern in Texten | T | Kanon-Felder dürfen Ziffern tragen; Vorlesetexte (`texte/*.json`, F3) schreiben Uhrzeiten und Beträge in Worten. Der Textprüfer prüft nur Vorlesetexte. |
| SENS-01 B4: „Fall-Code“ in der Zeitleiste | Ü | Neutral formuliert. |
| SENS-01 B5, B6, B7, B8, B9, B10, B11, B13, B14 | Ü | Loyalität ohne Geldbezug. Marek „Der Caterer“, Parken nach Telefonauskunft. Wojtek „Der Architekturstudent“, schlank, mit Brille. Lejla ohne „trotzdem“. Hana und Sibel: Ziele über Sachen statt Spott. Fatma lächelt Emine zu. Aylin sachlich. Emine „Die Grundschullehrerin“, Zeynep „Die Fußballtrainerin“. |
| SENS-01 B12: Kopftuch bei 2 von 3 kurdischen Figuren | Ü | Das dritte Kopftuch geht von Aylin (kurdisch) zu Azra (bosnisch). Verteilung: kurdisch 1, türkisch 1, bosnisch 1, je unbelastet und kompetent außer Fatma. |
| SENS-01 B16 | V | Teemeister ist Quellenrolle und Getränk des Abends. |
| SENS-01 Namensklang | T | Selin → Sibel (Reim). Serkan, Can und Baran bleiben, weil die Anlaute klar verschieden sind. Hana/Azra bleiben. |

## E-022 · F1-Prüfrunde: Entscheidungen zu F1-KONT-03 (Pfad Olli)
- **Abnahme:** `ABNAHME F1-KONT-03 · FREIGEGEBEN · 10/10`. Vollständig, jede Fundstelle mit Gegenstelle, Selbstprüfung über alle vier Kernverdächtigen, Endmarke vorhanden.

| Befund | Entscheidung | Folge |
|---|---|---|
| #1 Sturz Schneider | schon erledigt (E-021) | Tempo `faellt`; die Matrix zeigt „fällt“ statt „geht“. |
| #2 Notlaterne „nie bis zu ihr gekommen“ | Ü | Spurtext: „Herr Schneider hat sie nie in die Hand bekommen.“ |
| #3 Handykorb vor 23:55 | Ü | Der Korb steht seit 23:50 auf der Tafel, ab 23:55 kommen die Handys hinein. Olli wartet 23:52:30 nicht mehr am Korb, sondern setzt sich an den Kopf der Ost-Tafel. |
| #4 Eis für Wojtek nie übergeben | Ü | Olli bringt Wojtek um 0:01 das Eis („Hier, dein Eis. Sorry, hat gedauert.“), danach zurück an die Ost-Tafel. Gilt in allen Pfaden; das Unschuldsprofil nennt es. |
| #5 Motiv für den Bund | schon erledigt (E-021) | Gemeinsamer Fluchtgrund in allen Täterfassungen. |
| #6 Olli neben Cans Fluchtweg | V | Das ist Ollis eigene Wahrnehmung im Olli-Pfad. Der Rechner erzeugt sie; das Täterdossier (F3) schöpft aus ihr. Eine Zeugen-Beobachtung braucht es nicht, weil Olli als Täter lügt. |
| #7 Griff vor Ankunft | schon erledigt (E-021) | Griff 23:58:38. |
| #8 Wachszustand | Ü | Zur Tat „noch weich“, als Spur „inzwischen erstarrt“; Schlüsselbeweis und Spurtext gleich formuliert. |
| #9 Handschuh in Weste und am Kamin | Ü | Merkmal: „ein Arbeitshandschuh hängt aus der Westentasche, der zweite liegt seit 19:30 am Kamin“. |
| Frage „um Mitternacht“ | V | Kanon gilt: Strom aus 23:58:00. „Um Mitternacht“ ist die Erzählweise der Gäste; Vorlesetexte sagen „kurz vor Mitternacht“. |
| Frage „wer legt Schneider hin“ | V | Sturz nach dem Schlag, in allen Pfaden gleich (`faellt`). |
| Frage „Bund unter dem Eis bis 0:02“ | V | Fluchtgrund aus E-021: Olli will nicht mehr fliehen und lässt den Bund liegen. Ab 0:00:18 brennt Licht, der Kübel steht mitten am Thekenende; ihn dort herauszuholen sähen alle. |

## E-023 · F1-Prüfrunde: Entscheidungen zu F1-KONT-04 (Pfad Can)
- **Abnahme:** `ABNAHME F1-KONT-04 · FREIGEGEBEN · 10/10`. Vollständig, Fundstellen mit Gegenstellen, Geschwindigkeiten nachgerechnet, Endmarke vorhanden. Der Prüfer las den Kanon teils vor dem Stand von E-021; Befunde #1 und #4 waren dort schon erledigt.

| Befund | Entscheidung | Folge |
|---|---|---|
| #1 Motiv für den Bund | schon erledigt (E-021) | Gemeinsamer Fluchtgrund; Can hört die Drohung `ev_can_drohung` aus unter 1,5 m. |
| #2 Auslöser für „Buuuh!“ | T | Auslöser ist die quietschende Vorratstür (`ev_vorratstuer_auf`, im selben Raum laut), nicht Schneiders Satz. Can glaubt, das Geburtstagskind wird schon zur Torte gebracht (`z_tortenplan`). Steht jetzt in Cans Motivtext. |
| #3 Gang zum Liegenden fehlt im Profil | Ü | „Herr Schneider stürzt in den Vorratsraum. Can kniet sich neben ihn und reißt in Panik den Bund vom Gürtel.“ |
| #4 Leuchtfarbe nur im Dunkeln | schon erledigt (E-021) | Handabdruck in grünlich-weißer Farbe, im Licht sichtbar. |
| #5 Maske und Fasern nicht sichtbar | V | Wie E-021 (KONT-02 #4): Entscheidungen zielen auch auf Personen; Bauchtasche und Schneiders Hand werden über Entscheidungen untersucht, die es in allen Pfaden gibt (F2). |
| #6 „unter einer Kapuze“ | Ü | Gestrichen; bei Eigenleuchten sieht man nur das Gesicht. |
| #7 Fasern als falsche Fährte im Pfad Can | Ü | Rolle je Pfad: in Ahmet, Fatma, Olli `falsche_faehrte`, in Can `ausgangslage`. |
| #8 Lichtschritt der Vorratslampe | Ü | Ereignis `ev_vorratslicht_aus` (23:54:20, Can). Das Einschalten stand schon als `ev_vorratslicht` (0:00:18, Damir). Die Lichtzeiten selbst stehen in `raeume.json`. |
| #9 Matrix nur 23:55–0:05, WC-Zusatzweg | V | Das Fenster ist F-04. Der Rechner prüft die Pläne 23:50–0:15 jede Sekunde und rechnet den Zusatzweg in die Weglänge ein; die Karte zeigt das WC an seiner Tür. |
| #10 „um Mitternacht“ | V | Wie E-022. |
| Frage 4: Ahmets Stelle | Ü | „hinter der Theke am Ostende“. |
| Fragen 1–3 | V | Nach 0:00 gibt es keine Dunkelphase; die Spur ist im Licht sichtbar. Zugang zu Bauchtasche und Zeitleiste regelt F2 (Entscheidungen und Pflichtgespräche). |

## E-024 · F2: Entscheidungsmodell, Restverdächtige, Bonus-Hinweise (Denkprotokoll)
- **Frage:** Wie werden die neun Entscheidungen so gebaut, dass bei bestem Spiel nach Runde 2 genau zwei und nach Runde 3 genau eine Person übrig sind? Dabei soll kein Bonus-Hinweis ausschließen, jede richtige Option eine Begründungskette haben und keine falsche Option einen Schlüsselbeweis oder ein Zusatzindiz zeigen.
- **Verworfen:**
  - **Trenner allein schließt aus.** Dann klärt Runde 1 den Fall fast ganz (drei Alibis, eine Spätankunft).
  - **Abwesenheit einer Spur schließt aus**, etwa „keine Farbe am Griff“. Dann löst eine falsche Option den Fall (Kerzenständer im Pfad Fatma).
  - **Richtig ist immer die Option zur Täterperson.** Dann schließen die falschen Optionen Unschuldige aus.
- **Gewählt: Regeln des Ermittlungsbogens**
  - **R-ENTLASTET:** Wer beim Scheppern nachweislich woanders war (Alibi aus einer Befragung) **und** wessen Heimlichtuerei belegt ist (Nebendelikt aus einer Entscheidung), scheidet aus.
  - **R-UEBERFUEHRT:** Ein Schlüsselbeweis überführt; alle anderen scheiden aus.
  - Spätankunft, Zusatzindiz, Fundort und Motiv belasten nur. Sie ändern den Stand, nicht die Restmenge.
  - Harmlose Fassungen sind neutral formuliert („mit rotem Wachs verschmiert“) und lösen keine Regel aus. Wer aus dem Fehlen einer Spur selbst schließt, spielt gut; die Restmenge bleibt eine sichere Untergrenze.
- **Runde 1, Das Alibi-Geflecht** (pfadunabhängig richtig): Befragung der Trenner Damir, Emine, Azra; die falschen Optionen sind Joanna, Tugba und Tim. Das ergibt Alibis oder eine Spätankunft. Marek ist keine Entscheidung; sein Trenner-Wissen kommt als wahrer Bonus-Hinweis in Runde 1.
- **Runde 2, Die Indizien-Filterung:**
  - e2_1 Ascheneimer oder Cans Bauchtasche. Pfadabhängig: im Pfad Can die Bauchtasche, weil dann alle anderen ein Alibi haben.
  - e2_2 Fatmas Tasche oder Vitrine.
  - e2_3 Olli untersuchen oder Kamin-Nische.
  - Ergebnis: Das Nebendelikt wird belegt, im Täterpfad zusätzlich das Zusatzindiz. Bei bestem Spiel bleiben genau zwei übrig: die Täterperson und Can, im Pfad Can Ahmet und Can.
- **Runde 3, Die finale Gegenüberstellung:**
  - e3_1 Bundsuche in einem von drei Bereichen.
  - e3_2 Kerzenständer genau untersuchen oder Fatmas Hände und Ring.
  - e3_3 Zeynep oder Aylin; deckt das letzte Nebendelikt auf.
  - Mit dem Schlüsselbeweis bleibt genau eine Person.
- **Kanon-Folgen, damit jeder Pfad gleich gebaut ist** (je ein Schlüsselbeweis, ein Zusatzindiz und ein Fundort des Bunds):
  - Ahmet: Schlüsselbeweis ist die abgerissene Umschlag-Ecke im Wachs am Griff. Der Bund in der Jacke wird Fundort.
  - Olli: Zusatzindiz ist rotes Kerzenwachs am rechten Arbeitshandschuh in der Westentasche; das passt zur Quelle, die einen Handschuh als Zusatzindiz nennt. Der Bund im Eiskübel wird Fundort.
  - Der linke Handschuh am Kamin ist nur noch rußig.
  - Neue Pflichtgespräch-Beobachtungen: `b_emine_versteck` und `b_azra_versteck`. Neue verborgene Beobachtung: `b_wojtek_tuer`.
  - Bei jedem belegten Nebendelikt gibt die Person es auf Nachfrage zu.
- **Bonus-Hinweise (36):**
  - **wahr:** Runde 1 die Spätankunft der Täterperson (im Pfad Can Mareks Satz über das leuchtende Gesicht), Runde 2 ein Geheimnis oder Motiv der Täterperson, Runde 3 eine Entlastung der zweiten Person, die bei bestem Spiel übrig ist. Die Entlastung schließt nie allein aus, weil R-ENTLASTET zusätzlich das belegte Nebendelikt verlangt (W-1). Korrigiert nach F2-FALL-01.
  - **neutral:** wahre, pfadgleiche Sätze über Kernpersonen ohne neuen Wert.
  - **falsch:** ein Gerücht über einen Unschuldigen in derselben Satzform wie die wahren Hinweise. Jedes Gerücht widerlegt eine Entscheidung, die im selben Pfad richtig ist (`widerlegtDurch`).
  - Hinweise wirken nie auf die Restmenge (W-1 scharf).
- **G-1 präzisiert:** Sichtbar ist nur, ob die Gruppe zusammengehalten hat (wahr) oder nicht (neutral oder falsch), nie die Zahl. Sonst wäre ein als falsch erkanntes Gerücht ein Freispruch.
- **Wertung:** Punkte sind nur die richtigen Detektiv-Entscheidungen (0–9). Die Gruppenwahl bringt Hinweise, keine Punkte.
- **Nachtrag (Simulator-Lauf):**
  - **Befund:** Im Pfad Can schließt die falsche Option e2_1 (Ascheneimer) Ahmet aus, die richtige (Cans Bauchtasche) nicht.
  - **Ursache:** Der Pfad, dessen Trenner Runde 1 nicht befragt, hat nach Runde 1 drei Alibis.
  - **Suche:** Eine erschöpfende Suche über alle Aufteilungen von Runde 2 mit fester Runde 1 (Damir, Emine, Azra) fand keine Aufteilung, in der bei bestem Spiel nach Runde 2 genau zwei übrig sind und keine falsche Option mehr ausschließt.
  - **Ergebnis:** Das ist strukturell: In einem Pfad muss die richtige Option statt eines Ausschlusses ein Indiz gegen die Täterperson liefern.
  - **Regel (Prüfung im Simulator):** Eine falsche Option darf nur dann mehr ausschließen als die richtige, wenn die richtige ein belastendes Indiz gegen die Täterperson zeigt (Spätankunft, Zusatzindiz, Fundort, Schlüsselbeweis).
  - **Begründung:** Für die Spielenden ist das auch inhaltlich richtig. Nach drei Alibis ist Cans Bauchtasche die naheliegende Wahl; Ahmets Nebendelikt klärt nur noch eine Lüge.

## E-025 · F2-Prüfrunde: Entscheidungen zu F2-TEST-01..04, F2-FALL-01, F2-GEGEN-01
- **Abnahmen:**
  - `F2-TEST-01`, `F2-TEST-02`, `F2-TEST-03`, `F2-TEST-04`: je FREIGEGEBEN · 10/10. 78 neue Tests, jede Prüfung mit Rot-Probe, nur eigene Dateien.
  - `F2-FALL-01`: FREIGEGEBEN · 10/10. Genaue Zahlen, fand die Abweichung in E-024.
  - `F2-GEGEN-01`: FREIGEGEBEN · 10/10. Drei schwere Befunde mit Schritten.
- **Offene Fragen der Testschreiber:**
  - Sabotage ohne kooperative Stimme ergibt 0 (Untergrenze, gewollt).
  - Der Laufzeittest unter 60 s bleibt, weil F-06 das Budget verlangt.
  - J3 (Widerlegung in derselben oder früheren Runde) bleibt als Zusatzprüfung.

| Befund | Entscheidung | Folge |
|---|---|---|
| GEGEN #1: Gruppenzeile je Runde verrät mit dem Hinweis die Wahrheit | Ü | Vor der Auflösung zeigt das Spiel weder Qualität noch Stimmenzahl. Das Resümee-Fach „Gruppenergebnis“ sagt nur, dass die Runde etwas zugeflüstert hat (`resuemee.gruppe.<runde>`). Erst die Auflösung nennt, wie oft die Gruppe zusammengehalten hat (`aufloesung.gruppe.<n>`). G-1 in fall.json angepasst. |
| GEGEN #2: Sabotage bei 4 Rollen sichtbar | Ü (durch #1) | Ohne sichtbare Qualität ist keine Täterwahl ablesbar. |
| GEGEN #3: Kerzenständer überführt allein in drei Pfaden | Ü | R-UEBERFUEHRT verlangt Schlüsselbeweis und Fundort des Bunds derselben Person. Restmenge 1 mit weniger als 9 Punkten fällt von 383 auf 127 Folgen je Pfad. |
| GEGEN #4, FALL #1: erste Option meist richtig | Ü | Die App mischt die Anzeige je Fall-Code (`Spiel.optionen`, deterministisch). Die Kanon-Reihenfolge ist ausgeglichen: Ratestrategien kommen auf 3–6 Punkte, kein Pfad erreicht Meister. Fragetexte von e2_2 und e2_3 nennen keine Person mehr. |
| GEGEN #5a, c, d | Ü | Kette e2_1 (Pfad Can) spricht von Alibis, nicht von Ausschluss. Ketten in Runde 1 nennen das Gegenargument zur falschen Option. |
| GEGEN #5b | T | e3_3 bleibt eine Entscheidung ohne Wirkung auf die Restmenge in drei Pfaden. Sie deckt das letzte Nebendelikt auf (F-06 „bei bestem Spiel jedes Nebendelikt“). Die Kette nennt jetzt den Grund. |
| GEGEN #6a, FALL #3 | T | Die R3-Entlastung bleibt; sie schließt nie allein aus. E-024 ist korrigiert. |
| GEGEN #6b | V | Die R3-Gerüchte über das Bund-Versteck widerlegt die Bundsuche. Eine Fassung in Alibi-Form ließe sich durch keine Entscheidung widerlegen, weil Marek keine Entscheidung ist. Ohne sichtbare Qualität ist die Satzform nur über viele Abende lernbar (NEBELKARTE). |
| GEGEN #6c | Ü | Neutrale Hinweise haben jetzt die Satzform der Runde und sind wahr in allen Pfaden: Tim am Sicherungskasten, Tims Steckdose, Serkan am Tor. |
| GEGEN #6d | Ü | Die Vitrine zeigt den Diebstahl, nicht die Person: Rolle `umgebung`. |
| GEGEN #6e | V | Die Lage-Stufe gibt nur wieder, was der Detektiv gerade selbst gelesen hat. |
| GEGEN #7 | V | B ist nicht dominant: A kostet die Rolle etwas, hilft aber dem Ende der Gruppe. Die Auflösung zeigt das persönliche Ziel (E-013). F3 macht A im Text verlockend. |
| FALL #2: wahre Hinweise nennen den Täter | V | Ohne sichtbare Qualität ist ein wahrer Satz über die Täterperson nicht von einem Gerücht über einen Unschuldigen zu unterscheiden. Die Bestätigung kommt erst über eine Entscheidung. |
| FALL #4 | V | Wie E-024, Nachtrag. |
| FALL #5 | Ü | Der Simulator-Bericht führt drei Ratestrategien je Pfad. |

- **Regelkreis Lernen:**
  - **L-04:** Prüfaufträge stellen das Rollenbriefing wortgleich aus ROLLENBRIEFINGS.md voran. In F2-FALL-01 und F2-GEGEN-01 war es gekürzt.
  - **L-05:** Aufträge, die nur neue Dateien anlegen, laufen ohne eigenen Arbeitsbaum direkt im Repo. Rückgaben werden vor dem Commit selbst nachgeprüft.

## E-026 · F3: Textsammlung und Zuschnitt der Autorenaufträge (F3-ORCH-00)
- **Textsammlung** unter `content/party/schlosskeller/texte/`:
  - Index, je Auftrag eine Datei, Schemas je Bereich (`texte-*.schema.json`).
  - Lader und Zusammensetzer: `party/texte.dart`. Prüfungen: `textVerweise` und `textLuecken`. Anleitung: `texte/SCHLUESSEL.md`.
- **Verweise statt Abschrift.** Dossiers nennen Tatsachen als `beobachtung:`, `luege:`, `nebendelikt:`, `zeitleiste:` oder `spur:`. Das Trenner-Wissen setzt der Code je Pfad ein. So kann niemand pfadabhängiges Wissen falsch abschreiben.
- **P-1 maschinell.** Pflichtgespräche geben nur eigene Pflichtgespräch-Beobachtungen und die Behauptung eigener Lügen preis. Nebendelikte bleiben am Tisch verborgen; sonst schließt die Runde mit einem Alibi aus Runde 1 zu früh aus.
- **Eine Quelle für Wahltexte.** Sie stehen in `texte/wahlen-*.json`; `gruppenwahl.json` hält nur noch die Struktur.
- **Aufträge:**
  - Entfallen als Schreibaufträge: F3-AUTOR-31..35. Bonus-, Indiz- und Entscheidungstexte stehen schon im Kanon und werden in den KONT- und SENS-Stapeln mitgeprüft; Korrekturen macht ORCH.
  - Varianten-Regel: F3-AUTOR-36..38 (Intro), F3-AUTOR-49..50 (Texte der vier Schlüsselbeweise als Vorschlag) und F3-AUTOR-57..58 (Wahltexte der Kernrollen, je zwei Fassungen).
  - Die übrigen Zuschnitte bleiben (Dossiers in Viererblöcken, Gespräche je Runde und Block).

## E-027 · F3 Welle 1: Abnahmen und Entscheidungen (Textprüfer, Dossiers, Täterfassungen, Detektiv, Intro)
- **Abnahmen (alle FREIGEGEBEN):**

  | Bericht | Punkte | Grund für Abzug |
  |---|---|---|
  | BAUMEISTER-01 | 10 | – |
  | AUTOR-10 | 10 | – |
  | AUTOR-01 | 8 | Schweigegründe falsch zugeordnet; Cans Griff stand unter „weiß“ |
  | AUTOR-02 | 9 | Geheimnisse unter „weiß“ |
  | AUTOR-03 | 9 | Platzhalter-Fragen im Text |
  | AUTOR-04 | 9 | Platzhalter-Fragen im Text |
  | AUTOR-05 | 9 | Platzhalter-Fragen im Text |
  | AUTOR-06 bis -09 | je 10 | – |
  | AUTOR-36 | 9 | – |
  | AUTOR-37 | 10 | gewählte Fassung |
  | AUTOR-38 | 9 | – |

  Die Mängel waren klein. ORCH hat sie direkt behoben statt nachbessern zu lassen; das ist schneller, und es ist keine Nachbesserung offen.
- **Textprüfer:**
  - `textLint` bekommt `regeln` als Parameter, weil `textregeln.json` fallneutral ist.
  - Kontextausnahmen in der Form `wort:kontext` sind übernommen (Kater nur Katze, Rauch und Qualm nur mit Kamin).
  - „Turm“, „Gang“, „Zugang“, „Eingang“ und „Raum“ stehen in `raumAusnahmen`: „Toilette im Turm“ ist Kanon-Wortlaut, die übrigen sind Allgemeinwörter.
  - Der Umfang bleibt bei den Spielertexten. Figurenfelder wie `motiveAndConflict` sieht niemand am Tisch.
  - Ob „alkoholfrei“ beim ersten Nennen steht, prüft der Sensibilitätsleser.
- **Kanon:** `spur_notiz_fehlende.zeigt` ist in zwei Sätze geteilt (vorher 29 Wörter).
- **Dossiers:**
  - Schweigegründe der Kernrollen kommen aus dem eigenen Geheimnis (Ahmet: Miete; Fatma: Scham über die Schatulle; Olli: Türschaden selbst klären; Can: Streich und Zeynep).
  - Was ein Geheimnis verrät, steht unter `verbirgt`: Cans Griff, Joannas Foto, Emines Polizeidrohung.
  - Rollen ohne Geheimnis bekommen einen ehrlichen Satz aus ihrem Ziel.
  - Öffentliche Beziehungen (Geschwister, Cousins, beste Freundinnen) dürfen in `wer` stehen; Zeynep: „Can ist dein Bruder.“
  - Dossiers sprechen mit „du“ an (TON-LEITFADEN §3 ergänzt).
- **Täterfassungen:** Spuren stehen in `tatwissen`, `verbirgt` hält Lügen und Nebendelikt (SCHLUESSEL.md angepasst). Die Fasern stehen nur bei Can, denn bei den anderen sind sie eine falsche Fährte.
- **Detektiv:** 12 Schlüssel (der Auftrag nannte irrtümlich 13). „Zur Tatzeit“ statt „Scheppern“, „Mantel“ statt „Trenchcoat“; beides bleibt.
- **Intro (Varianten-Regel):** Fassung 2 ist gewählt.
  - Kriterien: vorlesbar, Grusel mit Humor, Knall wie im Kanon, nicht besetzte Rollen neutral als „ein Gast“.
  - Fassung 1 lässt den Knall weg.
  - Fassung 3 erzählt als Erinnerung, obwohl das Intro am Abend spielt, und verrät mit „eine Freundin“ das Geschlecht nicht besetzter Rollen.

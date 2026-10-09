# META-PROMPT · BOLLWERK
## Erarbeite den Master-Prompt, mit dem das Schlosskeller-Spiel in einer Nacht um das 10- bis 100-Fache wächst, sichtbar schöner wird und sauber auf main landet

> Diesen Text gibst du Claude (Opus) in Claude Code. Er baut **nicht** am Spiel. Claude erarbeitet damit in 2–4 Stunden
> den **Master-Prompt BOLLWERK**, misst, prüft und übergibt ihn. Mit dem Master-Prompt startest du danach den Nachtlauf.
> Darin orchestriert Opus Tausende Haiku-5.5-Varianten und schützt sie mit einer Prüfmauer.
> Der Nachtlauf beginnt erst, wenn der Lauf „Finalisierung Schlosskeller“ fertig ist.

---

## 0. EINSTELLUNGEN (vor dem Start, durch den Nutzer)

- Sitzung: Claude Code (Cloud) mit dem Repo `umutcantezgel-cpu/werwolf_digital_flutter`.
- **Ultracode einschalten.**
- In `/config` **„Dynamic workflow size“** hochsetzen oder abschalten. Sonst gilt der Richtwert „unter 10 Agenten je Workflow“.
- Orchestrator: Opus. Arbeiter: **Haiku 5.5**:
  - Modellkennung `claude-haiku-5-5`
  - im Agent-Werkzeug `model: "haiku"`
  - im Workflow `agent(…, {model: 'claude-haiku-5-5'})`
- Den Meta-Lauf kannst du jederzeit starten. Er stellt keine Fragen. Was er selbst entscheidet, legt er dir am Ende als **Annahmen** vor. Du kannst jede davon kippen, bevor du den Nachtlauf startest.
- Den Nachtlauf startest du mit der Nachricht **„START BOLLWERK“**. Der Master-Prompt prüft dann selbst, ob seine Startbedingung erfüllt ist (§2.2 B-02).

---

## 1. AUFTRAG

Du bist der **Prompt-Architekt**. Dein einziges Produkt ist der **Master-Prompt BOLLWERK**, im Folgenden „der Master-Prompt“. Er steuert einen Nachtlauf, in dem ein Opus mit Tausenden Haiku-5.5-Varianten fünf Dinge erreicht:

1. Das Spiel „Spuk im Schlosskeller“ in der App „Mordakte“ wird rundenbasiert spielbar. Steuerung über Entscheidungen, sichtbare Aktionen der Figur, starker Würfel. Spielbar als Party an einem Gerät, solo mit Bots und im WLAN.
2. Das Spiel wächst gegenüber dem Stand nach dem Finalisierungs-Lauf um das **10- bis 100-Fache** (gemessen in §6, Abschnitt UMFANG).
3. Das Design wird im gewählten Look **signifikant aufgewertet**, nachweisbar mit Bildern und Maßen.
4. Alles Bestehende ist archiviert, Brauchbares wiederverwertet.
5. Alles landet **sauber auf main**.

Begriffe:
- **Meta-Lauf:** der Lauf, den dieser Text steuert.
- **Nachtlauf BOLLWERK:** der Lauf, den der Master-Prompt steuert.
- **Variante:** ein von einem Agenten erzeugter Kandidat, der geprüft und bewertet wird. Das kann ein Text, ein Datensatz, Code, ein Test, eine Pose, eine Requisite oder ein Bild sein.
- **Finalisierungs-Lauf:** der andere Lauf auf `origin/finalisierung-schlosskeller` mit Planung in `planung/finalisierung-schlosskeller/`.

Der Master-Prompt muss **für sich allein ausführbar** sein. Ein frischer Opus, der nur den Master-Prompt und das Repo kennt, arbeitet ihn ohne diese Unterhaltung und ohne Rückfragen ab, auch nach einer Kontext-Verdichtung mitten in der Nacht.

Im Meta-Lauf baust du nichts am Spiel. Du erfasst, entwirfst, misst und simulierst. Proben laufen nur im Scratchpad oder in Wegwerf-Worktrees. Danach schreibst du, lässt gegenprüfen und übergibst.

---

## 2. WAS DER NUTZER WILL

### 2.1 Wörtlich (2026-10-09; unverändert in den Master-Prompt übernehmen)

Auftrag:
> „kannst du einen Prompt zum generieren eines Promptes entwickeln welcher alles bestehende archiviert und wiederverwertet für das game look alike. Steuerung funktioniert über rundenbasierte folgen von entscheidungen welche den Charakter entsprechende aktionen durchführen lässt wie in den keller gehen sowie ein Luck (Würfel) System für den effekt der entscheidungen manchmal. Der Prompt der dein Prompt entwickeln soll soll dich über Stunden beschäftigt halten so das du die ganze nacht mit tausenden Haikiu 5.5 Varianten in Ulttracode ein Bollwerk schaffen kannst um das game zu finalisieren!“

Präzisierung auf die Frage nach dem Finalisierungs-Lauf:
> „erstelle einfach den Prompt zum entwickeln des Prompts um nach seinen arbeiten das Spiel um den Faktor 10X-100X zu erweitern und das Design signifikant aufzuwerten sowie alles sauber auf main zusammenzuführen und bestehende arbeiten wiederzuverwerten mit dem design wofür wir uns jetzt entschieden hatten“

Weitere Antworten:
- **Würfel:** „Stark“, also: Der Würfel entscheidet auch, ob eine Untersuchung gelingt. Misslingt sie, gibt es einen zweiten Anlauf oder einen Umweg; lösbar bleibt der Fall.
- **Spielformen:** Party an einem Gerät, Solo mit Bots und WLAN-Mehrspieler, also alle drei.
- **App-Start:** „Schlosskeller als Start“. Die App öffnet das Schlosskeller-Rundenspiel; Burgstadt und die klassischen Fälle bleiben über ein Menü erreichbar.
- Zuvor: **„starte alle agenten gleichzeitig“**. Unabhängige Agenten laufen immer gleichzeitig, nie nacheinander.

### 2.2 Feste Entscheidungen (gelten für Meta-Lauf und Nachtlauf)

| Nr. | Entscheidung | Quelle |
|---|---|---|
| B-01 | **Bild-Look + Leben.** Der Look der heutigen Schlosskeller-Vorschau bleibt die Grundlage: gezeichnete Iso-Szene, Figuren, Licht. Räume und Figuren werden nie aus Pixel-3D-Blöcken gebaut. FEINKORN-Technik (Physik, Teilchen, Material, Klangfamilien, Messwerkzeuge) dient nur als „Leben“. Pixel-Teilchen sind nur für Splitter und Staub erlaubt. | E-F021 auf `kern-feinkorn` |
| B-02 | **Start nach dem Finalisierungs-Lauf.** Der Nachtlauf baut auf dessen Ergebnis auf. Startbedingung: Tag `schlosskeller-1.0` liegt auf origin, **oder** `origin/main` enthält den F7-Abschluss des Finalisierungs-Laufs. Ist die Bedingung nicht erfüllt, arbeitet der Nachtlauf nur im **Vorlauf** (§6, Abschnitt STARTBEDINGUNG). | 2.1 „nach seinen arbeiten“ |
| B-03 | **Faktor 10–100×** beim Spielumfang, gemessen über die Umfangsmatrix gegenüber der Basis nach dem Finalisierungs-Lauf. | 2.1 |
| B-04 | **Design signifikant aufwerten**, innerhalb von B-01. | 2.1 |
| B-05 | **Alles sauber auf main:** jede Linie mit fertiger, grüner Arbeit; nichts geht verloren; ohne Force-Push; mit vollem grünem Lauf. | 2.1 |
| B-06 | **Würfel stark** (Wortlaut 2.1), mit Lösbarkeitsgarantie (§3.2 W-Regeln). | 2.1 |
| B-07 | **Spielformen:** Party an einem Gerät, Solo mit Bots, WLAN-Mehrspieler über das vorhandene `packages/room_host` (Host ist der Detektiv; im Browser nur als Gast möglich). | 2.1 |
| B-08 | **App-Start:** Das Schlosskeller-Rundenspiel wird der Startbildschirm. Burgstadt und die klassischen Fälle bleiben über ein Menü erreichbar. | 2.1 |
| B-09 | **Bilder:** Jedes erzeugte Bild geht in den Chat. Viele Varianten werden zu Kontaktbögen gebündelt. | Nutzerregel |
| B-10 | **Keine Rückfragen** im Meta-Lauf und im Nachtlauf. Entscheidungen fallen per Denkprotokoll. Alles Gestalterische, das wirklich der Nutzer entscheiden muss, kommt sofort nach FÜR-DEN-NUTZER, mit Standardwahl, und die Arbeit geht weiter. | Nutzerregel, Lehre Z-12 |
| B-11 | **Gleichzeitig:** Unabhängige Agenten starten immer gemeinsam. | 2.1 |

### 2.3 Deutung der Begriffe (verbindlich; steht genauso im Master-Prompt)

| Wort des Nutzers | Bedeutung |
|---|---|
| „game look alike“ / „Design, wofür wir uns entschieden hatten“ | Der Look des Referenzbilds: Iso 2:1, gezeichnete Figuren in Kanonfarben, Gewölbe, Kerzenlicht und Vignette. Er wird weiterentwickelt, nicht ersetzt. |
| „Design signifikant aufwerten“ | Im selben Stil deutlich reicher und lebendiger:<br>• Posen und Gesten<br>• 22 Ruhe-Animationen aus dem Kanon<br>• Mimik<br>• Licht und Nebel des Krieges<br>• Requisiten-Vollständigkeit<br>• Leben (Staub, Splitter, Wachs, Seifenblasen)<br>• Übergänge, Entscheidungskarten, Würfelbühne, Klang<br>Nachweis über Vorher/Nachher-Bildpaare je Raum, Strukturmaße und ein geeichtes Bewertungsgremium (§6, Abschnitt DESIGN). |
| „rundenbasierte Folgen von Entscheidungen“ | Spieler steuern **über Entscheidungen je Runde**. Entscheidungen bilden Ketten: Ein Ergebnis öffnet Folgeentscheidungen. Der Echtzeit-Joystick ist nicht mehr die Spielsteuerung; ob er als Zusatz bleibt, entscheidet der Meta-Lauf mit Begründung. |
| „den Charakter entsprechende Aktionen durchführen lässt wie in den keller gehen“ | Jede Entscheidung löst eine **sichtbare Aktion** der Figur aus, z. B. Weg gehen, Tür öffnen, Treppe, Raum betreten, untersuchen, befragen, Licht schalten, kauern, Seifenblasen. Keine Entscheidung ohne Bild. Wege laufen über den vorhandenen A*. |
| „Luck (Würfel) … manchmal“ + „Stark“ | Bei einem festgelegten Teil der Entscheidungen fällt ein **offen sichtbarer** Wurf. Er bestimmt Gelingen und Wirkung in Stufen und darf eine Untersuchung scheitern lassen. Dann folgt ein zweiter Anlauf oder ein Umweg. Die Lösung bleibt garantiert erreichbar (W-Regeln). |
| „10X–100X erweitern“ | Messbar über die **Umfangsmatrix** (§6, Abschnitt UMFANG). Je Achse gilt ein Ziel im Band 10–100× gegenüber der Basis. Wo 10× sinnlos wäre (z. B. Zahl der Täterpfade), steht die Begründung im Log, und andere Achsen gleichen aus. **Nie Füllstoff:** Jedes neue Stück besteht Prüfung und Gremium. |
| „alles bestehende archiviert und wiederverwertet“ | Nichts geht verloren. Jede Linie steht mit SHA im ARCHIV. Archiviert wird an Ort und Stelle; Ordner werden nicht verschoben, weil Code und Tests an ihnen hängen. Brauchbares wird mit Herkunftsvermerk übernommen. |
| „alles sauber auf main zusammenführen“ | Am Ende enthält main jede fertige, grüne Arbeit. Je Linie wird entschieden: zusammenführen, teilweise übernehmen oder nur archivieren, mit Begründung. Dafür gelten: voller Prüflauf grün, Vorfahrtest, kein Force-Push, neuer Tag `bollwerk-1.0`. |
| „Bollwerk“ | Zweierlei: (1) eine **Prüfmauer** in Schichten mit einem einzigen Torwerkzeug, das „BOLLWERK GRÜN“ meldet; (2) eine **Variantenproduktion** in großer Breite, aus der nur Geprüftes und Bestbewertetes übernommen wird. |
| „tausende Haiku 5.5 Varianten“ | Gezählt werden geprüfte Varianten, nicht Agenten. Das Nachtziel stammt aus **gemessenem** Durchsatz (§7). |
| „die ganze Nacht“ | Mindestens 8 Stunden ohne Leerlauf: Auftragsvorrat plus Nachschubregeln. |

---

## 3. HARTE REGELN

### 3.1 Für den Meta-Lauf
1. Kein Eingriff in App-Code, Pakete, Kanon, Tests, Werkzeuge oder Einstellungen des Repos.
2. Schreiben darfst du:
   - `planung/bollwerk/**`
   - Proben im **Scratchpad**
   - **Wegwerf-Worktrees** (`git worktree add --detach`), die nie committet und am Ende entfernt werden
3. Git:
   - Arbeitsbranch **`bollwerk`** aus aktuellem `origin/main`, im Worktree `/home/user/bollwerk`.
   - Committen nur `planung/bollwerk/**`, mit expliziter Pfadliste.
   - Pushen nur mit `git push -u origin bollwerk`, vorher `bash tool/secret_scan.sh`.
   - Verboten: Force-Push, umgeschriebene Geschichte, gelöschte Remote-Branches, überschriebene Tags, neue Remotes.
4. Netzwerk nur für Git mit `origin` und zum Installieren der Abhängigkeiten, die das Projekt schon hat.
5. Keine Rückfragen (B-10). Unklares entscheidest du per Denkprotokoll in `planung/bollwerk/ENTSCHEIDUNGSLOG.md`.
6. Jedes Bild geht in den Chat (B-09).
7. Agenten des Meta-Laufs arbeiten nur lesend, außer in ihrem eigenen Wegwerf-Worktree oder Scratchpad-Ordner. Sitzungs-, Agenten-, Trigger- und `mcp__claude-code-remote__*`-Werkzeuge rufen sie nie auf.

### 3.2 Für den Master-Prompt (vollständig übernehmen; Kernsätze wörtlich aus den bisherigen Master-Prompts)

**Git und Push**
- „Verboten sind Force-Push, umgeschriebene Geschichte auf geteilten Branches, gelöschte Remote-Branches und überschriebene Tags.“
- „Lehnt origin einen Push ab, weil jemand anderes gepusht hat: holen, zusammenführen, alles neu testen, erneut pushen. Höchstens drei Anläufe.“
- „Erzwingt eine Schutzregel Pull Requests, pushst du den Arbeitsbranch und öffnest einen Pull Request mit dem Abschlussbericht.“
- „Vor jedem Push läuft ein Secret-Scan. Schlüssel, .env-Dateien und der Rohchat kommen nie in den Verlauf.“
- Jeder Push nennt sein Ziel ausdrücklich.
- Commits nur mit expliziter Pfadliste, nie `git add -A`.
- „Jeder Commit baut und testet grün.“
- `tool/commit_gruen.sh` wird nicht benutzt: Es nutzt `git add -A` und pusht fest auf `nachtlauf/burgstadt`. Ein eigenes Commit-Skript nach dem Muster von `tool/hd_commit.sh` bekommt Branch, Sitzung und erlaubte Pfade als Parameter und läuft im sauberen Worktree.
- „Netzwerk nutzt du nur für Git mit dem bestehenden origin und für Paketinstallationen über die Paketverwaltung des Projekts. Keine neuen Remotes, kein Deployment, kein Hochladen zu fremden Diensten.“

**Bestandsschutz**
- „Diese Einstellungen fasst du nicht an: Build, Signatur, Store-Einträge, Berechtigungen, App-Kennung und Versionsnummer.“
- „Du lädst nichts in die Stores hoch.“
- „In die App kommen keine neuen Abhängigkeiten.“ Ausnahme: `flutter_test` (SDK) als Dev-Abhängigkeit für Golden- und Widget-Tests, mit Begründung im Log.
- „Die App verbindet sich mit nichts Neuem; bestehende Verbindungen bleiben, wie sie sind.“ WLAN läuft über das vorhandene `room_host`.
- „Zur Laufzeit lädt das Spiel nichts von fremden Servern.“ Web-Builds immer mit `--no-web-resources-cdn`.
- „Bestehende Funktionen, Daten und Speicherstände bleiben erhalten. Was du ersetzt, bleibt über einen Schalter erreichbar, bis die Abnahme bestanden ist.“
- „Werkzeuge, Prüfstand und Modellschau erscheinen nie in der veröffentlichten App.“
- Deploy-Dateien `netlify.toml`, `vercel.json`, `railway.toml`, `build.sh` und `server/` bleiben unberührt.

**Inhalt** (TON-LEITFADEN §1, §3–§7, §9 und VERBOTE-LEITPLANKEN wörtlich anhängen)
- Kein Alkohol, keine Drogen, kein Rauchen, auch nicht als Witz oder Redewendung. Keine Klischees, keine Fachbegriffe, keine Zungenbrecher.
- Herr Schneider überlebt in jedem Ende. Der Schlag ist nur als Schatten und Geräusch angedeutet, kein Blut.
- Die Pfeife des Detektivs bleibt eine Silhouette und bläst Seifenblasen.
- Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe.
- Sätze im Mittel höchstens 14 Wörter, keiner über 25. Die Runde wird mit „ihr“ angesprochen, Einzelne mit „du“, nie gesiezt.
- Erzähler und Spieltexte: zur Laufzeit nur feste, geprüfte Bausteine. Agenten erzeugen sie beim Bauen, das Spiel erzeugt nichts.
- „Das Spiel lügt nie mit eigener Stimme.“ „Eine falsche Entscheidung deckt Wahres auf, das weniger hilft – nie Falsches.“
- Original statt Kopie: keine Marken, keine echten Personen, nichts aus bestehenden Spielen.
- **Nur der Schlosskeller-Kanon** (`content/party/schlosskeller/`). `krimidinner/` und `nachtlauf/kanon` sind ein anderer Fall (Merle, Lüddecke) und werden nie vermischt.

**Würfel (W-Regeln, neu)**
- W-1 **Quelle:** Würfe nur über `Rng` aus `packages/mordakte_core/lib/src/util/rng.dart` (mulberry32). Der Seed ist ein **eigener Strom**: Fall-Code + Entscheidungs-Kennung + Zug + Versuch, über `Rng.hashString`. Nie aus `FallCode.rng()`, sonst korreliert der Wurf mit dem Täterpfad. Nie `dart:math Random`, `Zufall`, `Lcg` oder `FeinZufall` für Spiellogik. Bei Mehrspieler würfelt nur der Host.
- W-2 **Offen:** Jeder Wurf ist sichtbar, mit Wahrscheinlichkeit vorab, und wird protokolliert. Der Bestand hat sich bewusst gegen versteckten Losentscheid entschieden.
- W-3 **Stark, aber lösbar:**
  - Ein Wurf darf eine Untersuchung scheitern lassen.
  - Jedes Scheitern öffnet einen zweiten Anlauf mit Bonus oder einen Umweg zum selben Wissen.
  - **Pech-Garantie:** Auch bei durchgehend schlechtesten Würfen erreicht bestes Spiel jedes Schlüsselwissen innerhalb des Rundenbudgets. Belegt wird das durch eine Simulation mit „immer Pech“ über alle Pfade.
- W-4 **Wahrheit unantastbar:** Ein Wurf deckt nie Falsches auf und ändert weder Tatmatrix, Pfad, Schneiders Überleben noch die Wahrheit eines Fakts. Er verändert Gelingen, Tempo, Kosten, Zusatzwissen, Punkte gemäß Regelwerk, Atmosphäre und Gags.
- W-5 **Pfadgleichheit:** Der sichtbare Kartenzustand vor dem Finale ist bei gleichem Würfelstrom in allen Pfaden gleich (K-1).
- W-6 **Determinismus:** Gleicher Fall-Code + gleiche Eingaben + gleiche Würfe ergeben dasselbe Protokoll und dieselbe Prüfsumme, 1.000-mal wiederholt, auf VM und Web.

**Dateihoheit und Archiv**
- Nach dem Finalisierungs-Lauf (B-02) gehen dessen Dateien an BOLLWERK über: Kanon, `party/**`, `lib/party/**`, ORCH-Dateien. Bis dahin gilt seine Hoheit (§4.5) uneingeschränkt.
- `krimidinner/**`, `nachtlauf/kanon/**` und die textPfade von Burgstadt werden nie geändert.
- `Zufall`, `Lcg` und `tool/layout_pruefsumme.dart` bleiben unberührt, denn an ihnen hängt die Layout-Prüfsumme von Burgstadt.
- Archiv an Ort und Stelle. Keine Planungs- oder Kanon-Ordner verschieben, denn `findeRepoWurzel()` verlangt `nachtlauf/`, die pubspec-Assets nennen `krimidinner/…/10_kanon/` und `nachtlauf/kanon/ANPASSUNG.md`, und Tests lesen Planungsdateien.
- `tool/abnahme.dart` (Z-13 kennt nur feste Push-Ziele) wird als Nachtlauf-Abnahme eingefroren und nicht als Tor von BOLLWERK benutzt.

**Agenten**
- Haiku-Agenten rufen nie Sitzungs-, Agenten-, Trigger- oder `mcp__claude-code-remote__*`-Werkzeuge auf.
- Sie committen und pushen nicht und führen kein `flutter build` aus.
- Sie arbeiten in eigenen Dateien oder im eigenen Worktree (`git checkout --detach <commit>`).
- Rückgabe in **einer** Nachricht, höchstens 1.800 Wörter, Endmarke `=== ENDE [Kennung] · BEREIT ZUR RÜCKGABE ===`.
- Keine Backticks in Heredocs.
- „OFFENE FRAGE“ notieren statt raten.

**Rechenlast**
- Der Container hat 4 Kerne, etwa 16 GB und keine GPU.
- Schwere Läufe nur über einen Schwerlast-Slot mit `flock`, höchstens einer zugleich:
  - voller Testlauf
  - Web-Build
  - Chromium
  - Leistung
- Leistung wird in Thread-CPU-Zeit gemessen, nie unter Parallellast.
- Agenten schreiben nie in den Baum, in dem gemessen oder getestet wird.

---

## 4. AUSGANGSLAGE (Stand 2026-10-09 ≈ 18:45 UTC – in M1 frisch prüfen)

### 4.1 Linien im Repo
| Linie | Ref · SHA | Stand | Vorläufige Klasse |
|---|---|---|---|
| Veröffentlicht | `origin/main` e7e4219 | Nachtlauf Burgstadt gemergt. App startet in `/burgstadt` (`lib/main.dart:73`). Schlosskeller nur über `lib/game/dev/preview_main.dart?party=schlosskeller`. | Basis |
| Finalisierung Schlosskeller | `origin/finalisierung-schlosskeller` 914b696 | F3-Tor bestanden, Abnahme 9 von 17, nächster Schritt F4-ORCH-01. F4 = Partysitzung auf der Karte (`F4-ENTWURF-PARTYSITZUNG.md`). F5 = Druck, F6 = Härtung, F7 = Übergabe mit Tag `schlosskeller-1.0`. Neuester Kanon 1.0.0. | läuft; Startbedingung B-02 |
| Burgstadt HD | `origin/claude/pensive-gates-ajtp7x` caf1d61 | Pausiert, 49 von 306 Paketen, HZ 0/14. Auf main liegt HD bis 96e9e5b (Merge 0304eb2). 8 Commits nur auf diesem Branch, nicht Vorfahr von main: Lichttabelle v2, Texturen, Formen stuhl/bank/tisch v2, Sprechblasen-Layout mit `ui_test`, Anklage v2. Unfertiges als Patch in `hd/wip/`. | auf main zusammenführen (grün) oder begründet nur archivieren |
| FEINKORN | `origin/kern-feinkorn` 1145cb9 | Archiviert (E-F021). Bibliothek `package:pixel_engine/feinkorn.dart` mit 37 Tests. Messwerkzeuge `tool/feinkorn/{bestand.dart,messen.mjs}`. Planung mit Messbasis, Szenenvertrag, Kanon-Auszug, Bildbestand. | Teile übernehmen, Rest archivieren |
| Krimidinner | `krimidinner/spuk-im-gewoelbe/` auf main | Anderer Fall. Welle 0, 0 von 204. `10_kanon/` ist App-Asset. | nie anfassen |
| Nachtlauf | `nachtlauf/` auf main | `belege/abnahme.txt`: 12 von 14 (Z-03 und Z-12 offen; STATUS sagt veraltet 13 von 14). | einfrieren |
| Jules-Optimierung | 41 × `origin/loop/epoch-*` | Alle sind Vorfahren von main (Octopus-Merge 7b8dfa0 „ours“, d92a675). Code verworfen. | nicht verwenden |
| Sonstige | `claude/nifty-gauss-s82y27` = main; `claude/ecstatic-cerf-7kzi1c` d92a675 (gemergt) | – | – |

Flüchtig und vor Verlust zu sichern (lesen, Secret-Scan, dann nach `planung/bollwerk/archiv/` übernehmen):
- im Scratchpad: Burgstadt-HD-Gesamtplan, 35 Briefings, FEINKORN-Rohmessungen
- Worktrees `/home/user/wt/{basis,palette}`: palette entspricht `hd/wip/P1-OPUS-07.patch`

### 4.2 Spielkern (reines Dart, `packages/mordakte_core/lib/src/party/`)
Der Spielkern ist schon **rundenbasiert**. Es fehlt nur die Oberfläche.
- `ablauf.dart`: `Spiel` mit `PartyPhase` (titel, einrichtung, rollen, intro, gespraeche, entscheidungen, gruppenwahl, bonus, resuemee, anklage, finale, aufloesung, ende). `einrichten`, `weiter`, `optionen` (je Code gemischt, `ablauf.dart:128`), `waehle`, `abstimmen`, `anklagen`.
- `entscheidungen.dart` mit `content/party/schlosskeller/entscheidungen.json`: 9 Detektiv-Entscheidungen in 3 Runden, je 2–3 Optionen. Jede Option hat ein `ziel` (person, gegenstand oder raum), dazu 30 Fakten und die Regeln R-ENTLASTET/R-UEBERFUEHRT.
- `gruppenwahl.dart` (60 Wahlen, Sabotage), `bonus.json` (36 Hinweise), `enden.dart` (4 Enden), `fall_code.dart` (5 Zeichen, Seed), `erzaehler.dart` (Bausteine), `tatmatrix.dart` (Pläne 23:50–00:15 als Animationsvorlage), `raumgraph.dart` (A*, Sichtlinie, Licht, `karte`).
- `simulator.dart` + `bin/party_simulate.dart --pruefen`: erschöpfend 768 Folgen × 4 Pfade × 4 Anklagen in etwa 0,3 s. `test/party/determinismus_test.dart`: 1.000 Abende in etwa 1,2 s.
- Kanon in `content/party/schlosskeller/`:
  - 7 Räume, 43 Orte, 8 Türen, 53 Einrichtungsstücke, 10 Lichtquellen, nur eine Ebene, Wendeltreppe zum WC als Zusatzweg
  - 4 Täterpfade, 20 Rollen plus Detektiv und Herr Schneider, 28 Gegenstände, 36 Spuren, 33 Beobachtungen
  - 1.217 Texte, 16 Finaltexte
  - `wahrnehmung.json`: Tempo 1,0 / 1,5 / 2,5 m/s
- Kanonische sichtbare Handlungen (Tatmatrix): gehen, rennen, Haltung (steht, sitzt, kauert, liegt), sprechen, Geräusch, Licht an/aus, Tür öffnen (6 von 8 quietschen; Raum blendet in 0,4 s auf), Riechen und Fühlen, Gags an Rüstung und Kamin, Seifenblasen.
- Kanonisch ausgeschlossen: hinausgehen, Notlaterne, Kerzenständer nehmen, Gewalt spielbar zeigen.

### 4.3 Look (`lib/game/**`, Mordakte-Renderer)
- **Projektion und Kamera:** `iso_math.dart` (64/32/40). Render-Reihenfolge in `mordakte_game.dart:830–920`: Böden, Bodendekor, Tiefensortierung, Licht, nach Licht, Wetter, Overlays, Vignette. Die Kamera folgt nur der eigenen Figur; Zoom 0,42–2,4 × 0,6–1,8.
- **Palette:** `szenario_export.dart:22–40` (Akzent #ff9329, dayAmbient 0.62, nightAmbient 0.06). Licht in `lighting.dart`. Cutaway und Verdeckung hängen an `_playerRoom`.
- **Figuren:** `FigurePainter.standing` mit Gehen in 6 Ansichten, dazu `lying` und Schattenfigur. **Keine** Posen, keine Ruhe-Animation, keine Mimik. Die 22 `idleAnimation`-Texte im Kanon sind nicht umgesetzt.
- **Requisiten:** `prop_painter.dart` kennt 34 Arten, 11 davon sind genutzt. Umwidmungen: Wendeltreppe als Regal, Teekocher als Herd. Auf Tischen stehen per Zufall **grüne Flaschen**, das verletzt die Inhaltsregel.
- **Datenlücken im Export:** Detektiv im Spiel rot (#b23a48) statt Kanon #B8A48A. Herr Schneider steht als NPC. Hotspots und Items im Export sind leer.
- **Overlays:** `markers.dart` (Ring, Banner, Sprechblase, Fortschritt), UI-Bausteine `TypewriterText`, `PaperCard`, `Stamp`, Schriften SpecialElite und Inter.
- **Ton:** Das Iso-Spiel hat keinen. Klangsynthese gibt es in `tool/ton` (WAV, deterministisch), Ausgabe über `audioplayers`.
- **Leistung** (Browser ohne GPU): Vorschau 6–8 / 3–4 / 2–3 B/s (hoch, mittel, einfach), Last ≈ 1,0, „ruhig“ so teuer wie „bewegt“. FEINKORN-Messung: Vorgebackene Bilder waren rund 8× schneller.
- **Referenzbild:** `origin/kern-feinkorn:planung/feinkorn/bilder/k0/vorher_buffetsaal.png` (1280×720, Tagmodus, Buffetsaal).
- **Look-Vertrag (Entwurf):**
  - *unverändert:* Iso-Maße, Kamera, Zeichenreihenfolge, Palette, Licht, Cutaway, `FigurePainter`-Proportionen und -Stil, Bedien-Optik
  - *erweiterbar, nur additiv:* neue Sitzung, optionale Haken `session is …`, neue Maler in neuen Dateien, Flutter-Ebenen im Noir-Stil, Posen als optionale Parameter

### 4.4 Steuerung und Sitzung
- **Naht:** `lib/session/game_session.dart` (`world`, `caseView`, `events`, `move`, `send`). Daran hängen `LocalSession`, `OnlineSession`, `FakeSession`, `ScenarioPreviewSession` (Vorlage) und geplant `PartyKartenSession`. Der Renderer bleibt unverändert, wenn eine neue Sitzung Snapshots liefert.
- **Heutige Eingabe:** Echtzeit-Joystick und Aktionsknopf (`lib/game/input/*`, `game_view.dart`). Der Folgemodus des Renderers zeichnet von der Sitzung bewegte Figuren mit (`mordakte_game.dart:482`). `TileGrid.findPath` (A*) liegt im Kern.
- **Befehle:** `commands.dart` ist sealed und wird mit dem Server geteilt, also nicht anfassen. Party-Absichten bekommen einen eigenen Typ.
- **Mehrspieler-Grundlagen:**
  - `room_host` (`RaumSpiel`, `RaumHost` über `dart:io`, im Browser nur Gast)
  - `BurgstadtRaum` als Muster: Gastgeber = Detektiv, Bots für offene Rollen, `wahlFrist` 90 s
- **Ungenutzt für die Party:** Engine und Server der klassischen Mordakte arbeiten in Echtzeit (E-001).

### 4.5 Hoheit, solange der Finalisierungs-Lauf läuft
- **Gehört dem Finalisierungs-Lauf:**
  - `content/party/**`, `packages/mordakte_core/lib/src/party/**`, `bin/party_*`, `test/party/**`
  - `lib/party/**`, `tool/e2e/**`, `docs/partykrimi/**`, `planung/finalisierung-schlosskeller/**`
  - ORCH-Dateien: `pubspec.yaml`, `packages/mordakte_core/pubspec.yaml`, Barrel `mordakte_core.dart`, `lib/l10n/app_de.arb`, `analysis_options.yaml`, `build.sh`, `lib/app/router.dart`, `lib/main.dart`, `lib/ui/screens/hub_screen.dart`, `.gitignore`
  - nur zusätzlich und abgestimmt: `preview_main.dart`, `prop_painter.dart`
  - main und Tag `schlosskeller-1.0`
- Nach B-02 geht diese Hoheit an BOLLWERK.

### 4.6 Prüfwerkzeuge und Lücken
- **Tests:** 56 Testdateien auf main. Letzter Volllauf: 817 bestanden, 1 übersprungen (`nachtlauf/belege/alle_tests_voll.txt`). Finalisierung: 228 Party-Tests.
- **Laufzeiten:**
  - `tool/alle_tests.sh`: schnell 224–280 s, voll 587–671 s
  - `tool/pruefen.sh [schnell|alles|e2e]`: e2e kaputt, `tool/e2e/e2e.mjs` gab es nie
  - `flutter analyze`: 5–9 s
- **Fehlt ganz:**
  - Root-`test/`, `flutter_test`, Widget- und Golden-Tests: **der Look ist ungeschützt**
  - Ende-zu-Ende in der App
  - Bildvergleich
  - CI
- **Vorhanden und nutzbar:**
  - `tool/secret_scan.sh`
  - `tool/hd_commit.sh` (Muster: sauberer Worktree, Pfadliste)
  - `tool/hd_migbeleg.sh` (Bildsatz-Vergleich)
  - `tool/e2e/foto.mjs` (Fotos ohne Vergleich; braucht globales Playwright per `createRequire` wie `messen.mjs`)
  - `tool/browser/geraete.js`
  - `kern-feinkorn:tool/feinkorn/bestand.dart` (Bestandsprüfsumme) und `messen.mjs` (Chromium mit CPU-Drossel 1×/4×/6×)
  - `textpruefer.dart` mit `bin/party_texte.dart` (1.217 Texte, 0 Treffer)
  - `leitplanken.dart`
- **Bekannte Fallen:**
  - `|| echo` um Tests verschluckt Rot (E28)
  - Abnahme-Werkzeug endet still (E31)
  - Vor jedem Web-Build `rm -rf .dart_tool/flutter_build` (E52)
  - `pub get` in allen 8 Paketen, auch `tool/ton`, sonst 46 Analysefehler
  - Zeitabhängige Tests werden unter Parallellast rot
  - Haiku-Sichtprüfer treffen geeicht nur 77,8–88,9 %, deshalb Messbares strukturell prüfen

### 4.7 Wiederverwertbar (aus FEINKORN, HD, Nachtlauf)
- **FEINKORN (alle auf `kern-feinkorn`):**
  - `Physikwelt` (120 Hz, deterministisch; noch kein Körper-gegen-Körper)
  - `Starrkoerper` (`matrix()` zeigt die Oberseite eines Würfels)
  - Partikel-Pool mit Ablagerung
  - web-sichere Prüfsumme
  - Materialtabelle (14)
  - Szenenvertrag (`GehtZu`, `Zustand`, `TuerAuf`, `Angekommen` …)
  - `IsoAnsicht` (gleich `Iso`)
  - Trennungsprüfung
  - Messbasis und Bildbestand mit Lückenliste
- **HD und Burgstadt:**
  - `hashTeil` (VM = Web)
  - Sprechblasen-Layout (1.000 Lagen, 0 Überlappungen)
  - Maße und Varianten der Formen
  - Eichbilder-Methode
  - Thread-CPU-Leistungsmessung
  - Muster `Figur.auftrag` (Entscheidung → Auftrag → Bewegung)
  - `FallBots`/`spieleDurch` (Rundensimulator)
- **Ton:** `tool/ton` (44 deterministische WAVs) und `Tonausgabe` (Pool aus 6 Spielern).
- **Würfelgröße:** Ein echter Würfel wäre bei Standardzoom kleiner als ein Pixel. Die Würfelbühne braucht deshalb eine eigene Skala als Overlay. Das Ergebnis kommt vom Host über `Rng`, die Physik sorgt nur für die Darstellung (Seiten passend umbenennen).

### 4.8 Lehren aus den bisherigen Läufen (in den Master-Prompt übernehmen)
**Bewährt:**
- Ein Torwerkzeug ist die einzige Quelle für „ZIEL ERREICHT“; Belege sind an HEAD bzw. Inhalts-Hash gebunden.
- Commits nur grün, mit Pfadliste, im sauberen Worktree.
- Maßstäbe im Code statt Sichtprüfer-Meinung. Sichtprüfer mit Bildern mit bekannten Fehlern eichen.
- Paketvertrag: höchstens 400 Zeilen plus Test plus Probe, höchstens 2 Nachbesserungen, dann übernimmt Opus.
- Rollenbriefings mit den „drei häufigsten Fehlern“.
- Variantenregel ★: An Schlüsselstellen bauen 2–3 Haiku parallel.
- Abbruchregel für Prüfschleifen.
- PRÜFPUNKT, STATUS, stündliches NACHTPROTOKOLL mit echter Uhrzeit (`TZ=Europe/Berlin date`), MORGENBERICHT um 07:00.
- **Früh Bilder zeigen:** FEINKORN wurde nach einer Stunde statt nach Tagen korrigiert.

**Fehler:**
- E28, E31, E36, E52.
- Agenten schreiben in den Messbaum.
- Z-12 lief 27 Runden ohne Konvergenz. Gestaltungsfragen gehören sofort zum Nutzer.
- Handkorrekturen haben Fehler nur verschoben.
- Große Pläne wurden von Richtungswechseln überholt. Deshalb kommt der **Durchstich zuerst** (eine Entscheidung → sichtbare Aktion → Würfel, mit Bild), bevor Wellen breit ausrollen.

**Durchsatz:** HD schaffte 15–20 Haiku-Pakete je Stunde bei 4 Plätzen.

### 4.9 Umgebung und Kapazität
- 4 Kerne, etwa 16 GB, keine GPU, kein Android-SDK, kein Xcode.
- Flutter 3.47.6 unter `/opt/flutter/bin` (nicht auf PATH), Node 22 unter `/opt/node22`, Chromium unter `/opt/pw-browsers`.
- **Gemessen am 2026-10-09:**
  - Ein Workflow lässt auf diesem Container höchstens **2** Agenten gleichzeitig laufen, nach der Regel min(16, Kerne − 2). Höchstens 1.000 Agenten je Workflow-Lebensdauer.
  - **8 direkte Hintergrund-Agenten liefen gleichzeitig.** Jeder brauchte 8–11 min und 260–345 Tsd. Tokens für eine breite Leseaufgabe.

### 4.10 Umfang heute (Basis für B-03; in M1 nach dem Finalisierungs-Lauf neu zählen)
| Achse | Heute (main / Finalisierung F3) |
|---|---|
| Spielbare Spielformen | 0 (nur Entwickler-Vorschau) |
| Wertende Entscheidungen | 9 in 3 Runden |
| Entscheidungsketten bzw. Folgeentscheidungen | 0 |
| Sichtbare Aktionsarten mit Animation | 1 (gehen) |
| Posen und Gesten | 0 (stehen, gehen, liegen) |
| Umgesetzte Ruhe-Animationen | 0 von 22 |
| Würfelereignisse bzw. Würfeltabellen | 0 |
| Räume / Orte | 7 / 43 |
| Genutzte Requisitenarten | 11 von 34 |
| Texte bzw. Bausteine | 1.217 |
| Gags und Nebenhandlungen | 3 Lacher |
| Leben-Effekte (Teilchen, Physik, Klang) | 0 im Spiel |
| Unterscheidbare Partieverläufe | 768 Folgen × 4 Pfade × Fall-Codes |
| Tests (Party / gesamt) | 228 / 817 |

### 4.11 Vorarbeit Spielmechanik (Startentwurf für M3, kein Endstand)

**Kanonlage**
- **Raumgraph:** ein Baum mit dem Buffetsaal als Knoten:
  - Buffetsaal – Vorratsraum
  - Buffetsaal – Durchgang – Kaminsaal – Turmgang
  - Buffetsaal – Ostsaal
  - Buffetsaal – Windfang
- **„In den Keller gehen“:** Alle sind schon im Gewölbe. Konkret wird daraus z. B. „In den Vorratsraum hinter der Theke gehen“, „durch den Durchgang in den Kaminsaal“ oder „durch die Bogentür in den Turmgang“.
- **Licht während der Ermittlung:** Strom an, Kerzen aus, Lichtkegel vom Handy des Detektivs.
- **Rundenuhr:** 45 Nachtminuten je Runde (00:30 / 01:15 / 02:00, Finale 02:45).
- **Detektiv** = Geburtstagskind am `geburtstagsplatz` (Ostsaal). **Herr Schneider** sitzt mit Kühlpack `hinter_rechtem_buffet`.

**Empfohlene Mischung „Karten mit Abstechern“**
- Jede der 9 Kanon-Entscheidungen wird ein Zug mit 2–3 Karten. Die gewählte Karte läuft als sichtbare Szene ab: Weg, Pose, Lampe, Fundkarte.
- Zwischen den Pflichtzügen gibt es **Abstecher** mit echten Wegen, z. B. Vorratsraum, Tee für Herrn Schneider, Tims Stirnlampe, Seifenblasen.
- Ansatz „gründlich“ (sicher, teurer) oder „zügig“ (mit Wurf).
- **Würfel:** 2W6 + Modifikator (Gegenstand +1, Helfer mit passendem Fachgebiet +1; Kernrollen helfen nur beim Befragen).
  - Stufen: 10+ Erfolg, 7–9 Teilerfolg, 6− Pech.
  - Chancen werden vorher in Prozent gezeigt.
- **Pech-Ausgleich:**
  - Seifenblasen-Marken: höchstens 3, je Marke +1.
  - Nach zwei Pech in Folge ist der nächste Wurf mindestens Teilerfolg.
  - Jedes Pech endet in einer kleinen, pfadgleichen Szene mit Glück im Unglück.
- Pflichtkarten kosten pauschal, ohne Wegkosten. Das verhindert die räumliche Schlagseite: Ein Geiz-Bot holte sonst 5–6 statt 4,33 Punkte.
- Seed `glueck:<code>:<wurfNr>`; Neutralmodus und „Tischwurf“ möglich.
- **Weißliste der Zusatzinfos:** pfadgleich, nicht verborgen, keine Faktquelle. Die Liste im Bericht beginnt mit `b_baran_rufe`, `b_hana_wachs`, `spur_laterne_unberuehrt`, `spur_torte` und den 3 Lachern.
- **Ausgeschlossen:** u. a. `b_zeynep_vorrat`, `b_damir_*`, `b_wojtek_tuer`, `spur_fasern_kapuze`.

**Anpassung an „Stark“ (B-06, Pflicht für M3)**
- Pech heißt: Die Untersuchung bringt das Wissen **noch nicht**. Danach gibt es einen **zweiten Anlauf** mit Bonus, der Nachtminuten kostet, oder einen **Umweg** zum selben Wissen, z. B. über einen Helfer oder einen anderen Zugang.
- Teilerfolg bringt das Wissen. Erfolg bringt das Wissen plus Zusatz.
- **Pech-Garantie:** Spätestens der dritte Anlauf ist mindestens Teilerfolg. Alle Fakten der Runde sind auch bei „immer Pech“ innerhalb der 45 Nachtminuten erreichbar.
- **Abnahme:** Der Endstand der Fakten je Runde ist identisch zum Neutrallauf; nur Zeitpunkt, Kosten und Zusatz unterscheiden sich.

**Abnahmekriterien als Startpunkt**
- Lösbarkeit: 10.000 Seeds × 4 Pfade.
- Glücksanteil am Ende ≤ 3 % gegenüber Neutralwürfeln, η² ≤ 0,05.
- Keine Sackgassen.
- Pfadgleichheit K-1 erweitert auf Skripte, Würfe und Pech-Szenen.
- Würfel unabhängig von der Gruppenwahl.
- Weißliste eingehalten.
- Kostenneutralität: Geiz-Bot ≤ 4,8 Punkte, |ρ| ≤ 0,2.
- Längste Pech-Serie ≤ 2.
- Szene je Zug Median ≤ 12 s, P95 ≤ 20 s, in ≤ 1 s überspringbar.
- Jede Entscheidung sichtbar: Weg > 0,5 m plus Pose; E2E-Foto mit dem Detektiv ≤ 1,5 m vom Ziel.
- Determinismus ×1000 auf VM und Web.
- Bots: 1.000 Partien je Pfad ohne Eingriff.

Diese Kriterien gelten für 9 Entscheidungen. Für den Umfang 10–100× rechnet M3 sie auf die erweiterte Struktur hoch.

---

## 5. ABLAUF DES META-LAUFS (M1–M8)

Unabhängige Agenten startest du **gleichzeitig** (B-11): als Hintergrund-Agenten in **einer** Nachricht und/oder in mehreren Workflows nebeneinander.

### M1 · Bestand, Startbedingung, Archiv, Umfangsbasis
1. Hole den Stand: `git fetch origin`. Notiere jede Linie mit SHA. Prüfe B-02: `git ls-remote --tags origin schlosskeller-1.0` und den Stand des Finalisierungs-Laufs (STATUS, letzter Commit, Abnahme).
2. Starte **mindestens 8 Leser gleichzeitig**, einen je Bereich:
   - Archiv und Regeln
   - Look
   - Steuerung und Sitzung
   - Runden und Zufall
   - Kanon und Hoheit
   - Prüf-Infrastruktur
   - Wiederverwertung
   - Umfangszählung
   
   Prüfe die Fakten aus §4 nach und ergänze, was sich seither geändert hat. Selbst prüfst du eine Stichprobe von 10 % nach. Bei mehr als 1 Fehler wird der Bereich neu erfasst.
3. Sichere das Flüchtige aus §4.1: Lies es, lass den Secret-Scan laufen und lege es unter `planung/bollwerk/archiv/` ab.
4. Ergebnisse:
   - `ARCHIV.md` (Linie · Ref · SHA · Inhalt · Klasse *zusammenführen / teilweise / nur archivieren / verwerfen* · Begründung)
   - `BESTAND.md`
   - `HOHEIT.md` (vor und nach B-02)
   - `UMFANG-BASIS.md` (Zählskripte und Werte je Achse, mit Befehl)

### M2 · Look-Vertrag, Referenzbilder, Design-Turnier
1. **Referenzbilder:** In einem Wegwerf-Worktree baust du die Vorschau und fotografierst sie je Raum, hochkant und quer, bei Tag und bei Nacht (`foto.mjs` bzw. `messen.mjs` mit `createRequire`). Die Bilder gehen als Kontaktbogen in den Chat.
2. Schreibe `LOOK-VERTRAG.md`: unverändert, erweiterbar, Messweg. Der Messweg sind Golden-Bilder mit fester Uhr; dafür ist ein optionaler Zeit-Haken nötig.
3. **Design-Turnier „signifikant aufwerten“:**
   - Lass mindestens 4 Aufwertungsrichtungen **im selben Stil** entwerfen, zum Beispiel:
     - Figuren lebendig (Posen, Ruhe-Animationen, Mimik)
     - Licht und Atmosphäre (Kerzen, Nebel des Krieges, Staub im Licht)
     - Raum-Reichtum (alle Requisiten, Wandschmuck, Boden-Details)
     - Bühne und Bedienung (Entscheidungskarten, Würfelbühne, Übergänge)
   - Je Richtung eine **Probe**: Vorher/Nachher-Ausschnitt, gemalt im Wegwerf-Worktree oder Scratchpad, nie committet, höchstens 60 Minuten je Probe. Alle Proben gehen in den Chat.
   - Ein Richtergremium mit 5 Linsen bewertet: Treue zum Look, Lesbarkeit am Handy, Atmosphäre, Leistungskosten, Bauaufwand.
   - Ergebnis: `DESIGN-AUFWERTUNG.md` mit Prioritäten, Strukturmaßen und dem Bewertungsweg aus §6, Abschnitt DESIGN.

### M3 · Spielmechanik-Turnier
1. **Entwürfe:** Mindestens 4 vollständige Entwürfe, unabhängig voneinander (Opus). Dazu mindestens 30 Haiku-Varianten zu Teilfragen:
   - Rundenstruktur für Party, Solo und WLAN
   - Ketten von Folgeentscheidungen
   - Würfel: Art, Schwellen, Modifikatoren aus Rolle und Gegenständen, Stufen, zweiter Anlauf, Umwege, Pech-Garantie
   - Würfelbühne
   - Aktionskatalog mit Kanon-Beleg
   - Bots für Gruppenwahl und Mitspieler
   - Ausbauachsen für 10–100×
2. **Richter:** 6 Linsen, je 0–10:
   - Partyspaß (4–20 Spieler)
   - Solo-Spaß
   - Fairness und Pech-Garantie
   - Kanon-Treue
   - Umsetzbarkeit im Look
   - Skalierbarkeit auf 10–100×
3. **Synthese:** Nimm den Sieger und übernimm die besten Ideen der anderen, jeweils mit Begründung.
4. **Simulationsprobe** im Scratchpad: reines Dart, das die vorhandenen Kernklassen nur importiert.
   - Je Täterpfad 10.000 Partien mit Seeds und den Strategien bestes Spiel, zufällig, erste Option und **immer Pech**.
   - Zu messen:
     - Lösbarkeit mit bestem Spiel bei immer Pech (Soll 100 %)
     - Sackgassen (Soll 0)
     - Glücksanteil am Ausgang
     - Rundenzahl und Dauer
     - Verteilung der Würfelstufen
     - Anteil der Entscheidungen mit Wurf
   - Reichen die Zahlen nicht, änderst du die Regeln und simulierst neu.
5. **Ergebnis:** `SPIELMECHANIK.md` mit
   - Regeln
   - JSON-Schemas für Entscheidung, Kette, Aktion, Wurf und Protokoll
   - Aktionskatalog (Aktion → Kanon-Beleg → Animation)
   - drei durchgespielten Beispielrunden, eine davon „in den Keller gehen“
   - Simulationszahlen
   - Rollenbots
   - WLAN-Protokoll über `RaumSpiel`

### M4 · Durchsatzmessung (Pilot)
- **Echter Pilot, alles gleichzeitig:**
  - 3 Workflows mit je 8 Haiku-Agenten
  - 12 direkte Hintergrund-Agenten (`model: "haiku"`)
- **Typische Nachtaufgaben** mit strukturierter Ausgabe:
  - je Agent 15 Entscheidungskarten-Varianten
  - 1 Testdatei mit Rot-Probe
  - 1 Posen-Variante als Code
  - 1 Prüfbericht
- **Zu messen:**
  - Dauer je Agent (Median, p90)
  - tatsächliche Gleichzeitigkeit
  - Varianten je Stunde
  - Ausfälle (null)
  - Anteil verwertbarer Varianten (Richterurteil ≥ 7/10, Inhaltsprüfer 0 Treffer)
  - Token je Variante
  - CPU-Last und Plattenverbrauch
- **Nachtkapazität** = gemessene Rate × 8 h × 0,6.
- Ergebnis: `DURCHSATZ.md`. Die Zahlen werden die Ziele des Master-Prompts.

### M5 · Master-Prompt schreiben
- Schreibe `planung/bollwerk/MASTER-PROMPT.md` nach §6, im Stil der bisherigen Master-Prompts:
  - Deutsch, „du“, nummerierte Abschnitte
  - jede Regel nur einmal
  - feste Vorrangordnung
  - messbare Kriterien
- Der Hauptteil hat höchstens 10.000 Wörter. Anhänge sind erlaubt: Auftragsvorrat, Schemas, Rollenbriefings, Kanon-Auszüge, Regeltexte.

### M6 · Gegenprüfung bis zur Ruhe
- Starte je Runde **gleichzeitig 8 Gegenprüfer**. Jeder versucht, den Master-Prompt zu brechen, mit einer eigenen Linse:
  1. **Ausführbarkeit:** Gibt es jeden Pfad, Befehl und jedes Werkzeug wirklich? Ist jeder erste Schritt eindeutig?
  2. **Regeln und Sicherheit:** Sind alle aus §3.2 enthalten? Gibt es Schlupflöcher? Ist die Hoheit vor und nach B-02 gewahrt?
  3. **Spielentwurf:** Spaß, Fairness, Pech-Garantie, Kanon, Sackgassen.
  4. **Durchhalten 8 h+:** Vorrat, Nachschub, Verdichtung, Wiederaufnahme, Herzschlag, CPU, Platte.
  5. **Bollwerk und Messbarkeit:** Hat jedes Kriterium einen Befehl und eine Schwelle?
  6. **Look und Design:** Kann ein Auftrag den Look brechen? Ist „signifikant“ belegbar?
  7. **Umfang 10–100× und Füllstoff-Schutz:** Werden Zahlen nur aufgebläht?
  8. **Zusammenführung auf main:** Reihenfolge, Konflikte, Vorfahrtests, Burgstadt-Schutz.
- Zusätzlich prüft ein **Vollständigkeitskritiker**.
- Jeder Befund geht an 3 Skeptiker. Er gilt, wenn mindestens 2 ihn bestätigen.
- Dedupliziere gegen **alle** je gesehenen Befunde.
- Schluss nach 2 ruhigen Runden oder nach 4 Runden. Der begründete Rest kommt ins Log.

### M7 · Trockenlauf
- Ein frischer Agent bekommt **nur** Master-Prompt und Repo. Er spielt die ersten 90 Minuten des Nachtlaufs auf dem Papier durch, mit jedem Befehl, jeder Datei und jedem Auftrag. Er meldet Blocker, fehlende Fakten und mehrdeutige Anweisungen.
- Ein zweiter frischer Agent spielt einen Haiku-Auftrag aus dem Vorrat durch (Vorlage, Hoheit, Rückgabe, 5-Punkte-Prüfung).
- Ein dritter frischer Agent spielt den **Vorlauf** durch, also den Fall „Startbedingung nicht erfüllt“.
- Fixe alles und wiederhole, bis 0 Blocker übrig sind.

### M8 · Übergabe
- `ANNAHMEN.md`: Was du selbst entschieden hast, wo der Nutzer anders entscheiden könnte, und deine Standardwahl. Höchstens 8 Punkte, jeder mit Folge. Es gibt **keine Wartefrage**.
- Commit und Push von `planung/bollwerk/**` auf `bollwerk` mit Secret-Scan. Wegwerf-Worktrees entfernen.
- **Chat:**
  - Zusammenfassung in 10 Zeilen
  - Dateiliste
  - Kontaktbögen (Referenz und Design-Proben)
  - Annahmen
  - Startanweisung „START BOLLWERK“
  - Ist B-02 noch nicht erfüllt: ein Hinweis, dass der Nachtlauf dann nur den Vorlauf macht
- Kippt der Nutzer Annahmen, arbeitest du sie ein und pushst erneut.

---

## 6. PFLICHTINHALT DES MASTER-PROMPTS

Der Master-Prompt hat diese Abschnitte. Jeder erfüllt die Mindestanforderungen.

**0. EINSTELLUNGEN**
- Ultracode, Workflow-Größe, Modelle
- Branch `bollwerk`, Worktree, Ordner `planung/bollwerk/`
- Startsatz und erwartete Dauer

**1. NORDSTERN UND ZIELBILD**
- Wortlaut §2.1, Entscheidungen §2.2, Deutung §2.3
- Referenzbilder je Raum
- „Fertig heißt …“ in einem Absatz

**2. STARTBEDINGUNG UND VORLAUF**
- Prüfung von B-02 als erster Schritt.
- **Vorlauf**, solange B-02 nicht erfüllt ist: nur Arbeit ohne Hoheitskonflikt in eigenem Namensraum, zum Beispiel
  - Würfelkern
  - Prüfwerkzeuge und Torwerkzeug
  - Look-Anker
  - Posen- und Leben-Bibliothek in neuen Dateien
  - Varianten in Entwurfsordnern
  - Simulationen
- Der Vorlauf wird nie gegen den anderen Lauf gemergt. Stündlich prüfst du B-02 neu.
- Sobald B-02 erfüllt ist: `origin/main` hereinholen, Hoheit übernehmen, Hauptlauf beginnen.

**3. AUTONOMIE UND DENKPROTOKOLL**
- keine Rückfragen
- Denkprotokoll: Ziel und Messgröße · mindestens drei Wege · Bewertung · Umkehrprobe · Folgen zweiter Ordnung · Eintrag im ENTSCHEIDUNGSLOG
- Gestaltungsfragen sofort nach FÜR-DEN-NUTZER, mit Standardwahl

**4. GRENZEN UND VORRANG**
- §3.2 vollständig
- Vorrang: Sicherheit und Regeln › Inhaltsregeln und Kanon › Lösbarkeit und Fairness (W-Regeln) › Look-Treue › Handyleistung › Umfang › Politur

**5. ARCHIV UND WIEDERVERWERTUNG**
- Tabelle aus `ARCHIV.md`
- Übernahme nur per Commit mit Vermerk `aus <ref>@<sha>:<pfad>`
- nichts löschen, nichts verschieben

**6. SPIELENTWURF** (aus `SPIELMECHANIK.md`)
- Rundenablauf für Party, Solo und WLAN
- Ketten von Folgeentscheidungen
- Aktionskatalog mit Animation
- Würfel (W-Regeln, Stufen, zweiter Anlauf, Umweg, Pech-Garantie, Bühne)
- Bots
- WLAN-Protokoll
- Bedienung im Look
- JSON-Schemas, Beispielrunden

**7. UMFANG 10–100×**
- Umfangsmatrix mit Basis aus `UMFANG-BASIS.md`, Zielband je Achse, Zählbefehl je Achse und Gesamtindex (gewichtetes geometrisches Mittel der Faktoren, Ziel ≥ 10×, Streckziel 100×)
- **Kanon-Erweiterungsregel:**
  - Kanon 1.0 (Wahrheit, Tatmatrix, Pfade, Fakten) bleibt unveränderlich.
  - Neues kommt als Schicht dazu: Nebenhandlungen, Zusatzfunde, Gespräche, Atmosphäre, Gags, Räume außerhalb des Tatgeschehens, Folgeentscheidungen.
  - Jedes neue Stück durchläuft Schema, Inhaltsprüfer, Simulator und Kanon-Wächter.
  - `kanonVersion` 2.0.0, Story-Bibel neu erzeugt.
- **Füllstoff-Schutz:** Ein Stück zählt nur, wenn es geprüft, verdrahtet, spielbar und im Protokoll erreichbar ist. Dubletten werden über Ähnlichkeitsprüfung erkannt.

**8. DESIGN-AUFWERTUNG** (aus `DESIGN-AUFWERTUNG.md`)
- Strukturmaße, z. B.:
  - Posen
  - Ruhe-Animationen 22/22
  - Requisitenarten
  - Licht- und Leben-Effekte
  - Übergänge
- Look-Anker (Golden mit fester Uhr)
- Vorher/Nachher-Paare je Raum an den Nutzer
- Gremium, geeicht mit Bildern mit bekannten Fehlern; Paarvergleich blind
- Leistungsbudget: nicht schlechter als die Messbasis, Ruhemodus beim Warten auf Entscheidungen

**9. ARCHITEKTUR UND DATEIPLAN**
- neue Dateien und Ordner
- Eingriffe in Bestandsdateien nur additiv und begründet
- Hoheitskarte vor und nach B-02
- App-Start (B-08) mit Menü zu Burgstadt und den klassischen Fällen
- Schalter und Rückfallweg
- Werkzeuge nie im Release

**10. ROLLEN UND AUFTRÄGE**
- Opus plus mindestens 12 Haiku-Rollen, darunter:
  - Regelwerker, Kartenschreiber, Kettenbauer, Aktionsanimator, Posenmaler, Requisitenmaler, Würfelmeister, Simulant
  - Testschreiber, Szenenprüfer, Kanonwächter, Sprachprüfer, Bestandswächter, Leistungsprüfer, Gegenprüfer, Advocatus (Mutanten)
- je Rolle ein Briefing mit drei häufigen Fehlern
- 13-teilige Auftragsvorlage mit Lernvermerken
- 5-Punkte-Prüfung (≥ 8/10, keine 0), höchstens 2 Nachbesserungen

**11. ORCHESTRIERUNG UND SKALIERUNG**
- Muster:
  - Varianten-Turnier: N Haiku-Varianten → automatische Filter → Haiku-Gremium mit 3 Linsen → Opus wählt und führt zusammen → Tests
  - Pipeline, Schleife bis Ruhe, gegnerische Prüfung, Vollständigkeitskritiker
- Kapazitätsplan aus `DURCHSATZ.md`, Wellenplan je Stunde, Zähler
- Wiederaufnahme über runId, journal und PRÜFPUNKT
- Isolation über Worktrees; nur Opus führt zusammen
- Schwerlast-Slot
- Herzschlag
- Fehlerregeln

**12. BAUPHASEN MIT TOREN**
- **B0:** Startbedingung, Archiv, Look-Anker, Torwerkzeug
- **B1:** Durchstich (eine Entscheidung → sichtbare Aktion → Würfelwurf), mit Bild an den Nutzer
- **B2:** Regelkern, Würfel, Ketten
- **B3:** Aktionen, Posen, Leben
- **B4:** Spielformen (Party, Solo, WLAN) und App-Start
- **B5:** Umfang-Wellen bis 10×
- **B6:** Design-Aufwertung und Umfang bis zum Streckziel
- **B7:** Härtung, Bollwerk voll, Leistung
- **B8:** Zusammenführung auf main und Tag `bollwerk-1.0`
- Je Phase: Ziel, Aufträge, Torkriterien, Push von `bollwerk`.

**13. AUFTRAGSVORRAT UND NACHSCHUB**
- Vorrat ≥ Nachtkapazität aus M4, im Anhang, jeder Auftrag mit Kennung, Rolle, Hoheit und Prüfung.
- Nachschubregeln aus Lücken, Befunden, Testfehlern und Umfangsachsen.
- Ist der Vorrat leer, läuft der Vollständigkeitskritiker.

**14. BOLLWERK** (Prüfschichten, je mit Befehl, Schwelle, Laufzeit, Häufigkeit)
- **L0 Fundament:**
  - `pub get` in allen 8 Paketen
  - `analyze`
  - Secret-Scan
  - `bestand.dart --vergleiche`
  - Release-Prüfung (Werkzeuge nicht im Release)
- **L1 Bestand:** `alle_tests.sh` und `pruefen.sh` (schnell je Commit, voll je Tor).
- **L2 Eigenschaften:** Invarianten des Zugmodells; Generator über `Rng`; bei Fehler den Seed melden.
- **L3 Determinismus:** Prüfsumme je Partie, VM gegen Web.
- **L4 Simulation:** mindestens 10.000 Partien je Pfad und Strategie, „immer Pech“ eingeschlossen.
- **L5 Inhalt:** `textpruefer`, `leitplanken`, Spoiler, verbotene Inhalte, Ähnlichkeitsprüfung gegen Füllstoff.
- **L6 Golden:** Look-Anker und neue Szenen mit fester Uhr.
- **L7 E2E:** headless Sitzungen, Browser-E2E, `e2e.mjs` neu.
- **L8 Leistung:** exklusiv, Thread-CPU.
- **L9 Rot-Proben und Mutanten.**
- **L10 Gremien:** geeicht, an Hash gebunden.
- Nur `tool/bollwerk.dart` meldet „BOLLWERK GRÜN“.

**15. ABNAHMEKRITERIEN** (B-K01 … B-Knn, jedes mit Methode, Schwelle und Beleg)
Mindestens abgedeckt:
- Steuerung über Entscheidungen; jede Entscheidung zeigt eine sichtbare Aktion
- Würfel nach W-1 bis W-6
- Pech-Garantie
- Lösbarkeit und Determinismus
- drei Spielformen spielbar
- App-Start nach B-08
- Look-Treue
- Design-Aufwertung belegt
- Umfangsindex ≥ 10×
- Leistung ≥ Messbasis
- alle Tests grün; Bestand, wo verlangt, unverändert
- Inhaltsregeln
- Archiv vollständig
- main sauber zusammengeführt
- übernommene Kriterien F-04, F-06, F-07, F-11, F-12, F-15 des Finalisierungs-Laufs

**16. ZUSAMMENFÜHRUNG AUF MAIN**
- Reihenfolge der Linien laut `ARCHIV.md`: zuerst `origin/main` herein, dann je Linie in einem Integrationsworktree.
- Konfliktregel; Burgstadt-Schutz (Layout-Prüfsumme gleich, textPfade unverändert).
- voller Lauf grün, `rm -rf .dart_tool/flutter_build`
- `git merge-base --is-ancestor <origin/main vorher> main`
- Push mit ausdrücklichem Ziel; Tag `bollwerk-1.0` (neu, nie überschrieben)
- PR-Weg, falls eine Schutzregel greift

**17. NEBELKARTE**
- Mindestens 15 Risiken mit Frühzeichen und Gegenmaßnahme, darunter:
  - Startbedingung hängt
  - Kollision mit Restarbeit des anderen Laufs
  - Kontextverdichtung
  - CPU
  - Haiku-Qualität
  - Füllstoff
  - Glücksfrust
  - Look-Bruch
  - Leistung
  - Plattenlimit
  - WLAN im Browser nur als Gast
  - Merge-Konflikte mit HD

**18. STATUS UND DISZIPLIN**
- STAND-Zeile: `STAND · Bauphase B[n] von B8 · Abnahme [a] von [N] · Umfang [x]× · Aufträge [fertig] von [gesamt] · Varianten [v] · Agenten aktiv [x] · Bildzeit Geräteklasse mittel [ms] · nächster Schritt: […]`
- STATUS, PRÜFPUNKT (bei jedem Blockende), NACHTPROTOKOLL stündlich, MORGENBERICHT 07:00
- Bilder als Kontaktbögen; Commits nur grün mit Pfadliste

**19. START**
- die ersten 10 Handlungen des Nachtlaufs, Schritt für Schritt

**20. ENDE**
- „ZIEL ERREICHT“ nur über das Torwerkzeug, wenn alle Kriterien erfüllt sind und 2 Prüfrunden ruhig waren
- sonst „BEREIT ZUR INTEGRATION“ mit Restliste
- Morgenbericht für den Nutzer

---

## 7. SKALIERUNG – „tausende Haiku-Varianten“ ehrlich erreichen

### 7.1 Gemessen
- Ein Workflow: höchstens 2 Agenten gleichzeitig auf 4 Kernen, höchstens 1.000 Agenten je Lebensdauer.
- 8 direkte Hintergrund-Agenten liefen gleichzeitig.
- M4 misst die tatsächlichen Werte für Haiku.

### 7.2 Hebel (in dieser Reihenfolge)
1. **Varianten bündeln:** Ein Haiku-Agent liefert 10–25 Varianten in strukturierter Ausgabe.
2. **Mehrere Workflows gleichzeitig** im Hintergrund, jeder mit eigener Grenze.
3. **Direkte Hintergrund-Agenten** zusätzlich, in einer Nachricht gestartet.
4. **`effort: 'low'`** für Mechanisches. Opus urteilt nur bei Synthese, Abnahme und Konflikten.
5. **Rechenarbeit von Denkarbeit trennen:** Haiku erzeugt, Skripte filtern (Schema, Inhaltsprüfer, Simulator, Ähnlichkeit), Gremien bewerten nur den Rest.

### 7.3 Zählen und Ziel
- Varianten = geprüfte Kandidaten mit Urteil.
- Beide Zähler (Varianten und Agentenaufrufe) stehen in der STAND-Zeile und stündlich im NACHTPROTOKOLL.
- Das Ziel stammt aus `DURCHSATZ.md`. Weicht die Rate nach 2 Stunden um mehr als 30 % ab, wird das Ziel angepasst und ins Log eingetragen.

### 7.4 Durchhalten
- Hintergrundarbeit weckt den Orchestrator von selbst; kein `sleep`-Polling.
- **Sicherheitsnetz:** `send_later` alle 45 Minuten, solange Arbeit läuft. Am Ende alle offenen Erinnerungen löschen.
- **Zustand lebt in Dateien:** PRÜFPUNKT, STATUS, Vorrat, journal. Nach jeder Verdichtung zuerst den PRÜFPUNKT lesen.
- **Durchstich vor Breite:** Erst wenn B1 mit Bild steht, rollen die Wellen breit aus.

---

## 8. ABNAHME DES META-LAUFS

| Nr. | Kriterium | Prüfung |
|---|---|---|
| M-01 | Master-Prompt für sich allein ausführbar | 3 Trockenläufe (M7) mit 0 Blockern |
| M-02 | Fakten stimmen | 10 zufällige Fakten mit Pfad bzw. SHA nachgeprüft, 0 Fehler |
| M-03 | Regeln vollständig | Abgleichliste §3.2 gegen die drei bisherigen Master-Prompts, 0 fehlende |
| M-04 | Nutzerwunsch abgedeckt | Anforderungsmatrix: jeder Satzteil aus §2.1 und jede Entscheidung aus §2.2 → Abschnitt im Master-Prompt |
| M-05 | Spielmechanik belegt | Simulationszahlen: Lösbarkeit 100 % auch bei „immer Pech“, Sackgassen 0 |
| M-06 | Design-Richtung belegt | mindestens 4 Proben im Chat, Gremiumsurteil, Prioritäten |
| M-07 | Umfang messbar | `UMFANG-BASIS.md` mit Zählbefehl je Achse; Zielband und Gesamtindex definiert |
| M-08 | Durchsatz gemessen | `DURCHSATZ.md` mit Messwerten und abgeleitetem Nachtziel |
| M-09 | Vorrat reicht | Aufträge ≥ Nachtkapazität, dazu Nachschubregeln |
| M-10 | Bollwerk prüfbar | jede Schicht mit Befehl, Schwelle und Laufzeit; ein Torwerkzeug |
| M-11 | Kriterien messbar | kein Kriterium ohne Methode und Schwelle |
| M-12 | Gegenprüfung abgeschlossen | 2 ruhige Runden oder 4 Runden mit begründetem Rest |
| M-13 | Hoheit gewahrt | kein Auftrag berührt vor B-02 fremde Dateien |
| M-14 | Zusammenführung geplant | Reihenfolge, Konfliktregel, Vorfahrtest und Burgstadt-Schutz je Linie |
| M-15 | Form | Hauptteil ≤ 10.000 Wörter, 0 Widersprüche |
| M-16 | Gesichert | Push auf `bollwerk`, Secret-Scan sauber, Wegwerf-Worktrees entfernt |

---

## 9. STAND-ZEILE DES META-LAUFS

Jede Antwort im Meta-Lauf beginnt mit:

`STAND · Meta-Lauf M[n] von M8 · Prüfrunde [r] · Agenten aktiv [x] · Varianten [v] · nächster Schritt: […]`

---

## 10. START DES META-LAUFS

1. `export PATH=/opt/flutter/bin:$PATH`; `git fetch origin`; Linien mit SHA notieren; B-02 prüfen.
2. Worktree `/home/user/bollwerk` auf neuem Branch `bollwerk` aus `origin/main` anlegen. Darin `planung/bollwerk/` mit ENTSCHEIDUNGSLOG, STATUS und PRÜFPUNKT anlegen. Diesen Meta-Prompt als `META-PROMPT.md` dazulegen.
3. M1 starten: alle Leser **gleichzeitig**. Parallel dazu den Pilot für M4 vorbereiten und die Referenzbilder für M2 bauen.
4. Danach M2 bis M8; was unabhängig ist, läuft gleichzeitig (M2-Design, M3-Mechanik, M4-Pilot).

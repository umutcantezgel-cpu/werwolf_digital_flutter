# A-1 · Nutzerwille, Entscheidungen, Annahmen, Begriffe

Wortlaut des Nutzers unverändert, das Auslösewort der Workflow-Automatik ist geschwärzt. Anpassungen für den Dauerlauf mit Leitstand stehen in der Tabelle „Gilt für den Dauerlauf“ am Ende; sie gehen den Zeilen darüber vor.

## A1 · Wortlaut des Nutzers (2026-10-09; unverändert übernehmen)

Auftrag:
> „kannst du einen Prompt zum generieren eines Promptes entwickeln welcher alles bestehende archiviert und wiederverwertet für das game look alike. Steuerung funktioniert über rundenbasierte folgen von entscheidungen welche den Charakter entsprechende aktionen durchführen lässt wie in den keller gehen sowie ein Luck (Würfel) System für den effekt der entscheidungen manchmal. Der Prompt der dein Prompt entwickeln soll soll dich über Stunden beschäftigt halten so das du die ganze nacht mit tausenden Haikiu 5.5 Varianten in [geschwärzt] ein Bollwerk schaffen kannst um das game zu finalisieren!“

Präzisierung:
> „erstelle einfach den Prompt zum entwickeln des Prompts um nach seinen arbeiten das Spiel um den Faktor 10X-100X zu erweitern und das Design signifikant aufzuwerten sowie alles sauber auf main zusammenzuführen und bestehende arbeiten wiederzuverwerten mit dem design wofür wir uns jetzt entschieden hatten“

Gewählte Optionen (die Texte stammen aus der Auswahl, die Claude angeboten hat):

| Frage | Gewählte Option |
|---|---|
| Würfel | **„Stark“**: „Der Würfel entscheidet auch, ob eine Untersuchung gelingt. Misslingt sie, gibt es einen zweiten Anlauf oder einen Umweg; lösbar bleibt der Fall.“ |
| Spielformen | **Party an einem Gerät, Solo mit Bots, WLAN-Mehrspieler** |
| App-Start | **„Schlosskeller als Start“**: „Die App öffnet das Schlosskeller-Rundenspiel. Burgstadt und die klassischen Fälle bleiben über ein Menü erreichbar.“ |
| Look (früher) | **„Bild-Look + Leben“** (E-F021) |

Weitere Aussagen des Nutzers:
- „starte alle agenten gleichzeitig“
- „zeig mir die bilder immer im chat wenn du welche machst“

---

## A2 · Feste Entscheidungen BE-01 … BE-14

| Nr. | Entscheidung |
|---|---|
| BE-01 | **Bild-Look + Leben.** Der Look des Referenzbilds bleibt (B3). Räume und Figuren werden nie aus Pixel-3D-Blöcken gebaut. FEINKORN-Technik dient nur als Leben (Physik, Teilchen mit Ablagerung, Material, Klangfamilien) und als Gelenkgerüst-Konzept für Posen im gezeichneten Stil. Pixel-Teilchen ≤ 3 px nur für Splitter und Staub. |
| BE-02 | **Nach dem Finalisierungs-Lauf.** Der Hauptlauf beginnt erst, wenn die Startbedingung (MP-2) erfüllt ist. Vorher arbeitet der Nachtlauf im Vorlauf V. |
| BE-03 | **Umfang 10–100×** über den Umfangsindex U (MP-7), gemessen gegen die Basis am B-02-Commit. |
| BE-04 | **Design deutlich sichtbar aufwerten** im Rahmen von BE-01. Nachweis: Strukturmaße, Stilprüfung, blinder Paarvergleich (MP-8). |
| BE-05 | **Alles sauber auf main.** Jede Linie der Klasse *zusammenführen* oder *teilweise übernehmen* kommt grün auf main. Jede Linie steht mit Ref und SHA in ARCHIV.md. Kein Branch wird gelöscht, nichts geht verloren (MP-16). |
| BE-06 | **Würfel stark** nach A1, mit Pech-Garantie und unantastbarer Kanon-Wertung (WÜ-1 … WÜ-6). |
| BE-07 | **Drei Spielformen:** Party an einem Gerät, Solo mit Bots, WLAN über das vorhandene `room_host`. |
| BE-08 | **App-Start Schlosskeller.** Burgstadt und die klassischen Fälle bleiben über ein Menü erreichbar. Ein Schalter stellt den Start zurück auf `/burgstadt`; er bleibt auch nach der Abnahme. |
| BE-09 | **Bilder:** Jedes erzeugte Bild geht in den Chat, gebündelt als Kontaktbogen (≤ 48 Kacheln). Höchstens 6 Bögen je Stunde. Nur Opus sendet. |
| BE-10 | **Keine Rückfragen, kein Warten.** Opus entscheidet per Denkprotokoll und trägt ins `ENTSCHEIDUNGSLOG.md` ein. Gestalterisches, das der Nutzer entscheiden sollte, kommt sofort nach `FUER-DEN-NUTZER.md` (Frage, Standardwahl, Folge), und die Arbeit geht mit der Standardwahl weiter. Haiku entscheidet nichts: Es schreibt OFFENE FRAGE, Opus entscheidet. |
| BE-11 | **Gleichzeitig:** Unabhängige Agenten starten gemeinsam, aber nie über die gemessene Kapazität hinaus. |
| BE-12 | **Druckspiel bleibt** Kanon-1.0-Schicht ohne Würfel, wortgleich (F:F-10, F:F-14). |
| BE-13 | **Licht und Nebel.** Nebel des Krieges nach F:§7.13 (`P/MASTER-PROMPT.md`) ist Pflicht (B2); auf `fin` ist er seit F4 gebaut. Für den Lichtzustand der Runden gilt der Kanon vor dem Look. Den Widerspruch „Strom an ab 00:00“ gegen „Stromausfall-Look“ legt M1 mit Standardwahl in ANNAHMEN.md (Standard: Kanon). |
| BE-14 | **Kanon-1.0 unantastbar.** Wachstum nur als Schicht in `content/runden/schlosskeller/` (MP-7). Keine neuen Bereiche außerhalb der 7 Räume (C5). |

---


### A2a · Annahmen (Standardwahl, kippbar mit „A<n>: …“)
| Nr. | Entscheidung | Standard |
|---|---|---|
| A-01 | Design-Richtung | beste Richtung aus der Design-Probe (mit Bild) |
| A-02 | Lichtzustand der Runden | Kanon |
| A-03 | Würfel und Kanon-Punkte | Würfel kostet nie Kanon-Punkte |
| A-04 | neue Fälle | nur Schichten, keine neuen Fälle oder Täterpfade |
| A-05 | Spieldauern | Abend Median ≤ 150 min, Runde Median ≤ 6 min |
| A-06 | Joystick | im Partymodus aus, sonst unverändert |
| A-07 | WLAN-Host | Gerät des Detektivs |
| A-08 | Musik | keine |
| A-09 | Gewichte g | 3, 2, 1, 1, 2 für X1, X2, X3, X4, X6; X5 Pflichtziel (ANNAHMEN A-09) |
| A-10 | Design und Umfang | gleichrangig |
| A-11 | Zwischenziel je Nacht | ja, je Achse in Einheiten |
| A-12 | HD-Linie `caf1d61` | nur mergen, wenn die Burgstadt-Bilder bytegleich bleiben; sonst zurückgestellt bis „A12: ja“ |
| A-13 | Sperrdatei mit Verboten (`.claude/settings.json`, nur `permissions.deny`) auf `bollwerk` | keine (die Modellangabe je Aufruf gilt); mit „A13: ja“ legt der Leitstand sie an |

## A3 · Begriffe und Deutung (verbindlich)

**Wörter des Nutzers**

| Wort | Bedeutung |
|---|---|
| „game look alike“ | Der Look des Referenzbilds `origin/kern-feinkorn:planung/feinkorn/bilder/k0/vorher_buffetsaal.png`. **Das Bild ist der Anker, nicht seine Beschreibung.** Iso 2:1, gezeichnete Figuren, Steinboden, Holzwände, dunkler Rand. Er wird weiterentwickelt, nicht ersetzt. Joystick und Aktionsknopf gehören nicht zum Look. |
| „Design signifikant aufwerten“ | Deutlich sichtbar, nicht statistisch. Belegt durch D1 Strukturmaße + D2 blinder Paarvergleich + D3 Eichung (MP-8), ohne Stilbruch (Stilprüfung S1–S5). |
| „rundenbasierte Folgen von Entscheidungen“ | Spieler steuern über Entscheidungen je Runde. Ketten: Ein Ergebnis öffnet Folgeentscheidungen. Die 9 Kanon-Entscheidungen bleiben die einzigen wertenden. Alles andere wächst als nichtwertende Folgeentscheidungen und Abstecher. Der Echtzeit-Joystick ist nicht mehr die Spielsteuerung; ob er als Zusatz bleibt, ist Annahme A-06. |
| „Aktionen … wie in den Keller gehen“ | Jede Entscheidung löst eine sichtbare Aktion der Figur aus (C1, C5): Weg über A*, Pose, Licht, Fundkarte. „In den Keller gehen“ zeigt wörtlich der Abstieg über die fünf Sandsteinstufen im Intro, dazu der Abstecher über die Wendeltreppe und die Raumwechsel. |
| „Luck (Würfel) … manchmal“ + „Stark“ | Bei 30–60 % der Züge einer Partie fällt ein offener Wurf. Er entscheidet über das Gelingen jedes Anlaufs; Pech heißt zweiter Anlauf oder Umweg. Die Kanon-Wertung (Punkte, Ende) bleibt unberührt (WÜ-4). Der Fall bleibt garantiert lösbar (WÜ-3). |
| „10X–100X erweitern“ | Umfangsindex U ≥ 10 (Streckziel 100) über Wachstumsachsen, dazu absolute Pflichtziele für Achsen mit Basis 0 oder Obergrenze. Kanonfeste Achsen haben Faktor 1 (MP-7). Umfang heißt Breite und Wiederspielwert, **nicht** längere Abende. Nie Füllstoff (Füllstoffprüfung F1–F5). |
| „alles bestehende archiviert und wiederverwertet“ | Jede Linie steht mit Ref und SHA in ARCHIV.md. Archiviert wird an Ort und Stelle; nichts wird verschoben. Wiederverwertung belegt je Linie ein Übernahme-Commit `aus <ref>@<sha>:<pfad>` oder eine begründete Absage. |
| „alles sauber auf main zusammenführen“ | MP-16: echte Merges mit `--no-ff`, nie `-s ours`, nie Squash, Rebase oder Cherry-pick ganzer Linien. Voller Prüflauf grün, Vorfahrtests, Burgstadt-Schutz, kein Force-Push. |
| „Bollwerk“ | Ein großes, belastbares Gesamtwerk für das Spiel: (1) eine breite Variantenproduktion, aus der nur Geprüftes ins Spiel kommt; (2) eine Prüfmauer mit dem Torwerkzeug `tool/bollwerk/bollwerk.dart` (MP-14). Die Mauer wächst mit dem Spiel. Ab BW1 gehen höchstens 20 % der Agentenaufrufe in Prüfwerkzeuge. |
| „tausende Haiku 5.5 Varianten“ | Zwei Zähler: Haiku-Agentenaufrufe und Varianten. Ziel für beide: vierstellig je Nacht. Liegt die gemessene Kapazität darunter, nutzt der Lauf die Hebel aus MP-11; sonst nennt der Morgenbericht die ehrliche Zahl und den Grund. |
| „die ganze Nacht“ | Kein Leerlauf von Start bis Morgenbericht. Morgenbericht zur Zeit M = spätere von 07:00 Berlin und T0 + 8 h. |

**Begriffe des Laufs**

| Begriff | Bedeutung |
|---|---|
| Variante | Ein Kandidat, den ein Agent erzeugt hat und der ein Urteil hat: verworfen durch das Filterskript oder bepunktet durch das Gremium. „Übernommen“ heißt: im Code oder in den Daten. |
| Linie | Ein Arbeitsstrang mit eigener Ref oder eigenem Ordner (B1). Die 41 `loop/epoch-*` zählen als eine Linie. Klassen: *Basis* (`origin/main`; die Finalisierung gilt bis B-02 als *läuft*, danach als Basis) · *zusammenführen* · *teilweise übernehmen* · *nur archivieren* · *eingefroren* (für BOLLWERK unantastbar, kann für sich selbst weiterlaufen, z. B. der Nachtlauf Burgstadt). |
| Hoheit | Über einen Pfad hat Hoheit, wer ihn als Einziger ändern darf. |
| Vorlauf V | Arbeit vor erfüllter Startbedingung, nur in eigenen Pfaden. |
| Hauptlauf | Phasen BW0 bis BW8 nach erfüllter Startbedingung. |
| T0 | Startzeit des Nachtlaufs (echte Uhrzeit im PRUEFPUNKT). |
| M | Zeit des Morgenberichts: die spätere von 07:00 Berlin und T0 + 8 h. |
| B-02 | Die Startbedingung des Hauptlaufs (Befehl in MP-2). Der Name stammt aus BE-02. |
| MC | Der Merge-Commit, der auf main soll (MP-16). |

---

---

## Gilt für den Dauerlauf (geht den Zeilen oben vor)

| Stelle oben | gilt jetzt | Ort im Master-Prompt |
|---|---|---|
| MP-n (Kennungen des Pflichtinhalts) | MP-2 → Abschnitt 2.2 und 8 (Vorlauf); MP-7 → 6 UMFANG; MP-8 → 6 DESIGN; MP-12 → 8; MP-14 → 7; MP-16 → 12 (nur bis MAIN-REIFE; der main-Push gehört dem Leitstand); MP-17 → 10; MP-18 → 11; MP-19 → 13 | – |
| BE-02 Startbedingung | B-02 gilt nur mit dem Eintrag `B-02 ERFÜLLT · K=<sha40>` oder `FREIGABE BOLLWERK · K=<sha40>` in STEUERUNG.md des Leitstands | 2.2 |
| BE-05 „alles sauber auf main“ | Der Nachtlauf liefert MAIN-REIFE mit Release-SHA R und `ZUSTAND: BEREIT FÜR MAIN`; den Push auf main macht der Leitstand. Archive sind Branches `archiv/*` des Leitstands; Tags gibt es nicht. | 6 MAIN-REIFE, 12 |
| BE-09 Bilder in den Chat | Kontaktbögen als Dateien unter `planung/bollwerk/bilder/<datum>/` mit Zeile in `bilder/INDEX.md`; der Leitstand zeigt sie im Chat. SendUserFile im Nachtlauf nur zusätzlich. | 6 DESIGN, 11 |
| A3 „die ganze Nacht“, Zeit M | M = 06:30 Europe/Berlin (Morgenbericht als Datei); Generationsfenster höchstens 12 h | 0, 2.5 |
| A3 „tausende Haiku-Varianten“, Workflows | Keine Workflows; direkte Hintergrund-Agenten über das Agent-Werkzeug, Wellengröße nach Messung (12; bis B-02 6) | 0, 5 |
| A3 „Bollwerk … Prüfwerkzeug höchstens 20 %“ | bleibt | 7 |
| A2a A-12, A-13 | bleiben Annahmen; neue Annahmen A-14 ff. stehen in `planung/bollwerk/ANNAHMEN.md` | – |

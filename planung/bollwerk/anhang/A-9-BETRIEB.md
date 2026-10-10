# A-9 · Betrieb: Dateivorlagen, Nebelkarte, Morgenbericht, Merge-Regeln, Glossar

## 1. Dateivorlagen (alle unter `planung/bollwerk/` auf `bollwerk`)

**LAUF.md** (Startstand vom Meta-Lauf; danach schreibt nur der Nachtlauf):
```
LEASE gen=0 session=- seit=- herzschlag=-
FENSTER gen=0 start=- ende=- M=-
ZUSTAND: NICHT BEGONNEN
K=-
R=-
QUITTIERT S=0 F=0
```
Jede Zeile genau einmal; Änderungen ersetzen die Zeile. `K=<sha40>` erst nach `B-02 ERFÜLLT · K=<sha40>` in STEUERUNG.md.

**PRUEFPUNKT.md:** Zeit (UTC und Berlin), Generation, Phase, nächster Schritt, `boot_id` (`cat /proc/sys/kernel/random/boot_id`), `SPERREN gen=<n> folge=<a> gesamt=<b>`, Startbild der Refs (`git ls-remote origin`, gekürzt), Weckruf-ID (`send_later`), eigene Worktrees und Pool-Plätze, Token-Zähler, „B-02 vermutlich“ oder „B-02 offen“, BW0-SHA.

**FLUG.md:** eine Zeile je Agent: `<Kennung> · <Typ> · agentId <id> · Start <UTC> · Ende erwartet <UTC> · Ausgabe <pfad> · Platz <NN|-> · Status <läuft|fertig|verloren|neu eingereiht>`.

**QUITTUNGEN.md:** nur angehängt: `QUITTUNG S-<n>|F-<n> · <UTC> · umgesetzt|abgelehnt <grund>`.

**KERNKARTE.md** (≤ 1.500 Wörter): Vorrang, harte Verbote, Schleifen mit Höchstzahlen, Drossel, Ereignisbudget, Pfade aller Zustandsdateien, Wiedereinstieg.

**NACHTPROTOKOLL.md:** stündlich eine Zeile mit `TZ=Europe/Berlin date`: Phase, U je Achse, Agenten aktiv/fertig, Annahmequote, Ausschussquote, Tokens, Stolperdraht.

**REGISTER.md:** Kennung · Slot · Status · Ringergebnisse · Punkte · übernommen in `<datei>@<sha7>`.

## 2. Weißliste der Steuerung (STEUERUNG.md / BEFUNDE.md des Leitstands)
Die Weißliste steht nur in Master-Prompt 2.5. Abgelehnt wird jeder Eintrag, der eine Grenze, ein Push-Ziel, die Hoheit, ein Z-Kriterium oder eine Schwelle nach unten ändert oder ein Löschen verlangt; dann `QUITTUNG S-<n> · <UTC> · abgelehnt <grund>` und ein Eintrag in FUER-DEN-NUTZER.md.

## 3. Nebelkarte (Risiko · Frühzeichen · Gegenmaßnahme)
1. B-02 hängt · Finalisierung ohne „ZIEL ERREICHT“ nach 2 Nächten · Vorlauf weiter, VORLAUF FERTIG, Leitstand fragt den Nutzer nach FREIGABE.
2. Finalisierung schreibt nach B-02 weiter · neue Commits auf `origin/finalisierung-schlosskeller` · Aufträge in übergegangenen Pfaden anhalten, hereinholen nach §5, FUER-DEN-NUTZER.
3. Burgstadt pusht auf main · `origin/main` bewegt sich · an Phasentoren hereinholen; Konfliktzahl berichten.
4. Berechtigungsnachfrage · Werkzeug wartet auf Freigabe · Sperrregel; Schrittart weglassen; nie umgehen.
5. Nutzungslimit (5 h) · Limitfehler im Ergebnis · sichern, PRUEFPUNKT, pushen; Weckruf auf Freigabe + 5 min; sonst „WEITER BOLLWERK“ des Leitstands.
6. Wochenlimit · `LIMIT-VORSORGE` · Welle abschließen, Morgenbericht vorziehen, NACHT-ENDE.
7. Kontextverdichtung · Zusammenfassung im Gespräch · Wiedereinstieg nach Abschnitt 11, erst dann Neues.
8. Maschine neu (`boot_id` anders) · Agenten verloren · FLUG prüfen, Fehlendes einmal neu einreihen, Werkzeugkette neu.
9. Herzschlag reißt · LEASE-Herzschlag > 90 min · Leitstand prüft Hänger; der Lauf pusht alle 30 min.
10. Ereignisstau bei Opus · > 40 Rückgaben je Stunde · Wellen kleiner, mehr Varianten je Agent.
11. Platte · `df` < 8 GB · keine neuen Worktrees, Logs löschen.
12. CPU/RAM · Last > 6 oder < 3 GB frei 10 min · keine neuen Code-Aufträge bis Last < 4.
13. Agentenprotokolle füllen die Platte · `/tmp/claude-0` > 3 GB · abgeschlossene Wellen aufräumen (nur eigene Ausgabedateien).
14. Haiku-Qualität sinkt · Annahmequote < 30 % zwei Wellen · Briefing einmal überarbeiten, sonst Typ streichen.
15. Füllstoff · F5 < 18/20 abgelehnt · Welle ungültig, Gremium neu eichen.
16. Werkzeugverstoß eines Agenten · Audit meldet tool_use außerhalb der Liste · Ergebnis verwerfen; schreibend = ABBRUCH.
17. Glücksfrust · Pech-Szenen-Median > 3 oder Spürbarkeit < 25 % · Parameter nur im Band nachstellen (L4).
18. Look-Bruch · S1–S6 rot · zurücknehmen, Look-Anker nie verschieben.
19. Leistung · L8 Median > 1,15 × Basis · Qualitätsstufe, Ruhemodus, Vorbacken.
20. WLAN im Browser nur als Gast · L7-Gast im Browser scheitert · Host bleibt VM/App; Hinweis in der Anleitung.
21. Merge-Konflikt HD · `merge-tree` meldet Konflikte · Linie nur archivieren (Leitstand), FUER-DEN-NUTZER.
22. Kanon-Verwechslung (Krimidinner) · Sperrliste trifft · Variante verwerfen, Briefing schärfen.
23. Pfad-Leck über Chancen oder Gags · |ρ(Chance, richtig)| > 0,1 · Chance je Entscheidung angleichen (K-06).
24. Heredoc mit Backticks · Befehl im Text wird ausgeführt · nur `<<'EOF'`, Texte mit Backticks über Write.
25. main liefert aus (Netlify, Vercel, Railway) · – · Nachtlauf pusht nie auf main; Morgenbericht nennt, was ausgeliefert werden könnte.

26. Kontingent und Generationswechsel · Tokenrahmen erreicht · Tokenrahmen der Nacht = (Zwischenziel X1 + X3 + X4 + X6 + Zwischenziel X2 ÷ 4) × 61 Tsd. Tokens je Einheit × 1,2 (Haiku und Opus getrennt geführt); ab 70 % nur Aufträge, die ein Z-Kriterium voranbringen; ab 90 % halbierst du die Wellengröße und startest nur noch Aufträge für Z-Kriterien; Leerlauf gibt es nur bei Limit, LIMIT-VORSORGE, Befund-Stopp oder ab 100 % des Rahmens, dann mit Weckruf. Rückgaben je Stunde höchstens 40 (Ereignisbudget); darüber kleinere Wellen mit mehr Varianten je Agent. Generationswechsel ohne Lücke: Zugende-Zeile nur nach gepushtem LAUF.md und PRUEFPUNKT.

## 4. Morgenbericht (bis 06:30 Berlin, `planung/bollwerk/MORGENBERICHT.md`, Alltagssprache)
1. Kurz gesagt · 2. Zuerst ansehen (Startbefehl) · 3. Vorher/Nachher-Kontaktbogen je Raum (Pfade) · 4. Die Nacht in Zahlen (U je Achse absolut und als Faktor, Volumenfaktor, Abnahme, Varianten, Agentenaufrufe, Tokens) · 5. Stand von `bollwerk` mit SHA · 6. Was auf Standardwahlen beruht, mit Folge beim Kippen · 7. Was nicht lief · 8. Nächster Schritt und Restbedarf in Nächten · 9. Bis zum Store fehlt (Release-Signatur, Datenschutzerklärung, Altersangaben, Bildschirmfotos, `web/manifest.json`, Tests auf echten Geräten).

## 4a. Kontaktbögen
Kontaktbögen (JPEG ≤ 2.400 px, ≤ 1,5 MB; Vorher/Nachher höchstens 6 Paare; Bewegungsstreifen zusätzlich als animiertes WebP ≤ 3 MB) unter `planung/bollwerk/bilder/<datum>/` mit Zeile in `bilder/INDEX.md` (Zeit, Pfad, sha256, Inhalt, Ansicht). Der Leitstand zeigt sie im Chat; SendUserFile nur zusätzlich. Bilder entstehen nur mit Mitteln ohne fremde Dienste; was ein Bildgenerator liefern müsste, steht als Bildbeschreibung in FUER-DEN-NUTZER.md.

## 5. Hereinholen von origin/main in `bollwerk` (Konfliktregel)
- `git merge-tree --write-tree --name-only HEAD origin/main` vorab ins NACHTPROTOKOLL.
- Konflikte in Kanon, textPfaden oder `layout_ausgang.txt` löst niemand per Hand: `git merge --abort`, FUER-DEN-NUTZER.
- Status- und Belegdateien: Seite von main, danach den Beleg neu erzeugen.
- Code löst nur Opus; danach `bollwerk.dart phase`, `git diff --cc` ins NACHTPROTOKOLL.
- Mehr als 5 Konfliktdateien oder mehr als 30 min: abbrechen, FUER-DEN-NUTZER, weiter ohne Hereinholen.
- Echte Merges mit `--no-ff`; nie `-s ours`, Squash, Rebase oder Cherry-pick ganzer Linien.

## 6. Prüfrunde des Nachtlaufs (Pflicht vor MAIN-REIFE)
10 Haiku-Gegenprüfer mit je einer Linse (Ausführbarkeit, Sicherheit und Hoheit, Spiel und Würfel, Durchhalten, Messbarkeit, Look, Umfang und Füllstoff, main-Reife und Archiv, Widerspruch, Loop-Schnittstelle) auf den Diff seit K und die Abnahmetabelle; je BLOCKER und MAJOR 3 Skeptiker (`model: "haiku"`, `effort: "max"`), ein Befund gilt bei 2 von 3; Ergebnis in `planung/bollwerk/belege/pruefrunde/<n>.json` mit HEAD über `bollwerk.dart pruefrunde --schreibe <n>`. Höchstens 4 Runden; ab E − 6 h keine neue (Abschnitt 8, BW8 startet `ziel` spätestens E − 5,5 h).

Vor jeder Runde schreibt Opus `git diff K HEAD -- . ':!planung/bollwerk' > /home/user/bw-varianten/pruefrunde-<n>.diff` und nennt den Pfad in jedem Prüfauftrag; jede Befunddatei `belege/pruefrunde/<n>.json` (über `pruefrunde --schreibe`) trägt `head` und je Befund `bestaetigt` (2 von 3). Z-34 prüft beides mit `jq`.

## 8. Archiv (Vorlauf)
`ARCHIV.md` entsteht im Vorlauf aus BESTAND §2: Linie · Ref · SHA · Klasse · Art (Merge, Übernahme, Absage) · Archiv-Branch; die SHA ist der Stand beim Eintrag, BW8 trägt origin/main neu ein. `tool/bollwerk/archiv_pruefen.sh` ohne Argument prüft Z-29 (jede Zeile aus BESTAND §2 in ARCHIV.md, jede Ref in `git ls-remote origin`), mit `--uebernahmen` Z-30. Läuft in `nacht` und `ziel`.

## 7. Glossar
B-02 Startbedingung (Finalisierung fertig) · K der B-02-Commit · R Release-SHA · MC Merge-Commit des Leitstands · BW0…BW8 Phasen · V Vorlauf · LEASE/FENSTER/ZUSTAND Zeilen in LAUF.md · S-/F-<n> Einträge in STEUERUNG/BEFUNDE · Ring 0–9 Prüfmauer · L0–L12 Schichten des Torwerkzeugs · X1–X6 Umfangsachsen · U Zuwachsfaktor · F1–F6 Füllstoffprüfung · D1–D3 Designnachweis · S1–S6 Stilprüfung · Leitstand die steuernde Sitzung des Nutzers (startet Generationen, setzt B-02, pusht main) · Tor Prüflauf `bollwerk.dart <modus>` · Slot ein Platz im Vorrat, der Varianten bekommt · Welle gleichzeitig gestartete Agenten · WÜ-1…6 Würfelregeln · C1–C9 Mechanik (A-4) · K-01…K-26 Kern-Aussagen (A-4) · BE-01…14 Entscheidungen, A-01… Annahmen (A-1) · Pool-Platz `/home/user/bw/NN` (Kopie ohne Git) · Würfelpate (wer den Wurf tippt) · Tischruf (Gruppenentscheidung nach Pech) · Seifenblasen-Marke (+1 auf einen späteren Wurf).

## 9. Nicht belegt (im Meta-Lauf nicht geprüft)
- Ob `TaskStop` Hintergrund-Agenten beendet: wenn nicht, verwirfst du ihre Ausgaben und setzt FLUG auf `verloren`.
- Ob `model: "opus"` auf `claude-opus-5-5` zeigt: in der ersten Opus-Welle die Modellzeile im Protokoll prüfen; weicht sie ab, keine Opus-Agenten mehr, Eintrag in FUER-DEN-NUTZER.
- `rate_limit_info`/`resetsAt` (STARTPAKET §4): fehlt das Feld, gilt jetzt + 60 min als Wiederaufnahme.
- Sitzungskennung über `get_session` (Abschnitt 0, L-8).

## 10. Lichtungsaufgaben (erste Arbeit der ersten Generation, Ergebnis ins ENTSCHEIDUNGSLOG)
L-1 voller Testlauf `tool/alle_tests.sh` auf dieser Maschine messen; L-2 Zeitmodell des Abends in L4 (Gesprächs-, Wahl-, Weitergabezeiten) und Abend-Invariante belegen; L-3 Gegenstände/Orte-Koordinaten für X3 am Raumgraph prüfen (Teilorte nur innerhalb der Räume); L-4 Weißliste am Kanon prüfen (Kandidat `spur_stirnlampe`, Herausnahme neutraler Bonus-Sätze und des Lachers 20:15; jede herausgenommene Zeile ersetzt ein neuer pfadgleicher Zusatzfund, Z-11 bleibt ≥ 14); L-5 Karte im Querformat verdeckt die Szene (Design-Aufgabe); L-6 Web-Gast im WLAN über den vorhandenen Client; L-7 Fortsetzen nach Nutzungslimit in Kindsitzungen beobachten und ins NACHTPROTOKOLL; L-8 Weg der Sitzungskennung (Abschnitt 0) festhalten.

F3-AUTOR-81 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Überarbeite die vier Finaltexte und die Rückblende des Pfads Fatma nach der neuen Ausgangsregel und den Prüfbefunden.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
Lies selbst: figuren.json (Figur fatma: killerProfile, luegen, nebendelikt), tatmatrix/fatma.json und tatmatrix/basis.json (Ereignisse 23:58 bis 0:00), gegenstaende.json (Spuren mit rolle fatma: Feld zeigt), zeitleiste.json (z_ausfall, z_licht, z_morgen), fall.json (Endenmatrix), texte/erzaehler-aufloesung.json (aufloesung.fatma.taeter, darf sich nicht widersprechen).

SCHNITTSTELLEN:
Deine Datei: content/party/schlosskeller/texte/erzaehler-finale-fatma.json mit genau 5 Einträgen: finale.fatma.ende_meister, finale.fatma.ende_teilerfolg, finale.fatma.ende_justizirrtum, finale.fatma.ende_eskalation, rueckblende.fatma. Kennungen und Dateikopf bleiben.

VERBINDLICHE REGELN FÜR DIESE NACHBESSERUNG (E-029, stehen auch in texte/SCHLUESSEL.md, Abschnitt „Regeln für Finale und Ausgang“):
1. Ausgang. Kein Finaltext sagt, ob das Geburtstagskind den Bund in der Nacht gefunden hat.
   - ende_meister und ende_teilerfolg (richtige Anklage): Die Täterperson gesteht und gibt den Bund aus ihrem Versteck heraus. Herr Schneider schließt noch in der Nacht das Außentor auf.
   - ende_justizirrtum und ende_eskalation (falsche Anklage): „Das Tor bleibt zu bis zum Morgen.“ Um sieben Uhr schließt Herrn Schneiders Kollegin mit dem Ersatzschlüssel das Außentor auf. Die Täterperson gesteht erst danach. Die falsch angeklagte Person wird nie genannt; der Text passt für jede.
2. Anrede. Das Geburtstagskind heißt „du“ („Du klagst Ahmet an, und es stimmt.“, „Du zeigst auf die falsche Person.“), die ganze Runde „ihr“ oder „die Runde“. Nicht „das Geburtstagskind“ als Subjekt.
3. Pflichtsatz. Jeder der vier Finaltexte enthält wörtlich „Herr Schneider überlebt“ (ein Test prüft das). Danach darf ein kleiner Lacher stehen, etwa „Er ist schon bald wieder grantig.“ Kein Blut, keine Wunde; Beule und Gedächtnislücke wie bisher.
4. Endentöne nach fall.json (Endenmatrix): Meister klar und erleichtert, mit Schlüsselbeweis und Zusatzindiz als Begründung (Wortlaut aus gegenstaende.json, Feld zeigt); Teilerfolg richtig, aber mit Glück und einem kleinen Riss; Justizirrtum kalte Stimmung und tiefer Riss; Eskalation lautes Durcheinander, Grüppchen.
5. Rückblende (Vorlesetext, 7 bis 10 Sätze), streng nach tatmatrix/<pfad>.json und tatmatrix/basis.json:
   - „Zwei vor zwölf“ gibt es den Knall; „Überall ist es dunkel, nur die Kerzen an der Anrichte und das grüne Notausgangsschild leuchten.“
   - Can springt mit der Maske aus dem Vorratsraum, Herr Schneider packt ihn an der Kapuze und ruft „Hab ich dich!“ (das passiert in jedem Pfad; im Pfad can geht es dort weiter).
   - Der Weg der Täterperson zur Vorratstür, Herrn Schneiders Satz aus der Tatmatrix, dann wörtlich: „Dann, in Panik: ein dumpfer Schlag, Poltern, Metall scheppert über den Steinboden.“
   - Die Spuren, die dabei entstehen (aus dem Schlag-Ereignis der Tatmatrix), das Abreißen des Bunds vom Gürtel und sein Versteck, zum Schluss: „Um Mitternacht schaltet Tim die Hauptsicherung wieder ein, und das Licht geht an.“
   - Keine Gedanken der Figuren (TON §2: der Erzähler kennt keine Gedanken), also nicht „Wer den Schlüssel hat, kommt raus …“. Stattdessen Handlung: „… reißt den Bund vom Gürtel“.
   - Herr Schneider beleidigt niemanden; seine Sätze wörtlich aus der Tatmatrix (dort ist „Freundchen“ gestrichen).
6. Uhrzeiten und Beträge in Worten, Sätze im Mittel höchstens 14 Wörter, keiner über 25. Keine Fachwörter, kein Alkohol (Getränke: Tee, alkoholfreier Apfelpunsch).
7. Keine neuen Tatsachen. Alles aus figuren.json (killerProfile der Täterperson), tatmatrix/<pfad>.json, gegenstaende.json, zeitleiste.json (z_morgen, z_licht, z_ausfall).

BEFUNDE ZU DEINER DATEI (aus F3-KONT-04, F3-KONT-05, F3-SENS-02; Spalten: Nr | Fundstelle | Prüfpunkt | Zitat Text | Zitat Kanon | Schwere | kleinste Korrektur). Die Regeln oben haben Vorrang vor einzelnen Vorschlägen:
[F3-KONT-04] | 4 | erzaehler-finale-fatma.json#finale.fatma.ende_meister, text | Ende richtige Anklage (E-029) | „Den Schlüsselbund findet das Geburtstagskind in der Brottasche auf dem linken Buffettisch.“; „Mit dem Bund kommt die Runde am Morgen hinaus.“ | SCHLUESSEL.md Z. 53 (wie Nr. 1). E-029 (b): „Der Bund kommt im Finale über das Geständnis.“ | schwer | „Fatma gibt den Schlüsselbund heraus, den sie in der Brottasche auf dem linken Buffettisch versteckt hat.“ und „Herr Schneider schließt noch in der Nacht das Außentor auf.“ |
[F3-KONT-04] | 5 | erzaehler-finale-fatma.json#finale.fatma.ende_teilerfolg, text | Ende richtige Anklage, Verlauf | „Den Schlüsselbund findet in der Nacht niemand.“; „…und die Gruppe sitzt bis zum Morgen fest.“; „Um sieben Uhr kommt Herrn Schneiders Kollegin mit dem Ersatzschlüssel und schließt das Außentor auf.“ | SCHLUESSEL.md Z. 52 und 53 (wie Nr. 2). E-029: „Bei richtiger Anklage gesteht die Täterperson und gibt den Bund heraus; das Tor geht noch in der Nacht auf.“ zeitleiste.json z_festgesetzt (00:03) beschreibt den Zustand vor der Anklage. | schwer | „Fatma gibt den Schlüsselbund aus der Brottasche auf dem linken Buffettisch heraus.“; „und die Gruppe sitzt bis zum Morgen fest“ streichen; „Herr Schneider schließt noch in der Nacht das Außentor auf.“ (für den Kollegin-Satz) |
[F3-KONT-04] | 6 | erzaehler-finale-fatma.json#finale.fatma.ende_justizirrtum, text | Ende falsche Anklage (E-029) | „Erst am Morgen wird der Schlüsselbund in der Brottasche auf dem linken Buffettisch gefunden.“; „Fatma gesteht: Die Tat war Panik im Dunkeln.“; „Mit dem Bund kommt die Runde hinaus.“ | SCHLUESSEL.md Z. 54 (wie Nr. 3). E-029: „Das Tor bleibt zu bis zum Morgen.“ | schwer | „Das Tor bleibt zu bis zum Morgen. Um sieben Uhr kommt Herrn Schneiders Kollegin mit dem Ersatzschlüssel und schließt das Außentor auf. Fatma gesteht erst danach: Die Tat war Panik im Dunkeln.“ (für die ersten drei Sätze); „Dann geht die Runde hinaus.“ (für den Bund-Satz) |
[F3-KONT-04] | 8 | erzaehler-finale-fatma.json#ende_meister, ende_teilerfolg, ende_justizirrtum, ende_eskalation, text | Anrede (siehe OFFENE FRAGE 2) | „Das Geburtstagskind hat alle Spuren zusammengetragen.“; „Das Geburtstagskind zeigt auf Fatma, und die Anklage stimmt.“; „Das Geburtstagskind klagt die falsche Person an.“ | wie Nr. 7 | mittel | „Du hast alle Spuren zusammengetragen.“; „Du zeigst auf Fatma, und die Anklage stimmt.“; „Du klagst die falsche Person an.“ |
[F3-KONT-04] | 10 | erzaehler-finale-fatma.json#rueckblende.fatma, text | Rückblende: Wege, Spuren | „Dann, in Panik, ein dumpfer Schlag: Poltern, Metall scheppert über den Steinboden.“ (ohne Silberring, Wachs, Schatulle und Weg) | tatmatrix/fatma.json ev_fatma_schlag: „Ihr Silberring schrammt über das Messing, rote Wachstropfen fallen auf die Schatulle.“ muenzschatulle 23:58:38 „in Fatmas Hand“. Plan 23:58:31 „nach vor_vorratstuer“. finale.fatma.ende_meister: „An Fatmas breitem Silberring klebt frischer Messingabrieb“ | mittel | Nach „…über den Steinboden.“ einfügen: „Ihr breiter Silberring schrammt über das Messing, und rote Wachstropfen fallen auf die Schatulle in ihrer Hand.“ Vor „Herr Schneider packt den Gurt …“ einfügen: „Fatma geht zur Vorratstür und hält dort die Schatulle in der Hand.“ Zur Gedankenzeile siehe OFFENE FRAGE 1. |
[F3-KONT-04] | 11 | erzaehler-finale-fatma.json#rueckblende.fatma, Satz 1 | Zeit und Licht, Querlesen mit Ahmet-Rückblende | „Kurz vor Mitternacht gibt es einen Knall, und alles ist dunkel.“ | zeitleiste.json z_ausfall (23:58): „Knall. Die Hauptsicherung fliegt raus, überall ist es dunkel. Nur die Kerzen an der Anrichte und das grüne Notausgangsschild leuchten.“ Ahmet-Rückblende: „Zwei vor zwölf gibt es einen Knall“ | mittel | „Zwei vor zwölf gibt es einen Knall, und überall ist es dunkel, nur die Kerzen an der Anrichte und das grüne Notausgangsschild leuchten.“ |
[F3-KONT-04] | 13 | erzaehler-finale-fatma.json#rueckblende.fatma, Satz 2 | Querlesen (Satz nur in der Ahmet-Rückblende) | „…und Herr Schneider packt Can an der Kapuze.“ | z_zusammenstoss (23:58:13): „…packt ihn an der Kapuze: „Hab ich dich!““ Ahmet-Rückblende: „ruft: „Hab ich dich!““ | leicht | „…und Herr Schneider packt Can an der Kapuze und ruft: „Hab ich dich!““ |
[F3-SENS-02] | 2 | finale-fatma#ende_meister | Ausgang, S12 | „Den Schlüsselbund findet das Geburtstagskind in der Brottasche …“; „Mit dem Bund kommt die Runde am Morgen hinaus.“ | E-029 richtig | schwer | „Fatma holt den Schlüsselbund aus der Brottasche und gibt ihn heraus. Noch in der Nacht schließt Herr Schneider das Außentor auf.“ Satz „Mit dem Bund …“ entfällt. Dazu „Du hast alle Spuren zusammengetragen.“ |
[F3-SENS-02] | 6 | finale-fatma#ende_teilerfolg | Ausgang, S12 | „Den Schlüsselbund findet in der Nacht niemand.“; „…und die Gruppe sitzt bis zum Morgen fest“; „Um sieben Uhr kommt …“; „Das Geburtstagskind zeigt auf Fatma“ | E-029 richtig; zeitleiste z_festgesetzt (siehe Frage 1) | schwer | „Fatma gibt den Schlüsselbund heraus. Noch in der Nacht schließt Herr Schneider das Außentor auf.“ „und die Gruppe sitzt bis zum Morgen fest“ entfällt. Dazu „Du zeigst auf Fatma, und die Anklage stimmt.“ |
[F3-SENS-02] | 10 | finale-fatma#ende_justizirrtum | Ausgang, S12 | „Erst am Morgen wird der Schlüsselbund … gefunden. Fatma gesteht: …“; „Mit dem Bund kommt die Runde hinaus.“; „Das Geburtstagskind klagt …“ | E-029 falsch | schwer | „Das Tor bleibt zu bis zum Morgen. Um sieben Uhr schließt Herrn Schneiders Kollegin mit dem Ersatzschlüssel das Außentor auf. Erst danach gesteht Fatma: Die Tat war Panik im Dunkeln. Dann gehen alle hinaus.“ Dazu „Du klagst die falsche Person an.“ |
[F3-SENS-02] | 17 | rueckblende.fatma; rueckblende.can | TON §1 (keine Tat ist geplant) | „Wer den Schlüssel hat, kommt raus, bevor das Licht angeht.“ | TON §1 Z. 11: „Keine Tat ist geplant“ | mittel | fatma: „Gleich darauf reißt sie den Bund vom Gürtel.“; can: „Can reißt den Schlüsselbund vom Gürtel.“ |
[F3-SENS-02] | 20 | intro#start; finale-fatma#ende_meister; aufloesung#ahmet.unschuldig, #ahmet.taeter | S11 | „Brot, Dips und Gebäck“; „die Reliefs zu Hause abzeichnen“; „einhundertfünfzig Euro“ (2×) | TON §4 Z. 26: „keine Anglizismen außerhalb der Fachwortliste“; SCHLUESSEL Z. 17: „Keine Fachwörter.“ | leicht | „Brot, Aufstriche und Gebäck.“; „die Verzierungen zu Hause abzeichnen“; „hundertfünfzig Euro“ (2×) |

EIGENE DATEIEN: content/party/schlosskeller/texte/erzaehler-finale-fatma.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN §1 bis §4, SCHLUESSEL.md (ganz), die genannten Kanon-Dateien und die drei anderen Finaldateien (nur lesen, damit die vier Pfade gleich gebaut sind).
2. Schreibe die fünf Texte neu, nach Regeln und Befunden.
3. Prüfe: python3 -m json.tool; dart test test/party/texte_test.dart test/party/erzaehler_test.dart test/party/spoiler_test.dart (grün); dart run bin/party_texte.dart 2>&1 | grep finale-fatma muss leer sein; grep -c "Herr Schneider überlebt" muss 4 ergeben.

ABNAHMEKRITERIEN UND TESTWEG: Fünf Einträge; Ausgangsregel in allen vier Finaltexten eingehalten; Pflichtsatz viermal; Rückblende deckt Weg, Satz, Schlag, Spuren und Bund-Versteck aus der Tatmatrix; Tests grün; Textprüfer ohne Befund.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-81
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Umgesetzte Befunde: <Liste>
- Abgelehnte Befunde mit Grund: <Liste oder „keine“>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-81 · BEREIT ZUR RÜCKGABE ===

F3-AUTOR-83 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Überarbeite die vier Finaltexte und die Rückblende des Pfads Can nach der neuen Ausgangsregel und den Prüfbefunden.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
Lies selbst: figuren.json (Figur can: killerProfile, luegen, nebendelikt), tatmatrix/can.json und tatmatrix/basis.json (Ereignisse 23:58 bis 0:00), gegenstaende.json (Spuren mit rolle can: Feld zeigt), zeitleiste.json (z_ausfall, z_licht, z_morgen), fall.json (Endenmatrix), texte/erzaehler-aufloesung.json (aufloesung.can.taeter, darf sich nicht widersprechen).

SCHNITTSTELLEN:
Deine Datei: content/party/schlosskeller/texte/erzaehler-finale-can.json mit genau 5 Einträgen: finale.can.ende_meister, finale.can.ende_teilerfolg, finale.can.ende_justizirrtum, finale.can.ende_eskalation, rueckblende.can. Kennungen und Dateikopf bleiben.

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
[F3-KONT-05] | 2 | texte/erzaehler-finale-can.json#rueckblende.can, text | K1 Geräusch, Kanon-Widerspruch | „Die Tür zum Vorratsraum quietscht auf, und im Dunkeln leuchtet eine weiße Gespenstermaske.“ | raeume.json#tueren vorrat_tuer: „zustand“: „angelehnt“, „quietscht“: false. tatmatrix/basis.json#ev_vorratstuer_auf (23:58:09): „Herr Schneider zieht die angelehnte Tür zum Vorratsraum auf.“ (ohne Geräusch). wahrnehmung.json#hoeren.tueren: „Wird eine quietschende Tür geöffnet oder geschlossen, ist das laut.“ Gegenstimme: figuren.json#can.motiveAndConflict: „…und die Tür zum Vorratsraum quietscht auf.“ | mittel | „Die Tür zum Vorratsraum geht auf, und im Dunkeln leuchtet eine weiße Gespenstermaske.“ (folgt raeume.json; siehe OFFENE FRAGE 2) |
[F3-KONT-05] | 3 | texte/erzaehler-finale-olli.json#finale.olli.ende_meister und #finale.olli.ende_justizirrtum; texte/erzaehler-finale-can.json#finale.can.ende_meister und #finale.can.ende_justizirrtum | K1 Zeit, Schlüssel | Olli Meister: „Am Morgen holt ihr den Bund hervor, und damit kommt ihr hinaus.“ Olli Justizirrtum: „Erst am Morgen findet ihr den Bund unter dem Eis im Eiskübel.“ Can Meister: „Damit kommt die Runde am Morgen hinaus, und alle lachen erleichtert.“ Can Justizirrtum: „Am Morgen findet die Runde den Schlüsselbund im Helm der Ritterrüstung.“ | zeitleiste.json#z_festgesetzt (00:03): „Die Gruppe sitzt bis zum Morgen fest.“ zeitleiste.json#z_morgen (07:00): „…kommt mit dem Ersatzschlüssel und schließt das Außentor auf.“ raeume.json#tueren aussentor und hoftuer: „schluessel“: „bund_schneider“, „schliesst“: „schluessel_beidseitig“. entscheidungen.json#e3_1 (Runde 3): Buffetsaal-Suche liefert f_fundort_olli, Turmgang-Suche liefert f_fundort_can. | mittel | OFFENE FRAGE: siehe Abschnitt unten, Punkt 1. |
[F3-KONT-05] | 5 | texte/erzaehler-finale-can.json#rueckblende.can, Schlagsatz | K1 Akteur, Gegenstand | „In Panik ein dumpfer Schlag, Poltern, Metall scheppert über den Steinboden.“ | texte/taeter-can.json tatwissen: „Im Dunkeln greifst du in Panik mit der Hand voller Leuchtfarbe nach dem Kerzenständer von der Anrichte. Du schlägst einmal zu.“ texte/erzaehler-aufloesung.json#aufloesung.can.taeter: „…in Panik hat Can den Kerzenständer genommen und einmal zugeschlagen.“ | leicht | „In Panik greift Can mit der Hand voller Leuchtfarbe nach dem Kerzenständer: ein dumpfer Schlag, Poltern, Metall scheppert über den Steinboden.“ |
[F3-SENS-02] | 4 | finale-can#ende_meister | Ausgang, S12 | „Den Schlüsselbund findet das Geburtstagskind im Helm …“; „Damit kommt die Runde am Morgen hinaus …“; „Das Geburtstagskind zeigt auf Can“ | E-029 richtig | schwer | „Can holt den Schlüsselbund aus dem Helm der Ritterrüstung und gibt ihn heraus. Noch in der Nacht schließt Herr Schneider das Außentor auf, und alle lachen erleichtert.“ Dazu „Du zeigst auf Can, und die Anklage stimmt.“ |
[F3-SENS-02] | 8 | finale-can#ende_teilerfolg | Ausgang, S12 | „Den Schlüsselbund findet in der Nacht niemand, er steckt im Helm …“; „Das Geburtstagskind zeigt auf Can“ | E-029 richtig | schwer | „Can holt den Schlüsselbund aus dem Helm der Ritterrüstung und gibt ihn heraus. Noch in der Nacht schließt Herr Schneider das Außentor auf.“ Dazu „Du zeigst auf Can, und die Anklage stimmt.“ |
[F3-SENS-02] | 12 | finale-can#ende_justizirrtum | Ausgang, S12 | „Am Morgen findet die Runde den Schlüsselbund …“; „Später kommt heraus: Can war es.“; „Mit dem Schlüsselbund kommt die Runde hinaus …“; „Das Geburtstagskind klagt …“ | E-029 falsch | schwer | „Das Tor bleibt zu bis zum Morgen. Um sieben Uhr schließt Herrn Schneiders Kollegin mit dem Ersatzschlüssel das Außentor auf. Erst danach gesteht Can: Die Tat war Panik im Dunkeln. Dann geht die Runde hinaus, doch zwischen den Freunden klafft ein tiefer Graben.“ Dazu „Du klagst die falsche Person an.“ |
[F3-SENS-02] | 17 | rueckblende.fatma; rueckblende.can | TON §1 (keine Tat ist geplant) | „Wer den Schlüssel hat, kommt raus, bevor das Licht angeht.“ | TON §1 Z. 11: „Keine Tat ist geplant“ | mittel | fatma: „Gleich darauf reißt sie den Bund vom Gürtel.“; can: „Can reißt den Schlüsselbund vom Gürtel.“ |
[F3-SENS-02] | 19 | rueckblende.can | S6, S8 (Herr Schneider beleidigt niemanden) | „Jetzt kommt die Polizei, Freundchen.“ | TON §7 Z. 63: „Er beleidigt niemanden.“; tatmatrix/can.json ev_can_drohung | leicht | „Jetzt kommt die Polizei.“ (Kanon-Änderung nötig, Frage 6) |

EIGENE DATEIEN: content/party/schlosskeller/texte/erzaehler-finale-can.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN §1 bis §4, SCHLUESSEL.md (ganz), die genannten Kanon-Dateien und die drei anderen Finaldateien (nur lesen, damit die vier Pfade gleich gebaut sind).
2. Schreibe die fünf Texte neu, nach Regeln und Befunden.
3. Prüfe: python3 -m json.tool; dart test test/party/texte_test.dart test/party/erzaehler_test.dart test/party/spoiler_test.dart (grün); dart run bin/party_texte.dart 2>&1 | grep finale-can muss leer sein; grep -c "Herr Schneider überlebt" muss 4 ergeben.

ABNAHMEKRITERIEN UND TESTWEG: Fünf Einträge; Ausgangsregel in allen vier Finaltexten eingehalten; Pflichtsatz viermal; Rückblende deckt Weg, Satz, Schlag, Spuren und Bund-Versteck aus der Tatmatrix; Tests grün; Textprüfer ohne Befund.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-83
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Umgesetzte Befunde: <Liste>
- Abgelehnte Befunde mit Grund: <Liste oder „keine“>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-83 · BEREIT ZUR RÜCKGABE ===

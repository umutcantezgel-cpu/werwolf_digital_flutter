F3-AUTOR-80 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Überarbeite die vier Finaltexte und die Rückblende des Pfads Ahmet nach der neuen Ausgangsregel und den Prüfbefunden.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
Lies selbst: figuren.json (Figur ahmet: killerProfile, luegen, nebendelikt), tatmatrix/ahmet.json und tatmatrix/basis.json (Ereignisse 23:58 bis 0:00), gegenstaende.json (Spuren mit rolle ahmet: Feld zeigt), zeitleiste.json (z_ausfall, z_licht, z_morgen), fall.json (Endenmatrix), texte/erzaehler-aufloesung.json (aufloesung.ahmet.taeter, darf sich nicht widersprechen).

SCHNITTSTELLEN:
Deine Datei: content/party/schlosskeller/texte/erzaehler-finale-ahmet.json mit genau 5 Einträgen: finale.ahmet.ende_meister, finale.ahmet.ende_teilerfolg, finale.ahmet.ende_justizirrtum, finale.ahmet.ende_eskalation, rueckblende.ahmet. Kennungen und Dateikopf bleiben.

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
[F3-KONT-04] | 1 | erzaehler-finale-ahmet.json#finale.ahmet.ende_meister, text | Ende richtige Anklage (E-029) | „Am Morgen schließt Herr Schneider mit seinem Bund das Außentor auf.“; „Das Geburtstagskind findet den Schlüsselbund in der Innentasche von Ahmets Jacke, am Jackenständer im Ostsaal.“ | SCHLUESSEL.md Z. 53: „Die Täterperson gesteht und gibt den Bund heraus. Herr Schneider schließt noch in der Nacht das Außentor auf.“ E-029 (b): „Der Bund kommt im Finale über das Geständnis.“ | schwer | „Ahmet gibt den Schlüsselbund heraus, den er in der Innentasche seiner Jacke am Jackenständer im Ostsaal versteckt hat.“ und „Herr Schneider schließt noch in der Nacht das Außentor auf.“ |
[F3-KONT-04] | 2 | erzaehler-finale-ahmet.json#finale.ahmet.ende_teilerfolg, text | Ende richtige Anklage, Verlauf | „Den Schlüsselbund findet in der Nacht niemand.“; „Um sieben Uhr kommt Herrn Schneiders Kollegin mit dem Ersatzschlüssel und schließt das Außentor auf.“ | SCHLUESSEL.md Z. 52: „Kein Finaltext sagt deshalb, ob das Geburtstagskind den Bund in der Nacht gefunden hat.“ Z. 54 ordnet „Um sieben Uhr … Kollegin“ der falschen Anklage zu. zeitleiste.json z_morgen (07:00). | schwer | „Ahmet gibt den Schlüsselbund aus der Innentasche seiner Jacke heraus.“ (für den ersten Satz); „Herr Schneider schließt noch in der Nacht das Außentor auf.“ (für den Kollegin-Satz) |
[F3-KONT-04] | 3 | erzaehler-finale-ahmet.json#finale.ahmet.ende_justizirrtum, text | Ende falsche Anklage (E-029) | „Erst am Morgen wird Ahmet entdeckt: Der Schlüsselbund steckt in der Innentasche seiner Jacke am Jackenständer im Ostsaal.“; „Ahmet gesteht: Die Tat war Panik im Dunkeln. Dann schließt Herr Schneider mit seinem Bund das Außentor auf, und alle gehen hinaus.“ | SCHLUESSEL.md Z. 54: „Der Bund bleibt verschwunden. Um sieben Uhr schließt Herrn Schneiders Kollegin mit dem Ersatzschlüssel auf (z_morgen). Die Täterperson gesteht erst danach.“ E-029: „Texte formulieren das neutral: „Das Tor bleibt zu bis zum Morgen.““ | schwer | „Das Tor bleibt zu bis zum Morgen. Um sieben Uhr kommt Herrn Schneiders Kollegin mit dem Ersatzschlüssel und schließt das Außentor auf. Ahmet gesteht erst danach: Die Tat war Panik im Dunkeln. Dann gehen alle hinaus.“ (ersetzt die drei Sätze) |
[F3-KONT-04] | 7 | erzaehler-finale-ahmet.json#ende_meister, ende_justizirrtum, ende_eskalation, text | Anrede (siehe OFFENE FRAGE 2) | „Das Geburtstagskind hat die Spuren sauber zusammengetragen.“; „Das Geburtstagskind klagt die falsche Person an.“; „Das Geburtstagskind zeigt auf die falsche Person“ | SCHLUESSEL.md Z. 57: „Anrede: Das Geburtstagskind heißt in Finaltexten „du“ (TON-LEITFADEN §3).“ | mittel | „Du hast die Spuren sauber zusammengetragen.“; „Du klagst die falsche Person an.“; „Du zeigst auf die falsche Person“ |
[F3-KONT-04] | 9 | erzaehler-finale-ahmet.json#rueckblende.ahmet, text | Rückblende: Wege, Spuren, Bund | „Dann, in Panik: ein dumpfer Schlag, Poltern, Metall scheppert über den Steinboden.“ (ohne Umschlag, Wachs und Weg); „Der Schlüsselbund wandert in die Innentasche von Ahmets Jacke …“ | tatmatrix/ahmet.json ev_ahmet_schlag: „Heißes Wachs tropft auf den Umschlag, eine Ecke reißt ab und bleibt am Griff kleben.“ Plan 23:58:30 „nach vor_vorratstuer“. zeitleiste.json z_bund_weg: „Der Schlüsselbund wird vom Gürtel gezogen.“ | mittel | Nach „…rennt davon.“ einfügen: „Ahmet schleicht vom Ostende der Theke zur Vorratstür.“ Nach „…über den Steinboden.“ einfügen: „Heißes Wachs tropft auf den Umschlag in Ahmets Hand, eine Ecke reißt ab und bleibt am Griff des Kerzenständers kleben.“ Den Bund-Satz beginnen mit „Der Schlüsselbund wird vom Gürtel gezogen und wandert …“ |
[F3-KONT-04] | 12 | erzaehler-finale-ahmet.json#rueckblende.ahmet, Satz 2 | Licht | „Überall ist es dunkel, nur die Kerzen an der Anrichte leuchten.“ | z_ausfall: „Nur die Kerzen an der Anrichte und das grüne Notausgangsschild leuchten.“ | leicht | „Überall ist es dunkel, nur die Kerzen an der Anrichte und das grüne Notausgangsschild leuchten.“ |
[F3-SENS-02] | 1 | finale-ahmet#ende_meister, text | Ausgang (E-029), S12 | „Am Morgen schließt Herr Schneider mit seinem Bund das Außentor auf.“; „Das Geburtstagskind findet den Schlüsselbund …“ | E-029 richtig: „gibt den Bund heraus; das Tor geht noch in der Nacht auf“ (ENTSCHEIDUNGSLOG, KONT-05) | schwer | „Ahmet holt den Schlüsselbund aus seiner Jacke und gibt ihn heraus. Noch in der Nacht schließt Herr Schneider das Außentor auf.“ Dazu „Du hast die Spuren sauber zusammengetragen.“ |
[F3-SENS-02] | 5 | finale-ahmet#ende_teilerfolg | Ausgang | „Den Schlüsselbund findet in der Nacht niemand.“; „Um sieben Uhr kommt Herrn Schneiders Kollegin …“ | E-029 richtig; fall.json: Teilerfolg „richtig“ | schwer | „Ahmet gibt den Schlüsselbund heraus. Noch in der Nacht schließt Herr Schneider das Außentor auf.“ |
[F3-SENS-02] | 9 | finale-ahmet#ende_justizirrtum | Ausgang, S12 | „Erst am Morgen wird Ahmet entdeckt: Der Schlüsselbund steckt …“; „Dann schließt Herr Schneider mit seinem Bund das Außentor auf …“; „Das Geburtstagskind klagt …“ | E-029 falsch: „Der Bund bleibt verschwunden. … Die Täterperson gesteht erst danach.“ (SCHLUESSEL Z. 54; z_morgen 07:00) | schwer | „Das Tor bleibt zu bis zum Morgen. Um sieben Uhr schließt Herrn Schneiders Kollegin mit dem Ersatzschlüssel das Außentor auf. Erst danach gesteht Ahmet: Die Tat war Panik im Dunkeln. Dann gehen alle hinaus.“ Dazu „Du klagst die falsche Person an.“ |
[F3-SENS-02] | 13 | finale-ahmet, -fatma, -can#ende_eskalation (je 1 Satz); alle vier nach dem Pflichtsatz | S12, S13 | „Das Geburtstagskind zeigt auf die falsche Person“; Pflichtsatz ohne Witz | SCHLUESSEL Z. 57 („du“); TON §1: „ist bald wieder grantig“ | mittel | „Du zeigst auf die falsche Person“; nach dem Pflichtsatz in allen vier: „Er ist schon wieder grantig.“ |
[F3-SENS-02] | 14 | finale-ahmet#ende_meister; aufloesung#leyla, #zeynep, #can.unschuldig | S14, TON §7 | „Lejla und Ahmet sind zusammen aufgewachsen, doch …“; „Lejla hat geschwiegen, weil Ahmet ihr Cousin ist.“; „Sie wollte ihren Bruder schützen“; „Seine Schwester Zeynep hat …“ | TON §7 Z. 64: „Schulden und Geldsorgen werden nie mit Familie oder Herkunft begründet.“; figuren.json leyla.loyalitaet; zeynep.ziel: „Can schützen.“ | mittel | leyla: „Lejla hat geschwiegen. Sie hatte Ahmet versprochen, nichts über die Rechnung zu sagen.“; zeynep: „Sie wollte Can schützen, und deshalb hat sie geschwiegen.“; can: „Zeynep hat für ihn Schmiere gestanden …“; ahmet: „Die Runde bleibt beieinander.“ Muster: zwei Frauen decken männliche Verwandte. |

EIGENE DATEIEN: content/party/schlosskeller/texte/erzaehler-finale-ahmet.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN §1 bis §4, SCHLUESSEL.md (ganz), die genannten Kanon-Dateien und die drei anderen Finaldateien (nur lesen, damit die vier Pfade gleich gebaut sind).
2. Schreibe die fünf Texte neu, nach Regeln und Befunden.
3. Prüfe: python3 -m json.tool; dart test test/party/texte_test.dart test/party/erzaehler_test.dart test/party/spoiler_test.dart (grün); dart run bin/party_texte.dart 2>&1 | grep finale-ahmet muss leer sein; grep -c "Herr Schneider überlebt" muss 4 ergeben.

ABNAHMEKRITERIEN UND TESTWEG: Fünf Einträge; Ausgangsregel in allen vier Finaltexten eingehalten; Pflichtsatz viermal; Rückblende deckt Weg, Satz, Schlag, Spuren und Bund-Versteck aus der Tatmatrix; Tests grün; Textprüfer ohne Befund.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-80
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Umgesetzte Befunde: <Liste>
- Abgelehnte Befunde mit Grund: <Liste oder „keine“>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-80 · BEREIT ZUR RÜCKGABE ===

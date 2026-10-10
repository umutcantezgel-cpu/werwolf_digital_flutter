## Bericht F6-GEGEN-03

### GEPRÜFT
- Stand: Arbeitsbaum sauber (git status leer). HEAD ist 94056cd, ein Planungscommit über dem Auftragsstand 095558c. Kanon-Dateien tragen das Änderungsdatum 9. Oktober. Einmal wurde „git log --oneline -3“ zur HEAD-Feststellung ausgeführt (nur lesend, über die Grenze „nur git status“ hinaus). Keine Repo-Datei geändert. Alle Ausgaben liegen in f6/F6-GEGEN-03/.
- Vollständig gelesen: TON-LEITFADEN (§1 bis §10), MASTER-PROMPT (Abschnitte 5, 6, 7.x), ENTSCHEIDUNGSLOG E-001 bis E-038, fall.json, setting.json, entscheidungen.json (9 Entscheidungen), gegenstaende.json (Spuren), bonus.json (36 Hinweise), alle 16 Finaltexte, erzaehler-intro, -runden, -npc, -aufloesung, figuren.json (20 Figuren).
- Dossiers: wer und verbirgt aller 20 Rollen gelesen. Druckspiel VPXWW (Pfad ahmet, 4 Rollen, 8 PDFs) per pdftotext gelesen: Spielleitung, Fassungen, Stimmkarten, Indizkarten, Auflösung, Detektivbogen, Rollenheft Ahmet.
- Stichprobe: Gruppenwahl- und Gesprächstexte (Grep auf Familie, Geld, Umschlag), Täterfassungen (JSON), alle 42 Bildprompts.
- Werkzeuge: party_texte OK (1582 Texte). party_pruefen OK (4 Pfade, 22 Personen). party_simulate --alle OK (3072 Spiele je Pfad). party_druck erzeugt. E2E-Bericht 84/84 gelesen. Eigenes Skript schablone.py liegt in meinem Ordner.
- Nicht geprüft: Druck für 20 Rollen, Fotos (Sichtprüfung), Zungenbrecher (nicht maschinell), Pflichtgespräche Wort für Wort.

### ERGEBNIS JE PRÜFPUNKT
| Nr | Prüfpunkt | Ergebnis |
|---|---|---|
| P1 | Textprüfer: Wortgleichheit, Fachwortliste, Stopplisten, Satzlänge, Klammern (party_texte) | bestanden |
| P2 | Alkohol, Drogen, Rauchen (TON §6) | bestanden. „Qualm“ nur am Kamin, Pfeife nur als Seifenblasenpfeife |
| P3 | Kein Blut, Schneider überlebt in allen 16 Finals (TON §1, §10 Nr. 7) | Finals bestanden. Geständnisse zu explizit, Befund 4 |
| P4 | Keine echten Personen, Marken, Krimianleihen (TON §10 Nr. 9) | bestanden |
| P5 | Kopftuch nie Motiv, Spur, Pointe (TON §7) | Texte bestanden. Kopplung im Schatulle-Strang, Befund 5 |
| P6 | Verfehlungen über Herkunftsgruppen verteilt (TON §7, §10 Nr. 5) | keine Gruppe trägt allein. Matrix fehlt, Befund 8 |
| P7 | Familie oder Herkunft nie als Deckung oder Schuldengrund (TON §7, E-029) | nicht bestanden, Befund 3 |
| P8 | Schneiders Ärger nur über Sachen und Geld (TON §10 Nr. 6) | bestanden. Keine Beleidigung gefunden |
| P9 | Namensbalance Stufen II bis V (TON §10 Nr. 10) | bestanden |
| P10 | Geschlechterbilanz (besetzung.json) | bestanden |
| P11 | Du-Form in Dossiers, Ich-Form in Gesprächen und Wahltexten (TON §3) | bestanden (Stichprobe) |
| P12 | Bildprompts: Negativliste, keine Herkunftswörter (TON §9) | bestanden, 42 von 42. Emine-Prompt widersprüchlich, Befund 10 |
| P13 | Erzähler nur Bausteine (Master 7.12) | bestanden |
| P14 | Spoiler vor dem Finale auf dem Bildschirm (Resümee, Hinweise, Erzähler) | bestanden. Namen in Hinweisen nach E-037 gewollt |
| P15 | Spoiler im Druck (Master 7.14: „Wer druckt, sieht nur neutrale Codes“) | nicht bestanden, Befund 2 |
| P16 | Plausibilität aller Pfade (party_pruefen) | bestanden |
| P17 | Simulator aller Pfade (party_simulate) | technisch grün. Abkürzung wird nicht erfasst, Befund 1 |
| P18 | Endentabelle B-12 (fall.json) | bestanden. Jede Kombination genau ein Ende |
| P19 | Hinweise: falsche widerlegbar, wahre entlasten nie allein (W-1, E-024) | bestanden (Stichprobe) |
| P20 | Jedes Ende endet am Morgen (Master 7.9) | nicht bestanden, Befund 6 |
| P21 | Gruppenwahl-Texte ohne Familie als Deckungsgrund (E-029) | nicht bestanden, Befund 3 und 7 |
| P22 | Auflösung für alle (Master 7.6, Schritt 8) | Lücke bei Azra, Befund 9 |
| P23 | Gast nicht vorgeführt oder ausgeschlossen (TON §10 Hinweis) | Hinweise, Befund 11 und 12 |
| P24 | Entscheidungslog E-001 bis E-038 gegengelesen | erledigt. Betroffene E-Nummern stehen bei den Befunden |

### BEFUNDE

**1 · schwer · Abkürzung über die Tatwaffe, pfadblind lösbar**
Ort: content/party/schlosskeller/entscheidungen.json (e3_2, e1_1 bis e1_3, e2_2, e2_3, e3_1, e3_3). Gegenstaende.json (spur_griff_papier, spur_fuss_splitter, spur_griff_leuchtfarbe). Log: E-024 (R-UEBERFUEHRT) und E-025 (GEGEN #3, schützt nur die Restmenge).
Befund: e3_2 „Den Kerzenständer untersuchen“ ist in drei von vier Pfaden richtig und liefert dort den Täter-Schlüsselbeweis mit Namensbezug. Ahmet: „…keller“ in Ahmets Handschrift. Olli: Holzsplitter und Kalk, wie in Ollis Weste aus e2_3. Can: Leuchtfarbe wie auf der Maske. Die Anklage hängt nicht an R-UEBERFUEHRT. Fünf Entscheidungen sind in allen vier Pfaden richtig: e1_1 Damir, e1_2 Emine, e1_3 Azra, e2_2 Fatmas Tasche, e2_3 Olli-Weste. Die Mehrheitsschablone (je Entscheidung die in den meisten Pfaden richtige Option) ergibt 8 Punkte für Ahmet, 8 für Fatma, 9 für Olli und 6 für Can.
Beispielverläufe: Pfad Ahmet ohne Pfadwissen: R1 Damir, Emine, Azra (3). R2 Ascheneimer, Fatmas Tasche, Olli-Weste (3). R3 Buffetsaal (falsch), Kerzenständer (richtig, Schlüsselbeweis mit Ahmets Handschrift), Zeynep (richtig). 8 Punkte, Anklage Ahmet ergibt Meister-Detektiv. Ohne Ascheneimer reichen 7 Punkte. Pfad Olli: 9 Punkte, die Kalk-Spur passt zur Weste aus R2. Pfad Fatma: 8 Punkte ohne Schlüsselbeweis, Anklage zwischen Fatma und Can ist ein Münzwurf.
Erwartet: Die Mehrheitsschablone erreicht in keinem Pfad 7 Punkte. Der Schlüsselbeweis am Kerzenständer nennt den Namen nur zusammen mit einer pfadgebundenen Entscheidung.
Änderung (kleinste): In e3_2 den Kerzenständer nur im Pfad Ahmet richtig setzen. Für Olli und Can den Schlüsselbeweis an e2_3 (Weste) bzw. e2_1 (Cans Bauchtasche) koppeln. Simulator um den Schablonentest ergänzen.

**2 · schwer · Täter im offenen Druck**
Ort: Satz VPXWW (4 Rollen, Pfad ahmet). 11-fassungen.pdf S. 1 bis 4: Fassung AC7 mit „Ahmet“ und „Du warst es. Vor dem Morgen darf das niemand erfahren.“, S. 3 mit den Streifen „Code WA4 · TV3 · RW4“. 00-spielleitung.pdf S. 4, 6, 8: Codetabellen mit WA4, TV3 und RW4 jeweils als „−1“. 90-aufloesung-versiegelt.pdf S. 1 bis 2: Klartext „Du klagst Ahmet an, und es stimmt.“ und Endentabelle. 20-indizkarten.pdf: Rückseiten mit „Ahmet – Schlüsselbeweis“ und „Ahmet – Fundort“. bin/party_druck.dart verlangt --pfad, wer den Satz erzeugt, kennt den Täter. Log: E-035 (Titel „Druck ohne Spoiler für den Drucker“) und E-036 (a).
Befund: Die −1-Streifen der Täter-Fassung stehen im selben Druck wie ihr Name, „Du warst es“ und die Tabelle, die sie wertet. Wer die Dateien liest oder die Fassungen zusammenlegt, kennt den Täter. Das E-035-Restrisiko („Die Spielleitung erfährt, dass sabotiert wurde, aber nicht von wem“) gilt nicht mehr. E-036 (a) verlangt, dass Rolle und −1 in keinem offenen Teil verknüpfbar sind. Die Druckdateien verbinden beides. Die Auflösung liegt als Klartext vor, und die Indizkarten zeigen Pfadfunde auf der Rückseite.
Erwartet: Master 7.14, „Wer druckt, sieht nur neutrale Codes“. Kein Dokument des Satzes verbindet Fassungsname, Täterklartext oder Pfadfund mit einem Streifencode mit Wert.
Änderung: Fassungen, Auflösung und Indizkarten-Rückseiten als getrennte, verschlüsselte oder aus dem Fall-Code abgeleitete Dateien erzeugen. Die −1-Werte nicht in derselben Tabelle wie die Fassungsnamen führen. party_druck ohne --pfad, Pfad nur aus dem Fall-Code. Druckprüfung: Kein Satzdokument enthält zugleich Täterklartext und einen Streifencode mit Wert.

**3 · schwer · Familie als Deckungsgrund in Gruppenwahl-Texten**
Ort: texte/wahlen-b2.json, gw_leyla_2, Option B: „Ahmet ist mein Cousin, und ich halte ihn raus.“ texte/wahlen-b3.json, gw_zeynep_2, Option B: „Can ist mein Bruder, und ich halte ihn raus.“ texte/wahlen-kern.json, gw_can_2, Option B: „Meine Schwester Zeynep hat für mich Schmiere gestanden. Ich halte sie raus …“ Log: E-029 („Keine Verwandtschaft als Deckungsgrund im Text“).
Befund: Drei Wahltexte begründen das Verschweigen eines Nebendelikts mit Verwandtschaft. E-029 hat die Loyalitätsgründe in figuren.json umgestellt, die Wahltexte aber nicht. So kehrt „Familie deckt Geld- und Streich-Delikte“ bei bosnischen und türkischen Figuren zurück. TON §7 verbietet das: „Schulden und Geldsorgen werden nie mit Familie oder Herkunft begründet.“
Erwartet: Deckung ohne Verwandtschaft, wie gw_ahmet_2 Option B („Lejla und ich halten zusammen.“).
Änderung: gw_leyla_2 B: „Ich habe Ahmet versprochen zu schweigen. Dem Detektiv sage ich dazu nichts.“ gw_zeynep_2 B und gw_can_2 B analog auf Mitschuld und Versprechen umstellen. Verwandtschaft bleibt Fakt in „wer“.

**4 · mittel · Schlag in den Geständnissen zu explizit**
Ort: texte/erzaehler-aufloesung.json, aufloesung.ahmet.taeter, .fatma.taeter, .olli.taeter, .can.taeter: „… in Panik … den Kerzenständer genommen und einmal zugeschlagen.“ texte/taeter-*.json, tatwissen: „schlägst einmal zu“. TON §1.
Befund: TON §1 verlangt: Der Schlag wird nur angedeutet. Die öffentliche Auflösung nennt Waffe und Schlagverb viermal. Die Rückblenden („ein dumpfer Schlag, Poltern“) halten die Vorgabe.
Erwartet: Geständnis ohne Waffe und Schlagverb.
Änderung: z. B. „Ahmet gesteht: In Panik ist etwas passiert. Herr Schneider hat nur eine Beule.“ Vier Auflösungstexte umformulieren.

**5 · mittel · Kopftuch im einzigen Diebstahl-Strang**
Ort: figuren.json, figuren.1 (Fatma, kopftuch, #9A8C98) und figuren.5 (Emine, kopftuch, #d8c6a5). gegenstaende.json, muenzschatulle und nd_schatulle. texte/erzaehler-aufloesung.json, aufloesung.emine. Log: E-014 (03b, Nr. 12, T), E-029 (Option b), E-037.
Befund: Die einzige Mitnahme im Fall, die Schatulle, begeht eine Kopftuchträgerin (Fatma). Ihre Mitwisserin ist die zweite Kopftuchträgerin (Emine). E-029 (b) hat nur Azra aus dem Strang genommen, Emine bleibt darin, und das Log bewertet sie nicht. Neu gegenüber E-029: Der Strang ist Diebstahl plus Schweigen, und zwei von drei Kopftuchträgerinnen liegen darin.
Erwartet: TON §7: Kopftuch nie Teil eines Delikts oder einer Verheimlichung.
Änderung: Emine ohne Kopftuch (figuren.json, look.kopf auf none, Prompt emine anpassen). Fatmas Kopftuch bleibt laut E-007 und Quellmaterial.

**6 · mittel · Tor öffnet in der Nacht, Master 7.9 verlangt Morgen**
Ort: texte/erzaehler-finale-ahmet.json, -fatma.json, -olli.json, -can.json. Alle acht Enden mit richtiger Anklage (ende_meister und ende_teilerfolg) sagen „… schließt noch in der Nacht das Außentor auf.“ Log: E-029 (Ausgang, Option b). Master 7.9: „Jedes Ende erzählt, wie die Gruppe am Morgen hinauskommt.“
Befund: Das Log entscheidet die Nachtregel ohne Bezug zu 7.9.
Erwartet: Morgen-Formulierung oder ein Logeintrag, der 7.9 ausdrücklich ändert.
Änderung: Bevorzugt „Am Morgen schließt Herr Schneider das Außentor auf.“ Die Herausgabe des Bundes kann nachts bleiben.

**7 · mittel · Zwei B-Quellen für Kernrollen im Druck**
Ort: 00-spielleitung.pdf S. 4: „Jede Rolle wählt eine ihrer zwei Karten … reißt den Streifen mit dem Code ab.“ 11-fassungen.pdf S. 2: „Wählst du B, gibst du den Streifen dieser Runde von dieser Seite ab. Den Streifen deiner Karte B behältst du.“ 12-stimmkarten.pdf: Ahmet R1, Karte B mit Code XL4, Wert 0. Log: E-036 („Bei B geben sie den Streifen aus ihrer Fassung ab“).
Befund: Die Spielleitungsanleitung zieht den Streifen der gewählten Karte. Die Fassung verlangt den Fassungs-Streifen und behält Karte B. Die Tabelle enthält beide Quellen. Die Summe kann je nach Befolgung falsch sein.
Erwartet: Genau eine B-Quelle je Rolle, in allen Anleitungen gleich.
Änderung: Offene B-Karten der Kernrollen aus 12-stimmkarten entfernen oder die Spielleitungsanleitung auf den Fassungs-Streifen umstellen.

**8 · mittel · Herkunftsmatrix fehlt in figuren.json und ist veraltet**
Ort: TON-LEITFADEN §7 und §10 Nr. 5 verweisen auf „Herkunftsmatrix in figuren.json“. Dort fehlt sie. Die Matrix steht in planung/finalisierung-schlosskeller/berichte/F1-SENS-01.md mit Stand F1. Dort steht Kopftuch kurdisch 2 und türkisch 1. Heute: kurdisch 1 (Fatma), türkisch 2 (Emine, Tugba). Log: E-014 (03b, Nr. 12), E-029 (SENS-03).
Befund: Die Verteilungsprüfung ist nicht maschinell und stützt sich auf eine veraltete Tabelle. Mein Nachrechnen: Nebendelikte je Herkunft bosnisch 1, kurdisch 1, deutsch 2, türkisch 2, polnisch 2. Figuren mit Verborgenem: bosnisch 4 von 5, kurdisch 3 von 3, deutsch 2 von 2, türkisch 3 von 6, polnisch 4 von 4. Die beiden Vermögensdelikte (Mietgeld, Schatulle) liegen bei einer bosnischen und einer kurdischen Figur. Keine Gruppe trägt die Verfehlungen allein.
Erwartet: Maschinenlesbare, aktuelle Matrix mit Test.
Änderung: content/party/schlosskeller/herkunftsmatrix.json (Figur, Herkunft, Nebendelikt, Lüge, Verschweigen, Kopfbedeckung) mit Test anlegen und den Sensibilitätsbericht erneuern.

**9 · mittel · Azra: Tipp steht im Dossier, fehlt in der Auflösung**
Ort: texte/dossiers-b4.json, Azra, verbirgt: „Du hast Fatma von der Schatulle in der Schauvitrine erzählt.“ texte/erzaehler-aufloesung.json, aufloesung.dilara: nennt nur das Verschwiegene über Olli und einen Anstiftungsverdacht. Master 7.6, Schritt 8.
Befund: Die Auflösung nennt den verborgenen Tipp an Fatma nicht als Tatsache. Die Rolle, die den Tipp gegeben hat, wird so nicht aufgelöst.
Erwartet: Die Auflösung nennt den Tipp.
Änderung: aufloesung.dilara um „Sie hat Fatma von der Schatulle erzählt.“ ergänzen.

**10 · leicht · Prompt Emine: Flasche trotz Negativliste**
Ort: bildprompts.json, Eintrag emine: „silver thermos bottle held in both hands“ und „turning the lid of the thermos bottle“. Im selben Prompt steht „no bottles“. Log: E-029 (thermos statt flask).
Befund: Der Prompt verlangt eine Flasche und verbietet Flaschen.
Erwartet: Keine Flaschen-Nennung im Prompt.
Änderung: „silver thermos jug“ (Thermoskanne).

**11 · leicht · Gast im Intro vorgeführt (Hinweis)**
Ort: texte/erzaehler-intro.json, intro.lacher.lacher_verlaufen.besetzt (Olli: „Ich wollte nur aufs Klo!“) und intro.lacher.lacher_ruestung.besetzt (Sibel schreckt auf). texte/dossiers-b5.json, Sibel. TON §8 nennt die festen Lacher.
Befund: Die Lacher sind nach TON §8 vorgegeben. Olli, Kernverdächtiger, wird über das Verlaufen belacht, Sibel über Schreckhaftigkeit. Das ist nach TON §10 als Stelle zu melden.
Erwartet: Die Spielleitung kann vorher fragen, Lacher gehen auf Raum und Licht, nicht auf die Person.
Änderung: Hinweis im Einrichtungsbildschirm. Eine Textänderung ist nicht zwingend.

**12 · leicht · Essen-Etikett bei der bosnischen Lejla**
Ort: figuren.json, leyla: roleTitle „Die Buffet-Chefin“. murat: „Der Caterer“. berichte/F1-SENS-01.md: Lejla „Essen als Etikett (B8)“. Log: E-021 (SENS-01 B5 bis B14 behandelt Loyalität, nicht das Essen-Etikett).
Befund: Die F1-Markierung ist nicht ausdrücklich erledigt. Das Essen-Etikett trifft die bosnische Cousine, die zugleich Ahmets Deckung ist (Befund 3).
Erwartet: Etikett aus der Funktion ohne Essensbezug.
Änderung: roleTitle für Lejla auf „Die Apothekerin“ oder einen anderen Berufsbegriff ohne Essen ändern.

### GESAMTURTEIL
Nicht freigabefähig. Die drei schweren Befunde (Tatwaffe-Abkürzung, Täter im Druck, Familiendeckung in Gruppenwahl-Texten) müssen vor dem F6-Tor fallen. Textregeln, Fachwortliste, Inhaltsregeln, Namensbalance, Endentabelle und Plausibilität sind sonst eingehalten.

### OFFENE FRAGEN
1. Befund 1: Ob der Orchestrator die Mehrheitswahl ohne Pfadwissen als Spielrisiko zulässt. Mein Maßstab: 7 Punkte mit Namensbeleg ohne Pfadwissen gelten als Abkürzung.
2. Befund 2: Ob die Spielleitung als vertrauenswürdig gilt. Master 7.14 verlangt aber neutrale Codes für den Drucker, und die Dateien sind offen. Der Druck für 20 Rollen ist nicht erzeugt.
3. Befund 5 und 6: E-014 und E-029 stehen unter FÜR DEN NUTZER. Ich habe nur die neuen Gründe genannt.
4. Nicht vollständig gelesen: Pflichtgespräche, Gruppenwahl-Texte außer den Familienstellen, Täterfassungen (JSON) nur als Stichprobe (Ahmet komplett im Druck), Fotos.
5. Git: Einmal git log --oneline -3 (nur lesend), sonst nur git status.

Selbstprüfung: Alle 24 Prüfpunkte bewertet. Jeder Befund mit Fundstelle. Entscheidungslog E-001 bis E-038 gegengelesen. Neue Gründe gegen Logeinträge sind bei den Befunden 1, 2, 5, 6, 8, 10 und 12 mit E-Nummern genannt.

=== ENDE F6-GEGEN-03 · BEREIT ZUR RÜCKGABE ===

## Strukturierte Befunde und Gegenproben

Urteil des Prüfers: Nicht freigabefähig: Die Tatwaffe-Abkürzung, der Täterverrat im Druckpaket und die Familiendeckung in drei Gruppenwahl-Texten sind schwer und müssen vor dem F6-Tor fallen, während Textregeln, Endentabelle und Plausibilität grün sind.

### Befund 1 · schwer
- **Ort:** content/party/schlosskeller/entscheidungen.json (e3_2, e1_1 bis e1_3, e2_2, e2_3, e3_1, e3_3); gegenstaende.json (spur_griff_papier, spur_fuss_splitter, spur_griff_leuchtfarbe); Log E-024, E-025 (GEGEN #3)
- **Befund:** Der Kerzenständer in e3_2 ist in drei von vier Pfaden richtig und liefert dort den Täter-Schlüsselbeweis mit Namensbezug (Ahmet: Handschrift; Olli: Kalk wie in der Weste; Can: Leuchtfarbe wie auf der Maske). Die Anklage hängt nicht an R-UEBERFUEHRT. Fünf Entscheidungen sind in allen Pfaden richtig. Mehrheitsschablone: 8 / 8 / 9 / 6 Punkte je Pfad. Pfad Ahmet ohne Pfadwissen: 8 Punkte, Anklage Ahmet ist Meister-Detektiv. Pfad Olli: 9 Punkte.
- **Erwartet:** Die Mehrheitsschablone erreicht in keinem Pfad 7 Punkte. Der Schlüsselbeweis am Kerzenständer nennt den Namen nur zusammen mit einer pfadgebundenen Entscheidung.
- **Änderung:** In e3_2 den Kerzenständer nur im Pfad Ahmet richtig setzen. Für Olli und Can den Schlüsselbeweis an e2_3 (Weste) bzw. e2_1 (Cans Bauchtasche) koppeln. Simulator um Schablonentest ergänzen.
- **Gegenprobe:** hält (schwer). Der Befund hält: Die Zahlen stimmen, und die Mehrheitsschablone ist eine pfadunabhängige feste Folge derselben Klasse wie die Ratestrategien, für die E-025 #4 festhält, dass kein Pfad Meister erreicht; der Simulator prüft aber nur drei solche Strategien und bleibt deshalb grün. Die Widerlegungsgründe greifen nur teilweise: Die Schablone setzt Wissen aus mehreren Fall-Codes voraus, und FUER-DEN-NUTZER nennt dieses Lernen nur für Hinweise, nicht für Entscheidungen, also ist der Punkt nicht entschieden. Der Befund ist eher zu eng, weil drei feste Folgen in allen vier Pfaden 7 Punkte oder mehr erreichen, weshalb die Gegenmaßnahme eine Simulatorprüfung auf feste Folgen sein sollte und nicht nur die Änderung an e3_2; die Schwere schwer gilt für Gruppen, die den Fall mehrfach spielen, bei einem einzigen Abend ist die Lücke nicht erreichbar.
  - Nachgeprüft: Gelesen: content/party/schlosskeller/entscheidungen.json (alle Entscheidungen, Fakten, Begründungen), gegenstaende.json (Kerzenständer-Spuren mit entstehtWenn, Schablonen-Spuren Bund, Weste, Umschlag), fall.json (Endenmatrix, Regeln), ENTSCHEIDUNGSLOG E-024, E-025 (GEGEN #3, #4, FALL #1), NEBELKARTE Nr. 6, FUER-DEN-NUTZER Zeile 22, enden.dart, entscheidungen.dart (restmenge, R-UEBERFUEHRT). Ausgeführt: party_simulate (grün, 768 Folgen je Pfad, drei Ratestrategien 3-6 Punkte). Python-Auszählung im Scratchpad: Mehrheitsschablone = 8/8/9/6 bestätigt, alle 768 festen Folgen geprüft (46 mit 7+ in mindestens zwei Pfaden, 3 mit 7+ in allen vier Pfaden, z. B. e1 richtig, e2_1 Ascheneimer, e2_2 Tasche, e2_3 Olli, e3_1 Turmgang, e3_2 Kerzenständer, e3_3 Zeynep: 8/7/8/7). Dart-Lauf mit dem Paket: Schablone-Restmenge nach Runde 3 = {ahmet, can} (Ahmet), {can, fatma} (Fatma), {olli} (Olli), {can} (Can). git status vor den Läufen sauber, keine Datei im Repo geändert.

### Befund 2 · schwer
- **Ort:** Druckspiel VPXWW, Pfad ahmet: 11-fassungen.pdf S. 1 bis 4 (Fassung AC7, Du warst es, Streifen WA4/TV3/RW4 auf S. 3); 00-spielleitung.pdf S. 4, 6, 8 (Codetabellen mit WA4, TV3, RW4 als -1); 90-aufloesung-versiegelt.pdf (Klartext); 20-indizkarten.pdf (Rückseiten Ahmet – Schlüsselbeweis); bin/party_druck.dart verlangt --pfad; Log E-035, E-036 (a)
- **Befund:** Die -1-Streifen der Täter-Fassung stehen im selben Druck wie der Name und Du warst es. Wer die Dateien liest oder die Fassungen zusammenlegt, kennt den Täter. Die Auflösung liegt als Klartext vor, die Indizkarten zeigen Pfadfunde auf der Rückseite. E-036 (a) gilt für die Druckdateien nicht.
- **Erwartet:** Master 7.14: Wer druckt, sieht nur neutrale Codes. Kein Dokument des Satzes verbindet Fassungsname, Täterklartext oder Pfadfund mit einem Streifencode mit Wert.
- **Änderung:** Fassungen, Auflösung und Indizkarten-Rückseiten als getrennte, verschlüsselte oder aus dem Fall-Code abgeleitete Dateien erzeugen. -1-Werte nicht in derselben Tabelle wie die Fassungsnamen. party_druck ohne --pfad. Druckprüfung: kein Satzdokument mit Täterklartext und Streifencode mit Wert zugleich.
- **Gegenprobe:** widerlegt (kein Befund). Die Fundstellen stimmen: Die Fassung AC7 verbindet Ahmet mit den Streifencodes, die Codetabelle des Spielleitungsheftes gibt diesen Codes −1, und die Auflösung und die Indizkarten zeigen den Täter. Der Befund ist trotzdem widerlegt, weil genau dieser Lesepfad über die Druckdatei bereits bewusst als Restrisiko entschieden ist (G1-15: „Wer das PDF absichtlich durchliest, kann spoilern“; E-035 und E-036 mit Indizkarten-Restrisiko) und dem Nutzer in FUER-DEN-NUTZER.md genannt wird; neue Gründe nennt der Befund nicht. Zudem ist die Prämisse „party_druck verlangt --pfad“ falsch, und kein einzelnes Dokument des Satzes verbindet Name und Wert, also bleibt der eigene Erwartungswert erfüllt; ein Wunsch nach Dateitrennung wäre eine Gestaltungsentscheidung des Nutzers, kein Befund.
  - Nachgeprüft: Ich habe party_druck.dart gelesen (das Argument --pfad ist optional, es gibt auch --code und einen Zufallsfall) und mit `--pfad ahmet --n 7` einen eigenen Satz erzeugt (scratchpad/f6/gegenprobe/ahmet). Mit pdftotext habe ich alle acht PDFs geprüft. In 11-fassungen.pdf stehen Ahmet, „Du warst es“ und auf Seite 3 die Streifencodes FP9, EH7, HK4 ohne Wert. In 00-spielleitung.pdf gibt die Codetabelle genau diesen Codes −1 (Zeilen 108, 180, 257). Die Stimmkarten (12) enthalten keinen Wert, 20-indizkarten enthält Ahmets Schlüsselbeweis auf der Rückseite, und 90 ist Klartext. Im Entscheidungslog habe ich E-035, E-036 (inklusive Restrisiko) und G1-15 (Zeile 172) gelesen, ebenso FUER-DEN-NUTZER.md Zeilen 19 und 26. Die Streifencodes meines Laufs (FP9, EH7, HK4) weichen von denen im Befund (WA4, TV3, RW4) ab, vermutlich wegen des Personenzahl-Parameters; der Mechanismus ist derselbe.

### Befund 3 · schwer
- **Ort:** texte/wahlen-b2.json gw_leyla_2 (B); texte/wahlen-b3.json gw_zeynep_2 (B); texte/wahlen-kern.json gw_can_2 (B); Log E-029 (Keine Verwandtschaft als Deckungsgrund im Text), TON §7
- **Befund:** Drei Gruppenwahl-Texte begründen das Verschweigen von Nebendelikten mit Verwandtschaft (Cousin, Bruder, Schwester). E-029 hat die Loyalitätsgründe in figuren.json umgestellt, die Wahltexte aber nicht. Das Muster Familie deckt Geld- und Streich-Delikte ist zurück. TON §7 verbietet es.
- **Erwartet:** Deckung ohne Verwandtschaft, wie gw_ahmet_2 Option B (Lejla und ich halten zusammen).
- **Änderung:** gw_leyla_2 B: Ich habe Ahmet versprochen zu schweigen. gw_zeynep_2 B und gw_can_2 B auf Mitschuld und Versprechen umstellen. Verwandtschaft bleibt Fakt in wer.
- **Gegenprobe:** hält (schwer). Der Befund hält: Die B-Texte gw_leyla_2 („Ahmet ist mein Cousin, und ich halte ihn raus“) und gw_zeynep_2 („Can ist mein Bruder …“) nennen die Verwandtschaft ausdrücklich als Grund fürs Verschweigen, während die Varianten _1 und _3 derselben Wahl ohne sie auskommen. E-029 hat nur figuren.json umgestellt, und SENS-03 hat „Keine Verwandtschaft als Deckungsgrund im Text“ entschieden, also ist das eine nicht umgesetzte Entscheidung und kein begründeter Gegenpunkt (Punkt c greift nicht). Das Muster deckt Geld (Rechnung) und Streich, der B-Text ist laut Code die offene Karte am Tisch, und SENS-03 hat dieses Muster selbst als schwer geführt; TON §7 trifft es knapp, weil Verwandtschaft als Motiv für das Verschweigen einer Geldsache steht, auch wenn Loyalität als Motiv erlaubt ist. Abschwächen muss man nur gw_can_2, dessen B vor allem die Mitschuld am Schmiere-Stehen nennt; die Änderungsvorschläge sollten sich an figuren.json halten (Can hat dort kein Versprechen, und Lejlas Versprechen steht schon in gw_leyla_1 A und gw_leyla_3 A).
  - Nachgeprüft: Gelesen: texte/wahlen-b2.json (gw_leyla_1 bis _3), wahlen-b3.json (gw_zeynep_1 bis _3), wahlen-kern.json (gw_can_1 bis _3, gw_ahmet_2); figuren.json, Loyalitätsfelder aller 20 Figuren; ENTSCHEIDUNGSLOG E-007, E-029 (KONT-01, Abschnitt Familie als Deckung, SENS-03 mit "Keine Verwandtschaft als Deckungsgrund im Text"), E-037, E-038; TON-LEITFADEN §5, §6, §7, §10; MASTER-PROMPT 7.15; texte/SCHLUESSEL.md Z. 62 (wer darf Verwandtschaft nennen); packages/mordakte_core/lib/src/party/druck/modell.dart Z. 285-292 (gw_<rolle>_<r> als Stimmkarte, B als offene Karte). Per grep über texte/, figuren.json und Dossiers nach Schwester, Bruder, Cousin, Verwandt und Familie gesucht: Die Verwandtschaft als Deckungsgrund steht nur in den drei B-Texten des Befunds. Nicht ausgeführt: dart-Werkzeuge und E2E-Fotos, weil der Befund auf Textstellen beruht. Keine Schreibvorgänge, keine Git-Befehle.

### Befund 4 · mittel
- **Ort:** texte/erzaehler-aufloesung.json (aufloesung.ahmet.taeter, .fatma.taeter, .olli.taeter, .can.taeter); texte/taeter-*.json (tatwissen: schlägst einmal zu); TON §1
- **Befund:** Das öffentliche Geständnis nennt Waffe und Schlagverb (einmal zugeschlagen) in allen vier Fällen. TON §1 verlangt, dass der Schlag nur angedeutet wird. Die Rückblenden halten die Vorgabe.
- **Erwartet:** Geständnis ohne Waffe und Schlagverb.
- **Änderung:** Z. B.: Ahmet gesteht: In Panik ist etwas passiert. Herr Schneider hat nur eine Beule. Vier Auflösungstexte umformulieren.
- **Gegenprobe:** hält (mittel). Der Befund hält. Alle vier Geständnisse in erzaehler-aufloesung.json nennen Kerzenständer und „einmal zugeschlagen“, die App liest diese Texte in der Auflösungsphase allen vor, und das Entscheidungslog trifft zum Schlagverb im Geständnis keine Entscheidung. Die öffentlichen Finaltexte halten dagegen den Schlag nur als „ein dumpfer Schlag, Poltern“ und das Geständnis als „Die Tat war Panik im Dunkeln“, weshalb die Auflösung von der Linie des TON §1 abweicht. Die Waffe allein trägt den Befund nicht, denn der Kerzenständer steht bereits in den öffentlichen Finaltexten; neu ist das Schlagverb, und die privaten Täter-Rückblenden sind davon nicht betroffen.
  - Nachgeprüft: git status (ohne Ausgabe, Arbeitsbaum sauber). content/party/schlosskeller/texte/erzaehler-aufloesung.json: alle vier .taeter-Einträge (aufloesung.ahmet/fatma/olli/can.taeter) nennen „Kerzenständer“ und „einmal zugeschlagen“, Befund bestätigt. taeter-ahmet/fatma/olli/can.json: Täter-Rückblende mit „schlägst einmal zu“ und „dumpfer Schlag“, privat. erzaehler-finale-*.json: öffentliche Finaltexte und rueckblende.* verwenden nur „ein dumpfer Schlag, Poltern“ ohne Schlagverb; Geständnis dort „Die Tat war Panik im Dunkeln“; der Kerzenständer steht dort bereits („Der Kerzenständer verrät ihn“). packages/mordakte_core/lib/src/party/erzaehler.dart Z. 118–121 und 155–157: Auflösungstexte werden in der Phase aufloesung allen vorgelesen. TON-LEITFADEN §1 und §6, MASTER-PROMPT Nordstern und 7.15 gelesen. ENTSCHEIDUNGSLOG: Suche nach Auflösung, Geständnis, Schlag, Kerzenständer, Waffe; E-029 (Auflösung KONT-03, SENS-02) und E-035 gelesen; keine Entscheidung zum Schlagverb im Geständnis. dart run bin/party_texte.dart: „Texte: OK (1582 Texte)“, Textprüfer erfasst die Regel nicht.

### Befund 5 · mittel
- **Ort:** figuren.json figuren.1 (Fatma, kopftuch) und figuren.5 (Emine, kopftuch); gegenstaende.json muenzschatulle; aufloesung.emine; Log E-014 (03b Nr. 12), E-029 (b), E-037
- **Befund:** Die einzige Mitnahme im Fall (Schatulle) begeht eine Kopftuchträgerin (Fatma). Ihre Mitwisserin Emine ist ebenfalls Kopftuchträgerin. E-029 (b) hat nur Azra entkoppelt, Emine bleibt im Strang, das Log bewertet sie nicht.
- **Erwartet:** TON §7: Kopftuch nie Teil eines Delikts oder einer Verheimlichung.
- **Änderung:** Emine ohne Kopftuch (figuren.json look.kopf auf none, Prompt emine anpassen). Fatmas Kopftuch bleibt laut E-007.
- **Gegenprobe:** widerlegt (leicht). Die Fundstellen stimmen: Emine traegt laut figuren.json ein beiges Kopftuch, steht im Schatulle-Strang, und E-029 hat nur Azras Kopftuch entkoppelt. Der Befund zitiert TON §7 aber falsch, denn die Regel verbietet Kopftuch als Teil einer Luege oder eines Delikts, nicht als Teil einer Verheimlichung; Emine hat weder Luege (luegen leer, Gespraeche zeigen Schweigen) noch Nebendelikt. Das Log hat die Frage zudem gesehen: E-029 nennt Emine im Kopftuch-Denkprotokoll ausdruecklich, und E-014 Zeile 151 fuehrt sie mit Kopftuch als Gegengewicht (Lehrerin) an. Bleibt ein Feinschliff-Punkt: Die Regel „außerhalb aller Delikt-Stränge“ ist nicht konsequent auf Emine angewendet, und zwei von drei Figuren des Schatulle-Strangs tragen Kopftuch; das ist eine Abwaegung fuer den Nutzer unter FÜR DEN NUTZER, kein Regelverstoß.
  - Nachgeprüft: Fundstellen selbst gelesen: figuren.json (Fatma, Emine, Azra, Tugba; Kopf, Nebendelikt, luegen und alle 20 Figuren tabelliert), gegenstaende.json (muenzschatulle, Lage bei Fatma), texte/erzaehler-aufloesung.json (aufloesung.emine), texte/dossiers-b2.json (Emines Dossier, verbirgt nur Schweigen), texte/gespraeche-r1-b2, r2-b2 und r3-b2 (alle Emine-Gespraeche, keine Luege erkennbar). Regeln: TON-LEITFADEN §6, §7 und §10 sowie MASTER-PROMPT 7.15. Log: E-007, E-014 (Zeile 151, Klischee-Kopplung), E-019 (B-15), E-029 (Kopftuch-Denkprotokoll Zeilen 710 bis 717, Mitnahme-Muster), E-037 und E-038. git status ausgefuehrt, keine Dart-Befehle, keine Dateien geschrieben.

### Befund 6 · mittel
- **Ort:** texte/erzaehler-finale-ahmet.json, -fatma.json, -olli.json, -can.json (ende_meister, ende_teilerfolg); Log E-029 (Ausgang Option b); Master 7.9
- **Befund:** Alle acht Enden mit richtiger Anklage öffnen das Tor in der Nacht (noch in der Nacht). Master 7.9 verlangt, dass jedes Ende am Morgen hinauskommt. E-029 entscheidet die Nachtregel ohne Bezug zu 7.9.
- **Erwartet:** Morgen-Formulierung oder ein Logeintrag, der 7.9 ausdrücklich ändert.
- **Änderung:** Am Morgen schließt Herr Schneider das Außentor auf. Die Herausgabe des Bundes kann nachts bleiben.
- **Gegenprobe:** hält (mittel). Der Befund hält, weil die Fundstellen den Widerspruch belegen: Master 7.9 verlangt den Ausgang am Morgen, die acht Enden mit richtiger Anklage öffnen das Tor in der Nacht. E-029 entscheidet die Nachtregel, nennt 7.9 aber nicht, und keine andere Logstelle ändert 7.9 ausdrücklich; die Begründung des Log (Bund als Schlüssel) klärt deshalb nicht, warum 7.9 nicht gilt. Die Schwere bleibt mittel, weil es ein Widerspruch zwischen Master, Log und Kanon (z_festgesetzt "sitzt bis zum Morgen fest") ist und keine Inhaltsregel verletzt wird; der Befund ist zudem nicht neu, sondern in F3-KONT-05, F3-AUTOR-83 und F3-SENS-02 bereits als offene Entscheidung gemeldet. Die vorgeschlagene Änderung ist tragfähig und löst auch z_festgesetzt, muss aber sagen, dass dann Herr Schneider mit dem Bund um 07:00 öffnet, während bei falscher Anklage die Kollegin mit dem Ersatzschlüssel öffnet, und dass acht Texte und die Ausgangsregel in SCHLUESSEL.md angepasst werden.
  - Nachgeprüft: Gelesen: texte/erzaehler-finale-ahmet.json, -fatma.json, -olli.json, -can.json (alle 16 Finaltexte und die vier Rückblenden). Alle acht Enden mit richtiger Anklage (ende_meister, ende_teilerfolg) sagen "noch in der Nacht" zur Öffnung des Außentors; alle acht Enden mit falscher Anklage (ende_justizirrtum, ende_eskalation) sagen "bis zum Morgen", Öffnung um 07:00 durch die Kollegin. Master MASTER-PROMPT.md 7.9 (Z. 263-267): "Jedes Ende erzählt, wie die Gruppe am Morgen hinauskommt." ENTSCHEIDUNGSLOG.md E-029 (Z. 672-681) gelesen: Option (b) mit Umkehrprobe, ohne Bezug zu 7.9. Volltextsuche im Log nach 7.9, Morgen, Tor: keine Stelle nennt 7.9; E-028 (Z. 641) hält nur fest, dass der Bund oder die Kollegin um 07:00 öffnet, als offene Autorenfrage; E-037 und E-007 ohne Bezug. SCHLUESSEL.md Z. 52-57 gelesen (Ausgangsregel). Kanon: zeitleiste.json z_festgesetzt (00:03) "Die Gruppe sitzt bis zum Morgen fest", z_morgen (07:00, Kollegin mit Ersatzschlüssel); fall.json morgenUhrzeit 07:00. Berichte berichte/F3-KONT-05.md (Offene Frage 1), F3-AUTOR-83.md (Offene Frage 1) und F3-SENS-02.md (Offene Frage 1) gelesen: der Widerspruch Morgen-Kanon gegen E-029 wurde dort schon gemeldet und als "Entscheidung nötig" offen gelassen; im Log findet sich dazu keine Entscheidung. git status: keine Änderungen. Nicht ausgeführt: dart-Werkzeuge, E2E-Fotos, Ton-Leitfaden §5/6/10 (für diese enge Prüfung nicht nötig).

### Befund 7 · mittel
- **Ort:** 00-spielleitung.pdf S. 4 (Karte wählen, Streifen der Karte); 11-fassungen.pdf S. 2 (B: Fassungs-Streifen, Karte B behalten); 12-stimmkarten.pdf (Ahmet R1 B = XL4, Wert 0); Log E-036
- **Befund:** Die Spielleitungsanleitung zieht den Streifen der gewählten Karte. Die Fassung verlangt den Fassungs-Streifen und behält Karte B. Die Tabelle enthält beide Quellen. Die Summe kann je nach Befolgung falsch sein.
- **Erwartet:** Genau eine B-Quelle je Rolle, in allen Anleitungen gleich.
- **Änderung:** Offene B-Karten der Kernrollen aus 12-stimmkarten entfernen oder die Spielleitungsanleitung auf den Fassungs-Streifen umstellen.
- **Gegenprobe:** hält (mittel). Der Befund hält stand, er ist nicht widerlegt: Spielleitung S. 4 (Gruppenwahl) und der Aufdruck auf jeder B-Karte verlangen, den Streifen der gewählten Karte abzureißen und in die Schüssel zu legen, während die versiegelte Fassung für B den Fassungs-Streifen verlangt und "Den Streifen deiner Karte B behältst du" schreibt. Im Pfad Ahmet (Täter) mit B in Runde 1 ergibt die Fassung FP9 (-1), die Karte XL4 (0); bei A der anderen fünf und B von Tim ergibt das Summe 4 (UX3) statt 5 (JC7). E-036 entscheidet die Fassungsregel, bedenkt aber den Spielleitungs- und Kartentext nicht, also liegt keine Begründung im Log vor. Vorschlag 1 (Kern-B-Karten entfernen) widerspricht E-036 und der Fassung. Passend ist, Spielleitung und B-Karten der vier Kernrollen auf den Fassungs-Streifen umzustellen, weil Lejla, Emine und Tim keine Fassung haben und ihr Kartenstreifen bleibt.
  - Nachgeprüft: Frischer Druck mit party_druck (Pfad ahmet, n=7) nach g03/ahmet7 erzeugt. Gelesen per pdftotext und als Bild (pdftoppm, 60 dpi): 00-spielleitung.pdf S. 4 (Gruppenwahl-Text und Codetabelle Runde 1), 11-fassungen.pdf S. 2 und S. 3 (Ahmet: Rundenwahl, Streifen Runde 1 = FP9), 12-stimmkarten.pdf S. 1 (Ahmet, Fatma, Olli, Can, Runde 1, A und B mit Aufdruck "Abreißen, falten und in die Schüssel legen"). Die Rundenwahl-Passage ist in allen vier Fassungen gleich (pdftotext). Tabelle Runde 1 enthält 7 A-Codes (+1), 7 B-Codes (0) und vier Fassungs-Streifen (FC9, FP9 = -1, KN9, NW9). Entscheidungslog gelesen: E-035 (Streifen-Regel, Gruppenwahl eindeutig), E-036 vollständig, E-037/E-038 auf Konflikte mit Streifen durchsucht (keine Treffer). Nur lesen; Schreiben nur in gegenprobe/g03. git nur als git status (sauber).

### Befund 8 · mittel
- **Ort:** TON-LEITFADEN §7 und §10 Nr. 5 (verweisen auf Herkunftsmatrix in figuren.json, dort nicht vorhanden); planung/finalisierung-schlosskeller/berichte/F1-SENS-01.md (Stand F1, Kopftuch veraltet); Log E-014 (03b Nr. 12), E-029 (SENS-03)
- **Befund:** Die Herkunftsmatrix fehlt in figuren.json und ist im F1-Bericht veraltet (Kopftuch kurdisch 2 und türkisch 1; heute kurdisch 1 und türkisch 2). Nachrechnung: Nebendelikte bosnisch 1, kurdisch 1, deutsch 2, türkisch 2, polnisch 2. Verborgenes je Herkunft: bosnisch 4 von 5, kurdisch 3 von 3, deutsch 2 von 2, türkisch 3 von 6, polnisch 4 von 4. Die zwei Vermögensdelikte liegen bei einer bosnischen und einer kurdischen Figur. Keine Gruppe trägt allein.
- **Erwartet:** Maschinenlesbare, aktuelle Matrix mit Test, die TON §10 Nr. 5 prüfbar macht.
- **Änderung:** content/party/schlosskeller/herkunftsmatrix.json (Figur, Herkunft, Nebendelikt, Lüge, Verschweigen, Kopfbedeckung) mit Test; Sensibilitätsbericht erneuern.
- **Gegenprobe:** hält (mittel). Der Kern hält: figuren.json hat keine Matrix, TON §7 verweist aber genau dort darauf, und ein Test prüft die Verteilung nicht; F3-SENS-02 OFFENE FRAGE 5 notiert die fehlende Matrix nur, das Log trifft dazu keine Entscheidung. Die Zahlen des Befunds stimmen, und die Aussage „keine Gruppe trägt allein“ bleibt wahr. Widerlegt sind dagegen die Teile zu F1-SENS-01 und zum Kopftuch: Der F1-Bericht ist ein eingefrorener Freigabe-Stand, den F3-SENS-02 ersetzt, und die Kopftuch-Änderung ist in E-029 begründet entschieden, also kein Fehler im Spiel. Schwere mittel wegen des Widerspruchs zwischen TON-Leitfaden und Kanon, ohne Auswirkung auf Spieler.
  - Nachgeprüft: Gelesen: figuren.json (alle Figuren mit Feldern herkunft, nebendelikt, luegen, look.kopf), TON-LEITFADEN §7 Z. 62 und §10 Nr. 5 (Z. 88), F1-SENS-01 (Herkunftsmatrix-Tabelle), F3-SENS-02 Z. 41 (OFFENE FRAGE 5), FUER-DEN-NUTZER Z. 30-31 und 44-45, ENTSCHEIDUNGSLOG E-007, E-014 (Z. 158ff., Nr. 12, B12), E-029 (SENS-03 Gewählt (c), Prüfstapel A Kopftuch mit Tugba). Gesucht: "matrix" in figuren.json (kein Matrix-Schlüssel, nur die Tatmatrix-Verweise im hinweis-Feld), "Herkunftsmatrix" in planung und Log (nur F1-Bericht, F3-SENS-02, Plan; keine Entscheidung im Log), Herkunfts-Verteilungstests in packages/mordakte_core/test (nur bildprompt_test mit Wortliste). Nachgerechnet mit python: Nebendelikte bosnisch 1, kurdisch 1, deutsch 2, türkisch 2, polnisch 2 (8 gesamt). Verborgenes über die verbirgt-Listen der Dossiers b1 bis b5 (Lügen, Nebendelikte, verborgene Beobachtungen, Schweigeversprechen; „Du verbirgst nichts“ zählt nicht): bosnisch 4 von 5 (Ahmet, Lejla, Azra, Damir), kurdisch 3 von 3, deutsch 2 von 2, türkisch 3 von 6 (Can, Emine, Zeynep), polnisch 4 von 4. Die Befund-Zahlen sind damit reproduzierbar, auch wenn der Befund „Verborgenes“ nicht definiert. Vermögensdelikte bei Ahmet (Mietgeld) und Fatma (Schatulle), Kopftuch heute bei Fatma (kurdisch) und Emine und Tugba (türkisch).

### Befund 9 · mittel
- **Ort:** texte/dossiers-b4.json (Azra, verbirgt: Du hast Fatma von der Schatulle erzählt); texte/erzaehler-aufloesung.json (aufloesung.dilara); Master 7.6 Schritt 8
- **Befund:** Die Auflösung nennt den verborgenen Tipp an Fatma nicht als Tatsache. Sie spricht nur von Olli und einem Anstiftungsverdacht. Die Rolle, die den Tipp gegeben hat, wird so nicht aufgelöst.
- **Erwartet:** Die Auflösung nennt den Tipp.
- **Änderung:** aufloesung.dilara um Sie hat Fatma von der Schatulle erzählt ergänzen.
- **Gegenprobe:** hält (mittel). Der Befund hält. Die Fundstelle ist belegt: dossiers-b4.json führt den Tipp unter verbirgt, aufloesung.dilara spricht nur von Olli und einem Anstiftungsverdacht, und kein Finaltext, keine Rückblende und keine Auflösung nennt den Tipp als Tatsache; die Gruppenwahl deckt ihn nur bei Option a auf. Das Entscheidungslog widerlegt den Punkt nicht: E-029 hat das Streichen des Tipps verworfen, AUTOR-47 setzt voraus, dass Finale und Rückblende das Genaue erzählen, was hier nicht geschieht, und die Frage F3-KONT-03 Nr. 8 ist nicht beantwortet. Der Vorschlag passt zu Master 7.6 Schritt 8 (jede Rolle erfährt, was die anderen verborgen haben) und ist pfadneutral, weil das Schatullen-Nebendelikt in allen Pfaden gilt; der Satz sollte vor dem Anstiftungssatz stehen, damit er als Tatsache gelesen wird.
  - Nachgeprüft: Gelesen: texte/erzaehler-aufloesung.json (aufloesung.dilara, aufloesung.emine, aufloesung.fatma.*), texte/dossiers-b4.json (dilara, verbirgt: "Du hast Fatma von der Schatulle in der Schauvitrine erzählt."), texte/wahlen-b4.json (gw_dilara_1: Option a deckt den Tipp auf, Option b schweigt), texte/erzaehler-finale-*.json und rueckblende.fatma (kein Hinweis auf Azra oder den Tipp), ENTSCHEIDUNGSLOG.md (E-029 Azra-Tipp, AUTOR-47 zur pfadneutralen Nebenrollen-Auflösung, F3-KONT-03 Nr. 8), MASTER-PROMPT.md 7.6 Schritt 8, berichte/F3-KONT-03.md (Frage 8 offen). Code: lib/src/party/erzaehler.dart Zeile 118-121 (aufloesung.<rolle> wird allen Spielern am Ende gezeigt). Repo-Suche nach Schatulle: keine Entscheidung und kein Finaltext nennt, wer Fatma von der Schatulle erzählt hat. Keine Dateien geändert, nur git status und Lesezugriffe.

### Befund 10 · leicht
- **Ort:** bildprompts.json, Eintrag emine (silver thermos bottle, lid of the thermos bottle); im selben Prompt no bottles; Log E-029 (thermos statt flask)
- **Befund:** Der Prompt verlangt eine Flasche und verbietet Flaschen im selben Satz.
- **Erwartet:** Keine Flaschen-Nennung im Prompt.
- **Änderung:** silver thermos jug (Thermoskanne).

### Befund 11 · leicht
- **Ort:** texte/erzaehler-intro.json (intro.lacher.lacher_verlaufen.besetzt, intro.lacher.lacher_ruestung.besetzt); texte/dossiers-b5.json (Sibel); TON §8 (feste Lacher), TON §10
- **Befund:** Zwei Gäste werden im Intro vorgeführt: Olli (Kernverdächtiger) über das Verlaufen, Sibel über ihre Schreckhaftigkeit. Die Lacher sind nach TON §8 vorgegeben, das Risiko des Vorführens ist aber zu melden.
- **Erwartet:** Die Spielleitung kann vorher fragen; Lacher gehen auf Raum und Licht, nicht auf die Person.
- **Änderung:** Hinweis im Einrichtungsbildschirm. Eine Textänderung ist nicht zwingend.

### Befund 12 · leicht
- **Ort:** figuren.json, leyla roleTitle (Die Buffet-Chefin); berichte/F1-SENS-01.md (Lejla: Essen als Etikett B8); Log E-021 (SENS-01 B5 bis B14 behandelt Loyalität, nicht dieses Etikett)
- **Befund:** Die F1-Markierung Essen als Etikett ist nicht ausdrücklich erledigt. Das Etikett trifft die bosnische Cousine, die zugleich Ahmets Deckung ist (Befund 3).
- **Erwartet:** Etikett aus der Funktion ohne Essensbezug.
- **Änderung:** roleTitle für Lejla auf Die Apothekerin oder einen anderen Berufsbegriff ohne Essen ändern.

## Abnahme (Orchestrator)
- FREIGEGEBEN · 9/10
- Funktion 2 · Kanon-Treue 2 · Verzahnung 2 · Inhalt 2 · Grenzen 1 (git log gelesen)
- Entscheidungen zu jedem Befund: ENTSCHEIDUNGSLOG E-039.

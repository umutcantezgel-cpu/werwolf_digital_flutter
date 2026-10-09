F3-AUTOR-43 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die vier Finaltexte und die Rückblende für den Pfad, in dem Ahmet zugeschlagen hat.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
{
 "taeter": {
  "name": "Ahmet",
  "motiveAndConflict": "Ahmet hat den Keller umsonst bekommen. Dafür gestaltet er das Programm des Adventsmarkts. Beim Essen hat er viel zu groß bestellt. Statt das zuzugeben, hat er von allen 150 € „Miete“ eingesammelt. Um 23:51 sagt Herr Schneider an der Theke: „Um zwölf sag ich allen, was der Keller gekostet hat.“",
  "killerProfile": {
   "crimeExecution": "Er kauert erst am Ostende der Theke neben Damir. Dann geht er zum Kerzenlicht an der Anrichte, um Herrn Schneider zu bitten. Herr Schneider, noch außer sich wegen Can, packt ihn am Arm und zischt: „Um zwölf erfahren's alle.“ In Panik greift Ahmet mit der Hand, in der er den Umschlag hält, den Kerzenständer und schlägt einmal zu. Heißes Wachs tropft auf den Umschlag, eine Ecke reißt ab und bleibt am Griff kleben. In Panik reißt er den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt er, dass Flucht alles schlimmer macht. Er steckt den Bund im Ost-Saal in seine eigene Jacke und kauert sich wieder neben Damir.",
   "smokingGun": "Im Wachs am Griff des Kerzenständers klebt eine abgerissene Ecke seines Mietumschlags.",
   "zusatzindiz": "Rote Wachstropfen auf dem leeren Umschlag im Ascheneimer am Kamin; eine Ecke fehlt."
  },
  "nebendelikt": {
   "id": "nd_mietgeld",
   "text": "Hat von allen 150 € Miete kassiert, obwohl der Keller nichts gekostet hat."
  },
  "loyalitaet": {
   "zu": "leyla",
   "grund": "Sie sind zusammen aufgewachsen und halten zusammen."
  }
 },
 "ereignisseImPfad": [
  {
   "id": "ev_can_gepackt",
   "t": "23:58:13",
   "ort": "vor_vorratstuer",
   "art": "handlung",
   "person": "schneider",
   "ziel": "can",
   "text": "Herr Schneider packt Can an der Kapuze."
  },
  {
   "id": "ev_can_losgerissen",
   "t": "23:58:28",
   "ort": "vor_vorratstuer",
   "art": "handlung",
   "person": "can",
   "text": "Can reißt sich los und rennt mit der leuchtenden Maske in der Hand davon."
  },
  {
   "id": "ev_ahmet_gepackt",
   "t": "23:58:36",
   "ort": "vor_vorratstuer",
   "art": "handlung",
   "person": "schneider",
   "ziel": "ahmet",
   "text": "Herr Schneider packt Ahmet am Arm."
  },
  {
   "id": "ev_ahmet_schlag",
   "t": "23:58:39",
   "ort": "vor_vorratstuer",
   "art": "handlung",
   "person": "ahmet",
   "text": "In Panik greift Ahmet mit der Hand, in der er den Umschlag hält, den Kerzenständer von der Anrichte und schlägt einmal zu. Heißes Wachs tropft auf den Umschlag, eine Ecke reißt ab und bleibt am Griff kleben."
  },
  {
   "id": "ev_ahmet_drohung",
   "t": "23:58:36",
   "ort": "vor_vorratstuer",
   "art": "geraeusch",
   "lautstaerke": "leise",
   "person": "schneider",
   "text": "Herr Schneider zischt: „Um zwölf erfahren's alle.“"
  }
 ],
 "ereignisseAllePfade": [],
 "bundVersteck": {
  "einrichtung": "jackenstaender",
  "ort": "am_jackenstaender",
  "stelle": "in der Innentasche von Ahmets Jacke"
 },
 "enden": [
  {
   "id": "ende_meister",
   "name": "Meister-Detektiv",
   "anklage": "richtig",
   "punkteVon": 7,
   "punkteBis": 9
  },
  {
   "id": "ende_teilerfolg",
   "name": "Teilerfolg",
   "anklage": "richtig",
   "punkteVon": 0,
   "punkteBis": 6
  },
  {
   "id": "ende_justizirrtum",
   "name": "Justizirrtum",
   "anklage": "falsch",
   "punkteVon": 4,
   "punkteBis": 9
  },
  {
   "id": "ende_eskalation",
   "name": "Totale Eskalation",
   "anklage": "falsch",
   "punkteVon": 0,
   "punkteBis": 3
  }
 ],
 "morgen": [
  {
   "zeit": "00:00",
   "text": "Tim schaltet die Hauptsicherung wieder ein."
  },
  {
   "zeit": "00:00:20",
   "text": "Damir findet Herrn Schneider im Vorratsraum."
  },
  {
   "zeit": "00:01:30",
   "text": "Herr Schneider kommt zu sich: Beule, Gedächtnislücke. „Mein Schlüsselbund! Der ist weg!“"
  },
  {
   "zeit": "00:03",
   "text": "Das Außentor ist zu, der Bund ist weg, hinter den Mauern gibt es keinen Empfang. Die Gruppe sitzt bis zum Morgen fest."
  },
  {
   "zeit": "00:05",
   "text": "Tugba gibt die Handys aus dem Korb zurück. Empfang hat keines."
  },
  {
   "zeit": "00:12",
   "text": "Ahmet leert den Umschlag mit dem Mietgeld und wirft ihn in den Ascheneimer am Kamin. Hana sieht es."
  },
  {
   "zeit": "00:20",
   "text": "Herr Schneider bittet das Geburtstagskind: „Finde raus, wer das war. Bis zum Morgen.“"
  },
  {
   "zeit": "00:30",
   "text": "Runde 1: Das Alibi-Geflecht."
  },
  {
   "zeit": "01:15",
   "text": "Runde 2: Die Indizien-Filterung."
  },
  {
   "zeit": "02:00",
   "text": "Runde 3: Die finale Gegenüberstellung."
  },
  {
   "zeit": "02:45",
   "text": "Finale: die Anklage."
  },
  {
   "zeit": "07:00",
   "text": "Herrn Schneiders Kollegin kommt mit dem Ersatzschlüssel und schließt das Außentor auf."
  }
 ],
 "opfer": {
  "name": "Herr Schneider",
  "gedaechtnisLueckeAb": "23:58:14"
 },
 "empfang": "Hinter den dicken Mauern gibt es keinen Handyempfang. Empfang gibt es erst draußen auf den Stufen zum Parkplatz."
}

SCHNITTSTELLEN:
Datei content/party/schlosskeller/texte/erzaehler-finale-ahmet.json, Feld eintraege: genau 5 Objekte {"id","text"}:
- finale.ahmet.ende_meister (richtige Anklage, 7–9 Punkte), finale.ahmet.ende_teilerfolg (richtige Anklage, 0–6 Punkte, mit Glück), finale.ahmet.ende_justizirrtum (falsche Anklage, 4–9 Punkte), finale.ahmet.ende_eskalation (falsche Anklage, 0–3 Punkte): je 6–10 Sätze Vorlesetext. Die Enden unterscheiden sich in Gerechtigkeit, Freundschaft und Stimmung. Jedes erzählt, wie die Gruppe am Morgen hinauskommt (Bund gefunden oder Hilfe von außen am Morgen; nur Fakten aus dem Auszug). PFLICHTSATZ in jedem Finaltext: Herr Schneider überlebt; er wacht auf, hat eine Beule und eine Gedächtnislücke, und es geht ihm bald wieder gut. Bei den zwei falschen Enden NENNT DER TEXT DIE ANGEKLAGTE PERSON NICHT (sie kann jede der drei Unschuldigen sein: „die falsche Person“, „wer zu Unrecht beschuldigt wurde“); Ahmet gesteht oder wird später entdeckt. Bei den richtigen Enden gesteht Ahmet, die Tat war Panik im Dunkeln.
- rueckblende.ahmet: 6–9 Sätze. Die zwei Minuten des Stromausfalls im Zeitraffer, aus ereignisseAllePfade und ereignisseImPfad in zeitlicher Reihenfolge: Knall, Dunkelheit, das leuchtende Gesicht, der Zusammenstoß, die Tat in Panik (nur angedeutet: „ein dumpfer Schlag, Poltern, Metall scheppert über den Steinboden“), der Bund, das Versteck, Licht. Kein Blut, keine Wunde.
Vorlesetexte: Uhrzeiten in Worten, keine Ziffern, keine Klammern.

EIGENE DATEIEN: content/party/schlosskeller/texte/erzaehler-finale-ahmet.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN, SCHLUESSEL.md und den Auszug.
2. Schreibe die 5 Einträge.
3. Prüfe mit python3 -m json.tool und dart test test/party/texte_test.dart.

ABNAHMEKRITERIEN UND TESTWEG: Genau 5 Einträge; Pflichtsatz in allen vier Finaltexten; falsche Enden ohne Namen der angeklagten Person; texte_test grün.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-43
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Pflichtsatz je Ende: <Zitat>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-43 · BEREIT ZUR RÜCKGABE ===

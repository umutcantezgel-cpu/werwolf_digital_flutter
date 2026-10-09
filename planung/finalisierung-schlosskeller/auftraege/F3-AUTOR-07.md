F3-AUTOR-07 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Täterfassung für Fatma: Tarngeschichte, Tatwissen, was zu verbergen ist, und das Ziel für den Abend.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
{
 "figur": {
  "figur": {
   "id": "fatma",
   "name": "Fatma",
   "roleTitle": "Die Designstudentin",
   "geschlecht": "w",
   "herkunft": "kurdisch",
   "besetzungsplatz": 2,
   "alltag": "Studiert Kommunikationsdesign im letzten Semester.",
   "persoenlichesZiel": "Die Schatulle soll zurück, ohne dass es alle erfahren.",
   "loyalitaet": {
    "zu": "emine",
    "grund": "Emine ist seit der Schulzeit ihre beste Freundin."
   },
   "motiveAndConflict": "Fatma schreibt ihre Abschlussarbeit über alte Münzbilder. Azra hat ihr von der Münzschatulle in der Turmvitrine erzählt. Um 23:40 hebt sie die gesprungene Scheibe an und nimmt die Schatulle mit. Sie will die Reliefs zu Hause abzeichnen und die Schatulle am Montag zurückbringen. Um 23:56 sieht Herr Schneider Glassplitter an ihrem Mantel: „Die Schatulle. Um Punkt zwölf geh ich raus und ruf die Polizei.“",
   "roleSecret": "Nachdem Herr Schneider sie um 23:56 erwischt hat, will sie ihm die Schatulle sofort zurückgeben. Um 23:57 geht sie mit der Tasche zur Theken-Klappe.",
   "luegen": [
    {
     "id": "luege_fatma_buffet",
     "behauptung": "Ich stand die ganze Zeit beim Gebäck am linken Buffet.",
     "wahrheit": "Um 23:57 war sie mit der Tasche an der Theken-Klappe."
    },
    {
     "id": "luege_fatma_tasche",
     "behauptung": "In meiner Tasche sind nur Bücher.",
     "wahrheit": "In der Tasche liegt die Münzschatulle aus der Vitrine."
    }
   ],
   "nebendelikt": {
    "id": "nd_schatulle",
    "text": "Hat die Münzschatulle aus der Turmvitrine mitgenommen."
   },
   "visualSpecs": {
    "silhouette": "Schlanke Statur, dunkles Kopftuch, knielanger Wollmantel",
    "outfit": "Weinroter Wollmantel, dunkler Rollkragen, schwarze Stoffhose, dunkles Kopftuch",
    "distinguishingFeature": "Schwere Umhängetasche aus Leder, breiter Silberring an der rechten Hand",
    "idleAnimation": "Nestelt am Reißverschluss ihrer Tasche und lächelt Emine zu"
   },
   "startRoom": "thekensaal",
   "innocentProfile": {
    "actualBehavior": "Beim Knall zieht sie sich mit der Tasche zum linken Buffettisch zurück und kauert dort gleich danach neben Emine."
   },
   "killerProfile": {
    "crimeExecution": "Beim Knall bleibt sie erschrocken vor der Theke stehen. Dann sieht sie das Kerzenlicht an der Anrichte und geht durch die Klappe hin, um die Schatulle sofort zurückzugeben. Herr Schneider packt den Gurt ihrer Tasche und zischt: „Zu spät. Die Polizei kommt so oder so.“ In Panik greift sie den Kerzenständer und schlägt einmal zu. In Panik reißt sie den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt sie, dass Flucht alles schlimmer macht. Sie steckt ihn in die Brottasche auf dem linken Buffettisch und kauert sich zu Emine.",
    "smokingGun": "Frischer Messingabrieb an ihrem breiten Silberring, passend zum Kerzenständer.",
    "zusatzindiz": "Rote Wachstropfen auf der Münzschatulle in ihrer Tasche."
   },
   "blackoutAlibi": "Behauptet, die ganze Zeit beim Gebäck am linken Buffettisch gestanden zu haben."
  },
  "eigeneBeobachtungen": [],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_vitrine_schatulle",
    "zeit": "23:40",
    "text": "Fatma hebt die gesprungene Scheibe der Vitrine an und nimmt die Münzschatulle mit. Emine sieht es.",
    "pfade": "alle"
   },
   {
    "id": "z_tasche_ausgebeult",
    "zeit": "23:45",
    "text": "Azra sieht, dass Fatmas Tasche auffällig ausgebeult ist.",
    "pfade": "alle"
   },
   {
    "id": "z_schatulle_entdeckt",
    "zeit": "23:56",
    "text": "Herr Schneider sieht Glassplitter an Fatmas Mantel: „Die Schatulle. Um Punkt zwölf geh ich raus und ruf die Polizei.“",
    "pfade": "alle"
   },
   {
    "id": "z_theke_2357",
    "zeit": "23:57",
    "text": "Fatma geht mit der Tasche zur Theken-Klappe, Olli holt am Eiskübel Eis, Ahmet schlüpft mit dem Umschlag hinter die Theke. Herr Schneider raunzt Olli an: „Zweitausend, bis zwölf.“",
    "pfade": "alle"
   }
  ]
 },
 "tatEreignisse": [
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
   "id": "ev_fatma_gepackt",
   "t": "23:58:38",
   "ort": "vor_vorratstuer",
   "art": "handlung",
   "person": "schneider",
   "ziel": "fatma",
   "text": "Herr Schneider packt den Gurt von Fatmas Tasche."
  },
  {
   "id": "ev_fatma_schlag",
   "t": "23:58:39",
   "ort": "vor_vorratstuer",
   "art": "handlung",
   "person": "fatma",
   "text": "In Panik greift Fatma den Kerzenständer von der Anrichte und schlägt einmal zu. Ihr Silberring schrammt über das Messing, rote Wachstropfen fallen auf die Schatulle."
  },
  {
   "id": "ev_fatma_drohung",
   "t": "23:58:38",
   "ort": "vor_vorratstuer",
   "art": "geraeusch",
   "lautstaerke": "leise",
   "person": "schneider",
   "text": "Herr Schneider zischt: „Zu spät. Die Polizei kommt so oder so.“"
  }
 ],
 "spurenImEigenenPfad": [
  {
   "gegenstand": "silberring_fatma",
   "spur": "spur_ring_messing",
   "zeigt": "Frischer goldgelber Messingabrieb in einer Kerbe des Rings.",
   "rolle": {
    "fatma": "schluesselbeweis"
   }
  },
  {
   "gegenstand": "muenzschatulle",
   "spur": "spur_schatulle_wachs",
   "zeigt": "Auf dem Deckel kleben rote Wachstropfen.",
   "rolle": {
    "fatma": "zusatzindiz"
   }
  },
  {
   "gegenstand": "brottasche",
   "spur": "spur_brottasche_bund",
   "zeigt": "Unter dem Brot liegt Herrn Schneiders Schlüsselbund.",
   "rolle": {
    "fatma": "fundort"
   }
  },
  {
   "gegenstand": "gelbe_fasern",
   "spur": "spur_fasern_kapuze",
   "zeigt": "Knallgelbe Fasern, wie von einer Kapuze.",
   "rolle": {
    "ahmet": "falsche_faehrte",
    "fatma": "falsche_faehrte",
    "olli": "falsche_faehrte",
    "can": "ausgangslage"
   }
  }
 ]
}

SCHNITTSTELLEN:
Datei content/party/schlosskeller/texte/taeter-fatma.json, Feld eintraege: genau 1 Objekt nach Schema content/party/schema/texte-taeter.schema.json, z. B.:
{
 "rolle": "fatma",
 "tarnung": "Was du über die Sekunden im Dunkeln erzählst …",
 "tatwissen": [
  {
   "text": "Was wirklich geschah, Satz für Satz …"
  },
  {
   "ref": "spur:<id>"
  }
 ],
 "verbirgt": [
  {
   "ref": "luege:<id>"
  },
  {
   "ref": "nebendelikt:<id>"
  },
  {
   "text": "…"
  }
 ],
 "ziel": "…"
}
Die Täterfassung ersetzt im Pfad fatma die Teile verbirgt und ziel der Unschuldsfassung; wer und weiss bleiben gleich. Ton: Die Tat geschah in Panik im Dunkeln, nicht geplant und nicht aus Wut. Die Figur bleibt liebenswert. Herr Schneider überlebt; kein Blut, keine Wunde, nur „ein dumpfer Schlag, Poltern“.

EIGENE DATEIEN: content/party/schlosskeller/texte/taeter-fatma.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN, SCHLUESSEL.md und den Auszug.
2. tarnung: 3–5 Sätze in Du-Form, was die Rolle über die Sekunden im Dunkeln erzählt. Sie stützt sich auf die Lügen der Rolle (luegen.behauptung).
3. tatwissen: 5–8 Punkte in zeitlicher Reihenfolge. Was wirklich geschah, aus killerProfile und tatEreignisse, dazu die Spuren, die die Tat hinterlassen hat, als spur:<id>.
4. verbirgt: alle Lügen der Rolle als luege:<id>, das Nebendelikt als nebendelikt:<id> und ein Satz, was passiert, wenn es herauskommt.
5. ziel: 1–2 Sätze. Unentdeckt bleiben, ohne einen Unschuldigen ins Unglück zu stürzen.
6. Prüfe mit python3 -m json.tool und dart test test/party/texte_test.dart.

ABNAHMEKRITERIEN UND TESTWEG: Genau 1 Eintrag; texte_test grün; Tatwissen deckt sich mit tatEreignisse und killerProfile; keine Gewaltbeschreibung.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-07
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Punkte in tatwissen: <Zahl>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-07 · BEREIT ZUR RÜCKGABE ===

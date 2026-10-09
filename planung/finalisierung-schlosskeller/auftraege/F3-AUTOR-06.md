F3-AUTOR-06 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Täterfassung für Ahmet: Tarngeschichte, Tatwissen, was zu verbergen ist, und das Ziel für den Abend.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
{
 "figur": {
  "figur": {
   "id": "ahmet",
   "name": "Ahmet",
   "roleTitle": "Der Organisator",
   "geschlecht": "m",
   "herkunft": "bosnisch",
   "besetzungsplatz": 1,
   "alltag": "Arbeitet in einer Agentur, die Stadtfeste und Märkte plant.",
   "persoenlichesZiel": "Niemand soll vor dem Morgen erfahren, dass die Miete erfunden war.",
   "loyalitaet": {
    "zu": "leyla",
    "grund": "Sie sind zusammen aufgewachsen und halten zusammen."
   },
   "motiveAndConflict": "Ahmet hat den Keller umsonst bekommen. Dafür gestaltet er das Programm des Adventsmarkts. Beim Essen hat er viel zu groß bestellt. Statt das zuzugeben, hat er von allen 150 € „Miete“ eingesammelt. Um 23:51 sagt Herr Schneider an der Theke: „Um zwölf sag ich allen, was der Keller gekostet hat.“",
   "roleSecret": "Um 23:57 schlüpft er mit dem Umschlag voller Mietgeld hinter die Theke. Er will Herrn Schneider bitten, um zwölf nichts zu sagen. Das Geld will er morgen allen zurückgeben.",
   "luegen": [
    {
     "id": "luege_ahmet_servietten",
     "behauptung": "Ich hab hinter der Theke nur Servietten gesucht.",
     "wahrheit": "Er wollte Herrn Schneider mit dem Umschlag um Aufschub bitten."
    },
    {
     "id": "luege_ahmet_miete",
     "behauptung": "Die 150 € waren für die Miete.",
     "wahrheit": "Der Keller hat nichts gekostet; das Geld deckt seine zu große Essensbestellung."
    }
   ],
   "nebendelikt": {
    "id": "nd_mietgeld",
    "text": "Hat von allen 150 € Miete kassiert, obwohl der Keller nichts gekostet hat."
   },
   "visualSpecs": {
    "silhouette": "Schlank, aufrecht, sportliche Haltung, Brille, kurzer Bart",
    "outfit": "Schwarzer Strickpulli über weißem T-Shirt, dunkle Jeans, weiße Turnschuhe. Die schwarze Stoffjacke hängt ab 23:55 am Jackenständer im Ost-Saal.",
    "distinguishingFeature": "Blaues Schlüsselband aus der Hosentasche, Handy in der Hand (ab 0:05, vorher im Handykorb)",
    "idleAnimation": "Dreht das Schlüsselband um den Finger und streicht sich nervös durch den Bart"
   },
   "startRoom": "thekensaal",
   "innocentProfile": {
    "actualBehavior": "Duckt sich beim Knall hinter der Theke am Ostende neben Damir und hält den Umschlag fest. Er bleibt dort, bis das Licht angeht. Später leert er den Umschlag und wirft ihn in den Ascheneimer am Kamin."
   },
   "killerProfile": {
    "crimeExecution": "Er kauert erst am Ostende der Theke neben Damir. Dann geht er zum Kerzenlicht an der Anrichte, um Herrn Schneider zu bitten. Herr Schneider, noch außer sich wegen Can, packt ihn am Arm und zischt: „Um zwölf erfahren's alle.“ In Panik greift Ahmet mit der Hand, in der er den Umschlag hält, den Kerzenständer und schlägt einmal zu. Heißes Wachs tropft auf den Umschlag, eine Ecke reißt ab und bleibt am Griff kleben. In Panik reißt er den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt er, dass Flucht alles schlimmer macht. Er steckt den Bund im Ost-Saal in seine eigene Jacke und kauert sich wieder neben Damir.",
    "smokingGun": "Im Wachs am Griff des Kerzenständers klebt eine abgerissene Ecke seines Mietumschlags.",
    "zusatzindiz": "Rote Wachstropfen auf dem leeren Umschlag im Ascheneimer am Kamin; eine Ecke fehlt."
   },
   "blackoutAlibi": "Behauptet, hinter der Theke nach Servietten gesucht zu haben."
  },
  "eigeneBeobachtungen": [],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_foto_streit",
    "zeit": "23:51",
    "text": "Herr Schneider zu Ahmet an der Theke: „Um zwölf sag ich allen, was der Keller gekostet hat.“ Joanna fotografiert den Streit.",
    "pfade": "alle"
   },
   {
    "id": "z_jacke",
    "zeit": "23:55",
    "text": "Ahmet hängt seine schwarze Jacke an den Jackenständer im Ost-Saal.",
    "pfade": "alle"
   },
   {
    "id": "z_theke_2357",
    "zeit": "23:57",
    "text": "Fatma geht mit der Tasche zur Theken-Klappe, Olli holt am Eiskübel Eis, Ahmet schlüpft mit dem Umschlag hinter die Theke. Herr Schneider raunzt Olli an: „Zweitausend, bis zwölf.“",
    "pfade": "alle"
   },
   {
    "id": "z_umschlag",
    "zeit": "00:12",
    "text": "Ahmet leert den Umschlag mit dem Mietgeld und wirft ihn in den Ascheneimer am Kamin. Hana sieht es.",
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
 "spurenImEigenenPfad": [
  {
   "gegenstand": "kerzenstaender",
   "spur": "spur_griff_papier",
   "zeigt": "Im erstarrten Wachs am Griff klebt eine abgerissene Ecke braunes Umschlagpapier. Darauf steht „…keller“, in Ahmets Handschrift.",
   "rolle": {
    "ahmet": "schluesselbeweis"
   }
  },
  {
   "gegenstand": "jacke_ahmet",
   "spur": "spur_jacke_bund",
   "zeigt": "In der Innentasche steckt Herrn Schneiders großer Schlüsselbund.",
   "rolle": {
    "ahmet": "fundort"
   }
  },
  {
   "gegenstand": "umschlag_mietgeld",
   "spur": "spur_umschlag_wachs",
   "zeigt": "Drei erstarrte rote Wachstropfen. Eine Ecke des Umschlags ist abgerissen.",
   "rolle": {
    "ahmet": "zusatzindiz"
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
Datei content/party/schlosskeller/texte/taeter-ahmet.json, Feld eintraege: genau 1 Objekt nach Schema content/party/schema/texte-taeter.schema.json, z. B.:
{
 "rolle": "ahmet",
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
Die Täterfassung ersetzt im Pfad ahmet die Teile verbirgt und ziel der Unschuldsfassung; wer und weiss bleiben gleich. Ton: Die Tat geschah in Panik im Dunkeln, nicht geplant und nicht aus Wut. Die Figur bleibt liebenswert. Herr Schneider überlebt; kein Blut, keine Wunde, nur „ein dumpfer Schlag, Poltern“.

EIGENE DATEIEN: content/party/schlosskeller/texte/taeter-ahmet.json

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
## Ergebnis F3-AUTOR-06
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Punkte in tatwissen: <Zahl>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-06 · BEREIT ZUR RÜCKGABE ===

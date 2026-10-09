F3-AUTOR-09 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Täterfassung für Can: Tarngeschichte, Tatwissen, was zu verbergen ist, und das Ziel für den Abend.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
{
 "figur": {
  "figur": {
   "id": "can",
   "name": "Can",
   "roleTitle": "Der Spaßvogel",
   "geschlecht": "m",
   "herkunft": "türkisch",
   "besetzungsplatz": 4,
   "alltag": "Macht eine Ausbildung zum Mediengestalter und dreht lustige Kurzvideos.",
   "persoenlichesZiel": "Der Streich soll nicht herauskommen.",
   "loyalitaet": {
    "zu": "zeynep",
    "grund": "Seine Schwester Zeynep hat für ihn Schmiere gestanden."
   },
   "motiveAndConflict": "Can hat am Nachmittag eine weiße Gespenstermaske mit Leuchtfarbe angemalt. Um 23:54 versteckt er sich damit im dunklen Vorratsraum. Um zwölf soll das Geburtstagskind zur Torte kommen und sich erschrecken. Kurz vor zwölf knallt es, das Licht geht aus, und die Tür zum Vorratsraum quietscht auf. Can glaubt, das Geburtstagskind wird schon gebracht, und springt mit „Buuuh!“ hervor. Er läuft Herrn Schneider in die Arme. Der packt ihn an der Kapuze und ruft: „Hab ich dich!“",
   "roleSecret": "Er hat mit der Leuchtmaske im Vorratsraum gewartet. Herr Schneider hat ihn an der Kapuze gepackt.",
   "luegen": [
    {
     "id": "luege_can_toilette",
     "behauptung": "Ich war die ganze Zeit auf der Toilette im Turm.",
     "wahrheit": "Er war im Vorratsraum und ist erst nach dem Zusammenstoß in den Turm gerannt."
    },
    {
     "id": "luege_can_maske",
     "behauptung": "Welche Maske? Ich hab keine Maske.",
     "wahrheit": "Die Leuchtmaske steckt in der Bauchtasche seines Pullis."
    }
   ],
   "nebendelikt": {
    "id": "nd_streich",
    "text": "Hat sich mit der Leuchtmaske im Vorratsraum versteckt, um das Geburtstagskind zu erschrecken."
   },
   "visualSpecs": {
    "silhouette": "Jugendlich, schlank, federnder Gang",
    "outfit": "Signalgelber weiter Kapuzenpulli, weite Jeans, bunte Turnschuhe",
    "distinguishingFeature": "Auffällige gelbe Kapuze, linke Hand tief in der Bauchtasche des Pullis (dort steckt die Maske)",
    "idleAnimation": "Zieht an den Kapuzenbändern und wippt auf den Zehenspitzen"
   },
   "startRoom": "west_saal",
   "innocentProfile": {
    "actualBehavior": "Er reißt sich los und rennt durch den Durchgang, noch bevor es scheppert. Die leuchtende Maske hält er in der Hand. Im Kaminsaal rennt er zur Bogentür, stopft die Maske in die Bauchtasche seines Pullis und versteckt sich oben auf der Toilette im Turm."
   },
   "killerProfile": {
    "crimeExecution": "Herr Schneider hält ihn an der Kapuze fest und zischt: „Jetzt kommt die Polizei, Freundchen.“ In Panik greift Can mit der Hand voller Leuchtfarbe den Kerzenständer von der Anrichte und schlägt einmal zu. Herr Schneider stürzt in den Vorratsraum. Can kniet sich neben ihn und reißt in Panik den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt er, dass Flucht alles schlimmer macht. Er rennt nach dem Scheppern durch den Durchgang und den Kaminsaal, stopft an der Bogentür die Maske in die Bauchtasche, steckt den Bund in den Helm der Ritterrüstung und versteckt sich auf der Toilette im Turm.",
    "smokingGun": "Ein Abdruck einer ganzen Hand in grünlich-weißer Leuchtfarbe um den Griff des Kerzenständers.",
    "zusatzindiz": "Rote Wachstropfen auf der Leuchtmaske."
   },
   "blackoutAlibi": "Behauptet, auf der Toilette im Turm gewesen zu sein."
  },
  "eigeneBeobachtungen": [],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_can_vorrat",
    "zeit": "23:54",
    "text": "Can schleicht über den Durchgang hinter die Theke in den Vorratsraum, macht dort das Licht aus und wartet mit der Leuchtmaske auf das Geburtstagskind. Zeynep steht am Bogen zum Durchgang Schmiere.",
    "pfade": "alle"
   },
   {
    "id": "z_zusammenstoss",
    "zeit": "23:58:13",
    "text": "Herr Schneider will die Notlaterne holen. Can springt mit der leuchtenden Maske aus dem Vorratsraum, Herr Schneider packt ihn an der Kapuze: „Hab ich dich!“",
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
   "text": "Herr Schneider packt Can an der Kapuze und hält ihn fest."
  },
  {
   "id": "ev_can_schlag",
   "t": "23:58:39",
   "ort": "vor_vorratstuer",
   "art": "handlung",
   "person": "can",
   "text": "In Panik greift Can mit der Hand voller Leuchtfarbe den Kerzenständer von der Anrichte und schlägt einmal zu. Rote Wachstropfen fallen auf die Maske in seiner anderen Hand."
  },
  {
   "id": "ev_can_drohung",
   "t": "23:58:31",
   "ort": "vor_vorratstuer",
   "art": "geraeusch",
   "lautstaerke": "leise",
   "person": "schneider",
   "text": "Herr Schneider zischt: „Jetzt kommt die Polizei, Freundchen.“"
  }
 ],
 "spurenImEigenenPfad": [
  {
   "gegenstand": "kerzenstaender",
   "spur": "spur_griff_leuchtfarbe",
   "zeigt": "Um den Griff liegt der Abdruck einer ganzen Hand in grünlich-weißer Leuchtfarbe, derselben Farbe wie auf der Maske.",
   "rolle": {
    "can": "schluesselbeweis"
   }
  },
  {
   "gegenstand": "leuchtmaske",
   "spur": "spur_maske_wachs",
   "zeigt": "Rote Wachstropfen auf der Stirn der Maske.",
   "rolle": {
    "can": "zusatzindiz"
   }
  },
  {
   "gegenstand": "ruestungshelm",
   "spur": "spur_helm_bund",
   "zeigt": "Im Helm klemmt Herrn Schneiders Schlüsselbund.",
   "rolle": {
    "can": "fundort"
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
Datei content/party/schlosskeller/texte/taeter-can.json, Feld eintraege: genau 1 Objekt nach Schema content/party/schema/texte-taeter.schema.json, z. B.:
{
 "rolle": "can",
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
Die Täterfassung ersetzt im Pfad can die Teile verbirgt und ziel der Unschuldsfassung; wer und weiss bleiben gleich. Ton: Die Tat geschah in Panik im Dunkeln, nicht geplant und nicht aus Wut. Die Figur bleibt liebenswert. Herr Schneider überlebt; kein Blut, keine Wunde, nur „ein dumpfer Schlag, Poltern“.

EIGENE DATEIEN: content/party/schlosskeller/texte/taeter-can.json

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
## Ergebnis F3-AUTOR-09
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Punkte in tatwissen: <Zahl>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-09 · BEREIT ZUR RÜCKGABE ===

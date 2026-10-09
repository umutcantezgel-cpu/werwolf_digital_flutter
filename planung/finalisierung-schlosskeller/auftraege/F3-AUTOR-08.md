F3-AUTOR-08 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Täterfassung für Olli: Tarngeschichte, Tatwissen, was zu verbergen ist, und das Ziel für den Abend.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
{
 "figur": {
  "figur": {
   "id": "olli",
   "name": "Olli",
   "roleTitle": "Der Anpacker",
   "geschlecht": "m",
   "herkunft": "deutsch",
   "besetzungsplatz": 3,
   "alltag": "Ist Lagerlogistiker und hilft bei jedem Umzug im Freundeskreis.",
   "persoenlichesZiel": "Den Türschaden selbst mit Herrn Schneider klären, ohne die Gruppe hineinzuziehen.",
   "loyalitaet": {
    "zu": "kaan",
    "grund": "Wojtek hat ihm beim Tragen geholfen und hält zu ihm."
   },
   "motiveAndConflict": "Um 18:30 trägt Olli mit Wojtek die Warmhaltebehälter durch den Turm. Dabei schrammt er die geschnitzte Bogentür, ein Beschlag reißt aus. Herr Schneider verlangt 2.000 € Bargeld und schließt die Tore ab: „Keiner geht, bevor das bezahlt ist.“ Um 23:00 streiten die beiden laut.",
   "roleSecret": "Um 23:57 holt er am Eiskübel Eis für Wojteks eingeklemmten Finger. Herr Schneider raunzt ihn an: „Zweitausend, bis zwölf.“",
   "luegen": [
    {
     "id": "luege_olli_tafel",
     "behauptung": "Ich saß die ganze Zeit am Tisch im Ost-Saal.",
     "wahrheit": "Um 23:57 war er am Eiskübel vor der Theke, danach kauerte er am rechten Buffettisch."
    }
   ],
   "nebendelikt": {
    "id": "nd_tuerschaden",
    "text": "Hat die Bogentür beschädigt und wollte die Schramme mit Möbelwachs verdecken."
   },
   "visualSpecs": {
    "silhouette": "Breit gebaut, kräftige Schultern, leicht gebeugte Haltung",
    "outfit": "Grauer Kapuzenpulli, dunkelblaue Daunenweste, Khakihose mit Seitentaschen",
    "distinguishingFeature": "Holzsplitter und weißer Kalk an den Ärmeln des Pullis; der rechte Arbeitshandschuh hängt aus der Westentasche, der linke liegt seit 19:30 am Kamin",
    "idleAnimation": "Reibt sich den Nacken, wechselt das Standbein und schaut auf seine Hände"
   },
   "startRoom": "ost_saal",
   "innocentProfile": {
    "actualBehavior": "Beim Knall tastet er sich vom Eiskübel zum rechten Buffettisch und kauert dort gleich danach neben Azra, bis das Licht angeht. Dann bringt er Wojtek das Eis und setzt sich in den Ost-Saal an die Tafel."
   },
   "killerProfile": {
    "crimeExecution": "Er bleibt erst am Eiskübel stehen. Dann geht er vor der Theke entlang und durch die Klappe zum Kerzenlicht, weil er mit Herrn Schneider reden will. Herr Schneider packt ihn am Ärmel und zischt: „Zweitausend. Sonst Polizei.“ In Panik greift Olli den Kerzenständer am Fuß und schlägt einmal zu. Rote Tropfen fallen auf den Handschuh, der aus seiner Westentasche hängt. In Panik reißt er den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt er, dass Flucht alles schlimmer macht. Er wirft ihn in den Eiskübel und kauert sich zu Azra.",
    "smokingGun": "Holzsplitter und weißer Kalk von seinen Ärmeln kleben im Wachs am Fuß des Kerzenständers, das inzwischen erstarrt ist.",
    "zusatzindiz": "Rote Kerzenwachstropfen auf dem Arbeitshandschuh in seiner Westentasche."
   },
   "blackoutAlibi": "Behauptet, die ganze Zeit am Kopf der Tafel im Ost-Saal gesessen zu haben."
  },
  "eigeneBeobachtungen": [],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_lieferung",
    "zeit": "18:30",
    "text": "Marek liefert das Essen über den Schlosshof und parkt auf Herrn Schneiders reserviertem Platz. Olli und Wojtek tragen die Warmhaltebehälter durch Hoftür, Turmgang und Bogentür.",
    "pfade": "alle"
   },
   {
    "id": "z_tuerschaden",
    "zeit": "18:35",
    "text": "Olli schrammt mit einem Warmhaltebehälter die geschnitzte Bogentür. Ein Beschlag reißt aus, Holzsplitter und weißer Kalk bleiben an seinen Pulli-Ärmeln.",
    "pfade": "alle"
   },
   {
    "id": "z_moebelwachs",
    "zeit": "18:45",
    "text": "Wojtek gibt Olli braunes Möbelwachs aus seiner Werkzeugtasche. Olli reibt es mit seinem rechten Arbeitshandschuh in die Schramme und steckt den Handschuh in die Westentasche.",
    "pfade": "alle"
   },
   {
    "id": "z_forderung",
    "zeit": "18:50",
    "text": "Herr Schneider entdeckt den Schaden, verlangt 2.000 € Bargeld und schreibt es in seinen Quittungsblock. Er schließt Hoftür und Außentor ab: „Keiner geht, bevor das bezahlt ist.“",
    "pfade": "alle"
   },
   {
    "id": "z_handschuh",
    "zeit": "19:30",
    "text": "Olli wärmt sich am noch kalten Kamin die Hände und vergisst dort seinen linken Arbeitshandschuh.",
    "pfade": "alle"
   },
   {
    "id": "z_verlaufen",
    "zeit": "20:15",
    "text": "Lacher: Olli sucht die Toilette, nimmt die falsche Tür hinter der Theke und steht im dunklen Vorratsraum vor der Geburtstagstorte. „Ich wollte nur aufs Klo!“",
    "pfade": "alle"
   },
   {
    "id": "z_streit_olli",
    "zeit": "23:00",
    "text": "Lauter Streit zwischen Herrn Schneider und Olli um die 2.000 €. Pawel versucht zu schlichten und wird barsch abgewiesen.",
    "pfade": "alle"
   },
   {
    "id": "z_olli_eis",
    "zeit": "23:52",
    "text": "Olli zu Wojtek: „Ich hol dir Eis. Und dann red ich mit Schneider.“",
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
   "id": "ev_olli_gepackt",
   "t": "23:58:38",
   "ort": "vor_vorratstuer",
   "art": "handlung",
   "person": "schneider",
   "ziel": "olli",
   "text": "Herr Schneider packt Olli am Ärmel."
  },
  {
   "id": "ev_olli_schlag",
   "t": "23:58:39",
   "ort": "vor_vorratstuer",
   "art": "handlung",
   "person": "olli",
   "text": "In Panik greift Olli den Kerzenständer am Fuß und schlägt einmal zu. Holzsplitter und weißer Kalk von seinem Ärmel bleiben im noch weichen Wachs am Fuß kleben. Rote Tropfen fallen auf den Handschuh, der aus seiner Westentasche hängt."
  },
  {
   "id": "ev_olli_drohung",
   "t": "23:58:38",
   "ort": "vor_vorratstuer",
   "art": "geraeusch",
   "lautstaerke": "leise",
   "person": "schneider",
   "text": "Herr Schneider zischt: „Zweitausend. Sonst Polizei.“"
  }
 ],
 "spurenImEigenenPfad": [
  {
   "gegenstand": "kerzenstaender",
   "spur": "spur_fuss_splitter",
   "zeigt": "Im roten Wachs am Fuß, das inzwischen erstarrt ist, kleben feine Holzsplitter und weißer Kalk.",
   "rolle": {
    "olli": "schluesselbeweis"
   }
  },
  {
   "gegenstand": "eiskuebel",
   "spur": "spur_eiskuebel_bund",
   "zeigt": "Unter den Eiswürfeln liegt Herrn Schneiders Schlüsselbund.",
   "rolle": {
    "olli": "fundort"
   }
  },
  {
   "gegenstand": "handschuh_weste_olli",
   "spur": "spur_weste_kerzenwachs",
   "zeigt": "Auf dem Handrücken kleben frische rote Kerzenwachstropfen.",
   "rolle": {
    "olli": "zusatzindiz"
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
Datei content/party/schlosskeller/texte/taeter-olli.json, Feld eintraege: genau 1 Objekt nach Schema content/party/schema/texte-taeter.schema.json, z. B.:
{
 "rolle": "olli",
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
Die Täterfassung ersetzt im Pfad olli die Teile verbirgt und ziel der Unschuldsfassung; wer und weiss bleiben gleich. Ton: Die Tat geschah in Panik im Dunkeln, nicht geplant und nicht aus Wut. Die Figur bleibt liebenswert. Herr Schneider überlebt; kein Blut, keine Wunde, nur „ein dumpfer Schlag, Poltern“.

EIGENE DATEIEN: content/party/schlosskeller/texte/taeter-olli.json

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
## Ergebnis F3-AUTOR-08
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Punkte in tatwissen: <Zahl>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-08 · BEREIT ZUR RÜCKGABE ===

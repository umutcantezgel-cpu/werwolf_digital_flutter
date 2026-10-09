F3-AUTOR-02 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Dossiers (wer ich bin, was ich weiß, was ich verberge, mein Ziel, Besetzungshinweis) für die Rollen Lejla (leyla), Emine (emine), Tim (tim), Joanna (johanna).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
[
 {
  "figur": {
   "id": "leyla",
   "name": "Lejla",
   "roleTitle": "Die Buffet-Chefin",
   "geschlecht": "w",
   "herkunft": "bosnisch",
   "besetzungsplatz": 5,
   "alltag": "Ist Apothekerin und hat das Buffet für heute Abend geplant.",
   "persoenlichesZiel": "Ahmet schützen, bis er selbst redet.",
   "loyalitaet": {
    "zu": "ahmet",
    "grund": "Ahmet ist ihr Cousin; sie hat ihm versprochen, nichts über die Rechnung zu sagen."
   },
   "motiveAndConflict": "Ahmets Cousine. Sie weiß, dass Ahmet mit der Rechnung fürs Essen in der Klemme steckt. Herr Schneider wollte am Nachmittag eine Genehmigung für das mitgebrachte Essen sehen.",
   "roleSecret": "Um 23:57 sah sie, wie Ahmet mit einem dicken Umschlag hinter die Theke schlüpfte.",
   "luegen": [],
   "nebendelikt": null,
   "visualSpecs": {
    "silhouette": "Zierlich, Haare zu einem straffen Dutt gebunden",
    "outfit": "Türkise Latzschürze über beigem Strickpulli, dunkle Leggings",
    "distinguishingFeature": "Abrechnungsblock in der Schürzentasche, Holzlöffel in der Hand",
    "idleAnimation": "Rückt Schüsseln gerade und rührt im Warmhaltebehälter"
   },
   "startRoom": "thekensaal",
   "blackoutAlibi": "Trug um 23:57:40 die Tortenteller in den Ost-Saal und stand beim Knall dort an der Tafel."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_lejla_ahmet_theke",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Um 23:57 schlüpfte Ahmet mit einem dicken Umschlag hinter die Theke."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_theke_2357",
    "zeit": "23:57",
    "text": "Fatma geht mit der Tasche zur Theken-Klappe, Olli holt am Eiskübel Eis, Ahmet schlüpft mit dem Umschlag hinter die Theke. Herr Schneider raunzt Olli an: „Zweitausend, bis zwölf.“",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "emine",
   "name": "Emine",
   "roleTitle": "Die Grundschullehrerin",
   "geschlecht": "w",
   "herkunft": "türkisch",
   "besetzungsplatz": 6,
   "alltag": "Ist Grundschullehrerin.",
   "persoenlichesZiel": "Fatma nicht verraten.",
   "loyalitaet": {
    "zu": "fatma",
    "grund": "Fatma ist ihre beste Freundin; sie glaubt ihr."
   },
   "motiveAndConflict": "Um 23:40 sah sie im Turmgang, wie Fatma die Schatulle aus der Vitrine nahm. Sie hat geschwiegen, weil Fatma versprochen hat, die Schatulle am Montag zurückzubringen.",
   "roleSecret": "Sie weiß, dass Fatma die Schatulle schon um 23:40 aus der Vitrine genommen hat.",
   "luegen": [],
   "nebendelikt": null,
   "visualSpecs": {
    "silhouette": "Mittelgroß, ruhige Haltung, beiges Kopftuch",
    "outfit": "Olivgrüner Steppmantel, beiges Kopftuch, dunkle Stoffhose, schwarze Stiefel",
    "distinguishingFeature": "Hält eine silberne Thermosflasche mit beiden Händen",
    "idleAnimation": "Dreht den Deckel der Thermosflasche auf und zu und schaut zu Fatma"
   },
   "startRoom": "thekensaal",
   "blackoutAlibi": "Kauerte beim Knall hinter dem linken Buffettisch."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_emine_schatulle",
    "pfade": "alle",
    "kanal": "verborgen",
    "text": "Um 23:40 sah sie im Turmgang, wie Fatma die Münzschatulle aus der Vitrine nahm.",
    "grundVerborgen": "Sie hat Fatma versprochen zu schweigen."
   },
   {
    "id": "b_emine_versteck",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Beim Knall duckte sie sich hinter den linken Buffettisch und blieb dort, bis das Licht anging."
   },
   {
    "id": "b_emine_fatma_frueh",
    "pfade": [
     "ahmet",
     "olli",
     "can"
    ],
    "kanal": "verborgen",
    "text": "Beim Scheppern kauerte Fatma neben ihr hinter dem linken Buffettisch. Sie war schon seit dem Knall da und hatte geflüstert: „Emine? Ich bin's, Fatma.“",
    "grundVerborgen": "Sie fürchtet, dass dann auch die Schatulle herauskommt."
   },
   {
    "id": "b_emine_fatma_spaet",
    "pfade": [
     "fatma"
    ],
    "kanal": "verborgen",
    "text": "Beim Scheppern war Fatma nicht neben ihr. Sie kam erst danach und flüsterte: „Emine? Ich bin's, Fatma.“",
    "grundVerborgen": "Fatma ist ihre beste Freundin."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_vitrine_schatulle",
    "zeit": "23:40",
    "text": "Fatma hebt die gesprungene Scheibe der Vitrine an und nimmt die Münzschatulle mit. Emine sieht es.",
    "pfade": "alle"
   },
   {
    "id": "z_schatulle_entdeckt",
    "zeit": "23:56",
    "text": "Herr Schneider sieht Glassplitter an Fatmas Mantel: „Die Schatulle. Um Punkt zwölf geh ich raus und ruf die Polizei.“",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "tim",
   "name": "Tim",
   "roleTitle": "Der Hobby-Elektriker",
   "geschlecht": "m",
   "herkunft": "deutsch",
   "besetzungsplatz": 7,
   "alltag": "Ist Mechatroniker und repariert gern alles selbst, manchmal zu gern.",
   "persoenlichesZiel": "Niemand soll erfahren, dass seine Mehrfachsteckdose den Ausfall verursacht hat.",
   "loyalitaet": null,
   "motiveAndConflict": "Um 23:57:50 steckt er für den Tortenkaffee die Kaffeemaschine in seine alte Mehrfachsteckdose. Herr Schneider hatte ihn gerade davor gewarnt. Um 23:58:00 knallt es, die Hauptsicherung fliegt raus.",
   "roleSecret": "Der Kurzschluss kam von seiner alten Mehrfachsteckdose. Am Sicherungskasten huschte im Dunkeln ein leuchtendes Gesicht an ihm vorbei.",
   "luegen": [],
   "nebendelikt": {
    "id": "nd_kurzschluss",
    "text": "Hat trotz Warnung die alte Mehrfachsteckdose benutzt und den Kurzschluss verursacht."
   },
   "visualSpecs": {
    "silhouette": "Kräftig, mittelgroß, lockige Haare",
    "outfit": "Rot-schwarz kariertes Flanellhemd über dunklem Shirt, derbe Arbeitshose",
    "distinguishingFeature": "Spannungsprüfer-Schraubenzieher hinter dem Ohr, kleine Stirnlampe um den Hals",
    "idleAnimation": "Klopft prüfend gegen Kabelkanäle und schüttelt den Kopf"
   },
   "startRoom": "west_saal",
   "blackoutAlibi": "Tastete sich beim Knall sofort zum Sicherungskasten im Kaminsaal. Dabei rutschte ihm die Stirnlampe vom Hals. Im Dunkeln fand er den richtigen Schalter nicht. Um 23:59:40 fand er die Stirnlampe auf dem Boden, um 0:00:00 war das Licht wieder an."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_tim_gesicht",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Am Sicherungskasten huschte im Dunkeln ein leuchtendes Gesicht an ihm vorbei."
   },
   {
    "id": "b_tim_kurzschluss",
    "pfade": "alle",
    "kanal": "verborgen",
    "text": "Der Kurzschluss kam von seiner alten Mehrfachsteckdose.",
    "grundVerborgen": "Er schämt sich, weil Herr Schneider ihn gewarnt hatte."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_steckdose",
    "zeit": "23:57:50",
    "text": "Herr Schneider warnt Tim vor der alten Leiste. Tim steckt die Kaffeemaschine trotzdem in seine Mehrfachsteckdose.",
    "pfade": "alle"
   },
   {
    "id": "z_licht",
    "zeit": "00:00",
    "text": "Tim schaltet die Hauptsicherung wieder ein.",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "johanna",
   "name": "Joanna",
   "roleTitle": "Die Fotografin des Abends",
   "geschlecht": "w",
   "herkunft": "polnisch",
   "besetzungsplatz": 8,
   "alltag": "Studiert Medienwissenschaft und fotografiert Hochzeiten als Nebenjob.",
   "persoenlichesZiel": "Ihr Versprechen an Ahmet halten, ohne das Geburtstagskind anzulügen.",
   "loyalitaet": {
    "zu": "ahmet",
    "grund": "Ahmet hat sie gebeten, das Streitfoto zu löschen."
   },
   "motiveAndConflict": "Sie fotografiert den Abend für das Geburtstagskind. Um 23:55 musste ihr Handy in den Handykorb. Ahmet hat sie gebeten, ein Foto zu löschen.",
   "roleSecret": "Sie hat ein Foto von 23:51: Herr Schneider und Ahmet streiten an der Theke.",
   "luegen": [],
   "nebendelikt": null,
   "visualSpecs": {
    "silhouette": "Schlank, aufrecht, schnelle Bewegungen",
    "outfit": "Violetter Cardigan über weißem Top, schwarze Stoffhose",
    "distinguishingFeature": "Handy auf einem kleinen Handyhalter mit Aufsteckleuchte",
    "idleAnimation": "Hebt das Handy, wischt durch Fotos und zoomt hinein"
   },
   "startRoom": "ost_saal",
   "blackoutAlibi": "Stand im Ost-Saal und hielt die Hände über den Handykorb. Um 23:59:30 schaltete sie als Erste die Handylampen ein."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_joanna_foto",
    "pfade": "alle",
    "kanal": "verborgen",
    "text": "Sie hat ein Foto von 23:51: Herr Schneider und Ahmet streiten an der Theke, Ahmet hält einen dicken Umschlag.",
    "grundVerborgen": "Ahmet hat sie gebeten, das Foto zu löschen."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_foto_streit",
    "zeit": "23:51",
    "text": "Herr Schneider zu Ahmet an der Theke: „Um zwölf sag ich allen, was der Keller gekostet hat.“ Joanna fotografiert den Streit.",
    "pfade": "alle"
   }
  ]
 }
]

SCHNITTSTELLEN:
Datei content/party/schlosskeller/texte/dossiers-b2.json, Feld eintraege: genau 4 Objekte nach Schema content/party/schema/texte-dossier.schema.json, z. B.:
{
 "rolle": "<id>",
 "wer": "Zwei bis vier Sätze Vorstellung …",
 "weiss": [
  {
   "ref": "beobachtung:<eigene Pflichtgespräch-Beobachtung>"
  },
  {
   "text": "Eigener Satz ohne neue Tatsache"
  }
 ],
 "verbirgt": [
  {
   "ref": "beobachtung:<eigene verborgene Beobachtung>"
  },
  {
   "ref": "nebendelikt:<id>"
  },
  {
   "ref": "luege:<id>"
  },
  {
   "text": "Warum du schweigst …"
  }
 ],
 "ziel": "…",
 "besetzung": "…"
}
Verweise: beobachtung:<id> nur für Beobachtungen DIESER Rolle (Feld wer), luege:<id> nur für Lügen dieser Rolle, nebendelikt:<id>, zeitleiste:<id> (aus dem Auszug). Pfadabhängige Beobachtungen (pfade ist eine Liste) IMMER beide Fassungen als Verweis aufnehmen; der Code wählt je Pfad die richtige.

EIGENE DATEIEN: content/party/schlosskeller/texte/dossiers-b2.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN, SCHLUESSEL.md und den Auszug.
2. Schreibe je Rolle wer (2–4 Sätze, Du-Form an die Spielerin: „Du bist …“, kein Geheimnis, sichtbares Merkmal aus visualSpecs), weiss (alle eigenen Beobachtungen mit kanal pflichtgespraech als Verweis, dazu höchstens 2 eigene Sätze aus der Zeitleiste der Rolle), verbirgt (alle eigenen Beobachtungen mit kanal verborgen als Verweis, das Nebendelikt der Rolle als Verweis, falls vorhanden, alle Lügen der Rolle als Verweis, und ein Satz, warum die Rolle schweigt: aus grundVerborgen oder loyalitaet), ziel (persoenlichesZiel in eigenen Worten, 1–2 Sätze), besetzung (1 Satz, dass jede Person die Rolle spielen kann, mit einem Hinweis zur Anrede, falls nötig).
3. Prüfe die Datei mit python3 -m json.tool und mit dart test test/party/texte_test.dart.

ABNAHMEKRITERIEN UND TESTWEG: Genau 4 Dossiers; texte_test grün; jeder Verweis aus dem Auszug; keine neuen Tatsachen.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-02
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Verweise je Rolle: <Rolle: Zahl>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-02 · BEREIT ZUR RÜCKGABE ===

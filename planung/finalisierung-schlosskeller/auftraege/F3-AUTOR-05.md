F3-AUTOR-05 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Dossiers (wer ich bin, was ich weiß, was ich verberge, mein Ziel, Besetzungshinweis) für die Rollen Damir (enes), Sibel (selin), Pawel (hakan), Tugba (tugba).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
[
 {
  "figur": {
   "id": "enes",
   "name": "Damir",
   "roleTitle": "Der Teemeister",
   "geschlecht": "m",
   "herkunft": "bosnisch",
   "besetzungsplatz": 17,
   "alltag": "Ist Erzieher und kocht für alle Tee, ob sie wollen oder nicht.",
   "persoenlichesZiel": "Sein Ärger mit Herrn Schneider über das Teegeschirr soll nicht zur Sprache kommen.",
   "loyalitaet": null,
   "motiveAndConflict": "Er schenkt den ganzen Abend Tee aus. Herr Schneider warf ihm vor, das Teegeschirr des Schlosses ohne Erlaubnis zu benutzen.",
   "roleSecret": "Um 23:57 sah er Ahmet, Fatma und Olli an der Theke, Herrn Schneider am Ostende. Can war nicht zu sehen.",
   "luegen": [],
   "nebendelikt": null,
   "visualSpecs": {
    "silhouette": "Schlank, aufmerksam, flinke Hände",
    "outfit": "Weißes Hemd mit hochgekrempelten Ärmeln, schwarze Schürze",
    "distinguishingFeature": "Hält ein schmales Teeglas auf einer Untertasse",
    "idleAnimation": "Poliert Teegläser mit einem weißen Tuch und prüft den Teekocher"
   },
   "startRoom": "thekensaal",
   "blackoutAlibi": "Duckte sich am Ostende hinter die Theke, um nicht an heiße Kannen zu stoßen."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_damir_an_der_theke",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Um 23:57 standen Ahmet, Fatma und Olli an der Theke, Herr Schneider am Ostende. Can war nicht zu sehen."
   },
   {
    "id": "b_damir_ahmet_blieb",
    "pfade": [
     "fatma",
     "olli",
     "can"
    ],
    "kanal": "verborgen",
    "text": "Beim Scheppern kauerte Ahmet neben ihm am Ostende der Theke. Er war schon seit dem Knall da und hatte geflüstert: „Damir? Ich bin's, Ahmet.“",
    "grundVerborgen": "Er will nicht, dass sein Ärger mit Herrn Schneider zur Sprache kommt."
   },
   {
    "id": "b_damir_ahmet_weg",
    "pfade": [
     "ahmet"
    ],
    "kanal": "verborgen",
    "text": "Beim Scheppern war Ahmet nicht neben ihm. Er war kurz davor aufgestanden und kam erst danach zurück: „Damir, ich bin's wieder.“",
    "grundVerborgen": "Ahmet ist ein Freund; er will ihn nicht ohne Not belasten."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_theke_2357",
    "zeit": "23:57",
    "text": "Fatma geht mit der Tasche zur Theken-Klappe, Olli holt am Eiskübel Eis, Ahmet schlüpft mit dem Umschlag hinter die Theke. Herr Schneider raunzt Olli an: „Zweitausend, bis zwölf.“",
    "pfade": "alle"
   },
   {
    "id": "z_gefunden",
    "zeit": "00:00:20",
    "text": "Damir findet Herrn Schneider im Vorratsraum.",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "selin",
   "name": "Sibel",
   "roleTitle": "Die Vorsichtige",
   "geschlecht": "w",
   "herkunft": "türkisch",
   "besetzungsplatz": 18,
   "alltag": "Studiert Biologie und fürchtet sich vor nichts außer alten Rüstungen.",
   "persoenlichesZiel": "Die Rüstung soll aus dem Turmgang verschwinden.",
   "loyalitaet": null,
   "motiveAndConflict": "Um 21:00 hielt sie die Ritterrüstung im Turmgang für einen Menschen, schrie auf und stieß gegen die Vitrine. Seitdem macht sie einen Bogen um den Turmgang.",
   "roleSecret": "Im Dunkeln huschte ein leuchtendes Gesicht unter einer Kapuze vom Durchgang quer durch den Kaminsaal zur Bogentür.",
   "luegen": [],
   "nebendelikt": null,
   "visualSpecs": {
    "silhouette": "Klein, zieht oft die Schultern hoch",
    "outfit": "Pastellrosa Strickpulli, helle Jeans, weißer Fransenschal",
    "distinguishingFeature": "Zieht den Fransenschal bis übers Kinn",
    "idleAnimation": "Schaut sich um und zuckt bei lauten Geräuschen zusammen"
   },
   "startRoom": "west_saal",
   "blackoutAlibi": "Kauerte auf der Wandbank im Kaminsaal."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_selin_gesicht",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Im Dunkeln huschte ein leuchtendes Gesicht quer durch den Kaminsaal zur Bogentür."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_ruestung",
    "zeit": "21:00",
    "text": "Lacher: Sibel hält die Ritterrüstung für einen Menschen, schreit auf und stolpert gegen die Schauvitrine. Die Scheibe bekommt einen feinen Sprung.",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "hakan",
   "name": "Pawel",
   "roleTitle": "Der Vermittler",
   "geschlecht": "m",
   "herkunft": "polnisch",
   "besetzungsplatz": 19,
   "alltag": "Ist Rechtsreferendar und schlichtet seit der Schulzeit jeden Streit.",
   "persoenlichesZiel": "Herrn Schneider in Schutz nehmen, ohne seine Geldsorgen auszuplaudern.",
   "loyalitaet": null,
   "motiveAndConflict": "Um 23:00 versuchte er, den Streit zwischen Herrn Schneider und Olli zu schlichten. Herr Schneider wies ihn barsch ab. Im Sommer hat Pawel bei der Schlossstiftung gejobbt.",
   "roleSecret": "Herr Schneider muss jeden Schaden der Stiftung melden. Kleine Schäden zahlt er oft aus eigener Tasche. Darum ist er beim Geld so streng.",
   "luegen": [],
   "nebendelikt": null,
   "visualSpecs": {
    "silhouette": "Ruhig, aufrecht, gelassene Haltung",
    "outfit": "Schokobraune Steppjacke über beigem Rollkragen, Halbschuhe",
    "distinguishingFeature": "Dunkelbraune Ledertasche neben sich, Teetasse in der Hand",
    "idleAnimation": "Nimmt einen langsamen Schluck Tee und beobachtet die Gruppe"
   },
   "startRoom": "ost_saal",
   "blackoutAlibi": "Blieb im Ost-Saal ruhig am Tisch und bat alle, keine Panik zu machen."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_pawel_schneider",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Herr Schneider muss jeden Schaden der Stiftung melden und zahlt kleine Schäden oft aus eigener Tasche. Darum ist er beim Geld so streng."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_streit_olli",
    "zeit": "23:00",
    "text": "Lauter Streit zwischen Herrn Schneider und Olli um die 2.000 €. Pawel versucht zu schlichten und wird barsch abgewiesen.",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "tugba",
   "name": "Tugba",
   "roleTitle": "Die Geburtstags-Planerin",
   "geschlecht": "w",
   "herkunft": "türkisch",
   "besetzungsplatz": 20,
   "alltag": "Ist Projektleiterin und plant sogar Geburtstage mit Ablaufplan.",
   "persoenlichesZiel": "Den Abend retten: Torte um halb eins, egal was passiert.",
   "loyalitaet": null,
   "motiveAndConflict": "Sie hat den Ablaufplan des Abends geschrieben. Um zwölf sollte das Geburtstagskind mit verbundenen Augen zur Torte in den Vorratsraum geführt werden. Herr Schneider hatte nur widerwillig erlaubt, die Torte dort zu kühlen.",
   "roleSecret": "Um 23:57 hat sie notiert, wer für die Torte fehlt und wo die Leute nach eigener Auskunft gerade sind.",
   "luegen": [],
   "nebendelikt": null,
   "visualSpecs": {
    "silhouette": "Organisiert, schwungvoll, geschäftsmäßig",
    "outfit": "Bordeauxroter Blazer über weißem Shirt, schmale Metallbrille",
    "distinguishingFeature": "Notizbuch mit goldenem Einband und Fineliner",
    "idleAnimation": "Blättert im Notizbuch, hakt Zeilen ab und schaut zur Wanduhr"
   },
   "startRoom": "ost_saal",
   "blackoutAlibi": "Stand im Ost-Saal an der Wandtafel mit dem Ablaufplan."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_tugba_notiz",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Um 23:57 hat sie notiert, wer für die Torte fehlt und wo die Leute nach eigener Auskunft gerade sind."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_tortenplan",
    "zeit": "23:55",
    "text": "Tugba ruft alle in den Ost-Saal, die Handys kommen in den Handykorb. Das Geburtstagskind bekommt eine Augenbinde und Barans Kopfhörer mit lauter Musik. Um zwölf soll es zur Torte in den Vorratsraum geführt werden.",
    "pfade": "alle"
   },
   {
    "id": "z_handys",
    "zeit": "00:05",
    "text": "Tugba gibt die Handys aus dem Korb zurück. Empfang hat keines.",
    "pfade": "alle"
   }
  ]
 }
]

SCHNITTSTELLEN:
Datei content/party/schlosskeller/texte/dossiers-b5.json, Feld eintraege: genau 4 Objekte nach Schema content/party/schema/texte-dossier.schema.json, z. B.:
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

EIGENE DATEIEN: content/party/schlosskeller/texte/dossiers-b5.json

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
## Ergebnis F3-AUTOR-05
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Verweise je Rolle: <Rolle: Zahl>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-05 · BEREIT ZUR RÜCKGABE ===

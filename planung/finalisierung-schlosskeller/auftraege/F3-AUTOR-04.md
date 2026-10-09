F3-AUTOR-04 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Dossiers (wer ich bin, was ich weiß, was ich verberge, mein Ziel, Besetzungshinweis) für die Rollen Serkan (serkan), Aylin (aylin), Wojtek (kaan), Azra (dilara).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
[
 {
  "figur": {
   "id": "serkan",
   "name": "Serkan",
   "roleTitle": "Der Fahrdienst-Organisator",
   "geschlecht": "m",
   "herkunft": "türkisch",
   "besetzungsplatz": 13,
   "alltag": "Ist Rettungssanitäter und fährt heute alle sicher nach Hause.",
   "persoenlichesZiel": "Alle so schnell wie möglich sicher nach Hause fahren.",
   "loyalitaet": null,
   "motiveAndConflict": "Er soll die Gäste nachts nach Hause fahren. Um 23:56 wollte er Decken aus dem Auto holen und fand das Außentor verschlossen.",
   "roleSecret": "Von kurz vor zwölf bis nach zwölf stand er am Außentor. Es war abgeschlossen; niemand ist hinaus.",
   "luegen": [],
   "nebendelikt": null,
   "visualSpecs": {
    "silhouette": "Kräftig, breite Statur, aufrechte Haltung",
    "outfit": "Stahlblaue Steppweste über grauem Sweatshirt, dunkle Kappe",
    "distinguishingFeature": "Klemmbrett mit Fahrzeiten, schwere Taschenlampe",
    "idleAnimation": "Rüttelt am Riegel des Außentors und leuchtet aufs Schloss"
   },
   "startRoom": "windfang",
   "blackoutAlibi": "Stand im Windfang am Außentor und leuchtete mit der Taschenlampe aufs Schloss."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_serkan_tor",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Von kurz vor zwölf bis nach zwölf stand er am Außentor. Es war abgeschlossen; niemand ist hinaus."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_serkan_tor",
    "zeit": "23:56",
    "text": "Serkan will Decken aus dem Auto holen und findet das Außentor verschlossen.",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "aylin",
   "name": "Aylin",
   "roleTitle": "Die Kassenprüferin",
   "geschlecht": "w",
   "herkunft": "kurdisch",
   "besetzungsplatz": 14,
   "alltag": "Ist Steuerfachangestellte und hebt jeden Beleg auf.",
   "persoenlichesZiel": "Ihr Geld zurückbekommen, ohne Ahmet vor allen bloßzustellen.",
   "loyalitaet": null,
   "motiveAndConflict": "Sie zahlte die 150 € nur unter Protest und wollte einen Beleg. Um 22:30 fragte sie Herrn Schneider direkt. Er schrieb ihr auf einen Quittungszettel: „Miete: 0 Euro.“",
   "roleSecret": "Sie hat Herrn Schneiders handschriftlichen Quittungszettel: „Miete: 0 Euro.“",
   "luegen": [],
   "nebendelikt": null,
   "visualSpecs": {
    "silhouette": "Sehr gerade Haltung, sachlich",
    "outfit": "Taubenblauer Strickcardigan, weiße Bluse, schwarze Stoffhose",
    "distinguishingFeature": "Schwarze Ledermappe mit Belegen und Kugelschreiber, fest an die Brust gedrückt",
    "idleAnimation": "Klickt mit dem Kugelschreiber und sieht zu Ahmet hinüber"
   },
   "startRoom": "ost_saal",
   "blackoutAlibi": "Saß im Ost-Saal an der Tafel und hielt ihre Mappe fest."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_aylin_quittung",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Sie hat Herrn Schneiders Quittungszettel: „Miete: 0 Euro.“"
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_quittung",
    "zeit": "22:30",
    "text": "Aylin fragt Herrn Schneider nach einem Beleg für die Miete. Er schreibt ihr auf einen Quittungszettel: „Miete: 0 Euro.“",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "kaan",
   "name": "Wojtek",
   "roleTitle": "Der Architekturstudent",
   "geschlecht": "m",
   "herkunft": "polnisch",
   "besetzungsplatz": 15,
   "alltag": "Studiert Architektur; Maßband und Bleistift hat er immer dabei.",
   "persoenlichesZiel": "Niemand soll wissen, dass die Idee mit dem Möbelwachs von ihm kam.",
   "loyalitaet": {
    "zu": "olli",
    "grund": "Olli ist sein Kumpel vom Tragen und hat ihm Eis geholt."
   },
   "motiveAndConflict": "Er hat mit Olli die Warmhaltebehälter durch den Turm getragen. Nach der Schramme riet er Olli, sie mit braunem Möbelwachs aus seiner Werkzeugtasche zu verdecken. Um 23:50 klemmte er sich an der Bogentür den Finger ein.",
   "roleSecret": "Um 23:52 sagte Olli zu ihm: „Ich hol dir Eis. Und dann red ich mit Schneider.“",
   "luegen": [],
   "nebendelikt": {
    "id": "nd_moebelwachs",
    "text": "Hat Olli geraten, die Schramme mit Möbelwachs zu verdecken."
   },
   "visualSpecs": {
    "silhouette": "Schlank, ruhige Haltung, Brille",
    "outfit": "Aschgrauer Kapuzenpulli, schwarze Arbeitshose mit verstärkten Knien",
    "distinguishingFeature": "Zimmermannsbleistift hinter dem Ohr, Maßband am Hosenbund, ein Finger mit Pflaster",
    "idleAnimation": "Streicht mit dem Daumen über die Schramme an der Bogentür"
   },
   "startRoom": "west_saal",
   "blackoutAlibi": "Stand an der Bogentür im Kaminsaal und tastete mit den Fingern die Schramme ab."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_wojtek_olli_satz",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Um 23:52 sagte Olli: „Ich hol dir Eis. Und dann red ich mit Schneider.“"
   },
   {
    "id": "b_wojtek_vorbei",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Im Dunkeln drängte sich jemand an ihm vorbei durch die Bogentür in den Turm."
   },
   {
    "id": "b_wojtek_tuer",
    "pfade": "alle",
    "kanal": "verborgen",
    "text": "Er weiß: Olli hat am Abend die Bogentür beschädigt, und Herr Schneider verlangt zweitausend Euro dafür. Das Möbelwachs zum Verdecken kam von ihm.",
    "grundVerborgen": "Die Idee mit dem Möbelwachs war seine; das soll niemand wissen."
   }
  ],
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
    "id": "z_finger",
    "zeit": "23:50",
    "text": "Wojtek klemmt sich an der Bogentür den Finger ein.",
    "pfade": "alle"
   },
   {
    "id": "z_olli_eis",
    "zeit": "23:52",
    "text": "Olli zu Wojtek: „Ich hol dir Eis. Und dann red ich mit Schneider.“",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "dilara",
   "name": "Azra",
   "roleTitle": "Die Flohmarkt-Kennerin",
   "geschlecht": "w",
   "herkunft": "bosnisch",
   "besetzungsplatz": 16,
   "alltag": "Studiert Kunstgeschichte und stöbert jedes Wochenende auf Flohmärkten.",
   "persoenlichesZiel": "Niemand soll denken, sie hätte Fatma zu etwas angestiftet.",
   "loyalitaet": null,
   "motiveAndConflict": "Sie kennt sich mit alten Münzen aus und hat Fatma von der Schatulle in der Turmvitrine erzählt. Herr Schneider fand es seltsam, wie lange sie vor der Vitrine stand.",
   "roleSecret": "Um 23:45 sah sie, dass Fatmas Tasche auffällig ausgebeult war.",
   "luegen": [],
   "nebendelikt": null,
   "visualSpecs": {
    "silhouette": "Groß, elegante Bewegungen, cremefarbenes Kopftuch",
    "outfit": "Pflaumenfarbenes Samtkleid, langer schwarzer Strickcardigan, cremefarbenes Kopftuch",
    "distinguishingFeature": "Kleine Lupe an einer Silberkette um den Hals, auffällige Ringe aus Holz und Stein",
    "idleAnimation": "Betrachtet ihre Ringe durch die Lupe und schaut zur Theke"
   },
   "startRoom": "thekensaal",
   "blackoutAlibi": "Stand am rechten Buffettisch und füllte Gebäck auf einen Pappteller."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_azra_tasche",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Um 23:45 war Fatmas Tasche auffällig ausgebeult."
   },
   {
    "id": "b_azra_versteck",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Beim Knall duckte sie sich am rechten Buffettisch und blieb dort, bis das Licht anging."
   },
   {
    "id": "b_azra_olli_frueh",
    "pfade": [
     "ahmet",
     "fatma",
     "can"
    ],
    "kanal": "verborgen",
    "text": "Beim Scheppern kauerte Olli neben ihr hinter dem rechten Buffettisch. Er war schon seit dem Knall da und hatte geflüstert: „Azra? Ich bin's, Olli.“",
    "grundVerborgen": "Sie will sich nicht in den Streit um Olli einmischen, solange niemand fragt."
   },
   {
    "id": "b_azra_olli_spaet",
    "pfade": [
     "olli"
    ],
    "kanal": "verborgen",
    "text": "Beim Scheppern war Olli nicht neben ihr. Er kam erst danach und flüsterte: „Azra? Ich bin's, Olli.“",
    "grundVerborgen": "Sie will Olli nicht ohne Not belasten."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_tasche_ausgebeult",
    "zeit": "23:45",
    "text": "Azra sieht, dass Fatmas Tasche auffällig ausgebeult ist.",
    "pfade": "alle"
   }
  ]
 }
]

SCHNITTSTELLEN:
Datei content/party/schlosskeller/texte/dossiers-b4.json, Feld eintraege: genau 4 Objekte nach Schema content/party/schema/texte-dossier.schema.json, z. B.:
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

EIGENE DATEIEN: content/party/schlosskeller/texte/dossiers-b4.json

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
## Ergebnis F3-AUTOR-04
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Verweise je Rolle: <Rolle: Zahl>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-04 · BEREIT ZUR RÜCKGABE ===

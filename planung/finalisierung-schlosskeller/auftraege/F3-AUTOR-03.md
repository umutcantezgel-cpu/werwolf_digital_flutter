F3-AUTOR-03 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Dossiers (wer ich bin, was ich weiß, was ich verberge, mein Ziel, Besetzungshinweis) für die Rollen Marek (murat), Zeynep (zeynep), Baran (baran), Hana (meryem).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
[
 {
  "figur": {
   "id": "murat",
   "name": "Marek",
   "roleTitle": "Der Caterer",
   "geschlecht": "m",
   "herkunft": "polnisch",
   "besetzungsplatz": 9,
   "alltag": "Führt mit seiner Schwester einen kleinen Catering-Betrieb.",
   "persoenlichesZiel": "Der Lieferwagen soll nicht abgeschleppt werden.",
   "loyalitaet": null,
   "motiveAndConflict": "Er hat das Essen geliefert und den Lieferwagen im Schlosshof auf Herrn Schneiders reserviertem Platz abgestellt; am Telefon hatte ihm jemand gesagt, das gehe in Ordnung. Herr Schneider drohte mit Abschleppen.",
   "roleSecret": "Im Dunkeln rannte ein leuchtendes Gespenstergesicht an ihm vorbei durch den Durchgang Richtung Kaminsaal.",
   "luegen": [],
   "nebendelikt": {
    "id": "nd_parken",
    "text": "Hat auf Herrn Schneiders reserviertem Platz geparkt."
   },
   "visualSpecs": {
    "silhouette": "Breitschultrig, sportlich, markante Gesichtszüge",
    "outfit": "Dunkelbraune Lederjacke, weißer Rollkragen, dunkle Jeans",
    "distinguishingFeature": "Lässt den Autoschlüssel mit glänzendem Anhänger um den Zeigefinger kreisen",
    "idleAnimation": "Zählt die Warmhaltebehälter durch und schaut auf die Uhr"
   },
   "startRoom": "thekensaal",
   "blackoutAlibi": "Holte im Durchgang eine Kiste Saft von den Getränkekisten."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_marek_gesicht",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Im Dunkeln rannte ein leuchtendes Gespenstergesicht an ihm vorbei durch den Durchgang Richtung Kaminsaal."
   },
   {
    "id": "b_marek_vor",
    "pfade": [
     "ahmet",
     "fatma",
     "olli"
    ],
    "kanal": "verborgen",
    "text": "Das leuchtende Gesicht rannte an ihm vorbei, bevor es an der Theke schepperte.",
    "grundVerborgen": "Er ist sich im Dunkeln nicht sicher und will niemanden falsch belasten."
   },
   {
    "id": "b_marek_nach",
    "pfade": [
     "can"
    ],
    "kanal": "verborgen",
    "text": "Das leuchtende Gesicht rannte an ihm vorbei, nachdem es an der Theke gescheppert hatte.",
    "grundVerborgen": "Er ist sich im Dunkeln nicht sicher und will niemanden falsch belasten."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_lieferung",
    "zeit": "18:30",
    "text": "Marek liefert das Essen über den Schlosshof und parkt auf Herrn Schneiders reserviertem Platz. Olli und Wojtek tragen die Warmhaltebehälter durch Hoftür, Turmgang und Bogentür.",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "zeynep",
   "name": "Zeynep",
   "roleTitle": "Die Fußballtrainerin",
   "geschlecht": "w",
   "herkunft": "türkisch",
   "besetzungsplatz": 10,
   "alltag": "Studiert Sport und trainiert eine Mädchen-Fußballmannschaft.",
   "persoenlichesZiel": "Can schützen.",
   "loyalitaet": {
    "zu": "can",
    "grund": "Can ist ihr Bruder."
   },
   "motiveAndConflict": "Sie steht für Cans Streich Schmiere am Bogen zum Durchgang. Sie fühlt sich schuldig, weil alles aus dem Ruder lief.",
   "roleSecret": "Sie weiß, dass Can mit der Leuchtmaske im dunklen Vorratsraum auf das Geburtstagskind gewartet hat.",
   "luegen": [],
   "nebendelikt": {
    "id": "nd_schmiere",
    "text": "Hat für Cans Streich Schmiere gestanden."
   },
   "visualSpecs": {
    "silhouette": "Zierlich, sportlich, lässiger Stil",
    "outfit": "Minzgrüner weiter Pulli, weite hellgraue Hose, Kappe verkehrt herum",
    "distinguishingFeature": "Weiße Kopfhörer locker um den Hals, kaut Kaugummi",
    "idleAnimation": "Kaut Kaugummi, wippt auf den Absätzen und behält Can im Blick"
   },
   "startRoom": "west_saal",
   "blackoutAlibi": "Stand am Bogen zwischen Kaminsaal und Durchgang und hielt nach dem Geburtstagskind Ausschau."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_zeynep_vorrat",
    "pfade": "alle",
    "kanal": "verborgen",
    "text": "Can hat mit der Leuchtmaske im dunklen Vorratsraum auf das Geburtstagskind gewartet.",
    "grundVerborgen": "Can ist ihr Bruder."
   },
   {
    "id": "b_zeynep_gesicht",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Ein leuchtendes Gesicht kam aus dem Durchgang an ihr vorbei in den Kaminsaal."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_can_vorrat",
    "zeit": "23:54",
    "text": "Can schleicht über den Durchgang hinter die Theke in den Vorratsraum, macht dort das Licht aus und wartet mit der Leuchtmaske auf das Geburtstagskind. Zeynep steht am Bogen zum Durchgang Schmiere.",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "baran",
   "name": "Baran",
   "roleTitle": "Der Mann für die Musik",
   "geschlecht": "m",
   "herkunft": "kurdisch",
   "besetzungsplatz": 11,
   "alltag": "Studiert Tontechnik und legt bei Freunden auf.",
   "persoenlichesZiel": "Seine Box soll nicht einkassiert werden.",
   "loyalitaet": null,
   "motiveAndConflict": "Herr Schneider verlangte ab 22:00 leise Musik und drohte, die Box einzukassieren. Um 23:55 setzte Baran dem Geburtstagskind seine großen Kopfhörer auf und ließ laute Musik für die Überraschung laufen.",
   "roleSecret": "Die Musik in den Kopfhörern lief über seine Box weiter, als der Strom weg war. Im Ost-Saal hörte er aus Richtung Theke erst „Hab ich dich!“, dann „Stehen bleiben!“, dann das Scheppern.",
   "luegen": [],
   "nebendelikt": null,
   "visualSpecs": {
    "silhouette": "Groß, schlank, leicht nach vorn geneigt",
    "outfit": "Anthrazitfarbener Kapuzenpulli mit neongrünen Kordeln, schwarze Jogginghose",
    "distinguishingFeature": "Große Kopfhörer auf dem Kopf (in der Tatnacht trägt sie das Geburtstagskind), tragbare Musikbox unter dem Arm",
    "idleAnimation": "Wippt im Takt und dreht am Lautstärkerad der Box"
   },
   "startRoom": "ost_saal",
   "blackoutAlibi": "Saß im Ost-Saal auf der Wandbank und hielt seine Box fest."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_baran_rufe",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Aus Richtung Theke hörte er erst „Hab ich dich!“, dann „Stehen bleiben!“, dann das Scheppern."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_musik",
    "zeit": "22:00",
    "text": "Herr Schneider verlangt leise Musik und droht, Barans Box einzukassieren.",
    "pfade": "alle"
   },
   {
    "id": "z_tortenplan",
    "zeit": "23:55",
    "text": "Tugba ruft alle in den Ost-Saal, die Handys kommen in den Handykorb. Das Geburtstagskind bekommt eine Augenbinde und Barans Kopfhörer mit lauter Musik. Um zwölf soll es zur Torte in den Vorratsraum geführt werden.",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "meryem",
   "name": "Hana",
   "roleTitle": "Die Kamin-Heizerin",
   "geschlecht": "w",
   "herkunft": "bosnisch",
   "besetzungsplatz": 12,
   "alltag": "Ist Försterin und kennt Holz besser als Kaminzüge.",
   "persoenlichesZiel": "Den Kamin wieder zum Ziehen bringen und sich bei Herrn Schneider für den Ruß entschuldigen.",
   "loyalitaet": null,
   "motiveAndConflict": "Um 23:30 feuert sie den Kamin an, ohne die Kaminklappe zu öffnen. Dichter Qualm füllt den Kaminsaal. Herr Schneider schimpft über den Ruß an der Wand.",
   "roleSecret": "Kurz nach dem Scheppern roch sie frisch erloschenes Kerzenwachs. Der Geruch kam mit dem Luftzug aus Richtung Theke.",
   "luegen": [],
   "nebendelikt": null,
   "visualSpecs": {
    "silhouette": "Mittelgroß, praktische Statur, hochgekrempelte Ärmel",
    "outfit": "Dunkelblaues Jeanshemd, feste Arbeitshose, Schnürstiefel",
    "distinguishingFeature": "Rußflecken auf der linken Wange und an den Händen, Schürhaken in der Hand",
    "idleAnimation": "Pustet sich eine Strähne aus der Stirn und wischt die Hände an einem alten Lappen ab"
   },
   "startRoom": "west_saal",
   "blackoutAlibi": "Stand am Kamin und wischte Ruß von der Wand."
  },
  "eigeneBeobachtungen": [
   {
    "id": "b_hana_wachs",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Kurz nach dem Scheppern roch sie frisch erloschenes Kerzenwachs. Der Geruch kam mit dem Luftzug aus Richtung Theke."
   },
   {
    "id": "b_hana_umschlag",
    "pfade": "alle",
    "kanal": "pflichtgespraech",
    "text": "Kurz nach zwölf warf Ahmet etwas Raschelndes in den Ascheneimer neben dem Kamin."
   }
  ],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_kamin",
    "zeit": "23:20",
    "text": "Hana feuert den Kamin an, ohne die Kaminklappe zu öffnen.",
    "pfade": "alle"
   },
   {
    "id": "z_qualm",
    "zeit": "23:30",
    "text": "Lacher: Dichter Qualm füllt den Kaminsaal, alle husten. Die Klappen der Lichtschächte werden aufgerissen, das Feuer wird gelöscht. Seitdem zieht Luft vom Buffetsaal in den Kaminsaal.",
    "pfade": "alle"
   }
  ]
 }
]

SCHNITTSTELLEN:
Datei content/party/schlosskeller/texte/dossiers-b3.json, Feld eintraege: genau 4 Objekte nach Schema content/party/schema/texte-dossier.schema.json, z. B.:
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

EIGENE DATEIEN: content/party/schlosskeller/texte/dossiers-b3.json

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
## Ergebnis F3-AUTOR-03
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Verweise je Rolle: <Rolle: Zahl>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-03 · BEREIT ZUR RÜCKGABE ===

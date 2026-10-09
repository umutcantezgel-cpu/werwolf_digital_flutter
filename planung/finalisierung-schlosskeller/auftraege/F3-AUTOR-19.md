F3-AUTOR-19 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die drei Pflichtgespräche der Runde 2 für die Rollen Serkan (serkan), Aylin (aylin), Wojtek (kaan), Azra (dilara) (12 Gespräche).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
{
 "runde": "Runde 2, Die Indizien-Filterung (Weltuhr Viertel nach eins): Man vergleicht Widersprüche, stellt Behauptungen auf die Probe und fragt nach auffälligem Verhalten, ohne eigene Geheimnisse preiszugeben.",
 "rollen": [
  {
   "figur": {
    "id": "serkan",
    "name": "Serkan",
    "roleTitle": "Der Fahrdienst-Organisator",
    "alltag": "Ist Rettungssanitäter und fährt heute alle sicher nach Hause.",
    "persoenlichesZiel": "Alle so schnell wie möglich sicher nach Hause fahren.",
    "loyalitaet": null,
    "startRoom": "windfang"
   },
   "eigeneLuegen": [],
   "eigenePflichtgespraechBeobachtungen": [
    {
     "id": "b_serkan_tor",
     "text": "Von kurz vor zwölf bis nach zwölf stand er am Außentor. Es war abgeschlossen; niemand ist hinaus."
    }
   ]
  },
  {
   "figur": {
    "id": "aylin",
    "name": "Aylin",
    "roleTitle": "Die Kassenprüferin",
    "alltag": "Ist Steuerfachangestellte und hebt jeden Beleg auf.",
    "persoenlichesZiel": "Ihr Geld zurückbekommen, ohne Ahmet vor allen bloßzustellen.",
    "loyalitaet": null,
    "startRoom": "ost_saal"
   },
   "eigeneLuegen": [],
   "eigenePflichtgespraechBeobachtungen": [
    {
     "id": "b_aylin_quittung",
     "text": "Sie hat Herrn Schneiders Quittungszettel: „Miete: 0 Euro.“"
    }
   ]
  },
  {
   "figur": {
    "id": "kaan",
    "name": "Wojtek",
    "roleTitle": "Der Architekturstudent",
    "alltag": "Studiert Architektur; Maßband und Bleistift hat er immer dabei.",
    "persoenlichesZiel": "Niemand soll wissen, dass die Idee mit dem Möbelwachs von ihm kam.",
    "loyalitaet": {
     "zu": "olli",
     "grund": "Olli ist sein Kumpel vom Tragen und hat ihm Eis geholt."
    },
    "startRoom": "west_saal"
   },
   "eigeneLuegen": [],
   "eigenePflichtgespraechBeobachtungen": [
    {
     "id": "b_wojtek_olli_satz",
     "text": "Um 23:52 sagte Olli: „Ich hol dir Eis. Und dann red ich mit Schneider.“"
    },
    {
     "id": "b_wojtek_vorbei",
     "text": "Im Dunkeln drängte sich jemand an ihm vorbei durch die Bogentür in den Turm."
    }
   ]
  },
  {
   "figur": {
    "id": "dilara",
    "name": "Azra",
    "roleTitle": "Die Flohmarkt-Kennerin",
    "alltag": "Studiert Kunstgeschichte und stöbert jedes Wochenende auf Flohmärkten.",
    "persoenlichesZiel": "Niemand soll denken, sie hätte Fatma zu etwas angestiftet.",
    "loyalitaet": null,
    "startRoom": "thekensaal"
   },
   "eigeneLuegen": [],
   "eigenePflichtgespraechBeobachtungen": [
    {
     "id": "b_azra_tasche",
     "text": "Um 23:45 war Fatmas Tasche auffällig ausgebeult."
    },
    {
     "id": "b_azra_versteck",
     "text": "Beim Knall duckte sie sich am rechten Buffettisch und blieb dort, bis das Licht anging."
    }
   ]
  }
 ],
 "alleRollen": [
  {
   "id": "ahmet",
   "name": "Ahmet",
   "roleTitle": "Der Organisator",
   "besetzungsplatz": 1
  },
  {
   "id": "fatma",
   "name": "Fatma",
   "roleTitle": "Die Designstudentin",
   "besetzungsplatz": 2
  },
  {
   "id": "olli",
   "name": "Olli",
   "roleTitle": "Der Anpacker",
   "besetzungsplatz": 3
  },
  {
   "id": "can",
   "name": "Can",
   "roleTitle": "Der Spaßvogel",
   "besetzungsplatz": 4
  },
  {
   "id": "leyla",
   "name": "Lejla",
   "roleTitle": "Die Buffet-Chefin",
   "besetzungsplatz": 5
  },
  {
   "id": "emine",
   "name": "Emine",
   "roleTitle": "Die Grundschullehrerin",
   "besetzungsplatz": 6
  },
  {
   "id": "tim",
   "name": "Tim",
   "roleTitle": "Der Hobby-Elektriker",
   "besetzungsplatz": 7
  },
  {
   "id": "johanna",
   "name": "Joanna",
   "roleTitle": "Die Fotografin des Abends",
   "besetzungsplatz": 8
  },
  {
   "id": "murat",
   "name": "Marek",
   "roleTitle": "Der Caterer",
   "besetzungsplatz": 9
  },
  {
   "id": "zeynep",
   "name": "Zeynep",
   "roleTitle": "Die Fußballtrainerin",
   "besetzungsplatz": 10
  },
  {
   "id": "baran",
   "name": "Baran",
   "roleTitle": "Der Mann für die Musik",
   "besetzungsplatz": 11
  },
  {
   "id": "meryem",
   "name": "Hana",
   "roleTitle": "Die Kamin-Heizerin",
   "besetzungsplatz": 12
  },
  {
   "id": "serkan",
   "name": "Serkan",
   "roleTitle": "Der Fahrdienst-Organisator",
   "besetzungsplatz": 13
  },
  {
   "id": "aylin",
   "name": "Aylin",
   "roleTitle": "Die Kassenprüferin",
   "besetzungsplatz": 14
  },
  {
   "id": "kaan",
   "name": "Wojtek",
   "roleTitle": "Der Architekturstudent",
   "besetzungsplatz": 15
  },
  {
   "id": "dilara",
   "name": "Azra",
   "roleTitle": "Die Flohmarkt-Kennerin",
   "besetzungsplatz": 16
  },
  {
   "id": "enes",
   "name": "Damir",
   "roleTitle": "Der Teemeister",
   "besetzungsplatz": 17
  },
  {
   "id": "selin",
   "name": "Sibel",
   "roleTitle": "Die Vorsichtige",
   "besetzungsplatz": 18
  },
  {
   "id": "hakan",
   "name": "Pawel",
   "roleTitle": "Der Vermittler",
   "besetzungsplatz": 19
  },
  {
   "id": "tugba",
   "name": "Tugba",
   "roleTitle": "Die Geburtstags-Planerin",
   "besetzungsplatz": 20
  }
 ],
 "oeffentlicheBeobachtungenAllerRollen": [
  {
   "id": "b_lejla_ahmet_theke",
   "wer": "leyla",
   "text": "Um 23:57 schlüpfte Ahmet mit einem dicken Umschlag hinter die Theke."
  },
  {
   "id": "b_damir_an_der_theke",
   "wer": "enes",
   "text": "Um 23:57 standen Ahmet, Fatma und Olli an der Theke, Herr Schneider am Ostende. Can war nicht zu sehen."
  },
  {
   "id": "b_emine_versteck",
   "wer": "emine",
   "text": "Beim Knall duckte sie sich hinter den linken Buffettisch und blieb dort, bis das Licht anging."
  },
  {
   "id": "b_azra_tasche",
   "wer": "dilara",
   "text": "Um 23:45 war Fatmas Tasche auffällig ausgebeult."
  },
  {
   "id": "b_azra_versteck",
   "wer": "dilara",
   "text": "Beim Knall duckte sie sich am rechten Buffettisch und blieb dort, bis das Licht anging."
  },
  {
   "id": "b_marek_gesicht",
   "wer": "murat",
   "text": "Im Dunkeln rannte ein leuchtendes Gespenstergesicht an ihm vorbei durch den Durchgang Richtung Kaminsaal."
  },
  {
   "id": "b_selin_gesicht",
   "wer": "selin",
   "text": "Im Dunkeln huschte ein leuchtendes Gesicht quer durch den Kaminsaal zur Bogentür."
  },
  {
   "id": "b_tim_gesicht",
   "wer": "tim",
   "text": "Am Sicherungskasten huschte im Dunkeln ein leuchtendes Gesicht an ihm vorbei."
  },
  {
   "id": "b_zeynep_gesicht",
   "wer": "zeynep",
   "text": "Ein leuchtendes Gesicht kam aus dem Durchgang an ihr vorbei in den Kaminsaal."
  },
  {
   "id": "b_hana_wachs",
   "wer": "meryem",
   "text": "Kurz nach dem Scheppern roch sie frisch erloschenes Kerzenwachs. Der Geruch kam mit dem Luftzug aus Richtung Theke."
  },
  {
   "id": "b_hana_umschlag",
   "wer": "meryem",
   "text": "Kurz nach zwölf warf Ahmet etwas Raschelndes in den Ascheneimer neben dem Kamin."
  },
  {
   "id": "b_baran_rufe",
   "wer": "baran",
   "text": "Aus Richtung Theke hörte er erst „Hab ich dich!“, dann „Stehen bleiben!“, dann das Scheppern."
  },
  {
   "id": "b_serkan_tor",
   "wer": "serkan",
   "text": "Von kurz vor zwölf bis nach zwölf stand er am Außentor. Es war abgeschlossen; niemand ist hinaus."
  },
  {
   "id": "b_wojtek_olli_satz",
   "wer": "kaan",
   "text": "Um 23:52 sagte Olli: „Ich hol dir Eis. Und dann red ich mit Schneider.“"
  },
  {
   "id": "b_wojtek_vorbei",
   "wer": "kaan",
   "text": "Im Dunkeln drängte sich jemand an ihm vorbei durch die Bogentür in den Turm."
  },
  {
   "id": "b_pawel_schneider",
   "wer": "hakan",
   "text": "Herr Schneider muss jeden Schaden der Stiftung melden und zahlt kleine Schäden oft aus eigener Tasche. Darum ist er beim Geld so streng."
  },
  {
   "id": "b_aylin_quittung",
   "wer": "aylin",
   "text": "Sie hat Herrn Schneiders Quittungszettel: „Miete: 0 Euro.“"
  },
  {
   "id": "b_tugba_notiz",
   "wer": "tugba",
   "text": "Um 23:57 hat sie notiert, wer für die Torte fehlt und wo die Leute nach eigener Auskunft gerade sind."
  }
 ]
}

SCHNITTSTELLEN:
Datei content/party/schlosskeller/texte/gespraeche-r2-b4.json, Feld eintraege: genau 12 Objekte (je Rolle nr 1, 2, 3) nach Schema texte-gespraech, z. B.:
{
 "id": "g_serkan_2_1",
 "rolle": "serkan",
 "runde": 2,
 "nr": 1,
 "partner": "<rollen-id oder detective>",
 "thema": "…",
 "ziel": "…",
 "preisgabe": [
  "beobachtung:<eigene Pflichtgespräch-Beobachtung>",
  "luege:<eigene Lüge>"
 ],
 "text": "Ein bis drei Sätze Gesprächseröffnung …"
}
- id: g_<rolle>_2_<nr>.
- partner: eine Rolle aus alleRollen oder detective, nie die Rolle selbst. Die drei Partner einer Rolle in dieser Runde sind verschieden. Bevorzuge Partner mit kleinem besetzungsplatz (die sind auch bei wenigen Spielenden besetzt) und Partner, die zum Thema etwas wissen können (öffentliche Beobachtungen). Fehlt ein Partner am Abend, springt automatisch ein Ersatz ein.
- thema: kurz („Wo warst du beim Knall?“). ziel: was die Rolle aus dem Gespräch herausholen will (1 Satz).
- preisgabe: was die Rolle in diesem Gespräch preisgeben MUSS – nur eigene Beobachtungen mit Kanal pflichtgespraech (beobachtung:<id>) oder die Behauptung einer eigenen Lüge (luege:<id>). Darf leer sein. NIE Nebendelikte, verborgene Beobachtungen, Spuren oder Zeitleiste.
- text: 1–3 Sätze in der Ich- oder Du-Form, wie die Rolle das Gespräch eröffnet. Der Text verrät nichts, was die Rolle verbirgt (Nebendelikt, verborgene Beobachtungen, Wahrheit hinter ihren Lügen), und keine Tatsache außer denen aus preisgabe und dem Auszug.
- Jede eigene Pflichtgespräch-Beobachtung einer Rolle kommt über die drei Runden mindestens einmal vor. In dieser Runde soll jede Rolle mindestens ein Gespräch mit Preisgabe haben, wenn sie überhaupt etwas preiszugeben hat.

EIGENE DATEIEN: content/party/schlosskeller/texte/gespraeche-r2-b4.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN, SCHLUESSEL.md (Regeln für Pflichtgespräche) und den Auszug.
2. Schreibe die 12 Gespräche.
3. Prüfe mit python3 -m json.tool und dart test test/party/texte_test.dart (P-1 wird dort maschinell geprüft).

ABNAHMEKRITERIEN UND TESTWEG: Genau 12 Gespräche, je Rolle 3 mit verschiedenen Partnern; texte_test grün; keine verborgene Tatsache im Text.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-19
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Partner je Rolle: <Rolle: Liste>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-19 · BEREIT ZUR RÜCKGABE ===

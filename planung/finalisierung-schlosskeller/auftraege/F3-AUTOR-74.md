F3-AUTOR-74 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Überarbeite die 36 Pflichtgespräche der Rollen Damir (enes), Sibel (selin), Pawel (hakan), Tugba (tugba) in allen drei Runden, damit sie partnerneutral sind und nur eigenes Wissen nutzen (Regeln P-2 bis P-4).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
{
 "wasAlleWissen": "Ein altes Schloss, etwas abgelegen vor der Stadt. Heute Abend wird hier Geburtstag gefeiert, und zwar im großen Gewölbekeller unter dem Schlossturm. Der Wind pfeift durch die Lichtschächte, und schwere Holztüren quietschen im Luftzug. Gruselig, aber gemütlich. Das Buffet ist eröffnet: warmes Essen, Brot, Dips und Gebäck. Kurz vor Mitternacht knallt es, dann ist es stockdunkel. Herr Schneider liegt bewusstlos im Vorratsraum gleich hinter der Tür. Der Schlüsselbund ist weg, und das Außentor ist zu. Hinter den dicken Mauern gibt es keinen Handyempfang, und ihr sitzt bis zum Morgen fest.",
 "rundenfragen": {
  "1": "Runde 1 · Alibis: wer war wo, was hat man gesehen oder gehört",
  "2": "Runde 2 · Widersprüche: Behauptungen auf die Probe stellen, nach auffälligem Verhalten fragen",
  "3": "Runde 3 · Gegenüberstellung: Verbündete suchen, auf Klarheit drängen, einen Freund schützen"
 },
 "kernrollen (dürfen angesprochen werden)": [
  {
   "id": "ahmet",
   "name": "Ahmet"
  },
  {
   "id": "fatma",
   "name": "Fatma"
  },
  {
   "id": "olli",
   "name": "Olli"
  },
  {
   "id": "can",
   "name": "Can"
  }
 ],
 "ersetzbareRollen (NIE nennen, nichts zuschreiben)": [
  {
   "id": "leyla",
   "name": "Lejla"
  },
  {
   "id": "emine",
   "name": "Emine"
  },
  {
   "id": "tim",
   "name": "Tim"
  },
  {
   "id": "johanna",
   "name": "Joanna"
  },
  {
   "id": "murat",
   "name": "Marek"
  },
  {
   "id": "zeynep",
   "name": "Zeynep"
  },
  {
   "id": "baran",
   "name": "Baran"
  },
  {
   "id": "meryem",
   "name": "Hana"
  },
  {
   "id": "serkan",
   "name": "Serkan"
  },
  {
   "id": "aylin",
   "name": "Aylin"
  },
  {
   "id": "kaan",
   "name": "Wojtek"
  },
  {
   "id": "dilara",
   "name": "Azra"
  },
  {
   "id": "enes",
   "name": "Damir"
  },
  {
   "id": "selin",
   "name": "Sibel"
  },
  {
   "id": "hakan",
   "name": "Pawel"
  },
  {
   "id": "tugba",
   "name": "Tugba"
  }
 ],
 "deineRollen": [
  {
   "figur": {
    "id": "enes",
    "name": "Damir",
    "roleTitle": "Der Teemeister",
    "alltag": "Ist Erzieher und kocht für alle Tee, ob sie wollen oder nicht.",
    "persoenlichesZiel": "Sein Ärger mit Herrn Schneider über das Teegeschirr soll nicht zur Sprache kommen.",
    "loyalitaet": null,
    "startRoom": "thekensaal"
   },
   "eigeneLuegen": [],
   "eigenePflichtgespraechBeobachtungen": [
    {
     "id": "b_damir_an_der_theke",
     "text": "Um 23:57 standen Ahmet, Fatma und Olli an der Theke, Herr Schneider am Ostende. Can war nicht zu sehen."
    }
   ],
   "vorstellung (dossier.wer, öffentlich)": "Du bist Damir, der Teemeister. Du arbeitest in der Kinderbetreuung und kochst für alle Tee, ob sie wollen oder nicht. Du bist aufmerksam und hast flinke Hände. Man erkennt dich an deinem weißen Hemd mit hochgekrempelten Ärmeln und an der schwarzen Schürze."
  },
  {
   "figur": {
    "id": "selin",
    "name": "Sibel",
    "roleTitle": "Die Vorsichtige",
    "alltag": "Studiert Biologie und fürchtet sich vor nichts außer alten Rüstungen.",
    "persoenlichesZiel": "Die Rüstung soll aus dem Turmgang verschwinden.",
    "loyalitaet": null,
    "startRoom": "west_saal"
   },
   "eigeneLuegen": [],
   "eigenePflichtgespraechBeobachtungen": [
    {
     "id": "b_selin_gesicht",
     "text": "Im Dunkeln huschte ein leuchtendes Gesicht quer durch den Kaminsaal zur Bogentür."
    }
   ],
   "vorstellung (dossier.wer, öffentlich)": "Du bist Sibel, die Vorsichtige. Du studierst Biologie und fürchtest dich vor nichts außer alten Rüstungen. Du bist auf der Geburtstagsfeier dabei und ziehst bei lauten Geräuschen oft die Schultern hoch. Man erkennt dich an dem weißen Fransenschal, den du dir bis übers Kinn ziehst."
  },
  {
   "figur": {
    "id": "hakan",
    "name": "Pawel",
    "roleTitle": "Der Vermittler",
    "alltag": "Ist Rechtsreferendar und schlichtet seit der Schulzeit jeden Streit.",
    "persoenlichesZiel": "Herrn Schneider in Schutz nehmen, ohne seine Geldsorgen auszuplaudern.",
    "loyalitaet": null,
    "startRoom": "ost_saal"
   },
   "eigeneLuegen": [],
   "eigenePflichtgespraechBeobachtungen": [
    {
     "id": "b_pawel_schneider",
     "text": "Herr Schneider muss jeden Schaden der Stiftung melden und zahlt kleine Schäden oft aus eigener Tasche. Darum ist er beim Geld so streng."
    }
   ],
   "vorstellung (dossier.wer, öffentlich)": "Du bist Pawel, der Vermittler. Du machst gerade dein Referendariat in Jura und schlichtest seit der Schulzeit jeden Streit. Du sitzt ruhig und aufrecht am Tisch und beobachtest die Gruppe. Man erkennt dich an deiner schokobraunen Steppjacke, der dunkelbraunen Ledertasche neben dir und deiner Teetasse."
  },
  {
   "figur": {
    "id": "tugba",
    "name": "Tugba",
    "roleTitle": "Die Geburtstags-Planerin",
    "alltag": "Ist Projektleiterin und plant sogar Geburtstage mit Ablaufplan.",
    "persoenlichesZiel": "Den Abend retten: Torte um halb eins, egal was passiert.",
    "loyalitaet": null,
    "startRoom": "ost_saal"
   },
   "eigeneLuegen": [],
   "eigenePflichtgespraechBeobachtungen": [
    {
     "id": "b_tugba_notiz",
     "text": "Um 23:57 hat sie notiert, wer für die Torte fehlt und wo die Leute nach eigener Auskunft gerade sind."
    }
   ],
   "vorstellung (dossier.wer, öffentlich)": "Du bist Tugba, die Geburtstags-Planerin. Du leitest Projekte bei der Arbeit und planst sogar Geburtstage mit Ablaufplan. Den Ablaufplan für diesen Abend hast du geschrieben. Man erkennt dich an deinem bordeauxroten Jackett, der schmalen Metallbrille und dem Notizbuch mit goldenem Einband."
  }
 ]
}

SCHNITTSTELLEN:
Deine drei Dateien: content/party/schlosskeller/texte/gespraeche-r1-b5.json, content/party/schlosskeller/texte/gespraeche-r2-b5.json, content/party/schlosskeller/texte/gespraeche-r3-b5.json. Jede hat 12 Einträge nach Schema texte-gespraech. Die Felder id, rolle, runde, nr, partner und preisgabe sind FEST und bleiben unverändert (der Orchestrator hat die Partner neu verteilt, damit niemand mehr als 7 Gespräche je Runde hat). Du änderst NUR thema, ziel und text.
NEUE REGELN (stehen auch in SCHLUESSEL.md, Abschnitt „Regeln für Pflichtgespräche“):
- P-2, partnerneutral: Ist der Partner eine ersetzbare Rolle (alles außer ahmet, fatma, olli, can und detective), springt bei kleiner Besetzung jemand anderes ein. Deshalb nennen thema, ziel und text den Partner NICHT, auch nicht als Anrede („Lejla, …“ ist verboten), und schreiben ihm nichts zu: keinen Beruf („du bist doch die Fotografin“), keinen Ort („du standest am Sicherungskasten“), keine Verwandtschaft („du bist meine Schwester“), keine Beobachtung („du hast doch was Leuchtendes gesehen“). Der Text muss mit JEDEM Gast funktionieren. Die App zeigt den Namen des tatsächlichen Partners auf der Karte. Ist der Partner eine Kernrolle (ahmet, fatma, olli, can), darfst du ihn mit Namen ansprechen. Den Detektiv sprichst du mit „du“ an, ohne Namen.
- P-3, eigenes Wissen: Der Text nutzt nur die eigene preisgabe (Kern der Beobachtung oder die BEHAUPTUNG der Lüge, nie ihre Wahrheit), die eigene Vorstellung und was alle wissen (wasAlleWissen). Nie Beobachtungen anderer Rollen („Wojtek hat erzählt …“, „Tim hat ein Gesicht gesehen“), nie etwas, das eine Rolle verbirgt. Fragen an den Partner sind immer erlaubt („Wo warst du beim Knall?“, „Hast du Ahmet gesehen?“).
- P-4, Abwechslung: Kein Text wiederholt einen anderen wortgleich, auch nicht über die Runden. Jede Runde klingt nach ihrer Rundenfrage.
- Steht etwas in preisgabe, bringt der Text dessen Kern zur Sprache. Ist preisgabe leer, eröffnet der Text mit einer Frage oder einer eigenen Haltung aus persoenlichesZiel oder loyalitaet, ohne neue Tatsache.
- thema: kurze Frage oder Stichwort, partnerneutral. ziel: ein Ich-Satz, was die Rolle herausfinden oder erreichen will, partnerneutral.

EIGENE DATEIEN: content/party/schlosskeller/texte/gespraeche-r1-b5.json, content/party/schlosskeller/texte/gespraeche-r2-b5.json, content/party/schlosskeller/texte/gespraeche-r3-b5.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN, SCHLUESSEL.md (ganz, besonders P-1 bis P-4) und den Auszug.
2. Lies deine drei Dateien. Gehe jedes der 36 Gespräche durch und schreibe thema, ziel und text neu, wo eine Regel verletzt ist. Was schon passt, darf bleiben.
3. Prüfe: python3 -m json.tool <datei> > /dev/null für alle drei; dann dart test test/party/texte_test.dart 2>&1 | grep "(P-2)" | grep -E "g_(enes|selin|hakan|tugba)_" muss LEER sein (Befunde anderer Rollen sind nicht deine Aufgabe; der Test als Ganzes bleibt rot, bis alle fünf Überarbeitungen fertig sind). Prüfe außerdem selbst mit grep, dass keiner der Namen aus ersetzbareRollen in deinen thema-, ziel- oder text-Feldern steht, wenn der partner des Eintrags eine ersetzbare Rolle ist.
4. Prüfe den Ton: dart run bin/party_texte.dart 2>&1 | grep -E "gespraeche-r[123]-b5" muss leer sein.

ABNAHMEKRITERIEN UND TESTWEG: 36 Gespräche; id, rolle, runde, nr, partner und preisgabe unverändert; keine P-2-Befunde für deine Rollen; kein Text nutzt fremdes Wissen; Textprüfer ohne Befund für deine Dateien.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-74
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Geänderte Gespräche: <Zahl> von 36
- Beispiele vorher/nachher: <zwei Paare>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-74 · BEREIT ZUR RÜCKGABE ===

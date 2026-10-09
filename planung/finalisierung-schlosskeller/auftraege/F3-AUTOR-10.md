F3-AUTOR-10 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe den Detektiv-Bogen für das Geburtstagskind in m- und w-Fassung und den Ermittlungsbogen mit den Regeln zum Ausschluss.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
{
 "detektiv": {
  "id": "detective",
  "title": "Der Detektiv / Die Detektivin (Geburtstagskind)",
  "selectableGenders": [
   "m",
   "w"
  ],
  "colorCode": "#B8A48A",
  "farbname": "Sandbeige",
  "startRoom": "ost_saal",
  "ermittlungsOrt": "geburtstagsplatz",
  "coordinates": {
   "x": 24.5,
   "y": 16.5
  },
  "visualSpecs": {
   "silhouette": "Mittelgroß, aufmerksame Haltung, Kopf leicht schief beim Zuhören",
   "baseOutfit": "Heller sandbeiger Trenchcoat über Alltagskleidung, schwarze Jeans, dunkle Turnschuhe",
   "accessories": [
    "Markante Brille",
    "Braun karierter Detektivhut",
    "Unangezündete Pfeife, aus der Seifenblasen steigen"
   ],
   "interactiveTool": "Handy in der Hand mit Taschenlampen-Lichtkegel",
   "idleAnimation": "Bläst mit der Pfeife ein paar Seifenblasen und tippt aufs Handy"
  },
  "tatnacht": "Ab 23:55 sitzt das Geburtstagskind mit verbundenen Augen und Kopfhörern im Ost-Saal auf dem Ehrenplatz. Die Musik läuft laut. Durch die Musik hört es nur den Knall, Herrn Schneiders lauten Ruf „Hab ich dich!“ und später ein Scheppern.",
  "auftrag": "Um 0:20 bittet Herr Schneider das Geburtstagskind: „Finde raus, wer das war. Bis zum Morgen.“",
  "nieVerdaechtig": true,
  "look": {
   "haut": "#d9a983",
   "haar": "#4a3222",
   "kopf": "detektivhut",
   "statur": "normal",
   "schnitt": "suit"
  }
 },
 "regeln": [
  {
   "id": "R-ENTLASTET",
   "wenn": [
    "alibi",
    "nebendelikt"
   ],
   "folge": "entlastet",
   "text": "Wer beim Scheppern nachweislich woanders war und wessen Heimlichtuerei belegt ist, scheidet aus."
  },
  {
   "id": "R-UEBERFUEHRT",
   "wenn": [
    "schluesselbeweis",
    "fundort"
   ],
   "folge": "ueberfuehrt",
   "text": "Ein Schlüsselbeweis überführt eine Person, wenn auch Herrn Schneiders Schlüsselbund an ihrem Versteck gefunden ist. Alle anderen scheiden aus."
  }
 ],
 "runden": [
  {
   "nr": 1,
   "name": "Das Alibi-Geflecht",
   "uhrzeit": "00:30",
   "kern": "Alle vier Kernverdächtigen haben gute Gründe, nahe der Theke gewesen zu sein."
  },
  {
   "nr": 2,
   "name": "Die Indizien-Filterung",
   "uhrzeit": "01:15",
   "kern": "Nebendelikte werden von echter Gewalt getrennt."
  },
  {
   "nr": 3,
   "name": "Die finale Gegenüberstellung",
   "uhrzeit": "02:00",
   "kern": "Bei gutem Spiel stehen zwei Restverdächtige dem Schlüsselbeweis gegenüber."
  }
 ],
 "enden": [
  {
   "id": "ende_meister",
   "name": "Meister-Detektiv",
   "anklage": "richtig",
   "punkteVon": 7,
   "punkteBis": 9
  },
  {
   "id": "ende_teilerfolg",
   "name": "Teilerfolg",
   "anklage": "richtig",
   "punkteVon": 0,
   "punkteBis": 6
  },
  {
   "id": "ende_justizirrtum",
   "name": "Justizirrtum",
   "anklage": "falsch",
   "punkteVon": 4,
   "punkteBis": 9
  },
  {
   "id": "ende_eskalation",
   "name": "Totale Eskalation",
   "anklage": "falsch",
   "punkteVon": 0,
   "punkteBis": 3
  }
 ],
 "fallRegeln": {
  "W-1": "Ein wahrer Bonus-Hinweis liefert einen wahren Baustein, entlastet aber nie allein einen Kernverdächtigen.",
  "S-1": "Resümees nur aus dem Wissen des Detektivs; bei nur einer Restperson kein Name.",
  "D-1": "Optionen mit 0 Punkten zeigen weder Schlüsselbeweis noch Zusatzindiz.",
  "G-1": "Die Option B der Täterrolle (Sabotage) zählt netto −1. Vor der Auflösung wird weder die Qualität des Hinweises noch die Stimmenzahl gezeigt (E-025).",
  "K-1": "Objekte, Marker und Licht auf der Karte sind vor dem Finale in allen Pfaden gleich.",
  "P-1": "Pflichtgespräche geben nur pfadneutrales Wissen preis."
 }
}

SCHNITTSTELLEN:
Datei content/party/schlosskeller/texte/detektiv.json, Feld eintraege: Objekte {"id": "<schlüssel>", "text": "…"} nach Schema texte-bausteine. Schlüssel genau diese:
detektiv.m.wer, detektiv.w.wer (Vorstellung, 2–3 Sätze, Du-Form, Optik aus dem Auszug; m und w unterscheiden sich nur in Anrede und Kleidung, falls nötig),
detektiv.m.auftrag, detektiv.w.auftrag (2–4 Sätze: du ermittelst bis zum Morgen, neun Entscheidungen in drei Runden, am Ende eine Anklage),
detektiv.regeln.entscheidungen (wie eine Entscheidung funktioniert: Ort betreten, Gegenstand untersuchen, Person befragen; nur eine Option je Entscheidung),
detektiv.regeln.punkte (jede gute Entscheidung bringt einen Punkt; die Zahl siehst du erst am Ende),
detektiv.regeln.hinweise (die Runde flüstert dir je Runde etwas zu; ob es stimmt, musst du selbst prüfen),
detektiv.regeln.anklage (Anklage gegen einen der vier: Ahmet, Fatma, Olli, Can),
ermittlungsbogen.einleitung, ermittlungsbogen.entlastet (Regel R-ENTLASTET in Alltagssprache), ermittlungsbogen.ueberfuehrt (Regel R-UEBERFUEHRT in Alltagssprache), ermittlungsbogen.restverdaechtige (wie man die Liste führt).
Keine Hinweise darauf, wer Täter ist; keine Fakten über die Tatnacht außer dem, was im Intro alle erfahren (Knall, Dunkelheit, Herr Schneider liegt bewusstlos im Vorratsraum gleich hinter der Tür, der Bund ist weg).

EIGENE DATEIEN: content/party/schlosskeller/texte/detektiv.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN und SCHLUESSEL.md.
2. Schreibe die 13 Einträge.
3. Prüfe mit python3 -m json.tool und dart test test/party/texte_test.dart.

ABNAHMEKRITERIEN UND TESTWEG: Genau 13 Einträge mit den genannten Schlüsseln; texte_test grün; keine Spoiler.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-10
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Schlüssel: <Liste>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-10 · BEREIT ZUR RÜCKGABE ===

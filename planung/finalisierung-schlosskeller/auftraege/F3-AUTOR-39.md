F3-AUTOR-39 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Erzählerbausteine für Rundenbeginn, Hinweis-Rahmen, Zwischenresümees und Anklage.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
{
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
 "kernverdaechtige": {
  "ahmet": "Ahmet",
  "fatma": "Fatma",
  "olli": "Olli",
  "can": "Can"
 },
 "regelS1": "Resümees nur aus dem Wissen des Detektivs; bei nur einer Restperson kein Name.",
 "regelG1": "Die Option B der Täterrolle (Sabotage) zählt netto −1. Vor der Auflösung wird weder die Qualität des Hinweises noch die Stimmenzahl gezeigt (E-025).",
 "restSchluessel": [
  "resuemee.rest.ahmet_fatma_olli",
  "resuemee.rest.ahmet_fatma_can",
  "resuemee.rest.ahmet_olli_can",
  "resuemee.rest.fatma_olli_can",
  "resuemee.rest.ahmet_fatma",
  "resuemee.rest.ahmet_olli",
  "resuemee.rest.ahmet_can",
  "resuemee.rest.fatma_olli",
  "resuemee.rest.fatma_can",
  "resuemee.rest.olli_can"
 ]
}

SCHNITTSTELLEN:
Datei content/party/schlosskeller/texte/erzaehler-runden.json, Feld eintraege: Objekte {"id","text"} (Schema texte-bausteine), genau diese 29 Schlüssel:
- runde.1.start, runde.2.start, runde.3.start: 3–5 Sätze Vorlesetext. Weltuhr in Worten (halb eins, Viertel nach eins, zwei Uhr), Stimmung im Keller, Name und Kern der Runde aus dem Auszug. Kein Hinweis auf Täter.
- bonus.rahmen: 1–2 Sätze, die JEDEN Hinweis einleiten („Aus der Runde wird dir zugeflüstert …“). Nie sagen, ob er stimmt.
- resuemee.gruppe.1, .2, .3: 1–2 Sätze. Die Runde hat dem Detektiv etwas zugeflüstert; ob es stimmt, muss der Detektiv prüfen. Keine Wertung, keine Zahl.
- resuemee.rest.alle: alle vier sind noch verdächtig. resuemee.rest.eins: nur noch eine Person ist übrig, OHNE Namen („Die Spuren haben sich gelichtet – jetzt liegt es an dir.“). Die 10 Schlüssel aus restSchluessel (z. B. resuemee.rest.ahmet_fatma_can): nennt genau die Namen im Schlüssel als noch verdächtig, 1–2 Sätze, sonst nichts.
- resuemee.lage.<runde>.offen, .spur, .klar für Runde 1–3 (9 Schlüssel): offen = noch keine Spur gegen jemanden; spur = es gibt erste Spuren; klar = ein Schlüsselbeweis liegt vor. 1–2 Sätze, ohne Namen.
- anklage.start: 3–4 Sätze. Die Nacht ist fast vorbei, der Detektiv klagt eine der vier Personen an.
Alle Texte sind Vorlesetexte: Uhrzeiten in Worten, keine Ziffern, keine Klammern, keine Abkürzungen.

EIGENE DATEIEN: content/party/schlosskeller/texte/erzaehler-runden.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN und SCHLUESSEL.md.
2. Schreibe die 29 Einträge.
3. Prüfe mit python3 -m json.tool und dart test test/party/texte_test.dart.

ABNAHMEKRITERIEN UND TESTWEG: Genau 29 Einträge; S-1 eingehalten (resuemee.rest.eins ohne Namen); texte_test grün.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-39
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Schlüssel: <Zahl>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-39 · BEREIT ZUR RÜCKGABE ===

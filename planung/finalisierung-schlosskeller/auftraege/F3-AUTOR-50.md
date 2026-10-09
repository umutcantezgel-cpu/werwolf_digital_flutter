F3-AUTOR-50 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 1

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schlage Fassung 2 der Fundtexte für Schlüsselbeweise, Zusatzindizien und Fundorte vor (Varianten-Regel).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
[
 {
  "gegenstand": "kerzenstaender",
  "spur": "spur_griff_papier",
  "rolle": {
   "ahmet": "schluesselbeweis"
  },
  "zeigt": "Im erstarrten Wachs am Griff klebt eine abgerissene Ecke braunes Umschlagpapier. Darauf steht „…keller“, in Ahmets Handschrift.",
  "harmlos": "Der Griff ist mit rotem Wachs verschmiert."
 },
 {
  "gegenstand": "kerzenstaender",
  "spur": "spur_griff_leuchtfarbe",
  "rolle": {
   "can": "schluesselbeweis"
  },
  "zeigt": "Um den Griff liegt der Abdruck einer ganzen Hand in grünlich-weißer Leuchtfarbe, derselben Farbe wie auf der Maske.",
  "harmlos": "Der Griff ist mit rotem Wachs verschmiert."
 },
 {
  "gegenstand": "kerzenstaender",
  "spur": "spur_fuss_splitter",
  "rolle": {
   "olli": "schluesselbeweis"
  },
  "zeigt": "Im roten Wachs am Fuß, das inzwischen erstarrt ist, kleben feine Holzsplitter und weißer Kalk.",
  "harmlos": "Am Fuß klebt rotes Wachs."
 },
 {
  "gegenstand": "silberring_fatma",
  "spur": "spur_ring_messing",
  "rolle": {
   "fatma": "schluesselbeweis"
  },
  "zeigt": "Frischer goldgelber Messingabrieb in einer Kerbe des Rings.",
  "harmlos": "Nur feine Kratzer von der Glasscheibe der Vitrine, kein Messing."
 },
 {
  "gegenstand": "jacke_ahmet",
  "spur": "spur_jacke_bund",
  "rolle": {
   "ahmet": "fundort"
  },
  "zeigt": "In der Innentasche steckt Herrn Schneiders großer Schlüsselbund.",
  "harmlos": "Die Innentasche ist leer bis auf ein Kaugummipapier."
 },
 {
  "gegenstand": "umschlag_mietgeld",
  "spur": "spur_umschlag_wachs",
  "rolle": {
   "ahmet": "zusatzindiz"
  },
  "zeigt": "Drei erstarrte rote Wachstropfen. Eine Ecke des Umschlags ist abgerissen.",
  "harmlos": "Kein Wachs, nur ein Knick."
 },
 {
  "gegenstand": "muenzschatulle",
  "spur": "spur_schatulle_wachs",
  "rolle": {
   "fatma": "zusatzindiz"
  },
  "zeigt": "Auf dem Deckel kleben rote Wachstropfen.",
  "harmlos": "Der Deckel ist sauber."
 },
 {
  "gegenstand": "leuchtmaske",
  "spur": "spur_maske_wachs",
  "rolle": {
   "can": "zusatzindiz"
  },
  "zeigt": "Rote Wachstropfen auf der Stirn der Maske.",
  "harmlos": "Kein Wachs, nur Leuchtfarbe."
 },
 {
  "gegenstand": "eiskuebel",
  "spur": "spur_eiskuebel_bund",
  "rolle": {
   "olli": "fundort"
  },
  "zeigt": "Unter den Eiswürfeln liegt Herrn Schneiders Schlüsselbund.",
  "harmlos": "Nur Eis und Schmelzwasser."
 },
 {
  "gegenstand": "brottasche",
  "spur": "spur_brottasche_bund",
  "rolle": {
   "fatma": "fundort"
  },
  "zeigt": "Unter dem Brot liegt Herrn Schneiders Schlüsselbund.",
  "harmlos": "Nur Brot und Krümel."
 },
 {
  "gegenstand": "ruestungshelm",
  "spur": "spur_helm_bund",
  "rolle": {
   "can": "fundort"
  },
  "zeigt": "Im Helm klemmt Herrn Schneiders Schlüsselbund.",
  "harmlos": "Im Helm nur Staub und eine alte Spinnwebe."
 },
 {
  "gegenstand": "handschuh_weste_olli",
  "spur": "spur_weste_kerzenwachs",
  "rolle": {
   "olli": "zusatzindiz"
  },
  "zeigt": "Auf dem Handrücken kleben frische rote Kerzenwachstropfen.",
  "harmlos": "Kein rotes Wachs, nur Kalkstaub."
 }
]

SCHNITTSTELLEN:
Keine Datei. Deine Rückgabe enthält eine Tabelle | spur | zeigt (neu) | harmlos (neu) | Begründung | für alle 12 Spuren aus dem Auszug.
- zeigt: was der Detektiv findet, 1–2 Sätze, anschaulich, eindeutig, ohne neue Tatsache (Ort, Gegenstand, Material wie im Auszug).
- harmlos: was der Detektiv in anderen Pfaden an derselben Stelle findet, 1 Satz, NEUTRAL (kein „kein Blut“, kein „ohne Farbe“, nichts, was eine Person ausschließt).
- VORGABE DIESER FASSUNG: mit einem kleinen Gruselmoment für das Geburtstagskind.

EIGENE DATEIEN: keine (nur Rückgabe)

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN und den Auszug.
2. Schreibe die Tabelle.

ABNAHMEKRITERIEN UND TESTWEG: Alle 12 Spuren; keine neue Tatsache; harmlose Fassungen neutral.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-50
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>

## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-50 · BEREIT ZUR RÜCKGABE ===

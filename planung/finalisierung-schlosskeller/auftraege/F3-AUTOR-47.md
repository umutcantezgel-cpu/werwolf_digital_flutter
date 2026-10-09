F3-AUTOR-47 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Auflösung: wie oft die Gruppe zusammengehalten hat und für jede Rolle, was sie verborgen hat.

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
[
 {
  "id": "ahmet",
  "name": "Ahmet",
  "persoenlichesZiel": "Niemand soll vor dem Morgen erfahren, dass die Miete erfunden war.",
  "loyalitaet": {
   "zu": "leyla",
   "grund": "Sie sind zusammen aufgewachsen und halten zusammen."
  },
  "nebendelikt": {
   "id": "nd_mietgeld",
   "text": "Hat von allen 150 € Miete kassiert, obwohl der Keller nichts gekostet hat."
  },
  "verborgen": [],
  "innocentProfile": {
   "actualBehavior": "Duckt sich beim Knall hinter der Theke am Ostende neben Damir und hält den Umschlag fest. Er bleibt dort, bis das Licht angeht. Später leert er den Umschlag und wirft ihn in den Ascheneimer am Kamin."
  },
  "killerProfile": {
   "crimeExecution": "Er kauert erst am Ostende der Theke neben Damir. Dann geht er zum Kerzenlicht an der Anrichte, um Herrn Schneider zu bitten. Herr Schneider, noch außer sich wegen Can, packt ihn am Arm und zischt: „Um zwölf erfahren's alle.“ In Panik greift Ahmet mit der Hand, in der er den Umschlag hält, den Kerzenständer und schlägt einmal zu. Heißes Wachs tropft auf den Umschlag, eine Ecke reißt ab und bleibt am Griff kleben. In Panik reißt er den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt er, dass Flucht alles schlimmer macht. Er steckt den Bund im Ost-Saal in seine eigene Jacke und kauert sich wieder neben Damir."
  }
 },
 {
  "id": "fatma",
  "name": "Fatma",
  "persoenlichesZiel": "Die Schatulle soll zurück, ohne dass es alle erfahren.",
  "loyalitaet": {
   "zu": "emine",
   "grund": "Emine ist seit der Schulzeit ihre beste Freundin."
  },
  "nebendelikt": {
   "id": "nd_schatulle",
   "text": "Hat die Münzschatulle aus der Turmvitrine mitgenommen."
  },
  "verborgen": [],
  "innocentProfile": {
   "actualBehavior": "Beim Knall zieht sie sich mit der Tasche zum linken Buffettisch zurück und kauert dort gleich danach neben Emine."
  },
  "killerProfile": {
   "crimeExecution": "Beim Knall bleibt sie erschrocken vor der Theke stehen. Dann sieht sie das Kerzenlicht an der Anrichte und geht durch die Klappe hin, um die Schatulle sofort zurückzugeben. Herr Schneider packt den Gurt ihrer Tasche und zischt: „Zu spät. Die Polizei kommt so oder so.“ In Panik greift sie den Kerzenständer und schlägt einmal zu. In Panik reißt sie den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt sie, dass Flucht alles schlimmer macht. Sie steckt ihn in die Brottasche auf dem linken Buffettisch und kauert sich zu Emine."
  }
 },
 {
  "id": "olli",
  "name": "Olli",
  "persoenlichesZiel": "Den Türschaden selbst mit Herrn Schneider klären, ohne die Gruppe hineinzuziehen.",
  "loyalitaet": {
   "zu": "kaan",
   "grund": "Wojtek hat ihm beim Tragen geholfen und hält zu ihm."
  },
  "nebendelikt": {
   "id": "nd_tuerschaden",
   "text": "Hat die Bogentür beschädigt und wollte die Schramme mit Möbelwachs verdecken."
  },
  "verborgen": [],
  "innocentProfile": {
   "actualBehavior": "Beim Knall tastet er sich vom Eiskübel zum rechten Buffettisch und kauert dort gleich danach neben Azra, bis das Licht angeht. Dann bringt er Wojtek das Eis und setzt sich in den Ost-Saal an die Tafel."
  },
  "killerProfile": {
   "crimeExecution": "Er bleibt erst am Eiskübel stehen. Dann geht er vor der Theke entlang und durch die Klappe zum Kerzenlicht, weil er mit Herrn Schneider reden will. Herr Schneider packt ihn am Ärmel und zischt: „Zweitausend. Sonst Polizei.“ In Panik greift Olli den Kerzenständer am Fuß und schlägt einmal zu. Rote Tropfen fallen auf den Handschuh, der aus seiner Westentasche hängt. In Panik reißt er den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt er, dass Flucht alles schlimmer macht. Er wirft ihn in den Eiskübel und kauert sich zu Azra."
  }
 },
 {
  "id": "can",
  "name": "Can",
  "persoenlichesZiel": "Der Streich soll nicht herauskommen.",
  "loyalitaet": {
   "zu": "zeynep",
   "grund": "Seine Schwester Zeynep hat für ihn Schmiere gestanden."
  },
  "nebendelikt": {
   "id": "nd_streich",
   "text": "Hat sich mit der Leuchtmaske im Vorratsraum versteckt, um das Geburtstagskind zu erschrecken."
  },
  "verborgen": [],
  "innocentProfile": {
   "actualBehavior": "Er reißt sich los und rennt durch den Durchgang, noch bevor es scheppert. Die leuchtende Maske hält er in der Hand. Im Kaminsaal rennt er zur Bogentür, stopft die Maske in die Bauchtasche seines Pullis und versteckt sich oben auf der Toilette im Turm."
  },
  "killerProfile": {
   "crimeExecution": "Herr Schneider hält ihn an der Kapuze fest und zischt: „Jetzt kommt die Polizei, Freundchen.“ In Panik greift Can mit der Hand voller Leuchtfarbe den Kerzenständer von der Anrichte und schlägt einmal zu. Herr Schneider stürzt in den Vorratsraum. Can kniet sich neben ihn und reißt in Panik den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt er, dass Flucht alles schlimmer macht. Er rennt nach dem Scheppern durch den Durchgang und den Kaminsaal, stopft an der Bogentür die Maske in die Bauchtasche, steckt den Bund in den Helm der Ritterrüstung und versteckt sich auf der Toilette im Turm."
  }
 },
 {
  "id": "leyla",
  "name": "Lejla",
  "persoenlichesZiel": "Ahmet schützen, bis er selbst redet.",
  "loyalitaet": {
   "zu": "ahmet",
   "grund": "Ahmet ist ihr Cousin; sie hat ihm versprochen, nichts über die Rechnung zu sagen."
  },
  "nebendelikt": null,
  "verborgen": []
 },
 {
  "id": "emine",
  "name": "Emine",
  "persoenlichesZiel": "Fatma nicht verraten.",
  "loyalitaet": {
   "zu": "fatma",
   "grund": "Fatma ist ihre beste Freundin; sie glaubt ihr."
  },
  "nebendelikt": null,
  "verborgen": [
   {
    "id": "b_emine_schatulle",
    "pfade": "alle",
    "text": "Um 23:40 sah sie im Turmgang, wie Fatma die Münzschatulle aus der Vitrine nahm."
   },
   {
    "id": "b_emine_fatma_frueh",
    "pfade": [
     "ahmet",
     "olli",
     "can"
    ],
    "text": "Beim Scheppern kauerte Fatma neben ihr hinter dem linken Buffettisch. Sie war schon seit dem Knall da und hatte geflüstert: „Emine? Ich bin's, Fatma.“"
   },
   {
    "id": "b_emine_fatma_spaet",
    "pfade": [
     "fatma"
    ],
    "text": "Beim Scheppern war Fatma nicht neben ihr. Sie kam erst danach und flüsterte: „Emine? Ich bin's, Fatma.“"
   }
  ]
 },
 {
  "id": "tim",
  "name": "Tim",
  "persoenlichesZiel": "Niemand soll erfahren, dass seine Mehrfachsteckdose den Ausfall verursacht hat.",
  "loyalitaet": null,
  "nebendelikt": {
   "id": "nd_kurzschluss",
   "text": "Hat trotz Warnung die alte Mehrfachsteckdose benutzt und den Kurzschluss verursacht."
  },
  "verborgen": [
   {
    "id": "b_tim_kurzschluss",
    "pfade": "alle",
    "text": "Der Kurzschluss kam von seiner alten Mehrfachsteckdose."
   }
  ]
 },
 {
  "id": "johanna",
  "name": "Joanna",
  "persoenlichesZiel": "Ihr Versprechen an Ahmet halten, ohne das Geburtstagskind anzulügen.",
  "loyalitaet": {
   "zu": "ahmet",
   "grund": "Ahmet hat sie gebeten, das Streitfoto zu löschen."
  },
  "nebendelikt": null,
  "verborgen": [
   {
    "id": "b_joanna_foto",
    "pfade": "alle",
    "text": "Sie hat ein Foto von 23:51: Herr Schneider und Ahmet streiten an der Theke, Ahmet hält einen dicken Umschlag."
   }
  ]
 },
 {
  "id": "murat",
  "name": "Marek",
  "persoenlichesZiel": "Der Lieferwagen soll nicht abgeschleppt werden.",
  "loyalitaet": null,
  "nebendelikt": {
   "id": "nd_parken",
   "text": "Hat auf Herrn Schneiders reserviertem Platz geparkt."
  },
  "verborgen": [
   {
    "id": "b_marek_vor",
    "pfade": [
     "ahmet",
     "fatma",
     "olli"
    ],
    "text": "Das leuchtende Gesicht rannte an ihm vorbei, bevor es an der Theke schepperte."
   },
   {
    "id": "b_marek_nach",
    "pfade": [
     "can"
    ],
    "text": "Das leuchtende Gesicht rannte an ihm vorbei, nachdem es an der Theke gescheppert hatte."
   }
  ]
 },
 {
  "id": "zeynep",
  "name": "Zeynep",
  "persoenlichesZiel": "Can schützen.",
  "loyalitaet": {
   "zu": "can",
   "grund": "Can ist ihr Bruder."
  },
  "nebendelikt": {
   "id": "nd_schmiere",
   "text": "Hat für Cans Streich Schmiere gestanden."
  },
  "verborgen": [
   {
    "id": "b_zeynep_vorrat",
    "pfade": "alle",
    "text": "Can hat mit der Leuchtmaske im dunklen Vorratsraum auf das Geburtstagskind gewartet."
   }
  ]
 },
 {
  "id": "baran",
  "name": "Baran",
  "persoenlichesZiel": "Seine Box soll nicht einkassiert werden.",
  "loyalitaet": null,
  "nebendelikt": null,
  "verborgen": []
 },
 {
  "id": "meryem",
  "name": "Hana",
  "persoenlichesZiel": "Den Kamin wieder zum Ziehen bringen und sich bei Herrn Schneider für den Ruß entschuldigen.",
  "loyalitaet": null,
  "nebendelikt": null,
  "verborgen": []
 },
 {
  "id": "serkan",
  "name": "Serkan",
  "persoenlichesZiel": "Alle so schnell wie möglich sicher nach Hause fahren.",
  "loyalitaet": null,
  "nebendelikt": null,
  "verborgen": []
 },
 {
  "id": "aylin",
  "name": "Aylin",
  "persoenlichesZiel": "Ihr Geld zurückbekommen, ohne Ahmet vor allen bloßzustellen.",
  "loyalitaet": null,
  "nebendelikt": null,
  "verborgen": []
 },
 {
  "id": "kaan",
  "name": "Wojtek",
  "persoenlichesZiel": "Niemand soll wissen, dass die Idee mit dem Möbelwachs von ihm kam.",
  "loyalitaet": {
   "zu": "olli",
   "grund": "Olli ist sein Kumpel vom Tragen und hat ihm Eis geholt."
  },
  "nebendelikt": {
   "id": "nd_moebelwachs",
   "text": "Hat Olli geraten, die Schramme mit Möbelwachs zu verdecken."
  },
  "verborgen": [
   {
    "id": "b_wojtek_tuer",
    "pfade": "alle",
    "text": "Er weiß: Olli hat am Abend die Bogentür beschädigt, und Herr Schneider verlangt zweitausend Euro dafür. Das Möbelwachs zum Verdecken kam von ihm."
   }
  ]
 },
 {
  "id": "dilara",
  "name": "Azra",
  "persoenlichesZiel": "Niemand soll denken, sie hätte Fatma zu etwas angestiftet.",
  "loyalitaet": null,
  "nebendelikt": null,
  "verborgen": [
   {
    "id": "b_azra_olli_frueh",
    "pfade": [
     "ahmet",
     "fatma",
     "can"
    ],
    "text": "Beim Scheppern kauerte Olli neben ihr hinter dem rechten Buffettisch. Er war schon seit dem Knall da und hatte geflüstert: „Azra? Ich bin's, Olli.“"
   },
   {
    "id": "b_azra_olli_spaet",
    "pfade": [
     "olli"
    ],
    "text": "Beim Scheppern war Olli nicht neben ihr. Er kam erst danach und flüsterte: „Azra? Ich bin's, Olli.“"
   }
  ]
 },
 {
  "id": "enes",
  "name": "Damir",
  "persoenlichesZiel": "Sein Ärger mit Herrn Schneider über das Teegeschirr soll nicht zur Sprache kommen.",
  "loyalitaet": null,
  "nebendelikt": null,
  "verborgen": [
   {
    "id": "b_damir_ahmet_blieb",
    "pfade": [
     "fatma",
     "olli",
     "can"
    ],
    "text": "Beim Scheppern kauerte Ahmet neben ihm am Ostende der Theke. Er war schon seit dem Knall da und hatte geflüstert: „Damir? Ich bin's, Ahmet.“"
   },
   {
    "id": "b_damir_ahmet_weg",
    "pfade": [
     "ahmet"
    ],
    "text": "Beim Scheppern war Ahmet nicht neben ihm. Er war kurz davor aufgestanden und kam erst danach zurück: „Damir, ich bin's wieder.“"
   }
  ]
 },
 {
  "id": "selin",
  "name": "Sibel",
  "persoenlichesZiel": "Die Rüstung soll aus dem Turmgang verschwinden.",
  "loyalitaet": null,
  "nebendelikt": null,
  "verborgen": []
 },
 {
  "id": "hakan",
  "name": "Pawel",
  "persoenlichesZiel": "Herrn Schneider in Schutz nehmen, ohne seine Geldsorgen auszuplaudern.",
  "loyalitaet": null,
  "nebendelikt": null,
  "verborgen": []
 },
 {
  "id": "tugba",
  "name": "Tugba",
  "persoenlichesZiel": "Den Abend retten: Torte um halb eins, egal was passiert.",
  "loyalitaet": null,
  "nebendelikt": null,
  "verborgen": []
 }
]

SCHNITTSTELLEN:
Datei content/party/schlosskeller/texte/erzaehler-aufloesung.json, Feld eintraege: genau 28 Objekte {"id","text"}:
- aufloesung.gruppe.0, .1, .2, .3: 1–2 Sätze, wie oft die Gruppe in den drei Runden zusammengehalten hat (0 bis 3 Mal), mit einem warmen Satz zur Freundschaft.
- aufloesung.<rolle> für die 16 Rollen ohne Kernrollen: 2–4 Sätze, was die Rolle verborgen hat und warum (Nebendelikt, verborgene Beobachtungen, Loyalität). Bei Beobachtungen mit Pfad-Liste (pfade) so formulieren, dass der Text in jedem Pfad stimmt („Sie wusste genau, wer beim Scheppern neben ihr kauerte.“), ohne den Täter zu nennen.
- aufloesung.<kernrolle>.unschuldig und aufloesung.<kernrolle>.taeter für ahmet, fatma, olli, can: unschuldig = 2–4 Sätze, was die Rolle verborgen hat (Nebendelikt, Lügen) und was sie wirklich tat. taeter = 2–4 Sätze, Geständnis der Tat in Panik, Herr Schneider geht es gut, und das Nebendelikt.
Diese Texte erscheinen erst nach dem Finale.

EIGENE DATEIEN: content/party/schlosskeller/texte/erzaehler-aufloesung.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN, SCHLUESSEL.md und den Auszug.
2. Schreibe die 28 Einträge.
3. Prüfe mit python3 -m json.tool und dart test test/party/texte_test.dart.

ABNAHMEKRITERIEN UND TESTWEG: Genau 28 Einträge; jede Tatsache aus dem Auszug; texte_test grün.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-47
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Schlüssel: <Zahl>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-47 · BEREIT ZUR RÜCKGABE ===

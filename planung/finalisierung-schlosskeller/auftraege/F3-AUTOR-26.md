F3-AUTOR-26 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Rundenwahl (Option A und B je Runde) für die Rollen Lejla (leyla), Emine (emine), Tim (tim), Joanna (johanna).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
[
 {
  "figur": {
   "id": "leyla",
   "name": "Lejla",
   "roleTitle": "Die Buffet-Chefin",
   "persoenlichesZiel": "Ahmet schützen, bis er selbst redet.",
   "loyalitaet": {
    "zu": "ahmet",
    "grund": "Ahmet ist ihr Cousin; sie hat ihm versprochen, nichts über die Rechnung zu sagen."
   },
   "motiveAndConflict": "Ahmets Cousine. Sie weiß, dass Ahmet mit der Rechnung fürs Essen in der Klemme steckt. Herr Schneider wollte am Nachmittag eine Genehmigung für das mitgebrachte Essen sehen.",
   "nebendelikt": null
  },
  "wahlen": [
   {
    "id": "gw_leyla_1",
    "rolle": "leyla",
    "runde": 1,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "persoenlichesZiel"
     },
     "nutzen": {
      "art": "gruppe"
     }
    },
    "b": {
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "ziel",
      "bezug": "persoenlichesZiel"
     }
    }
   },
   {
    "id": "gw_leyla_2",
    "rolle": "leyla",
    "runde": 2,
    "quelle": "loyalitaet",
    "a": {
     "kosten": {
      "art": "freund",
      "bezug": "ahmet"
     },
     "nutzen": {
      "art": "gruppe"
     }
    },
    "b": {
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "freund",
      "bezug": "ahmet"
     }
    }
   },
   {
    "id": "gw_leyla_3",
    "rolle": "leyla",
    "runde": 3,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "persoenlichesZiel"
     },
     "nutzen": {
      "art": "gruppe"
     }
    },
    "b": {
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "ziel",
      "bezug": "persoenlichesZiel"
     }
    }
   }
  ],
  "verborgen": []
 },
 {
  "figur": {
   "id": "emine",
   "name": "Emine",
   "roleTitle": "Die Grundschullehrerin",
   "persoenlichesZiel": "Fatma nicht verraten.",
   "loyalitaet": {
    "zu": "fatma",
    "grund": "Fatma ist ihre beste Freundin; sie glaubt ihr."
   },
   "motiveAndConflict": "Um 23:40 sah sie im Turmgang, wie Fatma die Schatulle aus der Vitrine nahm. Sie hat geschwiegen, weil Fatma versprochen hat, die Schatulle am Montag zurückzubringen.",
   "nebendelikt": null
  },
  "wahlen": [
   {
    "id": "gw_emine_1",
    "rolle": "emine",
    "runde": 1,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "persoenlichesZiel"
     },
     "nutzen": {
      "art": "gruppe"
     }
    },
    "b": {
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "ziel",
      "bezug": "persoenlichesZiel"
     }
    }
   },
   {
    "id": "gw_emine_2",
    "rolle": "emine",
    "runde": 2,
    "quelle": "loyalitaet",
    "a": {
     "kosten": {
      "art": "freund",
      "bezug": "fatma"
     },
     "nutzen": {
      "art": "gruppe"
     }
    },
    "b": {
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "freund",
      "bezug": "fatma"
     }
    }
   },
   {
    "id": "gw_emine_3",
    "rolle": "emine",
    "runde": 3,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "persoenlichesZiel"
     },
     "nutzen": {
      "art": "gruppe"
     }
    },
    "b": {
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "ziel",
      "bezug": "persoenlichesZiel"
     }
    }
   }
  ],
  "verborgen": [
   {
    "id": "b_emine_schatulle",
    "text": "Um 23:40 sah sie im Turmgang, wie Fatma die Münzschatulle aus der Vitrine nahm.",
    "grundVerborgen": "Sie hat Fatma versprochen zu schweigen."
   },
   {
    "id": "b_emine_fatma_frueh",
    "text": "Beim Scheppern kauerte Fatma neben ihr hinter dem linken Buffettisch. Sie war schon seit dem Knall da und hatte geflüstert: „Emine? Ich bin's, Fatma.“",
    "grundVerborgen": "Sie fürchtet, dass dann auch die Schatulle herauskommt."
   },
   {
    "id": "b_emine_fatma_spaet",
    "text": "Beim Scheppern war Fatma nicht neben ihr. Sie kam erst danach und flüsterte: „Emine? Ich bin's, Fatma.“",
    "grundVerborgen": "Fatma ist ihre beste Freundin."
   }
  ]
 },
 {
  "figur": {
   "id": "tim",
   "name": "Tim",
   "roleTitle": "Der Hobby-Elektriker",
   "persoenlichesZiel": "Niemand soll erfahren, dass seine Mehrfachsteckdose den Ausfall verursacht hat.",
   "loyalitaet": null,
   "motiveAndConflict": "Um 23:57:50 steckt er für den Tortenkaffee die Kaffeemaschine in seine alte Mehrfachsteckdose. Herr Schneider hatte ihn gerade davor gewarnt. Um 23:58:00 knallt es, die Hauptsicherung fliegt raus.",
   "nebendelikt": {
    "id": "nd_kurzschluss",
    "text": "Hat trotz Warnung die alte Mehrfachsteckdose benutzt und den Kurzschluss verursacht."
   }
  },
  "wahlen": [
   {
    "id": "gw_tim_1",
    "rolle": "tim",
    "runde": 1,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_kurzschluss"
     },
     "nutzen": {
      "art": "gruppe"
     }
    },
    "b": {
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "ziel",
      "bezug": "persoenlichesZiel"
     }
    }
   },
   {
    "id": "gw_tim_2",
    "rolle": "tim",
    "runde": 2,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_kurzschluss"
     },
     "nutzen": {
      "art": "gruppe"
     }
    },
    "b": {
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "ziel",
      "bezug": "persoenlichesZiel"
     }
    }
   },
   {
    "id": "gw_tim_3",
    "rolle": "tim",
    "runde": 3,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_kurzschluss"
     },
     "nutzen": {
      "art": "gruppe"
     }
    },
    "b": {
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "ziel",
      "bezug": "persoenlichesZiel"
     }
    }
   }
  ],
  "verborgen": [
   {
    "id": "b_tim_kurzschluss",
    "text": "Der Kurzschluss kam von seiner alten Mehrfachsteckdose.",
    "grundVerborgen": "Er schämt sich, weil Herr Schneider ihn gewarnt hatte."
   }
  ]
 },
 {
  "figur": {
   "id": "johanna",
   "name": "Joanna",
   "roleTitle": "Die Fotografin des Abends",
   "persoenlichesZiel": "Ihr Versprechen an Ahmet halten, ohne das Geburtstagskind anzulügen.",
   "loyalitaet": {
    "zu": "ahmet",
    "grund": "Ahmet hat sie gebeten, das Streitfoto zu löschen."
   },
   "motiveAndConflict": "Sie fotografiert den Abend für das Geburtstagskind. Um 23:55 musste ihr Handy in den Handykorb. Ahmet hat sie gebeten, ein Foto zu löschen.",
   "nebendelikt": null
  },
  "wahlen": [
   {
    "id": "gw_johanna_1",
    "rolle": "johanna",
    "runde": 1,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "persoenlichesZiel"
     },
     "nutzen": {
      "art": "gruppe"
     }
    },
    "b": {
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "ziel",
      "bezug": "persoenlichesZiel"
     }
    }
   },
   {
    "id": "gw_johanna_2",
    "rolle": "johanna",
    "runde": 2,
    "quelle": "loyalitaet",
    "a": {
     "kosten": {
      "art": "freund",
      "bezug": "ahmet"
     },
     "nutzen": {
      "art": "gruppe"
     }
    },
    "b": {
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "freund",
      "bezug": "ahmet"
     }
    }
   },
   {
    "id": "gw_johanna_3",
    "rolle": "johanna",
    "runde": 3,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "persoenlichesZiel"
     },
     "nutzen": {
      "art": "gruppe"
     }
    },
    "b": {
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "ziel",
      "bezug": "persoenlichesZiel"
     }
    }
   }
  ],
  "verborgen": [
   {
    "id": "b_joanna_foto",
    "text": "Sie hat ein Foto von 23:51: Herr Schneider und Ahmet streiten an der Theke, Ahmet hält einen dicken Umschlag.",
    "grundVerborgen": "Ahmet hat sie gebeten, das Foto zu löschen."
   }
  ]
 }
]

SCHNITTSTELLEN:
Datei content/party/schlosskeller/texte/wahlen-b2.json, Feld eintraege: genau 12 Objekte {"id": "gw_<rolle>_<runde>", "a": "…", "b": "…"} (Schema texte-wahl, KEIN Feld sabotage).
- a ist kooperativ: Die Rolle hilft dem Detektiv und zahlt dafür, was in wahlen[].a.kosten steht (geheimnis: ein Stück des eigenen Geheimnisses, bezug nennt welches; freund: der Freund aus bezug gerät ins Licht; ziel: das persönliche Ziel leidet).
- b ist eigennützig: Die Rolle schützt, was in wahlen[].b.nutzen steht.
- Je Option 1–2 Sätze in der Ich-Form („Ich erzähle dem Detektiv …“). Konkret, aber ohne neue Tatsachen. Beide Optionen sollen verlockend sein.
- Die Wahl ist geheim. Die Texte dürfen das eigene Geheimnis nennen, denn nur die Rolle liest sie.

EIGENE DATEIEN: content/party/schlosskeller/texte/wahlen-b2.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN, SCHLUESSEL.md (Regeln für die Rundenwahl) und den Auszug.
2. Schreibe die 12 Wahlen.
3. Prüfe mit python3 -m json.tool und dart test test/party/texte_test.dart.

ABNAHMEKRITERIEN UND TESTWEG: Genau 12 Einträge, Kosten und Nutzen passen zu gruppenwahl.json; texte_test grün.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-26
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Kosten je Wahl: <kurz>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-26 · BEREIT ZUR RÜCKGABE ===

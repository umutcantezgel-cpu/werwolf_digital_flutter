F3-AUTOR-29 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Rundenwahl (Option A und B je Runde) für die Rollen Damir (enes), Sibel (selin), Pawel (hakan), Tugba (tugba).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
[
 {
  "figur": {
   "id": "enes",
   "name": "Damir",
   "roleTitle": "Der Teemeister",
   "persoenlichesZiel": "Sein Ärger mit Herrn Schneider über das Teegeschirr soll nicht zur Sprache kommen.",
   "loyalitaet": null,
   "motiveAndConflict": "Er schenkt den ganzen Abend Tee aus. Herr Schneider warf ihm vor, das Teegeschirr des Schlosses ohne Erlaubnis zu benutzen.",
   "nebendelikt": null
  },
  "wahlen": [
   {
    "id": "gw_enes_1",
    "rolle": "enes",
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
    "id": "gw_enes_2",
    "rolle": "enes",
    "runde": 2,
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
    "id": "gw_enes_3",
    "rolle": "enes",
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
    "id": "b_damir_ahmet_blieb",
    "text": "Beim Scheppern kauerte Ahmet neben ihm am Ostende der Theke. Er war schon seit dem Knall da und hatte geflüstert: „Damir? Ich bin's, Ahmet.“",
    "grundVerborgen": "Er will nicht, dass sein Ärger mit Herrn Schneider zur Sprache kommt."
   },
   {
    "id": "b_damir_ahmet_weg",
    "text": "Beim Scheppern war Ahmet nicht neben ihm. Er war kurz davor aufgestanden und kam erst danach zurück: „Damir, ich bin's wieder.“",
    "grundVerborgen": "Ahmet ist ein Freund; er will ihn nicht ohne Not belasten."
   }
  ]
 },
 {
  "figur": {
   "id": "selin",
   "name": "Sibel",
   "roleTitle": "Die Vorsichtige",
   "persoenlichesZiel": "Die Rüstung soll aus dem Turmgang verschwinden.",
   "loyalitaet": null,
   "motiveAndConflict": "Um 21:00 hielt sie die Ritterrüstung im Turmgang für einen Menschen, schrie auf und stieß gegen die Vitrine. Seitdem macht sie einen Bogen um den Turmgang.",
   "nebendelikt": null
  },
  "wahlen": [
   {
    "id": "gw_selin_1",
    "rolle": "selin",
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
    "id": "gw_selin_2",
    "rolle": "selin",
    "runde": 2,
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
    "id": "gw_selin_3",
    "rolle": "selin",
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
   "id": "hakan",
   "name": "Pawel",
   "roleTitle": "Der Vermittler",
   "persoenlichesZiel": "Herrn Schneider in Schutz nehmen, ohne seine Geldsorgen auszuplaudern.",
   "loyalitaet": null,
   "motiveAndConflict": "Um 23:00 versuchte er, den Streit zwischen Herrn Schneider und Olli zu schlichten. Herr Schneider wies ihn barsch ab. Im Sommer hat Pawel bei der Schlossstiftung gejobbt.",
   "nebendelikt": null
  },
  "wahlen": [
   {
    "id": "gw_hakan_1",
    "rolle": "hakan",
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
    "id": "gw_hakan_2",
    "rolle": "hakan",
    "runde": 2,
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
    "id": "gw_hakan_3",
    "rolle": "hakan",
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
   "id": "tugba",
   "name": "Tugba",
   "roleTitle": "Die Geburtstags-Planerin",
   "persoenlichesZiel": "Den Abend retten: Torte um halb eins, egal was passiert.",
   "loyalitaet": null,
   "motiveAndConflict": "Sie hat den Ablaufplan des Abends geschrieben. Um zwölf sollte das Geburtstagskind mit verbundenen Augen zur Torte in den Vorratsraum geführt werden. Herr Schneider hatte nur widerwillig erlaubt, die Torte dort zu kühlen.",
   "nebendelikt": null
  },
  "wahlen": [
   {
    "id": "gw_tugba_1",
    "rolle": "tugba",
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
    "id": "gw_tugba_2",
    "rolle": "tugba",
    "runde": 2,
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
    "id": "gw_tugba_3",
    "rolle": "tugba",
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
 }
]

SCHNITTSTELLEN:
Datei content/party/schlosskeller/texte/wahlen-b5.json, Feld eintraege: genau 12 Objekte {"id": "gw_<rolle>_<runde>", "a": "…", "b": "…"} (Schema texte-wahl, KEIN Feld sabotage).
- a ist kooperativ: Die Rolle hilft dem Detektiv und zahlt dafür, was in wahlen[].a.kosten steht (geheimnis: ein Stück des eigenen Geheimnisses, bezug nennt welches; freund: der Freund aus bezug gerät ins Licht; ziel: das persönliche Ziel leidet).
- b ist eigennützig: Die Rolle schützt, was in wahlen[].b.nutzen steht.
- Je Option 1–2 Sätze in der Ich-Form („Ich erzähle dem Detektiv …“). Konkret, aber ohne neue Tatsachen. Beide Optionen sollen verlockend sein.
- Die Wahl ist geheim. Die Texte dürfen das eigene Geheimnis nennen, denn nur die Rolle liest sie.

EIGENE DATEIEN: content/party/schlosskeller/texte/wahlen-b5.json

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
## Ergebnis F3-AUTOR-29
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Kosten je Wahl: <kurz>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-29 · BEREIT ZUR RÜCKGABE ===

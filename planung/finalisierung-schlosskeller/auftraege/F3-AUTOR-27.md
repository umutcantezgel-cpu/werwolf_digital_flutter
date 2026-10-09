F3-AUTOR-27 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Rundenwahl (Option A und B je Runde) für die Rollen Marek (murat), Zeynep (zeynep), Baran (baran), Hana (meryem).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
[
 {
  "figur": {
   "id": "murat",
   "name": "Marek",
   "roleTitle": "Der Caterer",
   "persoenlichesZiel": "Der Lieferwagen soll nicht abgeschleppt werden.",
   "loyalitaet": null,
   "motiveAndConflict": "Er hat das Essen geliefert und den Lieferwagen im Schlosshof auf Herrn Schneiders reserviertem Platz abgestellt; am Telefon hatte ihm jemand gesagt, das gehe in Ordnung. Herr Schneider drohte mit Abschleppen.",
   "nebendelikt": {
    "id": "nd_parken",
    "text": "Hat auf Herrn Schneiders reserviertem Platz geparkt."
   }
  },
  "wahlen": [
   {
    "id": "gw_murat_1",
    "rolle": "murat",
    "runde": 1,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_parken"
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
    "id": "gw_murat_2",
    "rolle": "murat",
    "runde": 2,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_parken"
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
    "id": "gw_murat_3",
    "rolle": "murat",
    "runde": 3,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_parken"
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
    "id": "b_marek_vor",
    "text": "Das leuchtende Gesicht rannte an ihm vorbei, bevor es an der Theke schepperte.",
    "grundVerborgen": "Er ist sich im Dunkeln nicht sicher und will niemanden falsch belasten."
   },
   {
    "id": "b_marek_nach",
    "text": "Das leuchtende Gesicht rannte an ihm vorbei, nachdem es an der Theke gescheppert hatte.",
    "grundVerborgen": "Er ist sich im Dunkeln nicht sicher und will niemanden falsch belasten."
   }
  ]
 },
 {
  "figur": {
   "id": "zeynep",
   "name": "Zeynep",
   "roleTitle": "Die Fußballtrainerin",
   "persoenlichesZiel": "Can schützen.",
   "loyalitaet": {
    "zu": "can",
    "grund": "Can ist ihr Bruder."
   },
   "motiveAndConflict": "Sie steht für Cans Streich Schmiere am Bogen zum Durchgang. Sie fühlt sich schuldig, weil alles aus dem Ruder lief.",
   "nebendelikt": {
    "id": "nd_schmiere",
    "text": "Hat für Cans Streich Schmiere gestanden."
   }
  },
  "wahlen": [
   {
    "id": "gw_zeynep_1",
    "rolle": "zeynep",
    "runde": 1,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_schmiere"
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
    "id": "gw_zeynep_2",
    "rolle": "zeynep",
    "runde": 2,
    "quelle": "loyalitaet",
    "a": {
     "kosten": {
      "art": "freund",
      "bezug": "can"
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
      "bezug": "can"
     }
    }
   },
   {
    "id": "gw_zeynep_3",
    "rolle": "zeynep",
    "runde": 3,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_schmiere"
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
    "id": "b_zeynep_vorrat",
    "text": "Can hat mit der Leuchtmaske im dunklen Vorratsraum auf das Geburtstagskind gewartet.",
    "grundVerborgen": "Can ist ihr Bruder."
   }
  ]
 },
 {
  "figur": {
   "id": "baran",
   "name": "Baran",
   "roleTitle": "Der Mann für die Musik",
   "persoenlichesZiel": "Seine Box soll nicht einkassiert werden.",
   "loyalitaet": null,
   "motiveAndConflict": "Herr Schneider verlangte ab 22:00 leise Musik und drohte, die Box einzukassieren. Um 23:55 setzte Baran dem Geburtstagskind seine großen Kopfhörer auf und ließ laute Musik für die Überraschung laufen.",
   "nebendelikt": null
  },
  "wahlen": [
   {
    "id": "gw_baran_1",
    "rolle": "baran",
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
    "id": "gw_baran_2",
    "rolle": "baran",
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
    "id": "gw_baran_3",
    "rolle": "baran",
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
   "id": "meryem",
   "name": "Hana",
   "roleTitle": "Die Kamin-Heizerin",
   "persoenlichesZiel": "Den Kamin wieder zum Ziehen bringen und sich bei Herrn Schneider für den Ruß entschuldigen.",
   "loyalitaet": null,
   "motiveAndConflict": "Um 23:30 feuert sie den Kamin an, ohne die Kaminklappe zu öffnen. Dichter Qualm füllt den Kaminsaal. Herr Schneider schimpft über den Ruß an der Wand.",
   "nebendelikt": null
  },
  "wahlen": [
   {
    "id": "gw_meryem_1",
    "rolle": "meryem",
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
    "id": "gw_meryem_2",
    "rolle": "meryem",
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
    "id": "gw_meryem_3",
    "rolle": "meryem",
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
Datei content/party/schlosskeller/texte/wahlen-b3.json, Feld eintraege: genau 12 Objekte {"id": "gw_<rolle>_<runde>", "a": "…", "b": "…"} (Schema texte-wahl, KEIN Feld sabotage).
- a ist kooperativ: Die Rolle hilft dem Detektiv und zahlt dafür, was in wahlen[].a.kosten steht (geheimnis: ein Stück des eigenen Geheimnisses, bezug nennt welches; freund: der Freund aus bezug gerät ins Licht; ziel: das persönliche Ziel leidet).
- b ist eigennützig: Die Rolle schützt, was in wahlen[].b.nutzen steht.
- Je Option 1–2 Sätze in der Ich-Form („Ich erzähle dem Detektiv …“). Konkret, aber ohne neue Tatsachen. Beide Optionen sollen verlockend sein.
- Die Wahl ist geheim. Die Texte dürfen das eigene Geheimnis nennen, denn nur die Rolle liest sie.

EIGENE DATEIEN: content/party/schlosskeller/texte/wahlen-b3.json

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
## Ergebnis F3-AUTOR-27
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Kosten je Wahl: <kurz>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-27 · BEREIT ZUR RÜCKGABE ===

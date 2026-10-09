F3-AUTOR-58 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe Fassung 2 der Rundenwahl der vier Kernrollen mit Sabotage-Option (Varianten-Regel).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
[
 {
  "figur": {
   "id": "ahmet",
   "name": "Ahmet",
   "roleTitle": "Der Organisator",
   "persoenlichesZiel": "Niemand soll vor dem Morgen erfahren, dass die Miete erfunden war.",
   "loyalitaet": {
    "zu": "leyla",
    "grund": "Sie sind zusammen aufgewachsen und halten zusammen."
   },
   "motiveAndConflict": "Ahmet hat den Keller umsonst bekommen. Dafür gestaltet er das Programm des Adventsmarkts. Beim Essen hat er viel zu groß bestellt. Statt das zuzugeben, hat er von allen 150 € „Miete“ eingesammelt. Um 23:51 sagt Herr Schneider an der Theke: „Um zwölf sag ich allen, was der Keller gekostet hat.“",
   "nebendelikt": {
    "id": "nd_mietgeld",
    "text": "Hat von allen 150 € Miete kassiert, obwohl der Keller nichts gekostet hat."
   }
  },
  "wahlen": [
   {
    "id": "gw_ahmet_1",
    "rolle": "ahmet",
    "runde": 1,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_mietgeld"
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
    },
    "bTaeter": {
     "art": "sabotage",
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "tarnung"
     }
    }
   },
   {
    "id": "gw_ahmet_2",
    "rolle": "ahmet",
    "runde": 2,
    "quelle": "loyalitaet",
    "a": {
     "kosten": {
      "art": "freund",
      "bezug": "leyla"
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
      "bezug": "leyla"
     }
    },
    "bTaeter": {
     "art": "sabotage",
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "tarnung"
     }
    }
   },
   {
    "id": "gw_ahmet_3",
    "rolle": "ahmet",
    "runde": 3,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_mietgeld"
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
    },
    "bTaeter": {
     "art": "sabotage",
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "tarnung"
     }
    }
   }
  ],
  "verborgen": [],
  "killerProfile": {
   "crimeExecution": "Er kauert erst am Ostende der Theke neben Damir. Dann geht er zum Kerzenlicht an der Anrichte, um Herrn Schneider zu bitten. Herr Schneider, noch außer sich wegen Can, packt ihn am Arm und zischt: „Um zwölf erfahren's alle.“ In Panik greift Ahmet mit der Hand, in der er den Umschlag hält, den Kerzenständer und schlägt einmal zu. Heißes Wachs tropft auf den Umschlag, eine Ecke reißt ab und bleibt am Griff kleben. In Panik reißt er den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt er, dass Flucht alles schlimmer macht. Er steckt den Bund im Ost-Saal in seine eigene Jacke und kauert sich wieder neben Damir.",
   "smokingGun": "Im Wachs am Griff des Kerzenständers klebt eine abgerissene Ecke seines Mietumschlags.",
   "zusatzindiz": "Rote Wachstropfen auf dem leeren Umschlag im Ascheneimer am Kamin; eine Ecke fehlt."
  },
  "innocentProfile": {
   "actualBehavior": "Duckt sich beim Knall hinter der Theke am Ostende neben Damir und hält den Umschlag fest. Er bleibt dort, bis das Licht angeht. Später leert er den Umschlag und wirft ihn in den Ascheneimer am Kamin."
  }
 },
 {
  "figur": {
   "id": "fatma",
   "name": "Fatma",
   "roleTitle": "Die Designstudentin",
   "persoenlichesZiel": "Die Schatulle soll zurück, ohne dass es alle erfahren.",
   "loyalitaet": {
    "zu": "emine",
    "grund": "Emine ist seit der Schulzeit ihre beste Freundin."
   },
   "motiveAndConflict": "Fatma schreibt ihre Abschlussarbeit über alte Münzbilder. Azra hat ihr von der Münzschatulle in der Turmvitrine erzählt. Um 23:40 hebt sie die gesprungene Scheibe an und nimmt die Schatulle mit. Sie will die Reliefs zu Hause abzeichnen und die Schatulle am Montag zurückbringen. Um 23:56 sieht Herr Schneider Glassplitter an ihrem Mantel: „Die Schatulle. Um Punkt zwölf geh ich raus und ruf die Polizei.“",
   "nebendelikt": {
    "id": "nd_schatulle",
    "text": "Hat die Münzschatulle aus der Turmvitrine mitgenommen."
   }
  },
  "wahlen": [
   {
    "id": "gw_fatma_1",
    "rolle": "fatma",
    "runde": 1,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_schatulle"
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
    },
    "bTaeter": {
     "art": "sabotage",
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "tarnung"
     }
    }
   },
   {
    "id": "gw_fatma_2",
    "rolle": "fatma",
    "runde": 2,
    "quelle": "loyalitaet",
    "a": {
     "kosten": {
      "art": "freund",
      "bezug": "emine"
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
      "bezug": "emine"
     }
    },
    "bTaeter": {
     "art": "sabotage",
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "tarnung"
     }
    }
   },
   {
    "id": "gw_fatma_3",
    "rolle": "fatma",
    "runde": 3,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_schatulle"
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
    },
    "bTaeter": {
     "art": "sabotage",
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "tarnung"
     }
    }
   }
  ],
  "verborgen": [],
  "killerProfile": {
   "crimeExecution": "Beim Knall bleibt sie erschrocken vor der Theke stehen. Dann sieht sie das Kerzenlicht an der Anrichte und geht durch die Klappe hin, um die Schatulle sofort zurückzugeben. Herr Schneider packt den Gurt ihrer Tasche und zischt: „Zu spät. Die Polizei kommt so oder so.“ In Panik greift sie den Kerzenständer und schlägt einmal zu. In Panik reißt sie den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt sie, dass Flucht alles schlimmer macht. Sie steckt ihn in die Brottasche auf dem linken Buffettisch und kauert sich zu Emine.",
   "smokingGun": "Frischer Messingabrieb an ihrem breiten Silberring, passend zum Kerzenständer.",
   "zusatzindiz": "Rote Wachstropfen auf der Münzschatulle in ihrer Tasche."
  },
  "innocentProfile": {
   "actualBehavior": "Beim Knall zieht sie sich mit der Tasche zum linken Buffettisch zurück und kauert dort gleich danach neben Emine."
  }
 },
 {
  "figur": {
   "id": "olli",
   "name": "Olli",
   "roleTitle": "Der Anpacker",
   "persoenlichesZiel": "Den Türschaden selbst mit Herrn Schneider klären, ohne die Gruppe hineinzuziehen.",
   "loyalitaet": {
    "zu": "kaan",
    "grund": "Wojtek hat ihm beim Tragen geholfen und hält zu ihm."
   },
   "motiveAndConflict": "Um 18:30 trägt Olli mit Wojtek die Warmhaltebehälter durch den Turm. Dabei schrammt er die geschnitzte Bogentür, ein Beschlag reißt aus. Herr Schneider verlangt 2.000 € Bargeld und schließt die Tore ab: „Keiner geht, bevor das bezahlt ist.“ Um 23:00 streiten die beiden laut.",
   "nebendelikt": {
    "id": "nd_tuerschaden",
    "text": "Hat die Bogentür beschädigt und wollte die Schramme mit Möbelwachs verdecken."
   }
  },
  "wahlen": [
   {
    "id": "gw_olli_1",
    "rolle": "olli",
    "runde": 1,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_tuerschaden"
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
    },
    "bTaeter": {
     "art": "sabotage",
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "tarnung"
     }
    }
   },
   {
    "id": "gw_olli_2",
    "rolle": "olli",
    "runde": 2,
    "quelle": "loyalitaet",
    "a": {
     "kosten": {
      "art": "freund",
      "bezug": "kaan"
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
      "bezug": "kaan"
     }
    },
    "bTaeter": {
     "art": "sabotage",
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "tarnung"
     }
    }
   },
   {
    "id": "gw_olli_3",
    "rolle": "olli",
    "runde": 3,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_tuerschaden"
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
    },
    "bTaeter": {
     "art": "sabotage",
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "tarnung"
     }
    }
   }
  ],
  "verborgen": [],
  "killerProfile": {
   "crimeExecution": "Er bleibt erst am Eiskübel stehen. Dann geht er vor der Theke entlang und durch die Klappe zum Kerzenlicht, weil er mit Herrn Schneider reden will. Herr Schneider packt ihn am Ärmel und zischt: „Zweitausend. Sonst Polizei.“ In Panik greift Olli den Kerzenständer am Fuß und schlägt einmal zu. Rote Tropfen fallen auf den Handschuh, der aus seiner Westentasche hängt. In Panik reißt er den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt er, dass Flucht alles schlimmer macht. Er wirft ihn in den Eiskübel und kauert sich zu Azra.",
   "smokingGun": "Holzsplitter und weißer Kalk von seinen Ärmeln kleben im Wachs am Fuß des Kerzenständers, das inzwischen erstarrt ist.",
   "zusatzindiz": "Rote Kerzenwachstropfen auf dem Arbeitshandschuh in seiner Westentasche."
  },
  "innocentProfile": {
   "actualBehavior": "Beim Knall tastet er sich vom Eiskübel zum rechten Buffettisch und kauert dort gleich danach neben Azra, bis das Licht angeht. Dann bringt er Wojtek das Eis und setzt sich in den Ost-Saal an die Tafel."
  }
 },
 {
  "figur": {
   "id": "can",
   "name": "Can",
   "roleTitle": "Der Spaßvogel",
   "persoenlichesZiel": "Der Streich soll nicht herauskommen.",
   "loyalitaet": {
    "zu": "zeynep",
    "grund": "Seine Schwester Zeynep hat für ihn Schmiere gestanden."
   },
   "motiveAndConflict": "Can hat am Nachmittag eine weiße Gespenstermaske mit Leuchtfarbe angemalt. Um 23:54 versteckt er sich damit im dunklen Vorratsraum. Um zwölf soll das Geburtstagskind zur Torte kommen und sich erschrecken. Kurz vor zwölf knallt es, das Licht geht aus, und die Tür zum Vorratsraum quietscht auf. Can glaubt, das Geburtstagskind wird schon gebracht, und springt mit „Buuuh!“ hervor. Er läuft Herrn Schneider in die Arme. Der packt ihn an der Kapuze und ruft: „Hab ich dich!“",
   "nebendelikt": {
    "id": "nd_streich",
    "text": "Hat sich mit der Leuchtmaske im Vorratsraum versteckt, um das Geburtstagskind zu erschrecken."
   }
  },
  "wahlen": [
   {
    "id": "gw_can_1",
    "rolle": "can",
    "runde": 1,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_streich"
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
    },
    "bTaeter": {
     "art": "sabotage",
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "tarnung"
     }
    }
   },
   {
    "id": "gw_can_2",
    "rolle": "can",
    "runde": 2,
    "quelle": "loyalitaet",
    "a": {
     "kosten": {
      "art": "freund",
      "bezug": "zeynep"
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
      "bezug": "zeynep"
     }
    },
    "bTaeter": {
     "art": "sabotage",
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "tarnung"
     }
    }
   },
   {
    "id": "gw_can_3",
    "rolle": "can",
    "runde": 3,
    "quelle": "geheimnis",
    "a": {
     "kosten": {
      "art": "geheimnis",
      "bezug": "nd_streich"
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
    },
    "bTaeter": {
     "art": "sabotage",
     "kosten": {
      "art": "gruppe"
     },
     "nutzen": {
      "art": "tarnung"
     }
    }
   }
  ],
  "verborgen": [],
  "killerProfile": {
   "crimeExecution": "Herr Schneider hält ihn an der Kapuze fest und zischt: „Jetzt kommt die Polizei, Freundchen.“ In Panik greift Can mit der Hand voller Leuchtfarbe den Kerzenständer von der Anrichte und schlägt einmal zu. Herr Schneider stürzt in den Vorratsraum. Can kniet sich neben ihn und reißt in Panik den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt er, dass Flucht alles schlimmer macht. Er rennt nach dem Scheppern durch den Durchgang und den Kaminsaal, stopft an der Bogentür die Maske in die Bauchtasche, steckt den Bund in den Helm der Ritterrüstung und versteckt sich auf der Toilette im Turm.",
   "smokingGun": "Ein Abdruck einer ganzen Hand in grünlich-weißer Leuchtfarbe um den Griff des Kerzenständers.",
   "zusatzindiz": "Rote Wachstropfen auf der Leuchtmaske."
  },
  "innocentProfile": {
   "actualBehavior": "Er reißt sich los und rennt durch den Durchgang, noch bevor es scheppert. Die leuchtende Maske hält er in der Hand. Im Kaminsaal rennt er zur Bogentür, stopft die Maske in die Bauchtasche seines Pullis und versteckt sich oben auf der Toilette im Turm."
  }
 }
]

SCHNITTSTELLEN:
Datei planung/finalisierung-schlosskeller/varianten/wahlen-kern-v2.json (NICHT in texte/), Format wie texte/wahlen-kern.json: {"settingId":"spuk_im_schlosskeller","bereich":"wahl","hinweis":"Fassung 2","eintraege":[{"id":"gw_<rolle>_<runde>","a":"…","b":"…","sabotage":"…"}]} – genau 12 Einträge (ahmet, fatma, olli, can × Runde 1–3).
- a und b wie bei allen Rollen (Kosten und Nutzen aus wahlen[]).
- sabotage gilt nur, wenn die Rolle in diesem Fall die Täterperson ist. Sie klingt für die Rolle wie ein harmloses B, lenkt aber unauffällig ab (z. B. „Ich erzähle von etwas Nebensächlichem“). Kein Mord-, Gewalt- oder Schuldwort.
- VORGABE DIESER FASSUNG: emotional und persönlich, die Wahl als Gewissensfrage mit Humor.

EIGENE DATEIEN: planung/finalisierung-schlosskeller/varianten/wahlen-kern-v2.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN, SCHLUESSEL.md und den Auszug.
2. Schreibe die 12 Einträge.
3. Prüfe mit python3 -m json.tool.

ABNAHMEKRITERIEN UND TESTWEG: Genau 12 Einträge mit a, b, sabotage; keine Gewalt; keine Täterhinweise in a oder b.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-58
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Eigene Einschätzung der Fassung: <2 Sätze>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-58 · BEREIT ZUR RÜCKGABE ===

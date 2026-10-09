/// Kleines, vollständiges Beispiel-Szenario. Dient als Referenz für das
/// JSON-Format (`content/SCHEMA.md`), für die Entwicklung (FakeSession) und
/// für die Werkzeuge `validate`/`simulate`.
const sampleScenarioJson = r'''
{
  "id": "sample",
  "title": {"de": "Villa Probe"},
  "tagline": {"de": "Ein Testfall für Entwickler."},
  "synopsis": {"de": "Der Hausherr liegt tot im Arbeitszimmer. Drei Menschen waren im Haus."},
  "difficulty": 1,
  "minutes": 15,
  "theme": {
    "palette": {
      "background": "#0b0910", "floor": "#4a2f25", "floorAlt": "#3b241c",
      "wall": "#2a1d24", "wallTop": "#5a3a3f", "trim": "#c9a227",
      "accent": "#c9a227", "light": "#ffcf7a", "danger": "#b3122e",
      "text": "#f3e9dc", "fog": "#1a1420"
    },
    "weather": "rain",
    "lightning": true,
    "dayAmbient": 0.85,
    "nightAmbient": 0.08
  },
  "map": {
    "rows": [
      "####################",
      "#......#.....#.....#",
      "#......#.....#.....#",
      "#......+.....+.....#",
      "#......#.....#.....#",
      "#......#.....#.....#",
      "###+#######+####L###",
      "#..................#",
      "#..................#",
      "#####WW###+###WW####",
      "#..................#",
      "#..................#",
      "#..................#",
      "####################"
    ],
    "rooms": [
      {"id": "study", "name": {"de": "Arbeitszimmer"}, "x": 1, "y": 1, "w": 6, "h": 5, "floor": "parquet"},
      {"id": "salon", "name": {"de": "Salon"}, "x": 8, "y": 1, "w": 5, "h": 5, "floor": "carpet", "lit": true},
      {"id": "kitchen", "name": {"de": "Küche"}, "x": 14, "y": 1, "w": 5, "h": 5, "floor": "tiles"},
      {"id": "hall", "name": {"de": "Flur"}, "x": 1, "y": 7, "w": 18, "h": 2, "floor": "checker"},
      {"id": "garden", "name": {"de": "Garten"}, "x": 1, "y": 10, "w": 18, "h": 3, "floor": "grass", "outdoor": true}
    ],
    "props": [
      {"type": "bookshelf", "x": 1, "y": 1}, {"type": "bookshelf", "x": 2, "y": 1},
      {"type": "desk", "x": 3, "y": 2}, {"type": "clock", "x": 6, "y": 1},
      {"type": "rug", "x": 4, "y": 3}, {"type": "armchair", "x": 5, "y": 5},
      {"type": "lamp", "x": 12, "y": 1}, {"type": "fireplace", "x": 10, "y": 1},
      {"type": "sofa", "x": 9, "y": 3}, {"type": "sofa", "x": 11, "y": 3},
      {"type": "plant", "x": 12, "y": 5},
      {"type": "counter", "x": 14, "y": 1}, {"type": "counter", "x": 15, "y": 1},
      {"type": "stove", "x": 17, "y": 1}, {"type": "fridge", "x": 18, "y": 1},
      {"type": "table", "x": 16, "y": 3},
      {"type": "statue", "x": 5, "y": 7}, {"type": "wardrobe", "x": 18, "y": 7},
      {"type": "plant", "x": 1, "y": 8},
      {"type": "tree", "x": 3, "y": 11}, {"type": "bush", "x": 7, "y": 12},
      {"type": "bush", "x": 12, "y": 10}, {"type": "crate", "x": 17, "y": 12},
      {"type": "puddle", "x": 9, "y": 11}
    ],
    "spawn": [[9, 4], [10, 4], [11, 4], [9, 5], [10, 5], [11, 5]],
    "councilRoom": "salon"
  },
  "hotspots": [
    {"id": "h_body", "name": {"de": "Der Tote"}, "x": 4, "y": 3, "kind": "body"},
    {"id": "h_desk", "name": {"de": "Schreibtisch"}, "x": 3, "y": 2, "kind": "search"},
    {"id": "h_window", "name": {"de": "Beet unter dem Fenster"}, "x": 5, "y": 10, "kind": "search"},
    {"id": "h_fireplace", "name": {"de": "Kamin"}, "x": 10, "y": 1, "kind": "search"},
    {"id": "h_lab", "name": {"de": "Küchentisch (Labor)"}, "x": 16, "y": 3, "kind": "lab"},
    {"id": "h_drawer", "name": {"de": "Schublade"}, "x": 14, "y": 1, "kind": "search"},
    {"id": "h_wardrobe", "name": {"de": "Schrank"}, "x": 18, "y": 7, "kind": "hide"},
    {"id": "h_blood", "name": {"de": "Dunkle Spritzer"}, "x": 2, "y": 4, "kind": "blood"},
    {"id": "h_shed", "name": {"de": "Gerätekiste"}, "x": 17, "y": 12, "kind": "search", "requires": {"lead": "l_garden"}},
    {"id": "h_diary", "name": {"de": "Speisekammer"}, "x": 18, "y": 5, "kind": "search", "requires": {"lead": "l_kitchen"}, "fromChapter": 2},
    {"id": "h_echo", "name": {"de": "Kalte Stelle"}, "x": 12, "y": 12, "kind": "search", "ghost": true}
  ],
  "items": [
    {"id": "i_coffee", "type": "coffee", "x": 12, "y": 4, "chapter": 1},
    {"id": "i_battery", "type": "battery", "x": 2, "y": 8, "chapter": 1},
    {"id": "i_salts", "type": "salts", "x": 7, "y": 7, "chapter": 1},
    {"id": "i_medkit", "type": "medkit", "x": 15, "y": 4, "chapter": 2},
    {"id": "i_flare", "type": "flare", "x": 10, "y": 12, "chapter": 2},
    {"id": "i_antidote", "type": "antidote", "x": 17, "y": 8, "chapter": 2}
  ],
  "victim": {
    "name": {"de": "Konrad Probe"},
    "text": {"de": "Konrad Probe, 64, Hausherr. Zusammengesunken über dem Teppich."},
    "hotspot": "h_body",
    "look": {"coat": "#2b2b33", "hair": "#bbbbbb", "hat": "none", "build": "broad"}
  },
  "traits": {
    "shoe": {"label": {"de": "Schuhwerk"}, "values": {"sneaker": {"de": "Turnschuhe"}, "heel": {"de": "Absatzschuhe"}, "lacquer": {"de": "Lackschuhe"}}},
    "hand": {"label": {"de": "Händigkeit"}, "values": {"left": {"de": "Linkshänder"}, "right": {"de": "Rechtshänder"}}}
  },
  "suspects": [
    {
      "id": "nephew", "name": {"de": "Felix Probe"}, "role": {"de": "Neffe"},
      "bio": {"de": "Charmant, pleite, und der einzige Erbe."},
      "look": {"coat": "#3d5a80", "hair": "#5a3b1e", "hat": "cap", "build": "slim"},
      "x": 12, "y": 3,
      "traits": {"shoe": "sneaker", "hand": "left"},
      "candidate": true, "motives": ["inheritance", "debt"], "witness": true,
      "lines": {
        "greet": {"de": "Schlimme Sache. Aber ich habe damit nichts zu tun."},
        "alibi": {"de": "Ich habe im Salon Radio gehört. Den ganzen Abend."},
        "alibiLie": {"de": "Radio. Im Salon. Fragen Sie doch irgendwen."},
        "victim": {"de": "Onkel Konrad war streng. Aber er war Familie."},
        "observation": {"de": "Der Doktor war ziemlich lange im Garten, oder?"},
        "rumor": {"de": "Man sagt, Felix hat Spielschulden bei üblen Leuten."},
        "nervous": {"de": "Woher … woher haben Sie das?"},
        "annoyed": {"de": "Das ist lächerlich. Lassen Sie mich in Ruhe."}
      }
    },
    {
      "id": "housekeeper", "name": {"de": "Margot Weiss"}, "role": {"de": "Haushälterin"},
      "bio": {"de": "Seit 30 Jahren im Haus. Kennt jedes Geheimnis."},
      "look": {"coat": "#6b2737", "hair": "#2a1d14", "hat": "bun", "build": "small"},
      "x": 17, "y": 4,
      "traits": {"shoe": "heel", "hand": "right"},
      "candidate": true, "motives": ["debt", "revenge"], "witness": true,
      "lines": {
        "greet": {"de": "Ich habe ihm noch um neun den Tee gebracht."},
        "alibi": {"de": "Ich war im Dorf einkaufen. Der Laden hat bis zehn auf."},
        "alibiLie": {"de": "Einkaufen war ich. Die Quittung habe ich irgendwo."},
        "victim": {"de": "Er hat mir nie verziehen, dass meine Tochter fortging."},
        "observation": {"de": "Der junge Herr Felix stand um zehn im Flur. Barfuß? Nein … in Turnschuhen."},
        "rumor": {"de": "Im Dorf heißt es, Margot sollte entlassen werden."},
        "nervous": {"de": "Ich … ich muss mich setzen."},
        "annoyed": {"de": "So redet man nicht mit mir."}
      }
    },
    {
      "id": "doctor", "name": {"de": "Dr. Paul Brenner"}, "role": {"de": "Hausarzt"},
      "bio": {"de": "Alter Freund der Familie. Hat Zugang zu jedem Medikament."},
      "look": {"coat": "#2f3e46", "hair": "#9a9a9a", "hat": "bowler", "build": "tall"},
      "x": 9, "y": 8,
      "traits": {"shoe": "lacquer", "hand": "left"},
      "candidate": true, "motives": ["revenge", "inheritance"], "witness": true,
      "lines": {
        "greet": {"de": "Ich konnte nichts mehr für ihn tun."},
        "alibi": {"de": "Ich habe im Garten geraucht. Fragen Sie den Neffen, er sah mich."},
        "alibiLie": {"de": "Ich war im Garten. Allein. Wie jeden Abend."},
        "victim": {"de": "Konrad und ich … wir hatten unsere Differenzen. Alte Geschichten."},
        "observation": {"de": "Felix kam aus der Richtung des Arbeitszimmers. Sehr eilig."},
        "rumor": {"de": "Konrad wollte sein Testament ändern – zugunsten des Doktors."},
        "nervous": {"de": "Das beweist gar nichts."},
        "annoyed": {"de": "Ich bin Arzt, kein Verdächtiger."}
      }
    }
  ],
  "motives": [
    {"id": "inheritance", "name": {"de": "Erbschaft"}, "reveal": {"de": "Ein Testamentsentwurf: Das Vermögen sollte neu verteilt werden. Jemand wollte das verhindern."}},
    {"id": "debt", "name": {"de": "Schulden"}, "reveal": {"de": "Mahnungen und Schuldscheine. Der Täter brauchte Geld – sofort."}},
    {"id": "revenge", "name": {"de": "Rache"}, "reveal": {"de": "Ein alter Brief voller Hass. Hier ging es um eine offene Rechnung."}}
  ],
  "weapons": [
    {"id": "poison", "name": {"de": "Gift"}, "reveal": {"de": "Spuren eines Herzglykosids im Tee. Kein Unfall."}},
    {"id": "candlestick", "name": {"de": "Kerzenleuchter"}, "reveal": {"de": "Ein Schlag gegen die Schläfe. Wachsreste in der Wunde."}}
  ],
  "story": {"culprit": "nephew", "motive": "inheritance", "weapon": "poison"},
  "clues": [
    {"id": "c_autopsy", "kind": "weapon", "name": {"de": "Befund am Toten"},
     "found": {"de": "Keine offensichtliche Todesursache. Die Obduktion läuft."},
     "evolve": "time", "chapters": 1, "source": {"hotspot": "h_body"}, "chapter": 1},
    {"id": "c_ink", "kind": "trait", "trait": "hand", "name": {"de": "Verschmierte Tinte"},
     "found": {"de": "Ein umgestoßenes Tintenfass, jemand hat hineingefasst."},
     "reveal": {"de": "Die Schmierspur verrät: {value}."},
     "source": {"hotspot": "h_desk"}, "chapter": 1},
    {"id": "c_footprint", "kind": "trait", "trait": "shoe", "name": {"de": "Fußspur im Beet"},
     "found": {"de": "Ein frischer Abdruck im Schlamm."},
     "reveal": {"de": "Der Abdruck stammt von {value}."},
     "source": {"hotspot": "h_window"}, "chapter": 1, "expires": 1},
    {"id": "c_ashes", "kind": "motive", "name": {"de": "Verkohlte Papiere"},
     "found": {"de": "Halb verbrannte Blätter im Kamin."},
     "evolve": "lab", "source": {"hotspot": "h_fireplace"}, "chapter": 1},
    {"id": "c_receipt", "kind": "alibi", "subject": "housekeeper", "name": {"de": "Quittung vom Dorfladen"},
     "found": {"de": "Eine Quittung mit Uhrzeit."},
     "reveal": {"de": "22:05 Uhr, Dorfladen. Margot war zur Tatzeit nicht im Haus."},
     "revealFalse": {"de": "Die Uhrzeit wurde nachträglich geändert. Margots Alibi ist gelogen."},
     "evolve": "lab", "source": {"hotspot": "h_drawer"}, "chapter": 1},
    {"id": "c_alibi_doctor", "kind": "alibi", "subject": "doctor", "name": {"de": "Aussage über den Doktor"},
     "found": {"de": "Margot hat etwas über den Doktor gesehen."},
     "reveal": {"de": "Margot sah den Doktor um zehn durchs Küchenfenster im Garten rauchen."},
     "revealFalse": {"de": "Margot sah den Garten um zehn – leer. Der Doktor lügt."},
     "source": {"npc": "housekeeper", "topic": "observation"}, "chapter": 1},
    {"id": "c_alibi_nephew", "kind": "alibi", "subject": "nephew", "name": {"de": "Aussage über Felix"},
     "found": {"de": "Der Doktor erinnert sich an Felix."},
     "reveal": {"de": "Das Radio im Salon lief tatsächlich – der Doktor hörte es vom Garten aus."},
     "revealFalse": {"de": "Das Radio im Salon war kaputt. Felix' Alibi ist erfunden."},
     "source": {"npc": "doctor", "topic": "observation"}, "chapter": 1},
    {"id": "c_blood", "kind": "trait", "trait": "hand", "name": {"de": "Dunkle Spritzer"},
     "found": {"de": "Feine Spritzer an der Wand."},
     "reveal": {"de": "Das Muster passt zu: {value}."},
     "evolve": "lab", "source": {"hotspot": "h_blood"}, "chapter": 1},
    {"id": "c_shoes", "kind": "trait", "trait": "shoe", "name": {"de": "Schlammige Schuhe"},
     "found": {"de": "Versteckte Schuhe, voller Gartenschlamm."},
     "reveal": {"de": "Es sind {value}."},
     "source": {"hotspot": "h_shed"}, "chapter": 2},
    {"id": "c_diary", "kind": "story", "name": {"de": "Konrads Tagebuch"},
     "found": {"de": "„Ich weiß jetzt, wer mich bestiehlt. Morgen ändere ich alles.“"},
     "source": {"hotspot": "h_diary"}, "chapter": 2, "secret": true},
    {"id": "c_echo", "kind": "story", "name": {"de": "Ein Flüstern"},
     "found": {"de": "Eine Stimme aus dem Nichts: „Der Tee … war bitter …“"},
     "source": {"hotspot": "h_echo"}, "chapter": 1, "ghost": true}
  ],
  "combos": [
    {"id": "k_shoes", "a": "c_footprint", "b": "c_shoes",
     "name": {"de": "Spur und Schuh"}, "text": {"de": "Die versteckten Schuhe passen exakt in den Abdruck."},
     "reveals": ["c_footprint", "c_shoes"]},
    {"id": "k_letter", "a": "c_ashes", "b": "c_ink",
     "name": {"de": "Tinte auf Asche"}, "text": {"de": "Die Tinte auf den Papierresten stammt vom Schreibtisch. Jemand hat hier etwas verbrannt, was er gerade geschrieben hatte."},
     "lead": "l_kitchen"}
  ],
  "chapters": [
    {
      "title": {"de": "Kapitel 1 – Der Tote im Arbeitszimmer"},
      "intro": {"de": "Regen peitscht gegen die Fenster. Konrad Probe ist tot. Niemand verlässt das Haus, bevor der Fall gelöst ist."},
      "night": {"de": "Der Strom fällt aus. Irgendwo im Haus knarrt eine Diele."},
      "leads": [
        {"id": "l_garden", "name": {"de": "Den Garten absuchen"}, "text": {"de": "Die Gerätekiste im Garten wird geöffnet."}, "unlock": {"hotspots": ["h_shed"]}},
        {"id": "l_kitchen", "name": {"de": "Die Speisekammer öffnen"}, "text": {"de": "Die verschlossene Küchentür wird aufgebrochen."}, "unlock": {"hotspots": ["h_diary"], "doors": [[16, 6]]}, "hidden": true}
      ]
    },
    {
      "title": {"de": "Kapitel 2 – Spuren im Regen"},
      "intro": {"de": "Der Morgen graut. Die Laborergebnisse liegen vor. Und jemand hat in der Nacht nach Beweisen gesucht."},
      "night": {"de": "Die zweite Nacht. Diesmal ist der Schatten vorsichtiger."},
      "leads": [
        {"id": "l_garden2", "name": {"de": "Den Garten absuchen"}, "text": {"de": "Die Gerätekiste im Garten wird geöffnet."}, "unlock": {"hotspots": ["h_shed"]}},
        {"id": "l_kitchen2", "name": {"de": "Die Speisekammer öffnen"}, "text": {"de": "Die verschlossene Küchentür wird aufgebrochen."}, "unlock": {"hotspots": ["h_diary"], "doors": [[16, 6]]}}
      ]
    },
    {
      "title": {"de": "Kapitel 3 – Die Anklage"},
      "intro": {"de": "Letzte Gelegenheit. Danach müssen Sie sich festlegen."},
      "night": {"de": ""},
      "leads": []
    }
  ],
  "endings": {
    "verdict": {
      "perfect": {"title": {"de": "Lückenlos"}, "text": {"de": "Täter, Motiv und Waffe – alles bewiesen. Das Geständnis folgt noch in der Nacht."}},
      "solid": {"title": {"de": "Überführt"}, "text": {"de": "Die Beweise reichen. Ein paar Fragen bleiben offen, aber der Täter sitzt."}},
      "partial": {"title": {"de": "Mit Ach und Krach"}, "text": {"de": "Der richtige Name, aber die Beweislage ist dünn. Ein guter Anwalt wird es schwer machen."}},
      "wrong": {"title": {"de": "Justizirrtum"}, "text": {"de": "Ein Unschuldiger wird abgeführt. Der wahre Täter lächelt im Schatten."}},
      "unsolved": {"title": {"de": "Akte ungelöst"}, "text": {"de": "Niemand wird angeklagt. Der Fall verstaubt im Archiv."}}
    },
    "team": {
      "all": {"de": "Alle Ermittler haben die Nacht überlebt."},
      "some": {"de": "Nicht alle Ermittler haben es aus dem Haus geschafft."},
      "lone": {"de": "Nur einer von Ihnen ist noch übrig."},
      "none": {"de": "Keiner der Ermittler hat überlebt."}
    },
    "culprit": {
      "nephew": {"caught": {"de": "Felix gesteht: Er hätte alles verloren."}, "escaped": {"de": "Felix setzt sich mit dem Erbe ins Ausland ab."}},
      "housekeeper": {"caught": {"de": "Margot weint, als man sie abführt."}, "escaped": {"de": "Margot kündigt still und verschwindet."}},
      "doctor": {"caught": {"de": "Der Doktor verliert Lizenz und Freiheit."}, "escaped": {"de": "Der Doktor praktiziert weiter. Ausgerechnet."}}
    },
    "secret": {"de": "Das Tagebuch enthüllt: Konrad wusste es. Er hatte schon einen Brief an die Polizei geschrieben – zu spät."}
  }
}
''';

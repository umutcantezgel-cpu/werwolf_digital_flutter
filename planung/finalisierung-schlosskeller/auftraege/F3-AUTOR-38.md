F3-AUTOR-38 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe eine Fassung des Intros (Varianten-Regel, Fassung 3).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
{
 "setting": {
  "schauplatz": "Ein altes, etwas abgelegenes Schloss vor der Stadt. Gefeiert wird im großen Gewölbekeller unter dem Schlossturm.",
  "anlass": "Geburtstag. Ahmet hat den Keller über einen Gefallen organisiert: Er gestaltet umsonst das Programm des Adventsmarkts der Schlossstiftung.",
  "getraenke": [
   "schwarzer Tee aus dem großen Teekocher",
   "Kaffee",
   "warmer, alkoholfreier Apfelpunsch",
   "Wasser",
   "Säfte"
  ],
  "empfang": "Hinter den dicken Mauern gibt es keinen Handyempfang. Empfang gibt es erst draußen auf den Stufen zum Parkplatz.",
  "atmosphaere": [
   "Der Wind pfeift durch die Lichtschächte.",
   "Schwere Holztüren quietschen im Luftzug.",
   "Elektrische Kerzen flackern auf den Tafeln; echte Kerzen brennen nur im Messingkerzenständer an der Theke."
  ],
  "lacher": [
   {
    "id": "lacher_ruestung",
    "zeit": "21:00",
    "wer": "selin",
    "ort": "an_der_ruestung",
    "was": "Sibel hält die alte Ritterrüstung im Turmgang für einen Menschen, schreit auf und stolpert rückwärts gegen die Schauvitrine. Die Scheibe bekommt einen feinen Sprung.",
    "traegt": "Spur: Ab 21:00 ist die Vitrinenscheibe lose."
   },
   {
    "id": "lacher_verlaufen",
    "zeit": "20:15",
    "wer": "olli",
    "ort": "vorrat_mitte",
    "was": "Olli sucht die Toilette, nimmt die falsche Tür hinter der Theke und steht im dunklen Vorratsraum vor der Geburtstagstorte. „Ich wollte nur aufs Klo!“",
    "traegt": "Falsche Fährte: Olli kennt den Vorratsraum."
   },
   {
    "id": "lacher_kamin",
    "zeit": "23:30",
    "wer": "meryem",
    "ort": "am_kamin",
    "was": "Hana feuert den Kamin an, ohne die Kaminklappe zu öffnen. Dichter Qualm füllt den Kaminsaal, alle husten, die Lichtschacht-Klappen werden aufgerissen, das Feuer wird gelöscht.",
    "traegt": "Spur: Seit 23:30 zieht Luft vom Buffetsaal in den Kaminsaal; Gerüche wandern mit."
   }
  ],
  "ton": "Grusel mit Humor: quietschende Türen, Zugluft, flackerndes Licht, verpatzte Streiche. Herr Schneider überlebt immer; der Schlag ist nur Schatten und Geräusch."
 },
 "fall": {
  "titel": "Spuk im Schlosskeller",
  "untertitel": "Das Buffet hinter dicken Mauern",
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
  ]
 },
 "lacherRollen": {
  "lacher_ruestung": "Sibel",
  "lacher_verlaufen": "Olli",
  "lacher_kamin": "Hana"
 },
 "zeitleisteAbend": [
  {
   "id": "z_ankunft",
   "zeit": "18:00",
   "text": "Die Gäste kommen über die fünf Sandsteinstufen und das Außentor in den Keller. Herr Schneider begrüßt alle knapp und zeigt den Weg."
  },
  {
   "id": "z_lieferung",
   "zeit": "18:30",
   "text": "Marek liefert das Essen über den Schlosshof und parkt auf Herrn Schneiders reserviertem Platz. Olli und Wojtek tragen die Warmhaltebehälter durch Hoftür, Turmgang und Bogentür."
  },
  {
   "id": "z_tuerschaden",
   "zeit": "18:35",
   "text": "Olli schrammt mit einem Warmhaltebehälter die geschnitzte Bogentür. Ein Beschlag reißt aus, Holzsplitter und weißer Kalk bleiben an seinen Pulli-Ärmeln."
  },
  {
   "id": "z_moebelwachs",
   "zeit": "18:45",
   "text": "Wojtek gibt Olli braunes Möbelwachs aus seiner Werkzeugtasche. Olli reibt es mit seinem rechten Arbeitshandschuh in die Schramme und steckt den Handschuh in die Westentasche."
  },
  {
   "id": "z_forderung",
   "zeit": "18:50",
   "text": "Herr Schneider entdeckt den Schaden, verlangt 2.000 € Bargeld und schreibt es in seinen Quittungsblock. Er schließt Hoftür und Außentor ab: „Keiner geht, bevor das bezahlt ist.“"
  },
  {
   "id": "z_buffet",
   "zeit": "19:00",
   "text": "Das Buffet ist eröffnet: warmes Essen, Brot, Dips, Gebäck. Dazu schwarzer Tee aus dem großen Teekocher, Kaffee, alkoholfreier Apfelpunsch, Wasser und Säfte."
  },
  {
   "id": "z_handschuh",
   "zeit": "19:30",
   "text": "Olli wärmt sich am noch kalten Kamin die Hände und vergisst dort seinen linken Arbeitshandschuh."
  },
  {
   "id": "z_verlaufen",
   "zeit": "20:15",
   "text": "Lacher: Olli sucht die Toilette, nimmt die falsche Tür hinter der Theke und steht im dunklen Vorratsraum vor der Geburtstagstorte. „Ich wollte nur aufs Klo!“"
  },
  {
   "id": "z_ruestung",
   "zeit": "21:00",
   "text": "Lacher: Sibel hält die Ritterrüstung für einen Menschen, schreit auf und stolpert gegen die Schauvitrine. Die Scheibe bekommt einen feinen Sprung."
  },
  {
   "id": "z_kerzen",
   "zeit": "22:00",
   "text": "Herr Schneider zündet die drei roten Kerzen im Messingkerzenständer auf der Anrichte an. Es sind die einzigen echten Kerzen im Keller."
  },
  {
   "id": "z_musik",
   "zeit": "22:00",
   "text": "Herr Schneider verlangt leise Musik und droht, Barans Box einzukassieren."
  },
  {
   "id": "z_quittung",
   "zeit": "22:30",
   "text": "Aylin fragt Herrn Schneider nach einem Beleg für die Miete. Er schreibt ihr auf einen Quittungszettel: „Miete: 0 Euro.“"
  },
  {
   "id": "z_streit_olli",
   "zeit": "23:00",
   "text": "Lauter Streit zwischen Herrn Schneider und Olli um die 2.000 €. Pawel versucht zu schlichten und wird barsch abgewiesen."
  },
  {
   "id": "z_kamin",
   "zeit": "23:20",
   "text": "Hana feuert den Kamin an, ohne die Kaminklappe zu öffnen."
  },
  {
   "id": "z_qualm",
   "zeit": "23:30",
   "text": "Lacher: Dichter Qualm füllt den Kaminsaal, alle husten. Die Klappen der Lichtschächte werden aufgerissen, das Feuer wird gelöscht. Seitdem zieht Luft vom Buffetsaal in den Kaminsaal."
  },
  {
   "id": "z_vitrine_schatulle",
   "zeit": "23:40",
   "text": "Fatma hebt die gesprungene Scheibe der Vitrine an und nimmt die Münzschatulle mit. Emine sieht es."
  },
  {
   "id": "z_tasche_ausgebeult",
   "zeit": "23:45",
   "text": "Azra sieht, dass Fatmas Tasche auffällig ausgebeult ist."
  },
  {
   "id": "z_finger",
   "zeit": "23:50",
   "text": "Wojtek klemmt sich an der Bogentür den Finger ein."
  },
  {
   "id": "z_foto_streit",
   "zeit": "23:51",
   "text": "Herr Schneider zu Ahmet an der Theke: „Um zwölf sag ich allen, was der Keller gekostet hat.“ Joanna fotografiert den Streit."
  },
  {
   "id": "z_olli_eis",
   "zeit": "23:52",
   "text": "Olli zu Wojtek: „Ich hol dir Eis. Und dann red ich mit Schneider.“"
  },
  {
   "id": "z_vitrine_offen",
   "zeit": "23:53",
   "text": "Herr Schneider entdeckt auf seiner Runde die offene Vitrine und die Scherben."
  },
  {
   "id": "z_can_vorrat",
   "zeit": "23:54",
   "text": "Can schleicht über den Durchgang hinter die Theke in den Vorratsraum, macht dort das Licht aus und wartet mit der Leuchtmaske auf das Geburtstagskind. Zeynep steht am Bogen zum Durchgang Schmiere."
  },
  {
   "id": "z_tortenplan",
   "zeit": "23:55",
   "text": "Tugba ruft alle in den Ost-Saal, die Handys kommen in den Handykorb. Das Geburtstagskind bekommt eine Augenbinde und Barans Kopfhörer mit lauter Musik. Um zwölf soll es zur Torte in den Vorratsraum geführt werden."
  },
  {
   "id": "z_jacke",
   "zeit": "23:55",
   "text": "Ahmet hängt seine schwarze Jacke an den Jackenständer im Ost-Saal."
  },
  {
   "id": "z_serkan_tor",
   "zeit": "23:56",
   "text": "Serkan will Decken aus dem Auto holen und findet das Außentor verschlossen."
  },
  {
   "id": "z_schatulle_entdeckt",
   "zeit": "23:56",
   "text": "Herr Schneider sieht Glassplitter an Fatmas Mantel: „Die Schatulle. Um Punkt zwölf geh ich raus und ruf die Polizei.“"
  },
  {
   "id": "z_theke_2357",
   "zeit": "23:57",
   "text": "Fatma geht mit der Tasche zur Theken-Klappe, Olli holt am Eiskübel Eis, Ahmet schlüpft mit dem Umschlag hinter die Theke. Herr Schneider raunzt Olli an: „Zweitausend, bis zwölf.“"
  },
  {
   "id": "z_steckdose",
   "zeit": "23:57:50",
   "text": "Herr Schneider warnt Tim vor der alten Leiste. Tim steckt die Kaffeemaschine trotzdem in seine Mehrfachsteckdose."
  },
  {
   "id": "z_licht",
   "zeit": "00:00",
   "text": "Tim schaltet die Hauptsicherung wieder ein."
  },
  {
   "id": "z_gefunden",
   "zeit": "00:00:20",
   "text": "Damir findet Herrn Schneider im Vorratsraum."
  },
  {
   "id": "z_wach",
   "zeit": "00:01:30",
   "text": "Herr Schneider kommt zu sich: Beule, Gedächtnislücke. „Mein Schlüsselbund! Der ist weg!“"
  },
  {
   "id": "z_festgesetzt",
   "zeit": "00:03",
   "text": "Das Außentor ist zu, der Bund ist weg, hinter den Mauern gibt es keinen Empfang. Die Gruppe sitzt bis zum Morgen fest."
  },
  {
   "id": "z_handys",
   "zeit": "00:05",
   "text": "Tugba gibt die Handys aus dem Korb zurück. Empfang hat keines."
  },
  {
   "id": "z_umschlag",
   "zeit": "00:12",
   "text": "Ahmet leert den Umschlag mit dem Mietgeld und wirft ihn in den Ascheneimer am Kamin. Hana sieht es."
  },
  {
   "id": "z_auftrag",
   "zeit": "00:20",
   "text": "Herr Schneider bittet das Geburtstagskind: „Finde raus, wer das war. Bis zum Morgen.“"
  },
  {
   "id": "z_runde1",
   "zeit": "00:30",
   "text": "Runde 1: Das Alibi-Geflecht."
  },
  {
   "id": "z_runde2",
   "zeit": "01:15",
   "text": "Runde 2: Die Indizien-Filterung."
  },
  {
   "id": "z_runde3",
   "zeit": "02:00",
   "text": "Runde 3: Die finale Gegenüberstellung."
  },
  {
   "id": "z_finale",
   "zeit": "02:45",
   "text": "Finale: die Anklage."
  },
  {
   "id": "z_morgen",
   "zeit": "07:00",
   "text": "Herrn Schneiders Kollegin kommt mit dem Ersatzschlüssel und schließt das Außentor auf."
  }
 ]
}

SCHNITTSTELLEN:
Datei planung/finalisierung-schlosskeller/varianten/intro-v3.json (NICHT in texte/), Format wie texte/erzaehler-intro.json: {"settingId":"spuk_im_schlosskeller","bereich":"erzaehler","hinweis":"Intro-Fassung 3","eintraege":[{"id":"…","text":"…"}]}. Schlüssel genau: intro.start, intro.lacher.lacher_ruestung.besetzt, intro.lacher.lacher_ruestung.npc, intro.lacher.lacher_verlaufen.besetzt, intro.lacher.lacher_verlaufen.npc, intro.lacher.lacher_kamin.besetzt, intro.lacher.lacher_kamin.npc, intro.auftrag.m, intro.auftrag.w (9 Einträge).
- intro.start: 6–10 Sätze Vorlesetext. Schloss, Abend, die Gruppe, das Buffet im Gewölbe, kurz vor Mitternacht ein Knall, Dunkelheit, Herr Schneider liegt bewusstlos im Vorratsraum gleich hinter der Tür, der Schlüsselbund ist weg, das Außentor ist zu, kein Empfang: Die Gruppe sitzt bis zum Morgen fest. Nicht verraten, wer es war.
- intro.lacher.<id>.besetzt: 2–3 Sätze Rückblick auf den Lacher, die Figur mit Namen (Name aus lacherRollen). .npc: dieselbe Szene, aber die Figur nur neutral („ein Gast“, „eine Freundin“), weil niemand sie spielt.
- intro.auftrag.m / .w: 2–3 Sätze an das Geburtstagskind („du“), das jetzt Detektiv ist; m- und w-Fassung unterscheiden sich nur dort, wo es sprachlich nötig ist.
VORGABE DIESER FASSUNG: Fassung 3: nah am Geburtstagskind, als würde jemand aus der Gruppe erzählen, mit kleinen Rückblicken. Uhrzeiten in Worten, keine Ziffern, keine Klammern.

EIGENE DATEIEN: planung/finalisierung-schlosskeller/varianten/intro-v3.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN und SCHLUESSEL.md.
2. Schreibe die 9 Einträge nach der Vorgabe dieser Fassung.
3. Prüfe mit python3 -m json.tool. Zähle die Wörter je Satz in intro.start.

ABNAHMEKRITERIEN UND TESTWEG: Genau 9 Einträge; kein Spoiler; Lacher als Szene ohne Spott; Uhrzeiten in Worten.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-38
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Wörter intro.start: <Zahl>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-38 · BEREIT ZUR RÜCKGABE ===

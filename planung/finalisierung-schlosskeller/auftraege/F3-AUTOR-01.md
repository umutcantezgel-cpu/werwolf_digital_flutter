F3-AUTOR-01 · Autor · Bauphase F3 · Kanon v1.0 · Schwierigkeit 2

ROLLENBRIEFING AUTOR:
- **Aufgabe:** schreibt Dossiers, Gespräche, Hinweise und Erzählerbausteine nach Kanon-Auszug und TON-LEITFADEN, nur in die zugewiesenen Textdateien.
- **Gute Arbeit:** jede Tatsache stammt wortgleich aus dem Kanon-Auszug; kurze Alltagssätze; klingt wie Freunde Ende zwanzig; jeder Text ist vorlesbar und funktioniert ohne Zusatzwissen.
- **Häufigste Fehler:** 1) neue Fakten erfinden (Uhrzeiten, Orte, Gegenstände, Verwandtschaften), 2) zu lange Sätze, Fachwörter, Ziffern im Vorlesetext, 3) Täterwissen in Texte, die vor dem Finale alle sehen.
Für alle Rollen gilt der Umgang mit Unsicherheit: **Was du nicht sicher aus deinem Auftrag weißt, erfindest du nicht. Du schreibst `OFFENE FRAGE: …` an die Stelle und arbeitest am Rest weiter.**

AUFGABE IN EINEM SATZ: Schreibe die Dossiers (wer ich bin, was ich weiß, was ich verberge, mein Ziel, Besetzungshinweis) für die Rollen Ahmet (ahmet), Fatma (fatma), Olli (olli), Can (can).

DAS PROJEKT IN FÜNF SÄTZEN: Das Spiel ist eine Murder-Mystery-Party-App für Freundesgruppen zwischen 20 und 30 Jahren in Deutschland, lokal im Browser spielbar und als PDF druckbar. Im Fall „Spuk im Schlosskeller“ fällt um Mitternacht bei einer Geburtstagsfeier im Gewölbe eines Schlosses der Strom aus, und danach liegt der Schlossverwalter Herr Schneider bewusstlos im angrenzenden Vorratsraum. Das Geburtstagskind ermittelt als Detektiv mit neun Entscheidungen in drei Runden; die übrigen Gäste spielen Rollen mit Geheimnissen und treffen je Runde eine Wahl, die dem Detektiv hilft oder ihn in die Irre führt. Je nach Fall-Code ist einer von vier Verdächtigen der Täter, vier feste Enden folgen aus Punkten und Anklage, und der Erzähler spricht nur feste Textbausteine. Story und Spiel kommen aus einer Quelle, dem Kanon; jede Arbeit wird gegen ihn geprüft und nur vom Orchestrator integriert.

KANON-AUSZUG (unveränderlich; nur diese Tatsachen verwenden):
[
 {
  "figur": {
   "id": "ahmet",
   "name": "Ahmet",
   "roleTitle": "Der Organisator",
   "geschlecht": "m",
   "herkunft": "bosnisch",
   "besetzungsplatz": 1,
   "alltag": "Arbeitet in einer Agentur, die Stadtfeste und Märkte plant.",
   "persoenlichesZiel": "Niemand soll vor dem Morgen erfahren, dass die Miete erfunden war.",
   "loyalitaet": {
    "zu": "leyla",
    "grund": "Sie sind zusammen aufgewachsen und halten zusammen."
   },
   "motiveAndConflict": "Ahmet hat den Keller umsonst bekommen. Dafür gestaltet er das Programm des Adventsmarkts. Beim Essen hat er viel zu groß bestellt. Statt das zuzugeben, hat er von allen 150 € „Miete“ eingesammelt. Um 23:51 sagt Herr Schneider an der Theke: „Um zwölf sag ich allen, was der Keller gekostet hat.“",
   "roleSecret": "Um 23:57 schlüpft er mit dem Umschlag voller Mietgeld hinter die Theke. Er will Herrn Schneider bitten, um zwölf nichts zu sagen. Das Geld will er morgen allen zurückgeben.",
   "luegen": [
    {
     "id": "luege_ahmet_servietten",
     "behauptung": "Ich hab hinter der Theke nur Servietten gesucht.",
     "wahrheit": "Er wollte Herrn Schneider mit dem Umschlag um Aufschub bitten."
    },
    {
     "id": "luege_ahmet_miete",
     "behauptung": "Die 150 € waren für die Miete.",
     "wahrheit": "Der Keller hat nichts gekostet; das Geld deckt seine zu große Essensbestellung."
    }
   ],
   "nebendelikt": {
    "id": "nd_mietgeld",
    "text": "Hat von allen 150 € Miete kassiert, obwohl der Keller nichts gekostet hat."
   },
   "visualSpecs": {
    "silhouette": "Schlank, aufrecht, sportliche Haltung, Brille, kurzer Bart",
    "outfit": "Schwarzer Strickpulli über weißem T-Shirt, dunkle Jeans, weiße Turnschuhe. Die schwarze Stoffjacke hängt ab 23:55 am Jackenständer im Ost-Saal.",
    "distinguishingFeature": "Blaues Schlüsselband aus der Hosentasche, Handy in der Hand (ab 0:05, vorher im Handykorb)",
    "idleAnimation": "Dreht das Schlüsselband um den Finger und streicht sich nervös durch den Bart"
   },
   "startRoom": "thekensaal",
   "innocentProfile": {
    "actualBehavior": "Duckt sich beim Knall hinter der Theke am Ostende neben Damir und hält den Umschlag fest. Er bleibt dort, bis das Licht angeht. Später leert er den Umschlag und wirft ihn in den Ascheneimer am Kamin."
   },
   "killerProfile": {
    "crimeExecution": "Er kauert erst am Ostende der Theke neben Damir. Dann geht er zum Kerzenlicht an der Anrichte, um Herrn Schneider zu bitten. Herr Schneider, noch außer sich wegen Can, packt ihn am Arm und zischt: „Um zwölf erfahren's alle.“ In Panik greift Ahmet mit der Hand, in der er den Umschlag hält, den Kerzenständer und schlägt einmal zu. Heißes Wachs tropft auf den Umschlag, eine Ecke reißt ab und bleibt am Griff kleben. In Panik reißt er den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt er, dass Flucht alles schlimmer macht. Er steckt den Bund im Ost-Saal in seine eigene Jacke und kauert sich wieder neben Damir.",
    "smokingGun": "Im Wachs am Griff des Kerzenständers klebt eine abgerissene Ecke seines Mietumschlags.",
    "zusatzindiz": "Rote Wachstropfen auf dem leeren Umschlag im Ascheneimer am Kamin; eine Ecke fehlt."
   },
   "blackoutAlibi": "Behauptet, hinter der Theke nach Servietten gesucht zu haben."
  },
  "eigeneBeobachtungen": [],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_foto_streit",
    "zeit": "23:51",
    "text": "Herr Schneider zu Ahmet an der Theke: „Um zwölf sag ich allen, was der Keller gekostet hat.“ Joanna fotografiert den Streit.",
    "pfade": "alle"
   },
   {
    "id": "z_jacke",
    "zeit": "23:55",
    "text": "Ahmet hängt seine schwarze Jacke an den Jackenständer im Ost-Saal.",
    "pfade": "alle"
   },
   {
    "id": "z_theke_2357",
    "zeit": "23:57",
    "text": "Fatma geht mit der Tasche zur Theken-Klappe, Olli holt am Eiskübel Eis, Ahmet schlüpft mit dem Umschlag hinter die Theke. Herr Schneider raunzt Olli an: „Zweitausend, bis zwölf.“",
    "pfade": "alle"
   },
   {
    "id": "z_umschlag",
    "zeit": "00:12",
    "text": "Ahmet leert den Umschlag mit dem Mietgeld und wirft ihn in den Ascheneimer am Kamin. Hana sieht es.",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "fatma",
   "name": "Fatma",
   "roleTitle": "Die Designstudentin",
   "geschlecht": "w",
   "herkunft": "kurdisch",
   "besetzungsplatz": 2,
   "alltag": "Studiert Kommunikationsdesign im letzten Semester.",
   "persoenlichesZiel": "Die Schatulle soll zurück, ohne dass es alle erfahren.",
   "loyalitaet": {
    "zu": "emine",
    "grund": "Emine ist seit der Schulzeit ihre beste Freundin."
   },
   "motiveAndConflict": "Fatma schreibt ihre Abschlussarbeit über alte Münzbilder. Azra hat ihr von der Münzschatulle in der Turmvitrine erzählt. Um 23:40 hebt sie die gesprungene Scheibe an und nimmt die Schatulle mit. Sie will die Reliefs zu Hause abzeichnen und die Schatulle am Montag zurückbringen. Um 23:56 sieht Herr Schneider Glassplitter an ihrem Mantel: „Die Schatulle. Um Punkt zwölf geh ich raus und ruf die Polizei.“",
   "roleSecret": "Nachdem Herr Schneider sie um 23:56 erwischt hat, will sie ihm die Schatulle sofort zurückgeben. Um 23:57 geht sie mit der Tasche zur Theken-Klappe.",
   "luegen": [
    {
     "id": "luege_fatma_buffet",
     "behauptung": "Ich stand die ganze Zeit beim Gebäck am linken Buffet.",
     "wahrheit": "Um 23:57 war sie mit der Tasche an der Theken-Klappe."
    },
    {
     "id": "luege_fatma_tasche",
     "behauptung": "In meiner Tasche sind nur Bücher.",
     "wahrheit": "In der Tasche liegt die Münzschatulle aus der Vitrine."
    }
   ],
   "nebendelikt": {
    "id": "nd_schatulle",
    "text": "Hat die Münzschatulle aus der Turmvitrine mitgenommen."
   },
   "visualSpecs": {
    "silhouette": "Schlanke Statur, dunkles Kopftuch, knielanger Wollmantel",
    "outfit": "Weinroter Wollmantel, dunkler Rollkragen, schwarze Stoffhose, dunkles Kopftuch",
    "distinguishingFeature": "Schwere Umhängetasche aus Leder, breiter Silberring an der rechten Hand",
    "idleAnimation": "Nestelt am Reißverschluss ihrer Tasche und lächelt Emine zu"
   },
   "startRoom": "thekensaal",
   "innocentProfile": {
    "actualBehavior": "Beim Knall zieht sie sich mit der Tasche zum linken Buffettisch zurück und kauert dort gleich danach neben Emine."
   },
   "killerProfile": {
    "crimeExecution": "Beim Knall bleibt sie erschrocken vor der Theke stehen. Dann sieht sie das Kerzenlicht an der Anrichte und geht durch die Klappe hin, um die Schatulle sofort zurückzugeben. Herr Schneider packt den Gurt ihrer Tasche und zischt: „Zu spät. Die Polizei kommt so oder so.“ In Panik greift sie den Kerzenständer und schlägt einmal zu. In Panik reißt sie den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt sie, dass Flucht alles schlimmer macht. Sie steckt ihn in die Brottasche auf dem linken Buffettisch und kauert sich zu Emine.",
    "smokingGun": "Frischer Messingabrieb an ihrem breiten Silberring, passend zum Kerzenständer.",
    "zusatzindiz": "Rote Wachstropfen auf der Münzschatulle in ihrer Tasche."
   },
   "blackoutAlibi": "Behauptet, die ganze Zeit beim Gebäck am linken Buffettisch gestanden zu haben."
  },
  "eigeneBeobachtungen": [],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_vitrine_schatulle",
    "zeit": "23:40",
    "text": "Fatma hebt die gesprungene Scheibe der Vitrine an und nimmt die Münzschatulle mit. Emine sieht es.",
    "pfade": "alle"
   },
   {
    "id": "z_tasche_ausgebeult",
    "zeit": "23:45",
    "text": "Azra sieht, dass Fatmas Tasche auffällig ausgebeult ist.",
    "pfade": "alle"
   },
   {
    "id": "z_schatulle_entdeckt",
    "zeit": "23:56",
    "text": "Herr Schneider sieht Glassplitter an Fatmas Mantel: „Die Schatulle. Um Punkt zwölf geh ich raus und ruf die Polizei.“",
    "pfade": "alle"
   },
   {
    "id": "z_theke_2357",
    "zeit": "23:57",
    "text": "Fatma geht mit der Tasche zur Theken-Klappe, Olli holt am Eiskübel Eis, Ahmet schlüpft mit dem Umschlag hinter die Theke. Herr Schneider raunzt Olli an: „Zweitausend, bis zwölf.“",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "olli",
   "name": "Olli",
   "roleTitle": "Der Anpacker",
   "geschlecht": "m",
   "herkunft": "deutsch",
   "besetzungsplatz": 3,
   "alltag": "Ist Lagerlogistiker und hilft bei jedem Umzug im Freundeskreis.",
   "persoenlichesZiel": "Den Türschaden selbst mit Herrn Schneider klären, ohne die Gruppe hineinzuziehen.",
   "loyalitaet": {
    "zu": "kaan",
    "grund": "Wojtek hat ihm beim Tragen geholfen und hält zu ihm."
   },
   "motiveAndConflict": "Um 18:30 trägt Olli mit Wojtek die Warmhaltebehälter durch den Turm. Dabei schrammt er die geschnitzte Bogentür, ein Beschlag reißt aus. Herr Schneider verlangt 2.000 € Bargeld und schließt die Tore ab: „Keiner geht, bevor das bezahlt ist.“ Um 23:00 streiten die beiden laut.",
   "roleSecret": "Um 23:57 holt er am Eiskübel Eis für Wojteks eingeklemmten Finger. Herr Schneider raunzt ihn an: „Zweitausend, bis zwölf.“",
   "luegen": [
    {
     "id": "luege_olli_tafel",
     "behauptung": "Ich saß die ganze Zeit am Tisch im Ost-Saal.",
     "wahrheit": "Um 23:57 war er am Eiskübel vor der Theke, danach kauerte er am rechten Buffettisch."
    }
   ],
   "nebendelikt": {
    "id": "nd_tuerschaden",
    "text": "Hat die Bogentür beschädigt und wollte die Schramme mit Möbelwachs verdecken."
   },
   "visualSpecs": {
    "silhouette": "Breit gebaut, kräftige Schultern, leicht gebeugte Haltung",
    "outfit": "Grauer Kapuzenpulli, dunkelblaue Daunenweste, Khakihose mit Seitentaschen",
    "distinguishingFeature": "Holzsplitter und weißer Kalk an den Ärmeln des Pullis; der rechte Arbeitshandschuh hängt aus der Westentasche, der linke liegt seit 19:30 am Kamin",
    "idleAnimation": "Reibt sich den Nacken, wechselt das Standbein und schaut auf seine Hände"
   },
   "startRoom": "ost_saal",
   "innocentProfile": {
    "actualBehavior": "Beim Knall tastet er sich vom Eiskübel zum rechten Buffettisch und kauert dort gleich danach neben Azra, bis das Licht angeht. Dann bringt er Wojtek das Eis und setzt sich in den Ost-Saal an die Tafel."
   },
   "killerProfile": {
    "crimeExecution": "Er bleibt erst am Eiskübel stehen. Dann geht er vor der Theke entlang und durch die Klappe zum Kerzenlicht, weil er mit Herrn Schneider reden will. Herr Schneider packt ihn am Ärmel und zischt: „Zweitausend. Sonst Polizei.“ In Panik greift Olli den Kerzenständer am Fuß und schlägt einmal zu. Rote Tropfen fallen auf den Handschuh, der aus seiner Westentasche hängt. In Panik reißt er den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt er, dass Flucht alles schlimmer macht. Er wirft ihn in den Eiskübel und kauert sich zu Azra.",
    "smokingGun": "Holzsplitter und weißer Kalk von seinen Ärmeln kleben im Wachs am Fuß des Kerzenständers, das inzwischen erstarrt ist.",
    "zusatzindiz": "Rote Kerzenwachstropfen auf dem Arbeitshandschuh in seiner Westentasche."
   },
   "blackoutAlibi": "Behauptet, die ganze Zeit am Kopf der Tafel im Ost-Saal gesessen zu haben."
  },
  "eigeneBeobachtungen": [],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_lieferung",
    "zeit": "18:30",
    "text": "Marek liefert das Essen über den Schlosshof und parkt auf Herrn Schneiders reserviertem Platz. Olli und Wojtek tragen die Warmhaltebehälter durch Hoftür, Turmgang und Bogentür.",
    "pfade": "alle"
   },
   {
    "id": "z_tuerschaden",
    "zeit": "18:35",
    "text": "Olli schrammt mit einem Warmhaltebehälter die geschnitzte Bogentür. Ein Beschlag reißt aus, Holzsplitter und weißer Kalk bleiben an seinen Pulli-Ärmeln.",
    "pfade": "alle"
   },
   {
    "id": "z_moebelwachs",
    "zeit": "18:45",
    "text": "Wojtek gibt Olli braunes Möbelwachs aus seiner Werkzeugtasche. Olli reibt es mit seinem rechten Arbeitshandschuh in die Schramme und steckt den Handschuh in die Westentasche.",
    "pfade": "alle"
   },
   {
    "id": "z_forderung",
    "zeit": "18:50",
    "text": "Herr Schneider entdeckt den Schaden, verlangt 2.000 € Bargeld und schreibt es in seinen Quittungsblock. Er schließt Hoftür und Außentor ab: „Keiner geht, bevor das bezahlt ist.“",
    "pfade": "alle"
   },
   {
    "id": "z_handschuh",
    "zeit": "19:30",
    "text": "Olli wärmt sich am noch kalten Kamin die Hände und vergisst dort seinen linken Arbeitshandschuh.",
    "pfade": "alle"
   },
   {
    "id": "z_verlaufen",
    "zeit": "20:15",
    "text": "Lacher: Olli sucht die Toilette, nimmt die falsche Tür hinter der Theke und steht im dunklen Vorratsraum vor der Geburtstagstorte. „Ich wollte nur aufs Klo!“",
    "pfade": "alle"
   },
   {
    "id": "z_streit_olli",
    "zeit": "23:00",
    "text": "Lauter Streit zwischen Herrn Schneider und Olli um die 2.000 €. Pawel versucht zu schlichten und wird barsch abgewiesen.",
    "pfade": "alle"
   },
   {
    "id": "z_olli_eis",
    "zeit": "23:52",
    "text": "Olli zu Wojtek: „Ich hol dir Eis. Und dann red ich mit Schneider.“",
    "pfade": "alle"
   },
   {
    "id": "z_theke_2357",
    "zeit": "23:57",
    "text": "Fatma geht mit der Tasche zur Theken-Klappe, Olli holt am Eiskübel Eis, Ahmet schlüpft mit dem Umschlag hinter die Theke. Herr Schneider raunzt Olli an: „Zweitausend, bis zwölf.“",
    "pfade": "alle"
   }
  ]
 },
 {
  "figur": {
   "id": "can",
   "name": "Can",
   "roleTitle": "Der Spaßvogel",
   "geschlecht": "m",
   "herkunft": "türkisch",
   "besetzungsplatz": 4,
   "alltag": "Macht eine Ausbildung zum Mediengestalter und dreht lustige Kurzvideos.",
   "persoenlichesZiel": "Der Streich soll nicht herauskommen.",
   "loyalitaet": {
    "zu": "zeynep",
    "grund": "Seine Schwester Zeynep hat für ihn Schmiere gestanden."
   },
   "motiveAndConflict": "Can hat am Nachmittag eine weiße Gespenstermaske mit Leuchtfarbe angemalt. Um 23:54 versteckt er sich damit im dunklen Vorratsraum. Um zwölf soll das Geburtstagskind zur Torte kommen und sich erschrecken. Kurz vor zwölf knallt es, das Licht geht aus, und die Tür zum Vorratsraum quietscht auf. Can glaubt, das Geburtstagskind wird schon gebracht, und springt mit „Buuuh!“ hervor. Er läuft Herrn Schneider in die Arme. Der packt ihn an der Kapuze und ruft: „Hab ich dich!“",
   "roleSecret": "Er hat mit der Leuchtmaske im Vorratsraum gewartet. Herr Schneider hat ihn an der Kapuze gepackt.",
   "luegen": [
    {
     "id": "luege_can_toilette",
     "behauptung": "Ich war die ganze Zeit auf der Toilette im Turm.",
     "wahrheit": "Er war im Vorratsraum und ist erst nach dem Zusammenstoß in den Turm gerannt."
    },
    {
     "id": "luege_can_maske",
     "behauptung": "Welche Maske? Ich hab keine Maske.",
     "wahrheit": "Die Leuchtmaske steckt in der Bauchtasche seines Pullis."
    }
   ],
   "nebendelikt": {
    "id": "nd_streich",
    "text": "Hat sich mit der Leuchtmaske im Vorratsraum versteckt, um das Geburtstagskind zu erschrecken."
   },
   "visualSpecs": {
    "silhouette": "Jugendlich, schlank, federnder Gang",
    "outfit": "Signalgelber weiter Kapuzenpulli, weite Jeans, bunte Turnschuhe",
    "distinguishingFeature": "Auffällige gelbe Kapuze, linke Hand tief in der Bauchtasche des Pullis (dort steckt die Maske)",
    "idleAnimation": "Zieht an den Kapuzenbändern und wippt auf den Zehenspitzen"
   },
   "startRoom": "west_saal",
   "innocentProfile": {
    "actualBehavior": "Er reißt sich los und rennt durch den Durchgang, noch bevor es scheppert. Die leuchtende Maske hält er in der Hand. Im Kaminsaal rennt er zur Bogentür, stopft die Maske in die Bauchtasche seines Pullis und versteckt sich oben auf der Toilette im Turm."
   },
   "killerProfile": {
    "crimeExecution": "Herr Schneider hält ihn an der Kapuze fest und zischt: „Jetzt kommt die Polizei, Freundchen.“ In Panik greift Can mit der Hand voller Leuchtfarbe den Kerzenständer von der Anrichte und schlägt einmal zu. Herr Schneider stürzt in den Vorratsraum. Can kniet sich neben ihn und reißt in Panik den Bund vom Gürtel: Wer den Schlüssel hat, kommt raus, bevor das Licht angeht. Gleich danach merkt er, dass Flucht alles schlimmer macht. Er rennt nach dem Scheppern durch den Durchgang und den Kaminsaal, stopft an der Bogentür die Maske in die Bauchtasche, steckt den Bund in den Helm der Ritterrüstung und versteckt sich auf der Toilette im Turm.",
    "smokingGun": "Ein Abdruck einer ganzen Hand in grünlich-weißer Leuchtfarbe um den Griff des Kerzenständers.",
    "zusatzindiz": "Rote Wachstropfen auf der Leuchtmaske."
   },
   "blackoutAlibi": "Behauptet, auf der Toilette im Turm gewesen zu sein."
  },
  "eigeneBeobachtungen": [],
  "zeitleisteMitDieserRolle": [
   {
    "id": "z_can_vorrat",
    "zeit": "23:54",
    "text": "Can schleicht über den Durchgang hinter die Theke in den Vorratsraum, macht dort das Licht aus und wartet mit der Leuchtmaske auf das Geburtstagskind. Zeynep steht am Bogen zum Durchgang Schmiere.",
    "pfade": "alle"
   },
   {
    "id": "z_zusammenstoss",
    "zeit": "23:58:13",
    "text": "Herr Schneider will die Notlaterne holen. Can springt mit der leuchtenden Maske aus dem Vorratsraum, Herr Schneider packt ihn an der Kapuze: „Hab ich dich!“",
    "pfade": "alle"
   }
  ]
 }
]

SCHNITTSTELLEN:
Datei content/party/schlosskeller/texte/dossiers-b1.json, Feld eintraege: genau 4 Objekte nach Schema content/party/schema/texte-dossier.schema.json, z. B.:
{
 "rolle": "<id>",
 "wer": "Zwei bis vier Sätze Vorstellung …",
 "weiss": [
  {
   "ref": "beobachtung:<eigene Pflichtgespräch-Beobachtung>"
  },
  {
   "text": "Eigener Satz ohne neue Tatsache"
  }
 ],
 "verbirgt": [
  {
   "ref": "beobachtung:<eigene verborgene Beobachtung>"
  },
  {
   "ref": "nebendelikt:<id>"
  },
  {
   "ref": "luege:<id>"
  },
  {
   "text": "Warum du schweigst …"
  }
 ],
 "ziel": "…",
 "besetzung": "…"
}
Verweise: beobachtung:<id> nur für Beobachtungen DIESER Rolle (Feld wer), luege:<id> nur für Lügen dieser Rolle, nebendelikt:<id>, zeitleiste:<id> (aus dem Auszug). Pfadabhängige Beobachtungen (pfade ist eine Liste) IMMER beide Fassungen als Verweis aufnehmen; der Code wählt je Pfad die richtige. Bei den vier Kernrollen ist dies die UNSCHULDSFASSUNG (Pfade, in denen die Rolle nicht zugeschlagen hat): nutze innocentProfile und blackoutAlibi, nicht killerProfile. Was die Rolle im Dunkeln wirklich tat, steht als eigener Text-Punkt in verbirgt.

EIGENE DATEIEN: content/party/schlosskeller/texte/dossiers-b1.json

GRENZEN: Schreibe NUR in deine eigene Datei (unten). Keine andere Datei ändern oder anlegen, keine Kanon-Datei, kein Code. Kein Netz, keine Git-Befehle außer git status und git diff. Inhaltsregeln: kein Alkohol (Getränke nur Tee, Kaffee, alkoholfreier Apfelpunsch, Wasser, Säfte), keine Drogen, kein Rauchen (die Pfeife des Detektivs bläst nur Seifenblasen), keine Klischees, keine Fachwörter (Liste im TON-LEITFADEN §5), keine Zungenbrecher, keine echten Personen oder Marken. Herkunft, Religion und Kopftuch sind nie Motiv, Spur oder Pointe. Kein Blut, keine Wunde; Herr Schneider überlebt. Erfinde keine neuen Tatsachen (Uhrzeiten, Orte, Gegenstände, Verwandtschaften, Geschehnisse): Was nicht im Kanon-Auszug steht, gibt es nicht. Andere Agenten schreiben gleichzeitig andere Textdateien: fasse sie nicht an.

LIES ZUERST: planung/finalisierung-schlosskeller/TON-LEITFADEN.md (ganz) und content/party/schlosskeller/texte/SCHLUESSEL.md (ganz). Bei Fragen zum Kanon: content/party/schlosskeller/STORY-BIBEL.md (Kapitel 4 Figuren, 5 Zeitleiste, 7 Beobachtungen).

WERKZEUG: Repo /home/user/werwolf_digital_flutter. Prüfen: source /home/user/werwolf_digital_flutter/.werkzeug/env.sh ; cd /home/user/werwolf_digital_flutter/packages/mordakte_core ; dart test test/party/texte_test.dart (muss grün bleiben; prüft Schema, Verweise, P-1, doppelte Kennungen). Gültiges JSON: python3 -m json.tool <datei> > /dev/null.

MESSBARE TONREGELN: Sätze im Mittel höchstens 14 Wörter, keiner über 25; Alltagssprache von Freunden Ende zwanzig; in Erzählertexten Uhrzeiten und Beträge in Worten, keine Abkürzungen, keine Klammern.

ARBEITSSCHRITTE:
1. Lies TON-LEITFADEN, SCHLUESSEL.md und den Auszug.
2. Schreibe je Rolle wer (2–4 Sätze, Du-Form an die Spielerin: „Du bist …“, kein Geheimnis, sichtbares Merkmal aus visualSpecs), weiss (alle eigenen Beobachtungen mit kanal pflichtgespraech als Verweis, dazu höchstens 2 eigene Sätze aus der Zeitleiste der Rolle), verbirgt (alle eigenen Beobachtungen mit kanal verborgen als Verweis, das Nebendelikt der Rolle als Verweis, falls vorhanden, alle Lügen der Rolle als Verweis, und ein Satz, warum die Rolle schweigt: aus grundVerborgen oder loyalitaet), ziel (persoenlichesZiel in eigenen Worten, 1–2 Sätze), besetzung (1 Satz, dass jede Person die Rolle spielen kann, mit einem Hinweis zur Anrede, falls nötig).
3. Prüfe die Datei mit python3 -m json.tool und mit dart test test/party/texte_test.dart.

ABNAHMEKRITERIEN UND TESTWEG: Genau 4 Dossiers; texte_test grün; jeder Verweis aus dem Auszug; keine neuen Tatsachen.

AUSGABEFORMULAR (gesamte Rückgabe in EINER letzten Nachricht, Markdown, höchstens 900 Wörter):
## Ergebnis F3-AUTOR-01
- Geänderte Dateien: <Liste>
- Umfang: <Anzahl Einträge, Wörter gesamt>
- Längster Satz: <Wortzahl und Fundstelle>
- Tests: <letzte Zeile von dart test test/party/texte_test.dart>
- Verweise je Rolle: <Rolle: Zahl>
## OFFENE FRAGEN
<Liste oder „keine“>

SELBSTPRÜFUNG: Jede Tatsache aus dem Kanon-Auszug? Keine neue Uhrzeit, kein neuer Ort, kein neuer Gegenstand? Sätze gezählt? Nur eigene Datei geändert? Test gelaufen?
Letzte Zeile exakt: === ENDE F3-AUTOR-01 · BEREIT ZUR RÜCKGABE ===

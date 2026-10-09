ABNAHME F1-GEGEN-01 · FREIGEGEBEN · Funktion 2 · Kanon 2 · Verzahnung 2 · Inhalt 2 · Grenzen 2 · Summe 10/10 (E-021)

# Bericht F1-GEGEN-01

## Befunde F1-GEGEN-01

| Nr | Angriff mit Beispielverlauf | Datei/Stelle | Schwere | kleinste Gegenmaßnahme |
|---|---|---|---|---|
| 1 | **Can-Schlüsselbeweis nicht sichtbar.** Die Leuchtfarbe am Griff „schimmert im Dunkeln“. Die Runden liegen bei 00:30, 01:15 und 02:00. Ab 00:00:00 ist der Strom voll an (licht_strom), Tims Stirnlampe brennt bis 07:00. Es gibt also keine Dunkelphase am Kerzenständer, und der einzige Can-Schlüssel ist nicht ermittelbar. | gegenstaende.json spur_griff_leuchtfarbe; raeume.json lichtquellen; wahrnehmung.json licht | hoch | Spur als Lichtbefund formulieren (z. B. „grüner Schimmerfleck, im Licht sichtbar“) oder eine Dunkelphase als Ermittlungsmittel festlegen. |
| 2 | **Abkürzung über den Schlüsselbund.** Der Bund liegt im Täterpfad in genau einem von vier sichtbaren Behältern: Jackeninnentasche (Ahmet), Brottasche (Fatma), Eiskübel (Olli), Helm (Can). Wer diese vier Ziele öffnet, findet den Bund und kennt den Pfad ohne Trenner und ohne Griff- oder Fußspur. Beispiel Can: Helm öffnen, Bund finden, dazu Wojtek-Pflicht „drängte sich … in den Turm“ ergibt Can. | gegenstaende.json bund_schneider.versteckJePfad; beobachtungen b_wojtek_vorbei | hoch | Den Ort des Bundes pfadneutral halten: in allen Pfaden an einem gemeinsamen Ort. Der Pfad entscheidet dann nur über die Trägerspur. |
| 3 | **Abkürzung über den Wortlaut.** Die Schuldfassungen der Trenner tragen Marker, die Unschuldsfassungen nicht: „außer Atem“ (b_azra_olli_spaet, b_emine_fatma_spaet) und „ich bin's wieder“ (b_damir_ahmet_weg). „Außer Atem“ ist aus der Matrix nicht ableitbar. Olli und Fatma gehen nur (max. 1 m/s), Rennen ist Can vorbehalten. Wer Azra oder Emine befragt, hört den Pfad am Satzbau. Nach E-014 prüft der Spoilertest Pflichtgespräche und öffentliche Dossierteile, nicht ausdrücklich die verborgenen Fassungen. | beobachtungen.json, Trenner-Paare | hoch | Beide Fassungen im gleichen Satzbau und ähnlicher Länge. „Außer Atem“ streichen. Zeitbezug nur über „vor/nach dem Scheppern“. Wortlisten-Diff als Test. |
| 4 | **Trenner-Zeugen fehlen bei kleiner Besetzung.** minPlayers: Emine 6 (Fatma-Trenner), Marek 9 (Can), Azra 16 (Olli), Damir 17 (Ahmet). Bei 4 Personen fehlen alle vier. Bei 10 Personen fehlen die Trenner von Olli und Ahmet. Bei 16 fehlt der von Ahmet. Baran (ab 11) als Pflicht-Uhr fällt unter 11 Personen weg; der Erzählerbaustein b_detektiv_gehoert bleibt. Ohne Regel für unbesetzte Zeugen ist die Kette nicht erreichbar. | figuren.json besetzungsplatz/minPlayers; E-013 (NPC-Karte nur erwähnt) | hoch | NPC-Karten-Regel mit beiden Fassungen festlegen (versiegelt wie die Täterkarte). Je Trenner mindestens einen Zeugen im Mindestkader einplanen. |
| 5 | **Ring-Messing mehrdeutig.** Fatma hält Schneiders Bund in der Faust (Regel bund; Träger Fatma 23:58:45 bis 23:58:59). Ist das Schlüsselmaterial Messing, kann der goldgelbe Abrieb am Ring aus den Schlüsseln stammen, und das im eigenen Pfad. | gegenstaende.json spur_ring_messing; wahrnehmung.json hoeren.bund | mittel | Schlüssel aus Stahl festlegen. Die Ringspur um Kantenabrieb an der Kerzenständer-Kante und Schlagrichtung ergänzen. |
| 6 | **Griff-Kontakt in Fremdpfaden.** In Ahmet-, Fatma- und Olli-Pfad ringt Can von 23:58:13 bis 23:58:28 an der Vorratstür, 1,4 m vom Kerzenständer (Anrichte 13,5/8,5). Er hat die Leuchtfarbe in der Hand. Gegenbeispiel: Beim Festhalten streift er den Griff, und die Spur sieht wie im Can-Pfad aus. | ahmet.json ev_can_gepackt/ev_can_losgerissen; Fremdpfade | mittel | In Fremdpfaden Can mindestens 2 m vom Kerzenständer halten (Schneider hält ihn am Durchgang) oder die Spur an eine Greifbewegung mit Handflächenmuster koppeln. |
| 7 | **Wegkollision Ahmet–Damir.** Ahmet geht 23:58:46 bis 23:58:58 über hinter_theke_ost. Dort kauert Damir (sieht nichts, spürt bis 1 m). Im Ahmet-Pfad fehlt Damirs Spürzeile, und der Trenner schweigt dazu. | ahmet.json, Weg; basis.json enes | mittel | Route über die Nordkante (y 7) mit mindestens 1,5 m Abstand. Damirs Wahrnehmung aus der Matrix ableiten lassen. |
| 8 | **Olli-Ärmel als Dauermerkmal.** „Holzsplitter und weißer Kalk an den Ärmeln“ ist ein Figurmerkmal in allen Pfaden. Der Fußsplitter bestätigt damit nur ein pfadgleiches Merkmal. Olli bleibt in allen Pfaden belastet (Ärmel, Handschuh, Klemmbrett-Motiv, Bogentür). | figuren.json olli.visualSpecs; gegenstaende.json spur_fuss_splitter | mittel | Merkmal streichen oder durch ein Nicht-Splitter-Merkmal ersetzen. |
| 9 | **Handschuh-Zeitfrage.** Die Möbelwachsreste setzen voraus, dass Olli den Handschuh beim Auftragen trug. Der Kanon lässt ihn „am Abend“ am Kamin liegen. Die Figur hat einen einzelnen Handschuh in der Westentasche. | gegenstaende.json spur_handschuh_wachs; figuren.json olli | mittel | Zeitfenster festlegen und das Figurmerkmal angleichen. |
| 10 | **Kleinfehler.** Das Vorratslicht endet 23:54:20 ohne Verursacher (pfadgleich, implizit Can). ev_scheppern nennt „Kerzenlicht an der Theke“, die Kerzen stehen an der Anrichte. Die Fasern-Widerlegung „bevor es dunkel wurde“ widerspricht dem Knall um 23:58:00. Der Kerzenständer, der Schneiders Kopf trifft, hat keine Trefferspur. | raeume.json licht_vorrat; ereignisse; spur_fasern_kapuze | niedrig | Ereignis ergänzen, Texte angleichen. |
| 11 | **K-1-Ausnahme Bund.** Der Hinweis in gegenstaende.json erklärt die Bundlage zur einzigen Ausnahme, E-013 verlangt aber eine identische Karte. Konform ist es nur, wenn alle vier Behälter in allen Pfaden als Ziele gelistet sind und der Bund nie als Kartenmarker erscheint. | gegenstaende.json hinweis; E-013 G1-6 | niedrig | Klarstellung im Kanon. |

## Ermittlungswege je Pfad

| Pfad | Ausschluss der drei anderen über | Belastung über | pfadgleich ja/nein |
|---|---|---|---|
| Ahmet | Olli: Azra (frueh, ab 16 besetzt); Fatma: Emine (frueh, ab 6); Can: Marek (vor, ab 9) | Damir (weg, ab 17, verborgen); Schlüsselbeweis Jacken-Innentasche; Zusatz Umschlag-Rückseite am Ascheneimer | ja bei den Zielen; Schnellweg über den Bund (Zeile 2) |
| Fatma | Ahmet: Damir (blieb, ab 17); Olli: Azra (frueh); Can: Marek (vor) | Emine (spät, ab 6, verborgen); Schlüsselbeweis Ring (Zeile 5); Zusatz Wachs am Schatullendeckel | Ziele ja; Ring nein (Mehrdeutigkeit) |
| Olli | Ahmet: Damir (blieb); Fatma: Emine (frueh); Can: Marek (vor) | Azra (spät, ab 16, Wortmarker Zeile 3); Schlüsselbeweis Fuß (Zeile 8); Zusatz Eiskübel-Bund | ja bei den Zielen; Wortmarker und Bund-Schnellweg |
| Can | Ahmet: Damir (blieb); Fatma: Emine (frueh); Olli: Azra (frueh) | Marek (nach, ab 9, verborgen); Schlüsselbeweis Griff (Zeile 1); Zusatz Wachs an der Maskenstirn; Helm-Bund (Fundort) | Ziele ja; Sichtbarkeit nein (Zeile 1) |

Jeder Trenner hat genau einen Zeugen, das ist geprüft. Die Ausschlüsse je Pfad greifen über die Fassungen mit passenden pfade-Listen. Alle übrigen Ziele (Kerzenständer, Jacke, Umschlag, Schatulle, Maske, Ring, Brottasche, Eiskübel, Helm) existieren in allen Pfaden. Die Abweichung liegt nur im Befund.

## OFFENE FRAGEN

1. Gibt es eine Dunkelphase oder ein Lichtmittel, mit dem die Leuchtfarbe in den Runden sichtbar wird? Wie lange nachleuchtet die Farbe nach der Ladung im Licht bis 23:58?
2. Wie werden Trenner-Zeugen bei unbesetzter Rolle geführt? Mit Wortlaut je Pfad, und versiegelt oder offen im PDF?
3. Erreicht der Detektiv alle vier Trenner (vier Befragungen) und einen Schlüsselbeweis in den neun Entscheidungen? Die Dossier- und Entscheidungsdateien fehlen im Auszug und sind so nicht prüfbar.
4. Aus welchem Material ist Schneiders Schlüsselbund? Messing würde Zeile 5 verschärfen.
5. Wann wurde das Möbelwachs aufgetragen, und lag der Handschuh zu diesem Zeitpunkt an Olli?
6. Bleibt der Bund unter dem Eis im Eiskübel bis 00:30 bis 02:00 trocken und sichtbar? Wer hat das Vorratslicht um 23:54:20 ausgeschaltet?

=== ENDE F1-GEGEN-01 · BEREIT ZUR RÜCKGABE ===

HEAD a7f1985

# Gegenprüfung Inhalt, Runde 12 (Auftrag A-702m, Z-12)

Geprüfter Stand: HEAD a7f1985. Schritt 0 war `git merge --ff-only nachtlauf/burgstadt`, Fast-Forward von fb0ec24 auf a7f1985.

## Prüfprotokoll
- Scanner `dart run bin/leitplanken.dart --burgstadt` (Dart unter /opt/flutter/bin; `dart pub get --offline` ok): 119 Dateien, 0 Treffer, 0 Fehler, Exit 0.
- Git-Status nach allen Läufen sauber. Keine Daten geändert, kein commit, kein push, kein Build. Arbeitsdateien nur unter scratchpad/gegenpruefer_a702m/.
- Gelesen: A-702m vollständig; ENTSCHEIDUNGSLOG E23, E27, E29, E31, E33, E34, E35, E37, E38, E39, E40; nachtlauf/kanon/ANPASSUNG.md vollständig; LEITPLANKEN-AUSNAHMEN.md; FORMAT.md; O-Zeilen (223) aus K1, K2 (alle Rollen), K3-HINWEISE, K5, K6, K7, K8, K9.
- Spieltexte: texte/erzaehler.json und texte/tutorial.json vollständig.
- Burgstadt-Daten: stadt/bewohner.json (44) und stadt/haeuser.json (160) vollständig; rollen/faehigkeiten.json vollständig. innenraeume/haeuser.json und fallorte.json: Namen, Legenden und Beschreibungen gelesen; Kartengitter und Texturschlüssel nur strukturell.
- Figuren (pixel_engine/data/figuren: karten, rollen, teile_kleidung, teile_koepfe): alle Textwerte je Schlüsselpfad ausgewertet (Namen, Merkmale, Quellen, Teilkennungen). Zahlen, Farben und Maße nicht inhaltlich geprüft.
- Stichwortsuche über alle Textdaten: Alkohol und Drogen, Blut und Gewalt, Herkunft und Gruppen, Hexen und Filmfiguren, Täter-Merkmale, Namen aus fremden Werken, Uhrzeiten gegen LISTE-ZEITEN.
- L-Zeilen nur zur Widerspruchsprüfung gelesen, nicht zitiert. Frühere Berichte in A-702/ nicht gelesen.

## Befunde

**Befund 1 · gering** · packages/burgstadt_core/data/stadt/bewohner.json · B24 (Dieter Krämer), Felder saetze[0], gerede, nacht[1].tut
- Zitate: „Nimm den Pfad hinter dem Brunnen …“; „… der Ratsdiener sei am Brunnen dem Nebelriesen begegnet …“; „… trägt er Bekanntmachungen zum Brunnen …“
- Regel: LISTE-ORTE [O] (K1) mit der Formatregel „Was nicht in einer Liste steht, darf in Spieltexten nicht als Ort … auftauchen.“ Der Brunnen der Oberstadt steht nicht in der Liste, nur der Hofbrunnen der Burg. E27/H2 erweitert die Liste um Häuser, Gassen und Inschriften, nicht um Brunnen.
- Vorschlag: den Ort über gelistete Namen führen, z. B. „zum Pferdebrunnen“ (Hausname „Eckhaus am Pferdebrunnen“, H-002) oder „zum Marktplatz“. Alternativ den Oberstadt-Brunnen als Farbe in den LISTE-ORTE-Overlay aufnehmen, wie E27/H2.

**Befund 2 · gering** · bewohner.json · B15 (Vera Kessler), Felder wesen, nacht[1].tut, saetze[1]
- Zitate: „… sie kennt die Namen aller Alten im Haus …“; „… notiert die Schlafzeiten der Alten.“; „Meine Schützlinge schlafen gut, wenn man sie lässt.“
- Regel: Leitplanke „keine Klischees … über irgendeine andere Gruppe“. E34/B-2 hat Altersaussagen auf konkrete Personen umgestellt. Die Gruppenbezeichnung „die Alten“ ist davon nicht erfasst. Frau Lang bleibt nach E34 unverändert.
- Vorschlag: „aller Leute im Haus“, „die Schlafzeiten der Bewohner“, „Meine Schützlinge“ durch „Meine Leute“ ersetzen.

**Befund 3 · gering** · bewohner.json · B18 (Gottfried Lenz), saetze[2]; haeuser.json · H-004 (Haus zur Eule), geschichte
- Zitate: „Die Eule über der Tür ist aus Holz …“ (B18) gegen „Eine steinerne Eule sitzt über dem Dachfenster …“ (H-004).
- Regel: Konsistenz zwischen Bewohner- und Hausdaten. Kein O-Konflikt.
- Vorschlag: B18 angleichen, etwa „Die Eule über dem Dachfenster ist aus Stein, aber sie schaut so klug …“.

**Befund 4 · gering** · bewohner.json · B44 (Bernhard Seiler), gerede
- Zitat: „… und der Riese sei damit ins Tal gerutscht …“ (Abstieg am Seil).
- Regel: E39/B-05 hat „H-034 ohne Hinabgleiten am Seil“ beschlossen. Dieselbe Bewegung steht jetzt im Gerücht.
- Vorschlag: Satzteil streichen, sodass nur bleibt: „… der Seiler habe dem Nebelriesen ein Seil gedreht, aber das hat niemand gesehen.“

**Befund 5 · gering (Prüfpunkt)** · haeuser.json · H-053 (Haus zum Fensterladen), inschrift; H-132 (Haus zur Hecke), inschrift
- Zitate: „Hinter Läden wohnt, wer nicht gesehen werden will · 1793“; „Die Hecke schützt, was sie verbirgt · 1754“.
- Regel: Leitplanke „kein Text, der vor der Auflösung die Täterin nahelegt“. Es wird keine Person genannt, aber das Motiv Verbergen liegt thematisch nah an der Auflösung. Kein harter Verstoß, es ist eine Abwägung.
- Vorschlag (optional): neutral fassen, z. B. „Hinter Läden wohnt, wer Ruhe liebt · 1793“ bzw. „Die Hecke schützt den Garten · 1754“.

## Geprüft ohne Befund
- Scanner: 0 Treffer. Manuelle Durchsicht: keine Motive für Alkohol, Drogen, Hexen, Teufel, Walpurgis oder Film-Vampire. „Punsch“ nur als „alkoholfrei“ (Erzähler). Krug, Fass und Kanne nur für Wasser, Öl und Mehl. B14 „Am Brunnen“ ist Teil des Hausnamens „Drechslerei am Brunnen“ (H-041) und kein Befund.
- Verletzung: nur „Beule“, „Kühlpack“, „benommen“ (ERSETZE-17). Keine Blutdetails, das Opfer überlebt.
- Herkunft: keine Herkunft als Motiv, Indiz oder Pointe. Familienfelder des Overlays ohne Fest-, Speise- oder Instrument-Muster. Stadttexte nennen nur generische „Fremde“ (B08, H-012).
- Täter-Hinweise: keine Person in Stadt- oder Spieltexten herausgehoben. Clique-Namen nur in den Rollen- und Figurendaten. Die Spur-Fähigkeit wirkt nur in der Sichtschicht ihrer Rolle (E27/H1).
- Gerüchte um den Nebelriesen beschreiben Wege (Kamin, Schächte, Mauer, Seil). Prüfhinweis, kein Befund: Die Legende bleibt Gerücht (Begriff GL-15 [O]). Bewegungsangaben nicht weiter ausbauen.
- Zeiten: 22:05, 23:50 und 23:51 (R09), 21:20 (H-18), 23:52, 23:58 und 00:05 (Figurenzustand), 03:00 (Ofen, Uhrturm), 22:00 (Tore) stimmen mit LISTE-ZEITEN bzw. O-Zeilen überein.
- Figuren: Namen, Berufe, Kleidung, Schuhe, Merkmale und Quellen stichprobenartig gegen K2 und K9 abgeglichen, keine Abweichung. Kopftuch- und Afro-Teile sind ungenutzt (E39/B-10).
- Plagiat: Namen aus Filmen, Serien, Spielen und Büchern (u. a. Holmes, Watson, Poirot, Cluedo-Figuren, Die drei ???, TKKG, Hogwarts) ohne Treffer. Satzstichprobe ohne wörtliche Übernahmen. Die Inschrift „Der Turm sieht ins Tal, das Tal sieht zurück“ (H-141) lehnt sich nur an ein bekanntes Aphorismus-Muster an, kein Befund.

## Bereits entschieden (E23–E40), nicht als Befund gezählt
- E23/E29: „benommen“ im Spiel über ERSETZE-17 umgesetzt. „bewusstlos“ steht nur im O-Datensatz.
- E27: Kanon-Spuren (M5), Fähigkeit von R03 nur für R03 (H1), Teile im Code (M2), „Einspruch!“ (G3), Häuser in LISTE-ORTE (H2).
- E33, E34, E35: R06 „kurz benommen“, Ziegelei, LISTE-ZEITEN-Erweiterung, Hund-Satz (B09) umgesetzt.
- E37, E39: Kameragurt (R19) ergänzt, Knöpfe nur im Fundus, Rennen aus den Hinweisen entfernt. H-140 und H-143 (Schachtmotive) bleiben nach E39/B-04 als Gänsehaut ohne Versteck-Bild. Das Gerücht B08 („durch die alten Schächte“) gehört zu diesem Typ.
- E38: Familienfelder per Overlay, Wanderstiefel aus zwei Teilen.
- E40: Dutt-Frisur bei älteren Bewohnerinnen bewusst offen. Frau Lang (B15) bleibt nach E34 als Person belassen.
- Zu diesen Abwägungen liegt kein neuer Grund vor, daher sind sie nicht als Befund gezählt.

## Urteil
- Leitplanken eingehalten: ja. Scanner 0, keine Verstöße in der manuellen Durchsicht. Befund 2 betrifft die Formulierung, nicht einen Verstoß.
- Kanontreu: ja. Kein O-Datensatz widersprochen. Befund 1 ist ein Ortsnamen-Fehler außerhalb der Liste ohne Lösungsbezug.
- Plagiatsfrei: ja.
- Befunde: hoch 0 / mittel 0 / gering 5.
- Folge nach der E40-Abbruchregel (ja · ja · ja): Die geringen Befunde gehen in „FÜR DEN NUTZER“, es ist keine weitere Runde nötig.

Leitplanken eingehalten: ja · Kanontreu: ja · Plagiatsfrei: ja

---
*Ablage:* Der Prüfer (Haiku, A-702m) durfte keine Berichtsdatei anlegen und hat den Text in seiner Endmeldung übergeben. Opus hat ihn unverändert in diese Datei übernommen; nur diese Fußnote ist ergänzt.

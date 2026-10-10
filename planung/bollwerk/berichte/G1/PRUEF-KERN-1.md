# PRUEF-KERN-1 · Gegenprüfung Würfelkern V1

Nur gelesen; Zeilen in `V1/quelle/`, „Z.“ ohne Datei = zugschicht.dart. Z-03…Z-07 nach der Kurzfassung im Auftrag (der Master-Prompt lag nicht vor).

**Urteil: teil.** Kein BLOCKER, 9 MAJOR, 5 MINOR. Schwellen, Seed, Kosten, Reserve und Garantie halten A-4 ein, Marken, Abstecher-„gründlich“ und Ablaufsperren nicht.

## WÜ-Prüfung

- **WÜ-1 – erfüllt, mit Lücken.** Der Seed `wuerfel:$salz:$id:$anlauf` über `Rng` stimmt exakt (wuerfel.dart:87–93); ein Grep nach `hashCode`, `dart:math`, `DateTime`, `Stopwatch`, `FallCode` ergibt 0 Treffer. Aber der Kern nimmt jede Quelle und Abstecher-Id an (B13), und die Bänder würfeln aus dem Bot-Strom (B4).
- **WÜ-2 – Befund (B10).** Die Chancen stimmen (bei +0: 28/30/42 %), und die Würfe stehen in `wuerfe`. Der Garantie-Zustand ist aber privat (zugschicht.dart:57–65), deshalb liefert der Kern keine Chance vor dem Wurf.
- **WÜ-3 – Befund.** Die Kettensperre zählt nur (B3), die Marken weichen ab (B1), und der Beweis C8 Nr. 1a fehlt (B5).
- **WÜ-4 – erfüllt.** `wertung` ruft `sim.verlauf(optionsfolge)` auf (Z. 258), und kein Wurf erreicht `gewaehlt`. Gemessen werden nur Punkte (B6), und die Nebenwertung fehlt (B12).
- **WÜ-5 – erfüllt, aber ungetestet.** Der Pfad wirkt nur in `_decke` (Z. 245–246). Kein Test vergleicht Pfade (B9).
- **WÜ-6 – erfüllt.** Keine Uhr, geordnete Sammlungen; im Protokoll fehlen die Eingaben (B10).

## K-Prüfung

- **K-03 – teilweise.** Die Folgeentscheidung fehlt im Kern. Sie gehört als Zugtyp mit Kettensperre in zugschicht.dart. „Genau ein `Spiel.waehle`“ und „Auftakt einmal in Runde 1“ werden nicht erzwungen (B3).
- **K-05 – erfüllt für Pflichtzüge.** `istSuche` (Z. 53–54) ergibt e2_1, e2_2, e2_3, e3_1 und e3_2. Beim Abstecher ist der Wurf ein freier Schalter (B13).
- **K-06 – erfüllt.** `modifikator` hängt weder an Helfer noch an Ziel, Option oder Pfad (wuerfel.dart:32–38).
- **K-07 – Befund.** Die Schwellen 9/7, der Deckel +2 und Pech 15/10/6 von 36 stimmen (wuerfel.dart:19–37). „≤ 2 je Wissensziel“ fehlt (B1), und „gründlich“ im Abstecher kostet nichts (B2).
- **K-10 – Befund.** Die Garantie hat keinen Deckel (Z. 202), und der Tischruf ist erzwungen (Z. 200). Pech bringt aber keine Marke (B1).
- **K-11 – Befund.** Die Kosten stimmen bis auf B2 und B14.
- **K-12 – erfüllt.** Die Reserve gilt (Z. 139); vor jedem Öffnen ist `rest ≥ 14 × offene Pflichtzüge`, und „gründlich“ steckt in den 14 min. Die Schranke ist mit Standardwerten unerreichbar.
- **K-13 – Befund.** Die Liste entspricht C2 (aus entscheidungen.json nachgerechnet), wird aber nur gezählt (B3).
- **K-14 – erfüllt.** `waehle` wirft bei offener Untersuchung (Z. 177); der Beleg ist aber auch bei leerer Karte grün (B7).
- **K-15 – erfüllt.** Die Wertung hängt nur an `gewaehlt`. Ende, Gruppenwahl, Bonus, Rückblende und Schneider werden nicht gemessen (B6).
- **K-23 – erfüllt.** Der Seed nutzt `u.id` (Z. 201). Die Tests würden einen Bruch nicht bemerken (B9).
- **K-24 – im Kern nicht vorgesehen.** Rest je Runde (Z. 119), Abstecherzähler und Markenbestand fehlen; das gehört in zugschicht.dart (B12).

## L2-Tötungsprüfung

- **Pech-Garantie (46–56).** Tötet: Garantie fehlt oder greift erst ab Anlauf 4; Reserve ohne Pech-Zuschlag (Runde 1: rest 7 → −3). Tötet nicht: Garantie ab Anlauf 2, Garantie mit Deckel, leere Kettensperre, Schranke, Marken.
- **Wertung (58–72).** Tötet: Wurf ändert Option oder `z.fakten`. Tötet nicht: Ende, Gruppenwahl, Bonus; `mit`/`ohne` ist tautologisch (beide `sim.verlauf` derselben Folge).
- **Faktenstand (74–85).** Tötet: Das Wissen kommt erst nach dem nächsten Öffnen. Tötet nicht: zugschicht.dart:181 gelöscht (Karten leer, Schleife läuft 0-mal); Gleichtaktfehler in `_decke`.
- **Seed (87–97).** Tötet: anderes Format von `seedText`, Quelle mit Zustand. Tötet nicht: fester Seed in `augen`; Options-Id in zugschicht.dart:201, obwohl der Titel genau das verspricht.
- **Chancen (99–109).** Tötet: Teilerfolg-Schwelle, Pech-Zahlen, Garantie, Deckel. Tötet nicht: `erfolgAb = 10`, Werkzeug +2, „gleiche Chance je Option“ (der Test enthält keine Option).
- **Budget/Suchen (111–117).** Tötet: Kosten, Such-Regel. Tötet nicht: `zweit`, `dritt`.
- **Determinismus (119–126).** Tötet: Nichtdeterminismus im Prozess. Tötet nicht: geänderte Seed-Formel (kein Goldprotokoll), Pfadabhängigkeit (nur `can`).

## Simulator-Lücken

- **Z-03:** C8 Nr. 1a fehlt (B5); konstante Ströme ergeben nur E, T, PPT (nie PE, PT, PPE); die Referenz ist der Pech-Lauf (B7); Zufallsströme prüfen weder Kette noch Budget noch Faktenstand; andere Glieder als `fakt:` bleiben vor der Anzeige ungeprüft (C7 Solo).
- **Z-04:** Geprüft werden nur Punkte (B6). Es fehlen Ende je Anklage, Restverdächtige, Gruppenwahl, Bonus, Rückblende, Schneider, die 100 Ströme (C8 Nr. 2) und die Entkopplung (C8 Nr. 6).
- **Z-05:** Kein Tor für Runden ohne Wurf und für Sackgassen; nur `neutral`, 200 statt 10.000 Seeds (B11); Würfel aus dem Bot-Strom (B4).
- **Z-06:** Offen sind ρ(Chance, richtig), ρ(Kosten, richtig) und der Geiz-Bot (B8).
- **Z-07:** Offen: Gerätezeit ohne Schwelle; Abend, Solo, Szene je Zug und Werte je Pfad fehlen (B8).

## Befunde

| Nr | Schwere | Datei:Zeile | Regel | Szenario | Ersatz |
|---|---|---|---|---|---|
| 1 | MAJOR | zugschicht.dart:96–97, 130, 142, 153–156, 205–209; wuerfel_sim.py:92, 100 | K-07 „Seifenblasen-Marke +1 (≤ 1 je Wurf, ≤ 2 je Wissensziel, ≤ 3 je Partie)“; K-10 „Glück im Unglück (Marke + harmloser wahrer Satz)“ | Der erste Wurf löst eine nie verdiente Marke ein; e2_1 nimmt drei; Auftakt-Pech kostet eine Marke, statt eine zu bringen. So wurden die Bänder gemessen (Pech im 1. Anlauf bis 34,0 %, Grenze 35 %). | `markenBestand`/`markenEingeloest` statt `marken`; jedes Pech `markenBestand++`; einlösen nur bei `markenBestand > 0`, `markenEingeloest < 3`, `u.marken < 2` und Modifikator ohne Marke < 2. In der Vorlage genauso; Bänder neu messen. |
| 2 | MAJOR | zugschicht.dart:139, 145–152; runden_simulate.dart:133; wuerfel_sim.py:19, 108–113 | K-07 „„gründlich“ +2 (+2 min)“; K-12 „Ein Abstecher oder „gründlich“ nur, wenn danach Restzeit − 3 min (…) ≥ Σ …“ | Der Gier-Bot bekommt im Abstecher +2 umsonst; darauf beruht „0 Budgetüberschreitungen (Gier-Bot eingeschlossen)“. Mit +2 min bei gleicher Prüfung drohen bis zu 2 min Überschreitung. | `bool abstecherErlaubt({bool gruendlich = false}) => _lauf == null && rest - p.abstecher - (gruendlich ? p.gruendlich : 0) - p.abstecherPechZeit >= reserveBedarf;` und `rest -= p.abstecher + (gruendlich ? p.gruendlich : 0);`. In der Vorlage genauso; Kommentar wuerfel_sim.py:19 auf „+2 min“. |
| 3 | MAJOR | zugschicht.dart:116–121, 125, 178–185 | K-13 „Eine Entscheidung öffnet, wenn alle Vorgänger ihrer Liste gespielt und abgeschlossen sind“; C2 „Keine Kanon-Entscheidung verfällt je“ | `waehle('e1_1_damir')`, dann `beginneRunde(2)`: e1_2/e1_3 gehen verloren, e2_1 öffnet trotz Kette, `optionsfolge` wirft. `waehle('e2_2_vitrine')`, während e2_1 dran ist: Z. 178 entfernt e2_1, bevor Z. 180 wirft. | Erst prüfen, dann ändern: `final id = offen.first; _e(id).option(option); final fehlt = [for (final v in kettensperre[id] ?? const <String>[]) if (!aufgedeckt.contains(v)) v]; if (fehlt.isNotEmpty) throw StateError('Kette $id: $fehlt'); offen.removeAt(0);`. `beginneRunde` wirft bei offenen Zügen oder `r != runde + 1`; `auftakt` nur einmal in Runde 1. |
| 4 | MAJOR | wuerfel_sim.py:57–58, 209–212; runden_simulate.dart:31–38, 276–279 | C7 „Bot-Strom: … nie der Würfelstrom“; C3 „Die Chance korreliert nicht mit „Option richtig“ (\|ρ\| ≤ 0,1)“ | Würfel und Bot ziehen aus `Random(s)` mit gleichem `s`; Wort 0 bestimmt `wahl[e1_1]` (`_randbelow(2)`) und den ersten Auftakt-Würfel (`_randbelow(6)`). Bei oberstem Bit 0 ist e1_1 genau dann richtig, wenn der Würfel 3 oder 4 zeigt. | `Strom("zufall", seed("wuerfel", s))` bzw. `PyStrom(pySeed(['wuerfel', s]))`, in Dart besser `SalzWuerfel('meta:$s')`; danach neu messen. |
| 5 | MAJOR | runden_simulate.dart:365–369; wuerfel_sim.py:176–180 | WÜ-3 „Belegt wird das mit einem erschöpfenden Beweis (C8 Nr. 1)“; C8 1a „jede Ausgangsfolge (E, T, PE, PT, PPE, PPT …)“ | Der Port rechnet nur `3*14 <= 45`, die Vorlage setzt `alle_aufgedeckt=True` fest. Deckt ein Erfolg nach Pech nichts auf, bleibt L4 trotzdem grün. | `SkriptWuerfel implements WuerfelQuelle` mit Augen je `'$id#$anlauf'`; für jede Suche × Folge × {nochmal, umweg} × gründlich prüfen: `aufgedeckt.length == 9`, Fakten wie im Kanon, Kosten ≤ 14. |
| 6 | MAJOR | runden_simulate.dart:219, 235–237; wuerfel_sim.py:194–195 | WÜ-4 „Er ändert nie: … Restverdächtige, Bonus-Qualität, Gruppenwahl-Wertung, Ende, Rückblende, Schneiders Überleben“ | `wertung_abweichend` vergleicht nur Punkte. „Wertung ≠ Neutralwurf: 0 von 313.344“ deckt weder Ende noch Restverdächtige ab. | Schlüssel `[v.punkte, v.restNachRunde, v.fakten, for (final a in w.kanon.kernverdaechtige) w.sim.enden.ende(v.punkte, a == pfad).id]` mit `v = lg.z.wertung(w.sim, pfad)`, dazu die Ergebnisse der Party-Engine und 100 `SalzWuerfel`-Ströme. |
| 7 | MAJOR | runden_simulate.dart:236–245, 263–270; wuerfel_sim.py:194–199; eigenschaften_test.dart:79–84 | K-14 „Beim Öffnen jeder Entscheidung ist der Faktenstand gleich dem Lauf ohne Würfel“ | Der „Neutralwurf“ ist in Wahrheit der Lauf „immer Pech, n = 4“. Fehlt zugschicht.dart:181, bleiben L2-Test 3 und beide L4-Zähler bei 0. | `for (final e in w.ermittlung.entscheidungen) { ref[e.id] = Set.of(f); f.addAll(w.ermittlung.faktenVon(wahl[e.id]!, pfad)); }` mit leerem `ref` und `f`; zählen bei `length != 9` oder Abweichung von `ref`; im Test `hasLength(9)`. |
| 8 | MAJOR | runden_simulate.dart:10, 85, 406–409 | Z-06 (C8 Nr. 4 „Geiz-Bot … ≤ 4,8 Punkte und in keinem Pfad ≥ 7“); Z-07 (C7 „Median ≤ 6 min, P95 ≤ 10 min“) | `fairness` und `dauer` enden OFFEN; `geiz` wählt nie selbst. | `fairness`: ρ(Chance, richtig), ρ(Kosten, richtig) und ein Geiz-Bot, der die billigste Karte nimmt; `dauer`: Schwellen je Form und Pfad. |
| 9 | MAJOR | eigenschaften_test.dart:87–97, 119–126 | K-23 „die Id ist die der Entscheidung, also gleiche Zahl für jede Option“; WÜ-5 | Mit `_werfen(u.option, …)` in zugschicht.dart:201 oder festem Seed in wuerfel.dart:91 bleiben alle 7 Tests grün, L4 ebenso (nutzt `SalzWuerfel` nie). | Bei gleichem `SalzWuerfel` und gleicher Strategie: andere Wahl ⇒ gleiches `protokoll`, anderer Pfad ⇒ gleiche `ereignisse`; χ² über 36.000 `augen` < 23,2. |
| 10 | MINOR | zugschicht.dart:57–65, 224–237; wuerfel.dart:110–127 | WÜ-2 „Jeder Wurf ist sichtbar und protokolliert“; C7 „Protokoll der Eingaben und Würfe“ | Die Oberfläche muss `anlauf ≥ 3` nachbauen; der Tischruf fehlt im Protokoll; bei `mod` = 2 bleibt offen, ob eine Marke verbraucht wurde. | `vorschau({werkzeug, marke})` gibt `mod`, `garantie` und Prozent zurück; `Wurf` speichert auch `werkzeug`, `gruendlich` und `marke`; `ereignisse.add('${u.option}:ruf:${ruf.name}')`. |
| 11 | MINOR | runden_simulate.dart:318, 329, 356, 387–399 | C2 „je Runde ≥ 1 Wurf, nie jede Entscheidung“; C8 Nr. 13 „10.000 Seeds je Form und Besetzung“ | Eine Runde ohne Wurf oder eine Sackgasse lässt den Lauf GRÜN. Voreingestellt sind 200 Seeds. | `if (d('anteil_jede_runde_mit_wurf') < 1) rot.add('${e.key}:runde'); if (d('sackgassen') > 0) rot.add('${e.key}:sack');`, Standard `--seeds 10000`. |
| 12 | MINOR | zugschicht.dart:92–102, 119, 249–252 | K-24 „+1 je Lupe, Abstecher, übrige Marke und je 5 Restminuten“ | Der Rest früherer Runden ist überschrieben, und niemand zählt die Abstecher. | `restJeRunde.add(rest)` in `beendeRunde`, `abstecherZahl++`; `seifenblasenBilanz => erfolgeMitZusatz + abstecherZahl + markenBestand + restJeRunde.fold(0, (s, r) => s + r ~/ 5)`, getrennt von `wertung`. |
| 13 | MINOR | zugschicht.dart:145; eigenschaften_test.dart:24 | K-05 „Befragungen nie, in keiner Form“; K-23 „Nie laufende Wurfnummer“ | `abstecher('a2_3', mitWurf: true, werkzeug: true)` würfelt auch bei Befragung, nimmt eine laufende Nummer als Id und gibt Werkzeug ohne Besitz. | `abstecher(AbstecherKarte a)`: Id aus content/runden, Wurf aus `a.ziel` wie bei `istSuche`, `werkzeug` nur bei Besitz. |
| 14 | MINOR | zugschicht.dart:32; wuerfel_sim.py:82 | K-11 „Schlechtester Pflichtzug 6 + 2 + 3 + 3 = 14 min“ | Die Formel rechnet `2 * umweg`. Mit `zweit: 4` bliebe die Reserve bei 14, obwohl der Zug 15 kostet. | `pflicht + gruendlich + (zweit > umweg ? zweit : umweg) + (dritt > umweg ? dritt : umweg)`, ohne `dart:math`. |

**Selbstprüfung:** (a) 6 WÜ-Zeilen ✓ · (b) 12 K-Zeilen ✓ · (c) 7 L2-Zeilen für 7 Tests ✓ · (d) 14/14 Befunde mit Datei:Zeile ✓ · (e) 14/14 mit Ersatz ✓ · (f) ≤ 1.800 Wörter ✓

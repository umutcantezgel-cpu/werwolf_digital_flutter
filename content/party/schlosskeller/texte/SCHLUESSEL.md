# Textsammlung · Schlüssel und Regeln (F3-ORCH-00, E-026)

Diese Datei ist die Anleitung für alle Autorinnen und Autoren. Der Lader ist `packages/mordakte_core/lib/src/party/texte.dart`. Die Prüfungen laufen in `test/party/texte_test.dart` (Verweise und Regeln) und am F3-Tor über `textLuecken` (Vollständigkeit).

## Grundsätze
1. **Eine Quelle.** Tatsachen stehen schon im Kanon: Beobachtungen, Spuren, Lügen, Nebendelikte, Zeitleiste, Entscheidungen und Bonus-Hinweise. Texte schreiben sie nicht ab, sondern verweisen auf sie:
   - `beobachtung:<id>`
   - `luege:<id>`
   - `nebendelikt:<id>`
   - `zeitleiste:<id>`
   - `spur:<id>`

   Pfadabhängiges Wissen setzt der Code je Pfad ein. Eine Beobachtung, die es im Pfad nicht gibt, fällt weg.
2. **Jede Kennung genau einmal.** Jede Datei gehört genau einem Auftrag. Bei einer Doppelung gilt der erste Eintrag, und die Prüfung wird rot.
3. **Ton** nach `planung/finalisierung-schlosskeller/TON-LEITFADEN.md`:
   - Sätze im Mittel höchstens 14 Wörter, keiner über 25.
   - Keine Fachwörter.
   - Kein Alkohol, keine Drogen, kein Rauchen.
   - In Vorlesetexten (Erzähler) Uhrzeiten und Beträge in Worten.

## Dateien (Liste in `index.json`)
| Datei | Bereich | Einträge |
|---|---|---|
| `erzaehler-intro.json` | erzaehler | `intro.start`, `intro.lacher.<lacher>.besetzt` und `.npc` (je 3), `intro.auftrag.m`, `intro.auftrag.w` |
| `erzaehler-runden.json` | erzaehler | `runde.1.start` bis `runde.3.start`, `bonus.rahmen`, `resuemee.gruppe.1` bis `.3`, `resuemee.rest.*` (12), `resuemee.lage.<runde>.<offen\|spur\|klar>` (9), `anklage.start` |
| `erzaehler-finale-<pfad>.json` | erzaehler | `finale.<pfad>.<ende_meister\|ende_teilerfolg\|ende_justizirrtum\|ende_eskalation>`, `rueckblende.<pfad>` |
| `erzaehler-aufloesung.json` | erzaehler | `aufloesung.gruppe.0` bis `.3`, `aufloesung.<rolle>` (16 Nebenrollen), `aufloesung.<kernrolle>.taeter` und `.unschuldig` (8) |
| `dossiers-b1.json` bis `-b5.json` | dossier | je Rolle: `rolle`, `wer`, `weiss[]`, `verbirgt[]`, `ziel`, `besetzung` |
| `taeter-<pfad>.json` | taeter | `rolle`, `tarnung`, `tatwissen[]`, `verbirgt[]`, `ziel` |
| `detektiv.json` | detektiv | `detektiv.m.*`, `detektiv.w.*`, `ermittlungsbogen.*` |
| `gespraeche-r<N>-b<B>.json` | gespraech | `g_<rolle>_<runde>_<nr>` mit `partner`, `thema`, `ziel`, `preisgabe[]`, `text` |
| `wahlen-kern.json`, `wahlen-b2.json` bis `-b5.json` | wahl | `gw_<rolle>_<runde>` mit `a`, `b`, bei Kernrollen `sabotage` |
| `ui.json` | ui | `ui.*` (F4) |

Die Kennungen der Erzählerbausteine kommen aus `Erzaehler.katalog()`; andere Kennungen sind dort verboten.

## Sichtbarkeit
- **Vor dem Finale, am Tisch:**
  - Erzählerbausteine außer `finale.*`, `rueckblende.*` und `aufloesung.*`
  - `dossier.wer`, der Vorstellungstext
  - `thema` und `text` der Pflichtgespräche
- **Nur die eigene Rolle:** `weiss`, `verbirgt`, `ziel` (Dossier und Pflichtgespräch), Täterfassung, Wahltexte.
- **Nur der Detektiv:** `detektiv.*` und `ermittlungsbogen.*`.
- **Erst in der Auflösung:** die Begründungen der Entscheidungen (`entscheidungen.json`, `begruendung` je Pfad) und die Qualität der Hinweise. Vorher verrieten sie den Pfad.
- **Was der Detektiv findet:** Fundtexte (`zeigt` und `harmlos` der Spuren in `gegenstaende.json`) und Ergebnisse der Entscheidungen erscheinen, sobald eine Entscheidung sie aufdeckt. Ab dann gehören sie zum Wissen des Detektivs und dürfen am Tisch stehen. Fundtexte sind unpersönlich, ohne „du“, und verneinen nichts („kein Messing“ schlösse jemanden aus).
- **Spoilerregel (S-1):** Sie gilt für alles, was die App oder der Erzähler am Tisch zeigt. Was eine Rolle unter `weiss` kennt, darf ihre Spielerin selbst erzählen; das ist Spiel, kein Spoiler.
  - Einzelregeln:
  - Nichts, was am Tisch steht, verrät den Täter-Pfad oder geht über das Wissen des Detektivs hinaus.
  - `resuemee.rest.eins` nennt keinen Namen.
  - `bonus.rahmen` sagt nie, ob ein Hinweis stimmt.

## Regeln für Finale und Ausgang (E-029)
- Das Finale kennt nur Täterpfad, Ende und Punkte, nicht den Verlauf. Kein Finaltext sagt deshalb, ob das Geburtstagskind den Bund in der Nacht gefunden hat.
- **Richtige Anklage** (`ende_meister`, `ende_teilerfolg`): Die Täterperson gesteht und gibt den Bund heraus. Herr Schneider schließt das Außentor erst auf, als es dämmert; bis dahin gibt es Torte und Tee (Master 7.9, E-039).
- **Schlüsselbeweis im Meister-Ende** (E-039): Er kommt erst nach dem Geständnis, wenn alle gemeinsam hinsehen. Meister-Detektiv gibt es ab sieben Punkten, also auch ohne die Entscheidung, die ihn aufdeckt.
- **Falsche Anklage** (`ende_justizirrtum`, `ende_eskalation`): Der Bund bleibt verschwunden. Um sieben Uhr schließt Herrn Schneiders Kollegin mit dem Ersatzschlüssel auf (`z_morgen`). Die Täterperson gesteht erst danach.
- Eine falsch angeklagte Person wird nie beim Namen genannt; der Text passt für jede.
- Die Rückblende erzählt die Tat nach der Tatmatrix des Pfads: Weg zur Tat, Schlag, die Spuren, die dabei entstehen, und das Versteck des Bunds.
- Anrede: Das Geburtstagskind heißt in Finaltexten „du“ (TON-LEITFADEN §3).

## Regeln für Dossiers
- Dossiers sprechen die Spielerin oder den Spieler mit „du“ an.
- `wer`: Vorstellung in zwei bis vier Sätzen. Öffentlich bekannte Beziehungen (Geschwister, Cousins, beste Freundinnen) dürfen hier stehen; was jemand für einen anderen tut oder verschweigt, nicht. Name, Alltag, Bezug zur Gruppe, sichtbares Merkmal. Kein Geheimnis.
- `weiss`: was die Rolle sicher weiß und am Tisch sagen darf. Nichts, was ein eigenes oder fremdes Geheimnis verrät. Verweise nur auf eigene Beobachtungen der Rolle (Feld `wer` der Beobachtung). Eigene Sätze nur ohne neue Tatsachen.
- `verbirgt`: verborgene Beobachtungen der Rolle, Nebendelikt, eigene Lügen. Eine Lüge erscheint mit Behauptung und Wahrheit. Ein Satz dazu, warum die Rolle schweigt (aus `grundVerborgen`, `loyalitaet` oder `persoenlichesZiel`, E-029). Was das eigene Motiv verrät, steht hier und nicht unter `weiss`.
- `ziel`: das persönliche Ziel aus `figuren.json`, in eigenen Worten.
- `besetzung`: ein Satz, wie die Rolle von jedem Geschlecht gespielt wird.
- **Täterfassung:**
  - `tarnung`: was die Person über die Tatsekunden erzählt.
  - `tatwissen`: was wirklich geschah, aus `killerProfile` und der Tatmatrix des Pfads.
  - `verbirgt`: Lügen und Nebendelikt. Die Spuren der Tat stehen als `spur:<id>` in `tatwissen`.
  - `ziel`: unentdeckt bleiben, ohne Unschuldige ins Unglück zu stürzen.

## Regeln für Pflichtgespräche (P-1 bis P-4)
- Drei je Rolle und Runde: `nr` 1 bis 3.
- `partner` ist eine Rolle oder `detective`, der Wunschpartner. Am Abend legt der Gesprächsplan (E-028, `Besetzung.gespraechsplan`) den tatsächlichen Partner fest:
  - Ein besetzter Wunschpartner bleibt.
  - Fehlt er, kommt der erste besetzte Ersatzpartner aus `besetzung.json` mit freier Last, sonst die besetzte Person mit der kleinsten Last.
  - Höchstlast je Runde: 7 Gespräche je Rolle, als Sprecher und als Partner zusammen, 6 für den Detektiv.
- **P-2, partnerneutral:** Kann der Partner ersetzt werden (jede Rolle außer Ahmet, Fatma, Olli und Can), nennen `thema`, `ziel` und `text` ihn nicht, auch nicht als Anrede. Sie schreiben ihm nichts zu: keinen Beruf, keinen Ort, keine Verwandtschaft, keine Beobachtung. Die App zeigt den tatsächlichen Partner auf der Karte. Kernrollen und den Detektiv darf der Text ansprechen; den Detektiv ohne Namen, mit „du“.
- **P-3, eigenes Wissen:** Der Text nutzt nur die eigene `preisgabe`, die eigene Vorstellung (`dossier.wer`) und was alle wissen (Intro: Knall, Dunkelheit, Herr Schneider bewusstlos im Vorratsraum, Bund weg, Tor zu). Nie, was andere Rollen beobachtet haben, und nie etwas Verborgenes.
- **P-4, Abwechslung:** Kein Text wiederholt einen anderen wortgleich. Jede Runde klingt nach ihrer Frage: Runde 1 Alibis, Runde 2 Widersprüche, Runde 3 Gegenüberstellung.
- `preisgabe` enthält nur zwei Arten von Verweisen:
  - eigene Beobachtungen mit Kanal `pflichtgespraech`
  - eigene Lügen; am Tisch wird nur die Behauptung gesagt
- Nie Nebendelikte, verborgene Beobachtungen oder Spuren. Sonst schließt die Runde am Tisch zu früh aus.
- `text`: ein bis drei Sätze, mit denen die Rolle das Gespräch eröffnet. Steht etwas in `preisgabe`, bringt der Text dessen Kern zur Sprache; bei einer Lüge nur die Behauptung.

## Regeln für die Rundenwahl
- `a` ist kooperativ und kostet die Rolle etwas (siehe `gruppenwahl.json` → `kosten`).
- `b` schützt Ziel oder Freund.
- `sabotage` gibt es nur bei Kernrollen (Täterfassung). Sie klingt für Außenstehende wie ein harmloses `b`.
- Je Option ein bis zwei Sätze in der Ich-Form.

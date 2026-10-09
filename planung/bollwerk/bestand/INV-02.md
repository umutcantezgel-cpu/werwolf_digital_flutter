# M1-INV-02 · Inventar content/party/ (Stand wt/fin)

Befehlsbasis: `cd .../scratchpad/wt/fin`, Dateiliste `find content/party -type f | sort`, Bytes `wc -c < Datei`, Schlüssel `jq -r 'keys' Datei`, Arraylängen Ebene 1 `jq 'to_entries[] | select(.value|type=="array") | .key, (.value|length)'`, Ebene 2 analog unter Objekten. Textbausteine in `texte/*.json` = Länge von `eintraege`.

| Datei | Bytes | Schlüssel | Arrays mit Länge | Befehl |
|---|---|---|---|---|
| content/party/farbnamen.json | 2662 | farben, hinweis | farben=38 | wc -c; jq keys; jq Länge |
| content/party/schema/README.md | 963 | (kein JSON) | - | wc -c |
| content/party/schema/beobachtungen.schema.json | 8561 | $defs, $schema, additionalProperties, properties, required, title, type | required=3 | wc -c; jq keys; jq Länge |
| content/party/schema/besetzung.schema.json | 2365 | $defs, $schema, additionalProperties, properties, required, title, type | required=9 | wc -c; jq keys; jq Länge |
| content/party/schema/bonus.schema.json | 2348 | $defs, $schema, additionalProperties, properties, required, title, type | required=3 | wc -c; jq keys; jq Länge |
| content/party/schema/entscheidungen.schema.json | 9565 | $defs, $schema, additionalProperties, properties, required, title, type | required=5 | wc -c; jq keys; jq Länge |
| content/party/schema/fall.schema.json | 5337 | $defs, $schema, additionalProperties, properties, required, title, type | required=14 | wc -c; jq keys; jq Länge |
| content/party/schema/figuren.schema.json | 16875 | $defs, $schema, additionalProperties, properties, required, title, type | required=6 | wc -c; jq keys; jq Länge |
| content/party/schema/gegenstaende.schema.json | 9062 | $defs, $schema, additionalProperties, properties, required, title, type | required=4 | wc -c; jq keys; jq Länge |
| content/party/schema/gruppenwahl.schema.json | 6455 | $defs, $schema, additionalProperties, properties, required, title, type | required=4 | wc -c; jq keys; jq Länge |
| content/party/schema/raeume.schema.json | 8524 | $defs, $schema, additionalProperties, properties, required, title, type | required=10 | wc -c; jq keys; jq Länge |
| content/party/schema/setting.schema.json | 2751 | $defs, $schema, additionalProperties, properties, required, title, type | required=11 | wc -c; jq keys; jq Länge |
| content/party/schema/tatmatrix.schema.json | 5241 | $defs, $schema, additionalProperties, properties, required, title, type | required=6 | wc -c; jq keys; jq Länge |
| content/party/schema/texte-bausteine.schema.json | 1800 | $defs, $schema, additionalProperties, properties, required, title, type | required=4 | wc -c; jq keys; jq Länge |
| content/party/schema/texte-dossier.schema.json | 2261 | $defs, $schema, additionalProperties, properties, required, title, type | required=4 | wc -c; jq keys; jq Länge |
| content/party/schema/texte-gespraech.schema.json | 2543 | $defs, $schema, additionalProperties, properties, required, title, type | required=4 | wc -c; jq keys; jq Länge |
| content/party/schema/texte-index.schema.json | 1913 | $defs, $schema, additionalProperties, properties, required, title, type | required=3 | wc -c; jq keys; jq Länge |
| content/party/schema/texte-taeter.schema.json | 2187 | $defs, $schema, additionalProperties, properties, required, title, type | required=4 | wc -c; jq keys; jq Länge |
| content/party/schema/texte-wahl.schema.json | 1900 | $defs, $schema, additionalProperties, properties, required, title, type | required=4 | wc -c; jq keys; jq Länge |
| content/party/schema/wahrnehmung.schema.json | 6335 | $defs, $schema, additionalProperties, properties, required, title, type | required=8 | wc -c; jq keys; jq Länge |
| content/party/schema/zeitleiste.schema.json | 2421 | $defs, $schema, additionalProperties, properties, required, title, type | required=3 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/STORY-BIBEL.md | 174289 | (kein JSON) | - | wc -c |
| content/party/schlosskeller/beobachtungen.json | 25365 | beobachtungen, hinweis, settingId | beobachtungen=33 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/besetzung.json | 3710 | ersatzpartner, geschlechterBilanz, hinweis, maxRollen, minRollen, regeln, reihenfolge, settingId, stufen | reihenfolge=20; stufen=5; geschlechterBilanz=17; regeln=5; ersatzpartner.leyla=3; ersatzpartner.emine=2; ersatzpartner.tim=2; ersatzpartner.johanna=2; ersatzpartner.murat=3; ersatzpartner.zeynep=2; ersatzpartner.baran=2; ersatzpartner.meryem=2; ersatzpartner.serkan=2; ersatzpartner.aylin=2; ersatzpartner.kaan=2; ersatzpartner.dilara=2; ersatzpartner.enes=2; ersatzpartner.selin=2; ersatzpartner.hakan=2; ersatzpartner.tugba=2 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/bild.json | 12151 | beweise, hinweis, negativ, personen, raeume, settingId, stil | personen=22; raeume=7; beweise=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/bildprompts.json | 26467 | hinweis, prompts | prompts=42 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/bonus.json | 12469 | hinweis, hinweise, settingId | hinweise=36 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/entscheidungen.json | 22807 | entscheidungen, fakten, hinweis, regeln, settingId | regeln=2; fakten=30; entscheidungen=9 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/fall.json | 2671 | enden, finaleUhrzeit, kanonVersion, kernverdaechtige, morgenUhrzeit, personen, pfade, regeln, runden, rundendauerMinuten, schwellen, settingId, titel, untertitel | pfade=4; kernverdaechtige=4; runden=3; enden.matrix=4 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/figuren.json | 49236 | detektiv, figuren, hinweis, lookHinweis, opfer, settingId | figuren=20; detektiv.selectableGenders=2 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/gegenstaende.json | 26739 | gegenstaende, hinweis, nebendelikte, settingId | gegenstaende=28; nebendelikte=8 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/gruppenwahl.json | 29895 | hinweis, settingId, wahlen, wertung | wahlen=60 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/quellabgleich.json | 142436 | eintraege, hinweis, quelleSha256, settingId | eintraege=542 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/raeume.json | 25871 | einrichtung, geraeusch, lichtquellen, luftzug, massstab, orte, raster, rooms, settingId, tueren | rooms=7; tueren=8; einrichtung=53; orte=43; lichtquellen=10; luftzug=1; geraeusch.nachbarn=6; geraeusch.geschlossen=1 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/setting.json | 2548 | anlass, atmosphaere, brandschutz, datum, empfang, essen, getraenke, lacher, schauplatz, settingId, ton | getraenke=5; atmosphaere=3; lacher=3 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/tatmatrix/ahmet.json | 5051 | ereignisse, gegenstaende, hinweis, pfad, plaene, settingId | ereignisse=5; gegenstaende=3; plaene.ahmet=16 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/tatmatrix/basis.json | 17787 | ereignisse, gegenstaende, hinweis, pfad, plaene, settingId | ereignisse=12; gegenstaende=7; plaene.detective=3; plaene.schneider=18; plaene.ahmet=10; plaene.fatma=5; plaene.olli=10; plaene.can=10; plaene.leyla=2; plaene.tim=4; plaene.emine=3; plaene.johanna=2; plaene.murat=2; plaene.zeynep=2; plaene.baran=3; plaene.meryem=1; plaene.serkan=6; plaene.aylin=1; plaene.kaan=2; plaene.dilara=3; plaene.enes=6; plaene.selin=1; plaene.hakan=2; plaene.tugba=4 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/tatmatrix/can.json | 3620 | ereignisse, gegenstaende, hinweis, pfad, plaene, settingId | ereignisse=3; gegenstaende=2; plaene.can=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/tatmatrix/fatma.json | 4229 | ereignisse, gegenstaende, hinweis, pfad, plaene, settingId | ereignisse=5; gegenstaende=3; plaene.fatma=10 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/tatmatrix/olli.json | 4904 | ereignisse, gegenstaende, hinweis, pfad, plaene, settingId | ereignisse=5; gegenstaende=2; plaene.olli=16 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/SCHLUESSEL.md | 8484 | (kein JSON) | - | wc -c |
| content/party/schlosskeller/texte/detektiv.json | 3143 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/dossiers-b1.json | 5503 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=4 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/dossiers-b2.json | 3594 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=4 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/dossiers-b3.json | 3992 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=4 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/dossiers-b4.json | 3963 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=4 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/dossiers-b5.json | 4261 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=4 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/erzaehler-aufloesung.json | 7877 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=28 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/erzaehler-finale-ahmet.json | 3837 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=5 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/erzaehler-finale-can.json | 3548 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=5 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/erzaehler-finale-fatma.json | 3843 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=5 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/erzaehler-finale-olli.json | 3670 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=5 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/erzaehler-intro.json | 3007 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=9 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/erzaehler-npc.json | 1446 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=5 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/erzaehler-runden.json | 4182 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=29 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r1-b1.json | 4611 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r1-b2.json | 4597 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r1-b3.json | 4954 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r1-b4.json | 4812 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r1-b5.json | 4952 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r2-b1.json | 4967 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r2-b2.json | 5235 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r2-b3.json | 5517 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r2-b4.json | 5165 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r2-b5.json | 5609 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r3-b1.json | 4975 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r3-b2.json | 5008 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r3-b3.json | 5322 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r3-b4.json | 5228 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/gespraeche-r3-b5.json | 5404 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/index.json | 4045 | dateien, hinweis, settingId | dateien=50 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/taeter-ahmet.json | 2789 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=1 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/taeter-can.json | 2438 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=1 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/taeter-fatma.json | 2422 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=1 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/taeter-olli.json | 2473 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=1 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/ui-druck-karten.json | 5333 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=49 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/ui-druck-rollen.json | 2956 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=27 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/ui-druck-spielleitung.json | 11141 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=88 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/ui-einrichtung.json | 3171 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=30 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/ui-erzaehler.json | 664 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=5 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/ui-finale.json | 2121 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=22 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/ui-gruppenwahl.json | 1307 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=10 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/ui-npc.json | 424 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=2 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/ui-rollen.json | 2361 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=25 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/ui-runde.json | 943 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=9 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/ui-titel.json | 1211 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/ui.json | 4253 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=42 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/wahlen-b2.json | 3445 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/wahlen-b3.json | 3494 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/wahlen-b4.json | 4079 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/wahlen-b5.json | 4052 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/texte/wahlen-kern.json | 4468 | bereich, eintraege, hinweis, settingId | Textbausteine (eintraege)=12 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/wahrnehmung.json | 3507 | abtastung, fuehlen, haltungen, hinweis, hoeren, licht, riechen, settingId, tempo, zeitgefuehl | licht.voll=1; licht.schwach=3; licht.rest=2; abtastung.fenster=2; abtastung.planFenster=2 | wc -c; jq keys; jq Länge |
| content/party/schlosskeller/zeitleiste.json | 13783 | eintraege, hinweis, settingId | eintraege=44 | wc -c; jq keys; jq Länge |
| content/party/textregeln.json | 3871 | ausnahmen, fachwoerter, raumAusnahmen, raumwortEndungen, saetze, verboten, vorlesen | ausnahmen=34; raumwortEndungen=9; raumAusnahmen=10; verboten.alkohol=25; verboten.drogen=15; verboten.rauchen=38; vorlesen.abkuerzungen=5 | wc -c; jq keys; jq Länge |

## Summen

- Dateien gesamt: 95 (davon 92 JSON, 3 Markdown: schema/README.md, schlosskeller/STORY-BIBEL.md, schlosskeller/texte/SCHLUESSEL.md)
- Bytes gesamt: 925771
- Textbausteine in texte/*.json (Länge von `eintraege`, 50 Dateien ohne index.json; index.json listet 50 Dateien in `dateien`): siehe Tabelle, Summe nicht separat gebildet

## Selbstprüfung

- Tabellenzeilen Dateien = `find content/party -type f | wc -l` = 95. Bestanden.

#!/usr/bin/env python3
"""Erzeugt content/party/schlosskeller/quellabgleich.json aus dem lokalen Rohchat (F-02).

Jedes Element des Quellmaterials wird einer Kanon-Stelle zugeordnet oder begründet
verworfen. Die Ausgabe enthält nur Kennungen, Zeilennummern und eigene Kurzbezeichnungen,
keine wörtlichen Chat-Passagen (Secret-Scan Stufe 4). Läuft nur lokal, weil der Rohchat
nie ins Repo kommt.

Teile der Quelle:
  S  Setting 3 (Fließtext)            M  Mein Gedanke und Station A (Mechanik)
  R  Raummodell                        L  Figurenliste (Markdown)
  J  Figuren-JSON                      T  Täter-System
"""
import hashlib
import json
import re
import sys
from pathlib import Path

WURZEL = Path(__file__).resolve().parents[1]
CHAT = WURZEL / 'quellen' / 'schlosskeller-teamchat.txt'
KANON = WURZEL / 'content' / 'party' / 'schlosskeller'
AUS = KANON / 'quellabgleich.json'

if not CHAT.exists():
    print('Rohchat fehlt lokal – Quellabgleich kann nicht neu erzeugt werden.')
    sys.exit(0)

zeilen = CHAT.read_text(encoding='utf-8').splitlines()
figuren = json.loads((KANON / 'figuren.json').read_text(encoding='utf-8'))
alle = {f['id']: f for f in figuren['figuren']}
alle['detective'] = figuren['detektiv']
alle['schneider'] = figuren['opfer']
ziel_id = {'detective': 'detektiv', 'schneider': 'opfer'}

# A-Einträge je Person (BRUCHLISTE Teil 3)
A = {'detective': 'A-09', 'schneider': 'A-10', 'ahmet': 'A-11', 'fatma': 'A-12', 'olli': 'A-13', 'can': 'A-14',
     'zeynep': 'A-15', 'leyla': 'A-16', 'tim': 'A-17', 'emine': 'A-18', 'johanna': 'A-19', 'murat': 'A-20',
     'baran': 'A-21', 'meryem': 'A-22', 'serkan': 'A-23', 'aylin': 'A-24', 'kaan': 'A-25', 'dilara': 'A-26',
     'enes': 'A-27', 'selin': 'A-28', 'hakan': 'A-29', 'tugba': 'A-30'}
UMBENANNT = {'leyla', 'johanna', 'murat', 'meryem', 'kaan', 'dilara', 'enes', 'hakan'}


def zeile_von(muster, ab=1, bis=None):
    """Erste Zeile (1-basiert) ab `ab`, die `muster` enthält."""
    for i in range(ab - 1, bis or len(zeilen)):
        if muster in zeilen[i]:
            return i + 1
    raise SystemExit(f'Muster nicht gefunden: {muster!r} ab Zeile {ab}')


def norm(t):
    return re.sub(r'\s+', ' ', str(t)).strip().rstrip('.').lower()


eintraege = []


def eintrag(quelle, zeile, element, ziel, status, grund):
    eintraege.append({'id': f'{quelle}-{len([e for e in eintraege if e["quelle"] == quelle]) + 1:03d}', 'quelle': quelle,
                      'zeile': zeile, 'element': element, 'ziel': ziel, 'status': status, 'grund': grund})


# ---------- J: Figuren-JSON ----------
j_start = zeile_von('"settingId": "spuk_im_schlosskeller"') - 1
j_ende = zeile_von('nochmal als code', j_start)
roh = '\n'.join(zeilen[j_start - 1:j_ende - 1])
roh = roh[roh.index('{'):]
quelle_json = json.loads(roh)
JFELD = {  # Quellfeld -> (Kanonfeld, Grund bei Abweichung)
    'name': ('name', ['E-020']), 'age': ('age', []), 'tier': ('tier', []), 'minPlayers': ('minPlayers', ['B-13', 'V-21']),
    'roleTitle': ('roleTitle', ['V-25']), 'isPotentialKiller': ('isPotentialKiller', []), 'colorCode': ('colorCode', ['B-10']),
    'startRoom': ('startRoom', ['A-32']), 'coordinates': ('coordinates', ['A-32']),
    'visualSpecs.silhouette': ('visualSpecs.silhouette', ['V-27']), 'visualSpecs.outfit': ('visualSpecs.outfit', ['V-27']),
    'visualSpecs.distinguishingFeature': ('visualSpecs.distinguishingFeature', ['V-27']),
    'visualSpecs.idleAnimation': ('visualSpecs.idleAnimation', ['V-27']),
    'visualSpecs.colorCode': ('colorCode', ['B-10']),
    'motiveAndConflict': ('motiveAndConflict', ['V-22']), 'blackoutAlibi': ('blackoutAlibi', ['E-015']),
    'roleSecret': ('roleSecret', ['V-11']), 'killerProfile.crimeExecution': ('killerProfile.crimeExecution', ['V-24']),
    'killerProfile.smokingGun': ('killerProfile.smokingGun', ['B-09', 'E-019']),
    'innocentProfile.actualBehavior': ('innocentProfile.actualBehavior', ['E-015']),
    'title': ('title', []), 'selectableGenders': ('selectableGenders', []),
    'visualSpecs.baseOutfit': ('visualSpecs.baseOutfit', ['A-09']), 'visualSpecs.accessories': ('visualSpecs.accessories', ['B-14']),
    'visualSpecs.interactiveTool': ('visualSpecs.interactiveTool', ['A-09']), 'roleTitle_victim': ('roleTitle', []),
    'isNpc': ('isNpc', []), 'status': ('status', ['V-05']),
}


def flach(o, p=''):
    if isinstance(o, dict) and p != 'coordinates':
        for k, v in o.items():
            yield from flach(v, f'{p}.{k}' if p else k)
    else:
        yield p, o


def holen(o, pfad):
    for t in pfad.split('.'):
        if not isinstance(o, dict) or t not in o:
            return None
        o = o[t]
    return o


personen_quelle = [('detective', quelle_json['detective']), ('schneider', quelle_json['victim'])] + \
    [(c['id'], c) for c in quelle_json['characters']]
for pid, daten in personen_quelle:
    ab = zeile_von(f'"id": "{pid}"', j_start)
    for feld, wert in flach(daten):
        if feld == 'id':
            continue
        z = zeile_von(f'"{feld.split(".")[-1]}"', ab)
        if feld == 'visualSpecs.colorCode':
            kanonfeld, gruende = 'colorCode', ['B-10']
        elif feld in JFELD:
            kanonfeld, gruende = JFELD[feld]
        else:
            raise SystemExit(f'Feld ohne Zuordnung: {pid}.{feld}')
        kanonwert = holen(alle[pid], kanonfeld)
        ziel = f'figuren.json#{ziel_id.get(pid, pid)}.{kanonfeld}'
        if kanonwert is None:
            eintrag('J', z, f'{pid}.{feld}', [], 'verworfen', [A[pid]] + gruende)
        elif norm(kanonwert) == norm(wert):
            eintrag('J', z, f'{pid}.{feld}', [ziel], 'übernommen', [])
        else:
            g = [A[pid]] + gruende
            if feld == 'name' and pid not in UMBENANNT:
                g = [A[pid]]
            eintrag('J', z, f'{pid}.{feld}', [ziel], 'angepasst', g)
for r in quelle_json['rooms']:
    z = zeile_von(f'"id": "{r["id"]}"', j_start)
    eintrag('J', z, f'Raum {r["id"]}', [f'raeume.json#rooms.{r["id"]}'], 'angepasst', ['B-01', 'A-06', 'A-07'])

# ---------- L: Figurenliste ----------
LFELD = {'Rolle': ('motiveAndConflict', []), 'Status': ('status', ['V-05']), '2.5D-Optik': ('visualSpecs.outfit', ['V-27', 'A-31']),
         'Erkennungsmerkmal': ('visualSpecs.distinguishingFeature', ['V-27']), 'Startposition': ('ermittlungsOrt', ['A-32']),
         'Motiv': ('motiveAndConflict', ['V-22']), 'Alibi im Dunkeln': ('blackoutAlibi', ['E-015']),
         'Täter-Hinweis (wenn aktiv)': ('killerProfile.smokingGun', ['B-09', 'E-019']),
         'Täterin-Hinweis (wenn aktiv)': ('killerProfile.smokingGun', ['V-04', 'E-019']),
         'Geheimnis': ('roleSecret', ['V-11']), 'Ausrüstung': ('visualSpecs.interactiveTool', ['A-09']),
         'Funktion': ('auftrag', ['B-12']), 'Status_det': ('tatnacht', ['V-09'])}
l_start = zeile_von('### Der Detektiv (Das Geburtstagskind)')
l_ende = zeile_von('charakterliste', l_start)
aktuell = None
namen = {re.sub(r'\W', '', (f['quelle']['name'] if 'quelle' in f else f.get('name', ''))).lower(): fid for fid, f in alle.items()}
namen.update({'olli': 'olli', 'detektiv': 'detective', 'herrschneider': 'schneider'})
kopf = re.compile(r'^\[\d{2}\.\d{2}\.\d{2}, \d{2}:\d{2}:\d{2}\] [^:]+: ')
for i in range(l_start, l_ende):
    t = kopf.sub('', zeilen[i - 1])
    if t.startswith('### Der Detektiv'):
        aktuell = 'detective'
        continue
    if t.startswith('### Das Opfer'):
        aktuell = 'schneider'
        continue
    m = re.match(r'#### \d+\. ([A-Za-zÄÖÜäöüß]+)', t)
    if m:
        aktuell = namen.get(m.group(1).lower())
        if aktuell is None:
            raise SystemExit(f'Unbekannte Person in Zeile {i}: {m.group(1)}')
        continue
    m = re.search(r'\*([^*]+):\*', t)
    if m and aktuell:
        label = m.group(1).strip()
        key = 'Status_det' if (label == 'Status' and aktuell == 'detective') else label
        if key not in LFELD:
            raise SystemExit(f'Feld ohne Zuordnung in Zeile {i}: {label}')
        kf, gr = LFELD[key]
        if aktuell == 'detective' and kf == 'visualSpecs.outfit':
            kf = 'visualSpecs.baseOutfit'
        ziel = f'figuren.json#{ziel_id.get(aktuell, aktuell)}.{kf}'
        eintrag('L', i, f'{aktuell}: {label}', [ziel], 'angepasst', [A[aktuell]] + gr)

# ---------- S, M, R, T: kuratierte Elemente ----------
KURATIERT = {
    'S': [
        ('Setting 3: „Spuk im Schlosskeller“', 'Titel und Untertitel', ['fall.json#titel', 'fall.json#untertitel'], 'übernommen', []),
        ('Ein altes, etwas abgelegenes Schloss', 'Ort: abgelegenes Schloss', ['setting.json#ort'], 'übernommen', []),
        ('Einer aus der Gruppe arbeitet als Veranstalter', 'Veranstalter-Freund organisiert den Keller', ['figuren.json#ahmet.motiveAndConflict', 'figuren.json#ahmet.alltag'], 'angepasst', ['A-11']),
        ('Aufgestellt sind lange Holztische', 'Buffet: Essen, Brot, Dips, Tee, Apfelpunsch', ['setting.json#essen', 'setting.json#getraenke'], 'angepasst', ['B-14']),
        ('Hinter den dicken Steinmauern gibt es keinen Handyempfang', 'kein Handyempfang', ['setting.json#empfang'], 'übernommen', []),
        ('Der Wind pfeift durch die Mauerritzen', 'Wind, quietschende Türen, Kerzenschatten', ['setting.json#atmosphaere'], 'angepasst', ['B-04']),
        ('erschrickt sich zu Tode vor einer alten Ritterrüstung', 'Lacher Ritterrüstung', ['setting.json#lacher.lacher_ruestung'], 'angepasst', ['B-17']),
        ('verläuft sich auf dem Weg zur Toilette', 'Lacher Verlaufen', ['setting.json#lacher.lacher_verlaufen'], 'angepasst', ['B-17']),
        ('den Kamin anzufeuern', 'Lacher Kamin, Zugfenster', ['setting.json#lacher.lacher_kamin', 'raeume.json#luftzug'], 'angepasst', ['B-17', 'A-22']),
        ('fliegt mit einem lauten Knall die Hauptsicherung raus', 'Knall, Hauptsicherung, Dunkelheit', ['zeitleiste.json#z_ausfall'], 'angepasst', ['B-04', 'V-06']),
        ('Im Dunkeln hört man hastige Schritte', 'Schritte, Poltern, Scheppern', ['zeitleiste.json#z_schlag'], 'übernommen', []),
        ('Als die Handy-Taschenlampen angehen', 'Opfer im Vorratsraum, Metallkerzenständer', ['zeitleiste.json#z_gefunden', 'gegenstaende.json#kerzenstaender'], 'angepasst', ['B-05', 'V-05']),
        ('Der schwere Schlüsselbund für das Außentor fehlt', 'Schlüsselbund fehlt', ['gegenstaende.json#bund_schneider'], 'übernommen', []),
        ('Der Sachschaden an der Tür', 'Türschaden, 2.000 € bar', ['zeitleiste.json#z_tuerschaden', 'zeitleiste.json#z_forderung'], 'angepasst', ['B-07', 'B-02']),
        ('Der aus dem Ruder gelaufene Prank', 'Prank mit Maske im Vorratsraum', ['zeitleiste.json#z_can_vorrat'], 'angepasst', ['B-05', 'V-10']),
        ('Die Miet-Abzocke', '150 € Miete, Keller umsonst', ['figuren.json#ahmet.nebendelikt'], 'angepasst', ['V-22', 'A-11']),
        ('Der Diebstahl aus der Vitrine', 'Vitrine, Gedenkmünze, Ertappen', ['zeitleiste.json#z_vitrine_schatulle', 'zeitleiste.json#z_schatulle_entdeckt'], 'angepasst', ['B-08', 'A-12']),
        ('Räume: Der Kaminraum', 'Kaminraum, Vorratsraum, Wendeltreppengang, Sicherungskasten', ['raeume.json#rooms.west_saal', 'raeume.json#rooms.vorratsraum', 'raeume.json#rooms.turmgang'], 'angepasst', ['B-01']),
        ('Eine billige Plastik-Geistermaske', 'Maske hinter Getränkekiste', ['gegenstaende.json#leuchtmaske'], 'angepasst', ['B-06', 'A-14']),
        ('Frische Holzsplitter und weiße Lackspuren', 'Splitter und Lack an einer Jacke', ['figuren.json#olli.visualSpecs.distinguishingFeature'], 'angepasst', ['B-07', 'V-14']),
        ('Ein schwerer, leicht verbogener Metallkerzenständer', 'Kerzenständer mit Wachs', ['gegenstaende.json#kerzenstaender'], 'angepasst', ['B-04']),
        ('Ein handschriftlicher Quittungsblock', 'Quittungsblock mit 2.000-€-Forderung', ['gegenstaende.json#klemmbrett_schneider'], 'übernommen', []),
        ('Ein leerer Kautionsumschlag', 'leerer Umschlag im Kamin-Ascheneimer', ['gegenstaende.json#umschlag_mietgeld'], 'angepasst', ['B-17']),
        ('Warum es am Abend funktioniert', 'Begründung des Settings (Ton)', ['setting.json#ton'], 'übernommen', []),
    ],
    'M': [
        ('Erstelle das vollständige Produktions- und Spielkonzept', 'App lokal im Browser oder PDF', [], 'ausserhalb', ['E-001']),
        ('Es gibt 3 eigenständige Stories', 'drei Stories', [], 'ausserhalb', ['E-006']),
        ('Für eine Freundesgruppe (20–30 Jahre', 'Zielgruppe und Herkünfte', ['figuren.json#figuren'], 'übernommen', ['E-007']),
        ('Setting 1: „Ehrensache auf der Hebebühne“', 'Setting Werkstatt', [], 'ausserhalb', ['E-006']),
        ('Setting 2: „Der letzte Tee im Gemeindesaal“', 'Setting Gemeindesaal', [], 'ausserhalb', ['E-006']),
        ('Spielstruktur: 3 Runden', '3 Runden, 3 Pflichtgespräche, Bildprompts', ['fall.json#runden'], 'übernommen', []),
        ('Kein Alkohol, keine Drogen, keine Klischees', 'Inhaltsregeln', ['setting.json#getraenke'], 'übernommen', ['B-14']),
        ('Standardannahme: Feste modulare Stufen', 'Stufen 4/8/12/16/20', ['besetzung.json#stufen'], 'angepasst', ['B-13', 'V-21']),
        ('Option A: kooperativ/wachsam', 'Gruppenwahl A/B', [], 'spaeter', ['V-15', 'E-013']),
        ('Gruppenpunkte: Die Gruppe spielt dem Detektiv', 'Schwellen 60/40 %', ['fall.json#schwellen'], 'angepasst', ['E-013']),
        ('Jede richtige Detektiv-Entscheidung gibt 1 Ermittlungspunkt', 'Punkte 0–9', ['fall.json#enden'], 'übernommen', []),
        ('*Ende 1 (Meister-Detektiv):*', 'Endenmatrix', ['fall.json#enden'], 'angepasst', ['B-12']),
        ('Realistischer, atmosphärischer Foto-Look', 'Stil der Bildprompts', [], 'spaeter', ['V-30']),
        ('Bei Story 3 (Schlosskeller) liegt das Opfer im Koma', 'Schweregrad: Opfer schwer verletzt', ['figuren.json#opfer.status'], 'angepasst', ['V-05']),
        ('Pro Story sind 50% der Rollen männlich', 'Geschlechterverteilung 50/50', ['besetzung.json#geschlechterBilanz'], 'übernommen', ['V-21']),
        ('Menschenlesbares Markdown für Druck/PDF-Export', 'Markdown und JSON', ['STORY-BIBEL.md'], 'übernommen', ['E-002']),
    ],
    'R': [
        ('Fünf abgetretene, feuchte Rundstufen aus Sandstein', 'Stufen außen vom Parkplatz', ['raeume.json#rooms.windfang'], 'angepasst', ['B-03', 'A-04']),
        ('Eine schwere, zweiflügelige Eichentür', 'zweiflügelige Eichentür', ['raeume.json#tueren.aussentor'], 'angepasst', ['A-02']),
        ('Länglicher Schnitt, exakt 8 Meter lichte Weite', 'Thekensaal 8 m breit', ['raeume.json#rooms.thekensaal'], 'übernommen', []),
        ('Rechts und links an den Längswänden stehen tapezierte Buffettische', 'Buffettische links und rechts', ['raeume.json#einrichtung.linkes_buffet_12', 'raeume.json#einrichtung.rechtes_buffet_12'], 'angepasst', ['V-27', 'V-29']),
        ('Direkt gegenüber dem Eingang steht die massive Schanktheke', 'Theke gegenüber dem Eingang', ['raeume.json#einrichtung.theke_14'], 'angepasst', ['A-01', 'V-29']),
        ('Dahinter befinden sich Heißwasser-Samoware', 'Samoware, Kannen, Gläser hinter der Theke', ['raeume.json#einrichtung.teekocher', 'raeume.json#einrichtung.kaffeemaschine'], 'angepasst', ['V-27']),
        ('Auf gleicher Höhe links und rechts neben der Theke führen zwei Holztüren', 'Türen zu den Sälen', ['raeume.json#tueren.durchgang_ost', 'raeume.json#tueren.ost_tuer'], 'angepasst', ['B-01']),
        ('Fundort von Servierbesteck, Quittungen und dem Schlossriegel', 'Fundorte an der Theke', ['gegenstaende.json#klemmbrett_schneider'], 'angepasst', ['V-07']),
        ('Zentral im Raum stehen zwei zusammengeschobene lange Holztische', 'West-Saal: Tafeln, Bänke', ['raeume.json#rooms.west_saal'], 'übernommen', []),
        ('In der hinteren oberen Ecke befindet sich eine schwere Bogenholztür', 'Bogentür zum Treppenturm, WC', ['raeume.json#tueren.bogentuer', 'raeume.json#rooms.turmgang'], 'angepasst', ['B-01']),
        ('Der restliche Turm ist mit einem Vorhängeschloss abgesperrt', 'Turm abgesperrt', ['raeume.json#rooms.turmgang'], 'übernommen', []),
        ('Alibi-Zone. Wer zur Toilette ging', 'West-Saal als Alibi-Zone', ['tatmatrix/basis.json#plaene.can'], 'übernommen', []),
        ('Nahezu spiegelbildlich zu Raum 2', 'Ost-Saal ohne Außentür', ['raeume.json#rooms.ost_saal'], 'übernommen', []),
        ('Schallgeschützter Raum für diskrete 1-zu-1-Gespräche', 'Ost-Saal: Gespräche, Verstecke unter Bänken', ['raeume.json#rooms.ost_saal'], 'angepasst', ['E-015']),
        ('Fog-of-War-Logik', 'Fog-of-War mit Alpha-Fade 0,4 s', [], 'spaeter', ['V-32']),
        ('Grundbeleuchtung: Stark gedimmt', 'Grundlicht 20–25 %, Blaugrau', [], 'spaeter', ['V-32']),
        ('Punktlichtquellen: Warm-orange Point-Lights', 'Punktlichter RGB 255/147/41', ['raeume.json#lichtquellen.licht_kerzenstaender'], 'angepasst', ['B-04', 'V-32']),
        ('Schatten: 45°-Kantenabwurf', 'Schatten 45°', [], 'spaeter', ['V-32']),
    ],
    'T': [
        ('| *1. Ahmet* (Event-Macher)', 'Ahmet: Motiv, Zugang, Dynamik', ['figuren.json#ahmet.killerProfile.crimeExecution'], 'angepasst', ['V-24', 'A-11']),
        ('| *2. Fatma* (Schmuckliebhaberin)', 'Fatma: Motiv, Zugang, Dynamik', ['figuren.json#fatma.killerProfile.crimeExecution'], 'angepasst', ['V-22', 'V-24', 'A-12']),
        ('| *3. Olli* (Anpacker)', 'Olli: Motiv, Zugang, Dynamik', ['figuren.json#olli.killerProfile.crimeExecution'], 'angepasst', ['V-24', 'A-13']),
        ('| *4. Can* (Prankster)', 'Can: Motiv, Zugang, Dynamik', ['figuren.json#can.killerProfile.crimeExecution'], 'angepasst', ['V-24', 'A-14']),
        ('### Pfad 1: Ahmet ist der Täter', 'Pfad Ahmet: Tatablauf', ['tatmatrix/ahmet.json'], 'angepasst', ['B-02', 'V-24']),
        ('befindet sich in Ahmets schwarzer Stoffjacke', 'Pfad Ahmet: Schlüsselbeweis Jacke', ['gegenstaende.json#jacke_ahmet'], 'übernommen', ['A-03']),
        ('Ein zerrissener Schmierzettel in der Spüle', 'Pfad Ahmet: Zusatzindiz Schmierzettel', ['gegenstaende.json#umschlag_mietgeld'], 'verworfen', ['E-019']),
        ('### Pfad 2: Fatma ist die Täterin', 'Pfad Fatma: Tatablauf', ['tatmatrix/fatma.json'], 'angepasst', ['V-24']),
        ('An Fatmas auffälligem Silberring', 'Pfad Fatma: Schlüsselbeweis Ring', ['gegenstaende.json#silberring_fatma'], 'angepasst', ['V-04']),
        ('Die gestohlene Münze in ihrer Handtasche', 'Pfad Fatma: Zusatzindiz Wachs', ['gegenstaende.json#muenzschatulle'], 'angepasst', ['B-08', 'E-019']),
        ('### Pfad 3: Olli ist der Täter', 'Pfad Olli: Tatablauf', ['tatmatrix/olli.json'], 'angepasst', ['V-24']),
        ('An der Unterseite des Kerzenständers kleben', 'Pfad Olli: Schlüsselbeweis Splitter', ['gegenstaende.json#kerzenstaender'], 'angepasst', ['V-14', 'A-13']),
        ('In der Kamin-Nische im West-Saal liegt ein Arbeitshandschuh', 'Pfad Olli: Zusatzindiz Handschuh', ['gegenstaende.json#arbeitshandschuh_olli', 'gegenstaende.json#eiskuebel'], 'angepasst', ['V-02', 'B-16', 'E-019']),
        ('### Pfad 4: Can ist der Täter', 'Pfad Can: Tatablauf', ['tatmatrix/can.json'], 'angepasst', ['B-09', 'V-24']),
        ('An Schneiders Wachsjacke kleben auffällige gelbe Textilfasern', 'Pfad Can: Schlüsselbeweis Fasern', ['gegenstaende.json#gelbe_fasern', 'gegenstaende.json#kerzenstaender'], 'angepasst', ['B-09', 'E-019']),
        ('Die weggeworfene Geistermaske weist an der Stirnseite', 'Pfad Can: Zusatzindiz Maske', ['gegenstaende.json#leuchtmaske'], 'angepasst', ['B-09', 'E-019']),
        ('*Phase 1 (Das Alibi-Geflecht):*', 'Rundenthemen 1–3', ['fall.json#runden'], 'übernommen', []),
        ('Der Detektiv konfrontiert die beiden übriggebliebenen', 'Runde 3: zwei Restverdächtige', ['fall.json#runden'], 'angepasst', ['V-18']),
    ],
}
for quelle, liste in KURATIERT.items():
    for muster, element, ziel, status, grund in liste:
        eintrag(quelle, zeile_von(muster), element, ziel, status, grund)

eintraege.sort(key=lambda e: (e['quelle'], e['zeile']))
for q in 'SMRLJT':
    n = 0
    for e in eintraege:
        if e['quelle'] == q:
            n += 1
            e['id'] = f'{q}-{n:03d}'
aus = {
    'settingId': 'spuk_im_schlosskeller',
    'hinweis': 'Quellabgleich (F-02): Jedes Element des Quellmaterials ist einer Kanon-Stelle zugeordnet oder begründet verworfen. '
               'Quelle: S Setting, M Mechanik/Station A, R Raummodell, L Figurenliste, J Figuren-JSON, T Täter-System. '
               'Status: übernommen, angepasst (mit Grund), verworfen (mit Grund), spaeter (Regel entschieden, Umsetzung in späterer Phase), '
               'ausserhalb (nicht Teil dieses Falls). Erzeugt mit tool/quellabgleich.py aus dem lokalen Rohchat; Zeilen beziehen sich auf ihn.',
    'quelleSha256': hashlib.sha256(CHAT.read_bytes()).hexdigest(),
    'eintraege': eintraege,
}
AUS.write_text(json.dumps(aus, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
zaehl = {}
for e in eintraege:
    zaehl.setdefault(e['quelle'], {}).setdefault(e['status'], 0)
    zaehl[e['quelle']][e['status']] += 1
print(f'Geschrieben: {AUS} ({len(eintraege)} Einträge)')
for q, z in sorted(zaehl.items()):
    print(' ', q, z)

#!/usr/bin/env python3
"""Internes Werkzeug: erzeugt das Paketverzeichnis (Feinplan) 00_steuerung/PLAN.md.

Jede Zeile ist ein Datensatz im Kanon-Format:
  @KENNUNG [O] | Typ: … | Vorlage: … | Welle: … | Tag: … | Charge: a/b | Sitzung: H1–H3 | Lösung: ja/nein | Parameter: … | Umfang: … | Abhängig: … | Status: offen
Aufruf: python3 90_werkzeug/plan.py   (schreibt PLAN.md neu; Status bestehender Einträge bleibt erhalten)
"""
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ZIEL = os.path.join(ROOT, "00_steuerung", "PLAN.md")

P = []  # (kennung, typ, vorlage, welle, tag, charge, loesung, parameter, umfang, abh)


def add(k, typ, vorlage, welle, tag, charge, loes, param, umfang, abh="–"):
    P.append(dict(k=k, typ=typ, vorlage=vorlage, welle=welle, tag=tag, charge=charge,
                  loes=loes, param=param, umfang=umfang, abh=abh))


def r(n):
    return f"R{n:02d}"


KERN = [1, 2, 3, 4]
A = list(range(1, 9))
B = list(range(9, 21))
LOES_ROLLE = {3}  # Rolle mit Lösungswissen (Täterrolle)

# ---------- Tag 3 · Welle 1-A (Design-Vorrang zuerst) ----------
for v, ton in [(1, "gruseliger"), (2, "komischer"), (3, "ausgewogen")]:
    add(f"BILD-TITEL-V{v}", "VARIANTEN", "BILD-TITEL", 1, 3, "a", "nein", f"TON={ton}", "600–900")
for v, ton in [(1, "gruseliger"), (2, "komischer"), (3, "ausgewogen")]:
    add(f"BILD-EINLADUNG-V{v}", "VARIANTEN", "BILD-EINLADUNG", 1, 3, "a", "nein", f"TON={ton}", "600–900")
add("BILD-STATIONEN", "SCHREIB", "BILD-STATIONEN", 1, 3, "a", "nein", "MOTIVE=Kamin-Gewölbe,Speisekammer,Wendeltreppenturm,Hof", "600–900")
for n in A:
    add(f"PROFIL-{r(n)}", "SCHREIB", "PROFIL", 1, 3, "a", "ja" if n in LOES_ROLLE else "nein", f"ROLLE={r(n)}", "650–1.000")
for v, ton in [(1, "gruseliger"), (2, "komischer"), (3, "ausgewogen")]:
    add(f"ERZ-EINF-V{v}", "VARIANTEN", "ERZ-EINF", 1, 3, "a", "nein", f"TON={ton}", "600–900")
add("ERZ-VORST-A", "SCHREIB", "ERZ-VORST", 1, 3, "a", "nein", "ROLLEN=R01–R08", "600–850")
add("HINW-STAT-1", "SCHREIB", "HINW", 1, 3, "a", "nein", "GRUPPE=Speisekammer,Kamin-Gewölbe", "500–900")
add("HINW-STAT-2", "SCHREIB", "HINW", 1, 3, "a", "nein", "GRUPPE=Wendeltreppenturm,Hof", "500–900")
add("HINW-DOK", "SCHREIB", "HINW", 1, 3, "a", "nein", "GRUPPE=Dokumente", "600–1.000")
add("HINW-MELDE", "SCHREIB", "HINW-MELDE", 1, 3, "a", "nein", "ROLLEN=R01–R04", "600–900")
add("REQ-BAU-1", "SCHREIB", "REQ-BAU", 1, 3, "a", "ja", "STUECKE=BS-01,BS-02,BS-03,BS-04,BS-09", "750–1.250")
add("REQ-BAU-2", "SCHREIB", "REQ-BAU", 1, 3, "a", "ja", "STUECKE=BS-05,BS-06,BS-07,BS-08,BS-10,BS-12,BS-13", "750–1.250")
add("REQ-RAUM", "SCHREIB", "REQ-RAUM", 1, 3, "a", "nein", "–", "900–1.500")
add("REQ-KLANG-LICHT", "SCHREIB", "REQ-KLANG-LICHT", 1, 3, "a", "nein", "–", "800–1.400")
add("BILD-FIGUREN-1", "SCHREIB", "BILD-FIGUREN", 1, 3, "a", "nein", "FIGUREN=R01,R02,R03,R04", "500–800")
add("BILD-FIGUREN-2", "SCHREIB", "BILD-FIGUREN", 1, 3, "a", "nein", "FIGUREN=R05,R06,R07,R08", "500–800")
add("PRÜF-PROFIL-A", "PRÜF", "PRUEF-PROFIL", 1, 3, "b", "ja", "PAKETE=PROFIL-R01–R08", "600–1.200",
    ",".join(f"PROFIL-{r(n)}" for n in A))

# ---------- Tag 4 · Bilder Rest + Welle 2-A ----------
add("BILD-LAGEPLAN-BURG", "SCHREIB", "BILD-LAGEPLAN", 1, 4, "a", "nein", "MOTIVE=Lageplan,Burg außen,Burgwart,Wehrgang", "600–900")
add("BILD-BEWEISE-1", "SCHREIB", "BILD-BEWEISE", 1, 4, "a", "nein", "STUECKE=BSO-01,BSO-02,BSO-03,BSO-04,BSO-09", "600–900")
add("BILD-BEWEISE-2", "SCHREIB", "BILD-BEWEISE", 1, 4, "a", "nein", "STUECKE=BSO-05,BSO-06,BSO-07,BSO-08,BSO-12", "600–900")
add("BILD-KARTEN-1", "SCHREIB", "BILD-KARTEN", 1, 4, "a", "nein", "KARTEN=Rückseite Rollenkarte,Rückseite Gesprächsauftrag,Rückseite Spiegelstück,Rückseite Entscheidungskarte", "600–900")
add("BILD-KARTEN-2", "SCHREIB", "BILD-KARTEN", 1, 4, "a", "nein", "KARTEN=Rückseite Hinweiskarte,Rückseite Meldekarte,Rückseite Detektivkarte,Vorderseiten-Rahmen", "600–900")
add("HINW-DET", "SCHREIB", "HINW-DET", 1, 4, "a", "nein", "KARTEN=DET-B1 bis DET-B6", "500–800")
for n in A:
    add(f"P1-{r(n)}", "SCHREIB", "PHASE-ROLLE", 2, 4, "a", "ja" if n in LOES_ROLLE else "nein", f"PHASE=1;ROLLE={r(n)}",
        "900–1.500" if n in KERN else "550–900", f"PROFIL-{r(n)}")
add("DET-P1", "SCHREIB", "DET-PHASE", 2, 4, "a", "ja", "PHASE=1", "1.000–1.700")
add("ERZ-P1", "SCHREIB", "ERZ-PHASE", 2, 4, "a", "nein", "PHASE=1", "750–1.100")
add("ERZ-ANS-P1-A", "SCHREIB", "ERZ-ANSAGEN", 2, 4, "a", "nein", "PHASE=1;ROLLEN=R01–R08", "600–900")
add("PRÜF-P1-SPIEGEL-A", "PRÜF", "PRUEF-SPIEGEL", 2, 4, "b", "nein", "PHASE=1;ROLLEN=R01–R08", "600–1.200",
    ",".join(f"P1-{r(n)}" for n in A))
add("PRÜF-P1-KANON-A", "PRÜF", "PRUEF-KANON", 2, 4, "b", "ja", "PHASE=1;ROLLEN=R01–R08", "600–1.200",
    ",".join(f"P1-{r(n)}" for n in A))
add("PRÜF-W1-SPOILER", "PRÜF", "PRUEF-SPOILER", 1, 4, "b", "ja", "PAKETE=PROFIL-R01–R08,ERZ-EINF,ERZ-VORST-A,BILD-*", "600–1.200",
    "PROFIL-R01,ERZ-EINF-V1,ERZ-VORST-A,BILD-EINLADUNG-V1")
add("PRÜF-BILD", "PRÜF", "PRUEF-BILD", 1, 4, "b", "nein", "PAKETE=BILD-*", "600–1.000", "BILD-STATIONEN,BILD-FIGUREN-1")

# ---------- Tag 5 · Welle 3-A ----------
for n in A:
    add(f"P2-{r(n)}", "SCHREIB", "PHASE-ROLLE", 3, 5, "a", "ja" if n in LOES_ROLLE else "nein", f"PHASE=2;ROLLE={r(n)}",
        "900–1.500" if n in KERN else "550–900", f"P1-{r(n)}")
add("DET-P2", "SCHREIB", "DET-PHASE", 3, 5, "a", "ja", "PHASE=2", "1.000–1.700", "DET-P1")
add("ERZ-P2", "SCHREIB", "ERZ-PHASE", 3, 5, "a", "nein", "PHASE=2", "750–1.100", "ERZ-P1")
add("ERZ-ANS-P2-A", "SCHREIB", "ERZ-ANSAGEN", 3, 5, "a", "nein", "PHASE=2;ROLLEN=R01–R08", "600–900")
add("SL-AUFBAU", "SCHREIB", "SL", 5, 5, "a", "nein", "TEIL=Aufbau und Material", "800–1.300")
add("SL-ABLAUF", "SCHREIB", "SL", 5, 5, "a", "nein", "TEIL=Ablaufplan mit Cues", "800–1.300")
add("REGELBLATT", "SCHREIB", "REGELBLATT", 5, 5, "a", "nein", "–", "600–900")
add("PRÜF-P2-SPIEGEL-A", "PRÜF", "PRUEF-SPIEGEL", 3, 5, "b", "nein", "PHASE=2;ROLLEN=R01–R08", "600–1.200",
    ",".join(f"P2-{r(n)}" for n in A))
add("PRÜF-P2-KANON-A", "PRÜF", "PRUEF-KANON", 3, 5, "b", "ja", "PHASE=2;ROLLEN=R01–R08", "600–1.200",
    ",".join(f"P2-{r(n)}" for n in A))

# ---------- Tag 6 · Welle 4-A ----------
for n in A:
    add(f"P3-{r(n)}", "SCHREIB", "PHASE-ROLLE", 4, 6, "a", "ja" if n in LOES_ROLLE else "nein", f"PHASE=3;ROLLE={r(n)}",
        "900–1.500" if n in KERN else "550–900", f"P2-{r(n)}")
add("DET-P3", "SCHREIB", "DET-PHASE", 4, 6, "a", "ja", "PHASE=3", "1.000–1.700", "DET-P2")
add("ERZ-P3", "SCHREIB", "ERZ-PHASE", 4, 6, "a", "nein", "PHASE=3", "750–1.100", "ERZ-P2")
add("ERZ-ANS-P3-A", "SCHREIB", "ERZ-ANSAGEN", 4, 6, "a", "nein", "PHASE=3;ROLLEN=R01–R08", "600–900")
add("SL-REGELN", "SCHREIB", "SL", 5, 6, "a", "nein", "TEIL=Regeln und Sonderfälle", "800–1.300")
add("PRÜF-P3-SPIEGEL-A", "PRÜF", "PRUEF-SPIEGEL", 4, 6, "b", "nein", "PHASE=3;ROLLEN=R01–R08", "600–1.200",
    ",".join(f"P3-{r(n)}" for n in A))
add("PRÜF-P3-KANON-A", "PRÜF", "PRUEF-KANON", 4, 6, "b", "ja", "PHASE=3;ROLLEN=R01–R08", "600–1.200",
    ",".join(f"P3-{r(n)}" for n in A))

# ---------- Tag 7 · Welle 5 ----------
add("ERZ-EINGRENZ-1", "SCHREIB", "ERZ-EINGRENZ", 5, 7, "a", "ja", "BAENDER=0–3,4–6", "600–1.000")
add("ERZ-EINGRENZ-2", "SCHREIB", "ERZ-EINGRENZ", 5, 7, "a", "ja", "BAENDER=7–8,9", "600–1.000")
add("ERZ-ANKLAGE", "SCHREIB", "ERZ-ANKLAGE", 5, 7, "a", "ja", "–", "600–1.000")
for v, ton in [(1, "gruseliger"), (2, "komischer"), (3, "ausgewogen")]:
    add(f"ERZ-ENDEN-RICHTIG-V{v}", "VARIANTEN", "ERZ-ENDEN", 5, 7, "a", "ja", f"TON={ton};ENDEN=Meisterdetektiv,Teilerfolg", "600–900")
for v, ton in [(1, "gruseliger"), (2, "komischer"), (3, "ausgewogen")]:
    add(f"ERZ-ENDEN-FALSCH-V{v}", "VARIANTEN", "ERZ-ENDEN", 5, 7, "a", "ja", f"TON={ton};ENDEN=Justizirrtum,Totale Eskalation", "800–1.300")
for v, ton in [(1, "gruseliger"), (2, "komischer"), (3, "ausgewogen")]:
    add(f"ERZ-GEST-V{v}", "VARIANTEN", "ERZ-GEST", 5, 7, "a", "ja", f"TON={ton}", "600–900")
add("DET-MAPPE", "SCHREIB", "DET-MAPPE", 5, 7, "a", "nein", "–", "800–1.400")
add("SL-LÖSUNG-1", "SCHREIB", "SL", 5, 7, "a", "ja", "TEIL=Hergang und Zeitleiste", "1.000–1.600")
add("SL-LÖSUNG-2", "SCHREIB", "SL", 5, 7, "a", "ja", "TEIL=Lösungsweg und Gegenprobe", "1.000–1.600")
add("PRÜF-AUFL", "PRÜF", "PRUEF-AUFL", 5, 7, "b", "ja", "–", "600–1.200",
    "ERZ-EINGRENZ-1,ERZ-EINGRENZ-2,ERZ-ANKLAGE")

# ---------- Tag 8 · Probeläufe A + Welle 1-B ----------
for pfad in ["BEST", "SCHLECHT", "GEMISCHT"]:
    add(f"LAUF-04-{pfad}", "PROBELAUF", "LAUF", 6, 8, "b", "ja", f"N=4;PFAD={pfad}", "900–1.600", "DET-P3,ERZ-EINGRENZ-1")
add("LAUF-06-GEMISCHT", "PROBELAUF", "LAUF", 6, 8, "b", "ja", "N=6;PFAD=GEMISCHT", "900–1.600", "DET-P3")
for pfad in ["BEST", "SCHLECHT", "GEMISCHT"]:
    add(f"LAUF-08-{pfad}", "PROBELAUF", "LAUF", 6, 8, "b", "ja", f"N=8;PFAD={pfad}", "900–1.600", "DET-P3")
add("PRÜF-ZEIT-A", "PRÜF", "PRUEF-ZEIT", 6, 8, "b", "ja", "ROLLEN=R01–R08", "600–1.200", "P3-R08")
add("PRÜF-SKAL-A", "PRÜF", "PRUEF-SKAL", 6, 8, "b", "nein", "ROLLEN=R01–R08", "600–1.200", "P3-R08")
add("PRÜF-DET-FAIRPLAY", "PRÜF", "PRUEF-FAIRPLAY", 6, 8, "b", "ja", "–", "600–1.200", "DET-P3")
for n in B:
    add(f"PROFIL-{r(n)}", "SCHREIB", "PROFIL", 1, 8, "a", "nein", f"ROLLE={r(n)}", "650–1.000")
add("ERZ-VORST-B", "SCHREIB", "ERZ-VORST", 1, 8, "a", "nein", "ROLLEN=R09–R20", "800–1.100")
add("BILD-FIGUREN-3", "SCHREIB", "BILD-FIGUREN", 1, 8, "a", "nein", "FIGUREN=R09,R10,R11,R12", "500–800")
add("BILD-FIGUREN-4", "SCHREIB", "BILD-FIGUREN", 1, 8, "a", "nein", "FIGUREN=R13,R14,R15,R16", "500–800")
add("BILD-FIGUREN-5", "SCHREIB", "BILD-FIGUREN", 1, 8, "a", "nein", "FIGUREN=R17,R18,R19,R20", "500–800")

# ---------- Tag 9–11 · Welle 2-B bis 4-B ----------
for ph, tag in [(1, 9), (2, 10), (3, 11)]:
    for n in B:
        add(f"P{ph}-{r(n)}", "SCHREIB", "PHASE-ROLLE", ph + 1, tag, "a", "nein", f"PHASE={ph};ROLLE={r(n)}", "550–900",
            f"PROFIL-{r(n)}" if ph == 1 else f"P{ph - 1}-{r(n)}")
    add(f"ERZ-ANS-P{ph}-B", "SCHREIB", "ERZ-ANSAGEN", ph + 1, tag, "a", "nein", f"PHASE={ph};ROLLEN=R09–R20", "700–1.100")
    add(f"PRÜF-P{ph}-SPIEGEL-B", "PRÜF", "PRUEF-SPIEGEL", ph + 1, tag, "b", "nein", f"PHASE={ph};ROLLEN=R09–R20", "600–1.200",
        ",".join(f"P{ph}-{r(n)}" for n in B))
    add(f"PRÜF-P{ph}-KANON-B", "PRÜF", "PRUEF-KANON", ph + 1, tag, "b", "ja", f"PHASE={ph};ROLLEN=R09–R20", "600–1.200",
        ",".join(f"P{ph}-{r(n)}" for n in B))
add("PRÜF-PROFIL-B", "PRÜF", "PRUEF-PROFIL", 1, 9, "b", "ja", "PAKETE=PROFIL-R09–R20", "600–1.200",
    ",".join(f"PROFIL-{r(n)}" for n in B))
add("SL-BESETZUNG", "SCHREIB", "SL", 5, 9, "a", "ja", "TEIL=Besetzung je Spielerzahl", "850–1.300")

# ---------- Tag 12 · Probeläufe B + Endprüfungen ----------
add("LAUF-11-GEMISCHT", "PROBELAUF", "LAUF", 6, 12, "b", "ja", "N=11;PFAD=GEMISCHT", "900–1.600", "P3-R20")
for nn in [12, 16, 20]:
    for pfad in ["BEST", "SCHLECHT", "GEMISCHT"]:
        add(f"LAUF-{nn}-{pfad}", "PROBELAUF", "LAUF", 6, 12, "b", "ja", f"N={nn};PFAD={pfad}", "900–1.600", "P3-R20")
for k, v, l, prm in [("PRÜF-ZEIT-B", "PRUEF-ZEIT", "ja", "ROLLEN=R09–R20"), ("PRÜF-SKAL-B", "PRUEF-SKAL", "nein", "ROLLEN=R09–R20"),
                     ("PRÜF-ABSICHERUNG", "PRUEF-ABSICHERUNG", "ja", "–"), ("PRÜF-ERZ-VORLESE-1", "PRUEF-VORLESE", "nein", "TEXTE=Einführung,Phasen"),
                     ("PRÜF-ERZ-VORLESE-2", "PRUEF-VORLESE", "ja", "TEXTE=Auflösung,Enden,Geständnis"), ("PRÜF-LEIT-1", "PRUEF-LEIT", "nein", "TEXTE=Rollenmappen"),
                     ("PRÜF-LEIT-2", "PRUEF-LEIT", "ja", "TEXTE=Erzähler,Bilder"), ("PRÜF-SPOILER-1", "PRUEF-SPOILER", "ja", "TEXTE=Steckbriefe,Dossiers Unschuldiger"),
                     ("PRÜF-SPOILER-2", "PRUEF-SPOILER", "ja", "TEXTE=Erzähler bis Phase 3,Einladung,Regelblatt,Bilder")]:
    add(k, "PRÜF", v, 6, 12, "b", l, prm, "600–1.400", "P3-R20")

# ---------- Tag 13 · Montage und Lektorat ----------
for i, (von, bis) in enumerate([(1, 5), (6, 10), (11, 15), (16, 20)], 1):
    add(f"MONT-MAPPEN-{i}", "MONTAGE", "MONT-MAPPEN", 7, 13, "a", "nein", f"ROLLEN=R{von:02d}–R{bis:02d}", "750–1.100", "LAUF-20-BEST")
for k, prm, l in [("MONT-SKRIPTBUCH", "PRODUKT=Erzähler-Skriptbuch", "ja"), ("MONT-HANDBUCH", "PRODUKT=Spielleiter-Handbuch", "ja"),
                  ("MONT-DESIGN", "PRODUKT=Design-Paket", "nein"), ("MONT-QB", "PRODUKT=Qualitätsbericht", "ja")]:
    add(k, "MONTAGE", "MONT-PRODUKT", 7, 13, "a", l, prm, "600–1.300", "LAUF-20-BEST")
for k, prm, l in [("LEKT-PROFIL", "TEXTE=Steckbriefe und Dossiers", "ja"), ("LEKT-P1", "TEXTE=Phase 1", "ja"), ("LEKT-P2", "TEXTE=Phase 2", "ja"),
                  ("LEKT-P3", "TEXTE=Phase 3", "ja"), ("LEKT-ERZ", "TEXTE=Erzähler-Skriptbuch", "ja"), ("LEKT-SL", "TEXTE=Spielleiter-Handbuch", "ja"),
                  ("LEKT-DET", "TEXTE=Detektiv-Mappe und Hinweisset", "ja")]:
    add(k, "PRÜF", "LEKTORAT", 7, 13, "b", l, prm, "600–1.200", "MONT-SKRIPTBUCH")


def schreibe():
    alt = {}
    if os.path.exists(ZIEL):
        for line in open(ZIEL, encoding="utf-8"):
            m = re.match(r"^@(\S+) \[O\].*\| Status: (.+)$", line.strip())
            if m:
                alt[m.group(1)] = m.group(2)
    # Sitzungen je Tag und Charge reihum verteilen
    zaehler = {}
    for p in P:
        key = (p["tag"], p["charge"])
        i = zaehler.get(key, 0)
        p["sitzung"] = f"H{i % 3 + 1}"
        zaehler[key] = i + 1
    out = ["# PLAN · Paketverzeichnis (Feinplan) · Spuk im Gewölbe",
           "Erzeugt mit 90_werkzeug/plan.py. Ein Datensatz je Paket. Charge a = Schreiben und Reparatur, Charge b = Prüfen und Probeläufe auf bereits Freigegebenem; Charge b startet erst nach Abnahme von Charge a.",
           f"Summe: {len(P)} Pakete (ohne Reparaturläufe; Puffer 41 REP).", ""]
    tag = None
    for p in P:
        if p["tag"] != tag:
            tag = p["tag"]
            anz = sum(1 for x in P if x["tag"] == tag)
            out.append(f"\n## Tag {tag} · {anz} Pakete")
        st = alt.get(p["k"], "offen")
        out.append(f"@{p['k']} [O] | Typ: {p['typ']} | Vorlage: {p['vorlage']} | Welle: {p['welle']} | Tag: {p['tag']} | Charge: {p['charge']} | "
                   f"Sitzung: {p['sitzung']} | Lösung: {p['loes']} | Parameter: {p['param']} | Umfang: {p['umfang']} | Abhängig: {p['abh']} | Status: {st}")
    with open(ZIEL, "w", encoding="utf-8") as fh:
        fh.write("\n".join(out) + "\n")
    return len(P)


if __name__ == "__main__":
    n = schreibe()
    ids = [p["k"] for p in P]
    assert len(ids) == len(set(ids)), "doppelte Kennung"
    from collections import Counter
    print(f"{n} Pakete geschrieben.")
    print("je Tag:", dict(Counter(p['tag'] for p in P)))
    print("je Welle:", dict(sorted(Counter(p['welle'] for p in P).items())))
    print("je Typ:", dict(Counter(p['typ'] for p in P)))
    print("max je Tag/Charge/Sitzung:", max(Counter((p['tag'], p['charge'], p['sitzung']) for p in P).values()))

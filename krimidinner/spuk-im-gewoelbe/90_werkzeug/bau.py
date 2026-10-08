#!/usr/bin/env python3
"""Internes Werkzeug: baut Arbeitspakete aus PLAN, Vorlage und Kanon-Auszug (kein Endprodukt).

Aufruf:
  python3 90_werkzeug/bau.py PROFIL-R07            # baut 30_pakete/PROFIL-R07.r0.md
  python3 90_werkzeug/bau.py PROFIL-R07 --runde 1  # Runde 1 (Neuausgabe)
  python3 90_werkzeug/bau.py --tag 3               # alle Pakete von Tag 3 (Charge a)
  python3 90_werkzeug/bau.py --tag 3 --charge b
  python3 90_werkzeug/bau.py --test                # baut je Vorlage ein Paket nach 30_pakete/_test/
  python3 90_werkzeug/bau.py --durchspiel 8 BEST    # druckt den Durchspiel-Auszug für 8 Rollen
Regeln: Pakete mit „Lösung: nein“ bekommen nie einen [L]-Datensatz; sonst bricht der Bau ab.
"""
import os
import re
import sys
from collections import OrderedDict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kanon  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
VORL = os.path.join(ROOT, "20_vorlagen")
PAKETE = os.path.join(ROOT, "30_pakete")
FREI = os.path.join(ROOT, "60_freigaben")


class BauFehler(Exception):
    pass


def kanon_version():
    p = os.path.join(ROOT, "10_kanon", "VERSION.md")
    if os.path.exists(p):
        for line in open(p, encoding="utf-8"):
            m = re.search(r"Kanon v([\d.]+)", line)
            if m:
                return m.group(1)
    return "0.9"


def lade_datei(pfad):
    recs = OrderedDict()
    for line in open(pfad, encoding="utf-8"):
        line = line.rstrip("\n")
        m = kanon.REC.match(line)
        if not m:
            continue
        f = OrderedDict()
        for teil in [t for t in m.group("rest").split(" | ") if t.strip()]:
            teil = teil.strip().lstrip("|").strip()
            if ":" in teil:
                k, v = teil.split(":", 1)
                f[k.strip()] = v.strip()
        recs[m.group("id")] = kanon.Rec(m.group("id"), m.group("s"), f, os.path.basename(pfad), 0, line)
    return recs


def plan():
    return lade_datei(os.path.join(ROOT, "00_steuerung", "PLAN.md"))


def params(p):
    out = {}
    for teil in p.get("Parameter").split(";"):
        if "=" in teil:
            k, v = teil.split("=", 1)
            out[k.strip()] = v.strip()
    return out


def abschnitte(pfad, ebene="## "):
    sec, cur = OrderedDict(), None
    for line in open(pfad, encoding="utf-8"):
        if line.startswith(ebene) and not line.startswith(ebene + "#"):
            cur = line[len(ebene):].strip()
            sec[cur] = []
        elif cur is not None:
            sec[cur].append(line.rstrip("\n"))
    return {k: "\n".join(v).strip() for k, v in sec.items()}


def k8_teil(nummer):
    for k, v in abschnitte(os.path.join(ROOT, "10_kanon", "K8-STILBLATT.md")).items():
        if k.startswith(f"{nummer}."):
            return v
    raise BauFehler(f"K8 Abschnitt {nummer} fehlt")


def k9_teil(nummer):
    for k, v in abschnitte(os.path.join(ROOT, "10_kanon", "K9-LOOKBIBEL.md")).items():
        if k.startswith(f"{nummer}."):
            return v
    raise BauFehler(f"K9 Abschnitt {nummer} fehlt")


def muster(mid):
    txt = k8_teil(11)
    blocks = re.split(r"\n(?=### )", "\n" + txt)
    for b in blocks:
        if b.strip().startswith(f"### {mid} "):
            return b.strip()
    raise BauFehler(f"Muster {mid} fehlt")


# ---------------------------------------------------------------- Auszugsbausteine
class Auszug:
    def __init__(self, recs, loesung):
        self.recs, self.loesung = recs, loesung
        self.items = OrderedDict()   # id -> (rec, strip)
        self.notizen = []

    def add(self, rid, strip=(), pflicht=True):
        if rid in self.items:
            return
        r = self.recs.get(rid)
        if r is None:
            if pflicht:
                raise BauFehler(f"Kanon-Datensatz {rid} fehlt")
            return
        if r.sicht == "L" and not self.loesung:
            raise BauFehler(f"{rid} ist [L], Paket hat Lösung: nein")
        self.items[rid] = (r, tuple(strip))

    def add_prefix(self, prefix, sicht=None, strip=()):
        for rid, r in self.recs.items():
            if rid.startswith(prefix) and (sicht is None or r.sicht in sicht):
                self.add(rid, strip)

    def namen(self, rollen):
        for n in sorted(set(rollen)):
            st = self.recs.get(f"{n}-STAMM")
            if st and f"{n}-STAMM" not in self.items:
                self.notizen.append(f"{n} = {st.get('Name')} (Aussprache: {st.get('Aussprache')}; {st.get('Geschlecht')}, {st.get('Alter')}; {st.get('Beruf')})")

    def text(self):
        out = []
        for i, (rid, (r, strip)) in enumerate(self.items.items(), 1):
            out.append(f"{i}. [{rid}] ({ {'O': 'öffentlich', 'G': 'geheim', 'L': 'Lösung'}[r.sicht] })")
            for k, v in r.f.items():
                if k in strip:
                    continue
                out.append(f"   - {k}: {v}")
        if self.notizen:
            out.append("")
            out.append("Namen weiterer Personen (nur zur korrekten Schreibweise):")
            out += [f"   - {n}" for n in self.notizen]
        return "\n".join(out)


def rollen_in(text):
    return set(re.findall(r"\bR\d\d\b", text))


def basis_oeffentlich(a):
    for rid, r in a.recs.items():
        if re.match(r"^K-0\d\d$", rid) and r.sicht == "O":
            a.add(rid)
    a.add_prefix("LISTE-")


# ---------------------------------------------------------------- Auszüge je Vorlage
def ax_profil(a, prm, plan_rec):
    R = prm["ROLLE"]
    for t in ("STAMM", "ÖFFENTLICH", "GEHEIM", "WISSEN", "VERBINDUNGEN", "LÜGE"):
        a.add(f"{R}-{t}")
    if a.loesung:
        a.add(f"{R}-PLOT")
        for k in ("K-090", "K-091", "STRANG-b", "STRANG-c"):
            a.add(k)
    basis_oeffentlich(a)
    a.add_prefix("OA-")
    a.add("BW-STAMM")
    a.add("DET-STAMM")
    for i in range(1, 7):
        a.add(f"LR-{i}")
    txt = " ".join(a.items[k][0].roh for k in a.items)
    a.namen(rollen_in(txt) - {R})
    return {"ROLLE": R, "ROLLENNAME": a.recs[f"{R}-STAMM"].get("Name"),
            "SCHULD": ("Du bist die Person, die den Burgwart niedergeschlagen hat. Dein Dossier sagt das deutlich, ohne zu beschönigen, aber mit Verständnis."
                       if a.loesung else "Du bist NICHT die Person, die den Burgwart niedergeschlagen hat. Dein Dossier sagt das ausdrücklich in einem Satz.")}


def ax_phase_rolle(a, prm, plan_rec):
    R, ph = prm["ROLLE"], int(prm["PHASE"])
    for t in ("STAMM", "ÖFFENTLICH", "GEHEIM", "WISSEN", "LÜGE"):
        a.add(f"{R}-{t}")
    partner, hs = set(), []
    eigene, spiegel = [], []
    for _, g in kanon.gespraeche(a.recs, ph):
        if g.get("Von") == R:
            eigene.append(g)
        if g.get("Ziel") == R or g.get("Ersatz") == R:
            spiegel.append(g)
    if len(eigene) != 3:
        raise BauFehler(f"{R} hat in Phase {ph} {len(eigene)} Aufträge statt 3")
    for g in eigene:
        a.add(g.id, strip=("Antwortart", "Ersatz-Antwortart"))
        partner |= {g.get("Ziel"), g.get("Ersatz")}
        hs += re.findall(r"H-\d+", g.get("Gibt heraus") + " " + g.get("Ersatz gibt heraus"))
    for g in spiegel:
        if g.id in a.items:
            continue
        a.add(g.id)
        partner.add(g.get("Von"))
        hs += re.findall(r"H-\d+", g.get("Gibt heraus") + " " + g.get("Ersatz gibt heraus"))
    for h in hs:
        a.add(h)
    a.add(f"E{ph}-{R[1:]}", pflicht=False)
    a.add(f"MK{ph}-{R}", pflicht=False)
    for i in range(1, 7):
        a.add(f"LR-{i}")
    a.namen({p for p in partner if p and p != "–"} - {R})
    return {"ROLLE": R, "ROLLENNAME": a.recs[f"{R}-STAMM"].get("Name"), "PHASE": str(ph),
            "N_AUFTRAEGE": str(len(eigene)), "N_SPIEGEL": str(len(spiegel)),
            "SPIEGEL_LISTE": ", ".join(g.id + (" (Ersatzfall)" if g.get("Ersatz") == R else "") for g in spiegel)}


def ax_det_phase(a, prm, plan_rec):
    ph = int(prm["PHASE"])
    for i in (1, 2, 3):
        a.add(f"D{ph}-{i}")
        a.add(f"DW{ph}-{i}")
        for h in re.findall(r"H-\d+", a.recs[f"D{ph}-{i}"].get("Begründbar durch")):
            a.add(h)
    a.add("DET-STAMM")
    a.add("DET-ALIBI")
    a.add("BW-STAMM")
    a.namen({"R01", "R02", "R03", "R04"})
    return {"PHASE": str(ph)}


def ax_erz_phase(a, prm, plan_rec):
    ph = int(prm["PHASE"])
    basis_oeffentlich(a)
    a.add("BW-STAMM")
    a.add("BW-ZUSTAND")
    a.add(f"BW-AUSSAGE-{ph}")
    for rid, r in a.recs.items():
        if re.match(r"^H-\d\d$", rid) and r.sicht == "O" and r.get("Phase") == str(ph) and "Erzähler" not in r.get("Quelle"):
            a.add(rid)
    a.add("ZM-3")
    a.add("IF-5")
    a.add("IF-7")
    a.add("DET-STAMM")
    a.namen({"R01", "R02", "R03", "R04"})
    return {"PHASE": str(ph), "KATALOG": k8_teil(8)}


def ax_erz_einf(a, prm, plan_rec):
    a.add("FÜNF-SÄTZE")
    basis_oeffentlich(a)
    a.add_prefix("OA-")
    for k in ("BW-STAMM", "BW-ZUSTAND", "BW-AUSSAGE-0", "DET-STAMM", "DET-ALIBI"):
        a.add(k)
    for n in ("R01", "R02", "R03", "R04"):
        a.add(f"{n}-ÖFFENTLICH")
    a.namen({"R01", "R02", "R03", "R04"})
    return {"TON": prm.get("TON", "ausgewogen"), "KATALOG": k8_teil(8)}


def bereich(txt):
    m = re.match(r"R(\d\d)–R(\d\d)", txt)
    return [f"R{n:02d}" for n in range(int(m.group(1)), int(m.group(2)) + 1)]


def ax_erz_vorst(a, prm, plan_rec):
    rollen = bereich(prm["ROLLEN"])
    for n in rollen:
        a.add(f"{n}-STAMM")
        a.add(f"{n}-ÖFFENTLICH", strip=("Behauptetes Alibi",))
    a.add("K-001")
    return {"ROLLEN": prm["ROLLEN"], "ANZAHL": str(len(rollen)),
            "MARKER": "Rollen 01 bis 04 ohne Markierung; jede Rolle ab 05 steht vollständig zwischen [NUR WENN ROLLE NN BESETZT] und [ENDE BEDINGUNG]."}


HINW_GRUPPEN = {
    "Speisekammer,Kamin-Gewölbe": ["H-04", "H-06", "H-20", "H-21", "H-28"],
    "Wendeltreppenturm,Hof": ["H-12", "H-13", "H-27", "H-01", "H-02"],
    "Dokumente": ["H-07", "H-24", "H-08", "H-18", "H-23", "H-15"],
}


def ax_hinw(a, prm, plan_rec):
    ids = HINW_GRUPPEN[prm["GRUPPE"]]
    for h in ids:
        a.add(h)
    for b in range(1, 14):
        a.add(f"BSO-{b:02d}", pflicht=False)
    a.add("K-003")
    a.add("K-004")
    a.add("K-005")
    a.add("K-006")
    return {"GRUPPE": prm["GRUPPE"], "ANZAHL": str(len(ids)), "KENNUNGEN": ", ".join(ids)}


def ax_hinw_melde(a, prm, plan_rec):
    for ph in (1, 2, 3):
        for n in ("R01", "R02", "R03", "R04"):
            a.add(f"MK{ph}-{n}")
    a.add("IF-5")
    a.namen({"R01", "R02", "R03", "R04"})
    return {}


def ax_hinw_det(a, prm, plan_rec):
    a.add("DET-STAMM")
    a.add("DET-ALIBI")
    for i in range(1, 7):
        a.add(f"DET-B{i}")
    a.add("IF-1")
    a.add("IF-4")
    a.namen({"R01", "R02", "R03", "R04"})
    return {}


def ax_req_bau(a, prm, plan_rec):
    for s in prm["STUECKE"].split(","):
        a.add(s)
        a.add("BSO-" + s.split("-")[1], pflicht=False)
    a.add("K-004")
    a.add("K-005")
    a.add("K-007")
    return {"STUECKE": prm["STUECKE"], "ANZAHL": str(len(prm["STUECKE"].split(",")))}


def ax_req_raum(a, prm, plan_rec):
    basis_oeffentlich(a)
    for b in range(1, 14):
        a.add(f"BSO-{b:02d}")
    a.add_prefix("LA-")
    return {"KATALOG": k8_teil(8)}


def ax_req_klang(a, prm, plan_rec):
    a.add_prefix("OA-")
    a.add("BSO-08")
    a.add("H-08")
    a.add("ZM-1")
    a.add("ZM-3")
    a.add("ZM-5")
    a.add("IF-5")
    return {"KATALOG": k8_teil(8), "LICHT": k9_teil(2)}


def k9_basis():
    return "\n\n".join(f"{t}\n{k9_teil(n)}" for n, t in [(1, "Bildstil"), (2, "Licht"), (3, "Farbpalette"), (4, "Kamerasprache"),
                                                            (5, "Formate"), (6, "Ausschlüsse"), (9, "Aufbau eines Bildprompt-Eintrags")])


def ax_bild(a, prm, plan_rec):
    v = plan_rec.get("Vorlage")
    a.add("FÜNF-SÄTZE")
    a.add("K-001")
    a.add("K-002")
    if v in ("BILD-TITEL", "BILD-EINLADUNG"):
        a.add("LA-01")
        a.add("LA-02")
        a.add("LA-06")
        a.add("BW-STAMM")
        a.add("OA-04")
    elif v == "BILD-STATIONEN":
        for k in ("LA-02", "LA-03", "LA-04", "LA-06"):
            a.add(k)
    elif v == "BILD-LAGEPLAN":
        for k in ("LA-07", "LA-01", "LF-BW", "LA-05", "K-003", "K-004", "K-005", "K-006"):
            a.add(k)
    elif v == "BILD-FIGUREN":
        for f in prm["FIGUREN"].split(","):
            a.add(f"LF-{f}")
            a.add(f"{f}-STAMM", strip=("Familie", "Sprechweise"))
        a.add("LA-02")
    elif v == "BILD-BEWEISE":
        for s in prm["STUECKE"].split(","):
            a.add(s)
        a.add("LA-03")
        a.add("LA-04")
    elif v == "BILD-KARTEN":
        a.add("LA-02")
    return {"TON": prm.get("TON", "ausgewogen"), "LOOK": k9_basis(), "MOTIVE": prm.get("MOTIVE", prm.get("FIGUREN", prm.get("STUECKE", prm.get("KARTEN", ""))))}


AUSZUG = {
    "PROFIL": ax_profil, "PHASE-ROLLE": ax_phase_rolle, "DET-PHASE": ax_det_phase, "ERZ-PHASE": ax_erz_phase,
    "ERZ-EINF": ax_erz_einf, "ERZ-VORST": ax_erz_vorst, "HINW": ax_hinw, "HINW-MELDE": ax_hinw_melde, "HINW-DET": ax_hinw_det,
    "REQ-BAU": ax_req_bau, "REQ-RAUM": ax_req_raum, "REQ-KLANG-LICHT": ax_req_klang,
    "BILD-TITEL": ax_bild, "BILD-EINLADUNG": ax_bild, "BILD-STATIONEN": ax_bild, "BILD-LAGEPLAN": ax_bild,
    "BILD-FIGUREN": ax_bild, "BILD-BEWEISE": ax_bild, "BILD-KARTEN": ax_bild,
}


# ---------------------------------------------------------------- Auszüge Wellen 2–7
def material(ids):
    teile = []
    for i in ids:
        f = os.path.join(FREI, f"{i}.md")
        if not os.path.exists(f):
            raise BauFehler(f"Prüfmaterial {i} ist noch nicht freigegeben ({os.path.relpath(f, ROOT)} fehlt)")
        teile.append(f"===== MATERIAL {i} =====\n" + open(f, encoding="utf-8").read().strip())
    return "\n\n".join(teile)


def liste(txt):
    """'PROFIL-R01–R08' -> [PROFIL-R01 … PROFIL-R08]; Komma-Listen bleiben erhalten."""
    out = []
    for teil in txt.split(","):
        teil = teil.strip()
        m = re.match(r"^(.*R)(\d\d)–R(\d\d)$", teil)
        if m:
            out += [f"{m.group(1)}{n:02d}" for n in range(int(m.group(2)), int(m.group(3)) + 1)]
        elif teil and teil != "–":
            out.append(teil)
    return out


def ax_erz_ansagen(a, prm, plan_rec):
    ph = int(prm["PHASE"])
    ans = []
    for n in bereich(prm["ROLLEN"]):
        e = a.recs.get(f"E{ph}-{n[1:]}")
        if not e:
            raise BauFehler(f"E{ph}-{n[1:]} fehlt")
        a.add(e.id)
        for k, v in e.f.items():
            if k.startswith("Option ") and "Ansage" in v:
                ans.append(f"A-E{ph}-{n[1:]}-{k.split()[1]}")
    a.namen(bereich(prm["ROLLEN"]))
    return {"PHASE": str(ph), "ROLLEN": prm["ROLLEN"], "ANZAHL": str(len(ans)), "ANSAGEN": ", ".join(ans) or "keine"}


def ax_erz_eingrenz(a, prm, plan_rec):
    for rid in a.recs:
        if rid.startswith("AB-") or rid.startswith("VK-"):
            a.add(rid)
    for k in ("S-8", "S-9", "S-10", "K-092"):
        a.add(k)
    a.namen({"R01", "R02", "R03", "R04"})
    return {"BAENDER": prm["BAENDER"]}


def ax_erz_anklage(a, prm, plan_rec):
    a.add_prefix("AK-")
    a.add("VK-1")
    a.add("BW-STAMM")
    a.namen({"R01", "R02", "R03", "R04"})
    return {}


def ax_erz_enden(a, prm, plan_rec):
    for k in ("K-090", "K-091", "K-092", "STRANG-a", "STRANG-b", "STRANG-c", "STRANG-d", "S-8", "S-9", "S-10", "BW-STAMM"):
        a.add(k)
    a.add_prefix("EM-")
    for z in ("Z-2120", "Z-2245", "Z-2250", "Z-2320", "Z-2346", "Z-2358a", "Z-2358e", "Z-2358f", "Z-2358g", "Z-2358j", "Z-2358l", "Z-2358m", "Z-2359a", "Z-2359c", "Z-0000a"):
        a.add(z)
    a.namen({"R01", "R02", "R03", "R04"})
    return {"TON": prm.get("TON", "ausgewogen"), "ENDEN": prm.get("ENDEN", "")}


def ax_erz_gest(a, prm, plan_rec):
    for k in ("GS-1", "GS-2", "K-090", "K-091", "R03-STAMM", "BW-STAMM", "STRANG-b", "Z-2358f", "Z-2358g", "Z-2358j"):
        a.add(k)
    return {"TON": prm.get("TON", "ausgewogen")}


def ax_det_mappe(a, prm, plan_rec):
    a.add_prefix("IF-")
    for i in range(1, 7):
        a.add(f"LR-{i}")
    a.add("DET-STAMM")
    a.add("DET-ALIBI")
    for ph in (1, 2, 3):
        for i in (1, 2, 3):
            a.add(f"D{ph}-{i}")
    a.namen({"R01", "R02", "R03", "R04"})
    return {}


SL_TEILE = {
    "Aufbau und Material": lambda a: (basis_oeffentlich(a), [a.add(f"BSO-{b:02d}") for b in range(1, 14)], a.add_prefix("IF-")),
    "Ablaufplan mit Cues": lambda a: (a.add_prefix("ZM-"), a.add_prefix("IF-")),
    "Regeln und Sonderfälle": lambda a: (a.add_prefix("LR-"), a.add_prefix("IF-"), a.add_prefix("ZM-"), a.add_prefix("AK-")),
    "Hergang und Zeitleiste": lambda a: (a.add_prefix("Z-"), a.add_prefix("POS-"), a.add_prefix("PF-"), a.add("K-090")),
    "Lösungsweg und Gegenprobe": lambda a: (a.add_prefix("S-"), [a.add(f"DW{p}-{i}") for p in (1, 2, 3) for i in (1, 2, 3)], a.add_prefix("AB-"), a.add_prefix("EM-")),
    "Besetzung je Spielerzahl": lambda a: (a.add("VK-1"), [a.add(f"R{n:02d}-PLOT") for n in range(1, 21)], [a.add(f"R{n:02d}-STAMM") for n in range(1, 21)], a.add("ZM-2")),
}


def ax_sl(a, prm, plan_rec):
    teil = prm["TEIL"]
    SL_TEILE[teil](a)
    return {"TEIL": teil}


def ax_regelblatt(a, prm, plan_rec):
    a.add("FÜNF-SÄTZE")
    for i in range(1, 7):
        a.add(f"LR-{i}")
    a.add_prefix("IF-")
    a.add_prefix("ZM-")
    return {}


def ax_pruef(a, prm, plan_rec):
    v = plan_rec.get("Vorlage")
    abh = [x for x in plan_rec.get("Abhängig").split(",") if x.strip() and x.strip() != "–"]
    werte = {}
    if v == "PRUEF-PROFIL":
        ids = liste(prm["PAKETE"])
        for i in ids:
            n = i.split("-")[1]
            for t in ("STAMM", "ÖFFENTLICH", "GEHEIM", "WISSEN", "VERBINDUNGEN", "LÜGE", "PLOT"):
                a.add(f"{n}-{t}")
        werte["MATERIAL"] = material(ids)
    elif v in ("PRUEF-SPIEGEL", "PRUEF-KANON"):
        ph = int(prm["PHASE"])
        rollen = bereich(prm["ROLLEN"])
        for _, g in kanon.gespraeche(a.recs, ph):
            if {g.get("Von"), g.get("Ziel"), g.get("Ersatz")} & set(rollen):
                a.add(g.id)
                for h in re.findall(r"H-\d+", g.get("Gibt heraus") + " " + g.get("Ersatz gibt heraus")):
                    a.add(h)
        for n in rollen:
            a.add(f"E{ph}-{n[1:]}", pflicht=False)
            if v == "PRUEF-KANON":
                for t in ("WISSEN", "LÜGE"):
                    a.add(f"{n}-{t}")
        if v == "PRUEF-KANON":
            a.add_prefix("LR-")
        werte["MATERIAL"] = material([f"P{ph}-{n}" for n in rollen])
    elif v == "PRUEF-FAIRPLAY":
        for p in (1, 2, 3):
            for i in (1, 2, 3):
                a.add(f"D{p}-{i}")
                a.add(f"DW{p}-{i}")
                for h in re.findall(r"H-\d+", a.recs[f"D{p}-{i}"].get("Begründbar durch")):
                    a.add(h)
        werte["MATERIAL"] = material(["DET-P1", "DET-P2", "DET-P3"])
    elif v == "PRUEF-AUFL":
        a.add_prefix("AB-")
        a.add_prefix("AK-")
        a.add_prefix("EM-")
        a.add("VK-1")
        werte["MATERIAL"] = material(abh)
    else:
        # Prüfungen über viele Texte: Kanon-Grundlage je Typ, Material = alle Freigaben, die es schon gibt
        if v == "PRUEF-ZEIT":
            a.add_prefix("Z-")
            a.add_prefix("POS-")
        if v == "PRUEF-SPOILER":
            for k in ("K-090", "S-4", "S-5", "S-6", "S-7", "BS-01", "BS-02", "BS-07", "BS-13"):
                a.add(k)
        if v == "PRUEF-BILD":
            a.add_prefix("LA-")
            a.add_prefix("LF-")
        basis_oeffentlich(a)
        vorh = sorted(f[:-3] for f in os.listdir(FREI) if f.endswith(".md")) if os.path.isdir(FREI) else []
        muster_ids = {
            "PRUEF-BILD": [x for x in vorh if x.startswith("BILD-")],
            "PRUEF-SPOILER": [x for x in vorh if x.startswith(("PROFIL-", "ERZ-EINF", "ERZ-VORST", "BILD-", "REGELBLATT", "ERZ-P"))],
            "PRUEF-ZEIT": [x for x in vorh if x.startswith(("PROFIL-", "P1-", "P2-", "P3-"))],
            "PRUEF-SKAL": [x for x in vorh if x.startswith(("P1-", "P2-", "P3-", "ERZ-"))],
            "PRUEF-ABSICHERUNG": [],
            "PRUEF-VORLESE": [x for x in vorh if x.startswith("ERZ-") or x.startswith("DET-P")],
            "PRUEF-LEIT": vorh,
        }.get(v, [])
        if not muster_ids and v != "PRUEF-ABSICHERUNG":
            raise BauFehler(f"{v}: noch kein freigegebenes Material vorhanden")
        werte["MATERIAL"] = material(muster_ids) if muster_ids else ""
        if v == "PRUEF-ABSICHERUNG":
            import io
            import contextlib
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                kanon.probe_absicherung(a.recs, ausgabe=True)
            a.add_prefix("S-")
            werte["MATERIAL"] = "Absicherungstabelle (Schlussfolgerung: Besetzung:Anzahl unabhängiger Quellen)\n" + buf.getvalue()
    return werte


# ---------------------------------------------------------------- Probelauf, Montage, Lektorat
def kurz(txt, n=40):
    w = (txt or "").split()
    return " ".join(w[:n]) + (" …" if len(w) > n else "")


def durchspiel(recs, n, pfad):
    """Verdichteter Durchspiel-Auszug für Besetzung n (deterministisch aus dem Kanon)."""
    hs = {r.id: r for r in recs.values() if re.match(r"^H-\d+$", r.id)}
    out = [f"Besetzung: Rollen R01 bis R{n:02d} sind besetzt (dazu das Geburtstagskind als Detektiv). Pfad: {pfad}.",
           "Besetzte Rollen: " + "; ".join(f"R{i:02d} {recs[f'R{i:02d}-STAMM'].get('Name')}" for i in range(1, n + 1) if f"R{i:02d}-STAMM" in recs)]
    for ph in (1, 2, 3):
        out += ["", f"### Phase {ph}"]
        bw = recs.get(f"BW-AUSSAGE-{ph}")
        if bw:
            out.append(f"Erzähler, Phasenstart (Aussage des Burgwarts): {bw.get('Aussage')}")
        out.append("Ohne Gespräch erreichbar (Station, Beweisstück, Erzähler, Meldekarte):")
        for h in hs.values():
            if "G" in h.get("Quelle") and re.search(r"\bG\d-\d+\b", h.get("Quelle")):
                continue
            if h.get("Phase") == str(ph) and kanon.verfuegbar(recs, h, n):
                out.append(f"- {h.id} ({h.get('Form')}; {h.get('Quelle')}): {h.get('Inhalt')}")
        out.append("Gespräche, die stattfinden (Antwortart in Klammern):")
        for von, an, g, art in sorted(kanon.tatsaechliche(recs, ph, n), key=lambda x: (x[0], x[2].id)):
            if art == "FEHLT":
                out.append(f"- {g.id} R{von:02d} → niemand: ZIEL UND ERSATZ FEHLEN")
                continue
            ersatz = art == "ersatz"
            bed = g.get("Ersatz-Bedingung" if ersatz else "Bedingung")
            aa = g.get("Ersatz-Antwortart" if ersatz else "Antwortart")
            gh = re.findall(r"H-\d+", g.get("Ersatz gibt heraus" if ersatz else "Gibt heraus"))
            inhalt = " / ".join(f"{h}: {hs[h].get('Inhalt')}" if h in hs else f"{h}: FEHLT IM KANON" for h in gh)
            out.append(f"- {g.id} R{von:02d} → R{an:02d}{' (Ersatzfall)' if ersatz else ''}; Bedingung: {kurz(bed, 30)} ({aa}) ⇒ {inhalt or 'kein Hinweis'}")
        for e in sorted((r for r in recs.values() if re.match(rf"^E{ph}-\d\d$", r.id) and int(r.id[-2:]) <= n), key=lambda r: r.id):
            opts = " · ".join(f"{k}: {v}" for k, v in e.f.items() if k.startswith("Option"))
            out.append(f"- Rollen-Entscheidung {e.id} (R{e.id[-2:]}): {kurz(e.get('Lage'), 25)} · {opts}")
        for i in range(1, min(n, 4) + 1):
            mk = recs.get(f"MK{ph}-R{i:02d}")
            if mk:
                out.append(f"- Meldekarte {mk.id} (Lagerunde, Pflicht): {mk.get('Text')}")
        for i in (1, 2, 3):
            d, dw = recs.get(f"D{ph}-{i}"), recs.get(f"DW{ph}-{i}")
            if d and dw:
                out.append(f"- Detektiv-Entscheidung {d.id}: {d.get('Frage')} A: {d.get('Option A')} · B: {d.get('Option B')} · C: {d.get('Option C')} · "
                           f"richtig: {dw.get('Echte Spur')} · begründbar durch: {d.get('Begründbar durch')}")
    out += ["", "### Absicherung bei dieser Besetzung (Schlussfolgerung: unabhängige Quellen)"]
    for s in sorted((r for r in recs.values() if re.match(r"^S-\d+$", r.id)), key=lambda r: int(r.id[2:])):
        ids = set(re.findall(r"H-\d+", s.get("Hinweise")))
        for hw in recs.values():
            if hw.id.startswith("HW-") and re.search(r"\b" + re.escape(s.id) + r"\b", hw.get("Stützt")):
                ids.add("H-" + hw.id[3:])
        da = sorted(x for x in ids if x in hs and kanon.verfuegbar(recs, hs[x], n))
        out.append(f"- {s.id} ({'notwendig' if s.get('Notwendig').lower() == 'ja' else 'Gegenprobe'}): {s.get('Schlussfolgerung')} ⇒ erreichbar: {', '.join(da) or 'KEINER'}")
    return "\n".join(out)


def ax_lauf(a, prm, plan_rec):
    n, pfad = int(prm["N"]), prm["PFAD"]
    for pre in ("S-", "AB-", "AK-", "EM-", "LR-"):
        a.add_prefix(pre)
    a.add("VK-1")
    a.add("K-090")
    for p in (1, 2, 3):
        for i in (1, 2, 3):
            a.add(f"DW{p}-{i}")
    return {"N": str(n), "PFAD": pfad, "ZUSATZ_TITEL": f"Durchspiel-Auszug für {n} Rollen",
            "ZUSATZ": durchspiel(a.recs, n, pfad)}


def freigaben(praefixe):
    if not os.path.isdir(FREI):
        return []
    return sorted(f[:-3] for f in os.listdir(FREI) if f.endswith(".md") and f.startswith(tuple(praefixe)))


def mappen_inhalt(recs, R):
    zeilen = [f"MAPPE {R} · {recs[f'{R}-STAMM'].get('Name')} (Aussprache: {recs[f'{R}-STAMM'].get('Aussprache')})",
              f"- PROFIL-{R}: Steckbrief, Dossier, Kleidungshinweis"]
    for ph in (1, 2, 3):
        auf = [g.id for _, g in kanon.gespraeche(recs, ph) if g.get("Von") == R]
        sp = [g.id for _, g in kanon.gespraeche(recs, ph) if g.get("Ziel") == R]
        se = [g.id for _, g in kanon.gespraeche(recs, ph) if g.get("Ersatz") == R]
        karten = [f"Aufträge {', '.join(auf)}", f"Spiegelstücke {', '.join(sp) or '–'}"]
        if se:
            karten.append(f"Ersatz-Spiegelstücke {', '.join(se)}")
        karten.append(f"Entscheidungskarte E{ph}-{R[1:]}")
        if int(R[1:]) <= 4:
            karten.append(f"Meldekarte MK{ph}-{R}")
        zeilen.append(f"- P{ph}-{R}: " + " · ".join(karten))
    return "\n".join(zeilen)


def ax_mont_mappen(a, prm, plan_rec):
    rollen = bereich(prm["ROLLEN"])
    for R in rollen:
        a.add(f"{R}-STAMM", strip=("Familie", "Werdegang", "Wohnort", "Wurzeln"))
    vorlage = "\n\n".join(mappen_inhalt(a.recs, R) for R in rollen)
    return {"ROLLEN": prm["ROLLEN"], "ZUSATZ_TITEL": "Montagevorlage (Teile und Kartenkennungen je Mappe)", "ZUSATZ": vorlage}


PRODUKTE = {
    "Erzähler-Skriptbuch": ("ERZ-",),
    "Spielleiter-Handbuch": ("SL-", "REGELBLATT", "REQ-"),
    "Design-Paket": ("BILD-",),
    "Qualitätsbericht": ("PRUEF-", "PRÜF-", "LAUF-"),
}
LEKT_TEXTE = {
    "Steckbriefe und Dossiers": ("PROFIL-",),
    "Phase 1": ("P1-",), "Phase 2": ("P2-",), "Phase 3": ("P3-",),
    "Erzähler-Skriptbuch": ("ERZ-",),
    "Spielleiter-Handbuch": ("SL-", "REGELBLATT", "REQ-"),
    "Detektiv-Mappe und Hinweisset": ("DET-", "HINW-"),
}


def gliederung(kennung):
    """Überschriften und Feldnamen eines freigegebenen Texts (für Inhaltsverzeichnis und Cue-Index)."""
    z = []
    for line in open(os.path.join(FREI, f"{kennung}.md"), encoding="utf-8"):
        s = line.strip()
        if re.match(r"^(#+ |[A-ZÄÖÜ][A-ZÄÖÜ0-9 ·\-/]{2,}:|\[NUR WENN|=== )", s):
            z.append("   " + kurz(s, 16))
    return z


def ax_mont_produkt(a, prm, plan_rec):
    prod = prm["PRODUKT"]
    ids = freigaben(PRODUKTE[prod])
    if not ids:
        raise BauFehler(f"{prod}: noch keine freigegebenen Teile vorhanden")
    a.add("ZM-3")
    a.add("ZM-5")
    if prod == "Spielleiter-Handbuch":
        a.add_prefix("IF-")
    if prod == "Design-Paket":
        a.add_prefix("LA-")
    vorlage = []
    for i in ids:
        p = plan().get(i)
        vorlage.append(f"- {i} · {p.get('Typ') if p else 'Reparatur'}")
        vorlage += gliederung(i)
    return {"PRODUKT": prod, "ZUSATZ_TITEL": f"Montagevorlage {prod} (Reihenfolge, Teile, Gliederung)", "ZUSATZ": "\n".join(vorlage)}


def ax_lektorat(a, prm, plan_rec):
    texte = prm["TEXTE"]
    ids = freigaben(LEKT_TEXTE[texte])
    if not ids:
        raise BauFehler(f"Lektorat {texte}: noch keine freigegebenen Texte vorhanden")
    a.add_prefix("GL-")
    for i in range(1, 21):
        a.add(f"R{i:02d}-STAMM", strip=("Familie", "Werdegang", "Wohnort", "Wurzeln"), pflicht=False)
    a.add("BW-STAMM")
    a.add("DET-STAMM")
    return {"TEXTE": texte, "MATERIAL": material(ids)}


AUSZUG.update({
    "LAUF": ax_lauf, "MONT-MAPPEN": ax_mont_mappen, "MONT-PRODUKT": ax_mont_produkt, "LEKTORAT": ax_lektorat,
})


AUSZUG.update({
    "ERZ-ANSAGEN": ax_erz_ansagen, "ERZ-EINGRENZ": ax_erz_eingrenz, "ERZ-ANKLAGE": ax_erz_anklage, "ERZ-ENDEN": ax_erz_enden,
    "ERZ-GEST": ax_erz_gest, "DET-MAPPE": ax_det_mappe, "SL": ax_sl, "REGELBLATT": ax_regelblatt,
    "PRUEF-PROFIL": ax_pruef, "PRUEF-SPIEGEL": ax_pruef, "PRUEF-KANON": ax_pruef, "PRUEF-SPOILER": ax_pruef, "PRUEF-BILD": ax_pruef,
    "PRUEF-AUFL": ax_pruef, "PRUEF-ZEIT": ax_pruef, "PRUEF-SKAL": ax_pruef, "PRUEF-FAIRPLAY": ax_pruef, "PRUEF-ABSICHERUNG": ax_pruef,
    "PRUEF-VORLESE": ax_pruef, "PRUEF-LEIT": ax_pruef,
})


def fuelle(text, werte):
    def ersetze(m):
        k = m.group(1)
        if k not in werte:
            raise BauFehler(f"Platzhalter {{{{{k}}}}} ohne Wert")
        return werte[k]
    return re.sub(r"\{\{([A-Z_]+)\}\}", ersetze, text)


def baue(kennung, runde=0, zielordner=PAKETE):
    pl = plan()
    if kennung not in pl:
        raise BauFehler(f"{kennung} steht nicht im PLAN")
    p = pl[kennung]
    vname = p.get("Vorlage")
    vpfad = os.path.join(VORL, f"{vname}.md")
    if not os.path.exists(vpfad):
        raise BauFehler(f"Vorlage {vname} fehlt")
    v = abschnitte(vpfad)
    if vname not in AUSZUG:
        raise BauFehler(f"Für Vorlage {vname} ist noch kein Auszug definiert")
    recs, fehler = kanon.lade()
    loes = p.get("Lösung") == "ja"
    a = Auszug(recs, loes)
    prm = params(p)
    werte = {"ID": kennung, "TYP": p.get("Typ"), "WELLE": p.get("Welle"), "UMFANG": p.get("Umfang"), "VERSION": kanon_version()}
    werte.update(AUSZUG[vname](a, prm, p))
    werte.setdefault("TON", prm.get("TON", ""))
    stil_basis = "\n".join([k8_teil(2), "", k8_teil(3), "", "Zahlen, Uhrzeiten, Aussprache:", k8_teil(5)])
    verbote_basis = open(os.path.join(VORL, "bausteine", "VERBOTE-LEITPLANKEN.md"), encoding="utf-8").read().strip()
    musterliste = [m.strip() for m in v.get("MUSTER", "").split(",") if m.strip()]
    teile = []
    if loes:
        teile.append("[ENTHÄLT LÖSUNG]")
    teile.append(f"{kennung} · {p.get('Typ')} · Welle {p.get('Welle')} · Kanon v{werte['VERSION']} · erwarteter Umfang {p.get('Umfang')} Wörter")
    teile.append("")
    teile.append("Du arbeitest allein an diesem Paket. Außer diesem Text kennst du nichts: keine anderen Pakete, keine früheren Ergebnisse. "
                 "Alles Lösungsrelevante steht im Kanon-Auszug (Abschnitt 3); er ist unveränderlich. Lies das ganze Paket, bevor du schreibst.")
    teile.append("\n## 1. Deine Aufgabe in einem Satz\n" + fuelle(v["AUFGABE"], werte))
    teile.append("\n## 2. Das Spiel in fünf Sätzen\n" + recs["FÜNF-SÄTZE"].get("Text"))
    teile.append("\n## 3. Kanon-Auszug (unveränderlich; nichts davon ändern, nichts Lösungsrelevantes hinzuerfinden)\n" + a.text())
    if werte.get("MATERIAL"):
        teile.append("\n## 3b. Prüfmaterial (zu prüfende Texte, unverändert)\n" + werte["MATERIAL"])
    if werte.get("ZUSATZ"):
        teile.append(f"\n## 3c. {werte['ZUSATZ_TITEL']} (aus dem Kanon erzeugt, unveränderlich)\n" + werte["ZUSATZ"])
    teile.append("\n## 4. Stil und Ton\n" + fuelle(v.get("STIL", ""), werte) + "\n\nAllgemeine Regeln aus dem Stilblatt:\n" + stil_basis)
    teile.append("\n## 5. Verbote\n" + verbote_basis + ("\n" + fuelle(v["VERBOTE"], werte) if v.get("VERBOTE") else ""))
    teile.append("\n## 6. Arbeitsschritte\n" + fuelle(v["SCHRITTE"], werte))
    teile.append("\n## 7. Muster (nur für Format und Ton – nicht abschreiben, keine Sätze daraus übernehmen)\n" +
                 "\n\n".join(muster(m) for m in musterliste))
    teile.append("\n## 8. Ausgabeformular (feste Feldnamen in fester Reihenfolge)\n" + fuelle(v["FORMULAR"], werte))
    teile.append("\n## 9. Selbstprüfung (am Ende deiner Ausgabe ausfüllen)\n" + fuelle(v["SELBSTPRUEFUNG"], werte))
    teile.append("\n## 10. Endmarke\nDie letzte Zeile deiner Ausgabe lautet exakt:\n=== ENDE " + kennung +
                 " · BEREIT ZUR RÜCKGABE ===\nReicht der Platz nicht, hörst du an einer Feldgrenze auf mit:\n=== UNTERBROCHEN BEI [Feld] · WEITER MIT „weiter“ ===")
    text = "\n".join(teile) + "\n"
    if not loes and "[L]" in text:
        raise BauFehler("Lösungsmarke [L] im Paket ohne Lösung")
    os.makedirs(zielordner, exist_ok=True)
    ziel = os.path.join(zielordner, f"{kennung}.r{runde}.md")
    with open(ziel, "w", encoding="utf-8") as fh:
        fh.write(text)
    return ziel, len(text.split())


def main(argv):
    if "--durchspiel" in argv:
        i = argv.index("--durchspiel")
        recs, _ = kanon.lade()
        print(durchspiel(recs, int(argv[i + 1]), argv[i + 2] if len(argv) > i + 2 else "alle Pfade"))
        return 0
    if "--test" in argv:
        pl = plan()
        gesehen, ok = set(), 0
        for k, p in pl.items():
            v = p.get("Vorlage")
            if v in gesehen or v not in AUSZUG:
                continue
            gesehen.add(v)
            try:
                ziel, w = baue(k, 0, os.path.join(PAKETE, "_test"))
                print(f"OK   {v:18s} {k:22s} {w:5d} Wörter")
                ok += 1
            except BauFehler as e:
                print(f"FEHL {v:18s} {k:22s} {e}")
        fehlend = sorted({p.get('Vorlage') for p in pl.values()} - set(AUSZUG))
        print(f"{ok} Vorlagen getestet. Noch ohne Auszug: {', '.join(fehlend)}")
        return 0
    if "--tag" in argv:
        tag = argv[argv.index("--tag") + 1]
        charge = argv[argv.index("--charge") + 1] if "--charge" in argv else "a"
        for k, p in plan().items():
            if p.get("Tag") == tag and p.get("Charge") == charge:
                try:
                    ziel, w = baue(k)
                    print(f"OK   {k:22s} {w:5d} Wörter -> {os.path.relpath(ziel, ROOT)}")
                except BauFehler as e:
                    print(f"FEHL {k:22s} {e}")
        return 0
    runde = int(argv[argv.index("--runde") + 1]) if "--runde" in argv else 0
    ziel, w = baue(argv[1], runde)
    print(f"{ziel} ({w} Wörter)")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))

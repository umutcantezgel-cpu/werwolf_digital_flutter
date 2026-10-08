#!/usr/bin/env python3
"""Internes Werkzeug der Produktion (kein Endprodukt).

Liest die Kanon-Datensätze (siehe 10_kanon/FORMAT.md) und prüft sie mechanisch.

Aufruf:
  python3 90_werkzeug/kanon.py pruefe            # alle Proben
  python3 90_werkzeug/kanon.py pruefe last       # einzelne Probe: syntax last ersatz absicherung zeit d e vollst
  python3 90_werkzeug/kanon.py zeige R07         # alle Datensätze, deren Kennung mit R07 beginnt
  python3 90_werkzeug/kanon.py lasttabelle       # Gespräche je Rolle, Phase und Besetzung
  python3 90_werkzeug/kanon.py absicherungstabelle  # unabhängige Quellen je Schlussfolgerung und Besetzung
  python3 90_werkzeug/kanon.py gesamt            # schreibt 10_kanon/GESAMT-KANON.md (alle Teile in fester Reihenfolge)
"""
import os
import re
import sys
from collections import defaultdict, OrderedDict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
KANON = os.path.join(ROOT, "10_kanon")
REC = re.compile(r"^@(?P<id>[A-Za-zÄÖÜäöü0-9\-_.]+)\s*\[(?P<s>[OGL])\]\s*(?P<rest>.*)$")
ROLE = re.compile(r"\bR(\d\d)\b")


class Rec:
    def __init__(self, rid, sicht, felder, datei, zeile, roh):
        self.id, self.sicht, self.f, self.datei, self.zeile, self.roh = rid, sicht, felder, datei, zeile, roh

    def get(self, key, default=""):
        return self.f.get(key, default)


def lade(pfad=KANON):
    recs, fehler = OrderedDict(), []
    for name in sorted(os.listdir(pfad)):
        if not (name.startswith("K") and name.endswith(".md")):
            continue
        with open(os.path.join(pfad, name), encoding="utf-8") as fh:
            for nr, line in enumerate(fh, 1):
                line = line.rstrip("\n")
                if not line.startswith("@"):
                    continue
                m = REC.match(line)
                if not m:
                    fehler.append(f"SYNTAX {name}:{nr}: Kopf unlesbar: {line[:80]}")
                    continue
                felder = OrderedDict()
                rest = m.group("rest").strip()
                if rest.startswith("|"):
                    rest = rest[1:]
                for teil in [t for t in rest.split(" | ") if t.strip()]:
                    teil = teil.strip().lstrip("|").strip()
                    if ":" not in teil:
                        fehler.append(f"SYNTAX {name}:{nr}: Feld ohne Doppelpunkt in {m.group('id')}: {teil[:60]}")
                        continue
                    k, v = teil.split(":", 1)
                    felder[k.strip()] = v.strip()
                rid = m.group("id")
                if rid in recs:
                    fehler.append(f"DOPPELT {rid}: {recs[rid].datei}:{recs[rid].zeile} und {name}:{nr}")
                recs[rid] = Rec(rid, m.group("s"), felder, name, nr, line)
    return recs, fehler


def rnum(s):
    m = ROLE.search(s or "")
    return int(m.group(1)) if m else None


def gespraeche(recs, phase=None):
    out = []
    for r in recs.values():
        m = re.match(r"^G(\d)-(\d+)$", r.id)
        if m and (phase is None or int(m.group(1)) == phase):
            out.append((int(m.group(1)), r))
    return out


def tatsaechliche(recs, phase, n):
    """Liefert die bei Besetzung n tatsächlich stattfindenden Gespräche als (von, an, rec, art)."""
    res = []
    for _, g in gespraeche(recs, phase):
        von, ziel, ers = rnum(g.get("Von")), rnum(g.get("Ziel")), rnum(g.get("Ersatz"))
        if von is None or von > n:
            continue
        if ziel is not None and ziel <= n:
            res.append((von, ziel, g, "regulär"))
        elif ers is not None and ers <= n:
            res.append((von, ers, g, "ersatz"))
        else:
            res.append((von, None, g, "FEHLT"))
    return res


def probe_syntax(recs, fehler):
    ids = set(recs)
    for r in recs.values():
        for k, v in r.f.items():
            for ref in re.findall(r"\b(H-\d+|HW-\d+|G\d-\d+|D\d-\d|E\d-\d\d|S-\d+|BS-\d+|K-\d+)\b", v):
                if ref not in ids:
                    fehler.append(f"VERWEIS {r.id}.{k}: unbekannte Kennung {ref}")
    return fehler


def probe_ersatz(recs):
    f = []
    for _, g in gespraeche(recs):
        von, ziel, ers = rnum(g.get("Von")), rnum(g.get("Ziel")), rnum(g.get("Ersatz"))
        if von is None or ziel is None:
            f.append(f"ERSATZ {g.id}: Von/Ziel unlesbar")
            continue
        if von == ziel:
            f.append(f"ERSATZ {g.id}: Gespräch mit sich selbst")
        braucht = ziel >= 5 and ziel > von
        if braucht and ers is None:
            f.append(f"ERSATZ {g.id}: Ziel R{ziel:02d} > R{von:02d} braucht Ersatzziel")
        if braucht and ers is not None and not (ers <= 4 or ers < von):
            f.append(f"ERSATZ {g.id}: Ersatz R{ers:02d} ist nicht sicher anwesend (muss 1–4 oder < R{von:02d} sein)")
        if braucht and ers == von:
            f.append(f"ERSATZ {g.id}: Ersatz ist der Auftraggeber selbst")
        if not braucht and ers is not None:
            f.append(f"ERSATZ {g.id}: Ersatz angegeben, obwohl Ziel sicher anwesend ist")
        if braucht:
            for feld in ("Ersatz-Bedingung", "Ersatz-Frage", "Ersatz-Antwort", "Ersatz-Antwortart"):
                if not g.get(feld) or g.get(feld) in ("–", "-"):
                    f.append(f"SPIEGEL {g.id}: {feld} fehlt")
            if not g.get("Ersatz gibt heraus"):
                f.append(f"SPIEGEL {g.id}: Feld 'Ersatz gibt heraus' fehlt")
        mn = g.get("Min")
        if mn and mn.isdigit() and int(mn) != max(von, ziel, 4):
            f.append(f"MIN {g.id}: Min {mn} statt {max(von, ziel, 4)}")
        for feld in ("Bedingung", "Frage", "Antwort", "Antwortart", "Gibt heraus"):
            if not g.get(feld):
                f.append(f"SPIEGEL {g.id}: Feld '{feld}' fehlt")
    return f


def probe_last(recs, grenze=8, ausgabe=False):
    f = []
    for p in (1, 2, 3):
        aus = defaultdict(int)
        for _, g in gespraeche(recs, p):
            v = rnum(g.get("Von"))
            if v:
                aus[v] += 1
        for r in range(1, 21):
            if aus[r] != 3:
                f.append(f"LAST P{p}: R{r:02d} hat {aus[r]} ausgehende Aufträge statt 3")
        for n in range(4, 21):
            paare = set()
            for von, an, g, art in tatsaechliche(recs, p, n):
                if an is None:
                    f.append(f"LAST P{p} N={n}: {g.id} hat kein anwesendes Ziel")
                    continue
                paare.add(tuple(sorted((von, an))))
            last = defaultdict(int)
            for a, b in paare:
                last[a] += 1
                last[b] += 1
            for r in range(1, n + 1):
                if last[r] > grenze:
                    f.append(f"LAST P{p} N={n}: R{r:02d} hat {last[r]} Gespräche (> {grenze})")
                if last[r] == 0:
                    f.append(f"LAST P{p} N={n}: R{r:02d} hat kein Gespräch")
            if ausgabe:
                print(f"P{p} N={n:2d}: Gespräche {len(paare):2d} | max {max(last.values())} | " +
                      " ".join(f"R{r:02d}:{last[r]}" for r in range(1, n + 1)))
    return f


def verfuegbar(recs, h, n):
    """Ist Hinweis h bei Besetzung n erreichbar? (über Gesprächsquelle oder Min)"""
    q = h.get("Quelle")
    m = re.search(r"\b(G\d-\d+)\b", q)
    if m and m.group(1) in recs:
        g = recs[m.group(1)]
        von, ziel = rnum(g.get("Von")), rnum(g.get("Ziel"))
        if von is None or von > n:
            return False
        if ziel is not None and ziel <= n:
            return h.id in g.get("Gibt heraus")
        return h.id in g.get("Ersatz gibt heraus")
    mn = h.get("Min", "4")
    return (int(mn) if mn.isdigit() else 4) <= n


def probe_absicherung(recs, ausgabe=False):
    f = []
    schluesse = [r for r in recs.values() if re.match(r"^S-\d+$", r.id)]
    if not schluesse:
        return ["ABSICHERUNG: keine Schlussfolgerungen S-… gefunden"]
    for s in schluesse:
        if s.get("Notwendig").lower() != "ja":
            continue
        ids = set(re.findall(r"H-\d+", s.get("Hinweise")))
        for hw in recs.values():
            if hw.id.startswith("HW-") and re.search(r"\b" + re.escape(s.id) + r"\b", hw.get("Stützt")):
                ids.add("H-" + hw.id[3:])
        hs = [recs[x] for x in sorted(ids) if x in recs]
        unblock = [h for h in hs if ("HW-" + h.id[2:]) in recs and recs["HW-" + h.id[2:]].get("Blockierbar durch").lower().startswith("nein")]
        if not unblock:
            f.append(f"ABSICHERUNG {s.id}: kein unblockierbarer Hinweis")
        zeile = []
        for n in range(4, 21):
            da = [h for h in hs if verfuegbar(recs, h, n)]
            quellen = {re.sub(r"\s+", " ", h.get("Quelle")) for h in da}
            soll = 3 if n == 20 else 2
            if len(quellen) < soll:
                f.append(f"ABSICHERUNG {s.id} N={n}: {len(quellen)} unabhängige Quellen (Soll {soll})")
            zeile.append(f"{n}:{len(quellen)}")
        if ausgabe:
            print(f"{s.id}: " + " ".join(zeile))
    for h in recs.values():
        if re.match(r"^H-\d+$", h.id):
            mn = h.get("Min")
            echt = next((n for n in range(4, 21) if verfuegbar(recs, h, n)), None)
            if mn.isdigit() and echt is not None and int(mn) != echt and "G" in h.get("Quelle"):
                f.append(f"MIN {h.id}: Min {mn}, erreichbar aber erst ab {echt}" if echt > int(mn) else f"MIN {h.id}: Min {mn}, erreichbar schon ab {echt}")
            if echt is None:
                f.append(f"MIN {h.id}: in keiner Besetzung erreichbar")
            if ("HW-" + h.id[2:]) not in recs:
                f.append(f"HINWEIS {h.id}: Wahrheitsdatensatz HW-{h.id[2:]} fehlt")
    return f


def probe_zeit(recs):
    f = []
    belegt = defaultdict(dict)
    for z in recs.values():
        if not z.id.startswith("Z-"):
            continue
        t = z.get("Zeit")
        if not re.match(r"^\d\d:\d\d(:\d\d)?$", t):
            continue
        if len(t) == 5:
            t += ":00"
        for wer in re.findall(r"\b(R\d\d|DET|BW)\b", z.get("Wer")):
            ort = z.get("Ort")
            if t in belegt[wer] and belegt[wer][t][0] != ort:
                f.append(f"ZEIT {wer} {t}: {belegt[wer][t][0]} ({belegt[wer][t][1]}) und {ort} ({z.id})")
            belegt[wer][t] = (ort, z.id)
    return f


def probe_d(recs):
    f = []
    for p in (1, 2, 3):
        for i in (1, 2, 3):
            d, dw = recs.get(f"D{p}-{i}"), recs.get(f"DW{p}-{i}")
            if not d or not dw:
                f.append(f"D{p}-{i}: Datensatz D oder DW fehlt")
                continue
            for h in re.findall(r"H-\d+", d.get("Begründbar durch")):
                hr = recs.get(h)
                if not hr:
                    continue
                ph = hr.get("Phase")
                if ph.isdigit() and int(ph) > p:
                    f.append(f"D{p}-{i}: {h} erst ab Phase {ph}")
                if not verfuegbar(recs, hr, 4):
                    f.append(f"D{p}-{i}: {h} bei N=4 nicht erreichbar")
            werte = {dw.get("Echte Spur"), dw.get("Falsche Fährte"), dw.get("Ablenkung")}
            if werte != {"A", "B", "C"}:
                f.append(f"DW{p}-{i}: Optionen nicht genau A/B/C verteilt: {werte}")
            for o in ("A", "B", "C"):
                if not dw.get(f"Ergebnis {o}"):
                    f.append(f"DW{p}-{i}: Ergebnis {o} fehlt")
            for o in ("Option A", "Option B", "Option C"):
                txt = d.get(o)
                for r in re.findall(r"\bR(\d\d)\b", txt):
                    if int(r) > 4:
                        f.append(f"D{p}-{i}: {o} nennt Erweiterungsrolle R{r}")
    return f


def probe_e(recs):
    f = []
    for p in (1, 2, 3):
        for r in range(1, 21):
            e = recs.get(f"E{p}-{r:02d}")
            if not e:
                f.append(f"E{p}-{r:02d} fehlt")
                continue
            opts = [k for k in e.f if k.startswith("Option ")]
            if not 2 <= len(opts) <= 3:
                f.append(f"E{p}-{r:02d}: {len(opts)} Optionen (2–3 verlangt)")
            for k in opts:
                if "→ Folge:" not in e.get(k):
                    f.append(f"E{p}-{r:02d}.{k}: Folge fehlt")
    return f


def probe_vollst(recs):
    f = []
    teile = ("STAMM", "ÖFFENTLICH", "GEHEIM", "WISSEN", "VERBINDUNGEN", "PLOT", "LÜGE")
    for r in range(1, 21):
        for t in teile:
            if f"R{r:02d}-{t}" not in recs:
                f.append(f"K2: R{r:02d}-{t} fehlt")
    ges = defaultdict(lambda: [0, 0])
    for r in range(1, 21):
        st = recs.get(f"R{r:02d}-STAMM")
        if st:
            g = st.get("Geschlecht")
            ges[(r - 1) // 4][0 if g.startswith("w") else 1] += 1
    for b, (w, m) in sorted(ges.items()):
        if (w, m) != (2, 2):
            f.append(f"K2: Block {b * 4 + 1}–{b * 4 + 4} hat {w} w / {m} m (Soll 2/2)")
    for i in range(1, 8):
        if f"PF-{i}" not in recs:
            f.append(f"K1: Pflichtfrage PF-{i} fehlt")
    return f


PROBEN = OrderedDict([
    ("syntax", lambda r, fe: probe_syntax(r, fe)),
    ("vollst", lambda r, fe: probe_vollst(r)),
    ("ersatz", lambda r, fe: probe_ersatz(r)),
    ("last", lambda r, fe: probe_last(r)),
    ("absicherung", lambda r, fe: probe_absicherung(r)),
    ("zeit", lambda r, fe: probe_zeit(r)),
    ("d", lambda r, fe: probe_d(r)),
    ("e", lambda r, fe: probe_e(r)),
])


GESAMT_REIHE = [
    ("K1", ["K1-GRUNDWAHRHEIT.md"]),
    ("K2", ["K2-ROLLEN-KERN.md", "K2-ROLLEN-05-12.md", "K2-ROLLEN-13-20.md"]),
    ("K3", ["K3-HINWEISE.md", "K3-HINWEISE-KERN.md", "K3-HINWEISE-P1.md", "K3-HINWEISE-P2.md", "K3-HINWEISE-P3.md"]),
    ("K4", ["K4-GESPRAECHE-KERN.md", "K4-GESPRAECHE-P1.md", "K4-GESPRAECHE-P2.md", "K4-GESPRAECHE-P3.md"]),
    ("K5", ["K5-MECHANIK.md", "K5-ENTSCHEIDUNGEN-DETEKTIV.md", "K5-ENTSCHEIDUNGEN-P1.md", "K5-ENTSCHEIDUNGEN-P2.md", "K5-ENTSCHEIDUNGEN-P3.md"]),
    ("K6", ["K6-AUFLOESUNG.md"]),
    ("K7", ["K7-LUEGENREGEL.md"]),
    ("K8", ["K8-STILBLATT.md"]),
    ("K9", ["K9-LOOKBIBEL.md"]),
    ("Anhang", ["FORMAT.md", "SELBSTPRUEFUNG.md", "PROTOKOLL.md"]),
]


def schreibe_gesamt(recs, pfad=KANON):
    """Fügt alle Kanon-Dateien byte-gleich zu einem Dokument zusammen (Name beginnt nicht mit K, wird also nicht mitgeladen)."""
    version = "0.9"
    vp = os.path.join(pfad, "VERSION.md")
    if os.path.exists(vp):
        m = re.search(r"Kanon v([\d.]+)", open(vp, encoding="utf-8").read())
        version = m.group(1) if m else version
    teile = ["[ENTHÄLT LÖSUNG]", f"# KANON „Spuk im Gewölbe“ · Gesamtdokument · Kanon v{version}",
             f"Erzeugt aus den Einzeldateien in 10_kanon/ (nicht von Hand ändern) · {len(recs)} Datensätze.", "", "## Inhalt"]
    vorhanden = []
    for teil, dateien in GESAMT_REIHE:
        for d in dateien:
            if os.path.exists(os.path.join(pfad, d)):
                vorhanden.append((teil, d))
                teile.append(f"- {teil} · {d}")
    for teil, d in vorhanden:
        inhalt = open(os.path.join(pfad, d), encoding="utf-8").read().strip()
        inhalt = "\n".join(z for z in inhalt.split("\n") if z.strip() != "[ENTHÄLT LÖSUNG]")
        teile += ["", "", f"<!-- ===== {d} ===== -->", inhalt]
    ziel = os.path.join(pfad, "GESAMT-KANON.md")
    with open(ziel, "w", encoding="utf-8") as fh:
        fh.write("\n".join(teile) + "\n")
    return ziel


def main(argv):
    recs, fehler = lade()
    cmd = argv[1] if len(argv) > 1 else "pruefe"
    if cmd == "pruefe":
        welche = argv[2:] or list(PROBEN)
        gesamt = 0
        for name in welche:
            res = PROBEN[name](recs, list(fehler) if name == "syntax" else [])
            gesamt += len(res)
            print(f"== {name}: {len(res)} Befunde")
            for x in res[:400]:
                print("  " + x)
        print(f"== SUMME: {gesamt} Befunde · {len(recs)} Datensätze")
        return 1 if gesamt else 0
    if cmd == "zeige":
        for r in recs.values():
            if r.id.startswith(argv[2]):
                print(r.roh)
        return 0
    if cmd == "lasttabelle":
        probe_last(recs, ausgabe=True)
        return 0
    if cmd == "absicherungstabelle":
        probe_absicherung(recs, ausgabe=True)
        return 0
    if cmd == "gesamt":
        ziel = schreibe_gesamt(recs)
        print(f"{ziel} ({len(recs)} Datensätze)")
        return 0
    print(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv))

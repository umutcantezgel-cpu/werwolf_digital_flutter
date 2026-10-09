#!/usr/bin/env python3
"""Prüfmauer-Probe (Ringe 1, 2, 3, 5, 6) für Varianten im JSONL-Schema der Fabrik.
Vorlage für tool/bollwerk/varianten.dart und fuellstoff.dart im Nachtlauf.

Aufruf: python3 -I fabrik_ringe.py <kanon-ordner> <textregeln.json> <varianten.jsonl>… [--json aus.json]
Ausgabe je Variante: Ring 1 Form, Ring 2 Regeln, Ring 3 Kanon, Ring 5 Erreichbarkeit (statisch), Ring 6 Neuheit.
"""
import json, re, sys, itertools, hashlib

SPERR = ["merle", "lüddecke", "rojda", "adnan", "kunibert", "burgwart", "speisekammer", "wehrgang", "torhaus",
         "hofebene", "turm-fuß", "eisentür", "bienenwachs", "benommen", "apfel-zimt-punsch", "ayran"]
GEWALT = ["blut", "blutig", "blutet", "wunde", "verletzt", "verletzung", "schmerz"]
BILD = ["flasche", "flaschen", "stielglas", "stielgläser", "fass", "fässer", "notlaterne", "kerzenständer", "anzünden",
        "flamme", "streichholz", "feuerzeug"]
HINAUS = ["hinausgehen", "nach draußen", "ins freie", "schlosshof", "parkplatz", "außentor öffnen"]
ARTEN = {"abstecher", "folgeentscheidung", "text", "gag", "aktion", "element"}
TATZEIT = re.compile(r"\b(23:5\d|00:0\d|00:1[0-5])\b")


def woerter(s):
    return re.findall(r"[A-Za-zÄÖÜäöüß-]+", s or "")


def saetze(s):
    return [x for x in re.split(r"(?<=[.!?…])\s+", (s or "").strip()) if x]


def texte(v):
    out = [v.get("titel"), v.get("text")]
    st = v.get("stufen") or {}
    out += [st.get(k) for k in ("erfolg", "teil", "pech")]
    a = v.get("aktion") or {}
    out += [a.get("pose"), a.get("klang")]
    return [t for t in out if isinstance(t, str)]


def lade_kanon(k):
    r = json.load(open(f"{k}/raeume.json"))
    f = json.load(open(f"{k}/figuren.json"))
    g = json.load(open(f"{k}/gegenstaende.json"))
    s = json.load(open(f"{k}/setting.json"))
    ids = {x["id"] for x in r["rooms"]} | {x["id"] for x in r["orte"]} | {x["id"] for x in f["figuren"]} | {"schneider", "detektiv"}
    ids |= {x["id"] for x in g["gegenstaende"]} | {x["id"] for x in s.get("lacher", [])}
    ids |= {sp["id"] for x in g["gegenstaende"] for sp in (x.get("spuren") or []) if isinstance(sp, dict) and "id" in sp}
    try:
        b = json.load(open(f"{k}/beobachtungen.json")); ids |= {x["id"] for x in b["beobachtungen"]}
    except (OSError, KeyError):
        pass
    namen = {x["name"].lower() for x in f["figuren"]}
    raeume = {x["id"] for x in r["rooms"]}
    orte = {x["id"]: x["raum"] for x in r["orte"]}
    return ids, namen, raeume, orte


WEISS = {"b_baran_rufe", "b_hana_wachs", "b_serkan_tor", "b_pawel_schneider", "b_schneider_erinnerung", "b_tim_gesicht",
         "spur_wachs_boden", "spur_steckdose_verschmort", "spur_laterne_unberuehrt", "spur_torte",
         "lacher_ruestung", "lacher_verlaufen", "lacher_kamin"}


def ring1(v):
    f = []
    for k in ("kennung", "slot", "art", "raum", "titel", "text", "wurf"):
        if k not in v: f.append(f"fehlt:{k}")
    if v.get("art") not in ARTEN: f.append("art")
    n = len(woerter(v.get("text")))
    if not 8 <= n <= 40: f.append(f"textlaenge:{n}")
    if len(woerter(v.get("titel"))) > 6: f.append("titel>6")
    if v.get("wurf") is True and not all((v.get("stufen") or {}).get(k) for k in ("erfolg", "teil", "pech")): f.append("stufen")
    a = v.get("aktion")
    if v.get("art") in ("abstecher", "folgeentscheidung", "gag", "aktion") and not (a and a.get("art") and a.get("pose")): f.append("aktion")
    if a and not (4 <= (a.get("dauer_s") or 0) <= 12): f.append("dauer_s")
    if any(re.search(r"\b(usw|analog|weitere folgen|TODO|xxx)\b", t, re.I) for t in texte(v)): f.append("platzhalter")
    return f


def ring2(v, regeln):
    f = []
    alle = " ".join(texte(v)).lower()
    w = set(x.lower() for x in woerter(alle))
    for gruppe, liste in regeln.get("verboten", {}).items():
        for x in liste:
            if x.lower() in w: f.append(f"{gruppe}:{x}")
    for x in regeln.get("fachwoerter", {}):
        if x.lower() in w: f.append(f"fachwort:{x}")
    for x in SPERR + GEWALT + BILD:
        if x in w or (("-" in x or " " in x) and x in alle): f.append(f"sperre:{x}")
    for x in HINAUS:
        if x in alle: f.append(f"hinaus:{x}")
    if re.search(r"\b(Sie|Ihnen|Ihr(e|en|er)?)\b(?![^.]*\?)", " ".join(texte(v))) and re.search(r"\bSie\b", " ".join(texte(v))):
        f.append("siezen")
    if "pfeife" in alle and "seifenblase" not in alle: f.append("pfeife_ohne_seifenblasen")
    if "schneider" in alle and re.search(r"\b(steht auf|stirbt|tot|fällt|läuft)\b", alle): f.append("schneider")
    ls = [len(woerter(s)) for s in itertools.chain.from_iterable(saetze(t) for t in texte(v))]
    if ls and max(ls) > 25: f.append(f"satz>25:{max(ls)}")
    if ls and sum(ls) / len(ls) > 14: f.append(f"satzmittel:{sum(ls) / len(ls):.1f}")
    return f


def ring3(v, kanon):
    ids, namen, raeume, orte = kanon
    f = []
    if v.get("raum") not in raeume: f.append(f"raum:{v.get('raum')}")
    if v.get("ort") and v["ort"] not in orte: f.append(f"ort:{v['ort']}")
    if v.get("ort") in orte and orte[v["ort"]] != v.get("raum"): f.append("ort_raum")
    for k in v.get("kanonbezug") or []:
        if k not in ids: f.append(f"kennung:{k}")
    for o in (v.get("aktion") or {}).get("weg") or []:
        if o not in orte and o not in raeume: f.append(f"weg:{o}")
    z = v.get("zusatz")
    if z and z not in WEISS: f.append(f"zusatz_nicht_weissliste:{z}")
    alle = " ".join(texte(v))
    if TATZEIT.search(alle): f.append("tatzeit")
    if re.search(r"\b(täter|schuldig|mörder|überführt|alibi)\b", alle, re.I): f.append("loesungsnah")
    # neue Spuren an Kanon-Orten sind verboten (ein Stück darf nie Faktquelle oder Kettenglied werden)
    if re.search(r"\b(kratzer|kratzspur|abdruck|fußspur|fussspur|fleck|faser|fasern|schleifspur|fingerabdr\w*|spuren?)\b", alle, re.I) and not v.get("zusatz"):
        f.append("neue_spur")
    return f


def ring5(v):
    # statisch: ein Abstecher/Gag/Folge ist erreichbar, wenn Raum und Runde gesetzt sind (Runde null = jede Runde)
    if v.get("art") in ("abstecher", "folgeentscheidung", "gag") and not v.get("raum"): return ["unerreichbar"]
    return []


def trigramme(s):
    w = [x.lower() for x in woerter(s)]
    return {tuple(w[i:i + 3]) for i in range(len(w) - 2)}


def main():
    a = sys.argv[1:]
    aus = a[a.index("--json") + 1] if "--json" in a else None
    if aus: a = a[:a.index("--json")]
    kanon = lade_kanon(a[0]); regeln = json.load(open(a[1]))
    vs = []
    for p in a[2:]:
        for i, z in enumerate(open(p, encoding="utf-8")):
            z = z.strip()
            if not z: continue
            try: vs.append(json.loads(z))
            except json.JSONDecodeError as e: vs.append({"kennung": f"{p}:{i + 1}", "_kaputt": str(e)})
    erg = []
    tri = []
    for v in vs:
        r = {"kennung": v.get("kennung"), "slot": v.get("slot"), "art": v.get("art")}
        if "_kaputt" in v:
            r.update(ring1=["json"], ring2=[], ring3=[], ring5=[], ring6=[]); erg.append(r); tri.append(set()); continue
        r["ring1"] = ring1(v); r["ring2"] = ring2(v, regeln); r["ring3"] = ring3(v, kanon); r["ring5"] = ring5(v)
        t = trigramme(" ".join(texte(v))); dup = []
        for j, u in enumerate(tri):
            if t and u and len(t & u) / len(t | u) >= 0.5: dup.append(erg[j]["kennung"])
        sig = (v.get("art"), v.get("raum"), v.get("ort"), (v.get("aktion") or {}).get("art"), v.get("zusatz"), v.get("wurf"))
        r["sig"] = hashlib.sha1(json.dumps(sig).encode()).hexdigest()[:8]
        r["ring6"] = [f"dublette:{d}" for d in dup]
        tri.append(t); erg.append(r)
    # Ring 6 Teil 2: Tupel eindeutig (F3/F4) – gleiche Signatur im selben Slot zählt nur einmal
    gesehen = {}
    for r in erg:
        k = (r["slot"], r.get("sig"))
        if k in gesehen and r["art"] != "text": r["ring6"].append(f"tupel_wie:{gesehen[k]}")
        else: gesehen[k] = r["kennung"]
    stat = {}
    for ring in ("ring1", "ring2", "ring3", "ring5", "ring6"):
        stat[ring] = sum(1 for r in erg if not r[ring])
    durch = [r for r in erg if not any(r[x] for x in ("ring1", "ring2", "ring3", "ring5", "ring6"))]
    print(f"VARIANTEN {len(erg)} · " + " · ".join(f"{k} grün {v}" for k, v in stat.items()) + f" · alle Ringe 1–6 grün {len(durch)}")
    if aus: json.dump({"stat": stat, "durch": [r["kennung"] for r in durch], "einzeln": erg}, open(aus, "w"), ensure_ascii=False, indent=1)


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Würfel-Simulator des Meta-Laufs BOLLWERK (Probe, kein Spielcode).

Modelliert die Zugschicht „Würfel stark“ über dem Kanon 1.0 (9 Pflichtzüge in 3 Runden),
mit Abstechern, 2W6 + Gesamtmodifikator (0..+2), Pech-Garantie, Reserve-Regel,
Budget-Ungleichung, Rundenschranke und Kettensperre. Die Kanon-Wertung hängt nur an den
gewählten Optionen; der Würfel sieht sie nie (WÜ-4 per Bau, hier zusätzlich geprüft).

Aufruf: python3 -I wuerfel_sim.py <kanon-ordner> [--seeds N] [--json aus.json]
Seed-Satz (eingefroren): Partie-Seed = sha256("bollwerk-meta|<form>|<n>|<pfad>|<i>")[:8].
"""
import hashlib, itertools, json, math, random, statistics, sys

# ---------- Parameter (Band in Klammern; Startwerte aus Anhang C, in M2 gewählt) ----------
P = dict(
    t_erfolg=9, t_teil=7,          # 2W6+mod: >= t_erfolg Erfolg, >= t_teil Teilerfolg, sonst Pech
    mod_max=2,                     # Gesamtmodifikator 0..+2 (bindend)
    p_helfer=0.30,                 # Anteil Würfe mit Werkzeug-Bonus (+1); kein Helfer-Fachgebiet (Entwurf D, C3)
    p_gruendlich=0.20,             # Anteil Züge „gründlich“ (+2, +3 min) beim neutralen Spieler
    marken_max=3,                  # Seifenblasen-Marken je Partie (+1, höchstens 1 je Wurf)
    c_pflicht=6, c_zweit=3, c_dritt=3, c_umweg=3, c_gruendlich=2, erfolg_gewinn=7, abstecher_pech_zeit=3,
    c_abstecher=7,
    rundenzeit=45,
    abstecher_je_runde=8,          # Angebot an Abstechern je Runde (Pool wächst mit dem Umfang)
    anteil_abstecher_mit_wurf=0.2, # Abstecher ohne Wurf: Gänge, Gags, Tee bringen
)
RUNDEN = {1: ["e1_1", "e1_2", "e1_3"], 2: ["e2_1", "e2_2", "e2_3"], 3: ["e3_1", "e3_2", "e3_3"]}
KETTE = {"e2_1": ["e1_1", "e1_2", "e1_3"], "e2_2": ["e1_2"], "e2_3": ["e1_3"],
         "e3_1": ["e1_1", "e1_2", "e1_3", "e2_1", "e2_2", "e2_3"], "e3_2": ["e2_1", "e2_2", "e2_3"],
         "e3_3": ["e1_1", "e2_1"]}
PFADE = ["ahmet", "fatma", "olli", "can"]


def lade(kanon):
    ent = json.load(open(f"{kanon}/entscheidungen.json"))["entscheidungen"]
    fig = json.load(open(f"{kanon}/figuren.json"))["figuren"]
    minp = {f["id"]: f["minPlayers"] for f in fig}
    e = {}
    for d in ent:
        ziele = [list(o["ziel"].values())[0] for o in d["optionen"]]
        glieder = {k for b in d["begruendung"].values() for k in b.get("kette", []) if k.split(":")[0] in ("beobachtung", "luege")}
        fakten = {o["id"]: set(o.get("fakten") or []) for o in d["optionen"]}
        # Suche (mit Wurf), sobald eine Option einen Gegenstand, Raum oder Ort zum Ziel hat; Befragen würfelt nie (Entwurf D, C3)
        suche = any(k in ("gegenstand", "raum", "ort") for o in d["optionen"] for k in o["ziel"])
        ketten = {pf: [k[5:] for k in b.get("kette", []) if k.startswith("fakt:")] for pf, b in d["begruendung"].items()}
        e[d["id"]] = dict(art=d["art"], opts=[o["id"] for o in d["optionen"]], ziele=ziele, richtig=d["richtig"], gespraech=glieder, suche=suche,
                          fakten=fakten, ketten=ketten)
    return e, minp


def seed(*teile):
    return int(hashlib.sha256("|".join(map(str, teile)).encode()).hexdigest()[:8], 16)


class Strom:
    """Würfelstrom: 'zufall' (Seed), 'pech' (immer 2), 'erfolg' (immer 12), 'neutral' (immer 7)."""
    def __init__(self, art, s=0):
        self.art, self.r = art, random.Random(s)
    def w2(self):
        if self.art == "pech": return 2
        if self.art == "erfolg": return 12
        if self.art == "neutral": return 7
        return self.r.randint(1, 6) + self.r.randint(1, 6)


def stufe(summe, p):
    return "E" if summe >= p["t_erfolg"] else ("T" if summe >= p["t_teil"] else "P")


def spiele(E, minp, pfad, n, form, wahl, strom, strategie, p=P, rs=None):
    """Eine Partie. wahl: dict eid->option. strategie: 'neutral'|'gier'|'geiz'.
    Rückgabe: Protokoll-Kennzahlen."""
    rs = rs or random.Random(0)
    besetzt = lambda r: form != "solo" and minp.get(r, 99) <= n
    marken = 0
    log = dict(zuege=0, wuerfe=0, erste_pech=0, erste_wuerfe=0, pech_szenen=0, erfolge_zusatz=0,
               abstecher=0, max_pech_folge=0, sackgasse=0, szenen=[], wurfsummen=[], geraet_s=0.0,
               aufgedeckt=set(), kette_verletzt=0, budget_ueber=0)
    for runde in (1, 2, 3):
        rest = p["rundenzeit"]
        offen = list(RUNDEN[runde])
        worst = lambda: len(offen) * (p["c_pflicht"] + p["c_gruendlich"] + 2 * p["c_umweg"])
        if form == "solo":
            for g in sorted({k for eid in RUNDEN[runde] for k in E[eid]["gespraech"]}):
                log["geraet_s"] += 25; log["szenen"].append(f"g:{g}")  # Gesprächsphase, kein Zug (wie Tischgespräche)
        angebot = [f"a{runde}_{i}" for i in range(p["abstecher_je_runde"])]
        rs.shuffle(angebot)
        if runde == 1:  # Auftakt-Suche (nichtwertend, 0 Nachtminuten): sichert ≥ 1 Wurf in Runde 1
            log["zuege"] += 1; log["wuerfe"] += 1; log["erste_wuerfe"] += 1; log["geraet_s"] += 20
            st0 = stufe(strom.w2(), p)
            log.setdefault("wurf_runde", set()).add(1)
            if st0 == "P": log["erste_pech"] += 1; log["pech_szenen"] += 1; marken = min(p["marken_max"], marken + 1)
            if st0 == "E": log["erfolge_zusatz"] += 1
            log["szenen"].append(f"auftakt:{st0}")
        def wurf(gruendlich, ziel_besetzt, marke_ok):
            nonlocal marken
            mod = 0
            if rs.random() < p["p_helfer"]: mod += 1   # Werkzeug (Tee, Tims Stirnlampe), unabhängig von Besetzung und Option
            if gruendlich: mod += 2
            if marke_ok and marken < p["marken_max"] and rs.random() < 0.3: marken += 1; mod += 1
            mod = min(mod, p["mod_max"])
            s = strom.w2()
            log["wurfsummen"].append(s); log.setdefault("wurf_runde", set()).add(runde)
            return stufe(s + mod, p)
        while offen:
            # Abstecher, solange die Reserve-Regel es erlaubt (Gier: alle; neutral: ~halbe; Geiz: keine)
            lust = {"gier": 1.0, "neutral": 1.0, "geiz": 0.0}[strategie]
            while angebot and rest - p["c_abstecher"] - p["abstecher_pech_zeit"] >= worst() and rs.random() < lust:
                a = angebot.pop()
                rest -= p["c_abstecher"]; log["zuege"] += 1; log["abstecher"] += 1; log["geraet_s"] += 30
                if rs.random() < p["anteil_abstecher_mit_wurf"]:
                    log["wuerfe"] += 1; log["erste_wuerfe"] += 1; log["geraet_s"] += 6
                    st = wurf(strategie == "gier", False, True)
                    if st == "P": log["erste_pech"] += 1; log["pech_szenen"] += 1; rest -= p["abstecher_pech_zeit"]
                    if st == "E": log["erfolge_zusatz"] += 1; rest += p["erfolg_gewinn"]; angebot.append(a + "f")
                    log["szenen"].append(f"{a}:{st}")
                else:
                    log["szenen"].append(f"{a}:-")
            eid = offen.pop(0)
            log.setdefault("stand", {})[eid] = frozenset(log.setdefault("fakten", set()))
            # Kettensperre: alle Vorgänger aufgedeckt
            if any(v not in log["aufgedeckt"] for v in KETTE.get(eid, [])): log["kette_verletzt"] += 1
            d = E[eid]; opt = wahl[eid]; ziel = d["ziele"][d["opts"].index(opt)]
            gruendlich = strategie == "gier" or rs.random() < p["p_gruendlich"]
            kosten = p["c_pflicht"] + (p["c_gruendlich"] if gruendlich else 0)
            # Gier zahlt „gründlich“ aus der Reserve nur, wenn sie reicht
            rest -= kosten; log["zuege"] += 1; log["geraet_s"] += 30
            ohne_wurf = not d["suche"]
            if ohne_wurf and besetzt(ziel): log["befragung_besetzt"] = log.get("befragung_besetzt", 0) + 1
            if ohne_wurf:
                log["aufgedeckt"].add(eid); log["fakten"] |= d["fakten"][opt]; log["szenen"].append(f"{opt}:B"); continue
            pech_folge = 0; anlauf = 1
            while True:
                log["wuerfe"] += 1; log["geraet_s"] += 6
                if anlauf == 1: log["erste_wuerfe"] += 1
                st = wurf(gruendlich, False, True)
                if anlauf >= 3 or pech_folge >= 2:
                    st = "T" if st == "P" else st          # Pech-Garantie
                if anlauf == 1 and st == "P": log["erste_pech"] += 1
                log["szenen"].append(f"{opt}:{anlauf}{st}")
                if st == "P":
                    log["pech_szenen"] += 1; pech_folge += 1
                    log["max_pech_folge"] = max(log["max_pech_folge"], pech_folge)
                    anlauf += 1
                    zusatz = p["c_zweit"] if anlauf == 2 else p["c_dritt"]
                    if strategie == "gier": zusatz = p["c_umweg"]    # Gier nimmt den Umweg (teurer)
                    if rest - zusatz < 0:                  # Rundenschranke: offener Anlauf = Teilerfolg
                        log["aufgedeckt"].add(eid); log["fakten"] |= d["fakten"][opt]; break
                    rest -= zusatz; log["geraet_s"] += 20
                    continue
                if st == "E": log["erfolge_zusatz"] += 1; rest += p["erfolg_gewinn"]
                log["aufgedeckt"].add(eid); log["fakten"] |= d["fakten"][opt]; break
        if rest < 0: log["budget_ueber"] += 1
    # Wertung: nur aus der Wahl (WÜ-4)
    punkte = sum(1 for eid in E if wahl[eid] == E[eid]["richtig"][pfad])
    log["punkte"] = punkte
    log["sackgasse"] = int(len(log["aufgedeckt"]) != 9)
    return log


def alle_folgen(E):
    ids = [e for r in (1, 2, 3) for e in RUNDEN[r]]
    for kombi in itertools.product(*[E[i]["opts"] for i in ids]):
        yield dict(zip(ids, kombi))


def main():
    kanon = sys.argv[1]
    nseeds = int(sys.argv[sys.argv.index("--seeds") + 1]) if "--seeds" in sys.argv else 2000
    aus = sys.argv[sys.argv.index("--json") + 1] if "--json" in sys.argv else None
    E, minp = lade(kanon)
    folgen = list(alle_folgen(E))
    erg = {"parameter": P, "folgen": len(folgen)}

    # C8 Nr. 1a: Monotonie je Zug – alle Ausgangsfolgen eines Pflichtzugs enden aufgedeckt, Kosten <= worst
    folgen_zug = ["E", "T", "PE", "PT", "PPT", "PPE"]
    worst1 = P["c_pflicht"] + P["c_gruendlich"] + 2 * P["c_umweg"]
    kost = {f: P["c_pflicht"] + P["c_gruendlich"] + (P["c_umweg"] if len(f) > 1 else 0) + (P["c_umweg"] if len(f) > 2 else 0) for f in folgen_zug}
    erg["c8_1a"] = dict(folgen=folgen_zug, alle_aufgedeckt=True, max_kosten=max(kost.values()), worst=worst1,
                       budget_ungleichung=f"3*{worst1}={3*worst1} <= {P['rundenzeit']}", ok=3 * worst1 <= P["rundenzeit"])

    # C8 Nr. 1b + 2: erschöpfend 768 Folgen × 4 Pfade × Besetzung 4..20 × Ströme pech/erfolg; Gier-Bot zusätzlich
    sack = kette = budget = wert_abw = stand_abw = best_luecke = 0; laeufe = 0
    for pfad in PFADE:
        for wahl in folgen:
            neutralpunkte = None; neutralstand = None
            best = all(wahl[e] == E[e]["richtig"][pfad] for e in wahl)
            for n in range(4, 21):
                for art in ("pech", "erfolg", "neutral"):
                    for strat in ("neutral", "gier"):
                        lg = spiele(E, minp, pfad, n, "party", wahl, Strom(art), strat, rs=random.Random(seed(pfad, n, art, strat)))
                        laeufe += 1
                        sack += lg["sackgasse"]; kette += lg["kette_verletzt"]; budget += lg["budget_ueber"]
                        if neutralpunkte is None: neutralpunkte = lg["punkte"]; neutralstand = lg["stand"]
                        wert_abw += int(lg["punkte"] != neutralpunkte)
                        stand_abw += int(lg["stand"] != neutralstand)
                        if best:
                            for eid, st in lg["stand"].items():
                                best_luecke += sum(1 for f in E[eid]["ketten"].get(pfad, E[eid]["ketten"].get("alle", [])) if f not in st)
    erg["c8_1b_c8_2"] = dict(laeufe=laeufe, sackgassen=sack, kettenverletzungen=kette, budget_ueber=budget,
                           wertung_abweichend=wert_abw, faktenstand_abweichend_vom_neutralwurf=stand_abw,
                           bestes_spiel_fehlende_kettenglieder=best_luecke)

    # C8 Nr. 1c, 3, 13, Dauer, C9: Zufallsströme je Form und Besetzung
    def zufall(form, n, k):
        out = []
        for i in range(k):
            pfad = PFADE[i % 4]
            s = seed("bollwerk-meta", form, n, pfad, i)
            rs = random.Random(s)
            wahl = {eid: rs.choice(E[eid]["opts"]) for eid in E}
            out.append(spiele(E, minp, pfad, n, form, wahl, Strom("zufall", s), "neutral", rs=rs))
        return out
    baender = {}
    for form in ("party", "solo"):
        for n in (4, 8, 12, 16, 20):
            L = zufall(form, n, nseeds)
            anteil = [l["wuerfe"] / l["zuege"] for l in L]
            anteil_erste = sum(l["erste_wuerfe"] for l in L) / sum(l["zuege"] for l in L)
            anteil_streng = sum(l["erste_wuerfe"] for l in L) / sum(l["zuege"] - l.get("befragung_besetzt", 0) for l in L)
            pech1 = sum(l["erste_pech"] for l in L) / max(1, sum(l["erste_wuerfe"] for l in L))
            glueck = sorted(L, key=lambda l: statistics.mean(l["wurfsummen"]) if l["wurfsummen"] else 7)
            q = len(L) // 4
            unten, oben = glueck[:q], glueck[-q:]
            ab_u = statistics.mean(l["abstecher"] for l in unten); ab_o = statistics.mean(l["abstecher"] for l in oben)
            zf_u = statistics.mean(l["erfolge_zusatz"] for l in unten); zf_o = statistics.mean(l["erfolge_zusatz"] for l in oben)
            geraet_runde = sorted(l["geraet_s"] / 3 / 60 for l in L)
            rr = random.Random(seed("c9", form, n)); jac = []
            for _ in range(min(1000, len(L))):
                a, b = rr.sample(L, 2); A, B = set(a["szenen"]), set(b["szenen"])
                jac.append(len(A & B) / len(A | B))
            baender[f"{form}_n{n}"] = dict(
                partien=len(L),
                anteil_wurf_erste_anlaeufe=round(anteil_erste, 3),
                anteil_wurf_streng=round(anteil_streng, 3),
                anteil_wurf_median=round(statistics.median(anteil), 3),
                pech_erster_anlauf=round(pech1, 3),
                max_pech_folge=max(l["max_pech_folge"] for l in L),
                anteil_jede_runde_mit_wurf=round(sum(1 for l in L if l.get("wurf_runde", set()) >= {1, 2, 3}) / len(L), 4),
                pech_szenen_median=statistics.median(l["pech_szenen"] for l in L),
                erfolge_zusatz_median=statistics.median(l["erfolge_zusatz"] for l in L),
                abstecher_unten=round(ab_u, 2), abstecher_oben=round(ab_o, 2),
                abstecher_minus=round(1 - ab_u / ab_o, 3) if ab_o else None,
                zusatz_unten=round(zf_u, 2), zusatz_oben=round(zf_o, 2),
                zusatz_minus=round(1 - zf_u / zf_o, 3) if zf_o else None,
                geraet_min_je_runde_median=round(statistics.median(geraet_runde), 2),
                geraet_min_je_runde_p95=round(geraet_runde[int(0.95 * len(geraet_runde))], 2),
                sackgassen=sum(l["sackgasse"] for l in L),
                c9_jaccard_median=round(statistics.median(jac), 3),
                punkte_mittel=round(statistics.mean(l["punkte"] for l in L), 2),
            )
    erg["baender"] = baender
    s = json.dumps(erg, indent=1, default=list)
    if aus: open(aus, "w").write(s)
    print(s)


if __name__ == "__main__":
    main()

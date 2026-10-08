#!/usr/bin/env python3
"""Internes Werkzeug: erzeugt das Anker-Raster (Gesprächsskelett für K4) und prüft die Last.

Regeln (Grobplan 3.3, Risiko 4):
- Kernrollen 1–4: je Phase zwei Aufträge an Kernrollen in beidseitigen Paarungen
  (P1: 1-2,3-4 und 1-3,2-4 · P2: 1-3,2-4 und 1-4,2-3 · P3: 1-4,2-3 und 1-2,3-4);
  dritter Auftrag an die Rolle aus 5–8, deren Anker die Kernrolle in dieser Phase ist;
  Ersatzziel ist die dritte, noch nicht angesprochene Kernrolle.
- Rolle r ≥ 5 auf Blockposition j (1–4) hat in Phase p den Anker ((j-1 + p-1) mod 4) + 1.
- Block 5–8: Auftrag an Anker, an die Gegen-Kernrolle (Anker + 2) und Paarauftrag (5↔6, 7↔8).
- Block 9–20: Auftrag an Anker, an r−4 und Paarauftrag (9↔10, 11↔12, …).
- Ersatzziel eines Paarauftrags nach oben (ungerade r, Partner r+1 fehlt): die Rolle r−2;
  bei Rolle 5 die kleinste Kernrolle, die R05 in dieser Phase nicht schon anspricht.
  So führt auch die oberste Rolle bei ungerader Besetzung drei echte Gespräche.

Aufruf:
  python3 90_werkzeug/raster.py skelett      # K4-Skelettzeilen
  python3 90_werkzeug/raster.py last         # Lasttabelle aller Besetzungen
"""
import sys
from collections import defaultdict

PAAR1 = {1: [(1, 2), (3, 4)], 2: [(1, 3), (2, 4)], 3: [(1, 4), (2, 3)]}
PAAR2 = {1: [(1, 3), (2, 4)], 2: [(1, 4), (2, 3)], 3: [(1, 2), (3, 4)]}


def anker(r, p):
    j = (r - 5) % 4 + 1
    return ((j - 1) + (p - 1)) % 4 + 1


def partner(paare, r):
    for a, b in paare:
        if r == a:
            return b
        if r == b:
            return a
    raise ValueError


def paar(r):
    return r + 1 if r % 2 == 1 else r - 1


def skelett():
    zeilen = []
    for p in (1, 2, 3):
        nr = 0
        for r in range(1, 21):
            auftraege = []
            if r <= 4:
                k1, k2 = partner(PAAR1[p], r), partner(PAAR2[p], r)
                b1 = next(x for x in range(5, 9) if anker(x, p) == r)
                dritte = ({1, 2, 3, 4} - {r, k1, k2}).pop()
                auftraege = [(k1, None, "Kernpaarung"), (k2, None, "Kernpaarung"), (b1, dritte, "Kern→Zuträger")]
            else:
                a = anker(r, p)
                if r <= 8:
                    zweit = (a + 1) % 4 + 1
                    zweit_art = "Gegen-Kernrolle"
                else:
                    zweit = r - 4
                    zweit_art = "Kette r−4"
                pa = paar(r)
                ers = None
                if pa > r:
                    # neues, sicher anwesendes Gegenüber: r−2, bei Rolle 5 die freie Kernrolle
                    ers = r - 2 if r >= 7 else min({1, 2, 3, 4} - {a, zweit})
                auftraege = [(a, None, "Anker"), (zweit, None, zweit_art), (pa, ers, "Paar")]
            for ziel, ers, art in auftraege:
                nr += 1
                mn = max(r, ziel, 4)
                zeilen.append(dict(id=f"G{p}-{nr:02d}", p=p, von=r, ziel=ziel, ers=ers, min=mn, art=art))
    return zeilen


def last(zeilen, ausgabe=True):
    fehler = []
    for p in (1, 2, 3):
        for n in range(4, 21):
            paare = set()
            for z in zeilen:
                if z["p"] != p or z["von"] > n:
                    continue
                an = z["ziel"] if z["ziel"] <= n else z["ers"]
                if an is None or an > n:
                    fehler.append(f"{z['id']} N={n}: kein anwesendes Ziel")
                    continue
                paare.add(tuple(sorted((z["von"], an))))
            lst = defaultdict(int)
            for a, b in paare:
                lst[a] += 1
                lst[b] += 1
            mx = max(lst[r] for r in range(1, n + 1))
            mn = min(lst[r] for r in range(1, n + 1))
            if mx > 8:
                fehler.append(f"P{p} N={n}: max {mx}")
            if ausgabe:
                print(f"P{p} N={n:2d}: {len(paare):2d} Gespräche · max {mx} · min {mn} · " +
                      " ".join(f"{r}:{lst[r]}" for r in range(1, n + 1)))
    return fehler


if __name__ == "__main__":
    z = skelett()
    cmd = sys.argv[1] if len(sys.argv) > 1 else "last"
    if cmd == "skelett":
        for x in z:
            e = f"R{x['ers']:02d}" if x["ers"] else "–"
            print(f"@{x['id']} [G] | Von: R{x['von']:02d} | Ziel: R{x['ziel']:02d} | Ersatz: {e} | Min: {x['min']} | Art: {x['art']}")
    else:
        f = last(z)
        print("FEHLER:" if f else "Keine Lastverstöße.", *f, sep="\n")

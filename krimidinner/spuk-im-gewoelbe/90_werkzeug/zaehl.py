#!/usr/bin/env python3
"""Internes Werkzeug: mechanische Zählprüfung einer Rückgabe vor der Abnahme (kein Endprodukt).

Aufruf:
  python3 90_werkzeug/zaehl.py PROFIL-R07 0     # prüft 40_rueckgaben/PROFIL-R07.r0.md gegen 30_pakete/PROFIL-R07.r0.md
Ausgabe: eine Zeile je Prüfpunkt (OK / WARNUNG / FEHLER); die Abnahme bewertet die Befunde.
"""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bau  # noqa: E402

ROOT = bau.ROOT
ALKOHOL = r"\b(Wein|Rotwein|Weißwein|Glühwein|Bier|Sekt|Schnaps|Likör|Whisky|Rum|Wodka|Prosecco|Alkohol\w*|betrunken|beschwipst|angetrunken|Promille|Kater nach|Prost|anstoßen|Kneipe)\b"
PLATZHALTER = r"(\busw\.|\bund so weiter\b|\banalog\b|\bweitere folgen\b|\bTODO\b|\[Name\]|\bXX\b|^\s*…\s*$)"
LECK = r"(Täterin|Merle war es|Merle hat zugeschlagen|Gespenst war Merle|Merle war das Gespenst|23:58:2\d)"


def worte(text):
    return len(re.findall(r"\w+", text))


def main(argv):
    kennung, runde = argv[1], int(argv[2]) if len(argv) > 2 else 0
    paket = os.path.join(bau.PAKETE, f"{kennung}.r{runde}.md")
    rueck = os.path.join(ROOT, "40_rueckgaben", f"{kennung}.r{runde}.md")
    if not os.path.exists(rueck):
        print(f"FEHLER Rückgabe fehlt: {os.path.relpath(rueck, ROOT)}")
        return 1
    p = bau.plan()[kennung]
    text = open(rueck, encoding="utf-8").read()
    ptext = open(paket, encoding="utf-8").read() if os.path.exists(paket) else ""
    zeilen = [z for z in text.strip().split("\n") if z.strip()]
    befunde = []

    # 1. Endmarke
    soll = f"=== ENDE {kennung} · BEREIT ZUR RÜCKGABE ==="
    if zeilen and zeilen[-1].strip() == soll:
        befunde.append("OK Endmarke")
    elif any("=== UNTERBROCHEN BEI" in z for z in zeilen[-3:]):
        befunde.append("FEHLER Rückgabe unterbrochen (UNTERBROCHEN-Marke) [B-ENDMARKE]")
    else:
        befunde.append(f"FEHLER Endmarke fehlt oder weicht ab; letzte Zeile: {zeilen[-1][:80] if zeilen else '(leer)'} [B-ENDMARKE]")

    # 2. Formularfelder aus Abschnitt 8 des Pakets
    m = re.search(r"## 8\. Ausgabeformular[^\n]*\n(.*?)\n## 9\.", ptext, re.S)
    felder = []
    if m:
        for z in m.group(1).split("\n"):
            f = re.match(r"^\s*([A-ZÄÖÜ][A-ZÄÖÜ0-9 \-/·]{1,40}):", z)
            if f and "<" not in f.group(1):
                felder.append(f.group(1).strip())
    fehlend = [f for f in dict.fromkeys(felder) if not re.search(r"(^|\n)\s*" + re.escape(f) + r"\s*:", text)]
    befunde.append(f"OK Formularfelder ({len(felder)})" if not fehlend else f"FEHLER Formularfelder fehlen: {', '.join(fehlend)} [B-FELD]")

    # 3. Umfang (ohne Selbstprüfung)
    kern = re.split(r"\n\s*SELBSTPRÜFUNG:", text)[0]
    w = worte(kern)
    um = re.findall(r"[\d.]+", p.get("Umfang").replace(".", ""))
    if len(um) == 2:
        lo, hi = int(um[0]), int(um[1])
        if w < lo * 0.85 or w > hi * 1.15:
            befunde.append(f"WARNUNG Umfang {w} Wörter, Soll {lo}–{hi} (±15 %) [H-WORTSPANNE]")
        else:
            befunde.append(f"OK Umfang {w} Wörter (Soll {lo}–{hi})")

    # 4. Leitplanken, Platzhalter, Leck
    for name, muster, code in (("Alkohol-Stoppwort", ALKOHOL, "F-ALKOHOL"), ("Platzhalter", PLATZHALTER, "B-PLATZHALTER")):
        treffer = sorted({t if isinstance(t, str) else t[0] for t in re.findall(muster, kern, re.M | re.I)})
        befunde.append(f"OK {name}" if not treffer else f"FEHLER {name}: {', '.join(treffer)} [{code}]")
    if p.get("Lösung") != "ja":
        treffer = sorted(set(re.findall(LECK, kern)))
        befunde.append("OK kein Lösungsleck (Stichwortsuche)" if not treffer else f"FEHLER mögliches Lösungsleck: {', '.join(treffer)} [LECK]")

    # 5. Ziffern in Vorlesetexten
    if p.get("Vorlage", "").startswith("ERZ-"):
        ziff = [z.strip()[:60] for z in kern.split("\n") if re.search(r"\d", z) and not re.match(r"^\s*[A-ZÄÖÜ][A-ZÄÖÜ0-9 \-/·]+:", z)]
        befunde.append("OK keine Ziffern im Vorlesetext" if not ziff else f"WARNUNG Ziffern im Vorlesetext ({len(ziff)} Zeilen), z. B. „{ziff[0]}“ [G-ZIFFERN]")

    for b in befunde:
        print(b)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))

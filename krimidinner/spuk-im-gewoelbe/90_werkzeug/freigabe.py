#!/usr/bin/env python3
"""Internes Werkzeug: übernimmt eine abgenommene Rückgabe in 60_freigaben und führt Plan und Register nach (kein Endprodukt).

Aufruf:
  python3 90_werkzeug/freigabe.py PROFIL-R07 1          # Rückgabe r1 ist FREIGEGEBEN
  python3 90_werkzeug/freigabe.py --status PROFIL-R07 eskaliert
Die Abnahme 50_abnahmen/<ID>.r<n>.md muss „Urteil: FREIGEGEBEN“ enthalten, sonst bricht das Werkzeug ab.
Das Register hält je Freigabe die Kanon-Kennungen aus dem Paketauszug fest (für Reparaturen nach Kanon-Ergänzungen).
"""
import os
import re
import shutil
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bau  # noqa: E402

ROOT = bau.ROOT
PLAN = os.path.join(ROOT, "00_steuerung", "PLAN.md")
REGISTER = os.path.join(ROOT, "00_steuerung", "REGISTER.md")


def setze_status(kennung, status):
    zeilen = open(PLAN, encoding="utf-8").read().split("\n")
    for i, z in enumerate(zeilen):
        if z.startswith(f"@{kennung} "):
            zeilen[i] = re.sub(r"\| Status: [^|]*$", f"| Status: {status}", z)
            break
    else:
        raise SystemExit(f"{kennung} steht nicht im PLAN")
    open(PLAN, "w", encoding="utf-8").write("\n".join(zeilen))


def main(argv):
    if argv[1] == "--status":
        setze_status(argv[2], argv[3])
        print(f"{argv[2]}: Status {argv[3]}")
        return 0
    kennung, runde = argv[1], int(argv[2])
    abn = os.path.join(ROOT, "50_abnahmen", f"{kennung}.r{runde}.md")
    if not os.path.exists(abn) or not re.search(r"Urteil:\s*FREIGEGEBEN", open(abn, encoding="utf-8").read()):
        raise SystemExit(f"{kennung} r{runde}: keine Abnahme mit Urteil FREIGEGEBEN")
    summe = re.search(r"Summe:\s*(\d+)/16", open(abn, encoding="utf-8").read())
    os.makedirs(bau.FREI, exist_ok=True)
    shutil.copyfile(os.path.join(ROOT, "40_rueckgaben", f"{kennung}.r{runde}.md"), os.path.join(bau.FREI, f"{kennung}.md"))
    setze_status(kennung, f"freigegeben (r{runde}, {summe.group(1) if summe else '?'}/16)")
    paket = open(os.path.join(bau.PAKETE, f"{kennung}.r{runde}.md"), encoding="utf-8").read()
    auszug = re.search(r"## 3\. Kanon-Auszug[^\n]*\n(.*?)\n## 4\.", paket, re.S)
    ids = re.findall(r"^\d+\. \[([^\]]+)\]", auszug.group(1), re.M) if auszug else []
    if not os.path.exists(REGISTER):
        open(REGISTER, "w", encoding="utf-8").write("# REGISTER · Freigaben und ihre Kanon-Grundlage\n\n| Kennung | Runde | Summe | Kanon | Kanon-Kennungen im Auszug |\n|---|---|---|---|---|\n")
    with open(REGISTER, "a", encoding="utf-8") as fh:
        fh.write(f"| {kennung} | r{runde} | {summe.group(1) if summe else '?'}/16 | v{bau.kanon_version()} | {', '.join(ids)} |\n")
    print(f"{kennung}: freigegeben aus r{runde}, {len(ids)} Kanon-Kennungen registriert")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))

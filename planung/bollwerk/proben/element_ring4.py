#!/usr/bin/env python3
"""Ring 4 (statisch) für Bildschirmelemente: Tippflächen ≥ 48 dp, Bedienung im unteren Drittel (y ≥ 568 von 852),
Farben nur aus der Palette, Kontrast Text/Grund ≥ 4,5:1, Stufen mit Symbol und Wort.
Aufruf: python3 -I element_ring4.py <element.jsonl>"""
import json, sys
PAL = {'#070608', '#4f4842', '#454039', '#2b2521', '#4a4038', '#7d6242', '#ff9329', '#ffc27a', '#b3263a', '#f1ede4', '#15120f'}
def lum(h):
    c = [int(h[i:i + 2], 16) / 255 for i in (1, 3, 5)]
    c = [x / 12.92 if x <= 0.03928 else ((x + 0.055) / 1.055) ** 2.4 for x in c]
    return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2]
def kontrast(a, b):
    la, lb = sorted([lum(a), lum(b)], reverse=True); return (la + 0.05) / (lb + 0.05)
ok = 0; n = 0
for z in open(sys.argv[1], encoding='utf-8'):
    if not z.strip(): continue
    v = json.loads(z); n += 1; L = v.get('layout') or {}; f = []
    for k in L.get('knoepfe', []):
        if k.get('breite_dp', 0) < 48 or k.get('hoehe_dp', 0) < 48: f.append(f"tippflaeche:{k.get('name')}")
        if k.get('y_dp', 0) < 568: f.append(f"nicht_unten:{k.get('name')}")
    fa = L.get('farben') or {}
    for x in fa.values():
        if x.lower() not in PAL: f.append(f"farbe:{x}")
    if fa.get('text') and fa.get('grund') and kontrast(fa['text'].lower(), fa['grund'].lower()) < 4.5: f.append('kontrast')
    for s, t in (L.get('stufen_darstellung') or {}).items():
        if len((t or '').split()) < 2: f.append(f"nur_ein_zeichen:{s}")
    ok += not f
    print(v.get('kennung'), 'GRÜN' if not f else 'ROT ' + ','.join(f))
print(f'RING4 {ok}/{n} grün')

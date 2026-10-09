#!/usr/bin/env python3
"""Eichsätze D3a (Paar-Eichung) und D3b (Stilbruch, Überladen) aus echten Bildern.
Aufruf: python3 -I eichsatz.py <lauf1> <lauf2> <aus> <seed>
Erzeugt <aus>/d3a/<hash>_A.png,_B.png (24 Paare), <aus>/d3b/<hash>.png (18 Bilder) und <aus>/LOESUNG.json.
Die Lösung wird erst nach dem Gremium eingecheckt; Dateinamen sind Hashes."""
import sys, os, json, hashlib, random
from PIL import Image, ImageFilter, ImageEnhance, ImageDraw, ImageOps
l1, l2, aus, seed = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
r = random.Random(seed)
os.makedirs(f"{aus}/d3a", exist_ok=True); os.makedirs(f"{aus}/d3b", exist_ok=True)
namen = sorted(f for f in os.listdir(l1) if f.endswith('.png'))
klein = lambda im: im.resize((im.width // 2, im.height // 2), Image.LANCZOS)
verschlechtern = {
    'unscharf': lambda im: im.filter(ImageFilter.GaussianBlur(3)),
    'flau': lambda im: ImageEnhance.Contrast(im).enhance(0.55),
    'blass': lambda im: ImageEnhance.Color(im).enhance(0.25),
    'rauschen': lambda im: Image.blend(im, Image.effect_noise(im.size, 60).convert('RGB'), 0.18),
    'block': lambda im: im.resize((im.width // 6, im.height // 6), Image.NEAREST).resize(im.size, Image.NEAREST),
    'dunkel': lambda im: ImageEnhance.Brightness(im).enhance(0.55),
}
def h(*t): return hashlib.sha256('|'.join(map(str, t)).encode()).hexdigest()[:12]
loesung = {'d3a': {}, 'd3b': {}, 'seed': seed}
# 18 Kontrollpaare: je Bild 2 Verschlechterungen; Seite des Originals per Seed
arten = list(verschlechtern)
for i, n in enumerate(namen):
    im = klein(Image.open(f"{l1}/{n}").convert('RGB'))
    for k in range(2):
        art = arten[(2 * i + k) % len(arten)]
        schlecht = verschlechtern[art](im)
        orig_links = r.random() < 0.5
        key = h('kontrolle', seed, n, art)
        (im if orig_links else schlecht).save(f"{aus}/d3a/{key}_A.png"); (schlecht if orig_links else im).save(f"{aus}/d3a/{key}_B.png")
        loesung['d3a'][key] = {'typ': 'kontrolle', 'besser': 'A' if orig_links else 'B', 'quelle': n, 'art': art}
# 6 Gleichpaare: Lauf 1 gegen Lauf 2 (ΔE ≤ 1), richtige Antwort „gleich“
for n in r.sample(namen, 6):
    key = h('gleich', seed, n)
    klein(Image.open(f"{l1}/{n}").convert('RGB')).save(f"{aus}/d3a/{key}_A.png"); klein(Image.open(f"{l2}/{n}").convert('RGB')).save(f"{aus}/d3a/{key}_B.png")
    loesung['d3a'][key] = {'typ': 'gleich', 'besser': 'gleich', 'quelle': n}
# D3b: 6 Fehlertypen × 2 + 6 einwandfreie = 18 (12 mit bekanntem Fehler)
def pixel3d(im):
    k = im.resize((im.width // 10, im.height // 10), Image.NEAREST); k = ImageOps.posterize(k, 3)
    return k.resize(im.size, Image.NEAREST)
def fremdfarbe(im):
    hsv = im.convert('HSV'); a = list(hsv.split()); a[0] = a[0].point(lambda v: (v + 110) % 256); a[1] = a[1].point(lambda v: min(255, v * 2 + 60))
    return Image.merge('HSV', a).convert('RGB')
def lichtrichtung(im):
    g = Image.linear_gradient('L').resize(im.size).rotate(90, expand=False)
    return Image.composite(ImageEnhance.Brightness(im).enhance(2.2), ImageEnhance.Brightness(im).enhance(0.4), g)
def isowinkel(im): return im.rotate(9, resample=Image.BICUBIC, fillcolor=(7, 6, 8))
def abgeschnitten(im):
    im = im.copy(); d = ImageDraw.Draw(im); w, hh = im.size
    d.rectangle([w * 0.35, hh * 0.45, w * 0.6, hh * 0.62], fill=(7, 6, 8)); return im
def textueberlauf(im):
    im = im.copy(); d = ImageDraw.Draw(im); w, hh = im.size
    d.rectangle([w * 0.1, hh * 0.05, w * 0.9, hh * 0.13], fill=(28, 25, 30))
    d.text((w * 0.11, hh * 0.07), 'Wer weiß, wer im Dunkeln am Ostende der Theke war und warum die Tür so laut quietschte, als alle ' * 2, fill=(241, 237, 228))
    return im
def ueberladen(im):
    im = im.copy(); d = ImageDraw.Draw(im); w, hh = im.size; rr = random.Random(seed)
    for _ in range(160):
        x, y, s = rr.randint(0, w), rr.randint(0, hh), rr.randint(6, 26)
        d.ellipse([x, y, x + s, y + s], outline=(255, 147, 41), width=2)
    for _ in range(40):
        x, y = rr.randint(0, w), rr.randint(0, hh); d.rectangle([x, y, x + 30, y + 18], fill=(rr.randint(40, 255), 120, 60))
    return im
fehler = {'pixel3d': pixel3d, 'fremdfarbe': fremdfarbe, 'lichtrichtung': lichtrichtung, 'isowinkel': isowinkel,
          'abgeschnitten': abgeschnitten, 'textueberlauf': textueberlauf}
quellen = r.sample(namen, len(namen))
j = 0
for art, f in fehler.items():
    for k in range(2):
        n = quellen[j % len(quellen)]; j += 1
        key = h('d3b', seed, art, k)
        f(klein(Image.open(f"{l1}/{n}").convert('RGB'))).save(f"{aus}/d3b/{key}.png")
        loesung['d3b'][key] = {'fehler': art, 'quelle': n}
for k in range(6):
    n = quellen[(j + k) % len(quellen)]
    key = h('d3b-ok', seed, n, k)
    klein(Image.open(f"{l1}/{n}").convert('RGB')).save(f"{aus}/d3b/{key}.png")
    loesung['d3b'][key] = {'fehler': 'keiner', 'quelle': n}
# zusätzlich 6 Überladen-Bilder (für S1–S5 und D3b-Überladen)
for k in range(6):
    n = quellen[k]
    key = h('ueberladen', seed, n, k)
    ueberladen(klein(Image.open(f"{l1}/{n}").convert('RGB'))).save(f"{aus}/d3b/{key}.png")
    loesung['d3b'][key] = {'fehler': 'ueberladen', 'quelle': n}
json.dump(loesung, open(f"{aus}/LOESUNG.json", 'w'), indent=1)
print('d3a', len(loesung['d3a']), 'd3b', len(loesung['d3b']))

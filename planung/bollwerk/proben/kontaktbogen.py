#!/usr/bin/env python3
"""Kontaktbogen: Bilder in ein Raster mit Beschriftung, JPEG ≤ 2400 px breit und ≤ 1,5 MB.
Aufruf: python3 -I kontaktbogen.py <aus.jpg> <titel> <spalten> <bild1> [<bild2> …]"""
import sys, os
from PIL import Image, ImageDraw, ImageFont
aus, titel, spalten, bilder = sys.argv[1], sys.argv[2], int(sys.argv[3]), sys.argv[4:]
breite = 2400; rand = 12; kopf = 56; zeile = 30
zelle_b = (breite - rand * (spalten + 1)) // spalten
ims = [Image.open(b).convert('RGB') for b in bilder]
hoehen = []
for i in range(0, len(ims), spalten):
    hoehen.append(max(int(im.height * zelle_b / im.width) for im in ims[i:i + spalten]) + zeile)
bogen = Image.new('RGB', (breite, kopf + sum(hoehen) + rand * (len(hoehen) + 1)), (24, 22, 28))
d = ImageDraw.Draw(bogen)
try:
    f = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 22); fk = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', 28)
except OSError:
    f = fk = ImageFont.load_default()
d.text((rand, 12), titel, fill=(240, 230, 210), font=fk)
y = kopf + rand
for r, h in enumerate(hoehen):
    for c, im in enumerate(ims[r * spalten:(r + 1) * spalten]):
        x = rand + c * (zelle_b + rand)
        k = im.resize((zelle_b, int(im.height * zelle_b / im.width)), Image.LANCZOS)
        bogen.paste(k, (x, y))
        d.text((x, y + k.height + 4), os.path.basename(bilder[r * spalten + c]), fill=(220, 210, 190), font=f)
    y += h + rand
q = 88
while True:
    bogen.save(aus, 'JPEG', quality=q, optimize=True)
    if os.path.getsize(aus) <= 1_500_000 or q <= 40: break
    q -= 8
print(aus, bogen.size, os.path.getsize(aus), 'Byte, Qualität', q)

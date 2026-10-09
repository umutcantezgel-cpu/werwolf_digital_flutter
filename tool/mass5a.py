#!/usr/bin/env python3
# Bild-Näherung zum Maßstab 5a (E40): sucht in nachtlauf/bilder/phase3/figuren_aufstellung.png Figurenpaare mit
# gleicher Farbfamilie an Rumpf und Beinen, gleicher Kopfbedeckung (ja/nein) und kleinem Größenunterschied.
# Hilfsskript, kein Test. Braucht Python 3 und Pillow. Aufruf aus der Repo-Wurzel:
#   python3 tool/mass5a.py [<aufstellung.png>] [<max. Größenunterschied in Bildpixeln, Standard 10>]
import json, re, sys
from collections import Counter
from PIL import Image
import os
R=os.path.join(os.path.dirname(os.path.abspath(__file__)), '..') + '/'
pal=[int(x,16) for x in re.findall(r'0x([0-9A-F]{6})', open(R+'packages/pixel_engine/lib/src/palette.dart').read().split('RGB-Werte der 64')[1])][:64]
idx={((c>>16)&255,(c>>8)&255,c&255):i for i,c in enumerate(pal)}
bild=sys.argv[1] if len(sys.argv)>1 and sys.argv[1] else R+'nachtlauf/bilder/phase3/figuren_aufstellung.png'
im=Image.open(bild).convert('RGB'); W,H=im.size; px=im.load()
karten=json.load(open(R+'packages/pixel_engine/data/figuren/karten.json',encoding='utf-8'))['karten']
ids=[k['id'] for k in karten]; teile={k['id']:k['teile'] for k in karten}
cw=W/9; rh=H/8; bg=px[2,2]
def fam(i):
    r,s=divmod(i,8)
    if r==7: return None  # Haut
    if s<=1: return 'dunkel'
    if r in (0,1): return 'grau'
    return ['neutral','stein','holz','rot','bernstein','gruen','blau'][r]
def info(n):
    r,c=divmod(n,9)
    x0,x1=int(c*cw),int(c*cw+cw/3); y0,y1=int(r*rh),int((r+1)*rh)-30
    pts=[(x,y) for y in range(y0,y1,2) for x in range(x0,x1,2) if px[x,y]!=bg]
    top=min(p[1] for p in pts); bot=max(p[1] for p in pts); h=bot-top+2
    xs=[p[0] for p in pts]; w=max(xs)-min(xs)+2
    def zone(a,b):
        cnt=Counter()
        for x,y in pts:
            if top+a*h<=y<top+b*h:
                if any(px[x+dx,y+dy]==bg for dx,dy in ((2,0),(-2,0),(0,2),(0,-2))): continue
                f=fam(idx.get(px[x,y],63))
                if f: cnt[f]+=1
        return cnt.most_common(1)[0][0] if cnt else None
    return dict(h=h,w=w,ober=zone(0.28,0.50),unter=zone(0.62,0.88))
I={i:info(n) for n,i in enumerate(ids)}
def hut(i): return any(t.startswith('kopf-') for t in teile[i])
paare=[]
for a in range(len(ids)):
    for b in range(a+1,len(ids)):
        x,y=I[ids[a]],I[ids[b]]
        dh=abs(x['h']-y['h'])
        if dh<int(sys.argv[2]) if len(sys.argv)>2 else dh<10:
            if x['ober']==y['ober'] and x['unter']==y['unter'] and hut(ids[a])==hut(ids[b]):
                paare.append((dh,ids[a],ids[b],x,y))
for p in sorted(paare): print(f"{p[1]}/{p[2]} Δh {p[0]} · ober {p[3]['ober']} · unter {p[3]['unter']} · Hut {hut(p[1])} · h {p[3]['h']}/{p[4]['h']} w {p[3]['w']}/{p[4]['w']}")
print(len(paare),'Paare')

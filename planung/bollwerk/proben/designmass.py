#!/usr/bin/env python3
"""Designmaße-Probe (Basiswerte ohne Renderer-Masken; die Nacht nutzt Masken nach S1–S5).
Je Bild: Luminanz im Mittel, Vignette (Rand − Mitte), Palettenanteil (ΔE76 ≤ 10 zur Szenenpalette),
Iso-Kantenanteil (Kanten innerhalb ±3° von 0°, 90°, ±26,57°), Dunkelanteil (L < 5).
Aufruf: python3 -I designmass.py <bild> [<bild> …]"""
import sys, os
import numpy as np
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from bildgleich import lab  # noqa: E402

PALETTE = ['#070608', '#4f4842', '#454039', '#2b2521', '#4a4038', '#7d6242', '#ff9329', '#ffc27a', '#b3263a', '#f1ede4', '#15120f']
pal = lab(np.array([[int(h[i:i + 2], 16) for i in (1, 3, 5)] for h in PALETTE], dtype=np.uint8)[None])[0]
print('bild\tL_mittel\tvignette\tpalette_anteil\tiso_kanten_anteil\tdunkel_anteil')
for p in sys.argv[1:]:
    im = Image.open(p).convert('RGB')
    im = im.resize((im.width // 2, im.height // 2))
    a = np.asarray(im); L = lab(a)
    h, w = L.shape[:2]
    mitte = L[h // 4:3 * h // 4, w // 4:3 * w // 4, 0].mean()
    rand = np.concatenate([L[:h // 8, :, 0].ravel(), L[-h // 8:, :, 0].ravel(), L[:, :w // 8, 0].ravel(), L[:, -w // 8:, 0].ravel()]).mean()
    d = np.min(np.sqrt(((L[:, :, None, :] - pal[None, None]) ** 2).sum(-1)), axis=2)
    g = L[..., 0]
    gx = np.zeros_like(g); gy = np.zeros_like(g)
    gx[:, 1:-1] = g[:, 2:] - g[:, :-2]; gy[1:-1] = g[2:] - g[:-2]
    mag = np.hypot(gx, gy); kante = mag > 8
    winkel = (np.degrees(np.arctan2(gy, gx)) + 180) % 180  # Gradientenrichtung; Kante steht senkrecht dazu
    kw = (winkel + 90) % 180
    ziel = np.array([0, 90, 26.57, 180 - 26.57, 180])
    nah = np.min(np.abs(kw[..., None] - ziel), axis=-1) <= 3
    print(f"{os.path.basename(p)}\t{L[..., 0].mean():.1f}\t{rand - mitte:.1f}\t{np.mean(d <= 10):.3f}\t{np.mean(nah[kante]) if kante.any() else 0:.3f}\t{np.mean(L[..., 0] < 5):.3f}")

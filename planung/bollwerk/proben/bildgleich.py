#!/usr/bin/env python3
"""Bildgleichheit zweier Fotoläufe: sha256 gleich, sonst ΔE (CIE76 in Lab) je Pixel.
Aufruf: python3 -I bildgleich.py <ordnerA> <ordnerB>  → je Bild: anteil_pixel_anders, dE_mittel, dE_p99, dE_max"""
import sys, os, hashlib
import numpy as np
from PIL import Image

def lab(a):
    a = a.astype(np.float64) / 255.0
    a = np.where(a > 0.04045, ((a + 0.055) / 1.055) ** 2.4, a / 12.92)
    M = np.array([[0.4124, 0.3576, 0.1805], [0.2126, 0.7152, 0.0722], [0.0193, 0.1192, 0.9505]])
    xyz = a @ M.T / np.array([0.95047, 1.0, 1.08883])
    f = np.where(xyz > 216 / 24389, np.cbrt(xyz), (24389 / 27 * xyz + 16) / 116)
    return np.stack([116 * f[..., 1] - 16, 500 * (f[..., 0] - f[..., 1]), 200 * (f[..., 1] - f[..., 2])], -1)

def main():
    A, B = sys.argv[1:3]; schlecht = 0
    for n in sorted(f for f in os.listdir(A) if f.endswith('.png')):
        pa, pb = os.path.join(A, n), os.path.join(B, n)
        if hashlib.sha256(open(pa, 'rb').read()).digest() == hashlib.sha256(open(pb, 'rb').read()).digest():
            print(f"{n} sha256 gleich"); continue
        a = np.asarray(Image.open(pa).convert('RGB')); b = np.asarray(Image.open(pb).convert('RGB'))
        if a.shape != b.shape: print(f"{n} Größe anders"); schlecht += 1; continue
        d = np.sqrt(((lab(a) - lab(b)) ** 2).sum(-1))
        ok = d.mean() <= 1.0
        schlecht += not ok
        print(f"{n} anders={np.mean(d > 0.5):.4f} dE_mittel={d.mean():.3f} dE_p99={np.percentile(d, 99):.2f} dE_max={d.max():.1f} {'OK' if ok else 'ROT'}")
    print("GLEICHHEIT", "GRÜN" if schlecht == 0 else f"ROT ({schlecht})")


if __name__ == '__main__':
    main()

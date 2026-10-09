#!/usr/bin/env python3
"""Sucht längere wörtliche Passagen aus dem Rohchat (quellen/) in Dateien, die ins Repo gehen.

Prüft jede Zeile des Rohchats mit mindestens MIN Zeichen Fließtext (ohne Chat-Kopf,
ohne JSON-Schlüssel) gegen alle versionierten und neuen, nicht ignorierten Dateien.
Ausgabe: Treffer als „Datei: Anfang der Passage“. Exit 1 bei Treffern.
"""
import re
import subprocess
import sys
from pathlib import Path

MIN = 120
wurzel = Path(__file__).resolve().parents[2]
chat = wurzel / 'quellen' / 'schlosskeller-teamchat.txt'
if not chat.exists():
    print('Rohchat lokal nicht vorhanden – Passagenprüfung übersprungen.')
    sys.exit(0)
kopf = re.compile(r'^\[\d{2}\.\d{2}\.\d{2}, \d{2}:\d{2}:\d{2}\] [^:]+: ')
passagen = []
for zeile in chat.read_text(encoding='utf-8').splitlines():
    t = kopf.sub('', zeile).strip()
    t = re.sub(r'^"[A-Za-z]+":\s*', '', t).strip(' ",')
    t = re.sub(r'^[•\-\*⁠\s]+', '', t)
    if len(t) >= MIN:
        passagen.append(t)
dateien = subprocess.run(['git', 'ls-files', '-co', '--exclude-standard'], cwd=wurzel, capture_output=True, text=True).stdout.split('\n')
ausnahmen = ('quellen/', '.werkzeug/', 'tool/lib/chat_passagen.py')
treffer = []
for d in dateien:
    if not d or d.startswith(ausnahmen):
        continue
    p = wurzel / d
    try:
        inhalt = p.read_text(encoding='utf-8')
    except (UnicodeDecodeError, FileNotFoundError, IsADirectoryError):
        continue
    for t in passagen:
        if t in inhalt:
            treffer.append(f'{d}: „{t[:70]}…“')
for t in treffer:
    print(t)
print(f'Wörtliche Chat-Passagen (≥ {MIN} Zeichen): {len(treffer)}')
sys.exit(1 if treffer else 0)

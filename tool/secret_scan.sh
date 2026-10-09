#!/usr/bin/env bash
# Secret-Scan vor jedem Push. Prüft Arbeitsstand und gesamten Git-Verlauf:
#  1. Nichts aus quellen/ (Rohchat) ist je committet worden.
#  2. Keine Chat-Kopfzeilen des Rohchats im Verlauf.
#  3. Keine Schlüssel- oder Token-Muster, keine .env-Dateien.
#  4. Keine längeren wörtlichen Passagen (≥ 120 Zeichen) aus dem Rohchat im Arbeitsstand.
set -uo pipefail
cd "$(dirname "$0")/.."
fehler=0
melde() { echo "SECRET-SCAN: $*"; fehler=1; }

# 1. quellen/ nie im Verlauf
if [ -n "$(git log --all --format=%H -- quellen/ 2>/dev/null)" ]; then
  melde "quellen/ taucht im Git-Verlauf auf"
fi
if git ls-files --error-unmatch quellen >/dev/null 2>&1; then
  melde "quellen/ ist im Index"
fi

# 2. Chat-Kopfzeilen (Datum, Uhrzeit, Name) im Verlauf oder im Index
muster_chat='\[[0-9]{2}\.[0-9]{2}\.[0-9]{2}, [0-9]{2}:[0-9]{2}:[0-9]{2}\] '
if git grep --untracked -nE "$muster_chat" -- . ':!tool/secret_scan.sh' >/dev/null 2>&1; then
  melde "Chat-Kopfzeile im Arbeitsstand: $(git grep --untracked -lE "$muster_chat" -- . ':!tool/secret_scan.sh' | head -3 | tr '\n' ' ')"
fi
if git log --all -p -G"$muster_chat" --format=%h -- . ':!tool/secret_scan.sh' 2>/dev/null | grep -qE '^[0-9a-f]{7,}$'; then
  melde "Chat-Kopfzeile im Git-Verlauf"
fi

# 3. Schlüssel- und Token-Muster, .env-Dateien
muster_key='(AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9]{30,}|sk-[A-Za-z0-9_-]{24,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[abpr]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_-]{35})'
if git grep --untracked -nE "$muster_key" -- . ':!tool/secret_scan.sh' >/dev/null 2>&1; then
  melde "Schlüsselmuster im Arbeitsstand: $(git grep --untracked -lE "$muster_key" -- . ':!tool/secret_scan.sh' | head -3 | tr '\n' ' ')"
fi
if git log --all -p -G"$muster_key" --format=%h -- . ':!tool/secret_scan.sh' 2>/dev/null | grep -qE '^[0-9a-f]{7,}$'; then
  melde "Schlüsselmuster im Git-Verlauf"
fi
if git ls-files | grep -qE '(^|/)\.env(\..*)?$'; then
  melde ".env-Datei im Index"
fi

# 4. Keine längeren wörtlichen Passagen aus dem Rohchat in Dateien, die ins Repo gehen
if ! python3 tool/lib/chat_passagen.py >/tmp/chat_passagen.$$ 2>&1; then
  melde "wörtliche Chat-Passagen: $(head -3 /tmp/chat_passagen.$$ | tr '\n' ' ')"
fi
rm -f /tmp/chat_passagen.$$

if [ "$fehler" -ne 0 ]; then
  echo "Secret-Scan: FEHLER"
  exit 1
fi
echo "Secret-Scan: sauber"

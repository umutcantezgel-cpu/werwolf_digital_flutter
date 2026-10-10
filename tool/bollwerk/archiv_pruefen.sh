#!/usr/bin/env bash
# BOLLWERK · Archivprüfung (Z-29, Z-30; A-9 §8).
# Aufruf: bash tool/bollwerk/archiv_pruefen.sh              jede Linie aus BESTAND §2 steht in ARCHIV.md mit Ref, SHA, Klasse;
#                                                            jede Ref existiert in git ls-remote origin; nichts gelöscht
#         bash tool/bollwerk/archiv_pruefen.sh --uebernahmen je Linie der Klasse „zusammenführen“/„übernehmen“/„mitführen“
#                                                            ein Merge-Commit „Merge <ref>@<sha>“, je Pfad ein Commit
#                                                            „aus <ref>@<sha>:<pfad>“ oder eine Absage in der Spalte Art
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env.sh"
cd "$BW"
BESTAND=planung/bollwerk/BESTAND.md
ARCHIV=planung/bollwerk/ARCHIV.md
[ -f "$ARCHIV" ] || { echo "ARCHIV.md fehlt"; echo "Z-29 ROT"; exit 1; }
REFS="$(git ls-remote origin 'refs/heads/*')"
BETREFFE="$(git log --format=%s bollwerk)"
linien="$(sed -n '/^## 2\./,/^## 3\./p' "$BESTAND" | grep -E '^\| ' | grep -vE '^\| (Linie|---)' | cut -d'|' -f2 | sed 's/^ *//; s/ *$//')"
rot=0; n=0
while IFS= read -r linie; do
  [ -n "$linie" ] || continue
  n=$((n+1))
  zeile="$(grep -F "| $linie |" "$ARCHIV" | head -1)"
  if [ -z "$zeile" ]; then echo "fehlt in ARCHIV.md: $linie"; rot=$((rot+1)); continue; fi
  ref="$(echo "$zeile" | cut -d'|' -f3 | sed 's/^ *//; s/ *$//')"
  sha="$(echo "$zeile" | cut -d'|' -f4 | sed 's/^ *//; s/ *$//')"
  klasse="$(echo "$zeile" | cut -d'|' -f5 | sed 's/^ *//; s/ *$//')"
  if [ -z "$ref" ] || [ -z "$klasse" ]; then echo "unvollständig: $linie"; rot=$((rot+1)); continue; fi
  muster="refs/heads/${ref//\*/.*}"
  if ! grep -qE "[[:space:]]$muster\$" <<< "$REFS"; then echo "Ref fehlt auf origin: $ref ($linie)"; rot=$((rot+1)); continue; fi
  if [[ "$sha" =~ ^[0-9a-f]{7,40}$ ]]; then
    git cat-file -e "$sha^{commit}" || { echo "SHA unbekannt: $sha ($linie)"; rot=$((rot+1)); continue; }
  elif [[ "$ref" != *'*'* ]]; then
    echo "SHA fehlt: $linie"; rot=$((rot+1)); continue
  fi
  if [ "${1:-}" = --uebernahmen ] && [[ "$klasse" =~ ^(zusammenführen|übernehmen|mitführen) ]]; then
    art="$(echo "$zeile" | cut -d'|' -f6)"
    if grep -qE "^(Merge $ref@$sha|aus $ref@[0-9a-f]+:)" <<< "$BETREFFE"; then
      echo "übernommen: $linie"
    elif echo "$art" | grep -qiE 'Absage:'; then
      echo "abgesagt (begründet): $linie"
    else
      echo "Übernahme offen: $linie ($ref@$sha)"; rot=$((rot+1))
    fi
  fi
done <<< "$linien"
modus=Z-29; [ "${1:-}" = --uebernahmen ] && modus=Z-30
echo "Linien $n · Befunde $rot"
if [ "$rot" -eq 0 ] && [ "$n" -gt 0 ]; then echo "$modus GRÜN"; exit 0; fi
echo "$modus ROT"; exit 1

# BOLLWERK · Umgebung (A-2 A4.10). Aufruf: source <repo>/tool/bollwerk/env.sh
# BW ergibt sich aus dem Pfad dieser Datei; POOL ist umlenkbar (Meta-Trockenlauf).
BW="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export BW
export POOL="${POOL:-/home/user/bw}"
# Befund F-5: Nur eine eingerichtete Werkzeugkette (.werkzeug/flutter) lenkt Flutter und Pub-Cache um; in einer
# frischen Arbeitskopie ohne .werkzeug bleiben das vorhandene SDK und der vorhandene Cache (sonst pub get Exit 69).
if [ -x "$BW/.werkzeug/flutter/bin/flutter" ]; then
  export FLUTTER_ROOT="$BW/.werkzeug/flutter"
  export PUB_CACHE="$BW/.werkzeug/pub-cache"
  case ":$PATH:" in
    *":$BW/.werkzeug/flutter/bin:"*) ;;
    *) export PATH="$BW/.werkzeug/flutter/bin:/opt/node22/bin:$PATH" ;;
  esac
else
  case ":$PATH:" in
    *":/opt/node22/bin:"*) ;;
    *) export PATH="/opt/node22/bin:$PATH" ;;
  esac
fi

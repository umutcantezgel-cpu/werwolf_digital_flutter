# BOLLWERK · Umgebung (A-2 A4.10). Aufruf: source <repo>/tool/bollwerk/env.sh
# BW ergibt sich aus dem Pfad dieser Datei; POOL ist umlenkbar (Meta-Trockenlauf).
BW="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export BW
export POOL="${POOL:-/home/user/bw}"
export FLUTTER_ROOT="$BW/.werkzeug/flutter"
export PUB_CACHE="$BW/.werkzeug/pub-cache"
case ":$PATH:" in
  *":$BW/.werkzeug/flutter/bin:"*) ;;
  *) export PATH="$BW/.werkzeug/flutter/bin:/opt/node22/bin:$PATH" ;;
esac

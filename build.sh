#!/usr/bin/env bash
# Web-Vorschau für Vercel/Netlify. Flutter-Version ist gepinnt, damit Builds reproduzierbar sind.
set -euo pipefail

FLUTTER_VERSION="3.47.6"
FLUTTER_DIR="$HOME/flutter-$FLUTTER_VERSION"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  echo "Installiere Flutter $FLUTTER_VERSION ..."
  mkdir -p "$FLUTTER_DIR"
  curl -sSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    | tar -xJ -C "$FLUTTER_DIR" --strip-components=1
fi
export PATH="$FLUTTER_DIR/bin:$PATH"
git config --global --add safe.directory "$FLUTTER_DIR" || true

flutter config --enable-web
flutter pub get
# Optional: Online-Server per Umgebungsvariable MORDAKTE_SERVER (wss://…/ws).
# --no-web-resources-cdn: CanvasKit kommt aus dem eigenen Build, nicht von gstatic.com.
flutter build web --release --no-web-resources-cdn ${MORDAKTE_SERVER:+--dart-define=MORDAKTE_SERVER=$MORDAKTE_SERVER}

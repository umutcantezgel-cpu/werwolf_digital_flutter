#!/usr/bin/env bash
set -euo pipefail

# Install Flutter if not present
if ! command -v flutter >/dev/null 2>&1; then
  echo "Installing Flutter SDK..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$HOME/flutter"
  export PATH="$HOME/flutter/bin:$PATH"
  # enable web support and prefetch web artifacts
  flutter config --enable-web
  flutter precache --web
fi

# Ensure flutter is on PATH for the rest of the script
export PATH="$HOME/flutter/bin:$PATH"

# Fetch dependencies and build web
flutter pub get
flutter build web --release

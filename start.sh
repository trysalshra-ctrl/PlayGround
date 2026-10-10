#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PROJECT_ROOT="$(pwd)"
/usr/bin/time -p pwd
DIST_DIR="$PROJECT_ROOT/dist"
PORT="${PORT:-3000}"
export PORT
WEB_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
/usr/bin/time -p mkdir -p "$DIST_DIR"
/usr/bin/time -p test -f "$DIST_DIR/index.html"
/usr/bin/time -p test -f "$DIST_DIR/edited_no_app_text.png" || /usr/bin/time -p cp "$PROJECT_ROOT/edited_no_app_text.png" "$DIST_DIR/edited_no_app_text.png"
if /usr/bin/time -p test -f "$PROJECT_ROOT/package.json"; then
  if /usr/bin/time -p test -f "$PROJECT_ROOT/package-lock.json"; then
    /usr/bin/time -p npm ci --no-audit --no-fund
  else
    /usr/bin/time -p npm install --no-audit --no-fund
  fi
  if /usr/bin/time -p npm run --silent build --if-present; then
    true
  fi
  /usr/bin/time -p test -f "$DIST_DIR/index.html"
fi
/usr/bin/time -p mkdir -p "$WEB_DIR"
/usr/bin/time -p printf '%s' '{"project":"'"$PROJECT_ROOT"'","directory":"'"$DIST_DIR"'"}' > "$WEB_DIR/deployment-output.json"
/usr/bin/time -p cat "$WEB_DIR/deployment-output.json"
/usr/bin/time -p python3 --version
exec /usr/bin/time -p python3 -m http.server "$PORT" --directory "$DIST_DIR" --bind 0.0.0.0

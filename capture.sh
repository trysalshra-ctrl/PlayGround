#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PROJECT_ROOT="$(pwd)"
/usr/bin/time -p pwd
RUNTIME="${RUNTIME_DIR:-/home/runner/work/_temp/omgithub-runtime}"
if ! /usr/bin/time -p test -n "${CAPTURE_URL:-}"; then
  echo "Set CAPTURE_URL and CAPTURE_DIR." >&2
  exit 1
fi
if ! /usr/bin/time -p test -n "${CAPTURE_DIR:-}"; then
  echo "Set CAPTURE_URL and CAPTURE_DIR." >&2
  exit 1
fi
/usr/bin/time -p mkdir -p "$CAPTURE_DIR"
/usr/bin/time -p test -f "$RUNTIME/scripts/default-capture.mjs"
/usr/bin/time -p test -n "${HOME:-}"
set +e
/usr/bin/time -p node "$RUNTIME/scripts/default-capture.mjs"
status=$?
set -e
/usr/bin/time -p echo "capture runner exit: $status"
if /usr/bin/time -p test "$status" -ne 0; then
  exit "$status"
fi
if ! /usr/bin/time -p test -f "$CAPTURE_DIR/final-desktop.png"; then
  echo "Missing $CAPTURE_DIR/final-desktop.png" >&2
  exit 1
fi
if ! /usr/bin/time -p test -f "$CAPTURE_DIR/final-mobile.png"; then
  echo "Missing $CAPTURE_DIR/final-mobile.png" >&2
  exit 1
fi
/usr/bin/time -p ls -lh "$CAPTURE_DIR/final-desktop.png" "$CAPTURE_DIR/final-mobile.png"
